CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS
  *  功能描述：同业存单发行结果明细表
  *  创建日期：20240428
  *  开发人员：YJY
  *  来源表： IOL.V_IBMS_VTRD_NCD_RESULT_DETAILS
  *  目标表： O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240428  YJY     首次创建
  **************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                    --跑批数据日期
  V_STARTTIME DATE;                           --处理开始时间
  V_ENDTIME   DATE;                           --处理结束时间
  V_STEP      INTEGER := 0;                   --处理步骤
  V_SQLCOUNT  INTEGER := 0;                   --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                  --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                  --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS';
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';     --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS T WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业存单发行结果明细表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS
    (
         SEQ_ID                     --序列号                                    
        ,SYSORDID                   --交易单号                                  
        ,REF_SYSORDID               --子交易单号                                
        ,I_CODE                     --存单代码                                  
        ,A_TYPE                     --存单资产类型                              
        ,M_TYPE                     --存单市场类型                              
        ,ISSUE_TYPE                 --发行方式(1-报价发行,2-招标发行,3-浮息发行)
        ,PARTYID                    --认购人ID                                  
        ,PARTYNAME                  --认购人名称                                
        ,BID_PRICE                  --投标价位(元)                              
        ,BID_AMOUNT                 --投标量(亿元)                              
        ,BIDDING_PRICE              --中标价位(元)                              
        ,BIDDING_AMOUNT             --中标量(亿元)                              
        ,BID_TIME                   --认购时间                                  
        ,USERNAME                   --提交用户                                  
        ,BIDDING_ACTUAL_AMOUNT      --实际认购量                                
        ,MEMO                       --备注                                      
        ,SALES_ORGANIZATION         --销售机构                                  
        ,COST_CALCULATE_RULE        --费用计算规则                              
        ,BIDDING_PAY_AMOUNT         --缴款金额(元)                              
        ,BANK_CODE                  --开户行行号                                
        ,TRDACCCODE                 --交易账号                                  
        ,SALES_NAME                 --销售机构名称                              
        ,SALES_ORG_NAME             --                                          
        ,SALES_RATIO                --                                          
        ,SALES_ORG_RATIO            --                                          
        ,SALES_NAME_RATE            --                                          
        ,SALES_ORG_NAME_RATE        --                                          
        ,START_DT                   --开始时间                                  
        ,END_DT                     --结束时间                                  
        ,ID_MARK                    --增删标志                                  
        ,ETL_TIMESTAMP              --ETL处理时间戳                             

    )
  SELECT 
        SEQ_ID                     --序列号                                    
        ,SYSORDID                   --交易单号                                  
        ,REF_SYSORDID               --子交易单号                                
        ,I_CODE                     --存单代码                                  
        ,A_TYPE                     --存单资产类型                              
        ,M_TYPE                     --存单市场类型                              
        ,ISSUE_TYPE                 --发行方式(1-报价发行,2-招标发行,3-浮息发行)
        ,PARTYID                    --认购人ID                                  
        ,PARTYNAME                  --认购人名称                                
        ,BID_PRICE                  --投标价位(元)                              
        ,BID_AMOUNT                 --投标量(亿元)                              
        ,BIDDING_PRICE              --中标价位(元)                              
        ,BIDDING_AMOUNT             --中标量(亿元)                              
        ,BID_TIME                   --认购时间                                  
        ,USERNAME                   --提交用户                                  
        ,BIDDING_ACTUAL_AMOUNT      --实际认购量                                
        ,MEMO                       --备注                                      
        ,SALES_ORGANIZATION         --销售机构                                  
        ,COST_CALCULATE_RULE        --费用计算规则                              
        ,BIDDING_PAY_AMOUNT         --缴款金额(元)                              
        ,BANK_CODE                  --开户行行号                                
        ,TRDACCCODE                 --交易账号                                  
        ,SALES_NAME                 --销售机构名称                              
        ,SALES_ORG_NAME             --                                          
        ,SALES_RATIO                --                                          
        ,SALES_ORG_RATIO            --                                          
        ,SALES_NAME_RATE            --                                          
        ,SALES_ORG_NAME_RATE        --                                          
        ,START_DT                   --开始时间                                  
        ,END_DT                     --结束时间                                  
        ,ID_MARK                    --增删标志                                  
        ,ETL_TIMESTAMP              --ETL处理时间戳                         
    FROM IOL.V_IBMS_VTRD_NCD_RESULT_DETAILS  --视图-同业存单发行结果明细表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
     ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_O_IOL_IBMS_VTRD_NCD_RESULT_DETAILS;
/

