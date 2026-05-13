CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_LOAN_ACCT_FTP_REFLOW(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_LOAN_ACCT_FTP_REFLOW
  *  功能描述：贷款账户-FTP回流-手工报表专用
  *  创建日期：20221229
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261  ftp初级报表账户明细结果集
             RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO  零售贷款账户信息
             RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO 对公贷款账户信息
             RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO 票据贴现信息
  *  目标表：RRP_MDL.M_MRPT_LOAN_ACCT_FTP_REFLOW 贷款账户-FTP回流-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221229  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_LOAN_ACCT_FTP_REFLOW'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  --清空目标表
  V_SQL :='TRUNCATE TABLE RRP_MDL.M_MRPT_LOAN_ACCT_FTP_REFLOW';
  EXECUTE IMMEDIATE V_SQL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入零售贷款账户';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_LOAN_ACCT_FTP_REFLOW NOLOGGING
  (
			DATA_DT, 				      	--数据日期
			ACCT_NO,                --账号
			SUB_ACCT_NO,            --子账号
			CURR_CD,                --币种
			FINAL_FTP_RATE,         --最终FTP利率
			FINAL_FTP_ACCINT_DAY,   --最终FTP利息日累计
			FINAL_FTP_ACCINT_YEAR,  --最终FTP利息年累计
			ACCINT_DAY,             --利息收支日累计
			EXERCISE_INTEREST_RATE  --执行利率
  )
   SELECT /*+ PARALLEL */
           V_P_DATE                          --数据日期
          ,T2.ACCT_ID                        -- 账号
          ,T2.DUBIL_NUM                      -- 子账号
          ,T1.CURRENCY_CD                    -- 币种
          ,T1.FINAL_FTP_RATE                 -- 最终FTP利率
          ,T1.FINAL_FTP_ACCINT_DAY           -- 最终FTP利息日累计
          ,T1.FINAL_FTP_ACCINT_YEAR          -- 最终FTP利息年累计
          ,T1.ACCINT_DAY                     -- 利息收支日累计
          ,T1.EXERCISE_INTEREST_RATE         -- 执行利率
     FROM RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261 T1  --ftp初级报表账户明细结果集
    INNER JOIN  RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T2  --零售贷款账户信息
       ON T1.T_ACCT_NO = T2.DUBIL_NUM
      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE T1.DATA_SRC = 'ftp_loan_acct'
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入对公贷款账户';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_LOAN_ACCT_FTP_REFLOW NOLOGGING
  (
			DATA_DT, 				      	--数据日期
			ACCT_NO,                --账号
			SUB_ACCT_NO,            --子账号
			CURR_CD,                --币种
			FINAL_FTP_RATE,         --最终FTP利率
			FINAL_FTP_ACCINT_DAY,   --最终FTP利息日累计
			FINAL_FTP_ACCINT_YEAR,  --最终FTP利息年累计
			ACCINT_DAY,             --利息收支日累计
			EXERCISE_INTEREST_RATE  --执行利率
  )
   SELECT /*+ PARALLEL */
           V_P_DATE                          --数据日期
          ,T2.ACCT_ID                        -- 账号
          ,T2.DUBIL_NUM                      -- 子账号
          ,T1.CURRENCY_CD                    -- 币种
          ,T1.FINAL_FTP_RATE                 -- 最终FTP利率
          ,T1.FINAL_FTP_ACCINT_DAY           -- 最终FTP利息日累计
          ,T1.FINAL_FTP_ACCINT_YEAR          -- 最终FTP利息年累计
          ,T1.ACCINT_DAY                     -- 利息收支日累计
          ,T1.EXERCISE_INTEREST_RATE         -- 执行利率
     FROM RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261 T1  --ftp初级报表账户明细结果集
    INNER JOIN  RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T2  --对公贷款账户信息
       ON T1.T_ACCT_NO = T2.DUBIL_NUM
      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE T1.DATA_SRC = 'ftp_loan_acct'
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入票据贴现';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_LOAN_ACCT_FTP_REFLOW NOLOGGING
  (
			DATA_DT, 				      	--数据日期
			ACCT_NO,                --账号
			SUB_ACCT_NO,            --子账号
			CURR_CD,                --币种
			FINAL_FTP_RATE,         --最终FTP利率
			FINAL_FTP_ACCINT_DAY,   --最终FTP利息日累计
			FINAL_FTP_ACCINT_YEAR,  --最终FTP利息年累计
			ACCINT_DAY,             --利息收支日累计
			EXERCISE_INTEREST_RATE  --执行利率
  )
   SELECT /*+ PARALLEL */
           V_P_DATE                          --数据日期
          ,T2.BUS_ID                        -- 账号
          ,T2.BILL_NUM                      -- 子账号
          ,T1.CURRENCY_CD                    -- 币种
          ,T1.FINAL_FTP_RATE                 -- 最终FTP利率
          ,T1.FINAL_FTP_ACCINT_DAY           -- 最终FTP利息日累计
          ,T1.FINAL_FTP_ACCINT_YEAR          -- 最终FTP利息年累计
          ,T1.ACCINT_DAY                     -- 利息收支日累计
          ,T1.EXERCISE_INTEREST_RATE         -- 执行利率
     FROM RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261 T1  --ftp初级报表账户明细结果集
    INNER JOIN  RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T2  --票据贴现信息
        ON T1.T_ACCT_NO = T2.BILL_NUM
       AND T1.S_ACCT_NO=T2.BUS_ID
       AND T1.ACCT_ORG_CD=T2.ENTER_ACCT_ORG_ID
      AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    WHERE T1.DATA_SRC = 'ftp_loan_acct'
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 5;
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

END ETL_M_MRPT_LOAN_ACCT_FTP_REFLOW;
/

