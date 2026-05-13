CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_GHB_EXT_CRDT_OCUP_H(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_GHB_EXT_CRDT_OCUP_H
  *  功能描述：华兴外部授信占用历史
  *  创建日期：20240718
  *  开发人员：YJY
  *  来源表： IML.AGT_GHB_EXT_CRDT_OCUP_H
  *  目标表： O_IML_AGT_GHB_EXT_CRDT_OCUP_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240718  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_GHB_EXT_CRDT_OCUP_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_GHB_EXT_CRDT_OCUP_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-华兴外部授信占用历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_GHB_EXT_CRDT_OCUP_H
    (AGT_ID                  --协议编号        
    ,LP_ID                   --法人编号        
    ,SER_NUM                 --序列号          
    ,APV_FORM_NUM            --审批单号        
    ,TRAN_ODD_NO             --交易单号        
    ,FIN_INSTM_ID            --金融工具编号    
    ,ASSET_TYPE_ID           --资产类型编号    
    ,MARKET_TYPE_ID          --市场类型编号    
    ,INTNAL_VCH_ACCT_ID      --内部券账户编号  
    ,ACCT_ACCTNT_CLS_CD      --账户会计分类代码
    ,ACCT_B_CATE_CD          --账簿类别代码    
    ,CRDT_SIDE_CUST_ID       --授信方客户编号  
    ,CRDT_SIDE_NAME          --授信方名称      
    ,LMT_CONT_ID             --额度合同编号    
    ,OCCU_LMT                --已占用额度      
    ,OCUP_SURP_LMT           --占用剩余额度    
    ,START_DT                --开始时间        
    ,END_DT                  --结束时间        
    ,ID_MARK                 --增删标志        
    ,SRC_TABLE_NAME          --源表名称        
    ,JOB_CD                  --任务编码        
    ,ETL_TIMESTAMP           --ETL处理时间戳                                
    )
  SELECT AGT_ID                  --协议编号        
        ,LP_ID                   --法人编号        
        ,SER_NUM                 --序列号          
        ,APV_FORM_NUM            --审批单号        
        ,TRAN_ODD_NO             --交易单号        
        ,FIN_INSTM_ID            --金融工具编号    
        ,ASSET_TYPE_ID           --资产类型编号    
        ,MARKET_TYPE_ID          --市场类型编号    
        ,INTNAL_VCH_ACCT_ID      --内部券账户编号  
        ,ACCT_ACCTNT_CLS_CD      --账户会计分类代码
        ,ACCT_B_CATE_CD          --账簿类别代码    
        ,CRDT_SIDE_CUST_ID       --授信方客户编号  
        ,CRDT_SIDE_NAME          --授信方名称      
        ,LMT_CONT_ID             --额度合同编号    
        ,OCCU_LMT                --已占用额度      
        ,OCUP_SURP_LMT           --占用剩余额度    
        ,START_DT                --开始时间        
        ,END_DT                  --结束时间        
        ,ID_MARK                 --增删标志        
        ,SRC_TABLE_NAME          --源表名称        
        ,JOB_CD                  --任务编码        
        ,ETL_TIMESTAMP           --ETL处理时间戳    
    FROM IML.V_AGT_GHB_EXT_CRDT_OCUP_H    --视图-华兴外部授信占用历史
   WHERE ID_MARK <> 'D'; 

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_GHB_EXT_CRDT_OCUP_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_GHB_EXT_CRDT_OCUP_H;
/

