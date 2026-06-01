/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_assettype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_assettype
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_assettype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_assettype(
    assettype_id number -- 资产类型ID
    ,aspclient_id number -- 部门号
    ,assettype_shortname varchar2(30) -- 资产类型简称
    ,assettype_name varchar2(75) -- 资产类型全称
    ,lastmodified timestamp -- 最后修改时间
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
grant select on ${iol_schema}.ctms_tbs_vs_assettype to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_assettype to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_assettype to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_assettype to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_assettype is '资产类型定义表';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.assettype_id is '资产类型ID';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.aspclient_id is '部门号';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.assettype_shortname is '资产类型简称';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.assettype_name is '资产类型全称';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_assettype.etl_timestamp is 'ETL处理时间戳';
