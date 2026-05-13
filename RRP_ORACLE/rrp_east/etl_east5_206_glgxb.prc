CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_206_GLGXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：关联关系表
  **  存储过程名称:  ETL_EAST5_206_GLGXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人      修改原因
  **  20220524     付善斌      填报机构源调整
  **  20220531     付善斌      关联人编号与客户编号一致问题
  **  20220601     付善斌      归属机构逻辑添加
  **  20220605     付善斌      当关联人证件号码取不到情况处理
  **  20220608     付善斌      增加关联限制表
  **  20220620     付善斌      关联关系和码值表关联条件调整
  **  20220629     LIP         修改日志记录格式，修改字段超长、字段换行问题
  **  20230427     LIP         将客户名称全是中文的()改为（）
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_206_GLGXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_206_GLGXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG  := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '关联关系表-插入临时表1';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.M_CUST_CORP_REL_SUB_TMP';
    INSERT INTO RRP_EAST.M_CUST_CORP_REL_SUB_TMP
      (DATA_DT,              --数据日期
       LGL_REP_ID,           --法人编号
       CUST_ID,              --客户编号
       REL_TYP,              --关系类型
       REL_PSN_TYP,          --关联人类型
       REL_PSN_CUST_NM,      --关联人客户名称
       REL_PSN_CUST_ID,      --关联人客户编号
       REL_PSN_CTRY_CD,      --关联人国家代码
       REL_PSN_CRDL_TYP,     --关联人证件类型
       REL_PSN_CRDL_NO,      --关联人证件号码
       PBC_NO,               --人行支付行号
       FIN_PERMIT_NO,        --金融许可证号
       ACT_CNTLR_FLG,        --实际控制人标志
       ACT_CNTLR_TYP,        --实际控制人类型
       REGD_CD_RSK,          --登记注册代码（客户风险）
       UPD_INFO_DT,          --更新信息日期
       SENIOR_IMPT_PSN_FLG,  --高管及重要联系人标志
       REL_STAT,             --关联关系状态
       PP1_NO,               --护照1号码
       PP1_ISU_DT,           --护照1签发日期
       PP1_EXP_DT,           --护照1到期日期
       PP2_NO,               --护照2号码
       PP2_ISU_DT,           --护照2签发日期
       PP2_EXP_DT,           --护照2到期日期
       PP3_NO,               --护照3号码
       PP3_ISU_DT,           --护照3签发日期
       PP3_EXP_DT,           --护照3到期日期
       OTH_CRDL_TYP1,        --其他证件类型1
       OTH_CRDL_NO1,         --其他证件号码1
       OTH_CRDL_TYP2,        --其他证件类型2
       OTH_CRDL_NO2,         --其他证件号码2
       DEPT_LINE,            --部门条线
       DATA_SRC              --数据来源
       )
      WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/A.DATA_DT         AS DATA_DT,              --数据日期
           A.LGL_REP_ID                      AS LGL_REP_ID,           --法人编号
           A.CUST_ID                         AS CUST_ID,              --客户编号
           A.REL_TYP                         AS REL_TYP,              --关系类型
           A.REL_PSN_TYP                     AS REL_PSN_TYP,          --关联人类型
           --A.REL_PSN_CUST_NM                 AS REL_PSN_CUST_NM,      --关联人客户名称
           TRIM(REGEXP_REPLACE(A.REL_PSN_CUST_NM,'[/$\]','')) AS REL_PSN_CUST_NM,      --关联人客户名称 --MOD BY LIP 20260417
           A.REL_PSN_CUST_ID                 AS REL_PSN_CUST_ID,      --关联人客户编号
           A.REL_PSN_CTRY_CD                 AS REL_PSN_CTRY_CD,      --关联人国家代码
           A.REL_PSN_CRDL_TYP                AS REL_PSN_CRDL_TYP,     --关联人证件类型
           --A.REL_PSN_CRDL_NO                 AS REL_PSN_CRDL_NO,      --关联人证件号码
           --A.PBC_NO                          AS PBC_NO,               --人行支付行号
           --A.FIN_PERMIT_NO                   AS FIN_PERMIT_NO,        --金融许可证号
           TRIM(REGEXP_REPLACE(A.REL_PSN_CRDL_NO,'[/$\]','')) AS REL_PSN_CRDL_NO,      --关联人证件号码 --MOD BY LIP 20260417
           TRIM(REGEXP_REPLACE(A.PBC_NO,'[/$\]','')) AS PBC_NO,               --人行支付行号 --MOD BY LIP 20260417
           TRIM(REGEXP_REPLACE(A.FIN_PERMIT_NO,'[/$\]','')) AS FIN_PERMIT_NO,        --金融许可证号 --MOD BY LIP 20260417
           A.ACT_CNTLR_FLG                   AS ACT_CNTLR_FLG,        --实际控制人标志
           A.ACT_CNTLR_TYP                   AS ACT_CNTLR_TYP,        --实际控制人类型
           A.REGD_CD_RSK                     AS REGD_CD_RSK,          --登记注册代码（客户风险）
           A.UPD_INFO_DT                     AS UPD_INFO_DT,          --更新信息日期
           A.SENIOR_IMPT_PSN_FLG             AS SENIOR_IMPT_PSN_FLG,  --高管及重要联系人标志
           A.REL_STAT                        AS REL_STAT,             --关联关系状态
           A.PP1_NO                          AS PP1_NO,               --护照1号码
           A.PP1_ISU_DT                      AS PP1_ISU_DT,           --护照1签发日期
           A.PP1_EXP_DT                      AS PP1_EXP_DT,           --护照1到期日期
           A.PP2_NO                          AS PP2_NO,               --护照2号码
           A.PP2_ISU_DT                      AS PP2_ISU_DT,           --护照2签发日期
           A.PP2_EXP_DT                      AS PP2_EXP_DT,           --护照2到期日期
           A.PP3_NO                          AS PP3_NO,               --护照3号码
           A.PP3_ISU_DT                      AS PP3_ISU_DT,           --护照3签发日期
           A.PP3_EXP_DT                      AS PP3_EXP_DT,           --护照3到期日期
           A.OTH_CRDL_TYP1                   AS OTH_CRDL_TYP1,        --其他证件类型1
           A.OTH_CRDL_NO1                    AS OTH_CRDL_NO1,         --其他证件号码1
           A.OTH_CRDL_TYP2                   AS OTH_CRDL_TYP2,        --其他证件类型2
           A.OTH_CRDL_NO2                    AS OTH_CRDL_NO2,         --其他证件号码2
           A.DEPT_LINE                       AS DEPT_LINE,            --部门条线
           A.DATA_SRC                        AS DATA_SRC,             --数据来源
           ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,A.REL_TYP ORDER BY A.REL_PSN_TYP,A.DATA_SRC,
             A.REL_PSN_CRDL_TYP NULLS LAST,A.REL_PSN_CRDL_NO DESC NULLS LAST) AS ROWNO --排序号
      FROM RRP_MDL.M_CUST_CORP_REL_SUB A --对公客户关联人子表
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_EAST.EAST5_KHXXB KHXXB --通过客户统一编号和证件号码限制有业务数据客户
        ON KHXXB.KHTYBH = A.CUST_ID
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.REL_PSN_CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001'
       AND CODE.MOD_FLG = 'EAST'
     WHERE TRIM(A.REL_PSN_CRDL_NO) IS NOT NULL
       AND A.DATA_DT = V_P_DATE)
    SELECT T.DATA_DT,              --数据日期
           T.LGL_REP_ID,           --法人编号
           T.CUST_ID,              --客户编号
           T.REL_TYP,              --关系类型
           T.REL_PSN_TYP,          --关联人类型
           T.REL_PSN_CUST_NM,      --关联人客户名称
           T.REL_PSN_CUST_ID,      --关联人客户编号
           T.REL_PSN_CTRY_CD,      --关联人国家代码
           T.REL_PSN_CRDL_TYP,     --关联人证件类型
           T.REL_PSN_CRDL_NO,      --关联人证件号码
           T.PBC_NO,               --人行支付行号
           T.FIN_PERMIT_NO,        --金融许可证号
           T.ACT_CNTLR_FLG,        --实际控制人标志
           T.ACT_CNTLR_TYP,        --实际控制人类型
           T.REGD_CD_RSK,          --登记注册代码（客户风险）
           T.UPD_INFO_DT,          --更新信息日期
           T.SENIOR_IMPT_PSN_FLG,  --高管及重要联系人标志
           T.REL_STAT,             --关联关系状态
           T.PP1_NO,               --护照1号码
           T.PP1_ISU_DT,           --护照1签发日期
           T.PP1_EXP_DT,           --护照1到期日期
           T.PP2_NO,               --护照2号码
           T.PP2_ISU_DT,           --护照2签发日期
           T.PP2_EXP_DT,           --护照2到期日期
           T.PP3_NO,               --护照3号码
           T.PP3_ISU_DT,           --护照3签发日期
           T.PP3_EXP_DT,           --护照3到期日期
           T.OTH_CRDL_TYP1,        --其他证件类型1
           T.OTH_CRDL_NO1,         --其他证件号码1
           T.OTH_CRDL_TYP2,        --其他证件类型2
           T.OTH_CRDL_NO2,         --其他证件号码2
           T.DEPT_LINE,            --部门条线
           T.DATA_SRC              --数据来源
      FROM TMP1 T
     WHERE T.ROWNO = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '关联关系表-插入目标临时表';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_206_GLGXB_TMP';
    INSERT INTO RRP_EAST.EAST5_206_GLGXB_TMP
      (RID,           --数据主键
       JRXKZH,        --金融许可证号
       NBJGH,         --内部机构号
       KHTYBH,        --客户统一编号
       KHMC,          --客户名称
       KHZJLB,        --客户证件类别
       KHZJHM,        --客户证件号码
       GXLX,          --关系类型
       GLRKHTYBH,     --关联人客户统一编号
       GLRMC,         --关联人名称
       GLRLB,         --关联人类别
       GLRZJLB,       --关联人证件类别
       GLRZJHM,       --关联人证件号码
       GXZT,          --关系状态
       BBZ,           --备注
       CJRQ,          --采集日期
       DEPT_NO,       --部门编号
       SRC_SYS_ID,    --来源系统ID
       ISSUED_NO,     --填报机构
       ORG_NO,        --报送机构
       ADDRESS,       --归属地
       GLRMC_ORIG,    --关联人名称脱敏
       GLRZJHM_ORIG,  --关联人证件号码（脱敏前）
       KHZJHM_ORIG,   --客户证件号码（脱敏前）
       GSFZJG         --归属分支机构
       )
      WITH TMP AS (
    SELECT /*+MATERIALIZE*/T.CUST_ID,
           T.CRDL_NO,
           T.CRDL_TYP,
           /*ROW_NUMBER() OVER(PARTITION BY T.CUST_ID ORDER BY DECODE(T.CRDL_TYP,'236',1,CODE.ROWNO)) ROWNO*/--因CODE_MAP 无 ROWNO 字段故注释掉相关条件
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ID ORDER BY T.CRDL_TYP /*DECODE(T.CRDL_TYP,'236',1,CODE.ROWNO)*/) ROWNO
      FROM RRP_MDL.M_CUST_CORP_CRDL_SUB T
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = T.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --客户证件类别 --ADD BY LIP
       AND CODE.MOD_FLG = 'EAST'
     WHERE T.DATA_DT = V_P_DATE),
      TMP_EAST5_206_GLGXB AS (
    SELECT /*+MATERIALIZE*/
           SYS_GUID()                                              AS RID,           --数据主键
           C.FIN_PERMIT_NO                                         AS JRXKZH,        --金融许可证号
           C.ORG_ID                                                AS NBJGH,         --内部机构号
           A.CUST_ID                                               AS KHTYBH,        --客户统一编号
           B.CUST_NM                                               AS KHMC,          --客户名称
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL AND B.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(B.PBC_NO) IS NOT NULL AND B.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS KHZJLB,        --客户证件类别

           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN TRIM(B.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(B.FIN_PERMIT_NO)
                ELSE NVL(TRIM(B.CRDL_NO), TRIM(F.CRDL_NO))
            END                                                    AS KHZJHM,        --客户证件号码
           CASE WHEN CODE1.TAR_VALUE_NAME IS NULL THEN --对公关系类型
                CASE WHEN CODE11.TAR_VALUE_NAME LIKE '其他-担保' THEN '担保关系'
                     WHEN CODE11.TAR_VALUE_NAME LIKE '其他-%'
                     THEN TRIM(SUBSTRB(CODE11.TAR_VALUE_NAME,1,300)) --有对私关系类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
                     ELSE TRIM(SUBSTRB('其他-'|| CODE11.TAR_VALUE_NAME,1,300)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                 END
                --ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,200))
                ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,300)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS GXLX,          --关系类型
           A.REL_PSN_CUST_ID                                       AS GLRKHTYBH,     --关联人客户统一编号
           CASE --WHEN A.REL_PSN_CRDL_TYP LIKE '1%'
                WHEN (A.REL_PSN_CRDL_TYP LIKE '1%' AND LENGTH(A.REL_PSN_CRDL_TYP) = 4) OR
                     A.REL_PSN_TYP IN ('01', '02', '03', '04', '05', '06','011','012') --MOD BY LIP 20260402
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.REL_PSN_CUST_NM),'[[:punct:]]',''), 0))
                ELSE TRIM(A.REL_PSN_CUST_NM)
            END                                                    AS GLRMC,         --关联人名称
           CASE WHEN A.REL_PSN_CRDL_TYP LIKE '1%' AND LENGTH(A.REL_PSN_CRDL_TYP) = 4 THEN '自然人' --MOD BY LIP 20241105 根据证件类型判断
                WHEN A.REL_PSN_TYP IN ('01', '02', '03', '04', '05', '06','011','012') THEN '自然人'
                WHEN A.REL_PSN_TYP = '07' THEN '国有企业'
                WHEN A.REL_PSN_TYP = '08' THEN '民营企业'
                WHEN A.REL_PSN_TYP = '09' THEN '政府机关'
                WHEN A.REL_PSN_TYP = '10' THEN '事业单位'
                WHEN A.REL_PSN_TYP = '11' THEN '社会团体'
                WHEN A.REL_PSN_TYP = '12' THEN '境外机构'
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE4.TAR_VALUE_NAME,'其他-',''),1,30))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS GLRLB,         --关联人类别
           CASE WHEN TRIM(D.PBC_NO) IS NOT NULL AND D.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(D.PBC_NO) IS NOT NULL AND D.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(D.PBC_NO) IS NULL AND TRIM(D.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                ELSE TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS GLRZJLB,       --关联人证件类别
           CASE WHEN TRIM(D.PBC_NO) IS NOT NULL THEN D.PBC_NO
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(D.FIN_PERMIT_NO) IS NOT NULL THEN D.FIN_PERMIT_NO
                WHEN A.REL_PSN_CRDL_TYP LIKE '1%' THEN
                --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                CASE WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                     WHEN NVL(LENGTHB(TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(A.REL_PSN_CRDL_NO,1,6))
                 END||
                RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.REL_PSN_CUST_NM),'[[:punct:]]',''),1) ||
                         TRIM(A.REL_PSN_CRDL_NO))
                ELSE TRIM(A.REL_PSN_CRDL_NO)
            END                                                    AS GLRZJHM,       --关联人证件号码 --MODIFY BY LIP
           CODE3.TAR_VALUE_NAME                                    AS GXZT,          --关系状态
           ''                                                      AS BBZ,           --备注
           V_MONTH_END_DATEID                                      AS CJRQ,          --采集日期
           '000'                                                   AS DEPT_NO,       --部门编号
           '01'                                                    AS SRC_SYS_ID,    --来源系统ID
           '000000'                                                AS ISSUED_NO,     --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO,        --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,       --归属地
           A.REL_PSN_CUST_NM                                       AS GLRMC_ORIG,    --关联人名称（脱敏前）
           CASE WHEN TRIM(D.PBC_NO) IS NOT NULL THEN TRIM(D.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(D.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(D.FIN_PERMIT_NO)
                ELSE TRIM(A.REL_PSN_CRDL_NO)
            END                                                    AS GLRZJHM_ORIG,  --关联人证件号码（脱敏前）
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN B.PBC_NO
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN B.FIN_PERMIT_NO
                ELSE NVL(TRIM(B.CRDL_NO), F.CRDL_NO)
            END                                                    AS KHZJHM_ORIG,   --客户证件号码（脱敏前）
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                    AS GSFZJG,        --归属分支机构 --MODIFY BY LIP
           ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY A.DATA_DT) AS NUM
      FROM RRP_EAST.M_CUST_CORP_REL_SUB_TMP A --对公客户关联人子表
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.CRDL_NO IS NOT NULL --限制证件号码不为空，后续取消该条件
       AND UPPER(B.DATA_SRC) = 'EIFS'
       AND B.CUST_STAT != 'B' --剔除销户
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.REL_PSN_CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN TMP F
        ON F.CUST_ID = A.CUST_ID
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = NVL(TRIM(B.CRDL_TYP), F.CRDL_TYP)
       AND CODE.SRC_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --客户证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.REL_TYP
       AND CODE1.SRC_CLASS_CODE IN ('C0058') --关系类型
       AND CODE1.TAR_CLASS_CODE IN ('C0058') --关系类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE11 --码值配置表
        ON CODE11.SRC_VALUE_CODE = A.REL_TYP
       AND CODE11.SRC_CLASS_CODE IN ('C0017') --关系类型
       AND CODE11.TAR_CLASS_CODE IN ('C0017') --关系类型
       AND CODE11.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.REL_PSN_CRDL_TYP
       AND CODE2.SRC_CLASS_CODE = 'C0001' --关联人证件类别
       AND CODE2.TAR_CLASS_CODE = 'C0001' --关联人证件类别
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.REL_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0002' --关系状态
       AND CODE3.TAR_CLASS_CODE = 'Z0002' --关系状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.REL_PSN_TYP
       AND CODE4.SRC_CLASS_CODE = 'C0025' --关联人类别
       AND CODE4.TAR_CLASS_CODE = 'C0025' --关联人类别
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE)
    SELECT T.RID,           --数据主键
           T.JRXKZH,        --金融许可证号
           T.NBJGH,         --内部机构号
           T.KHTYBH,        --客户统一编号
           T.KHMC,          --客户名称
           T.KHZJLB,        --客户证件类别
           T.KHZJHM,        --客户证件号码
           T.GXLX,          --关系类型
           T.GLRKHTYBH,     --关联人客户统一编号
           T.GLRMC,         --关联人名称
           T.GLRLB,         --关联人类别
           T.GLRZJLB,       --关联人证件类别
           T.GLRZJHM,       --关联人证件号码
           T.GXZT,          --关系状态
           T.BBZ,           --备注
           T.CJRQ,          --采集日期
           T.DEPT_NO,       --部门编号
           T.SRC_SYS_ID,    --来源系统ID
           T.ISSUED_NO,     --填报机构
           T.ORG_NO,        --报送机构
           T.ADDRESS,       --归属地
           T.GLRMC_ORIG,    --关联人名称脱敏
           T.GLRZJHM_ORIG,  --关联人证件号码（脱敏前）
           T.KHZJHM_ORIG,   --客户证件号码（脱敏前）
           T.GSFZJG         --归属分支机构
      FROM TMP_EAST5_206_GLGXB T;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '关联关系表-插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_206_GLGXB
      (RID,           --数据主键
       JRXKZH,        --金融许可证号
       NBJGH,         --内部机构号
       KHTYBH,        --客户统一编号
       KHMC,          --客户名称
       KHZJLB,        --客户证件类别
       KHZJHM,        --客户证件号码
       GXLX,          --关系类型
       GLRKHTYBH,     --关联人客户统一编号
       GLRMC,         --关联人名称
       GLRLB,         --关联人类别
       GLRZJLB,       --关联人证件类别
       GLRZJHM,       --关联人证件号码
       GXZT,          --关系状态
       BBZ,           --备注
       CJRQ,          --采集日期
       DEPT_NO,       --部门编号
       SRC_SYS_ID,    --来源系统ID
       ISSUED_NO,     --填报机构
       ORG_NO,        --报送机构
       ADDRESS,       --归属地
       GLRMC_ORIG,    --关联人名称脱敏
       GLRZJHM_ORIG,  --关联人证件号码（脱敏前）
       KHZJHM_ORIG,   --客户证件号码（脱敏前）
       GSFZJG         --归属分支机构
       )
      WITH TMP1 AS (
    SELECT SYS_GUID()                                    AS RID,           --数据主键
           A.JRXKZH                                      AS JRXKZH,        --金融许可证号
           A.NBJGH                                       AS NBJGH,         --内部机构号
           A.KHTYBH                                      AS KHTYBH,        --客户统一编号
           --A.KHMC                                        AS KHMC,          --客户名称
           --MOD BY LIP 20241206 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(KHMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(KHMC),'(','（'),')','）'),' ','')
                ELSE TRIM(KHMC)
            END                                           AS KHMC,         --客户名称
           A.KHZJLB                                       AS KHZJLB,       --客户证件类别
           A.KHZJHM                                       AS KHZJHM,       --客户证件号码
           A.GXLX                                         AS GXLX,         --关系类型
           A.GLRKHTYBH                                    AS GLRKHTYBH,    --关联人客户统一编号
           --MOD BY LIP 20241206 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(GLRMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(GLRMC),'(','（'),')','）'),' ','')
                ELSE TRIM(GLRMC)
            END                                           AS GLRMC,        --关联人名称
           A.GLRLB                                        AS GLRLB,        --关联人类别
           CASE WHEN TRIM(GLRZJHM) IS NOT NULL THEN GLRZJLB
                ELSE '其他-客户编号'
            END                                           AS GLRZJLB,      --关联人证件类别
           NVL(TRIM(A.GLRZJHM),A.GLRKHTYBH)               AS GLRZJHM,      --关联人证件号码
           A.GXZT                                         AS GXZT,         --关系状态
           A.BBZ                                          AS BBZ,          --备注
           A.CJRQ                                         AS CJRQ,         --采集日期
           '000'                                          AS DEPT_NO,      --部门编号
           A.SRC_SYS_ID                                   AS SRC_SYS_ID,   --来源系统ID
           '000000'                                       AS ISSUED_NO,    --填报机构
           A.ORG_NO                                       AS ORG_NO,       --报送机构
           A.ADDRESS                                      AS ADDRESS,      --归属地
           A.GLRMC_ORIG                                   AS GLRMC_ORIG,   --关联人名称（脱敏前）
           A.GLRZJHM_ORIG                                 AS GLRZJHM_ORIG, --关联人证件号码（脱敏前）
           A.KHZJHM_ORIG                                  AS KHZJHM_ORIG,  --客户证件号码（脱敏前）
           A.GSFZJG                                       AS GSFZJG,       --归属分支机构
           --ROW_NUMBER() OVER(PARTITION BY A.CJRQ,A.GXLX,A.KHZJHM,A.GLRZJHM ORDER BY A.GLRZJHM) RN
           ROW_NUMBER() OVER(PARTITION BY A.CJRQ,A.GXLX,A.KHZJHM,NVL(TRIM(A.GLRZJHM),A.GLRKHTYBH)
               ORDER BY NVL(TRIM(A.GLRZJHM),A.GLRKHTYBH)) RN --MOD BY LIP 20241206
      FROM RRP_EAST.EAST5_206_GLGXB_TMP A
     WHERE A.CJRQ = V_P_DATE)
    SELECT RID,           --数据主键
           JRXKZH,        --金融许可证号
           NBJGH,         --内部机构号
           KHTYBH,        --客户统一编号
           KHMC,          --客户名称
           KHZJLB,        --客户证件类别
           KHZJHM,        --客户证件号码
           GXLX,          --关系类型
           GLRKHTYBH,     --关联人客户统一编号
           GLRMC,         --关联人名称
           GLRLB,         --关联人类别
           GLRZJLB,       --关联人证件类别
           GLRZJHM,       --关联人证件号码
           GXZT,          --关系状态
           BBZ,           --备注
           CJRQ,          --采集日期
           DEPT_NO,       --部门编号
           SRC_SYS_ID,    --来源系统ID
           ISSUED_NO,     --填报机构
           ORG_NO,        --报送机构
           ADDRESS,       --归属地
           GLRMC_ORIG,    --关联人名称脱敏
           GLRZJHM_ORIG,  --关联人证件号码（脱敏前）
           KHZJHM_ORIG,   --客户证件号码（脱敏前）
           GSFZJG         --归属分支机构
      FROM TMP1
     WHERE NVL(KHTYBH,' ') <> NVL(GLRKHTYBH,' ') --关联人编号，与客户号应不一样
       AND NVL(KHMC,' ') <> NVL(GLRMC,' ') --MOD BY LIP 20241206
       AND NVL(KHZJHM,' ') <> NVL(GLRZJHM,' ') --MOD BY LIP 20241203
       AND RN = 1;

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
    SELECT CJRQ,KHZJHM,GXLX,GLRZJHM,COUNT(1)
      FROM RRP_EAST.EAST5_206_GLGXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,KHZJHM,GXLX,GLRZJHM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_206_GLGXB(CJRQ,KHZJHM,GXLX,GLRZJHM)数据重复';
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

END ETL_EAST5_206_GLGXB;
/

