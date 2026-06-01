/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_rcd_ir_action_bc_month
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_rcd_ir_action_bc_month_ex purge;
alter table ${iol_schema}.rsts_rcd_ir_action_bc_month add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_rcd_ir_action_bc_month truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_rcd_ir_action_bc_month_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_rcd_ir_action_bc_month where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_rcd_ir_action_bc_month_ex(
    loan_no -- 贷款借据号
    ,data_dt -- 数据日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_no -- 合同号
    ,loan_biz_type_cd -- 业务品种代码
    ,overduedays_month -- 逾期天数
    ,ovdue_princp_amt -- 逾期本金
    ,rcva_owe_int -- 应收欠息
    ,dun_owe_int -- 催收欠息
    ,rcva_acr_intr -- 应收应计利息
    ,dun_acr_intr -- 催收应计利息
    ,rcva_pnlt -- 应收罚息
    ,dun_pnlt -- 催收罚息
    ,rcva_accr_pnlt -- 应收应计罚息
    ,dun_accr_pnlt -- 催收应计罚息
    ,rcva_cmpd_intr -- 应收复息
    ,accr_cmpd_intr -- 应计复息
    ,loan_total_bal -- 贷款余额
    ,repayment -- 实还金额
    ,adv_repay_flg -- 提前还款标志
    ,adv_repay_amt -- 提前还款本金
    ,agt_status_cd -- 贷款账户状态代码
    ,risk_rat_categ_cd -- 风险评级类别代码
    ,risk_rat_resu_cd -- 风险评级结果代码
    ,v_dyyhje -- 当月应还金额
    ,v_dysjhkl -- 当月实际还款率
    ,v_dyyqje -- 当月逾期金额
    ,v_dyyqqs -- 当月逾期期数
    ,v_ye -- 余额
    ,v_yelxzjys -- 余额连续增加月份数
    ,v_hkllxzjys -- 还款率连续增加月份数
    ,v_hkllxjsys -- 还款率连续减少月份数
    ,v_lxwyqys -- 连续未逾期月数
    ,v_lxqyys -- 连续月数
    ,v_yqbyqqslxzjys -- 逾期并逾期期数连续增加的月数
    ,v_yqjelxzjys -- 逾期金额连续增加月数
    ,v_lxyqys -- 连续逾期月数
    ,write_off_flg -- 核销标志
    ,bout_liqdt_flg -- 第三方代偿标志
    ,data_src_cd -- 数据来源代码
    ,serno -- 业务流水号
    ,blng_org_id -- 所属机构
    ,iden_num -- 客户证件号码
    ,grade_key_id -- 申请评分流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    loan_no -- 贷款借据号
    ,data_dt -- 数据日期
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cont_no -- 合同号
    ,loan_biz_type_cd -- 业务品种代码
    ,overduedays_month -- 逾期天数
    ,ovdue_princp_amt -- 逾期本金
    ,rcva_owe_int -- 应收欠息
    ,dun_owe_int -- 催收欠息
    ,rcva_acr_intr -- 应收应计利息
    ,dun_acr_intr -- 催收应计利息
    ,rcva_pnlt -- 应收罚息
    ,dun_pnlt -- 催收罚息
    ,rcva_accr_pnlt -- 应收应计罚息
    ,dun_accr_pnlt -- 催收应计罚息
    ,rcva_cmpd_intr -- 应收复息
    ,accr_cmpd_intr -- 应计复息
    ,loan_total_bal -- 贷款余额
    ,repayment -- 实还金额
    ,adv_repay_flg -- 提前还款标志
    ,adv_repay_amt -- 提前还款本金
    ,agt_status_cd -- 贷款账户状态代码
    ,risk_rat_categ_cd -- 风险评级类别代码
    ,risk_rat_resu_cd -- 风险评级结果代码
    ,v_dyyhje -- 当月应还金额
    ,v_dysjhkl -- 当月实际还款率
    ,v_dyyqje -- 当月逾期金额
    ,v_dyyqqs -- 当月逾期期数
    ,v_ye -- 余额
    ,v_yelxzjys -- 余额连续增加月份数
    ,v_hkllxzjys -- 还款率连续增加月份数
    ,v_hkllxjsys -- 还款率连续减少月份数
    ,v_lxwyqys -- 连续未逾期月数
    ,v_lxqyys -- 连续月数
    ,v_yqbyqqslxzjys -- 逾期并逾期期数连续增加的月数
    ,v_yqjelxzjys -- 逾期金额连续增加月数
    ,v_lxyqys -- 连续逾期月数
    ,write_off_flg -- 核销标志
    ,bout_liqdt_flg -- 第三方代偿标志
    ,data_src_cd -- 数据来源代码
    ,serno -- 业务流水号
    ,blng_org_id -- 所属机构
    ,iden_num -- 客户证件号码
    ,grade_key_id -- 申请评分流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_rcd_ir_action_bc_month
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_rcd_ir_action_bc_month exchange partition p_${batch_date} with table ${iol_schema}.rsts_rcd_ir_action_bc_month_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_rcd_ir_action_bc_month to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_rcd_ir_action_bc_month_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_rcd_ir_action_bc_month',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);