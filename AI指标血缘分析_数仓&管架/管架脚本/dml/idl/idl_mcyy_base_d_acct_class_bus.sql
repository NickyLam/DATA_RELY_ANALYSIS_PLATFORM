/*
Purpose:    BASE_D_ACCT_CLASS_BUS:账户类基础指标结果表
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_acct_class_bus
Createdate: 20220510

Logs:
  郑沛隆 2022-05-10 新建脚本          
*/
 
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 1.1 drop tmp tables and add partition
whenever sqlerror continue none;

alter table ${idl_schema}.base_d_acct_class_bus drop partition p_${batch_date};

alter table ${idl_schema}.base_d_acct_class_bus add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

drop table ${idl_schema}.tmp_base_d_acct_class_bus purge;

-- 1.2 create tmp tables
whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.tmp_base_d_acct_class_bus
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_acct_class_bus
where 0=1;

whenever sqlerror exit sql.sqlcode;
INSERT /*+ append */ INTO ${idl_schema}.TMP_BASE_D_ACCT_CLASS_BUS
(
INDEX_NO 
,ORG_NO 
,SUP_ORG_NO
,INDEX_VALUE_D 
,INDEX_VALUE_M 
,INDEX_VALUE_Q
,INDEX_VALUE_Y
,ESPEC_DIMEN_CD1 
,ESPEC_DIMEN_CD2 
,ESPEC_DIMEN_CD3 
,ESPEC_DIMEN_CD4 
,ESPEC_DIMEN_CD5 
,REMARK 
,ETL_DT 
,ETL_TIMESTAMP
)

WITH ST1 AS (
SELECT *
FROM BASE_D_ACCT_CLASS_BUS_INCRS 
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
ST2 AS (
SELECT * 
FROM BASE_D_ACCT_CLASS_BUS_ACCUM
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
ST3 AS (
SELECT * 
FROM COMB_D_ACCT_CLASS_BUS
WHERE ETL_DT=to_date('${batch_date}','yyyymmdd')
),
-- 3.1 集合结果输出
DB_REST AS (
SELECT * FROM ST1
UNION ALL SELECT * FROM ST2
UNION ALL SELECT * FROM ST3
)
SELECT 
*
FROM DB_REST;

COMMIT;


-- 3.2 exchage ex table and target table
alter table ${idl_schema}.base_d_acct_class_bus exchange partition p_${batch_date} with table ${idl_schema}.tmp_base_d_acct_class_bus;

-- 3.3 drop tmp table
drop TABLE ${idl_schema}.tmp_base_d_acct_class_bus purge;

-- 4.1 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_acct_class_bus',partname => 'p_${batch_date}',ESTIMATE_PERCENT => 10,method_opt=>'for all columns size 1',no_invalidate=>false,granularity=>'partition',cascade => true,force=>true,degree => 8);

whenever sqlerror continue none;

alter table ${idl_schema}.mcyy_bu_analysis truncate subpartition p_${batch_date}_acct_class_bus;

alter table ${idl_schema}.mcyy_bu_analysis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'))(
                                              subpartition p_${batch_date}_acct_class_bus values ('BASE_D_ACCT_CLASS_BUS')
                                              )
;
alter table ${idl_schema}.mcyy_bu_analysis modify partition p_${batch_date} 
                                             add subpartition p_${batch_date}_acct_class_bus values ('BASE_D_ACCT_CLASS_BUS')
;

whenever sqlerror exit sql.sqlcode;


call pkg_mcyy_ind_share_intfc.prc_get_sorc_sys_data('BASE_D_ACCT_CLASS_BUS',${batch_date});


whenever sqlerror exit sql.sqlcode;

exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mcyy_bu_analysis',partname => 'p_${batch_date}_acct_class_bus', granularity => 'SUBPARTITION', degree => 8, cascade => true);



