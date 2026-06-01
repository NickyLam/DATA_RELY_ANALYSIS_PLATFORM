/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_base_acct
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
                       FROM ncbs_rb_base_acct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_base_acct');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_base_acct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_base_acct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_base_acct(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,acct_status -- 账户状态
            ,acct_type -- 账户类型
            ,base_acct_no -- 交易账号/卡号
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,acct_close_date -- 销户日期
            ,reason_code -- 
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
            ,card_no -- 卡号
            ,client_no -- 客户编号
            ,client_type -- 客户类型
            ,doc_type -- 凭证类型
            ,document_id -- 证件号码
            ,document_type -- 客户证件类型
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,voucher_status -- 凭证状态
            ,acct_desc -- 账户描述
            ,acct_exec -- 银行客户经理编号
            ,acct_res_status -- 账户限制标志
            ,acct_status_prev -- 账户上一状态
            ,all_dep_ind -- 通存标志
            ,all_dra_ind -- 通兑标志
            ,checked_flag -- 黑名单是否已检查标志位
            ,company -- 法人
            ,prefix -- 前缀
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,terminal_id -- 交易终端编号
            ,fixed_call -- 定期账户细类
            ,acct_open_date -- 账户开户日期
            ,acct_status_upd_date -- 账户状态变更日期
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,iss_country -- 发证国家
            ,acct_branch -- 开户机构编号
            ,acct_ccy -- 账户币种
            ,acct_close_reason -- 关闭原因
            ,acct_close_user_id -- 账户销户操作柜员
            ,alt_acct_name -- 备用账户名称
            ,last_change_user_id -- 最后修改柜员
            ,old_prod_type -- 原产品类型
            ,voucher_start_no -- 凭证起始号码
            ,to_date('00010101','yyyymmdd') as acct_close_date -- 销户日期
            ,' ' as reason_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_base_acct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
