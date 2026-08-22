# TPEx Relay Kit

用途：避開 Cloudflare Workers -> TPEx 的 WAF redirect loop。

1. 建立 public GitHub repo，例如 `stan-tpex-relay`。
2. 把本 ZIP 解壓後所有內容放在 repo 根目錄。
3. GitHub > Actions > Update TPEx Relay > Run workflow。
4. 成功後確認 `data/*.json` 有內容。
5. Cloudflare Pages > Settings > Variables and Secrets 新增：

`TPEX_PROXY_BASE=https://raw.githubusercontent.com/<帳號>/<repo>/main/data`

6. 重新部署 Stan Proxy Support 版本。
7. App > 設定 > TPEx Proxy Status，確認 HTTP 200 與 rows > 0。
8. 再按「檢查最新盤面」。

排程：平日台灣時間約 14:10 自動更新。
