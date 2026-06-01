/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_jgzbxm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_jgzbxm
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_jgzbxm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_jgzbxm(
    jgdh varchar2(75) -- 机构代号
    ,pm number(22,0) -- 排名
    ,xm varchar2(75) -- 项目
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
grant select on ${iol_schema}.pams_csb_jgzbxm to ${iml_schema};
grant select on ${iol_schema}.pams_csb_jgzbxm to ${icl_schema};
grant select on ${iol_schema}.pams_csb_jgzbxm to ${idl_schema};
grant select on ${iol_schema}.pams_csb_jgzbxm to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_jgzbxm is '参数表_机构指标项目';
comment on column ${iol_schema}.pams_csb_jgzbxm.jgdh is '机构代号';
comment on column ${iol_schema}.pams_csb_jgzbxm.pm is '排名';
comment on column ${iol_schema}.pams_csb_jgzbxm.xm is '项目';
comment on column ${iol_schema}.pams_csb_jgzbxm.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_jgzbxm.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_jgzbxm.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_jgzbxm.etl_timestamp is 'ETL处理时间戳';
