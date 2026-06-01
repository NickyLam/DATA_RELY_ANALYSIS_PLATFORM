/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_neeqsdescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_neeqsdescription
whenever sqlerror continue none;
drop table ${iol_schema}.wind_neeqsdescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_neeqsdescription(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_code varchar2(60) -- 交易代码
    ,s_info_name varchar2(150) -- 证券简称
    ,s_info_pinyin varchar2(60) -- 简称拼音
    ,s_info_exchmarket varchar2(60) -- 交易所代码
    ,s_info_listboard varchar2(15) -- 上市板代码
    ,s_info_listdate varchar2(12) -- 上市时间
    ,s_info_delistdate varchar2(12) -- 摘牌日期
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
grant select on ${iol_schema}.wind_neeqsdescription to ${iml_schema};
grant select on ${iol_schema}.wind_neeqsdescription to ${icl_schema};
grant select on ${iol_schema}.wind_neeqsdescription to ${idl_schema};
grant select on ${iol_schema}.wind_neeqsdescription to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_neeqsdescription is '股转系统股票基本资料';
comment on column ${iol_schema}.wind_neeqsdescription.object_id is '对象ID';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_code is '交易代码';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_name is '证券简称';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_pinyin is '简称拼音';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_exchmarket is '交易所代码';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_listboard is '上市板代码';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_listdate is '上市时间';
comment on column ${iol_schema}.wind_neeqsdescription.s_info_delistdate is '摘牌日期';
comment on column ${iol_schema}.wind_neeqsdescription.opdate is '';
comment on column ${iol_schema}.wind_neeqsdescription.opmode is '';
comment on column ${iol_schema}.wind_neeqsdescription.start_dt is '开始时间';
comment on column ${iol_schema}.wind_neeqsdescription.end_dt is '结束时间';
comment on column ${iol_schema}.wind_neeqsdescription.id_mark is '增删标志';
comment on column ${iol_schema}.wind_neeqsdescription.etl_timestamp is 'ETL处理时间戳';
