/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_ckzytzsy_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_ckzytzsy_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_ckzytzsy_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_ckzytzsy_recal(
    tjrq number(22) -- 统计日期
    ,hth varchar2(300) -- 合同号
    ,jxdxdh number(22) -- 绩效对象代号
    ,zyzqlx varchar2(6) -- 质押债券类型
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,zyr number(22) -- 质押日
    ,dqr number(22) -- 到期日
    ,zyzqje number(25,4) -- 质押债券金额
    ,tzsy number(25,4) -- 调整收益
    ,sdtzsy number(25,4) -- 时点调整收益
    ,ldpz varchar2(6) -- 联动标志
    ,tzsyylj number(25,4) -- 调整收益月累计
    ,tzsyjlj number(25,4) -- 调整收益季累计
    ,tzsynlj number(25,4) -- 调整收益年累计
    ,recal_dt number(22) -- 重算日期
    ,khjlgh varchar2(60) -- 客户经理工号
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
grant select on ${iol_schema}.pams_jxbb_ckzytzsy_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_ckzytzsy_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_ckzytzsy_recal is '绩效报表-存款质押调整收益_重算';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.hth is '合同号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.zyzqlx is '质押债券类型';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.zyr is '质押日';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.zyzqje is '质押债券金额';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.tzsy is '调整收益';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.sdtzsy is '时点调整收益';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.ldpz is '联动标志';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_ckzytzsy_recal.etl_timestamp is 'ETL处理时间戳';
