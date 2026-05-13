CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_505_STZFXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：受托支付信息表
  **  存储过程名称:  ETL_EAST5_505_STZFXXB
  **  存储过程创建日期:2022-07-13
  **  存储过程创建人:付善斌
  **  来源表:
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        ENTRS_PAY_SUB C       --受托支付子表
  **  目标表:
  **         EAST5_505_STZFXXB
  **
  **  修改日期    修改人      修改原因
  **  20221108    LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
  **  20230526    LIP         过滤支付失败的数据
  **  20230829    LIP         增加受托支付总金额
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 1;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_505_STZFXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_505_STZFXXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_MONTH_END_DATEID;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_505_STZFXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       BZ, --币种
       DKJE, --贷款金额
       STZFJE, --受托支付金额
       STZFRQ, --受托支付日期
       STZFDXZH, --受托支付对象账号
       STZFDXHM, --受托支付对象户名
       STZFDXHH, --受托支付对象行号
       STZFDXXM, --受托支付对象行名
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       STZFDXHM_ORIG, --受托支付对象户名脱敏
       STZFDXHM_OTH, --户名是否自然人名称
       GSFZJG,--归属分支机构
       STZFJEZE --受托支付金额总额 --ADD BY LIP 严希婧要求增加以便核数
       )
      WITH ENTRS_PAY_SUB AS (
    SELECT CA.RCPT_ID AS RCPT_ID,
           CA.ENTRS_PAY_OBJ_ACC ENTRS_PAY_OBJ_ACC,
           MIN(CA.ENTRS_PAY_DT) ENTRS_PAY_DT,
           SUM(CA.ENTRS_PAY_AMT) ENTRS_PAY_AMT,
           MIN(TRIM(CA.ENTRS_PAY_OBJ_PBC_NO)) ENTRS_PAY_OBJ_PBC_NO,
           MIN(TRIM(CA.ENTRS_PAY_OBJ_BANK_NM)) ENTRS_PAY_OBJ_BANK_NM,
           MIN(CA.ENTRS_PAY_OBJ_ACC_NM) ENTRS_PAY_OBJ_ACC_NM,
           MAX(CA.TOT_ENTRS_PAY_AMT) TOT_ENTRS_PAY_AMT
      FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB CA  --受托支付子表
     WHERE CA.REPORT_FLAG = 'Y' --模型增加了状态判断
       /*MOD BY LIP 20230721 根据严希婧口径:对公贷款只取成功的，未成功的业务手工补录 个人贷款部分不区分状态*/                 
       AND TO_DATE(CA.ENTRS_PAY_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TO_DATE(CA.ENTRS_PAY_DT,'YYYYMMDD') >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
       AND CA.DATA_DT = V_P_DATE
     GROUP BY CA.RCPT_ID,CA.ENTRS_PAY_OBJ_ACC)
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           B.ORG_ID                                            AS NBJGH, --内部机构号
           A.CONT_ID                                           AS XDHTH, --信贷合同号
           A.RCPT_ID                                           AS XDJJH, --信贷借据号
           A.CUR                                               AS BZ, --币种
           A.LOAN_AMT                                          AS DKJE, --贷款金额
           --C.ENTRS_PAY_AMT                                     AS STZFJE, --受托支付金额
           --MOD BY LIP 20260316 与严希婧沟通后调整：因部分受托支付金额包含了代垫金额，如果受托支付金额大于借据金额时，改成借据金额
           CASE WHEN NVL(C.ENTRS_PAY_AMT,0) > NVL(A.LOAN_AMT,0) THEN NVL(A.LOAN_AMT,0)
                ELSE NVL(C.ENTRS_PAY_AMT,0)
            END                                                AS STZFJE, --受托支付金额
           NVL(C.ENTRS_PAY_DT, '99991231')                     AS STZFRQ, --受托支付日期
           C.ENTRS_PAY_OBJ_ACC                                 AS STZFDXZH, --受托支付对象账号
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(CASE WHEN LENGTH(C.ENTRS_PAY_OBJ_ACC_NM) > 3
                    AND REGEXP_REPLACE(TRIM(C.ENTRS_PAY_OBJ_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.ENTRS_PAY_OBJ_ACC_NM),'(','（'),')','）'),' ','')
                WHEN LENGTH(C.ENTRS_PAY_OBJ_ACC_NM) > 3
                THEN C.ENTRS_PAY_OBJ_ACC_NM
                ELSE /*SUBSTRB(C.ENTRS_PAY_OBJ_ACC_NM, LENGTHB(C.ENTRS_PAY_OBJ_ACC_NM) - 2, 3)*/
                --RRP_MDL.FUN_DESENSITIZATION(C.ENTRS_PAY_OBJ_ACC_NM,0)
                TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(C.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''),0)) --MODIFY BY LIP
            END)                                               AS STZFDXHM, --受托支付对象户名
           TRIM(C.ENTRS_PAY_OBJ_PBC_NO)                        AS STZFDXHH, --受托支付对象行号
           TRIM(C.ENTRS_PAY_OBJ_BANK_NM)                       AS STZFDXXM, --受托支付对象行名
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01 '                                               AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           --C.ENTRS_PAY_OBJ_ACC_NM                              AS STZFDXHM_ORIG, --受托支付对象户名脱敏
           CASE WHEN REGEXP_REPLACE(TRIM(C.ENTRS_PAY_OBJ_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.ENTRS_PAY_OBJ_ACC_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.ENTRS_PAY_OBJ_ACC_NM)
            END                                                AS STZFDXHM_ORIG, --受托支付对象户名脱敏
           CASE WHEN LENGTH(C.ENTRS_PAY_OBJ_ACC_NM) > 3 THEN '否'
                ELSE '是'
            END                                                AS STZFDXHM_OTH, --户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG,--归属分支机构 --MODIFY BY LIP
           NVL(C.TOT_ENTRS_PAY_AMT,0)                          AS STZFJEZE --受托支付金额总额
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
     --INNER JOIN RRP_MDL.B_LOAN_ENTRS_PAY_SUB C --受托支付子表
     INNER JOIN ENTRS_PAY_SUB C --受托支付子表
        ON C.RCPT_ID = A.RCPT_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.LOAN_BIZ_TYP NOT LIKE '0205%' --剔除垫款 --ADD BY LIP 20250217 根据严希婧口径调整，剔除垫款的受托记录
       AND A.SUBJ_ID NOT LIKE '13050201%' --福费廷成本 --ADD BY LIP 20250218 根据严希婧口径调整，福费廷成本不会是受托支付
       AND A.LOAN_BIZ_TYP NOT LIKE '0204%' --过滤贸易融资数据 --ADD BY LIP 20250409
       AND A.LOAN_STD_PROD_ID NOT IN ('203030600002','203020300002') --过滤贸易融资数据 --ADD BY LIP 20250409
       AND A.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,XDJJH,STZFDXZH,COUNT(1)
      FROM RRP_EAST.EAST5_505_STZFXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,XDJJH,STZFDXZH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_505_STZFXXB(CJRQ,XDJJH,STZFDXZH)数据重复';
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

END ETL_EAST5_505_STZFXXB;
/

