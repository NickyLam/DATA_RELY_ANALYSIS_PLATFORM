/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_abs_account_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_abs_account_info
whenever sqlerror continue none;
drop table ${iol_schema}.abss_abs_account_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_account_info(
    accountid varchar2(60) -- 账户编号
    ,productid varchar2(60) -- 产品编号
    ,accounttype varchar2(36) -- 账户类型
    ,accountno varchar2(48) -- 账户号码
    ,accountname varchar2(300) -- 账户名称
    ,accountbank varchar2(36) -- 账户开户行
    ,accountaffiorg varchar2(36) -- 账户归属机构
    ,accountbalance number(24,6) -- 账户余额
    ,remark varchar2(383) -- 余额
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
grant select on ${iol_schema}.abss_abs_account_info to ${iml_schema};
grant select on ${iol_schema}.abss_abs_account_info to ${icl_schema};
grant select on ${iol_schema}.abss_abs_account_info to ${idl_schema};
grant select on ${iol_schema}.abss_abs_account_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_abs_account_info is '账户信息表';
comment on column ${iol_schema}.abss_abs_account_info.accountid is '账户编号';
comment on column ${iol_schema}.abss_abs_account_info.productid is '产品编号';
comment on column ${iol_schema}.abss_abs_account_info.accounttype is '账户类型';
comment on column ${iol_schema}.abss_abs_account_info.accountno is '账户号码';
comment on column ${iol_schema}.abss_abs_account_info.accountname is '账户名称';
comment on column ${iol_schema}.abss_abs_account_info.accountbank is '账户开户行';
comment on column ${iol_schema}.abss_abs_account_info.accountaffiorg is '账户归属机构';
comment on column ${iol_schema}.abss_abs_account_info.accountbalance is '账户余额';
comment on column ${iol_schema}.abss_abs_account_info.remark is '余额';
comment on column ${iol_schema}.abss_abs_account_info.start_dt is '开始时间';
comment on column ${iol_schema}.abss_abs_account_info.end_dt is '结束时间';
comment on column ${iol_schema}.abss_abs_account_info.id_mark is '增删标志';
comment on column ${iol_schema}.abss_abs_account_info.etl_timestamp is 'ETL处理时间戳';
