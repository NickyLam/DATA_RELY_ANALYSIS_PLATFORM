/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hkstockhsindustriesmembers
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hkstockhsindustriesmembers
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hkstockhsindustriesmembers purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkstockhsindustriesmembers(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,hs_ind_code varchar2(75) -- 恒生行业代码
    ,entry_dt varchar2(12) -- 纳入日期
    ,remove_dt varchar2(12) -- 剔除日期
    ,cur_sign number(1,0) -- 最新标志
    ,opdate date -- 
    ,opmode varchar2(2) -- 
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
grant select on ${iol_schema}.wind_hkstockhsindustriesmembers to ${iml_schema};
grant select on ${iol_schema}.wind_hkstockhsindustriesmembers to ${icl_schema};
grant select on ${iol_schema}.wind_hkstockhsindustriesmembers to ${idl_schema};
grant select on ${iol_schema}.wind_hkstockhsindustriesmembers to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hkstockhsindustriesmembers is '';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.object_id is '对象ID';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.hs_ind_code is '恒生行业代码';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.opdate is '';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.opmode is '';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hkstockhsindustriesmembers.etl_timestamp is 'ETL处理时间戳';
