/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ap_repayment_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ap_repayment_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ap_repayment_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_repayment_plan(
    serialno varchar2(64) -- 流水号
    ,repayperiod number(22) -- 期次
    ,plandetailno varchar2(64) -- 明细编号
    ,interestamount number(24,6) -- 拟还利息金额元）
    ,repaydate date -- 计划还款日期
    ,customername varchar2(200) -- 客户名称
    ,deleteflag varchar2(12) -- 删除标志
    ,feeamount number(24,6) -- 拟还费用金额元）
    ,customerid varchar2(16) -- 客户ID
    ,repaytype varchar2(2) -- 还款类型
    ,amountsum number(24,6) -- 拟还款合计金额元）
    ,amount number(24,6) -- 拟还本金金额元）
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
grant select on ${iol_schema}.icms_ap_repayment_plan to ${iml_schema};
grant select on ${iol_schema}.icms_ap_repayment_plan to ${icl_schema};
grant select on ${iol_schema}.icms_ap_repayment_plan to ${idl_schema};
grant select on ${iol_schema}.icms_ap_repayment_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ap_repayment_plan is '方案还款表';
comment on column ${iol_schema}.icms_ap_repayment_plan.serialno is '流水号';
comment on column ${iol_schema}.icms_ap_repayment_plan.repayperiod is '期次';
comment on column ${iol_schema}.icms_ap_repayment_plan.plandetailno is '明细编号';
comment on column ${iol_schema}.icms_ap_repayment_plan.interestamount is '拟还利息金额元）';
comment on column ${iol_schema}.icms_ap_repayment_plan.repaydate is '计划还款日期';
comment on column ${iol_schema}.icms_ap_repayment_plan.customername is '客户名称';
comment on column ${iol_schema}.icms_ap_repayment_plan.deleteflag is '删除标志';
comment on column ${iol_schema}.icms_ap_repayment_plan.feeamount is '拟还费用金额元）';
comment on column ${iol_schema}.icms_ap_repayment_plan.customerid is '客户ID';
comment on column ${iol_schema}.icms_ap_repayment_plan.repaytype is '还款类型';
comment on column ${iol_schema}.icms_ap_repayment_plan.amountsum is '拟还款合计金额元）';
comment on column ${iol_schema}.icms_ap_repayment_plan.amount is '拟还本金金额元）';
comment on column ${iol_schema}.icms_ap_repayment_plan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ap_repayment_plan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ap_repayment_plan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ap_repayment_plan.etl_timestamp is 'ETL处理时间戳';
