/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_contact_credit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_contact_credit
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_contact_credit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_contact_credit(
    exposurebalance number(24,6) -- 敞口余额
    ,customerid varchar2(16) -- 客户编号
    ,creditcontractno varchar2(64) -- 额度合同编号
    ,approveexposuresum number(24,6) -- 批复敞口
    ,creditstartdate date -- 额度开始日期
    ,usedbalance number(24,6) -- 使用余额
    ,objectno varchar2(64) -- 对象号(风险监测主表流水号)
    ,creditmarutity date -- 额度到期日
    ,updatedate date -- 更新日期
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(64) -- 更新人机构编号
    ,serialno varchar2(64) -- 流水号
    ,credittype varchar2(10) -- 额度类型
    ,contactserialno varchar2(64) -- 对象号(风险监测-客户联系监测流水号)
    ,inputuserid varchar2(64) -- 登记人
    ,approvecreditsum number(24,6) -- 批复额度
    ,updateuserid varchar2(64) -- 更新人编号
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
grant select on ${iol_schema}.icms_customer_contact_credit to ${iml_schema};
grant select on ${iol_schema}.icms_customer_contact_credit to ${icl_schema};
grant select on ${iol_schema}.icms_customer_contact_credit to ${idl_schema};
grant select on ${iol_schema}.icms_customer_contact_credit to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_contact_credit is '风险监测-客户联系监测-授信额度信息';
comment on column ${iol_schema}.icms_customer_contact_credit.exposurebalance is '敞口余额';
comment on column ${iol_schema}.icms_customer_contact_credit.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_contact_credit.creditcontractno is '额度合同编号';
comment on column ${iol_schema}.icms_customer_contact_credit.approveexposuresum is '批复敞口';
comment on column ${iol_schema}.icms_customer_contact_credit.creditstartdate is '额度开始日期';
comment on column ${iol_schema}.icms_customer_contact_credit.usedbalance is '使用余额';
comment on column ${iol_schema}.icms_customer_contact_credit.objectno is '对象号(风险监测主表流水号)';
comment on column ${iol_schema}.icms_customer_contact_credit.creditmarutity is '额度到期日';
comment on column ${iol_schema}.icms_customer_contact_credit.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_contact_credit.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_contact_credit.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_contact_credit.updateorgid is '更新人机构编号';
comment on column ${iol_schema}.icms_customer_contact_credit.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_contact_credit.credittype is '额度类型';
comment on column ${iol_schema}.icms_customer_contact_credit.contactserialno is '对象号(风险监测-客户联系监测流水号)';
comment on column ${iol_schema}.icms_customer_contact_credit.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_contact_credit.approvecreditsum is '批复额度';
comment on column ${iol_schema}.icms_customer_contact_credit.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_contact_credit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_customer_contact_credit.etl_timestamp is 'ETL处理时间戳';
