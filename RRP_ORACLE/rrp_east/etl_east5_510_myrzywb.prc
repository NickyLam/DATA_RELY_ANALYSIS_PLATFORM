CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_510_MYRZYWB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：贸易融资业务表
  **  存储过程名称:  ETL_EAST5_510_MYRZYWB
  **  存储过程创建日期:2022-07-14
  **  存储过程创建人:付善斌
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_LOAN_TRD_FNC_SUB C --贸易融资贷款子表
  **        M_CUST_CORP_INFO      --对公客户信息
  **  目标表:
  **         EAST5_510_MYRZYWB
  **  修改日期    修改人    修改原因
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_510_MYRZYWB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_510_MYRZYWB'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

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
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_510_MYRZYWB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       MYRZPZ, --贸易融资品种
       BZ, --币种
       MYRZJE, --贸易融资金额
       FKRQ, --融资发放日期
       HKRQ, --融资还款日期
       KZHMC, --开证行名称
       GHFMC, --购货方名称
       XHFMC, --销货方名称
       MYJYBJ, --贸易交易内容
       ZFDXMC, --支付对象名称
       HKDXMC, --还款对象名称
       SXFBZ, --手续费币种
       SXFJE, --手续费金额
       BZJBL, --保证金比例
       BZJBZ, --保证金币种
       BZJJE, --保证金金额
       BZJZH, --保证金账号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                        AS RID,              --数据主键
           B.FIN_PERMIT_NO                                   AS JRXKZH,           --金融许可证号
           B.ORG_ID                                          AS NBJGH,            --内部机构号
           B.ORG_NM                                          AS YHJGMC,           --银行机构名称
           A.CONT_ID                                         AS XDHTH,            --信贷合同号
           A.RCPT_ID                                         AS XDJJH,            --信贷借据号
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))           AS MYRZPZ,           --贸易融资品种 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))           AS MYRZPZ,           --贸易融资品种 --MODIFY BY LIP 20240409 改为UTF-8的长度
           A.CUR                                             AS BZ,               --币种
           A.LOAN_AMT                                        AS MYRZJE,           --贸易融资金额
           A.LOAN_ACT_DSTR_DT                                AS FKRQ,             --融资发放日期
           /*NVL(A.LAST_REPY_DT,A.LOAN_ORIG_EXP_DT)            AS HKRQ,             --融资还款日期  --MODIFY BY CAIZHENGWEI 修改融资还款日期取值逻辑，取借据表原始到期日期*/
           CASE WHEN NVL(A.LAST_REPY_DT,'99991231') NOT IN ('99991231') THEN A.LAST_REPY_DT
                ELSE A.LOAN_ORIG_EXP_DT
            END                                              AS HKRQ,             --融资还款日期 --MODIFY BY 谢宇庚 20221010借据表上次还款日期有默认值  参考旧监管逻辑
           TRIM(C.ISU_BANK_NM)                               AS KZHMC,            --开证行名称
           /*TRIM(C.BUY_SIDE_NM)                               AS GHFMC,            --购货方名称
           TRIM(C.SELL_SIDE_NM)                              AS XHFMC,            --销货方名称*/
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(SUBSTRB(CASE WHEN REGEXP_REPLACE(TRIM(C.BUY_SIDE_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.BUY_SIDE_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.BUY_SIDE_NM)
            --END,1,300))                                      AS GHFMC,            --购货方名称
            END,1,450))                                      AS GHFMC,            --购货方名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(SUBSTRB(CASE WHEN REGEXP_REPLACE(TRIM(C.SELL_SIDE_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.SELL_SIDE_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.SELL_SIDE_NM)
            --END,1,300))                                      AS XHFMC,            --销货方名称
            END,1,450))                                      AS XHFMC,            --销货方名称  --MODIFY BY LIP 20240409 改为UTF-8的长度
           --SUBSTRB(TRIM(C.TRA_CONTENT),1,1500)               AS MYJYBJ,           --贸易交易内容
           --TRIM(SUBSTRB(TRIM(C.TRA_CONTENT),1,1000))         AS MYJYBJ,           --贸易交易内容 --MODIFY BY LIP
           --TRIM(SUBSTRB(REPLACE(REPLACE(C.TRA_CONTENT,CHR(10),''),CHR(13),''),1,1000)) AS MYJYBJ, --贸易交易内容 --MODIFY BY LIP
           TRIM(SUBSTRB(REPLACE(REPLACE(C.TRA_CONTENT,CHR(10),''),CHR(13),''),1,1500)) AS MYJYBJ, --贸易交易内容 --MODIFY BY LIP 20240409 改为UTF-8的长度
           /*TRIM(C.PAY_OBJ_NM)                                AS ZFDXMC,           --支付对象名称
           TRIM(C.REPY_OBJ_NM)                               AS HKDXMC,           --还款对象名称*/
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(SUBSTRB(CASE WHEN REGEXP_REPLACE(TRIM(C.PAY_OBJ_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.PAY_OBJ_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.PAY_OBJ_NM)
            --END,1,300))                                      AS ZFDXMC,           --支付对象名称
            END,1,450))                                      AS ZFDXMC,           --支付对象名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(SUBSTRB(CASE WHEN REGEXP_REPLACE(TRIM(C.REPY_OBJ_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.REPY_OBJ_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.REPY_OBJ_NM)
            --END,1,300))                                      AS HKDXMC,           --还款对象名称
            END,1,450))                                      AS HKDXMC,           --还款对象名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           NVL(TRIM(REPLACE(C.COMM_CUR,'-','')),A.CUR)       AS SXFBZ,            --手续费币种
           C.COMM_AMT                                        AS SXFJE,            --手续费金额
           A.MRGN_PCT                                        AS BZJBL,            --保证金比例
           NVL(TRIM(REPLACE(A.MRGN_CUR,'-','')),A.CUR)       AS BZJBZ,            --保证金币种
           A.MRGN                                            AS BZJJE,            --保证金金额
           TRIM(A.MRGN_ACC)                                  AS BZJZH,            --保证金账号
           CASE WHEN A.RCPT_STAT = 'A' THEN '正常'
                WHEN A.RCPT_STAT = 'B' THEN '逾期'
                WHEN A.RCPT_STAT = 'C0201' THEN '核销'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让'
                WHEN A.RCPT_STAT = 'C01' THEN '结清'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,20)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                              AS DKZT,             --贷款状态
           ''                                                AS BBZ,              --备注
           V_MONTH_END_DATEID                                AS CJRQ,             --采集日期
           '000'                                             AS DEPT_NO,          --部门编号
           '01'                                              AS SRC_SYS_ID,       --来源系统ID
           '000000'                                          AS ISSUED_NO,        --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                    AS ORG_NO,           --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                              AS ADDRESS,          --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                              AS GSFZJG            --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_TRD_FNC_SUB C --贸易融资贷款子表
        ON C.RCPT_ID = A.RCPT_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.TRA_FNC_VRTY
       AND CODE.SRC_CLASS_CODE = 'T0006' --贸易融资品种
       AND CODE.TAR_CLASS_CODE = 'T0006' --贸易融资品种
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.RCPT_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0007' --借据状态
       AND CODE1.TAR_CLASS_CODE = 'D0007' --借据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_BIZ_TYP = '0399') --贷款业务类型='贸易融资'
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
    SELECT CJRQ,XDHTH,XDJJH,BZ,COUNT(1)
      FROM RRP_EAST.EAST5_510_MYRZYWB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,XDHTH,XDJJH,BZ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_510_MYRZYWB(CJRQ,XDHTH,XDJJH,BZ)数据重复';
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

END ETL_EAST5_510_MYRZYWB;
/

