/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_gl_freevalue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_gl_freevalue
whenever sqlerror continue none;
drop table ${iol_schema}.iers_gl_freevalue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_freevalue(
    dr number(10,0) -- 删除标志
    ,freevalueid varchar2(30) -- 辅助核算id
    ,pk_group varchar2(30) -- 集团
    ,ts varchar2(29) -- 时间戳
    ,typevalue1 varchar2(330) -- 自定义
    ,typevalue2 varchar2(330) -- 自定义
    ,typevalue3 varchar2(330) -- 自定义
    ,typevalue4 varchar2(330) -- 自定义
    ,typevalue5 varchar2(330) -- 自定义
    ,typevalue6 varchar2(330) -- 自定义
    ,typevalue7 varchar2(330) -- 自定义
    ,typevalue8 varchar2(330) -- 自定义
    ,typevalue9 varchar2(330) -- 自定义
    ,typevaluemd5 varchar2(48) -- 自定义
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
grant select on ${iol_schema}.iers_gl_freevalue to ${iml_schema};
grant select on ${iol_schema}.iers_gl_freevalue to ${icl_schema};
grant select on ${iol_schema}.iers_gl_freevalue to ${idl_schema};
grant select on ${iol_schema}.iers_gl_freevalue to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_gl_freevalue is '新费用辅助核算';
comment on column ${iol_schema}.iers_gl_freevalue.dr is '删除标志';
comment on column ${iol_schema}.iers_gl_freevalue.freevalueid is '辅助核算id';
comment on column ${iol_schema}.iers_gl_freevalue.pk_group is '集团';
comment on column ${iol_schema}.iers_gl_freevalue.ts is '时间戳';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue1 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue2 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue3 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue4 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue5 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue6 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue7 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue8 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevalue9 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.typevaluemd5 is '自定义';
comment on column ${iol_schema}.iers_gl_freevalue.start_dt is '开始时间';
comment on column ${iol_schema}.iers_gl_freevalue.end_dt is '结束时间';
comment on column ${iol_schema}.iers_gl_freevalue.id_mark is '增删标志';
comment on column ${iol_schema}.iers_gl_freevalue.etl_timestamp is 'ETL处理时间戳';
