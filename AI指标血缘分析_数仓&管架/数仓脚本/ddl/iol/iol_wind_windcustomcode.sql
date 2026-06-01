/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_windcustomcode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_windcustomcode
whenever sqlerror continue none;
drop table ${iol_schema}.wind_windcustomcode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_windcustomcode(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_asharecode varchar2(15) -- 证券ID
    ,s_info_compcode varchar2(15) -- 公司ID
    ,s_info_securitiestypes varchar2(15) -- 证券类型
    ,s_info_sectypename varchar2(150) -- 类型名称
    ,s_info_countryname varchar2(150) -- 国别
    ,s_info_countrycode varchar2(15) -- 国别编号
    ,s_info_exchmarketname varchar2(60) -- 交易所
    ,s_info_exchmarket varchar2(20) -- 交易所编号
    ,crncy_name varchar2(60) -- 币种
    ,crncy_code varchar2(15) -- 币种编号
    ,s_info_isincode varchar2(60) -- ISIN代码
    ,s_info_code varchar2(60) -- 交易代码
    ,s_info_name varchar2(300) -- 证券中文简称
    ,exchmarket varchar2(20) -- 交易所
    ,security_status number(9,0) -- 存续状态
    ,s_info_org_code varchar2(30) -- 组织机构代码
    ,s_info_typecode number(9,0) -- 分类代码
    ,s_info_min_price_chg_unit number(24,8) -- 最小价格变动单位
    ,s_info_lot_size number(20,4) -- 每手数量
    ,s_info_ename varchar2(300) -- 证券英文简称
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
grant select on ${iol_schema}.wind_windcustomcode to ${iml_schema};
grant select on ${iol_schema}.wind_windcustomcode to ${icl_schema};
grant select on ${iol_schema}.wind_windcustomcode to ${idl_schema};
grant select on ${iol_schema}.wind_windcustomcode to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_windcustomcode is 'Wind兼容代码';
comment on column ${iol_schema}.wind_windcustomcode.object_id is '对象ID';
comment on column ${iol_schema}.wind_windcustomcode.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_windcustomcode.s_info_asharecode is '证券ID';
comment on column ${iol_schema}.wind_windcustomcode.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_windcustomcode.s_info_securitiestypes is '证券类型';
comment on column ${iol_schema}.wind_windcustomcode.s_info_sectypename is '类型名称';
comment on column ${iol_schema}.wind_windcustomcode.s_info_countryname is '国别';
comment on column ${iol_schema}.wind_windcustomcode.s_info_countrycode is '国别编号';
comment on column ${iol_schema}.wind_windcustomcode.s_info_exchmarketname is '交易所';
comment on column ${iol_schema}.wind_windcustomcode.s_info_exchmarket is '交易所编号';
comment on column ${iol_schema}.wind_windcustomcode.crncy_name is '币种';
comment on column ${iol_schema}.wind_windcustomcode.crncy_code is '币种编号';
comment on column ${iol_schema}.wind_windcustomcode.s_info_isincode is 'ISIN代码';
comment on column ${iol_schema}.wind_windcustomcode.s_info_code is '交易代码';
comment on column ${iol_schema}.wind_windcustomcode.s_info_name is '证券中文简称';
comment on column ${iol_schema}.wind_windcustomcode.exchmarket is '交易所';
comment on column ${iol_schema}.wind_windcustomcode.security_status is '存续状态';
comment on column ${iol_schema}.wind_windcustomcode.s_info_org_code is '组织机构代码';
comment on column ${iol_schema}.wind_windcustomcode.s_info_typecode is '分类代码';
comment on column ${iol_schema}.wind_windcustomcode.s_info_min_price_chg_unit is '最小价格变动单位';
comment on column ${iol_schema}.wind_windcustomcode.s_info_lot_size is '每手数量';
comment on column ${iol_schema}.wind_windcustomcode.s_info_ename is '证券英文简称';
comment on column ${iol_schema}.wind_windcustomcode.opdate is '';
comment on column ${iol_schema}.wind_windcustomcode.opmode is '';
comment on column ${iol_schema}.wind_windcustomcode.start_dt is '开始时间';
comment on column ${iol_schema}.wind_windcustomcode.end_dt is '结束时间';
comment on column ${iol_schema}.wind_windcustomcode.id_mark is '增删标志';
comment on column ${iol_schema}.wind_windcustomcode.etl_timestamp is 'ETL处理时间戳';
