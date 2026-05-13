CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_MERCHT_TRAN_DTL(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_EVT_MERCHT_TRAN_DTL
  *  功能描述：商户交易明细流水表
  *  创建日期：2022/12/07
  *  开发人员：HDY
  *  来源表：  O_IML_EVT_MERCHT_TRAN_DTL 商户交易明细表

  *  目标表：  M_MRPT_EVT_MERCHT_TRAN_DTL
  *
  *  配置表：
  *  修改情况：1  202212/07  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_EVT_MERCHT_TRAN_DTL' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME      VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_EVT_MERCHT_TRAN_DTL'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_EVT_MERCHT_TRAN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --DELETE FROM RPT_MRPT_RESULT T WHERE T.DATA_DATE = V_P_DATE AND T.RPT_NO = V_RPT_NO;--手工报表指标结果表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_TRUNCATE(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 商户交易明细表--';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_EVT_MERCHT_TRAN_DTL
             (   DATA_DT                       --01 数据日期
                ,CARD_NO                       --02 卡号
                ,LP_ID                         --03 法人编号
                ,TRAN_TM                       --04 交易时间
                ,TRAN_DT                       --05 交易日期
                ,TRAN_TYPE_DESCB               --06 交易类型描述
                ,CURR_CD                       --07 币种代码
                ,TRAN_AMT                      --08 交易金额
                ,MERCHT_NO                     --09 商户号
                ,MERCHT_NAME                   --10 商户名称
                ,UNIONPAY_MERCHT_CATE_CD       --11 银联商户类别代码
                ,MERCHT_COMM_FEE               --12 商户手续费
                ,INT_PAYBL_AMT                 --13 应付金额
                ,RECVBL_AMT                    --14 应收金额
                ,DEBIT_CRDT_FLG                --15 借贷标志
                ,ETL_DT                        --16 etl处理日期
                ,SRC_TABLE_NAME                --17 源表名称
                ,JOB_CD                        --18 任务编码
       )
      SELECT   V_P_DATE                       --01 数据日期
               ,CARD_NO                       --02 卡号
               ,LP_ID                         --03 法人编号
               ,TRAN_TM                       --04 交易时间
               ,TRAN_DT                       --05 交易日期
               ,TRAN_TYPE_DESCB               --06 交易类型描述
               ,CURR_CD                       --07 币种代码
               ,TRAN_AMT                      --08 交易金额
               ,MERCHT_NO                     --09 商户号
               ,MERCHT_NAME                   --10 商户名称
               ,UNIONPAY_MERCHT_CATE_CD       --11 银联商户类别代码
               ,MERCHT_COMM_FEE               --12 商户手续费
               ,INT_PAYBL_AMT                 --13 应付金额
               ,RECVBL_AMT                    --14 应收金额
               ,DEBIT_CRDT_FLG                --15 借贷标志
               ,ETL_DT                        --16 etl处理日期
               ,SRC_TABLE_NAME                --17 源表名称
               ,JOB_CD                        --18 任务编码
          FROM RRP_MDL.O_IML_EVT_MERCHT_TRAN_DTL  --商户交易明细表
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    D_ENDTIME := SYSDATE;
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_EVT_MERCHT_TRAN_DTL;
/

