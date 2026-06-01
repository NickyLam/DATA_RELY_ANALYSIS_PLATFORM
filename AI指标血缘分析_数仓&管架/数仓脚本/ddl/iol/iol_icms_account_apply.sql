/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_account_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_account_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_account_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_account_apply(
    serialno varchar2(32) -- 申请流水号
    ,applyexpain varchar2(600) -- 提前还款说明
    ,inputuserid varchar2(32) -- 录入人
    ,payaccountno varchar2(50) -- 账户编号
    ,isdomeassetstype varchar2(2) -- 是否境内资产转让
    ,boughtsum number(24,6) -- 卖出金额
    ,tradecustomer varchar2(80) -- 交易对手
    ,inputdate date -- 录入日期
    ,accounttype varchar2(2) -- 提前还款类型
    ,businesscurrency varchar2(32) -- 币种
    ,balance number(24,6) -- 借据余额
    ,flag varchar2(2) -- 状态
    ,newdate number(24,0) -- 新期数
    ,removeorderno varchar2(40) -- 退保单号
    ,inputorgid varchar2(32) -- 录入机构
    ,interestamt number(24,6) -- 清收金额
    ,importcharges number(24,6) -- 汇入手续费
    ,duebillno varchar2(40) -- 借据流水号
    ,liquidatedsum number(24,6) -- 违约金
    ,saleratio varchar2(20) -- 卖出利率
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,advancerepaytype varchar2(10) -- 提前还款类型
    ,businesssum number(24,6) -- 借据金额
    ,repaymentno varchar2(32) -- 还款编号
    ,customerid varchar2(32) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,repaytype varchar2(20) -- 还款类型
    ,putoutno varchar2(40) -- 出账号
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
grant select on ${iol_schema}.icms_account_apply to ${iml_schema};
grant select on ${iol_schema}.icms_account_apply to ${icl_schema};
grant select on ${iol_schema}.icms_account_apply to ${idl_schema};
grant select on ${iol_schema}.icms_account_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_account_apply is '提前还款申请表';
comment on column ${iol_schema}.icms_account_apply.serialno is '申请流水号';
comment on column ${iol_schema}.icms_account_apply.applyexpain is '提前还款说明';
comment on column ${iol_schema}.icms_account_apply.inputuserid is '录入人';
comment on column ${iol_schema}.icms_account_apply.payaccountno is '账户编号';
comment on column ${iol_schema}.icms_account_apply.isdomeassetstype is '是否境内资产转让';
comment on column ${iol_schema}.icms_account_apply.boughtsum is '卖出金额';
comment on column ${iol_schema}.icms_account_apply.tradecustomer is '交易对手';
comment on column ${iol_schema}.icms_account_apply.inputdate is '录入日期';
comment on column ${iol_schema}.icms_account_apply.accounttype is '提前还款类型';
comment on column ${iol_schema}.icms_account_apply.businesscurrency is '币种';
comment on column ${iol_schema}.icms_account_apply.balance is '借据余额';
comment on column ${iol_schema}.icms_account_apply.flag is '状态';
comment on column ${iol_schema}.icms_account_apply.newdate is '新期数';
comment on column ${iol_schema}.icms_account_apply.removeorderno is '退保单号';
comment on column ${iol_schema}.icms_account_apply.inputorgid is '录入机构';
comment on column ${iol_schema}.icms_account_apply.interestamt is '清收金额';
comment on column ${iol_schema}.icms_account_apply.importcharges is '汇入手续费';
comment on column ${iol_schema}.icms_account_apply.duebillno is '借据流水号';
comment on column ${iol_schema}.icms_account_apply.liquidatedsum is '违约金';
comment on column ${iol_schema}.icms_account_apply.saleratio is '卖出利率';
comment on column ${iol_schema}.icms_account_apply.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_account_apply.advancerepaytype is '提前还款类型';
comment on column ${iol_schema}.icms_account_apply.businesssum is '借据金额';
comment on column ${iol_schema}.icms_account_apply.repaymentno is '还款编号';
comment on column ${iol_schema}.icms_account_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_account_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_account_apply.repaytype is '还款类型';
comment on column ${iol_schema}.icms_account_apply.putoutno is '出账号';
comment on column ${iol_schema}.icms_account_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_account_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_account_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_account_apply.etl_timestamp is 'ETL处理时间戳';
