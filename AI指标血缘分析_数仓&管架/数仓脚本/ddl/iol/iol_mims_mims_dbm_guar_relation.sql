/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_mims_dbm_guar_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_mims_dbm_guar_relation
whenever sqlerror continue none;
drop table ${iol_schema}.mims_mims_dbm_guar_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_mims_dbm_guar_relation(
    poolsccode varchar2(48) -- 资产池押品编号
    ,cmdtysccode varchar2(48) -- 详情押品编号
    ,guartype varchar2(30) -- 押品类型
    ,keycolumn varchar2(90) -- 押品关键字一
    ,keycolumn1 varchar2(90) -- 押品关键字二
    ,poolcode varchar2(48) -- 池编号
    ,flag varchar2(3) -- 处理成功标识:1.成功 0未处理
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
grant select on ${iol_schema}.mims_mims_dbm_guar_relation to ${iml_schema};
grant select on ${iol_schema}.mims_mims_dbm_guar_relation to ${icl_schema};
grant select on ${iol_schema}.mims_mims_dbm_guar_relation to ${idl_schema};
grant select on ${iol_schema}.mims_mims_dbm_guar_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_mims_dbm_guar_relation is '票据系统资产池拆分关系表';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.poolsccode is '资产池押品编号';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.cmdtysccode is '详情押品编号';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.guartype is '押品类型';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.keycolumn is '押品关键字一';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.keycolumn1 is '押品关键字二';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.poolcode is '池编号';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.flag is '处理成功标识:1.成功 0未处理';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.start_dt is '开始时间';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.end_dt is '结束时间';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.id_mark is '增删标志';
comment on column ${iol_schema}.mims_mims_dbm_guar_relation.etl_timestamp is 'ETL处理时间戳';
