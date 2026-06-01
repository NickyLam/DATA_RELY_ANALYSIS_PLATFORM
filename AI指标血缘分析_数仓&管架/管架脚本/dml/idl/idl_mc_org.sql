set timing on

-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 1.1 create table for exchage
whenever sqlerror continue none;

MERGE INTO MC_ORG A
USING ${idl_schema}.MTL_CMM_INTNAL_ORG_INFO B
ON (A.ORG_NO = B.ORG_ID)
WHEN MATCHED THEN
UPDATE SET 
     A.ORG_NAME     = B.ORG_ABBR                                 -- 机构名称
    ,A.SUPER_ORG_NO = B.ADMIN_SUPER_ORG_ID                       -- 上级机构号
    ,A.ORG_ABBR     = B.ORG_NAME                                 -- 机构简称(名称)
    ,A.ETL_DT       = B.ETL_DT                                   -- 跑数时间
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
  AND B.ORG_ID  NOT LIKE '89%'                                   -- 排除事业部
  AND B.ADMIN_SUPER_ORG_ID = '000000'                            -- 上级机构
  AND B.ORG_ID <> '800'                                          -- 排除总行
WHEN NOT MATCHED THEN 
INSERT 
(  
     ORG_NO        
    ,ORG_NAME      
    ,SUPER_ORG_NO  
    ,SUPER_ORG_NAME
    ,ACCTS_ORG_IND 
    ,ORG_STATUS_CD 
    ,ORG_LEVEL     
    ,ORG_LEVEL_CD  
    ,ENTY_ORG_FLG  
    ,ORG_ABBR      
    ,REMARK        
    ,ETL_DT 
)

VALUES
(
     B.ORG_ID                  
    ,B.ORG_ABBR             
    ,B.ADMIN_SUPER_ORG_ID   
    ,''                     
    ,'0'                    
    ,'2'                    
    ,'3'                    
    ,'10'                   
    ,'10'                   
    ,B.ORG_NAME             
    ,''                     
    ,B.ETL_DT  
)
WHERE B.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
  AND B.ORG_ID NOT LIKE '89%'                                    -- 排除事业部
  AND (B.ADMIN_SUPER_ORG_ID = '000000' OR B.ORG_ID = '000000')   -- 上级机构
  AND B.ORG_ID <> '800'                                          -- 排除总行 
;
COMMIT ;

-- 3.1 gather table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}', tabname => 'mc_org', degree => 8, cascade => true);