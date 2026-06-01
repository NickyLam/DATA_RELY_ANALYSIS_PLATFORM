/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_contract_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_contract_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_contract_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_contract_info(
    contractno varchar2(64) -- 合同流水号
    ,operateuserid varchar2(64) -- 主办机构编号
    ,overdueratefloat number(12,8) -- 逾期利率浮动比例
    ,assetno varchar2(64) -- 资产编号
    ,outbalance number(24,6) -- 表外利息余额
    ,classifyresult varchar2(36) -- 风险分类
    ,operateorgid varchar2(64) -- 主办客户经理编号
    ,begindate date -- 合同起始日
    ,rateadjusttype varchar2(36) -- 利率调整方式
    ,signdate date -- 合同签订日
    ,approvedate varchar2(64) -- 审批通过日
    ,inputuserid varchar2(64) -- 登记人
    ,repaytype varchar2(36) -- 还款方式
    ,interestoverdueday number(22) -- 欠息天数
    ,deleteflag varchar2(12) -- 删除标志
    ,certtype varchar2(4) -- 证件类型
    ,interestdate number(22) -- 结息扣款日
    ,resourcesystem varchar2(36) -- 来源系统
    ,customername varchar2(200) -- 客户名称
    ,currency varchar2(3) -- 币种
    ,repayno varchar2(64) -- 还款账号
    ,principaloverdueday number(22) -- 本金逾期天数
    ,updateorgid varchar2(64) -- 更新机构
    ,interestcyc varchar2(64) -- 结息周期
    ,ratefloattype varchar2(36) -- 利率浮动类型
    ,ratefloat number(12,8) -- 利率浮动值
    ,cooperateuserid varchar2(64) -- 协办客户经理编号
    ,writeoffflag varchar2(36) -- 核销状态
    ,balance number(24,6) -- 合同余额
    ,cooperateorgid varchar2(64) -- 协办机构编号
    ,mforgid varchar2(64) -- 入账机构编号
    ,onbalance number(24,6) -- 表内利息余额
    ,newnpdate date -- 最新进入不良日期
    ,expiredate date -- 合同到期日
    ,wrightoffbalance number(24,6) -- 核销当日欠息
    ,tmsp varchar2(64) -- 时间戳
    ,inputdate date -- 登记日期
    ,certid varchar2(60) -- 证件号码
    ,businesstype varchar2(64) -- 业务品种编号
    ,cooperateusername varchar2(160) -- 协办客户经理名称
    ,inputorgid varchar2(64) -- 登记机构
    ,assetname varchar2(1000) -- 资产名称
    ,updateuserid varchar2(64) -- 更新人
    ,updatedate date -- 更新日期
    ,customerid varchar2(16) -- 客户号
    ,businesssum number(24,6) -- 合同金额
    ,yearrate number(12,8) -- 执行年利率
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
grant select on ${iol_schema}.icms_ap_contract_info to ${iml_schema};
grant select on ${iol_schema}.icms_ap_contract_info to ${icl_schema};
grant select on ${iol_schema}.icms_ap_contract_info to ${idl_schema};
grant select on ${iol_schema}.icms_ap_contract_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_contract_info is '问题资产合同信息表';
comment on column ${iol_schema}.icms_ap_contract_info.contractno is '合同流水号';
comment on column ${iol_schema}.icms_ap_contract_info.operateuserid is '主办机构编号';
comment on column ${iol_schema}.icms_ap_contract_info.overdueratefloat is '逾期利率浮动比例';
comment on column ${iol_schema}.icms_ap_contract_info.assetno is '资产编号';
comment on column ${iol_schema}.icms_ap_contract_info.outbalance is '表外利息余额';
comment on column ${iol_schema}.icms_ap_contract_info.classifyresult is '风险分类';
comment on column ${iol_schema}.icms_ap_contract_info.operateorgid is '主办客户经理编号';
comment on column ${iol_schema}.icms_ap_contract_info.begindate is '合同起始日';
comment on column ${iol_schema}.icms_ap_contract_info.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_ap_contract_info.signdate is '合同签订日';
comment on column ${iol_schema}.icms_ap_contract_info.approvedate is '审批通过日';
comment on column ${iol_schema}.icms_ap_contract_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ap_contract_info.repaytype is '还款方式';
comment on column ${iol_schema}.icms_ap_contract_info.interestoverdueday is '欠息天数';
comment on column ${iol_schema}.icms_ap_contract_info.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_contract_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_ap_contract_info.interestdate is '结息扣款日';
comment on column ${iol_schema}.icms_ap_contract_info.resourcesystem is '来源系统';
comment on column ${iol_schema}.icms_ap_contract_info.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_contract_info.currency is '币种';
comment on column ${iol_schema}.icms_ap_contract_info.repayno is '还款账号';
comment on column ${iol_schema}.icms_ap_contract_info.principaloverdueday is '本金逾期天数';
comment on column ${iol_schema}.icms_ap_contract_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ap_contract_info.interestcyc is '结息周期';
comment on column ${iol_schema}.icms_ap_contract_info.ratefloattype is '利率浮动类型';
comment on column ${iol_schema}.icms_ap_contract_info.ratefloat is '利率浮动值';
comment on column ${iol_schema}.icms_ap_contract_info.cooperateuserid is '协办客户经理编号';
comment on column ${iol_schema}.icms_ap_contract_info.writeoffflag is '核销状态';
comment on column ${iol_schema}.icms_ap_contract_info.balance is '合同余额';
comment on column ${iol_schema}.icms_ap_contract_info.cooperateorgid is '协办机构编号';
comment on column ${iol_schema}.icms_ap_contract_info.mforgid is '入账机构编号';
comment on column ${iol_schema}.icms_ap_contract_info.onbalance is '表内利息余额';
comment on column ${iol_schema}.icms_ap_contract_info.newnpdate is '最新进入不良日期';
comment on column ${iol_schema}.icms_ap_contract_info.expiredate is '合同到期日';
comment on column ${iol_schema}.icms_ap_contract_info.wrightoffbalance is '核销当日欠息';
comment on column ${iol_schema}.icms_ap_contract_info.tmsp is '时间戳';
comment on column ${iol_schema}.icms_ap_contract_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ap_contract_info.certid is '证件号码';
comment on column ${iol_schema}.icms_ap_contract_info.businesstype is '业务品种编号';
comment on column ${iol_schema}.icms_ap_contract_info.cooperateusername is '协办客户经理名称';
comment on column ${iol_schema}.icms_ap_contract_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ap_contract_info.assetname is '资产名称';
comment on column ${iol_schema}.icms_ap_contract_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ap_contract_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ap_contract_info.customerid is '客户号';
comment on column ${iol_schema}.icms_ap_contract_info.businesssum is '合同金额';
comment on column ${iol_schema}.icms_ap_contract_info.yearrate is '执行年利率';
comment on column ${iol_schema}.icms_ap_contract_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_contract_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_contract_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_contract_info.etl_timestamp is 'ETL处理时间戳';
