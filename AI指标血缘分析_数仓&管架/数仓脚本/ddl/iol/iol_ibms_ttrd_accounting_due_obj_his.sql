/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_due_obj_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_due_obj_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_due_obj_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_due_obj_his(
    obj_id varchar2(45) -- 对象id
    ,tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,prmr_inst_id number(16,0) -- 主指令id
    ,currency varchar2(5) -- 币种
    ,pay_amount number(31,8) -- 支付余额
    ,receive_amount number(31,8) -- 收取余额
    ,open_time varchar2(29) -- 开仓时间
    ,update_time varchar2(29) -- 更新时间
    ,first_prmr_inst_id number(16,0) -- 首次挂账主指令号
    ,inst_type varchar2(2) -- 存储维度的指令类型
    ,inst_ext_acct_id varchar2(30) -- 外部账户
    ,inst_int_acct_id varchar2(45) -- 内部账户
    ,inst_trade_grp_id varchar2(30) -- 组合号
    ,inst_i_code varchar2(120) -- 金融工具代码
    ,inst_a_type varchar2(30) -- 金融工具类型
    ,inst_m_type varchar2(30) -- 金融工具市场
    ,state number(4,0) -- 挂账状态
    ,pay_cp number(31,8) -- 支付成本
    ,receive_cp number(31,8) -- 收取成本
    ,pay_ai number(31,8) -- 支付利息
    ,receive_ai number(31,8) -- 收取利息
    ,pay_fee number(31,8) -- 支付费用
    ,receive_fee number(31,8) -- 收取费用
    ,pay_cash number(31,8) -- 支付资金
    ,receive_cash number(31,8) -- 收取资金
    ,inst_custom_dim1 varchar2(300) -- 扩展维度1
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
grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_due_obj_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_due_obj_his is '应收款核算余额表历史';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.obj_id is '对象id';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.prmr_inst_id is '主指令id';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.pay_amount is '支付余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.receive_amount is '收取余额';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.open_time is '开仓时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.first_prmr_inst_id is '首次挂账主指令号';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_type is '存储维度的指令类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_ext_acct_id is '外部账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_int_acct_id is '内部账户';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_trade_grp_id is '组合号';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_a_type is '金融工具类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_m_type is '金融工具市场';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.state is '挂账状态';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.pay_cp is '支付成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.receive_cp is '收取成本';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.pay_ai is '支付利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.receive_ai is '收取利息';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.pay_fee is '支付费用';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.receive_fee is '收取费用';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.pay_cash is '支付资金';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.receive_cash is '收取资金';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.inst_custom_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_accounting_due_obj_his.etl_timestamp is 'ETL处理时间戳';
