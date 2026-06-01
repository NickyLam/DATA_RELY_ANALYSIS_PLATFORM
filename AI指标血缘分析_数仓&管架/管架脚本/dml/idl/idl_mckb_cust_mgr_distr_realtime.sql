/*
Purpose:    客户经理放款看板准实时:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔15分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_cust_mgr_distr_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_icms_business_duebill
msl_icms_hqd_ipc_legalperson_app
msl_icms_business_approve
msl_icms_business_contract

-- 20260206 修改及新增
修改：
    1.把 MGR_NO
         MGR_NAME--客户经理名称
         CREATE_DATE --系统开通权限时间 这三个字段放在TMP表中加工

    2.新增 LP_CLS_PROD 产品分类字段 
    3.新增上游依赖 
       MSL_ICMS_WYD_LOAN  
       MSL_ICMS_USER_INFO 

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01 purge ;
drop table ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_02 purge ;

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_cust_mgr_distr_realtime
where 1=2 ;

set serveroutput on 
DECLARE

    CURSOR  CUR_RUN_LOGS IS 
    SELECT log_id
      ,index_no
      ,sum_start_time
      ,sum_end_time
      ,(CASE
           WHEN run_sts = '1' THEN
            '补跑'
           ELSE
            '正常'
       END) AS run_flag --批次类型判断
FROM   mcyy_realtime_run_log
WHERE  etl_dt = to_date('${batch_date}' ,'yyyymmdd')
AND    ((run_sts = 0) --正常批次                     
      OR run_sts = 1 AND to_char(SYSDATE,'HH24MI') -
      to_char(start_time,'HH24MI') >= 15) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no ='MCKB_CUST_MGR_DISTR_REALTIME'
ORDER  BY sum_end_time,index_no;

BEGIN
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table
UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND    index_no ='MCKB_CUST_MGR_DISTR_REALTIME';
 
COMMIT;
delete mckb_cust_mgr_distr_realtime_tmp_01;
commit;

-- 2.1 insert into realtime table
INSERT /*+ append */INTO ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01
    (ETL_DT      -- 数据日期
    ,PED_NO      -- 周期编号
    ,PED_NAME    -- 周期名称
    ,ORG_NO      -- 机构编号
    ,MGR_NO      -- 客户经理编号
    ,MGR_NAME    -- 客户经理名称     -- 20260206 新增 
    ,CREATE_DATE -- 系统开通权限时间 -- 20260206 新增 
    ,DISTR_AMT   -- 放款金额
    ,LP_CLS_ID   -- 法人分类编号
    ,LP_CLS_NAME -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类  1 是IPC/2 是数据贷 -- 20260206 新增 
     )
     -- IPC 
     --累计
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
               ,BD.OPERATEUSERID            AS MGR_NO      -- 客户经理编号
               ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
               ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
        -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE OPERATEORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
              ,BD.OPERATEUSERID
              ,T4.NAME        
              ,TRUNC(T4.CREATE_DATE)
        UNION ALL
         --日
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'001'                       AS PED_NO
               ,'当日'                      AS PED_NAME
               ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
               ,BD.OPERATEUSERID            AS MGR_NO               
               ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
               ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1是IPC/2是数据贷/0是好企贷合计 
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE OPERATEORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)= TO_DATE('${batch_date}','yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
                ,BD.OPERATEUSERID
                ,T4.NAME        
                ,TRUNC(T4.CREATE_DATE)
        UNION ALL
        --月
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'002'                       AS PED_NO
               ,'当月'                      AS PED_NAME
               ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
               ,BD.OPERATEUSERID            AS MGR_NO              
               ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
               ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE OPERATEORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        UNION ALL
        --年
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'004'                       AS PED_NO
               ,'当年'                      AS PED_NAME
               ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
               ,BD.OPERATEUSERID            AS MGR_NO                          
               ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
               ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE OPERATEORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        UNION ALL
        --周
        SELECT 
              REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
              ,'005'                       AS PED_NO
              ,'当周'                      AS PED_NAME
              ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
              ,BD.OPERATEUSERID            AS MGR_NO           
              ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
              ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'2'                         AS LP_CLS_ID
              ,'个人'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE OPERATEORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${week_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        UNION ALL
         --累计
        SELECT REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
               ,BD.OPERATEUSERID            AS MGR_NO    
               ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
               ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'1'                         AS LP_CLS_ID
               ,'企业'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE 1 = 1
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        UNION ALL
         --日
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'001'                       AS PED_NO
              ,'当日'                      AS PED_NAME
              ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
              ,BD.OPERATEUSERID            AS MGR_NO    
              ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
              ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
           -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE TRUNC(BD.PUTOUTDATE) = TO_DATE('${batch_date}', 'yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        UNION ALL
         --月
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'002'                       AS PED_NO
              ,'当月'                      AS PED_NAME
              ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
              ,BD.OPERATEUSERID            AS MGR_NO    
              ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
              ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${month_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
              ,BD.OPERATEUSERID
              ,T4.NAME        
              ,TRUNC(T4.CREATE_DATE)
        UNION ALL
         --年
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'004'                       AS PED_NO
              ,'当年'                      AS PED_NAME
              ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
              ,BD.OPERATEUSERID            AS MGR_NO    
              ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
              ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${year_start}', 'yyyymmdd')
               AND TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
               AND T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
              ,BD.OPERATEUSERID
              ,T4.NAME        
              ,TRUNC(T4.CREATE_DATE)
          UNION ALL
         --周
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'005'                       AS PED_NO
              ,'当周'                      AS PED_NAME
              ,SUBSTR(BD.OPERATEORGID,1,3) AS ORG_NO
              ,BD.OPERATEUSERID            AS MGR_NO    
              ,T4.NAME                     AS MGR_NAME    -- 客户经理名称
              ,TRUNC(T4.CREATE_DATE)       AS CREATE_DATE -- 系统开通权限时间
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON   BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON   BC.BAPSERIALNO = BA.SERIALNO 
        INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON   BD.CONTRACTSERIALNO = BC.SERIALNO
         -- 20260206 新增 
        LEFT JOIN MSL_HGLS_USER_CLIENT T4 -- 用户客户信息 
        ON    T4.ACCOUNT = BD.OPERATEUSERID
        AND   T4.ISDEL = 0 
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${week_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        AND   T4.ISDEL = 0
        GROUP BY SUBSTR(BD.OPERATEORGID,1,3)
             ,BD.OPERATEUSERID
             ,T4.NAME        
             ,TRUNC(T4.CREATE_DATE)
        -- 好企贷 数据贷  20260206 新增 
        -- 累计
        UNION ALL 
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间 
                ,SUM(WL.BUSINESSSUM)                AS DISTR_AMT    -- 放款金额 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
         --日
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT        
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
        -- 月
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
        -- 年
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL 
        -- 周 
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'005'                              AS PED_NO
                ,'当周'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
        --累计
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
        --日
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
         --月
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,UI.USERID                          AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                        AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')    AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
         --年
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                         AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')     AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS DISTR_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
        UNION ALL
         --周 
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
                ,'005'                               AS PED_NO
                ,'当周'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,UI.USERID                           AS MGR_NO       -- 推荐人用户编号
                ,UI.USERNAME                         AS MGR_NAME     -- 推荐人用户编号
                ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')     AS CREATE_DATE  -- 登记时间
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS DISTR_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        LEFT JOIN MSL_ICMS_USER_INFO UI 
        ON      UI.USERID = WL.INPUTUSERID
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
                 ,UI.USERID
                 ,UI.USERNAME                    
                 ,TO_DATE(REPLACE(NVL(SUBSTR(TRIM(UI.INPUTDATE),0,10),SUBSTR(TRIM(UI.UPDATETIME),0,10)),'/',''),'yyyymmdd')
             ;
      COMMIT;

-- 产品合计 
     INSERT /*+ append */ INTO ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01
                (ETL_DT            -- 数据日期
                ,PED_NO            -- 周期编号
                ,PED_NAME          -- 周期名称
                ,ORG_NO            -- 机构编号
                ,MGR_NO            -- 客户经理编号
                ,MGR_NAME          -- 推荐人用户编号
                ,CREATE_DATE       -- 登记时间 
                ,DISTR_AMT         -- 放款金额
                ,LP_CLS_ID         -- 法人分类编号
                ,LP_CLS_NAME       -- 法人分类名称
                ,LP_CLS_PROD       -- 产品分类 
                 )
        SELECT 
                 T1.ETL_DT         AS ETL_DT
                ,T1.PED_NO         AS PED_NO
                ,T1.PED_NAME       AS PED_NAME
                ,T1.ORG_NO         AS ORG_NO
                ,T1.MGR_NO         AS MGR_NO
                ,T1.MGR_NAME       AS MGR_NAME   
                ,T1.CREATE_DATE    AS CREATE_DATE
                ,SUM(T1.DISTR_AMT) AS DISTR_AMT
                ,T1.LP_CLS_ID      AS LP_CLS_ID
                ,T1.LP_CLS_NAME    AS LP_CLS_NAME
                ,'0'               AS LP_CLS_PROD -- 1 IPC/2 数据贷 /0好企贷合计 
        FROM     MCKB_CUST_MGR_DISTR_REALTIME_TMP_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,T1.MGR_NO
                ,T1.MGR_NAME   
                ,T1.CREATE_DATE
                ,T1.LP_CLS_ID  
                ,T1.LP_CLS_NAME
                ;
     COMMIT;
      
-- 汇总合计 
     INSERT /*+ append */ INTO ${idl_schema}.mckb_cust_mgr_distr_realtime_tmp_01
                (ETL_DT            -- 数据日期
                ,PED_NO            -- 周期编号
                ,PED_NAME          -- 周期名称
                ,ORG_NO            -- 机构编号
                ,MGR_NO            -- 客户经理编号
                ,MGR_NAME          -- 推荐人用户编号
                ,CREATE_DATE       -- 登记时间 
                ,DISTR_AMT         -- 放款金额
                ,LP_CLS_ID         -- 法人分类编号
                ,LP_CLS_NAME       -- 法人分类名称
                ,LP_CLS_PROD       -- 产品分类 
                 )
        SELECT 
                 T1.ETL_DT         AS ETL_DT
                ,T1.PED_NO         AS PED_NO
                ,T1.PED_NAME       AS PED_NAME
                ,T1.ORG_NO         AS ORG_NO
                ,T1.MGR_NO         AS MGR_NO
                ,T1.MGR_NAME       AS MGR_NAME   
                ,T1.CREATE_DATE    AS CREATE_DATE
                ,SUM(T1.DISTR_AMT) AS DISTR_AMT
                ,'0'               AS LP_CLS_ID
                ,'合计'            AS LP_CLS_NAME
                ,T1.LP_CLS_PROD    AS LP_CLS_PROD
        FROM     MCKB_CUST_MGR_DISTR_REALTIME_TMP_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,T1.MGR_NO
                ,T1.MGR_NAME   
                ,T1.CREATE_DATE
                ,T1.LP_CLS_PROD
                ;
     COMMIT;
DELETE MCKB_CUST_MGR_DISTR_REALTIME;
commit;
     INSERT /*+ append */INTO ${idl_schema}.MCKB_CUST_MGR_DISTR_REALTIME
           (ETL_DT        -- 数据日期
           ,PED_NO        -- 周期编号
           ,PED_NAME      -- 周期名称
           ,RANK          -- 排名
           ,ORG_NO        -- 机构编号
           ,ORG_NAME      -- 机构名称
           ,MGR_NO        -- 客户经理编号
           ,MGR_NAME      -- 客户经理名称
           ,DISTR_AMT     -- 放款金额
           ,LP_CLS_ID     -- 法人分类编号
           ,LP_CLS_NAME   -- 法人分类名称
           ,CREATE_DATE   -- 系统开通权限时间
           ,LP_CLS_PROD   -- 产品分类 
           ,ETL_TIMESTAMP -- ETL处理时间戳
            )
     SELECT REC_RUN_LOGS.SUM_END_TIME  AS ETL_DT        -- 数据日期
            ,T1.PED_NO                 AS PED_NO        -- 周期编号
            ,T1.PED_NAME               AS PED_NAME      -- 周期名称
            ,ROW_NUMBER() OVER(PARTITION BY T1.PED_NO,T1.LP_CLS_ID,T1.LP_CLS_PROD ORDER BY T1.DISTR_AMT DESC) AS RANK --排名
            ,T1.ORG_NO                 AS ORG_NO        -- 机构编号
            ,T2.ORG_NAME               AS ORG_NAME      -- 机构名称
            ,T1.MGR_NO                 AS MGR_NO        -- 客户经理编号
            ,T1.MGR_NAME               AS MGR_NAME      -- 客户经理名称
            ,NVL(T1.DISTR_AMT,0)       AS DISTR_AMT     -- 放款金额
            ,T1.LP_CLS_ID              AS LP_CLS_ID     -- 法人分类编号
            ,T1.LP_CLS_NAME            AS LP_CLS_NAME   -- 法人分类名称
            ,T1.CREATE_DATE            AS CREATE_DATE   -- 系统开通权限时间
            ,T1.LP_CLS_PROD            AS LP_CLS_PROD   -- 产品分类 
            ,SYSDATE                   AS ETL_TIMESTAMP -- ETL处理时间戳
    FROM  MCKB_CUST_MGR_DISTR_REALTIME_TMP_01 T1
    LEFT JOIN MC_ORGA_PARA T2
    ON     T2.ORG_NO=T1.ORG_NO
      -- 20260206 注释 
      -- LEFT JOIN MTL_PTY_EMPLY T3 
      -- ON     T3.EMPLY_ID=T1.MGR_NO
      -- AND  t3.etl_dt=to_date('${last_date}', 'yyyymmdd')
      -- LEFT JOIN msl_hgls_user_client t4
      -- ON    T4.ACCOUNT=T1.MGR_NO
      -- WHERE T4.ISDEL=0 
        ;
COMMIT;
--只展示前十名
--delete mckb_cust_mgr_distr_realtime where rank>10;
--COMMIT;

-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND   index_no ='MCKB_CUST_MGR_DISTR_REALTIME';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mckb_cust_mgr_distr_realtime出错' || SQLERRM);
    
END;

/
           
            
