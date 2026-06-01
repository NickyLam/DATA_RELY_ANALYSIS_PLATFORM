set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

-- 删除目标表错误指标数据
delete  mtl_fdl_idx_index_data a
where exists ( select 1 from  mc_idx_index_data_bl b
where  a.index_no = b.index_no 
   and a.org_no = b.org_no 
   and a.index_measure = b.index_measure 
   and a.etl_dt = b.etl_dt
   -- and a.batch_freq = b.batch_freq
   and a.curr_cd = b.curr_cd
   and b.etl_dt = to_date('${batch_date}','yyyymmdd') 
   and substr(b.index_no,1,2) in ('FM','IN','GM')
   )
;
commit ;


whenever sqlerror exit sql.sqlcode; 
-- 2.1 insert data to table

--插入补录数据
insert into   ${idl_schema}.mtl_fdl_idx_index_data 
(    INDEX_NO         
    ,ORG_NO           
    ,BIZ_STRIP_LINE_CD
    ,DIM_CD1          
    ,DIM_CD2          
    ,DIM_CD3          
    ,BATCH_FREQ       
    ,INDEX_MEASURE    
    ,CURR_CD          
    ,INDEX_VAL        
    ,ETL_DT           
    ,ETL_TIMESTAMP 
)
select INDEX_NO         
    ,ORG_NO           
    ,BIZ_STRIP_LINE_CD
    ,DIM_CD1          
    ,DIM_CD2          
    ,DIM_CD3          
    ,BATCH_FREQ       
    ,INDEX_MEASURE    
    ,CURR_CD          
    ,INDEX_VAL        
    ,ETL_DT           
    ,ETL_TIMESTAMP    
from mc_idx_index_data_bl 
where etl_dt = to_date('${batch_date}','yyyymmdd')  
  AND SUBSTR(INDEX_NO,1,2) in ('FM','IN','GM')
;
commit;


-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_fdl_idx_index_data',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);