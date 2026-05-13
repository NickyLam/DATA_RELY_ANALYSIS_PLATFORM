CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_401_ZZKJQKMB_20221103(I_DATADATE IN INTEGER, --跑批日期
                                                            O_ERRCODE  OUT INTEGER --错误代码
                                                            )
  /***********************************************************************
  **  存储过程详细说明：总账会计全科目表
  **  存储过程名称:  ETL_EAST5_401_ZZKJQKMB
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
  **  20221108    LIP        各季度数据改从总账出数，不再自行汇总
  ***********************************************************************/
IS
  V_DATE                  DATE;             --数据日期(判断输入参数日期格式是否准确)
  V_P_DATE                CHAR(8);          --数据日期
  --V_LAST_MONTH_END_DATE   DATE;           --上月月底日期
  --V_LAST_MONTH_END_DATEID CHAR(8);        --上月月底采集日期
  V_MONTH_STA_DATEID      CHAR(8);          --本月月初日期
  V_MONTH_END_DATEID      CHAR(8);          --本月月底日期
  V_HY_STA_DATEID         CHAR(8);          --半年初日期
  --V_QUA_STA_DATEID        CHAR(8);          --季初日期
  --V_START_DATE            DATE;           --跑批开始时间
  --V_END_DATE              DATE;           --跑批结束时间
  V_PROC_NAME             VARCHAR2(100);    --存储过程名称
  V_TABLE_NAME            VARCHAR2(100);    --表名称
  V_PARTITION_NAME        VARCHAR2(100);    --分区名称
  V_FREQ_FLAG             VARCHAR2(10);     --跑批频度
  V_STEP_ID               INTEGER;          --任务号
  --V_COUNT                 INTEGER;          --数据记录条数
  --V_DATEDT                CHAR(8);
  --V_START_DT              VARCHAR2(8);

  --V_SQLERRM               VARCHAR2(1000);   --错误信息
  --V_SP_ID                 INTEGER;          --日志ID
  --V_SP_STEP_ID            INTEGER;          --分步日志ID
  V_STARTTIME             DATE;             --处理开始时间
  V_ENDTIME               DATE;             --处理结束时间
  V_SQLCOUNT              INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG                VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC             VARCHAR2(100);    --处理步骤描述
  --V_ETL_DATE              CHAR(8);          --系统时间对应月初日期
