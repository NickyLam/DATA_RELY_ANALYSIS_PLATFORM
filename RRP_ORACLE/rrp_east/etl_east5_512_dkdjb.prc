CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_512_DKDJB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /***********************************************************************
  **  存储过程详细说明：垫款登记表
  **  存储过程名称:  ETL_EAST5_512_DKDJB
  **  存储过程创建日期:2022-07-14
  **  存储过程创建人:付善斌
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_CUST_IND_INFO      --个人客户信息
  **        M_CUST_CORP_INFO      --对公客户信息
  **        M_LOAN_CONT_INFO E --贷款合同信息
  **        M_PUM_ORG_INFO_EAST B --机构表
  **  目标表:
  **         EAST5_512_DKDJB
  **  修改日期        修改原因           修改人
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
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_512_DKDJB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_512_DKDJB'; --存储过程名称
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
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

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
    INSERT INTO RRP_EAST.EAST5_512_DKDJB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       DKLX, --垫款类型
       YHTBH, --原合同编号
       BZ, --币种
       DKJE, --垫款金额
       DKYE, --垫款余额
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       DKRQ, --垫款日期
       DKZT, --垫款状态
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
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           B.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           A.CONT_ID                                           AS XDHTH, --信贷合同号
           A.RCPT_ID                                           AS XDJJH, --信贷借据号
           CASE WHEN A.LOAN_BIZ_TYP = '020501' THEN '1.1承兑汇票'
                WHEN A.LOAN_BIZ_TYP = '020504' THEN '3.1跟单信用证'
                WHEN A.LOAN_BIZ_TYP = '02050501' THEN '1.2融资性保函'
                WHEN A.LOAN_BIZ_TYP = '02050502' THEN '2.1非融资性保函'
                WHEN A.LOAN_BIZ_TYP = '02059901' THEN '1.3其他等同于贷款的授信业务'
                WHEN A.LOAN_BIZ_TYP = '02059902' THEN '2.2其他与交易相关的或有项目'
                WHEN A.LOAN_BIZ_TYP = '02059903' THEN '3.2其他与贸易相关的或有项目'
                ELSE '其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-','')
            END                                                AS DKLX, --垫款类型
           --MODIFY BY CAIZHENGWEI 修改原始合同号取值逻辑 20220531 BEGIN
           --NVL(E.CONT_ID,A.ORIG_CONT_ID)                       AS YHTBH, --原合同编号
           A.BILL_NO                                           AS YHTBH, --原合同编号
           --MODIFY BY CAIZHENGWEI 修改原始合同号取值逻辑 20220531 END
           A.CUR                                               AS BZ, --币种
           A.LOAN_AMT                                          AS DKJE, --垫款金额
           A.LOAN_BAL                                          AS DKYE, --垫款余额
           A.CUST_ID                                           AS KHTYBH, --客户统一编号
           --NVL(D.CUST_NM_DESEN,C.CUST_NM)                      AS KHMC,    --客户名称--MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM_DESEN IS NOT NULL THEN D.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                AS KHMC,    --客户名称
           A.LOAN_ACT_DSTR_DT                                  AS DKRQ, --垫款日期
           CASE WHEN A.RCPT_STAT IN ('A', 'B') THEN '未结清'
                WHEN A.RCPT_STAT = 'C0201' THEN '核销'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让'
                --WHEN A.RCPT_STAT = 'C01' THEN '结清'
                WHEN A.RCPT_STAT = 'C01' THEN '已结清' --MOD BY LIP 20260114
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,20)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                AS DKZT, --垫款状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           --NVL(C.CUST_NM, D.CUST_NM)                           AS KHMC_ORIG, --客户名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM IS NOT NULL THEN D.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                AS KHMC_ORIG, --客户名称（脱敏前）
           CASE WHEN D.CUST_NM IS NOT NULL THEN '是'
                ELSE '否'
            END                                                AS KHMC_OTH, --客户是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG--归属分支机构 --MODIFY BY LIP,
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      --LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO E --表内借据信息
        ON E.RCPT_ID = A.ORIG_RCPT_NO
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.LOAN_BIZ_TYP
       AND CODE.SRC_CLASS_CODE = 'T0001' --垫款类型
       AND CODE.TAR_CLASS_CODE = 'T0001' --垫款类型
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
     WHERE A.LOAN_BIZ_TYP LIKE '0205%' --贷款业务类型 = '各项垫款'
       AND A.AD_CSH_FLG = '0' --ADD BY LIP 20230616 剔除过路垫款
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
    SELECT CJRQ,XDHTH,XDJJH,YHTBH,KHTYBH,COUNT(1)
      FROM RRP_EAST.EAST5_512_DKDJB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,XDHTH,XDJJH,YHTBH,KHTYBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_512_DKDJB(CJRQ,XDHTH,XDJJH,YHTBH,KHTYBH)数据重复';
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

END ETL_EAST5_512_DKDJB;
/

