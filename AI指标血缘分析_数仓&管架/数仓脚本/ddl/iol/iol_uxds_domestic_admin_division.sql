/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_domestic_admin_division
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_domestic_admin_division
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_domestic_admin_division purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_domestic_admin_division(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,provincial_name varchar2(60) -- 省级行政区划名
    ,municipal_admin_division_name varchar2(90) -- 市级行政区划名
    ,name_of_county_admin_division varchar2(120) -- 县级行政区划名
    ,encode varchar2(36) -- 编码
    ,is_latest number(1,0) -- 是否最新
    ,code_respond_district_type varchar2(54) -- 编码对应地区类型
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_domestic_admin_division to ${iml_schema};
grant select on ${iol_schema}.uxds_domestic_admin_division to ${icl_schema};
grant select on ${iol_schema}.uxds_domestic_admin_division to ${idl_schema};
grant select on ${iol_schema}.uxds_domestic_admin_division to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_domestic_admin_division is '全国县以上行政区划编码表';
comment on column ${iol_schema}.uxds_domestic_admin_division.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_domestic_admin_division.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_domestic_admin_division.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_domestic_admin_division.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_domestic_admin_division.provincial_name is '省级行政区划名';
comment on column ${iol_schema}.uxds_domestic_admin_division.municipal_admin_division_name is '市级行政区划名';
comment on column ${iol_schema}.uxds_domestic_admin_division.name_of_county_admin_division is '县级行政区划名';
comment on column ${iol_schema}.uxds_domestic_admin_division.encode is '编码';
comment on column ${iol_schema}.uxds_domestic_admin_division.is_latest is '是否最新';
comment on column ${iol_schema}.uxds_domestic_admin_division.code_respond_district_type is '编码对应地区类型';
comment on column ${iol_schema}.uxds_domestic_admin_division.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_domestic_admin_division.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_domestic_admin_division.etl_timestamp is 'ETL处理时间戳';
