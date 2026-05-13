CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_ZCCZ(I_P_DATE      IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_LOAN_ZCZR
  *  功能描述：资产处置整合表
  *  创建日期：20250828
  *  开发人员：HYF
  *  来源表： M_CUST_IND_INFO 个人客户表
  *           M_LOAN_TRF_REL_INFO 信贷资产转让关系信息
  *           M_LOAN_CNCL_INFO 资产核销信息
  *           S_LOAN 贷款整合表
  *           S_LOAN_BAL_CHANGE_EX 贷款变动整合表
  *           S_LOAN_WRITE_OFF 贷款核销 
  *           S_ASSET_DISPL_INFO 资产清收处置信息
  *  目标表： S_LOAN_ZCCZ 资产处置整合表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20250822  HYF        创建
  *             2    20260119  HYF        补充对公处置
  *             3    20260127  HYF        补充零售资产证券化
  *             4    20260212  HYF        按惠州分行要求剔除跨年冲正借据R20220708694554599761
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_ZCCZ'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_ZCCZ'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_ZCZR T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_ZCZR'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.S_LOAN_ZCCZ_HXSH';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.S_LOAN_ZCCZ_LV5';
  
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  V_STEP := 2;
  V_STEP_DESC := '--加工核销收回数据--';
  V_STARTTIME := SYSDATE;
  --由于联合网贷处置清收存的是每天每月全量，因此需要取每月月末+当前日期 
  INSERT INTO RRP_MDL.S_LOAN_ZCCZ_HXSH
  (DATA_DT         --1 数据日期
  ,RCPT_ID         --2 借据号
  ,YEAR_HXSH_BAL   --3 年累计核销收回金额
  ,MON_HXSH_BAL    --4 月累计核销收回金额
  ,HXSH_DT         --5 核销收回日期
  )
  WITH TMP AS
  ( SELECT /*+ materialize PARALLEL(4)*/
           T1.LOAN_NUM     AS RCPT_ID --借据号
          ,T1.RETRIEVE_AMT AS RETRIEVE_AMT --核销收回金额
          ,T1.RETRIEVE_DATE AS RETRIEVE_DATE --核销收回日期
     FROM RRP_MDL.S_LOAN_WRITE_OFF T1 
    WHERE T1.DATA_SRC IN ('零售贷款')
      AND SUBSTR(TO_CHAR(T1.RETRIEVE_DATE,'YYYYMMDD'),1,4) = SUBSTR(V_P_DATE,1,4) --当年
      AND T1.RETRIEVE_AMT <> 0
      AND T1.DATA_DT = V_P_DATE       
    UNION ALL    
   SELECT /*+ materialize PARALLEL(4)*/
           T1.DUBIL_ID   AS RCPT_ID --借据号
          ,T1.DISPL_AMT  AS RETRIEVE_AMT --核销收回金额
          ,TO_DATE(T1.REPAY_DT,'YYYYMMDD')+1 AS RETRIEVE_DATE --核销收回日期
     FROM RRP_MDL.S_ASSET_DISPL_INFO T1 --资产清收处置信息
    WHERE T1.DATA_DT <= V_P_DATE
      AND T1.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
      AND ( T1.DATA_DT IN (
                           SELECT TO_CHAR(ADD_MONTHS(LAST_DAY(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1),+ROWNUM),'YYYYMMDD') AS LASTDATE
                           FROM DUAL
                           CONNECT BY ROWNUM <= CEIL(MONTHS_BETWEEN(TO_DATE(V_P_DATE,'YYYYMMDD'),TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1))
                        )--当年每月月末
            OR T1.DATA_DT = V_P_DATE)
      AND T1.DISPL_WAY = '现金收回' 
      AND T1.ASSET_TYPE= '已核销资产' 
      AND T1.DISPL_AMT <> 0
    )
  SELECT /*+ materialize PARALLEL(4)*/
         V_P_DATE             AS DATA_DT --1 数据日期
        ,T1.RCPT_ID           AS RCPT_ID --2 借据号   
        ,SUM(T1.RETRIEVE_AMT) AS YEAR_HXSH_BAL --3 年累计核销收回金额  
        ,SUM(CASE WHEN SUBSTR(TO_CHAR(T1.RETRIEVE_DATE,'YYYYMMDD'),0,6) = SUBSTR(V_P_DATE,0,6) 
                  THEN T1.RETRIEVE_AMT
             ELSE 0 END)       AS MON_HXSH_BAL --4 月累计核销收回金额
        ,TO_CHAR(MAX(T1.RETRIEVE_DATE),'YYYYMMDD') AS HXSH_DT --5 核销收回日期
   FROM TMP T1 
  WHERE 1=1 
  GROUP BY T1.RCPT_ID ;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '--加工处置五级分类数据--';
  V_STARTTIME := SYSDATE;
  --由于存在当天还款五级分类由不良变动为正常的情况，因此对此场景取其变动前仍为不良的情况
  INSERT INTO RRP_MDL.S_LOAN_ZCCZ_LV5
  ( RCPT_ID --1 借据号
   ,LVL5_CL --2 处置时点五级分类代码
   ,CZFS_DT --3 处置时间
   )
  SELECT G.RCPT_ID --1 借据号
        ,CASE WHEN G.BDS_LVL5_CL IN ('03','04','05') 
              THEN G.BDS_LVL5_CL
              ELSE G.BDQ_LVL5_CL 
           END AS LVL5_CL --2 处置时点五级分类代码 
        ,CASE WHEN G.DATA_SRC = '联合网贷' 
              THEN TO_CHAR(TO_DATE(G.CHANGE_DT,'YYYYMMDD')-1,'YYYYMMDD')
              ELSE G.CHANGE_DT 
           END AS CZFS_DT --3 处置时间
   FROM RRP_MDL.S_LOAN_BAL_CHANGE G  
  WHERE 1=1;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
        
  V_STEP := 4;
  V_STEP_DESC := '--加工零售贷款单笔转让数据--';
  V_STARTTIME := SYSDATE;
  
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
   (   DATA_DT         --1 数据日期
      ,RCPT_ID         --2 借据号
      ,ORG_ID          --3 机构编号
      ,CUST_ID         --4 客户号
      ,CUST_NAME       --5 客户名称
      ,ZCLX_TYP        --6 资产类型
      ,CZFS_TYP        --7 处置方式
      ,CZFS_DT         --8 处置时间
      ,BS_CZFS_DT      --9 报送处置时间
      ,CZFS_BAL        --10 处置金额
      ,YEAR_HXSH_BAL   --11 年累计核销收回金额
      ,MON_HXSH_BAL    --12 月累计核销收回金额
      ,HXSH_DT         --13 核销收回日期
      ,LVL5_CL         --14 处置时点五级分类代码
      ,LVL5_CL_NAME    --15 处置时点五级分类名称
      ,NC_LVL5_CL      --16 年初五级分类代码
      ,NC_LVL5_CL_NAME --17 年初五级分类名称
      ,TXHY            --18 投向行业
      ,DATA_SRC        --19 数据来源
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE             AS DATA_DT         --1 数据日期
        ,T1.RCPT_ID           AS RCPT_ID         --2 借据号
        ,T3.ORG_ID            AS ORG_ID          --3 机构编号
        ,T3.CUST_ID           AS CUST_ID         --4 客户号
        ,T6.CUST_NM           AS CUST_NAME       --5 客户名称
        ,'不良贷款'           AS ZCLX_TYP        --6 资产类型
        ,'转让'               AS CZFS_TYP        --7 处置方式
        ,T1.ASSET_TRAN_DT     AS CZFS_DT         --8 处置时间
        ,T1.ASSET_TRAN_DT     AS BS_CZFS_DT      --9 报送处置时间
        ,(T1.TRF_LOAN_PRIN - NVL(T2.CNCL_LN_PRIN,T1.CNCL_LOAN_PRIN)) AS CZFS_BAL --10 处置金额
        ,0                    AS YEAR_HXSH_BAL   --11 年累计核销收回金额
        ,0                    AS MON_HXSH_BAL    --12 月累计核销收回金额
        ,''                   AS HXSH_DT         --13 核销收回日期
        ,T5.LVL5_CL           AS LVL5_CL         --14 处置时点五级分类代码
        ,CASE WHEN T5.LVL5_CL = '01' THEN '正常类'
              WHEN T5.LVL5_CL = '02' THEN '关注类'
              WHEN T5.LVL5_CL = '03' THEN '次级类'
              WHEN T5.LVL5_CL = '04' THEN '可疑类'
              WHEN T5.LVL5_CL = '05' THEN '损失类'
         END                  AS LVL5_CL_NAME     --15 处置时点五级分类名称
        ,T4.LVL5_CL           AS NC_LVL5_CL       --16 年初五级分类代码
        ,CASE WHEN T4.LVL5_CL = '01' THEN '正常类'
              WHEN T4.LVL5_CL = '02' THEN '关注类'
              WHEN T4.LVL5_CL = '03' THEN '次级类'
              WHEN T4.LVL5_CL = '04' THEN '可疑类'
              WHEN T4.LVL5_CL = '05' THEN '损失类'
         END                  AS NC_LVL5_CL_NAME   --17 年初五级分类名称
        ,T3.LOAN_DIR_IDY      AS TXHY              --18 投向行业
        ,'零售贷款单笔转让'   AS DATA_SRC          --19 数据来源        
  FROM RRP_MDL.M_LOAN_TRF_REL_INFO T1 --信贷资产转让关系信息
  LEFT JOIN RRP_MDL.M_LOAN_CNCL_INFO T2 --资产核销信息
    ON T2.RCPT_ID = T1.RCPT_ID
   AND T2.DATA_SRC = '零售贷款差额核销'
   AND T2.DATA_DT = V_P_DATE
 INNER JOIN RRP_MDL.S_LOAN T3 --贷款整合表
    ON T3.RCPT_ID = T1.RCPT_ID
   AND T3.DATA_DT = V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN T4 --年初贷款数据
    ON T4.RCPT_ID = T1.RCPT_ID
   AND T4.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD') 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_LV5 T5 --资产处置五级分类表
    ON T5.RCPT_ID = T1.RCPT_ID
   AND T5.CZFS_DT = T1.ASSET_TRAN_DT 
  LEFT JOIN RRP_MDL.M_CUST_IND_INFO T6 --个人客户信息
    ON T6.CUST_ID = T3.CUST_ID
   AND T6.DATA_DT = V_P_DATE   
 WHERE T1.DATA_SRC = '零售贷款单笔转让'
   AND SUBSTR(T1.ASSET_TRAN_DT,0,4) = SUBSTR(V_P_DATE,0,4) --当年
   AND T1.DATA_DT = V_P_DATE;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '--加工零售贷款单笔转让资产证券化数据--';
  V_STARTTIME := SYSDATE;
  
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
   (   DATA_DT         --1 数据日期
      ,RCPT_ID         --2 借据号
      ,ORG_ID          --3 机构编号
      ,CUST_ID         --4 客户号
      ,CUST_NAME       --5 客户名称
      ,ZCLX_TYP        --6 资产类型
      ,CZFS_TYP        --7 处置方式
      ,CZFS_DT         --8 处置时间
      ,BS_CZFS_DT      --9 报送处置时间
      ,CZFS_BAL        --10 处置金额
      ,YEAR_HXSH_BAL   --11 年累计核销收回金额
      ,MON_HXSH_BAL    --12 月累计核销收回金额
      ,HXSH_DT         --13 核销收回日期
      ,LVL5_CL         --14 处置时点五级分类代码
      ,LVL5_CL_NAME    --15 处置时点五级分类名称
      ,NC_LVL5_CL      --16 年初五级分类代码
      ,NC_LVL5_CL_NAME --17 年初五级分类名称
      ,TXHY            --18 投向行业
      ,DATA_SRC        --19 数据来源
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE             AS DATA_DT         --1 数据日期
        ,T1.RCPT_ID           AS RCPT_ID         --2 借据号
        ,T3.ORG_ID            AS ORG_ID          --3 机构编号
        ,T3.CUST_ID           AS CUST_ID         --4 客户号
        ,T6.CUST_NM           AS CUST_NAME       --5 客户名称
        ,'不良贷款'           AS ZCLX_TYP        --6 资产类型
        ,'转让'               AS CZFS_TYP        --7 处置方式
        ,T1.ASSET_TRAN_DT     AS CZFS_DT         --8 处置时间
        ,T1.ASSET_TRAN_DT     AS BS_CZFS_DT      --9 报送处置时间
        ,(T1.TRF_LOAN_PRIN - NVL(T2.CNCL_LN_PRIN,T1.CNCL_LOAN_PRIN)) AS CZFS_BAL --10 处置金额
        ,0                    AS YEAR_HXSH_BAL   --11 年累计核销收回金额
        ,0                    AS MON_HXSH_BAL    --12 月累计核销收回金额
        ,''                   AS HXSH_DT         --13 核销收回日期
        ,T5.LVL5_CL           AS LVL5_CL         --14 处置时点五级分类代码
        ,CASE WHEN T5.LVL5_CL = '01' THEN '正常类'
              WHEN T5.LVL5_CL = '02' THEN '关注类'
              WHEN T5.LVL5_CL = '03' THEN '次级类'
              WHEN T5.LVL5_CL = '04' THEN '可疑类'
              WHEN T5.LVL5_CL = '05' THEN '损失类'
         END                  AS LVL5_CL_NAME     --15 处置时点五级分类名称
        ,T4.LVL5_CL           AS NC_LVL5_CL       --16 年初五级分类代码
        ,CASE WHEN T4.LVL5_CL = '01' THEN '正常类'
              WHEN T4.LVL5_CL = '02' THEN '关注类'
              WHEN T4.LVL5_CL = '03' THEN '次级类'
              WHEN T4.LVL5_CL = '04' THEN '可疑类'
              WHEN T4.LVL5_CL = '05' THEN '损失类'
         END                  AS NC_LVL5_CL_NAME   --17 年初五级分类名称
        ,T3.LOAN_DIR_IDY      AS TXHY              --18 投向行业
        ,'零售贷款单笔转让'   AS DATA_SRC          --19 数据来源        
  FROM RRP_MDL.M_LOAN_TRF_REL_INFO T1 --信贷资产转让关系信息
  LEFT JOIN RRP_MDL.M_LOAN_CNCL_INFO T2 --资产核销信息
    ON T2.RCPT_ID = T1.RCPT_ID
   AND T2.DATA_SRC = '零售贷款差额核销'
   AND T2.DATA_DT = V_P_DATE
 INNER JOIN RRP_MDL.S_LOAN T3 --贷款整合表
    ON T3.RCPT_ID = T1.RCPT_ID
   AND T3.DATA_DT = V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN T4 --年初贷款数据
    ON T4.RCPT_ID = T1.RCPT_ID
   AND T4.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD') 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_LV5 T5 --资产处置五级分类表
    ON T5.RCPT_ID = T1.RCPT_ID
   AND T5.CZFS_DT = T1.ASSET_TRAN_DT 
  LEFT JOIN RRP_MDL.M_CUST_IND_INFO T6 --个人客户信息
    ON T6.CUST_ID = T3.CUST_ID
   AND T6.DATA_DT = V_P_DATE   
 WHERE T1.DATA_SRC = '资产证券化'
   AND T1.LOAN_BIZ_TYP = '001' --零售
   AND SUBSTR(T1.ASSET_TRAN_DT,0,4) = SUBSTR(V_P_DATE,0,4) --当年
   AND T1.DATA_DT = V_P_DATE;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6;
  V_STEP_DESC := '--加工零售贷款不良收回数据--';
  V_STARTTIME := SYSDATE;
  
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
  (    DATA_DT               --1 数据日期
      ,RCPT_ID               --2 借据号
      ,ORG_ID                --3 机构编号
      ,CUST_ID               --4 客户号
      ,CUST_NAME             --5 客户名称
      ,ZCLX_TYP              --6 资产类型
      ,CZFS_TYP              --7 处置方式
      ,CZFS_DT               --8 处置时间
      ,BS_CZFS_DT            --9 报送处置时间
      ,CZFS_BAL              --10 处置金额
      ,YEAR_HXSH_BAL         --11 年累计核销收回金额
      ,MON_HXSH_BAL          --12 月累计核销收回金额
      ,HXSH_DT               --13 核销收回日期
      ,LVL5_CL               --14 处置时点五级分类代码
      ,LVL5_CL_NAME          --15 处置时点五级分类名称
      ,NC_LVL5_CL            --16 年初五级分类代码
      ,NC_LVL5_CL_NAME       --17 年初五级分类名称
      ,TXHY                  --18 投向行业
      ,DATA_SRC              --19 数据来源
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE                AS DATA_DT               --1 数据日期
        ,T1.RCPT_ID              AS RCPT_ID               --2 借据号
        ,T2.ORG_ID               AS ORG_ID                --3 机构编号
        ,T2.CUST_ID              AS CUST_ID               --4 客户号
        ,T5.CUST_NM              AS CUST_NAME             --5 客户名称
        ,'不良贷款'              AS ZCLX_TYP              --6 资产类型
        ,'直接催收'              AS CZFS_TYP              --7 处置方式
        ,T1.CZFS_DT              AS CZFS_DT               --8 处置时间
        ,T1.CZFS_DT              AS BS_CZFS_DT            --9 报送处置时间
        ,T1.CZFS_BAL             AS CZFS_BAL              --10 处置金额
        ,0                       AS YEAR_HXSH_BAL         --11 年累计核销收回金额
        ,0                       AS MON_HXSH_BAL          --12 月累计核销收回金额
        ,''                      AS HXSH_DT               --13 核销收回日期
        ,T4.LVL5_CL              AS LVL5_CL               --14 处置时点五级分类代码
        ,CASE WHEN T4.LVL5_CL = '01' THEN '正常类'
              WHEN T4.LVL5_CL = '02' THEN '关注类'
              WHEN T4.LVL5_CL = '03' THEN '次级类'
              WHEN T4.LVL5_CL = '04' THEN '可疑类'
              WHEN T4.LVL5_CL = '05' THEN '损失类'
         END                     AS LVL5_CL_NAME          --15 处置时点五级分类名称
        ,T3.LVL5_CL              AS NC_LVL5_CL            --16 年初五级分类代码
        ,CASE WHEN T3.LVL5_CL = '01' THEN '正常类'
              WHEN T3.LVL5_CL = '02' THEN '关注类'
              WHEN T3.LVL5_CL = '03' THEN '次级类'
              WHEN T3.LVL5_CL = '04' THEN '可疑类'
              WHEN T3.LVL5_CL = '05' THEN '损失类'
         END                     AS NC_LVL5_CL_NAME       --17 年初五级分类名称
        ,T2.LOAN_DIR_IDY         AS TXHY                  --18 投向行业
        ,'零售贷款不良收回'      AS DATA_SRC              --19 数据来源        
  FROM RRP_MDL.S_LOAN_BAL_CHANGE_EX T1 --记录贷款余额不良变动
 INNER JOIN RRP_MDL.S_LOAN T2 --贷款整合表
    ON T2.RCPT_ID = T1.RCPT_ID
   AND T2.DATA_DT = V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN T3 --年初贷款数据
    ON T3.RCPT_ID = T1.RCPT_ID
   AND T3.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD') 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_LV5 T4 --资产处置五级分类表
    ON T4.RCPT_ID = T1.RCPT_ID
   AND T4.CZFS_DT = T1.CZFS_DT 
  LEFT JOIN RRP_MDL.M_CUST_IND_INFO T5 --个人客户信息
    ON T5.CUST_ID = T3.CUST_ID
   AND T5.DATA_DT = V_P_DATE   
 WHERE T1.CZFS_TYP = '不良贷款收回'
   AND SUBSTR(T1.CZFS_DT,0,4) = SUBSTR(V_P_DATE,0,4) --当年
   AND T1.DATA_DT = V_P_DATE;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 7;
  V_STEP_DESC := '--加工核销数据--';
  V_STARTTIME := SYSDATE;
  
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
  (    DATA_DT               --1 数据日期
      ,RCPT_ID               --2 借据号
      ,ORG_ID                --3 机构编号
      ,CUST_ID               --4 客户号
      ,CUST_NAME             --5 客户名称
      ,ZCLX_TYP              --6 资产类型
      ,CZFS_TYP              --7 处置方式
      ,CZFS_DT               --8 处置时间
      ,BS_CZFS_DT            --9 报送处置时间
      ,CZFS_BAL              --10 处置金额
      ,YEAR_HXSH_BAL         --11 年累计核销收回金额
      ,MON_HXSH_BAL          --12 月累计核销收回金额
      ,HXSH_DT               --13 核销收回日期
      ,LVL5_CL               --14 处置时点五级分类代码
      ,LVL5_CL_NAME          --15 处置时点五级分类名称
      ,NC_LVL5_CL            --16 年初五级分类代码
      ,NC_LVL5_CL_NAME       --17 年初五级分类名称
      ,TXHY                  --18 投向行业
      ,DATA_SRC              --19 数据来源
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE                 AS DATA_DT          --1 数据日期
        ,T1.RCPT_ID               AS RCPT_ID          --2 借据号
        ,T2.ORG_ID                AS ORG_ID           --3 机构编号
        ,T2.CUST_ID               AS CUST_ID          --4 客户号
        ,T6.CUST_NM               AS CUST_NAME        --5 客户名称
        ,'不良贷款'               AS ZCLX_TYP         --6 资产类型
        ,CASE WHEN T1.DATA_SRC = '零售贷款差额核销' 
              THEN '差额核销'
              ELSE '全额核销' 
          END                     AS CZFS_TYP         --7 处置方式
        ,T1.CNCL_DT               AS CZFS_DT          --8 处置时间
        ,T1.CNCL_DT               AS BS_CZFS_DT       --9 报送处置时间
        ,T1.CNCL_LN_PRIN          AS CZFS_BAL         --10 处置金额
        ,T5.YEAR_HXSH_BAL         AS YEAR_HXSH_BAL    --11 年累计核销收回金额
        ,T5.MON_HXSH_BAL          AS MON_HXSH_BAL     --12 月累计核销收回金额
        ,T5.HXSH_DT               AS HXSH_DT          --13 核销收回日期
        ,T4.LVL5_CL               AS LVL5_CL          --14 处置时点五级分类代码
        ,CASE WHEN T4.LVL5_CL = '01' THEN '正常类'
              WHEN T4.LVL5_CL = '02' THEN '关注类'
              WHEN T4.LVL5_CL = '03' THEN '次级类'
              WHEN T4.LVL5_CL = '04' THEN '可疑类'
              WHEN T4.LVL5_CL = '05' THEN '损失类'
         END                      AS LVL5_CL_NAME     --15 处置时点五级分类名称
        ,T3.LVL5_CL               AS NC_LVL5_CL       --16 年初五级分类代码
        ,CASE WHEN T3.LVL5_CL = '01' THEN '正常类'
              WHEN T3.LVL5_CL = '02' THEN '关注类'
              WHEN T3.LVL5_CL = '03' THEN '次级类'
              WHEN T3.LVL5_CL = '04' THEN '可疑类'
              WHEN T3.LVL5_CL = '05' THEN '损失类'
         END                      AS NC_LVL5_CL_NAME  --17 年初五级分类名称
        ,T2.LOAN_DIR_IDY          AS TXHY             --18 投向行业
        ,CASE WHEN T1.DATA_SRC = '零售贷款' THEN '零售贷款全额核销'
              WHEN T1.DATA_SRC = '联合网贷' THEN '联合网贷全额核销'
              ELSE '零售贷款差额核销' 
          END                     AS DATA_SRC         --19 数据来源        
  FROM RRP_MDL.M_LOAN_CNCL_INFO T1 --资产核销信息
 INNER JOIN RRP_MDL.S_LOAN T2 --贷款整合表
    ON T2.RCPT_ID = T1.RCPT_ID
   AND T2.DATA_DT = V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN T3 --年初贷款数据
    ON T3.RCPT_ID = T1.RCPT_ID
   AND T3.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD') 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_LV5 T4 --资产处置五级分类表
    ON T4.RCPT_ID = T1.RCPT_ID
   AND T4.CZFS_DT = T1.CNCL_DT 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_HXSH T5 --资产处置核销收回表
    ON T5.RCPT_ID = T1.RCPT_ID
  LEFT JOIN RRP_MDL.M_CUST_IND_INFO T6 --个人客户信息
    ON T6.CUST_ID = T3.CUST_ID
   AND T6.DATA_DT = V_P_DATE   
 WHERE T1.DATA_SRC IN ('零售贷款差额核销','零售贷款','联合网贷')
   AND SUBSTR(T1.CNCL_DT,0,4) = SUBSTR(V_P_DATE,0,4) --当年
   AND T1.DATA_DT = V_P_DATE;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 8;
  V_STEP_DESC := '--加工联合网贷不良收回数据--';
  V_STARTTIME := SYSDATE;
  --由于联合网贷处置清收存的是每天每月全量，因此需要取每月月末+当前日期   
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
  (    DATA_DT               --1 数据日期
      ,RCPT_ID               --2 借据号
      ,ORG_ID                --3 机构编号
      ,CUST_ID               --4 客户号
      ,CUST_NAME             --5 客户名称
      ,ZCLX_TYP              --6 资产类型
      ,CZFS_TYP              --7 处置方式
      ,CZFS_DT               --8 处置时间
      ,BS_CZFS_DT            --9 报送处置时间
      ,CZFS_BAL              --10 处置金额
      ,YEAR_HXSH_BAL         --11 年累计核销收回金额
      ,MON_HXSH_BAL          --12 月累计核销收回金额
      ,HXSH_DT               --13 核销收回日期
      ,LVL5_CL               --14 处置时点五级分类代码
      ,LVL5_CL_NAME          --15 处置时点五级分类名称
      ,NC_LVL5_CL            --16 年初五级分类代码
      ,NC_LVL5_CL_NAME       --17 年初五级分类名称
      ,TXHY                  --18 投向行业
      ,DATA_SRC              --19 数据来源
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE                 AS DATA_DT            --1 数据日期
        ,T1.DUBIL_ID              AS RCPT_ID            --2 借据号
        ,T1.ORG_ID                AS ORG_ID             --3 机构编号
        ,T1.CUST_ID               AS CUST_ID            --4 客户号
        ,T1.CUST_NAME             AS CUST_NAME          --5 客户名称
        ,'不良贷款'               AS ZCLX_TYP           --6 资产类型
        ,'现金收回'               AS CZFS_TYP           --7 处置方式
        ,TO_CHAR(T1.DISPL_DT,'YYYYMMDD')      
                                  AS CZFS_DT            --8 处置时间
        ,TO_CHAR(T1.DISPL_DT,'YYYYMMDD')              
                                  AS BS_CZFS_DT         --9 报送处置时间
        ,T1.DISPL_AMT             AS CZFS_BAL           --10 处置金额
        ,0                        AS YEAR_HXSH_BAL      --11 年累计核销收回金额
        ,0                        AS MON_HXSH_BAL       --12 月累计核销收回金额
        ,''                       AS HXSH_DT            --13 核销收回日期
        ,CASE WHEN T1.DISPL_LVL5_CL IN ('正常') THEN '01'
              WHEN T1.DISPL_LVL5_CL IN ('关注') THEN '02'
              WHEN T1.DISPL_LVL5_CL IN ('次级') THEN '03'
              WHEN T1.DISPL_LVL5_CL IN ('可疑') THEN '04'
              WHEN T1.DISPL_LVL5_CL IN ('损失') THEN '05'
          END                     AS LVL5_CL             --14 处置时点五级分类代码
        ,CASE WHEN T1.DISPL_LVL5_CL IN ('正常') THEN '正常类'
              WHEN T1.DISPL_LVL5_CL IN ('关注') THEN '关注类'
              WHEN T1.DISPL_LVL5_CL IN ('次级') THEN '次级类'
              WHEN T1.DISPL_LVL5_CL IN ('可疑') THEN '可疑类'
              WHEN T1.DISPL_LVL5_CL IN ('损失') THEN '损失类'
          END                     AS LVL5_CL_NAME       --15 处置时点五级分类名称
        ,T2.LVL5_CL               AS NC_LVL5_CL         --16 年初五级分类代码
        ,CASE WHEN T2.LVL5_CL = '01' THEN '正常类'
              WHEN T2.LVL5_CL = '02' THEN '关注类'
              WHEN T2.LVL5_CL = '03' THEN '次级类'
              WHEN T2.LVL5_CL = '04' THEN '可疑类'
              WHEN T2.LVL5_CL = '05' THEN '损失类'
         END                      AS NC_LVL5_CL_NAME    --17 年初五级分类名称
        ,T1.INDUS                 AS TXHY               --18 投向行业
        ,'联合网贷不良收回'       AS DATA_SRC           --19 数据来源        
  FROM RRP_MDL.S_ASSET_DISPL_INFO T1 --资产清收处置信息
  LEFT JOIN RRP_MDL.S_LOAN T2 --年初贷款数据
    ON T2.RCPT_ID = T1.DUBIL_ID
   AND T2.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD')  
 WHERE T1.DISPL_WAY = '现金收回'
   AND T1.ASSET_TYPE = '不良贷款'
   AND ( T1.DATA_DT IN (
                           SELECT TO_CHAR(ADD_MONTHS(LAST_DAY(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1),+ROWNUM),'YYYYMMDD') AS LASTDATE
                           FROM DUAL
                           CONNECT BY ROWNUM <= CEIL(MONTHS_BETWEEN(TO_DATE(V_P_DATE,'YYYYMMDD'),TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1))
                        )--当年每月月末
            OR T1.DATA_DT = V_P_DATE);
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 9;
  V_STEP_DESC := '--加工对公资产处置数据--';
  V_STARTTIME := SYSDATE;
  
  INSERT /*+APPEND*/ INTO RRP_MDL.S_LOAN_ZCCZ
  (    DATA_DT               --1 数据日期
      ,RCPT_ID               --2 借据号
      ,ORG_ID                --3 机构编号
      ,CUST_ID               --4 客户号
      ,CUST_NAME             --5 客户名称
      ,ZCLX_TYP              --6 资产类型
      ,CZFS_TYP              --7 处置方式
      ,CZFS_DT               --8 处置时间
      ,BS_CZFS_DT            --9 报送处置时间
      ,CZFS_BAL              --10 处置金额
      ,YEAR_HXSH_BAL         --11 年累计核销收回金额
      ,MON_HXSH_BAL          --12 月累计核销收回金额
      ,HXSH_DT               --13 核销收回日期
      ,LVL5_CL               --14 处置时点五级分类代码
      ,LVL5_CL_NAME          --15 处置时点五级分类名称
      ,NC_LVL5_CL            --16 年初五级分类代码
      ,NC_LVL5_CL_NAME       --17 年初五级分类名称
      ,TXHY                  --18 投向行业
      ,DATA_SRC              --19 数据来源
  ) 
--存在DISP_WAY_CD = '04' 同其他处置方式金额加总相等的情况，需要将该部分剔除
WITH TMP AS (
SELECT A.DUBIL_ID,A.BAL_CHAG_DATE,COUNT(1) NUM
FROM RRP_MDL.O_ICL_CMM_LOAN_BAL_CHG_INFO A
WHERE A.BUS_LINE_CD = '01' --对公
AND A.BAL_TM_LVL5_CLS_CD IN ('30','40','50') --不良贷款
AND SUBSTR(TO_CHAR(A.ETL_DT,'YYYYMMDD'),0,4) = SUBSTR(V_P_DATE,0,4) --当年发生
GROUP BY A.DUBIL_ID,A.BAL_CHAG_DATE
HAVING COUNT(1) >1
),
TMP2 AS (
SELECT A.DUBIL_ID,A.BAL_CHAG_DATE,A.DISP_WAY_CD 
FROM RRP_MDL.O_ICL_CMM_LOAN_BAL_CHG_INFO A
INNER JOIN TMP B
ON B.DUBIL_ID = A.DUBIL_ID
WHERE A.BUS_LINE_CD = '01' --对公
AND A.BAL_TM_LVL5_CLS_CD IN ('30','40','50') --不良贷款
AND A.DISP_WAY_CD = '04'
AND SUBSTR(TO_CHAR(A.ETL_DT,'YYYYMMDD'),0,4) = SUBSTR(V_P_DATE,0,4) --当年发生
),
TMP_DCCZ AS (
 SELECT /*+MATERIALIZE*/
         T.DUBIL_ID AS RCPT_ID
        ,T.ACCT_INSTIT_ID AS ORG_NO
        ,T.BAL_TM_LVL5_CLS_CD AS LVL5_CLS_CD
        ,T.PRIC_AMT AS PRIC_AMT
        ,T1.LOAN_DIR_IDY AS LOAN_DIR_IDY
        ,T.ETL_DT AS CZFS_DT
        ,T.DISP_WAY_CD AS DISP_WAY_CD
        ,V_P_DATE AS DATA_DT
    FROM RRP_MDL.O_ICL_CMM_LOAN_BAL_CHG_INFO T --不良问题贷款余额变动信息 
    LEFT JOIN RRP_MDL.S_LOAN T1 --贷款整合表
      ON T1.RCPT_ID = T.DUBIL_ID
     AND T1.DATA_DT = V_P_DATE    
    LEFT JOIN TMP2 S
           ON S.DUBIL_ID = T.DUBIL_ID
          AND S.DISP_WAY_CD = T.DISP_WAY_CD
   WHERE S.DUBIL_ID IS NULL --剔除重复数据
     AND T.BUS_LINE_CD = '01' --对公
     AND T.BAL_TM_LVL5_CLS_CD IN ('30','40','50') --不良贷款
     AND ( T.DISP_WAY_CD NOT IN ('04') 
           OR (T.DISP_WAY_CD = '04' AND TRUNC(NVL(T.WRT_OFF_DT,TO_DATE('29991231','YYYYMMDD'))) > TRUNC(T.BAL_CHAG_DATE))
         )
     AND SUBSTR(TO_CHAR(T.ETL_DT,'YYYYMMDD'),0,4) = SUBSTR(V_P_DATE,0,4) --当年发生 
  ) 
  SELECT /*+use_hash(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T1 T2 T3 T4 T5 T6 T7 T8 T9) full(T9)*/
         V_P_DATE                 AS DATA_DT          --1 数据日期
        ,T1.RCPT_ID               AS RCPT_ID          --2 借据号
        ,T2.ORG_ID                AS ORG_ID           --3 机构编号
        ,T2.CUST_ID               AS CUST_ID          --4 客户号
        ,T6.CUST_NM               AS CUST_NAME        --5 客户名称
        ,'不良贷款'               AS ZCLX_TYP         --6 资产类型
        ,CASE WHEN T1.DISP_WAY_CD = '01' THEN '转让'
              WHEN T1.DISP_WAY_CD = '02' THEN '全额核销'
              WHEN T1.DISP_WAY_CD = '03' THEN '差额核销'
              WHEN T1.DISP_WAY_CD = '04' THEN '现金收回'
          END                     AS CZFS_TYP         --7 处置方式
        ,TO_CHAR(T1.CZFS_DT,'YYYYMMDD')               
                                  AS CZFS_DT          --8 处置时间
        ,TO_CHAR(T1.CZFS_DT,'YYYYMMDD') 
                                  AS BS_CZFS_DT       --9 报送处置时间
        ,T1.PRIC_AMT*D.EXRT       AS CZFS_BAL         --10 处置金额
        ,0                        AS YEAR_HXSH_BAL    --11 年累计核销收回金额
        ,0                        AS MON_HXSH_BAL     --12 月累计核销收回金额
        ,''                       AS HXSH_DT          --13 核销收回日期
        ,CASE WHEN T1.LVL5_CLS_CD = '10' THEN '01'
              WHEN T1.LVL5_CLS_CD = '20' THEN '02'
              WHEN T1.LVL5_CLS_CD = '30' THEN '03'
              WHEN T1.LVL5_CLS_CD = '40' THEN '04'
              WHEN T1.LVL5_CLS_CD = '50' THEN '05'
         END                      AS LVL5_CL          --14 处置时点五级分类代码       
        ,CASE WHEN T1.LVL5_CLS_CD = '10' THEN '正常类'
              WHEN T1.LVL5_CLS_CD = '20' THEN '关注类'
              WHEN T1.LVL5_CLS_CD = '30' THEN '次级类'
              WHEN T1.LVL5_CLS_CD = '40' THEN '可疑类'
              WHEN T1.LVL5_CLS_CD = '50' THEN '损失类'
         END                      AS LVL5_CL_NAME     --15 处置时点五级分类名称
        ,T3.LVL5_CL               AS NC_LVL5_CL       --16 年初五级分类代码
        ,CASE WHEN T3.LVL5_CL = '01' THEN '正常类'
              WHEN T3.LVL5_CL = '02' THEN '关注类'
              WHEN T3.LVL5_CL = '03' THEN '次级类'
              WHEN T3.LVL5_CL = '04' THEN '可疑类'
              WHEN T3.LVL5_CL = '05' THEN '损失类'
         END                      AS NC_LVL5_CL_NAME  --17 年初五级分类名称
        ,T2.LOAN_DIR_IDY          AS TXHY             --18 投向行业
        ,CASE WHEN T1.DISP_WAY_CD = '01' THEN '对公贷款资产转让'
              WHEN T1.DISP_WAY_CD = '02' THEN '对公贷款全额核销'
              WHEN T1.DISP_WAY_CD = '03' THEN '对公贷款差额核销'
              WHEN T1.DISP_WAY_CD = '04' THEN '对公贷款现金收回'
          END                     AS DATA_SRC         --19 数据来源        
  FROM TMP_DCCZ T1 --资产处置
 INNER JOIN RRP_MDL.S_LOAN T2 --贷款整合表
    ON T2.RCPT_ID = T1.RCPT_ID
   AND T2.DATA_DT = V_P_DATE
  LEFT JOIN RRP_MDL.S_LOAN T3 --年初贷款数据
    ON T3.RCPT_ID = T1.RCPT_ID
   AND T3.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')-1,'YYYYMMDD') 
/*  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_LV5 T4 --资产处置五级分类表
    ON T4.RCPT_ID = T1.RCPT_ID
   AND T4.CZFS_DT = T1.CNCL_DT 
  LEFT JOIN RRP_MDL.S_LOAN_ZCCZ_HXSH T5 --资产处置核销收回表
    ON T5.RCPT_ID = T1.RCPT_ID*/
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D --汇率表
      ON D.BASE_CUR = T2.CUR --基准币种
     AND D.CNV_CUR = 'CNY' --折算币种
     AND D.DATA_DT = T1.DATA_DT    
  LEFT JOIN RRP_MDL.M_CUST_CORP_INFO T6 --对公客户信息
    ON T6.CUST_ID = T3.CUST_ID
   AND T6.DATA_DT = V_P_DATE   
 WHERE T1.DATA_DT = V_P_DATE;
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --剔除跨年冲正借据 20260212
  DELETE FROM RRP_MDL.S_LOAN_ZCCZ A WHERE A.RCPT_ID  IN ('R20220708694554599761') AND A.CZFS_BAL < 0 AND A.DATA_DT = V_P_DATE;
  COMMIT;
  
  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_ZCCZ;
/

