CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_INTSTL_REMIT_EVT(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：国结汇款事件
  **存储过程名称：    ETL_O_IML_EVT_INTSTL_REMIT_EVT
  **存储过程创建日期：20250121
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250121    YJY        创建
  ** 20250417    YJY        新增跨境电商标志
  ***************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_INTSTL_REMIT_EVT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_INTSTL_REMIT_EVT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-国结汇款事件';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_INTSTL_REMIT_EVT NOLOGGING 
  (      EVT_ID                          --事件编号
        ,LP_ID                           --法人编号
        ,SORC_SYS_ID                     --源系统编号
        ,TRAN_DESCB                      --交易描述
        ,RECVER_CUST_ID                  --收款人客户编号
        ,RECVER_ADDR_NAME                --收款人地址名称
        ,RECVER_EN_NAME                  --收款人英文名称
        ,PAY_BANK_ID                     --付款银行编号
        ,PAY_BANK_ADDR_NAME              --付款银行地址名称
        ,PAY_BANK_NAME                   --付款银行名称
        ,REMITER_CUST_ID                 --汇款人客户编号
        ,REMITER_ADDR_NAME               --汇款人地址名称
        ,REMITER_NAME                    --汇款人名称
        ,REMIT_BANK_ID                   --汇款银行编号
        ,REMIT_BANK_ADDR_NAME            --汇款银行地址名称
        ,REMIT_BANK_NAME                 --汇款银行名称
        ,VALUE_DT                        --起息日期
        ,TRAN_START_TM                   --交易开始时间
        ,TRAN_CLOSE_TM                   --交易关闭时间
        ,ABMT_MSG_FEE_BEAR_WAY_CD        --汇入报文费用承担方式代码
        ,REMIT_OPER_TM                   --汇款经办时间
        ,OPER_USER                       --经办用户
        ,REMIT_OUT_MSG_FEE_BEAR_WAY_CD   --汇出报文费用承担方式代码
        ,PAY_TYPE_CD                     --付款类型代码
        ,CLEAR_ID                        --清算编号
        ,ABMT_COMM_FEE_CURR_CD           --汇入手续费币种代码
        ,ABMT_COMM_FEE_AMT               --汇入手续费金额
        ,REMIT_CATE_CD                   --汇款类别代码
        ,REMIT_WAY_CD                    --汇款方式代码
        ,PAY_DT                          --付款日期
        ,CUST_TYPE_CD                    --客户类型代码
        ,SOE_TYPE_CD                     --结汇类型代码
        ,INIT_CURR_CD                    --原始币种代码
        ,REMIT_OUT_COMM_FEE_CURR_CD      --汇出手续费币种代码
        ,REMIT_OUT_COMM_FEE_AMT          --汇出手续费金额
        ,INIT_AMT                        --原始金额
        ,EXCH_RAT                        --汇率
        ,SELL_FX_TYPE_CD                 --售汇类型代码
        ,MSG_TYPE_CD                     --报文类型代码
        ,BELONG_ORG_ID                   --归属机构编号
        ,OPER_ORG_ID                     --经办机构编号
        ,REMIT_PROC_TYPE_CD              --汇款处理类型代码
        ,BAL_PAY_TYPE_CD                 --收支类型代码
        ,REMITER_ACCT_ID                 --汇款人帐户编号
        ,RECVER_ACCT_ID                  --收款人帐户编号
        ,REFUND_FLG                      --退汇标志
        ,NRA_ACCT_FLG                    --NRA账户标志
        ,CLEAR_CHN_CD                    --清算渠道代码
        ,CROSS_BOR_CAP_POOL_FLG          --跨境资金池标志
        ,CAP_POOL_BUS_TYPE_CD            --资金池业务类型代码
        ,CAP_POOL_BUS_PRIC               --资金池业务本金
        ,CAP_POOL_BUS_INT                --资金池业务利息
        ,ENTR_PAY_ID                     --受托支付编号
        ,ENTR_PAY_OUT_ACCT_DUBIL_ID      --受托支付出账借据编号
        ,GPI_REMIT_FLG                   --GPI汇款标志
        ,GPI_MSG_FEEDBACK_STATUS_CD      --GPI报文反馈状态代码
        ,INQUIRY_FLG                     --询价标志
        ,DEDUCT_ACCT_ID                  --扣费账户编号
        ,START_DT                        --开始时间
        ,END_DT                          --结束时间
        ,ID_MARK                         --增删标志
        ,SRC_TABLE_NAME                  --源表名称
        ,JOB_CD                          --任务编码
        ,ETL_TIMESTAMP                   --ETL处理时间戳
        ,CBEC_FLG                        --跨境电商标志 --ADD BY YJY 20250417
    )
    SELECT
        EVT_ID                          --事件编号
        ,LP_ID                           --法人编号
        ,SORC_SYS_ID                     --源系统编号
        ,TRAN_DESCB                      --交易描述
        ,RECVER_CUST_ID                  --收款人客户编号
        ,RECVER_ADDR_NAME                --收款人地址名称
        ,RECVER_EN_NAME                  --收款人英文名称
        ,PAY_BANK_ID                     --付款银行编号
        ,PAY_BANK_ADDR_NAME              --付款银行地址名称
        ,PAY_BANK_NAME                   --付款银行名称
        ,REMITER_CUST_ID                 --汇款人客户编号
        ,REMITER_ADDR_NAME               --汇款人地址名称
        ,REMITER_NAME                    --汇款人名称
        ,REMIT_BANK_ID                   --汇款银行编号
        ,REMIT_BANK_ADDR_NAME            --汇款银行地址名称
        ,REMIT_BANK_NAME                 --汇款银行名称
        ,VALUE_DT                        --起息日期
        ,TRAN_START_TM                   --交易开始时间
        ,TRAN_CLOSE_TM                   --交易关闭时间
        ,ABMT_MSG_FEE_BEAR_WAY_CD        --汇入报文费用承担方式代码
        ,REMIT_OPER_TM                   --汇款经办时间
        ,OPER_USER                       --经办用户
        ,REMIT_OUT_MSG_FEE_BEAR_WAY_CD   --汇出报文费用承担方式代码
        ,PAY_TYPE_CD                     --付款类型代码
        ,CLEAR_ID                        --清算编号
        ,ABMT_COMM_FEE_CURR_CD           --汇入手续费币种代码
        ,ABMT_COMM_FEE_AMT               --汇入手续费金额
        ,REMIT_CATE_CD                   --汇款类别代码
        ,REMIT_WAY_CD                    --汇款方式代码
        ,PAY_DT                          --付款日期
        ,CUST_TYPE_CD                    --客户类型代码
        ,SOE_TYPE_CD                     --结汇类型代码
        ,INIT_CURR_CD                    --原始币种代码
        ,REMIT_OUT_COMM_FEE_CURR_CD      --汇出手续费币种代码
        ,REMIT_OUT_COMM_FEE_AMT          --汇出手续费金额
        ,INIT_AMT                        --原始金额
        ,EXCH_RAT                        --汇率
        ,SELL_FX_TYPE_CD                 --售汇类型代码
        ,MSG_TYPE_CD                     --报文类型代码
        ,BELONG_ORG_ID                   --归属机构编号
        ,OPER_ORG_ID                     --经办机构编号
        ,REMIT_PROC_TYPE_CD              --汇款处理类型代码
        ,BAL_PAY_TYPE_CD                 --收支类型代码
        ,REMITER_ACCT_ID                 --汇款人帐户编号
        ,RECVER_ACCT_ID                  --收款人帐户编号
        ,REFUND_FLG                      --退汇标志
        ,NRA_ACCT_FLG                    --NRA账户标志
        ,CLEAR_CHN_CD                    --清算渠道代码
        ,CROSS_BOR_CAP_POOL_FLG          --跨境资金池标志
        ,CAP_POOL_BUS_TYPE_CD            --资金池业务类型代码
        ,CAP_POOL_BUS_PRIC               --资金池业务本金
        ,CAP_POOL_BUS_INT                --资金池业务利息
        ,ENTR_PAY_ID                     --受托支付编号
        ,ENTR_PAY_OUT_ACCT_DUBIL_ID      --受托支付出账借据编号
        ,GPI_REMIT_FLG                   --GPI汇款标志
        ,GPI_MSG_FEEDBACK_STATUS_CD      --GPI报文反馈状态代码
        ,INQUIRY_FLG                     --询价标志
        ,DEDUCT_ACCT_ID                  --扣费账户编号
        ,START_DT                        --开始时间
        ,END_DT                          --结束时间
        ,ID_MARK                         --增删标志
        ,SRC_TABLE_NAME                  --源表名称
        ,JOB_CD                          --任务编码
        ,ETL_TIMESTAMP                   --ETL处理时间戳
        ,CBEC_FLG                        --跨境电商标志 --ADD BY YJY 20250417
  FROM IML.V_EVT_INTSTL_REMIT_EVT  --视图-国结汇款事件
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_INTSTL_REMIT_EVT', '', O_ERRCODE);

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

END ETL_O_IML_EVT_INTSTL_REMIT_EVT;
/

