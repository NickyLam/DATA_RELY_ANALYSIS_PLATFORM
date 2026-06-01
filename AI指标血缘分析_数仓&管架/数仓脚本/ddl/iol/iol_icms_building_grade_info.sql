/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_building_grade_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_building_grade_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_building_grade_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_building_grade_info(
    serialno varchar2(20) -- 流水号
    ,bldgencd varchar2(32) -- 楼盘编码
    ,rowcount varchar2(10) -- 条数
    ,message varchar2(1000) -- 说明
    ,data varchar2(4000) -- 数据域
    ,remark varchar2(100) -- 备注
    ,attribute1 varchar2(50) -- 属性1
    ,attribute2 varchar2(50) -- 属性2
    ,attribute3 varchar2(50) -- 属性3
    ,regioncd varchar2(32) -- 行政区划代码
    ,prptycomplloc varchar2(200) -- 物业完整地址
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
grant select on ${iol_schema}.icms_building_grade_info to ${iml_schema};
grant select on ${iol_schema}.icms_building_grade_info to ${icl_schema};
grant select on ${iol_schema}.icms_building_grade_info to ${idl_schema};
grant select on ${iol_schema}.icms_building_grade_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_building_grade_info is '世联楼盘评级表';
comment on column ${iol_schema}.icms_building_grade_info.serialno is '流水号';
comment on column ${iol_schema}.icms_building_grade_info.bldgencd is '楼盘编码';
comment on column ${iol_schema}.icms_building_grade_info.rowcount is '条数';
comment on column ${iol_schema}.icms_building_grade_info.message is '说明';
comment on column ${iol_schema}.icms_building_grade_info.data is '数据域';
comment on column ${iol_schema}.icms_building_grade_info.remark is '备注';
comment on column ${iol_schema}.icms_building_grade_info.attribute1 is '属性1';
comment on column ${iol_schema}.icms_building_grade_info.attribute2 is '属性2';
comment on column ${iol_schema}.icms_building_grade_info.attribute3 is '属性3';
comment on column ${iol_schema}.icms_building_grade_info.regioncd is '行政区划代码';
comment on column ${iol_schema}.icms_building_grade_info.prptycomplloc is '物业完整地址';
comment on column ${iol_schema}.icms_building_grade_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_building_grade_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_building_grade_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_building_grade_info.etl_timestamp is 'ETL处理时间戳';
