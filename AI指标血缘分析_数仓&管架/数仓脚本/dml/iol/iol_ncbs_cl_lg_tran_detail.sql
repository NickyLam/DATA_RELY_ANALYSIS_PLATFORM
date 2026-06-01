/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_lg_tran_detail
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
drop table ${iol_schema}.ncbs_cl_lg_tran_detail_ex purge;
alter table ${iol_schema}.ncbs_cl_lg_tran_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_lg_tran_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_lg_tran_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_lg_tran_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_lg_tran_detail_ex(
    dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,lg_acct_type -- 保函账户类型
    ,lg_tran_type -- 保函交易类型
    ,seq_no -- 序号
    ,lg_internal_key -- 保函账号key值
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,loan_no -- 贷款号
    ,tran_amt -- 交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    dd_no -- 发放号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,lg_acct_type -- 保函账户类型
    ,lg_tran_type -- 保函交易类型
    ,seq_no -- 序号
    ,lg_internal_key -- 保函账号key值
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,loan_no -- 贷款号
    ,tran_amt -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_lg_tran_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_lg_tran_detail exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_lg_tran_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_lg_tran_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_lg_tran_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_lg_tran_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);