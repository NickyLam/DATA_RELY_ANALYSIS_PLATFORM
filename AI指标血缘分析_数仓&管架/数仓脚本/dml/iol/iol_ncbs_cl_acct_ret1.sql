/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_acct
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM ncbs_cl_acct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_cl_acct');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_cl_acct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_cl_acct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_cl_acct(
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,acct_status_yesterday -- 上一日账户状态
            ,last_merge_flag -- 
            ,renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            od_grace_end_date -- 免息截止日期
            ,acct_name -- 账户名称
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,branch -- 机构编号
            ,business_unit -- 账套
            ,ccy -- 币种
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,dd_no -- 发放号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_status_prev -- 账户上一状态
            ,alloc_seq_fee -- 贷款费用还款顺序
            ,alloc_seq_int -- 贷款利息还款顺序
            ,alloc_seq_odi -- 贷款复利还款顺序
            ,alloc_seq_odp -- 贷款罚息还款顺序
            ,alloc_seq_pri -- 贷款本金还款顺序
            ,alloc_seq_type -- 贷款自动还款类型
            ,appr_flag -- 复核标志
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,calc_times -- 气球贷计算期次
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,five_category -- 贷款五级分类
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,int_ind_flag -- 是否计息
            ,is_individual -- 个体客户标志
            ,lender -- 贷款人
            ,manual_change_schedule_flag -- 是否需要手工录入还款计划
            ,marketing_prod_desc -- 营销产品名称
            ,mid_period -- 累进间隔期数
            ,old_dd_no -- 原发放号
            ,old_loan_no -- 原贷款号
            ,osa_flag -- 离岸标记
            ,other_consumption -- 其他消费
            ,pay_off_type -- 贷款销户类型
            ,pre_repay_deal -- 还款计划变更方式
            ,purpose_id -- 用途编号
            ,recover_flag -- 实时追缴标志字段
            ,regen_schedule_flag -- 重新生成还款计划标志
            ,region_flag -- 区内区外标记
            ,sched_mode -- 还款方式
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_project_no -- 子项目号
            ,sub_sched_mode -- 当前子计划方式
            ,terminal_id -- 交易终端编号
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,closed_date -- 关闭日期
            ,contraction_date -- 变期不变额最后变化日期
            ,effect_date -- 产品生效日期
            ,first_overdue_date -- 最早逾期日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,ssi_end_date -- 贴息截止日期
            ,tran_timestamp -- 交易时间戳
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,add_ratio -- 累进比例
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,contributive_ratio -- 出资比例
            ,fir_period -- 首段期数
            ,formula_amt -- 每期计划还款额
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,loan_no -- 贷款号
            ,marketing_prod -- 营销产品
            ,old_prod_type -- 原产品类型
            ,pay_off_reason -- 贷款销户原因
            ,add_amt -- 累进金额
            ,apply_branch -- 申请机构
            ,auto_transfer_flag -- 是否核销后自动转款
            ,sched_assemble_flag -- 自动组合还款标识
            ,reaccount_cd -- 对账代码
            ,ext_trade_no -- 原业务编号
            ,hour_int_rate -- 按小时利率
            ,client_econ_type -- 客户经济类型
            ,gear_by_hour_flag -- 按小时靠档标志
            ,abs_flag -- 资产证券化标志
            ,auto_reversal_flag -- 自动冲正标志|自动冲正标志|Y-自动冲正,N-业务冲正
            ,anytime_rec_flag -- 随借随还标志|随借随还标志 Y-是,N-否
            ,gear_prod_flag -- 是否靠档计息标志|是否靠档计息标志
            ,document_id -- 证件号码|证件号码
            ,document_type -- 客户证件类型|客户证件类型
            ,accounting_status_yesterday -- 上日核算状态|ZHC-正常,YUQ-逾期,FYJ-非应计,FY-手工转非应计,DZA-呆账,DZI-呆滞,WRN-核销,TER-终止
            ,is_trf_flag -- 资产转让标志
            ,' ' as acct_status_yesterday -- 上一日账户状态
            ,' ' as last_merge_flag -- 
            ,' ' as renew_fact_flg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
