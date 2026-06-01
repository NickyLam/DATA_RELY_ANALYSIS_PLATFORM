/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tcs_tbhisfeyehz
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbhisfeyehz_ex purge;
alter table ${iol_schema}.nfss_tcs_tbhisfeyehz add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_tcs_tbhisfeyehz;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_tcs_tbhisfeyehz_ex nologging
compress
as
select * from ${iol_schema}.nfss_tcs_tbhisfeyehz where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_tcs_tbhisfeyehz_ex(
    sum_date -- 汇总日期
    ,sum_flag -- 汇总方式,0-按交易机构，1-按开户机构
    ,internal_branch -- 机构内码
    ,client_type -- 客户类型,1-个人客户，0-对公客户
    ,prd_code -- 产品代码
    ,branch_no -- 机构代码
    ,ta_code -- TA代码
    ,tot_vol -- 份额总数
    ,long_frozen_vol -- 长期冻结份额
    ,nav -- 产品净值
    ,client_num -- 有效户数
    ,prd_type -- 产品类别,0-基金，1-理财
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sum_date -- 汇总日期
    ,sum_flag -- 汇总方式,0-按交易机构，1-按开户机构
    ,internal_branch -- 机构内码
    ,client_type -- 客户类型,1-个人客户，0-对公客户
    ,prd_code -- 产品代码
    ,branch_no -- 机构代码
    ,ta_code -- TA代码
    ,tot_vol -- 份额总数
    ,long_frozen_vol -- 长期冻结份额
    ,nav -- 产品净值
    ,client_num -- 有效户数
    ,prd_type -- 产品类别,0-基金，1-理财
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_tcs_tbhisfeyehz
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_tcs_tbhisfeyehz exchange partition p_${batch_date} with table ${iol_schema}.nfss_tcs_tbhisfeyehz_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tcs_tbhisfeyehz to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_tcs_tbhisfeyehz_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tcs_tbhisfeyehz',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);