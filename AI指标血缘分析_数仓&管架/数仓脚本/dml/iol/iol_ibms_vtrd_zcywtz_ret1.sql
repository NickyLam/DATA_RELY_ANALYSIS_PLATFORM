/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_vtrd_zcywtz
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
                       FROM ibms_vtrd_zcywtz_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ibms_vtrd_zcywtz');
  
  if v_var <> 0 then 
    execute immediate 'alter table ibms_vtrd_zcywtz drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ibms_vtrd_zcywtz add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ibms_vtrd_zcywtz(
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,datamark -- 唯一标识
            ,month_repay_record -- 当月还本记录
            ,month_average -- 月日均
            ,year_average -- 年日均
            ,in_due_ai -- 表内应收未收利息
            ,out_due_ai -- 表外应收利息
            ,this_month_prft_ir -- 利息收入（当月）
            ,this_year_prft_ir -- 利息收入（本年）
            ,year_chg_fv -- 公允价值变动（年初）
            ,month_chg_fv -- 公允价值变动（当月）
            ,year_prft_fv_real -- 公允价值变动损益（本年）
            ,year_prft_trd -- 买卖损益（本年）
            ,prft_ir_subj_code -- 利息损益科目号
            ,prft_trd_subj_code -- 价差损益科目号
            ,chg_fv_subj_code -- 估值损益科目号
            ,basic_asset_clients -- 基础资产客户
            ,underly_types_assets -- 底层资产类型
            ,guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            obj_id -- 核算id
            ,beg_date -- 余额日期
            ,org_id -- 机构号
            ,trade_id -- 交易单号
            ,secu_acct_name -- 投组单元
            ,dict_value -- 会计分类
            ,p_type_name -- 产品类型
            ,p_class -- 产品分类
            ,i_code -- 金融工具代码
            ,i_name -- 金融工具名称
            ,trd_orddate -- 交易日期
            ,trd_party_name -- 交易对手
            ,trd_party_class -- 交易对手客户分类
            ,issue_name -- 发行人/实际融资人
            ,issue_class -- 实际融资人客户分类
            ,exhacc -- 划款账号
            ,party_acct_code -- 收款账号
            ,currency -- 币种
            ,cp -- 投资本金
            ,coupon -- 执行利率
            ,open_date -- 起息日
            ,end_date -- 到期日
            ,inst_start_date -- 原始期限
            ,inst_mrt_date -- 剩余期限
            ,first_payment_date -- 首次付息日
            ,pay_freq_name -- 付息频率
            ,daycount_name -- 计息基准
            ,coupon_type_name -- 息票类型
            ,tzye -- 投资余额
            ,ai -- 应计利息
            ,prft_ir -- 利息收入
            ,zmye -- 账面余额
            ,business_category_name -- 投向行业门类
            ,business_category_min_name -- 投向行业大类
            ,s_grade -- 债项/主体评级
            ,g31_plass -- g31分类
            ,final_invest_name -- 最终投向类型
            ,management_mode -- 管理方式
            ,raise_way -- 产品募集方式
            ,tzcplx -- 投资产品类型
            ,under_debt_class -- 底层为债券的债券分类
            ,under_debt_rating -- 底层为债券的评级
            ,hx_isgover_fund -- 是否政府投资基金
            ,is_pioneer_invest_fund -- 是否创业投资基金
            ,hx_isdistbus -- 是否异地业务
            ,hx_islocfinanc -- 是否地方政府融资平台
            ,risk_assets_weight -- 风险权重
            ,trader -- 经办人
            ,op_user_name1 -- 总行经办人
            ,op_user_name2 -- 总行复核人
            ,cp_subj_code -- 本金科目号
            ,ai_tax_rate -- 增值税税率(应计利息收入)
            ,amrt_tax_rate -- 增值税税率(摊销利息收入)
            ,trd_tax_rate -- 增值税税率(买卖损益)
            ,ibs -- 数据来源
            ,hxkhh -- 交易对手核心客户号
            ,hxkhh1 -- 实际融资人核心客户号
            ,mid_invest_industry_categories -- 投向行业中类
            ,invest_industry_subcategories -- 投向行业细类
            ,funds_purpose -- 资金用途
            ,guarantee_method -- 担保方式
            ,credit_methods -- 增信方式
            ,credit_cust -- 增信主体
            ,' ' as datamark -- 唯一标识
            ,' ' as month_repay_record -- 当月还本记录
            ,0 as month_average -- 月日均
            ,0 as year_average -- 年日均
            ,0 as in_due_ai -- 表内应收未收利息
            ,0 as out_due_ai -- 表外应收利息
            ,0 as this_month_prft_ir -- 利息收入（当月）
            ,0 as this_year_prft_ir -- 利息收入（本年）
            ,0 as year_chg_fv -- 公允价值变动（年初）
            ,0 as month_chg_fv -- 公允价值变动（当月）
            ,0 as year_prft_fv_real -- 公允价值变动损益（本年）
            ,0 as year_prft_trd -- 买卖损益（本年）
            ,' ' as prft_ir_subj_code -- 利息损益科目号
            ,' ' as prft_trd_subj_code -- 价差损益科目号
            ,' ' as chg_fv_subj_code -- 估值损益科目号
            ,' ' as basic_asset_clients -- 基础资产客户
            ,' ' as underly_types_assets -- 底层资产类型
            ,' ' as guarantee_description -- 担保描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ibms_vtrd_zcywtz_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
