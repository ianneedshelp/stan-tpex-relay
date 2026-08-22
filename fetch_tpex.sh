#!/usr/bin/env bash
set -euo pipefail
mkdir -p data
fetch_json(){
  url="$1"; out="$2"; tmp="${out}.tmp"
  curl --fail --location --silent --show-error --retry 3 --retry-delay 2 --retry-all-errors \
    -H 'Accept: application/json' -H 'User-Agent: Mozilla/5.0 GitHubActions-TPEx-Relay/1.0' "$url" -o "$tmp"
  python3 - "$tmp" "$out" <<'PY'
import json,sys,pathlib
src=pathlib.Path(sys.argv[1]); dst=pathlib.Path(sys.argv[2])
obj=json.loads(src.read_text(encoding='utf-8-sig'))
if isinstance(obj,dict):
    for k in ('data','result','rows','msgArray'):
        if isinstance(obj.get(k),list):
            obj=obj[k]; break
if not isinstance(obj,(list,dict)): raise SystemExit('Unexpected JSON root')
dst.write_text(json.dumps(obj,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
src.unlink(missing_ok=True)
PY
}
fetch_json "https://www.tpex.org.tw/openapi/v1/tpex_mainboard_daily_close_quotes" "data/tpex_mainboard_daily_close_quotes.json"
fetch_json "https://www.tpex.org.tw/openapi/v1/tpex_mainboard_quotes" "data/tpex_mainboard_quotes.json"
fetch_json "https://www.tpex.org.tw/openapi/v1/tpex_mainboard_peratio_analysis" "data/tpex_mainboard_peratio_analysis.json"
fetch_json "https://www.tpex.org.tw/openapi/v1/mopsfin_t187ap05_O" "data/mopsfin_t187ap05_O.json"
fetch_json "https://www.tpex.org.tw/openapi/v1/tpex_3insti_daily_trading" "data/tpex_3insti_daily_trading.json"
date -u +"%Y-%m-%dT%H:%M:%SZ" > data/updated_at.txt
