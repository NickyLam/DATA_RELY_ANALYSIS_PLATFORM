/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_slgetgyconstruction_slgetgyconstruction
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,areaname varchar2(4000) -- 行政区
    ,constructionid varchar2(4000) -- 楼盘编码
    ,address varchar2(4000) -- 地址
    ,constructionname varchar2(4000) -- 名称
    ,areaid varchar2(4000) -- 行政区编号
    ,aliases varchar2(4000) -- 别名
    ,slgetgyconstruction varchar2(4000) -- 关联标签
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction to ${iml_schema};
grant select on ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction to ${icl_schema};
grant select on ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction to ${idl_schema};
grant select on ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction is 'slGetGyConstruction_slGetGyConstruction';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.areaname is '行政区';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.constructionid is '楼盘编码';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.address is '地址';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.constructionname is '名称';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.areaid is '行政区编号';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.aliases is '别名';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.slgetgyconstruction is '关联标签';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.genmonth is '';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_slgetgyconstruction_slgetgyconstruction.etl_timestamp is 'ETL处理时间戳';
