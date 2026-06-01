/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_cp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_cp
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_cp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_cp(
    cph varchar2(180) -- 产品号
    ,cpmc varchar2(1500) -- 产品名称
    ,cpyjfl varchar2(300) -- 产品一级分类
    ,cpejfl varchar2(300) -- 产品二级分类
    ,cpsjfl varchar2(300) -- 产品四级分类
    ,cpsijfl varchar2(300) -- 产品四级分类
    ,cpzt varchar2(30) -- 产品状态
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
grant select on ${iol_schema}.pams_csb_cp to ${iml_schema};
grant select on ${iol_schema}.pams_csb_cp to ${icl_schema};
grant select on ${iol_schema}.pams_csb_cp to ${idl_schema};
grant select on ${iol_schema}.pams_csb_cp to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_cp is '参数表_产品';
comment on column ${iol_schema}.pams_csb_cp.cph is '产品号';
comment on column ${iol_schema}.pams_csb_cp.cpmc is '产品名称';
comment on column ${iol_schema}.pams_csb_cp.cpyjfl is '产品一级分类';
comment on column ${iol_schema}.pams_csb_cp.cpejfl is '产品二级分类';
comment on column ${iol_schema}.pams_csb_cp.cpsjfl is '产品四级分类';
comment on column ${iol_schema}.pams_csb_cp.cpsijfl is '产品四级分类';
comment on column ${iol_schema}.pams_csb_cp.cpzt is '产品状态';
comment on column ${iol_schema}.pams_csb_cp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_csb_cp.etl_timestamp is 'ETL处理时间戳';
