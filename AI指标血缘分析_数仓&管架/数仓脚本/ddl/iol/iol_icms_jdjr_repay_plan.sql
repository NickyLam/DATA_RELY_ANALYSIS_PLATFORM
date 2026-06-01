/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_jdjr_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_jdjr_repay_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_jdjr_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_jdjr_repay_plan(
    repaychangetype varchar2(1) -- 新增还款变更类型
    ,termno varchar2(30) -- 分期单号
    ,prinrepaydt varchar2(10) -- 本金到期日
    ,enchashfee number(26,8) -- 取现手续费
    ,lastovdstatus varchar2(1) -- 前一天逾期状态
    ,bussdate varchar2(10) -- 业务日期
    ,repaytermno number(22) -- 还款期数
    ,volfee number(26,8) -- 违约金
    ,lastovddays number(22,0) -- 前一天逾期天数
    ,termtype varchar2(4) -- 期数类型
    ,pnltrepaybalance number(26,8) -- 待还罚息
    ,curovddays number(22) -- 当前逾期天数
    ,prdno varchar2(4) -- 产品编号
    ,loanno varchar2(60) -- 贷款编号
    ,realityrate number(26,8) -- 分期单执行费率
    ,ovddays number(22) -- 逾期天数
    ,intrepaydt varchar2(10) -- 利息到期日
    ,repayterms number(22) -- 还款总期数
    ,migtflag varchar2(80) -- 
    ,intrepaybalance number(26,8) -- 待还利息
    ,limitno varchar2(60) -- 额度编号
    ,enchashfeeenddate varchar2(10) -- 取现手续费到期日
    ,prdcode varchar2(60) -- 产品编号（行内）
    ,prinrepaybalance number(26,8) -- 待还本金
    ,contno varchar2(30) -- 合同号
    ,curovdstatus varchar2(1) -- 当前逾期状态
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
grant select on ${iol_schema}.icms_jdjr_repay_plan to ${iml_schema};
grant select on ${iol_schema}.icms_jdjr_repay_plan to ${icl_schema};
grant select on ${iol_schema}.icms_jdjr_repay_plan to ${idl_schema};
grant select on ${iol_schema}.icms_jdjr_repay_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_jdjr_repay_plan is '京东还款计划';
comment on column ${iol_schema}.icms_jdjr_repay_plan.repaychangetype is '新增还款变更类型';
comment on column ${iol_schema}.icms_jdjr_repay_plan.termno is '分期单号';
comment on column ${iol_schema}.icms_jdjr_repay_plan.prinrepaydt is '本金到期日';
comment on column ${iol_schema}.icms_jdjr_repay_plan.enchashfee is '取现手续费';
comment on column ${iol_schema}.icms_jdjr_repay_plan.lastovdstatus is '前一天逾期状态';
comment on column ${iol_schema}.icms_jdjr_repay_plan.bussdate is '业务日期';
comment on column ${iol_schema}.icms_jdjr_repay_plan.repaytermno is '还款期数';
comment on column ${iol_schema}.icms_jdjr_repay_plan.volfee is '违约金';
comment on column ${iol_schema}.icms_jdjr_repay_plan.lastovddays is '前一天逾期天数';
comment on column ${iol_schema}.icms_jdjr_repay_plan.termtype is '期数类型';
comment on column ${iol_schema}.icms_jdjr_repay_plan.pnltrepaybalance is '待还罚息';
comment on column ${iol_schema}.icms_jdjr_repay_plan.curovddays is '当前逾期天数';
comment on column ${iol_schema}.icms_jdjr_repay_plan.prdno is '产品编号';
comment on column ${iol_schema}.icms_jdjr_repay_plan.loanno is '贷款编号';
comment on column ${iol_schema}.icms_jdjr_repay_plan.realityrate is '分期单执行费率';
comment on column ${iol_schema}.icms_jdjr_repay_plan.ovddays is '逾期天数';
comment on column ${iol_schema}.icms_jdjr_repay_plan.intrepaydt is '利息到期日';
comment on column ${iol_schema}.icms_jdjr_repay_plan.repayterms is '还款总期数';
comment on column ${iol_schema}.icms_jdjr_repay_plan.migtflag is '';
comment on column ${iol_schema}.icms_jdjr_repay_plan.intrepaybalance is '待还利息';
comment on column ${iol_schema}.icms_jdjr_repay_plan.limitno is '额度编号';
comment on column ${iol_schema}.icms_jdjr_repay_plan.enchashfeeenddate is '取现手续费到期日';
comment on column ${iol_schema}.icms_jdjr_repay_plan.prdcode is '产品编号（行内）';
comment on column ${iol_schema}.icms_jdjr_repay_plan.prinrepaybalance is '待还本金';
comment on column ${iol_schema}.icms_jdjr_repay_plan.contno is '合同号';
comment on column ${iol_schema}.icms_jdjr_repay_plan.curovdstatus is '当前逾期状态';
comment on column ${iol_schema}.icms_jdjr_repay_plan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_jdjr_repay_plan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_jdjr_repay_plan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_jdjr_repay_plan.etl_timestamp is 'ETL处理时间戳';
