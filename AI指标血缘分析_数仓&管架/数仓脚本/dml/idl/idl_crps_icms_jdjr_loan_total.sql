/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_crps_icms_jdjr_loan_total
CreateDate: 20230608
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.crps_icms_jdjr_loan_total drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.crps_icms_jdjr_loan_total add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.crps_icms_jdjr_loan_total (
etl_dt  --etl处理日期
,jzno  --记账代码
,jzamt  --记账金额

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,replace(replace(t1.jzno,chr(13),''),chr(10),'') as jzno --记账代码
,replace(replace(t1.jzamt,chr(13),''),chr(10),'') as jzamt --记账金额
from ${iol_schema}.icms_jdjr_loan_total t1    --总账
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'crps_icms_jdjr_loan_total',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
