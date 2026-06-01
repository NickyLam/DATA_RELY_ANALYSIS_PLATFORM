/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_lsb_khqycpxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_lsb_khqycpxx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_lsb_khqycpxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_lsb_khqycpxx(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgkhdxdh number(22) -- 客户开户机构考核对象代号
    ,kh varchar2(250) -- 卡号
    ,zhdh varchar2(120) -- 存款账户代号
    ,zzh varchar2(120) -- 存款子户号
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(600) -- 客户名称
    ,jgdh varchar2(30) -- 客户开户机构代号
    ,khlx varchar2(30) -- 客户类型：1-对公,1-对私
    ,cplx varchar2(30) -- 签约产品类型
    ,cplxmc varchar2(300) -- 签约产品类型名称
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
grant select on ${iol_schema}.pams_lsb_khqycpxx to ${iml_schema};
grant select on ${iol_schema}.pams_lsb_khqycpxx to ${icl_schema};
grant select on ${iol_schema}.pams_lsb_khqycpxx to ${idl_schema};
grant select on ${iol_schema}.pams_lsb_khqycpxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_lsb_khqycpxx is '临时表-客户签约产品信息';
comment on column ${iol_schema}.pams_lsb_khqycpxx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_lsb_khqycpxx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.jgkhdxdh is '客户开户机构考核对象代号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.kh is '卡号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.zhdh is '存款账户代号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.zzh is '存款子户号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.khh is '客户号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.khmc is '客户名称';
comment on column ${iol_schema}.pams_lsb_khqycpxx.jgdh is '客户开户机构代号';
comment on column ${iol_schema}.pams_lsb_khqycpxx.khlx is '客户类型：1-对公,1-对私';
comment on column ${iol_schema}.pams_lsb_khqycpxx.cplx is '签约产品类型';
comment on column ${iol_schema}.pams_lsb_khqycpxx.cplxmc is '签约产品类型名称';
comment on column ${iol_schema}.pams_lsb_khqycpxx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_lsb_khqycpxx.etl_timestamp is 'ETL处理时间戳';
