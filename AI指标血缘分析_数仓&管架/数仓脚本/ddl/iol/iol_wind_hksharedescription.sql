/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_hksharedescription
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_hksharedescription
whenever sqlerror continue none;
drop table ${iol_schema}.wind_hksharedescription purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hksharedescription(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_code varchar2(60) -- 交易代码
    ,s_info_isincode varchar2(60) -- [内部]ISIN代码
    ,s_info_name varchar2(300) -- 证券中文简称
    ,s_info_name_eng varchar2(300) -- [内部]证券英文简称
    ,s_info_fullname varchar2(300) -- [内部]证券中文全称
    ,s_info_fullname_eng varchar2(300) -- [内部]证券英文全称
    ,securityclass number(9,0) -- 品种大类代码
    ,securitysubclass number(9,0) -- 品种细类代码
    ,securitytype varchar2(15) -- 品种类型(兼容)
    ,s_info_countrycode varchar2(15) -- 国家及地区代码
    ,s_info_exchange_eng varchar2(60) -- 交易所英文简称
    ,s_info_exchange varchar2(60) -- 交易所名称(兼容)
    ,s_info_listboard varchar2(15) -- 上市板
    ,s_info_compcode varchar2(15) -- 公司id
    ,s_info_status number(9,0) -- 存续状态
    ,crncy_code varchar2(15) -- 交易币种
    ,s_info_par number(24,8) -- 面值
    ,min_prc_chg_unit number(24,8) -- 最小价格变动单位
    ,s_info_unitperlot number(20,4) -- 每手数量
    ,s_info_listdate varchar2(12) -- 开始交易日期
    ,s_info_delistdate varchar2(12) -- 最后交易日期
    ,s_info_listprice number(24,8) -- 挂牌价
    ,is_hksc number(5,0) -- 是否在港股通范围内
    ,istemporarysymbol number(5,0) -- 是否并行临时代码
    ,is_h number(1,0) -- 是否是H股
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
grant select on ${iol_schema}.wind_hksharedescription to ${iml_schema};
grant select on ${iol_schema}.wind_hksharedescription to ${icl_schema};
grant select on ${iol_schema}.wind_hksharedescription to ${idl_schema};
grant select on ${iol_schema}.wind_hksharedescription to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_hksharedescription is '香港股票基本资料';
comment on column ${iol_schema}.wind_hksharedescription.object_id is '对象ID';
comment on column ${iol_schema}.wind_hksharedescription.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_hksharedescription.s_info_code is '交易代码';
comment on column ${iol_schema}.wind_hksharedescription.s_info_isincode is '[内部]ISIN代码';
comment on column ${iol_schema}.wind_hksharedescription.s_info_name is '证券中文简称';
comment on column ${iol_schema}.wind_hksharedescription.s_info_name_eng is '[内部]证券英文简称';
comment on column ${iol_schema}.wind_hksharedescription.s_info_fullname is '[内部]证券中文全称';
comment on column ${iol_schema}.wind_hksharedescription.s_info_fullname_eng is '[内部]证券英文全称';
comment on column ${iol_schema}.wind_hksharedescription.securityclass is '品种大类代码';
comment on column ${iol_schema}.wind_hksharedescription.securitysubclass is '品种细类代码';
comment on column ${iol_schema}.wind_hksharedescription.securitytype is '品种类型(兼容)';
comment on column ${iol_schema}.wind_hksharedescription.s_info_countrycode is '国家及地区代码';
comment on column ${iol_schema}.wind_hksharedescription.s_info_exchange_eng is '交易所英文简称';
comment on column ${iol_schema}.wind_hksharedescription.s_info_exchange is '交易所名称(兼容)';
comment on column ${iol_schema}.wind_hksharedescription.s_info_listboard is '上市板';
comment on column ${iol_schema}.wind_hksharedescription.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_hksharedescription.s_info_status is '存续状态';
comment on column ${iol_schema}.wind_hksharedescription.crncy_code is '交易币种';
comment on column ${iol_schema}.wind_hksharedescription.s_info_par is '面值';
comment on column ${iol_schema}.wind_hksharedescription.min_prc_chg_unit is '最小价格变动单位';
comment on column ${iol_schema}.wind_hksharedescription.s_info_unitperlot is '每手数量';
comment on column ${iol_schema}.wind_hksharedescription.s_info_listdate is '开始交易日期';
comment on column ${iol_schema}.wind_hksharedescription.s_info_delistdate is '最后交易日期';
comment on column ${iol_schema}.wind_hksharedescription.s_info_listprice is '挂牌价';
comment on column ${iol_schema}.wind_hksharedescription.is_hksc is '是否在港股通范围内';
comment on column ${iol_schema}.wind_hksharedescription.istemporarysymbol is '是否并行临时代码';
comment on column ${iol_schema}.wind_hksharedescription.is_h is '是否是H股';
comment on column ${iol_schema}.wind_hksharedescription.opdate is '';
comment on column ${iol_schema}.wind_hksharedescription.opmode is '';
comment on column ${iol_schema}.wind_hksharedescription.start_dt is '开始时间';
comment on column ${iol_schema}.wind_hksharedescription.end_dt is '结束时间';
comment on column ${iol_schema}.wind_hksharedescription.id_mark is '增删标志';
comment on column ${iol_schema}.wind_hksharedescription.etl_timestamp is 'ETL处理时间戳';
