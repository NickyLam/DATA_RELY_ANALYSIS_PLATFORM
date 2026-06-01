/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbtrans
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
                       FROM ifms_tbtrans_bak_${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ifms_tbtrans');
  
  if v_var <> 0 then 
    execute immediate 'alter table ifms_tbtrans drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ifms_tbtrans add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.ifms_tbtrans(
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,' ' as prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,' ' as trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ifms_tbtrans_bak_${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
