/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_tran_hist
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

declare
     v_flag   number(10) :=0;
          
begin
	for tb in (select partition_name,table_name,substr(partition_name,3) as etl_dt 
	             from user_tab_partitions 
	            where table_name = upper('ncbs_cl_tran_hist_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_cl_tran_hist')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_cl_tran_hist drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_cl_tran_hist add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_cl_tran_hist(
    acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,branch -- 机构编号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,dd_no -- 发放号
    ,doc_type -- 凭证类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,withdrawal_type -- 支取方式
    ,acct_desc -- 账户描述
    ,acct_real_flag -- 账户虚实标志
    ,acct_tran_flag -- 账户交易标志
    ,amt_calc_type -- 金额计算类型
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,commission_phone -- 代办人电话
    ,company -- 法人
    ,cr_dr_maint_ind -- 借贷标识
    ,event_type -- 事件类型
    ,fh_seq_no -- 资金冻结流水号
    ,from_rate_flag -- 买方交易汇率标志
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,limit_ref -- 限额编码
    ,marketing_prod_desc -- 营销产品名称
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_seq_no -- 对方交易流水号
    ,pay_unit -- 交款单位
    ,pbk_upd_flag -- 是否补登存
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,priority -- 优先级
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_flag -- 汇率标志
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,reversal -- 是否冲正标志
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,to_id -- 卖方牌价类型
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,accounting_status -- 核算状态
    ,effect_date -- 产品生效日期
    ,reversal_date -- 冲正日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,commission_client_name -- 代办人名称
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,from_amount -- 移出金额
    ,from_ccy -- 起始币种
    ,from_xrate -- 买方汇率值
    ,loan_no -- 贷款号
    ,marketing_prod -- 营销产品
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,to_amount -- 移入金额
    ,to_ccy -- 目的币种
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_method -- 到账方式
    ,reaccount_cd -- 对账代码
    ,client_econ_type -- 客户经济类型
    ,bus_seq_no -- 业务流水号
    ,sub_seq_no -- 系统子流水号|系统子流水号
    ,main_source_module -- 主模块
    ,system_code -- 来源系统编号
    ,extra_tran_timestamp -- 反洗钱加工时间戳
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,branch -- 机构编号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,dd_no -- 发放号
    ,doc_type -- 凭证类型
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,withdrawal_type -- 支取方式
    ,acct_desc -- 账户描述
    ,acct_real_flag -- 账户虚实标志
    ,acct_tran_flag -- 账户交易标志
    ,amt_calc_type -- 金额计算类型
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,commission_phone -- 代办人电话
    ,company -- 法人
    ,cr_dr_maint_ind -- 借贷标识
    ,event_type -- 事件类型
    ,fh_seq_no -- 资金冻结流水号
    ,from_rate_flag -- 买方交易汇率标志
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,limit_ref -- 限额编码
    ,marketing_prod_desc -- 营销产品名称
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_seq_no -- 对方交易流水号
    ,pay_unit -- 交款单位
    ,pbk_upd_flag -- 是否补登存
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,priority -- 优先级
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_flag -- 汇率标志
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reserve1 -- 预留字段1
    ,reserve2 -- 预留字段2
    ,reversal -- 是否冲正标志
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,terminal_id -- 交易终端编号
    ,to_id -- 卖方牌价类型
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,accounting_status -- 核算状态
    ,effect_date -- 产品生效日期
    ,reversal_date -- 冲正日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,base_equiv_amt -- 基础等值金额
    ,commission_client_name -- 代办人名称
    ,contra_acct_ccy -- 对方币种
    ,contra_equiv_amt -- 对方等值金额
    ,cross_rate -- 交叉汇率
    ,from_amount -- 移出金额
    ,from_ccy -- 起始币种
    ,from_xrate -- 买方汇率值
    ,loan_no -- 贷款号
    ,marketing_prod -- 营销产品
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_reference -- 对方交易参考号
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,to_amount -- 移入金额
    ,to_ccy -- 目的币种
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_method -- 到账方式
    ,reaccount_cd -- 对账代码
    ,client_econ_type -- 客户经济类型
    ,bus_seq_no -- 业务流水号
    ,sub_seq_no -- 系统子流水号|系统子流水号
    ,main_source_module -- 主模块
    ,system_code -- 来源系统编号
    ,' ' as extra_tran_timestamp -- 反洗钱加工时间戳
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_cl_tran_hist_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/