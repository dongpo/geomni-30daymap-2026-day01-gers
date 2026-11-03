CREATE OR REPLACE TABLE source_keys AS
 SELECT p.id AS original_gers_id,p.name,s.provider,s.dataset,s.record_id,s.license
 FROM poi p,UNNEST(p.sources) t(s) WHERE p.id IN ('214bf395-7335-4d99-9f72-aa8ad3403164','8b964415-d832-4451-9f1a-8be4bb9601b5','1709e0cb-c2f9-4eab-8df1-c92b486c9255','316d3c22-c51e-4b32-a04c-0f11e070540a','50e06345-7a3b-435a-9aa5-68e94a6e4190','f4e28492-3c08-4504-8729-aec82048776b','aca7c916-b497-4d7c-8522-77b86e15a858','c09a44b0-bab8-487c-97d0-3a44b8ce1848','73c8b370-21b5-4e71-b92f-b0815427f1e1') AND s.record_id IS NOT NULL;
COPY source_keys TO 'outputs/v2/evidence/source-keys.csv' (HEADER);
COPY (SELECT s.name,s.provider,s.record_id,b.id AS resolved_gers_id,s.original_gers_id,
 b.id=s.original_gers_id AS id_agrees,r.last_seen,r.path IS NOT NULL AS registry_live
 FROM source_keys s LEFT JOIN bridge b ON s.provider=b.provider AND s.record_id=b.record_id
 LEFT JOIN registry r ON b.id=r.id ORDER BY s.name,s.provider) TO 'outputs/v2/evidence/cross-dataset-join.csv' (HEADER);