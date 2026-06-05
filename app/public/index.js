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

new ReplayRouteIndexController().init();
