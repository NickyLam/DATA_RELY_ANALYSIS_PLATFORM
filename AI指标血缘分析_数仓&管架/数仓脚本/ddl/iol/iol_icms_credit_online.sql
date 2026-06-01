/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_online
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_online
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_online purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_online(
    applyserialno varchar2(32) -- 授信申请流水号
    ,gylsubtype varchar2(10) -- 供应链子类型，码值GYLSubType
    ,migtflag varchar2(80) -- 
    ,channel varchar2(10) -- 渠道
    ,inputuser varchar2(32) -- 登记人
    ,artificialno varchar2(200) -- 文本合同编号
    ,businesssum number(22,4) -- 申请金额
    ,maturity varchar2(10) -- 额度结束日期
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,israise varchar2(10) -- 是否提额，码值IsRaise
    ,businesstype varchar2(40) -- 业务品种
    ,modelresult varchar2(4000) -- 零售内评风控策略JSON结果
    ,status varchar2(1) -- 状态
    ,inputorg varchar2(32) -- 登记机构
    ,isnotice varchar2(1) -- 是否回调通知（1是2否）
    ,isverify varchar2(10) -- 是否核验通过，码值YesNo
    ,phaseno varchar2(10) -- 审批阶段（0100失败1000成功）
    ,applyseqnum varchar2(32) -- 授信申请接口流水号
    ,interfacecode varchar2(20) -- 回调交易码
    ,contractserialno varchar2(32) -- 合同流水号
    ,customerid varchar2(40) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,isbreakheadauth varchar2(10) -- 是否突破总部权限，码值YesNo
    ,putoutdate varchar2(10) -- 额度开始日期
    ,approveserialno varchar2(40) -- 批复流水号
    ,inputtime varchar2(32) -- 登记时间
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
grant select on ${iol_schema}.icms_credit_online to ${iml_schema};
grant select on ${iol_schema}.icms_credit_online to ${icl_schema};
grant select on ${iol_schema}.icms_credit_online to ${idl_schema};
grant select on ${iol_schema}.icms_credit_online to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_online is '线上贷款';
comment on column ${iol_schema}.icms_credit_online.applyserialno is '授信申请流水号';
comment on column ${iol_schema}.icms_credit_online.gylsubtype is '供应链子类型，码值GYLSubType';
comment on column ${iol_schema}.icms_credit_online.migtflag is '';
comment on column ${iol_schema}.icms_credit_online.channel is '渠道';
comment on column ${iol_schema}.icms_credit_online.inputuser is '登记人';
comment on column ${iol_schema}.icms_credit_online.artificialno is '文本合同编号';
comment on column ${iol_schema}.icms_credit_online.businesssum is '申请金额';
comment on column ${iol_schema}.icms_credit_online.maturity is '额度结束日期';
comment on column ${iol_schema}.icms_credit_online.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_credit_online.israise is '是否提额，码值IsRaise';
comment on column ${iol_schema}.icms_credit_online.businesstype is '业务品种';
comment on column ${iol_schema}.icms_credit_online.modelresult is '零售内评风控策略JSON结果';
comment on column ${iol_schema}.icms_credit_online.status is '状态';
comment on column ${iol_schema}.icms_credit_online.inputorg is '登记机构';
comment on column ${iol_schema}.icms_credit_online.isnotice is '是否回调通知（1是2否）';
comment on column ${iol_schema}.icms_credit_online.isverify is '是否核验通过，码值YesNo';
comment on column ${iol_schema}.icms_credit_online.phaseno is '审批阶段（0100失败1000成功）';
comment on column ${iol_schema}.icms_credit_online.applyseqnum is '授信申请接口流水号';
comment on column ${iol_schema}.icms_credit_online.interfacecode is '回调交易码';
comment on column ${iol_schema}.icms_credit_online.contractserialno is '合同流水号';
comment on column ${iol_schema}.icms_credit_online.customerid is '客户编号';
comment on column ${iol_schema}.icms_credit_online.customername is '客户名称';
comment on column ${iol_schema}.icms_credit_online.isbreakheadauth is '是否突破总部权限，码值YesNo';
comment on column ${iol_schema}.icms_credit_online.putoutdate is '额度开始日期';
comment on column ${iol_schema}.icms_credit_online.approveserialno is '批复流水号';
comment on column ${iol_schema}.icms_credit_online.inputtime is '登记时间';
comment on column ${iol_schema}.icms_credit_online.start_dt is '开始时间';
comment on column ${iol_schema}.icms_credit_online.end_dt is '结束时间';
comment on column ${iol_schema}.icms_credit_online.id_mark is '增删标志';
comment on column ${iol_schema}.icms_credit_online.etl_timestamp is 'ETL处理时间戳';
