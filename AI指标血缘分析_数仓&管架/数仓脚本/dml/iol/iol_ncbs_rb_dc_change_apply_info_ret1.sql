/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_change_apply_info
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
                       FROM ncbs_rb_dc_change_apply_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_dc_change_apply_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_dc_change_apply_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_dc_change_apply_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_change_apply_info(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_name -- 客户名称
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,res_seq_no -- 限制编号
            ,stage_code -- 期次代码
            ,last_change_date -- 最后修改日期
            ,tran_date -- 交易日期
            ,tran_timestamp -- 交易时间戳
            ,dep_keep_days -- 存款天数
            ,int_rem_days -- 计息剩余天数
            ,trf_total_settle_amt -- 转让总对价
            ,trf_end_date -- 转让到期日
            ,direction_trf_flag -- 是否定期转让
            ,order_start_date -- 挂单起始日期
            ,trf_in_fee_amt -- 转入费用
            ,order_end_date -- 挂单结束日期
            ,trf_pri_amt -- 转让本金金额
            ,trf_command -- 转让口令
            ,trf_rate -- 转让利率
            ,trf_type -- 转让类型
            ,trf_status -- 转让状态
            ,beneficiary_client_no -- 受益人客户号
            ,trf_no -- 转让号
            ,trf_date -- 转让日期
            ,beneficiary_profit_rate -- 受让人收益率
            ,trf_out_fee_amt -- 转出费用
            ,prod_type -- 产品编号|产品编号
            ,settle_acct_seq_no -- 结算账户序号|结算账户序号
            ,settle_base_acct_no -- 结算账号|结算账号
            ,inner_base_acct_no -- 转入账号/卡号
            ,reference -- 转让流水号
            ,' ' as rec_time -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_change_apply_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
