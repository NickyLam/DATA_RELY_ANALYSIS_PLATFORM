/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_repayment_plan_info
CreateDate: 20250509
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_repayment_plan_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_repayment_plan_info(
etl_dt date --数据日期
,duebillserialno varchar2(40) --借据流水号
,dateno number(24,6) --期号
,penaltyinterest number(24,6) --实还罚息
,paymenttype varchar2(16) --还款方式
,unpaidsum number(24,6) --本期剩余本金
,businessrate number(15,8) --执行利率
,businesscurrency varchar2(3) --币种
,enddate date --终止日期
,flag varchar2(2) --处理标志（0-已执行1-未执行）
,actualsum number(24,6) --实还本金
,actualinterest number(24,6) --实还利息
,compoundinterest number(24,6) --实还复息
,normalsum number(24,6) --正常本金
,periodinterestsum number(24,6) --本期应收利息
,executiondate date --结清日期
,periodsum number(24,6) --本期应收本金
,discountsum number(24,6) --其中贴息金额
,startdate date --起始日期
,putoutunpaidsum number(24,6) --借据剩余贷款本金
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,schedamt number(24,6) --每期还款总额
,intaccrued number(17,2) --应计利息
,odpaccrued number(17,2) --应计罚息
,odiaccrued number(17,2) --应计复利
,odpoutstanding number(17,2) --应收罚息
,odioutstanding number(17,2) --应收复利
,ysintamt number(24,6) --应收欠息
,remark varchar2(600) --备注
,gracedate date --宽限日期
,respaidintamt number(24,6) --剩余应还利息

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_repayment_plan_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_repayment_plan_info is '借据还款计划信息';
comment on column ${idl_schema}.icms_repayment_plan_info.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_repayment_plan_info.duebillserialno is '借据流水号';
comment on column ${idl_schema}.icms_repayment_plan_info.dateno is '期号';
comment on column ${idl_schema}.icms_repayment_plan_info.penaltyinterest is '实还罚息';
comment on column ${idl_schema}.icms_repayment_plan_info.paymenttype is '还款方式';
comment on column ${idl_schema}.icms_repayment_plan_info.unpaidsum is '本期剩余本金';
comment on column ${idl_schema}.icms_repayment_plan_info.businessrate is '执行利率';
comment on column ${idl_schema}.icms_repayment_plan_info.businesscurrency is '币种';
comment on column ${idl_schema}.icms_repayment_plan_info.enddate is '终止日期';
comment on column ${idl_schema}.icms_repayment_plan_info.flag is '处理标志（0-已执行1-未执行）';
comment on column ${idl_schema}.icms_repayment_plan_info.actualsum is '实还本金';
comment on column ${idl_schema}.icms_repayment_plan_info.actualinterest is '实还利息';
comment on column ${idl_schema}.icms_repayment_plan_info.compoundinterest is '实还复息';
comment on column ${idl_schema}.icms_repayment_plan_info.normalsum is '正常本金';
comment on column ${idl_schema}.icms_repayment_plan_info.periodinterestsum is '本期应收利息';
comment on column ${idl_schema}.icms_repayment_plan_info.executiondate is '结清日期';
comment on column ${idl_schema}.icms_repayment_plan_info.periodsum is '本期应收本金';
comment on column ${idl_schema}.icms_repayment_plan_info.discountsum is '其中贴息金额';
comment on column ${idl_schema}.icms_repayment_plan_info.startdate is '起始日期';
comment on column ${idl_schema}.icms_repayment_plan_info.putoutunpaidsum is '借据剩余贷款本金';
comment on column ${idl_schema}.icms_repayment_plan_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_repayment_plan_info.schedamt is '每期还款总额';
comment on column ${idl_schema}.icms_repayment_plan_info.intaccrued is '应计利息';
comment on column ${idl_schema}.icms_repayment_plan_info.odpaccrued is '应计罚息';
comment on column ${idl_schema}.icms_repayment_plan_info.odiaccrued is '应计复利';
comment on column ${idl_schema}.icms_repayment_plan_info.odpoutstanding is '应收罚息';
comment on column ${idl_schema}.icms_repayment_plan_info.odioutstanding is '应收复利';
comment on column ${idl_schema}.icms_repayment_plan_info.ysintamt is '应收欠息';
comment on column ${idl_schema}.icms_repayment_plan_info.remark is '备注';
comment on column ${idl_schema}.icms_repayment_plan_info.gracedate is '宽限日期';
comment on column ${idl_schema}.icms_repayment_plan_info.respaidintamt is '剩余应还利息';

