/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_chgfinyearenddt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_chgfinyearenddt
whenever sqlerror continue none;
drop table ${iol_schema}.wind_chgfinyearenddt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_chgfinyearenddt(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(15) -- 品种ID
    ,id_typecode number(9,0) -- 品种类别代码
    ,chg_typecode number(9,0) -- 条款属性类型代码
    ,start_dt_ora varchar2(12) -- 起始日期
    ,end_dt_ora varchar2(12) -- 终止日期
    ,finyearenddt varchar2(4000) -- 条款
    ,cur_sign number(1,0) -- 是否最新
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
grant select on ${iol_schema}.wind_chgfinyearenddt to ${iml_schema};
grant select on ${iol_schema}.wind_chgfinyearenddt to ${icl_schema};
grant select on ${iol_schema}.wind_chgfinyearenddt to ${idl_schema};
grant select on ${iol_schema}.wind_chgfinyearenddt to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_chgfinyearenddt is '财报年结日变更';
comment on column ${iol_schema}.wind_chgfinyearenddt.object_id is '对象ID';
comment on column ${iol_schema}.wind_chgfinyearenddt.s_info_compcode is '品种ID';
comment on column ${iol_schema}.wind_chgfinyearenddt.id_typecode is '品种类别代码';
comment on column ${iol_schema}.wind_chgfinyearenddt.chg_typecode is '条款属性类型代码';
comment on column ${iol_schema}.wind_chgfinyearenddt.start_dt_ora is '起始日期';
comment on column ${iol_schema}.wind_chgfinyearenddt.end_dt_ora is '终止日期';
comment on column ${iol_schema}.wind_chgfinyearenddt.finyearenddt is '条款';
comment on column ${iol_schema}.wind_chgfinyearenddt.cur_sign is '是否最新';
comment on column ${iol_schema}.wind_chgfinyearenddt.start_dt is '开始时间';
comment on column ${iol_schema}.wind_chgfinyearenddt.end_dt is '结束时间';
comment on column ${iol_schema}.wind_chgfinyearenddt.id_mark is '增删标志';
comment on column ${iol_schema}.wind_chgfinyearenddt.etl_timestamp is 'ETL处理时间戳';
