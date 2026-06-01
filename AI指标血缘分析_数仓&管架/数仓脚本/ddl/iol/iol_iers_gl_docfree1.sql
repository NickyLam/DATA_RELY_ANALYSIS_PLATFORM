/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_docfree1
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_docfree1
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_docfree1 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_docfree1(
    assid varchar2(30) -- 
    ,dr number(10,0) -- 
    ,f1 varchar2(30) -- 
    ,f10 varchar2(30) -- 
    ,f11 varchar2(30) -- 
    ,f12 varchar2(30) -- 
    ,f13 varchar2(30) -- 
    ,f14 varchar2(30) -- 
    ,f15 varchar2(30) -- 
    ,f16 varchar2(30) -- 
    ,f17 varchar2(30) -- 
    ,f18 varchar2(30) -- 
    ,f19 varchar2(30) -- 
    ,f2 varchar2(30) -- 
    ,f20 varchar2(3000) -- 
    ,f21 varchar2(30) -- 
    ,f22 varchar2(30) -- 
    ,f23 varchar2(30) -- 
    ,f24 varchar2(30) -- 
    ,f25 varchar2(30) -- 
    ,f26 varchar2(30) -- 
    ,f27 varchar2(30) -- 
    ,f28 varchar2(30) -- 
    ,f29 varchar2(30) -- 
    ,f3 varchar2(30) -- 
    ,f30 varchar2(30) -- 
    ,f4 varchar2(30) -- 
    ,f5 varchar2(30) -- 
    ,f6 varchar2(30) -- 
    ,f7 varchar2(30) -- 
    ,f8 varchar2(30) -- 
    ,f9 varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,ts varchar2(29) -- 
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
grant select on ${iol_schema}.iers_gl_docfree1 to ${iml_schema};
grant select on ${iol_schema}.iers_gl_docfree1 to ${icl_schema};
grant select on ${iol_schema}.iers_gl_docfree1 to ${idl_schema};
grant select on ${iol_schema}.iers_gl_docfree1 to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_docfree1 is '';
comment on column ${iol_schema}.iers_gl_docfree1.assid is '';
comment on column ${iol_schema}.iers_gl_docfree1.dr is '';
comment on column ${iol_schema}.iers_gl_docfree1.f1 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f10 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f11 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f12 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f13 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f14 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f15 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f16 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f17 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f18 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f19 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f2 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f20 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f21 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f22 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f23 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f24 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f25 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f26 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f27 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f28 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f29 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f3 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f30 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f4 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f5 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f6 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f7 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f8 is '';
comment on column ${iol_schema}.iers_gl_docfree1.f9 is '';
comment on column ${iol_schema}.iers_gl_docfree1.pk_group is '';
comment on column ${iol_schema}.iers_gl_docfree1.ts is '';
comment on column ${iol_schema}.iers_gl_docfree1.start_dt is '开始时间';
comment on column ${iol_schema}.iers_gl_docfree1.end_dt is '结束时间';
comment on column ${iol_schema}.iers_gl_docfree1.id_mark is '增删标志';
comment on column ${iol_schema}.iers_gl_docfree1.etl_timestamp is 'ETL处理时间戳';
