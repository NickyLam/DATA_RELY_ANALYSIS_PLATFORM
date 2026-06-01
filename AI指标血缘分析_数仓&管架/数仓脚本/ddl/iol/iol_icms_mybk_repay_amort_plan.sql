/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_repay_amort_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_repay_amort_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_repay_amort_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_repay_amort_plan(
    contractno varchar2(64) -- 借据号
    ,termno number(3,0) -- 期次号
    ,migtflag varchar2(80) -- 
    ,prinbal number(20,2) -- 本金余额
    ,startdate varchar2(64) -- 分期开始日期
    ,prinovddays number(5,0) -- 本金逾期天数
    ,writeoff varchar2(8) -- 核销标识，已核销为Y，否则为N
    ,enddate varchar2(64) -- 分期结束日期
    ,intovddate varchar2(64) -- 利息转逾期日期
    ,ovdintpnltbal number(20,2) -- 逾期利息罚息余额
    ,settledate varchar2(64) -- 会计日期
    ,bsntype varchar2(64) -- 产品业务类型
    ,intbal number(20,2) -- 利息余额
    ,ovdprinpnltbal number(20,2) -- 逾期本金罚息余额
    ,intamt number(20,2) -- 初始利息匡算金额
    ,intovddays number(5,0) -- 利息逾期天数
    ,prinovddate varchar2(64) -- 本金转逾期日期
    ,cleardate varchar2(64) -- 结清日期
    ,prinamt number(20,2) -- 本金金额
    ,status varchar2(10) -- 分期状态
    ,accruedstatus varchar2(8) -- 应计非应计标识，应计0，非应计1
    ,selftermno number(3,0) -- 我行期次号
    ,selfstartdate varchar2(64) -- 我行分期开始日期
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_mybk_repay_amort_plan to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_repay_amort_plan to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_repay_amort_plan to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_repay_amort_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_repay_amort_plan is '还款计划信息';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.migtflag is '';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.prinbal is '本金余额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.settledate is '会计日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.intbal is '利息余额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.intamt is '初始利息匡算金额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.prinamt is '本金金额';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.status is '分期状态';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.selftermno is '我行期次号';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.selfstartdate is '我行分期开始日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.updatedate is '更新日期';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_repay_amort_plan.etl_timestamp is 'ETL处理时间戳';
