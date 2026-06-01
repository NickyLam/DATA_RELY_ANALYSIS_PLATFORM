/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_finance_profit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_finance_profit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_finance_profit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_profit(
    clrid varchar2(32) -- 押品编号
    ,inappdocno varchar2(120) -- 收益权政府批文文号
    ,inappdocnum varchar2(200) -- 收益权政府批文名称
    ,ownerno varchar2(120) -- 权益证书编号
    ,ownername varchar2(100) -- 权益所有人名称
    ,startdate date -- 权益开始时间
    ,duedate date -- 权益到期时间
    ,remark varchar2(4000) -- 其他说明
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
grant select on ${iol_schema}.icms_clr_asset_finance_profit to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_profit to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_profit to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_finance_profit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_finance_profit is '金融质押品之收益权信息表';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.inappdocno is '收益权政府批文文号';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.inappdocnum is '收益权政府批文名称';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.ownerno is '权益证书编号';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.ownername is '权益所有人名称';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.startdate is '权益开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.duedate is '权益到期时间';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_finance_profit.etl_timestamp is 'ETL处理时间戳';
