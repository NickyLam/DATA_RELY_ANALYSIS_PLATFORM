/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_case_customer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_case_customer
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_case_customer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_case_customer(
    customerid varchar2(16) -- 客户编号
    ,caseno varchar2(64) -- 案件编号
    ,certtype varchar2(6) -- 证件类型
    ,inputorgid varchar2(12) -- 登记机构
    ,attribute4 varchar2(160) -- 扩展要素四
    ,attribute5 varchar2(160) -- 扩展要素五
    ,customertype varchar2(36) -- 客户类型
    ,certid varchar2(18) -- 证件号
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,attribute3 varchar2(160) -- 扩展要素三
    ,customername varchar2(200) -- 客户名称
    ,inputdate date -- 登记日期
    ,inputuserid varchar2(64) -- 登记人
    ,attribute1 varchar2(160) -- 扩展要素一
    ,address varchar2(400) -- 住所地
    ,updatedate date -- 更新日期
    ,attribute2 varchar2(160) -- 扩展要素二
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
grant select on ${iol_schema}.icms_ap_case_customer to ${iml_schema};
grant select on ${iol_schema}.icms_ap_case_customer to ${icl_schema};
grant select on ${iol_schema}.icms_ap_case_customer to ${idl_schema};
grant select on ${iol_schema}.icms_ap_case_customer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_case_customer is '案件客户信息';
comment on column ${iol_schema}.icms_ap_case_customer.customerid is '客户编号';
comment on column ${iol_schema}.icms_ap_case_customer.caseno is '案件编号';
comment on column ${iol_schema}.icms_ap_case_customer.certtype is '证件类型';
comment on column ${iol_schema}.icms_ap_case_customer.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_case_customer.attribute4 is '扩展要素四';
comment on column ${iol_schema}.icms_ap_case_customer.attribute5 is '扩展要素五';
comment on column ${iol_schema}.icms_ap_case_customer.customertype is '客户类型';
comment on column ${iol_schema}.icms_ap_case_customer.certid is '证件号';
comment on column ${iol_schema}.icms_ap_case_customer.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_case_customer.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_case_customer.attribute3 is '扩展要素三';
comment on column ${iol_schema}.icms_ap_case_customer.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_case_customer.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_case_customer.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_case_customer.attribute1 is '扩展要素一';
comment on column ${iol_schema}.icms_ap_case_customer.address is '住所地';
comment on column ${iol_schema}.icms_ap_case_customer.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_case_customer.attribute2 is '扩展要素二';
comment on column ${iol_schema}.icms_ap_case_customer.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_case_customer.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_case_customer.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_case_customer.etl_timestamp is 'ETL处理时间戳';
