/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_contact_business
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_contact_business
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_contact_business purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_contact_business(
    creditserialno varchar2(64) -- 对象号(风险监测-客户联系监测授信额度流水号)
    ,updatedate date -- 更新日期
    ,duebillserialno varchar2(64) -- 借据编号
    ,operateuserid varchar2(64) -- 经办人
    ,customerid varchar2(16) -- 客户编号
    ,contactserialno varchar2(64) -- 对象号(风险监测-客户联系监测流水号)
    ,marurity date -- 到期日期
    ,operateorgid varchar2(64) -- 经办机构
    ,serialno varchar2(64) -- 流水号
    ,objectno varchar2(64) -- 对象号(风险监测主表流水号)
    ,productid varchar2(64) -- 业务品种
    ,putoutsum number(24,6) -- 出账金额
    ,inputuserid varchar2(64) -- 登记人
    ,riskclassify varchar2(64) -- 风险分类
    ,inputdate date -- 登记日期
    ,bcserialno varchar2(64) -- 额度合同编号
    ,currentsum number(24,6) -- 当期金额
    ,updateuserid varchar2(64) -- 更新人编号
    ,updateorgid varchar2(64) -- 更新人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,putoutdate date -- 出账日期
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_customer_contact_business to ${iml_schema};
grant select on ${iol_schema}.icms_customer_contact_business to ${icl_schema};
grant select on ${iol_schema}.icms_customer_contact_business to ${idl_schema};
grant select on ${iol_schema}.icms_customer_contact_business to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_contact_business is '风险监测-客户联系监测-授信业务信息';
comment on column ${iol_schema}.icms_customer_contact_business.creditserialno is '对象号(风险监测-客户联系监测授信额度流水号)';
comment on column ${iol_schema}.icms_customer_contact_business.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_contact_business.duebillserialno is '借据编号';
comment on column ${iol_schema}.icms_customer_contact_business.operateuserid is '经办人';
comment on column ${iol_schema}.icms_customer_contact_business.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_contact_business.contactserialno is '对象号(风险监测-客户联系监测流水号)';
comment on column ${iol_schema}.icms_customer_contact_business.marurity is '到期日期';
comment on column ${iol_schema}.icms_customer_contact_business.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_customer_contact_business.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_contact_business.objectno is '对象号(风险监测主表流水号)';
comment on column ${iol_schema}.icms_customer_contact_business.productid is '业务品种';
comment on column ${iol_schema}.icms_customer_contact_business.putoutsum is '出账金额';
comment on column ${iol_schema}.icms_customer_contact_business.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_contact_business.riskclassify is '风险分类';
comment on column ${iol_schema}.icms_customer_contact_business.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_contact_business.bcserialno is '额度合同编号';
comment on column ${iol_schema}.icms_customer_contact_business.currentsum is '当期金额';
comment on column ${iol_schema}.icms_customer_contact_business.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_contact_business.updateorgid is '更新人机构编号';
comment on column ${iol_schema}.icms_customer_contact_business.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_contact_business.putoutdate is '出账日期';
comment on column ${iol_schema}.icms_customer_contact_business.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_customer_contact_business.etl_timestamp is 'ETL处理时间戳';
