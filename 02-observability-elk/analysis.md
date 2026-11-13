# Log analysis

A quick analysis of `samples/nginx-access.log`, run with an AI assistant (Claude). Every finding below can be replayed by a human operator in Kibana in a few seconds: type the query in the dashboard search bar, and the three charts filter at once.

## Data

| | |
|---|---|
| Requests | 14,496 |
| Period | 2024-06-24 → 2024-08-21 |
| Distinct client IPs | 1,804 |
| Data sent | 614 MiB (644 MB) |

Sizes are in binary units (1 MiB = 1,048,576 bytes), as in the dashboard (`Bytes (1024)` format, labelled "MB" by Kibana).

## Method

| Step | Asked to | How |
|---|---|---|
| First look: verbs, top URLs, user agents of HEAD requests, total bytes | the raw file | `awk` counts over every line |
| Findings: status codes, bytes per URL, scanners, bots, distinct IPs | Elasticsearch, index `nginx-access` | aggregations (`terms`, `sum`, `cardinality`) sent with `curl` to the same API Kibana uses |
| Cross-check | the raw file | each Elasticsearch figure recounted with `awk` / `grep`: same results (the 2,454 scanner requests found by Kibana match the raw file; a slightly different Elasticsearch pattern gave 2,456) |

Example, the share of GIF files in the data sent:

```bash
# Elasticsearch: sum of bytes for *.gif requests
curl -s 'localhost:9200/nginx-access/_search?size=0' -H 'Content-Type: application/json' \
  -d '{"query":{"wildcard":{"request":"*.gif"}},"aggs":{"bytes":{"sum":{"field":"bytes"}}}}'

# Raw file: same figure, without Elasticsearch
awk -F'"' '{split($2,r," "); if (r[2] ~ /\.gif$/) {split($3,s," "); b+=s[2]}} END {print b}' samples/nginx-access.log
```

## Findings

| # | Finding | Query (dashboard search bar) | Action |
|---|---|---|---|
| 1 | **GIF files are 85 % of the data sent, for 2.4 % of the requests**: 345 requests, 520 MiB out of 614. `knowledge_kungfu.gif` alone: 159 MiB in 43 requests. It makes 26 of the 39 MiB of the biggest peak (2024-06-25) | `request : *.gif` | convert the GIFs to MP4 or WebP: files 5 to 10 times lighter, total bandwidth divided by about 3 to 4 |
| 2 | **A quarter of the responses are 404 (3,511), and about 45 % of them come from four missing standard files**: `/robots.txt` (870), `/favicon.ico` (485), `/apple-touch-icon.png` (123), `/manifest.json` (120) | `response : 404` | add the four files |
| 3 | **One request in six is a vulnerability scan**: 2,454 requests from 144 IPs (8 % of the clients) probe PHP, WordPress, `.env` or `.git` paths on a site that uses neither PHP nor WordPress, including CVE-2024-4577 a few days after its disclosure. Most get a 301 (HTTP to HTTPS), then a 404 | `request : (*.php* or *wp-* or *.env* or *.git* or *admin*)` | make sure `.env` and `.git` are never served; ban the most insistent IPs (fail2ban) if the noise matters |
| 4 | **About one request in five comes from a crawler that names itself**: 2,563 requests whose user agent contains "bot", "spider" or "crawler" (Bytespider 530, MJ12bot 115…). Crawlers read pages for search engines, SEO tools or AI training, and sign their user agent on purpose so site owners can allow or block them: most are legitimate. They are not the scanners of finding 3 (31 requests in common). Other robots hide: 660 HEAD requests pose as Chrome 74, a 2019 browser | `agent : (*bot* or *spider* or *crawler*)` | raw figures overstate human visitors; steer crawlers with a `robots.txt` (see finding 2) |

## Conclusion

The site is a small static blog. About a third of its traffic is robots, in two families of similar size: crawlers that name themselves, mostly legitimate (finding 4), and vulnerability scanners (finding 3). The scans are noise rather than a threat, since nothing they look for exists. The two cheapest wins are not about security: lighter images (finding 1) and four missing files (finding 2).

