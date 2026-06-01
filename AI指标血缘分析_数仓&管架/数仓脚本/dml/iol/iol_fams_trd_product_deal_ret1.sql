/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_trd_product_deal
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
                       FROM fams_trd_product_deal_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('fams_trd_product_deal');
  
  if v_var <> 0 then 
    execute immediate 'alter table fams_trd_product_deal drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table fams_trd_product_deal add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.fams_trd_product_deal(
            trade_id -- 交易编号
            ,busi_type -- 业务类型，债券交易、产品交易，估值核算专用
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,settle_speed -- 清算速度
            ,ccy -- 交易币种
            ,cprice_date -- 净值日期
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值(还本前)，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额，债券数量等
            ,prin_amt -- 交易本金，债券券面等
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向，买入、卖出、收息、还本、申购、赎回等
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、撤销
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,p_trade_id -- 原交易编号，撤销时存原来的交易编号
            ,is_clean -- 是否结清，收息付费时用
            ,totle_trade_id -- 汇总交易编号
            ,r_trade_id -- 反向交易编号
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,sec_manage_acct_id -- 证券管理户代码
            ,f_trade_id -- 关联系统交易编号
            ,cash_id -- 现金流代码，还本、付息、付费等时存对应计划的现金流代码
            ,regist_org -- 登记托管机构
            ,remark -- 备注
            ,cancel_remark -- 撤销说明
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,delivery_type -- 
            ,pay_date -- 交付日
            ,sale_code -- 销售代码
            ,split_trade_id -- 拆分前交易编号
            ,is_swap_transaction -- 是否转仓交易
            ,out_of_account -- 出账流水号
            ,org_code -- 所属机构
            ,invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            trade_id -- 交易编号
            ,busi_type -- 业务类型，债券交易、产品交易，估值核算专用
            ,finprod_id -- 金融产品代码
            ,finprod_type -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
            ,finprod_type2 -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
            ,branch -- 分支序号
            ,trade_date -- 交易日期
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,settle_date -- 交割日期
            ,settle_speed -- 清算速度
            ,ccy -- 交易币种
            ,cprice_date -- 净值日期
            ,unit_cprice -- 单位净价
            ,unit_int -- 单位利息
            ,unit_fprice -- 单位全价
            ,par_value -- 单位面值，债券100或者当前面值(还本前)，其他资产1
            ,cprice_amt -- 净价总额
            ,share_amt -- 交易份额，债券数量等
            ,prin_amt -- 交易本金，债券券面等
            ,int_amt -- 利息总额
            ,fprice_amt -- 全价总额
            ,fee_amt_pay -- 随交易支付费用
            ,trade_amt -- 交易金额
            ,fee_amt_unpay -- 未随交易支付费用
            ,fee_amt -- 总交易费用
            ,ps -- 交易方向，买入、卖出、收息、还本、申购、赎回等
            ,yield -- 到期收益率
            ,exer_yield -- 行权收益率
            ,inv_aim -- 投资目的
            ,trade_status -- 交易状态，初始、撤销
            ,is_cancel -- 是否已撤销，默认“否”，在交易发生撤销时更新成“是”
            ,p_trade_id -- 原交易编号，撤销时存原来的交易编号
            ,is_clean -- 是否结清，收息付费时用
            ,totle_trade_id -- 汇总交易编号
            ,r_trade_id -- 反向交易编号
            ,b_trade_id -- 前置交易编号，记录该交易的前置交易编号。比如申购确认时存申购申请交易编号
            ,chl_id -- 渠道/通道代码
            ,counter_id -- 交易对手
            ,is_out_trade -- 是否外部交易，是、否
            ,trade_market -- 交易场所，银行间、上交所、深交所、柜面等
            ,trade_plat -- 交易平台，银行间、上交所固定收益平台、上交所大宗交易平台、深交所大宗平台、深交所综合协议交易平台、其他等
            ,trade_market_mode -- 交易市场，一级市场、二级市场
            ,trader -- 交易员
            ,counter_trader -- 对手方交易员
            ,counter_contact -- 对手方联系方式
            ,sec_manage_acct_id -- 证券管理户代码
            ,f_trade_id -- 关联系统交易编号
            ,cash_id -- 现金流代码，还本、付息、付费等时存对应计划的现金流代码
            ,regist_org -- 登记托管机构
            ,remark -- 备注
            ,cancel_remark -- 撤销说明
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,delivery_type -- 
            ,pay_date -- 交付日
            ,sale_code -- 销售代码
            ,split_trade_id -- 拆分前交易编号
            ,is_swap_transaction -- 是否转仓交易
            ,out_of_account -- 出账流水号
            ,' ' as org_code -- 所属机构
            ,' ' as invest_manager -- 投资经理
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_trd_product_deal_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
