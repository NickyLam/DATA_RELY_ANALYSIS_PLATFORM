/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_APPLY_RELATIVE_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_APPLY_RELATIVE_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_APPLY_RELATIVE');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_APPLY_RELATIVE drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_APPLY_RELATIVE add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_APPLY_RELATIVE(
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativesum -- 关联金额
            ,oldcontractno -- 旧额度合同号
            ,renewsum -- 
            ,renewdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,objecttype -- 对象类型
            ,objectno -- 对象编号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,relativesum -- 关联金额
            ,oldcontractno -- 旧额度合同号
            ,0 AS renewsum -- 
            ,to_date('00010101','yyyymmdd') as renewdate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_APPLY_RELATIVE_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
