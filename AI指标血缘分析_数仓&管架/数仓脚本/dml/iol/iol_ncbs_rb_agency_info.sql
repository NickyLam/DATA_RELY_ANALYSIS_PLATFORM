/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agency_info
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
drop table ${iol_schema}.ncbs_rb_agency_info_ex purge;
alter table ${iol_schema}.ncbs_rb_agency_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_agency_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_agency_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agency_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_agency_info_ex(
    ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,agency_type -- 代发代扣类型
    ,agreement_id -- 协议编号
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,company -- 法人
    ,res_seq_no -- 限制编号
    ,batch_end_time -- 批次处理终止时间戳
    ,batch_start_time -- 批次处理起始时间戳
    ,effect_date -- 产品生效日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,batch_failure_reason -- 批处理失败原因
    ,failure_reason -- 失败原因
    ,tran_amt -- 交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,agency_type -- 代发代扣类型
    ,agreement_id -- 协议编号
    ,batch_no -- 批次号
    ,batch_status -- 批次处理状态
    ,company -- 法人
    ,res_seq_no -- 限制编号
    ,batch_end_time -- 批次处理终止时间戳
    ,batch_start_time -- 批次处理起始时间戳
    ,effect_date -- 产品生效日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,batch_failure_reason -- 批处理失败原因
    ,failure_reason -- 失败原因
    ,tran_amt -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_agency_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_agency_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agency_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agency_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_agency_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agency_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);