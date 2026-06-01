/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_bwarereceipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_bwarereceipt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_bwarereceipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_bwarereceipt(
    clrid varchar2(32) -- 押品编号
    ,warereceiptno varchar2(100) -- 仓单编号
    ,startdate date -- 仓单起始日期
    ,enddate date -- 仓单到期日期
    ,tradename varchar2(100) -- 货物名称
    ,issuername varchar2(100) -- 发行人名称
    ,issuertype varchar2(2) -- 发行人类型
    ,bourse varchar2(2) -- 仓单所属交易所
    ,totalprice number(24,6) -- 标准仓单价值
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
grant select on ${iol_schema}.icms_clr_asset_other_bwarereceipt to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_bwarereceipt to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_bwarereceipt to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_bwarereceipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_bwarereceipt is '其他类之标准仓单信息表';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.warereceiptno is '仓单编号';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.startdate is '仓单起始日期';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.enddate is '仓单到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.tradename is '货物名称';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.issuername is '发行人名称';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.issuertype is '发行人类型';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.bourse is '仓单所属交易所';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.totalprice is '标准仓单价值';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_bwarereceipt.etl_timestamp is 'ETL处理时间戳';
