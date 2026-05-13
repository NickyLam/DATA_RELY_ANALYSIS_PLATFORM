CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_MRPT_BILL_RDISC_FTP(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_MRPT_BILL_RDISC_FTP
  *  功能描述：票据再贴现-FTP表-手工报表专用
  *  创建日期：20221230
  *  开发人员：CYK
  *  来源表：RRP_MDL.M_MRPT_BILL_RDISC_FTP_REFLOW 票据再贴现_FTP回流
             RRP_MDL.M_MRPT_INCOME_ICM_EPD  利息收支表-统计利息-手工报表专用
             RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO 票据再贴现信息表
             RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO 票据贴现信息
  *  目标表：RRP_MDL.S_MRPT_BILL_RDISC_FTP 票据再贴现-FTP表-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221230  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_S_MRPT_BILL_RDISC_FTP'; -- 程序名称
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
  V_TAB_NAME := 'S_MRPT_BILL_RDISC_FTP'; --表名称

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
  V_STEP_DESC := '插入贷款账户-FTP表';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.S_MRPT_BILL_RDISC_FTP NOLOGGING
  (
			DATA_DT, 		  --统计日期
			BIZ_NO,           --票据号
			CUST_NAME,        --账户名称
			CUST_ID,          --客户编号
			FTP_PRC,          --FTP价格
			FTP_TRF_INCOME,   --FTP转移收入
			INTEREST,         --利息
			YEAR_RATE,        --年利率
			FTP_PROFIT_DIF,   --FTP利差
			FTP_PFT           --FTP收益
  )
  SELECT /*+ PARALLEL */
				V_P_DATE AS DATA_DT,
				TXR.BIZ_NO,
				TX.CUST_NAME,
				TX.CUST_ID,
				TXR.FINAL_FTP_RATE AS FTP_PRC,
				TXR.FINAL_FTP_ACCINT_DAY AS FTP_INT_INCOME,
				LXSZ.INCOME,
				(CASE
					WHEN TXR.EXERCISE_INTEREST_RATE = 0 THEN
					ZTX.DISCNT_INT_RAT
					ELSE
					TXR.EXERCISE_INTEREST_RATE
				END) AS YEAR_RATE,
				TXR.FINAL_FTP_RATE - ZTX.DISCNT_INT_RAT AS FTP_PROFIT_DIF,
				TXR.FINAL_FTP_ACCINT_DAY - NVL(LXSZ.INCOME, 0) AS FTP_PFT　　　　　　
   FROM RRP_MDL.M_MRPT_BILL_RDISC_FTP_REFLOW TXR --票据再贴现_FTP回流
  INNER JOIN RRP_MDL.M_MRPT_INCOME_ICM_EPD LXSZ --利息收支表-统计利息-手工报表专用
     ON TXR.BIZ_NO = LXSZ.RELA_FIELD
    AND LXSZ.BUS_TYPE_CD = 'BILL'
    AND LXSZ.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO ZTX --票据再贴现信息表
     ON TXR.BIZ_NO = ZTX.BUS_ID
    AND ZTX.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
   LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO TX --票据贴现信息
     ON TX.BILL_NUM = ZTX.BILL_NUM
    AND TX.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
  WHERE TX.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

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

END ETL_S_MRPT_BILL_RDISC_FTP;
/

