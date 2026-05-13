CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CLASSIFY_ADJUST(I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_CLASSIFY_ADJUST
  *  功能描述：风险分类调整
  *  创建日期：20241025
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_CLASSIFY_ADJUST
  *  目标表： O_IOL_ICMS_CLASSIFY_ADJUST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20241025   YJY     首次创建
  ************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_CLASSIFY_ADJUST'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-风险分类调整';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_CLASSIFY_ADJUST
    (
      SERIALNO              --流水号                                     
     ,OBJECTTYPE            --对象类型对象类型(合同/借据)                
     ,PRODUCTID             --业务品种                                   
     ,ADJUSTDATE            --调整申请日期                               
     ,ADJUSTAPPLYER         --调整申请人                                 
     ,CUSTOMERNAME          --客户名称                                   
     ,ADJUSTORGID           --调整申请机构                               
     ,APPROVESTATUS         --审批状态                                   
     ,OPERATEDATE           --经办日期                                   
     ,INPUTDATE             --登记日期                                   
     ,ADJUSTTYPE            --调整类型调整类型(分类结果调整/分类方式调整)
     ,BELONGDEPT            --所属条线                                   
     ,INPUTUSERID           --登记人                                     
     ,UPDATEDATE            --更新日期                                   
     ,CORPORGID             --法人机构编号                               
     ,OBJECTNO              --对象编号借据编号（借据编号/合同编号）      
     ,OPERATEORGID          --经办机构                                   
     ,CUSTOMERID            --客户编号                                   
     ,ADJUSTREASON          --分类调整原因                               
     ,UPDATEORGID           --更新机构                                   
     ,MIGTFLAG              --迁移标志：crsrcrilcupl                     
     ,ADJUSTCLASSIFYRESULT  --调整分类结果                               
     ,CURRCLASSIFYTYPE      --当前分类方式                               
     ,UPDATEUSERID          --更新人                                     
     ,ADJUSTFINISHDATE      --认定完成时间                               
     ,ACCOUNTMONTH          --期次                                       
     ,INPUTORGID            --登记机构                                   
     ,RELATIVESERIALNO      --原分类编号                                 
     ,OPERATEUSERID         --经办人                                     
     ,CURRCLASSIFYRESULT    --当前分类结果                               
     ,START_DT              --开始时间                                   
     ,END_DT                --结束时间                                   
     ,ID_MARK               --增删标志                                   
     ,ETL_TIMESTAMP         --ETL处理时间戳                              
    )
  SELECT 
      SERIALNO              --流水号                                     
     ,OBJECTTYPE            --对象类型对象类型(合同/借据)                
     ,PRODUCTID             --业务品种                                   
     ,ADJUSTDATE            --调整申请日期                               
     ,ADJUSTAPPLYER         --调整申请人                                 
     ,CUSTOMERNAME          --客户名称                                   
     ,ADJUSTORGID           --调整申请机构                               
     ,APPROVESTATUS         --审批状态                                   
     ,OPERATEDATE           --经办日期                                   
     ,INPUTDATE             --登记日期                                   
     ,ADJUSTTYPE            --调整类型调整类型(分类结果调整/分类方式调整)
     ,BELONGDEPT            --所属条线                                   
     ,INPUTUSERID           --登记人                                     
     ,UPDATEDATE            --更新日期                                   
     ,CORPORGID             --法人机构编号                               
     ,OBJECTNO              --对象编号借据编号（借据编号/合同编号）      
     ,OPERATEORGID          --经办机构                                   
     ,CUSTOMERID            --客户编号                                   
     ,ADJUSTREASON          --分类调整原因                               
     ,UPDATEORGID           --更新机构                                   
     ,MIGTFLAG              --迁移标志：crsrcrilcupl                     
     ,ADJUSTCLASSIFYRESULT  --调整分类结果                               
     ,CURRCLASSIFYTYPE      --当前分类方式                               
     ,UPDATEUSERID          --更新人                                     
     ,ADJUSTFINISHDATE      --认定完成时间                               
     ,ACCOUNTMONTH          --期次                                       
     ,INPUTORGID            --登记机构                                   
     ,RELATIVESERIALNO      --原分类编号                                 
     ,OPERATEUSERID         --经办人                                     
     ,CURRCLASSIFYRESULT    --当前分类结果                               
     ,START_DT              --开始时间                                   
     ,END_DT                --结束时间                                   
     ,ID_MARK               --增删标志                                   
     ,ETL_TIMESTAMP         --ETL处理时间戳                              
    FROM IOL.V_ICMS_CLASSIFY_ADJUST --视图-风险分类调整
    WHERE ID_MARK <> 'D'
    ; 

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_CLASSIFY_ADJUST', '', O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := 3;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '-- 程序跑批结束 --';
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_CLASSIFY_ADJUST;
/

