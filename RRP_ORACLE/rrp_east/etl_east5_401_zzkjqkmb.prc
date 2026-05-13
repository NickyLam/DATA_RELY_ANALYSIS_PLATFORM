CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_401_ZZKJQKMB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：总账会计全科目表
  **  存储过程名称:  ETL_EAST5_401_ZZKJQKMB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期    修改人      修改项
  **  20220601    付善斌     主键变更
  **  20220623    付善斌     过滤科目名为空的数据
  **  20220616    WHB        修改月报汇率取数口径:由当天汇率改为月底汇率
  **  20220616    WHB        调整格式、修改字段超长、字段换行问题、增量改月跑
  **  20221209    TANGAN      核算中台的总账余额表是一张多维度表，新增了产品维度，需按照科目币种进行汇总处理
  ***********************************************************************/
AS
  V_P_DATE           VARCHAR2(8);         --数据日期
  V_MONTH_STA_DATEID VARCHAR2(8);         --本月月初日期
  V_MONTH_END_DATEID VARCHAR2(8);         --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);       --分区名称
  V_FREQ_FLAG        VARCHAR2(10);        --跑批频度
  V_STEP             INTEGER := 0;        --任务号
  V_COUNT            INTEGER := 0;        --数据记录条数
  V_STARTTIME        DATE;                --处理开始时间
  V_ENDTIME          DATE;                --处理结束时间
  V_SQLCOUNT         INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);       --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_401_ZZKJQKMB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_401_ZZKJQKMB'; --存储过程名称
