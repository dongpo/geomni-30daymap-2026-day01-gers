CREATE OR REPLACE TABLE poi AS
SELECT id, names.primary AS name, taxonomy.primary AS category, basic_category, operating_status,
       sources, geometry, bbox, version
FROM read_parquet('s3://overturemaps-us-west-2/release/2026-10-21.0/theme=places/type=place/*',hive_partitioning=true)
WHERE bbox.xmin >= 121.50 AND bbox.xmax <= 121.58
  AND bbox.ymin >= 25.02 AND bbox.ymax <= 25.08;
COPY poi TO 'outputs/v2/data/taipei-poi.parquet' (FORMAT PARQUET);
COPY (SELECT id,name,category,basic_category,operating_status,version,CAST(sources AS JSON) AS sources,geometry FROM poi)
 TO 'outputs/v2/data/taipei-poi.geojson' (FORMAT GDAL,DRIVER 'GeoJSON');