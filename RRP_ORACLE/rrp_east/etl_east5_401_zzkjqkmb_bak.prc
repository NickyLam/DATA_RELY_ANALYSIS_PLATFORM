CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_401_ZZKJQKMB_BAK(I_DATADATE IN INTEGER, --跑批日期
                                                   O_ERRCODE  OUT VARCHAR2 --错误代码
                                                   )
  /***********************************************************************
  **  存储过程详细说明：总账会计全科目表
  **  存储过程名称:  ETL_EAST5_401_ZZKJQKMB_BAK
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_DATADATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期    修改人      修改项
  **  20220601    付善斌     主键变更
  **  20220623    付善斌     过滤科目名为空的数据
  **  20220616    WHB        修改月报汇率取数口径:由当天汇率改为月底汇率
  **  20220616    WHB        调整格式、修改字段超长、字段换行问题、增量改月跑
  ***********************************************************************/
IS
  V_DATE                  DATE; --数据日期(判断输入参数日期格式是否准确)
  V_P_DATE                CHAR(8); --数据日期
  --V_LAST_MONTH_END_DATE   DATE; --上月月底日期
  --V_LAST_MONTH_END_DATEID CHAR(8); --上月月底采集日期
  V_MONTH_STA_DATEID      CHAR(8); --本月月初日期
  V_MONTH_END_DATEID      CHAR(8); --本月月底日期
  --V_START_DATE            DATE; --跑批开始时间
  --V_END_DATE              DATE; --跑批结束时间
  V_PROC_NAME             VARCHAR2(100); --存储过程名称
  V_TABLE_NAME            VARCHAR2(100); --表名称
  V_PARTITION_NAME        VARCHAR2(100); --分区名称
  V_FREQ_FLAG             VARCHAR2(10); --跑批频度
  V_STEP_ID               INTEGER; --任务号
  V_COUNT                 INTEGER; --数据记录条数
  --V_DATEDT                CHAR(8);
  V_START_DT              VARCHAR2(8);

  V_SQLERRM               VARCHAR2(1000); --错误信息
  V_SP_ID                 INTEGER; --日志ID
  V_SP_STEP_ID            INTEGER; --分步日志ID
  V_STARTTIME             DATE; -- 处理开始时间
  V_ENDTIME               DATE;   -- 处理结束时间
  V_SQLCOUNT              INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG                VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC             VARCHAR2(100);    -- 处理步骤描述
  V_ETL_DATE              CHAR(8); --系统时间对应月初日期
