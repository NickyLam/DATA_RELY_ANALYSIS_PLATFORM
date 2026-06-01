/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_invoice_er_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_invoice_er_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_invoice_er_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_invoice_er_detail(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,invoice_gen_mode varchar2(1) -- 单据生成方式
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,sched_seq_no varchar2(50) -- 还款计划序号
    ,stage_no number(5) -- 期次
    ,due_date date -- 单据到期日
    ,end_date date -- 结束日期
    ,grace_date date -- 宽限日
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,billed_amt number(17,2) -- 出单金额
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
grant select on ${iol_schema}.ncbs_cl_invoice_er_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_er_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_er_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_invoice_er_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_invoice_er_detail is '罚息复利出单明细表';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.invoice_gen_mode is '单据生成方式';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.sched_seq_no is '还款计划序号';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.due_date is '单据到期日';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.grace_date is '宽限日';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.billed_amt is '出单金额';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_invoice_er_detail.etl_timestamp is 'ETL处理时间戳';
