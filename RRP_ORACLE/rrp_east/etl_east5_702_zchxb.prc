CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_702_ZCHXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_702_ZCHXB
  *  功能描述：资产核销表
  *  创建日期：20220712
  *  开发人员：王锐
  *  来源表： M_LOAN_CNCL_INFO  资产核销信息
              M_CUST_IND_INFO  个人客户信息
              M_CUST_CORP_INFO 对公客户信息
              M_PUM_ORG_INFO_EAST  机构表
              CODE_MAP   码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_702_ZCHXB 资产核销表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *
  ***************************************************************************/
AS
  V_P_DATE          VARCHAR2(8);      --数据日期
  V_STEP_DESC       VARCHAR2(100);    --处理步骤描述
  V_STARTTIME       DATE := SYSDATE;  --处理开始时间
  V_ENDTIME         DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT        INTEGER := 0;     --更新或删除影响的记录数
  V_COUNT           INTEGER := 0;     --数据记录条数
  V_STEP            INTEGER := 0;     --处理步骤
  V_SQLMSG          VARCHAR2(300);    --SQL执行描述信息
  V_LAST_DAT        VARCHAR2(8);      --当月月末
  V_FREQ_FLAG       VARCHAR2(10);     --跑批频度
  V_PARTITION_NAME  VARCHAR2(100);    --分区名
  V_PROC_NAME       VARCHAR2(30) := 'ETL_EAST5_702_ZCHXB'; --程序名称
  V_TABLE_NAME      VARCHAR2(100):= 'EAST5_702_ZCHXB'; --表名称
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := I_P_DATE; --获取跑批日期
  O_ERRCODE := '0';
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME); --跑批频度判断
  V_PARTITION_NAME := 'PARTITION_'||V_P_DATE; --当前日期

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    --增加分区
    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_LAST_DAT,V_TABLE_NAME,1,O_ERRCODE);

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
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_LAST_DAT, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '装入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_702_ZCHXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZCLX, --资产类型
       HTH, --合同号
       JJH, --借据号
       BZ, --币种
       HXBJ, --实核本金
       SHBNLX, --实核表内利息
       SHBWLX, --实核表外利息
       HXRQ, --核销日期
       SHBJ, --收回本金
       SHLX, --收回利息
       SHRQ, --收回日期
       SHBZ, --收回标志
       SHYGH, --收回员工号
       HXZT, --核销状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG --归属分支机构
       )
      WITH TMP1 AS (
      SELECT '2019060100019011640110471903T' XDJJH,'20200429' HXRQ,1359.27 SHBJ FROM DUAL UNION ALL
      SELECT '2019072400019011750146263883T' XDJJH,'20200429' HXRQ,475.58 SHBJ FROM DUAL UNION ALL
      SELECT '2019060300019011140177759504T' XDJJH,'20200429' HXRQ,1186.48 SHBJ FROM DUAL UNION ALL
      SELECT '2019061200019011960152361435T' XDJJH,'20200429' HXRQ,1074.85 SHBJ FROM DUAL UNION ALL
      SELECT '2019060500019011730121959823T' XDJJH,'20200429' HXRQ,1244.91 SHBJ FROM DUAL)
    SELECT SYS_GUID()                                                      AS RID, --数据主键
           D.FIN_PERMIT_NO                                                 AS JRXKZH, --金融许可证号
           D.ORG_ID                                                        AS NBJGH, --内部机构号
           A.CUST_ID                                                       AS KHTYBH, --客户统一编号
           --NVL(B.CUST_NM_DESEN, C.CUST_NM)                                 AS KHMC, --客户名称--MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN B.CUST_NM_DESEN IS NOT NULL THEN B.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                            AS KHMC, --客户名称
           /*NVL(CASE WHEN LENGTH(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]',''))= LENGTHB(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]',''))
                    THEN SUBSTR(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]','')) - 2, 3)
                    ELSE SUBSTR(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(B.CUST_NM,'[[:punct:]]','')), 1)
               END,C.CUST_NM)                                              AS KHMC, --客户名称  */ --modify by tangan at 20221209 脱敏
           CODE.TAR_VALUE_NAME                                             AS ZCLX, --资产类型
           A.CONT_ID                                                       AS HTH, --合同号
           A.RCPT_ID                                                       AS JJH, --借据号
           A.CUR                                                           AS BZ, --币种
           --A.CNCL_LN_PRIN                                                  AS HXBJ, --实核本金
           --MOD BY LIP 20240315 根据张家伟提供的excel修改4笔花呗的核销日期和本金
           COALESCE(E.SHBJ,A.CNCL_LN_PRIN)                                 AS HXBJ, --实核本金
          --A.CNCL_LN_PRIN+A.CNCL_RETRV_PRIN                                 AS HXBJ, --实核本金
           A.CNCL_IN_TAM_INT                                               AS SHBNLX, --实核表内利息
           A.CNCL_OUT_TAM_INT                                              AS SHBWLX, --实核表外利息
           --NVL(A.CNCL_DT, '99991231')                                      AS HXRQ, --核销日期
           --MOD BY LIP 20240315 根据张家伟提供的excel修改4笔花呗的核销日期和本金
           COALESCE(E.HXRQ,A.CNCL_DT,'99991231')                           AS HXRQ, --核销日期
           A.CNCL_RETRV_PRIN                                               AS SHBJ, --收回本金
           A.CNCL_RETRV_IN_TAM_INT + A.CNCL_RETRV_OUT_TAM_INT              AS SHLX, --收回利息
           NVL(A.CNCL_RETRV_DT, '99991231')                                AS SHRQ, --收回日期
           CASE WHEN A.RETRV_FLG = 'N' THEN '未收回'
                /*WHEN A.RETRV_TYP = '01' THEN '部分收回'
                WHEN A.RETRV_TYP = '02' THEN '完全收回'*/
                WHEN A.RETRV_TYP = 'N' THEN '部分收回'
                WHEN A.RETRV_TYP = 'Y' THEN '完全收回'                     --modify 20230129 LHQ 修改取值口径
            END                                                            AS SHBZ, --收回标志
           REPLACE(REPLACE(A.RETRV_EMP_NO,CHR(10),''),CHR(13),'')          AS SHYGH, --收回员工号
           REPLACE(REPLACE(CODE1.TAR_VALUE_NAME,CHR(10),''),CHR(13),'')    AS HXZT, --核销状态
           ''                                                              AS BBZ, --备注
           V_LAST_DAT                                                      AS CJRQ, --采集日期
           '000'                                                           AS DEPT_NO, --部门编号
           '01'                                                            AS SRC_SYS_ID, --来源系统ID
           '000000'                                                        AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                                AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                            AS ADDRESS, --归属地
           --NVL(B.CUST_NM,C.CUST_NM)                                        AS KHMC_ORIG, --客户名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN B.CUST_NM IS NOT NULL THEN B.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                            AS KHMC_ORIG, --客户名称（脱敏前）
           CASE WHEN B.CUST_NM IS NOT NULL THEN '是'
                ELSE '否'
            END                                                            AS KHMC_OTH, --客户是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN D.GSFZJG
                ELSE '9999'
            END                                                            AS GSFZJG --归属分支机构
       FROM RRP_MDL.M_LOAN_CNCL_INFO A --资产核销信息
     INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO A1 --表内借据表
        ON A1.RCPT_ID = A.RCPT_ID
       AND A1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = NVL(M.ORG_ID1,'800')
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.AST_TYP
       AND CODE.SRC_CLASS_CODE = 'T0017' --资产类型
       AND CODE.TAR_CLASS_CODE = 'T0017' --资产类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.CNCL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0131' --核销状态
       AND CODE1.TAR_CLASS_CODE = 'D0131' --核销状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN TMP1 E
        ON E.XDJJH = A.RCPT_ID
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = D.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE NVL(TRIM(A1.CNL_ACC_DT),'99991231') >= (CASE WHEN A1.DATA_SRC = '联合网贷' THEN TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD')
                                                        ELSE TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
                                                    END) --剔除历史销户数据
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
    SELECT CJRQ,HTH,JJH,BZ,COUNT(1)
      FROM RRP_EAST.EAST5_702_ZCHXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,HTH,JJH,BZ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_702_ZCHXB(CJRQ,HTH,JJH,BZ)数据重复';
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

  --判断跑批是否完成
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

END ETL_EAST5_702_ZCHXB;
/

