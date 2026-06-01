/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_precontract
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
                       FROM ncbs_rb_dc_precontract_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_dc_precontract');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_dc_precontract drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_dc_precontract add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_precontract(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,int_type -- 利率类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,reference -- 交易参考号
            ,user_id -- 交易柜员编号
            ,voucher_no -- 凭证号码
            ,withdrawal_type -- 支取方式
            ,acct_nature -- 存款账户类型
            ,auto_settle_flag -- 自动结清标志
            ,company -- 法人
            ,cycle_freq -- 结息频率
            ,cycle_int_flag -- 按频率付息标志
            ,email -- 电子邮件
            ,int_calc_type -- 计息类型
            ,issue_year -- 发行年度
            ,narrative -- 摘要
            ,precontract_no -- 预约号
            ,precontract_status -- 期次产品预约状态
            ,precontract_type -- 预约登记的账户类型
            ,print_cnt -- 打印次数
            ,res_seq_no -- 限制编号
            ,seq_no -- 序号
            ,source_type -- 渠道编号
            ,stage_code -- 期次代码
            ,stage_prod_class -- 期次产品分类
            ,channel -- 渠道
            ,delete_date -- 删除日期
            ,issue_end_date -- 发行终止日期
            ,issue_start_date -- 发行起始日期
            ,next_cycle_date -- 下一结息日
            ,pledged_flag -- 质押标志
            ,precontract_date -- 预约登记日期
            ,precontract_open_date -- 预约开户日期
            ,redeem_date -- 资产赎回日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,actual_rate -- 行内利率
            ,auth_user_id -- 授权柜员
            ,del_auth_user_id -- 删除授权柜员
            ,del_reason -- 删除原因
            ,del_user_id -- 删除柜员
            ,failure_reason -- 失败原因
            ,float_rate -- 浮动利率
            ,issue_amt -- 期次发行金额
            ,oth_acct_name -- 对方账户名称
            ,oth_acct_seq_no -- 对方账户序列号
            ,oth_base_acct_no -- 对方账号/卡号
            ,oth_ccy -- 对手账户币种
            ,oth_internal_key -- 对手账户内部键
            ,oth_prod_type -- 对方账户产品类型
            ,precontract_amt -- 预约金额
            ,precontract_branch -- 预约/认购机构
            ,precontract_ccy -- 期次产品预约币种
            ,real_rate -- 执行利率
            ,tran_amt -- 交易金额
            ,int_day -- 存贷结息日期
            ,hang_seq_no -- 挂账序列号
            ,dep_term_internal_key -- 定期一本通账户内部键
            ,acct_int_type -- 计息方法
            ,subs_internal_key -- 认购账户内部键
            ,comb_prod_no -- 组合产品编号
            ,charge_int_internal_key -- 收息账户内部键
            ,sub_hang_seq_no -- 追加挂账子序号
            ,exp_redeem_int_amt -- 预计赎回利息
            ,cancel_date -- 撤单日期|撤单日期
            ,' ' as deposit_nature -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_precontract_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
