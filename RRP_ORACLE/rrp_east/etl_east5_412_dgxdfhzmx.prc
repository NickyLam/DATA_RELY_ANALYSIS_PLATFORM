CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_412_DGXDFHZMX(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_412_DGXDFHZMX
  *  功能描述：对公信贷分户账明细记录
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_TRA_LOAN_DTL
  *            M_LOAN_IN_DUBILL_INFO
  *            M_CUST_CORP_INFO
  *            M_PUM_ORG_INFO_EAST
  *            M_GL_INFO
  *  目标表：  EAST5_412_DGXDFHZMX
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期   修改人      修改项目
  *  20220511   LIP         修改日志写入方式
  *  20221108   LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
  *  20230714   LIP         调整授权柜员号口径，当授权柜员号和交易柜员号相同时，将授权柜员号置空
  *  20230714   LIP         受托支付的，取受托支付对应的交易日期、交易金额及对应交易对手信息
  ***************************************************************************/
AS
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
  V_LAST_DAT       VARCHAR2(8);      --当月月末
  V_START_DAT      VARCHAR2(8);      --当月月初
  V_PROC_NAME      VARCHAR2(100) := UPPER('ETL_EAST5_412_DGXDFHZMX'); --存储过程名称
  V_TABLE_NAME     VARCHAR2(100) := UPPER('EAST5_412_DGXDFHZMX'); --表名称
BEGIN
  V_P_DATE   := TO_CHAR(I_P_DATE);
  O_ERRCODE  := '0';
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_START_DAT := SUBSTR(V_P_DATE,1,6)||'01'; --当月月初
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG  := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  IF V_FREQ_FLAG = '1' THEN
    --删除当日分区数据
    V_STEP := 1;
    V_STEP_DESC := '表分区处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_LAST_DAT,V_TABLE_NAME,1,O_ERRCODE); --新建分区

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '清空当日分区以便重跑';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_TRUNCATE(V_LAST_DAT,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理对公信贷分户账明细记录信息';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_412_DGXDFHZMX
      (RID, --数据主键
       JYXLH, --交易序列号
       YWBLJGH, --业务办理机构号
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       DKFHZH, --贷款分户账号
       XDJJH, --信贷借据号
       HXJYRQ, --核心交易日期
       HXJYSJ, --核心交易时间
       JYLX, --交易类型
       JYJDBZ, --交易借贷标志
       BZ, --币种
       JYJE, --交易金额
       ZHYE, --账户余额
       DFZH, --对方账号
       DFHM, --对方户名
       DFXH, --对方行号
       DFXM, --对方行名
       ZY, --摘要
       JYQD, --交易渠道
       CBMBZ, --冲补抹标志
       JYGYH, --交易柜员号
       SQGYH, --授权柜员号
       XZBZ, --现转标志
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       DFHM_ORIG, --对方户名（脱敏前）
       DFHM_OTH, --户名是否自然人名称
       GSFZJG --归属分支机构
       )
      WITH LOAN_ENTRS_PAY_SUB AS (
    SELECT TA.RCPT_ID,      --借据编号
           TA.PAY_FLOW_NUM,
           TA.ENTRS_PAY_AMT,
           TA.ENTRS_PAY_DT,        --受托支付日期
           TA.ENTRS_PAY_OBJ_ACC,   --受托支付对象账号
           TA.ENTRS_PAY_OBJ_ACC_NM,  --受托支付对象户名
           CASE WHEN LENGTH(TA.ENTRS_PAY_OBJ_ACC_NM) > 3
                AND REGEXP_REPLACE(TRIM(TA.ENTRS_PAY_OBJ_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(TA.ENTRS_PAY_OBJ_ACC_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(TA.ENTRS_PAY_OBJ_ACC_NM),'[[:punct:]]',''),0))
            END DFHM,
           CASE WHEN LENGTH(TA.ENTRS_PAY_OBJ_ACC_NM) > 3
                THEN '否'
                ELSE '是'
            END DFHM_OTH,
           TA.ENTRS_PAY_OBJ_PBC_NO,  --受托支付对象行号
           TA.ENTRS_PAY_OBJ_BANK_NM, --受托支付对象行名
           CASE WHEN TA.ENTRS_PAY_AMT > T.DISTR_AMT THEN T.DISTR_AMT
                ELSE TA.ENTRS_PAY_AMT
            END JYJE, --交易金额 交易金额大于借据金额时，包含了代客支付金额，交易金额就是借据金额
           SUM(TA.ENTRS_PAY_AMT) OVER(PARTITION BY TA.RCPT_ID) TOT_JYJE,
           T.DISTR_AMT,
           CASE WHEN T.LOAN_BIZ_TYP LIKE '0204%' OR T.LOAN_STD_PROD_ID IN ('203030600002','203020300002')
                THEN T.DISTR_AMT --贸易融资数据用放款金额 --MOD BY LIP 20250409
                ELSE TA.TOT_ENTRS_PAY_AMT
            END TOT_ENTRS_PAY_AMT
      FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB TA --受托支付子表
     INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO T
        ON T.RCPT_ID = TA.RCPT_ID
       AND T.DATA_SRC = '对公信贷'
       AND T.LOAN_BIZ_TYP NOT LIKE '0205%' --剔除垫款 --ADD BY LIP 20250217 根据严希婧口径调整，剔除垫款的受托记录
       AND T.DISTR_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
       AND T.DISTR_DT <= V_P_DATE
       AND T.DATA_DT = V_P_DATE
     WHERE TA.REPORT_FLAG = 'Y'
       AND TA.DATA_DT = V_P_DATE),
    LOAN_ENTRS_PAY_SUB_TMP AS (--ADD BY LIP 20241112 部分受托支付的将剩余部分的插入明细
    SELECT * FROM LOAN_ENTRS_PAY_SUB UNION ALL 
    SELECT DISTINCT RCPT_ID,NULL PAY_FLOW_NUM,DISTR_AMT - TOT_ENTRS_PAY_AMT AS ENTRS_PAY_AMT,NULL ENTRS_PAY_DT,NULL ENTRS_PAY_OBJ_ACC,
           NULL ENTRS_PAY_OBJ_ACC_NM,NULL DFHM,NULL DFHM_OTH,NULL ENTRS_PAY_OBJ_PBC_NO,NULL ENTRS_PAY_OBJ_BANK_NM,
           DISTR_AMT - TOT_ENTRS_PAY_AMT AS JYJE,NULL TOT_JYJE,NULL DISTR_AMT,NULL TOT_ENTRS_PAY_AMT
      FROM LOAN_ENTRS_PAY_SUB
     WHERE DISTR_AMT > TOT_ENTRS_PAY_AMT --取部分受托支付的
       AND TOT_ENTRS_PAY_AMT <> 0)
    SELECT /*+USE_HASH(A,DUB,C,B,D,CODE1,CODE2,CODE3,CODE4,CODE5,ORG,LIST)*/
           SYS_GUID()                                                    AS RID, --数据主键
           --A.TRA_SEQ_NO                                                  AS JYXLH, --交易序列号
           --MOD BY LIP 20231012 受托支付的可能对应多条，用流水号和支付流水号拼接
           A.TRA_SEQ_NO||SUB.PAY_FLOW_NUM                                AS JYXLH, --交易序列号
           BB.ORG_ID                                                     AS YWBLJGH, --业务办理机构号
           B.FIN_PERMIT_NO                                               AS JRXKZH, --金融许可证号
           B.ORG_ID                                                      AS NBJGH, --内部机构号
           B.ORG_NM                                                      AS YHJGMC, --银行机构名称
           --SUBSTR(A.SUBJ_ID,1,8)                                         AS MXKMBH, --明细科目编号
           --转贴现卖出的借据模型没取到科目号
           SUBSTR(NVL(TRIM(A.SUBJ_ID),DUB.SUBJ_ID),1,8)                   AS MXKMBH, --明细科目编号
           D.SUBJ_NM                                                      AS MXKMMC, --明细科目名称
           --A.CUST_ID                                                     AS KHTYBH, --客户统一编号
           DUB.CUST_ID                                                    AS KHTYBH, --客户统一编号
           --C.CUST_NM                                                     AS ZHMC, --账户名称
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                          AS ZHMC, --账户名称
           --A.ACC_ID                                                      AS DKFHZH, --贷款分户账号
           DUB.ACC_ID                                                    AS DKFHZH, --贷款分户账号 MODIFY BY LIP 20220502
           A.RCPT_ID                                                     AS XDJJH, --信贷借据号
           --A.TRA_DT                                                      AS HXJYRQ, --核心交易日期 MODIFY BY LIP 20220509
           --MOD BY LIP 20231012 受托支付取受托支付表的支付日期
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.ENTRS_PAY_DT
                ELSE A.TRA_DT
            END                                                          AS HXJYRQ, --核心交易日期 MODIFY BY LIP 20231013
           NVL(TO_CHAR(A.TRA_TM,'HH24MISS'),'000000')                    AS HXJYSJ, --核心交易时间
           /*CASE WHEN TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40)) IS NOT NULL
                THEN TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))
            END                                                          AS JYLX, --交易类型*/
           CASE WHEN TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60)) IS NOT NULL
                THEN TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))
            END                                                          AS JYLX, --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE2.TAR_VALUE_NAME                                          AS JYJDBZ, --交易借贷标志
           CASE WHEN TRIM(A.CUR) = '-' THEN TRIM(DUB.CUR)
                ELSE TRIM(A.CUR)
            END                                                          AS BZ, --币种
           --A.TRA_AMT                                                     AS JYJE, --交易金额
           --MOD BY LIP 20231012 优先取受托支付表的交易金额，因为受托金额中含有代客户付的金额，所以如果金额大于借据金额，则取借据金额
           --MDO BY LIP 20240312 福费廷贷款发放的交易金额取核心登记的交易金额
           CASE WHEN DUB.LOAN_BIZ_TYP LIKE '0204%' OR DUB.LOAN_STD_PROD_ID IN ('203030600002','203020300002')
                THEN A.TRA_AMT --MOD BY LIP 20250409
                WHEN DUB.LOAN_STD_PROD_ID IN ('203020300001','203020300002','203030600001','203030600002')
                     AND A.TRA_TYP = '11' THEN A.TRA_AMT
                WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL AND SUB.JYJE > DUB.DISTR_AMT THEN DUB.DISTR_AMT
                WHEN SUB.RCPT_ID IS NOT NULL THEN SUB.JYJE
                ELSE A.TRA_AMT
            END                                                          AS JYJE, --交易金额
           A.ACC_BAL                                                     AS ZHYE, --账户余额
           --A.OPP_ACC                                                     AS DFZH, --对方账号
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.ENTRS_PAY_OBJ_ACC
                WHEN A.OPP_ACC IS NOT NULL THEN A.OPP_ACC
                WHEN A.ABSTR LIKE '%利息入账' THEN A.RCPT_ID
                WHEN CODE1.TAR_VALUE_NAME LIKE '%还%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.REPY_ACC
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.ETR_ACC
            END                                                          AS DFZH, --对方账号 --MODIFY BY LIP
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.DFHM
                --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN A.CORP_IND_FLG = '1' AND TRIM(A.OPP_ACC_NM) IS NOT NULL THEN
                     /*SUBSTRB(A.OPP_ACC_NM,LENGTHB(A.OPP_ACC_NM) - 2,3)*/
                     --RRP_MDL.FUN_DESENSITIZATION(A.OPP_ACC_NM,0)--考虑不同字符集，截取方式不同
                     TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''),0))
                WHEN TRIM(A.OPP_ACC_NM) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(A.OPP_ACC_NM) IS NOT NULL
                THEN TRIM(A.OPP_ACC_NM)
                WHEN A.ABSTR LIKE '%利息入账'
                     AND REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                WHEN A.ABSTR LIKE '%利息入账'
                THEN C.CUST_NM
                WHEN CODE1.TAR_VALUE_NAME LIKE '%还%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.REPY_ACC
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                     AND REGEXP_REPLACE(TRIM(DUB.ETR_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(DUB.ETR_ACC_NM),'(','（'),')','）'),' ','')
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.ETR_ACC_NM
            END                                                          AS DFHM, --对方户名
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.ENTRS_PAY_OBJ_PBC_NO
                WHEN A.OPP_PBC_NO IS NOT NULL THEN A.OPP_PBC_NO
                WHEN A.ABSTR LIKE '%利息入账' THEN B.PBC_NO
            END                                                          AS DFXH, --对方行号
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.ENTRS_PAY_OBJ_BANK_NM
                WHEN A.OPP_BANK_NM IS NOT NULL THEN A.OPP_BANK_NM
                WHEN A.ABSTR LIKE '%利息入账' THEN B.ORG_NM
                WHEN CODE1.TAR_VALUE_NAME LIKE '%还%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.LOAN_REPY_ACC_OPEN_BANK_NM
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.LOAN_ETR_ACC_OPEN_BANK_NM
            END                                                          AS DFXM, --对方行名
           --REPLACE(REPLACE(TRIM(A.ABSTR),CHR(10),''),CHR(13),'')         AS ZY, --摘要
           TRIM(REPLACE(REPLACE(REGEXP_REPLACE(A.ABSTR,'[· ？！?!$%^#°*?!^|       /-]',''),CHR(10),''),CHR(13),'')) AS ZY, --摘要
           --TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))                     AS JYQD, --交易渠道
           TRIM(SUBSTRB(CASE WHEN CODE5.TAR_VALUE_NAME LIKE '三方支付%'
                             THEN REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付')
                             ELSE CODE5.TAR_VALUE_NAME
            --END,1,40))                                                   AS JYQD, --交易渠道 --MODIFY BY LIP
            END,1,60))                                                   AS JYQD, --交易渠道 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE3.TAR_VALUE_NAME                                          AS CBMBZ, --冲补抹标志
           TRIM(A.TRA_TLR_NO)                                            AS JYGYH, --交易柜员号
           --A.GRANT_TLR_NO                                                AS SQGYH, --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           --CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40)) NOT IN ('柜面')
           CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
                THEN NULL
                ELSE TRIM(A.GRANT_TLR_NO)
            END                                                          AS SQGYH, --授权柜员号
           CODE4.TAR_VALUE_NAME                                          AS XZBZ, --现转标志
           CASE WHEN A.ABSTR = '核销' THEN '核销交易'
                WHEN A.ABSTR LIKE '%转让%' THEN '转让交易'
            END                                                          AS BBZ, --备注
           V_LAST_DAT                                                    AS CJRQ, --采集日期
           '000'                                                         AS DEPT_NO, --部门编号
           '01'                                                          AS SRC_SYS_ID, --来源系统ID
           '000000'                                                      AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                              AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                          AS ADDRESS, --归属地
           --A.OPP_ACC_NM                                                  AS DFHM_ORIG, --对方户名（脱敏前）
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.ENTRS_PAY_OBJ_ACC_NM
                --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN A.CORP_IND_FLG = '1' AND TRIM(A.OPP_ACC_NM) IS NOT NULL THEN TRIM(A.OPP_ACC_NM)
                WHEN TRIM(A.OPP_ACC_NM) IS NOT NULL
                     AND REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(A.OPP_ACC_NM) IS NOT NULL
                THEN TRIM(A.OPP_ACC_NM)
                WHEN A.ABSTR LIKE '%利息入账'
                     AND REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                WHEN A.ABSTR LIKE '%利息入账'
                THEN C.CUST_NM
                WHEN CODE1.TAR_VALUE_NAME LIKE '%还%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.REPY_ACC
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                     AND REGEXP_REPLACE(TRIM(DUB.ETR_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(DUB.ETR_ACC_NM),'(','（'),')','）'),' ','')
                WHEN CODE1.TAR_VALUE_NAME LIKE '%票据买断式转贴现%' AND NVL(A.ABSTR,' ') <> '核销'
                THEN DUB.ETR_ACC_NM
            END                                                          AS DFHM_ORIG, --对方户名（脱敏前）
           --MOD BY LIP 20231012 优先取受托支付表的对方信息
           CASE WHEN SUB.RCPT_ID IS NOT NULL AND SUB.PAY_FLOW_NUM IS NOT NULL THEN SUB.DFHM_OTH
                WHEN A.CORP_IND_FLG = '1' THEN '是'
                ELSE '否'
           END                                                           AS DFHM_OTH, --户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                          AS GSFZJG  --归属分支机构
      FROM RRP_MDL.M_TRA_LOAN_DTL A --信贷账户交易流水
     INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO DUB --表内借据信息 ADD BY LIP 20220502 用借据限制流水
        ON DUB.RCPT_ID = A.RCPT_ID
       AND (DUB.LOAN_BIZ_TYP NOT LIKE '01%' OR DUB.LOAN_BIZ_TYP LIKE '90%')
       AND DUB.LOAN_BIZ_TYP <> '99'
       AND DUB.AD_CSH_FLG = '0' --ADD BY LIP 20230616 剔除过路垫款
       AND DUB.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND DUB.DATA_DT = V_LAST_DAT
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息 MODIFY BY LIP 20220510
        ON C.CUST_ID = DUB.CUST_ID
       AND C.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG M1 --机构映射表
        ON M1.ORG_ID = A.TRA_ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST BB --机构表
        ON BB.ORG_ID = NVL(M1.ORG_ID1,'800')
       AND BB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(NVL(TRIM(A.SUBJ_ID),DUB.SUBJ_ID),1,8)---科目报送到三级
       --AND D.DATA_DT = V_P_DATE
       AND D.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_TYP
       AND CODE1.SRC_CLASS_CODE = 'CD1311' --交易类型
       AND CODE1.TAR_CLASS_CODE = 'D0121' --交易类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.TRA_DR_CR_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0017' --交易借贷标志
       AND CODE2.TAR_CLASS_CODE = 'Z0017' --交易借贷标志
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.FLUSH_PATCH_FLG
       AND CODE3.SRC_CLASS_CODE = 'D0128' --冲补抹标志
       AND CODE3.TAR_CLASS_CODE = 'D0128' --冲补抹标志
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.CASH_TRF_FLG
       AND CODE4.SRC_CLASS_CODE = 'Z0019' --现转标志
       AND CODE4.TAR_CLASS_CODE = 'Z0019' --现转标志
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.TRA_CHAN
       AND CODE5.SRC_CLASS_CODE = 'Z0014' --交易渠道
       AND CODE5.TAR_CLASS_CODE = 'Z0014' --交易渠道
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
      --LEFT JOIN LOAN_ENTRS_PAY_SUB SUB
      LEFT JOIN LOAN_ENTRS_PAY_SUB_TMP SUB --MOD BY LIP 20241112
        ON SUB.RCPT_ID = A.RCPT_ID
       AND A.DATA_SRC = '对公贷款放款'
     WHERE A.CORP_IND_FLG = '2' --对公
       --AND NVL(A.ABSTR,'1') NOT IN ('票据追索结清')
       --MOD BY LIP 20240105 过滤金数的票据追索数据，追索的取imas部分的
       AND NVL(A.DATA_SRC,'1') NOT IN ('票据追索结清')
       AND A.TRA_DT <= V_LAST_DAT
       --AND A.TRA_DT >= V_START_DAT
       AND A.TRA_DT >= TO_CHAR(TO_DATE(V_START_DAT,'YYYYMMDD')-1,'YYYYMMDD') --MOD BY LIP 20250304 微业贷数据T+2
       AND A.DATA_DT <= V_LAST_DAT
       AND A.DATA_DT >= V_START_DAT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,JYXLH,DKFHZH,XDJJH,HXJYRQ,HXJYSJ,COUNT(1)
      FROM RRP_EAST.EAST5_412_DGXDFHZMX T
     WHERE CJRQ = V_LAST_DAT
     GROUP BY CJRQ,JYXLH,DKFHZH,XDJJH,HXJYRQ,HXJYSJ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_412_DGXDFHZMX(CJRQ,JYXLH,DKFHZH,XDJJH,HXJYRQ,HXJYSJ)数据重复';
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
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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

END ETL_EAST5_412_DGXDFHZMX;
/

