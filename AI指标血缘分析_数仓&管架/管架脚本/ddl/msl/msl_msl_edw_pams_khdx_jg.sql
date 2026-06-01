/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pams_khdx_jg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pams_khdx_jg
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pams_khdx_jg purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pams_khdx_jg(
    etl_dt date
    ,khdxdh number(22)
    ,jgdh varchar2(15)
    ,jgmc varchar2(150)
    ,jyjgbz varchar2(2)
    ,pxbz number(22)
    ,zxzt varchar2(2)
    ,zxrq number(22)
    ,fhdh varchar2(15)
    ,fhbz varchar2(3)
    ,jgdj varchar2(3)
    ,jgqc varchar2(150)
    ,start_dt date
    ,end_dt date
    ,id_mark varchar2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pams_khdx_jg to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pams_khdx_jg is '考核对象-机构';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.khdxdh is '考核对象代号';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.jgdh is '机构代号';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.jgmc is '机构名称';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.jyjgbz is '经营机构标志';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.pxbz is '排序标志';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.zxzt is '注销状态';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.zxrq is '注销日期';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.fhdh is '分行代号';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.fhbz is '分行标志';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.jgdj is '机构登记';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.jgqc is '机构全称';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.start_dt is '开始时间';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.end_dt is '结束时间';
comment on column ${msl_schema}.msl_edw_pams_khdx_jg.id_mark is '增删标志';
