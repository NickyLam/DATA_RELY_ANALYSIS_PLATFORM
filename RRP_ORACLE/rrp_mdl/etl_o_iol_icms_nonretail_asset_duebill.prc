CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL
  *  功能描述：非零售问题资产处理借据表
  *  创建日期：20250925
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_NONRETAIL_ASSET_DUEBILL
  *  目标表： O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250925  YJY      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL'; -- 程序名称
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
  --DELETE FROM RRP_MDL.O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '非零售问题资产处理借据表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL  
    (
         PROGRAMNO      --方案编号
        ,CUSTOMERID      --客户编号
        ,CUSTOMERNAME    --客户名称  
        ,DUEBILLNO      --借据编号
        ,PRODUCTID      --业务品种
        ,CLASSIFYRESULT    --五级分类
        ,BUSINESSSUM    --借据金额
        ,BALANCE      --借据余额
        ,OWEDAMOUNT      --欠本金额
        ,INTERESTAMOUNT    --欠息金额
        ,PENALTYAMOUNT    --罚息
        ,COMPOUNDAMOUNT    --复利
        ,PUTOUTDATE      --起始日
        ,MATURITY      --到期日
        ,OVERDUEDAYS    --逾期天数
        ,INPUTUSERID    --登记人
        ,INPUTORGID      --登记机构
        ,UPDATEUSERID    --更新人
        ,UPDATEORGID    --更新机构
        ,UPDATEDATE      --更新日期
        ,INPUTDATE      --登记日期
        ,START_DT      --开始时间
        ,END_DT          --结束时间
        ,ID_MARK      --增删标志
    )
  SELECT                 
         PROGRAMNO      --方案编号
        ,CUSTOMERID      --客户编号
        ,CUSTOMERNAME    --客户名称  
        ,DUEBILLNO      --借据编号
        ,PRODUCTID      --业务品种
        ,CLASSIFYRESULT    --五级分类
        ,BUSINESSSUM    --借据金额
        ,BALANCE      --借据余额
        ,OWEDAMOUNT      --欠本金额
        ,INTERESTAMOUNT    --欠息金额
        ,PENALTYAMOUNT    --罚息
        ,COMPOUNDAMOUNT    --复利
        ,PUTOUTDATE      --起始日
        ,MATURITY      --到期日
        ,OVERDUEDAYS    --逾期天数
        ,INPUTUSERID    --登记人
        ,INPUTORGID      --登记机构
        ,UPDATEUSERID    --更新人
        ,UPDATEORGID    --更新机构
        ,UPDATEDATE      --更新日期
        ,INPUTDATE      --登记日期
        ,START_DT      --开始时间
        ,END_DT          --结束时间
        ,ID_MARK      --增删标志
    FROM IOL.V_ICMS_NONRETAIL_ASSET_DUEBILL  --视图-非零售问题资产处理借据表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --分析表
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL', '', O_ERRCODE);
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

END ETL_O_IOL_ICMS_NONRETAIL_ASSET_DUEBILL;
/

