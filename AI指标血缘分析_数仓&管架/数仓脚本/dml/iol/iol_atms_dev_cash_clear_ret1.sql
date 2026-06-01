/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_cash_clear
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
                       FROM atms_dev_cash_clear_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('atms_dev_cash_clear');
  
  if v_var <> 0 then 
    execute immediate 'alter table atms_dev_cash_clear drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table atms_dev_cash_clear add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.atms_dev_cash_clear(
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,' ' as add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_dev_cash_clear_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
