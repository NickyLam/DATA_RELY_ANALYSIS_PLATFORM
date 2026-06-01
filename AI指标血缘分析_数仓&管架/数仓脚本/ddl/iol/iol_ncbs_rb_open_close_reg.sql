/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_open_close_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_open_close_reg
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_open_close_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_open_close_reg(
    acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reason_code varchar2(10) -- 账户用途
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_nature varchar2(10) -- 存款账户类型
    ,company varchar2(20) -- 法人
    ,inform_bank_flag varchar2(1) -- 是否通知人行
    ,is_self varchar2(1) -- 视同本人标志
    ,narrative varchar2(400) -- 摘要
    ,op_method varchar2(1) -- 开销户操作方式
    ,reason_code_desc varchar2(100) -- 原因代码描述
    ,reg_type varchar2(1) -- 登记类型
    ,seq_no varchar2(50) -- 序号
    ,suc_flag varchar2(1) -- 社会统一信用代码标志
    ,active_date date -- 激活日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,open_branch varchar2(12) -- 开立机构
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,approval_no varchar2(50) -- 审批单号
    ,narrative_code varchar2(30) -- 摘要码
    ,extra_tran_timestamp varchar2(26) -- 反洗钱加工时间戳
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
grant select on ${iol_schema}.ncbs_rb_open_close_reg to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_open_close_reg to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_open_close_reg to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_open_close_reg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_open_close_reg is '账户/卡开立注销登记簿';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.company is '法人';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.inform_bank_flag is '是否通知人行';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.is_self is '视同本人标志';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.op_method is '开销户操作方式';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.reason_code_desc is '原因代码描述';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.reg_type is '登记类型';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.suc_flag is '社会统一信用代码标志';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.active_date is '激活日期';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.extra_tran_timestamp is '反洗钱加工时间戳';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_open_close_reg.etl_timestamp is 'ETL处理时间戳';
