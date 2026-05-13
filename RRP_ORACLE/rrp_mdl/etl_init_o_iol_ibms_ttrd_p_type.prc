CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TTRD_P_TYPE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IBMS_TTRD_P_TYPE
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_P_TYPE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TTRD_P_TYPE'; -- 程序名称
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

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_P_TYPE';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_P_TYPE NOLOGGING
    (  ID	--产品分类ID
      ,A_TYPE	--资产类型
      ,P_TYPE	--产品类型
      ,P_TYPE_NAME	--产品类型名称
      ,IS_AUTO_PRFT	--是否自动息差；1：是，0：否
      ,IS_ALLOW_DELAY	--是否允许延迟到期
      ,AMORT_METHOD	--摊销算法
      ,AMORT_METHOD_NAME	--摊销算法名称
      ,IS_TPRICE	--是否估值
      ,FV_TYPE	--估值类型
      ,IS_ALLOW_WITHDRAW	--是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
      ,IS_ALLOW_ACCRUE	--是否允许计提
      ,IS_ALLOW_RECEIVEAI	--是否允许随时收息
      ,IS_AUTO_OVERDUE	--是否自动逾期;1:是，0：否
      ,PENDING_ACCOUNT	--挂账账户
      ,PENDING_ACCOUNT_NAME	--挂账账户户名
      ,START_DT	--开始时间
      ,END_DT	--结束时间
      ,ID_MARK	--增删标志
     )
  SELECT /*+PARALLEL*/
     ID	--产品分类ID
    ,A_TYPE	--资产类型
    ,P_TYPE	--产品类型
    ,P_TYPE_NAME	--产品类型名称
    ,IS_AUTO_PRFT	--是否自动息差；1：是，0：否
    ,IS_ALLOW_DELAY	--是否允许延迟到期
    ,AMORT_METHOD	--摊销算法
    ,AMORT_METHOD_NAME	--摊销算法名称
    ,IS_TPRICE	--是否估值
    ,FV_TYPE	--估值类型
    ,IS_ALLOW_WITHDRAW	--是否允许支取 0:不允许支持 1:允许支持（不需要审批） 2:允许支持（需要审批）
    ,IS_ALLOW_ACCRUE	--是否允许计提
    ,IS_ALLOW_RECEIVEAI	--是否允许随时收息
    ,IS_AUTO_OVERDUE	--是否自动逾期;1:是，0：否
    ,PENDING_ACCOUNT	--挂账账户
    ,PENDING_ACCOUNT_NAME	--挂账账户户名
    ,START_DT	--开始时间
    ,END_DT	--结束时间
    ,ID_MARK	--增删标志

    FROM IOL.V_IBMS_TTRD_P_TYPE   --资产类型表_视图
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

  END ETL_INIT_O_IOL_IBMS_TTRD_P_TYPE;
/

