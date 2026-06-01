/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_business_receipt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_business_receipt_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_business_receipt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_business_receipt_info(
    recordno varchar2(64) -- 记录编号
    ,objectno varchar2(64) -- 关联流水号
    ,objecttype varchar2(64) -- 关联对象类型
    ,receiptid varchar2(64) -- 单据编号
    ,customerid varchar2(64) -- 客户编号
    ,customername varchar2(2000) -- 客户名称
    ,receiptccy varchar2(15) -- 单据币种
    ,receiptamount number(24,6) -- 单据金额（元）
    ,receipttype varchar2(32) -- 单据种类
    ,attribute1 varchar2(2000) -- 预留字段1
    ,attribute2 varchar2(2000) -- 预留字段2
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_business_receipt_info to ${iml_schema};
grant select on ${iol_schema}.icms_business_receipt_info to ${icl_schema};
grant select on ${iol_schema}.icms_business_receipt_info to ${idl_schema};
grant select on ${iol_schema}.icms_business_receipt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_business_receipt_info is '商业票据信息表';
comment on column ${iol_schema}.icms_business_receipt_info.recordno is '记录编号';
comment on column ${iol_schema}.icms_business_receipt_info.objectno is '关联流水号';
comment on column ${iol_schema}.icms_business_receipt_info.objecttype is '关联对象类型';
comment on column ${iol_schema}.icms_business_receipt_info.receiptid is '单据编号';
comment on column ${iol_schema}.icms_business_receipt_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_business_receipt_info.customername is '客户名称';
comment on column ${iol_schema}.icms_business_receipt_info.receiptccy is '单据币种';
comment on column ${iol_schema}.icms_business_receipt_info.receiptamount is '单据金额（元）';
comment on column ${iol_schema}.icms_business_receipt_info.receipttype is '单据种类';
comment on column ${iol_schema}.icms_business_receipt_info.attribute1 is '预留字段1';
comment on column ${iol_schema}.icms_business_receipt_info.attribute2 is '预留字段2';
comment on column ${iol_schema}.icms_business_receipt_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_business_receipt_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_business_receipt_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_business_receipt_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_business_receipt_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_business_receipt_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_business_receipt_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_business_receipt_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_business_receipt_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_business_receipt_info.etl_timestamp is 'ETL处理时间戳';
