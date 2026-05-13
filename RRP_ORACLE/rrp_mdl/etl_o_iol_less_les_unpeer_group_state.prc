CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_LESS_LES_UNPEER_GROUP_STATE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_LESS_LES_UNPEER_GROUP_STATE
  *  功能描述：非同业集团客户及经济依存客户大额风险暴露情况表
  *  创建日期：20230607
  *  开发人员：MW
  *  来源表： IOL.V_LESS_LES_UNPEER_GROUP_STATE
  *  目标表： O_IOL_LESS_LES_UNPEER_GROUP_STATE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230607  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_LESS_LES_UNPEER_GROUP_STATE'; -- 程序名称
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
	V_TAB_NAME := 'O_IOL_LESS_LES_UNPEER_GROUP_STATE';
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_LESS_LES_UNPEER_GROUP_STATE T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_LESS_LES_UNPEER_GROUP_STATE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-非同业集团客户及经济依存客户大额风险暴露情况表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_LESS_LES_UNPEER_GROUP_STATE
  (
					DATADATE   --数据日期
					,SEQITEM   --序号
					,CUSTOMERTYPE   --客户类型
					,CUSTOMERNAME   --客户名称
					,CUSTOMERCODE   --客户代码
					,SUMEXPSE   --风险暴露总和-合计
					,UNEXEMPTRISKEXPSE   --风险暴露总和-其中：不可豁免风险暴露
					,FIRSTCAPNARAT   --占一级资本净额比例-合计
					,UNEXEMPTRISKEXPSEPROP   --占一级资本净额比例-其中：不可豁免风险暴露
					,AFCOMNRISKEXPSE   --一般风险暴露-合计
					,ANYLOAN   --一般风险暴露-其中：各项贷款
					,SUMPROD   --一般风险暴露-其中：债券投资
					,SECUINVEST   --特定风险暴露-合计
					,ZGPROD   --特定风险暴露-资产管理产品
					,TRUSTPROD   --资产管理产品-其中：信托产品
					,NBRK_EVNCHREM   --资产管理产品-其中：非保本理财
					,SECUASTMGMTPROD   --资产管理产品-其中：证券业资管产品
					,ZQPROD   --特定风险暴露-资产证券化产品
					,AFTRADEACCTRISKEXPSE   --交易账簿风险暴露
					,AFTRADECPCRDTRISKEXPSE   --交易对手信用风险暴露
					,AFPTENTRISKEXPSE   --潜在风险暴露-合计
					,BANKACPTDRAFT   --潜在风险暴露-其中：银行承兑汇票
					,DOCUMLC   --潜在风险暴露-其中：跟单信用证
					,BKLTR   --潜在风险暴露-其中：保函
					,LOANPROMS   --潜在风险暴露-其中：贷款承诺
					,AFOTHRISKEXPSE   --其他风险暴露
					,MOVERISKEXPSE   --风险缓释转出的风险暴露（转入为负数）
					,SUMUNEXPSE   --不考虑风险缓释作用的风险暴露总和
					--,ETL_DT   --ETL处理日期
	)
    SELECT
					DATADATE   --数据日期
					,SEQITEM   --序号
					,CUSTOMERTYPE   --客户类型
					,CUSTOMERNAME   --客户名称
					,CUSTOMERCODE   --客户代码
					,SUMEXPSE   --风险暴露总和-合计
					,UNEXEMPTRISKEXPSE   --风险暴露总和-其中：不可豁免风险暴露
					,FIRSTCAPNARAT   --占一级资本净额比例-合计
					,UNEXEMPTRISKEXPSEPROP   --占一级资本净额比例-其中：不可豁免风险暴露
					,AFCOMNRISKEXPSE   --一般风险暴露-合计
					,ANYLOAN   --一般风险暴露-其中：各项贷款
					,SUMPROD   --一般风险暴露-其中：债券投资
					,SECUINVEST   --特定风险暴露-合计
					,ZGPROD   --特定风险暴露-资产管理产品
					,TRUSTPROD   --资产管理产品-其中：信托产品
					,NBRK_EVNCHREM   --资产管理产品-其中：非保本理财
					,SECUASTMGMTPROD   --资产管理产品-其中：证券业资管产品
					,ZQPROD   --特定风险暴露-资产证券化产品
					,AFTRADEACCTRISKEXPSE   --交易账簿风险暴露
					,AFTRADECPCRDTRISKEXPSE   --交易对手信用风险暴露
					,AFPTENTRISKEXPSE   --潜在风险暴露-合计
					,BANKACPTDRAFT   --潜在风险暴露-其中：银行承兑汇票
					,DOCUMLC   --潜在风险暴露-其中：跟单信用证
					,BKLTR   --潜在风险暴露-其中：保函
					,LOANPROMS   --潜在风险暴露-其中：贷款承诺
					,AFOTHRISKEXPSE   --其他风险暴露
					,MOVERISKEXPSE   --风险缓释转出的风险暴露（转入为负数）
					,SUMUNEXPSE   --不考虑风险缓释作用的风险暴露总和
					--,ETL_DT   --ETL处理日期
    FROM IOL.V_LESS_LES_UNPEER_GROUP_STATE  --视图-非同业集团客户及经济依存客户大额风险暴露情况表
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

  END ETL_O_IOL_LESS_LES_UNPEER_GROUP_STATE;
/

