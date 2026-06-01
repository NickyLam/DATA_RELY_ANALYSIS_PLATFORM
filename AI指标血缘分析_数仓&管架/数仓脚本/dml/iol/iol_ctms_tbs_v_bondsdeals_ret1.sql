/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_bondsdeals
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
                       FROM ctms_tbs_v_bondsdeals_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ctms_tbs_v_bondsdeals');
  
  if v_var <> 0 then 
    execute immediate 'alter table ctms_tbs_v_bondsdeals drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ctms_tbs_v_bondsdeals add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */into ${iol_schema}.ctms_tbs_v_bondsdeals(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手id
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是cfets交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,assettype_id -- 资产类型id
            ,bondsdeals_id_grand -- 原始交易id
            ,stock_id -- 股票代码
            ,convert_price -- 转股价格
            ,stock_price -- 正股价格
            ,convert_quantity -- 转股数量
            ,dn_dealer -- 本币交易员
            ,currency -- 币种
            ,tradetime -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,bondstype -- 债券类型
            ,serial_number -- 交易号
            ,tradedate -- 交易日
            ,settledate -- 交割日
            ,buyorsell -- 买卖方向
            ,cleanprice -- 交易净价
            ,dirtyprice -- 交易全价
            ,yieldtomaturity -- 到期收益率
            ,settleamount -- 结算金额
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,folderatts -- 账户属性
            ,classfyname -- 四分类名称
            ,cptys_shortname -- 交易对手名称
            ,cptys_id -- 交易对手id
            ,settletype -- 结算方式
            ,dealer_id -- 交易员
            ,dealer_name -- 交易员名称
            ,ref_number -- 成交编号
            ,feeamount -- 手续费
            ,taxamount -- 税金
            ,brokeramount -- 佣金
            ,note -- 备注
            ,nominal -- 券面总额
            ,accruedamount -- 应计利息总额
            ,cfets_from -- 是否是cfets交易
            ,source -- 交易来源
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,assettype_id -- 资产类型id
            ,bondsdeals_id_grand -- 原始交易id
            ,stock_id -- 股票代码
            ,convert_price -- 转股价格
            ,stock_price -- 正股价格
            ,convert_quantity -- 转股数量
            ,dn_dealer -- 本币交易员
            ,currency -- 币种
            ,' ' as tradetime -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ctms_tbs_v_bondsdeals_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
