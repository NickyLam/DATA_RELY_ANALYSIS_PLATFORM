/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_customer_info(
    sourcesystemcustomerid varchar2(160) -- 源系统产品编号
    ,swiftcode varchar2(64) -- SWIFT代码
    ,limitamount number(24,6) -- 限额
    ,unifiedcreditexposureamount number(24,6) -- 统一授信敞口金额
    ,updateuserid varchar2(64) -- 最后更新人
    ,belonggroupid varchar2(30) -- 所属集团编号
    ,crossbranchgroupflag varchar2(2) -- 跨分行集团客户标志
    ,updatedate timestamp -- 最后更新日期
    ,limitamountcurrency varchar2(36) -- 限额币种
    ,inputdate timestamp -- 登记日期
    ,updateorgid varchar2(64) -- 最后更新机构
    ,customername varchar2(200) -- 客户名称
    ,importantgroupflag varchar2(2) -- 重点集团客户标志
    ,unifiedcreditcurrency varchar2(36) -- 统一授信币种
    ,financialinstitutioncode varchar2(64) -- 金融机构代码
    ,creditleveltype varchar2(64) -- 适用额度层级类型
    ,entscale varchar2(36) -- 企业规模
    ,inputorgid varchar2(12) -- 登记机构
    ,customerid varchar2(32) -- 客户编号
    ,customertype varchar2(64) -- 客户类型
    ,businesslicenseno varchar2(64) -- 营业执照号
    ,status varchar2(64) -- 状态
    ,inputuserid varchar2(64) -- 登记人
    ,sourcesystem varchar2(64) -- 来源系统
    ,unifiedcreditnominalamount number(24,6) -- 统一授信名义金额
    ,remark varchar2(1000) -- 备注
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
grant select on ${iol_schema}.icms_cl_customer_info to ${iml_schema};
grant select on ${iol_schema}.icms_cl_customer_info to ${icl_schema};
grant select on ${iol_schema}.icms_cl_customer_info to ${idl_schema};
grant select on ${iol_schema}.icms_cl_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_customer_info is '授信客户信息';
comment on column ${iol_schema}.icms_cl_customer_info.sourcesystemcustomerid is '源系统产品编号';
comment on column ${iol_schema}.icms_cl_customer_info.swiftcode is 'SWIFT代码';
comment on column ${iol_schema}.icms_cl_customer_info.limitamount is '限额';
comment on column ${iol_schema}.icms_cl_customer_info.unifiedcreditexposureamount is '统一授信敞口金额';
comment on column ${iol_schema}.icms_cl_customer_info.updateuserid is '最后更新人';
comment on column ${iol_schema}.icms_cl_customer_info.belonggroupid is '所属集团编号';
comment on column ${iol_schema}.icms_cl_customer_info.crossbranchgroupflag is '跨分行集团客户标志';
comment on column ${iol_schema}.icms_cl_customer_info.updatedate is '最后更新日期';
comment on column ${iol_schema}.icms_cl_customer_info.limitamountcurrency is '限额币种';
comment on column ${iol_schema}.icms_cl_customer_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_customer_info.updateorgid is '最后更新机构';
comment on column ${iol_schema}.icms_cl_customer_info.customername is '客户名称';
comment on column ${iol_schema}.icms_cl_customer_info.importantgroupflag is '重点集团客户标志';
comment on column ${iol_schema}.icms_cl_customer_info.unifiedcreditcurrency is '统一授信币种';
comment on column ${iol_schema}.icms_cl_customer_info.financialinstitutioncode is '金融机构代码';
comment on column ${iol_schema}.icms_cl_customer_info.creditleveltype is '适用额度层级类型';
comment on column ${iol_schema}.icms_cl_customer_info.entscale is '企业规模';
comment on column ${iol_schema}.icms_cl_customer_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_customer_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_cl_customer_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_cl_customer_info.businesslicenseno is '营业执照号';
comment on column ${iol_schema}.icms_cl_customer_info.status is '状态';
comment on column ${iol_schema}.icms_cl_customer_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_customer_info.sourcesystem is '来源系统';
comment on column ${iol_schema}.icms_cl_customer_info.unifiedcreditnominalamount is '统一授信名义金额';
comment on column ${iol_schema}.icms_cl_customer_info.remark is '备注';
comment on column ${iol_schema}.icms_cl_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_cl_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_cl_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_cl_customer_info.etl_timestamp is 'ETL处理时间戳';
