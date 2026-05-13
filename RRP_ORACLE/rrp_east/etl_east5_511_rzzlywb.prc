CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_511_RZZLYWB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：融资租赁业务表
  **  存储过程名称:  ETL_EAST5_511_RZZLYWB
  **  存储过程创建日期:2022-07-14
  **  存储过程创建人:付善斌
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_LOAN_FIN_LEA_SUB C --融资租赁子表
  **        M_CUST_CORP_INFO      --对公客户信息
  **        M_LOAN_CONT_INFO E --贷款合同信息
  **  目标表:
  **         EAST5_511_RZZLYWB
  **  修改日期    修改人      修改原因
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
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_511_RZZLYWB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_511_RZZLYWB'); --表名称
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
    INSERT INTO RRP_EAST.EAST5_511_RZZLYWB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       RZZLLX, --融资租赁类型
       ZLBDW, --租赁标的物
       XYZBZDM, --币种
       XYZJE, --合同金额
       XYZYE, --合同余额
       HTYDRQ, --合同起始日期
       HTDQRQ, --合同到期日期
       CZRBH, --承租人编号
       CZRMC, --承租人名称
       CZRZH, --承租人账号
       CZRKHHMC, --承租人开户行名称
       ZLGSZJLB, --租赁公司证件类别
       ZLGSZJHM, --租赁公司证件号码
       ZLGSMC, --租赁公司名称
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
       CZRMC_ORIG, --承租人名称（脱敏前）
       ZLGSZJHM_ORIG, --租赁公司证件号码（脱敏前）
       CZRMC_OTH, --承租人是否个人客户
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           B.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           A.CONT_ID                                           AS XDHTH, --信贷合同号
           A.RCPT_ID                                           AS XDJJH, --信贷借据号
           CODE.TAR_VALUE_NAME                                AS RZZLLX, --融资租赁类型
           C.LEASE_ULYG                                        AS ZLBDW, --租赁标的物
           A.CUR                                               AS XYZBZDM, --币种
           E.CONT_AMT                                          AS XYZJE, --合同金额
           A.LOAN_BAL                                          AS XYZYE, --合同余额
           NVL(E.CONT_START_DT, '99991231')                    AS HTYDRQ, --合同起始日期
           NVL(E.CONT_EXP_DT, '99991231')                      AS HTDQRQ, --合同到期日期
           A.CUST_ID                                           AS CZRBH, --承租人编号
           --D.CUST_NM                                           AS CZRMC, --承租人名称
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                AS CZRMC, --承租人名称
           A.REPY_ACC                                          AS CZRZH, --承租人账号
           A.LOAN_REPY_ACC_OPEN_BANK_NM                        AS CZRKHHMC, --承租人开户行名称
           CASE WHEN TRIM(D.PBC_NO) IS NOT NULL AND D.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN D.PBC_NO IS NOT NULL AND D.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN D.PBC_NO IS NULL AND D.FIN_PERMIT_NO IS NOT NULL THEN '金融许可证号'
                --ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))
                ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                AS ZLGSZJLB, --租赁公司证件类别
           CASE WHEN D.PBC_NO IS NOT NULL THEN D.PBC_NO
                WHEN D.PBC_NO IS NULL AND D.FIN_PERMIT_NO IS NOT NULL THEN D.FIN_PERMIT_NO
                ELSE C.LEASE_CO_CRDL_NO
            END                                                AS ZLGSZJHM, --租赁公司证件号码
           --C.LEASE_CO_NM                                       AS ZLGSMC, --租赁公司名称
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.LEASE_CO_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.LEASE_CO_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.LEASE_CO_NM)
            END                                                AS ZLGSMC, --租赁公司名称
           C.COMM_CUR                                          AS SXFBZ, --手续费币种
           C.COMM_AMT                                          AS SXFJE, --手续费金额
           A.MRGN_PCT                                          AS BZJBL, --保证金比例
           A.MRGN_CUR                                          AS BZJBZ, --保证金币种
           A.MRGN                                              AS BZJJE, --保证金金额
           A.MRGN_ACC                                          AS BZJZH, --保证金账号
           CASE WHEN A.RCPT_STAT = 'A' THEN '正常'
                WHEN A.RCPT_STAT = 'B' THEN '逾期'
                WHEN A.RCPT_STAT = 'C0201' THEN '核销'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让'
                WHEN A.RCPT_STAT = 'C01' THEN '结清'
                ELSE '其他-' || REPLACE(CODE2.TAR_VALUE_NAME, '其他-', '')
            END                                                AS DKZT, --贷款状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           A.DEPT_LINE                                         AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           --D.CUST_NM                                           AS CZRMC_ORIG, --承租人名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                AS CZRMC_ORIG, --承租人名称（脱敏前）
           CASE WHEN D.PBC_NO IS NOT NULL THEN D.PBC_NO
                WHEN D.PBC_NO IS NULL AND D.FIN_PERMIT_NO IS NOT NULL THEN D.FIN_PERMIT_NO
                ELSE C.LEASE_CO_CRDL_NO
            END                                                AS ZLGSZJHM_ORIG, --租赁公司证件号码（脱敏前）
           '否'                                                AS CZRMC_OTH, --承租人是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG--归属分支机构*/
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_FIN_LEA_SUB C --融资租赁子表
        ON C.RCPT_ID = A.RCPT_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO E --贷款合同信息
        ON E.CONT_ID = A.CONT_ID
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.FIN_LEASE_TYP
       AND CODE.SRC_CLASS_CODE = 'D0122' --融资租赁类型
       AND CODE.TAR_CLASS_CODE = 'D0122' --融资租赁类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.LEASE_CO_CRDL_TYP
       AND CODE1.SRC_CLASS_CODE = 'C0001' --租赁公司证件类别
       AND CODE1.TAR_CLASS_CODE = 'C0001' --租赁公司证件类别
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.RCPT_STAT
       AND CODE2.SRC_CLASS_CODE = 'D0007' --借据状态
       AND CODE2.TAR_CLASS_CODE = 'D0007' --借据状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.LOAN_BIZ_TYP = '0206' --贷款业务类型 = '融资租赁'
       --AND A.CNL_ACC_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --剔除上月结清数据
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
    SELECT CJRQ,XDHTH,XDJJH,COUNT(1)
      FROM RRP_EAST.EAST5_511_RZZLYWB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,XDHTH,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_511_RZZLYWB(CJRQ,XDHTH,XDJJH)数据重复';
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

END ETL_EAST5_511_RZZLYWB;
/

