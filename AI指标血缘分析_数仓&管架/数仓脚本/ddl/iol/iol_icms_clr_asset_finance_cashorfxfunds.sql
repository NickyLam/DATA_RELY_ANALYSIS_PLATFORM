/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_cashorfxfunds
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_cashorfxfunds
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_cashorfxfunds purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_cashorfxfunds(
    clrid varchar2(96) -- 押品编号
    ,currency varchar2(9) -- 币种
    ,account varchar2(240) -- 账号
    ,subaccount varchar2(120) -- 子账户号
    ,openaccountorgid varchar2(96) -- 开户机构
    ,startdate date -- 起始日期
    ,enddate date -- 截止日期
    ,usebalance number(24,6) -- 账户可用余额
    ,pledgesum number(24,6) -- 质押金额
    ,remark varchar2(2400) -- 其他说明
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
grant select on ${iol_schema}.icms_clr_asset_finance_cashorfxfunds to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_cashorfxfunds to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_cashorfxfunds to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_cashorfxfunds to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_cashorfxfunds is '金融质押品之现金现汇信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.currency is '币种';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.account is '账号';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.subaccount is '子账户号';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.openaccountorgid is '开户机构';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.startdate is '起始日期';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.enddate is '截止日期';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.usebalance is '账户可用余额';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.pledgesum is '质押金额';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_cashorfxfunds.etl_timestamp is 'ETL处理时间戳';
