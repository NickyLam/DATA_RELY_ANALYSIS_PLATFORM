/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_evt_myloan_tran_repay_plan
CreateDate: 20230608
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_evt_myloan_tran_repay_plan purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_evt_myloan_tran_repay_plan(
etl_dt date --etl处理日期
,evt_id varchar2(500) --事件编号
,lp_id varchar2(60) --法人编号
,cont_id varchar2(100) --合同编号
,pd_num varchar2(30) --期次号
,asset_tran_bus_dt date --资产转让业务日期
,asset_tran_tran_tm timestamp --资产转让交易时间
,asset_tran_bus_flow_num varchar2(500) --资产转让业务流水号
,cap_flow_num varchar2(500) --资金流水号
,inst_start_dt date --分期开始日期
,inst_end_dt date --分期结束日期
,pric_bal number(30,2) --本金余额
,int_bal number(30,2) --利息余额
,ovdue_pric_pnlt_bal number(30,2) --逾期本金罚息余额
,ovdue_int_pnlt_bal number(30,2) --逾期利息罚息余额
,tran_type_cd varchar2(60) --转让类型代码
,tran_way_cd varchar2(30) --转让方式代码
,tran_amt number(30,2) --转让金额
,asset_bal_diff_amt number(30,2) --作价资产余额和转让金额差价
,inst_status_cd varchar2(60) --分期状态代码
,acru_non_idf_cd varchar2(30) --应计非应计标识代码
,wrt_off_flg varchar2(30) --核销标志
,asset_tran_cntpty_org_id varchar2(500) --资产转让交易对手机构编号
,dist_cd varchar2(60) --行政区划代码

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_evt_myloan_tran_repay_plan to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_evt_myloan_tran_repay_plan is '网商贷资产转入还款计划';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.evt_id is '事件编号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.lp_id is '法人编号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.cont_id is '合同编号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.pd_num is '期次号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.asset_tran_bus_dt is '资产转让业务日期';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.asset_tran_tran_tm is '资产转让交易时间';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.asset_tran_bus_flow_num is '资产转让业务流水号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.cap_flow_num is '资金流水号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.inst_start_dt is '分期开始日期';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.inst_end_dt is '分期结束日期';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.pric_bal is '本金余额';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.int_bal is '利息余额';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.ovdue_pric_pnlt_bal is '逾期本金罚息余额';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.ovdue_int_pnlt_bal is '逾期利息罚息余额';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.tran_type_cd is '转让类型代码';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.tran_way_cd is '转让方式代码';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.tran_amt is '转让金额';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.asset_bal_diff_amt is '作价资产余额和转让金额差价';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.inst_status_cd is '分期状态代码';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.acru_non_idf_cd is '应计非应计标识代码';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.wrt_off_flg is '核销标志';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.asset_tran_cntpty_org_id is '资产转让交易对手机构编号';
comment on column ${idl_schema}.crps_evt_myloan_tran_repay_plan.dist_cd is '行政区划代码';

