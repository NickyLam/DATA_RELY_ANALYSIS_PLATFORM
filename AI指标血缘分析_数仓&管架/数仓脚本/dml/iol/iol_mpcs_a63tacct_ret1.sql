/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a63tacct
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
                       FROM mpcs_a63tacct_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('mpcs_a63tacct');
  
  if v_var <> 0 then 
    execute immediate 'alter table mpcs_a63tacct drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table mpcs_a63tacct add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.mpcs_a63tacct(
            signno -- 签约号
            ,acctno -- 账号
            ,acctname -- 账户名称
            ,custno -- 客户号
            ,permit -- 账户权限
            ,openbrcno -- 开户机构号
            ,stat -- 状态
            ,signdt -- 签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            signno -- 签约号
            ,acctno -- 账号
            ,acctname -- 账户名称
            ,custno -- 客户号
            ,permit -- 账户权限
            ,openbrcno -- 开户机构号
            ,stat -- 状态
            ,' ' as signdt -- 签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from mpcs_a63tacct_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
