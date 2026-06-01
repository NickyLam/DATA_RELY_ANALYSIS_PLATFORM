/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_fee_int_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_fee_int_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_fee_int_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_fee_int_detail(
    fee_int_no varchar2(50) -- 费用计提编号
    ,int_amt number(17,2) -- 利息金额
    ,start_accrual_date date -- 开始计提日期
    ,end_accrual_date date -- 结束计提日期
    ,freq_type varchar2(5) -- 频率
    ,ext_trade_no varchar2(50) -- 原业务编号
    ,fee_type varchar2(20) -- 费率类型
    ,status varchar2(1) -- 状态
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,user_id varchar2(8) -- 交易柜员编号
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,tran_date date -- 交易日期
    ,write_off_int_amt number(17,2) -- 核销利息
    ,recalc_start_date date -- 利息重算起始日
    ,accr_date date -- 计提日期
    ,next_accr_date date -- 下一计提日期
    ,narrative varchar2(400) -- 摘要
    ,narrative_code varchar2(30) -- 摘要码
    ,int_accr number(17,2) -- 计提利息
    ,recalc_int_amt number(17,2) -- 重算利息总金额
    ,reference varchar2(50) -- 交易参考号
    ,ccy varchar2(3) -- 币种
    ,oth_client_name varchar2(200) -- 对手客户名称
    ,acct_exec_name varchar2(200) -- 客户经理姓名
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,oth_client_no varchar2(16) -- 对手客户
    ,oth_business_no varchar2(200) -- 对手业务编号
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
grant select on ${iol_schema}.ncbs_rb_fee_int_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_fee_int_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_fee_int_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_fee_int_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_fee_int_detail is '费用计提明细表';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.fee_int_no is '费用计提编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.start_accrual_date is '开始计提日期';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.end_accrual_date is '结束计提日期';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.freq_type is '频率';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.ext_trade_no is '原业务编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.status is '状态';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.write_off_int_amt is '核销利息';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.recalc_start_date is '利息重算起始日';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.accr_date is '计提日期';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.next_accr_date is '下一计提日期';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.narrative_code is '摘要码';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.int_accr is '计提利息';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.recalc_int_amt is '重算利息总金额';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.oth_client_name is '对手客户名称';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.acct_exec_name is '客户经理姓名';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.oth_client_no is '对手客户';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.oth_business_no is '对手业务编号';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_fee_int_detail.etl_timestamp is 'ETL处理时间戳';
