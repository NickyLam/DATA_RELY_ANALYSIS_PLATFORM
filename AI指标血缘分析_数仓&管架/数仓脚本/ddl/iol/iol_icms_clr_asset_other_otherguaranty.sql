/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_asset_other_otherguaranty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_asset_other_otherguaranty
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_asset_other_otherguaranty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_other_otherguaranty(
    clrid varchar2(32) -- 押品编号
    ,guarname varchar2(100) -- 抵押物名称
    ,amount number(10,2) -- 抵押物数量
    ,unit varchar2(10) -- 计量单位
    ,guarunitprice number(24,6) -- 抵押物单价
    ,guaraddress varchar2(100) -- 抵押物存放地
    ,gaindate date -- 所有权取得日期
    ,valuesum number(24,6) -- 抵押物原价值
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
grant select on ${iol_schema}.icms_clr_asset_other_otherguaranty to ${iml_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherguaranty to ${icl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherguaranty to ${idl_schema};
grant select on ${iol_schema}.icms_clr_asset_other_otherguaranty to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_asset_other_otherguaranty is '其他类之其他抵押物信息表';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.guarname is '抵押物名称';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.amount is '抵押物数量';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.unit is '计量单位';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.guarunitprice is '抵押物单价';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.guaraddress is '抵押物存放地';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.gaindate is '所有权取得日期';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.valuesum is '抵押物原价值';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.tdcurrency is '币种';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.remark is '其他说明';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.guarantyregno is '抵押登记编号';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_asset_other_otherguaranty.etl_timestamp is 'ETL处理时间戳';
