/*
Purpose:    绩效数据切换分区
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_jx_move_data
Createdate: 20210809
Logs:

*/
set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;
--drop table ${idl_schema}.MC_INDEX_FACT_bak_0809 purge;

--备份数据
create table MC_INDEX_FACT_bak_0809 
compress ${option_switch} for query high
as
select * from MC_INDEX_FACT;

--1.2 循环创建指定分区
whenever sqlerror exit sql.sqlcode; 

set serveroutput on 

--此过程用于循环创建子分区
declare
  
   mon_end     DATE;--结束日期
   mon_begin   DATE;--开始日期
   i           DATE;
   exists_flag NUMBER(10) := 0;-- 子分区存在标志 0：没有/大于1：有子分区

begin
  mon_end    :=to_date('20210513','yyyymmdd');
  mon_begin  :=to_date('20201130','yyyymmdd');
  i          :=mon_begin; 
  
  --当开始日期小于结束日期循环创建子分区
WHILE(i <= mon_end) LOOP

  --判断当天子分区是否已存在
   SELECT count(1) INTO exists_flag FROM user_tab_subpartitions WHERE table_name='MC_INDEX_FACT' AND substr(subpartition_name,12,2)='JX' AND substr(subpartition_name,3,8)=to_char(i,'yyyymmdd');

  --子分区不存在 
   IF exists_flag = 0 THEN
  --执行创建子分区 
      EXECUTE IMMEDIATE 'alter table mc_index_fact modify partition p_'|| to_char(i,'yyyymmdd')||' add subpartition p_'|| to_char(i,'yyyymmdd')|| '_jx values (''JX'')'; 
   
   END IF; 

   i := i + 1;

END LOOP;
--若有异常，则打印异常
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('创建分区失败' || SQLERRM);

END;

/

--删除FDW子分区下的绩效数据
delete from MC_INDEX_FACT where substr(index_no,1,2)='JX' and (etl_dt between date'2020-11-30'  and date'2021-05-13')  and source_sys='FDW';

commit;


--绩效数据回插
insert into MC_INDEX_FACT
select
ETL_DT,
INDEX_NO,
INDEX_NAME,
ORG_NO,
ORG_NAME,
SUPER_ORG_NO,
ORG_SORT,
CURR_NO,
CURR_NAME,
INDEX_VALUE,
ACCU_INDEX_VALUE_M,
ACCU_INDEX_VALUE_Y,
RATE_UP_DAY,
RATE_LAST_MONTH,
RATE_LAST_YEAR,
RATE_LAST_PERIOD,
RATE_UP_DAY_PER,
RATE_LAST_MONTH_PER,
RATE_LAST_YEAR_PER,
RATE_LAST_PERIOD_PER,
INDEX_RANKING,
INDEX_RANKING_CHA,
INDEX_VALUE_AVG,
INDEX_VALUE_LIMIT,
RATIO_INDEX,
RATIO_ORG,
UNIT,
FREQUENCY,
MEASURE_NO,
'JX' as SOURCE_SYS,
INDEX_MEASURE,
ETL_TIMESTAMP,
RATE_LAST_QUATER,
RATE_LAST_QUATER_PER	
from MC_INDEX_FACT_bak_0809
where substr(index_no,1,2)='JX' and (etl_dt between date'2020-11-30'  and date'2021-05-13')  and source_sys='FDW';

commit;

--drop table MC_INDEX_FACT_bak_0809 purge;
