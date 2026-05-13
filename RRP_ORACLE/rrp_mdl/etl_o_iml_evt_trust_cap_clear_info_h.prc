CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_TRUST_CAP_CLEAR_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：信托资金清算信息历史
  **存储过程名称：    ETL_O_IML_EVT_TRUST_CAP_CLEAR_INFO_H
  **存储过程创建日期：20250915
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250915    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_TRUST_CAP_CLEAR_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_TRUST_CAP_CLEAR_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-信托资金清算信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_TRUST_CAP_CLEAR_INFO_H NOLOGGING 
  (        EVT_ID                   --事件编号
          ,LP_ID                    --法人编号
          ,CLEAR_FLOW_NUM           --清算流水号
          ,TRAN_DT                  --交易日期
          ,CLEAR_DT                 --清算日期
          ,ACTL_ENTER_ACCT_DT       --实际入账日期
          ,BF_ACTL_ENTER_ACCT_DT    --变动前实际入账日期
          ,CFM_FLOW_NUM             --确认流水号
          ,RELA_FLOW_NUM            --关联流水号
          ,INTIOR_CD                --发起方代码
          ,TRAN_CD                  --交易代码
          ,BUS_CD                   --业务代码
          ,CUST_TYPE_CD             --客户类型代码
          ,FINC_CUST_ID             --理财客户编号
          ,BANK_ID                  --银行编号
          ,CUST_ID                  --交易客户编号
          ,BANK_ACCT_ID             --银行账户编号
          ,BANK_ACCT_TYPE_CD        --银行账户类型代码
          ,TRAN_CHN_CD              --交易渠道编号
          ,TRAN_TELLER_ID           --交易柜员编号
          ,TERMN_ID                 --交易终端编号
          ,TRAN_ORG_ID              --交易机构编号
          ,TRAN_BELONG_ORG_ID       --交易所属机构编号
          ,TA_CD                    --TA代码
          ,PROD_CD                  --产品代码
          ,ACCT_DIR_CD              --账务方向代码
          ,CLEAR_AMT                --清算金额
          ,CURR_CD                  --币种代码
          ,EC_IDF_CD                --钞汇标识代码
          ,UNFRZ_AMT                --解冻金额
          ,HOST_TRAN_CODE           --主机交易码
          ,HOST_DT                  --主机日期
          ,HOST_FLOW_NUM            --主机流水号
          ,FROZ_AMT                 --冻结金额
          ,BAL_CHK_CFM_CD           --勾对确认代码
          ,CAP_CATE_CD              --资金类别代码
          ,PRIC_PRFT_FLG            --本金收益标志
          ,CFM_LOT                  --确认份额
          ,PRIC                     --本金
          ,PROD_ACCT_NUM            --产品账号
          ,PROD_ACCT_TYPE_CD        --产品账户类型代码
          ,MEMO_COMNT               --摘要说明
          ,STATUS_CD                --状态代码
          ,INIT_CLEAR_FLOW_NUM      --原清算流水号
          ,RETURN_CODE              --返回码
          ,RETURN_INFO              --返回信息
          ,INTFC_PROC_FLG_CD        --接口处理标志代码
          ,START_DT                 --开始时间
          ,END_DT                   --结束时间
          ,ID_MARK                  --增删标志
          ,SRC_TABLE_NAME           --源表名称
          ,JOB_CD                   --任务编码
          ,ETL_TIMESTAMP            --ETL处理时间戳
    )
    SELECT
          EVT_ID                   --事件编号
          ,LP_ID                    --法人编号
          ,CLEAR_FLOW_NUM           --清算流水号
          ,TRAN_DT                  --交易日期
          ,CLEAR_DT                 --清算日期
          ,ACTL_ENTER_ACCT_DT       --实际入账日期
          ,BF_ACTL_ENTER_ACCT_DT    --变动前实际入账日期
          ,CFM_FLOW_NUM             --确认流水号
          ,RELA_FLOW_NUM            --关联流水号
          ,INTIOR_CD                --发起方代码
          ,TRAN_CD                  --交易代码
          ,BUS_CD                   --业务代码
          ,CUST_TYPE_CD             --客户类型代码
          ,FINC_CUST_ID             --理财客户编号
          ,BANK_ID                  --银行编号
          ,CUST_ID                  --交易客户编号
          ,BANK_ACCT_ID             --银行账户编号
          ,BANK_ACCT_TYPE_CD        --银行账户类型代码
          ,TRAN_CHN_CD              --交易渠道编号
          ,TRAN_TELLER_ID           --交易柜员编号
          ,TERMN_ID                 --交易终端编号
          ,TRAN_ORG_ID              --交易机构编号
          ,TRAN_BELONG_ORG_ID       --交易所属机构编号
          ,TA_CD                    --TA代码
          ,PROD_CD                  --产品代码
          ,ACCT_DIR_CD              --账务方向代码
          ,CLEAR_AMT                --清算金额
          ,CURR_CD                  --币种代码
          ,EC_IDF_CD                --钞汇标识代码
          ,UNFRZ_AMT                --解冻金额
          ,HOST_TRAN_CODE           --主机交易码
          ,HOST_DT                  --主机日期
          ,HOST_FLOW_NUM            --主机流水号
          ,FROZ_AMT                 --冻结金额
          ,BAL_CHK_CFM_CD           --勾对确认代码
          ,CAP_CATE_CD              --资金类别代码
          ,PRIC_PRFT_FLG            --本金收益标志
          ,CFM_LOT                  --确认份额
          ,PRIC                     --本金
          ,PROD_ACCT_NUM            --产品账号
          ,PROD_ACCT_TYPE_CD        --产品账户类型代码
          ,MEMO_COMNT               --摘要说明
          ,STATUS_CD                --状态代码
          ,INIT_CLEAR_FLOW_NUM      --原清算流水号
          ,RETURN_CODE              --返回码
          ,RETURN_INFO              --返回信息
          ,INTFC_PROC_FLG_CD        --接口处理标志代码
          ,START_DT                 --开始时间
          ,END_DT                   --结束时间
          ,ID_MARK                  --增删标志
          ,SRC_TABLE_NAME           --源表名称
          ,JOB_CD                   --任务编码
          ,ETL_TIMESTAMP            --ETL处理时间戳
  FROM IML.V_EVT_TRUST_CAP_CLEAR_INFO_H --视图-信托资金清算信息历史
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D'
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_TRUST_CAP_CLEAR_INFO_H', '', O_ERRCODE);

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

END ETL_O_IML_EVT_TRUST_CAP_CLEAR_INFO_H;
/

