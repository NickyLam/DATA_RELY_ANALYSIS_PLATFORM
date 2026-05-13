CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_CL_INTER_BANK_BALANCE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_CL_INTER_BANK_BALANCE
  *  功能描述：同业代付登记簿余额表
  *  创建日期：20230216
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_NCBS_CL_INTER_BANK_BALANCE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230216  梅炜     首次创建
  *             2    20241226  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_CL_INTER_BANK_BALANCE'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  
 -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_CL_INTER_BANK_BALANCE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-同业代付登记簿余额表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_CL_INTER_BANK_BALANCE NOLOGGING
    (
				SUM_PAY_AGENT_PRI			--累计已代付本金
       ,SUM_PAY_AGENT_ODP			--累计已代付罚息
       ,CLIENT_NO		     	    --客户编号
       ,CMISLOAN_NO			      --客户借据编号
       ,CR_INT			          --当日计提利息
       ,PRE_CR_INT			      --上日计提利息
       ,SUM_INT_ACCRUED			  --累计计提利息
       ,SUM_PAY_AGENT_INT			--累计已代付利息
       ,PAY_AGENT_PRI			    --代付本金
       ,CR_ODP			          --当日计提罚息
       ,SUM_ODP			          --累计计提罚息
       ,SUM_ODP_ADJ_AMT			  --累计罚息调整金额
       ,SUM_INTEREST_ADJ_AMT	--累计利息调整金额
       ,PRE_CR_ODP			      --上日计提罚息
       ,INTER_BANK_BUSI_NO		--同业代付业务编号
       ,IS_LAST_PAY_AGENT			--是否最后一次代付
       ,TIMESTAMP			        --时间戳
       ,START_DT			        --开始时间
       ,END_DT			          --结束时间
       ,ID_MARK			          --增删标志
       ,ETL_TIMESTAMP			    --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
				SUM_PAY_AGENT_PRI			--累计已代付本金
       ,SUM_PAY_AGENT_ODP			--累计已代付罚息
       ,CLIENT_NO		     	    --客户编号
       ,CMISLOAN_NO			      --客户借据编号
       ,CR_INT			          --当日计提利息
       ,PRE_CR_INT			      --上日计提利息
       ,SUM_INT_ACCRUED			  --累计计提利息
       ,SUM_PAY_AGENT_INT			--累计已代付利息
       ,PAY_AGENT_PRI			    --代付本金
       ,CR_ODP			          --当日计提罚息
       ,SUM_ODP			          --累计计提罚息
       ,SUM_ODP_ADJ_AMT			  --累计罚息调整金额
       ,SUM_INTEREST_ADJ_AMT	--累计利息调整金额
       ,PRE_CR_ODP			      --上日计提罚息
       ,INTER_BANK_BUSI_NO		--同业代付业务编号
       ,IS_LAST_PAY_AGENT			--是否最后一次代付
       ,TIMESTAMP			        --时间戳
       ,START_DT			        --开始时间
       ,END_DT			          --结束时间
       ,ID_MARK			          --增删标志
       ,ETL_TIMESTAMP			    --ETL处理时间戳
    FROM IOL.V_NCBS_CL_INTER_BANK_BALANCE   --同业代付登记簿余额表_视图
   WHERE ID_MARK <> 'D'
 		;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_NCBS_CL_INTER_BANK_BALANCE;
/

