SELECT
    etl_dt
    ,etl_timestamp
    ,num
    ,import_way
FROM ${src_schema}.yygj_etl_dt
WHERE 1 = 1 