# Geomni · Day 01 · 台北 POI × GERS 實體關聯

[Open demo](https://dongpo.github.io/geomni-30daymap-2026-day01-gers/)

這個 demo 使用 Overture 2026-10-21.0 的台北局部 POI，共 95,877 筆記錄。金色標示 9 個含多來源資訊的圖徵。

選取 GERS 實例，可查看名稱、ID 與來源鍵。實驗以 provider + record_id 查官方 Bridge，再查 Registry；18 個來源鍵均接回預期的 9 個 ID。

這是 Overture 來源欄位與官方索引的回查，不是獨立業務資料配對準確率測試，也未驗證跨月 ID 持續性。記錄數不等於商家數。

原始查詢：DuckDB Spatial。網頁呈現：MapLibre GL JS。範圍 121.50–121.58°E、25.02–25.08°N。

## Run locally

```sh
python3 -m http.server 8000
```

Open http://localhost:8000. Static site; no API keys. Each repository contains its own assets and does not depend on the other demos. Modern browser with WebGL and DecompressionStream required for Points/Lines.

## Evidence and licensing

See `evidence/`, `LICENSE-DATA.txt` and vendor notices. Prepared 2026-11-03. Original release query SQL records the analysis workflow; local file paths in SQL refer to the original analysis workspace. This is a geographic technology demonstration, not navigation or a legal boundary service.
