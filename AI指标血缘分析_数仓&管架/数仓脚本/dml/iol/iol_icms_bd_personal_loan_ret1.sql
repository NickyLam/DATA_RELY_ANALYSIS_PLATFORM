/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_BD_PERSONAL_LOAN_ret1
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
                       FROM ICMS_BD_PERSONAL_LOAN_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_BD_PERSONAL_LOAN');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_BD_PERSONAL_LOAN drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_BD_PERSONAL_LOAN add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_BD_PERSONAL_LOAN(
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,custloantype -- 
            ,isagriculture -- 
            ,entclaimserialno -- 
            ,retailclaimserialno -- 
            ,entclaimimageinfono -- 
            ,indclaimimageinfono -- 
            ,isbelongterm -- 
            ,productchannel -- 
            ,ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 借据编号
            ,iswhite -- 是否白户
            ,balloonamortenddate -- 气球贷摊销到期日
            ,isfarmer -- 是否农户
            ,migtflag -- 迁移标志
            ,indtype -- 客户性质：IndType
            ,taxflg -- 是否涉税：YesNo
            ,' ' AS custloantype -- 
            ,' ' AS isagriculture -- 
            ,' ' AS entclaimserialno -- 
            ,' ' AS retailclaimserialno -- 
            ,' ' AS entclaimimageinfono -- 
            ,' ' AS indclaimimageinfono -- 
            ,' ' AS isbelongterm -- 
            ,' ' AS productchannel -- 
            ,' ' AS ftpapplyno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_BD_PERSONAL_LOAN_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
