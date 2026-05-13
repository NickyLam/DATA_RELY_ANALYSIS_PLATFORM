CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_MIGRATE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_MIGRATE
  *  功能描述：贷款迁徙信息整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_IN_DUBILL_INFO
  *            M_LOAN_RSTD_SUB
  *
  *
  *
  *
  *
  *  目标表：  S_LOAN_MIGRATE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_MIGRATE'; -- 程序名称
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
  V_TAB_NAME := 'S_LOAN_MIGRATE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_MIGRATE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_MIGRATE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_STEP_DESC := '贷款迁徙信息整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_MIGRATE
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CONT_ID, --合同编号
       RCPT_ID, --借据编号
       CUR, --币种
       BGN_YEAR_LOAN_BAL, --年初贷款余额
       BGN_YEAR_INT_ADJ, --年初利息调整
       BGN_YEAR_FAIR_VAL_CHG, --年初公允价值变动
       LOAN_BAL, --贷款余额
       INT_ADJ, --利息调整
       FAIR_VAL_CHG, --公允价值变动
       LOAN_ACT_DSTR_DT, --贷款实际发放日期
       BGN_YEAR_LOAN_LVL5_CL, --年初五级分类
       LVL5_CL, --五级分类
       BGN_YEAR_RSTD_LOAN_FLG, --年初重组贷款标志
       RCMB_LOAN_FLG, --重组贷款标志
       BGN_YEAR_RSTD_LOAN_RE_FLG, --年初重组贷款再重组标志
       BGN_YEAR_RSTD_LOAN_UP_FLG, --年初重组上调贷款标志
       RSTD_RAISE_LOAN_FLG, --重组上调贷款标志
       RSTD_UN_NPL_FLG, --重组后未计入不良贷款标志
       ALDY_NPL_FLG, --曾下迁为不良贷款标志
       RSTD_LOAN_FLG, --重组调整贷款标志
       RCPT_STAT, --借据状态
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      SELECT A.DATA_DT                   AS DATA_DT, --数据日期
             A.LGL_REP_ID                AS LGL_REP_ID, --法人编号
             A.ORG_ID                    AS ORG_ID, --机构编号
             A.CONT_ID                   AS CONT_ID, --合同编号
             A.RCPT_ID                   AS RCPT_ID, --借据编号
             A.CUR                       AS CUR, --币种
             B.LOAN_BAL                  AS BGN_YEAR_LOAN_BAL, --年初贷款余额
             B.INT_ADJ                   AS BGN_YEAR_INT_ADJ, --年初利息调整
             B.FAIR_VAL_CHG              AS BGN_YEAR_FAIR_VAL_CHG, --年初公允价值变动
             A.LOAN_BAL                  AS LOAN_BAL, --贷款余额
             A.INT_ADJ                   AS INT_ADJ, --利息调整
             A.FAIR_VAL_CHG              AS FAIR_VAL_CHG, --公允价值变动
             A.LOAN_ACT_DSTR_DT          AS LOAN_ACT_DSTR_DT, --贷款实际发放日期
             B.LVL5_CL                   AS BGN_YEAR_LOAN_LVL5_CL, --年初五级分类
             A.LVL5_CL                   AS LVL5_CL, --五级分类
             C.BGN_YEAR_RSTD_LOAN_FLG    AS BGN_YEAR_RSTD_LOAN_FLG, --年初重组贷款标志
             A.RSTD_LOAN_FLG             AS RCMB_LOAN_FLG, --重组贷款标志
             C.BGN_YEAR_RSTD_LOAN_RE_FLG AS BGN_YEAR_RSTD_LOAN_RE_FLG, --年初重组贷款再重组标志
             C.BGN_YEAR_RSTD_LOAN_UP_FLG AS BGN_YEAR_RSTD_LOAN_UP_FLG, --年初重组上调贷款标志
             C.RSTD_RAISE_LOAN_FLG       AS RSTD_RAISE_LOAN_FLG, --重组上调贷款标志
             C.RSTD_UN_NPL_FLG           AS RSTD_UN_NPL_FLG, --重组后未计入不良贷款标志
             C.NPL_FLG                   AS ALDY_NPL_FLG, --曾下迁为不良贷款标志
             C.RSTD_LOAN_FLG             AS RSTD_LOAN_FLG, --重组调整贷款标志
             A.RCPT_STAT                 AS RCPT_STAT, --借据状态
             A.DEPT_LINE                 AS DEPT_LINE, --部门条线
             A.DATA_SRC                  AS DATA_SRC --数据来源
        FROM M_LOAN_IN_DUBILL_INFO A --表内借据信息
        LEFT JOIN M_LOAN_IN_DUBILL_INFO B --表内借据信息
          ON A.RCPT_ID = B.RCPT_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN M_LOAN_RSTD_SUB C --重组贷款子表
          ON A.RCPT_ID = C.RCPT_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.DATA_DT = V_P_DATE;
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

  END ETL_S_LOAN_MIGRATE;
/

