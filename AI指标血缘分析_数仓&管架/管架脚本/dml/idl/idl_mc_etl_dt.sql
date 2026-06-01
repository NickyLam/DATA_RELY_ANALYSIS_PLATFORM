set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

DELETE FROM MC_ETL_DT;

COMMIT;

INSERT INTO MC_ETL_DT
SELECT to_date('${batch_date}','yyyymmdd')                             AS ETL_DT         --ETL处理日期
      ,TO_TIMESTAMP('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6')  AS ETL_TIMESTAMP  --ETL处理时间戳
FROM dual; 

COMMIT ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_etl_dt', degree => 8, cascade => true);