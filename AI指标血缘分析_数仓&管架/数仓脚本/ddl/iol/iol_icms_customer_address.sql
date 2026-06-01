/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_address
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_address
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_address purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_address(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(32) -- 客户编号
    ,districtname varchar2(80) -- 区域名称
    ,country varchar2(80) -- 地址所属国家/地区
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,address varchar2(400) -- 地址详情
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,updateorgid varchar2(64) -- 更新机构
    ,addtype varchar2(80) -- 地址类型
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,cityname varchar2(80) -- 城市名称
    ,city varchar2(80) -- 地址所属市/县
    ,inputdate date -- 登记日期
    ,provincename varchar2(80) -- 省份名称
    ,isnew varchar2(2) -- 是否最新
    ,isadd varchar2(2) -- 是否通讯地址
    ,zipcode varchar2(400) -- 邮政编码
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
grant select on ${iol_schema}.icms_customer_address to ${iml_schema};
grant select on ${iol_schema}.icms_customer_address to ${icl_schema};
grant select on ${iol_schema}.icms_customer_address to ${idl_schema};
grant select on ${iol_schema}.icms_customer_address to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_address is '客户地址';
comment on column ${iol_schema}.icms_customer_address.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_address.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_address.districtname is '区域名称';
comment on column ${iol_schema}.icms_customer_address.country is '地址所属国家/地区';
comment on column ${iol_schema}.icms_customer_address.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_address.address is '地址详情';
comment on column ${iol_schema}.icms_customer_address.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_address.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_address.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_address.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_address.addtype is '地址类型';
comment on column ${iol_schema}.icms_customer_address.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_address.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_address.cityname is '城市名称';
comment on column ${iol_schema}.icms_customer_address.city is '地址所属市/县';
comment on column ${iol_schema}.icms_customer_address.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_address.provincename is '省份名称';
comment on column ${iol_schema}.icms_customer_address.isnew is '是否最新';
comment on column ${iol_schema}.icms_customer_address.isadd is '是否通讯地址';
comment on column ${iol_schema}.icms_customer_address.zipcode is '邮政编码';
comment on column ${iol_schema}.icms_customer_address.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_address.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_address.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_address.etl_timestamp is 'ETL处理时间戳';
