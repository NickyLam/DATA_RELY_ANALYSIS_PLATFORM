/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_fixedterm_account
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_fixedterm_account
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_fixedterm_account(
    acct_id number(16,0) -- 主键id
    ,acct_code varchar2(45) -- 定期账户
    ,acct_name varchar2(383) -- 定期账号名称
    ,bank_code varchar2(75) -- 开户行号
    ,bank_name varchar2(383) -- 开户行名称
    ,i_id number(22) -- 机构号
    ,party_id number(22) -- 
    ,core_acct_code varchar2(45) -- 核心账号
    ,core_acct_name varchar2(383) -- 核心账号名称
    ,currency varchar2(5) -- 币种
    ,acct_type number(22,0) -- 账户类型
    ,status number(22,0) -- 账户状态
    ,update_user number(19,0) -- 更新人
    ,update_time varchar2(29) -- 更新时间
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
grant select on ${iol_schema}.ibms_ttrd_fixedterm_account to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_fixedterm_account to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_fixedterm_account to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_fixedterm_account to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_fixedterm_account is '定期账户';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.acct_id is '主键id';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.acct_code is '定期账户';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.acct_name is '定期账号名称';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.bank_code is '开户行号';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.bank_name is '开户行名称';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.party_id is '';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.core_acct_code is '核心账号';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.core_acct_name is '核心账号名称';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.acct_type is '账户类型';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.status is '账户状态';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.update_user is '更新人';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_fixedterm_account.etl_timestamp is 'ETL处理时间戳';
