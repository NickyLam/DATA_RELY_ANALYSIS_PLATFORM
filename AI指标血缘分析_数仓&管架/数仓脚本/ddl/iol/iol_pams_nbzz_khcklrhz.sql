/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_khcklrhz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_khcklrhz
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_khcklrhz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_khcklrhz(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khh varchar2(45) -- 客户号
    ,kmh varchar2(30) -- 科目号
    ,dzybz varchar2(2) -- 抵质押标志：1-是
    ,whzhbz varchar2(2) -- 外汇账户标志：0-否，1-是
    ,bz varchar2(5) -- 币种
    ,ye number(25,4) -- 余额
    ,ylj number(25,4) -- 月累计
    ,jlj number(25,4) -- 季累计
    ,nlj number(25,4) -- 年累计
    ,drsy number(25,4) -- 日收益
    ,dysy number(25,4) -- 月收益
    ,djsy number(25,4) -- 季收益
    ,dnsy number(25,4) -- 年收益
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
grant select on ${iol_schema}.pams_nbzz_khcklrhz to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_khcklrhz to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_khcklrhz to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_khcklrhz to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_khcklrhz is '客户存款利润明细账汇总';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.kmh is '科目号';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.dzybz is '抵质押标志：1-是';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.whzhbz is '外汇账户标志：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.ye is '余额';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.ylj is '月累计';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.jlj is '季累计';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.nlj is '年累计';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.drsy is '日收益';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.dysy is '月收益';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.djsy is '季收益';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.dnsy is '年收益';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_khcklrhz.etl_timestamp is 'ETL处理时间戳';
