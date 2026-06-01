/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_nbzhlx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_nbzhlx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_nbzhlx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_nbzhlx(
    tjrq number -- 统计日期
    ,jgdh varchar2(30) -- 机构代号
    ,bjkm varchar2(60) -- 本金科目
    ,lxkm varchar2(60) -- 利息科目
    ,bz varchar2(9) -- 币种
    ,sdlx number(24,6) -- 利息
    ,cph varchar2(180) -- 产品号
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
grant select on ${iol_schema}.pams_jxdx_nbzhlx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_nbzhlx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_nbzhlx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_nbzhlx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_nbzhlx is '绩效对象_内部账利息';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.bjkm is '本金科目';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.lxkm is '利息科目';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.sdlx is '利息';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_nbzhlx.etl_timestamp is 'ETL处理时间戳';
