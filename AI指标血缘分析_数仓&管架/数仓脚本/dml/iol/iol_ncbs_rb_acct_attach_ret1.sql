/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct_attach
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
                       FROM ncbs_rb_acct_attach_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_acct_attach');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_acct_attach drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_acct_attach add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_acct_attach(
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            internal_key -- 账户内部键值
            ,gl_code -- 科目代码
            ,acct_proof_status -- 账户验证状态
            ,acct_proof_reason -- 验证失败原因
            ,acct_property -- 外汇账户性质
            ,bal_chg_ind -- 余额联动变动标识
            ,bal_upd_type -- 余额更新类型
            ,balance_way -- 余额方向
            ,od_facility -- 是否可透支
            ,cycle_int_flag -- 按频率付息标志
            ,auto_settle_flag -- 自动结清标志
            ,auto_dep -- 是否自动续存
            ,manual_account_flag -- 是否允许手工记账标识
            ,fta_acct_flag -- 是否自贸区账户标识
            ,fta_code -- 自贸区代码
            ,contra_base_acct_no -- 交易对手账号
            ,contra_acct_name -- 对手账号名称
            ,contra_branch -- 对手账户开户行
            ,contra_branch_name -- 对手账户开户行名称
            ,hang_write_off_flag -- 挂销账标志
            ,hang_term -- 挂账期限
            ,write_off_way -- 销账方式
            ,agreement_status -- 协议状态
            ,prod_class -- 产品分类
            ,special_prod_class -- 签约产品分类
            ,stage_code -- 期次代码
            ,annual_flag -- 证件年检标志
            ,annual_status -- 年检通过状态
            ,last_reset_date -- 上一年检重置日期
            ,last_stop_date -- 上一年检截止日期
            ,blacklist_status -- 黑名单状态
            ,last_blacklist_date -- 最后黑名单日期
            ,free_sum -- 手续费免费次数
            ,impound_fad -- 强制扣划导致违约状态
            ,msg_status -- 短信签约状态
            ,client_no -- 客户编号
            ,tran_timestamp -- 交易时间戳
            ,company -- 法人
            ,auto_renew_term -- 账户转存期限
            ,auto_renew_term_type -- 账户转存存期类型
            ,total_draw_amt -- 累计可支取本金金额
            ,allow_suspend_flag -- 是否允许账户转久悬
            ,all_dra_int_branch -- 通兑机构
            ,deposit_nature -- 核心存款性质
            ,acct_verify_status -- 账户核实状态
            ,is_sell_cheque -- 是否允许出售支票标识
            ,acct_verify_status_prev -- 账户上一核实状态
            ,private_acct_flag -- 隐私账户标志
            ,case_involved_date -- 客户涉案日期
            ,case_involved_reason -- 客户涉案原因
            ,treatment -- 处理种类
            ,agreement_id -- 协议编号
            ,approval_no -- 审批单号
            ,contra_client_no -- 对方客户号
            ,contra_area_code -- 对手行开立机构所属区域代码
            ,contra_country -- 交易对手行所属国家/地区
            ,swift_id -- 银行国际代码
            ,counter_dep_flag -- 是否允许柜面跨行存入许可标识
            ,counter_debt_flag -- 是否允许柜面跨行支取许可标识
            ,pre_debt_date -- 定期提前支取日期
            ,online_flag -- 是否联机
            ,check_certificate_amt -- 查证金额
            ,manage_flag -- 监管标志
            ,check_certificate_type -- 查证类型
            ,manage_content -- 监管内容
            ,agreement_deposit_type -- 协议存款类型
            ,next_dep_day -- 下一续存日
            ,acct_open_mode -- 开户模式
            ,manage_type -- 监管类型
            ,back_to_date -- 转回日期
            ,amount_nature -- 资金性质
            ,int_tax_levy -- 利息税征收标志
            ,re_open_date -- 销户重开日期和时间
            ,acct_open_type -- 开户方式
            ,contra_acct_open_date -- 对手账户开户日期
            ,first_draw_date -- 最早可支取日
            ,tax_rate -- 税率
            ,acct_channel_flag -- 账户渠道标识
            ,fast_open_acct_flag -- 是否一键开户标识
            ,acct_property2 -- 账户性质2
            ,case_involved_flag -- 涉案标识及暂停非柜原因
            ,delay_pay_int -- 延期付息标志
            ,spec_day -- 指定日
            ,tax_discount_maturity_date -- 优惠利息税率到期日
            ,both_limit_flag -- 双边限额限制标识
            ,fund_from_acct_no -- 资金来源账号
            ,fund_from_acct_seq_no -- 资金来源账户子序号
            ,is_effect_document -- 是否有有效身份证件
            ,dc_prod_change_flag -- 大额存单产品变更标志|是否为大额存单产品变更的账户
            ,pcp_delay_int_flag -- 兴惠存标识|是否签约集团资金池或延期付息
            ,open_acct_prov -- 开户省份|开户省份(用于二三类开户使用)
            ,open_acct_city -- 开户城市|开户城市(用于二三类开户使用)
            ,off_site_sign -- 本异地标识|用于二三类户开户1-异地,0-本地
            ,fix_rate_period_freq -- 固定利率周期|固定利率周期
            ,book_settele_date -- 预约结清日
            ,apply_debt_date -- 预约支取日期
            ,apply_debt_flag -- 是否预约支取
            ,allow_print_certificate_flag -- 打印证实书标志
            ,cash_manage_product -- 是否现金管理类产品
            ,int_rate_form_no -- 利率审批单单号
            ,manage_start_date -- 监管标识设置日期
            ,manage_end_date -- 取消监管标识日期
            ,' ' as bal_int_split -- 本息分离标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_rb_acct_attach_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
