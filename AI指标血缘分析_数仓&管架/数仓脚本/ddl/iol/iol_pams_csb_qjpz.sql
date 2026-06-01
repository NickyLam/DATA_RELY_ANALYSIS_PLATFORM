/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_csb_qjpz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_csb_qjpz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_csb_qjpz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_csb_qjpz(
    qjmc varchar2(45) -- 区间名称
    ,qjsx number(25,4) -- 区间上限
    ,qsrq number(22,0) -- 起始日期
    ,jsrq number(22,0) -- 结束日期
    ,qjxx number(25,4) -- 区间下限
    ,qjz varchar2(45) -- 区间值
    ,sxxms varchar2(300) -- 上下限描述
    ,qjms varchar2(300) -- 区间描述
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
grant select on ${iol_schema}.pams_csb_qjpz to ${iml_schema};
grant select on ${iol_schema}.pams_csb_qjpz to ${icl_schema};
grant select on ${iol_schema}.pams_csb_qjpz to ${idl_schema};
grant select on ${iol_schema}.pams_csb_qjpz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_csb_qjpz is '参数表-区间配置';
comment on column ${iol_schema}.pams_csb_qjpz.qjmc is '区间名称';
comment on column ${iol_schema}.pams_csb_qjpz.qjsx is '区间上限';
comment on column ${iol_schema}.pams_csb_qjpz.qsrq is '起始日期';
comment on column ${iol_schema}.pams_csb_qjpz.jsrq is '结束日期';
comment on column ${iol_schema}.pams_csb_qjpz.qjxx is '区间下限';
comment on column ${iol_schema}.pams_csb_qjpz.qjz is '区间值';
comment on column ${iol_schema}.pams_csb_qjpz.sxxms is '上下限描述';
comment on column ${iol_schema}.pams_csb_qjpz.qjms is '区间描述';
comment on column ${iol_schema}.pams_csb_qjpz.start_dt is '开始时间';
comment on column ${iol_schema}.pams_csb_qjpz.end_dt is '结束时间';
comment on column ${iol_schema}.pams_csb_qjpz.id_mark is '增删标志';
comment on column ${iol_schema}.pams_csb_qjpz.etl_timestamp is 'ETL处理时间戳';
