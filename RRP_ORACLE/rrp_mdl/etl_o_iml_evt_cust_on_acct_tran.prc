CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CUST_ON_ACCT_TRAN(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：客户挂账交易事件
  **存储过程名称：    ETL_O_IML_EVT_CUST_ON_ACCT_TRAN
  **存储过程创建日期：20250408
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250408    YJY        创建
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_CUST_ON_ACCT_TRAN'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CUST_ON_ACCT_TRAN';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-客户挂账交易事件';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_CUST_ON_ACCT_TRAN NOLOGGING 
  (    EVT_ID                    --事件编号
       ,LP_ID                    --法人编号
       ,ON_ACCT_SEQ_NUM          --挂账序号
       ,ON_ACCT_SUB_ACCT_NUM     --挂账子账号
       ,CURR_CD                  --币种代码
       ,CUST_ACCT_NUM            --客户账号
       ,CUST_TYPE_CD             --客户类型代码
       ,CUST_ID                  --客户编号
       ,CUST_NAME                --客户名称
       ,CERT_NO                  --证件号码
       ,CERT_TYPE_CD             --证件类型代码
       ,APPL_CUST_ID             --申请客户编号
       ,DEBIT_CRDT_FLG           --借贷标志
       ,ON_ACCT_TOT              --挂账总额
       ,ON_ACCT_AMT              --挂账金额
       ,ON_ACCT_BAL              --挂账余额
       ,ON_ACCT_EXP_DT           --挂账到期日期
       ,CAP_SRC_CD               --资金来源代码
       ,TRAN_REF_NO              --交易参考号
       ,TRAN_DT                  --交易日期
       ,TRAN_TM                  --交易时间
       ,TRAN_STATUS_CD           --交易状态代码
       ,CNTPTY_ACCT_NAME         --交易对手账户名称
       ,CNTPTY_ACCT_ID           --交易对手账户编号
       ,CNTPTY_OPEN_ACCT_ORG_ID  --交易对手开户机构编号
       ,CNTPTY_ACCT_BANK_INT_FLG --交易对手账户行内标志
       ,TRAN_TELLER_ID           --交易柜员编号
       ,TRAN_ORG_ID              --交易机构编号
       ,TRAN_MEMO_DESCB          --交易摘要描述
       ,STL_ACCT_NAME            --结算账户名称
       ,STL_ACCT_ID              --结算账户编号
       ,GOLD_BUS_ID              --押金业务编号
       ,AUTH_TELLER_ID           --授权柜员编号
       ,LAST_MODIF_DT            --上次修改日期
       ,FINAL_MODIF_DT           --最后修改日期
       ,START_DT                 --开始时间
       ,END_DT                   --结束时间
       ,ID_MARK                  --增删标志
       ,SRC_TABLE_NAME           --源表名称
       ,JOB_CD                   --任务编码
       ,ETL_TIMESTAMP            --ETL处理时间戳
    )
    SELECT
        EVT_ID                    --事件编号
       ,LP_ID                    --法人编号
       ,ON_ACCT_SEQ_NUM          --挂账序号
       ,ON_ACCT_SUB_ACCT_NUM     --挂账子账号
       ,CURR_CD                  --币种代码
       ,CUST_ACCT_NUM            --客户账号
       ,CUST_TYPE_CD             --客户类型代码
       ,CUST_ID                  --客户编号
       ,CUST_NAME                --客户名称
       ,CERT_NO                  --证件号码
       ,CERT_TYPE_CD             --证件类型代码
       ,APPL_CUST_ID             --申请客户编号
       ,DEBIT_CRDT_FLG           --借贷标志
       ,ON_ACCT_TOT              --挂账总额
       ,ON_ACCT_AMT              --挂账金额
       ,ON_ACCT_BAL              --挂账余额
       ,ON_ACCT_EXP_DT           --挂账到期日期
       ,CAP_SRC_CD               --资金来源代码
       ,TRAN_REF_NO              --交易参考号
       ,TRAN_DT                  --交易日期
       ,TRAN_TM                  --交易时间
       ,TRAN_STATUS_CD           --交易状态代码
       ,CNTPTY_ACCT_NAME         --交易对手账户名称
       ,CNTPTY_ACCT_ID           --交易对手账户编号
       ,CNTPTY_OPEN_ACCT_ORG_ID  --交易对手开户机构编号
       ,CNTPTY_ACCT_BANK_INT_FLG --交易对手账户行内标志
       ,TRAN_TELLER_ID           --交易柜员编号
       ,TRAN_ORG_ID              --交易机构编号
       ,TRAN_MEMO_DESCB          --交易摘要描述
       ,STL_ACCT_NAME            --结算账户名称
       ,STL_ACCT_ID              --结算账户编号
       ,GOLD_BUS_ID              --押金业务编号
       ,AUTH_TELLER_ID           --授权柜员编号
       ,LAST_MODIF_DT            --上次修改日期
       ,FINAL_MODIF_DT           --最后修改日期
       ,START_DT                 --开始时间
       ,END_DT                   --结束时间
       ,ID_MARK                  --增删标志
       ,SRC_TABLE_NAME           --源表名称
       ,JOB_CD                   --任务编码
       ,ETL_TIMESTAMP            --ETL处理时间戳
  FROM IML.V_EVT_CUST_ON_ACCT_TRAN --视图-客户挂账交易事件
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_CUST_ON_ACCT_TRAN', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_EVT_CUST_ON_ACCT_TRAN;
/

