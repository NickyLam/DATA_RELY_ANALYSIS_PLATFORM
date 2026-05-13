CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_UNIONPAY_COMM_FEE_FLOW(I_P_DATE IN INTEGER,
                                                                  O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_UNIONPAY_COMM_FEE_FLOW
  *  功能描述：银联手续费流水
  *  创建日期：20221229
  *  开发人员：阳娟
  *  来源表： O_IML_EVT_UNIONPAY_COMM_FEE_FLOW
  *  目标表： M_MRPT_UNIONPAY_COMM_FEE_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221229  阳娟     首次创建
  ***************************************************************************/
   AS
  -- 定义变量 --
  --XZY 这里要注意，不用他们的规则，用我们自己的规则，变量前一个字母是字段类型的首字母，方便看类型，比如INTEGER类型就用I_开头，VARCHAR2就用V_开头
  --XZY 这部分基本照抄，开发完成后再把不需要的去掉
  I_STEP      INTEGER := 0; -- 处理步骤
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE; -- 处理结束时间
  I_STEP_DESC VARCHAR2(100); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_UNIONPAY_COMM_FEE_FLOW'; -- 程序名称 --XZY 新建一个的时候，批量替换成新的名字就行
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态SQL
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_UNIONPAY_COMM_FEE_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_EVT_OS_INVEST_FINC_BUS_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  V_SQL :='TRUNCATE TABLE M_MRPT_UNIONPAY_COMM_FEE_FLOW';
  EXECUTE IMMEDIATE V_SQL;
  
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  -- 程序业务逻辑处理主体部分 --
  I_STEP := I_STEP + 1; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '数据落地-银联手续费流水';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_UNIONPAY_COMM_FEE_FLOW
  (
           DATA_DT
          ,EVT_ID  --事件编号
          ,LP_ID  --法人编号
          ,ORG_ID  --机构编号
          ,UNIONPAY_TRAN_TYPE_CD  --银联交易类型代码
          ,TRADER_TYPE_CD  --交易方类型代码
          ,TRAN_DT  --交易日期
          ,INT_PAYBL_AMT  --应付金额
          ,RECVBL_AMT  --应收金额
          ,FRONT_DT  --前置日期
          ,FRONT_FLOW_NUM  --前置流水号
          ,CORE_TRAN_FLOW_NUM  --核心交易流水号
          ,CORE_TRAN_DT  --核心交易日期
          ,UNIONPAY_FRONT_TRAN_STATUS_CD  --银联前置交易状态代码
          ,ERR_CD  --错误码
          ,ERR_INFO_DESC  --错误信息描述
          ,PAYBL_EXCH_FEE  --应付交换费
          ,RECVBL_EXCH_FEE  --应收交换费
          ,TRAN_CLEAR_FEE  --转接清算费
          ,ETL_DT  --ETL处理日期
          ,SRC_TABLE_NAME  --源表名称
          ,JOB_CD  --任务编码
           )
    SELECT
           V_P_DATE
          ,EVT_ID  --事件编号
          ,LP_ID  --法人编号
          ,ORG_ID  --机构编号
          ,UNIONPAY_TRAN_TYPE_CD  --银联交易类型代码
          ,TRADER_TYPE_CD  --交易方类型代码
          ,TRAN_DT  --交易日期
          ,INT_PAYBL_AMT  --应付金额
          ,RECVBL_AMT  --应收金额
          ,FRONT_DT  --前置日期
          ,FRONT_FLOW_NUM  --前置流水号
          ,CORE_TRAN_FLOW_NUM  --核心交易流水号
          ,CORE_TRAN_DT  --核心交易日期
          ,UNIONPAY_FRONT_TRAN_STATUS_CD  --银联前置交易状态代码
          ,ERR_CD  --错误码
          ,ERR_INFO_DESC  --错误信息描述
          ,PAYBL_EXCH_FEE  --应付交换费
          ,RECVBL_EXCH_FEE  --应收交换费
          ,TRAN_CLEAR_FEE  --转接清算费
          ,ETL_DT  --ETL处理日期
          ,SRC_TABLE_NAME  --源表名称
          ,JOB_CD  --任务编码
     FROM RRP_MDL.O_IML_EVT_UNIONPAY_COMM_FEE_FLOW  ---银联手续费流水
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

   I_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   D_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
   /*  I_STEP := I_STEP + 1;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_UNIONPAY_COMM_FEE_FLOW;
/

