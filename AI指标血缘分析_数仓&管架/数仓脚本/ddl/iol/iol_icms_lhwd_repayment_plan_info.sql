/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_repayment_plan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_repayment_plan_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_repayment_plan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_repayment_plan_info(
    curdate varchar2(8) -- 业务日期 D日
    ,loanid varchar2(64) -- 借据号
    ,termno varchar2(64) -- 期次 从1开始
    ,startdate varchar2(8) -- 开始日期
    ,enddate varchar2(8) -- 到期日期
    ,withdrawenddate varchar2(8) -- 计息结束日期
    ,cleardate varchar2(8) -- 结清日期
    ,termstatus varchar2(2) -- 本期状态 1-正常 2-逾期 3-结清
    ,normalsum number(24,6) -- 应还本金
    ,prinbal number(24,6) -- 应还本金-实还本金
    ,inttotal number(24,6) -- 应还利息
    ,pnltinttotal number(24,6) -- 应还罚息
    ,pnltodiamt number(24,6) -- 应还复利
    ,prinrepay number(24,6) -- 实还本金
    ,intrepay number(24,6) -- 实还利息
    ,pnltintrepay number(24,6) -- 实还罚息
    ,pnltodiamtpay number(24,6) -- 实还复利
    ,intdiscount number(24,6) -- 减免利息
    ,pnltintdiscount number(24,6) -- 减免罚息
    ,pnltodidiscount number(24,6) -- 减免复利
    ,intbal number(24,6) -- 应还利息-实还利息
    ,pnltintbal number(24,6) -- 应还罚息-实还罚息
    ,pnltodibal number(24,6) -- 应还复利-实还复利
    ,daysovd varchar2(64) -- 逾期天数
    ,intdaysovd varchar2(64) -- 逾期天数
    ,daysovdt date -- 根据本金逾期天数倒推
    ,intdaysovdt date -- 根据利息逾期天数倒推
    ,currency varchar2(3) -- 默认CNY 人民币元
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
grant select on ${iol_schema}.icms_lhwd_repayment_plan_info to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_plan_info to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_plan_info to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_repayment_plan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_repayment_plan_info is '联合网贷还款计划表';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.curdate is '业务日期 D日';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.loanid is '借据号';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.termno is '期次 从1开始';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.startdate is '开始日期';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.enddate is '到期日期';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.withdrawenddate is '计息结束日期';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.cleardate is '结清日期';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.termstatus is '本期状态 1-正常 2-逾期 3-结清';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.normalsum is '应还本金';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.prinbal is '应还本金-实还本金';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.inttotal is '应还利息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltinttotal is '应还罚息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltodiamt is '应还复利';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.prinrepay is '实还本金';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.intrepay is '实还利息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltintrepay is '实还罚息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltodiamtpay is '实还复利';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.intdiscount is '减免利息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltintdiscount is '减免罚息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltodidiscount is '减免复利';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.intbal is '应还利息-实还利息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltintbal is '应还罚息-实还罚息';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.pnltodibal is '应还复利-实还复利';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.daysovd is '逾期天数';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.intdaysovd is '逾期天数';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.daysovdt is '根据本金逾期天数倒推';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.intdaysovdt is '根据利息逾期天数倒推';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.currency is '默认CNY 人民币元';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_repayment_plan_info.etl_timestamp is 'ETL处理时间戳';
