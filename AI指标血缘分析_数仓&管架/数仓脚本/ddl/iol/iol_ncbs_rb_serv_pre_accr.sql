/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_serv_pre_accr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_serv_pre_accr
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_serv_pre_accr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_serv_pre_accr(
    pre_accr_no varchar2(50) -- 预提摊销编号
    ,pre_accr_status varchar2(1) -- 预提状态
    ,gl_code varchar2(20) -- 科目代码
    ,fee_type varchar2(20) -- 费率类型
    ,cur_pre_accr_amt number(17,2) -- 当日预提金额
    ,total_pre_accr_amt number(17,2) -- 预提总金额
    ,agg_pre_accr_amt number(17,2) -- 累计已预提金额
    ,can_pay_accr_amt number(17,2) -- 可支出金额
    ,paid_pre_accr_amt number(17,2) -- 已支出金额
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,amortize_period_type varchar2(1) -- 摊销期限类型
    ,amortize_day varchar2(2) -- 摊销日
    ,amortize_month varchar2(2) -- 摊销月
    ,pre_accr_date date -- 预提日期
    ,supplement_date date -- 补账日期
    ,start_date date -- 开始日期
    ,end_date date -- 结束日期
    ,oper_date date -- 操作日期
    ,oper_user_id varchar2(8) -- 操作柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,branch varchar2(12) -- 交易机构编号
    ,ext_trade_no varchar2(50) -- 原业务编号
    ,remark varchar2(600) -- 备注
    ,client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,ccy varchar2(3) -- 币种
    ,recalc_start_date date -- 利息重算起始日
    ,recalc_int_amt number(17,2) -- 重算利息总金额
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_exec_name varchar2(200) -- 客户经理姓名
    ,oth_client_no varchar2(16) -- 对手客户
    ,oth_client_name varchar2(200) -- 对手客户名称
    ,oth_business_no varchar2(200) -- 对手业务编号
    ,oth_client_type varchar2(3) -- 对手客户类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_rb_serv_pre_accr to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_serv_pre_accr to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_serv_pre_accr to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_serv_pre_accr to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_serv_pre_accr is '费用预提信息表';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.pre_accr_no is '预提摊销编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.pre_accr_status is '预提状态';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.cur_pre_accr_amt is '当日预提金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.total_pre_accr_amt is '预提总金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.agg_pre_accr_amt is '累计已预提金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.can_pay_accr_amt is '可支出金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.paid_pre_accr_amt is '已支出金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.amortize_period_type is '摊销期限类型';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.amortize_day is '摊销日';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.amortize_month is '摊销月';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.pre_accr_date is '预提日期';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.supplement_date is '补账日期';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oper_date is '操作日期';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oper_user_id is '操作柜员';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.branch is '交易机构编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.ext_trade_no is '原业务编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.recalc_start_date is '利息重算起始日';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.recalc_int_amt is '重算利息总金额';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.acct_exec_name is '客户经理姓名';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oth_client_no is '对手客户';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oth_client_name is '对手客户名称';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oth_business_no is '对手业务编号';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.oth_client_type is '对手客户类型';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_serv_pre_accr.etl_timestamp is 'ETL处理时间戳';
