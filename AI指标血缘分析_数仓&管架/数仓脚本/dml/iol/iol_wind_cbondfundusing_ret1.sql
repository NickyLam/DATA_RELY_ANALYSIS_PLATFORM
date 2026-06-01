/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondfundusing
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
                       FROM wind_cbondfundusing_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('wind_cbondfundusing');
  
  if v_var <> 0 then 
    execute immediate 'alter table wind_cbondfundusing drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table wind_cbondfundusing add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;
  
insert /*+ append */ into ${iol_schema}.wind_cbondfundusing(
        object_id -- 
        ,s_info_windcode -- 
        ,sec_id -- 
        ,start_dt_ora -- 
        ,end_dt_ora -- 
        ,cur_sign -- 
        ,funduse -- 
        ,opdate -- 
        ,opmode -- 
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
            object_id -- 
        ,s_info_windcode -- 
        ,sec_id -- 
        ,start_dt_ora -- 
        ,end_dt_ora -- 
        ,cur_sign -- 
        ,substr(funduse,1,1300)
        ,opdate -- 
        ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.wind_cbondfundusing_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
