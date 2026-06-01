/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ul_acct_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ul_acct_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ul_acct_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ul_acct_balance(
    cmisloan_no varchar2(60) -- 客户借据编号|客户借据编号
    ,client_no varchar2(16) -- 客户编号|客户编号
    ,dd_amt number(17,2) -- 发放金额|发放金额
    ,osl_amt number(17,2) -- 客户未到期本金|客户未到期本金
    ,prd_amt number(17,2) -- 逾期本金 |逾期本金
    ,intp_amt number(17,2) -- 逾期利息|逾期利息
    ,odpp_amt number(17,2) -- 逾期罚息余额  |逾期罚息余额
    ,odip_amt number(17,2) -- 复利余额  |复利余额
    ,gprd_amt number(17,2) -- 宽限期本金 |宽限期本金
    ,gintp_amt number(17,2) -- 宽限期利息 |宽限期利息
    ,godpp_amt number(17,2) -- 宽限期罚息 |宽限期罚息
    ,godip_amt number(17,2) -- 宽限期复利 |宽限期复利
    ,company varchar2(20) -- 法人|法人
    ,tran_timestamp varchar2(26) -- 交易时间戳|交易时间戳
    ,batch_no varchar2(50) -- 批次号|批次号
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
grant select on ${iol_schema}.ncbs_ul_acct_balance to ${iml_schema};
grant select on ${iol_schema}.ncbs_ul_acct_balance to ${icl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_balance to ${idl_schema};
grant select on ${iol_schema}.ncbs_ul_acct_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ul_acct_balance is '联合贷贷款余额信息表';
comment on column ${iol_schema}.ncbs_ul_acct_balance.cmisloan_no is '客户借据编号|客户借据编号';
comment on column ${iol_schema}.ncbs_ul_acct_balance.client_no is '客户编号|客户编号';
comment on column ${iol_schema}.ncbs_ul_acct_balance.dd_amt is '发放金额|发放金额';
comment on column ${iol_schema}.ncbs_ul_acct_balance.osl_amt is '客户未到期本金|客户未到期本金';
comment on column ${iol_schema}.ncbs_ul_acct_balance.prd_amt is '逾期本金 |逾期本金';
comment on column ${iol_schema}.ncbs_ul_acct_balance.intp_amt is '逾期利息|逾期利息';
comment on column ${iol_schema}.ncbs_ul_acct_balance.odpp_amt is '逾期罚息余额  |逾期罚息余额';
comment on column ${iol_schema}.ncbs_ul_acct_balance.odip_amt is '复利余额  |复利余额';
comment on column ${iol_schema}.ncbs_ul_acct_balance.gprd_amt is '宽限期本金 |宽限期本金';
comment on column ${iol_schema}.ncbs_ul_acct_balance.gintp_amt is '宽限期利息 |宽限期利息';
comment on column ${iol_schema}.ncbs_ul_acct_balance.godpp_amt is '宽限期罚息 |宽限期罚息';
comment on column ${iol_schema}.ncbs_ul_acct_balance.godip_amt is '宽限期复利 |宽限期复利';
comment on column ${iol_schema}.ncbs_ul_acct_balance.company is '法人|法人';
comment on column ${iol_schema}.ncbs_ul_acct_balance.tran_timestamp is '交易时间戳|交易时间戳';
comment on column ${iol_schema}.ncbs_ul_acct_balance.batch_no is '批次号|批次号';
comment on column ${iol_schema}.ncbs_ul_acct_balance.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_ul_acct_balance.etl_timestamp is 'ETL处理时间戳';
