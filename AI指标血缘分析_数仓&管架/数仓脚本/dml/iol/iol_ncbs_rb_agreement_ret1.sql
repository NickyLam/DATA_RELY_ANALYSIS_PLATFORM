/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement
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
                       FROM ncbs_rb_agreement_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_agreement');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_agreement drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_agreement add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_agreement(
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tran_branch -- 核心交易机构编号
            ,is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            acct_name -- 账户名称
            ,acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,client_short -- 客户简称
            ,prod_type -- 产品编号
            ,user_id -- 交易柜员编号
            ,agreement_class -- 协议分类
            ,agreement_close_acct_flag -- 签约后是否允许销户
            ,agreement_id -- 协议编号
            ,agreement_key -- 协议键值
            ,agreement_key_type -- 协议键类型
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,out_sign_channel -- 解约渠道
            ,sign_channel -- 签约渠道
            ,agreement_open_date -- 协议签订日期
            ,end_date -- 结束日期
            ,last_change_date -- 最后修改日期
            ,out_sign_date -- 解约日期
            ,sign_date -- 签约日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,agre_prod_type -- 签约主产品类型
            ,agreement_amt -- 协议金额
            ,last_change_user_id -- 最后修改柜员
            ,opposite_internal_key -- 签约对方账户内部键
            ,out_sign_branch -- 解约机构
            ,out_sign_user_id -- 解约柜员
            ,sign_branch -- 签约机构
            ,sign_user_id -- 签约柜员
            ,tran_branch -- 核心交易机构编号
            ,' ' as is_auto_sign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_agreement_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
