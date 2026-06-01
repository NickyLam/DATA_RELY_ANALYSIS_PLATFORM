/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acc_cash
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acc_cash
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acc_cash purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_cash(
    accid varchar2(45) -- 账户代码
    ,accname varchar2(383) -- 账户名称
    ,status number(22) -- 账户状态 3：停用 11：已启用
    ,remark varchar2(300) -- 备注
    ,pc1 varchar2(45) -- 资金账户属性1 理财产品定义id
    ,pc2 varchar2(45) -- 资金账户属性2
    ,pc3 varchar2(45) -- 资金账户属性3
    ,pc4 varchar2(45) -- 资金账户属性4
    ,currency varchar2(5) -- 币种
    ,invest_type number(22) -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,i_id number(22) -- 机构号
    ,pp_env_code varchar2(45) -- 定价环境代码
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
grant select on ${iol_schema}.ibms_ttrd_acc_cash to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acc_cash is '二级资金账户表';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.accid is '账户代码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.accname is '账户名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.status is '账户状态 3：停用 11：已启用';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.pc1 is '资金账户属性1 理财产品定义id';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.pc2 is '资金账户属性2';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.pc3 is '资金账户属性3';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.pc4 is '资金账户属性4';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.invest_type is '0自有资产（自营业务）、1客户资产（代客、理财）';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.pp_env_code is '定价环境代码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acc_cash.etl_timestamp is 'ETL处理时间戳';
