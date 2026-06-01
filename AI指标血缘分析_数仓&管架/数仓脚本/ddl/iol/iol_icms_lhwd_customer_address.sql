/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_customer_address
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_customer_address
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_customer_address purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_customer_address(
    serialno varchar2(64) -- 流水号
    ,customerid varchar2(16) -- 客户编号
    ,addtype varchar2(10) -- 地址类型
    ,addtypename varchar2(80) -- 地址类型描述
    ,provincecode varchar2(10) -- 省编码
    ,provincename varchar2(80) -- 省名称
    ,citycode varchar2(10) -- 市编码
    ,cityname varchar2(80) -- 市名称
    ,addressdetail varchar2(500) -- 地址详情
    ,creditchannel varchar2(32) -- 授信渠道
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_lhwd_customer_address to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_customer_address to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_address to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_address to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_customer_address is '联合网贷地址信息表';
comment on column ${iol_schema}.icms_lhwd_customer_address.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_customer_address.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_customer_address.addtype is '地址类型';
comment on column ${iol_schema}.icms_lhwd_customer_address.addtypename is '地址类型描述';
comment on column ${iol_schema}.icms_lhwd_customer_address.provincecode is '省编码';
comment on column ${iol_schema}.icms_lhwd_customer_address.provincename is '省名称';
comment on column ${iol_schema}.icms_lhwd_customer_address.citycode is '市编码';
comment on column ${iol_schema}.icms_lhwd_customer_address.cityname is '市名称';
comment on column ${iol_schema}.icms_lhwd_customer_address.addressdetail is '地址详情';
comment on column ${iol_schema}.icms_lhwd_customer_address.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_customer_address.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_customer_address.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_customer_address.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lhwd_customer_address.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_customer_address.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_customer_address.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_customer_address.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_customer_address.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_customer_address.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_customer_address.etl_timestamp is 'ETL处理时间戳';
