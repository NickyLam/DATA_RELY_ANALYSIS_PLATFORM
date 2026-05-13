CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_RDW_RML_R03_WL_LOAN_PROMIS(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_RDW_RML_R03_WL_LOAN_PROMIS
  *  功能描述：风险集市_R03_网贷贷款承诺
  *  创建日期：20240423
  *  开发人员：YJY
  *  来源表： RDW.V_RML_R03_WL_LOAN_PROMIS
  *  目标表： O_RDW_RML_R03_WL_LOAN_PROMIS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240423  YJY      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_RDW_RML_R03_WL_LOAN_PROMIS'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_RDW_RML_R03_WL_LOAN_PROMIS T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_FDW_FDL_IDX_INDEX_DATA_NEW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '风险集市_R03_网贷贷款承诺';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_RDW_RML_R03_WL_LOAN_PROMIS
    (
     LMT_CONT_NO       --合同编号    
    ,CUST_NO           --客户编号    
    ,MGMT_ORG_NO       --机构编号    
    ,STD_PROD_NO       --产品编号    
    ,CURR_CD           --币种代码    
    ,CRDT_LMT          --总额度      
    ,USED_AMT          --已用额度    
    ,AVAILABLE_AMT     --可用金额    
    ,BEGIN_DT          --生效日期    
    ,EXP_DT            --结束日期    
    ,CIRCL_FLG         --循环标志    
    ,GUAR_FLG          --有担保标志  
    ,LOAN_PROMIS_CLS   --贷款承诺分类
    ,GROUP_NO          --组号        
    ,ETL_DT            --数据日期    
    ,CURR_BAL          --当期余额    

    )
  SELECT                 
    LMT_CONT_NO       --合同编号    
    ,CUST_NO           --客户编号    
    ,MGMT_ORG_NO       --机构编号    
    ,STD_PROD_NO       --产品编号    
    ,CURR_CD           --币种代码    
    ,CRDT_LMT          --总额度      
    ,USED_AMT          --已用额度    
    ,AVAILABLE_AMT     --可用金额    
    ,BEGIN_DT          --生效日期    
    ,EXP_DT            --结束日期    
    ,CIRCL_FLG         --循环标志    
    ,GUAR_FLG          --有担保标志  
    ,LOAN_PROMIS_CLS   --贷款承诺分类
    ,GROUP_NO          --组号        
    ,ETL_DT            --数据日期    
    ,CURR_BAL          --当期余额      
    FROM RDW.V_RML_R03_WL_LOAN_PROMIS  --视图-风险集市R03_网贷贷款承诺
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --分析表
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, 'O_RDW_RML_R03_WL_LOAN_PROMIS', '', O_ERRCODE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_RDW_RML_R03_WL_LOAN_PROMIS;
/

