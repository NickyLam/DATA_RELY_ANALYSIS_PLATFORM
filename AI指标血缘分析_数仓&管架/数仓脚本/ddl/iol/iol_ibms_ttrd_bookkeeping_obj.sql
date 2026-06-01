/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_bookkeeping_obj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_bookkeeping_obj
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj(
    tsk_id varchar2(45) -- 任务id
    ,beg_date varchar2(15) -- 开始日期
    ,end_date varchar2(15) -- 结束日期
    ,subj_org_id varchar2(45) -- 机构码
    ,subj_code varchar2(150) -- 科目码
    ,subj_sub_code varchar2(150) -- 科目子码
    ,inner_acct_sn varchar2(45) -- 内部账序号
    ,core_acct_code varchar2(45) -- 核心账号
    ,currency varchar2(5) -- 币种
    ,debit_value number(20,2) -- 借方余额
    ,credit_value number(20,2) -- 贷方余额
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
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_bookkeeping_obj is '会计余额表';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.tsk_id is '任务id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.beg_date is '开始日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.end_date is '结束日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.subj_org_id is '机构码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.subj_code is '科目码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.subj_sub_code is '科目子码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.inner_acct_sn is '内部账序号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.core_acct_code is '核心账号';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.debit_value is '借方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.credit_value is '贷方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.pay_value is '付款余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.receive_value is '收款余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.secu_acct_id is '券账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.cash_acct_id is '资金账户';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.core_acct_name is '核心账号名称';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.t_currency is '折算币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.t_credit_value is '折算后贷方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.t_debit_value is '折算后借方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim2 is '扩展维度2';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim3 is '扩展维度3';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim4 is '扩展维度4';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim5 is '扩展维度5';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.ext_dim6 is '扩展维度6';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj.etl_timestamp is 'ETL处理时间戳';
