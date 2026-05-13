CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_TRUST_TRAN_CFM_EVT(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：信托交易确认事件
  **存储过程名称：    ETL_O_IML_EVT_TRUST_TRAN_CFM_EVT
  **存储过程创建日期：20250911
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250911    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_TRUST_TRAN_CFM_EVT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_TRUST_TRAN_CFM_EVT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-信托交易确认事件';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_TRUST_TRAN_CFM_EVT NOLOGGING 
  (       EVT_ID                --事件编号
         ,LP_ID                 --法人编号
         ,TA_CD                 --TA代码
         ,CFM_DT                --确认日期
         ,TA_CFM_FLOW_NUM       --TA确认流水号
         ,INIT_CFM_FLOW_NUM     --原确认流水号
         ,INTIOR_TYPE_CD        --发起方类型代码
         ,TRAN_DT               --交易日期
         ,TRAN_TM               --交易时间
         ,CLEAR_DT              --清算日期
         ,FLOW_NUM              --流水号
         ,TRAN_CD               --交易代码
         ,BUS_CD                --业务代码
         ,TRAN_ORG_ID           --交易机构编号
         ,OPEN_ACCT_ORG_ID      --开户机构编号
         ,TRAN_CHN_CD           --交易渠道编号
         ,TERMN_ID              --交易终端编号
         ,TRAN_TELLER_ID        --交易柜员编号
         ,FINC_CUST_ID          --理财客户编号
         ,CUST_TYPE_CD          --客户类型代码
         ,FINC_ACCT_ID          --理财账户编号
         ,CUST_ID               --交易客户编号
         ,BANK_ACCT_ID          --银行账户编号
         ,TA_TRAN_ACCT_ID       --TA交易账户编号
         ,TRAN_MED_TYPE_CD      --交易介质类型代码
         ,TRAN_MED_ID           --交易介质编号
         ,EC_IDF_CD             --钞汇标识代码
         ,PROD_ID               --产品编号
         ,CHARGE_WAY_CD         --收费方式代码
         ,PROD_NV               --产品净值
         ,TRAN_PRICE            --交易价格
         ,TRAN_AMT              --交易金额
         ,STL_CURR_CD           --结算币种代码
         ,CFM_AMT               --确认金额
         ,TRAN_LOT              --交易份额
         ,CFM_LOT               --确认份额
         ,NEED_HUGE_REDEM_PROC_FLG  --需要巨额赎回处理标志
         ,FORCE_REDEM_RS        --强行赎回原因
         ,COMM_DISCNT           --佣金折扣
         ,TOT_COST              --总费用
         ,COMM_FEE              --手续费
         ,STAMP_TAX             --印花税
         ,INT_TAX               --利息税
         ,TRAN_FEE              --过户费
         ,AGENT_FEE             --代理费
         ,BACK_END_CHARGE       --后端收费
         ,OTHER_FEE_1           --其他费用1
         ,OTHER_FEE_2           --其他费用2
         ,CFM_PRFT              --确认收益
         ,MGMT_FEE              --管理费
         ,COTIN_FROZ_AMT        --继续冻结金额
         ,DTL_FLG               --明细标志
         ,END_TYPE_CD           --结束类型代码
         ,FROZ_RS_CD            --冻结原因代码
         ,TRAN_DIR_CD           --转换方向代码
         ,INT_AMT               --利息金额
         ,INT_TURN_LOT          --利息转份额
         ,DIVD_WAY_CD           --分红方式代码
         ,MEMO_COMNT            --摘要说明
         ,RETURN_CODE           --返回码
         ,ERR_INFO              --错误信息
         ,TRAN_STATUS_CD        --交易状态代码
         ,CUST_MGR_ID           --客户经理编号
         ,RELA_DT               --关联日期
         ,RELA_FLOW_NUM         --关联流水号
         ,BANK_COMM_FEE         --银行手续费
         ,INTIOR_FLOW_NUM       --发起方流水号
         ,CONT_ID               --合约编号
         ,HOST_TRAN_CD          --主机交易代码
         ,HOST_DT               --主机日期
         ,HOST_FLOW_NUM         --主机流水号
         ,TRAN_POST_LOT         --交易后份额
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
         ,SRC_TABLE_NAME        --源表名称
         ,JOB_CD                --任务编码
         ,ETL_TIMESTAMP         --ETL处理时间戳
    )
    SELECT
              EVT_ID                --事件编号
         ,LP_ID                 --法人编号
         ,TA_CD                 --TA代码
         ,CFM_DT                --确认日期
         ,TA_CFM_FLOW_NUM       --TA确认流水号
         ,INIT_CFM_FLOW_NUM     --原确认流水号
         ,INTIOR_TYPE_CD        --发起方类型代码
         ,TRAN_DT               --交易日期
         ,TRAN_TM               --交易时间
         ,CLEAR_DT              --清算日期
         ,FLOW_NUM              --流水号
         ,TRAN_CD               --交易代码
         ,BUS_CD                --业务代码
         ,TRAN_ORG_ID           --交易机构编号
         ,OPEN_ACCT_ORG_ID      --开户机构编号
         ,TRAN_CHN_CD           --交易渠道编号
         ,TERMN_ID              --交易终端编号
         ,TRAN_TELLER_ID        --交易柜员编号
         ,FINC_CUST_ID          --理财客户编号
         ,CUST_TYPE_CD          --客户类型代码
         ,FINC_ACCT_ID          --理财账户编号
         ,CUST_ID               --交易客户编号
         ,BANK_ACCT_ID          --银行账户编号
         ,TA_TRAN_ACCT_ID       --TA交易账户编号
         ,TRAN_MED_TYPE_CD      --交易介质类型代码
         ,TRAN_MED_ID           --交易介质编号
         ,EC_IDF_CD             --钞汇标识代码
         ,PROD_ID               --产品编号
         ,CHARGE_WAY_CD         --收费方式代码
         ,PROD_NV               --产品净值
         ,TRAN_PRICE            --交易价格
         ,TRAN_AMT              --交易金额
         ,STL_CURR_CD           --结算币种代码
         ,CFM_AMT               --确认金额
         ,TRAN_LOT              --交易份额
         ,CFM_LOT               --确认份额
         ,NEED_HUGE_REDEM_PROC_FLG  --需要巨额赎回处理标志
         ,FORCE_REDEM_RS        --强行赎回原因
         ,COMM_DISCNT           --佣金折扣
         ,TOT_COST              --总费用
         ,COMM_FEE              --手续费
         ,STAMP_TAX             --印花税
         ,INT_TAX               --利息税
         ,TRAN_FEE              --过户费
         ,AGENT_FEE             --代理费
         ,BACK_END_CHARGE       --后端收费
         ,OTHER_FEE_1           --其他费用1
         ,OTHER_FEE_2           --其他费用2
         ,CFM_PRFT              --确认收益
         ,MGMT_FEE              --管理费
         ,COTIN_FROZ_AMT        --继续冻结金额
         ,DTL_FLG               --明细标志
         ,END_TYPE_CD           --结束类型代码
         ,FROZ_RS_CD            --冻结原因代码
         ,TRAN_DIR_CD           --转换方向代码
         ,INT_AMT               --利息金额
         ,INT_TURN_LOT          --利息转份额
         ,DIVD_WAY_CD           --分红方式代码
         ,MEMO_COMNT            --摘要说明
         ,RETURN_CODE           --返回码
         ,ERR_INFO              --错误信息
         ,TRAN_STATUS_CD        --交易状态代码
         ,CUST_MGR_ID           --客户经理编号
         ,RELA_DT               --关联日期
         ,RELA_FLOW_NUM         --关联流水号
         ,BANK_COMM_FEE         --银行手续费
         ,INTIOR_FLOW_NUM       --发起方流水号
         ,CONT_ID               --合约编号
         ,HOST_TRAN_CD          --主机交易代码
         ,HOST_DT               --主机日期
         ,HOST_FLOW_NUM         --主机流水号
         ,TRAN_POST_LOT         --交易后份额
         ,START_DT              --开始时间
         ,END_DT                --结束时间
         ,ID_MARK               --增删标志
         ,SRC_TABLE_NAME        --源表名称
         ,JOB_CD                --任务编码
         ,ETL_TIMESTAMP         --ETL处理时间戳
  FROM IML.V_EVT_TRUST_TRAN_CFM_EVT --视图-信托交易确认事件
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_TRUST_TRAN_CFM_EVT', '', O_ERRCODE);

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

END ETL_O_IML_EVT_TRUST_TRAN_CFM_EVT;
/