BEGIN
  O_ERRCODE := '0';
  V_P_DATE  := TO_CHAR(I_P_DATE);
  V_MONTH_STA_DATEID := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

  /*增加分区*/
  V_STEP    := 1;
  V_STEP_DESC := '删除当日分区数据';
  V_STARTTIME := SYSDATE;
  --删除当日分区数据
  RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE);
  RRP_EAST.ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID, V_TABLE_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC  := '清空临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.TMP_SUM_M_GL_BAL';
  --插入基础数据
  INSERT INTO RRP_EAST.TMP_SUM_M_GL_BAL( --插入基础数据 进行便于计算
    DATA_DT,       --数据日期
    LGL_REP_ID,    --法人编号
    FREQ,          --频度
    ORG_ID,        --机构编号
    CUR,           --币种
    SUBJ_ID,       --科目编号
    --SUBJ_NM,       --科目名称
    SUBJ_LVL,      --科目级次
    SUBJ_TYP,      --科目类型
    BGN_DR_BAL,    --期初借方余额
    BGN_CR_BAL,    --期初贷方余额
    CURR_DR_AMT,   --本期借方发生额
    CURR_CR_AMT,   --本期贷方发生额
    END_DR_BAL,    --期末借方余额
    END_CR_BAL,    --期末贷方余额
    DEPT_LINE,     --部门条线
    DATA_SRC       --数据来源
    )
  SELECT TA.DATA_DT               AS DATA_DT,       --数据日期
         TA.LGL_REP_ID            AS LGL_REP_ID,    --法人编号
         TA.FREQ                  AS FREQ,          --频度
         TA.ORG_ID                AS ORG_ID,        --机构编号
         TA.CUR                   AS CUR,           --币种
         TA.SUBJ_ID               AS SUBJ_ID,       --科目编号
         --TA.SUBJ_NM               AS SUBJ_NM,       --科目名称
         TA.SUBJ_LVL              AS SUBJ_LVL,      --科目级次
         TA.SUBJ_TYP              AS SUBJ_TYP,      --科目类型
         SUM(TA.BGN_DR_BAL)       AS BGN_DR_BAL,    --期初借方余额
         SUM(TA.BGN_CR_BAL)       AS BGN_CR_BAL,    --期初贷方余额
         SUM(TA.CURR_DR_AMT)      AS CURR_DR_AMT,   --本期借方发生额
         SUM(TA.CURR_CR_AMT)      AS CURR_CR_AMT,   --本期贷方发生额
         SUM(TA.END_DR_BAL)       AS END_DR_BAL,    --期末借方余额
         SUM(TA.END_CR_BAL)       AS END_CR_BAL,    --期末贷方余额
         MAX(TA.DEPT_LINE)        AS DEPT_LINE,     --部门条线
         MAX(TA.DATA_SRC)         AS DATA_SRC       --数据来源
    FROM RRP_MDL.M_GL_BAL TA
   INNER JOIN RRP_MDL.M_PUM_ORG_INFO_EAST TB
      ON TB.ORG_ID = TA.ORG_ID
     AND TB.DATA_DT = V_P_DATE
   WHERE TA.CUR NOT IN ('CCC','USC','CFC','CUC') --CCC本外币合计 核算中台的是按每天的汇率计算的，EAST业务确认要用月末的 --MODIFY BY TANGAN AT 20221208 剔除上游汇总币种
     AND TA.ORG_ID <> '999999' --UPDATE BY CXL 去除掉999999机构
     AND LENGTH(TA.STD_PROD_ID) = 1 --只要汇总后的产品数据
     AND TA.DATA_DT >= V_MONTH_STA_DATEID
     AND TA.DATA_DT <= V_P_DATE
   GROUP BY TA.DATA_DT,TA.LGL_REP_ID,TA.FREQ,TA.ORG_ID,TA.CUR,TA.SUBJ_ID,TA.SUBJ_LVL,TA.SUBJ_TYP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP    := V_STEP + 1;
  V_STEP_DESC := '将人民币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
  V_STARTTIME := SYSDATE;
  RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,'TMP_401_ZZKJQKMB_BWB', O_ERRCODE);
  RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,'TMP_401_ZZKJQKMB_BWB', 1, O_ERRCODE);
  --EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_EAST.TMP_401_ZZKJQKMB_BWB');
  INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
    NBJGH,  --内部机构号
    KJKMBH, --会计科目编号
    BZ,     --币种
    QCJFYE, --期初借方余额
    QCDFYE, --期初贷方余额
    JFFSE,  --本期借方发生额
    DFFSE,  --本期贷方发生额
    QMJFYE, --期末借方余额
    QMDFYE, --期末贷方余额
    CJRQ,   --采集日期
    BSZQ,   --报送周期
    KJRQ    --会计日期
    )
  SELECT A.ORG_ID        AS NBJGH,  --内部机构号
         A.SUBJ_ID       AS KJKMBH, --会计科目编号
         A.CUR           AS BZ,     --币种
         A.BGN_DR_BAL    AS QCJFYE, --期初借方余额
         A.BGN_CR_BAL    AS QCDFYE, --期初贷方余额
         A.CURR_DR_AMT   AS JFFSE,  --本期借方发生额
         A.CURR_CR_AMT   AS DFFSE,  --本期贷方发生额
         A.END_DR_BAL    AS QMJFYE, --期末借方余额
         A.END_CR_BAL    AS QMDFYE, --期末贷方余额
         V_P_DATE        AS CJRQ,   --采集日期
         '日报'          AS BSZQ,   --报送周期
         A.DATA_DT       AS KJRQ    --会计日期
    FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
   WHERE A.CUR = 'CNY'
     AND A.DATA_DT >= V_MONTH_STA_DATEID
     AND A.DATA_DT <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP    := V_STEP + 1;
  V_STEP_DESC := '将本外币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
    NBJGH,  --内部机构号
    KJKMBH, --会计科目编号
    BZ,     --币种
    QCJFYE, --期初借方余额
    QCDFYE, --期初贷方余额
    JFFSE,  --本期借方发生额
    DFFSE,  --本期贷方发生额
    QMJFYE, --期末借方余额
    QMDFYE, --期末贷方余额
    CJRQ,   --采集日期
    BSZQ,   --报送周期
    KJRQ    --会计日期
    )
  SELECT A.ORG_ID                                          AS NBJGH,  --内部机构号
         A.SUBJ_ID                                         AS KJKMBH, --会计科目编号
         'BWB'                                             AS BZ,     --币种
         /*A.BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)         AS QCJFYE, --期初借方余额
         A.BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)         AS QCDFYE, --期初贷方余额
         A.CURR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1)        AS JFFSE,  --本期借方发生额
         A.CURR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1)        AS DFFSE,  --本期贷方发生额
         A.END_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)         AS QMJFYE, --期末借方余额
         A.END_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)         AS QMDFYE, --期末贷方余额*/
         SUM(A.BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1))    AS QCJFYE, --期初借方余额
         SUM(A.BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1))    AS QCDFYE, --期初贷方余额
         SUM(A.CURR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1))   AS JFFSE,  --本期借方发生额
         SUM(A.CURR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1))   AS DFFSE,  --本期贷方发生额
         SUM(A.END_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1))    AS QMJFYE, --期末借方余额
         SUM(A.END_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1))    AS QMDFYE, --期末贷方余额
         V_P_DATE                                          AS CJRQ,   --采集日期
         '日报'                                            AS BSZQ,   --报送周期
         A.DATA_DT                                         AS KJRQ    --采集日期
    FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EXRT
      ON EXRT.BASE_CUR = A.CUR
     AND EXRT.CNV_CUR = 'CNY'
     AND EXRT.DATA_DT = V_P_DATE
   WHERE A.DATA_DT >= V_MONTH_STA_DATEID
     AND A.DATA_DT <= V_P_DATE
   GROUP BY A.ORG_ID,A.SUBJ_ID,A.DATA_DT;

  --清空临时表TMP_401_ZZKJQKMB_MQHY数据
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP    := V_STEP + 1;
  V_STEP_DESC := '清空临时表数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.TMP_401_ZZKJQKMB_MQHY';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP    := V_STEP + 1;
  V_STEP_DESC:= '汇总数据到临时表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_MQHY(
    NBJGH,
    KJKMBH,
    BZ,
    YCJFYE,
    YCDFYE,
    YJFSE,
    YDFSE,
    JCJFYE,
    JCDFYE,
    JJFSE,
    JDFSE,
    BNCJFYE,
    BNCDFYE,
    BNJFSE,
    BNDFSE,
    NCJFYE,
    NCDFYE,
    NJFSE,
    NDFSE)
  SELECT NBJGH,
         KJKMBH,
         BZ,
         /*MODIFY BY CXL 20220520 START*/
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,6) || '01' THEN NVL(QCJFYE,0) END,0)) AS YCJFYE, --月初借方余额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,6) || '01' THEN NVL(QCDFYE,0) END,0)) AS YCDFYE, --月初贷方余额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,6) = SUBSTR(V_P_DATE,1,6) THEN NVL(JFFSE,0) END,0)) AS YJFSE, --月借方发生额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,6) = SUBSTR(V_P_DATE,1,6) THEN NVL(DFFSE,0) END,0)) AS YDFSE, --月贷方发生额
         SUM(NVL(CASE WHEN KJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') THEN NVL(QCJFYE,0) END,0)) AS JCJFYE, --季初借方余额
         SUM(NVL(CASE WHEN KJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') THEN NVL(QCDFYE,0) END,0)) AS JCDFYE, --季初贷方余额
         SUM(NVL(CASE WHEN KJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') AND KJRQ <= V_P_DATE THEN NVL(JFFSE,0) END,0)) AS JJFSE, --季借方发生额
         SUM(NVL(CASE WHEN KJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') AND KJRQ <= V_P_DATE THEN NVL(DFFSE,0) END,0)) AS JDFSE, --季贷方发生额
         SUM(NVL(CASE WHEN KJRQ = (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN  SUBSTR(V_P_DATE,1,4) || '0101' ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) THEN NVL(QCJFYE,0) END,0)) AS BNCJFYE, --半年初借方余额
         SUM(NVL(CASE WHEN KJRQ = (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101' ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) THEN NVL(QCDFYE,0) END,0)) AS BNCDFYE, --半年初贷方余额
         SUM(NVL(CASE WHEN KJRQ >= (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101' ELSE SUBSTR(V_P_DATE,1,4) || '0701' END)  THEN NVL(JFFSE,0)END,0)) AS BNJFSE, --半年借方发生额
         SUM(NVL(CASE WHEN KJRQ >= (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101'  ELSE SUBSTR(V_P_DATE,1,4) || '0701'  END) AND KJRQ <= V_P_DATE THEN NVL(DFFSE,0) END,0)) AS BNDFSE, --半年贷方发生额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,4) || '0101' THEN NVL(QCJFYE,0) END,0)) AS NCJFYE, --年初借方余额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,4) || '0101' THEN NVL(QCDFYE,0) END,0)) AS NCDFYE, --年初贷方余额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,4) = SUBSTR(V_P_DATE,1,4) THEN NVL(JFFSE,0) END,0)) AS NJFSE, --年借方发生额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,4) = SUBSTR(V_P_DATE,1,4) THEN NVL(DFFSE,0)  END,0)) AS NDFSE --年贷方发生额
  /*MODIFY BY CXL 20220520 END*/
    FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
   WHERE A.BZ = 'CNY'
     AND CJRQ >= SUBSTR(V_P_DATE,1,4) || '0101'
     AND CJRQ <= V_P_DATE
   GROUP BY NBJGH, KJKMBH, BZ
   UNION ALL
  SELECT NBJGH,
         KJKMBH,
         'BWB',
         /*MODIFY BY CXL 20220520 start*/
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,6) || '01' THEN
                    NVL(QCJFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YCJFYE, --月初借方余额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,6) || '01' THEN
                    NVL(QCDFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YCDFYE, --月初贷方余额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,6) = SUBSTR(V_P_DATE,1,6) THEN
                    NVL(JFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YJFSE, --月借方发生额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,6) = SUBSTR(V_P_DATE,1,6) THEN
                    NVL(DFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YDFSE, --月贷方发生额
         SUM(NVL(CASE WHEN KJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') THEN
                    NVL(QCJFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JCJFYE, --季初借方余额
         SUM(NVL(CASE WHEN KJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') THEN
                    NVL(QCDFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JCDFYE, --季初贷方余额
         SUM(NVL(CASE WHEN KJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') AND KJRQ <= V_P_DATE THEN
                    NVL(JFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JJFSE, --季借方发生额
         SUM(NVL(CASE WHEN KJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),'YYYYMMDD') AND KJRQ <= V_P_DATE THEN
                    NVL(DFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JDFSE, --季贷方发生额
         SUM(NVL(CASE WHEN KJRQ = (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101'
                                        ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) THEN
                    NVL(QCJFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNCJFYE, --半年初借方余额
         SUM(NVL(CASE WHEN KJRQ = (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN  SUBSTR(V_P_DATE,1,4) || '0101'
                                        ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) THEN
                    NVL(QCDFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNCDFYE, --半年初贷方余额
         SUM(NVL(CASE WHEN KJRQ >= (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101'
                                         ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) AND KJRQ <= V_P_DATE THEN
                    NVL(JFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNJFSE, --半年借方发生额
         SUM(NVL(CASE WHEN KJRQ >= (CASE WHEN SUBSTR(V_P_DATE,5,2) <= '06' THEN SUBSTR(V_P_DATE,1,4) || '0101'
                                         ELSE SUBSTR(V_P_DATE,1,4) || '0701' END) AND KJRQ <= V_P_DATE THEN
                    NVL(DFFSE,0)  END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNDFSE, --半年贷方发生额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,4) || '0101' THEN
                    NVL(QCJFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NCJFYE, --年初借方余额
         SUM(NVL(CASE WHEN KJRQ = SUBSTR(V_P_DATE,1,4) || '0101' THEN
                    NVL(QCDFYE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NCDFYE, --年初贷方余额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,4) = SUBSTR(V_P_DATE,1,4) THEN
                    NVL(JFFSE,0)  END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NJFSE, --年借方发生额
         SUM(NVL(CASE WHEN SUBSTR(KJRQ,1,4) = SUBSTR(V_P_DATE,1,4) THEN
                    NVL(DFFSE,0) END,0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NDFSE --年贷方发生额
    /*MODIFY BY CXL 20220520 END*/
    FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EXRT
      ON EXRT.BASE_CUR = A.BZ
     AND EXRT.CNV_CUR = 'CNY'
     AND EXRT.DATA_DT = V_P_DATE
   WHERE A.BZ = 'BWB'
     --AND A.BZ <> 'BWB'
     --AND KJKMBH = '1001'
     AND CJRQ >= SUBSTR(V_P_DATE,1,4) || '0101'
     AND CJRQ <= V_P_DATE
   GROUP BY NBJGH, KJKMBH;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --判断数据日期是否为月末
  IF TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD') = V_P_DATE THEN
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入月报数据到临时表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
      NBJGH,       --内部机构号
      KJKMBH,      --会计科目编号
      BZ,          --币种
      QCJFYE,      --期初借方余额
      QCDFYE,      --期初贷方余额
      JFFSE,       --本期借方发生额
      DFFSE,       --本期贷方发生额
      QMJFYE,      --期末借方余额
      QMDFYE,      --期末贷方余额
      CJRQ,        --采集日期
      BSZQ,        --报送周期
      KJRQ         --会计日期
      )
    SELECT A.NBJGH          AS NBJGH,       --内部机构号
           A.KJKMBH         AS KJKMBH,      --会计科目编号
           A.BZ             AS BZ,          --币种
           SUM(B.YCJFYE)    AS QCJFYE,      --期初借方余额
           SUM(B.YCDFYE)    AS QCDFYE,      --期初贷方余额
           SUM(B.YJFSE)     AS JFFSE,       --本期借方发生额
           SUM(B.YDFSE)     AS DFFSE,       --本期贷方发生额
           SUM(A.QMJFYE)    AS QMJFYE,      --期末借方余额
           SUM(A.QMDFYE)    AS QMDFYE,      --期末贷方余额
           V_P_DATE         AS CJRQ,        --采集日期
           '月报'           AS BSZQ,        --报送周期
           A.KJRQ           AS KJRQ         --会计日期
      FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
      LEFT JOIN RRP_EAST.TMP_401_ZZKJQKMB_MQHY B
        ON B.NBJGH = A.NBJGH
       AND B.KJKMBH = A.KJKMBH
       AND B.BZ = A.BZ
     WHERE A.BZ IN ('CNY','BWB')
       AND A.BSZQ = '日报'
       AND A.KJRQ = V_P_DATE
       AND A.CJRQ = V_P_DATE
     GROUP BY A.NBJGH,A.KJKMBH,A.BZ,A.KJRQ;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  /*判断数据日期是否为季末*/
  IF TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Q'),3) - 1,'YYYYMMDD') = V_P_DATE THEN
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入季报数据到临时表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
      NBJGH,       --内部机构号
      KJKMBH,      --会计科目编号
      BZ,          --币种
      QCJFYE,      --期初借方余额
      QCDFYE,      --期初贷方余额
      JFFSE,       --本期借方发生额
      DFFSE,       --本期贷方发生额
      QMJFYE,      --期末借方余额
      QMDFYE,      --期末贷方余额
      CJRQ,        --采集日期
      BSZQ,        --报送周期
      KJRQ         --会计日期
      )
    SELECT A.NBJGH              AS NBJGH,       --内部机构号
           A.KJKMBH             AS KJKMBH,      --会计科目编号
           A.BZ                 AS BZ,          --币种
           SUM(B.JCJFYE)        AS QCJFYE,      --期初借方余额
           SUM(B.JCDFYE)        AS QCDFYE,      --期初贷方余额
           SUM(B.JJFSE)         AS JFFSE,       --本期借方发生额
           SUM(B.JDFSE)         AS DFFSE,       --本期贷方发生额
           SUM(A.QMJFYE)        AS QMJFYE,      --期末借方余额
           SUM(A.QMDFYE)        AS QMDFYE,      --期末贷方余额
           V_P_DATE             AS CJRQ,        --采集日期
           '季报'               AS BSZQ,        --报送周期
           A.KJRQ               AS KJRQ         --会计日期
      FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
      LEFT JOIN RRP_EAST.TMP_401_ZZKJQKMB_MQHY B
        ON B.NBJGH = A.NBJGH
       AND B.KJKMBH = A.KJKMBH
       AND B.BZ = A.BZ
     WHERE A.BZ IN ('CNY','BWB')
       AND A.BSZQ = '月报'
       AND A.KJRQ = V_P_DATE
       AND A.CJRQ = V_P_DATE
     GROUP BY A.NBJGH,A.KJKMBH,A.BZ,A.KJRQ;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  /*判断数据日期是否为半年末*/
  IF SUBSTR(V_P_DATE, 5, 4) IN ('0630','1231') THEN
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入半年报数据到临时表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
      NBJGH,       --内部机构号
      KJKMBH,      --会计科目编号
      BZ,          --币种
      QCJFYE,      --期初借方余额
      QCDFYE,      --期初贷方余额
      JFFSE,       --本期借方发生额
      DFFSE,       --本期贷方发生额
      QMJFYE,      --期末借方余额
      QMDFYE,      --期末贷方余额
      CJRQ,        --采集日期
      BSZQ,        --报送周期
      KJRQ         --会计日期
      )
    SELECT A.NBJGH              AS NBJGH,       --内部机构号
           A.KJKMBH             AS KJKMBH,      --会计科目编号
           A.BZ                 AS BZ,          --币种
           SUM(B.BNCJFYE)       AS QCJFYE,      --期初借方余额
           SUM(B.BNCDFYE)       AS QCDFYE,      --期初贷方余额
           SUM(B.BNJFSE)        AS JFFSE,       --本期借方发生额
           SUM(B.BNDFSE)        AS DFFSE,       --本期贷方发生额
           SUM(A.QMJFYE)        AS QMJFYE,      --期末借方余额
           SUM(A.QMDFYE)        AS QMDFYE,      --期末贷方余额
           V_P_DATE             AS CJRQ,        --采集日期
           '半年报'             AS BSZQ,        --报送周期
           A.KJRQ               AS KJRQ         --会计日期
      FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
      LEFT JOIN RRP_EAST.TMP_401_ZZKJQKMB_MQHY B
        ON B.NBJGH = A.NBJGH
       AND B.KJKMBH = A.KJKMBH
       AND B.BZ = A.BZ
     WHERE A.BZ IN ('CNY','BWB')
       AND A.BSZQ = '月报'
       AND A.KJRQ = V_P_DATE
       AND A.CJRQ = V_P_DATE
     GROUP BY A.NBJGH,A.KJKMBH,A.BZ,A.KJRQ;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  /*判断数据日期是否为年末*/
  IF SUBSTR(V_P_DATE, 5, 4) = '1231' THEN
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入年报数据到临时表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB(
      NBJGH,       --内部机构号
      KJKMBH,      --会计科目编号
      BZ,          --币种
      QCJFYE,      --期初借方余额
      QCDFYE,      --期初贷方余额
      JFFSE,       --本期借方发生额
      DFFSE,       --本期贷方发生额
      QMJFYE,      --期末借方余额
      QMDFYE,      --期末贷方余额
      CJRQ,        --采集日期
      BSZQ,        --报送周期
      KJRQ         --会计日期
      )
    SELECT A.NBJGH             AS NBJGH,       --内部机构号
           A.KJKMBH            AS KJKMBH,      --会计科目编号
           A.BZ                AS BZ,          --币种
           SUM(B.NCJFYE)       AS QCJFYE,      --期初借方余额
           SUM(B.NCDFYE)       AS QCDFYE,      --期初贷方余额
           SUM(B.NJFSE)        AS JFFSE,       --本期借方发生额
           SUM(B.NDFSE)        AS DFFSE,       --本期贷方发生额
           SUM(A.QMJFYE)       AS QMJFYE,      --期末借方余额
           SUM(A.QMDFYE)       AS QMDFYE,      --期末贷方余额
           V_P_DATE            AS CJRQ,        --采集日期
           '年报'              AS BSZQ,        --报送周期
           A.KJRQ              AS KJRQ         --会计日期
      FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
      LEFT JOIN RRP_EAST.TMP_401_ZZKJQKMB_MQHY B
        ON B.NBJGH = A.NBJGH
       AND B.KJKMBH = A.KJKMBH
       AND B.BZ = A.BZ
     WHERE A.BZ IN ('CNY','BWB')
       AND A.BSZQ = '月报'
       AND A.KJRQ = V_P_DATE
       AND A.CJRQ = V_P_DATE
     GROUP BY A.NBJGH,A.KJKMBH,A.BZ,A.KJRQ;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  --将汇总数据插入目标表
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入目标表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_EAST.EAST5_401_ZZKJQKMB(
    RID,        --数据主键
    JRXKZH,     --金融许可证号
    NBJGH,      --内部机构号
    YHJGMC,     --银行机构名称
    KJKMBH,     --会计科目编号
    KJKMMC,     --会计科目名称
    BZ,         --币种
    QCJFYE,     --期初借方余额
    QCDFYE,     --期初贷方余额
    JFFSE,      --本期借方发生额
    DFFSE,      --本期贷方发生额
    QMJFYE,     --期末借方余额
    QMDFYE,     --期末贷方余额
    BSZQ,       --报送周期
    KJRQ,       --会计日期
    BBZ,        --备注
    CJRQ,       --采集日期
    DEPT_NO,    --部门编号
    SRC_SYS_ID, --来源系统ID
    ISSUED_NO,  --填报机构
    ORG_NO,     --报送机构
    ADDRESS,    --归属地
    GSFZJG      --归属分支机构
    )
  SELECT SYS_GUID()              AS RID,        --数据主键
         C.FIN_PERMIT_NO         AS JRXKZH,     --金融许可证号
         A.NBJGH                 AS NBJGH,      --内部机构号
         C.ORG_NM                AS YHJGMC,     --银行机构名称
         A.KJKMBH                AS KJKMBH,     --会计科目编号
         GL.SUBJ_NM              AS KJKMMC,     --会计科目名称
         A.BZ                    AS BZ,         --币种
         NVL(A.QCJFYE,0)         AS QCJFYE,     --期初借方余额
         NVL(A.QCDFYE,0)         AS QCDFYE,     --期初贷方余额
         NVL(A.JFFSE,0)          AS JFFSE,      --本期借方发生额
         NVL(A.DFFSE,0)          AS DFFSE,      --本期贷方发生额
         NVL(A.QMJFYE,0)         AS QMJFYE,     --期末借方余额
         NVL(A.QMDFYE,0)         AS QMDFYE,     --期末贷方余额
         A.BSZQ                  AS BSZQ,       --报送周期
         A.KJRQ                  AS KJRQ,       --会计日期
         ''                      AS BBZ,        --备注
         V_MONTH_END_DATEID      AS CJRQ,       --采集日期
         '000'                   AS DEPT_NO,    --部门编号
         '01'                    AS SRC_SYS_ID, --来源系统ID
         '000000'                AS ISSUED_NO,  --填报机构
         ORG.ORG_ID_LEL_0        AS ORG_NO,     --报送机构
         LIST.REP_ORG_ID         AS ADDRESS,    --归属地
         C.GSFZJG                AS GSFZJG      --归属分支机构
    FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
      ON C.ORG_ID = A.NBJGH
     AND C.DATA_DT = V_MONTH_END_DATEID
    LEFT JOIN RRP_MDL.M_GL_INFO GL
      ON GL.SUBJ_ID = A.KJKMBH
     AND GL.DATA_DT = V_MONTH_END_DATEID
    LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
      ON ORG.ORG_ID = A.NBJGH
    LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
      ON 1 = 1
     AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
   WHERE A.BZ IN ('CNY','BWB')
     AND A.NBJGH <> '999999' --UPDATE BY CXL 去除掉999999机构
     AND TRIM(GL.SUBJ_NM) IS NOT NULL
     AND A.CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
    SELECT CJRQ,NBJGH,KJKMBH,BZ,BSZQ,KJRQ,COUNT(1)
      FROM RRP_EAST.EAST5_401_ZZKJQKMB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,NBJGH,KJKMBH,BZ,BSZQ,KJRQ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_401_ZZKJQKMB(CJRQ,NBJGH,KJKMBH,BZ,BSZQ,KJRQ)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_401_ZZKJQKMB;
/

