/*
Purpose:    共性加工层-日常删除分区脚本，此脚本由手工生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd dqc_icl_enty_tab_drop_partition
CreateDate: 20200416
FileType:   DML
Logs:
   20210716 何桐金  更改逻辑：resv_ped=2保留最近10天和月末3天)      
                              resv_ped is null 不处理
                              resv_ped=1 月末两3天+最近2个月
   20251118 陈伟峰 调整resv_ped=1 月末3天+最近2个月
*/

set timing on
set serveroutput on
-- 执行清理操作


declare
  vc_flag number(10) := 0;
  vc_partition_name varchar2(100) := 0;
  vc_del_dt varchar2(8) := null;
  vc_del_dt_10 date := null;
  vc_partition_name_10 varchar2(100) := 0;
begin 	 
	vc_del_dt         := to_char(add_months(to_date('${batch_date}', 'yyyymmdd'), -3), 'yyyymmdd');
  vc_partition_name := 'P_' || vc_del_dt;
  vc_del_dt_10  := trunc(to_date('${batch_date}', 'yyyymmdd'))-11;  
  vc_partition_name_10 := 'P_' ||to_char(vc_del_dt_10,'yyyymmdd');  
  -- 读取ICL的表信息及清理机制
  for tb in (select tab_en_name,resv_ped from icl.cmm_icl_enty_tab_info where resv_ped is not null
    --  and tab_en_name in('CMM_IFS_ACCT_INFO','CMM_INDV_CUST_BASIC_INFO')
      ) loop
    if tb.resv_ped=2 then
       if vc_del_dt_10 <> last_day(vc_del_dt_10) 
          and vc_del_dt_10 <> last_day(vc_del_dt_10)-1
          and vc_del_dt_10 <> last_day(vc_del_dt_10)-2 then          
      -- 判断传入的分区是不存在
        select count(1)
          into vc_flag
          from user_tab_partitions
         where table_name = upper(tb.tab_en_name)
           and partition_name = vc_partition_name_10;
        if vc_flag <> 0 then                  
             execute immediate 'alter table icl.' || tb.tab_en_name || ' drop partition ' || vc_partition_name_10;                         
           end if;                           
      end if;   
    elsif  tb.resv_ped=1 then                         
      if  (vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 1), 'yyyymmdd') and
            vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 2), 'yyyymmdd') and
          vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 3), 'yyyymmdd')) then
        --and vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 3), 'yyyymmdd') )                     
        -- 判断传入的分区是不存在
        select count(1)
          into vc_flag
          from user_tab_partitions
         where table_name = upper(tb.tab_en_name)
           and partition_name = vc_partition_name;           
        -- 如果分区存在，则删除
        if vc_flag <> 0 then        
          execute immediate 'alter table icl.' || tb.tab_en_name || ' drop partition ' || vc_partition_name;          
        end if;               
      end if; 
   /*  else       
      if (vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 1), 'yyyymmdd') and
         vc_del_dt <> to_char((trunc(add_months(to_date(vc_del_dt, 'yyyymmdd'), 1), 'mm') - 2), 'yyyymmdd') ) then
       -- 判断传入的分区是不存在
        select count(1)
          into vc_flag
          from user_tab_partitions
         where table_name = upper(tb.tab_en_name)
           and partition_name = vc_partition_name;          
        -- 如果分区存在，则删除
        if vc_flag <> 0 then       
          execute immediate 'alter table icl.' || tb.tab_en_name || ' drop partition ' || vc_partition_name;         
        end if;                
      end if;*/             
    end if;        
  end loop;
end;
/