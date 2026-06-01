/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_accountrelatedwithbondissue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_accountrelatedwithbondissue
whenever sqlerror continue none;
drop table ${iol_schema}.wind_accountrelatedwithbondissue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_accountrelatedwithbondissue(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,type_code number(9,0) -- 发行类型代码
    ,account_num varchar2(60) -- 账号
    ,account_title varchar2(150) -- 账户名称
    ,bank_name varchar2(150) -- 开户行名称
    ,bank_num varchar2(60) -- 清算行行号
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
grant select on ${iol_schema}.wind_accountrelatedwithbondissue to ${iml_schema};
grant select on ${iol_schema}.wind_accountrelatedwithbondissue to ${icl_schema};
grant select on ${iol_schema}.wind_accountrelatedwithbondissue to ${idl_schema};
grant select on ${iol_schema}.wind_accountrelatedwithbondissue to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_accountrelatedwithbondissue is '债券发行涉及银行账号';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.object_id is '对象ID';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.type_code is '发行类型代码';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.account_num is '账号';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.account_title is '账户名称';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.bank_name is '开户行名称';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.bank_num is '清算行行号';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.start_dt is '开始时间';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.end_dt is '结束时间';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.id_mark is '增删标志';
comment on column ${iol_schema}.wind_accountrelatedwithbondissue.etl_timestamp is 'ETL处理时间戳';
