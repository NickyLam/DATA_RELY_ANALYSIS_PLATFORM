/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_zgxtmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_zgxtmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_zgxtmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_zgxtmx(
    tjrq number(38,0) -- 统计日期
    ,jxdxdh number(38,0) -- 绩效对象代号
    ,khdxdh number(38,0) -- 考核对象代号
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,bz varchar2(9) -- 币种
    ,fpjs varchar2(6) -- 分配角色
    ,zhye number(25,4) -- 账户余额
    ,zlbl number(19,5) -- 增量比例
    ,hyye number(25,4) -- 行员余额
    ,hyylj number(25,4) -- 行员月累计
    ,hyjlj number(25,4) -- 行员季累计
    ,hynlj number(25,4) -- 行员年累计
    ,khh varchar2(180) -- 客户号
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
grant select on ${iol_schema}.pams_nbzz_zgxtmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_zgxtmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_zgxtmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_zgxtmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_zgxtmx is '资管信托明细账';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_zgxtmx.etl_timestamp is 'ETL处理时间戳';
