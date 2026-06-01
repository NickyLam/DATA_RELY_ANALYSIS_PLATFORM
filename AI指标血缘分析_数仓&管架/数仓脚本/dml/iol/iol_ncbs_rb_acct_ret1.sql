/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_acct
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
                       FROM ncbs_rb_acct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_acct');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_acct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_acct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ncbs_rb_acct(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,business_unit -- 账套
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,reason_code -- 账户用途
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,term -- 存期
            ,term_type -- 期限单位
            ,acct_class -- 账户等级
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_license_no -- 账户许可证号
            ,acct_nature -- 存款账户类型
            ,acct_real_flag -- 账户虚实标志
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,acct_stop_pay -- 账户余额止付标志
            ,addtl_principal -- 是否允许增加本金
            ,agreement_id -- 协议编号
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,appr_flag -- 复核标志
            ,appr_letter_no -- 核准件编号
            ,auto_renew_rollover -- 自动转存方式
            ,auto_settle_flag -- 自动结清标志
            ,bal_type -- 余额类型
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,cur_stage_no -- 当前期数
            ,dac_value -- dac值防篡改加密
            ,gl_type -- 总账类型
            ,impound_fad -- 强制扣划导致违约状态
            ,individual_flag -- 对公对私标志
            ,int_ind_flag -- 是否计息
            ,joint_acct_flag -- 联合账户标志
            ,last_mvmt_status -- 定期账户上一次更改状态
            ,lead_acct_flag -- 主账户标志
            ,main_bal_flag -- 主账户是否带余额
            ,main_int_flag -- 主账户是否带利息
            ,management_free_flag -- 对公免收管理费标志，对私免收管理费和卡年费标识
            ,multi_bal_type_flag -- 是否多余额
            ,no_tran_flag -- 6个月无交易标志
            ,osa_flag -- 离岸标记
            ,ownership_type -- 归属种类
            ,partial_renew_roll -- 是否部分本金转存
            ,prefix -- 前缀
            ,recover_flag -- 实时追缴标志字段
            ,region_flag -- 区内区外标记
            ,renew_no -- 本金转存次数
            ,rollover_no -- 本息转存次数
            ,settle -- 结算标志
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,times_renewed -- 已本金转存次数
            ,times_rolledover -- 已本息转存次数
            ,xrate_id -- 汇兑方式
            ,accounting_status -- 核算状态
            ,accounting_status_prev -- 上次核算状态
            ,fixed_call -- 定期账户细类
            ,accounting_status_upd_date -- 核算状态变更日期
            ,acct_close_date -- 销户日期
            ,acct_due_date -- 账户有效日期
            ,acct_license_date -- 账户许可证签发日期
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,approval_date -- 复核日期
            ,dormant_date -- 转不动户日期
            ,effect_date -- 产品生效日期
            ,last_change_date -- 最后修改日期
            ,last_tran_date -- 最后交易日期
            ,maturity_date -- 到期日期
            ,open_tran_date -- 开户后首次交易日期
            ,ori_maturity_date -- 账户原始到期日期
            ,orig_acct_open_date -- 账户原始开立日期
            ,settle_date -- 结算日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,appr_user_id -- 复核柜员
            ,home_branch -- 客户管理行
            ,last_change_user_id -- 最后修改柜员
            ,main_prod_type -- 卡产品代码
            ,mm_ref_no -- 资金交易参考号
            ,notice_period -- 通知期限
            ,old_prod_type -- 原产品类型
            ,parent_internal_key -- 上级账户标识符
            ,settle_user_id -- 结算柜员
            ,voucher_start_no -- 凭证起始号码
            ,xrate -- 汇率
            ,apply_branch -- 申请机构
            ,acct_name_prefix -- 账户名称前缀
            ,acct_name_suffix -- 账户名称后缀
            ,open_user_id -- 开户柜员编号
            ,acct_property2 -- 账户性质2
            ,amend_date -- 变更日期
            ,is_med_ins_flag -- 是否医保账户标志
            ,is_travel_card_flag -- 是否旅行通账户标志
            ,travel_due_date -- 旅行通卡有效期
            ,is_soc_fin_flag -- 是否为社保卡下金融账户标志
            ,' ' as to_out_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ncbs_rb_acct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
