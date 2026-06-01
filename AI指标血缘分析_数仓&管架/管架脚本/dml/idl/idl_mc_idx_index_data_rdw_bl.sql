set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;




-- 风险数据补录
-- 删除目标表对应指标数据[风险集市]
delete  mtl_rdl_idx_indx_data a
where exists 
( 
    select 1 from  mc_idx_index_data_bl b
    where  a.indx_no = b.index_no 
       and a.org_no = b.org_no 
       and a.etl_dt = b.etl_dt
       and a.curr_cd = b.curr_cd
       and b.etl_dt = to_date('${batch_date}','yyyymmdd')   
       and substr(b.index_no,1,2) = 'RM'
)
;
commit ;
whenever sqlerror exit sql.sqlcode; 
-- 2.1 insert data to table
--插入补录数据
insert into   ${idl_schema}.mtl_rdl_idx_indx_data 
(    INDX_NO         
    ,ORG_NO           
    ,STAT_PED_CD       
    ,CURR_CD          
    ,INDX_VAL
    ,INDX_DIMEN_CD
    ,INDX_DIMEN_NO
    ,INDEX_MEASURE
    ,ETL_DT           
    ,ETL_TIMESTAMP 
)
select INDEX_NO         
    ,ORG_NO           
    ,'M'       
    ,CURR_CD          
    ,INDEX_VAL 
    ,'ALL'
    ,'IND001'
    ,INDEX_MEASURE
    ,ETL_DT           
    ,ETL_TIMESTAMP    
from mc_idx_index_data_bl 
where etl_dt = to_date('${batch_date}','yyyymmdd')  
 AND SUBSTR(INDEX_NO,1,2)='RM'                      -- 筛选风险的
;
commit;

whenever sqlerror exit sql.sqlcode; 

-- 插入补录日志，记录风险补录条数
delete from mc_idx_index_data_rdw_bl ;
commit;

whenever sqlerror exit sql.sqlcode; 
insert into mc_idx_index_data_rdw_bl
(
      INDEX_NO
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
     ,sysdate
from mc_idx_index_data_bl
where etl_dt = to_date('${batch_date}','yyyymmdd')  
 AND SUBSTR(INDEX_NO,1,2)='RM' 
;
commit ;


-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_idx_index_data_rdw_bl', degree => 8, cascade => true);