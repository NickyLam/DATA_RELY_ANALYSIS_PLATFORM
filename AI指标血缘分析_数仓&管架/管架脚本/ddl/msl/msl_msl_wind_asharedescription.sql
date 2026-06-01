/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_wind_asharedescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_wind_asharedescription
whenever sqlerror continue none;
drop table ${msl_schema}.msl_wind_asharedescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_wind_asharedescription(
    ETL_DT DATE
    ,OBJECT_ID VARCHAR2(100)
    ,S_INFO_WINDCODE VARCHAR2(40)
    ,S_INFO_CODE VARCHAR2(40)
    ,S_INFO_NAME VARCHAR2(50)
    ,S_INFO_COMPNAME VARCHAR2(100)
    ,S_INFO_COMPNAMEENG VARCHAR2(100)
    ,S_INFO_ISINCODE VARCHAR2(40)
    ,S_INFO_EXCHMARKET VARCHAR2(40)
    ,S_INFO_LISTBOARD VARCHAR2(10)
    ,S_INFO_LISTDATE VARCHAR2(8)
    ,S_INFO_DELISTDATE VARCHAR2(8)
    ,S_INFO_SEDOLCODE VARCHAR2(40)
    ,CRNCY_CODE VARCHAR2(10)
    ,S_INFO_PINYIN VARCHAR2(40)
    ,S_INFO_LISTBOARDNAME VARCHAR2(15)
    ,IS_SHSC NUMBER(5,0)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant


-- comment
comment on table ${msl_schema}.msl_wind_asharedescription is '中国A股基本资料';
comment on column ${msl_schema}.msl_wind_asharedescription.ETL_DT is 'ETL处理日期';
comment on column ${msl_schema}.msl_wind_asharedescription.OBJECT_ID is '对象ID';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_WINDCODE is 'Wind代码';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_CODE is '交易代码';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_NAME is '证券简称';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_COMPNAME is '公司中文名称';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_COMPNAMEENG is '公司英文名称';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_ISINCODE is 'ISIN代码';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_EXCHMARKET is '交易所';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_LISTBOARD is '上市板类型';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_LISTDATE is '上市日期';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_DELISTDATE is '退市日期';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_SEDOLCODE is '';
comment on column ${msl_schema}.msl_wind_asharedescription.CRNCY_CODE is '货币代码';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_PINYIN is '简称拼音';
comment on column ${msl_schema}.msl_wind_asharedescription.S_INFO_LISTBOARDNAME is '上市板';
comment on column ${msl_schema}.msl_wind_asharedescription.IS_SHSC is '是否在沪股通或深港通范围内';
comment on column ${msl_schema}.msl_wind_asharedescription.START_DT is '开始时间';
comment on column ${msl_schema}.msl_wind_asharedescription.END_DT is '结束时间';
comment on column ${msl_schema}.msl_wind_asharedescription.ID_MARK is '增删标志';
