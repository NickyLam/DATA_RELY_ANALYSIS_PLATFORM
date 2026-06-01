/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_otherpledge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_otherpledge
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_otherpledge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_otherpledge(
    clrid varchar2(32) -- 押品编号
    ,guarname varchar2(200) -- 质押物名称
    ,amount number(38,0) -- 质押物数量
    ,unit varchar2(2) -- 计量单位
    ,gaindate date -- 所有权取得日期
    ,valuesum number(24,6) -- 质押物原价值
    ,tdcurrency varchar2(3) -- 币种
    ,remark varchar2(4000) -- 其他说明
    ,guarantyregno varchar2(96) -- 抵押登记编号
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
grant select on ${iol_schema}.icms_clr_asset_other_otherpledge to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherpledge to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherpledge to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherpledge to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_otherpledge is '其他类之其他质押物信息表';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.guarname is '质押物名称';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.amount is '质押物数量';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.unit is '计量单位';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.gaindate is '所有权取得日期';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.valuesum is '质押物原价值';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.guarantyregno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_otherpledge.etl_timestamp is 'ETL处理时间戳';
