# Legacy IP Leads (2026-06-05)

## High-confidence legacy infra IPs

These appear repeatedly in project artifacts and/or are currently mapped by DNS for Millsberry legacy hosts.

- 209.34.86.51
  - Host mapping: graphics.millsberry.com
  - Evidence: recovery report and current DNS resolution
- 209.34.87.107
  - Host mapping: devgraphics.millsberry.com, dev2graphics.millsberry.com
  - Evidence: recovery report and current DNS resolution
- 209.34.87.112
  - Host mapping: dev.millsberry.com, dev2.millsberry.com
  - Evidence: recovery report and current DNS resolution
- 209.34.64.0/19 (netblock lead)
  - Evidence: recovery report infrastructure section

## Additional IPs found in corpus (lower confidence for core hosting)

- 64.191.225.20
- 64.191.225.25
- 172.16.26.10 (private/internal)

## DNS check results (current)

- graphics.millsberry.com -> 209.34.86.51
- devgraphics.millsberry.com -> 209.34.87.107
- dev2graphics.millsberry.com -> 209.34.87.107
- dev.millsberry.com -> 209.34.87.112
- dev2.millsberry.com -> 209.34.87.112
- www.millsberry.com -> no public A response
- millsberry.com -> no public A record

## Why this matters

Even without published A records for apex/www, these legacy subdomain A records still resolve and may correspond to parked, firewalled, or restricted legacy origins.

## Next targeted pivots

1. Query passive DNS services (SecurityTrails, RiskIQ, DNSDB, DomainTools) for historical A records on:
   - millsberry.com
   - www.millsberry.com
   - graphics/dev/dev2/devgraphics/dev2graphics.millsberry.com
2. Ask General Mills DNS/NetOps for historic zone exports and split-horizon records.
3. Search internal CMDB/firewall/vendor billing for all 209.34.64.0/19 assignments tied to millsberry hostnames.
