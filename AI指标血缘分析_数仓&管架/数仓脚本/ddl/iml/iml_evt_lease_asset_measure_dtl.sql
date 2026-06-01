/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_lease_asset_measure_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_lease_asset_measure_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_lease_asset_measure_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_lease_asset_measure_dtl(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,lease_measure_ser_num varchar2(100) -- 承租计量序列号
    ,lease_asset_ser_num varchar2(100) -- 承租资产序列号
    ,measure_tm timestamp -- 计量时间
    ,acct_b_id varchar2(100) -- 账簿编号
    ,measure_mon varchar2(100) -- 计量月
    ,tm_bg_use_right_asset_bal number(30,2) -- 期初使用权资产余额
    ,curr_issue_depre_amt number(30,2) -- 本期折旧金额
    ,acm_depre_amt number(30,2) -- 累计折旧金额
    ,term_end_use_right_asset_bal number(30,2) -- 期末使用权资产余额
    ,tm_bg_at_paybl_rent_money number(30,2) -- 期初税后应付租赁款
    ,curr_issue_plan_pay_lmt number(30,2) -- 本期计划付款额
    ,acm_acct_paybl number(30,2) -- 累计应付款
    ,term_end_at_paybl_rent_money number(30,2) -- 期末税后应付租赁款
    ,tm_bg_amort_cost_bal number(30,2) -- 期初摊余成本余额
    ,curr_issue_rent_liab_chg number(30,2) -- 本期租赁负债变化
    ,acm_rent_liab_chg number(30,2) -- 累计租赁负债变化
    ,term_end_amort_cost_bal number(30,2) -- 期末摊余成本余额
    ,tm_bg_uncfm_fin_fee_bal number(30,2) -- 期初未确认融资费用余额
    ,curr_issue_int_fee number(30,2) -- 本期利息费用
    ,acm_int_fee number(30,2) -- 累计利息费用
    ,term_end_uncfm_fin_fee_bal number(30,2) -- 期末未确认融资费用余额
    ,curr_modif_use_right_asset_amt number(30,2) -- 本期合同变更使用权资产发生额
    ,curr_modif_paybl_rent_money number(30,2) -- 本期合同变更应付租赁款
    ,curr_modif_amort_cost_amt number(30,2) -- 本期合同变更摊余成本发生额
    ,curr_modif_uncfm_fin_fee_amt number(30,2) -- 本期合同变更未确认融资费用发生额
    ,new_crition_duran_pl_amt number(30,2) -- 新准则期间损益金额
    ,old_crition_duran_pl_amt number(30,2) -- 旧准则期间损益金额
    ,new_old_crition_pl_diff_amt number(30,2) -- 新旧准则损益差异金额
    ,curr_mon_acm_paybl_rent_decrs number(30,2) -- 本期当月累计应付租赁款减少额
    ,curr_mon_acm_rent_liab_chg number(30,2) -- 本期当月累计租赁负债变化
    ,curr_mon_acm_int_fee number(30,2) -- 本期当月累计利息费用
    ,acm_old_crition_duran_pl_amt number(30,2) -- 累计旧准则期间损益金额
    ,dt_type_cd varchar2(100) -- 日期类型代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_lease_asset_measure_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_lease_asset_measure_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_lease_asset_measure_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_lease_asset_measure_dtl is '承租租赁资产计量明细';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.lease_measure_ser_num is '承租计量序列号';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.lease_asset_ser_num is '承租资产序列号';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.measure_tm is '计量时间';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acct_b_id is '账簿编号';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.measure_mon is '计量月';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.tm_bg_use_right_asset_bal is '期初使用权资产余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_issue_depre_amt is '本期折旧金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acm_depre_amt is '累计折旧金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.term_end_use_right_asset_bal is '期末使用权资产余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.tm_bg_at_paybl_rent_money is '期初税后应付租赁款';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_issue_plan_pay_lmt is '本期计划付款额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acm_acct_paybl is '累计应付款';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.term_end_at_paybl_rent_money is '期末税后应付租赁款';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.tm_bg_amort_cost_bal is '期初摊余成本余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_issue_rent_liab_chg is '本期租赁负债变化';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acm_rent_liab_chg is '累计租赁负债变化';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.term_end_amort_cost_bal is '期末摊余成本余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.tm_bg_uncfm_fin_fee_bal is '期初未确认融资费用余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_issue_int_fee is '本期利息费用';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acm_int_fee is '累计利息费用';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.term_end_uncfm_fin_fee_bal is '期末未确认融资费用余额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_modif_use_right_asset_amt is '本期合同变更使用权资产发生额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_modif_paybl_rent_money is '本期合同变更应付租赁款';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_modif_amort_cost_amt is '本期合同变更摊余成本发生额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_modif_uncfm_fin_fee_amt is '本期合同变更未确认融资费用发生额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.new_crition_duran_pl_amt is '新准则期间损益金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.old_crition_duran_pl_amt is '旧准则期间损益金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.new_old_crition_pl_diff_amt is '新旧准则损益差异金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_mon_acm_paybl_rent_decrs is '本期当月累计应付租赁款减少额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_mon_acm_rent_liab_chg is '本期当月累计租赁负债变化';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.curr_mon_acm_int_fee is '本期当月累计利息费用';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.acm_old_crition_duran_pl_amt is '累计旧准则期间损益金额';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.dt_type_cd is '日期类型代码';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_lease_asset_measure_dtl.etl_timestamp is 'ETL处理时间戳';
