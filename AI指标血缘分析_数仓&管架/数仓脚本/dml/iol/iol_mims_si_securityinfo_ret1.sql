/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_securityinfo
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
                       FROM mims_si_securityinfo_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mims_si_securityinfo');
  
  if v_var <> 0 then 
    execute immediate 'alter table mims_si_securityinfo drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mims_si_securityinfo add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.mims_si_securityinfo(
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            sccode -- 
            ,guartype -- 
            ,createuser -- 
            ,deptcode -- 
            ,createdate -- 
            ,conominium -- 
            ,conshare -- 
            ,effecttype -- 
            ,isinsure -- 
            ,guaregisterstate -- 
            ,guainsurestate -- 
            ,state -- 
            ,usestate -- 
            ,guaspecialstate -- 
            ,bxability -- 
            ,isotherguar -- 
            ,isgencust -- 
            ,confmamt -- 
            ,confmcurrency -- 
            ,evaldate -- 
            ,datasourceflag -- 
            ,exapstate -- 
            ,editstate -- 
            ,bxability2 -- 
            ,isgain -- 
            ,ismodify -- 
            ,guarinfoname -- 
            ,controlchange -- 
            ,updates -- 
            ,upduser -- 
            ,issaveowner -- 是否保存我行
            ,amount -- 优先受偿权数额
            ,issequence -- 是否第一顺位 C0101         0 否、1 是
            ,' ' as guarsign -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_securityinfo_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
