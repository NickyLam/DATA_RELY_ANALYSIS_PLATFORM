CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_MRPT_DEP_ACCT_FTP(I_P_DATE IN INTEGER,
                                                    O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_MRPT_DEP_ACCT_FTP
  *  功能描述：存款账户-FTP表-手工报表专用
  *  创建日期：20221229
  *  开发人员：CYK
  *  来源表：RRP_MDL.M_MRPT_INCOME_ICM_EPD  利息收支表-统计利息-手工报表专用
             RRP_MDL.M_MRPT_DEP_ACCT_FTP_REFLOW  存款账户-FTP回流-手工报表专用
             RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO 存款账户信息表
  *  目标表：RRP_MDL.S_MRPT_DEP_ACCT_FTP 存款账户-FTP表-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221229  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_S_MRPT_DEP_ACCT_FTP'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_PART_NAME   VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME    VARCHAR2(100);  --表名称

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'S_MRPT_DEP_ACCT_FTP'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  /*--查询分区是否已经存在
  SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户-FTP表';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.S_MRPT_DEP_ACCT_FTP NOLOGGING
  (
			DATA_DT, 		      --数据日期
			ACCT_ID,          --账号
			ACCT_SID,         --子账号
			ACCT_NAME,        --账户名称
			CUST_ID,          --客户编号
			FTP_PRC,          --FTP价格
			FTP_INCOME,       --FTP收入
			INTEREST_EXPN,    --FTP利息支出
			YEAR_RATE,        --年利率
			FTP_PROFIT_DIF,   --FTP利差
			FTP_PFT           --FTP收益
  )
 SELECT DATA_DT,
        ACCT_ID,
        ACCT_SID,
        ACCT_NAME,
        CUST_ID,
        FTP_PRC,
        FTP_INCOME,
        INTEREST_EXPN,
        YEAR_RATE,
        FTP_PROFIT_DIF,
        FTP_PFT
   FROM (SELECT /*+ PARALLEL */
          V_P_DATE DATA_DT,
          A.ACCT_ID,
          A.ACCT_SID,
          A.ACCT_NAME,
          A.CUST_ID,
          A.FTP_PRC,
          A.FTP_INCOME,
          B.INTEREST_EXPN,
          A.YEAR_RATE,
          A.F_RATE - A.E_RATE FTP_PROFIT_DIF,
          A.F_FTP - B.INTEREST_EXPN FTP_PFT
           FROM (SELECT A.ACCT_ID AS ACCT_ID,
                        A.ACCT_ID AS ACCT_SID,
                        A.ACCT_NAME,
                        A.CUST_ID,
                        MAX(B.FINAL_FTP_RATE) FTP_PRC,
                        SUM(B.FINAL_FTP_ACCINT_YEAR) FTP_INCOME,
                        MAX(B.EXERCISE_INTEREST_RATE) YEAR_RATE,
                        MAX(B.FINAL_FTP_RATE) F_RATE,
                        MAX(B.EXERCISE_INTEREST_RATE) AS E_RATE,
                        SUM(B.FINAL_FTP_ACCINT_DAY) AS F_FTP
                   FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款账户信息表
                   LEFT JOIN RRP_MDL.M_MRPT_DEP_ACCT_FTP_REFLOW B --存款账户_FTP回流
                     ON A.ACCT_ID = B.SUB_ACCT_NO
                    AND B.DATA_DT = V_P_DATE
                  GROUP BY A.ACCT_ID, A.ACCT_NAME, A.CUST_ID) A
           LEFT JOIN (SELECT RELA_FIELD, MAX(INCOME) INTEREST_EXPN
                       FROM RRP_MDL.M_MRPT_INCOME_ICM_EPD
                      WHERE BUS_TYPE_CD = 'DEP'
                        AND DATA_DT = V_P_DATE
                      GROUP BY RELA_FIELD) B --利息收支信息临时表
             ON A.CUST_ID = B.RELA_FIELD)
  WHERE NVL(FTP_INCOME, 0) <> 0
     OR NVL(FTP_PFT, 0) <> 0
     OR NVL(INTEREST_EXPN, 0) <> 0
     OR NVL(YEAR_RATE, 0) <> 0
     OR NVL(FTP_PROFIT_DIF, 0) <> 0;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_MRPT_DEP_ACCT_FTP;
/

