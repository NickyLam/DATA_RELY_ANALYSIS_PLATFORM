/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,areaname varchar2(4000) -- 行政区
    ,provincename varchar2(4000) -- 省份
    ,constructionid varchar2(4000) -- 楼盘编码
    ,slgetconstrutionviewinfobyid varchar2(4000) -- 关联标签
    ,doorplate varchar2(4000) -- 显示地址
    ,developers varchar2(4000) -- 开发商
    ,regionname varchar2(4000) -- 片区
    ,constructionname varchar2(4000) -- 楼盘名称
    ,arealine varchar2(4000) -- 环线
    ,areaid varchar2(4000) -- 行政区ID
    ,enddate varchar2(4000) -- 建成年代
    ,salename varchar2(4000) -- 楼盘自定义名称
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
grant select on ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid to ${iml_schema};
grant select on ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid to ${icl_schema};
grant select on ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid to ${idl_schema};
grant select on ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid is 'slGetConstrutionViewInfoById_slGetConstrutionViewInfoById';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.areaname is '行政区';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.provincename is '省份';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.constructionid is '楼盘编码';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.slgetconstrutionviewinfobyid is '关联标签';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.doorplate is '显示地址';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.developers is '开发商';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.regionname is '片区';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.constructionname is '楼盘名称';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.arealine is '环线';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.areaid is '行政区ID';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.enddate is '建成年代';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.salename is '楼盘自定义名称';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.genmonth is '';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_slgetconstrutionviewinfobyid_slgetconstrutionviewinfobyid.etl_timestamp is 'ETL处理时间戳';
