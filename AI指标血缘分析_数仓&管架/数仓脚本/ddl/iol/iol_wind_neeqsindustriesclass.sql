/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_neeqsindustriesclass
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_neeqsindustriesclass
whenever sqlerror continue none;
drop table ${iol_schema}.wind_neeqsindustriesclass purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsindustriesclass(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司ID
    ,wind_ind_code varchar2(75) -- Wind行业代码
    ,entry_dt varchar2(12) -- 纳入日期
    ,remove_dt varchar2(12) -- 剔除日期
    ,cur_sign number(1,0) -- 最新标志
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
grant select on ${iol_schema}.wind_neeqsindustriesclass to ${iml_schema};
grant select on ${iol_schema}.wind_neeqsindustriesclass to ${icl_schema};
grant select on ${iol_schema}.wind_neeqsindustriesclass to ${idl_schema};
grant select on ${iol_schema}.wind_neeqsindustriesclass to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_neeqsindustriesclass is '股转系统股票Wind行业分类';
comment on column ${iol_schema}.wind_neeqsindustriesclass.object_id is '对象ID';
comment on column ${iol_schema}.wind_neeqsindustriesclass.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_neeqsindustriesclass.wind_ind_code is 'Wind行业代码';
comment on column ${iol_schema}.wind_neeqsindustriesclass.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_neeqsindustriesclass.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_neeqsindustriesclass.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_neeqsindustriesclass.start_dt is '开始时间';
comment on column ${iol_schema}.wind_neeqsindustriesclass.end_dt is '结束时间';
comment on column ${iol_schema}.wind_neeqsindustriesclass.id_mark is '增删标志';
comment on column ${iol_schema}.wind_neeqsindustriesclass.etl_timestamp is 'ETL处理时间戳';
