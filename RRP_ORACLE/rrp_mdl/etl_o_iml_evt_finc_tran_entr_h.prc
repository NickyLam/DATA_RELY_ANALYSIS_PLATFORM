CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_FINC_TRAN_ENTR_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：理财交易委托历史
  **存储过程名称：    ETL_O_IML_EVT_FINC_TRAN_ENTR_H
  **存储过程创建日期：20251010
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251010    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_FINC_TRAN_ENTR_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_FINC_TRAN_ENTR_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-理财交易委托历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_FINC_TRAN_ENTR_H NOLOGGING 
  (           EVT_ID                     --事件编号
             ,LP_ID                      --法人编号
             ,ENTR_FLOW_NUM              --委托流水号
             ,INTIOR_FLOW_NUM            --发起方流水号
             ,CONT_ID                    --合约编号
             ,TRAN_DT                    --交易日期
             ,TRAN_TM                    --交易时间
             ,TRAN_SYS_DT                --交易系统日期
             ,SELLER_CD                  --销售商代码
             ,TRAN_CD                    --交易代码
             ,TRAN_ORG_ID                --交易机构编号
             ,TRAN_ACCT_OPEN_ORG_ID      --交易账户开户机构编号
             ,TA_CD                      --TA代码
             ,FINC_ACCT_NUM              --理财账号
             ,INTNAL_CUST_ID             --内部客户编号
             ,CUST_TYPE_CD               --客户类型代码
             ,BANK_ID                    --银行编号
             ,PARTY_ID                   --当事人编号
             ,BANK_ACCT_ID               --银行账户编号
             ,EC_IDF_CD                  --钞汇标识代码
             ,TRAN_MED_TYPE_CD           --交易介质类型代码
             ,TRAN_MED_ID                --交易介质编号
             ,TRAN_CHN_CD                --交易渠道代码
             ,TRAN_TELLER_ID             --交易柜员编号
             ,AUTH_TELLER_ID             --授权柜员编号
             ,PROD_ID                    --产品编号
             ,CURR_CD                    --币种代码
             ,PROD_CATE_CD               --产品类别代码
             ,PROD_WAY_CD                --产品方式代码
             ,RELA_DT                    --关联日期
             ,RELA_FLOW_NUM              --关联流水号
             ,TRAN_AMT                   --交易金额
             ,CUST_GROUPING_CD           --客户分组代码
             ,ACCT_STATUS_CD             --账务状态代码
             ,INIT_FLOW_TRAN_CHN         --原流水交易渠道
             ,INIT_FLOW_TRAN_ORG_ID      --原流水交易机构编号
             ,TRAN_LOT                   --交易份额
             ,HUGE_REDEM_PROC_FLG        --巨额赎回处理标志
             ,REDEM_MODE_CD              --赎回模式代码
             ,DIVD_WAY_CD                --分红方式代码
             ,FROZ_RS_CD                 --冻结原因代码
             ,TARGET_BANK_ACCT_ID        --目标银行账户编号
             ,CUST_RISK_LEVEL_CD         --客户风险等级代码
             ,PROD_RISK_LEVEL_CD         --产品风险等级代码
             ,SEND_HOST_FLOW_NUM         --发送主机流水号
             ,HOST_CHECK_ENTRY_DT        --主机对账日期
             ,INIT_TRAN_HOST_ENTRY_DT    --原交易主机对账日期
             ,HOST_TRAN_CD               --主机交易代码
             ,HOST_DT                    --主机日期
             ,HOST_FLOW_ID               --主机流水编号
             ,SUPV_NOMAL_FLG             --监管正常标志
             ,CUST_MGR_ID                --客户经理编号
             ,ERR_DESCB                  --错误描述
             ,TRAN_STATUS_CD             --交易状态代码
             ,ACCPT_WAY_CD               --受理方式代码
             ,MEMO_DESCB                 --摘要描述
             ,BUY_ACCT_ID                --购买账户编号
             ,REDEM_ACCT_ID              --赎回账户编号
             ,STDBY_AMT                  --备用金额
             ,REMARK_FIELD_1             --备注字段1
             ,REMARK_FIELD_2             --备注字段2
             ,START_DT                   --开始时间
             ,END_DT                     --结束时间
             ,ID_MARK                    --增删标志
             ,SRC_TABLE_NAME             --源表名称
             ,JOB_CD                     --任务编码
             ,ETL_TIMESTAMP              --ETL处理时间戳
    )
    SELECT
              EVT_ID                     --事件编号
             ,LP_ID                      --法人编号
             ,ENTR_FLOW_NUM              --委托流水号
             ,INTIOR_FLOW_NUM            --发起方流水号
             ,CONT_ID                    --合约编号
             ,TRAN_DT                    --交易日期
             ,TRAN_TM                    --交易时间
             ,TRAN_SYS_DT                --交易系统日期
             ,SELLER_CD                  --销售商代码
             ,TRAN_CD                    --交易代码
             ,TRAN_ORG_ID                --交易机构编号
             ,TRAN_ACCT_OPEN_ORG_ID      --交易账户开户机构编号
             ,TA_CD                      --TA代码
             ,FINC_ACCT_NUM              --理财账号
             ,INTNAL_CUST_ID             --内部客户编号
             ,CUST_TYPE_CD               --客户类型代码
             ,BANK_ID                    --银行编号
             ,PARTY_ID                   --当事人编号
             ,BANK_ACCT_ID               --银行账户编号
             ,EC_IDF_CD                  --钞汇标识代码
             ,TRAN_MED_TYPE_CD           --交易介质类型代码
             ,TRAN_MED_ID                --交易介质编号
             ,TRAN_CHN_CD                --交易渠道代码
             ,TRAN_TELLER_ID             --交易柜员编号
             ,AUTH_TELLER_ID             --授权柜员编号
             ,PROD_ID                    --产品编号
             ,CURR_CD                    --币种代码
             ,PROD_CATE_CD               --产品类别代码
             ,PROD_WAY_CD                --产品方式代码
             ,RELA_DT                    --关联日期
             ,RELA_FLOW_NUM              --关联流水号
             ,TRAN_AMT                   --交易金额
             ,CUST_GROUPING_CD           --客户分组代码
             ,ACCT_STATUS_CD             --账务状态代码
             ,INIT_FLOW_TRAN_CHN         --原流水交易渠道
             ,INIT_FLOW_TRAN_ORG_ID      --原流水交易机构编号
             ,TRAN_LOT                   --交易份额
             ,HUGE_REDEM_PROC_FLG        --巨额赎回处理标志
             ,REDEM_MODE_CD              --赎回模式代码
             ,DIVD_WAY_CD                --分红方式代码
             ,FROZ_RS_CD                 --冻结原因代码
             ,TARGET_BANK_ACCT_ID        --目标银行账户编号
             ,CUST_RISK_LEVEL_CD         --客户风险等级代码
             ,PROD_RISK_LEVEL_CD         --产品风险等级代码
             ,SEND_HOST_FLOW_NUM         --发送主机流水号
             ,HOST_CHECK_ENTRY_DT        --主机对账日期
             ,INIT_TRAN_HOST_ENTRY_DT    --原交易主机对账日期
             ,HOST_TRAN_CD               --主机交易代码
             ,HOST_DT                    --主机日期
             ,HOST_FLOW_ID               --主机流水编号
             ,SUPV_NOMAL_FLG             --监管正常标志
             ,CUST_MGR_ID                --客户经理编号
             ,ERR_DESCB                  --错误描述
             ,TRAN_STATUS_CD             --交易状态代码
             ,ACCPT_WAY_CD               --受理方式代码
             ,MEMO_DESCB                 --摘要描述
             ,BUY_ACCT_ID                --购买账户编号
             ,REDEM_ACCT_ID              --赎回账户编号
             ,STDBY_AMT                  --备用金额
             ,REMARK_FIELD_1             --备注字段1
             ,REMARK_FIELD_2             --备注字段2
             ,START_DT                   --开始时间
             ,END_DT                     --结束时间
             ,ID_MARK                    --增删标志
             ,SRC_TABLE_NAME             --源表名称
             ,JOB_CD                     --任务编码
             ,ETL_TIMESTAMP              --ETL处理时间戳
  FROM IML.V_EVT_FINC_TRAN_ENTR_H --视图-理财交易委托历史
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_FINC_TRAN_ENTR_H', '', O_ERRCODE);

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

END ETL_O_IML_EVT_FINC_TRAN_ENTR_H;
/

