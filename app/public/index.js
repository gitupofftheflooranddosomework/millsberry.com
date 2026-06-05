class ReplayRouteIndexController {
  constructor() {
    this.filterInput = document.querySelector("[data-filter]");
    this.sortSelect = document.querySelector("[data-sort]");
    this.resultsCount = document.querySelector("[data-results-count]");
    this.resultsLabel = String(this.resultsCount?.dataset.resultsLabel || "route");
    this.routeList = document.querySelector("[data-route-list]");
    this.groupButtons = Array.from(document.querySelectorAll("[data-route-filter]"));
    this.rows = Array.from(document.querySelectorAll("[data-route-row]"));
  }

  init() {
    if (!this.routeList || this.rows.length === 0) return;
    this.bindEvents();
    this.applyFilterAndSort();
  }

  bindEvents() {
    if (this.filterInput) {
      this.filterInput.addEventListener("input", () => {
        this.applyFilterAndSort();
      });
    }

    if (this.sortSelect) {
      this.sortSelect.addEventListener("change", () => {
        this.applyFilterAndSort();
      });
    }

    for (const button of this.groupButtons) {
      button.addEventListener("click", () => {
        const term = button.dataset.routeFilter || "";
        if (this.filterInput) this.filterInput.value = term;
        this.applyFilterAndSort();
      });
    }
  }

  applyFilterAndSort() {
    const filteredRows = this.filterRows();
    this.sortRows(filteredRows);
    this.updateResultsCount(filteredRows.length);
  }

  filterRows() {
    const term = String(this.filterInput?.value || "").trim().toLowerCase();
    if (!term) {
      for (const row of this.rows) row.hidden = false;
      return [...this.rows];
    }

    // Support multi-term searching so users can quickly narrow large route lists.
    const tokens = term.split(/\s+/).filter(Boolean);
    const visible = [];
    for (const row of this.rows) {
      const haystack = String(row.dataset.search || "");
      const matches = tokens.every((token) => haystack.includes(token));
      row.hidden = !matches;
      if (matches) visible.push(row);
    }
    return visible;
  }

  sortRows(visibleRows) {
    const sortBy = String(this.sortSelect?.value || "route-asc");
    const compare = this.comparatorFor(sortBy);
    visibleRows.sort(compare);
    for (const row of visibleRows) {
      this.routeList.appendChild(row);
    }
  }

  comparatorFor(sortBy) {
    const routeValue = (row) => String(row.dataset.route || "");
    const timestampValue = (row) => String(row.dataset.timestamp || "");

    if (sortBy === "time-desc") {
      return (a, b) => timestampValue(b).localeCompare(timestampValue(a)) || routeValue(a).localeCompare(routeValue(b));
    }
    if (sortBy === "time-asc") {
      return (a, b) => timestampValue(a).localeCompare(timestampValue(b)) || routeValue(a).localeCompare(routeValue(b));
    }
    if (sortBy === "route-desc") {
      return (a, b) => routeValue(b).localeCompare(routeValue(a)) || timestampValue(b).localeCompare(timestampValue(a));
    }
    return (a, b) => routeValue(a).localeCompare(routeValue(b)) || timestampValue(b).localeCompare(timestampValue(a));
  }

  updateResultsCount(visibleCount) {
    if (!this.resultsCount) return;
    this.resultsCount.textContent = `${visibleCount} ${this.resultsLabel}${visibleCount === 1 ? "" : "s"}`;
  }
}

class SwfTeaserScrollController {
  constructor() {
    this.filterInput = document.querySelector("[data-filter]");
    this.sortSelect = document.querySelector("[data-sort]");
    this.resultsCount = document.querySelector("[data-results-count]");
    this.resultsLabel = String(this.resultsCount?.dataset.resultsLabel || "teaser");
    this.list = document.querySelector("[data-teaser-list]");
    this.loader = document.querySelector("[data-teaser-loader]");
    this.empty = document.querySelector("[data-teaser-empty]");
    this.sentinel = document.querySelector("[data-teaser-sentinel]");
    this.offset = 0;
    this.total = 0;
    this.loading = false;
    this.hasMore = true;
    this.abortController = null;
    this.observer = null;
    this.debounceId = null;
    this.pageSize = 36;
  }

