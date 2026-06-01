/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_fin_product_add
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
                       FROM fams_fin_product_add_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('fams_fin_product_add');
  
  if v_var <> 0 then 
    execute immediate 'alter table fams_fin_product_add drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table fams_fin_product_add add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.fams_fin_product_add(
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            finprod_id -- 金融产品代码
            ,sale_department -- 销售部门，零售产品管理部、金融同业部、对公产品和现金管理部
            ,sale_layer -- 销售分层
            ,sale_period -- 销售期次
            ,pur_speed -- 申购确认速度，如果资产只有一个确认速度，则存该字段
            ,red_speed -- 赎回确认速度
            ,is_sec_bond -- 是否次级债
            ,wind_id -- wind对象id
            ,is_auto_update -- 是否接口自动更新
            ,portfolio_id -- 投资组合代码
            ,prod_regist_code -- 产品登记编码
            ,is_cycle -- 是否周期型
            ,is_lay -- 是否分层
            ,lay_type -- 分层类型，金额分层、期限分层、客户类型
            ,invest_nature -- 投资性质，固定收益类、权益类、商品及金融衍生品类、混合类
            ,profit_flag -- 收益标识，非保本浮动收益型、保本浮动、保证收益型
            ,sale_mode -- 销售模式，直销、代销、委托
            ,chb_id -- 中债报送编码
            ,tmpl_id -- 产品模板代码
            ,close_days -- 封闭期限(天)，产品每次开放对应的封闭期限
            ,issue_status -- 产品发行状态
            ,issue_status_remark -- 发行状态备注
            ,is_compound_int -- 是否按日复利
            ,term_type -- 期限品种
            ,face_value -- 面值，债券单位面值
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,pay_type -- 划款方式
            ,is_reconciliation -- 是否对账
            ,is_cash_manage -- 是否现金管理类
            ,risk_level -- 产品风险等级
            ,deal_mode -- 处理模式
            ,is_exclusive -- 是否专属产品
            ,bid_date -- 投标日期
            ,board -- 上市板
            ,sh_or_zh -- 是否沪港通或深港通
            ,is_margin_finprod -- 是否融资融券标的
            ,city_bond_lev -- 城投债级别
            ,is_city_bond -- 是否城投债
            ,investment_cycle -- 投资周期
            ,prod_manager -- 产品经理
            ,collect_type -- 收取方式
            ,regulatory_rating -- 监管评级
            ,toff_enddate -- 认购终止日
            ,trm_fund_abbr -- 交易所基金简称
            ,trm_fund_type -- 交易所基金类型
            ,gra_fund_type -- 分级基金
            ,pur_red_id -- 申购赎回代码
            ,pur_red_abbr -- 申购赎回简称
            ,pur_start_low -- 单笔申购金额下限
            ,red_start_low -- 单笔赎回份额下限
            ,etf_type -- etf类型
            ,etf_min_prunit -- etf最小申购赎回单位
            ,toff_strdate -- 认购起始日
            ,' ' as org_code -- 所属机构
            ,' ' as invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_fin_product_add_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
