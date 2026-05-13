CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_904_WTDKXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_904_WTDKXXB
  *  功能描述：委托贷款信息表
  *  创建日期：20220714
  *  开发人员：王锐
  *  来源表： M_LOAN_ENTRS_SUB  委托贷款子表
              M_LOAN_IN_DUBILL_INFO  表内借据信息
              M_PUM_ORG_INFO_EAST   机构表
              M_CUST_CORP_INFO   对公客户信息
              M_CUST_IND_INFO   个人客户信息
              M_GL_INFO     总账会计科目信息表
              CODE_MAP CODE  --码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_904_WTDKXXB   委托贷款信息表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *
  ***************************************************************************/
AS
  V_P_DATE           VARCHAR2(8);    --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);  --分区名称
  V_FREQ_FLAG        VARCHAR2(10);   --跑批频度
  V_STEP             INTEGER := 0;   --任务号
  V_COUNT            INTEGER := 0;   --数据记录条数
  V_STARTTIME        DATE := SYSDATE;--处理开始时间
  V_ENDTIME          DATE := SYSDATE;--处理结束时间
  V_SQLCOUNT         INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);  --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_904_WTDKXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_904_WTDKXXB'); --表名称
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
    V_STEP_DESC := '装入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_904_WTDKXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       HTBH, --信贷合同号
       XDJJH, --信贷借据号
       WTDKLX, --委托贷款类型
       BZ, --币种
       DKJE, --合同金额
       HTQSRQ, --合同起始日期
       HTDQRQ, --合同到期日期
       WTRBH, --委托人编号
       WTRMC, --委托人名称
       WTRZH, --委托人账号
       WTRKHHMC, --委托人开户行名称
       SYRMC, --受益人名称
       SYRZH, --受益人账号
       SYRKHHMC, --受益人开户行名称
       SFSX, --是否收息
       SXFBZ, --手续费币种
       SXFJE, --手续费金额
       KHJLGH, --经办人工号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       SYRMC_ORIG, --受益人名称（脱敏前）
       WTRMC_ORIG, --委托人名称（脱敏前）
       WTRMC_OTH, --委托人是否个人
       SYRMC_OTH, --受益人是否个人
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                                           AS RID, --数据主键
           C.FIN_PERMIT_NO                                                      AS JRXKZH, --金融许可证号
           C.ORG_ID                                                             AS NBJGH, --内部机构号
           C.ORG_NM                                                             AS YHJGMC, --银行机构名称
           SUBSTR(B.SUBJ_ID, 1, 8)                                              AS MXKMBH, --明细科目编号
           F.SUBJ_NM                                                            AS MXKMMC, --明细科目名称
           B.CONT_ID                                                            AS HTBH, --信贷合同号
           A.RCPT_ID                                                            AS XDJJH, --信贷借据号
           CASE WHEN A.CONSR_TYP = '04' THEN '公积金贷款'
                WHEN A.ENTRS_LOAN_SUM_CL = '9011' THEN '现金管理项下委托贷款'
                WHEN A.ENTRS_LOAN_SUM_CL = '9012' THEN '非现金管理项下委托贷款'
            END                                                                 AS WTDKLX, --委托贷款类型
           B.CUR                                                                AS BZ, --币种
           B.LOAN_AMT                                                           AS DKJE, --合同金额
           NVL(B.LOAN_ACT_DSTR_DT, '99991231')                                  AS HTQSRQ, --合同起始日期
           NVL(B.LOAN_ACT_EXP_DT, '99991231')                                   AS HTDQRQ, --合同到期日期
           A.CONSR_CUST_ID                                                      AS WTRBH, --委托人编号
           --NVL(D.CUST_NM,E.CUST_NM_DESEN)                                       AS WTRMC, --委托人名称  --MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN E.CUST_NM_DESEN IS NOT NULL THEN E.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                                 AS WTRMC, --委托人名称
           A.ENTRS_ACC                                                          AS WTRZH, --委托人账号
           A.CONSR_OPEN_BANK_NM                                                 AS WTRKHHMC, --委托人开户行名称
           --NVL(D1.CUST_NM,E1.CUST_NM_DESEN)                                     AS WTRMC, --委托人名称  --MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN E1.CUST_NM_DESEN IS NOT NULL THEN E1.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(D1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D1.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D1.CUST_NM)
            END                                                                 AS SYRMC, --受益人名称
           B.ETR_ACC                                                            AS SYRZH, --受益人账号
           B.LOAN_ETR_ACC_OPEN_BANK_NM                                          AS SYRKHHMC, --受益人开户行名称
           CODE.TAR_VALUE_NAME                                                  AS SFSX, --是否收息
           A.COMM_CUR                                                           AS SXFBZ, --手续费币种
           NVL(A.COMM_AMT,0.00)                                                 AS SXFJE, --手续费金额
           A.HDLR_NO                                                            AS KHJLGH, --经办人工号
           CASE WHEN B.RCPT_STAT = 'A' THEN '正常'
                WHEN B.RCPT_STAT = 'B' THEN '逾期'
                WHEN B.RCPT_STAT = 'C0201' THEN '核销'
                WHEN B.RCPT_STAT LIKE 'C0202%' THEN '转让'
                WHEN B.RCPT_STAT = 'C01' THEN '结清'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                                 AS DKZT, --贷款状态
           ''                                                                   AS BBZ, --备注
           V_MONTH_END_DATEID                                                   AS CJRQ, --采集日期
           '000'                                                                AS DEPT_NO, --部门编号
           '01'                                                                 AS SRC_SYS_ID, --来源系统ID
           '000000'                                                             AS ISSUED_NO, --填报机构
           '000000'                                                             AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                                 AS ADDRESS, --归属地
           /*NVL(D1.CUST_NM,E1.CUST_NM)                                           AS SYRMC_ORIG, --受益人名称（脱敏前）
           NVL(D.CUST_NM,E.CUST_NM)                                             AS WTRMC_ORIG, --委托人名称（脱敏前）*/
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN E1.CUST_NM IS NOT NULL THEN E1.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(D1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D1.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D1.CUST_NM)
            END                                                                 AS SYRMC_ORIG, --受益人名称（脱敏前）
           CASE WHEN E.CUST_NM IS NOT NULL THEN E.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                                 AS WTRMC_ORIG, --委托人名称（脱敏前）
           CASE WHEN E.CUST_NM IS NOT NULL THEN '是' ELSE '否' END              AS WTRMC_OTH, --委托人是否个人
           CASE WHEN E1.CUST_NM IS NOT NULL THEN '是' ELSE '否' END             AS SYRMC_OTH, --受益人是否个人
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                                 AS GSFZJG--归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_LOAN_ENTRS_SUB A --委托贷款子表
     INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO B --表内借据信息
        ON B.RCPT_ID = A.RCPT_ID
       AND B.LOAN_BIZ_TYP = '90' --委托贷款
       AND B.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CONSR_CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST E --个人客户信息
        ON E.CUST_ID = A.CONSR_CUST_ID
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D1 --对公客户信息
        ON D1.CUST_ID = B.CUST_ID
       AND D1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST E1 --个人客户信息
        ON E1.CUST_ID = B.CUST_ID
       AND E1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO F --总账会计科目信息表
        ON F.SUBJ_ID = SUBSTR(B.SUBJ_ID,1,8) ---科目报送到三级
       AND F.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.INT_COLL_FLG
       AND CODE.SRC_CLASS_CODE = 'Z0001' --是否收息
       AND CODE.TAR_CLASS_CODE = 'Z0001' --是否收息
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = B.RCPT_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0007' --借据状态
       AND CODE1.TAR_CLASS_CODE = 'D0007' --借据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20241018 增加现金管理项下委托贷款取数来源
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '装入目标表--现金管理项下委托贷款';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_904_WTDKXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       HTBH, --信贷合同号
       XDJJH, --信贷借据号
       WTDKLX, --委托贷款类型
       BZ, --币种
       DKJE, --合同金额
       HTQSRQ, --合同起始日期
       HTDQRQ, --合同到期日期
       WTRBH, --委托人编号
       WTRMC, --委托人名称
       WTRZH, --委托人账号
       WTRKHHMC, --委托人开户行名称
       SYRMC, --受益人名称
       SYRZH, --受益人账号
       SYRKHHMC, --受益人开户行名称
       SFSX, --是否收息
       SXFBZ, --手续费币种
       SXFJE, --手续费金额
       KHJLGH, --经办人工号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       SYRMC_ORIG, --受益人名称（脱敏前）
       WTRMC_ORIG, --委托人名称（脱敏前）
       WTRMC_OTH, --委托人是否个人
       SYRMC_OTH, --受益人是否个人
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                                           AS RID, --数据主键
           C.FIN_PERMIT_NO                                                      AS JRXKZH, --金融许可证号
           C.ORG_ID                                                             AS NBJGH, --内部机构号
           C.ORG_NM                                                             AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID, 1, 8)                                              AS MXKMBH, --明细科目编号
           F.SUBJ_NM                                                            AS MXKMMC, --明细科目名称
           A.CONT_ID                                                            AS HTBH, --信贷合同号
           A.RCPT_ID                                                            AS XDJJH, --信贷借据号
           CASE WHEN A.CONSR_TYP = '04' THEN '公积金贷款'
                WHEN A.ENTRS_LOAN_SUM_CL = '9011' THEN '现金管理项下委托贷款'
                WHEN A.ENTRS_LOAN_SUM_CL = '9012' THEN '非现金管理项下委托贷款'
            END                                                                 AS WTDKLX, --委托贷款类型
           A.CUR                                                                AS BZ, --币种
           A.ENTRS_AMT                                                          AS DKJE, --合同金额
           NVL(A.AGRT_START_DT,'99991231')                                      AS HTQSRQ, --合同起始日期
           NVL(A.AGRT_EXP_DT,'99991231')                                        AS HTDQRQ, --合同到期日期
           A.CONSR_CUST_ID                                                      AS WTRBH, --委托人编号
           CASE WHEN E.CUST_NM_DESEN IS NOT NULL THEN E.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                                 AS WTRMC, --委托人名称
           A.ENTRS_ACC                                                          AS WTRZH, --委托人账号
           A.CONSR_OPEN_BANK_NM                                                 AS WTRKHHMC, --委托人开户行名称
           CASE WHEN E1.CUST_NM_DESEN IS NOT NULL THEN E1.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(D1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D1.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D1.CUST_NM)
            END                                                                 AS SYRMC, --受益人名称
           A.ETR_ACC                                                            AS SYRZH, --受益人账号
           A.ETR_ACC_OPEN_BANK_NM                                               AS SYRKHHMC, --受益人开户行名称
           CODE.TAR_VALUE_NAME                                                  AS SFSX, --是否收息
           A.COMM_CUR                                                           AS SXFBZ, --手续费币种
           NVL(A.COMM_AMT,0.00)                                                 AS SXFJE, --手续费金额
           TRIM(A.HDLR_NO)                                                      AS KHJLGH, --经办人工号
           A.AGRT_STAT                                                          AS DKZT, --贷款状态
           ''                                                                   AS BBZ, --备注
           V_MONTH_END_DATEID                                                   AS CJRQ, --采集日期
           '000'                                                                AS DEPT_NO, --部门编号
           '01'                                                                 AS SRC_SYS_ID, --来源系统ID
           '000000'                                                             AS ISSUED_NO, --填报机构
           '000000'                                                             AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                                 AS ADDRESS, --归属地
           CASE WHEN E1.CUST_NM IS NOT NULL THEN E1.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(D1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D1.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D1.CUST_NM)
            END                                                                 AS SYRMC_ORIG, --受益人名称（脱敏前）
           CASE WHEN E.CUST_NM IS NOT NULL THEN E.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                                 AS WTRMC_ORIG, --委托人名称（脱敏前）
           CASE WHEN E.CUST_NM IS NOT NULL THEN '是' ELSE '否' END              AS WTRMC_OTH, --委托人是否个人
           CASE WHEN E1.CUST_NM IS NOT NULL THEN '是' ELSE '否' END             AS SYRMC_OTH, --受益人是否个人
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                                 AS GSFZJG--归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_LOAN_ENTRS_SUB A --委托贷款子表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.HDL_ORG_NM
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CONSR_CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST E --个人客户信息
        ON E.CUST_ID = A.CONSR_CUST_ID
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D1 --对公客户信息
        ON D1.CUST_ID = A.ETR_CUST_ID
       AND D1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST E1 --个人客户信息
        ON E1.CUST_ID = A.ETR_CUST_ID
       AND E1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO F --总账会计科目信息表
        ON F.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8) ---科目报送到三级
       AND F.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.INT_COLL_FLG
       AND CODE.SRC_CLASS_CODE = 'Z0001' --是否收息
       AND CODE.TAR_CLASS_CODE = 'Z0001' --是否收息
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.ENTRS_LOAN_SUM_CL = '9011' --现金管理项下委托贷款
       AND NVL(A.AGRT_START_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1，'YYYYMMDD')
       AND NVL(A.AGRT_START_DT,'99991231') <= V_P_DATE --只需要报送本月发放的现金管理的贷款数据
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
    SELECT CJRQ,HTBH,XDJJH,COUNT(1)
      FROM RRP_EAST.EAST5_904_WTDKXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,HTBH,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_904_WTDKXXB(CJRQ,HTBH,XDJJH)数据重复';
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

END ETL_EAST5_904_WTDKXXB;
/

