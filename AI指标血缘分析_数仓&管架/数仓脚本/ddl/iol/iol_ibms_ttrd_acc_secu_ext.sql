/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acc_secu_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acc_secu_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acc_secu_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_secu_ext(
    accid varchar2(30) -- 账户代码
    ,accname varchar2(180) -- 账户名称
    ,market varchar2(30) -- 交易市场
    ,exhacc varchar2(30) -- 交易所账户
    ,exhseat varchar2(15) -- 交易所席位
    ,acctype varchar2(2) -- 账户类型
    ,status number(22) -- 账户状态
    ,exec_mode number(22) -- 执行模式
    ,grade varchar2(3) -- 甲乙丙丁
    ,cash_ext_accid varchar2(30) -- 外部资金账户id
    ,host_market varchar2(30) -- 托管场所
    ,i_id number(22) -- 机构号
    ,spv_id number(16,0) -- spv信息id
    ,s_pset varchar2(33) -- 结算场所代码
    ,s_pset_name varchar2(75) -- 结算场所名称
    ,s_pset_country varchar2(15) -- 国家代码
    ,s_agent_code_type varchar2(2) -- 代理行代码类型,1:bic,2:dss
    ,s_agent_code_dss varchar2(270) -- 代理行代码编码集合名称
    ,s_agent_code varchar2(420) -- 代理行代码
    ,s_agent_account varchar2(150) -- 代理行账号
    ,s_code_type varchar2(2) -- 交易主体代码类型,1:bic,2:dss
    ,s_code_dss varchar2(270) -- 交易主体代码编码集合名称
    ,s_code varchar2(420) -- 交易主体代码
    ,s_account varchar2(150) -- 交易主体账号
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
grant select on ${iol_schema}.ibms_ttrd_acc_secu_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_secu_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acc_secu_ext is '一级证券账户表';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.accid is '账户代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.accname is '账户名称';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.market is '交易市场';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.exhacc is '交易所账户';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.exhseat is '交易所席位';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.acctype is '账户类型';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.status is '账户状态';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.exec_mode is '执行模式';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.grade is '甲乙丙丁';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.cash_ext_accid is '外部资金账户id';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.host_market is '托管场所';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.spv_id is 'spv信息id';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_pset is '结算场所代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_pset_name is '结算场所名称';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_pset_country is '国家代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_agent_code_type is '代理行代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_agent_code_dss is '代理行代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_agent_code is '代理行代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_agent_account is '代理行账号';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_code_type is '交易主体代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_code_dss is '交易主体代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_code is '交易主体代码';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.s_account is '交易主体账号';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acc_secu_ext.etl_timestamp is 'ETL处理时间戳';
