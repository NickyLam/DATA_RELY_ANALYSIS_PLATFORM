CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：大额存单转让申请表
  **存储过程名称：    ETL_O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO
  **存储过程创建日期：20251210
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251210    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-大额存单转让申请表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO NOLOGGING 
  (      ACCT_SEQ_NO                 --账户子账号
        ,BASE_ACCT_NO                --交易账号/卡号
        ,CLIENT_NAME                 --客户名称
        ,CLIENT_NO                   --客户编号
        ,INTERNAL_KEY                --账户内部键值
        ,USER_ID                     --交易柜员编号
        ,COMPANY                     --法人
        ,RES_SEQ_NO                  --限制编号
        ,STAGE_CODE                  --期次代码
        ,LAST_CHANGE_DATE            --最后修改日期
        ,TRAN_DATE                   --交易日期
        ,TRAN_TIMESTAMP              --交易时间戳
        ,DEP_KEEP_DAYS               --存款天数
        ,INT_REM_DAYS                --计息剩余天数
        ,TRF_TOTAL_SETTLE_AMT        --转让总对价
        ,TRF_END_DATE                --转让到期日
        ,DIRECTION_TRF_FLAG          --是否定期转让
        ,ORDER_START_DATE            --挂单起始日期
        ,TRF_IN_FEE_AMT              --转入费用
        ,ORDER_END_DATE              --挂单结束日期
        ,TRF_PRI_AMT                 --转让本金金额
        ,TRF_COMMAND                 --转让口令
        ,TRF_RATE                    --转让利率
        ,TRF_TYPE                    --转让类型
        ,TRF_STATUS                  --转让状态
        ,BENEFICIARY_CLIENT_NO       --受益人客户号
        ,TRF_NO                      --转让号
        ,TRF_DATE                    --转让日期
        ,BENEFICIARY_PROFIT_RATE     --受让人收益率
        ,TRF_OUT_FEE_AMT             --转出费用
        ,PROD_TYPE                   --产品编号|产品编号
        ,SETTLE_ACCT_SEQ_NO          --结算账户序号|结算账户序号
        ,SETTLE_BASE_ACCT_NO         --结算账号|结算账号
        ,INNER_BASE_ACCT_NO          --转入账号/卡号
        ,REFERENCE                   --转让流水号
        ,REC_TIME                    --申请时间
        ,START_DT                    --开始时间
        ,END_DT                      --结束时间
        ,ID_MARK                     --增删标志
        ,ETL_TIMESTAMP               --ETL处理时间戳
    )
  SELECT 
        ACCT_SEQ_NO                 --账户子账号
        ,BASE_ACCT_NO                --交易账号/卡号
        ,CLIENT_NAME                 --客户名称
        ,CLIENT_NO                   --客户编号
        ,INTERNAL_KEY                --账户内部键值
        ,USER_ID                     --交易柜员编号
        ,COMPANY                     --法人
        ,RES_SEQ_NO                  --限制编号
        ,STAGE_CODE                  --期次代码
        ,LAST_CHANGE_DATE            --最后修改日期
        ,TRAN_DATE                   --交易日期
        ,TRAN_TIMESTAMP              --交易时间戳
        ,DEP_KEEP_DAYS               --存款天数
        ,INT_REM_DAYS                --计息剩余天数
        ,TRF_TOTAL_SETTLE_AMT        --转让总对价
        ,TRF_END_DATE                --转让到期日
        ,DIRECTION_TRF_FLAG          --是否定期转让
        ,ORDER_START_DATE            --挂单起始日期
        ,TRF_IN_FEE_AMT              --转入费用
        ,ORDER_END_DATE              --挂单结束日期
        ,TRF_PRI_AMT                 --转让本金金额
        ,TRF_COMMAND                 --转让口令
        ,TRF_RATE                    --转让利率
        ,TRF_TYPE                    --转让类型
        ,TRF_STATUS                  --转让状态
        ,BENEFICIARY_CLIENT_NO       --受益人客户号
        ,TRF_NO                      --转让号
        ,TRF_DATE                    --转让日期
        ,BENEFICIARY_PROFIT_RATE     --受让人收益率
        ,TRF_OUT_FEE_AMT             --转出费用
        ,PROD_TYPE                   --产品编号|产品编号
        ,SETTLE_ACCT_SEQ_NO          --结算账户序号|结算账户序号
        ,SETTLE_BASE_ACCT_NO         --结算账号|结算账号
        ,INNER_BASE_ACCT_NO          --转入账号/卡号
        ,REFERENCE                   --转让流水号
        ,REC_TIME                    --申请时间
        ,START_DT                    --开始时间
        ,END_DT                      --结束时间
        ,ID_MARK                     --增删标志
        ,ETL_TIMESTAMP               --ETL处理时间戳
    FROM IOL.V_NCBS_RB_DC_CHANGE_APPLY_INFO    --视图-大额存单转让申请表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_NCBS_RB_DC_CHANGE_APPLY_INFO;
/

