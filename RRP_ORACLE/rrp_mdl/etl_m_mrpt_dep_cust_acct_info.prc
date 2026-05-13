CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_DEP_CUST_ACCT_INFO(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_DEP_CUST_ACCT_INFO
  *  功能描述：存款主账户信息表-手工报表专用
  *  创建日期：20221212
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO 存款主账户信息表
  *  目标表：RRP_MDL.M_MRPT_DEP_CUST_ACCT_INFO  存款主账户信息表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221212  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_DEP_CUST_ACCT_INFO'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;
  V_SQL       VARCHAR2(2000); -- 动态sql

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_MRPT_DEP_CUST_ACCT_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  
  V_SQL :='TRUNCATE TABLE M_MRPT_DEP_CUST_ACCT_INFO';
  EXECUTE IMMEDIATE V_SQL; 
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款主账户信息表数据';
  D_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_MRPT_DEP_CUST_ACCT_INFO
  (
		DATA_DT,    -- 数据日期
		CUST_ACCT_ID,    -- 客户账户编号
		OPEN_ACCT_DT,    -- 开户日期
		ACCT_STATUS_CD,    -- 账户状态代码
		VOUCH_FORM_CD,    -- 凭证形式代码
		ACCT_BELONG_ORG_ID,    -- 账户所属机构编号
		VOUCH_KIND_CD    -- 凭证种类代码
  )
  SELECT V_P_DATE,
		     A.CUST_ACCT_ID,    -- 客户账户编号
		     A.OPEN_ACCT_DT,    -- 开户日期
		     A.ACCT_STATUS_CD,    -- 账户状态代码
		     A.VOUCH_FORM_CD,    -- 凭证形式代码
		     A.ACCT_BELONG_ORG_ID,    -- 账户所属机构编号
		     A.VOUCH_KIND_CD    -- 凭证种类代码
  FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.ACCT_STATUS_CD = 'A' --正常
  AND SUBSTR(A.CUST_ACCT_ID,1,2)='62';

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  D_ENDTIME := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

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
    D_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_DEP_CUST_ACCT_INFO;
/

