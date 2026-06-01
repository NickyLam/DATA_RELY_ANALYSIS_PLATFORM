/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_common_account_hist
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
	            where table_name = upper('ncbs_rb_common_account_hist_bak${batch_date}')
	              and partition_name <> 'P_19000101') loop
	             
  select count(*) into v_flag
    from all_tab_partitions 
   where table_owner = upper('IOL')
     and table_name = upper('ncbs_rb_common_account_hist')
     and partition_name = tb.partition_name;
     
  if v_flag <> 0 then
     execute immediate 'alter table ncbs_rb_common_account_hist drop partition '|| tb.partition_name ;
     
  end if;
  
     execute immediate 'alter table ncbs_rb_common_account_hist add partition ' || tb.partition_name || ' values (to_date(' || tb.etl_dt || ',''yyyymmdd''))';

insert /*+ append */ into ${iol_schema}.ncbs_rb_common_account_hist(
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,branch -- 机构编号
    ,business_unit -- 账套
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,country -- 国家
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,auto_reversal_flag -- 自动冲正标志
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,br_seq_no -- 前端流水号
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,fee_type -- 费率类型
    ,gl_posted_flag -- 过账标记
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,memo1 -- 备用字段1
    ,memo2 -- 备用字段2
    ,memo3 -- 备用字段3
    ,memo4 -- 备用4
    ,memo5 -- 备用5
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,program_id -- 交易代码
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,system_id -- 系统id
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,auth_user_id -- 授权柜员
    ,credit_card_no -- 信用卡号
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
    ,spread_percent -- 浮动百分比
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,settle_client_acct_seq_no -- 科目记账客户子账号
    ,settle_client_acct_name -- 科目账记账客户账号名称
    ,settle_client_acct_no -- 科目账记账客户账号
    ,oth_client_type -- 对方客户类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,amt_type -- 金额类型
    ,branch -- 机构编号
    ,business_unit -- 账套
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,country -- 国家
    ,document_id -- 证件号码
    ,document_type -- 客户证件类型
    ,gl_code -- 科目代码
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,auto_reversal_flag -- 自动冲正标志
    ,bank_seq_no -- 银行交易序号
    ,batch_no -- 批次号
    ,br_seq_no -- 前端流水号
    ,cash_item -- 现金项目
    ,channel_seq_no -- 全局流水号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,fee_type -- 费率类型
    ,gl_posted_flag -- 过账标记
    ,medium_flag -- 介质标志
    ,medium_type -- 存款介质类型
    ,memo1 -- 备用字段1
    ,memo2 -- 备用字段2
    ,memo3 -- 备用字段3
    ,memo4 -- 备用4
    ,memo5 -- 备用5
    ,narrative -- 摘要
    ,oth_acct_desc -- 对方账户描述
    ,oth_branch_regionalism_code -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code -- 真实对方金融机构行政区划代码
    ,oth_seq_no -- 对方交易流水号
    ,primary_event_type -- 主事件类型
    ,primary_tran_seq_no -- 主交易序号
    ,program_id -- 交易代码
    ,reversal_flag -- 交易是否已冲正
    ,reversal_tran_type -- 冲正交易类型
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,sub_seq_no -- 系统流水号
    ,system_code -- 来源系统编号
    ,system_id -- 系统id
    ,tae_sub_seq_no -- tae子流水序号
    ,terminal_id -- 交易终端编号
    ,trace_id -- 跟踪id
    ,tran_desc -- 交易描述
    ,tran_hist_seq_no -- 交易流水号
    ,tran_note -- 交易附言
    ,tran_status -- 冲补抹标志
    ,accounting_status -- 核算状态
    ,channel_date -- 渠道日期
    ,effect_date -- 产品生效日期
    ,reversal_tran_date -- 冲正交易日期
    ,settlement_date -- 清算日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_ccy -- 账户币种
    ,auth_user_id -- 授权柜员
    ,credit_card_no -- 信用卡号
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
    ,spread_percent -- 浮动百分比
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,settle_client_acct_seq_no -- 科目记账客户子账号
    ,settle_client_acct_name -- 科目账记账客户账号名称
    ,settle_client_acct_no -- 科目账记账客户账号
    ,' ' as oth_client_type -- 对方客户类型
    ,etl_dt as etl_dt -- ETL处理日期
    ,etl_timestamp as etl_timestamp -- ETL处理时间
from ncbs_rb_common_account_hist_bak${batch_date}
where etl_dt = to_date(tb.etl_dt, 'yyyymmdd');

commit;
end loop;
end;
/