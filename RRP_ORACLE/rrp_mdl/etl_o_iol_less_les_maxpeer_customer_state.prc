CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE
  *  功能描述：最大单家及全部同业融资业务情况表
  *  创建日期：20230607
  *  开发人员：MW
  *  来源表： IOL.V_LESS_LES_MAXPEER_CUSTOMER_STATE
  *  目标表： O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230607  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME	VARCHAR2(200);--表名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
	V_TAB_NAME := 'O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE';
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-最大单家及全部同业融资业务情况表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE
  (
					DATADATE   --数据日期
					,SEQITEM   --序号
					,COLLCUSTOMERNAME   --客户名称
					,COLLCERTNUM   --客户代码
					,LACIBANK   --拆放同业-合计
					,IBANK_OFFER   --拆放同业-其中：同业拆借
					,IBANKBRW_MONEY   --拆放同业-其中：同业借款
					,TRUSIBANKERA_PAY   --拆放同业-其中：受托方同业代付
					,STORIBANK   --拆放同业-合计
					,BUYRESALE   --存放同业
					,OTHIBANK   --买入返售
					,SUMBANK   --其他同业融出
					,SUMBANKPT   --同业融出合计
					,RTRATIO   --扣除结算性同业存款和风险权重为零资产后的融出余额
					,STLIBANKDPST   --占一级资本净额比例%
					,RISKWGHTZEROAST   --风险权重为零的资产
					,NOTST   --同业投资业务
					--,ETL_DT   --ETL处理日期

	)
    SELECT
					DATADATE   --数据日期
					,SEQITEM   --序号
					,COLLCUSTOMERNAME   --客户名称
					,COLLCERTNUM   --客户代码
					,LACIBANK   --拆放同业-合计
					,IBANK_OFFER   --拆放同业-其中：同业拆借
					,IBANKBRW_MONEY   --拆放同业-其中：同业借款
					,TRUSIBANKERA_PAY   --拆放同业-其中：受托方同业代付
					,STORIBANK   --拆放同业-合计
					,BUYRESALE   --存放同业
					,OTHIBANK   --买入返售
					,SUMBANK   --其他同业融出
					,SUMBANKPT   --同业融出合计
					,RTRATIO   --扣除结算性同业存款和风险权重为零资产后的融出余额
					,STLIBANKDPST   --占一级资本净额比例%
					,RISKWGHTZEROAST   --风险权重为零的资产
					,NOTST   --同业投资业务
					--,ETL_DT   --ETL处理日期
    FROM IOL.V_LESS_LES_MAXPEER_CUSTOMER_STATE  --视图-最大单家及全部同业融资业务情况表
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

  END ETL_O_IOL_LESS_LES_MAXPEER_CUSTOMER_STATE;
/

