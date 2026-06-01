/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_km
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_km
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_km purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_km(
    kmh varchar2(30) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,kmjb varchar2(2) -- 科目级别
    ,sjkm varchar2(15) -- 上级科目
    ,bnwbz varchar2(2) -- 表内外标志
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
grant select on ${iol_schema}.pams_csb_km to ${iml_schema};
grant select on ${iol_schema}.pams_csb_km to ${icl_schema};
grant select on ${iol_schema}.pams_csb_km to ${idl_schema};
grant select on ${iol_schema}.pams_csb_km to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_km is '参数表-科目';
comment on column ${iol_schema}.pams_csb_km.kmh is '科目号';
comment on column ${iol_schema}.pams_csb_km.kmmc is '科目名称';
comment on column ${iol_schema}.pams_csb_km.kmjb is '科目级别';
comment on column ${iol_schema}.pams_csb_km.sjkm is '上级科目';
comment on column ${iol_schema}.pams_csb_km.bnwbz is '表内外标志';
comment on column ${iol_schema}.pams_csb_km.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_km.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_km.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_km.etl_timestamp is 'ETL处理时间戳';
