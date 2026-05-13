CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_REF_ONL_BANK_TRAN_CODE_H (
                                                                   I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2 )
 /*******************************************************************
  **存储过程详细说明：网上银行交易码参数历史表
  **存储过程名称：    ETL_M_MRPT_REF_ONL_BANK_TRAN_CODE_H
  **存储过程创建日期：20230112
  **存储过程创建人：  YANGJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --
  I_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_REF_ONL_BANK_TRAN_CODE_H'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  I_STEP_DESC VARCHAR2(200); --任务名称

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --清理当天数据
 DELETE FROM RRP_MDL.M_MRPT_REF_ONL_BANK_TRAN_CODE_H WHERE DATA_DT = V_P_DATE;--普通表的重跑处理
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;

  COMMIT;
 ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP      := 2; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '网上银行交易码参数数据插入目标表';
  D_STARTTIME := SYSDATE;

 INSERT /*+APPEND*/ INTO RRP_MDL.M_MRPT_REF_ONL_BANK_TRAN_CODE_H NOLOGGING
    (
    DATA_DT
   ,SERV_TYPE_CD   --服务类型代码
   ,TRAN_CODE       --交易码
   ,TRAN_NAME       --交易名称
   ,TRAN_FLG_COMB   --交易标志组合
   ,START_DT        --开始日期
   ,END_DT          --结束日期
   ,ID_MARK         --删除标识
   ,SRC_TABLE_NAME  --源表名称
   ,JOB_CD          --任务代码
    )
   SELECT /*+PARALLEL*/
    V_P_DATE
   ,SERV_TYPE_CD   --服务类型代码
   ,TRAN_CODE       --交易码
   ,TRAN_NAME       --交易名称
   ,TRAN_FLG_COMB   --交易标志组合
   ,START_DT        --开始日期
   ,END_DT          --结束日期
   ,ID_MARK         --删除标识
   ,SRC_TABLE_NAME  --源表名称
   ,JOB_CD          --任务代码
    FROM RRP_MDL.O_IML_REF_ONL_BANK_TRAN_CODE_H  -- 网上银行交易码参数历史表--视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYY-MM-DD')
     AND END_DT >= TO_DATE(V_P_DATE,'YYYY-MM-DD')
   ;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
     /*I_STEP := 3;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_REF_ONL_BANK_TRAN_CODE_H;
/

