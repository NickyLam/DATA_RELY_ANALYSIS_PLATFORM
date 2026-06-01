/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckzytzsy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckzytzsy
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckzytzsy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckzytzsy(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,zyzqlx varchar2(3) -- 质押债券类型
    ,jgdh varchar2(15) -- 机构代号
    ,jgmc varchar2(150) -- 机构名称
    ,khh varchar2(45) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,zyzqje number(25,4) -- 质押债券金额
    ,tzsy number(25,4) -- 调整收益
    ,sdtzsy number(25,4) -- 时点调整收益
    ,tzsyylj number(25,4) -- 调整收益月累计
    ,tzsyjlj number(25,4) -- 调整收益季累计
    ,tzsynlj number(25,4) -- 调整收益年累计
    ,khjlgh varchar2(60) -- 客户经理工号
    ,hth varchar2(100) -- 合同号
    ,zyr number -- 质押日
    ,dqr number -- 到期日
    ,ldpz varchar2(2) -- 联动标志
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
grant select on ${iol_schema}.pams_jxbb_ckzytzsy to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckzytzsy is '绩效报表-存款质押调整收益';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.zyzqlx is '质押债券类型';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.zyzqje is '质押债券金额';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.tzsy is '调整收益';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.sdtzsy is '时点调整收益';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.hth is '合同号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.zyr is '质押日';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.ldpz is '联动标志';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy.etl_timestamp is 'ETL处理时间戳';
