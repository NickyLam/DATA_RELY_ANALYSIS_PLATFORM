/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_prod_reaccount_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_prod_reaccount_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_prod_reaccount_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_prod_reaccount_reg(
    reference varchar2(50) -- 交易参考号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,dr_cr_flag varchar2(1) -- 借贷方向标志
    ,pri_amt_str varchar2(50) -- 本金金额
    ,int_amt number(17,2) -- 利息金额
    ,prod_balance number(17,2) -- 产品余额
    ,tran_date date -- 交易日期
    ,tran_time varchar2(26) -- 交易时间
    ,tran_type varchar2(10) -- 交易类型
    ,channel_muster varchar2(500) -- 渠道集合
    ,collect_principal_amt number(17,2) -- 联动交易本金
    ,collect_tran_remark varchar2(600) -- 联动交易备注
    ,client_no varchar2(16) -- 客户编号
    ,agreement_type varchar2(5) -- 协议类型
    ,agreement_id varchar2(50) -- 协议编号
    ,seq_no varchar2(50) -- 序号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,mon_avg_amt number(17,2) -- 月平均余额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_prod_reaccount_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_prod_reaccount_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_reaccount_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_prod_reaccount_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_prod_reaccount_reg is '产品对账单|产品对账单';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.dr_cr_flag is '借贷方向标志';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.pri_amt_str is '本金金额';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.prod_balance is '产品余额';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.tran_time is '交易时间';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.channel_muster is '渠道集合';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.collect_principal_amt is '联动交易本金';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.collect_tran_remark is '联动交易备注';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.mon_avg_amt is '月平均余额';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_prod_reaccount_reg.etl_timestamp is 'ETL处理时间戳';
