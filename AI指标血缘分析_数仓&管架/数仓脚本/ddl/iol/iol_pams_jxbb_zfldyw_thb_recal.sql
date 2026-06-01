/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zfldyw_thb_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zfldyw_thb_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zfldyw_thb_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zfldyw_thb_recal(
    tjrq number(22) -- 统计日期
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,tzsy number(25,4) -- 调整收益余额
    ,tzsyylj number(25,4) -- 调整收益月累计
    ,tzsyjlj number(25,4) -- 调整收益季累计
    ,tzsynlj number(25,4) -- 调整收益年累计
    ,zhye number(25,4) -- 账户余额
    ,zhnrjye number(25,4) -- 账户年日均余额
    ,ldbm varchar2(60) -- 联动部门
    ,ldywpz varchar2(150) -- 联动业务品种
    ,zcbh varchar2(900) -- 资产编号
    ,zcmc varchar2(300) -- 资产名称
    ,recal_dt number(22) -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_zfldyw_thb_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zfldyw_thb_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldyw_thb_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zfldyw_thb_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zfldyw_thb_recal is '绩效报表_总分联动业务_投行部_重算';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.tzsy is '调整收益余额';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.tzsyylj is '调整收益月累计';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.tzsyjlj is '调整收益季累计';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.tzsynlj is '调整收益年累计';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.zhnrjye is '账户年日均余额';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.ldbm is '联动部门';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.ldywpz is '联动业务品种';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.zcbh is '资产编号';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.zcmc is '资产名称';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zfldyw_thb_recal.etl_timestamp is 'ETL处理时间戳';
