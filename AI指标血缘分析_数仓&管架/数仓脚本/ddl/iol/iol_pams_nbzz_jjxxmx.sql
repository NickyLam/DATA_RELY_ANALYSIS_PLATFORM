/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_jjxxmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_jjxxmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_jjxxmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_jjxxmx(
    tjrq number(38,0) -- 统计日期
    ,jxdxdh number(38,0) -- 绩效对象代号
    ,khdxdh number(38,0) -- 考核对象代号
    ,jgkhdxdh number(38,0) -- 机构考核对象代号
    ,fpjs varchar2(6) -- 分配角色
    ,khh varchar2(180) -- 客户号
    ,cpdm varchar2(300) -- 产品代码
    ,cpsx varchar2(30) -- 产品属性
    ,jgdh varchar2(180) -- 机构代号
    ,zhbs varchar2(6) -- 账户标识
    ,bz varchar2(12) -- 币种
    ,zlbl number(30,4) -- 增量比例
    ,zhye number(30,10) -- 账户余额
    ,hyye number(30,10) -- 行员余额
    ,hyylj number(30,10) -- 行员月累计
    ,hyjlj number(30,10) -- 行员季累计
    ,hynlj number(30,10) -- 行员年累计
    ,fe number(30,4) -- 份额
    ,hyfe number(30,4) -- 行员份额
    ,hyfeylj number(30,4) -- 行员份额月累计
    ,hyfejlj number(30,4) -- 行员份额季累计
    ,hyfenlj number(30,4) -- 行员份额年累计
    ,ymjjbz varchar2(3) -- 盈米基金标志：0-否，1-是
    ,ztbz varchar2(3) -- 在途基金标识
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
grant select on ${iol_schema}.pams_nbzz_jjxxmx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_jjxxmx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_jjxxmx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_jjxxmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_jjxxmx is '内部总账_基金信息明细_回流';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.cpdm is '产品代码';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.cpsx is '产品属性';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.zhye is '账户余额';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyye is '行员余额';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyylj is '行员月累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyjlj is '行员季累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hynlj is '行员年累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.fe is '份额';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyfe is '行员份额';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyfeylj is '行员份额月累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyfejlj is '行员份额季累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.hyfenlj is '行员份额年累计';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.ymjjbz is '盈米基金标志：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.ztbz is '在途基金标识';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_jjxxmx.etl_timestamp is 'ETL处理时间戳';
