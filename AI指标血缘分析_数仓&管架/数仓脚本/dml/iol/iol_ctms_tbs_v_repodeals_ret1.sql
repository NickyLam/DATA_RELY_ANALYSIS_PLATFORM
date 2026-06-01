/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_repodeals
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
                       FROM ctms_tbs_v_repodeals_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ctms_tbs_v_repodeals');
  
  if v_var <> 0 then 
    execute immediate 'alter table ctms_tbs_v_repodeals drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ctms_tbs_v_repodeals add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ctms_tbs_v_repodeals(
            deal_id -- 引用表id
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 券面总额
            ,first_price -- 首次净价
            ,maturity_price -- 到期净价
            ,repo_rate -- 回购利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 回购天数
            ,repodeals_id_grand -- 原始交易id
            ,repo_id -- 回购名称
            ,clearing_type -- 清算类型
            ,dn_dealer -- 本币交易员
            ,trade_time -- 交易时间
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
            ,serial_number -- 交易号(标识数据表中记录的唯一组合)
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 券面总额
            ,first_price -- 首次净价
            ,maturity_price -- 到期净价
            ,repo_rate -- 回购利率
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户id
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手id
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer_id -- 交易员id
            ,dealer_name -- 交易员姓名
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是cfets交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源id
            ,repo_days -- 回购天数
            ,repodeals_id_grand -- 原始交易id
            ,repo_id -- 回购名称
            ,clearing_type -- 清算类型
            ,dn_dealer -- 本币交易员
            ,to_date('00010101','yyyymmdd') as trade_time -- 交易时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ctms_tbs_v_repodeals_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
