/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_bookkeeping_obj_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his(
    tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,subj_org_id varchar2(45) -- 机构码
    ,subj_code varchar2(150) -- 科目码
    ,subj_sub_code varchar2(150) -- 科目子码
    ,inner_acct_sn varchar2(45) -- 内部账序号
    ,core_acct_code varchar2(45) -- 核心账号
    ,currency varchar2(5) -- 币种
    ,debit_value number(31,2) -- 借方余额
    ,credit_value number(31,2) -- 贷方余额
    ,pay_value number(31,8) -- 付款余额
    ,receive_value number(31,8) -- 收款余额
    ,secu_acct_id varchar2(45) -- 券账户
    ,cash_acct_id varchar2(45) -- 资金账户
    ,update_time varchar2(29) -- 更新时间
    ,core_acct_name varchar2(300) -- 核心账号名称
    ,t_currency varchar2(5) -- 折算币种
    ,t_credit_value number(31,8) -- 折算后贷方余额
    ,t_debit_value number(31,8) -- 折算后借方余额
    ,ext_i_code varchar2(120) -- 金融工具代码
    ,ext_a_type varchar2(30) -- 金融工具资产类型
    ,ext_m_type varchar2(30) -- 金融工具市场类型
    ,ext_dim1 varchar2(300) -- 扩展维度1
    ,ext_dim2 varchar2(300) -- 扩展维度2
    ,ext_dim3 varchar2(300) -- 扩展维度3
    ,ext_dim4 varchar2(300) -- 扩展维度4
    ,ext_dim5 varchar2(300) -- 扩展维度5
    ,ext_dim6 varchar2(300) -- 扩展维度6
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
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_his to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_his to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_his to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_bookkeeping_obj_his is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.subj_org_id is '机构码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.subj_code is '科目码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.subj_sub_code is '科目子码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.inner_acct_sn is '内部账序号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.core_acct_code is '核心账号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.debit_value is '借方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.credit_value is '贷方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.pay_value is '付款余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.receive_value is '收款余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.secu_acct_id is '券账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.cash_acct_id is '资金账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.core_acct_name is '核心账号名称';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.t_currency is '折算币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.t_credit_value is '折算后贷方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.t_debit_value is '折算后借方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim2 is '扩展维度2';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim3 is '扩展维度3';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim4 is '扩展维度4';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim5 is '扩展维度5';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.ext_dim6 is '扩展维度6';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_his.etl_timestamp is 'ETL处理时间戳';
