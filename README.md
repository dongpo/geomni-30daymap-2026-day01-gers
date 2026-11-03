# Geomni · 同一個地點，如何連接不同來源的資料？

[操作地圖](https://dongpo.github.io/geomni-30daymap-2026-day01-gers/)

## 這張地圖要回答什麼？

同一間飯店或店家，在不同來源中可能有不同識別碼。這張圖展示如何透過 GERS 的共同地理實體 ID，連接這些來源記錄。

## 地圖怎麼看？

青綠色點為台北局部範圍內的 95,877 筆 POI 記錄；金色點為 9 個多來源關聯實例。選取金色實例可查看 GERS ID 與來源鍵。背景點提供位置脈絡，不代表商家總數或商業熱度；也未排除非營業狀態的記錄。

## 資料來源與範圍

Overture Maps Places，固定版本 2026-10-21.0。範圍為 121.50–121.58°E、25.02–25.08°N，並非完整台北市。使用同版本的 GERS Bridge Files，以及本次查詢保存的 Registry 狀態。

## 資料做了什麼處理？

以 DuckDB Spatial 查詢雲端 GeoParquet，按範圍選取 POI，保留名稱、類別、幾何、ID 與來源資訊。從 9 個多來源實例抽出 18 個來源鍵，以 provider + record_id 查 Bridge，再以 GERS ID 查 Registry。18 個來源鍵均接回預期 ID，9 個 ID 均查得 Registry 路徑。

## Bridge 是哪個資料集？

Bridge Files 是 Overture 發布的來源識別碼與 GERS ID 對照資料。本次讀取 s3://overturemaps-us-west-2/bridgefiles/2026-10-21.0/provider={meta,opentravel,uberall,microsoft,pinmeto}/theme=places/type=place/*。花括號表示分別查詢五個來源分區。

## 9 個地點、18 個來源鍵代表什麼？

Meta ↔ OpenTravel：3 個地點；Meta ↔ Uberall：5 個地點；Microsoft ↔ PinMeTo：1 個地點。每個樣本取兩個來源鍵，共 18 個，包含 Hotel Resonance Taipei，並非另外 18 個地點。Bridge 查詢另保留了這 9 個 ID 的 22 列記錄；18 個來源鍵是其中的子集。

## 以 Hotel Resonance Taipei 為例

Meta 的記錄 114417610475910 與 OpenTravel 的 TSAUP，在 Bridge 中連到同一個 GERS ID：316d3c22-c51e-4b32-a04c-0f11e070540a。意義是：持有這些來源鍵的資料可沿著對照表建立關聯，不必每次重新比對名稱與座標。沒有現成對照的外部資料仍須先做實體比對；取得 ID 不代表能取得來源的全部內容。

## 網頁用了什麼架構？

雲端 GeoParquet → 本機 DuckDB 查詢與關聯核對 → GeoJSON → gzip 壓縮檔 → GitHub Pages → 瀏覽器解壓縮 → MapLibre GL JS 的 WebGL 點圖層。資料處理事先完成；點選地點不會即時查詢 Meta 或 OpenTravel，也沒有後端分析 API。

## 這次實作的界線

來源鍵取自 Overture 自身的 sources 欄位，這次驗證的是已提供的識別關係，尚未串接獨立取得的外部業務資料。未測試實體配對準確率或跨版本 ID 持續性。

## 資料與技術來源

- [Overture Places 資料結構](https://docs.overturemaps.org/schema/reference/places/place/)
- [GERS Bridge Files](https://docs.overturemaps.org/gers/bridge-files/)
- [GERS Registry](https://docs.overturemaps.org/gers/registry/)

## 本機執行

```sh
python3 -m http.server 8000
```

開啟 http://localhost:8000。各 repo 資產獨立，不需要 API key。Points／Lines 需要支援 WebGL 與 DecompressionStream 的現代瀏覽器。

## 證據與授權

查詢 SQL、核對表或結果見 `evidence/`；資料授權與歸屬見 `LICENSE-DATA.txt`，第三方程式授權保留於 `vendor/`。SQL 中的輸出路徑記錄原分析工作目錄，可依重現環境調整。內容更新：2026-11-03。
