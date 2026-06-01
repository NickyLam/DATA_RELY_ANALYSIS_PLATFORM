/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_tran_hist
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
	            where table_name = upper('ncbs_rb_tran_hist_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_rb_tran_hist')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_rb_tran_hist drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_rb_tran_hist add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_rb_tran_hist(
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,client_type -- 客户类型
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
    ,acct_class -- 账户等级
    ,acct_desc -- 账户描述
    ,acct_real_flag -- 账户虚实标志
    ,acct_tran_flag -- 账户交易标志
    ,amt_calc_type -- 金额计算类型
    ,auto_reversal_flag -- 自动冲正标志
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,bill_no -- 票据号码
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,event_type -- 事件类型
    ,fh_seq_no -- 资金冻结流水号
    ,fin_type -- 理财类型
    ,from_rate_flag -- 买方交易汇率标志
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,limit_ref -- 限额编码
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,orig_system -- 交易发起方业务分类
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,pay_unit -- 交款单位
    ,pbk_upd_flag -- 是否补登存
    ,pi_flag -- 小额免密标志
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,priority -- 优先级
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reversal_flag -- 交易是否已冲正
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,send_system -- 转发系统
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,to_id -- 卖方牌价类型
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,channel -- 渠道
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,orig_tran_timestamp -- 原始交易时间戳
    ,reversal_date -- 冲正日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,actual_bal_amt_fin -- 交易后余额加理财
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
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_document_id -- 交易对手证件号码
    ,oth_document_type -- 交易对手证件类型
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type -- 真实交易对手账户类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,oth_reference -- 对方交易参考号
    ,oth_tran_addr -- 交易发生地
    ,oth_tran_name -- 交易对手名称
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,sub_acct_no -- 子账户
    ,to_amount -- 移入金额
    ,to_ccy -- 目的币种
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,contra_tran_date -- 他行交易日期
    ,bus_seq_no -- 业务流水号
    ,narrative_code -- 摘要码
    ,cheque_date -- 支票凭证出票日期
    ,old_data_remark -- 
    ,cash_to_code -- 
    ,cash_to_country -- 
    ,cash_from_code -- 
    ,cash_from_country -- 
    ,main_source_module -- 主模块
    ,loan_prod_type -- 贷款产品类型
    ,remark -- 备注
    ,orig_channel_seq_no -- 
    ,third_bus_type -- 
    ,marketing_prod_desc -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,client_type -- 客户类型
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
    ,acct_class -- 账户等级
    ,acct_desc -- 账户描述
    ,acct_real_flag -- 账户虚实标志
    ,acct_tran_flag -- 账户交易标志
    ,amt_calc_type -- 金额计算类型
    ,auto_reversal_flag -- 自动冲正标志
    ,bal_type -- 余额类型
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,bill_no -- 票据号码
    ,biz_type -- 中间业务类型
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,commission_client_tel -- 代办/代理人电话
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,event_type -- 事件类型
    ,fh_seq_no -- 资金冻结流水号
    ,fin_type -- 理财类型
    ,from_rate_flag -- 买方交易汇率标志
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,limit_ref -- 限额编码
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,narrative -- 摘要
    ,orig_system -- 交易发起方业务分类
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,pay_unit -- 交款单位
    ,pbk_upd_flag -- 是否补登存
    ,pi_flag -- 小额免密标志
    ,prefix -- 前缀
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,print_cnt -- 打印次数
    ,priority -- 优先级
    ,program_id -- 交易代码
    ,quote_type -- 牌价类型
    ,rate_type -- 汇率类型
    ,receipt_no -- 回收号
    ,reversal_flag -- 交易是否已冲正
    ,reversal_seq_no -- 冲正流水号
    ,reversal_tran_type -- 冲正交易类型
    ,send_system -- 转发系统
    ,seq_no -- 序号
    ,serv_charge -- 服务费标识
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,to_id -- 卖方牌价类型
    ,to_rate_flag -- 卖方交易汇率标志
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,tran_category -- 交易种类
    ,channel -- 渠道
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,orig_tran_timestamp -- 原始交易时间戳
    ,reversal_date -- 冲正日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,actual_bal -- 实际余额
    ,actual_bal_amt_fin -- 交易后余额加理财
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
    ,oth_acct_ccy -- 对方账户币种
    ,oth_acct_seq_no -- 对方账户序列号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,oth_base_acct_no -- 对方账号/卡号
    ,oth_branch -- 对方账户开户机构
    ,oth_document_id -- 交易对手证件号码
    ,oth_document_type -- 交易对手证件类型
    ,oth_internal_key -- 对手账户内部键
    ,oth_prod_type -- 对方账户产品类型
    ,oth_real_bank_code -- 真实对方金融机构代码
    ,oth_real_bank_name -- 真实对方金融机构名称
    ,oth_real_base_acct_no -- 真实交易对手账号
    ,oth_real_document_id -- 真实交易对手证件号码
    ,oth_real_document_type -- 真实交易对手证件类型
    ,oth_real_prod_type -- 真实交易对手账户类型
    ,oth_real_tran_addr -- 真实交易发生地
    ,oth_real_tran_name -- 真实交易对手名称
    ,oth_reference -- 对方交易参考号
    ,oth_tran_addr -- 交易发生地
    ,oth_tran_name -- 交易对手名称
    ,ov_cross_rate -- 实际交易时修改交叉汇率
    ,ov_to_amount -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt -- 交易前余额
    ,sub_acct_no -- 子账户
    ,to_amount -- 移入金额
    ,to_ccy -- 目的币种
    ,to_xrate -- 卖方汇率值
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_method -- 到账方式
    ,flat_rate -- 平盘汇率
    ,reaccount_cd -- 对账代码
    ,contra_tran_date -- 他行交易日期
    ,bus_seq_no -- 业务流水号
    ,narrative_code -- 摘要码
    ,cheque_date -- 支票凭证出票日期
    ,old_data_remark -- 
    ,cash_to_code -- 
    ,cash_to_country -- 
    ,cash_from_code -- 
    ,cash_from_country -- 
    ,' ' as main_source_module -- 主模块
    ,' ' as loan_prod_type -- 贷款产品类型
    ,' ' as remark -- 备注
    ,' ' as orig_channel_seq_no -- 
    ,' ' as third_bus_type -- 
    ,' ' as marketing_prod_desc -- 
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_rb_tran_hist_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/