/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_asharedescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_asharedescription
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_asharedescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_asharedescription(
     object_id varchar2(100) -- 对象ID
    ,s_info_windcode varchar2(40) -- Wind代码
    ,s_info_code varchar2(40) -- 交易代码
    ,s_info_name varchar2(50) -- 证券简称
    ,s_info_compname varchar2(100) -- 公司中文名称
    ,s_info_compnameeng varchar2(100) -- 公司英文名称
    ,s_info_isincode varchar2(40) -- ISIN代码
    ,s_info_exchmarket varchar2(40) -- 交易所
    ,s_info_listboard varchar2(10) -- 上市板类型
    ,s_info_listdate varchar2(8) -- 上市日期
    ,s_info_delistdate varchar2(8) -- 退市日期
    ,s_info_sedolcode varchar2(40) -- 
    ,crncy_code varchar2(10) -- 货币代码
    ,s_info_pinyin varchar2(40) -- 简称拼音
    ,s_info_listboardname varchar2(15) -- 上市板
    ,is_shsc number(5,0) -- 是否在沪股通或深港通范围内
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_wind_asharedescription to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_asharedescription is '中国A股基本资料';
comment on column ${itl_schema}.mtl_wind_asharedescription.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_asharedescription.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_windcode is 'Wind代码';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_code is '交易代码';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_name is '证券简称';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_compname is '公司中文名称';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_compnameeng is '公司英文名称';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_isincode is 'ISIN代码';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_exchmarket is '交易所';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_listboard is '上市板类型';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_listdate is '上市日期';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_delistdate is '退市日期';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_sedolcode is '';
comment on column ${itl_schema}.mtl_wind_asharedescription.crncy_code is '货币代码';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_pinyin is '简称拼音';
comment on column ${itl_schema}.mtl_wind_asharedescription.s_info_listboardname is '上市板';
comment on column ${itl_schema}.mtl_wind_asharedescription.is_shsc is '是否在沪股通或深港通范围内';
comment on column ${itl_schema}.mtl_wind_asharedescription.start_dt is '开始时间';
comment on column ${itl_schema}.mtl_wind_asharedescription.end_dt is '结束时间';
comment on column ${itl_schema}.mtl_wind_asharedescription.id_mark is '增删标志';
comment on column ${itl_schema}.mtl_wind_asharedescription.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_asharedescription.etl_timestamp is 'ETL处理时间戳';
