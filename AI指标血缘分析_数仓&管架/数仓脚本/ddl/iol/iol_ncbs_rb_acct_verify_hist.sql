/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_verify_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_verify_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_verify_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_verify_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,disposal_method varchar2(2) -- 处置方法
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,verification_date date -- 核实日期
    ,acct_proof_reason varchar2(200) -- 验证失败原因
    ,narrative1 varchar2(600) -- 备注
    ,oper_user_id varchar2(8) -- 操作柜员
    ,acct_verify_status varchar2(2) -- 账户核实状态
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
grant select on ${iol_schema}.ncbs_rb_acct_verify_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_verify_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_verify_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_verify_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_verify_hist is '账户核实历史登记簿';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.disposal_method is '处置方法';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.verification_date is '核实日期';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.acct_proof_reason is '验证失败原因';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.narrative1 is '备注';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.oper_user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.acct_verify_status is '账户核实状态';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_verify_hist.etl_timestamp is 'ETL处理时间戳';
