/*
Purpose:    进件看板准实时:数据来源于综合信贷系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔15分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20250313
Logs:

-- 生成的IDL层表 ：mckb_distr_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_icms_business_duebill
msl_icms_hqd_ipc_legalperson_app
msl_icms_business_approve
msl_icms_business_contract
*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_distr_realtime_tmp_01 purge ;
drop table ${idl_schema}.mckb_distr_realtime_tmp_02 purge ;

whenever sqlerror exit sql.sqlcode; 
create table  ${idl_schema}.mckb_distr_realtime_tmp_01 compress
AS 
select * from ${idl_schema}.mckb_distr_realtime
where 1=2 ;
create table  ${idl_schema}.mckb_distr_realtime_tmp_02 compress
AS 
select * from ${idl_schema}.mckb_distr_realtime
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
AND    index_no ='MCKB_DISTR_REALTIME'
ORDER  BY sum_end_time,index_no;

BEGIN
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table
UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND    index_no ='MCKB_DISTR_REALTIME';
 
COMMIT;
delete mckb_distr_realtime_tmp_01;
commit;
-- 2.1 insert into realtime table
INSERT /*+ append */INTO ${idl_schema}.mckb_distr_realtime_tmp_01
               (ETL_DT      -- 数据日期
               ,PED_NO      -- 周期编号
               ,PED_NAME    -- 周期名称
               ,ORG_NO      -- 机构编号
               ,DISTR_AMT   -- 放款金额
               ,LP_CLS_ID   -- 法人分类编号
               ,LP_CLS_NAME -- 法人分类名称
               ,LP_CLS_PROD -- 产品分类 
                )
     --累计
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --日
        SELECT 
              REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
              ,'001'                       AS PED_NO
              ,'当日'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'2'                         AS LP_CLS_ID
              ,'个人'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --月
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'002'                       AS PED_NO
               ,'当月'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${month_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --年
        SELECT 
              REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
              ,'004'                       AS PED_NO
              ,'当年'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'2'                         AS LP_CLS_ID
              ,'个人'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${year_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
         UNION ALL
        --季
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'003'                       AS PED_NO
               ,'当季'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${quarter_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
        --周
        SELECT 
               REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'005'                       AS PED_NO
               ,'当周'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'2'                         AS LP_CLS_ID
               ,'个人'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_BUSINESS_DUEBILL BD
        WHERE INPUTORGID IS NOT NULL
        AND   PRODUCTID = '201020100054'
        AND   TRUNC(PUTOUTDATE)>= TO_DATE('${week_start}','yyyymmdd')
        AND   TRUNC(PUTOUTDATE)<= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
        --累计
        SELECT REC_RUN_LOGS.SUM_END_TIME    AS ETL_DT
               ,'099'                       AS PED_NO
               ,'累计'                      AS PED_NAME
               ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
               ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
               ,'1'                         AS LP_CLS_ID
               ,'企业'                      AS LP_CLS_NAME
               ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM   MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE 1 = 1
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
        --日
        SELECT REC_RUN_LOGS.SUM_END_TIME      AS ETL_DT
                 ,'001'                       AS PED_NO
                 ,'当日'                      AS PED_NAME
                 ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
                 ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
                 ,'1'                         AS LP_CLS_ID
                 ,'企业'                      AS LP_CLS_NAME
                 ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM   MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON     BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON     BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON     BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) = TO_DATE('${batch_date}', 'yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --月
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'002'                       AS PED_NO
              ,'当月'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${month_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --年
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'004'                       AS PED_NO
              ,'当年'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM  MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON    BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON    BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON    BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${year_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL
         --季
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'003'                       AS PED_NO
              ,'当季'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON   BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON   BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON   BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${quarter_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
         UNION ALL
         --周
        SELECT REC_RUN_LOGS.SUM_END_TIME   AS ETL_DT
              ,'005'                       AS PED_NO
              ,'当周'                      AS PED_NAME
              ,SUBSTR(BD.INPUTORGID, 0, 3) AS ORG_NO
              ,SUM(BD.BUSINESSSUM)         AS DISTR_AMT
              ,'1'                         AS LP_CLS_ID
              ,'企业'                      AS LP_CLS_NAME
              ,'1'                         AS LP_CLS_PROD  -- 1 是IPC/2 是数据贷/0好企贷合计 
        FROM MSL_ICMS_HQD_IPC_LEGALPERSON_APP HILA
        LEFT JOIN MSL_ICMS_BUSINESS_APPROVE BA 
        ON   BA.BASERIALNO = HILA.BASERIALNO
        LEFT JOIN MSL_ICMS_BUSINESS_CONTRACT BC 
        ON   BC.BAPSERIALNO = BA.SERIALNO 
        LEFT JOIN MSL_ICMS_BUSINESS_DUEBILL BD 
        ON   BD.CONTRACTSERIALNO = BC.SERIALNO
        WHERE TRUNC(BD.PUTOUTDATE) >= TO_DATE('${week_start}', 'yyyymmdd')
        AND   TRUNC(BD.PUTOUTDATE) <= TO_DATE('${batch_date}', 'yyyymmdd')
        GROUP BY SUBSTR(BD.INPUTORGID, 0, 3)
        UNION ALL 
        -- 好企贷 数据贷 20260206 新增 
         --累计
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        AND     TRUNC(WL.INPUTDATE)= TO_DATE('${batch_date}','yyyymmdd')
        GROUP BY SUBSTR(WL.INPUTORGID,0,3)
        UNION ALL
        -- 月
        SELECT 
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
                REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT  REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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
        SELECT   REC_RUN_LOGS.SUM_END_TIME           AS ETL_DT
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

INSERT /*+ append */INTO ${idl_schema}.mckb_distr_realtime_tmp_01
    (ETL_DT      -- 数据日期
    ,PED_NO      -- 周期编号
    ,PED_NAME    -- 周期名称
    ,ORG_NO      -- 机构编号
    ,DISTR_AMT   -- 放款金额
    ,LP_CLS_ID   -- 法人分类编号
    ,LP_CLS_NAME -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类 
     )
     --全行汇总
        SELECT 
              ETL_DT          AS ETL_DT
              ,PED_NO         AS PED_NO
              ,PED_NAME       AS PED_NAME
              ,'000000'       AS ORG_NO
              ,SUM(DISTR_AMT) AS DISTR_AMT
              ,LP_CLS_ID      AS LP_CLS_ID
              ,LP_CLS_NAME    AS LP_CLS_NAME
              ,LP_CLS_PROD    AS LP_CLS_PROD
        FROM    MCKB_DISTR_REALTIME_TMP_01 
        GROUP BY PED_NO
                ,PED_NAME
                ,LP_CLS_ID
                ,LP_CLS_NAME
                ,ETL_DT
                ,LP_CLS_PROD
                ;
     commit;
-- 产品合计 
INSERT /*+ append */INTO ${idl_schema}.mckb_distr_realtime_tmp_01
    (ETL_DT      -- 数据日期
    ,PED_NO      -- 周期编号
    ,PED_NAME    -- 周期名称
    ,ORG_NO      -- 机构编号
    ,DISTR_AMT   -- 放款金额
    ,LP_CLS_ID   -- 法人分类编号
    ,LP_CLS_NAME -- 法人分类名称
    ,LP_CLS_PROD -- 产品分类 
     )
     --全行汇总
        SELECT 
              ETL_DT          AS ETL_DT
              ,PED_NO         AS PED_NO
              ,PED_NAME       AS PED_NAME
              ,ORG_NO         AS ORG_NO
              ,SUM(DISTR_AMT) AS DISTR_AMT
              ,LP_CLS_ID      AS LP_CLS_ID
              ,LP_CLS_NAME    AS LP_CLS_NAME
              ,'0'            AS LP_CLS_PROD
        FROM    MCKB_DISTR_REALTIME_TMP_01 
        GROUP BY PED_NO
                ,PED_NAME
                ,LP_CLS_ID
                ,LP_CLS_NAME
                ,ETL_DT
                ,ORG_NO
                ;
     commit;
-- 汇总合计 
        INSERT /*+ append */INTO ${idl_schema}.mckb_distr_realtime_tmp_01
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
        FROM   MCKB_DISTR_REALTIME_TMP_01 T1
        GROUP BY T1.PED_NO
                ,T1.PED_NAME
                ,T1.ETL_DT
                ,T1.ORG_NO
                ,LP_CLS_PROD
                ;
     commit;
delete mckb_distr_realtime;
commit;
     INSERT /*+ append */INTO ${idl_schema}.mckb_distr_realtime
            (ETL_DT                 -- 数据日期
            ,PED_NO                 -- 周期编号
            ,PED_NAME               -- 周期名称
            ,GROUPING               -- 分组
            ,ORG_NO                 -- 机构编号
            ,ORG_NAME               -- 机构名称
            ,DISTR_AMT              -- 放款金额
            ,ACVMNT_DATA_TARGET     -- 业绩数据目标
            ,ACVMNT_DATA_ARRIVE_RAT -- 业绩数据达成率
            ,LP_CLS_ID              -- 法人分类编号
            ,LP_CLS_NAME            -- 法人分类名称
            ,LP_CLS_PROD            -- 产品分类 
            ,ETL_TIMESTAMP          -- ETL处理时间戳
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
     SELECT rec_run_logs.sum_end_time AS etl_dt --数据日期
            ,t1.ped_no --周期编号
            ,t1.ped_name --周期名称
            ,case when t1.lp_cls_id='0' then dense_rank()over(ORDER BY (nvl(t21.distr_amt,0))desc)
                  when t1.lp_cls_id='1' then dense_rank()over(ORDER BY nvl(t22.distr_amt,0)desc)
                  when t1.lp_cls_id='2' then dense_rank()over(ORDER BY nvl(t22.distr_amt,0)desc)
             end as grouping -- 分组
            ,T1.ORG_NO           -- 机构编号
            ,T1.ORG_NAME         -- 机构名称
            ,NVL(T2.DISTR_AMT,0) -- 放款金额
            -- ,CASE WHEN T1.LP_CLS_ID='0' THEN T3.TARGET_VAL*10000 END AS ACVMNT_DATA_TARGET                       -- 业绩数据目标
            -- ,CASE WHEN T1.LP_CLS_ID='0' THEN (T21.DISTR_AMT/(T3.TARGET_VAL*10000)) END ACVMNT_DATA_ARRIVE_RAT    -- 业绩数据达成率
            ,0 AS ACVMNT_DATA_TARGET
            ,0 AS ACVMNT_DATA_ARRIVE_RAT
            ,T1.LP_CLS_ID             -- 法人分类编号
            ,T1.LP_CLS_NAME           -- 法人分类名称
            ,T1.LP_CLS_PROD           -- 产品分类 
            ,SYSDATE AS ETL_TIMESTAMP -- ETL处理时间戳
      FROM  (select * from mc_orga_para,tmp_ped,tmp_lp_cls,TMP_PRO_CLS) t1 -- 机构树表
      LEFT   JOIN MCKB_DISTR_REALTIME_TMP_01 T2
      ON     T1.ORG_NO = T2.ORG_NO
      AND    T1.PED_NO=T2.PED_NO 
      AND    T1.LP_CLS_ID=T2.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T2.LP_CLS_PROD
      LEFT   JOIN MCKB_DISTR_REALTIME_TMP_01 T21
      ON     T1.ORG_NO = T21.ORG_NO
      AND    T21.PED_NO ='004'--合计按照当年完成率排序
      AND    T1.LP_CLS_ID=T21.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T21.LP_CLS_PROD
      LEFT   JOIN MCKB_DISTR_REALTIME_TMP_01 T22
      ON     T1.ORG_NO = T22.ORG_NO
      AND    T22.PED_NO ='099'--个人/企业按照累计放款排序
      AND    T1.LP_CLS_ID=T22.LP_CLS_ID
      AND    T1.LP_CLS_PROD = T22.LP_CLS_PROD
      -- LEFT JOIN MCKB_TARGET_VAL_CFG T3
      -- ON     T3.ORG_NO=T1.ORG_NO
      WHERE  T1.ORG_NO IN ('000000'-- 总行
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
                            )
                            ;
COMMIT;

-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id =rec_run_logs.log_id
 AND   index_no ='MCKB_DISTR_REALTIME';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mckb_distr_realtime出错' || SQLERRM);
    
END;

/
           
            
