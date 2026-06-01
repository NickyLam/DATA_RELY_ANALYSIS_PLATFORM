/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_bail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_bail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_bail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_bail(
    clrid varchar2(32) -- 押品编号
    ,account varchar2(60) -- 账号
    ,bailseqno varchar2(30) -- 保证金流水号
    ,freezemoney number(20,2) -- 保证金冻结金额
    ,childaccount varchar2(60) -- 子账户号
    ,opendept varchar2(60) -- 开户机构
    ,tdcurrency varchar2(3) -- 币种
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
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
grant select on ${iol_schema}.icms_clr_asset_finance_bail to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bail to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bail to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_bail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_bail is '保证金';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.account is '账号';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.bailseqno is '保证金流水号';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.freezemoney is '保证金冻结金额';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.childaccount is '子账户号';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.opendept is '开户机构';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_bail.etl_timestamp is 'ETL处理时间戳';