BEGIN
  V_P_DATE     := TO_CHAR(I_DATADATE);
  V_PROC_NAME  := UPPER('ETL_EAST5_401_ZZKJQKMB_BAK');
  V_TABLE_NAME := UPPER('EAST5_401_ZZKJQKMB');
  O_ERRCODE    := '0';
  V_STEP_ID    := '1';
  V_COUNT      := 0;
  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE       := TO_DATE(I_DATADATE, 'YYYY-MM-DD');
  V_MONTH_STA_DATEID      := TO_CHAR(TRUNC(V_DATE,'MM'), 'YYYYMMDD');
  V_MONTH_END_DATEID      := TO_CHAR(LAST_DAY(V_DATE), 'YYYYMMDD');
  V_PARTITION_NAME        := 'PARTITION_' || V_P_DATE;
  --V_LAST_MONTH_END_DATE   := ADD_MONTHS(V_DATE, -1);
  --V_LAST_MONTH_END_DATEID := TO_CHAR(V_LAST_MONTH_END_DATE, 'YYYYMMDD');
  V_FREQ_FLAG             := FUN_FREQ(I_DATADATE, V_PROC_NAME);

  --V_START_DT := SUBSTR(V_P_DATE, 0, 6) || '01'; --月初

  --判断跑批频度
  --判断跑批频度
  --IF V_FREQ_FLAG = '1' THEN

  /*增加分区*/
  V_STEP_ID    := V_STEP_ID + 1;
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'增加分区');
  V_STEP_DESC := '删除当日分区数据';
  V_STARTTIME := SYSDATE;
  --删除当日分区数据
  RRP_EAST.ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID, V_TABLE_NAME, O_ERRCODE);
  RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序业务逻辑处理主体部分--
  V_STEP_ID := V_STEP_ID + 1; --小于10步骤直接写数字，大于10步用V_STEP_ID := V_STEP_ID + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'清空临时表数据');
  V_STEP_DESC  := '清空临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.TMP_SUM_M_GL_BAL';
  --插入基础数据
  INSERT INTO RRP_EAST.TMP_SUM_M_GL_BAL --插入基础数据 进行便于计算
    (DATA_DT,
     LGL_REP_ID,
     FREQ,
     ORG_ID,
     CUR,
     SUBJ_ID,
     --SUBJ_NM,
     SUBJ_LVL,
     SUBJ_TYP,
     BGN_DR_BAL,
     BGN_CR_BAL,
     CURR_DR_AMT,
     CURR_CR_AMT,
     END_DR_BAL,
     END_CR_BAL,
     DEPT_LINE,
     DATA_SRC)
  SELECT TA.DATA_DT,
         TA.LGL_REP_ID,
         TA.FREQ,
         TA.ORG_ID,
         TA.CUR,
         TA.SUBJ_ID,
         --TA.SUBJ_NM,
         TA.SUBJ_LVL,
         TA.SUBJ_TYP,
         TA.BGN_DR_BAL,
         TA.BGN_CR_BAL,
         TA.CURR_DR_AMT,
         TA.CURR_CR_AMT,
         TA.END_DR_BAL,
         TA.END_CR_BAL,
         TA.DEPT_LINE,
         TA.DATA_SRC
    FROM RRP_MDL.M_GL_BAL TA
   INNER JOIN RRP_MDL.M_PUM_ORG_INFO TB
      ON TB.ORG_ID = TA.ORG_ID
     AND TB.DATA_DT = V_P_DATE
   WHERE TA.CUR NOT IN ('CCC') --CCC本外币合计  核算中台的是按每天的汇率计算的，EAST业务确认要用月末的
     AND TA.ORG_ID <> '999999' --UPDATE BY CXL 去除掉999999机构
     AND TA.DATA_DT >= V_MONTH_STA_DATEID
     AND TA.DATA_DT <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP_ID    := V_STEP_ID + 1;
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'取3级往上科目插入临时表');
  V_STEP_DESC := '将人民币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_EAST.TMP_401_ZZKJQKMB_BWB');
  INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
    (NBJGH, --内部机构号
    KJKMBH, --会计科目编号
    BZ, --币种
    QCJFYE, --期初借方余额
    QCDFYE, --期初贷方余额
    JFFSE, --本期借方发生额
    DFFSE, --本期贷方发生额
    QMJFYE, --期末借方余额
    QMDFYE, --期末贷方余额
    CJRQ,
    BSZQ)
  SELECT A.ORG_ID        AS NBJGH,  --内部机构号
         A.SUBJ_ID       AS KJKMBH, --会计科目编号
         A.CUR           AS BZ,     --币种
         A.BGN_DR_BAL    AS QCJFYE, --期初借方余额
         A.BGN_CR_BAL    AS QCDFYE, --期初贷方余额
         A.CURR_DR_AMT   AS JFFSE,  --本期借方发生额
         A.CURR_CR_AMT   AS DFFSE,  --本期贷方发生额
         A.END_DR_BAL    AS QMJFYE, --期末借方余额
         A.END_CR_BAL    AS QMDFYE, --期末贷方余额
         V_P_DATE        AS CJRQ,
         '日报'          AS BSZQ
    FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
   WHERE A.CUR = 'CNY'
     AND A.DATA_DT >= V_MONTH_STA_DATEID
     AND A.DATA_DT <= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP_ID    := V_STEP_ID + 1;
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'取3级往上科目插入临时表');
  V_STEP_DESC := '将本外币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
    (NBJGH, --内部机构号
    KJKMBH, --会计科目编号
    BZ,     --币种
    QCJFYE, --期初借方余额
    QCDFYE, --期初贷方余额
    JFFSE, --本期借方发生额
    DFFSE, --本期贷方发生额
    QMJFYE, --期末借方余额
    QMDFYE, --期末贷方余额
    CJRQ,   --采集日期
    BSZQ)   --报送周期
  SELECT A.ORG_ID                                          AS NBJGH, --内部机构号
         A.SUBJ_ID                                         AS KJKMBH, --会计科目编号
         'BWB'                                             AS BZ, --币种
         A.BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS QCJFYE, --期初借方余额
         A.BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS QCDFYE, --期初贷方余额
         A.CURR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1) AS JFFSE, --本期借方发生额
         A.CURR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1) AS DFFSE, --本期贷方发生额
         A.END_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS QMJFYE, --期末借方余额
         A.END_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS QMDFYE, --期末贷方余额
         V_P_DATE                                   AS CJRQ,   --采集日期
         '日报'                                     AS BSZQ    --报送周期
  FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
  LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EXRT
    ON EXRT.BASE_CUR = A.CUR
   AND EXRT.CNV_CUR = 'CNY'
   AND EXRT.DATA_DT = V_P_DATE
 WHERE A.DATA_DT >= V_MONTH_STA_DATEID
   AND A.DATA_DT <= V_P_DATE;  --因上游已按机构和科目汇总，因此无需在做汇总操作 MODIFY LHQ 20221013

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP_ID    := V_STEP_ID + 1;
  V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'清空临时表数据');
  V_STEP_DESC := '清空临时表数据';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_401_ZZKJQKMB_MQHY ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP_ID    := V_STEP_ID + 1;
  V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'汇总数据到临时表');
  V_STEP_DESC:= '汇总数据到临时表';
  V_STARTTIME := SYSDATE;
    INSERT INTO TMP_401_ZZKJQKMB_MQHY
      (NBJGH,
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
             SUM(NVL(CASE WHEN CJRQ = SUBSTR(V_P_DATE, 1, 6) || '01' THEN NVL(QCJFYE, 0) END,0)) AS YCJFYE, --月初借方余额
             SUM(NVL(CASE WHEN CJRQ = SUBSTR(V_P_DATE, 1, 6) || '01' THEN NVL(QCDFYE, 0) END,0)) AS YCDFYE, --月初贷方余额
             SUM(NVL(CASE WHEN SUBSTR(CJRQ, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN NVL(JFFSE, 0) END,0)) AS YJFSE, --月借方发生额
             SUM(NVL(CASE WHEN SUBSTR(CJRQ, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN NVL(DFFSE, 0) END,0)) AS YDFSE, --月贷方发生额
             SUM(NVL(CASE WHEN CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),'YYYYMMDD') THEN NVL(QCJFYE, 0) END,0)) AS JCJFYE, --季初借方余额
             SUM(NVL(CASE WHEN CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),'YYYYMMDD') THEN NVL(QCDFYE, 0) END,0)) AS JCDFYE, --季初贷方余额
             SUM(NVL(CASE WHEN CJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),'YYYYMMDD') AND CJRQ <= V_P_DATE THEN NVL(JFFSE, 0) END,0)) AS JJFSE, --季借方发生额
             SUM(NVL(CASE WHEN CJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),'YYYYMMDD') AND CJRQ <= V_P_DATE THEN NVL(DFFSE, 0) END,0)) AS JDFSE, --季贷方发生额
             SUM(NVL(CASE WHEN CJRQ = (CASE WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                                                 SUBSTR(V_P_DATE, 1, 4) || '0101'
                                            ELSE SUBSTR(V_P_DATE, 1, 4) || '0701'
                                            END) THEN NVL(QCJFYE, 0) END, 0)) AS BNCJFYE, --半年初借方余额
             SUM(NVL(CASE WHEN CJRQ = (CASE WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                                                 SUBSTR(V_P_DATE, 1, 4) || '0101'
                          ELSE SUBSTR(V_P_DATE, 1, 4) || '0701' END) THEN NVL(QCDFYE, 0) END, 0)) AS BNCDFYE, --半年初贷方余额
             SUM(NVL(CASE  WHEN CJRQ >= (CASE WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                           ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) AND CJRQ <= V_P_DATE THEN
                        NVL(JFFSE, 0)
                     END,
                     0)) AS BNJFSE, --半年借方发生额
             SUM(NVL(CASE
                       WHEN CJRQ >= (CASE
                              WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                              ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) AND CJRQ <= V_P_DATE THEN
                        NVL(DFFSE, 0)
                     END,
                     0)) AS BNDFSE, --半年贷方发生额

             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 4) || '0101' THEN
                        NVL(QCJFYE, 0)
                     END,
                     0)) AS NCJFYE, --年初借方余额
             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 4) || '0101' THEN
                        NVL(QCDFYE, 0)
                     END,
                     0)) AS NCDFYE, --年初贷方余额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN
                        NVL(JFFSE, 0)
                     END,
                     0)) AS NJFSE, --年借方发生额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN
                        NVL(DFFSE, 0)
                     END,
                     0)) AS NDFSE --年贷方发生额
      /*MODIFY BY CXL 20220520 END*/
        FROM TMP_401_ZZKJQKMB_BWB A
       WHERE CJRQ >= SUBSTR(V_P_DATE, 1, 4) || '0101'
         AND CJRQ <= V_P_DATE
         AND A.BZ = 'CNY'
       GROUP BY NBJGH, KJKMBH, BZ
      UNION ALL
      SELECT NBJGH,
             KJKMBH,
             'BWB',
             /*MODIFY BY CXL 20220520 start*/
             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 6) || '01' THEN
                        NVL(QCJFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YCJFYE, --月初借方余额
             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 6) || '01' THEN
                        NVL(QCDFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YCDFYE, --月初贷方余额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN
                        NVL(JFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YJFSE, --月借方发生额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 6) = SUBSTR(V_P_DATE, 1, 6) THEN
                        NVL(DFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS YDFSE, --月贷方发生额

             SUM(NVL(CASE
                       WHEN CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),
                                           'YYYYMMDD') THEN
                        NVL(QCJFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JCJFYE, --季初借方余额
             SUM(NVL(CASE
                       WHEN CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),
                                           'YYYYMMDD') THEN
                        NVL(QCDFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JCDFYE, --季初贷方余额
             SUM(NVL(CASE
                       WHEN CJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),
                                            'YYYYMMDD') AND CJRQ <= V_P_DATE THEN
                        NVL(JFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JJFSE, --季借方发生额
             SUM(NVL(CASE
                       WHEN CJRQ >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'),
                                            'YYYYMMDD') AND CJRQ <= V_P_DATE THEN
                        NVL(DFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS JDFSE, --季贷方发生额

             SUM(NVL(CASE
                       WHEN CJRQ = (CASE
                              WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                              ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) THEN
                        NVL(QCJFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNCJFYE, --半年初借方余额
             SUM(NVL(CASE
                       WHEN CJRQ = (CASE
                              WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                              ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) THEN
                        NVL(QCDFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNCDFYE, --半年初贷方余额

             SUM(NVL(CASE
                       WHEN CJRQ >= (CASE
                              WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                              ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) AND CJRQ <= V_P_DATE THEN
                        NVL(JFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNJFSE, --半年借方发生额
             SUM(NVL(CASE
                       WHEN CJRQ >= (CASE
                              WHEN SUBSTR(V_P_DATE, 5, 2) <= '06' THEN
                               SUBSTR(V_P_DATE, 1, 4) || '0101'
                              ELSE
                               SUBSTR(V_P_DATE, 1, 4) || '0701'
                            END) AND CJRQ <= V_P_DATE THEN
                        NVL(DFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS BNDFSE, --半年贷方发生额

             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 4) || '0101' THEN
                        NVL(QCJFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NCJFYE, --年初借方余额
             SUM(NVL(CASE
                       WHEN CJRQ = SUBSTR(V_P_DATE, 1, 4) || '0101' THEN
                        NVL(QCDFYE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NCDFYE, --年初贷方余额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN
                        NVL(JFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NJFSE, --年借方发生额
             SUM(NVL(CASE
                       WHEN SUBSTR(CJRQ, 1, 4) = SUBSTR(V_P_DATE, 1, 4) THEN
                        NVL(DFFSE, 0)
                     END,
                     0) * NVL(EXRT.MDL_PRC / 100, 1)) AS NDFSE --年贷方发生额
      /*MODIFY BY CXL 20220520 end*/
        FROM TMP_401_ZZKJQKMB_BWB A
        LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EXRT
          ON A.BZ = EXRT.BASE_CUR
          and EXRT.CNV_CUR = 'CNY'
         AND EXRT.DATA_DT = V_P_DATE
       WHERE CJRQ >= SUBSTR(V_P_DATE, 1, 4) || '0101'
         AND CJRQ <= V_P_DATE
         AND A.BZ <> 'BWB'
      --AND KJKMBH = '1001'
       GROUP BY NBJGH, KJKMBH;
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE  := SQLCODE;
    V_ENDTIME  := SYSDATE;
    COMMIT;


   -- 判断数据日期是否为月末
    IF TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE, 'YYYYMMDD')), 'YYYYMMDD') =
       V_P_DATE THEN
    V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入月报数据到临时表');
    V_STEP_DESC := '插入月报数据到临时表';
      V_STARTTIME := SYSDATE;

      INSERT INTO TMP_401_ZZKJQKMB_BWB
        (NBJGH, --内部机构号
         KJKMBH, --会计科目编号
         BZ, --币种
         QCJFYE, --期初借方余额
         QCDFYE, --期初贷方余额
         JFFSE, --本期借方发生额
         DFFSE, --本期贷方发生额
         QMJFYE, --期末借方余额
         QMDFYE, --期末贷方余额
         CJRQ,
         BSZQ --报送周期
         )
        SELECT A.NBJGH AS NBJGH, --内部机构号
               A.KJKMBH AS KJKMBH, --会计科目编号
               A.BZ AS BZ, --币种
               SUM(B.YCJFYE) AS QCJFYE, --期初借方余额
               SUM(B.YCDFYE) AS QCDFYE, --期初贷方余额
               SUM(B.YJFSE) AS JFFSE, --本期借方发生额
               SUM(B.YDFSE) AS DFFSE, --本期贷方发生额
               SUM(A.QMJFYE) AS QMJFYE, --期末借方余额
               SUM(A.QMDFYE) AS QMDFYE, --期末贷方余额
               V_P_DATE AS CJRQ,
               '月报' AS BSZQ --报送周期
          FROM TMP_401_ZZKJQKMB_BWB A
          LEFT JOIN TMP_401_ZZKJQKMB_MQHY B
            ON A.NBJGH = B.NBJGH
           AND A.KJKMBH = B.KJKMBH
           AND A.BZ = B.BZ
         WHERE A.CJRQ = V_P_DATE
           AND A.BZ IN ('CNY', 'BWB') --WUHB
         GROUP BY A.NBJGH, --内部机构号
                  A.KJKMBH, --会计科目编号
                  A.BZ;
      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
      O_ERRCODE  := SQLCODE;
      V_ENDTIME  := SYSDATE;
      COMMIT;

      /*        RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);
      */
    END IF;

    /*判断数据日期是否为季末*/
    IF TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'), 3) - 1,
               'YYYYMMDD') = V_P_DATE THEN
    V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID :=FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入季报数据到临时表');
    V_STEP_DESC := '插入季报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO TMP_401_ZZKJQKMB_BWB
        (NBJGH, --内部机构号
         KJKMBH, --会计科目编号
         BZ, --币种
         QCJFYE, --期初借方余额
         QCDFYE, --期初贷方余额
         JFFSE, --本期借方发生额
         DFFSE, --本期贷方发生额
         QMJFYE, --期末借方余额
         QMDFYE, --期末贷方余额
         CJRQ,
         BSZQ --报送周期
         )
        SELECT A.NBJGH AS NBJGH, --内部机构号
               A.KJKMBH AS KJKMBH, --会计科目编号
               A.BZ AS BZ, --币种
               SUM(B.JCJFYE) AS QCJFYE, --期初借方余额
               SUM(B.JCDFYE) AS QCDFYE, --期初贷方余额
               SUM(B.JJFSE) AS JFFSE, --本期借方发生额
               SUM(B.JDFSE) AS DFFSE, --本期贷方发生额
               SUM(A.QMJFYE) AS QMJFYE, --期末借方余额
               SUM(A.QMDFYE) AS QMDFYE, --期末贷方余额
               V_P_DATE AS CJRQ, --采集日期
               '季报' AS BSZQ --报送周期
          FROM TMP_401_ZZKJQKMB_BWB A
          LEFT JOIN TMP_401_ZZKJQKMB_MQHY B
            ON A.NBJGH = B.NBJGH
           AND A.KJKMBH = B.KJKMBH
           AND A.BZ = B.BZ
         WHERE A.CJRQ = V_P_DATE
           AND A.BZ IN ('CNY', 'BWB') --WUHB
         GROUP BY A.NBJGH, --内部机构号
                  A.KJKMBH, --会计科目编号
                  A.BZ;
      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
      O_ERRCODE  := SQLCODE;
      V_ENDTIME  := SYSDATE;
      COMMIT;
      /*        RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);
      */
    END IF;

    /*判断数据日期是否为半年末*/
    IF SUBSTR(V_P_DATE, 5, 4) IN ('0630', '1231') THEN
    V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入半年报数据到临时表');
    V_STEP_DESC  := '插入半年报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO TMP_401_ZZKJQKMB_BWB
        (NBJGH, --内部机构号
         KJKMBH, --会计科目编号
         BZ, --币种
         QCJFYE, --期初借方余额
         QCDFYE, --期初贷方余额
         JFFSE, --本期借方发生额
         DFFSE, --本期贷方发生额
         QMJFYE, --期末借方余额
         QMDFYE, --期末贷方余额
         CJRQ,
         BSZQ --报送周期
         )
        SELECT A.NBJGH AS NBJGH, --内部机构号
               A.KJKMBH AS KJKMBH, --会计科目编号
               A.BZ AS BZ, --币种
               SUM(B.BNCJFYE) AS QCJFYE, --期初借方余额
               SUM(B.BNCDFYE) AS QCDFYE, --期初贷方余额
               SUM(B.BNJFSE) AS JFFSE, --本期借方发生额
               SUM(B.BNDFSE) AS DFFSE, --本期贷方发生额
               SUM(A.QMJFYE) AS QMJFYE, --期末借方余额
               SUM(A.QMDFYE) AS QMDFYE, --期末贷方余额
               V_P_DATE AS CJRQ, --采集日期
               '半年报' AS BSZQ --报送周期
          FROM TMP_401_ZZKJQKMB_BWB A
          LEFT JOIN TMP_401_ZZKJQKMB_MQHY B
            ON A.NBJGH = B.NBJGH
           AND A.KJKMBH = B.KJKMBH
           AND A.BZ = B.BZ
         WHERE A.CJRQ = V_P_DATE
           AND A.BZ in ('CNY', 'BWB') --WUHB
         GROUP BY A.NBJGH, --内部机构号
                  A.KJKMBH, --会计科目编号
                  A.BZ;
      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
      O_ERRCODE  := SQLCODE;
      V_ENDTIME  := SYSDATE;
      COMMIT;
      /*        RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);
      */
    END IF;

    /*判断数据日期是否为年末*/
    IF SUBSTR(V_P_DATE, 5, 4) = '1231' THEN
    V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID :=FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入年报数据到临时表');
    V_STEP_DESC := '插入年报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO TMP_401_ZZKJQKMB_BWB
        (NBJGH, --内部机构号
         KJKMBH, --会计科目编号
         BZ, --币种
         QCJFYE, --期初借方余额
         QCDFYE, --期初贷方余额
         JFFSE, --本期借方发生额
         DFFSE, --本期贷方发生额
         QMJFYE, --期末借方余额
         QMDFYE, --期末贷方余额
         CJRQ,
         BSZQ --报送周期
         )
        SELECT A.NBJGH AS NBJGH, --内部机构号
               A.KJKMBH AS KJKMBH, --会计科目编号
               A.BZ AS BZ, --币种
               SUM(B.NCJFYE) AS QCJFYE, --期初借方余额
               SUM(B.NCDFYE) AS QCDFYE, --期初贷方余额
               SUM(B.NJFSE) AS JFFSE, --本期借方发生额
               SUM(B.NDFSE) AS DFFSE, --本期贷方发生额
               SUM(A.QMJFYE) AS QMJFYE, --期末借方余额
               SUM(A.QMDFYE) AS QMDFYE, --期末贷方余额
               V_P_DATE AS CJRQ, --采集日期
               '年报' AS BSZQ --报送周期
          FROM TMP_401_ZZKJQKMB_BWB A
          LEFT JOIN TMP_401_ZZKJQKMB_MQHY B
            ON A.NBJGH = B.NBJGH
           AND A.KJKMBH = B.KJKMBH
           AND A.BZ = B.BZ
         WHERE A.CJRQ = V_P_DATE
           AND A.BZ in ('CNY', 'BWB') --WUHB
         GROUP BY A.NBJGH, --内部机构号
                  A.KJKMBH, --会计科目编号
                  A.BZ;
      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
      O_ERRCODE  := SQLCODE;
      V_ENDTIME  := SYSDATE;
      COMMIT;
      /*        RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);
      */
    END IF;

    /*V_STEP_ID    := '15';
    V_SP_STEP_ID := RRP_MDL.FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'删除当日数据');
    DELETE FROM RRP_MDL.EAST5_401_ZZKJQKMB WHERE CJRQ = V_P_DATE;
    V_COUNT := SQL%ROWCOUNT;
    COMMIT;
    RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);*/

       V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := SQLCODE;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入目标表');
    V_STEP_DESC  := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO EAST5_401_ZZKJQKMB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       KJKMBH, --会计科目编号
       KJKMMC, --会计科目名称
       BZ, --币种
       QCJFYE, --期初借方余额
       QCDFYE, --期初贷方余额
       JFFSE, --本期借方发生额
       DFFSE, --本期贷方发生额
       QMJFYE, --期末借方余额
       QMDFYE, --期末贷方余额
       BSZQ, --报送周期
       KJRQ, --会计日期
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG --归属分支机构
       )
      SELECT
      --MD5(V_MONTH_END_DATEID || A.BZ || A.BSZQ || A.KJKMBH || A.NBJGH) AS RID, ---数据主键
       SYS_GUID() AS RID, ---数据主键
       C.FIN_PERMIT_NO AS JRXKZH, --金融许可证号
       A.NBJGH AS NBJGH, --内部机构号
       C.ORG_NM AS YHJGMC, --银行机构名称
       A.KJKMBH AS KJKMBH, --会计科目编号
       GL.SUBJ_NM AS KJKMMC, --会计科目名称
       A.BZ AS BZ, --币种
       A.QCJFYE AS QCJFYE, --期初借方余额
       A.QCDFYE AS QCDFYE, --期初贷方余额
       A.JFFSE AS JFFSE, --本期借方发生额
       A.DFFSE AS DFFSE, --本期贷方发生额
       A.QMJFYE AS QMJFYE, --期末借方余额
       A.QMDFYE AS QMDFYE, --期末贷方余额
       A.BSZQ AS BSZQ, --报送周期
       A.CJRQ AS KJRQ, --会计日期
       '' AS BBZ, --备注
       V_MONTH_END_DATEID AS CJRQ, --采集日期
       /*'01' UPDATE BY CXL 20220524*/
       '000' AS DEPT_NO, --部门编号
       '01' AS SRC_SYS_ID, --来源系统ID
       /*A.NBJGH UPDATE BY CXL 20220524*/
       '800918' AS ISSUED_NO, --填报机构
       ORG.ORG_ID_LEL_0 AS ORG_NO, --报送机构
       /*CASE
         WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
         ELSE LIST.REP_ORG_ID
       END AS ADDRESS, --归属地*/
       LIST.REP_ORG_ID AS ADDRESS, --归属地
       C.GSFZJG AS GSFZJG --归属分支机构
        FROM TMP_401_ZZKJQKMB_BWB A
        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO C --机构表
          ON A.NBJGH = C.ORG_ID
         AND C.DATA_DT = V_MONTH_END_DATEID
        LEFT JOIN RRP_MDL.M_GL_INFO GL
          ON A.KJKMBH = GL.SUBJ_ID
         AND GL.DATA_DT = V_MONTH_END_DATEID
        LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
          ON A.NBJGH = ORG.ORG_ID
        LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
          ON 1 = 1
         AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
       WHERE A.CJRQ = V_P_DATE
         AND A.BZ IN ('CNY', 'BWB') --WUHB
         AND A.NBJGH <> '999999' --UPDATE BY CXL 去除掉999999机构
         AND TRIM(GL.SUBJ_NM) IS NOT NULL;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := SQLCODE;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --END;

  --ADD BY LIP 20220630 汇总到目标表
  V_STEP_ID    := V_STEP_ID + 1;
  V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'表分析');
  --表分析
  --RRP_MDL.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);
  --RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', 0);

  V_STEP_ID    := V_STEP_ID + 1;
  V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'跑批结束');
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_SQLERRM := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    --记录异常信息
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := SQLCODE;
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    ROLLBACK;
    RAISE;

END ETL_EAST5_401_ZZKJQKMB_BAK;
/

