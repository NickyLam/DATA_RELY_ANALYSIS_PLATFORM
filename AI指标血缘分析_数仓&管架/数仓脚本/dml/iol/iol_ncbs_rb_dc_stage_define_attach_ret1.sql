/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_stage_define_attach
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
                       FROM ncbs_rb_dc_stage_define_attach_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ncbs_rb_dc_stage_define_attach');
  
  if v_var <> 0 then 
    execute immediate 'alter table ncbs_rb_dc_stage_define_attach drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ncbs_rb_dc_stage_define_attach add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_stage_define_attach(
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,un_white_view_flag -- 
            ,om_apply_no -- 
            ,roll_issue_flag -- 
            ,roll_start_date -- 
            ,roll_end_date -- 
            ,redeem_term_type -- 
            ,redeem_term -- 
            ,white_change_flag -- 
            ,white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            trf_out_fee_type -- 转出费用类型
            ,sell_branch -- 出售分行或者出售机构
            ,change_min_amt -- 期次最小变动金额
            ,client_type -- 客户类型
            ,int_type -- 利率类型
            ,user_id -- 交易柜员编号
            ,company -- 法人
            ,email -- 电子邮件
            ,inland_offshore -- 境内境外标志
            ,settle_acct_type -- 结算账户类型
            ,stage_code -- 期次代码
            ,trf_flag -- 转让标志
            ,int_start_date -- 起息日
            ,maturity_date -- 到期日期
            ,tran_timestamp -- 交易时间戳
            ,available_limit -- 可用额度
            ,float_rate -- 浮动利率
            ,keep_min_bal -- 最小留存金额
            ,real_rate -- 执行利率
            ,sg_max_amt -- 单笔认购最大金额
            ,sg_min_amt -- 单次最小支取金额
            ,spread_percent -- 浮动百分比
            ,tohonor_rate -- 赎回利率
            ,on_sale_channel -- 产品可售渠道
            ,prod_desc_address -- 产品说明书链接
            ,redemption_int_type -- 大额存单赎回利率类型
            ,trf_in_fee_type -- 转入费用类型
            ,trf_in_fee_amt -- 转入费用
            ,comb_prod_flag -- 是否组合产品
            ,allow_fund_source_inner_flag -- 是否允许资金来源为内部户
            ,redemption_int_flag -- 赎回利率标识
            ,int_start_flag -- 起息标识
            ,direction_charge_int_flag -- 指定收息标志
            ,promissory_redeem_date -- 原约定赎回日期
            ,trf_out_fee_amt -- 转出费用
            ,' ' as un_white_view_flag -- 
            ,' ' as om_apply_no -- 
            ,' ' as roll_issue_flag -- 
            ,to_date('00010101','yyyymmdd') as roll_start_date -- 
            ,to_date('00010101','yyyymmdd') as roll_end_date -- 
            ,' ' as redeem_term_type -- 
            ,' ' as redeem_term -- 
            ,' ' as white_change_flag -- 
            ,' ' as white_support_branch -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_dc_stage_define_attach_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
