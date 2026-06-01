/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_billofload
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_billofload
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_billofload purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_billofload(
    clrid varchar2(32) -- 押品编号
    ,billno varchar2(100) -- 单据号码
    ,tradename varchar2(100) -- 货物名称
    ,unit varchar2(2) -- 货物计量单位
    ,otherremark varchar2(30) -- 其他计量单位说明
    ,amount number(38,0) -- 货物账面数量
    ,perprice number(24,6) -- 货物账面单价
    ,tdcurrency varchar2(3) -- 币种
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
grant select on ${iol_schema}.icms_clr_asset_other_billofload to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_billofload to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_billofload to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_billofload to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_billofload is '其他类之提单信息表';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.billno is '单据号码';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.tradename is '货物名称';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.unit is '货物计量单位';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.otherremark is '其他计量单位说明';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.amount is '货物账面数量';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.perprice is '货物账面单价';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_billofload.etl_timestamp is 'ETL处理时间戳';
