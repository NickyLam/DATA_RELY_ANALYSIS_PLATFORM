/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_guarantee_guarantor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_guarantee_guarantor
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_guarantee_guarantor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_guarantee_guarantor(
    datadt varchar2(10) -- 数据日期
    ,guarcontractno varchar2(64) -- 担保合同编号
    ,guarantorcustid varchar2(32) -- 保证人客户号
    ,orgid varchar2(20) -- 机构号
    ,risktype varchar2(10) -- 保证或者抵质押物风险缓释类型
    ,guarantortype varchar2(10) -- 保证人客户类型
    ,guarantorname varchar2(80) -- 保证人名称
    ,guarantoridtype varchar2(32) -- 保证人证件类型
    ,guarantoridno varchar2(40) -- 保证人证件号码
    ,guarantyvaluelimit number(22,2) -- 保证人保证能力上限
    ,guarantorasset number(22,2) -- 保证人净资产
    ,guarantyvalue number(22,2) -- 保证金额
    ,merchantid varchar2(32) -- 单位ID
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
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
grant select on ${iol_schema}.icms_wyd_guarantee_guarantor to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_guarantor to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_guarantor to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_guarantee_guarantor to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_guarantee_guarantor is '保证人信息';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.datadt is '数据日期';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarcontractno is '担保合同编号';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantorcustid is '保证人客户号';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.risktype is '保证或者抵质押物风险缓释类型';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantortype is '保证人客户类型';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantorname is '保证人名称';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantoridtype is '保证人证件类型';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantoridno is '保证人证件号码';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantyvaluelimit is '保证人保证能力上限';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantorasset is '保证人净资产';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.guarantyvalue is '保证金额';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.merchantid is '单位ID';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_guarantee_guarantor.etl_timestamp is 'ETL处理时间戳';
