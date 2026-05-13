CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IBANK_BOND_DEBIT_CRDT(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：同业债券借贷
  **存储过程名称：    ETL_O_ICL_CMM_IBANK_BOND_DEBIT_CRDT
  **存储过程创建日期：20250507
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250507    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_ICL_CMM_IBANK_BOND_DEBIT_CRDT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IBANK_BOND_DEBIT_CRDT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业债券借贷';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_IBANK_BOND_DEBIT_CRDT NOLOGGING 
  (        ETL_DT            --数据日期
          ,LP_ID             --法人编号
          ,BUS_ID            --业务编号
          ,ENTRY_ORG_ID      --记账机构编号
          ,EXT_SECU_ACCT_ID  --外部证券账户编号
          ,INTNAL_SECU_ACCT_ID      --内部证券账户编号
          ,FIN_INSTM_ID      --金融工具编号
          ,ASSET_TYPE_ID     --资产类型编号
          ,ASSET_TYPE_NAME   --资产类型名称
          ,MARKET_TYPE_ID    --市场类型编号
          ,OBJ_ID            --对象编号
          ,ASSET_UNIQ_IDF_ID --资产唯一标识编号
          ,PROD_TYPE_CD      --产品类型代码
          ,TRAN_ACCT_B_ID    --交易账簿编号
          ,TRAN_ACCT_B_NAME  --交易账簿名称
          ,ACCT_B_ATTR_CD    --账簿属性代码
          ,STD_PROD_ID       --标准产品编号
          ,ASSET_THD_CLS_CD  --资产三分类代码
          ,CURR_CD           --币种代码
          ,TRAN_DIR_CD       --交易方向代码
          ,INT_ACCR_BASE_CD  --计息基准代码
          ,CNTPTY_CUST_ID    --交易对手客户编号
          ,CNTPTY_ID         --交易对手编号
          ,CNTPTY_NAME       --交易对手名称
          ,PORTF_ID          --投组编号
          ,PORTF_NAME        --投组名称
          ,PRIC_SUBJ_ID      --本金科目编号
          ,INT_SUBJ_ID       --利息科目编号
          ,TRAN_DT           --交易日期
          ,VALUE_DT          --起息日期
          ,EXP_DT            --到期日期
          ,TRAN_AMT          --交易金额
          ,EXP_STL_AMT       --到期结算金额
          ,DEBIT_CRDT_FEE_RAT --借贷费率
          ,DEBIT_CRDT_DAYS   --借贷天数
          ,INPWN_BOND_COMB   --质押债券组合
          ,UNDERLY_BOND_ID   --标的债券编号
          ,INPWN_CERT_FACE_LMT  --质押券面额
          ,ACRU_INT          --应计利息
          ,INT_RECVBL        --应收利息
          ,HOLD_POS          --持有仓位
          ,CURRT_BAL         --当期余额
          ,TRAN_ID           --交易编号
          ,TRAN_CLEAR_ACCT_ID   --交易清算账户编号
          ,TRAN_CLEAR_BANK_NO   --交易清算银行行号
          ,TRAN_CLEAR_BANK_NAME --交易清算银行行名
          ,JOB_CD             --任务代码
          ,ETL_TIMESTAMP      --数据处理时间
    )
    SELECT
          ETL_DT            --数据日期
          ,LP_ID             --法人编号
          ,BUS_ID            --业务编号
          ,ENTRY_ORG_ID      --记账机构编号
          ,EXT_SECU_ACCT_ID  --外部证券账户编号
          ,INTNAL_SECU_ACCT_ID      --内部证券账户编号
          ,FIN_INSTM_ID      --金融工具编号
          ,ASSET_TYPE_ID     --资产类型编号
          ,ASSET_TYPE_NAME   --资产类型名称
          ,MARKET_TYPE_ID    --市场类型编号
          ,OBJ_ID            --对象编号
          ,ASSET_UNIQ_IDF_ID --资产唯一标识编号
          ,PROD_TYPE_CD      --产品类型代码
          ,TRAN_ACCT_B_ID    --交易账簿编号
          ,TRAN_ACCT_B_NAME  --交易账簿名称
          ,ACCT_B_ATTR_CD    --账簿属性代码
          ,STD_PROD_ID       --标准产品编号
          ,ASSET_THD_CLS_CD  --资产三分类代码
          ,CURR_CD           --币种代码
          ,TRAN_DIR_CD       --交易方向代码
          ,INT_ACCR_BASE_CD  --计息基准代码
          ,CNTPTY_CUST_ID    --交易对手客户编号
          ,CNTPTY_ID         --交易对手编号
          ,CNTPTY_NAME       --交易对手名称
          ,PORTF_ID          --投组编号
          ,PORTF_NAME        --投组名称
          ,PRIC_SUBJ_ID      --本金科目编号
          ,INT_SUBJ_ID       --利息科目编号
          ,TRAN_DT           --交易日期
          ,VALUE_DT          --起息日期
          ,EXP_DT            --到期日期
          ,TRAN_AMT          --交易金额
          ,EXP_STL_AMT       --到期结算金额
          ,DEBIT_CRDT_FEE_RAT --借贷费率
          ,DEBIT_CRDT_DAYS   --借贷天数
          ,INPWN_BOND_COMB   --质押债券组合
          ,UNDERLY_BOND_ID   --标的债券编号
          ,INPWN_CERT_FACE_LMT  --质押券面额
          ,ACRU_INT          --应计利息
          ,INT_RECVBL        --应收利息
          ,HOLD_POS          --持有仓位
          ,CURRT_BAL         --当期余额
          ,TRAN_ID           --交易编号
          ,TRAN_CLEAR_ACCT_ID   --交易清算账户编号
          ,TRAN_CLEAR_BANK_NO   --交易清算银行行号
          ,TRAN_CLEAR_BANK_NAME --交易清算银行行名
          ,JOB_CD             --任务代码
          ,ETL_TIMESTAMP      --数据处理时间
  FROM ICL.V_CMM_IBANK_BOND_DEBIT_CRDT --视图-同业债券借贷
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') 
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_IBANK_BOND_DEBIT_CRDT', '', O_ERRCODE);

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

END ETL_O_ICL_CMM_IBANK_BOND_DEBIT_CRDT;
/

