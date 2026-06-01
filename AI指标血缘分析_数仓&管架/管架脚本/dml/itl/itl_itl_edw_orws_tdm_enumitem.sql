/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_tdm_enumitem
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_orws_tdm_enumitem drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_tdm_enumitem drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_tdm_enumitem add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_tdm_enumitem partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 
    ,enumid   -- 
    ,enumsortid    -- 
    ,superenumid   -- 
    ,enumword      -- 
    ,code          -- 
    ,name          -- 
    ,seqno         -- 
    ,status        -- 
    ,managetype    -- 
    ,isdefault     -- 
    ,iscanselect   -- 
    ,remark   -- 
    ,etl_timestamp  -- 
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.enumid  -- 
    ,t1.enumsortid  -- 
    ,t1.superenumid  -- 
    ,replace(replace(t1.enumword,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.code,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.name,chr(13),''),chr(10),'')  -- 
    ,t1.seqno  -- 
    ,t1.status  -- 
    ,t1.managetype  -- 
    ,t1.isdefault  -- 
    ,t1.iscanselect  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_orws_tdm_enumitem t1    --员工教育简历表
where  etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_tdm_enumitem',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);