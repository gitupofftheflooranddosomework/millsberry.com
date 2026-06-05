# Millsberry recovery OSINT report

Date: 2026-06-04

## Executive findings

- `millsberry.com` remains registered under General Mills through CSC Corporate Domains.
- Current authoritative nameservers are:
  - `jfbextdns1.genmills.com`
  - `mgoextdns1.genmills.com`
  - `mgoextdns2.genmills.com`
- The current apex has NS/SOA/TXT records but no public A/AAAA record found.
- `www.millsberry.com` does not currently resolve publicly.
- Several old infrastructure records still resolve:
  - `graphics.millsberry.com` -> `209.34.86.51`
  - `dev.millsberry.com` -> `209.34.87.112`
  - `dev2.millsberry.com` -> `209.34.87.112`
  - `devgraphics.millsberry.com` -> `209.34.87.107`
  - `dev2graphics.millsberry.com` -> `209.34.87.107`
- Those old hosts did not return normal HTTP responses from the public internet, but the records are still active and should be checked from General Mills network, DNS, CMDB, firewall, and hosting/vendor records.
- Wayback Machine contains a substantial client-side recovery surface: HTML/PHTML pages, GIF/JPEG/PNG assets, JavaScript/CSS, and many SWF files.
- Server-side PHP/PHTML source was not exposed by Wayback; a full functional restoration will require internal backups, old vendor archives, or rebuilding server behavior from archived front-end assets and Flash behavior.

## Generated files

- `wayback_millsberry_200_unique.json`: first 5,000 unique 200-status archived URL keys, dominated by user home pages.
- `wayback_no_home_200_unique.json`: 4,091 archived URL keys excluding `/home/`, better for application structure and assets.
- `wayback_swf_200_unique.json`: 840 SWF-matching archive rows.
- `wayback_flash_assets.csv`: 768 archived Flash/octet-stream asset rows, 265 unique digests.
- `wayback_hosts.txt`: unique hostnames seen in archive data.
- `wayback_host_summary.csv`: per-host archive counts and first/last capture timestamps.

## High-value archived hosts

- `www.millsberry.com`: main site and PHP/PHTML app pages.
- `graphics.millsberry.com`: production static art/Flash.
- `devgraphics.millsberry.com`: development static art/Flash, archived heavily in 2006-2007.
- `dev.millsberry.com`: development app host.
- `dev2.millsberry.com` / `dev2graphics.millsberry.com`: second development environment.
- `www.sillyrabbit.millsberry.com`: Trix subsite.
- `www.luckycharms.millsberry.com` and `www.luckycharmsfun.millsberry.com`: Lucky Charms subsites.
- `www.nutsabouthoney.millsberry.com`: Honey Nut Cheerios subsite.
- `honeydefender.millsberry.com`: later/current brand host.

## Current certificate transparency findings

Recent 2026 certificates exist for:

- `nutsabouthoney.millsberry.com`
- `www.nutsabouthoney.millsberry.com`
- `honeydefender.millsberry.com`
- `www.honeydefender.millsberry.com`
- `luckycharmsfun.millsberry.com`
- `www.luckycharmsfun.millsberry.com`

These currently resolve to `34.8.19.241` and serve current Cheerios/Lucky Charms pages, not the original Millsberry game.

## Infrastructure leads

Old Millsberry infrastructure points into `209.34.64.0/19`, associated through ARIN with NTT/legacy hosting records. General Mills should search internal vendor, firewall, and billing records for:

- `209.34.86.51`
- `209.34.87.107`
- `209.34.87.112`
- `209.34.64.0/19`
- Hostnames: `graphics`, `dev`, `dev2`, `devgraphics`, `dev2graphics`

## Recovery strategy

1. Preserve current DNS state and request zone-file/history exports from the General Mills DNS team.
2. Check whether the old `209.34.*` hosts are reachable from corporate/VPN networks or only externally firewalled.
3. Search internal CMDB, firewall rules, CDN/origin records, and NTT/vendor contracts for the IPs above.
4. Search old source repositories and backup systems for names including `millsberry`, `graphics.millsberry.com`, `process_buddy.phtml`, `process_home.phtml`, `top_nav_xml.phtml`, and `item_loader_v5.swf`.
5. Use the archive manifests here to download recoverable client assets from Wayback.
6. Decompile SWF assets legally/with authorization to reconstruct client-side flows and server API contracts.
7. Rebuild missing server-side behavior only after exhausting internal backup/vendor retrieval, because Wayback does not expose the PHP/PHTML source.

## Public references checked

- RDAP: `https://rdap.verisign.com/com/v1/domain/millsberry.com`
- CSC RDAP related link from Verisign response.
- Wayback CDX API: `https://web.archive.org/cdx`
- Certificate transparency via Cert Spotter API.
- Public web search results including Games Finder history page, Get Lucas Millsberry page, Whois.com domain summary, and academic/marketing reports referencing Millsberry and branded subdomains.
