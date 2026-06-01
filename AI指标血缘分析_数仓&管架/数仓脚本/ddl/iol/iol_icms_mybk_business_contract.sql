/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_business_contract(
    serialno varchar2(30) -- 合同编号
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,businessflag varchar2(6) -- 额度/业务标志
    ,applytype varchar2(64) -- 申请类型
    ,occurdate date -- 签订日期
    ,currency varchar2(3) -- 额度/业务币种
    ,businesssum number(24,6) -- 合同金额
    ,putoutsum number(24,6) -- 实际放款金额
    ,putoutdate date -- 放款日期
    ,productid varchar2(32) -- 产品编号
    ,productclassify varchar2(36) -- 产品所属大类
    ,termmonth number(38,0) -- 期限(月)
    ,startdate date -- 合同开始日期
    ,maturity date -- 合同到期日期
    ,baseratetype varchar2(5) -- 基准利率类型
    ,rateadjusttype varchar2(4) -- 利率调整方式
    ,vouchtype varchar2(1) -- 主担保方式
    ,othervouchtype varchar2(32) -- 其他担保方式
    ,repaytype varchar2(4) -- 还款方式
    ,repaydate number(38,0) -- 指定还款日
    ,purpose varchar2(1000) -- 用途
    ,balance number(24,6) -- 合同贷款余额
    ,status varchar2(48) -- 合同状态
    ,finishdate date -- 终结日期
    ,approvestatus varchar2(64) -- 审批状态
    ,operateuserid varchar2(8) -- 业务经办人编号
    ,operateorgid varchar2(64) -- 经办机构
    ,operatedate date -- 经办日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,loanusetype varchar2(6) -- 贷款用途
    ,loanaccountname varchar2(160) -- 贷款入账(收款账户)账户名
    ,loanaccountorgid varchar2(64) -- 贷款入账(收款账户)账户开户机构
    ,effectdate date -- 合同签订日期
    ,executerate number(15,8) -- 执行利率
    ,baserialno varchar2(64) -- 授信申请流水号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
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
grant select on ${iol_schema}.icms_mybk_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_business_contract is '网商贷合同表';
comment on column ${iol_schema}.icms_mybk_business_contract.serialno is '合同编号';
comment on column ${iol_schema}.icms_mybk_business_contract.customerid is '客户编号';
comment on column ${iol_schema}.icms_mybk_business_contract.customername is '客户名称';
comment on column ${iol_schema}.icms_mybk_business_contract.businessflag is '额度/业务标志';
comment on column ${iol_schema}.icms_mybk_business_contract.applytype is '申请类型';
comment on column ${iol_schema}.icms_mybk_business_contract.occurdate is '签订日期';
comment on column ${iol_schema}.icms_mybk_business_contract.currency is '额度/业务币种';
comment on column ${iol_schema}.icms_mybk_business_contract.businesssum is '合同金额';
comment on column ${iol_schema}.icms_mybk_business_contract.putoutsum is '实际放款金额';
comment on column ${iol_schema}.icms_mybk_business_contract.putoutdate is '放款日期';
comment on column ${iol_schema}.icms_mybk_business_contract.productid is '产品编号';
comment on column ${iol_schema}.icms_mybk_business_contract.productclassify is '产品所属大类';
comment on column ${iol_schema}.icms_mybk_business_contract.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_mybk_business_contract.startdate is '合同开始日期';
comment on column ${iol_schema}.icms_mybk_business_contract.maturity is '合同到期日期';
comment on column ${iol_schema}.icms_mybk_business_contract.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_mybk_business_contract.rateadjusttype is '利率调整方式';
comment on column ${iol_schema}.icms_mybk_business_contract.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_mybk_business_contract.othervouchtype is '其他担保方式';
comment on column ${iol_schema}.icms_mybk_business_contract.repaytype is '还款方式';
comment on column ${iol_schema}.icms_mybk_business_contract.repaydate is '指定还款日';
comment on column ${iol_schema}.icms_mybk_business_contract.purpose is '用途';
comment on column ${iol_schema}.icms_mybk_business_contract.balance is '合同贷款余额';
comment on column ${iol_schema}.icms_mybk_business_contract.status is '合同状态';
comment on column ${iol_schema}.icms_mybk_business_contract.finishdate is '终结日期';
comment on column ${iol_schema}.icms_mybk_business_contract.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_mybk_business_contract.operateuserid is '业务经办人编号';
comment on column ${iol_schema}.icms_mybk_business_contract.operateorgid is '经办机构';
comment on column ${iol_schema}.icms_mybk_business_contract.operatedate is '经办日期';
comment on column ${iol_schema}.icms_mybk_business_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_mybk_business_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_mybk_business_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybk_business_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_mybk_business_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_mybk_business_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_mybk_business_contract.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_mybk_business_contract.loanaccountname is '贷款入账(收款账户)账户名';
comment on column ${iol_schema}.icms_mybk_business_contract.loanaccountorgid is '贷款入账(收款账户)账户开户机构';
comment on column ${iol_schema}.icms_mybk_business_contract.effectdate is '合同签订日期';
comment on column ${iol_schema}.icms_mybk_business_contract.executerate is '执行利率';
comment on column ${iol_schema}.icms_mybk_business_contract.baserialno is '授信申请流水号';
comment on column ${iol_schema}.icms_mybk_business_contract.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_mybk_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_business_contract.etl_timestamp is 'ETL处理时间戳';
