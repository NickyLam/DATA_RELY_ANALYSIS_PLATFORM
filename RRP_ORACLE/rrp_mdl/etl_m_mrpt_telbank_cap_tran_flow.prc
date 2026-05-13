CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_TELBANK_CAP_TRAN_FLOW(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_TELBANK_CAP_TRAN_FLOW
  *  功能描述：电话银行资金交易流水
  *  创建日期：2023/01/06
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_IML_EVT_TELBANK_CAP_TRAN_FLOW  电话银行资金交易流水

  *  目标表：  M_MRPT_TELBANK_CAP_TRAN_FLOW
  *
  *  配置表：
  *  修改情况：1  2023/01/06  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_TELBANK_CAP_TRAN_FLOW' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_TELBANK_CAP_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_TELBANK_CAP_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
 -- DELETE FROM RPT_MRPT_RESULT T WHERE T.DATA_DATE = V_P_DATE AND T.RPT_NO = V_RPT_NO;--手工报表指标结果表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 电话银行资金交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_TELBANK_CAP_TRAN_FLOW NOLOGGING
             (DATA_DT                --01  数据日期
              ,EVT_ID                --02  事件编号
              ,LP_ID                 --03  法人编号
              ,TRAN_FLOW_NUM         --04  交易流水号
              ,CALL_FLOW_NUM         --05  呼叫流水号
              ,IN_CALL_NUM           --06  呼入电话号码
              ,AUD_SYS_CD            --07  语音系统代码
              ,TRAN_CD               --08  交易代码
              ,TRAN_DT               --09  交易日期
              ,TRAN_TM               --10  交易时间
              ,RETURN_CODE           --11  返回码
              ,RETURN_INFO           --12  返回信息
              ,CUST_NAME             --13  客户名称
              ,PAY_ACCT_ID           --14  付款账户编号
              ,PAY_BANK_NO           --15  付款行行号
              ,PAY_BANK_NAME         --16  付款行名称
              ,RECVBL_ACCT_ID        --17  收款账户编号
              ,RECVBL_ACCT_NAME      --18  收款账户名称
              ,RECV_BANK_NO          --19  收款行行号
              ,RECV_BANK_NAME        --20  收款行名称
              ,AVL_AGING_CD          --21  到账时效代码
              ,TRAN_AMT              --22  交易金额
              ,COMM_FEE              --23  手续费
              ,CURR_CD               --24  币种代码
              ,CHN_CD                --25  渠道代码
              ,DEP_TERM              --26  存期
              ,REDT_FLG              --27  转存标志
              ,OPERR_ID              --28  操作员编号
              ,SIGN_ORG_NAME         --29  签约机构名称
              ,DEP_TERM_CD           --30  存期代码
              ,SAV_TYPE_CD           --31  储种代码
              ,ETL_DT                --32  etl处理日期
              ,SRC_TABLE_NAME        --33  源表名称
              ,JOB_CD                --34  任务编码
              ,ETL_TIMESTAMP         --35  etl处理时间戳
       )
      SELECT  V_P_DATE                     --01  数据日期
              ,EVT_ID                      --02  事件编号
              ,LP_ID                       --03  法人编号
              ,TRAN_FLOW_NUM               --04  交易流水号
              ,CALL_FLOW_NUM               --05  呼叫流水号
              ,IN_CALL_NUM                 --06  呼入电话号码
              ,AUD_SYS_CD                  --07  语音系统代码
              ,TRAN_CD                     --08  交易代码
              ,TO_DATE(TO_CHAR(TRAN_TM,'YYYYMMDD'),'YYYYMMDD') --09  交易日期
              ,TRAN_TM                     --10  交易时间
              ,RETURN_CODE                 --11  返回码
              ,RETURN_INFO                 --12  返回信息
              ,CUST_NAME                   --13  客户名称
              ,PAY_ACCT_ID                 --14  付款账户编号
              ,PAY_BANK_NO                 --15  付款行行号
              ,PAY_BANK_NAME               --16  付款行名称
              ,RECVBL_ACCT_ID              --17  收款账户编号
              ,RECVBL_ACCT_NAME            --18  收款账户名称
              ,RECV_BANK_NO                --19  收款行行号
              ,RECV_BANK_NAME              --20  收款行名称
              ,AVL_AGING_CD                --21  到账时效代码
              ,TRAN_AMT                    --22  交易金额
              ,COMM_FEE                    --23  手续费
              ,CURR_CD                     --24  币种代码
              ,CHN_CD                      --25  渠道代码
              ,DEP_TERM                    --26  存期
              ,REDT_FLG                    --27  转存标志
              ,OPERR_ID                    --28  操作员编号
              ,SIGN_ORG_NAME               --29  签约机构名称
              ,DEP_TERM_CD                 --30  存期代码
              ,SAV_TYPE_CD                 --31  储种代码
              ,ETL_DT                      --32  etl处理日期
              ,SRC_TABLE_NAME              --33  源表名称
              ,JOB_CD                      --34  任务编码
              ,ETL_TIMESTAMP               --35  etl处理时间戳
         FROM RRP_MDL.O_IML_EVT_TELBANK_CAP_TRAN_FLOW  --电话银行资金交易流水
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --V_SQL :='TRUNCATE TABLE TMP_M_MFD_ASSURANCE_DP';
 -- EXECUTE IMMEDIATE V_SQL;

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
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_TELBANK_CAP_TRAN_FLOW;
/

