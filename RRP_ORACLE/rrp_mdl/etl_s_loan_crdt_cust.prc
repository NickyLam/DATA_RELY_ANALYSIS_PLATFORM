CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_CRDT_CUST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_CRDT_CUST
  *  功能描述：授信按客户整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CRDT_LMT_SUB
  *            M_CUST_IND_INFO
  *            M_CRDT_LMT_INFO
  *            M_CUST_CORP_INFO
  *
  *
  *
  *
  *  目标表：  S_LOAN_CRDT_CUST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_CRDT_CUST'; -- 程序名称
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
  V_TAB_NAME := 'S_LOAN_CRDT_CUST'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_CRDT_CUST T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_CRDT_CUST'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '授信按客户整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_CRDT_CUST
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       CUST_ID, --客户编号
       ORG_ID, --机构编号
       CUR, --币种
       CRDT_TOTAL_LMT, --授信总额度
       EXP_CRDT_LMT, --敞口授信额度
       OPR_CRDT_TOT_AMT, --经营授信总额
       HSE_CRDT_LMT, --住房授信额度
       CAR_LOAN_CRDT_LMT, --车贷授信额度
       SL_CRDT_LMT, --助学授信额度
       OTH_CNSMP_CRDT_LMT, --其他消费授信额度
       BANK_TAX_COOP_LOAN_CRDT_FLG, --银税合作贷款授信标志
       CUST_LRG_CL, --客户大类
       CORP_CUST_TYP, --对公客户类型
       OPR_CUST_TYP, --经营性客户类型
       BIO_FLG, --境内外标志
       ENT_SCALE, --企业规模
       CBRC_FLG, --CBRC标志
       PBOC_FLG, --PBOC标志
       OTH_IN_CRDT_AMT   , --其他表内授信金额
       OUT_CRDT_AMT      , --表外授信金额
       BILL_ACPT_CRDT_AMT, --票据承兑授信金额
       OTH_IN_USE_CRDT_AMT,--其他表内授信余额
       OUT_USE_CRDT_AMT,   --表外授信余额
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
      -- CNYE --承诺余额
       )
      WITH TMP_M_CRDT_LMT_SUB AS
       (SELECT DISTINCT T.CUST_ID,
                        T.BANK_TAX_COOP_LOAN_CRDT_FLG
          FROM M_CRDT_LMT_SUB T
         WHERE T.DATA_DT = V_P_DATE)
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUR AS CUR, --币种
             A.CRDT_TOTAL_LMT AS CRDT_TOTAL_LMT, --授信总额度
             A.EXP_CRDT_LMT AS EXP_CRDT_LMT, --敞口授信额度
             A.OPR_CRDT_TOT_AMT AS OPR_CRDT_TOT_AMT, --经营授信总额
             A.HSE_CRDT_LMT AS HSE_CRDT_LMT, --住房授信额度
             A.CAR_LOAN_CRDT_LMT AS CAR_LOAN_CRDT_LMT, --车贷授信额度
             A.SL_CRDT_LMT AS SL_CRDT_LMT, --助学授信额度
             A.OTH_CNSMP_CRDT_LMT AS OTH_CNSMP_CRDT_LMT, --其他消费授信额度
             D.BANK_TAX_COOP_LOAN_CRDT_FLG AS BANK_TAX_COOP_LOAN_CRDT_FLG, --银税合作贷款授信标志
             CASE
               WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' THEN
                '01' --对私客户(含个体工商户)
               WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' THEN
                '02' --对公客户（剔除个体工商户）
             END AS CUST_LRG_CL, --客户大类
             B.CUST_CL AS CORP_CUST_TYP, --对公客户类型
             CASE
               WHEN B.CUST_CL = 'E' THEN
                'A'
               ELSE
                C.OPR_CUST_TYP
             END AS OPR_CUST_TYP, --经营性客户类型
             NVL(B.BIO_FLG, C.BIO_FLG) AS BIO_FLG, --境内外标志
             B.ENT_SCALE AS ENT_SCALE, --企业规模
             'Y' AS CBRC_FLG, --CBRC标志
             'Y' AS PBOC_FLG, --PBOC标志
             A.OTH_IN_CRDT_AMT    AS OTH_IN_CRDT_AMT   , --其他表内授信金额
             A.OUT_CRDT_AMT       AS OUT_CRDT_AMT      , --表外授信金额
             A.BILL_ACPT_CRDT_AMT AS BILL_ACPT_CRDT_AMT, --票据承兑授信金额
             A.CRDT_TOTAL_LMT-A.ALDY_USE_LMT,            --其他表内授信余额
             A.OTH_CNSMP_CRDT_LMT-A.OTH_CNSMP_ALDY_USE_CRDT_LMT,
             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC --数据来源
            -- E.CNYE AS CNYE --承诺余额
        FROM M_CRDT_LMT_INFO A --授信额度主表
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN TMP_M_CRDT_LMT_SUB D --授信额度子表
          ON A.CUST_ID = D.CUST_ID
/*        LEFT JOIN M_ADD_DG_002_CREDIT E --授信补录表
        ON A.CUST_ID = E.KHWYM
        AND E.DATA_DATE = V_P_DATE*/
       WHERE A.CRDT_STAT = 'Y'
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);




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

  END ETL_S_LOAN_CRDT_CUST;
/

