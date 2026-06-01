/*
Purpose:    放款看板T+1:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mckb_distr
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_distr
-- 以下为依赖了上游的表 (OGG实时表):
msl_icms_business_duebill
msl_icms_hqd_ipc_legalperson_app
msl_icms_business_approve
msl_icms_business_contract

-- 20260206 新增 
-- 上游标
MSL_ICMS_WYD_LOAN
-- 新增字段 
LP_CLS_PROD 产品分类  -- 1 是IPC/2 是数据贷/0 好企贷 合计
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_distr_tmp_01 purge ;
drop table ${idl_schema}.mckb_distr_tmp_02 purge ;

alter table ${idl_schema}.mckb_distr add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_distr_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_distr
where 1=2 ;
create table  ${idl_schema}.mckb_distr_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_distr
where 1=2 ;

-- 2.1 insert into table
INSERT /*+ append */
INTO ${idl_schema}.mckb_distr_tmp_01
    (ETL_DT      --数据日期
    ,PED_NO      --周期编号
    ,PED_NAME    --周期名称
    --,GROUPING --分组
    ,ORG_NO        --机构编号
    --,ORG_NAME    --机构名称
    ,DISTR_AMT      --放款金额
    --,ACVMNT_DATA_TARGET --业绩数据目标
    --,ACVMNT_DATA_ARRIVE_RAT --业绩数据达成率
    ,LP_CLS_ID     -- 法人分类编号
    ,LP_CLS_NAME   -- 法人分类名称
    -- 20260206 新增 
    ,LP_CLS_PROD   -- 产品分类 
    --,ETL_TIMESTAMP --ETL处理时间戳
     )
      --累计
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') as etl_dt
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   trunc(putoutdate) <= to_date('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --日
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') as etl_dt
               ,'001' as ped_no
               ,'当日' as ped_name
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM   MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE  INPUTORGID IS NOT NULL
        AND    PRODUCTID = '201020100054'
        AND    TRUNC(PUTOUTDATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --月
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'002'                       AS PED_NO
               ,'当月'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID,0,3)   AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND PRODUCTID = '201020100054'
        AND TRUNC(PUTOUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --年
         SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'004'                       AS PED_NO
               ,'当年'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= to_date('${year_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= to_date('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --季
        SELECT 
               TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'003'                      AS PED_NO
               ,'当季'                     AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0,3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)        AS DISTR_AMT
               ,'2'                        AS LP_CLS_ID
               ,'个人'                     AS LP_CLS_NAME
               ,'1'                        AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${quarter_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --周
        SELECT 
              TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
              ,'005'                       AS PED_NO
              ,'当周'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID,0,3)   AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'2'                         AS LP_CLS_ID
              ,'个人'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${week_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --累计
         SELECT TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0,3)  AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'1'                         AS LP_CLS_ID
               ,'企业'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON        BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON        BC.BAPSERIALNO = BA.SERIALNO 
        -- 20260316 按照 全流程看板修改 
        -- INNER JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON        BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
         UNION ALL
        --日
        SELECT TO_DATE('${batch_date}','yyyymmdd') as etl_dt
              ,'001'                       AS PED_NO
              ,'当日'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID,0,3)   AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON        BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON        BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON         BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE     TRUNC(BD.PUTOUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID,0,3)
        UNION ALL
         --月
        SELECT TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'002'                       AS PED_NO
                 ,'当月'                      AS PED_NAME
                 ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
                 ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
                 ,'1'                         AS LP_CLS_ID
                 ,'企业'                      AS LP_CLS_NAME
                 ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON        BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON         BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON       BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --年
        SELECT TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                 ,'004'                            AS PED_NO
                 ,'当年'                           AS PED_NAME
                 ,SUBSTR(BD.INPUTORGID, 0, 3)      AS ORG_NO
                 ,SUM(BD.BUSINESSSUM)              AS DISTR_AMT
                 ,'1'                              AS LP_CLS_ID
                 ,'企业'                           AS LP_CLS_NAME
                 ,'1'                              AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON       BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON       BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON        BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND       TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID,0,3)
        UNION ALL
         --季
        SELECT TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
              ,'003'                       AS PED_NO
              ,'当季'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM      MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON        BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON        BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON         BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE  TRUNC(BD.PUTOUTDATE) >= TO_DATE('${quarter_start}','yyyymmdd')
        AND    TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --周
        SELECT TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
              ,'005'                       AS PED_NO
              ,'当周'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID,0,3)   AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM     MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON        BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON        BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON         BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= to_date('${week_start}','yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= to_date('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL 
        -- 20260206 新增 数据贷 
       --累计
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,SUM(WL.BUSINESSSUM)                AS DISTR_AMT    --放款金额 
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --日
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS DISTR_AMT        
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        -- AND     TRUNC(TO_DATE(WL.PUTOUTDATE,'yyyymmdd'))= TO_DATE('${batch_date}','yyyymmdd')
         AND     TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        -- 月
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        -- 年
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'004'                              AS PED_NO
                ,'当年'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL 
        -- 季
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'003'                              AS PED_NO
                ,'当季'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${quarter_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL 
        -- 周 
        SELECT 
                TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'005'                              AS PED_NO
                ,'当周'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT         -- 业绩数据金额
                ,'2'                                AS LP_CLS_ID
                ,'个人'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   WL.INPUTORGID IS NOT NULL
        AND     WL.PRODUCTID = '201020100063' -- 个人 201020100063/企业 203050100001
        AND     TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        --累计
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'099'                              AS PED_NO
                ,'累计'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL -- 贷款主文件
        WHERE   TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        --日
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'001'                              AS PED_NO
                ,'当日'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID,0,3)          AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(WL.INPUTDATE) = TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --月
        SELECT  TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'002'                              AS PED_NO
                ,'当月'                             AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)        AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))         AS ACVMNT_DATA_AMT          -- 业绩数据金额
                ,'1'                                AS LP_CLS_ID
                ,'企业'                             AS LP_CLS_NAME
                ,'2'                                AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${month_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
         --年
        SELECT   TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'004'                               AS PED_NO
                ,'当年'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${year_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
         UNION ALL
         --季
        SELECT   TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'003'                               AS PED_NO
                ,'当季'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${quarter_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
        UNION ALL
         --周 
        SELECT   TO_DATE('${batch_date}','yyyymmdd') AS ETL_DT
                ,'005'                               AS PED_NO
                ,'当周'                              AS PED_NAME
                ,SUBSTR(WL.INPUTORGID, 0, 3)         AS ORG_NO
                ,SUM(NVL(WL.BUSINESSSUM,0))          AS ACVMNT_DATA_AMT           -- 业绩数据金额
                ,'1'                                 AS LP_CLS_ID
                ,'企业'                              AS LP_CLS_NAME
                ,'2'                                 AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷
        FROM    MSL_ICMS_WYD_LOAN WL
        WHERE   TRUNC(WL.INPUTDATE) >= TO_DATE('${week_start}','yyyymmdd')
        AND     TRUNC(WL.INPUTDATE) <= TO_DATE('${batch_date}','yyyymmdd')
        AND     WL.PRODUCTID = '203050100001' -- 企业 203050100001
        GROUP BY SUBSTR(WL.INPUTORGID, 0, 3)    
        ;
COMMIT;

INSERT /*+ append */INTO ${idl_schema}.mckb_distr_tmp_01
    (etl_dt --数据日期
    ,ped_no --周期编号
    ,ped_name --周期名称
    --,grouping --分组
    ,org_no --机构编号
    --,org_name --机构名称
    ,distr_amt --放款金额
    --,acvmnt_data_target --业绩数据目标
    --,acvmnt_data_arrive_rat --业绩数据达成率
    ,lp_cls_id --法人分类编号
    ,lp_cls_name --法人分类名称
    ,LP_CLS_PROD  -- 产品分类 
    --,etl_timestamp --etl处理时间戳
     )
     --全行汇总
     SELECT 
                 ETL_DT          AS ETL_DT
                 ,PED_NO         AS PED_NO
                 ,PED_NAME       AS PED_NAME
                 ,'000000'       AS ORG_NO
                 ,SUM(DISTR_AMT) AS DISTR_AMT
                 ,LP_CLS_ID      AS LP_CLS_ID   -- 1企业/2个人
                 ,LP_CLS_NAME    AS LP_CLS_NAME -- 企业/个人
                 ,LP_CLS_PROD    AS LP_CLS_PROD-- 1 是IPC/2 是数据贷
           FROM MCKB_DISTR_TMP_01 
           GROUP BY PED_NO
                   ,PED_NAME
                   ,LP_CLS_ID
                   ,LP_CLS_NAME
                   ,ETL_DT
                   ,LP_CLS_PROD
                   ;
     COMMIT;
-- 20260112 新增  
-- 产品汇总 
INSERT INTO ${idl_schema}.mckb_distr_tmp_01
            (ETL_DT        -- 数据日期
             ,PED_NO       -- 周期编号
             ,PED_NAME     -- 周期名称
             ,ORG_NO       -- 机构编号
             ,DISTR_AMT    -- 放款金额
             ,LP_CLS_ID    -- 法人分类编号
             ,LP_CLS_NAME -- 法人分类名称
             ,LP_CLS_PROD  -- 产品分类 
              )
SELECT 
        ETL_DT                        AS ETL_DT
        ,PED_NO                       AS PED_NO
        ,PED_NAME                     AS PED_NAME
        ,ORG_NO                       AS ORG_NO
        ,SUM(DISTR_AMT)               AS DISTR_AMT    -- 业绩数据金额
        ,LP_CLS_ID                    AS LP_CLS_ID    -- 2 是个人/1是企业
        ,LP_CLS_NAME                  AS LP_CLS_NAME
        ,'0'                          AS LP_CLS_PROD  -- 合计 
FROM    MCKB_DISTR_TMP_01 
GROUP BY PED_NO
        ,PED_NAME
        ,LP_CLS_ID
        ,LP_CLS_NAME
        ,ETL_DT
        ,ORG_NO
        ;
     COMMIT;

INSERT /*+ append */INTO ${idl_schema}.mckb_distr_tmp_01
               (ETL_DT      -- 数据日期
               ,PED_NO      -- 周期编号
               ,PED_NAME    -- 周期名称
               ,ORG_NO      -- 机构编号
               ,DISTR_AMT   -- 放款金额
               ,LP_CLS_ID   -- 法人分类编号
               ,LP_CLS_NAME -- 法人分类名称
               ,LP_CLS_PROD -- 产品分类 
                )
        SELECT 
                T1.ETL_DT          AS ETL_DT
                ,T1.PED_NO         AS PED_NO
                ,T1.PED_NAME       AS PED_NAME
                ,T1.ORG_NO         AS ORG_NO
                ,SUM(T1.DISTR_AMT) AS DISTR_AMT
                ,'0'               AS LP_CLS_ID
                ,'合计'            AS LP_CLS_NAME
                ,LP_CLS_PROD       AS LP_CLS_PROD
        FROM    MCKB_DISTR_TMP_01 T1
        GROUP BY T1.PED_NO
                   ,T1.PED_NAME
                   ,T1.ETL_DT
                   ,T1.ORG_NO
                   ,LP_CLS_PROD
                   ;
     commit;

INSERT /*+ append */INTO ${idl_schema}.MCKB_DISTR_TMP_02
    (ETL_DT            --数据日期
    ,PED_NO            --周期编号
    ,PED_NAME          --周期名称
    ,GROUPING          --分组
    ,ORG_NO            --机构编号
    ,ORG_NAME          --机构名称
    ,DISTR_AMT         --放款金额
    ,ACVMNT_DATA_TARGET --业绩数据目标
    ,ACVMNT_DATA_ARRIVE_RAT --业绩数据达成率
    ,LP_CLS_ID       --法人分类编号
    ,LP_CLS_NAME     --法人分类名称
    -- 20260206 新增  
    ,LP_CLS_PROD     -- 产品分类
    ,ETL_TIMESTAMP   --ETL处理时间戳
     )
     with tmp_ped as
       (select '099' as ped_no
              ,'累计' as ped_name
          from dual
        union all
        select '001' as ped_no
              ,'当日' as ped_name
          from dual
        union all
        select '002' as ped_no
              ,'当月' as ped_name
          from dual
        union all
        select '004' as ped_no
              ,'当年' as ped_name
          from dual
         union all
        select '003' as ped_no
              ,'当季' as ped_name
          from dual
          union all
        select '005' as ped_no
              ,'当周' as ped_name
          from dual),
      tmp_lp_cls as
       (select '0' as lp_cls_id
              ,'合计' as lp_cls_name
          from dual
        union all
        select '1' as lp_cls_id
              ,'企业' as lp_cls_name
          from dual
        union all
        select '2' as lp_cls_id
              ,'个人' as lp_cls_name
          from dual),
          TMP_PRO_CLS AS (
                         SELECT '1' AS LP_CLS_PROD -- 数据贷_IPC
                         FROM DUAL
                         UNION ALL
                         SELECT '2' AS LP_CLS_PROD -- 数据贷_数据贷
                         FROM DUAL
                         UNION ALL
                         SELECT '0' AS LP_CLS_PROD -- 好企贷_合计 
                         FROM DUAL
                       )
     SELECT to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
            ,t1.ped_no --周期编号
            ,t1.ped_name --周期名称
            --,case when t1.lp_cls_id='0' then dense_rank()over(ORDER BY (t21.distr_amt/(t3.TARGET_VAL*10000))desc)
            --      when t1.lp_cls_id='1' then dense_rank()over(ORDER BY nvl(t22.distr_amt,0)desc)
            --      when t1.lp_cls_id='2' then dense_rank()over(ORDER BY nvl(t22.distr_amt,0)desc)
            -- END AS GROUPING --分组
            ,CASE WHEN T1.LP_CLS_ID='0' THEN DENSE_RANK()OVER(ORDER BY NVL(T21.DISTR_AMT,0)DESC)
                   WHEN T1.LP_CLS_ID='1' THEN DENSE_RANK()OVER(ORDER BY NVL(T22.DISTR_AMT,0)DESC)
                   WHEN T1.LP_CLS_ID='2' THEN DENSE_RANK()OVER(ORDER BY NVL(T22.DISTR_AMT,0)DESC)
             END AS GROUPING --分组
            ,t1.org_no --机构编号
            ,t1.org_name --机构名称
            ,nvl(t2.distr_amt,0) --放款金额
            -- 20260206 取消 
            --,case when t1.lp_cls_id='0' then t3.TARGET_VAL*10000 end acvmnt_data_target --业绩数据目标
            --,case when t1.lp_cls_id='0' then (t21.distr_amt/(t3.TARGET_VAL*10000)) end acvmnt_data_arrive_rat --业绩数据达成率
            ,0     AS acvmnt_data_target --业绩数据目标
            ,0     AS acvmnt_data_arrive_rat --业绩数据达成率
            ,T1.LP_CLS_ID       -- 法人分类编号
            ,T1.LP_CLS_NAME     -- 法人分类名称
            ,T1.LP_CLS_PROD    -- 产品分类
            ,SYSDATE  AS ETL_TIMESTAMP --ETL处理时间戳
      FROM   (SELECT * FROM MC_ORGA_PARA,TMP_PED,TMP_LP_CLS,TMP_PRO_CLS) T1 -- 机构树表
      LEFT   JOIN mckb_distr_tmp_01 t2
      ON     T1.ORG_NO = T2.ORG_NO 
      AND    T1.PED_NO=T2.PED_NO             -- 周期 
      AND    T1.LP_CLS_ID = T2.LP_CLS_ID     -- 企业/个人 
      AND    T1.LP_CLS_PROD = t2.LP_CLS_PROD -- 产品分类 
      LEFT   JOIN MCKB_DISTR_TMP_01 T21
      ON     T1.ORG_NO = T21.ORG_NO
      AND    T21.PED_NO ='004'--合计按照当年完成率排序
      AND    T1.LP_CLS_ID=T21.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T21.LP_CLS_PROD -- 产品分类 
      LEFT   JOIN MCKB_DISTR_TMP_01 T22
      ON     T1.ORG_NO = T22.ORG_NO
      AND    T22.PED_NO = '099'--个人/企业按照累计放款排序
      AND    T1.LP_CLS_ID = T22.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T22.LP_CLS_PROD -- 产品分类 
      -- 李旻翀 业务下线
      --LEFT JOIN MCKB_TARGET_VAL_CFG T3
      --ON     T3.ORG_NO=T1.ORG_NO
      WHERE  t1.org_no in ('000000'-- 总行
                            ,'801' -- 广州分行
                            ,'802' -- 汕头分行
                            ,'803' -- 佛山分行
                            ,'805' -- 深圳分行
                            ,'806' -- 东莞分行
                            ,'807' -- 中山分行
                            ,'808' -- 江门分行
                            ,'809' -- 珠海分行
                            ,'810' -- 惠州分行
                            ,'811' -- 肇庆分行
                            ,'812' -- 湛江分行
                            );
COMMIT;

-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.mckb_distr truncate partition p_${batch_date} reuse storage;

-- 3.3 exchage tm table and target table
alter table ${idl_schema}.mckb_distr exchange partition p_${batch_date} with table mckb_distr_tmp_02;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.mckb_distr to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.mckb_distr_tmp_01 purge ;
drop table ${idl_schema}.mckb_distr_tmp_02 purge ;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mckb_distr', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);

           
            
