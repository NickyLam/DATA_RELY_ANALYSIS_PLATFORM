CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_FIN_INST_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_M_FIN_INST_INFO
  *  功能描述：金融工具信息表
  *  创建日期：20220609
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_B_FIN_INST_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220609  梅炜      首次创建
  *             2    20221122  hulj      增加数据重复校验
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_FIN_INST_INFO
'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
 /* V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期*/
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_BEG_THIS_MON DATE; --本月初
  V_BEG_THIS_YEAR DATE;--本年初
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_BEG_THIS_MON := TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'),'MM'); --本月初
  V_BEG_THIS_YEAR := TO_DATE(SUBSTR(V_P_DATE,1,4)||'0101','YYYYMMDD'); --本年初
  V_TAB_NAME := 'M_FIN_INST_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

 -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入金融工具信息表-资金债券回购表出卖出回购和买入返售数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
       DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                                AS DATA_DT                    --数据日期
    ,A.LP_ID                                                                      AS LGL_REP_ID                 --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                                                 AS ORG_ID                     --机构编号
    ,B.CNTPTY_ID ||'_'|| B.TRAN_ID                                                AS FIN_INST_ID                --金融工具编号
    --,B.CNTPTY_NAME||'_'||DECODE(B.TRAN_DIR_CD,'01','质押式正回购','质押式逆回购') AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN B.REPO_TYPE_CD = 'N' AND B.TRAN_DIR_CD = '01' THEN '质押式正回购'
          WHEN B.REPO_TYPE_CD = 'N' AND B.TRAN_DIR_CD = '02' THEN '质押式逆回购'
          WHEN B.REPO_TYPE_CD = 'B' AND B.TRAN_DIR_CD = '01' THEN '买断式正回购'
          WHEN B.REPO_TYPE_CD = 'B' AND B.TRAN_DIR_CD = '02' THEN '买断式逆回购'
     END                                                                          AS FIN_INST_NM                --金融工具名称
    --,'99'||DECODE(B.TRAN_DIR_CD,'01','08','09')                                   AS AST_TYP                    --资产类型
    ,CASE WHEN B.REPO_TYPE_CD = 'N' AND B.TRAN_DIR_CD = '01' THEN '9908'   --其他-质押式正回购
          WHEN B.REPO_TYPE_CD = 'N' AND B.TRAN_DIR_CD = '02' THEN '9909'   --其他-质押式逆回购
          WHEN B.REPO_TYPE_CD = 'B' AND B.TRAN_DIR_CD = '01' THEN '9901'   --其他-买断式正回购
          WHEN B.REPO_TYPE_CD = 'B' AND B.TRAN_DIR_CD = '02' THEN '9902'   --其他-买断式逆回购
     END                                                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                                                    AS CUR                        --币种
    ,B.TRAN_AMT                                                                   AS ISU_PRC                    --发行价格
    ,B.TRAN_AMT                                                                   AS ISU_TOT_SCALE              --发行总规模
    ,D.CUST_NAME                                                                  AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                                                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(B.TRAN_DT, 'YYYYMMDD')                                               AS ISU_DT                     --发行日期
    ,TO_CHAR(B.EXP_DT, 'YYYYMMDD')                                                AS EXP_DT                     --到期日期
    ,'非LPR'                                                                      AS RATE_TYP                   --利率类型
    ,B.REPO_INT_RAT /*A.ACTL_INT_RAT*/                                            AS ACT_RATE                   --实际利率
    ,'N'                                                                          AS OPTION_FLG                 --含权标识
    ,B.TRAN_AMT                                                                   AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(B.TRAN_DT, 'YYYYMMDD')                                               AS ASES_PRC_DT                --评估价格日期
    ,NULL                                                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,NULL                                                                         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                                                         AS DEPT_LINE                  --部门条线
    ,'资金债券回购表出卖出回购和买入返售数据'                                        AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
  INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BOND_REPO B  --资金债券回购
     ON A.BUS_ID = B.BUS_ID
    AND B.REPO_TYPE_CD IN ('N','B') --N-质押式回购交易、B-买断式回购交易
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D    --对公客户基本信息
     ON D.CUST_ID = B.CUST_ID
    AND D.ETL_DT = B.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.ASSET_TYPE_NAME LIKE '%回购%'
    AND (A.CURR_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    --AND (A.CURR_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入金融工具信息表-资金业务持仓表出银行次级债、银行永续债数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     T.DATA_DT                       AS DATA_DT                    --数据日期
    ,T.LGL_REP_ID                    AS LGL_REP_ID                 --法人编号
    ,MAX(T.ORG_ID)                   AS ORG_ID                     --机构编号
    ,T.FIN_INST_ID                   AS FIN_INST_ID                --金融工具编号
    ,T.FIN_INST_NM                   AS FIN_INST_NM                --金融工具名称
    ,T.AST_TYP                       AS AST_TYP                    --资产类型
    ,MAX(T.CUR)                      AS CUR                        --币种
    ,MAX(T.ISU_PRC)                  AS ISU_PRC                    --发行价格
    ,MAX(T.ISU_TOT_SCALE)            AS ISU_TOT_SCALE              --发行总规模
    ,MAX(T.ISU_ORG_NM)               AS ISU_ORG_NM                 --发行机构名称
    ,MAX(T.ISU_ORG_ID)               AS ISU_ORG_ID                 --发行机构编码
    ,MAX(T.ISU_CTRY_CD)              AS ISU_CTRY_CD                --发行国家代码
    ,MAX(T.ISU_DT)                   AS ISU_DT                     --发行日期
    ,MAX(T.EXP_DT)                   AS EXP_DT                     --到期日期
    ,MAX(T.RATE_TYP)                 AS RATE_TYP                   --利率类型
    ,MAX(T.ACT_RATE)                 AS ACT_RATE                   --实际利率
    ,MAX(T.OPTION_FLG)               AS OPTION_FLG                 --含权标识
    ,MAX(T.RCTLY_ASES_PRC)           AS RCTLY_ASES_PRC             --最近评估价格
    ,MAX(T.ASES_PRC_DT)              AS ASES_PRC_DT                --评估价格日期
    ,MAX(T.BASE_AST_ID)              AS BASE_AST_ID                --基础资产编号
    ,MAX(T.BASE_AST_NM)              AS BASE_AST_NM                --基础资产名称
    ,SUM(T.BASE_AST_SCALE)           AS BASE_AST_SCALE             --基础资产规模
    ,SUM(T.BASE_AST_PCT)             AS BASE_AST_PCT               --基础资产占比
    ,MAX(T.BASE_AST_RTG)             AS BASE_AST_RTG               --基础资产评级
    ,MAX(T.BASE_AST_RTG_ORG_NM)      AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,MAX(T.BASE_AST_CUST_NM)         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,MAX(T.BASE_AST_CUST_CTRY_CD)    AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,MAX(T.BASE_AST_CUST_RTG)        AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,MAX(T.BASE_AST_CUST_RTG_ORG_NM) AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,MAX(T.BASE_AST_CUST_IDY)        AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,MAX(T.FNL_DIR_TYP)              AS FNL_DIR_TYP                --最终投向类型
    ,MAX(T.FNL_DIR_IDY)              AS FNL_DIR_IDY                --最终投向行业
    ,MAX(T.DEPT_LINE)                AS DEPT_LINE                  --部门条线
    ,MAX(T.DATA_SRC)                 AS DATA_SRC                   --数据来源
  FROM (
    SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
      ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
      ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID                     --机构编号
      ,B.BOND_ID  /*A.BAL_ID*/                      AS FIN_INST_ID                --金融工具编号
      ,B.BOND_NAME                                  AS FIN_INST_NM                --金融工具名称
      ,'9905'                                       AS AST_TYP                    --资产类型
      ,B.CURR_CD                                    AS CUR                        --币种
      ,B.ISSUE_PRICE                                AS ISU_PRC                    --发行价格
      ,B.ISSUE_SIZE * 100000000                     AS ISU_TOT_SCALE              --发行总规模
      ,B.ISSUER_NAME                                AS ISU_ORG_NM                 --发行机构名称
      ,'91440500279832882U'                         AS ISU_ORG_ID                 --发行机构编码
      ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
      ,TO_CHAR(B.ISSUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
      ,TO_CHAR(B.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
      ,'非LPR'                                      AS RATE_TYP                   --利率类型
      ,NVL(TRIM(B.FAC_VAL_INT_RAT),B.ISSUE_INT_RAT) AS ACT_RATE                   --实际利率
      ,DECODE(B.EX_CHOICE_TYPE_CD,'0','N','Y')      AS OPTION_FLG                 --含权标识
      ,B.ISSUE_PRICE                                AS RCTLY_ASES_PRC             --最近评估价格
      ,TO_CHAR(B.ISSUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
      ,B.BOND_ID                                    AS BASE_AST_ID                --基础资产编号
      ,B.BOND_NAME                                  AS BASE_AST_NM                --基础资产名称
      ,A.HOLD_POS                                   AS BASE_AST_SCALE             --基础资产规模
      ,CASE WHEN NVL(TRIM(B.ISSUE_SIZE),0) <> 0 THEN ROUND(A.HOLD_POS/B.ISSUE_SIZE/1000000,2)
            ELSE 0
       END                                          AS BASE_AST_PCT               --基础资产占比
      ,E.RATING_REST_CD                             AS BASE_AST_RTG               --基础资产评级
      ,E.RATING_CORP_CN_NAME                        AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
      ,B.ISSUER_NAME                                AS BASE_AST_CUST_NM           --基础资产客户名称
      ,'CHN'                                        AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
      ,F.RATING_REST_CD                             AS BASE_AST_CUST_RTG          --基础资产客户评级
      ,F.RATING_CORP_CN_NAME                        AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
      ,'J6621'                                      AS BASE_AST_CUST_IDY          --基础资产客户行业
      ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
      ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
      ,NULL                                         AS DEPT_LINE                  --部门条线
      ,'资金业务持仓表出银行次级债、银行永续债数据'    AS DATA_SRC                   --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
    INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
       ON A.MAIN_ASSET_ID = B.BOND_ID
      AND A.ETL_DT = B.ETL_DT
    LEFT JOIN (
         SELECT BOND_ID
               ,RATING_CORP_CN_NAME
               ,RATING_REST_CD
               ,ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY RATING_DT DESC) AS NUM
         FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO --债券评级信息
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ) E
      ON B.BOND_ID = E.BOND_ID
     AND E.NUM = 1
    LEFT JOIN (
         SELECT ISSUER_ID
               ,ISSUER_CUST_ID
               ,RATING_CORP_CN_NAME
               ,RATING_REST_CD
               ,ROW_NUMBER() OVER(PARTITION BY ISSUER_ID ORDER BY RATING_DT DESC) AS NUM
         FROM RRP_MDL.O_ICL_CMM_ISSUER_RATING_INFO   --发行人评级信息
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ) F
      ON B.ISSUER_CD = F.ISSUER_ID
     AND F.NUM = 1
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')

      AND A.ASSET_TYPE_NAME = '债券发行'
      AND B.BOND_TYPE_CD IN ('7','71','X','Y')
      --AND (A.CURR_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
      AND A.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.HOLD_POS <> 0
      AND TRIM(A.SUBJ_ID) IS NOT NULL
  ) T
  GROUP BY T.DATA_DT,T.LGL_REP_ID,T.FIN_INST_ID,T.FIN_INST_NM,T.AST_TYP
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-同业现金借贷表出卖出回购和买入返售、同业拆入、拆放同业和非结算性存放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID                     --机构编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID                --金融工具编号
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN A.ACTL_FINER_NAME||'_'||'质押式逆回购'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN A.ACTL_FINER_NAME||'_'||'质押式正回购'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1011' THEN C.FIN_INSTM_NAME
          ELSE A.ACTL_FINER_NAME||'_'||A.ASSET_TYPE_NAME
     END                                          AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '9909'    --其他-质押式逆回购
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '9908'    --其他-质押式正回购
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '9903'    --其他-同业拆入
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '9904'    --其他-同业拆出
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1011' THEN '01'      --现金及银行存款
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.ACTL_BAL                                   AS ISU_PRC                    --发行价格
    ,A.ACTL_BAL                                   AS ISU_TOT_SCALE              --发行总规模
    ,A.ACTL_FINER_NAME                            AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.FAC_VAL_INT_RAT                            AS ACT_RATE                   --实际利率
    ,'N'                                          AS OPTION_FLG                 --含权标识
    ,A.ACTL_BAL                                   AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
    ,NULL                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,A.ACTL_FINER_NAME                            AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'同业现金借贷表出卖出回购和买入返售、同业拆入、拆放同业和非结算性存放同业数据'
                                                  AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT A  --同业现金借贷表
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN O_ICL_CMM_CORP_CUST_BASIC_INFO D    --对公客户基本信息
     ON D.CUST_ID = A.ACTL_FINER_CUST_ID
    AND D.ETL_DT = A.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND SUBSTR(A.SUBJ_ID,1,4) IN ('1111','2111','1302','2003','1011')
    --AND (A.CURRT_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND (A.ACTL_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    AND A.CURRT_BAL > 0
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-资金债券投资表出同业存单投资和债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     T.DATA_DT                       AS DATA_DT                    --数据日期
    ,T.LGL_REP_ID                    AS LGL_REP_ID                 --法人编号
    ,MAX(T.ORG_ID)                   AS ORG_ID                     --机构编号
    ,T.FIN_INST_ID                   AS FIN_INST_ID                --金融工具编号
    ,T.FIN_INST_NM                   AS FIN_INST_NM                --金融工具名称
    ,T.AST_TYP                       AS AST_TYP                    --资产类型
    ,MAX(T.CUR)                      AS CUR                        --币种
    ,MAX(T.ISU_PRC)                  AS ISU_PRC                    --发行价格
    ,MAX(T.ISU_TOT_SCALE)            AS ISU_TOT_SCALE              --发行总规模
    ,MAX(T.ISU_ORG_NM)               AS ISU_ORG_NM                 --发行机构名称
    ,MAX(T.ISU_ORG_ID)               AS ISU_ORG_ID                 --发行机构编码
    ,MAX(T.ISU_CTRY_CD)              AS ISU_CTRY_CD                --发行国家代码
    ,MAX(T.ISU_DT)                   AS ISU_DT                     --发行日期
    ,MAX(T.EXP_DT)                   AS EXP_DT                     --到期日期
    ,MAX(T.RATE_TYP)                 AS RATE_TYP                   --利率类型
    ,MAX(T.ACT_RATE)                 AS ACT_RATE                   --实际利率
    ,MAX(T.OPTION_FLG)               AS OPTION_FLG                 --含权标识
    ,MAX(T.RCTLY_ASES_PRC)           AS RCTLY_ASES_PRC             --最近评估价格
    ,MAX(T.ASES_PRC_DT)              AS ASES_PRC_DT                --评估价格日期
    ,MAX(T.BASE_AST_ID)              AS BASE_AST_ID                --基础资产编号
    ,MAX(T.BASE_AST_NM)              AS BASE_AST_NM                --基础资产名称
    ,SUM(T.BASE_AST_SCALE)           AS BASE_AST_SCALE             --基础资产规模
    ,SUM(T.BASE_AST_PCT)             AS BASE_AST_PCT               --基础资产占比
    ,MAX(T.BASE_AST_RTG)             AS BASE_AST_RTG               --基础资产评级
    ,MAX(T.BASE_AST_RTG_ORG_NM)      AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,MAX(T.BASE_AST_CUST_NM)         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,MAX(T.BASE_AST_CUST_CTRY_CD)    AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,MAX(T.BASE_AST_CUST_RTG)        AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,MAX(T.BASE_AST_CUST_RTG_ORG_NM) AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,MAX(T.BASE_AST_CUST_IDY)        AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,MAX(T.FNL_DIR_TYP)              AS FNL_DIR_TYP                --最终投向类型
    ,MAX(T.FNL_DIR_IDY)              AS FNL_DIR_IDY                --最终投向行业
    ,MAX(T.DEPT_LINE)                AS DEPT_LINE                  --部门条线
    ,MAX(T.DATA_SRC)                 AS DATA_SRC                   --数据来源
  FROM (
    SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
      ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
      ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID                     --机构编号
      ,A.BOND_ID /*A.BAL_ID*/                       AS FIN_INST_ID                --金融工具编号
      ,B.BOND_NAME                                  AS FIN_INST_NM                --金融工具名称
      ,'06' /*标准化债券*/                          AS AST_TYP                    --资产类型
      ,B.CURR_CD                                    AS CUR                        --币种
      ,B.ISSUE_PRICE                                AS ISU_PRC                    --发行价格
      ,B.ISSUE_SIZE * 100000000                     AS ISU_TOT_SCALE              --发行总规模
      ,A.ISSUER_NAME                                AS ISU_ORG_NM                 --发行机构名称
      ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
      ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
      ,TO_CHAR(A.ISSUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
      ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
      ,'非LPR'                                      AS RATE_TYP                   --利率类型
      ,CASE WHEN NVL(TRIM(A.FAC_VAL_INT_RAT),0) <> 0 THEN A.FAC_VAL_INT_RAT
            ELSE NVL(TRIM(B.ISSUE_INT_RAT),0)*1
       END                                          AS ACT_RATE                   --实际利率
      ,CASE WHEN B.EX_CHOICE_TYPE_CD = '0' THEN 'N'
            ELSE 'Y'
       END                                          AS OPTION_FLG                 --含权标识
      ,NVL(TRIM(A.CBOND_NET_PRICE_EVLTION),B.ISSUE_PRICE) AS RCTLY_ASES_PRC             --最近评估价格
      ,TO_CHAR(A.STL_DT, 'YYYYMMDD')                AS ASES_PRC_DT                --评估价格日期
      ,A.BOND_ID                                    AS BASE_AST_ID                --基础资产编号
      ,B.BOND_NAME                                  AS BASE_AST_NM                --基础资产名称
      ,A.HOLD_POS                                   AS BASE_AST_SCALE             --基础资产规模
      ,CASE WHEN NVL(TRIM(B.ISSUE_SIZE),0) <> 0 THEN ROUND(A.HOLD_POS/B.ISSUE_SIZE/1000000,2)
            ELSE 0
       END                                          AS BASE_AST_PCT               --基础资产占比
      ,E.RATING_REST_CD                             AS BASE_AST_RTG               --基础资产评级
      ,E.RATING_CORP_CN_NAME                        AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
      ,A.ISSUER_NAME                                AS BASE_AST_CUST_NM           --基础资产客户名称
      ,NVL(TRIM(D.CTY_RG_CD),D.INVTOR_CTY_CD)       AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
      ,F.RATING_REST_CD                             AS BASE_AST_CUST_RTG          --基础资产客户评级
      ,F.RATING_CORP_CN_NAME                        AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
      ,D.INDUS_TYPE_CD                              AS BASE_AST_CUST_IDY          --基础资产客户行业
      ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
      ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
      ,NULL                                         AS DEPT_LINE                  --部门条线
      ,'资金债券投资表出同业存单投资和债券投资数据'    AS DATA_SRC                   --数据来源
    FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST A  --资金债券投资表
    /*INNER JOIN (
      SELECT BOND_ID,MAX(BAL_ID) BAL_ID
      FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST    --资金债券投资表
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND BUS_CATE_NAME IN ('现券','债券负债')
      AND (BOOK_BAL > 0 OR STL_DT >= V_BEG_THIS_MON)
      AND TRIM(SUBJ_ID) IS NOT NULL
      GROUP BY BOND_ID
    ) A1
       ON A.BAL_ID = A1.BAL_ID*/
    INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B  --债券基本信息
       ON A.BOND_ID = B.BOND_ID
      AND A.ETL_DT = B.ETL_DT
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON A.ISSUER_CUST_ID = D.CUST_ID
     AND A.ETL_DT = D.ETL_DT
    LEFT JOIN (
         SELECT BOND_ID
               ,RATING_CORP_CN_NAME
               ,RATING_REST_CD
               ,ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY RATING_DT DESC) AS NUM
         FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO --债券评级信息
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ) E
      ON A.BOND_ID = E.BOND_ID
     AND E.NUM = 1
    LEFT JOIN (
         SELECT ISSUER_ID
               ,ISSUER_CUST_ID
               ,RATING_CORP_CN_NAME
               ,RATING_REST_CD
               ,ROW_NUMBER() OVER(PARTITION BY ISSUER_ID ORDER BY RATING_DT DESC) AS NUM
         FROM RRP_MDL.O_ICL_CMM_ISSUER_RATING_INFO   --发行人评级信息
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       ) F
      ON B.ISSUER_CD = F.ISSUER_ID
     AND F.NUM = 1
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TRIM(B.BOND_TYPE_CD) IS NOT NULL
      AND A.BUS_CATE_NAME IN ('现券','债券负债')
      --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
      AND TRIM(A.SUBJ_ID) IS NOT NULL
      AND (A.BOOK_BAL > 0 OR A.STL_DT >= V_BEG_THIS_MON)
  ) T
  GROUP BY T.DATA_DT,T.LGL_REP_ID,T.FIN_INST_ID,T.FIN_INST_NM,T.AST_TYP
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-票据转贴现信息表出卖出回购和买入返售票据数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
    DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.ACCT_INSTIT_ID /*D.ORG_ID1*/               AS ORG_ID                     --机构编号
    ,A.BILL_NUM                                   AS FIN_INST_ID                --金融工具编号
    ,NVL(TRIM(E.CUST_NAME),A.CNTPTY_NAME)||'_'||B.CD_DESCB||C.CD_DESCB  AS FIN_INST_NM --金融工具名称
    ,CASE WHEN A.BUS_TYPE_CD = 'BT02' AND A.TRAN_DIR_CD = '01' THEN '9909'  --其他-质押式逆回购
          WHEN A.BUS_TYPE_CD = 'BT03' AND A.TRAN_DIR_CD = '01' THEN '9902'  --其他-买断式逆回购
          WHEN A.BUS_TYPE_CD = 'BT02' AND A.TRAN_DIR_CD = '02' THEN '9908'  --其他-质押式正回购
          WHEN A.BUS_TYPE_CD = 'BT03' AND A.TRAN_DIR_CD = '02' THEN '9901'  --其他-买断式正回购
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.FAC_VAL_AMT                                AS ISU_PRC                    --发行价格
    ,A.FAC_VAL_AMT                                AS ISU_TOT_SCALE              --发行总规模
    ,NVL(TRIM(E.CUST_NAME),A.CNTPTY_NAME)         AS ISU_ORG_NM                 --发行机构名称
    ,E.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.STL_DT, 'YYYYMMDD')                AS ISU_DT                     --发行日期
    ,TO_CHAR(A.REPO_DT, 'YYYYMMDD')               AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.DISCNT_INT_RAT                             AS ACT_RATE                   --实际利率
    ,'N'                                          AS OPTION_FLG                 --含权标识
    ,A.FAC_VAL_AMT                                AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.STL_DT, 'YYYYMMDD')                AS ASES_PRC_DT                --评估价格日期
    ,NULL                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'票据转贴现信息表出卖出回购和买入返售票据数据'  AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息表
  INNER JOIN (
    SELECT AA.BUS_ID,ROW_NUMBER() OVER(PARTITION BY AA.BILL_NUM ORDER BY NVL(TRIM(AA.ACTL_REPO_DT),'99991231') DESC) AS NUM
    FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO AA --票据转贴现信息表
    WHERE AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND AA.BUS_TYPE_CD IN ('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
    AND AA.ENTRY_STATUS_CD = '03'
    AND (TRIM(AA.ACTL_REPO_DT) IS NULL OR AA.ACTL_REPO_DT >= V_BEG_THIS_MON)
  ) A1
    ON A1.BUS_ID = A.BUS_ID
   AND A1.NUM = 1
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD B --公共代码表
    ON A.BILL_KIND_CD = B.CD_VAL
   AND B.CD_ID = 'CD1384'  --票据类型代码
  LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD C --公共代码表
    ON A.BUS_TYPE_CD = C.CD_VAL
   AND C.CD_ID = 'CD1076'  --票据类型代码
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
    ON A.CNTPTY_ID = E.CUST_ID
   AND A.ETL_DT = E.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.BUS_TYPE_CD IN('BT02', 'BT03') --'BT02'--质押式回购, 'BT03'--买断式回购
    AND A.ENTRY_STATUS_CD = '03'
    AND (TRIM(A.ACTL_REPO_DT) IS NULL OR A.ACTL_REPO_DT >= V_BEG_THIS_MON)
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-外汇同业拆借表出外币回购、同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT DISTINCT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.ENTRY_ORG_ID /*B.ORG_ID1*/                 AS ORG_ID                     --机构编号
    ,A.CNTPTY_ID||'_'||A.BUS_ID/*A.BAG_ID*/       AS FIN_INST_ID                --金融工具编号
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)||'_'||'质押式逆回购'
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)||'_'||'质押式正回购'
          ELSE NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)||'_'||A.PORTF_NAME
     END                                          AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '1111' THEN '9909'    --其他-质押式逆回购
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2111' THEN '9908'    --其他-质押式正回购
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '9903'    --其他-同业拆入
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '9904'    --其他-同业拆出
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.TRAN_AMT                                   AS ISU_PRC                    --发行价格
    ,A.TRAN_AMT                                   AS ISU_TOT_SCALE              --发行总规模
    ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')               AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.EXEC_INT_RAT                               AS ACT_RATE                   --实际利率
    ,'N'                                          AS OPTION_FLG                 --含权标识
    ,A.TRAN_AMT                                   AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
    ,NULL                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'外汇同业拆借表出外币回购、同业拆入和拆放同业数据'
                                                  AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_FX_IB_LEND A --外汇同业拆借表_视图
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
    ON A.CUST_ID = D.CUST_ID
   AND A.ETL_DT = D.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.PORTF_NAME IN ('外币质押式回购','外币拆借')
    AND TRIM(A.ENTRY_ORG_ID) IS NOT NULL
    --AND (A.CURRT_BAL  > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND (A.CURRT_BAL > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
     V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-资金债券借贷表出债券借贷数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.ENTRY_ORG_ID /*C.ORG_ID1*/                 AS ORG_ID                     --机构编号
    ,A.BUS_ID                                     AS FIN_INST_ID                --金融工具编号
    ,CASE WHEN A.TRAN_DIR_CD = '01' THEN A.CNTPTY_NAME||'_债券借入'
          WHEN A.TRAN_DIR_CD = '02' THEN A.CNTPTY_NAME||'_债券借出'
     END                                          AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN A.TRAN_DIR_CD = '01' THEN '9906'  --其他-债券借入
          WHEN A.TRAN_DIR_CD = '02' THEN '9907'  --其他-债券借出
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.TRAN_AMT                                   AS ISU_PRC                    --发行价格
    ,A.TRAN_AMT                                   AS ISU_TOT_SCALE              --发行总规模
    ,D.CUST_NAME                                  AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,B.FAC_VAL_INT_RAT                            AS ACT_RATE                   --实际利率
    ,'N'                                          AS OPTION_FLG                 --含权标识
    ,A.TRAN_AMT                                   AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
    ,NULL                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'资金债券借贷表出债券借贷数据'                 AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_BOND_DEBIT_CRDT A  --资金债券借贷表
  LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
    ON A.UNDERLY_BOND_ID = B.BOND_ID
   AND A.ETL_DT = B.ETL_DT
   AND UPPER(B.DATA_SRC_SYS_IDF) = 'CTMS'
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
    ON A.CUST_ID = D.CUST_ID
   AND A.ETL_DT = D.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND A.EXP_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.EXP_DT >= V_BEG_THIS_MON
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-资金同业拆借表出同业拆入和拆放同业数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.ENTRY_ORG_ID /*B.ORG_ID1*/                 AS ORG_ID                     --机构编号
    ,A.BUS_ID /*A.BAG_ID*/                        AS FIN_INST_ID                --金融工具编号
    ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)||'_'||'同业拆借'  AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN SUBSTR(A.SUBJ_ID,1,4) = '2003' THEN '9903'    --其他-同业拆入
          WHEN SUBSTR(A.SUBJ_ID,1,4) = '1302' THEN '9904'    --其他-同业拆出
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.TRAN_AMT                                   AS ISU_PRC                    --发行价格
    ,A.TRAN_AMT                                   AS ISU_TOT_SCALE              --发行总规模
    ,NVL(TRIM(D.CUST_NAME),A.CNTPTY_NAME)         AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.EXEC_INT_RAT                               AS ACT_RATE                   --实际利率
    ,'N'                                          AS OPTION_FLG                 --含权标识
    ,A.TRAN_AMT                                   AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
    ,NULL                                         AS BASE_AST_ID                --基础资产编号
    ,NULL                                         AS BASE_AST_NM                --基础资产名称
    ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,NULL                                         AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'资金同业拆借表出同业拆入和拆放同业数据'        AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_CAP_IB_LEND A  --资金同业拆借表
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
    ON A.CUST_ID = D.CUST_ID
   AND A.ETL_DT = D.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   --AND (A.CURRT_BAL  > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
   AND (A.CURRT_BAL  > 0 OR A.EXP_DT > V_BEG_THIS_MON)
   AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表-同业证券持仓表出同业存单发行、货币基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
  (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     T.DATA_DT                       AS DATA_DT                    --数据日期
    ,T.LGL_REP_ID                    AS LGL_REP_ID                 --法人编号
    ,MAX(T.ORG_ID)                   AS ORG_ID                     --机构编号
    ,T.FIN_INST_ID                   AS FIN_INST_ID                --金融工具编号
    ,T.FIN_INST_NM                   AS FIN_INST_NM                --金融工具名称
    ,T.AST_TYP                       AS AST_TYP                    --资产类型
    ,MAX(T.CUR)                      AS CUR                        --币种
    ,SUM(T.ISU_PRC)                  AS ISU_PRC                    --发行价格
    ,SUM(T.ISU_TOT_SCALE)            AS ISU_TOT_SCALE              --发行总规模
    ,MAX(T.ISU_ORG_NM)               AS ISU_ORG_NM                 --发行机构名称
    ,MAX(T.ISU_ORG_ID)               AS ISU_ORG_ID                 --发行机构编码
    ,MAX(T.ISU_CTRY_CD)              AS ISU_CTRY_CD                --发行国家代码
    ,MAX(T.ISU_DT)                   AS ISU_DT                     --发行日期
    ,MAX(T.EXP_DT)                   AS EXP_DT                     --到期日期
    ,MAX(T.RATE_TYP)                 AS RATE_TYP                   --利率类型
    ,MAX(T.ACT_RATE)                 AS ACT_RATE                   --实际利率
    ,MAX(T.OPTION_FLG)               AS OPTION_FLG                 --含权标识
    ,SUM(T.RCTLY_ASES_PRC)           AS RCTLY_ASES_PRC             --最近评估价格
    ,MAX(T.ASES_PRC_DT)              AS ASES_PRC_DT                --评估价格日期
    ,MAX(T.BASE_AST_ID)              AS BASE_AST_ID                --基础资产编号
    ,MAX(T.BASE_AST_NM)              AS BASE_AST_NM                --基础资产名称
    ,SUM(T.BASE_AST_SCALE)           AS BASE_AST_SCALE             --基础资产规模
    ,SUM(T.BASE_AST_PCT)             AS BASE_AST_PCT               --基础资产占比
    ,MAX(T.BASE_AST_RTG)             AS BASE_AST_RTG               --基础资产评级
    ,MAX(T.BASE_AST_RTG_ORG_NM)      AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,MAX(T.BASE_AST_CUST_NM)         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,MAX(T.BASE_AST_CUST_CTRY_CD)    AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,MAX(T.BASE_AST_CUST_RTG)        AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,MAX(T.BASE_AST_CUST_RTG_ORG_NM) AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,MAX(T.BASE_AST_CUST_IDY)        AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,MAX(T.FNL_DIR_TYP)              AS FNL_DIR_TYP                --最终投向类型
    ,MAX(T.FNL_DIR_IDY)              AS FNL_DIR_IDY                --最终投向行业
    ,MAX(T.DEPT_LINE)                AS DEPT_LINE                  --部门条线
    ,MAX(T.DATA_SRC)                 AS DATA_SRC                   --数据来源
  FROM (
    SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
      ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
      ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID                     --机构编号
      ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID                --金融工具编号
      ,D.FIN_INSTM_NAME                             AS FIN_INST_NM                --金融工具名称
      ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%同业存单%' THEN '9910'  --其他-同业存单发行
            WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '16'  --公募基金
       END                                          AS AST_TYP                    --资产类型
      ,D.CURR_CD                                    AS CUR                        --币种
      ,ABS(A.NET_PRICE_COST)                        AS ISU_PRC                    --发行价格
      ,ABS(A.NET_PRICE_COST)                        AS ISU_TOT_SCALE              --发行总规模
      ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%同业存单%' THEN '广东华兴银行股份有限公司'
            WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN A.ISSUER_NAME
       END                                          AS ISU_ORG_NM                 --发行机构名称
      ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%同业存单%' THEN '91440500279832882U'
            WHEN A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN NULL
       END                                          AS ISU_ORG_ID                 --发行机构编码
      ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
      ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
      ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
      ,'非LPR'                                      AS RATE_TYP                   --利率类型
      ,A.ACTL_INT_RAT                               AS ACT_RATE                   --实际利率
      ,'N'                                          AS OPTION_FLG                 --含权标识
      ,ABS(A.NET_PRICE_COST)                        AS RCTLY_ASES_PRC             --最近评估价格
      ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
      ,NULL                                         AS BASE_AST_ID                --基础资产编号
      ,NULL                                         AS BASE_AST_NM                --基础资产名称
      ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
      ,NULL                                         AS BASE_AST_PCT               --基础资产占比
      ,NULL                                         AS BASE_AST_RTG               --基础资产评级
      ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
      ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
      ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
      ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
      ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
      ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
      ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
      ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
      ,NULL                                         AS DEPT_LINE                  --部门条线
      ,'同业证券持仓表出同业存单发行、货币基金数据'    AS DATA_SRC                   --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A  --同业证券持仓表
    INNER JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM D --同业金融工具
       ON A.FIN_INSTM_ID = D.FIN_INSTM_ID
      AND A.ASSET_TYPE_ID = D.ASSET_TYPE_ID
      AND A.MARKET_TYPE_ID = D.MARKET_TYPE_ID
      AND A.ETL_DT = D.ETL_DT
   /* LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO C  --同业交易对手信息
      ON A.ISSUER_ID = C.SRC_PARTY_ID
     AND A.ETL_DT = C.ETL_DT */
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND (A.ASSET_TYPE_NAME LIKE '%同业存单%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%')
      --AND (ABS(A.ACTL_BAL) > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
      AND (ABS(A.ACTL_BAL) > 0 OR A.EXP_DT >= V_BEG_THIS_MON)
      AND TRIM(A.SUBJ_ID) IS NOT NULL
  ) T
  GROUP BY T.DATA_DT,T.LGL_REP_ID,T.FIN_INST_ID,T.FIN_INST_NM,T.AST_TYP
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '金融工具信息表--同业债券投资表出债券投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
 (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     T.DATA_DT                       AS DATA_DT                    --数据日期
    ,T.LGL_REP_ID                    AS LGL_REP_ID                 --法人编号
    ,MAX(T.ORG_ID)                   AS ORG_ID                     --机构编号
    ,T.FIN_INST_ID                   AS FIN_INST_ID                --金融工具编号
    ,T.FIN_INST_NM                   AS FIN_INST_NM                --金融工具名称
    ,T.AST_TYP                       AS AST_TYP                    --资产类型
    ,MAX(T.CUR)                      AS CUR                        --币种
    ,MAX(T.ISU_PRC)                  AS ISU_PRC                    --发行价格
    ,SUM(T.ISU_TOT_SCALE)            AS ISU_TOT_SCALE              --发行总规模
    ,MAX(T.ISU_ORG_NM)               AS ISU_ORG_NM                 --发行机构名称
    ,MAX(T.ISU_ORG_ID)               AS ISU_ORG_ID                 --发行机构编码
    ,MAX(T.ISU_CTRY_CD)              AS ISU_CTRY_CD                --发行国家代码
    ,MAX(T.ISU_DT)                   AS ISU_DT                     --发行日期
    ,MAX(T.EXP_DT)                   AS EXP_DT                     --到期日期
    ,MAX(T.RATE_TYP)                 AS RATE_TYP                   --利率类型
    ,MAX(T.ACT_RATE)                 AS ACT_RATE                   --实际利率
    ,MAX(T.OPTION_FLG)               AS OPTION_FLG                 --含权标识
    ,MAX(T.RCTLY_ASES_PRC)           AS RCTLY_ASES_PRC             --最近评估价格
    ,MAX(T.ASES_PRC_DT)              AS ASES_PRC_DT                --评估价格日期
    ,MAX(T.BASE_AST_ID)              AS BASE_AST_ID                --基础资产编号
    ,MAX(T.BASE_AST_NM)              AS BASE_AST_NM                --基础资产名称
    ,SUM(T.BASE_AST_SCALE)           AS BASE_AST_SCALE             --基础资产规模
    ,SUM(T.BASE_AST_PCT)             AS BASE_AST_PCT               --基础资产占比
    ,MAX(T.BASE_AST_RTG)             AS BASE_AST_RTG               --基础资产评级
    ,MAX(T.BASE_AST_RTG_ORG_NM)      AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,MAX(T.BASE_AST_CUST_NM)         AS BASE_AST_CUST_NM           --基础资产客户名称
    ,MAX(T.BASE_AST_CUST_CTRY_CD)    AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,MAX(T.BASE_AST_CUST_RTG)        AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,MAX(T.BASE_AST_CUST_RTG_ORG_NM) AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,MAX(T.BASE_AST_CUST_IDY)        AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,MAX(T.FNL_DIR_TYP)              AS FNL_DIR_TYP                --最终投向类型
    ,MAX(T.FNL_DIR_IDY)              AS FNL_DIR_IDY                --最终投向行业
    ,MAX(T.DEPT_LINE)                AS DEPT_LINE                  --部门条线
    ,MAX(T.DATA_SRC)                 AS DATA_SRC                   --数据来源
  FROM (
    SELECT
       TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
      ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
      ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID                     --机构编号
      ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID                --金融工具编号
      ,A.BOND_NAME                                  AS FIN_INST_NM                --金融工具名称
      ,'06'                                         AS AST_TYP                    --资产类型
      ,A.CURR_CD                                    AS CUR                        --币种
      ,A.FAC_VAL_AMT                                AS ISU_PRC                    --发行价格
      ,A.HOLD_FAC_VAL                               AS ISU_TOT_SCALE              --发行总规模
      ,NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME)         AS ISU_ORG_NM                 --发行机构名称
      ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
      ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
      ,TO_CHAR(A.ISSUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
      ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
      ,'非LPR'                                      AS RATE_TYP                   --利率类型
      ,A.FAC_VAL_INT_RAT /*A.ACTL_INT_RAT*/         AS ACT_RATE                   --实际利率
      ,CASE WHEN A.EX_TYPE_CD IN ('A','B','E') THEN 'Y'
            ELSE 'N'
       END                                          AS OPTION_FLG                 --含权标识
      ,NVL(TRIM(A.CSECU_NET_PRICE_EVLTION),A.FAC_VAL_AMT) AS RCTLY_ASES_PRC             --最近评估价格
      ,TO_CHAR(A.LAST_UPDATE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
      ,A.FIN_INSTM_ID                               AS BASE_AST_ID                --基础资产编号
      ,A.BOND_NAME                                  AS BASE_AST_NM                --基础资产名称
      ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
      ,NULL                                         AS BASE_AST_PCT               --基础资产占比
      ,NULL                                         AS BASE_AST_RTG               --基础资产评级
      ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
      ,NVL(TRIM(D.CUST_NAME),A.ISSUER_NAME)         AS BASE_AST_CUST_NM           --基础资产客户名称
      ,NVL(TRIM(D.CTY_RG_CD),'CHN')                 AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
      ,D.CRDT_CUST_RISK_RATING_CD                   AS BASE_AST_CUST_RTG          --基础资产客户评级
      ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
      ,D.INDUS_TYPE_CD                              AS BASE_AST_CUST_IDY          --基础资产客户行业
      ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
      ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
      ,NULL                                         AS DEPT_LINE                  --部门条线
      ,'同业债券投资表出债券投资数据'                 AS DATA_SRC                   --数据来源
    FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST A  --同业债券投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
      ON A.ISSUER_CUST_ID = D.CUST_ID
     AND A.ETL_DT = D.ETL_DT
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
      AND A.CAP_TYPE_CD = '0' --自营
      AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
      AND TRIM(A.SUBJ_ID) IS NOT NULL
  ) T
  GROUP BY T.DATA_DT,T.LGL_REP_ID,T.FIN_INST_ID,T.FIN_INST_NM,T.AST_TYP
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入金融工具信息表--同业非标投资表出资产支持证券（资产支持票据）和公募基金投资、资产管理产品投资数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
 (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT DISTINCT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID                     --机构编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID                --金融工具编号
    ,C.FIN_INSTM_NAME                             AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '08'  --理财直接融资工具
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '16'  --公募基金
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%'  THEN '07' --理财产品
          WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN '08' --理财直接融资工具
          WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN '05' --保险产品
          WHEN (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'  THEN '08' --理财直接融资工具
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,A.FAC_VAL_AMT                                AS ISU_PRC                    --发行价格
    ,A.CURR_BAL                                   AS ISU_TOT_SCALE              --发行总规模
    ,D.PARTY_FNAME                              AS ISU_ORG_NM                 --发行机构名称
    ,D.PARTY_CD_CERT_ID                          AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.FAC_VAL_INT_RAT                            AS ACT_RATE                   --实际利率
    ,NULL /*CASE WHEN C.CONTN_WEIGHT_FLG = '1' THEN 'Y'
          ELSE 'N'
     END     */                                     AS OPTION_FLG                 --含权标识
    ,A.FAC_VAL_AMT                                AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
    ,A.UDER_BOND_CD                               AS BASE_AST_ID                --基础资产编号
    ,A.UDER_BOND_NAME                             AS BASE_AST_NM                --基础资产名称
    ,A.UDER_POST_DENOM                            AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,A.UDER_BOND_RATING_REST_CD                   AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,A.UDER_ACTL_FINER_NAME                       AS BASE_AST_CUST_NM           --基础资产客户名称
    ,'CHN'                                        AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,A.FINAL_DIR_INDUS_SUBCLASS                   AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'同业非标投资表出资产支持证券（资产支持票据）和公募基金投资、资产管理产品投资数据'
                                                  AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST A  --同业非标投资表
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO D  --同业交易对手信息
    ON A.CNTPTY_ID = D.SRC_PARTY_ID
   AND A.ETL_DT = D.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
    AND A.ASSET_TYPE_NAME NOT LIKE '%货币基金%'
    AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
    AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入金融工具信息表--同业净值型产品投资表出资产管理计划、债券基金数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
 (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT
     TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                    --数据日期
    ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
    ,A.BELONG_ORG_ID /*B.ORG_ID1*/                AS ORG_ID                     --机构编号
    ,A.FIN_INSTM_ID /*||A.OBJ_ID*/                AS FIN_INST_ID                --金融工具编号
    ,C.FIN_INSTM_NAME                             AS FIN_INST_NM                --金融工具名称
    ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%票据资管计划%' THEN '08'  --理财直接融资工具
          WHEN A.ASSET_TYPE_NAME LIKE '%债券基金%' OR A.ASSET_TYPE_NAME LIKE '%货币基金%' THEN '16'  --公募基金
          WHEN A.ASSET_TYPE_NAME LIKE '%理财%'  THEN '07' --理财产品
          WHEN A.ASSET_TYPE_NAME LIKE '%信托计划%' OR A.ASSET_TYPE_NAME LIKE '银登中心信贷资产%' THEN '08' --理财直接融资工具
          WHEN A.ASSET_TYPE_NAME LIKE '保险资管计划' THEN '05' --保险产品
          WHEN (A.ASSET_TYPE_NAME LIKE '%资%管%计划%' AND A.ASSET_TYPE_NAME NOT LIKE '%票据资管计划%')
            OR A.ASSET_TYPE_NAME LIKE '%交易所公司债%'
            OR A.ASSET_TYPE_NAME LIKE '%资产支持证券%'  THEN '08' --理财直接融资工具
          ELSE '99'
     END                                          AS AST_TYP                    --资产类型
    ,A.CURR_CD                                    AS CUR                        --币种
    ,C.FAC_VAL_AMT                                AS ISU_PRC                    --发行价格
    ,A.CURR_BAL                                   AS ISU_TOT_SCALE              --发行总规模
    ,NVL(TRIM(D.CUST_NAME),SUBSTR(A.CNTPTY_CLS_DESCB,INSTR(A.CNTPTY_CLS_DESCB,'.',1,2)+1)) AS ISU_ORG_NM                 --发行机构名称
    ,D.SOCI_CRDT_CD                               AS ISU_ORG_ID                 --发行机构编码
    ,'CHN'                                        AS ISU_CTRY_CD                --发行国家代码
    ,TO_CHAR(A.VALUE_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
    ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
    ,'非LPR'                                      AS RATE_TYP                   --利率类型
    ,A.FAC_VAL_INT_RAT                            AS ACT_RATE                   --实际利率
    ,NULL/*CASE WHEN C.CONTN_WEIGHT_FLG = '1' THEN 'Y'
          ELSE 'N'
     END       */                                   AS OPTION_FLG                 --含权标识
    ,A.TD_NV                                      AS RCTLY_ASES_PRC             --最近评估价格
    ,TO_CHAR(A.LAST_UPDATE_DT, 'YYYYMMDD')        AS ASES_PRC_DT                --评估价格日期
    ,A.UDER_BOND_CD                               AS BASE_AST_ID                --基础资产编号
    ,A.UDER_BOND_NAME                             AS BASE_AST_NM                --基础资产名称
    ,A.UDER_POST_DENOM                            AS BASE_AST_SCALE             --基础资产规模
    ,NULL                                         AS BASE_AST_PCT               --基础资产占比
    ,A.UDER_BOND_RATING                           AS BASE_AST_RTG               --基础资产评级
    ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,A.UDER_ACTL_FINER_NAME                       AS BASE_AST_CUST_NM           --基础资产客户名称
    ,'CHN'                                        AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
    ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
    ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
    ,A.FINAL_DIR_INDUS_SUBCLASS                   AS FNL_DIR_IDY                --最终投向行业
    ,NULL                                         AS DEPT_LINE                  --部门条线
    ,'同业净值型产品投资表出资产管理计划、债券基金数据'
                                                  AS DATA_SRC                   --数据来源
  FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
  INNER JOIN (
    SELECT FIN_INSTM_ID,MAX(OBJ_ID) AS OBJ_ID
    FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST --同业净值型产品投资
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND (BOOK_BAL > 0 OR LAST_UPDATE_DT >= V_BEG_THIS_MON)
      AND TRIM(SUBJ_ID) IS NOT NULL
    GROUP BY FIN_INSTM_ID
  ) A1
    ON A.OBJ_ID = A1.OBJ_ID
  LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM C --同业金融工具
    ON A.FIN_INSTM_ID = C.FIN_INSTM_ID
   AND A.ASSET_TYPE_ID = C.ASSET_TYPE_ID
   AND A.MARKET_TYPE_ID = C.MARKET_TYPE_ID
   AND A.ETL_DT = C.ETL_DT
  LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO E --债券基本信息
    ON E.BOND_ID = A.FIN_INSTM_ID
   AND E.ASSET_TYPE_ID = A.ASSET_TYPE_ID
   AND CASE WHEN E.DATA_SRC_SYS_IDF='CTMS' THEN 'X_CNBD' ELSE E.BOND_MARKET_TYPE_CD END = A.MARKET_TYPE_ID
   AND E.ETL_DT = A.ETL_DT
  LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
    ON E.ISSUER_CUST_ID = D.CUST_ID
   AND E.ETL_DT = D.ETL_DT
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   -- AND (A.BOOK_BAL > 0 OR TO_CHAR(A.EXP_DT,'YYYYMM') = SUBSTR(V_P_DATE,1,6))
   AND (A.BOOK_BAL > 0 OR A.LAST_UPDATE_DT >= V_BEG_THIS_MON)
   AND TRIM(A.SUBJ_ID) IS NOT NULL
  ;
     V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入金融工具信息表--委托同业代付数据'; --modify by tangan at 20221223
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FIN_INST_INFO
 (
     DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,ORG_ID                     --机构编号
    ,FIN_INST_ID                --金融工具编号
    ,FIN_INST_NM                --金融工具名称
    ,AST_TYP                    --资产类型
    ,CUR                        --币种
    ,ISU_PRC                    --发行价格
    ,ISU_TOT_SCALE              --发行总规模
    ,ISU_ORG_NM                 --发行机构名称
    ,ISU_ORG_ID                 --发行机构编码
    ,ISU_CTRY_CD                --发行国家代码
    ,ISU_DT                     --发行日期
    ,EXP_DT                     --到期日期
    ,RATE_TYP                   --利率类型
    ,ACT_RATE                   --实际利率
    ,OPTION_FLG                 --含权标识
    ,RCTLY_ASES_PRC             --最近评估价格
    ,ASES_PRC_DT                --评估价格日期
    ,BASE_AST_ID                --基础资产编号
    ,BASE_AST_NM                --基础资产名称
    ,BASE_AST_SCALE             --基础资产规模
    ,BASE_AST_PCT               --基础资产占比
    ,BASE_AST_RTG               --基础资产评级
    ,BASE_AST_RTG_ORG_NM        --基础资产评级机构
    ,BASE_AST_CUST_NM           --基础资产客户名称
    ,BASE_AST_CUST_CTRY_CD      --基础资产客户国家
    ,BASE_AST_CUST_RTG          --基础资产客户评级
    ,BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
    ,BASE_AST_CUST_IDY          --基础资产客户行业
    ,FNL_DIR_TYP                --最终投向类型
    ,FNL_DIR_IDY                --最终投向行业
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
  )
  SELECT  V_P_DATE                                     AS DATA_DT                    --数据日期
         ,A.LP_ID                                      AS LGL_REP_ID                 --法人编号
         ,A.OUT_ACCT_ORG_ID                            AS ORG_ID                     --机构编号
         ,A.DUBIL_ID                                   AS FIN_INST_ID                --金融工具编号
         ,A.CUST_NAME                                  AS FIN_INST_NM                --金融工具名称
         ,'9911'                                       AS AST_TYP                    --资产类型 --其他-委托同业代付
         ,A.CURR_CD                                    AS CUR                        --币种
         ,A.CONT_AMT                                   AS ISU_PRC                    --发行价格
         ,A.CONT_AMT                                   AS ISU_TOT_SCALE              --发行总规模
         ,A.CUST_NAME                                  AS ISU_ORG_NM                 --发行机构名称
         ,CASE WHEN E.CTY_RG_CD = 'CHN' THEN NVL(TRIM(E.SOCI_CRDT_CD),TRIM(E.ORGNZ_CD))
               ELSE '0'
           END                                         AS ISU_ORG_ID                 --发行机构编码
         ,E.CTY_RG_CD                                  AS ISU_CTRY_CD                --发行国家代码
         ,TO_CHAR(A.DISTR_DT, 'YYYYMMDD')              AS ISU_DT                     --发行日期
         ,TO_CHAR(A.EXP_DT, 'YYYYMMDD')                AS EXP_DT                     --到期日期
         ,CASE WHEN A.BASE_RAT_TYPE_CD IN ('2230','2231','2232') THEN 'LPR'
               ELSE '非LPR'
           END                                         AS RATE_TYP                   --利率类型
         --,C.INSTRT                                     AS ACT_RATE                   --实际利率
         ,A.EXEC_INT_RAT                               AS ACT_RATE                   --实际利率
         ,'N'                                          AS OPTION_FLG                 --含权标识
         ,A.CONT_AMT                                   AS RCTLY_ASES_PRC             --最近评估价格
         ,TO_CHAR(A.DISTR_DT, 'YYYYMMDD')              AS ASES_PRC_DT                --评估价格日期
         ,NULL                                         AS BASE_AST_ID                --基础资产编号
         ,NULL                                         AS BASE_AST_NM                --基础资产名称
         ,NULL                                         AS BASE_AST_SCALE             --基础资产规模
         ,NULL                                         AS BASE_AST_PCT               --基础资产占比
         ,NULL                                         AS BASE_AST_RTG               --基础资产评级
         ,NULL                                         AS BASE_AST_RTG_ORG_NM        --基础资产评级机构
         ,NULL                                         AS BASE_AST_CUST_NM           --基础资产客户名称
         ,NULL                                         AS BASE_AST_CUST_CTRY_CD      --基础资产客户国家
         ,NULL                                         AS BASE_AST_CUST_RTG          --基础资产客户评级
         ,NULL                                         AS BASE_AST_CUST_RTG_ORG_NM   --基础资产客户评级机构
         ,NULL                                         AS BASE_AST_CUST_IDY          --基础资产客户行业
         ,NULL                                         AS FNL_DIR_TYP                --最终投向类型
         ,NULL                                         AS FNL_DIR_IDY                --最终投向行业
         ,NULL                                         AS DEPT_LINE                  --部门条线 /*投行与金融机构部*/
         ,'委托同业代付数据'                            AS DATA_SRC                   --数据来源
    FROM RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H A --业务出账申请
    /*LEFT JOIN RRP_MDL.ADD_WTTYDF_CUST_INFO B  -- 委托同业代付客户名单
           ON TRIM(B.CUST_NAME) = TRIM(A.ERA_PAY_BANK_NAME)
    LEFT JOIN RRP_MDL.O_IOL_CRSS_BUSINESS_PUTOUT C
           ON C.SERIALNO = A.OUT_ACCT_FLOW_NUM
          AND C.SUBJECTNO LIKE '130603%'
          AND C.MATURITY > TO_CHAR(TRUNC(V_DATE,'MM'),'YYYY/MM/DD')
          AND C.ID_MARK <> 'D'
          AND C.START_DT <= V_DATE
          AND C.END_DT > V_DATE*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E
           ON E.CUST_ID = A.CUST_ID
          AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE A.PROD_ID IN ('203020700001','203020700002')
    AND A.EXP_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --未结清
    AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(A.DUBIL_ID) IS NOT NULL
    ;

     V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 增加数据重复校验 --
        WITH TMP1 AS (
  SELECT DATA_DT,FIN_INST_ID,FIN_INST_NM,COUNT(1)
    FROM RRP_MDL.M_FIN_INST_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,FIN_INST_ID,FIN_INST_NM
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');

    -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_FIN_INST_INFO
;
/

