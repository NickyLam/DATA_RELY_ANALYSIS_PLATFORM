CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_ENTRS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_ENTRS
  *  功能描述：委托贷款业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CUST_IND_INFO
  *            M_LOAN_ENTRS_SUB
  *            M_CUST_CORP_INFO
  *            M_LOAN_IN_DUBILL_INFO
  *
  *
  *
  *
  *  目标表：  S_LOAN_ENTRS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231206  HYF      修改金融机构委托标志
  *             2    20241107  HYF      调整贷款余额取值
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_ENTRS'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_ENTRS'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_ENTRS T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_ENTRS'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'S_LOAN_ENTRS', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '委托贷款业务整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_ENTRS
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       RCPT_ID, --借据编号
       CUST_ID, --借款人客户编号
       CONSR_CUST_ID, --委托人客户编号
       BIZ_CUR, --业务币种
       LOAN_BAL, --贷款余额
       ENTRS_LOAN_SUB_CL, --委托贷款细类
       CUST_LRG_CL, --借款人大类
       CUST_TYP, --借款人类型
       CUST_CORP_TYP, --借款人对公客户类型
       CUST_ENT_HLDG_TYP, --借款人企业控股类型
       CUST_OPR_CUST_TYP, --借款人经营性客户类型
       CUST_ENT_SCALE, --借款人企业规模
       CONSR_TYP, --委托人类型
       HPF_LOAN_FLG, --住房公积金贷款标志
       BIO_LOAN_FLG, --境内外贷款标志
       LOAN_DIR_IDY, --贷款投向行业
       ENTRS_LOAN_SPCL_DIR, --委托贷款特殊投向
       DEPT_LINE, --部门条线
       DATA_SRC, --数据来源
       ENTRS_LOAN_USEAGE, --委托贷款用途
       FI_ENTRS_IND, --金融机构委托标志
       CUST_BLNG_IDY --借款人客户所属行业
       )
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             B.ORG_ID AS ORG_ID, --机构编号
             A.RCPT_ID AS RCPT_ID, --借据编号
             B.CUST_ID AS CUST_ID, --借款人客户编号
             A.CONSR_CUST_ID AS CONSR_CUST_ID, --委托人客户编号
             B.CUR AS BIZ_CUR, --业务币种
             A.LOAN_BAL AS LOAN_BAL, --贷款余额
             A.ENTRS_LOAN_SUM_CL AS ENTRS_LOAN_SUB_CL, --委托贷款细类
             CASE
               WHEN F.CUST_ID IS NOT NULL OR E.CUST_CL = 'E' THEN
                '01' --对私客户(含个体工商户)
               WHEN E.CUST_ID IS NOT NULL AND E.CUST_CL != 'E' THEN
                '02' --对公客户（剔除个体工商户）
             END AS CUST_LRG_CL, --借款人大类
             CASE
               WHEN F.RSDNT_FLG = 'N' OR E.RSDNT_FLG = 'N' THEN
                'B04' --境外
               WHEN F.CUST_ID IS NOT NULL THEN
                'B03' --个人
               WHEN E.FIN_ORG_TYP = 'A10000' THEN
                'A01' --中央银行
               WHEN E.FIN_ORG_TYP LIKE 'C%' THEN
                'A02' --存款类金融机构
               WHEN E.FIN_ORG_TYP LIKE 'D%' THEN
                'A03' --非存款类金融机构
               WHEN E.FIN_ORG_TYP LIKE 'E%' THEN
                'A04' --证券业金融机构
               WHEN E.FIN_ORG_TYP LIKE 'F%' THEN
                'A05' --保险业金融机构
               WHEN A.CONSR_TYP = '05' THEN
                'A06' --特殊目的载体
               WHEN E.FIN_ORG_TYP IS NOT NULL THEN
                'A07' --其他金融机构
               WHEN SUBSTR(E.CUST_CL, 1, 1) IN ('B', --政府机关
                                                'C', --事业单位
                                                'D', --社会团体
                                                'F', --部队
                                                'G', --社保基金
                                                'H' --住房公积金
                                                ) THEN
                'B01' --广义政府
               ELSE
                'B02' --企业及各类组织
             END AS CUST_TYP, --借款人类型
             E.CUST_CL AS CUST_CORP_TYP, --借款人对公客户类型
             E.ENT_HLDG_TYP AS CUST_ENT_HLDG_TYP, --借款人企业控股类型
             CASE
               WHEN E.CUST_CL = 'E' THEN
                F.OPR_CUST_TYP
             END AS CUST_OPR_CUST_TYP, --借款人经营性客户类型
             E.ENT_SCALE AS CUST_ENT_SCALE, --借款人企业规模
             CASE
               WHEN D.RSDNT_FLG = 'N' OR C.RSDNT_FLG = 'N' THEN
                'B04' --境外
               WHEN D.CUST_ID IS NOT NULL THEN
                'B03' --个人
               WHEN C.FIN_ORG_TYP = 'A10000' THEN
                'A01' --中央银行
               WHEN C.FIN_ORG_TYP LIKE 'C%' THEN
                'A02' --存款类金融机构
               WHEN C.FIN_ORG_TYP LIKE 'D%' THEN
                'A03' --非存款类金融机构
               WHEN C.FIN_ORG_TYP LIKE 'E%' THEN
                'A04' --证券业金融机构
               WHEN C.FIN_ORG_TYP LIKE 'F%' THEN
                'A05' --保险业金融机构
               WHEN A.CONSR_TYP = '05' THEN
                'A06' --特殊目的载体
               WHEN C.FIN_ORG_TYP IS NOT NULL THEN
                'A07' --其他金融机构
               WHEN SUBSTR(C.CUST_CL, 1, 1) IN ('B', --政府机关
                                                'C', --事业单位
                                                'D', --社会团体
                                                'F', --部队
                                                'G', --社保基金
                                                'H' --住房公积金
                                                ) THEN
                'B01' --广义政府
               ELSE
                'B02' --企业及各类组织
             END AS CONSR_TYP, --委托人类型
             CASE
               WHEN C.CUST_CL LIKE 'H%' --住房公积金
                THEN
                'Y'
               ELSE
                'N'
             END AS HPF_LOAN_FLG, --住房公积金贷款标志
             E.BIO_FLG   AS BIO_LOAN_FLG, --境内外贷款标志
             B.LOAN_DIR_IDY AS LOAN_DIR_IDY, --贷款投向行业
             A.ENTRS_LOAN_DIR AS ENTRS_LOAN_SPCL_DIR, --委托贷款特殊投向
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC, --数据来源
             A.ENTRS_LOAN_USEAGE, --委托贷款用途
             CASE WHEN A.DATA_SRC = '现金管理项下委托贷款' THEN 'Z'
             ELSE DECODE(A.CAP_SRC_CD,'1','Y','N') END AS FI_ENTRS_IND,--金融机构委托标志 MDF BY HYF 20231206
             NVL(E.CUST_BLNG_IDY, F.CUST_BLNG_IDY)  AS CUST_BLNG_IDY --借款人客户所属行业
       FROM M_LOAN_ENTRS_SUB A --委托贷款子表
       LEFT JOIN M_LOAN_IN_DUBILL_INFO B --表内借据信息
          ON B.RCPT_ID = A.RCPT_ID
         AND B.DATA_DT = V_P_DATE
         AND B.ORG_ID IS NOT NULL
         AND B.ORG_ID <> ' '
       LEFT JOIN M_CUST_CORP_INFO C --对公客户信息表
          ON C.CUST_ID = A.CONSR_CUST_ID
         AND C.DATA_DT = V_P_DATE
       LEFT JOIN M_CUST_IND_INFO D --个人客户信息
          ON D.CUST_ID = A.CONSR_CUST_ID
         AND D.DATA_DT = V_P_DATE
       LEFT JOIN M_CUST_CORP_INFO E --对公客户信息表
          ON E.CUST_ID = B.CUST_ID
         AND E.DATA_DT = V_P_DATE
       LEFT JOIN M_CUST_IND_INFO F --个人客户信息
          ON F.CUST_ID = B.CUST_ID
         AND F.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE
;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_ENTRS字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := V_STEP + 1;
  V_STEP_DESC := '委托贷款业务整合表--查询数据是否重复';
  V_STARTTIME := SYSDATE;

    WITH TMP1 AS (
  SELECT DATA_DT,RCPT_ID,COUNT(1)
    FROM RRP_MDL.S_LOAN_ENTRS T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,RCPT_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;


   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_ENTRS;
/

