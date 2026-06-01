/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_customer_ent
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_customer_ent
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_customer_ent purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_customer_ent(
    serialno varchar2(64) -- 流水号
    ,relacustomerid varchar2(16) -- 关联客户编号
    ,corpname varchar2(200) -- 企业名称
    ,corpsocialcode varchar2(50) -- 统一社会信用代码
    ,industrytype varchar2(10) -- 所属行业类型
    ,corpstatus varchar2(10) -- 企业状态
    ,customertype varchar2(10) -- 客户属性
    ,managerrole varchar2(10) -- 经营者身份
    ,setupdate date -- 企业成立日期
    ,fictitiousperson varchar2(50) -- 法定代表人
    ,registeradd varchar2(400) -- 注册地址
    ,shareholdingratio varchar2(10) -- 持股占比
    ,licensebegin date -- 证照起始日期
    ,licensematurity date -- 证照有效期至
    ,registerregion varchar2(400) -- 注册地省市区
    ,registeramount number(24,6) -- 注册资本
    ,paidamount number(24,6) -- 实收资本
    ,employeenumber number(10,0) -- 企业员工人数
    ,enttype varchar2(20) -- 企业类型
    ,currency varchar2(3) -- 币种
    ,businessyear number(22,0) -- 实际经营年限
    ,businessscope varchar2(3000) -- 经营范围
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
grant select on ${iol_schema}.icms_lhwd_customer_ent to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_customer_ent to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_ent to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_customer_ent to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_customer_ent is '联合网贷客户关联企业基本信息表';
comment on column ${iol_schema}.icms_lhwd_customer_ent.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_customer_ent.relacustomerid is '关联客户编号';
comment on column ${iol_schema}.icms_lhwd_customer_ent.corpname is '企业名称';
comment on column ${iol_schema}.icms_lhwd_customer_ent.corpsocialcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_lhwd_customer_ent.industrytype is '所属行业类型';
comment on column ${iol_schema}.icms_lhwd_customer_ent.corpstatus is '企业状态';
comment on column ${iol_schema}.icms_lhwd_customer_ent.customertype is '客户属性';
comment on column ${iol_schema}.icms_lhwd_customer_ent.managerrole is '经营者身份';
comment on column ${iol_schema}.icms_lhwd_customer_ent.setupdate is '企业成立日期';
comment on column ${iol_schema}.icms_lhwd_customer_ent.fictitiousperson is '法定代表人';
comment on column ${iol_schema}.icms_lhwd_customer_ent.registeradd is '注册地址';
comment on column ${iol_schema}.icms_lhwd_customer_ent.shareholdingratio is '持股占比';
comment on column ${iol_schema}.icms_lhwd_customer_ent.licensebegin is '证照起始日期';
comment on column ${iol_schema}.icms_lhwd_customer_ent.licensematurity is '证照有效期至';
comment on column ${iol_schema}.icms_lhwd_customer_ent.registerregion is '注册地省市区';
comment on column ${iol_schema}.icms_lhwd_customer_ent.registeramount is '注册资本';
comment on column ${iol_schema}.icms_lhwd_customer_ent.paidamount is '实收资本';
comment on column ${iol_schema}.icms_lhwd_customer_ent.employeenumber is '企业员工人数';
comment on column ${iol_schema}.icms_lhwd_customer_ent.enttype is '企业类型';
comment on column ${iol_schema}.icms_lhwd_customer_ent.currency is '币种';
comment on column ${iol_schema}.icms_lhwd_customer_ent.businessyear is '实际经营年限';
comment on column ${iol_schema}.icms_lhwd_customer_ent.businessscope is '经营范围';
comment on column ${iol_schema}.icms_lhwd_customer_ent.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_customer_ent.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_customer_ent.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_customer_ent.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lhwd_customer_ent.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_customer_ent.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_customer_ent.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_customer_ent.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_customer_ent.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_customer_ent.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_customer_ent.etl_timestamp is 'ETL处理时间戳';
