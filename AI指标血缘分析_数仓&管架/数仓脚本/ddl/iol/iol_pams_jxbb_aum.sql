/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_aum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_aum
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_aum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_aum(
    jxdxdh number(22,0) -- 
    ,tjrq number(22,0) -- 
    ,khh varchar2(90) -- 
    ,khzt varchar2(3) -- 客户状态
    ,xhrq number(22,0) -- 
    ,aumye number(25,4) -- 
    ,aumyrjye number(25,4) -- 
    ,aumjrjye number(25,4) -- 
    ,aumnrjye number(25,4) -- 
    ,lsaumyrjqj varchar2(45) -- 
    ,fhaumyrjqj varchar2(45) -- 
    ,xtjhye number(25,4) -- 
    ,xtjhyrj number(25,4) -- 
    ,xtjhnrj number(25,4) -- 
    ,xtjhjrj number(25,4) -- 
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
grant select on ${iol_schema}.pams_jxbb_aum to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_aum to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_aum to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_aum to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_aum is '临时中间表';
comment on column ${iol_schema}.pams_jxbb_aum.jxdxdh is '';
comment on column ${iol_schema}.pams_jxbb_aum.tjrq is '';
comment on column ${iol_schema}.pams_jxbb_aum.khh is '';
comment on column ${iol_schema}.pams_jxbb_aum.khzt is '客户状态';
comment on column ${iol_schema}.pams_jxbb_aum.xhrq is '';
comment on column ${iol_schema}.pams_jxbb_aum.aumye is '';
comment on column ${iol_schema}.pams_jxbb_aum.aumyrjye is '';
comment on column ${iol_schema}.pams_jxbb_aum.aumjrjye is '';
comment on column ${iol_schema}.pams_jxbb_aum.aumnrjye is '';
comment on column ${iol_schema}.pams_jxbb_aum.lsaumyrjqj is '';
comment on column ${iol_schema}.pams_jxbb_aum.fhaumyrjqj is '';
comment on column ${iol_schema}.pams_jxbb_aum.xtjhye is '';
comment on column ${iol_schema}.pams_jxbb_aum.xtjhyrj is '';
comment on column ${iol_schema}.pams_jxbb_aum.xtjhnrj is '';
comment on column ${iol_schema}.pams_jxbb_aum.xtjhjrj is '';
comment on column ${iol_schema}.pams_jxbb_aum.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_aum.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_aum.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_aum.etl_timestamp is 'ETL处理时间戳';
