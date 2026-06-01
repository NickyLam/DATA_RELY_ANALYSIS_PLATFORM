/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_settle_card_preset_acct
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
drop table ${iol_schema}.ncbs_rb_settle_card_preset_acct_ex purge;
alter table ${iol_schema}.ncbs_rb_settle_card_preset_acct add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_settle_card_preset_acct truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_settle_card_preset_acct_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_settle_card_preset_acct where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_settle_card_preset_acct_ex(
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,branch_name -- 银行机构名称
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,user_id -- 交易柜员编号
    ,bank_in_out -- 是否行内行外
    ,card_pb_ind -- 卡/折标志
    ,company -- 法人
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,settle_base_acct_no -- 结算账号
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,branch_name -- 银行机构名称
    ,card_no -- 卡号
    ,client_no -- 客户编号
    ,prod_type -- 产品编号
    ,user_id -- 交易柜员编号
    ,bank_in_out -- 是否行内行外
    ,card_pb_ind -- 卡/折标志
    ,company -- 法人
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,settle_base_acct_no -- 结算账号
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_settle_card_preset_acct
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_settle_card_preset_acct exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_settle_card_preset_acct_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_settle_card_preset_acct to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_settle_card_preset_acct_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_settle_card_preset_acct',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);