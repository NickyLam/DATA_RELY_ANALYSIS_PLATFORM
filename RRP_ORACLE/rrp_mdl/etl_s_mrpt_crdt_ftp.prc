CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_MRPT_CRDT_FTP(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_MRPT_CRDT_FTP
  *  功能描述：类信贷-FTP-手工报表专用
  *  创建日期：20221230
  *  开发人员：CYK
  *  来源表：RRP_MDL.M_MRPT_CRDT_FTP_REFLOW 类信贷_FTP回流
             RRP_MDL.M_MRPT_INVEST_BIZ 非标投资持仓
             RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO 利息收支信息
  *  目标表：RRP_MDL.S_MRPT_CRDT_FTP 类信贷-FTP-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221230  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_S_MRPT_CRDT_FTP'; -- 程序名称
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
  V_TAB_NAME := 'S_MRPT_CRDT_FTP'; --表名称

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
  V_STEP_DESC := '插入类信贷-FTP';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.S_MRPT_CRDT_FTP NOLOGGING
  (
			DATA_DT, 					--数据日期
			BUS_NO,                     --业务编号
			UDER_ACTL_FINER_NAME,       --实际融资人名称
			UDER_ACTL_FINER_CUST_ID,    --实际融资人编号
			EXT_SECU_ACCT_NO,           --外部证券账户编号
			INTNAL_SECU_ACCT_NO,        --内部证券账户编号
			FIN_INSTM_NO,               --金融工具编号
			ASSET_TYPE_NO,              --资产类型编号
			MARKET_TYPE_NO,             --市场类型编号
			CURR_CD,                    --币种
			FINAL_FTP_RATE,             --最终FTP利率
			FINAL_FTP_ACCINT_DAY,       --最终FTP利息日累计
			FINAL_FTP_ACCINT_MONTH,     --最终FTP利息月累计
			FINAL_FTP_ACCINT_YEAR,      --最终FTP利息年累计
			INT_INCOME_EXPNS_D          --当日利息收支
  )
  SELECT /*+ PARALLEL */
     V_P_DATE AS DATA_DT,
     FTP.BUS_NO,
     LXD.UDER_ACTL_FINER_NAME,
     LXD.UDER_ACTL_FINER_CUST_ID,
     FTP.EXT_SECU_ACCT_NO,
     FTP.INTNAL_SECU_ACCT_NO,
     FTP.FIN_INSTM_NO,
     FTP.ASSET_TYPE_NO,
     FTP.MARKET_TYPE_NO,
     CASE
       WHEN FTP.CURR_CD = 'CNY' THEN
        '01'
       ELSE
        FTP.CURR_CD
     END CURR_CD,
     FTP.FINAL_FTP_RATE,
     FTP.FINAL_FTP_ACCINT_DAY,
     FTP.FINAL_FTP_ACCINT_MONTH,
     FTP.FINAL_FTP_ACCINT_YEAR,
     NVL(LX.INT_INCOME_EXPNS_D, 0) INT_INCOME_EXPNS_D
      FROM RRP_MDL.M_MRPT_CRDT_FTP_REFLOW FTP --类信贷_FTP回流
      LEFT JOIN RRP_MDL.M_MRPT_INVEST_BIZ LXD --非标投资持仓
        ON LXD.DATA_DT = V_P_DATE
       AND FTP.BUS_NO = LXD.OJB_NO
       AND FTP.EXT_SECU_ACCT_NO = LXD.EXT_SECU_ACCT_NO
       AND FTP.INTNAL_SECU_ACCT_NO = LXD.INTNAL_SECU_ACCT_NO
       AND FTP.FIN_INSTM_NO = LXD.FIN_INSTM_NO
       AND FTP.ASSET_TYPE_NO = LXD.ASSET_TYPE_NO
       AND FTP.MARKET_TYPE_NO = LXD.MARKET_TYPE_NO
      LEFT JOIN RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO LX --利息收支信息
        ON 9999 || LXD.EXT_SECU_ACCT_NO || LXD.INTNAL_SECU_ACCT_NO ||
           LXD.FIN_INSTM_NO || LXD.MARKET_TYPE_NO || LXD.OJB_NO =
           LX.RELA_FIELD　
     WHERE FTP.DATA_DT = V_P_DATE;

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

END ETL_S_MRPT_CRDT_FTP;
/

