/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_corp_cust_asset_and_bus_inco_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info
whenever sqlerror continue none;
drop table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info(
    etl_dt date -- 数据日期   
    ,cust_id varchar2(60) -- 客户编号   
    ,cust_name varchar2(100) -- 客户名称   
    ,tot_asset number(30,6) -- 总资产   
    ,bus_inco number(30,6) -- 营业收入   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info is '企业客户资产及营业收入信息';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.etl_dt is '数据日期';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.cust_id is '客户编号';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.cust_name is '客户名称';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.tot_asset is '总资产';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.bus_inco is '营业收入';
comment on column ${idl_schema}.cmm_corp_cust_asset_and_bus_inco_info.etl_timestamp is '数据处理时间';