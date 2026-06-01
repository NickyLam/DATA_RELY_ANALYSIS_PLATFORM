/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_neeqgradation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_neeqgradation
whenever sqlerror continue none;
drop table ${iol_schema}.wind_neeqgradation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqgradation(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,s_info_windcode varchar2(60) -- WIND代码
    ,wind_sec_code varchar2(75) -- 板块代码
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
grant select on ${iol_schema}.wind_neeqgradation to ${iml_schema};
grant select on ${iol_schema}.wind_neeqgradation to ${icl_schema};
grant select on ${iol_schema}.wind_neeqgradation to ${idl_schema};
grant select on ${iol_schema}.wind_neeqgradation to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_neeqgradation is '';
comment on column ${iol_schema}.wind_neeqgradation.object_id is '对象ID';
comment on column ${iol_schema}.wind_neeqgradation.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_neeqgradation.s_info_windcode is 'WIND代码';
comment on column ${iol_schema}.wind_neeqgradation.wind_sec_code is '板块代码';
comment on column ${iol_schema}.wind_neeqgradation.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_neeqgradation.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_neeqgradation.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_neeqgradation.opdate is '';
comment on column ${iol_schema}.wind_neeqgradation.opmode is '';
comment on column ${iol_schema}.wind_neeqgradation.start_dt is '开始时间';
comment on column ${iol_schema}.wind_neeqgradation.end_dt is '结束时间';
comment on column ${iol_schema}.wind_neeqgradation.id_mark is '增删标志';
comment on column ${iol_schema}.wind_neeqgradation.etl_timestamp is 'ETL处理时间戳';
