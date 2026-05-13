CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SDIS_T_2_1(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_SDIS_T_2_1
  *  功能描述：表2.1 单一法人基本情况 取数脚本
  *  目标表  ：
  *  来源表  ：
  *  配置表  ：不涉及
  *  创建日期：20250806
  *  开发人员：chenzw
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250806  chenzw   首次创建
  *             2    20251104  yanyh    修改上市情况、上市标志加工逻辑
  *             3    20251120  yanyh    修改客户范围，单一法人无需关联授信，取有业务的客户
  ***************************************************************************/
AS
  --定义变量--
  V_P_DATE    VARCHAR2(8);                          -- 跑批数据日期
  V_ETL_DATE  DATE;                          -- 跑批数据日期
  V_SYSTEM    VARCHAR2(30) := '一表通';             -- 来源系统
  V_PROC_NAME VARCHAR2(30) := 'ETL_SDIS_T_2_1';     -- 程序名称
  V_STARTTIME DATE;                                 -- 处理开始时间
  V_ENDTIME   DATE;                                 -- 处理结束时间
  V_STEP      INTEGER := 0;                         -- 处理步骤
  V_STEP_DESC VARCHAR2(500);                        -- 步骤描述
  V_SQLCOUNT  INTEGER;                              -- 记录数
  V_SQLMSG    VARCHAR2(500);                        -- SQL执行描述信息
  V_TAB_NAME  VARCHAR2(100) := 'SDIS_T_2_1';        -- 表名
  V_PART_NAME VARCHAR2(100);                        -- 分区名

BEGIN
  -- 获取跑批数据日期 --
  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_ETL_DATE  := TO_DATE(V_P_DATE,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- STEP1：跑批开始 --
  V_STEP      := 1;
  V_STEP_DESC := '跑批开始';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP2: 处理表分区 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '处理分区';
  V_STARTTIME := SYSDATE;
  RRP_YBT.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  RRP_YBT.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TAB_NAME,O_ERRCODE);

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- STEP3: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公客户信息表-加工法定代表人信息插入临时表01';
  V_STARTTIME := SYSDATE;
   EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_YBT.TMP_SDIS_T_2_1_01';
    INSERT INTO RRP_YBT.TMP_SDIS_T_2_1_01
      (DATA_DT,
       LGL_REP_ID,
       CUST_ID,
       REL_TYP,
       REL_PSN_TYP,
       REL_PSN_CUST_NM,
       REL_PSN_CUST_ID,
       REL_PSN_CTRY_CD,
       REL_PSN_CRDL_TYP,
       REL_PSN_CRDL_NO,
       PBC_NO,
       FIN_PERMIT_NO,
       ACT_CNTLR_FLG,
       ACT_CNTLR_TYP,
       REGD_CD_RSK,
       UPD_INFO_DT,
       SENIOR_IMPT_PSN_FLG,
       REL_STAT,
       PP1_NO,
       PP1_ISU_DT,
       PP1_EXP_DT,
       PP2_NO,
       PP2_ISU_DT,
       PP2_EXP_DT,
       PP3_NO,
       PP3_ISU_DT,
       PP3_EXP_DT,
       OTH_CRDL_TYP1,
       OTH_CRDL_NO1,
       OTH_CRDL_TYP2,
       OTH_CRDL_NO2,
       DEPT_LINE,
       DATA_SRC,
       NUM,
       FRDBZJHM)
      SELECT DATA_DT,
             LGL_REP_ID,
             CUST_ID,
             REL_TYP,
             REL_PSN_TYP,
             REL_PSN_CUST_NM,
             REL_PSN_CUST_ID,
             REL_PSN_CTRY_CD,
             REL_PSN_CRDL_TYP,
             REL_PSN_CRDL_NO,
             PBC_NO,
             FIN_PERMIT_NO,
             ACT_CNTLR_FLG,
             ACT_CNTLR_TYP,
             REGD_CD_RSK,
             UPD_INFO_DT,
             SENIOR_IMPT_PSN_FLG,
             REL_STAT,
             PP1_NO,
             PP1_ISU_DT,
             PP1_EXP_DT,
             PP2_NO,
             PP2_ISU_DT,
             PP2_EXP_DT,
             PP3_NO,
             PP3_ISU_DT,
             PP3_EXP_DT,
             OTH_CRDL_TYP1,
             OTH_CRDL_NO1,
             OTH_CRDL_TYP2,
             OTH_CRDL_NO2,
             DEPT_LINE,
             DATA_SRC,
             ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.DATA_SRC,
               T.REL_PSN_CRDL_TYP NULLS LAST,T.REL_PSN_CRDL_NO DESC NULLS LAST) AS NUM,
            /* CASE WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
              END||REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]','')||UPPER(T.REL_PSN_CRDL_NO)
                        AS FRDBZJHM */ --法人代表证件号码 --MODIFY BY LIP 20220628
         UPPER(T.REL_PSN_CRDL_NO) AS FRDBZJHM  --法人代表证件号码 不做拼接--MODIFY BY LZM 20251128
        FROM RRP_MDL.M_CUST_CORP_REL_SUB T
       WHERE T.REL_PSN_TYP = '01' --法定代表人
         AND T.DATA_DT = V_P_DATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- STEP4: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公客户信息表--财务主管临时表处理插入临时表02';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_YBT.TMP_SDIS_T_2_1_02';
  INSERT INTO RRP_YBT.TMP_SDIS_T_2_1_02
      (DATA_DT,
       LGL_REP_ID,
       CUST_ID,
       REL_TYP,
       REL_PSN_TYP,
       REL_PSN_CUST_NM,
       REL_PSN_CUST_ID,
       REL_PSN_CTRY_CD,
       REL_PSN_CRDL_TYP,
       REL_PSN_CRDL_NO,
       PBC_NO,
       FIN_PERMIT_NO,
       ACT_CNTLR_FLG,
       ACT_CNTLR_TYP,
       REGD_CD_RSK,
       UPD_INFO_DT,
       SENIOR_IMPT_PSN_FLG,
       REL_STAT,
       PP1_NO,
       PP1_ISU_DT,
       PP1_EXP_DT,
       PP2_NO,
       PP2_ISU_DT,
       PP2_EXP_DT,
       PP3_NO,
       PP3_ISU_DT,
       PP3_EXP_DT,
       OTH_CRDL_TYP1,
       OTH_CRDL_NO1,
       OTH_CRDL_TYP2,
       OTH_CRDL_NO2,
       DEPT_LINE,
       DATA_SRC,
       NUM,
       CWFZRZJHM)
      SELECT DATA_DT,
             LGL_REP_ID,
             CUST_ID,
             REL_TYP,
             REL_PSN_TYP,
             REL_PSN_CUST_NM,
             REL_PSN_CUST_ID,
             REL_PSN_CTRY_CD,
             REL_PSN_CRDL_TYP,
             REL_PSN_CRDL_NO,
             PBC_NO,
             FIN_PERMIT_NO,
             ACT_CNTLR_FLG,
             ACT_CNTLR_TYP,
             REGD_CD_RSK,
             UPD_INFO_DT,
             SENIOR_IMPT_PSN_FLG,
             REL_STAT,
             PP1_NO,
             PP1_ISU_DT,
             PP1_EXP_DT,
             PP2_NO,
             PP2_ISU_DT,
             PP2_EXP_DT,
             PP3_NO,
             PP3_ISU_DT,
             PP3_EXP_DT,
             OTH_CRDL_TYP1,
             OTH_CRDL_NO1,
             OTH_CRDL_TYP2,
             OTH_CRDL_NO2,
             DEPT_LINE,
             DATA_SRC,
             ROW_NUMBER() OVER(PARTITION BY T.CUST_ID,T.REL_TYP,T.REL_PSN_TYP ORDER BY T.DATA_SRC,
               T.REL_PSN_CRDL_TYP NULLS LAST,T.REL_PSN_CRDL_NO DESC NULLS LAST) AS NUM,
             /*CASE WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(T.REL_PSN_CRDL_NO,1,6))
              END||REGEXP_REPLACE(T.REL_PSN_CUST_NM,'[[:punct:]]','')||UPPER(T.REL_PSN_CRDL_NO)
                            AS CWFZRZJHM */ --财务负责人证件号码 --MODIFY BY LIP 20220628
       UPPER(T.REL_PSN_CRDL_NO) AS CWFZRZJHM  --财务负责人证件号码 不做拼接--MODIFY BY LZM 20251128
        FROM RRP_MDL.M_CUST_CORP_REL_SUB T
       WHERE T.REL_PSN_TYP = '05'
         AND T.DATA_DT = V_P_DATE; --财务主管

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- STEP5: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '对公客户信息表--上市情况临时表处理插入临时表03';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_YBT.TMP_SDIS_T_2_1_03';
  INSERT INTO RRP_YBT.TMP_SDIS_T_2_1_03
      (DATA_DT,
       CUST_ID,
       LISTED_COMPANY
       )
       SELECT DATA_DT
             ,CUST_ID
             ,CASE WHEN IPO_TYP IS NOT NULL AND CTRY_CD IS NOT NULL THEN
                        CASE WHEN IPO_CO_STK_CD LIKE '%、%' THEN IPO_TYP||'-'||CTRY_CD||'-'||REGEXP_SUBSTR(IPO_CO_STK_CD,'[^、]+',1,1)||';'||IPO_TYP||'-'||CTRY_CD||'-'||REGEXP_SUBSTR(IPO_CO_STK_CD,'[^、]+',1,2)
                             ELSE IPO_TYP||'-'||CTRY_CD||'-'||IPO_CO_STK_CD
                             END
                   WHEN IPO_TYP IS NULL AND CTRY_CD IS NOT NULL THEN
                        CASE WHEN IPO_CO_STK_CD LIKE '%、%' THEN CTRY_CD||'-'||REGEXP_SUBSTR(IPO_CO_STK_CD,'[^、]+',1,1)||';'||CTRY_CD||'-'||REGEXP_SUBSTR(IPO_CO_STK_CD,'[^、]+',1,2)
                             ELSE CTRY_CD||'-'||IPO_CO_STK_CD
                             END
                   WHEN IPO_TYP IS NULL AND CTRY_CD IS NULL THEN
                        CASE WHEN IPO_CO_STK_CD LIKE '%、%' THEN REGEXP_REPLACE(IPO_CO_STK_CD,'、',';')
                             ELSE IPO_CO_STK_CD
                             END
                   END AS LISTED_COMPANY    --上市情况      --MODIFY BY YYH 20251104
        FROM
       (
      SELECT A.DATA_DT,
             A.CUST_ID,
             CASE WHEN UPPER(F.IPO_TYP) = 'A' OR ((UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+'))='SZ') AND REGEXP_SUBSTR(F.IPO_CO_STK_CD,'\d+') LIKE '0%')
                    OR ((UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+'))='SH') AND REGEXP_SUBSTR(F.IPO_CO_STK_CD,'\d+') LIKE '6%') THEN 'A'
                  WHEN UPPER(F.IPO_TYP) = 'B' OR ((UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+'))='SZ') AND REGEXP_SUBSTR(F.IPO_CO_STK_CD,'\d+') LIKE '200%')
                    OR ((UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+'))='SH') AND REGEXP_SUBSTR(F.IPO_CO_STK_CD,'\d+') LIKE '900%') THEN 'B'
                  WHEN UPPER(F.IPO_TYP) = 'H' OR UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+'))='HK' OR TRIM(F.CTRY_CD) = 'HKG' THEN 'C'
                  WHEN UPPER(F.IPO_TYP) IN ('N','S','F') OR (LENGTH(TRIM(F.CTRY_CD))= 3 AND TRIM(F.CTRY_CD) NOT IN ('CHN','HKG')) THEN 'D'
                  END                                          AS IPO_TYP,            --上市类型
             CASE WHEN LENGTH(TRIM(F.CTRY_CD))= 3 THEN TRIM(F.CTRY_CD)
                  WHEN UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+')) LIKE '%SZ%' OR UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+')) LIKE '%SH%' THEN 'CHN'
                  WHEN UPPER(REGEXP_SUBSTR(F.IPO_CO_STK_CD,'[A-Za-z]+')) LIKE '%HK%' THEN 'HKG'
                  END                                          AS CTRY_CD,            --上市国别
             REGEXP_REPLACE(F.IPO_CO_STK_CD,'[^0-9、]','')     AS IPO_CO_STK_CD       --上市公司代码

        FROM RRP_MDL.M_CUST_CORP_INFO A  -- 对公客户基本信息

        INNER JOIN RRP_MDL.M_CUST_CORP_IPO_SUB F  -- 单一法人客户上市情况子表
                ON F.CUST_ID = A.CUST_ID
                AND F.DATA_DT = V_P_DATE
                AND REGEXP_REPLACE(F.IPO_CO_STK_CD,'[^0-9、]','') IS NOT NULL

        WHERE A.DATA_DT = V_P_DATE
        )
          ;

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- STEP5: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '获取单一法人客户数据到 表2.1 单一法人基本情况临时表04';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_YBT.TMP_SDIS_T_2_1_04';
  INSERT INTO RRP_YBT.TMP_SDIS_T_2_1_04
      (
       CUST_ID
       )
  --RRP_CRRS.CRRS_ENT_CREDIT
  SELECT DISTINCT A.CUST_ID
      FROM RRP_YBT.CUSTOMER_FLAG_YBT A      --业务客户前置表 MOD BY YYH 20251120 以一表通其他业务表出现的客户号限制客户表的客户范围
INNER JOIN RRP_MDL.M_CUST_CORP_INFO CUST1   --对公客户信息
        ON A.CUST_ID = CUST1.CUST_ID
       AND CUST1.DATA_DT = V_P_DATE
       --AND CUST1.TYBZ = 'N'  --同业标志为否
 LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B
        ON A.CUST_ID = B.CUST_ID
       AND B.ETL_DT = V_ETL_DATE
     WHERE A.DATA_DT = V_P_DATE
       AND A.CUST_TP <> '同业客户'                        --剔除同业客户 2.3同业客户范围
       AND CUST1.CUST_CL <> 'E'                         --剔除个体工商户 2.4对公客户号个体工商户范围
       AND NVL(TRIM(B.CRDT_CUST_TYPE_CD),'-') <> '5'    --剔除虚拟集团号 2.2虚拟集团客户号范围
  UNION
  --RRP_CRRS.CRRS_ENT_GROUP_CLIENT
  SELECT DISTINCT GRP.MBR_CUST_ID           --取集团下成员客户（实体）的客户号
      FROM RRP_MDL.M_CRDT_LMT_SUB A         --授信额度子表
     INNER JOIN (SELECT B.CUST_ID
               ,B.DATA_DT
               ,B.GRP_MBR_NUM
               ,C.MBR_CUST_ID
               ,C.MBR_NM
             FROM RRP_MDL.M_CUST_CORP_GRP_SUB B --集团客户信息子表
            INNER JOIN RRP_MDL.M_CUST_CORP_GRPMBR_SUB C --集团客户成员子表
             ON B.CUST_ID = C.GRP_CUST_ID
            AND C.DATA_DT = V_P_DATE
            WHERE B.DATA_DT = V_P_DATE ) GRP    --判断集团客户
      ON GRP.MBR_CUST_ID = A.CUST_ID
       AND GRP.GRP_MBR_NUM > 1  --MOD BY YJY 20241107调整集团成员数大于1
       INNER JOIN RRP_MDL.M_CUST_CORP_INFO E --对公客户信息
      ON E.CUST_ID = GRP.CUST_ID
       AND E.DATA_DT = V_P_DATE
       AND E.TYBZ = 'N'   --MOD BY YJY 20250402 剔除同业客户的数据
     WHERE A.DATA_DT = V_P_DATE
       AND A.CRDT_LMT > 0
       AND (A.CRDT_STAT = 'Y' OR A.CRDT_EXP_DT >= V_P_DATE)
       AND A.GROUP_CRDT_FLG = '1'
       AND A.DATA_SRC <> '转授信'
       AND A.CUST_ID_ZT_FLG <> 'Y' -- MOD BY YJY 20250228
       AND A.CRDT_CONT_ID NOT IN (SELECT CRDT_CONT_ID_KHFX --转授信客户的额度合同
                    FROM RRP_MDL.M_CRDT_LMT_SUB   --授信额度子表
                     WHERE DATA_DT = V_P_DATE
                     AND DATA_SRC = '转授信' -- MOD BY YJY 20241107
                     AND CUST_ID_ZT_FLG <> 'Y') -- MOD BY YJY 20250228
  UNION
  SELECT DISTINCT A.CUST_ID
   FROM (SELECT DISTINCT CUST_ID,CRDT_CONT_ID_KHFX,CUR,CRDT_LMT
          FROM RRP_MDL.M_CRDT_LMT_SUB
         WHERE CRDT_STAT = 'Y'
           AND CRDT_LMT > 0
           AND DATA_SRC = '转授信'
           AND DATA_DT = V_P_DATE
           AND CUST_ID_ZT_FLG <> 'Y' ) A -- 授信额度子表 -- MOD BY YJY 20250228
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO CUST1 --对公客户信息  取供应链融资成员客户名称
      ON CUST1.CUST_ID = A.CUST_ID
       AND CUST1.DATA_DT = V_P_DATE
       AND CUST1.CUST_CL <> 'E'         --剔除个体工商户
       AND CUST1.TYBZ = 'N'   --MOD BY YJY 20250402 剔除同业客户的数据

     INNER JOIN RRP_MDL.M_LOAN_CONT_INFO D  --贷款合同信息
      ON D.CONT_ID = A.CRDT_CONT_ID_KHFX
       AND D.DATA_DT = V_P_DATE

  ;

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP6: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表2.1 单一法人基本情况';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_YBT.SDIS_T_2_1
             (
 RID              -- 数据主键
,B010001          -- 客户ID
,B010002          -- 机构ID
,B010003          -- 对公客户名称
,B010004          -- 统一社会信用代码
,B010005          -- 组织机构登记年检更新日期
,B010006          -- 登记注册代码
,B010007          -- 登记注册年检更新日期
,B010008          -- 全球法人识别编码
,B010019          -- 注册资本
,B010020          -- 注册资本币种
,B010021          -- 实收资本
,B010022          -- 实收资本币种
,B010023          -- 成立日期
,B010024          -- 经营范围
,B010025          -- 行业类型
,B010026          -- 对公客户类型
,B010027          -- 控股类型
,B010028          -- 注册地国家地区
,B010029          -- 注册地址
,B010030          -- 注册地行政区划
,B010031          -- 电话号码
,B010032          -- 法定代表人姓名
,B010033          -- 法定代表人证件类型
,B010034_ORIG      -- 法定代表人证件号码（脱敏前）
,B010034          -- 法定代表人证件号码
,B010035          -- 财务人员姓名
,B010036          -- 财务人员证件类型
,B010037_ORIG      -- 财务人员证件号码（脱敏前）
,B010037          -- 财务人员证件号码
,B010038          -- 基本存款账号
,B010039          -- 基本存款账户开户行行号
,B010040          -- 基本存款账户开户行名称
,B010041          -- 员工人数
,B010042          -- 上市情况
,B010043          -- 新型农业经营主体标识
,B010044          -- 外部评级结果
,B010045          -- 信用评级机构
,B010046          -- 内部评级结果
,B010047          -- 环境和社会风险分类
,B010048          -- 首次建立信贷关系年月
,B010049          -- 风险预警信号
,B010050          -- 关注事件代码
,B010053          -- 关停企业标识
,B010057          -- 母公司名称
,B010058          -- 违约概率
,B010061          -- 科技企业类型
,ADDRESS          -- 地区
,B010060          -- 采集日期
,DEPT_NO          -- 条线
,ISSUED_NO          -- 填报机构
,RPT_ORG_NO          -- 报送机构
,DATA_DT          -- 数据日期
)

SELECT       SYS_GUID()               AS RID                    --数据主键
            ,A.CUST_ID                AS B010001                --客户ID
                        /*
                    ,CASE WHEN B.ORG_ID IS NULL THEN 'B1194H24405000000'
                        WHEN B.ORG_ID = '802' THEN 'B1194B34405802'
                        WHEN B.FIN_PERMIT_NO IS NULL  THEN 'B1194H24405'||SUBSTR(B.ORG_ID,1,13)
                        ELSE SUBSTR(B.FIN_PERMIT_NO,1,11)||SUBSTR(B.ORG_ID,1,13)
                        END                 AS B010002              --机构ID
                        */
            ,NVL(B.FIN_ORG_NO,'B1194H24405800')
                                      AS B010002                --机构ID
            ,CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                    ELSE TRIM(A.CUST_NM)
                    END               AS B010003                --对公客户名称
            ,REGEXP_REPLACE(F.CERT_NUM,'[^0-9a-zA-Z]','')
                                      AS B010004                --统一社会信用代码
            ,NVL(TO_CHAR(COALESCE(R.START_DT,R.CERT_EFFECT_DT,F.START_DT,F.CERT_EFFECT_DT),'YYYY-MM-DD'),'9999-12-31')
                                      AS B010005                --组织机构登记年检更新日期
            ,CASE WHEN G.PARTY_ID IS NOT NULL THEN G.CERT_NUM
                  WHEN J.PARTY_ID IS NOT NULL THEN J.CERT_NUM
            END                       AS B010006                --登记注册代码
            ,NVL(TO_CHAR(COALESCE(G.START_DT,G.CERT_EFFECT_DT,J.START_DT,J.CERT_EFFECT_DT),'YYYY-MM-DD')
                ,'9999-12-31')
                                      AS B010007                --登记注册年检更新日期
            ,K.LEI_ID                 AS B010008                --全球法人识别编码
            ,CASE WHEN A.REGD_CPTL > 0 THEN ROUND(A.REGD_CPTL,2)
                  END                 AS B010019                --注册资本
            ,CASE WHEN TRIM(A.REGD_CPTL_CUR) = 'CCC' THEN 'CNY'
                  WHEN UPPER(REGEXP_SUBSTR(A.REGD_CPTL_CUR,'[A-Za-z]+')) IS NOT NULL THEN TRIM(A.REGD_CPTL_CUR)
                  WHEN TRIM(A.REGD_CPTL_CUR) IS NULL AND A.REGD_CPTL >0 AND (A.BIO_FLG = 'Y' OR A.REGD_LAND_CTRY_CD IN ('CHN','XXX')) THEN 'CNY'
                  END                 AS B010020                --注册资本币种
            ,CASE WHEN A.PAID_IN_CPTL > 0 THEN ROUND(A.PAID_IN_CPTL,2)
                  END                 AS B010021                --实收资本
            ,CASE WHEN TRIM(A.PAID_IN_CPTL_CUR) = 'CCC' THEN 'CNY'
                  WHEN UPPER(REGEXP_SUBSTR(A.PAID_IN_CPTL_CUR,'[A-Za-z]+')) IS NOT NULL THEN TRIM(A.PAID_IN_CPTL_CUR)
                  WHEN TRIM(A.PAID_IN_CPTL_CUR) IS NULL AND A.PAID_IN_CPTL > 0 THEN 'CNY'
                  END                 AS B010022                --实收资本币种
            ,NVL(TO_CHAR(TO_DATE(A.ESTM_DT,'YYYY-MM-DD'),'YYYY-MM-DD'),'9999-12-31')
                                      AS B010023                --成立日期
            ,SUBSTRB(TRIM(REPLACE(REPLACE(A.OPR_SCOPE,CHR(10),''),CHR(13),'')),1,2000)
                                      AS B010024                --经营范围
            ,CASE WHEN TRIM(A.REGD_LAND_CTRY_CD) NOT IN ('CHN','XXX') THEN '99999'
                  ELSE TRIM(A.CUST_BLNG_IDY)
                  END                 AS B010025                --行业类型
            ,CASE WHEN A.NATL_ECON_DEPT_CL LIKE 'E%' THEN '09'         --境外机构
                  WHEN A.NATL_ECON_DEPT_CL IN ('A01','A02') THEN '05'  --政府机关
                  WHEN A.CUST_CL = 'C' THEN '06'                       --事业单位
                  WHEN A.CUST_CL = 'D' THEN '07'                       --社会团体
                  WHEN A.CUST_CL LIKE 'A%' AND (LO.IS_CBRC_ENT='Y' OR A.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')) AND A.ENT_SCALE = 'L' THEN '01'
                  WHEN A.CUST_CL LIKE 'A%' AND (LO.IS_CBRC_ENT='Y' OR A.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')) AND A.ENT_SCALE = 'M' THEN '02'
                  WHEN A.CUST_CL LIKE 'A%' AND (LO.IS_CBRC_ENT='Y' OR A.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')) AND A.ENT_SCALE = 'S' THEN '03'
                  WHEN A.CUST_CL LIKE 'A%' AND (LO.IS_CBRC_ENT='Y' OR A.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）')) AND A.ENT_SCALE = 'X' THEN '04'
                  --WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'L' THEN '01'
                  --WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'M' THEN '02'
                  --WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'S' THEN '03'
                  --WHEN A.CUST_CL LIKE 'A%' AND A.ENT_SCALE = 'X' THEN '04'
                  ELSE '08'                                             --其他组织机构
                  END                 AS B010026                --对公客户类型         --20251202根据1104指标核对反馈原口径指标对不上，故调整客户分类为企业的口径
            ,CASE WHEN P.CUST_ID IS NOT NULL AND A.CUST_CL = 'E' THEN NULL        --20251202根据1104报表核对专员ZLY要求特殊处理
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) LIKE 'A%' THEN '01'
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) LIKE 'B%' THEN '02'
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) LIKE 'C%' THEN '03'
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) LIKE 'D%' THEN '04'
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) LIKE 'E%' THEN '05'
                  WHEN SUBSTR(A.ENT_HLDG_TYP,1,3) = 'X' THEN '06'
                  END                 AS B010027                --控股类型
            ,CASE WHEN TRIM(A.REGD_LAND_CTRY_CD) IS NOT NULL AND TRIM(A.REGD_LAND_CTRY_CD)<>'XXX' THEN TRIM(A.REGD_LAND_CTRY_CD)
                  WHEN TRIM(A.REGD_LAND_CTRY_CD)='XXX' THEN 'CHN'
                  END                 AS B010028                --注册地国家地区
            ,REMOVE_SPECIAL_CHARS(SUBSTRB(TRIM(REPLACE(REPLACE(A.REGD_ADDR,CHR(10),''),CHR(13),'')),1,255))
                                      AS B010029                --注册地址
            ,CASE WHEN TRIM(A.REGD_LAND_CTRY_CD) NOT IN ('CHN','XXX') AND TRIM(A.REGD_LAND_CTRY_CD) IS NOT NULL THEN TRIM(A.REGD_LAND_CTRY_CD)
                  WHEN TRIM(A.OPR_LAND_AREA_CD) <> '000000' THEN TRIM(A.OPR_LAND_AREA_CD)
                  ELSE TRIM(A.REGD_LAND_AREA_CD)
                  END                 AS B010030                --注册地行政区划
            ,A.TEL                    AS B010031                --电话号码
            ,REMOVE_SPECIAL_CHARS(D.REL_PSN_CUST_NM)
                                      AS B010032                --法定代表人姓名
            ,CASE WHEN D.REL_PSN_CRDL_TYP = '1998' THEN '1999'         --20260114陈俊文：1998-无证件 对公映射至2999-其他证件（对公）个人映射至1999-其他证件（个人）
                  ELSE CODE1.TAR_VALUE_CODE
                  END                 AS B010033                --法定代表人证件类型
            ,CASE WHEN D.REL_PSN_CRDL_TYP = '1998' THEN NULL
                  ELSE REMOVE_SPECIAL_CHARS(D.FRDBZJHM)
                  END                 AS B010034_ORIG           --法定代表人证件号码(脱敏前)
            ,NULL                     AS B010034                --法定代表人证件号码
            ,CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([0-9\-])+$') THEN NULL
                  ELSE REPLACE(REPLACE(E.REL_PSN_CUST_NM,CHR(10),''),CHR(13),'')
                  END                 AS B010035                --财务人员姓名
            ,CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([0-9\-])+$') THEN NULL
          --WHEN E.REL_PSN_CRDL_TYP = '1998' THEN '1999'
            ELSE CODE2.TAR_VALUE_CODE
          END           AS B010036                --财务人员证件类型
            ,CASE WHEN REGEXP_LIKE(TRIM(E.REL_PSN_CUST_NM),'^([0-9\-])+$') THEN NULL
                  WHEN E.REL_PSN_CRDL_TYP = '1998' THEN NULL
                  ELSE REPLACE(REPLACE(E.CWFZRZJHM,CHR(10),''),CHR(13),'')
                  END                 AS B010037_ORIG           --财务人员证件号码(脱敏前)
            ,NULL                     AS B010037                --财务人员证件号码
            ,REMOVE_SPECIAL_CHARS(TRIM(A.BSC_DEP_ACC))
                                      AS B010038                --基本存款账号
            ,CASE WHEN TRIM(A.BSC_DEP_ACC) IS NULL THEN NULL
                  ELSE NVL(MM.FIN_INST_CODE,A.BSC_ACC_OPEN_BANK_ID)
                  END                 AS B010039                --基本存款账户开户行行号
            ,CASE WHEN TRIM(A.BSC_DEP_ACC) IS NULL THEN NULL
                  ELSE NVL(A.BSC_ACC_OPEN_BANK_NM,MM.ORG_NAME)
                  END                 AS B010040                --基本存款账户开户行名称
            ,CASE WHEN LENGTH(A.EMP_NUM)<=8 AND A.EMP_NUM > 0 THEN A.EMP_NUM
                  END                 AS B010041                --员工人数
            ,N.LISTED_COMPANY         AS B010042                --上市情况
            ,'0'                      AS B010043                --新型农业经营主体标识                    --口径无法取得有效值，默认为否，如需加工需要业务提供新口径或补录名单
            ,CASE WHEN TRIM(L.RATING_ORG_NAME) IS NOT NULL AND TRIM(L.RATING_ORG_NAME) NOT IN ('无','空') THEN TRIM(L.RATING_LEVEL_CD)   --与公司部陈俊文确认，信用评级机构非有效值时，外部评级结果不取
                  END                 AS B010044                --外部评级结果
            ,CASE WHEN TRIM(L.RATING_ORG_NAME) NOT IN ('无','空') THEN TRIM(L.RATING_ORG_NAME)
                  END                 AS B010045                --信用评级机构
            ,A.INR_RTG                AS B010046                --内部评级结果
            ,A.MJR_ENV_SAFE_RSK_ENT_CL
                                      AS B010047                --环境和社会风险分类
            ,CASE WHEN Q.CUST_ID IS NOT NULL AND Q.FIR_LON_DT NOT IN ('00010101','20991231') THEN TO_CHAR(TO_DATE(Q.FIR_LON_DT,'YYYYMMDD'),'YYYY-MM')
                  WHEN TRIM(A.FIRST_ESTBL_CRDT_REL_DT) IN ('00010101','20991231') THEN '9999-12'
                  ELSE TO_CHAR(TO_DATE(A.FIRST_ESTBL_CRDT_REL_DT,'YYYYMMDD'),'YYYY-MM')
                  END                 AS B010048                --首次建立信贷关系年月
            ,NULL                     AS B010049                --风险预警信号 填null
            ,NULL                     AS B010050                --关注事件代码 填null
            /*,DECODE(M1.SFGTQY,'Y','1'
                             ,'N','0'
                             ,M1.SFGTQY)
                             */
            ,DECODE(A.ENT_CLOSE_FLG,'Y','1','N','0','0')
                                      AS B010053                --关停企业标识
            ,CASE WHEN REGEXP_REPLACE(GRP.MO_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                  THEN REPLACE(REPLACE(REPLACE(TRIM(GRP.MO_NM),'(','（'),')','）'),' ','')
                  ELSE TRIM(GRP.MO_NM)
                  END                 AS B010057                --母公司名称
            ,A.PD                     AS B010058                --违约概率
            ,(CASE WHEN A.TECH_ENT_FLG = 'Y'  AND A.ENT_SCALE IN ('M','S') THEN '1' ELSE '0' END)   --科技型中小企业标识
             ||(CASE WHEN A.PRCN_SML_CUST_FLG = 'Y' THEN '1' ELSE '0' END)               --专精特新中小企业标识
             ||(CASE WHEN A.PRCN_LG_CUST_FLG = 'Y' THEN '1' ELSE '0' END)               --专精特新小巨人企业标识
             ||(CASE WHEN A.CTY_TECH_INOVT_CORP_FLG = 'Y' THEN '1' ELSE '0' END)                    --国家技术创新示范企业标识
             ||(CASE WHEN A.ITEM_CORP_FLG = 'Y' THEN '1'  ELSE '0' END)                             --制造业单项冠军企业标识
             ||(CASE WHEN A.HIGH_TECH_ENT_FLG = 'Y' THEN '1' ELSE '0' END)                          --高新技术企业标识
                                      AS B010061                --科技企业类型
            ,NULL                     AS ADDRESS                --地区
            ,TO_CHAR(TO_DATE(V_P_DATE,'YYYY-MM-DD'),'YYYY-MM-DD')
                                      AS B010060                --采集日期
            ,'GSYHB'                  AS DEPT_NO                --条线
            ,'000000'                 AS ISSUED_NO              --填报机构
            ,'000000'                 AS RPT_ORG_NO             --报送机构
            ,V_P_DATE                 AS DATA_DT                --数据日期
FROM RRP_MDL.M_CUST_CORP_INFO A --对公客户信息

LEFT JOIN (
     SELECT CUST_ID
           ,MAX(IS_CBRC_ENT) AS IS_CBRC_ENT
                FROM RRP_MDL.S_LOAN
               WHERE DATA_DT=V_P_DATE
            GROUP BY CUST_ID
            ) LO
        ON A.CUST_ID = LO.CUST_ID

/*
        LEFT JOIN RRP_MDL.ORG_CONFIG M  --机构映射表
               ON M.ORG_ID = A.ORG_ID
        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO B --机构表
               ON B.ORG_ID = NVL(M.ORG_ID1,'800')
              AND B.DATA_DT = V_P_DATE
              */
        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_YBT B              --20251205统一取机构号
               ON B.ORG_ID = A.ORG_ID
              AND B.DATA_DT = V_P_DATE

        LEFT JOIN RRP_YBT.TMP_SDIS_T_2_1_02 E --表2.1单一法人基本情况临时表02(加工财务主管信息)
               ON E.CUST_ID = A.CUST_ID
              AND E.NUM = 1

        LEFT JOIN RRP_YBT.TMP_SDIS_T_2_1_01 D --表2.1单一法人基本情况临时表01(加工法定代表人信息)
               ON D.CUST_ID = A.CUST_ID
              AND D.NUM = 1

       LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值映射表
              ON CODE1.SRC_VALUE_CODE = D.REL_PSN_CRDL_TYP
             AND CODE1.SRC_CLASS_CODE = 'CD1014' --证件类型
             AND CODE1.TAR_CLASS_CODE = 'CD1014' --证件类型
             AND CODE1.MOD_FLG = 'YBT'

       LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值映射表
              ON CODE2.SRC_VALUE_CODE = E.REL_PSN_CRDL_TYP
             AND CODE2.SRC_CLASS_CODE = 'CD1014' --证件类型
             AND CODE2.TAR_CLASS_CODE = 'CD1014' --证件类型
             AND CODE2.MOD_FLG = 'YBT'

        LEFT JOIN RRP_MDL.ORG_CONFIG MM   --机构配置表 取基本存款账户开户行号
               ON MM.ORG_ID = A.BSC_ACC_OPEN_BANK_ID

/*
        LEFT JOIN (SELECT TTT.SFGTQY
                          ,KHWYM
                          ,ROW_NUMBER() OVER(PARTITION BY KHWYM ORDER BY BXCDJMFYLB) AS RN
                   FROM RRP_MDL.M_ADD_DG_001_CUST TTT
                  WHERE TTT.DATA_DATE = V_P_DATE
                  ) M1 --补录表-对公-客户基表（应急处理，KHWYM客户唯一码存在重复，后面修改）
            ON M1.KHWYM = A.CUST_ID
            AND M1.RN = 1
            */

        LEFT JOIN
            (
            SELECT F.PARTY_ID
                  ,F.CERT_TYPE_CD
                  ,F.CERT_NUM
                  ,F.START_DT
                  ,F.CERT_EFFECT_DT
                  ,ROW_NUMBER() OVER(PARTITION BY F.PARTY_ID ORDER BY
                  (CASE WHEN F.CERT_TYPE_CD = '2313' THEN '1'       --营业执照（统一社会信用代码）
                        WHEN F.CERT_TYPE_CD = '2314' THEN '2'       --登记证书
                        WHEN F.CERT_TYPE_CD = '2072' THEN '3'       --地税登记证（18位）
                        WHEN F.CERT_TYPE_CD = '2071' THEN '4'       --国税登记证（18位）
                        END)
                                    ) AS RN
              FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H F            --当事人证件信息历史     取统一社会信用代码       --MODIFY BY YYH
             WHERE F.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               AND F.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               AND F.SORC_SYS_CD = 'EIFS'
               AND (
                    (F.CERT_TYPE_CD = '2313' AND LENGTH(REGEXP_REPLACE(F.CERT_NUM,'[^0-9a-zA-Z]','')) <= 18)
                        OR
                    (F.CERT_TYPE_CD IN ('2314','2072','2071') AND LENGTH(REGEXP_REPLACE(F.CERT_NUM,'[^0-9a-zA-Z]','')) = 18)
                    )
            ) F
            ON F.PARTY_ID = A.CUST_ID
           AND F.RN = 1

      LEFT JOIN
            (
            SELECT G.PARTY_ID
                  ,G.CERT_TYPE_CD
                  ,G.CERT_NUM
                  ,G.START_DT
                  ,G.CERT_EFFECT_DT
                  ,ROW_NUMBER() OVER(PARTITION BY G.PARTY_ID ORDER BY
                  (CASE WHEN G.CERT_TYPE_CD = '2501' THEN '1'       --工商注册号
                        WHEN G.CERT_TYPE_CD = '2321' THEN '2'       --机关和事业单位登记号
                        WHEN G.CERT_TYPE_CD = '2030' THEN '3'       --社会团体法人登记证书
                        END)
                                    ) AS RN
              FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H G            --当事人证件信息历史     取登记注册代码       --MODIFY BY YYH
             WHERE G.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
               AND G.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
               AND G.SORC_SYS_CD = 'EIFS'
               AND G.CERT_TYPE_CD IN ('2501','2321','2030')
            ) G
            ON G.PARTY_ID = A.CUST_ID
           AND G.RN = 1

     LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H R  --当事人证件信息历史
        ON R.PARTY_ID = A.CUST_ID
       AND R.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND R.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       AND R.CERT_TYPE_CD  = '2020'                   --组织机构代码证
       AND R.SORC_SYS_CD = 'EIFS'                  --源系统代码

        LEFT JOIN (
                    SELECT
                        J1.PARTY_ID
                        ,J1.CERT_NUM
                        ,J1.START_DT
                        ,J1.CERT_EFFECT_DT
                        ,ROW_NUMBER() OVER(PARTITION BY J1.PARTY_ID ORDER BY J1.CERT_TYPE_CD) AS RN
                    FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H J1  --当事人证件信息历史
                    WHERE J1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND J1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                    AND J1.CERT_TYPE_CD NOT IN('2313','2501','2321','2030') --其它
                    AND J1.SORC_SYS_CD = 'EIFS'                  --源系统代码
                )J
        ON A.CUST_ID = J.PARTY_ID
        AND J.RN = 1

        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO K --对公客户补充信息
               ON A.CUST_ID = K.CUST_ID
              AND K.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')

        LEFT JOIN RRP_YBT.TMP_SDIS_T_2_1_03 N --上市情况临时表处理插入临时表03
               ON N.CUST_ID = A.CUST_ID

    LEFT JOIN (SELECT L.PARTY_ID
            ,L.RATING_ORG_NAME
            ,DECODE(L.RATING_LEVEL_CD,'AAA+','1','AAA','2','AAA-','3','AA+','4','AA','5','AA-','6','A+','7',
                'A','8','A-','9','BBB+','10','BBB','11','BBB-','12','BB','13','B','14','C','15','D','16',
                L.RATING_LEVEL_CD
                ) AS RATING_LEVEL_CD
            ,ROW_NUMBER()OVER(PARTITION BY PARTY_ID ORDER BY DECODE(L.RATING_LEVEL_CD,'AAA+','1','AAA','2',
                'AAA-','3','AA+','4','AA','5','AA-','6','A+','7','A','8','A-','9','BBB+','10','BBB','11',
                'BBB-','12','BB','13','B','14','C','15','D','16',L.RATING_LEVEL_CD)
                ) RN
          FROM RRP_MDL.O_IML_PTY_PARTY_RATING_H L  --当事人评级信息
           WHERE
               L.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
           AND L.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
           AND L.ID_MARK <> 'D'
           AND L.RATING_INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                     --AND L.SRC_TABLE_NAME IN('crss_customer_rate_result','nrrs_gs_yearratresult')
           )L
      ON L.PARTY_ID = A.CUST_ID
     AND L.RN = 1

    LEFT JOIN
        (SELECT DISTINCT B.MBR_CUST_ID,C.MO_NM
              FROM (SELECT MBR_CUST_ID
                          ,GRP_CUST_ID
                            FROM RRP_MDL.M_CUST_CORP_GRPMBR_SUB
                           WHERE DATA_DT = V_P_DATE
                    ) B --集团客户成员子表
        INNER JOIN (SELECT MBR_CUST_ID AS MO_ID     --母公司ID
              ,MBR_NM AS MO_NM      --母公司名称
                          ,GRP_CUST_ID
                            FROM RRP_MDL.M_CUST_CORP_GRPMBR_SUB
                           WHERE PAR_CO_FLG = 'Y'
                             AND DATA_DT = V_P_DATE
                    ) C --集团客户成员子表
                ON B.GRP_CUST_ID = C.GRP_CUST_ID
        ) GRP
    ON A.CUST_ID = GRP.MBR_CUST_ID

       LEFT JOIN (SELECT Q.CUST_ID
                        ,MIN(Q.FIR_LON_DT) AS FIR_LON_DT
                  FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO Q
                  WHERE TRIM(Q.FIR_LON_DT) IS NOT NULL
                  AND Q.DATA_DT = V_P_DATE
                  --AND Q.FIR_LON_DT NOT IN ('00010101','20991231')
          GROUP BY Q.CUST_ID
                ) Q --表内借据信息
         ON Q.CUST_ID = A.CUST_ID

    LEFT JOIN (SELECT DISTINCT CASE WHEN DATA_SRC = '票据转贴现' THEN NVL(DISCNT_CUST_ID,'-')
                                    WHEN LOAN_STD_PROD_ID IN ('203020300002','203030600002') THEN LC_BENEFC --二级福费廷取受益人
                                    ELSE CUST_ID
                                    END AS CUST_ID
                           FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO WHERE LOAN_STD_PROD_ID = '203030500015' AND DATA_DT = V_P_DATE) P --表内借据信息
         ON A.CUST_ID = P.CUST_ID

    INNER JOIN RRP_YBT.TMP_SDIS_T_2_1_04 O --取单一法人客户(有业务)， 集团客户授信中有表内外业务余额或授信额度的成员客户信息
            ON A.CUST_ID = O.CUST_ID

        WHERE A.DATA_DT = V_P_DATE
          --AND A.OPR_STAT <> '02'  --停业
    ;

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP4: 表分析 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  RRP_YBT.ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP5: 跑批结束 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
       VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 异常处理 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_SDIS_T_2_1;
/

