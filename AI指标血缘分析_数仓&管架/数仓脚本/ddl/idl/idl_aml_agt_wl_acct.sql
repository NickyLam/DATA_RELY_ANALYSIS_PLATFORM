/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_agt_wl_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_agt_wl_acct
whenever sqlerror continue none;
drop table ${idl_schema}.aml_agt_wl_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_agt_wl_acct(
    etl_dt date -- 数据日期   
    ,acct_id varchar2(60) -- 账户编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,acct_name varchar2(250) -- 账户名称   
    ,acct_type_cd varchar2(30) -- 账户类型代码   
    ,cap_acct_id varchar2(60) -- 资金账户编号   
    ,open_bank_name varchar2(500) -- 开户行名称   
    ,open_bank_num varchar2(60) -- 开户行号   
    ,open_acct_name varchar2(250) -- 开户名称   
    ,acct_status_cd varchar2(30) -- 账户状态代码   
    ,teller_id varchar2(60) -- 柜员编号   
    ,asset_acct_type_cd varchar2(30) -- 资产账户类型代码   
    ,bd_card_no varchar2(60) -- 绑定卡卡号   
    ,bind_mobile_no varchar2(60) -- 绑定手机号码   
    ,pbc_fin_inst_code varchar2(60) -- 人行金融机构编码   
    ,obank_card_flg varchar2(30) -- 他行卡标志   
    ,cust_id varchar2(60) -- 客户编号   
    ,start_dt date -- 开始日期   
    ,end_dt date -- 结束日期   
    ,id_mark varchar2(10) -- 删除标识   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_agt_wl_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_agt_wl_acct is '网贷账户';
comment on column ${idl_schema}.aml_agt_wl_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_agt_wl_acct.acct_id is '账户编号';
comment on column ${idl_schema}.aml_agt_wl_acct.lp_id is '法人编号';
comment on column ${idl_schema}.aml_agt_wl_acct.acct_name is '账户名称';
comment on column ${idl_schema}.aml_agt_wl_acct.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.aml_agt_wl_acct.cap_acct_id is '资金账户编号';
comment on column ${idl_schema}.aml_agt_wl_acct.open_bank_name is '开户行名称';
comment on column ${idl_schema}.aml_agt_wl_acct.open_bank_num is '开户行号';
comment on column ${idl_schema}.aml_agt_wl_acct.open_acct_name is '开户名称';
comment on column ${idl_schema}.aml_agt_wl_acct.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.aml_agt_wl_acct.teller_id is '柜员编号';
comment on column ${idl_schema}.aml_agt_wl_acct.asset_acct_type_cd is '资产账户类型代码';
comment on column ${idl_schema}.aml_agt_wl_acct.bd_card_no is '绑定卡卡号';
comment on column ${idl_schema}.aml_agt_wl_acct.bind_mobile_no is '绑定手机号码';
comment on column ${idl_schema}.aml_agt_wl_acct.pbc_fin_inst_code is '人行金融机构编码';
comment on column ${idl_schema}.aml_agt_wl_acct.obank_card_flg is '他行卡标志';
comment on column ${idl_schema}.aml_agt_wl_acct.cust_id is '客户编号';
comment on column ${idl_schema}.aml_agt_wl_acct.start_dt is '开始日期';
comment on column ${idl_schema}.aml_agt_wl_acct.end_dt is '结束日期';
comment on column ${idl_schema}.aml_agt_wl_acct.id_mark is '删除标识';
comment on column ${idl_schema}.aml_agt_wl_acct.job_cd is '任务代码';
comment on column ${idl_schema}.aml_agt_wl_acct.etl_timestamp is '数据处理时间';