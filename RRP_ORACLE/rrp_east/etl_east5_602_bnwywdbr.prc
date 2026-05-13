CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_602_BNWYWDBR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
 **  存储过程详细说明：表内外业务担保人
 **  存储过程名称:  ETL_EAST5_602_BNWYWDBR
 **  存储过程创建日期:2022-07-14
 **  存储过程创建人:付善斌
 **        M_CUST_GUAR_INFO    --担保人信息
 **        M_GUA_REL_GUAR      --担保合同与担保人对应关系信息
 **        M_PUM_ORG_INFO_EAST      --机构表
 **        M_GUA_REL_BSN_CONT  --担保合同和业务合同对应关系表
 **        M_GUA_CONT_INFO C   --担保合同表
 **  目标表:
 **         EAST5_602_BNWYWDBR
 **  修改日期     修改人      修改原因
 **  20251212     LIP         根据业务要求，剔除未签合同的担保合同
************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);    --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);  --分区名称
  V_FREQ_FLAG        VARCHAR2(10);   --跑批频度
  V_STEP             INTEGER := 0;   --任务号
  V_COUNT            INTEGER := 0;   --数据记录条数
  V_STARTTIME        DATE;           --处理开始时间
  V_ENDTIME          DATE;           --处理结束时间
  V_SQLCOUNT         INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);  --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_602_BNWYWDBR'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_602_BNWYWDBR'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
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

    /*删除当日分区数据*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '加工临时表数据';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_602_BNWYWDBR_TMP'; --ADD BY LIP 20241030
    INSERT INTO RRP_EAST.EAST5_602_BNWYWDBR_TMP
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       DBHTH, --担保合同号
       BZRLB, --担保人类别
       BZRMC, --担保人名称
       DBRZJLB, --担保人证件类别
       DBRZJHM, --担保人证件号码
       DBRJZCBZ, --担保人净资产币种
       DBRJZC, --担保人净资产
       DBHTZT, --担保合同状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       BZRMC_ORIG, --担保人名称（脱敏前）
       DBRZJHM_ORIG, --担保人证件号码（脱敏前）
       BZRMC_OTH --担保人是否个人
       ,GSFZJG --归属分支机构
       ,BDBRSFGR  --被担保人是否个人
       )
      WITH XDHTB_KHMC_OTH AS (--MODIFY BY TANGAN AT 20230201
    SELECT /*+MATERIALIZE*/
           T1.GUA_CONT_ID,MAX(T2.KHMC_OTH) KHMC_OTH,
           SUM(CASE WHEN NVL(T1.BIZ_ACT_END_DT,'99991231') > V_P_DATE THEN 1
                    ELSE 0
                END) YX_ZS
      FROM RRP_MDL.M_GUA_REL_BSN_CONT T1 --担保合同和业务合同对应关系表
      LEFT JOIN RRP_EAST.EAST5_501_XDHTB T2
        ON T2.XDHTH = T1.BIZ_CONT_ID
       AND T2.CJRQ = V_P_DATE
      LEFT JOIN RRP_MDL.M_GUA_CONT_INFO T3 --担保合同表
        ON T3.GUA_CONT_ID = T1.GUA_CONT_ID
       AND NVL(T3.GUA_CONT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND CASE WHEN T3.GUA_CONT_EFF_DT NOT IN ('00010101','29991231','20991231') THEN T3.GUA_CONT_EFF_DT
                WHEN T3.GUA_CONT_SIGN_DT NOT IN ('00010101','29991231','20991231') THEN T3.GUA_CONT_SIGN_DT
                ELSE '99991231'
            END <= V_P_DATE --MOD BY LIP 20260323 根据业务需求，剔除合同起始日录入有问题大于采集日期的数据
       AND T3.DATA_DT = V_P_DATE
     WHERE (T2.XDHTH IS NOT NULL OR T3.LOAN_MON_FLAG = 'Y') --MOD BY LIP 2024716
       AND NVL(T3.GUA_CONT_STAT_YBT,'1') NOT IN ('110') --未签合同 --MOD BY LIP 20251212 根据业务要求，剔除未签合同的担保合同
       AND (NVL(T1.BIZ_ACT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') OR T2.XDHTH IS NOT NULL)
       AND NVL(T1.GUA_REL_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND T1.DATA_DT = V_P_DATE
     GROUP BY T1.GUA_CONT_ID)
    SELECT --SYS_GUID()                                        AS RID, --数据主键
           V_MONTH_END_DATEID || A.GUA_CONT_ID || B.GUAR_PRIM_CRDL_NO AS RID, --数据主键 --MOD BY LIP 20241030
           D.FIN_PERMIT_NO                                   AS JRXKZH, --金融许可证号
           --C.ORG_ID                                          AS NBJGH, --内部机构号
           --D.ORG_ID                                          AS NBJGH, --内部机构号
           --NVL(D.ORG_ID1,'800001')                           AS NBJGH, --内部机构号  --20221212 增减关键表 修改取值字段
           D.ORG_ID                                          AS NBJGH, --内部机构号  --20221212 增减关键表 修改取值字段
           A.GUA_CONT_ID                                     AS DBHTH, --担保合同号
           CASE WHEN B.CORP_INDV_FLG = '1' THEN '个人'
                WHEN B.CORP_INDV_FLG = '2' THEN '对公'
                /*--因部分担保人的证件类型为空，暂用客户号的首位数字判断类别
                WHEN SUBSTR(B.GUAR_ID,1,1) IN ('5','9') THEN '对公'
                WHEN SUBSTR(B.GUAR_ID,1,1) IN ('1','3') THEN '个人'*/
                --MOD BY LIP 20241030 担保人编号调整成了押品编号
                WHEN LENGTH(B.GUAR_NM) > 3 THEN '对公'
                WHEN LENGTH(B.GUAR_NM) <= 3 THEN '个人'
            END                                              AS BZRLB, --担保人类别
           CASE WHEN B.GUAR_PRIM_CRDL_TYP LIKE '1%' OR B.CORP_INDV_FLG = '1' OR LENGTH(B.GUAR_NM) <= 3 --MOD BY LIP 20241030
                /*THEN SUBSTRB(B.GUAR_NM, LENGTHB(B.GUAR_NM) - 2, 3)*/
                --THEN FUN_DESENSITIZATION(B.GUAR_NM,0)
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(B.GUAR_NM,'[[:punct:]]',''),0)) --MODIFY BY LIP
                --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN REGEXP_REPLACE(TRIM(B.GUAR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.GUAR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.GUAR_NM)
            END                                              AS BZRMC, --担保人名称
           --CODE2.TAR_VALUE_NAME                              AS DBRZJLB, --担保人证件类别
           --TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,40))          AS DBRZJLB, --担保人证件类别
           TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,60))          AS DBRZJLB, --担保人证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN B.GUAR_PRIM_CRDL_TYP LIKE '1%' OR B.CORP_INDV_FLG = '1' OR LENGTH(B.GUAR_NM) <= 3 --MOD BY LIP 20241030
                THEN --涉及个人身份证件时需按照本规范给定规则进行脱敏处理
                     --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                     CASE WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                          WHEN LENGTHB(TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(B.GUAR_PRIM_CRDL_NO,1,6))
                      END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(B.GUAR_NM,'[[:punct:]]',''),1)||
                    UPPER(B.GUAR_PRIM_CRDL_NO))--MODIFY BY LIP
                ELSE TRIM(B.GUAR_PRIM_CRDL_NO)
            END                                              AS DBRZJHM, --担保人证件号码
           B.GUAR_NET_AST_CUR                                AS DBRJZCBZ, --担保人净资产币种
           B.GUAR_NET_AST                                    AS DBRJZC, --担保人净资产
           CASE --WHEN SUBSTR(TO_CHAR(SX.MAX_DT,'YYYYMMDD'),1,6)||'01' = SUBSTR(V_P_DATE,1,6)||'01' THEN '失效'
                WHEN EE.YX_ZS = 0 THEN '失效' --MOD BY LIP 20240716
                --MODIFY 20230313 LHQ 当担保合同旗下所有业务合同和额度合同的状态均为4（即失效）是和最大更新日期等于当月，担保合同状态更新为失效
                WHEN C.GUA_CONT_STAT = 'Y' THEN '有效'
                WHEN C.GUA_CONT_STAT = 'N' THEN '失效'
            END                                              AS DBHTZT, --担保合同状态
           CASE WHEN TRIM(B.GUAR_NET_AST) IS NULL
                THEN CASE WHEN C.GUA_TYP = 'A' THEN '抵押'
                          WHEN C.GUA_TYP = 'B' THEN '质押'
                      END
                ELSE ''
            END                                              AS BBZ, --备注
           V_MONTH_END_DATEID                                AS CJRQ, --采集日期
           '000'                                             AS DEPT_NO, --部门编号
           '01'                                              AS SRC_SYS_ID, --来源系统ID
           '000000'                                          AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                  AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                              AS ADDRESS, --归属地
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(B.GUAR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.GUAR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.GUAR_NM)
            END                                              AS BZRMC_ORIG, --担保人名称（脱敏前）
           TRIM(B.GUAR_PRIM_CRDL_NO)                         AS DBRZJHM_ORIG, --担保人证件号码（脱敏前）
           CASE WHEN B.GUAR_PRIM_CRDL_TYP LIKE '1%' OR B.CORP_INDV_FLG = '1' OR LENGTH(B.GUAR_NM) <= 3 --MOD BY LIP 20241030
                THEN '是'
                ELSE '否'
            END                                              AS BZRMC_OTH, --担保人是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN D.GSFZJG
                ELSE '9999'
            END                                              AS GSFZJG, --归属分支机构 --MODIFY BY LIP
           NVL(TRIM(EE.KHMC_OTH),'否')                       AS BDBRSFGR  --被担保人是否个人 --modify by tangan at 20230201
      FROM RRP_MDL.M_GUA_REL_GUAR A --担保合同与担保人对应关系信息
     INNER /*LEFT*/ JOIN RRP_MDL.M_CUST_GUAR_INFO B --担保人信息
        ON B.GUAR_ID = A.GUAR_ID
       AND B.DATA_DT = V_P_DATE
     INNER /*LEFT*/ JOIN RRP_MDL.M_GUA_CONT_INFO C --担保合同表
        ON C.GUA_CONT_ID = A.GUA_CONT_ID
       AND NVL(C.GUA_CONT_STAT_YBT,'1') NOT IN ('110') --未签合同 --MOD BY LIP 20251212 根据业务要求，剔除未签合同的担保合同
       AND NVL(C.GUA_CONT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND C.DATA_DT = V_P_DATE
     --LEFT JOIN XDHTB_KHMC_OTH EE
     INNER JOIN XDHTB_KHMC_OTH EE --MOD BY LIP 20230609 剔除未生效或撤销的合同
        ON EE.GUA_CONT_ID = A.GUA_CONT_ID
      /*LEFT JOIN SX_CONT SX --担保合同旗下所有业务合同和额度合同的状态和最大更新日期
        ON SX.GUAR_CONT_ID = A.GUA_CONT_ID*/
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = NVL(M.ORG_ID1,'800')
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CORP_INDV_FLG
       AND CODE.SRC_CLASS_CODE = 'Z0013' --担保人类别
       AND CODE.TAR_CLASS_CODE = 'Z0013' --担保人类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.GUA_CONT_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE1.TAR_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = B.GUAR_PRIM_CRDL_TYP
       AND CODE2.SRC_CLASS_CODE = 'C0001' --担保人证件类别
       AND CODE2.TAR_CLASS_CODE = 'C0001' --担保人证件类别
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = D.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*NOT EXISTS(SELECT * FROM SX_CONT A1 WHERE A.GUA_CONT_ID = A1.GUAR_CONT_ID) --ADD 20230306 LHQ 根据信贷口径，过滤不符合条件的担保合同
       AND*/NVL(A.GUA_REL_GUAR_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20250106 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_602_BNWYWDBR(
      RID, --数据主键
      JRXKZH, --金融许可证号
      NBJGH, --内部机构号
      DBHTH, --担保合同号
      BZRLB, --担保人类别
      BZRMC, --担保人名称
      DBRZJLB, --担保人证件类别
      DBRZJHM, --担保人证件号码
      DBRJZCBZ, --担保人净资产币种
      DBRJZC, --担保人净资产
      DBHTZT, --担保合同状态
      BBZ, --备注
      CJRQ, --采集日期
      DEPT_NO, --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO, --填报机构
      ORG_NO, --报送机构
      ADDRESS, --归属地
      BZRMC_ORIG, --担保人名称（脱敏前）
      DBRZJHM_ORIG, --担保人证件号码（脱敏前）
      BZRMC_OTH, --担保人是否个人
      GSFZJG, --归属分支机构
      BDBRSFGR  --被担保人是否个人
      )
      WITH TMP_EAST5_602_BNWYWDBR AS (
    SELECT RID, --数据主键
           JRXKZH, --金融许可证号
           NBJGH, --内部机构号
           DBHTH, --担保合同号
           BZRLB, --担保人类别
           BZRMC, --担保人名称
           DBRZJLB, --担保人证件类别
           DBRZJHM, --担保人证件号码
           DBRJZCBZ, --担保人净资产币种
           DBRJZC, --担保人净资产
           DBHTZT, --担保合同状态
           BBZ, --备注
           CJRQ, --采集日期
           DEPT_NO, --部门编号
           SRC_SYS_ID, --来源系统ID
           ISSUED_NO, --填报机构
           ORG_NO, --报送机构
           ADDRESS, --归属地
           BZRMC_ORIG, --担保人名称（脱敏前）
           DBRZJHM_ORIG, --担保人证件号码（脱敏前）
           BZRMC_OTH, --担保人是否个人
           GSFZJG, --归属分支机构
           BDBRSFGR, --被担保人是否个人
           ROW_NUMBER() OVER(PARTITION BY CJRQ,DBHTH,BZRMC_ORIG,DBRZJHM_ORIG ORDER BY DBRJZC DESC) RN
      FROM RRP_EAST.EAST5_602_BNWYWDBR_TMP)
    SELECT SYS_GUID() AS RID, --数据主键
           JRXKZH, --金融许可证号
           NBJGH, --内部机构号
           DBHTH, --担保合同号
           BZRLB, --担保人类别
           BZRMC, --担保人名称
           DBRZJLB, --担保人证件类别
           DBRZJHM, --担保人证件号码
           DBRJZCBZ, --担保人净资产币种
           DBRJZC, --担保人净资产
           DBHTZT, --担保合同状态
           BBZ, --备注
           CJRQ, --采集日期
           DEPT_NO, --部门编号
           SRC_SYS_ID, --来源系统ID
           ISSUED_NO, --填报机构
           ORG_NO, --报送机构
           ADDRESS, --归属地
           BZRMC_ORIG, --担保人名称（脱敏前）
           DBRZJHM_ORIG, --担保人证件号码（脱敏前）
           BZRMC_OTH, --担保人是否个人
           GSFZJG, --归属分支机构
           BDBRSFGR --被担保人是否个人
      FROM TMP_EAST5_602_BNWYWDBR A
     WHERE A.RN = 1
     UNION ALL
    --ADD BY LIP 20241030 上月有效但当月没采集到的数据
    SELECT SYS_GUID()                 AS RID, --数据主键
           C.FIN_PERMIT_NO            AS JRXKZH, --金融许可证号
           B.NBJGH                    AS NBJGH, --内部机构号
           B.DBHTH                    AS DBHTH, --担保合同号
           B.BZRLB                    AS BZRLB, --担保人类别
           B.BZRMC                    AS BZRMC, --担保人名称
           B.DBRZJLB                  AS DBRZJLB, --担保人证件类别
           B.DBRZJHM                  AS DBRZJHM, --担保人证件号码
           B.DBRJZCBZ                 AS DBRJZCBZ, --担保人净资产币种
           B.DBRJZC                   AS DBRJZC, --担保人净资产
           '失效'                     AS DBHTZT, --担保合同状态
           B.BBZ                      AS BBZ, --备注
           V_P_DATE                   AS CJRQ, --采集日期
           '000'                      AS DEPT_NO, --部门编号
           '01'                       AS SRC_SYS_ID, --来源系统ID
           '000000'                   AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0           AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                       AS ADDRESS, --归属地
           B.BZRMC_ORIG               AS BZRMC_ORIG, --担保人名称（脱敏前）
           B.DBRZJHM_ORIG             AS DBRZJHM_ORIG, --担保人证件号码（脱敏前）
           B.BZRMC_OTH                AS BZRMC_OTH, --担保人是否个人
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                       AS GSFZJG, --归属分支机构
           B.BDBRSFGR                 AS BDBRSFGR --被担保人是否个人
      FROM RRP_EAST.EAST5_602_BNWYWDBR B
      LEFT JOIN TMP_EAST5_602_BNWYWDBR A
        ON A.DBHTH = B.DBHTH
       AND NVL(A.BZRMC_ORIG,' ') = NVL(B.BZRMC_ORIG,' ')
       AND NVL(A.DBRZJHM_ORIG,' ') = NVL(B.DBRZJHM_ORIG,' ')
       AND A.RN = 1
       AND A.CJRQ = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = B.NBJGH
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DBHTH IS NULL
       AND B.DBHTZT = '有效'
       AND B.CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD');

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
    SELECT CJRQ,DBHTH,/*BZRMC,DBRZJHM*/BZRMC_ORIG,DBRZJHM_ORIG,COUNT(1) --MOD BY LIP 20241030
      FROM RRP_EAST.EAST5_602_BNWYWDBR T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,DBHTH,/*BZRMC,DBRZJHM*/BZRMC_ORIG,DBRZJHM_ORIG
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_602_BNWYWDBR(CJRQ,DBHTH,BZRMC,DBRZJHM)数据重复';
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

END ETL_EAST5_602_BNWYWDBR;
/

