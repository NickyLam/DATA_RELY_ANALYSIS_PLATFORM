/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_new_balance
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
                       FROM ctms_tbs_v_new_balance_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ctms_tbs_v_new_balance');
  
  if v_var <> 0 then 
    execute immediate 'alter table ctms_tbs_v_new_balance drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ctms_tbs_v_new_balance add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.ctms_tbs_v_new_balance(
            baretrade_id -- 
            ,baretradename -- 
            ,balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,arvinterestcost -- 挂账金额
            ,arvinterestcost_subjectid -- 挂账科目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            baretrade_id -- 
            ,baretradename -- 
            ,balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,0 as arvinterestcost -- 挂账金额
            ,' ' as arvinterestcost_subjectid -- 挂账科目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_new_balance_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
