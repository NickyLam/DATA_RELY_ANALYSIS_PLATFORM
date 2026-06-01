/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_repayment_plan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_repayment_plan_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_repayment_plan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_repayment_plan_info(
    curdate varchar2(8) -- 账务日期
    ,loanid varchar2(64) -- 借据号
    ,termno varchar2(64) -- 期序
    ,startdate varchar2(8) -- 开始日期
    ,enddate varchar2(8) -- 到期日期
    ,cleardate varchar2(8) -- 结清日期
    ,termstatus varchar2(2) -- 本期状态
    ,printotal varchar2(64) -- 应还本金
    ,prinrepay varchar2(64) -- 已还本金
    ,intplan varchar2(64) -- 计划利息
    ,inttotal varchar2(64) -- 应还利息
    ,intrepay varchar2(64) -- 已还利息
    ,intdiscount varchar2(64) -- 减免利息
    ,intbal varchar2(64) -- 利息余额
    ,pnltinttotal varchar2(64) -- 应还罚息
    ,pnltintrepay varchar2(64) -- 已还罚息
    ,pnltintdiscount varchar2(64) -- 减免罚息
    ,pnltintbal varchar2(64) -- 罚息余额
    ,prepmtfeerepay varchar2(64) -- 已还提前还款手续费
    ,productno varchar2(32) -- 产品编号
    ,outloanchannelno varchar2(64) -- 平台订单号
    ,daysovd varchar2(64) -- 逾期天数
    ,currency varchar2(3) -- 币种
    ,dailyint number(24,6) -- 当日计提利息
    ,dailypnltint number(24,6) -- 当日计提罚息
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
grant select on ${iol_schema}.icms_zjbk_repayment_plan_info to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_repayment_plan_info to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_repayment_plan_info to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_repayment_plan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_repayment_plan_info is '字节还款计划表';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.curdate is '账务日期';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.loanid is '借据号';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.termno is '期序';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.startdate is '开始日期';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.enddate is '到期日期';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.cleardate is '结清日期';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.termstatus is '本期状态';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.printotal is '应还本金';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.prinrepay is '已还本金';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.intplan is '计划利息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.inttotal is '应还利息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.intrepay is '已还利息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.intdiscount is '减免利息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.intbal is '利息余额';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.pnltinttotal is '应还罚息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.pnltintrepay is '已还罚息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.pnltintdiscount is '减免罚息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.pnltintbal is '罚息余额';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.prepmtfeerepay is '已还提前还款手续费';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.productno is '产品编号';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.daysovd is '逾期天数';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.currency is '币种';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.dailyint is '当日计提利息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.dailypnltint is '当日计提罚息';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_repayment_plan_info.etl_timestamp is 'ETL处理时间戳';