  init() {
    if (!this.list || !this.sentinel) return;
    this.bindEvents();
    this.loadNextPage(true);
    this.observer = new IntersectionObserver((entries) => {
      if (entries.some((entry) => entry.isIntersecting)) {
        this.loadNextPage(false);
      }
    }, { rootMargin: "300px 0px" });
    this.observer.observe(this.sentinel);
  }

  bindEvents() {
    const scheduleReset = () => {
      if (this.debounceId !== null) window.clearTimeout(this.debounceId);
      this.debounceId = window.setTimeout(() => this.loadNextPage(true), 200);
    };

    if (this.filterInput) {
      this.filterInput.addEventListener("input", scheduleReset);
    }
    if (this.sortSelect) {
      this.sortSelect.addEventListener("change", () => this.loadNextPage(true));
    }
  }

  queryParams(reset) {
    const params = new URLSearchParams();
    params.set("offset", String(reset ? 0 : this.offset));
    params.set("limit", String(this.pageSize));
    const query = String(this.filterInput?.value || "").trim();
    if (query) params.set("q", query);
    const sortBy = String(this.sortSelect?.value || "time-desc");
    params.set("sort", sortBy);
    return params;
  }

  async loadNextPage(reset) {
    if (this.loading) return;
    if (!reset && !this.hasMore) return;

    this.loading = true;
    this.toggleLoader(true);
    this.empty.hidden = true;

    if (reset) {
      this.offset = 0;
      this.total = 0;
      this.hasMore = true;
      this.list.innerHTML = "";
      if (this.abortController) this.abortController.abort();
    }

    const controller = new AbortController();
    this.abortController = controller;

    try {
      const response = await fetch(`/__swf_teasers.json?${this.queryParams(reset).toString()}`, {
        headers: { "Accept": "application/json" },
        signal: controller.signal
      });
      if (!response.ok) throw new Error(`Request failed: ${response.status}`);
      const payload = await response.json();
      this.total = Number(payload.total || 0);
      this.offset = Number(payload.nextOffset || 0);
      this.hasMore = Boolean(payload.hasMore);
      this.renderItems(Array.isArray(payload.items) ? payload.items : []);
      this.updateResultsCount(this.total);
      this.empty.hidden = this.total !== 0;
    } catch (error) {
      if (error.name !== "AbortError") {
        this.empty.textContent = "Unable to load teaser photos right now.";
        this.empty.hidden = false;
      }
    } finally {
      this.loading = false;
      this.toggleLoader(false);
    }
  }

  renderItems(items) {
    if (!items.length) return;
    const fragment = document.createDocumentFragment();
    for (const item of items) {
      fragment.appendChild(this.buildCard(item));
    }
    this.list.appendChild(fragment);
  }

  buildCard(item) {
    const title = item.title || item.sourcePath || item.sourceHref || "Recovered SWF";
    const previewHref = `/__swf_preview?src=${encodeURIComponent(item.sourceHref || "")}`;
    const card = document.createElement("article");
    card.className = "teaser-card";

    const imageLink = document.createElement("a");
    imageLink.href = previewHref;
    imageLink.className = "teaser-thumb";

    const image = document.createElement("img");
    image.src = item.teaserHref || "";
    image.alt = title;
    image.loading = "lazy";
    image.decoding = "async";

    imageLink.appendChild(image);
    card.appendChild(imageLink);

    const heading = document.createElement("h3");
    heading.textContent = title;
    card.appendChild(heading);

    const meta = document.createElement("p");
    const kind = item.kind || "SWF";
    const stamp = item.timestamp ? ` · ${item.timestamp}` : "";
    meta.textContent = `${kind}${stamp}`;
    card.appendChild(meta);

    const action = document.createElement("a");
    action.href = previewHref;
    action.className = "teaser-open";
    action.textContent = "Open Preview";
    card.appendChild(action);

    return card;
  }

  toggleLoader(show) {
    if (!this.loader) return;
    this.loader.hidden = !show;
  }

  updateResultsCount(visibleCount) {
    if (!this.resultsCount) return;
    this.resultsCount.textContent = `${visibleCount} ${this.resultsLabel}${visibleCount === 1 ? "" : "s"}`;
  }
}

new ReplayRouteIndexController().init();
new SwfTeaserScrollController().init();
