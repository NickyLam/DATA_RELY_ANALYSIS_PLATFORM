/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_src_dw_agt_ln_ac_base_info
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
drop table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info_ex purge;
alter table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info_ex(
    data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,loan_acct_id -- 贷款账户编号 Y
    ,etl_dt_ora -- 数据日期 Y
    ,blng_pty_id -- 所属客户编号
    ,acct_name -- 账户名称
    ,prd_id -- 核算产品编号
    ,open_dt -- 开户日期
    ,loan_issue_dt -- 放款日期
    ,int_dt -- 起息日期
    ,trmi_dt -- 终止日期
    ,due_dt -- 到期日期
    ,open_org_id -- 开户机构编号
    ,mgmt_org_id -- 管理机构编号
    ,accting_org_id -- 账务机构编号
    ,pty_mgr_id -- 客户经理编号
    ,agt_status_cd -- 贷款账户状态代码
    ,accting_coa_id -- 会计科目编号
    ,term_corp_cd -- 期限单位代码
    ,loan_term -- 贷款期限
    ,ccy_cd -- 币种代码
    ,issue_amt -- 发放金额
    ,rate_base_typ_cd -- 利率基准类型代码
    ,rate_base_val -- 利率基准值
    ,exec_rate -- 正常执行利率
    ,ovdue_exec_rate -- 逾期执行利率
    ,float_rate_flg -- 浮动利率标志
    ,rate_float_mode_cd -- 利率浮动方式代码
    ,float_freq_cd -- 浮动频率代码
    ,rate_float_val -- 正常利率浮动值
    ,ovdue_rate_float -- 逾期利率浮动值
    ,curr_rate_eff_day -- 当前利率生效日
    ,next_rate_adj_day -- 下一利率调整日
    ,loan_base_mon_day_qty -- 贷款基准月天数
    ,loan_base_year_day_qty -- 贷款基准年天数
    ,loan_compd_int_flg -- 贷款复利标志
    ,loan_stl_mode_cd -- 贷款结息方式代码
    ,loan_int_mode_cd -- 贷款计息方式代码
    ,loan_calc_forml -- 贷款计算公式
    ,dd_acct_id -- 放款账户编号
    ,repay_mode_cd -- 还款方式代码
    ,repay_freq_cd -- 还款频率代码
    ,repay_acct_id -- 还款账户编号
    ,assoc_loan_contr_id -- 贷款合同编号
    ,bil_acct_id -- 记账分户账编号
    ,assoc_bil_id -- 关联票证编号
    ,loan_assoc_marg_acct -- 贷款关联保证金账号
    ,margin_ccy_cd -- 保证金币种代码
    ,margin_amt -- 保证金金额
    ,marg_ratio -- 保证金比例
    ,blng_biz_line_cd -- 所属业务条线代码
    ,loan_biz_type_cd -- 贷款业务品种代码
    ,sub_guar_mode_cd -- 子担保方式代码
    ,loan_cate_cd -- 贷款类型代码
    ,gov_platf_loan_flg -- 政府融资平台贷款标志
    ,acct_categ_cd -- 会计类别代码
    ,loan_flg -- 贷款标志
    ,acpt_flg -- 承兑标志
    ,bout_liqdt_flg -- 买断清收标志
    ,comm_invo_num -- 商业发票号码
    ,comm_inv_ccy_cd -- 商业发票币种代码
    ,comm_inv_amt -- 商业发票金额
    ,comm_inv_type_cd -- 商业发票种类代码
    ,fft_type_cd -- 福费廷种类代码
    ,int_acct_id -- 利息科目编号
    ,write_off_flg -- 核销标志
    ,product_no -- 标准贷款产品编号（新一代无贷款业务品种代码，改用这个关联）
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,loan_acct_id -- 贷款账户编号 Y
    ,etl_dt_ora -- 数据日期 Y
    ,blng_pty_id -- 所属客户编号
    ,acct_name -- 账户名称
    ,prd_id -- 核算产品编号
    ,open_dt -- 开户日期
    ,loan_issue_dt -- 放款日期
    ,int_dt -- 起息日期
    ,trmi_dt -- 终止日期
    ,due_dt -- 到期日期
    ,open_org_id -- 开户机构编号
    ,mgmt_org_id -- 管理机构编号
    ,accting_org_id -- 账务机构编号
    ,pty_mgr_id -- 客户经理编号
    ,agt_status_cd -- 贷款账户状态代码
    ,accting_coa_id -- 会计科目编号
    ,term_corp_cd -- 期限单位代码
    ,loan_term -- 贷款期限
    ,ccy_cd -- 币种代码
    ,issue_amt -- 发放金额
    ,rate_base_typ_cd -- 利率基准类型代码
    ,rate_base_val -- 利率基准值
    ,exec_rate -- 正常执行利率
    ,ovdue_exec_rate -- 逾期执行利率
    ,float_rate_flg -- 浮动利率标志
    ,rate_float_mode_cd -- 利率浮动方式代码
    ,float_freq_cd -- 浮动频率代码
    ,rate_float_val -- 正常利率浮动值
    ,ovdue_rate_float -- 逾期利率浮动值
    ,curr_rate_eff_day -- 当前利率生效日
    ,next_rate_adj_day -- 下一利率调整日
    ,loan_base_mon_day_qty -- 贷款基准月天数
    ,loan_base_year_day_qty -- 贷款基准年天数
    ,loan_compd_int_flg -- 贷款复利标志
    ,loan_stl_mode_cd -- 贷款结息方式代码
    ,loan_int_mode_cd -- 贷款计息方式代码
    ,loan_calc_forml -- 贷款计算公式
    ,dd_acct_id -- 放款账户编号
    ,repay_mode_cd -- 还款方式代码
    ,repay_freq_cd -- 还款频率代码
    ,repay_acct_id -- 还款账户编号
    ,assoc_loan_contr_id -- 贷款合同编号
    ,bil_acct_id -- 记账分户账编号
    ,assoc_bil_id -- 关联票证编号
    ,loan_assoc_marg_acct -- 贷款关联保证金账号
    ,margin_ccy_cd -- 保证金币种代码
    ,margin_amt -- 保证金金额
    ,marg_ratio -- 保证金比例
    ,blng_biz_line_cd -- 所属业务条线代码
    ,loan_biz_type_cd -- 贷款业务品种代码
    ,sub_guar_mode_cd -- 子担保方式代码
    ,loan_cate_cd -- 贷款类型代码
    ,gov_platf_loan_flg -- 政府融资平台贷款标志
    ,acct_categ_cd -- 会计类别代码
    ,loan_flg -- 贷款标志
    ,acpt_flg -- 承兑标志
    ,bout_liqdt_flg -- 买断清收标志
    ,comm_invo_num -- 商业发票号码
    ,comm_inv_ccy_cd -- 商业发票币种代码
    ,comm_inv_amt -- 商业发票金额
    ,comm_inv_type_cd -- 商业发票种类代码
    ,fft_type_cd -- 福费廷种类代码
    ,int_acct_id -- 利息科目编号
    ,write_off_flg -- 核销标志
    ,product_no -- 标准贷款产品编号（新一代无贷款业务品种代码，改用这个关联）
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_src_dw_agt_ln_ac_base_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info exchange partition p_${batch_date} with table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_src_dw_agt_ln_ac_base_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_src_dw_agt_ln_ac_base_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);