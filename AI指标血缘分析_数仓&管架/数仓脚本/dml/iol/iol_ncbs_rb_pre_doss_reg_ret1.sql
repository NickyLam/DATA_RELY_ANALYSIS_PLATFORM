/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_pre_doss_reg
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
                       FROM ncbs_rb_pre_doss_reg_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_pre_doss_reg');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_pre_doss_reg drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_pre_doss_reg add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_pre_doss_reg(
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            batch_no -- 批次号|批次号
            ,base_acct_no -- 交易账号/卡号|用于描述不同账户结构下的账号，如果是卡的话代表卡号，否则代表账号
            ,acct_seq_no -- 账户子账号|账户序列号，采用顺序数字，表示在同一账号、账户类型、币种下的不同子账户，比如定期存款序列号，卡下选择账户
            ,doss_date -- 转久悬日期|转久悬日期
            ,acct_name -- 账户名称|账户名称，一般指中文账户名称
            ,acct_branch -- 开户机构编号|账户实际开户机构，柜面为实际网点机构，线上渠道一般为对应主账户的实际开户机构
            ,pre_trf_flag -- 预转标识|久悬户预转标识|s-预转成功,f-预转失败
            ,batch_status -- 批次处理状态|批次处理状态|n-新建,v-已验证,w-待处理(部分成功),s-成功,f-失败,d-待审批,a-已审批
            ,failure_reason -- 失败原因|失败原因
            ,audit_date -- 审计日期|审计日期
            ,company -- 法人|法人
            ,tran_timestamp -- 交易时间戳|交易时间戳
            ,approve_status -- 审批状态|久悬户处理审批状态|y-审核通过,n-审核不通过
            ,remark -- 备注|备注
            ,internal_key -- 账户内部键值|账户内部键值
            ,client_no -- 客户编号|客户编号
            ,approval_date -- 复核日期|复核日期
            ,sub_seq_no -- 系统子流水号|系统子流水号
            ,user_id -- 交易柜员编号|核心交易柜员编号
            ,' ' as control_msg -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_pre_doss_reg_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
