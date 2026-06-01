set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

drop table ${idl_schema}.MC_INDEX_FACT_SUP_temp01 purge ;
drop table ${idl_schema}.MC_INDEX_FACT_SUP_temp02 purge ;
delete  ${idl_schema}.MC_INDEX_FACT_SUP where etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


create table  MC_INDEX_FACT_SUP_temp01
as
select    a.ETL_DT            as ETL_DT   --日期                                                           
         ,c.INDEX_NO          as INDEX_NO --指标编码                                                          
         ,c.INDEX_NAME        as INDEX_NAME --指标名称                                                          
         ,c.PAGE_ROUTE        as PAGE_ROUTE     --页面路由                                                          
         ,c.PAGE_SEAT	        as PAGE_SEAT   --页面位置 
         ,c.CHART_TITLE       as CHART_TITLE --图表标题                                                          
         ,a.ORG_NO            as ORG_NO         --机构编码                                                          
         ,a.ORG_NAME          as ORG_NAME     --机构名称                                                          
         ,a.super_org_no	    as super_org_no   --上级机构编号 
         ,a.CURR_NO           as CURR_NO --币种编号                                                          
         ,a.CURR_NAME         as CURR_NAME  --币种名称                                                          
         ,a.INDEX_VALUE       as INDEX_VALUE     --指标值                                                          
         ,0                  as INDEX_VALUE_LIMIT	   --阀值 
         ,b.SUP_LOGIC1||round(b.SUP_VALUE1,4)||b.SUP_LOGIC2||round(b.SUP_VALUE2,4)        
                              as SUP_LOGIC --逻辑关系 
         ,c.FIELD_NO          as FIELD_NO --字段编号                                                          
         ,c.FIELD_NAME        as FIELD_NAME  --字段名称                                                          
         ,c.MEASURE_NO        as MEASURE_NO     --度量编号                                                          
         ,c.INDEX_MEASURE     as INDEX_MEASURE	   --度量名称 
         ,a.UNIT              as UNIT --单位    
         ,a.SOURCE_SYS        as SOURCE_SYS	   --来源系统 
        ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --ETL处理时间戳                                                                                                           
  from mc_index_fact a
  left join MC_SUP_INDEX b
    on a.index_no = b.index_no
  left join mc_sup_page c
    on b.index_no = c.index_no
   and a.measure_no = c.measure_no
 where a.etl_dt = to_date('${batch_date}','yyyymmdd')
 --  and a.org_no in ('801','802','803','805','806','807','808','809','810','811','000000')
   and ((c.org_class='0' and a.org_no in('000000')) or (c.org_class='3' and a.org_no in('801','802','803','805','806','807','808','809','810','811')))
   and a.CURR_NO='BWB'
   and c.INDEX_NO not like 'YL%'
   and b.sup_status = '1'
   and c.FIELD_NO='index_value'
   and c.page_seat is not null
   and ((case
         when b.sup_logic1 = '小于等于' then
          a.index_value - b.sup_value1
         when b.sup_logic1 = '小于' then
          a.index_value - b.sup_value1
         when b.sup_logic1 = '大于等于' then
          b.sup_value1 - a.index_value
         when b.sup_logic1 = '大于' then
          b.sup_value1 - a.index_value
         else
          0
       end) < 0 or (case
         when b.sup_logic2 = '小于等于' then
          a.index_value - b.sup_value2
         when b.sup_logic2 = '小于' then
          a.index_value - b.sup_value2
         when b.sup_logic2 = '大于等于' then
          b.sup_value2 - a.index_value
         when b.sup_logic2 = '大于' then
          b.sup_value2 - a.index_value
         else
          0
       end) < 0);


COMMIT ;

create table  MC_INDEX_FACT_SUP_temp02
as
select    a.ETL_DT            as ETL_DT   --日期                                                           
         ,c.INDEX_NO          as INDEX_NO --指标编码                                                          
         ,c.INDEX_NAME        as INDEX_NAME --指标名称                                                          
         ,c.PAGE_ROUTE        as PAGE_ROUTE     --页面路由                                                          
         ,c.PAGE_SEAT	        as PAGE_SEAT   --页面位置 
         ,c.CHART_TITLE       as CHART_TITLE --图表标题                                                          
         ,a.ORG_NO            as ORG_NO         --机构编码                                                          
         ,a.ORG_NAME          as ORG_NAME     --机构名称                                                          
         ,a.super_org_no	    as super_org_no   --上级机构编号 
         ,a.CURR_NO           as CURR_NO --币种编号                                                          
         ,a.CURR_NAME         as CURR_NAME  --币种名称                                                          
         ,a.INDEX_VALUE       as INDEX_VALUE     --指标值                                                          
         ,0                  as INDEX_VALUE_LIMIT	   --阀值 
         ,b.SUP_LOGIC1||round(b.SUP_VALUE1,4)||b.SUP_LOGIC2||round(b.SUP_VALUE2,4)        
                              as SUP_LOGIC --逻辑关系 
         ,c.FIELD_NO          as FIELD_NO --字段编号                                                          
         ,c.FIELD_NAME        as FIELD_NAME  --字段名称                                                          
         ,c.MEASURE_NO        as MEASURE_NO     --度量编号                                                          
         ,c.INDEX_MEASURE     as INDEX_MEASURE	   --度量名称 
         ,a.UNIT              as UNIT --单位    
         ,a.SOURCE_SYS        as SOURCE_SYS	   --来源系统 
        ,to_timestamp('${batch_timestamp}','yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --ETL处理时间戳                                                                                                           
  from mc_index_fact a
  left join MC_SUP_INDEX b
    on a.index_no = b.index_no
  left join mc_sup_page c
    on b.index_no = c.index_no
   and a.measure_no = c.measure_no
 where a.etl_dt = to_date('${batch_date}','yyyymmdd')
   and a.org_no in ('000000')
   and a.CURR_NO='BWB'
   and b.sup_status = '1'
   and c.FIELD_NO='accu_index_value_y'
   and c.page_seat is not null
   and ((case
         when b.sup_logic1 = '小于等于' then
          a.accu_index_value_y - b.sup_value1
         when b.sup_logic1 = '小于' then
          a.accu_index_value_y - b.sup_value1
         when b.sup_logic1 = '大于等于' then
          b.sup_value1 - a.accu_index_value_y
         when b.sup_logic1 = '大于' then
          b.sup_value1 - a.accu_index_value_y
         else
          0
       end) < 0 or (case
         when b.sup_logic2 = '小于等于' then
          a.accu_index_value_y - b.sup_value2
         when b.sup_logic2 = '小于' then
          a.accu_index_value_y - b.sup_value2
         when b.sup_logic2 = '大于等于' then
          b.sup_value2 - a.accu_index_value_y
         when b.sup_logic2 = '大于' then
          b.sup_value2 - a.accu_index_value_y
         else
          0
       end) < 0);


COMMIT ;

insert into ${idl_schema}.MC_INDEX_FACT_SUP 
select * from MC_INDEX_FACT_SUP_temp01;

COMMIT ;

insert into ${idl_schema}.MC_INDEX_FACT_SUP 
select * from MC_INDEX_FACT_SUP_temp02;

COMMIT ;

drop table ${idl_schema}.MC_INDEX_FACT_SUP_temp01 purge ;
drop table ${idl_schema}.MC_INDEX_FACT_SUP_temp02 purge ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'MC_INDEX_FACT_SUP', degree => 8, cascade => true);