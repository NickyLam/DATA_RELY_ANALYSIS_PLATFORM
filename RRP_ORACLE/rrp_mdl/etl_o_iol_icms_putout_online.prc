CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_PUTOUT_ONLINE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_PUTOUT_ONLINE
  *  功能描述：线上放款申请记录
  *  创建日期：20230625
  *  开发人员：MW
  *  来源表： IOL.V_ICMS_PUTOUT_ONLINE
  *  目标表： O_IOL_ICMS_PUTOUT_ONLINE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230625  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_PUTOUT_ONLINE'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(200);--表名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_IOL_ICMS_PUTOUT_ONLINE';
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_ICMS_PUTOUT_ONLINE T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ICMS_PUTOUT_ONLINE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-线上放款申请记录';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_PUTOUT_ONLINE
  (
		PUTOUTNO   --出账流水号
		,CONTRACTSERIALNO   --合同号
		,HOSTNBR   --信保转账交易流水
		,DD_STATUS   --放款状态
		,HOSTDATE   --信保转账交易日期
		,FIRSTPAYAMT   --首付款金额
		,MIGTFLAG   --MIGTFLAG
		,CHANNEL   --渠道号
		,ISFIRSTPAY   --是否首付款1是2否
		,FIRSTPAYRATIO   --首付款比例%
		,DUEBILLSERIALNO   --借据号
		,BILLAMT   --服务费
		,OARATEEXARESULT   --OA利率审批结果 0 不通过 1 通过1
		,ORDERNO   --订单号
		,ORDERSUMAMT   --订单金额
		,START_DT   --开始时间
		,END_DT   --结束时间

  )
    SELECT
		 PUTOUTNO   --出账流水号
		,CONTRACTSERIALNO   --合同号
		,HOSTNBR   --信保转账交易流水
		,DD_STATUS   --放款状态
		,HOSTDATE   --信保转账交易日期
		,FIRSTPAYAMT   --首付款金额
		,MIGTFLAG   --MIGTFLAG
		,CHANNEL   --渠道号
		,ISFIRSTPAY   --是否首付款1是2否
		,FIRSTPAYRATIO   --首付款比例%
		,DUEBILLSERIALNO   --借据号
		,BILLAMT   --服务费
		,OARATEEXARESULT   --OA利率审批结果 0 不通过 1 通过1
		,ORDERNO   --订单号
		,ORDERSUMAMT   --订单金额
		,START_DT   --开始时间
		,END_DT   --结束时间
    FROM IOL.V_ICMS_PUTOUT_ONLINE  --视图-线上放款申请记录
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);
   V_STEP := 3;
   V_STEP_DESC := '-- 程序跑批结束 --';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   -- 程序跑批结束记录 --



   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_ICMS_PUTOUT_ONLINE;
/

