/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fip_docview_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fip_docview_b
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fip_docview_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_docview_b(
    desdocvalue varchar2(152) -- 目标档案值
    ,dr number(10,0) -- 删除标志
    ,factorvalue1 varchar2(152) -- 来源档案值1
    ,factorvalue2 varchar2(152) -- 来源档案值2
    ,factorvalue3 varchar2(152) -- 来源档案值3
    ,factorvalue4 varchar2(152) -- 来源档案值4
    ,factorvalue5 varchar2(152) -- 来源档案值5
    ,factorvalue6 varchar2(152) -- 来源档案值6
    ,factorvalue7 varchar2(152) -- 来源档案值7
    ,factorvalue8 varchar2(152) -- 来源档案值8
    ,factorvalue9 varchar2(152) -- 来源档案值9
    ,indexnumber number(38,0) -- 序号
    ,pk_classview varchar2(30) -- 对照表_主键
    ,pk_classview_b varchar2(30) -- 对象标识
    ,pk_org varchar2(30) -- 来源组织
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.iers_fip_docview_b to ${iml_schema};
grant select on ${iol_schema}.iers_fip_docview_b to ${icl_schema};
grant select on ${iol_schema}.iers_fip_docview_b to ${idl_schema};
grant select on ${iol_schema}.iers_fip_docview_b to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fip_docview_b is '对照表内容';
comment on column ${iol_schema}.iers_fip_docview_b.desdocvalue is '目标档案值';
comment on column ${iol_schema}.iers_fip_docview_b.dr is '删除标志';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue1 is '来源档案值1';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue2 is '来源档案值2';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue3 is '来源档案值3';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue4 is '来源档案值4';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue5 is '来源档案值5';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue6 is '来源档案值6';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue7 is '来源档案值7';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue8 is '来源档案值8';
comment on column ${iol_schema}.iers_fip_docview_b.factorvalue9 is '来源档案值9';
comment on column ${iol_schema}.iers_fip_docview_b.indexnumber is '序号';
comment on column ${iol_schema}.iers_fip_docview_b.pk_classview is '对照表_主键';
comment on column ${iol_schema}.iers_fip_docview_b.pk_classview_b is '对象标识';
comment on column ${iol_schema}.iers_fip_docview_b.pk_org is '来源组织';
comment on column ${iol_schema}.iers_fip_docview_b.ts is '时间戳';
comment on column ${iol_schema}.iers_fip_docview_b.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fip_docview_b.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fip_docview_b.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fip_docview_b.etl_timestamp is 'ETL处理时间戳';
