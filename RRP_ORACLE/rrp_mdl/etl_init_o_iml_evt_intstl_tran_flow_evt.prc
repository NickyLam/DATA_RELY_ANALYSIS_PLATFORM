CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_INTSTL_TRAN_FLOW_EVT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_INTSTL_TRAN_FLOW_EVT
  *  功能描述：国结交易流水
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_INTSTL_TRAN_FLOW_EVT
  *  目标表： O_IML_EVT_INTSTL_TRAN_FLOW_EVT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_IML_EVT_INTSTL_TRAN_FLOW_EVT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_INTSTL_TRAN_FLOW_EVT ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_INTSTL_TRAN_FLOW_EVT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-国结交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_INTSTL_TRAN_FLOW_EVT
  (
		ETL_DT  --ETL处理日期
		,EVT_ID  --事件编号
		,LP_ID  --法人编号
		,SRC_EVT_ID  --源事件编号
		,TRAN_TM  --交易时间
		,TRAN_CODE  --交易码
		,RGST_TELLER_ID  --登记柜员编号
		,TRAN_NAME  --交易名称
		,TRAN_ID  --交易编号
		,BUS_TABLE_NAME  --业务表名称
		,BUS_TAB_FLOW_NUM  --业务表流水号
		,TRAN_DESCB  --交易描述
		,BUS_TELLER_ID  --业务柜员编号
		,TRAN_CMPLT_TM  --交易完成时间
		,REMARK  --备注
		,AUTH_STATUS_CD  --授权状态代码
		,SUBMIT_STATUS_CD  --提交状态代码
		,CHECK_DT  --复核日期
		,AUTH_CURR_CD  --授权币种代码
		,AUTH_AMT  --授权金额
		,CURR_CD  --币种代码
		,TRAN_AMT  --交易金额
		,MODIF_TELLER_ID  --修改柜员编号
		,ORD_TAB_FLOW_NUM  --ORD表流水号
		,ORG_ID  --机构编号
		,ENTRY_ORG_ID  --记账机构编号
		,BUS_BELONG_ORG_ID  --业务所属机构编号
		,ORG_IDF_CD  --机构标识代码
		,OVA_FLOW_NUM  --全局流水号
		,REVS_FLOW_NUM  --冲正流水号
		,REVS_RS  --冲正原因
    )
    SELECT
		ETL_DT  --ETL处理日期
		,EVT_ID  --事件编号
		,LP_ID  --法人编号
		,SRC_EVT_ID  --源事件编号
		,TRAN_TM  --交易时间
		,TRAN_CODE  --交易码
		,RGST_TELLER_ID  --登记柜员编号
		,TRAN_NAME  --交易名称
		,TRAN_ID  --交易编号
		,BUS_TABLE_NAME  --业务表名称
		,BUS_TAB_FLOW_NUM  --业务表流水号
		,TRAN_DESCB  --交易描述
		,BUS_TELLER_ID  --业务柜员编号
		,TRAN_CMPLT_TM  --交易完成时间
		,REMARK  --备注
		,AUTH_STATUS_CD  --授权状态代码
		,SUBMIT_STATUS_CD  --提交状态代码
		,CHECK_DT  --复核日期
		,AUTH_CURR_CD  --授权币种代码
		,AUTH_AMT  --授权金额
		,CURR_CD  --币种代码
		,TRAN_AMT  --交易金额
		,MODIF_TELLER_ID  --修改柜员编号
		,ORD_TAB_FLOW_NUM  --ORD表流水号
		,ORG_ID  --机构编号
		,ENTRY_ORG_ID  --记账机构编号
		,BUS_BELONG_ORG_ID  --业务所属机构编号
		,ORG_IDF_CD  --机构标识代码
		,OVA_FLOW_NUM  --全局流水号
		,REVS_FLOW_NUM  --冲正流水号
		,REVS_RS  --冲正原因
    FROM IML.V_EVT_INTSTL_TRAN_FLOW_EVT  --视图-国结交易流水
    WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')

;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_O_IML_EVT_INTSTL_TRAN_FLOW_EVT;
/