BEGIN
  V_P_DATE                := TO_CHAR(I_DATADATE);
  V_PROC_NAME             := UPPER('ETL_EAST5_401_ZZKJQKMB');
  V_TABLE_NAME            := UPPER('EAST5_401_ZZKJQKMB');
  O_ERRCODE               := 0;
  V_STEP_ID               := '1';
  --V_COUNT                 := 0;
  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE                  := TO_DATE(I_DATADATE,'YYYYMMDD');       --数据日期
  V_MONTH_STA_DATEID      := TO_CHAR(TRUNC(V_DATE,'MM'),'YYYYMMDD'); --本月月初日期
  V_MONTH_END_DATEID      := TO_CHAR(LAST_DAY(V_DATE),'YYYYMMDD');   --本月月底日期
  V_PARTITION_NAME        := 'PARTITION_' || V_MONTH_END_DATEID;
  V_HY_STA_DATEID         := CASE WHEN SUBSTR(I_DATADATE, 5, 2) <= '06' THEN SUBSTR(I_DATADATE, 1, 4) || '0101'
                                  ELSE SUBSTR(I_DATADATE, 1, 4) || '0701'
                              END;                                   --半年初日期
  --V_QUA_STA_DATEID        := TRUNC(V_DATE, 'Q');                     --季初日期
  V_FREQ_FLAG             := FUN_FREQ(I_DATADATE, V_PROC_NAME);
  --V_LAST_MONTH_END_DATE   := ADD_MONTHS(V_DATE, -1);
  --V_LAST_MONTH_END_DATEID := TO_CHAR(V_LAST_MONTH_END_DATE, 'YYYYMMDD');

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
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
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
      (DATA_DT,               --数据日期
       LGL_REP_ID,            --法人编号
       FREQ,                  --频度
       ORG_ID,                --机构编号
       CUR,                   --币种
       SUBJ_ID,               --科目编号
       SUBJ_NM,               --科目名称
       SUBJ_LVL,              --科目级次
       SUBJ_TYP,              --科目类型
       DTL_SUBJ_FLG,          --明细科目标志
       BGN_DR_BAL,            --期初借方余额
       BGN_CR_BAL,            --期初贷方余额
       CURR_DR_AMT,           --本期借方发生额
       CURR_CR_AMT,           --本期贷方发生额
       END_DR_BAL,            --期末借方余额
       END_CR_BAL,            --期末贷方余额
       MON_BGN_DR_BAL,        --月初借方余额
       MON_BGN_CR_BAL,        --月初贷方余额
       MON_DR_AMT,            --月借方发生额
       MON_CR_AMT,            --月贷方发生额
       QRT_BGN_DR_BAL,        --季初借方余额
       QRT_BGN_CR_BAL,        --季初贷方余额
       QRT_DR_AMT,            --季借方发生额
       QRT_CR_AMT,            --季贷方发生额
       HALF_YEAR_BGN_DR_BAL,  --半年初借方余额
       HALF_YEAR_BGN_CR_BAL,  --半年初贷方余额
       HALF_YEAR_DR_AMT,      --半年借方发生额
       HALF_YEAR_CR_AMT,      --半年贷方发生额
       YEAR_BGN_DR_BAL,       --年初借方余额
       YEAR_BGN_CR_BAL,       --年初贷方余额
       YEAR_DR_AMT,           --年借方发生额
       YEAR_CR_AMT,           --年贷方发生额
       DEPT_LINE,             --部门条线
       DATA_SRC               --数据来源
      )
    SELECT TA.DATA_DT                                       AS DATA_DT,               --数据日期
           TA.LGL_REP_ID                                    AS LGL_REP_ID,            --法人编号
           TA.FREQ                                          AS FREQ,                  --频度
           TA.ORG_ID                                        AS ORG_ID,                --机构编号
           TA.CUR                                           AS CUR,                   --币种
           TA.SUBJ_ID                                       AS SUBJ_ID,               --科目编号
           TA.SUBJ_NM                                       AS SUBJ_NM,               --科目名称
           TA.SUBJ_LVL                                      AS SUBJ_LVL,              --科目级次
           TA.SUBJ_TYP                                      AS SUBJ_TYP,              --科目类型
           TA.DTL_SUBJ_FLG                                  AS DTL_SUBJ_FLG,          --明细科目标志
           TA.BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)       AS BGN_DR_BAL,            --期初借方余额
           TA.BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)       AS BGN_CR_BAL,            --期初贷方余额
           TA.CURR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1)      AS CURR_DR_AMT,           --本期借方发生额
           TA.CURR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1)      AS CURR_CR_AMT,           --本期贷方发生额
           TA.END_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)       AS END_DR_BAL,            --期末借方余额
           TA.END_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)       AS END_CR_BAL,            --期末贷方余额
           TA.MON_BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)   AS MON_BGN_DR_BAL,        --月初借方余额
           TA.MON_BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)   AS MON_BGN_CR_BAL,        --月初贷方余额
           TA.MON_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1)       AS MON_DR_AMT,            --月借方发生额
           TA.MON_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1)       AS MON_CR_AMT,            --月贷方发生额
           TA.QRT_BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)   AS QRT_BGN_DR_BAL,        --季初借方余额
           TA.QRT_BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)   AS QRT_BGN_CR_BAL,        --季初贷方余额
           TA.QRT_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1)       AS QRT_DR_AMT,            --季借方发生额
           TA.QRT_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1)       AS QRT_CR_AMT,            --季贷方发生额
           TA.HALF_YEAR_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1) AS HALF_YEAR_BGN_DR_BAL,  --半年初借方余额
           TA.HALF_YEAR_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1) AS HALF_YEAR_BGN_CR_BAL,  --半年初贷方余额
           TA.HALF_YEAR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1) AS HALF_YEAR_DR_AMT,      --半年借方发生额
           TA.HALF_YEAR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1) AS HALF_YEAR_CR_AMT,      --半年贷方发生额
           TA.YEAR_BGN_DR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS YEAR_BGN_DR_BAL,       --年初借方余额
           TA.YEAR_BGN_CR_BAL * NVL(EXRT.MDL_PRC / 100, 1)  AS YEAR_BGN_CR_BAL,       --年初贷方余额
           TA.YEAR_DR_AMT * NVL(EXRT.MDL_PRC / 100, 1)      AS YEAR_DR_AMT,           --年借方发生额
           TA.YEAR_CR_AMT * NVL(EXRT.MDL_PRC / 100, 1)      AS YEAR_CR_AMT,           --年贷方发生额
           TA.DEPT_LINE                                     AS DEPT_LINE,             --部门条线
           TA.DATA_SRC                                      AS DATA_SRC               --数据来源
      FROM RRP_MDL.M_GL_BAL TA
     INNER JOIN RRP_MDL.M_PUM_ORG_INFO_EAST TB
        ON TB.ORG_ID = TA.ORG_ID
       AND TB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EXRT
        ON EXRT.BASE_CUR = TA.CUR
       AND EXRT.CNV_CUR = 'CNY'
       AND EXRT.DATA_DT = V_P_DATE
     WHERE --TA.CUR NOT IN ('CCC') --CCC本外币合计  核算中台的是按每天的汇率计算的，EAST业务确认要用月末的
           TA.CUR NOT IN ('CCC','USC','CFC','CUC') --CCC本外币合计  核算中台的是按每天的汇率计算的，EAST业务确认要用月末的
       AND TA.ORG_ID <> '999999' --UPDATE BY CXL 去除掉999999机构
       AND TA.DATA_DT >= V_MONTH_STA_DATEID
       AND TA.DATA_DT <= V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP_ID    := V_STEP_ID + 1;
    --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'取3级往上科目插入临时表');
    V_STEP_DESC := '将人民币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE ('TRUNCATE TABLE RRP_EAST.TMP_401_ZZKJQKMB_BWB');
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
      (NBJGH,           --内部机构号
       KJKMBH,          --会计科目编号
       BZ,              --币种
       QCJFYE,          --本日期初借方余额
       QCDFYE,          --本日期初贷方余额
       JFFSE,           --本日借方发生额
       DFFSE,           --本日贷方发生额
       QMJFYE,          --本日期末借方余额
       QMDFYE,          --本日期末贷方余额
       YCJFYE,          --月初借方余额
       YCDFYE,          --月初贷方余额
       YJFSE,           --月借方发生额
       YDFSE,           --月贷方发生额
       JCJFYE,          --季初借方余额
       JCDFYE,          --季初贷方余额
       JJFSE,           --季借方发生额
       JDFSE,           --季贷方发生额
       BNCJFYE,         --半年初借方余额
       BNCDFYE,         --半年初贷方余额
       BNJFSE,          --半年借方发生额
       BNDFSE,          --半年贷方发生额
       NCJFYE,          --年初借方余额
       NCDFYE,          --年初贷方余额
       NJFSE,           --年借方发生额
       NDFSE,           --年贷方发生额
       CJRQ,            --采集日期
       BSZQ             --报送周期
       )
    SELECT A.ORG_ID                AS NBJGH,           --内部机构号
           A.SUBJ_ID               AS KJKMBH,          --会计科目编号
           A.CUR                   AS BZ,              --币种
           A.BGN_DR_BAL            AS QCJFYE,          --本日期初借方余额
           A.BGN_CR_BAL            AS QCDFYE,          --本日期初贷方余额
           A.CURR_DR_AMT           AS JFFSE,           --本日借方发生额
           A.CURR_CR_AMT           AS DFFSE,           --本日贷方发生额
           A.END_DR_BAL            AS QMJFYE,          --本日期末借方余额
           A.END_CR_BAL            AS QMDFYE,          --本日期末借方余额
           A.MON_BGN_DR_BAL        AS YCJFYE,          --月初借方余额
           A.MON_BGN_CR_BAL        AS YCDFYE,          --月初贷方余额
           A.MON_DR_AMT            AS YJFSE,           --月借方发生额
           A.MON_CR_AMT            AS YDFSE,           --月贷方发生额
           A.QRT_BGN_DR_BAL        AS JCJFYE,          --季初借方余额
           A.QRT_BGN_CR_BAL        AS JCDFYE,          --季初贷方余额
           A.QRT_DR_AMT            AS JJFSE,           --季借方发生额
           A.QRT_CR_AMT            AS JDFSE,           --季贷方发生额
           A.HALF_YEAR_BGN_DR_BAL  AS BNCJFYE,         --半年初借方余额
           A.HALF_YEAR_BGN_CR_BAL  AS BNCDFYE,         --半年初贷方余额
           A.HALF_YEAR_DR_AMT      AS BNJFSE,          --半年借方发生额
           A.HALF_YEAR_CR_AMT      AS BNDFSE,          --半年贷方发生额
           A.YEAR_BGN_DR_BAL       AS NCJFYE,          --年初借方余额
           A.YEAR_BGN_CR_BAL       AS NCDFYE,          --年初贷方余额
           A.YEAR_DR_AMT           AS NJFSE,           --年借方发生额
           A.YEAR_CR_AMT           AS NDFSE,           --年贷方发生额
           A.DATA_DT               AS CJRQ,            --采集日期
           '日报'                  AS BSZQ             --报送周期
      FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
     WHERE A.CUR = 'CNY'
       AND A.DATA_DT >= V_MONTH_STA_DATEID
       AND A.DATA_DT <= V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP_ID    := V_STEP_ID + 1;
    --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'取3级往上科目插入临时表');
    V_STEP_DESC := '将本外币数据插入RRP_EAST.TMP_401_ZZKJQKMB_BWB';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
      (NBJGH,           --内部机构号
       KJKMBH,          --会计科目编号
       BZ,              --币种
       QCJFYE,          --本日期初借方余额
       QCDFYE,          --本日期初贷方余额
       JFFSE,           --本日借方发生额
       DFFSE,           --本日贷方发生额
       QMJFYE,          --本日期末借方余额
       QMDFYE,          --本日期末贷方余额
       YCJFYE,          --月初借方余额
       YCDFYE,          --月初贷方余额
       YJFSE,           --月借方发生额
       YDFSE,           --月贷方发生额
       JCJFYE,          --季初借方余额
       JCDFYE,          --季初贷方余额
       JJFSE,           --季借方发生额
       JDFSE,           --季贷方发生额
       BNCJFYE,         --半年初借方余额
       BNCDFYE,         --半年初贷方余额
       BNJFSE,          --半年借方发生额
       BNDFSE,          --半年贷方发生额
       NCJFYE,          --年初借方余额
       NCDFYE,          --年初贷方余额
       NJFSE,           --年借方发生额
       NDFSE,           --年贷方发生额
       CJRQ,            --采集日期
       BSZQ             --报送周期
       )
    SELECT A.ORG_ID                     AS NBJGH,           --内部机构号
           A.SUBJ_ID                    AS KJKMBH,          --会计科目编号
           'BWB'                        AS BZ,              --币种
           SUM(A.BGN_DR_BAL)            AS QCJFYE,          --本日期初借方余额
           SUM(A.BGN_CR_BAL)            AS QCDFYE,          --本日期初贷方余额
           SUM(A.CURR_DR_AMT)           AS JFFSE,           --本日借方发生额
           SUM(A.CURR_CR_AMT)           AS DFFSE,           --本日贷方发生额
           SUM(A.END_DR_BAL)            AS QMJFYE,          --本日期末借方余额
           SUM(A.END_CR_BAL)            AS QMDFYE,          --本日期末借方余额
           SUM(A.MON_BGN_DR_BAL)        AS YCJFYE,          --月初借方余额
           SUM(A.MON_BGN_CR_BAL)        AS YCDFYE,          --月初贷方余额
           SUM(A.MON_DR_AMT)            AS YJFSE,           --月借方发生额
           SUM(A.MON_CR_AMT)            AS YDFSE,           --月贷方发生额
           SUM(A.QRT_BGN_DR_BAL)        AS JCJFYE,          --季初借方余额
           SUM(A.QRT_BGN_CR_BAL)        AS JCDFYE,          --季初贷方余额
           SUM(A.QRT_DR_AMT)            AS JJFSE,           --季借方发生额
           SUM(A.QRT_CR_AMT)            AS JDFSE,           --季贷方发生额
           SUM(A.HALF_YEAR_BGN_DR_BAL)  AS BNCJFYE,         --半年初借方余额
           SUM(A.HALF_YEAR_BGN_CR_BAL)  AS BNCDFYE,         --半年初贷方余额
           SUM(A.HALF_YEAR_DR_AMT)      AS BNJFSE,          --半年借方发生额
           SUM(A.HALF_YEAR_CR_AMT)      AS BNDFSE,          --半年贷方发生额
           SUM(A.YEAR_BGN_DR_BAL)       AS NCJFYE,          --年初借方余额
           SUM(A.YEAR_BGN_CR_BAL)       AS NCDFYE,          --年初贷方余额
           SUM(A.YEAR_DR_AMT)           AS NJFSE,           --年借方发生额
           SUM(A.YEAR_CR_AMT)           AS NDFSE,           --年贷方发生额
           A.DATA_DT                    AS CJRQ,            --采集日期
           '日报'                       AS BSZQ             --报送周期
      FROM RRP_EAST.TMP_SUM_M_GL_BAL A --总账会计科目余额表
     WHERE A.DATA_DT >= V_MONTH_STA_DATEID
       AND A.DATA_DT <= V_P_DATE
     GROUP BY A.ORG_ID,A.SUBJ_ID,A.DATA_DT;  --按机构科目日期对各币种数据进行汇总

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    --判断数据日期是否为月末
    IF TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE, 'YYYYMMDD')), 'YYYYMMDD') = V_P_DATE THEN
      V_STEP_ID    := V_STEP_ID + 1;
      --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入月报数据到临时表');
      V_STEP_DESC := '插入月报数据到临时表';
      V_STARTTIME := SYSDATE;

      INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
        (NBJGH,        --内部机构号
         KJKMBH,       --会计科目编号
         BZ,           --币种
         QCJFYE,       --期初借方余额
         QCDFYE,       --期初贷方余额
         JFFSE,        --本期借方发生额
         DFFSE,        --本期贷方发生额
         QMJFYE,       --期末借方余额
         QMDFYE,       --期末贷方余额
         CJRQ,
         BSZQ          --报送周期
        )
      SELECT A.NBJGH            AS NBJGH,     --内部机构号
             A.KJKMBH           AS KJKMBH,    --会计科目编号
             A.BZ               AS BZ,        --币种
             A.YCJFYE           AS QCJFYE,    --期初借方余额
             A.YCDFYE           AS QCDFYE,    --期初贷方余额
             A.YJFSE            AS JFFSE,     --本期借方发生额
             A.YDFSE            AS DFFSE,     --本期贷方发生额
             A.QMJFYE           AS QMJFYE,    --期末借方余额
             A.QMDFYE           AS QMDFYE,    --期末贷方余额
             V_P_DATE           AS CJRQ,
             '月报'             AS BSZQ --报送周期
        FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
       WHERE A.BZ IN ('CNY','BWB')
         AND A.BSZQ = '日报'
         AND A.CJRQ = V_P_DATE;

      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
      O_ERRCODE  := SUBSTR(SQLCODE,1,30);
      V_ENDTIME  := SYSDATE;
      COMMIT;

    END IF;

    /*判断数据日期是否为季末*/
    IF TO_CHAR(ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'Q'), 3) - 1,'YYYYMMDD') = V_P_DATE THEN
      V_STEP_ID    := V_STEP_ID + 1;
      --V_SP_STEP_ID :=FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入季报数据到临时表');
      V_STEP_DESC := '插入季报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
        (NBJGH,        --内部机构号
         KJKMBH,       --会计科目编号
         BZ,           --币种
         QCJFYE,       --期初借方余额
         QCDFYE,       --期初贷方余额
         JFFSE,        --本期借方发生额
         DFFSE,        --本期贷方发生额
         QMJFYE,       --期末借方余额
         QMDFYE,       --期末贷方余额
         CJRQ,
         BSZQ          --报送周期
        )
      SELECT A.NBJGH            AS NBJGH,     --内部机构号
             A.KJKMBH           AS KJKMBH,    --会计科目编号
             A.BZ               AS BZ,        --币种
             A.JCJFYE           AS QCJFYE,    --期初借方余额
             A.JCDFYE           AS QCDFYE,    --期初贷方余额
             A.JJFSE            AS JFFSE,     --本期借方发生额
             A.JDFSE            AS DFFSE,     --本期贷方发生额
             A.QMJFYE           AS QMJFYE,    --期末借方余额
             A.QMDFYE           AS QMDFYE,    --期末贷方余额
             V_P_DATE           AS CJRQ,
             '季报'             AS BSZQ --报送周期
        FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
       WHERE A.BZ IN ('CNY','BWB')
         AND A.BSZQ = '日报'
         AND A.CJRQ = V_P_DATE;

        V_SQLCOUNT := SQL%ROWCOUNT;
        V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
        O_ERRCODE  := SUBSTR(SQLCODE,1,30);
        V_ENDTIME  := SYSDATE;
        COMMIT;
        /*RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);*/
    END IF;

    /*判断数据日期是否为半年末*/
    IF SUBSTR(V_P_DATE, 5, 4) IN ('0630', '1231') THEN
      V_STEP_ID    := V_STEP_ID + 1;
      --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入半年报数据到临时表');
      V_STEP_DESC  := '插入半年报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
        (NBJGH,        --内部机构号
         KJKMBH,       --会计科目编号
         BZ,           --币种
         QCJFYE,       --期初借方余额
         QCDFYE,       --期初贷方余额
         JFFSE,        --本期借方发生额
         DFFSE,        --本期贷方发生额
         QMJFYE,       --期末借方余额
         QMDFYE,       --期末贷方余额
         CJRQ,
         BSZQ          --报送周期
        )
      SELECT A.NBJGH            AS NBJGH,     --内部机构号
             A.KJKMBH           AS KJKMBH,    --会计科目编号
             A.BZ               AS BZ,        --币种
             A.BNCJFYE          AS QCJFYE,    --期初借方余额
             A.BNCDFYE          AS QCDFYE,    --期初贷方余额
             A.BNJFSE           AS JFFSE,     --本期借方发生额
             A.BNDFSE           AS DFFSE,     --本期贷方发生额
             A.QMJFYE           AS QMJFYE,    --期末借方余额
             A.QMDFYE           AS QMDFYE,    --期末贷方余额
             V_P_DATE           AS CJRQ,
             '半年报'           AS BSZQ       --报送周期
        FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
       WHERE A.BZ IN ('CNY','BWB')
         AND A.BSZQ = '日报'
         AND A.CJRQ = V_P_DATE;

        V_SQLCOUNT := SQL%ROWCOUNT;
        V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
        O_ERRCODE  := SUBSTR(SQLCODE,1,30);
        V_ENDTIME  := SYSDATE;
        COMMIT;

    END IF;

    /*判断数据日期是否为年末*/
    IF SUBSTR(V_P_DATE, 5, 4) = '1231' THEN
      V_STEP_ID    := V_STEP_ID + 1;
      --V_SP_STEP_ID :=FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入年报数据到临时表');
      V_STEP_DESC := '插入年报数据到临时表';
      V_STARTTIME := SYSDATE;
      INSERT INTO RRP_EAST.TMP_401_ZZKJQKMB_BWB
        (NBJGH,        --内部机构号
         KJKMBH,       --会计科目编号
         BZ,           --币种
         QCJFYE,       --期初借方余额
         QCDFYE,       --期初贷方余额
         JFFSE,        --本期借方发生额
         DFFSE,        --本期贷方发生额
         QMJFYE,       --期末借方余额
         QMDFYE,       --期末贷方余额
         CJRQ,
         BSZQ          --报送周期
        )
      SELECT A.NBJGH            AS NBJGH,     --内部机构号
             A.KJKMBH           AS KJKMBH,    --会计科目编号
             A.BZ               AS BZ,        --币种
             A.NCJFYE           AS QCJFYE,    --期初借方余额
             A.NCDFYE           AS QCDFYE,    --期初贷方余额
             A.NJFSE            AS JFFSE,     --本期借方发生额
             A.NDFSE            AS DFFSE,     --本期贷方发生额
             A.QMJFYE           AS QMJFYE,    --期末借方余额
             A.QMDFYE           AS QMDFYE,    --期末贷方余额
             V_P_DATE           AS CJRQ,
             '年报'             AS BSZQ       --报送周期
        FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
       WHERE A.BZ IN ('CNY','BWB')
         AND A.BSZQ = '日报'
         AND A.CJRQ = V_P_DATE;

        V_SQLCOUNT := SQL%ROWCOUNT;
        V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
        O_ERRCODE  := SUBSTR(SQLCODE,1,30);
        V_ENDTIME  := SYSDATE;
        COMMIT;
        /*RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);*/
    END IF;

    /*V_STEP_ID    := V_STEP_ID + 1;
    V_SP_STEP_ID := RRP_MDL.FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'删除当日数据');
    DELETE FROM RRP_MDL.EAST5_401_ZZKJQKMB WHERE CJRQ = V_P_DATE;
    V_COUNT := SQL%ROWCOUNT;
    COMMIT;
    RRP_MDL.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', V_COUNT);*/

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP_ID    := V_STEP_ID + 1;
    --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'插入目标表');
    V_STEP_DESC  := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_401_ZZKJQKMB
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
    SELECT SYS_GUID()                     AS RID, ---数据主键
           C.FIN_PERMIT_NO                AS JRXKZH, --金融许可证号
           A.NBJGH                        AS NBJGH, --内部机构号
           C.ORG_NM                       AS YHJGMC, --银行机构名称
           A.KJKMBH                       AS KJKMBH, --会计科目编号
           GL.SUBJ_NM                     AS KJKMMC, --会计科目名称
           A.BZ                           AS BZ, --币种
           A.QCJFYE                       AS QCJFYE, --期初借方余额
           A.QCDFYE                       AS QCDFYE, --期初贷方余额
           A.JFFSE                        AS JFFSE, --本期借方发生额
           A.DFFSE                        AS DFFSE, --本期贷方发生额
           A.QMJFYE                       AS QMJFYE, --期末借方余额
           A.QMDFYE                       AS QMDFYE, --期末贷方余额
           A.BSZQ                         AS BSZQ, --报送周期
           A.CJRQ                         AS KJRQ, --会计日期
           ''                             AS BBZ, --备注
           V_MONTH_END_DATEID             AS CJRQ, --采集日期
           '000'                          AS DEPT_NO, --部门编号
           '01'                           AS SRC_SYS_ID, --来源系统ID
           '800918'                       AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0               AS ORG_NO, --报送机构
           /*CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                           AS ADDRESS, --归属地*/
           LIST.REP_ORG_ID                AS ADDRESS, --归属地
           C.GSFZJG                       AS GSFZJG --归属分支机构
      FROM RRP_EAST.TMP_401_ZZKJQKMB_BWB A
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
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
       AND A.BZ IN ('CNY', 'BWB')
       AND TRIM(GL.SUBJ_NM) IS NOT NULL;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --END IF;

  --ADD BY LIP 20220630 汇总到目标表
  V_STEP_ID    := V_STEP_ID + 1;
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'表分析');
  --表分析
  RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);
  --RRP_EAST.SP_YU_ETL_UPDATE_LOG(V_SP_STEP_ID, V_SQLERRM, '跑批正确', 0);

  V_STEP_ID    := V_STEP_ID + 1;
  --V_SP_STEP_ID := FUN_YU_ETL_INSERT_LOG(I_DATADATE,V_PROC_NAME,V_STEP_ID,'跑批结束');
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '跑批正确：['||SQLCODE||'],描述信息：'||SQLERRM;
  --O_ERRCODE := SUBSTR(SQLCODE,1,30);
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE   := 1; --将SQL错误编号赋植给O_ERRCODE
    --V_SQLERRM := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    --记录异常信息
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    --O_ERRCODE := SUBSTR(SQLCODE,1,30);
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP_ID,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
    ROLLBACK;
    RAISE;

END ETL_EAST5_401_ZZKJQKMB_20221103;
/

