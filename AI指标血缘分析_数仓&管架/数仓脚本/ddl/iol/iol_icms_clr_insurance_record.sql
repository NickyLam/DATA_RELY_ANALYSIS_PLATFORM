/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_insurance_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_insurance_record
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_insurance_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_insurance_record(
    insurancerecordid varchar2(96) -- 保险记录编号
    ,guarantyplanno varchar2(96) -- 担保方案编号
    ,clrid varchar2(96) -- 押品编号
    ,insurancestatus varchar2(54) -- 保险状态
    ,insurancecompany varchar2(240) -- 保险公司名称
    ,insurancetype varchar2(18) -- 保险类型
    ,benificiary varchar2(240) -- 保险受益人
    ,insurancepolicyid varchar2(360) -- 保险单号
    ,insuranceamount number(24,6) -- 投保金额
    ,insurancefee number(24,6) -- 保险费
    ,insurancefeerate number(12,8) -- 保险费率
    ,paymentmethod varchar2(18) -- 缴费方式
    ,startdate date -- 保险起始日
    ,enddate date -- 保险到期日
    ,expirydate date -- 保险失效日
    ,expiryreason varchar2(4000) -- 保险失效原因
    ,issuedate date -- 出单日期
    ,isrenewinsurance varchar2(3) -- 续保标志
    ,isneedwarehousing varchar2(3) -- 是否需要入库
    ,inputuserid varchar2(96) -- 登记人
    ,inputorgid varchar2(96) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateuserid varchar2(96) -- 更新人
    ,updateorgid varchar2(96) -- 更新机构
    ,updatedate timestamp -- 更新日期
    ,corporgid varchar2(96) -- 法人机构编号
    ,oldclrid varchar2(3000) -- 合并前押品编号
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,insurancecompanycode varchar2(20) -- 保险公司编号
    ,underwriters1 varchar2(200) -- 核保人名称1
    ,underwriters2 varchar2(200) -- 核保人名称2
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
grant select on ${iol_schema}.icms_clr_insurance_record to ${iml_schema};
grant select on ${iol_schema}.icms_clr_insurance_record to ${icl_schema};
grant select on ${iol_schema}.icms_clr_insurance_record to ${idl_schema};
grant select on ${iol_schema}.icms_clr_insurance_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_insurance_record is '押品保险记录';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancerecordid is '保险记录编号';
comment on column ${iol_schema}.icms_clr_insurance_record.guarantyplanno is '担保方案编号';
comment on column ${iol_schema}.icms_clr_insurance_record.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancestatus is '保险状态';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancecompany is '保险公司名称';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancetype is '保险类型';
comment on column ${iol_schema}.icms_clr_insurance_record.benificiary is '保险受益人';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancepolicyid is '保险单号';
comment on column ${iol_schema}.icms_clr_insurance_record.insuranceamount is '投保金额';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancefee is '保险费';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancefeerate is '保险费率';
comment on column ${iol_schema}.icms_clr_insurance_record.paymentmethod is '缴费方式';
comment on column ${iol_schema}.icms_clr_insurance_record.startdate is '保险起始日';
comment on column ${iol_schema}.icms_clr_insurance_record.enddate is '保险到期日';
comment on column ${iol_schema}.icms_clr_insurance_record.expirydate is '保险失效日';
comment on column ${iol_schema}.icms_clr_insurance_record.expiryreason is '保险失效原因';
comment on column ${iol_schema}.icms_clr_insurance_record.issuedate is '出单日期';
comment on column ${iol_schema}.icms_clr_insurance_record.isrenewinsurance is '续保标志';
comment on column ${iol_schema}.icms_clr_insurance_record.isneedwarehousing is '是否需要入库';
comment on column ${iol_schema}.icms_clr_insurance_record.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_insurance_record.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_insurance_record.inputdate is '登记日期';
comment on column ${iol_schema}.icms_clr_insurance_record.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_insurance_record.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_insurance_record.updatedate is '更新日期';
comment on column ${iol_schema}.icms_clr_insurance_record.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_clr_insurance_record.oldclrid is '合并前押品编号';
comment on column ${iol_schema}.icms_clr_insurance_record.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_insurance_record.insurancecompanycode is '保险公司编号';
comment on column ${iol_schema}.icms_clr_insurance_record.underwriters1 is '核保人名称1';
comment on column ${iol_schema}.icms_clr_insurance_record.underwriters2 is '核保人名称2';
comment on column ${iol_schema}.icms_clr_insurance_record.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_insurance_record.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_insurance_record.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_insurance_record.etl_timestamp is 'ETL处理时间戳';
