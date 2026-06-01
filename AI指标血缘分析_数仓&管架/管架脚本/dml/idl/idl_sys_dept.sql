set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

MERGE INTO SYS_DEPT A
USING MTL_CMM_INTNAL_ORG_INFO B
ON (A.DEPT_ID = B.ORG_ID)
WHEN MATCHED THEN
UPDATE SET  
    A.PARENT_ID   = B.ADMIN_SUPER_ORG_ID 
   ,A.DEPT_NAME   = B.ORG_ABBR
   ,A.PHONE       = B.PHONE
   ,A.CREATE_TIME = B.ORG_FOUND_DT
   ,A.UPDATE_TIME = sysdate
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
   AND B.ORG_ID  <> '000000'
WHEN NOT MATCHED THEN 
  INSERT 
(   
    DEPT_ID                              
   ,PARENT_ID  
   ,ANCESTORS  
   ,DEPT_NAME  
   ,ORDER_NUM  
   ,LEADER     
   ,PHONE      
   ,EMAIL      
   ,STATUS     
   ,DEL_FLAG   
   ,CREATE_BY  
   ,CREATE_TIME
   ,UPDATE_BY  
   ,UPDATE_TIME

)
VALUES
(
    B.ORG_ID
   ,B.ADMIN_SUPER_ORG_ID 
   ,'0,000000'             
   ,B.ORG_ABBR             
   ,TO_NUMBER(B.ORG_ID)    
   ,''                     
   ,B.PHONE                
   ,'' 
   ,'0' 
   ,'0' 
   ,'' 
   ,B.ORG_FOUND_DT 
   ,'' 
   ,sysdate 
)
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
  AND B.ORG_ID <> '000000'
;
COMMIT;


-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'sys_dept', degree => 8, cascade => true);


