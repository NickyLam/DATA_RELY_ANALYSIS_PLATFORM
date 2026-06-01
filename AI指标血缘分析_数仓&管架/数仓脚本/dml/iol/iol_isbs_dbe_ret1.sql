/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_dbe
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
                       FROM isbs_dbe_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('isbs_dbe');
  
  if v_var <> 0 then 
    execute immediate 'alter table isbs_dbe drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table isbs_dbe add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    

end loop;
end;
/
 
insert /*+ append */ into ${iol_schema}.isbs_dbe(
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,oppacc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            inr -- 
            ,tmpref -- 
            ,ownextkey -- 
            ,ver -- 
            ,actiontype -- 
            ,actiondesc -- 
            ,rptno -- 
            ,custype -- 
            ,idcode -- 
            ,custcod -- 
            ,custnm -- 
            ,oppuser -- 
            ,txccy -- 
            ,txamt -- 
            ,exrate -- 
            ,lcyamt -- 
            ,lcyacc -- 
            ,fcyamt -- 
            ,fcyacc -- 
            ,othamt -- 
            ,othacc -- 
            ,methods -- 
            ,buscode -- 
            ,oppacc -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from isbs_dbe_bak${batch_date}
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') and inr !=' ';
commit;

