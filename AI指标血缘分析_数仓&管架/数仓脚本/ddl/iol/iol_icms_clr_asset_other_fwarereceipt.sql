/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_fwarereceipt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_fwarereceipt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_fwarereceipt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_fwarereceipt(
    clrid varchar2(32) -- 押品编号
    ,billno varchar2(60) -- 单据号码
    ,startdate date -- 仓单起始日期
    ,enddate date -- 仓单到期日期
    ,tradename varchar2(100) -- 货物名称
    ,province varchar2(60) -- 所在/注册省份
    ,city varchar2(60) -- 所在/注册市
    ,unit varchar2(2) -- 货物计量单位
    ,otherremark varchar2(30) -- 其他计量单位说明
    ,amount number(38,0) -- 货物账面数量
    ,perprice number(24,6) -- 货物账面单价
    ,totalprice number(24,6) -- 非标仓单价值
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
grant select on ${iol_schema}.icms_clr_asset_other_fwarereceipt to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_fwarereceipt to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_fwarereceipt to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_fwarereceipt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_fwarereceipt is '其他类之非标准仓单信息表';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.billno is '单据号码';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.startdate is '仓单起始日期';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.enddate is '仓单到期日期';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.tradename is '货物名称';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.province is '所在/注册省份';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.city is '所在/注册市';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.unit is '货物计量单位';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.otherremark is '其他计量单位说明';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.amount is '货物账面数量';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.perprice is '货物账面单价';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.totalprice is '非标仓单价值';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_fwarereceipt.etl_timestamp is 'ETL处理时间戳';
