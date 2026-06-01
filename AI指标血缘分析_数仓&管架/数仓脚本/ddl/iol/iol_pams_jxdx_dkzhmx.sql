/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dkzhmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dkzhmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dkzhmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dkzhmx(
    jxdxdh number(38,0) -- 绩效对象代号
    ,qsrq number(38,0) -- 起始日期
    ,jsrq number(38,0) -- 结束日期
    ,zhye number(25,4) -- 账户余额
    ,njs number(25,4) -- 年积数
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
grant select on ${iol_schema}.pams_jxdx_dkzhmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dkzhmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dkzhmx is '绩效对象-贷款账户明细';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.qsrq is '起始日期';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.jsrq is '结束日期';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.njs is '年积数';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_dkzhmx.etl_timestamp is 'ETL处理时间戳';
