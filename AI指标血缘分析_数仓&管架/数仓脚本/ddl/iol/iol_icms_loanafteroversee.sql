/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_loanafteroversee
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_loanafteroversee
whenever sqlerror continue none;
drop table ${iol_schema}.icms_loanafteroversee purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_loanafteroversee(
    serialno varchar2(64) -- 流水号
    ,inspectbasic varchar2(1000) -- 检查要素
    ,overseematurity date -- 监测截止日
    ,manageuserid varchar2(64) -- 主办客户经理
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,putoutdate date -- 出账日期
    ,inputuserid varchar2(64) -- 登记人
    ,approvestatus varchar2(10) -- 审批状态
    ,inputtype varchar2(1) -- 录入类型1：对公贷后录入2：对私贷后录入
    ,updateuserid varchar2(64) -- 更新人编号
    ,objecttype varchar2(64) -- 对象类型，存储各监测类型
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,updateorgid varchar2(64) -- 更新机构编号
    ,exemptiontype varchar2(10) -- 豁免申请类型
    ,manageorgid varchar2(64) -- 主办机构
    ,putoutsum number(24,6) -- 出账金额
    ,isoverdue varchar2(2) -- 是否过期
    ,submitriskmanager varchar2(64) -- 提交风险经理用户编号
    ,customername varchar2(200) -- 客户名称
    ,contractserialno varchar2(64) -- 合同号
    ,customerid varchar2(64) -- 客户编号
    ,overseemonth varchar2(10) -- 监测月份(检查期次)
    ,flag varchar2(10) -- 生成标志010：手工录入020：批量自动生成
    ,currency varchar2(18) -- 币种
    ,certtype varchar2(32) -- 证件类型
    ,migtflag varchar2(80) -- 
    ,curclaifyresult varchar2(10) -- 当前检查五级分类结果
    ,putoutserialno varchar2(64) -- 出账号
    ,finishstatus varchar2(1) -- 完成状态0：过期未完成1：未过期未完成2：已完成
    ,customertype varchar2(10) -- 客户类型
    ,applytype varchar2(10) -- 申请类型:010投贷后020实地030风险监测
    ,curopinion varchar2(800) -- 当前检查业务经办意见
    ,objectno varchar2(64) -- 对象号
    ,docid varchar2(80) -- 填写调查报告的DOCID
    ,inputorgid varchar2(64) -- 登记机构
    ,certid varchar2(60) -- 证件号码
    ,finishdate date -- 完成日期
    ,projectfinancingflag varchar2(10) -- 预测现金流可覆盖借款余额标志
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
grant select on ${iol_schema}.icms_loanafteroversee to ${iml_schema};
grant select on ${iol_schema}.icms_loanafteroversee to ${icl_schema};
grant select on ${iol_schema}.icms_loanafteroversee to ${idl_schema};
grant select on ${iol_schema}.icms_loanafteroversee to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_loanafteroversee is '风险监测申请/投贷后检查申请/实地检查申请';
comment on column ${iol_schema}.icms_loanafteroversee.serialno is '流水号';
comment on column ${iol_schema}.icms_loanafteroversee.inspectbasic is '检查要素';
comment on column ${iol_schema}.icms_loanafteroversee.overseematurity is '监测截止日';
comment on column ${iol_schema}.icms_loanafteroversee.manageuserid is '主办客户经理';
comment on column ${iol_schema}.icms_loanafteroversee.inputdate is '登记日期';
comment on column ${iol_schema}.icms_loanafteroversee.updatedate is '更新日期';
comment on column ${iol_schema}.icms_loanafteroversee.putoutdate is '出账日期';
comment on column ${iol_schema}.icms_loanafteroversee.inputuserid is '登记人';
comment on column ${iol_schema}.icms_loanafteroversee.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_loanafteroversee.inputtype is '录入类型1：对公贷后录入2：对私贷后录入';
comment on column ${iol_schema}.icms_loanafteroversee.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_loanafteroversee.objecttype is '对象类型，存储各监测类型';
comment on column ${iol_schema}.icms_loanafteroversee.isinuse is '添加维护标志1正常2不维护';
comment on column ${iol_schema}.icms_loanafteroversee.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_loanafteroversee.exemptiontype is '豁免申请类型';
comment on column ${iol_schema}.icms_loanafteroversee.manageorgid is '主办机构';
comment on column ${iol_schema}.icms_loanafteroversee.putoutsum is '出账金额';
comment on column ${iol_schema}.icms_loanafteroversee.isoverdue is '是否过期';
comment on column ${iol_schema}.icms_loanafteroversee.submitriskmanager is '提交风险经理用户编号';
comment on column ${iol_schema}.icms_loanafteroversee.customername is '客户名称';
comment on column ${iol_schema}.icms_loanafteroversee.contractserialno is '合同号';
comment on column ${iol_schema}.icms_loanafteroversee.customerid is '客户编号';
comment on column ${iol_schema}.icms_loanafteroversee.overseemonth is '监测月份(检查期次)';
comment on column ${iol_schema}.icms_loanafteroversee.flag is '生成标志010：手工录入020：批量自动生成';
comment on column ${iol_schema}.icms_loanafteroversee.currency is '币种';
comment on column ${iol_schema}.icms_loanafteroversee.certtype is '证件类型';
comment on column ${iol_schema}.icms_loanafteroversee.migtflag is '';
comment on column ${iol_schema}.icms_loanafteroversee.curclaifyresult is '当前检查五级分类结果';
comment on column ${iol_schema}.icms_loanafteroversee.putoutserialno is '出账号';
comment on column ${iol_schema}.icms_loanafteroversee.finishstatus is '完成状态0：过期未完成1：未过期未完成2：已完成';
comment on column ${iol_schema}.icms_loanafteroversee.customertype is '客户类型';
comment on column ${iol_schema}.icms_loanafteroversee.applytype is '申请类型:010投贷后020实地030风险监测';
comment on column ${iol_schema}.icms_loanafteroversee.curopinion is '当前检查业务经办意见';
comment on column ${iol_schema}.icms_loanafteroversee.objectno is '对象号';
comment on column ${iol_schema}.icms_loanafteroversee.docid is '填写调查报告的DOCID';
comment on column ${iol_schema}.icms_loanafteroversee.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_loanafteroversee.certid is '证件号码';
comment on column ${iol_schema}.icms_loanafteroversee.finishdate is '完成日期';
comment on column ${iol_schema}.icms_loanafteroversee.projectfinancingflag is '预测现金流可覆盖借款余额标志';
comment on column ${iol_schema}.icms_loanafteroversee.start_dt is '开始时间';
comment on column ${iol_schema}.icms_loanafteroversee.end_dt is '结束时间';
comment on column ${iol_schema}.icms_loanafteroversee.id_mark is '增删标志';
comment on column ${iol_schema}.icms_loanafteroversee.etl_timestamp is 'ETL处理时间戳';
