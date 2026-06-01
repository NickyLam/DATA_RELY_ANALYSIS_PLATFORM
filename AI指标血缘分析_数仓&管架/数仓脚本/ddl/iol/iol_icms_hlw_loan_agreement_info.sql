/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hlw_loan_agreement_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hlw_loan_agreement_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hlw_loan_agreement_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hlw_loan_agreement_info(
    serialno varchar2(32) -- 流水号
    ,productid varchar2(200) -- 产品编号
    ,productname varchar2(1000) -- 产品名称
    ,belongorgid varchar2(1000) -- 所属机构
    ,agreementno varchar2(200) -- 合作协议编号
    ,ismainagreement varchar2(10) -- 是否属于主协议
    ,mainagreementno varchar2(200) -- 对应的主合作协议编号
    ,cooperatename varchar2(200) -- 合作方名称
    ,cooperatecerttype varchar2(10) -- 合作方证件类型
    ,cooperatecertid varchar2(64) -- 合作方证件号码
    ,cooperatetype varchar2(10) -- 合作方类型
    ,cooperatemethod varchar2(200) -- 合作方式
    ,providecreditmodel varchar2(200) -- 提供增信的模式
    ,cooperateregisteraddress varchar2(500) -- 合作方注册地行政区划
    ,startdate varchar2(20) -- 合作协议起始日期
    ,maturitydate varchar2(20) -- 合作协议到期日期
    ,actualmaturitydate varchar2(20) -- 合作协议实际终止日期
    ,limitflag varchar2(10) -- 限制标识
    ,cooperatestatus varchar2(10) -- 协议状态
    ,operationtype varchar2(6) -- 数据操作类型:01-新增02-编辑
    ,oldserialno varchar2(32) -- 原数据流水号
    ,datastatus varchar2(32) -- 数据状态：01-启用；02-停用
    ,approvestatus varchar2(64) -- 流程状态
    ,inputuserid varchar2(16) -- 登记人
    ,inputorgid varchar2(16) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(16) -- 更新人
    ,updateorgid varchar2(16) -- 更新机构
    ,updatedate date -- 更新时间
    ,investmentprop number(24,6) -- 对我行出资部分进行担保的比例
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
grant select on ${iol_schema}.icms_hlw_loan_agreement_info to ${iml_schema};
grant select on ${iol_schema}.icms_hlw_loan_agreement_info to ${icl_schema};
grant select on ${iol_schema}.icms_hlw_loan_agreement_info to ${idl_schema};
grant select on ${iol_schema}.icms_hlw_loan_agreement_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hlw_loan_agreement_info is '互联网贷款产品合作协议信息表';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.serialno is '流水号';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.productid is '产品编号';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.productname is '产品名称';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.belongorgid is '所属机构';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.agreementno is '合作协议编号';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.ismainagreement is '是否属于主协议';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.mainagreementno is '对应的主合作协议编号';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatename is '合作方名称';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatecerttype is '合作方证件类型';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatecertid is '合作方证件号码';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatetype is '合作方类型';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatemethod is '合作方式';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.providecreditmodel is '提供增信的模式';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperateregisteraddress is '合作方注册地行政区划';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.startdate is '合作协议起始日期';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.maturitydate is '合作协议到期日期';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.actualmaturitydate is '合作协议实际终止日期';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.limitflag is '限制标识';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.cooperatestatus is '协议状态';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.operationtype is '数据操作类型:01-新增02-编辑';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.oldserialno is '原数据流水号';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.datastatus is '数据状态：01-启用；02-停用';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.approvestatus is '流程状态';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.investmentprop is '对我行出资部分进行担保的比例';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_hlw_loan_agreement_info.etl_timestamp is 'ETL处理时间戳';
