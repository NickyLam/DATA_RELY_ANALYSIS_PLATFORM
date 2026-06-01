/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_dbm_guar_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_dbm_guar_relation
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_dbm_guar_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_dbm_guar_relation(
    poolsccode varchar2(32) -- 资产池押品编号
    ,cmdtysccode varchar2(32) -- 详情押品编号
    ,guartype varchar2(32) -- 押品类型
    ,keycolumn varchar2(60) -- 押品关键字一
    ,keycolumn1 varchar2(60) -- 押品关键字二
    ,poolcode varchar2(32) -- 融资编号
    ,flag varchar2(2) -- 处理成功标识:1.成功 0未处理
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_clr_dbm_guar_relation to ${iml_schema};
grant select on ${iol_schema}.icms_clr_dbm_guar_relation to ${icl_schema};
grant select on ${iol_schema}.icms_clr_dbm_guar_relation to ${idl_schema};
grant select on ${iol_schema}.icms_clr_dbm_guar_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_dbm_guar_relation is '资产池拆分关系';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.poolsccode is '资产池押品编号';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.cmdtysccode is '详情押品编号';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.guartype is '押品类型';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.keycolumn is '押品关键字一';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.keycolumn1 is '押品关键字二';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.poolcode is '融资编号';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.flag is '处理成功标识:1.成功 0未处理';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_clr_dbm_guar_relation.etl_timestamp is 'ETL处理时间戳';
