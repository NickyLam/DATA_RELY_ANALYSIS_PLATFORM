/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_year_plan
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
drop table ${iol_schema}.ncbs_rb_dc_year_plan_ex purge;
alter table ${iol_schema}.ncbs_rb_dc_year_plan add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ncbs_rb_dc_year_plan;

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_dc_year_plan_ex nologging
compress
as
select * from ${iol_schema}.ncbs_rb_dc_year_plan where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_year_plan_ex(
    ccy -- 币种
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,issue_year -- 发行年度
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,adjust_limit -- 调整额度
    ,distribute_limit -- 已分配额度
    ,leave_limit -- 剩余额度
    ,record_limit -- 备案额度
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,issue_year -- 发行年度
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,adjust_limit -- 调整额度
    ,distribute_limit -- 已分配额度
    ,leave_limit -- 剩余额度
    ,record_limit -- 备案额度
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_dc_year_plan
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_dc_year_plan exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_year_plan_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_year_plan to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_dc_year_plan_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_year_plan',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);