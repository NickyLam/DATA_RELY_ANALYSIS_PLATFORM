CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_FINA_REPORT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
*  程序名称：ETL_O_IOL_ICMS_FINA_REPORT
*  功能描述：财报簿
*  创建日期：20220611
*  开发人员：梅炜
*  来源表：
*  目标表：  O_O_IOL_ICMS_FINA_REPORT
*  配置表：  CODE_MAP
*  修改情况：序号  修改日期  修改人   修改原因
*             1    20220611  梅炜      首次创建
*             2    20241230  YJY       优化脚本
**************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;          --处理步骤
  V_P_DATE    VARCHAR2(8);           --跑批数据日期
  V_STARTTIME DATE;                  --处理开始时间
  V_ENDTIME   DATE;                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);         --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);         --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_FINA_REPORT'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_FINA_REPORT';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-财报簿';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_FINA_REPORT
    (REPORTNO          --财报号
    ,REPORTTYPENO     --财报类型编号
    ,CUSTOMERID       --客户编号
    ,ACCOUNTINGMONTH  --会计月
    ,REPORTSCOPE      --报表口径
    ,REPORTPERIOD     --报表周期
    ,CURRENCY         --币种
    ,MONETARYUNIT     --货币单位在CODE_LIBRARY拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
    ,REPORTSTATUS     --状态
    ,AUDITFLAG        --审计标志
    ,AUDITINGAGENCY   --审计机构
    ,AUDITOPINION     --审计意见
    ,DELETEFLAG       --删除标志
    ,WARNINGRESULT    --预警结果
    ,REMARK           --注释
    ,INPUTUSERID      --登记人
    ,INPUTORGID       --登记机构
    ,INPUTDATE        --登记日期登记日期时间
    ,UPDATEUSERID     --更新人
    ,UPDATEORGID      --更新机构
    ,UPDATEDATE       --更新日期
    ,AUDITDATE        --审计时间
    ,CORPORGID        --法人机构编号
    ,REPORTFLAG       --报表检查标志
    ,REPORTOPINION    --报表注释
    ,ACCORDINGFLAG    --依据标志
    ,ISLOCK           --是否内评系统锁定：0-锁定 1-正常
    ,HXTYZLSOURCE     --资料来源
    ,START_DT         --开始时间
    ,END_DT           --结束时间
    ,ID_MARK          --增删标志
    )
  SELECT REPORTNO         --财报号
        ,REPORTTYPENO     --财报类型编号
        ,CUSTOMERID       --客户编号
        ,ACCOUNTINGMONTH  --会计月
        ,REPORTSCOPE      --报表口径
        ,REPORTPERIOD     --报表周期
        ,CURRENCY         --币种
        ,MONETARYUNIT     --货币单位在CODE_LIBRARY拥有码值,即(千元,万元等)同时外部取值时将基数与本值相乘,再返回.
        ,REPORTSTATUS     --状态
        ,AUDITFLAG        --审计标志
        ,AUDITINGAGENCY   --审计机构
        ,AUDITOPINION     --审计意见
        ,DELETEFLAG       --删除标志
        ,WARNINGRESULT    --预警结果
        ,REMARK           --注释
        ,INPUTUSERID      --登记人
        ,INPUTORGID       --登记机构
        ,INPUTDATE        --登记日期登记日期时间
        ,UPDATEUSERID     --更新人
        ,UPDATEORGID      --更新机构
        ,UPDATEDATE       --更新日期
        ,AUDITDATE        --审计时间
        ,CORPORGID        --法人机构编号
        ,REPORTFLAG       --报表检查标志
        ,REPORTOPINION    --报表注释
        ,ACCORDINGFLAG    --依据标志
        ,ISLOCK           --是否内评系统锁定：0-锁定 1-正常
        ,HXTYZLSOURCE     --资料来源
        ,START_DT         --开始时间
        ,END_DT           --结束时间
        ,ID_MARK          --增删标志
    FROM IOL.V_ICMS_FINA_REPORT --视图-财报簿
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;

  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_FINA_REPORT', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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

END ETL_O_IOL_ICMS_FINA_REPORT;
/

