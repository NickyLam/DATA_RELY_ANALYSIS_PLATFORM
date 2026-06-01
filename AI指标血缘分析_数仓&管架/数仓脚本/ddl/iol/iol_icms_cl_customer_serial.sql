/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_customer_serial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_customer_serial
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_customer_serial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_customer_serial(
    customername varchar2(200) -- 客户名称
    ,inputuserid varchar2(64) -- 登记人
    ,certtype varchar2(4) -- 主证件的类型
    ,certid varchar2(18) -- 主证件的号码
    ,sourcesystemcustomerid varchar2(160) -- 源系统产品编号
    ,crossbranchgroupflag varchar2(2) -- 跨分行集团客户标志
    ,entscale varchar2(1) -- 企业规模
    ,status varchar2(64) -- 状态
    ,serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 最后更新机构
    ,inputdate timestamp -- 登记日期
    ,unifiedcreditnominalamount number(24,6) -- 统一授信名义金额
    ,importantgroupflag varchar2(2) -- 重点集团客户标志
    ,customerid varchar2(16) -- 客户编号
    ,swiftcode varchar2(64) -- SWIFT代码
    ,remark varchar2(1000) -- 备注
    ,unifiedcreditexposureamount number(24,6) -- 统一授信敞口金额
    ,inputorgid varchar2(12) -- 登记机构
    ,limitamountcurrency varchar2(36) -- 限额币种
    ,sourcesystem varchar2(64) -- 来源系统
    ,businesslicenseno varchar2(64) -- 营业执照号
    ,updatedate timestamp -- 最后更新日期
    ,limitamount number(24,6) -- 限额
    ,updateuserid varchar2(64) -- 最后更新人
    ,customertype varchar2(64) -- 客户类型
    ,unifiedcreditcurrency varchar2(36) -- 统一授信币种
    ,financialinstitutioncode varchar2(64) -- 金融机构代码
    ,belonggroupid varchar2(30) -- 所属集团编号
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
grant select on ${iol_schema}.icms_cl_customer_serial to ${iml_schema};
grant select on ${iol_schema}.icms_cl_customer_serial to ${icl_schema};
grant select on ${iol_schema}.icms_cl_customer_serial to ${idl_schema};
grant select on ${iol_schema}.icms_cl_customer_serial to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_customer_serial is '授信客户流水信息';
comment on column ${iol_schema}.icms_cl_customer_serial.customername is '客户名称';
comment on column ${iol_schema}.icms_cl_customer_serial.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_customer_serial.certtype is '主证件的类型';
comment on column ${iol_schema}.icms_cl_customer_serial.certid is '主证件的号码';
comment on column ${iol_schema}.icms_cl_customer_serial.sourcesystemcustomerid is '源系统产品编号';
comment on column ${iol_schema}.icms_cl_customer_serial.crossbranchgroupflag is '跨分行集团客户标志';
comment on column ${iol_schema}.icms_cl_customer_serial.entscale is '企业规模';
comment on column ${iol_schema}.icms_cl_customer_serial.status is '状态';
comment on column ${iol_schema}.icms_cl_customer_serial.serialno is '流水号';
comment on column ${iol_schema}.icms_cl_customer_serial.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_customer_serial.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_customer_serial.unifiedcreditnominalamount is '统一授信名义金额';
comment on column ${iol_schema}.icms_cl_customer_serial.importantgroupflag is '重点集团客户标志';
comment on column ${iol_schema}.icms_cl_customer_serial.customerid is '客户编号';
comment on column ${iol_schema}.icms_cl_customer_serial.swiftcode is 'SWIFT代码';
comment on column ${iol_schema}.icms_cl_customer_serial.remark is '备注';
comment on column ${iol_schema}.icms_cl_customer_serial.unifiedcreditexposureamount is '统一授信敞口金额';
comment on column ${iol_schema}.icms_cl_customer_serial.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_customer_serial.limitamountcurrency is '限额币种';
comment on column ${iol_schema}.icms_cl_customer_serial.sourcesystem is '来源系统';
comment on column ${iol_schema}.icms_cl_customer_serial.businesslicenseno is '营业执照号';
comment on column ${iol_schema}.icms_cl_customer_serial.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_customer_serial.limitamount is '限额';
comment on column ${iol_schema}.icms_cl_customer_serial.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_customer_serial.customertype is '客户类型';
comment on column ${iol_schema}.icms_cl_customer_serial.unifiedcreditcurrency is '统一授信币种';
comment on column ${iol_schema}.icms_cl_customer_serial.financialinstitutioncode is '金融机构代码';
comment on column ${iol_schema}.icms_cl_customer_serial.belonggroupid is '所属集团编号';
comment on column ${iol_schema}.icms_cl_customer_serial.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_customer_serial.etl_timestamp is 'ETL处理时间戳';
