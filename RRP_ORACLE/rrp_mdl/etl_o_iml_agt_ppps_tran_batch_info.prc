CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_PPPS_TRAN_BATCH_INFO(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_PPPS_TRAN_BATCH_INFO
  *  功能描述：PPPS交易批次信息
  *  创建日期：20240401
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_PPPS_TRAN_BATCH_INFO
  *  目标表： O_IML_AGT_PPPS_TRAN_BATCH_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240401  YJY     首次创建
  **************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_AGT_PPPS_TRAN_BATCH_INFO';
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_PPPS_TRAN_BATCH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_PPPS_TRAN_BATCH_INFO T WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_PPPS_TRAN_BATCH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-PPPS交易批次信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_PPPS_TRAN_BATCH_INFO
    (AGT_ID                     --协议编号        
    ,LP_ID                      --法人编号        
    ,CHN_ID                     --渠道编号        
    ,CHN_TRAN_FLOW_NUM          --渠道交易流水号  
    ,CHN_TRAN_DT                --渠道交易日期    
    ,MERCHT_ID                  --商户编号        
    ,CHN_SYS_CD                 --渠道系统代码    
    ,OVA_FLOW_NUM               --全局流水号      
    ,TRAN_BATCH_NO              --交易批次号      
    ,TRAN_DT                    --交易日期        
    ,TRAN_BATCH_STATUS_CD       --交易批次状态代码
    ,SYS_ID                     --系统编号        
    ,TRAN_CATE_CD               --交易类别代码    
    ,TRAN_TYPE_CD               --转接类型代码    
    ,CURR_CD                    --币种代码        
    ,TOT_TRAN_AMT               --总交易金额      
    ,TOT_TRAN_CNT               --总交易笔数      
    ,FAIL_AMT                   --失败金额        
    ,FAIL_CNT                   --失败笔数        
    ,SUCS_AMT                   --成功金额        
    ,SUCS_CNT                   --成功笔数        
    ,PLAT_RETURN_CODE           --平台返回码      
    ,PLAT_RETURN_DESCB          --平台返回描述    
    ,SRC_AGT_ID                 --源协议编号      
    ,RECVBL_ACCT_ID             --收款账户编号    
    ,RECVBL_ACCT_NAME           --收款账户名称    
    ,FEE_ID                     --费用编号        
    ,FEE_DESCB                  --费用描述        
    ,INSIDE_ACCT_FLG            --内部户标志      
    ,INTNAL_ACCT_ID             --内部账户编号    
    ,INTNAL_ACCT_NAME           --内部账户名称    
    ,CORP_ACCT_ID               --对公账户编号    
    ,CORP_ACCT_NAME             --对公账户名称    
    ,SIGN_FLG                   --签约标志        
    ,TRAN_TELLER_ID             --交易柜员编号    
    ,AUTH_TELLER_ID             --授权柜员编号    
    ,CHECK_TELLER_ID            --复核柜员编号    
    ,TRAN_ORG_ID                --交易机构编号    
    ,FINAL_UPDATE_DT            --最后更新日期    
    ,REMARK                     --备注            
    ,START_DT                   --开始日期        
    ,END_DT                     --结束日期        
    ,ID_MARK                    --删除标识        
    ,SRC_TABLE_NAME             --源表名称        
    ,JOB_CD                     --任务代码        
    ,ETL_TIMESTAMP              --数据处理时间    
    )
  SELECT AGT_ID                     --协议编号        
        ,LP_ID                      --法人编号        
        ,CHN_ID                     --渠道编号        
        ,CHN_TRAN_FLOW_NUM          --渠道交易流水号  
        ,CHN_TRAN_DT                --渠道交易日期    
        ,MERCHT_ID                  --商户编号        
        ,CHN_SYS_CD                 --渠道系统代码    
        ,OVA_FLOW_NUM               --全局流水号      
        ,TRAN_BATCH_NO              --交易批次号      
        ,TRAN_DT                    --交易日期        
        ,TRAN_BATCH_STATUS_CD       --交易批次状态代码
        ,SYS_ID                     --系统编号        
        ,TRAN_CATE_CD               --交易类别代码    
        ,TRAN_TYPE_CD               --转接类型代码    
        ,CURR_CD                    --币种代码        
        ,TOT_TRAN_AMT               --总交易金额      
        ,TOT_TRAN_CNT               --总交易笔数      
        ,FAIL_AMT                   --失败金额        
        ,FAIL_CNT                   --失败笔数        
        ,SUCS_AMT                   --成功金额        
        ,SUCS_CNT                   --成功笔数        
        ,PLAT_RETURN_CODE           --平台返回码      
        ,PLAT_RETURN_DESCB          --平台返回描述    
        ,SRC_AGT_ID                 --源协议编号      
        ,RECVBL_ACCT_ID             --收款账户编号    
        ,RECVBL_ACCT_NAME           --收款账户名称    
        ,FEE_ID                     --费用编号        
        ,FEE_DESCB                  --费用描述        
        ,INSIDE_ACCT_FLG            --内部户标志      
        ,INTNAL_ACCT_ID             --内部账户编号    
        ,INTNAL_ACCT_NAME           --内部账户名称    
        ,CORP_ACCT_ID               --对公账户编号    
        ,CORP_ACCT_NAME             --对公账户名称    
        ,SIGN_FLG                   --签约标志        
        ,TRAN_TELLER_ID             --交易柜员编号    
        ,AUTH_TELLER_ID             --授权柜员编号    
        ,CHECK_TELLER_ID            --复核柜员编号    
        ,TRAN_ORG_ID                --交易机构编号    
        ,FINAL_UPDATE_DT            --最后更新日期    
        ,REMARK                     --备注            
        ,START_DT                   --开始日期        
        ,END_DT                     --结束日期        
        ,ID_MARK                    --删除标识        
        ,SRC_TABLE_NAME             --源表名称        
        ,JOB_CD                     --任务代码        
        ,ETL_TIMESTAMP              --数据处理时间    
    FROM IML.V_AGT_PPPS_TRAN_BATCH_INFO  --视图-PPPS交易批次信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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

END ETL_O_IML_AGT_PPPS_TRAN_BATCH_INFO;
/

