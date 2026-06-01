/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_acct_trans_fft
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
                       FROM icms_acct_trans_fft_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_acct_trans_fft');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_acct_trans_fft drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_acct_trans_fft add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    

insert /*+ append */ into ${iol_schema}.icms_acct_trans_fft(
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,counterparty -- 交易对手
            ,counterpartyid -- 交易对手编号
            ,shroffaccount -- 收款账号
            ,loannumber -- 借据笔数
            ,resalegatheramount -- 转卖收款金额汇总
            ,resaleloanamount -- 转卖借据金额汇总
            ,transferins -- 转让说明
            ,completeflag -- 暂存标志
            ,fundsourceaccountno -- 资金来源账号
            ,fundsourcebankid -- 资金来源行号
            ,fundsourceaccountname -- 资金来源户名
            ,' ' as fundsourcebankname -- 资金来源行名
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_acct_trans_fft_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
