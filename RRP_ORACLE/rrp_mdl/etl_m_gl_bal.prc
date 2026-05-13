CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GL_BAL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_GL_BAL
  *  功能描述：监管集市银行机构仅报送有余额、有变动的信息
  *  创建日期：20220520
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息表
  *            IML.REF_POSTN_PARA  --职位参数
  *            ICL.CMM_CLERK_INFO  --行员信息表
  *  目标表：  M_GL_BAL  --总账会计科目余额表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220915  HULJ     新增字段,调整逻辑。
  *             2    20221105  MW       增加月、季、旬、年借方、贷方发生额字段
  *             3    20221108  HULJ     增加数据重复校验
  *             4    20231110  HYF      年底取结转前调账后数据，套账期次为：12
                5    20231201  LWB      计算年累计或月累计的字段需剔除'2023-13'结转后的数据
                6    20250220  YJY      新增月、季、半年、年借方、贷方累计发生额
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC      VARCHAR2(100);                   --处理步骤描述
  V_P_DATE         VARCHAR2(8);                     --跑批数据日期
  V_STARTTIME      DATE;                            --处理开始时间
  V_ENDTIME        DATE;                            --处理结束时间
  V_Y_END_DT       DATE;
  V_STEP           INTEGER := 0;                    --处理步骤
  V_SQLCOUNT2      INTEGER;
  V_SQLCOUNT       INTEGER := 0;                    --更新或删除影响的记录数
  V_SQLMSG         VARCHAR2(300);                   --SQL执行描述信息
  V_DATA_DT        VARCHAR2(10);                    --报送日期
  V_PART_NAME      VARCHAR2(100);                   --分区名
  V_TAB_NAME       VARCHAR2(100) := 'M_GL_BAL';     --表名
  V_PROC_NAME      VARCHAR2(100) := 'ETL_M_GL_BAL'; --程序名称
  V_SYSTEM         VARCHAR2(30) := '监管报送';      --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_DATA_DT   := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD');
  V_Y_END_DT  := TO_DATE(SUBSTR(V_P_DATE,1,4)||'-12-31','YYYY-MM-DD'); --年末

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_GL_BAL T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1 ;
  V_STEP_DESC := '处理累计余额';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_GL_BAL_TMP3');
  INSERT INTO RRP_MDL.M_GL_BAL_TMP3
    (DATA_DT
    ,ORG_ID
    ,SUBJ_ID
    ,CUR
    ,STD_PROD_ID
    ,YEAR_CUM_BAL
    ,HALF_CUM_BAL
    ,QRT_CUM_BAL
    ,MON_CUM_BAL
    ,YEAR_CUM_CR_BAL
    ,YEAR_CUM_DR_BAL
    ,HALF_CUM_CR_BAL
    ,HALF_CUM_DR_BAL
    ,QRT_CUM_CR_BAL
    ,QRT_CUM_DR_BAL
    ,MON_CUM_CR_BAL
    ,MON_CUM_DR_BAL
    ,YEAR_CUM_CR_AMT  --年累计贷方发生额 --ADD BY YJY 20250220
    ,YEAR_CUM_DR_AMT  --年累计借方发生额 --ADD BY YJY 20250220
    ,HALF_CUM_CR_AMT  --半年累计贷方发生额 --ADD BY YJY 20250220
    ,HALF_CUM_DR_AMT  --半年累计借方发生额 --ADD BY YJY 20250220
    ,QRT_CUM_CR_AMT   --季累计贷方发生额 --ADD BY YJY 20250220
    ,QRT_CUM_DR_AMT   --季累计借方发生额 --ADD BY YJY 20250220
    ,MON_CUM_CR_AMT   --月累计贷方发生额 --ADD BY YJY 20250220
    ,MON_CUM_DR_AMT   --月累计借方发生额 --ADD BY YJY 20250220
    )
  SELECT T2.DATA_DT
        ,T2.ORG_ID
        ,T2.SUBJ_ID
        ,T2.CUR
        ,T2.STD_PROD_ID
        ,SUM(CASE WHEN T2.YEAR_FLG = 'Y'  THEN NVL(T2.TD_OC_BAL,0) END)      AS YEAR_CUM_BAL
        ,SUM(CASE WHEN T2.HALF_FLG = 'HY' THEN NVL(T2.TD_OC_BAL,0) END)      AS HALF_CUM_BAL
        ,SUM(CASE WHEN T2.QRT_FLG = 'Q'   THEN NVL(T2.TD_OC_BAL,0) END)      AS QRT_CUM_BAL
        ,SUM(CASE WHEN T2.MON_FLG = 'M'   THEN NVL(T2.TD_OC_BAL,0) END)      AS MON_CUM_BAL
        ,SUM(CASE WHEN T2.YEAR_FLG = 'Y'  THEN NVL(T2.TD_OC_CR_BAL,0) END)   AS YEAR_CUM_CR_BAL
        ,SUM(CASE WHEN T2.YEAR_FLG = 'Y'  THEN NVL(T2.TD_OC_DR_BAL,0) END)   AS YEAR_CUM_DR_BAL
        ,SUM(CASE WHEN T2.HALF_FLG = 'HY' THEN NVL(T2.TD_OC_CR_BAL,0) END)   AS HALF_CUM_CR_BAL
        ,SUM(CASE WHEN T2.HALF_FLG = 'HY' THEN NVL(T2.TD_OC_DR_BAL,0) END)   AS HALF_CUM_DR_BAL
        ,SUM(CASE WHEN T2.QRT_FLG = 'Q'   THEN NVL(T2.TD_OC_CR_BAL,0) END)   AS QRT_CUM_CR_BAL
        ,SUM(CASE WHEN T2.QRT_FLG = 'Q'   THEN NVL(T2.TD_OC_DR_BAL,0) END)   AS QRT_CUM_DR_BAL
        ,SUM(CASE WHEN T2.MON_FLG = 'M'   THEN NVL(T2.TD_OC_CR_BAL,0) END)   AS MON_CUM_CR_BAL
        ,SUM(CASE WHEN T2.MON_FLG = 'M'   THEN NVL(T2.TD_OC_DR_BAL,0) END)   AS MON_CUM_DR_BAL
        ,SUM(CASE WHEN T2.YEAR_FLG = 'Y'  THEN NVL(T2.TD_OC_CR_AMT,0) END)   AS YEAR_CUM_CR_AMT  --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.YEAR_FLG = 'Y'  THEN NVL(T2.TD_OC_DR_AMT,0) END)   AS YEAR_CUM_DR_AMT  --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.HALF_FLG = 'HY' THEN NVL(T2.TD_OC_CR_AMT,0) END)   AS HALF_CUM_CR_AMT  --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.HALF_FLG = 'HY' THEN NVL(T2.TD_OC_DR_AMT,0) END)   AS HALF_CUM_DR_AMT  --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.QRT_FLG = 'Q'   THEN NVL(T2.TD_OC_CR_AMT,0) END)   AS QRT_CUM_CR_AMT   --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.QRT_FLG = 'Q'   THEN NVL(T2.TD_OC_DR_AMT,0) END)   AS QRT_CUM_DR_AMT   --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.MON_FLG = 'M'   THEN NVL(T2.TD_OC_CR_AMT,0) END)   AS MON_CUM_CR_AMT   --ADD BY YJY 20250220
        ,SUM(CASE WHEN T2.MON_FLG = 'M'   THEN NVL(T2.TD_OC_DR_AMT,0) END)   AS MON_CUM_DR_AMT   --ADD BY YJY 20250220
    FROM (SELECT V_P_DATE            AS DATA_DT
                ,T1.ORG_ID           AS ORG_ID
                ,T1.SUBJ_ID          AS SUBJ_ID
                ,T1.CURR_CD          AS CUR
                ,T1.STD_PROD_ID      AS STD_PROD_ID
                ,T1.TD_OC_BAL        AS TD_OC_BAL
                ,T1.TD_OC_DR_BAL     AS TD_OC_DR_BAL
                ,T1.TD_OC_CR_BAL     AS TD_OC_CR_BAL
                ,T1.TD_OC_DR_AMT     AS TD_OC_DR_AMT  --本日原币借方发生额 --ADD BY YJY 20250220
				        ,T1.TD_OC_CR_AMT     AS TD_OC_CR_AMT  --本日原币贷方发生额 --ADD BY YJY 20250220
                ,CASE WHEN T1.ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') AND TO_DATE(V_P_DATE,'YYYYMMDD')
                      THEN 'Y'
                  END                AS YEAR_FLG
                ,CASE WHEN T1.ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q') AND TO_DATE(V_P_DATE,'YYYYMMDD')
                      THEN 'Q'
                  END                AS QRT_FLG
                ,CASE WHEN T1.ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') AND TO_DATE(V_P_DATE,'YYYYMMDD')
                      THEN 'M'
                  END                AS MON_FLG
                ,CASE WHEN (T1.ETL_DT BETWEEN TO_DATE((SUBSTR(V_P_DATE,1,4) || '0701'),'YYYYMMDD') AND TO_DATE(V_P_DATE,'YYYYMMDD')
                            AND T1.ETL_DT >= TO_DATE((SUBSTR(V_P_DATE,1,4) || '0701'),'YYYYMMDD'))
                           OR (T1.ETL_DT BETWEEN TO_DATE(V_P_DATE,'YYYYMMDD') AND TO_DATE((SUBSTR(V_P_DATE,1,4) || '0701'),'YYYYMMDD')
                            AND T1.ETL_DT < TO_DATE((SUBSTR(V_P_DATE,1,4) || '0701'),'YYYYMMDD'))
                      THEN 'HY'
                  END                AS HALF_FLG
            FROM RRP_MDL.O_ICL_CMM_GL_BAL T1
           WHERE T1.DATA_SRC_CD <> '99'
             AND T1.ACCT_DURAN <> SUBSTR(V_P_DATE,1,4) || '-13'
             AND T1.ETL_DT BETWEEN TO_DATE((SUBSTR(V_P_DATE,1,4) || '0101'),'YYYYMMDD') AND TO_DATE(V_P_DATE,'YYYYMMDD')) T2
   GROUP BY T2.DATA_DT,T2.SUBJ_ID,T2.ORG_ID,T2.CUR,T2.STD_PROD_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '总账会计科目余额表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GL_BAL
    (DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,FREQ              --频度
    ,ORG_ID            --机构编号
    ,CUR               --币种
    ,SUBJ_ID           --科目编号
    ,SUBJ_NM           --科目名称
    ,SUBJ_LVL          --科目级次
    ,SUBJ_TYP          --科目类型
    ,BGN_DR_BAL        --期初借方余额
    ,BGN_CR_BAL        --期初贷方余额
    ,CURR_DR_AMT       --本期借方发生额
    ,CURR_CR_AMT       --本期贷方发生额
    ,END_DR_BAL        --期末借方余额
    ,END_CR_BAL        --期末贷方余额
    ,MON_DR_AMT        --月借方发生额
    ,MON_CR_AMT        --月贷方发生额
    ,QRT_DR_AMT        --季借方发生额
    ,QRT_CR_AMT        --季贷方发生额
    ,YEAR_DR_AMT       --年借方发生额
    ,YEAR_CR_AMT       --年贷方发生额
    ,MON_BGN_DR_BAL    --月初借方余额
    ,MON_BGN_CR_BAL    --月初贷方余额
    ,QRT_BGN_DR_BAL    --季初借方余额
    ,QRT_BGN_CR_BAL    --季初贷方余额
    ,YEAR_BGN_DR_BAL   --年初借方余额
    ,YEAR_BGN_CR_BAL   --年初贷方余额
    ,TEN_BGN_DR_BAL    --旬初借方余额
    ,TEN_BGN_CR_BAL    --旬初贷方余额  --20221104 新增月、季、年、旬余额
    ,HALF_YEAR_DR_AMT  --半年借方发生额
    ,HALF_YEAR_CR_AMT  --半年贷方发生额
    ,HALF_YEAR_DR_BAL  --半年借方余额
    ,HALF_YEAR_CR_BAL  --半年贷方余额
    ,MON_DATES         --月累计天数
    ,QRT_DATES         --季累计天数
    ,YEAR_DATES        --年累计天数
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
    ,DTL_SUBJ_FLG      --明细科目标志1明细0汇总
    ,STD_PROD_ID       --标准产品
    ,TD_BAL_DIR_CD     --本日余额方向代码
    ,TD_OC_BAL         --本日原币余额
    ,IN_OUT_TAB_FLG    --表内外标志
    ,YEAR_CUM_BAL      --年累计余额
    ,HALF_CUM_BAL      --半年累计余额
    ,QRT_CUM_BAL       --季累计余额
    ,MON_CUM_BAL       --月累计余额
    ,MON_CUM_CR_BAL    --月累计贷方余额
    ,MON_CUM_DR_BAL    --月累计借方余额
    ,QRT_CUM_CR_BAL    --季累计贷方余额
    ,QRT_CUM_DR_BAL    --季累计借方余额
    ,HALF_CUM_CR_BAL   --半年累计贷方余额
    ,HALF_CUM_DR_BAL   --半年累计借方余额
    ,YEAR_CUM_CR_BAL   --年累计贷方余额
    ,YEAR_CUM_DR_BAL   --年累计借方余额
    ,MON_CUM_CR_AMT    --月累计贷方发生额  ADD BY YJY 20250220 
    ,MON_CUM_DR_AMT    --月累计借方发生额  ADD BY YJY 20250220
    ,QRT_CUM_CR_AMT    --季累计贷方发生额  ADD BY YJY 20250220
    ,QRT_CUM_DR_AMT    --季累计借方发生额  ADD BY YJY 20250220
    ,HALF_CUM_CR_AMT   --半年累计贷方发生额  ADD BY YJY 20250220
    ,HALF_CUM_DR_AMT   --半年累计借方发生额  ADD BY YJY 20250220
    ,YEAR_CUM_CR_AMT   --年累计贷方发生额  ADD BY YJY 20250220
    ,YEAR_CUM_DR_AMT   --年累计借方发生额  ADD BY YJY 20250220
    )
  SELECT TO_CHAR(T1.ETL_DT,'YYYYMMDD')   AS DATA_DT           --数据日期
        ,'9999'                          AS LGL_REP_ID        --法人编号
        ,'D'                             AS FREQ              --频度 日报
        ,T1.ORG_ID                       AS ORG_ID            --机构编号
        ,T1.CURR_CD                      AS CUR               --币种
        ,T1.SUBJ_ID                      AS SUBJ_ID           --科目编号
        ,C.SUBJ_NAME                     AS SUBJ_NM           --科目名称
        ,C.SUBJ_LEV_CD                   AS SUBJ_LVL          --科目级次
        ,NULL                            AS SUBJ_TYP          --科目类型
        ,T1.QCJFYE                       AS BGN_DR_BAL        --期初借方余额
        ,T1.QCDFYE                       AS BGN_CR_BAL        --期初贷方余额
        ,T1.JFFSE                        AS CURR_DR_AMT       --本期借方发生额
        ,T1.DFFSE                        AS CURR_CR_AMT       --本期贷方发生额
        ,T1.QMJFYE                       AS END_DR_BAL        --期末借方余额
        ,T1.QMDFYE                       AS END_CR_BAL        --期末贷方余额
        ,T1.BYJFFSE                      AS MON_DR_AMT        --月借方发生额
        ,T1.BYDFFSE                      AS MON_CR_AMT        --月贷方发生额
        ,T1.BJJFFSE                      AS QRT_DR_AMT        --季借方发生额
        ,T1.BJDFFSE                      AS QRT_CR_AMT        --季贷方发生额
        ,T1.BNJFFSE                      AS YEAR_DR_AMT       --年借方发生额
        ,T1.BNDFFSE                      AS YEAR_CR_AMT       --年贷方发生额
        ,T1.YCJFYE                       AS MON_BGN_DR_BAL    --月初借方余额
        ,T1.YCDFYE                       AS MON_BGN_CR_BAL    --月初贷方余额
        ,T1.JCJFYE                       AS QRT_BGN_DR_BAL    --季初借方余额
        ,T1.JCDFYE                       AS QRT_BGN_CR_BAL    --季初贷方余额
        ,T1.NCJFYE                       AS YEAR_BGN_DR_BAL   --年初借方余额
        ,T1.NCDFYE                       AS YEAR_BGN_CR_BAL   --年初贷方余额
        ,T1.XCJFYE                       AS TEN_BGN_DR_BAL    --旬初借方余额
        ,T1.XCDFYE                       AS TEN_BGN_CR_BAL    --旬初贷方余额
        ,T1.BBNJFFSE                     AS HALF_YEAR_DR_AMT  --半年借方发生额
        ,T1.BBNDFFSE                     AS HALF_YEAR_CR_AMT  --半年贷方发生额
        ,T1.BBNJFYE                      AS HALF_YEAR_DR_BAL  --半年借方余额
        ,T1.BBNDFYE                      AS HALF_YEAR_CR_BAL  --半年贷方余额
        ,T1.MON_DATES                    AS MON_DATES         --月累计天数
        ,T1.QRT_DATES                    AS QRT_DATES         --季累计天数
        ,T1.YEAR_DATES                   AS YEAR_DATES        --年累计天数
        ,'800918'                        AS DEPT_LINE         --部门条线
        ,T1.JOB_CD                       AS DATA_SRC          --数据来源
        ,T1.DTL_SUBJ_FLG                 AS DTL_SUBJ_FLG      --明细科目标志1明细0汇总
        ,T1.STD_PROD_ID                  AS STD_PROD_ID       --标准产品
        ,T1.TD_BAL_DIR_CD                AS TD_BAL_DIR_CD     --本日余额方向代码
        ,T1.TD_OC_BAL                    AS TD_OC_BAL         --本日原币余额
        ,T1.IN_OUT_TAB_FLG               AS IN_OUT_TAB_FLG    --表内外标志
        ,D.YEAR_CUM_BAL                  AS YEAR_CUM_BAL      --年累计余额
        ,D.HALF_CUM_BAL                  AS HALF_CUM_BAL      --半年累计余额
        ,D.QRT_CUM_BAL                   AS QRT_CUM_BAL       --季累计余额
        ,D.MON_CUM_BAL                   AS MON_CUM_BAL       --月累计余额
        ,D.MON_CUM_CR_BAL                AS MON_CUM_CR_BAL    --年累计贷方余额
        ,D.MON_CUM_DR_BAL                AS MON_CUM_DR_BAL    --年累计借方余额
        ,D.QRT_CUM_CR_BAL                AS QRT_CUM_CR_BAL    --季累计贷方余额
        ,D.QRT_CUM_DR_BAL                AS QRT_CUM_DR_BAL    --季累计借方余额
        ,D.HALF_CUM_CR_BAL               AS HALF_CUM_CR_BAL   --半年累计贷方余额
        ,D.HALF_CUM_DR_BAL               AS HALF_CUM_DR_BAL   --半年累计借方余额
        ,D.YEAR_CUM_CR_BAL               AS YEAR_CUM_CR_BAL   --年累计贷方余额
        ,D.YEAR_CUM_DR_BAL               AS YEAR_CUM_DR_BAL   --年累计贷方余额
        ,D.MON_CUM_CR_AMT                AS MON_CUM_CR_AMT    --月累计贷方发生额  ADD BY YJY 20250220 
        ,D.MON_CUM_DR_AMT                AS MON_CUM_DR_AMT    --月累计借方发生额  ADD BY YJY 20250220
        ,D.QRT_CUM_CR_AMT                AS QRT_CUM_CR_AMT    --季累计贷方发生额  ADD BY YJY 20250220
        ,D.QRT_CUM_DR_AMT                AS QRT_CUM_DR_AMT    --季累计借方发生额  ADD BY YJY 20250220
        ,D.HALF_CUM_CR_AMT               AS HALF_CUM_CR_AMT   --半年累计贷方发生额  ADD BY YJY 20250220
        ,D.HALF_CUM_DR_AMT               AS HALF_CUM_DR_AMT   --半年累计借方发生额  ADD BY YJY 20250220
        ,D.YEAR_CUM_CR_AMT               AS YEAR_CUM_CR_AMT   --年累计贷方发生额  ADD BY YJY 20250220
        ,D.YEAR_CUM_DR_AMT               AS YEAR_CUM_DR_AMT   --年累计借方发生额  ADD BY YJY 20250220
    FROM (
  SELECT A.ETL_DT                                  AS ETL_DT                        --数据日期
        ,A.ACCT_DURAN                              AS ACCT_DURAN                    --数据区间
        ,A.ORG_ID                                  AS ORG_ID                        --机构编号
        ,A.SUBJ_ID                                 AS SUBJ_ID                       --会计科目编号
        ,A.CURR_CD                                 AS CURR_CD                       --币种代码
        ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.YD_OC_DR_BAL -A.YD_OC_CR_BAL  --轧差
                  WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.YD_OC_DR_BAL-A.YD_OC_CR_BAL> 0 THEN A.YD_OC_DR_BAL-A.YD_OC_CR_BAL ELSE 0 END)
                  WHEN A.SUBJ_DIR_CD = 'C' THEN 0
                  ELSE A.YD_OC_DR_BAL
              END)                                 AS QCJFYE                         --期初借方余额
        ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.YD_OC_CR_BAL-A.YD_OC_DR_BAL   --轧差
                  WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.YD_OC_CR_BAL-A.YD_OC_DR_BAL> 0 THEN A.YD_OC_CR_BAL-A.YD_OC_DR_BAL ELSE 0 END)
                  WHEN A.SUBJ_DIR_CD = 'D' THEN 0
                  ELSE A.YD_OC_CR_BAL
              END)                                 AS QCDFYE                         --期初贷方余额
        ,SUM(A.TD_OC_DR_AMT)                       AS JFFSE                          --本期借方发生额
        ,SUM(A.TD_OC_CR_AMT)                       AS DFFSE                          --本期贷方发生额
        ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_OC_DR_BAL -A.TD_OC_CR_BAL  --轧差
                  WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL> 0 THEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL ELSE 0 END)
                  WHEN A.SUBJ_DIR_CD = 'C' THEN 0
                  ELSE A.TD_OC_DR_BAL
              END)                                 AS QMJFYE                         --期末借方余额
        ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL --轧差
                  WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL> 0 THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL ELSE 0 END)
                  WHEN A.SUBJ_DIR_CD = 'D' THEN 0
                  ELSE A.TD_OC_CR_BAL
              END)                                 AS QMDFYE                         --期末贷方余额
        ,SUM(A.MON_OC_DR_AMT)                      AS BYJFFSE
        ,SUM(A.MON_OC_CR_AMT)                      AS BYDFFSE
        ,SUM(A.SSN_OC_DR_AMT)                      AS BJJFFSE
        ,SUM(A.SSN_OC_CR_AMT)                      AS BJDFFSE
        ,SUM(A.YEAR_OC_DR_AMT)                     AS BNJFFSE
        ,SUM(A.YEAR_OC_CR_AMT)                     AS BNDFFSE
        ,SUM(A.EAR_M_DR_OC_BAL)                    AS YCJFYE
        ,SUM(A.EAR_M_CR_OC_BAL)                    AS YCDFYE
        ,SUM(A.EAR_S_DR_OC_BAL)                    AS JCJFYE
        ,SUM(A.EAR_S_CR_OC_BAL)                    AS JCDFYE
        ,SUM(A.EAR_Y_DR_OC_BAL)                    AS NCJFYE
        ,SUM(A.EAR_Y_CR_OC_BAL)                    AS NCDFYE
        ,SUM(A.TEN_DYS_BG_DR_OC_BAL)               AS XCJFYE
        ,SUM(A.TEN_DYS_BG_CR_OC_BAL)               AS XCDFYE
        ,SUM(A.HALF_Y_OC_DR_AMT)                   AS BBNJFFSE
        ,SUM(A.HALF_Y_OC_CR_AMT)                   AS BBNDFFSE
        ,SUM(A.HALF_Y_TM_BG_DR_OC_BAL)             AS BBNJFYE
        ,SUM(A.HALF_Y_TM_BG_CR_OC_BAL)             AS BBNDFYE
        ,ABS(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') + 1) AS MON_DATES
        ,ABS(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q') + 1) AS QRT_DATES
        ,ABS(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y') + 1) AS YEAR_DATES
        ,SUBSTR(A.JOB_CD,0,4)                      AS JOB_CD
        ,A.DTL_SUBJ_FLG                            AS DTL_SUBJ_FLG
        ,A.STD_PROD_ID                             AS STD_PROD_ID
        ,MAX(A.TD_BAL_DIR_CD)                      AS TD_BAL_DIR_CD
        ,SUM(A.TD_OC_BAL)                          AS TD_OC_BAL
        ,MAX(A.IN_OUT_TAB_FLG)                     AS IN_OUT_TAB_FLG
   FROM RRP_MDL.O_ICL_CMM_GL_BAL A --总账余额
  WHERE A.ORG_ID <> '892001' 
    AND A.DATA_SRC_CD <> '99'
    AND A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_P_DATE,1,4) || '-12' ELSE SUBSTR(V_DATA_DT,0,7) END --年末取结转前调账后的数据--20231110
    AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  GROUP BY A.ETL_DT --1.数据日期
          ,A.ACCT_DURAN--数据区间
          ,A.ORG_ID --3.机构编号
          ,A.SUBJ_ID --4.会计科目编号
          ,A.CURR_CD
          ,SUBSTR(A.JOB_CD,0,4)
          ,A.DTL_SUBJ_FLG
          ,A.STD_PROD_ID) T1
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = T1.ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C  --科目信息
      ON C.SUBJ_ID = T1.SUBJ_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_GL_BAL_TMP3 D
      ON D.ORG_ID = T1.ORG_ID
     AND D.SUBJ_ID = T1.SUBJ_ID
     AND D.CUR = T1.CURR_CD
     AND NVL(D.STD_PROD_ID,0) = NVL(T1.STD_PROD_ID,0);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1 ;
  V_STEP_DESC := '处理年日均余额';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_GL_BAL_TMP1');
  INSERT INTO RRP_MDL.M_GL_BAL_TMP1
    (DATA_DT                          --01数据日期
    ,ORG_ID                           --02机构号
    ,SUBJ_ID                          --03科目号
    ,CUR                              --04币种
    ,STD_PROD_ID                      --05标准产品编号
    ,YEAR_DLY_AVG_CR_BAL              --06年日均贷方余额
    ,YEAR_DLY_AVG_DR_BAL              --07年日均借方余额
    )
  SELECT DISTINCT
         V_P_DATE               AS DATA_DT          --01 数据日期
         ,T.ORG_ID              AS ORG_ID           --02 机构号
         ,T.SUBJ_ID             AS SUBJ_ID          --03 科目号
         ,T.CUR                 AS CUR              --04 币种
         ,T.STD_PROD_ID         AS STD_PROD_ID      --05 标准产品编号
         ,ABS(SUM(T.YEAR_DLY_AVG_CR_BAL)/(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY') + 1))
                                AS YEAR_DLY_AVG_CR_BAL
         ,ABS(SUM(T.YEAR_DLY_AVG_DR_BAL)/(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY') + 1))
                                AS YEAR_DLY_AVG_DR_BAL
    FROM (
    SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT          --01 数据日期
          ,A.ORG_ID                     AS ORG_ID           --02 机构号
          ,A.SUBJ_ID                    AS SUBJ_ID          --03 科目号
          ,A.CURR_CD                    AS CUR              --04 币种
          ,A.STD_PROD_ID                AS STD_PROD_ID      --05 标准产品编号
          ,SUM(NVL(A.TD_OC_CR_BAL,0))   AS YEAR_DLY_AVG_CR_BAL --06 年日均贷方余额
          ,SUM(NVL(A.TD_OC_DR_BAL,0))   AS YEAR_DLY_AVG_DR_BAL --07 年日均借方余额
    FROM RRP_MDL.O_ICL_CMM_GL_BAL A
   WHERE A.ACCT_DURAN <> '2023-13'
     AND A.ETL_DT BETWEEN TO_DATE((SUBSTR(V_P_DATE,1,4) || '0101'),'YYYYMMDD') AND TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.ETL_DT,A.SUBJ_ID,A.ORG_ID,A.CURR_CD,A.STD_PROD_ID) T
   GROUP BY T.SUBJ_ID, T.ORG_ID,T.CUR,T.STD_PROD_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1 ;
  V_STEP_DESC := '插入年日均余额';
  V_STARTTIME := SYSDATE ;
  MERGE /*+ORDER USE_HASH(A,B)*/ INTO RRP_MDL.M_GL_BAL A
  USING RRP_MDL.M_GL_BAL_TMP1 B
     ON (A.SUBJ_ID = B.SUBJ_ID AND A.ORG_ID = B.ORG_ID AND A.CUR = B.CUR
         AND A.STD_PROD_ID = B.STD_PROD_ID AND A.DATA_DT = B.DATA_DT)
   WHEN MATCHED THEN UPDATE SET
     A.YEAR_DLY_AVG_CR_BAL = B.YEAR_DLY_AVG_CR_BAL,
     A.YEAR_DLY_AVG_DR_BAL = B.YEAR_DLY_AVG_DR_BAL;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1 ;
  V_STEP_DESC := '处理月日均余额';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_MDL.M_GL_BAL_TMP2');
  INSERT INTO RRP_MDL.M_GL_BAL_TMP2
    (DATA_DT                          --01数据日期
    ,ORG_ID                           --02机构号
    ,SUBJ_ID                          --03科目号
    ,CUR                              --04币种
    ,STD_PROD_ID                      --05标准产品编号
    ,MON_DLY_AVG_CR_BAL               --06年日均贷方余额
    ,MON_DLY_AVG_DR_BAL               --07年日均借方余额
    )
  SELECT DISTINCT
         V_P_DATE               AS DATA_DT          --01 数据日期
        ,T.ORG_ID               AS ORG_ID           --02 机构号
        ,T.SUBJ_ID              AS SUBJ_ID          --03 科目号
        ,T.CUR                  AS CUR              --04 币种
        ,T.STD_PROD_ID          AS STD_PROD_ID      --05 标准产品编号
        ,ABS(SUM(T.MON_DLY_AVG_CR_BAL)/(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') + 1))
                                AS MON_DLY_AVG_CR_BAL
        ,ABS(SUM(T.MON_DLY_AVG_DR_BAL)/(TO_DATE(V_P_DATE,'YYYYMMDD') - TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') + 1))
                                AS MON_DLY_AVG_DR_BAL
    FROM (
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT          --01 数据日期
         ,A.ORG_ID                    AS ORG_ID           --02 机构号
         ,A.SUBJ_ID                   AS SUBJ_ID          --03 科目号
         ,A.CURR_CD                   AS CUR              --04 币种
         ,A.STD_PROD_ID               AS STD_PROD_ID      --05 标准产品编号
         ,SUM(NVL(A.TD_OC_CR_BAL,0))  AS MON_DLY_AVG_CR_BAL --06 月日均贷方余额
         ,SUM(NVL(A.TD_OC_DR_BAL,0))  AS MON_DLY_AVG_DR_BAL --07 月日均借方余额
    FROM RRP_MDL.O_ICL_CMM_GL_BAL A
   WHERE A.ACCT_DURAN <> '2023-13'
     AND A.ETL_DT BETWEEN TO_DATE((SUBSTR(V_P_DATE,1,6) || '01'),'YYYYMMDD') AND TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY A.ETL_DT,A.SUBJ_ID,A.ORG_ID,A.CURR_CD,A.STD_PROD_ID) T
   GROUP BY T.SUBJ_ID, T.ORG_ID,T.CUR,T.STD_PROD_ID;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   V_STEP := V_STEP + 1 ;
  V_STEP_DESC := '插入月日均余额';
  V_STARTTIME := SYSDATE;
  MERGE /*+ ORDER USE_HASH(A,B)*/ INTO RRP_MDL.M_GL_BAL A
  USING RRP_MDL.M_GL_BAL_TMP2 B
     ON (A.SUBJ_ID = B.SUBJ_ID AND A.ORG_ID = B.ORG_ID AND A.CUR = B.CUR
         AND A.STD_PROD_ID = B.STD_PROD_ID AND A.DATA_DT = B.DATA_DT)
  WHEN MATCHED THEN UPDATE SET
    A.MON_DLY_AVG_CR_BAL = B.MON_DLY_AVG_CR_BAL,
    A.MON_DLY_AVG_DR_BAL = B.MON_DLY_AVG_DR_BAL;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,FREQ,ORG_ID,SUBJ_ID,STD_PROD_ID,CUR,DTL_SUBJ_FLG,COUNT(1)
    FROM RRP_MDL.M_GL_BAL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,FREQ,ORG_ID,SUBJ_ID,STD_PROD_ID,CUR,DTL_SUBJ_FLG
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP_DESC := '-- 程序跑批结束 --';
    WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE
   WHERE ETL_DATE = V_P_DATE
     AND PROC_NAME = 'ETL_M_GL_BAL')
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,'ETL_M_GL_BAL_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_GL_BAL;
/

