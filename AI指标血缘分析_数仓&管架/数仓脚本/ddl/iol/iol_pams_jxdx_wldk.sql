/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_wldk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_wldk
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_wldk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_wldk(
    jxdxdh number(22,0) -- 
    ,wdbh varchar2(90) -- 
    ,bz varchar2(45) -- 
    ,jgdh varchar2(90) -- 
    ,kmh varchar2(90) -- 
    ,khrq number(22,0) -- 
    ,dqrq number(22,0) -- 
    ,zhye number(30,2) -- 
    ,khje number(30,2) -- 
    ,ywpz varchar2(90) -- 
    ,cpbh varchar2(90) -- 
    ,jxfs varchar2(45) -- 
    ,hkfs varchar2(45) -- 
    ,qxrq number(22,0) -- 
    ,txhydm varchar2(150) -- 
    ,txdm varchar2(45) -- 
    ,llfddm varchar2(45) -- 
    ,jxbz varchar2(15) -- 
    ,jqbz varchar2(15) -- 
    ,hxbz varchar2(15) -- 
    ,nll number(38,8) -- 
    ,jzll number(38,8) -- 
    ,yqzxll number(38,8) -- 
    ,ysyjlx number(30,2) -- 
    ,dyhkbj number(30,2) -- 
    ,dqhklx number(30,2) -- 
    ,yqbj number(30,2) -- 
    ,ljyswslxje number(30,2) -- 
    ,yqlx number(30,2) -- 
    ,hxbj number(30,2) -- 
    ,hxlx number(30,2) -- 
    ,xczhje number(30,2) -- 
    ,xczflx number(30,2) -- 
    ,tjrq number(22,0) -- 统计日期
    ,khdxdh number(22,0) -- 考核对象代号
    ,gxhslx varchar2(3) -- 关系函数类型
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
grant select on ${iol_schema}.pams_jxdx_wldk to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_wldk to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_wldk to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_wldk to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_wldk is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jxdxdh is '';
comment on column ${iol_schema}.pams_jxdx_wldk.wdbh is '';
comment on column ${iol_schema}.pams_jxdx_wldk.bz is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jgdh is '';
comment on column ${iol_schema}.pams_jxdx_wldk.kmh is '';
comment on column ${iol_schema}.pams_jxdx_wldk.khrq is '';
comment on column ${iol_schema}.pams_jxdx_wldk.dqrq is '';
comment on column ${iol_schema}.pams_jxdx_wldk.zhye is '';
comment on column ${iol_schema}.pams_jxdx_wldk.khje is '';
comment on column ${iol_schema}.pams_jxdx_wldk.ywpz is '';
comment on column ${iol_schema}.pams_jxdx_wldk.cpbh is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jxfs is '';
comment on column ${iol_schema}.pams_jxdx_wldk.hkfs is '';
comment on column ${iol_schema}.pams_jxdx_wldk.qxrq is '';
comment on column ${iol_schema}.pams_jxdx_wldk.txhydm is '';
comment on column ${iol_schema}.pams_jxdx_wldk.txdm is '';
comment on column ${iol_schema}.pams_jxdx_wldk.llfddm is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jxbz is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jqbz is '';
comment on column ${iol_schema}.pams_jxdx_wldk.hxbz is '';
comment on column ${iol_schema}.pams_jxdx_wldk.nll is '';
comment on column ${iol_schema}.pams_jxdx_wldk.jzll is '';
comment on column ${iol_schema}.pams_jxdx_wldk.yqzxll is '';
comment on column ${iol_schema}.pams_jxdx_wldk.ysyjlx is '';
comment on column ${iol_schema}.pams_jxdx_wldk.dyhkbj is '';
comment on column ${iol_schema}.pams_jxdx_wldk.dqhklx is '';
comment on column ${iol_schema}.pams_jxdx_wldk.yqbj is '';
comment on column ${iol_schema}.pams_jxdx_wldk.ljyswslxje is '';
comment on column ${iol_schema}.pams_jxdx_wldk.yqlx is '';
comment on column ${iol_schema}.pams_jxdx_wldk.hxbj is '';
comment on column ${iol_schema}.pams_jxdx_wldk.hxlx is '';
comment on column ${iol_schema}.pams_jxdx_wldk.xczhje is '';
comment on column ${iol_schema}.pams_jxdx_wldk.xczflx is '';
comment on column ${iol_schema}.pams_jxdx_wldk.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_wldk.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_wldk.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_wldk.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_wldk.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_wldk.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_wldk.etl_timestamp is 'ETL处理时间戳';
