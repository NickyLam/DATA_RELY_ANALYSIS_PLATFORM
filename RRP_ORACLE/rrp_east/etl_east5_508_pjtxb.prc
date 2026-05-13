CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_508_PJTXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：票据贴现表
  **  存储过程名称:  ETL_EAST5_508_PJTXB
  **  存储过程创建日期:2022-07-13
  **  存储过程创建人:付善斌
  **  来源表:
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_BILL_INFO           --票据票面表
  **        M_CUST_CORP_INFO      --对公客户信息
  **  目标表:
  **         EAST5_508_PJTXB
  **  修改日期    修改人      修改原因
      20221206    LHQ       根据银监反馈，需取百分比为单位的贴现利率
  ************************************************************************/
IS
  V_P_DATE         VARCHAR2(8);      --数据日期
  V_PARTITION_NAME VARCHAR2(100);    --分区名称
  V_FREQ_FLAG      VARCHAR2(10);     --跑批频度
  V_STEP           INTEGER := 0;     --任务号
  V_COUNT          INTEGER := 0;     --数据记录条数
  V_SQLCOUNT       INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME      DATE := SYSDATE;  --处理开始时间
  V_ENDTIME        DATE := SYSDATE;  --处理结束时间
  V_SQLMSG         VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC      VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME     VARCHAR2(100) := 'EAST5_508_PJTXB'; --表名称
  V_PROC_NAME      VARCHAR2(100) := 'ETL_EAST5_508_PJTXB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    --增加分区
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

    --删除当日分区数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
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
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_508_PJTXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRKHTYBH, --贴现人客户统一编号
       TXRZH, --贴现人账号
       TXRKHHMC, --贴现人开户行名称
       TXJE, --贴现金额
       TXRQ, --贴现日期
       TXJXTS, --贴现计息天数
       TXL, --贴现利率
       TXLX, --贴现利息
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,--归属分支机构
       PJHM_OLD --票据号码
       )
    SELECT SYS_GUID()                                                AS RID, --数据主键
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           B.ORG_ID                                                  AS NBJGH, --内部机构号
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           A.CONT_ID                                                 AS XDHTH, --信贷合同号
           A.RCPT_ID                                                 AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.BILL_NO)                                 AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.BILL_NO
            END                                                      AS PJHM, --票据号码 --MOD BY LIP 20240725
           CODE.TAR_VALUE_NAME                                       AS PJLX, --票据类型
           A.CUR                                                     AS BZ, --币种
           C.BILL_PAR_AMT                                            AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT,'99991231')                             AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                             AS PJDQRQ, --票据到期日期
           /*C.DRAWER_NM                                               AS CPRMC, --出票人名称
           C.ACPTR_NM                                                AS CDRMC, --承兑人名称
           D.CUST_NM                                                 AS TXRMC, --贴现人名称*/
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.DRAWER_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.DRAWER_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.DRAWER_NM)
            END                                                      AS CPRMC, --出票人名称
           CASE WHEN REGEXP_REPLACE(TRIM(C.ACPTR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.ACPTR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.ACPTR_NM)
            END                                                      AS CDRMC, --承兑人名称
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                      AS TXRMC, --贴现人名称
           A.CUST_ID                                                 AS TXRKHTYBH, --贴现人客户统一编号
           A.ETR_ACC                                                 AS TXRZH, --贴现人账号
           A.LOAN_ETR_ACC_OPEN_BANK_NM                               AS TXRKHHMC, --贴现人开户行名称
           --A.LOAN_BAL - A.INT_ADJ + A.FAIR_VAL_CHG                   AS TXJE,--贴现金额
           A.BILL_ACT_AMT                                            AS TXJE, --贴现金额 --增加BILL_ACT_AMT字段就取消注释
           NVL(A.LOAN_ACT_DSTR_DT,'99991231')                        AS TXRQ, --贴现日期
           TO_DATE(C.BILL_EXP_DT,'YYYYMMDD')-TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYYMMDD') AS TXJXTS, --贴现计息天数
           A.EXEC_RATE                                               AS TXL, --贴现利率  --20221216  LHQ 根据银监反馈，需取百分比为单位的贴现利率
           A.ACCRD_INT                                               AS TXLX, --贴现利息
           --TRIM(SUBSTR(CODE1.TAR_VALUE_NAME,1,20))                   AS PJZT, --票据状态
           CASE WHEN T.BILL_STATUS_CD = '-' THEN '其他'
                WHEN T.BILL_STATUS_CD IN ('00','30') THEN '正常'
                WHEN T.BILL_STATUS_CD IN ('42','56') THEN '解付'
                WHEN T.BILL_STATUS_CD = '21' THEN '卖断'
                WHEN T.BILL_STATUS_CD IN ('53','57','99') THEN '其他-无效'
            END                                                      AS PJZT, --票据状态
           ''                                                        AS BBZ, --备注
           V_P_DATE                                                  AS CJRQ, --采集日期
           '000'                                                     AS DEPT_NO, --部门编号
           '01'                                                      AS SRC_SYS_ID, --来源系统ID
           '000000'                                                  AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.BILL_NO)                                 AS PJHM_OLD --票据 --ADD BY LIP 20240725
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_BILL_INFO C --票据票面表
        ON C.BILL_NO = A.BILL_NO
       AND C.DATA_DT = V_P_DATE
       LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T --票据贴现信息
        ON T.BILL_ID = A.BILL_NO
       AND T.ENTRY_STATUS_CD = '03'
       AND T.DISCNT_STATUS_CD IN ('06')
       AND T.ETL_DT =  TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.LOAN_BIZ_TYP LIKE '0301%' --票据贴现业务
       AND (A.CNL_ACC_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --剔除上月结清数据
             OR A.CNL_ACC_DT IS NULL)
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
    SELECT CJRQ,NBJGH,XDHTH,XDJJH,PJHM,COUNT(1)
      FROM RRP_EAST.EAST5_508_PJTXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,NBJGH,XDHTH,XDJJH,PJHM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_508_PJTXB(CJRQ,NBJGH,XDHTH,XDJJH,PJHM)数据重复';
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

END ETL_EAST5_508_PJTXB;
/

