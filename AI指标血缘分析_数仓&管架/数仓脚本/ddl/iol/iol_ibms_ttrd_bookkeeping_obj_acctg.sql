/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_bookkeeping_obj_acctg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg(
    tsk_id varchar2(45) -- 
    ,beg_date varchar2(15) -- 
    ,end_date varchar2(15) -- 
    ,subj_org_id varchar2(45) -- 
    ,subj_code varchar2(150) -- 
    ,subj_sub_code varchar2(150) -- 
    ,inner_acct_sn varchar2(45) -- 
    ,core_acct_code varchar2(45) -- 
    ,currency varchar2(5) -- 
    ,debit_value number(31,2) -- 
    ,credit_value number(31,2) -- 
    ,pay_value number(31,8) -- 
    ,receive_value number(31,8) -- 
    ,secu_acct_id varchar2(45) -- 
    ,cash_acct_id varchar2(45) -- 
    ,update_time varchar2(29) -- 
    ,core_acct_name varchar2(300) -- 
    ,t_currency varchar2(5) -- 折算币种
    ,t_credit_value number(31,8) -- 折算后贷方余额
    ,t_debit_value number(31,8) -- 折算后借方余额
    ,acctg_obj_id varchar2(45) -- 核算对象id
    ,ext_i_code varchar2(120) -- 金融工具代码
    ,ext_a_type varchar2(30) -- 金融工具资产类型
    ,ext_m_type varchar2(30) -- 金融工具市场类型
    ,ext_dim1 varchar2(300) -- 扩展维度1
    ,ext_dim2 varchar2(300) -- 扩展维度2
    ,ext_dim3 varchar2(300) -- 扩展维度3
    ,ext_dim4 varchar2(300) -- 扩展维度4
    ,ext_dim5 varchar2(300) -- 扩展维度5
    ,ext_dim6 varchar2(300) -- 扩展维度6
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
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.tsk_id is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.beg_date is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.end_date is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.subj_org_id is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.subj_code is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.subj_sub_code is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.inner_acct_sn is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.core_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.currency is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.debit_value is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.credit_value is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.pay_value is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.receive_value is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.secu_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.cash_acct_id is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.update_time is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.core_acct_name is '';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.t_currency is '折算币种';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.t_credit_value is '折算后贷方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.t_debit_value is '折算后借方余额';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.acctg_obj_id is '核算对象id';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_a_type is '金融工具资产类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_m_type is '金融工具市场类型';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim1 is '扩展维度1';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim2 is '扩展维度2';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim3 is '扩展维度3';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim4 is '扩展维度4';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim5 is '扩展维度5';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.ext_dim6 is '扩展维度6';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_bookkeeping_obj_acctg.etl_timestamp is 'ETL处理时间戳';
