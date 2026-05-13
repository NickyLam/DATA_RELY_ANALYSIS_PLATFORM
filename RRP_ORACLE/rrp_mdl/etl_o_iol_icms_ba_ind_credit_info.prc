CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BA_IND_CREDIT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                              O_ERRCODE OUT VARCHAR2 --错误代码
                                                              )
 /*******************************************************************
  **存储过程详细说明：个人客户征信信息
  **存储过程名称：    ETL_O_IOL_ICMS_BA_IND_CREDIT_INFO
  **存储过程创建日期：20250303
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250303    YJY        创建
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_BA_IND_CREDIT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BA_IND_CREDIT_INFO';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-个人客户征信信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BA_IND_CREDIT_INFO NOLOGGING 
    (SERIALNO            --流水号
    ,BASERIALNO          --申请流水号
    ,REPORTDATE          --报告日期
    ,REPORTID            --报告ID
    ,CERTTYPE            --证件类型
    ,CERTID              --证件号码
    ,CUSTOMERNAME        --客户姓名
    ,CUSTOMERID          --客户号
    ,CUSTOMERTYPE        --客户类型
    ,RELATIVETYPE        --关联人类型
    ,INPUTUSERID         --登记人
    ,INPUTORGID          --登记机构
    ,INPUTDATE           --登记日期
    ,UPDATEUSERID        --更新人
    ,UPDATEORGID         --更新机构
    ,UPDATEDATE          --更新日期
    ,REPORTREMARK        --征信报告备注
    ,QRYOPERTP           --查询操作申请类型
    ,AUTHOTYPE           --授权方式
    ,BIOMETRICS          --生物识别技术
    ,STATUS              --请求结果状态
    ,PBCDATA             --征信查询结果
    ,MIGTFLAG            --迁移标志：crs rcr ilc upl
    ,AUTHODATE           --授权时间
    ,AUTHOSTRDATE        --授权起始时间
    ,AUTHOENDDATE        --授权结束时间
    ,SUPPLYFLAG          --补录标识YesNo 1-是 ，0-否
    ,SUPPLYCOMPLETE      --影像资料是否补充完全YesNo,1-是，0-否
    ,ISCREDITFLAG        --是否查询征信报告
    ,CRASERIALNO         --征信申请流程关联流水号
    ,XXDYXSERIALNO       --新兴贷用信申请关联流水号
    ,CREDITVALIDATETIME  --征信有效期
    ,ETL_DT              --ETL处理日期
    ,ETL_TIMESTAMP       --ETL处理时间戳
    ,AUTHOBKID           --客户数据授权书编号
    )
  SELECT SERIALNO            --流水号
        ,BASERIALNO          --申请流水号
        ,REPORTDATE          --报告日期
        ,REPORTID            --报告ID
        ,CERTTYPE            --证件类型
        ,CERTID              --证件号码
        ,CUSTOMERNAME        --客户姓名
        ,CUSTOMERID          --客户号
        ,CUSTOMERTYPE        --客户类型
        ,RELATIVETYPE        --关联人类型
        ,INPUTUSERID         --登记人
        ,INPUTORGID          --登记机构
        ,INPUTDATE           --登记日期
        ,UPDATEUSERID        --更新人
        ,UPDATEORGID         --更新机构
        ,UPDATEDATE          --更新日期
        ,REPORTREMARK        --征信报告备注
        ,QRYOPERTP           --查询操作申请类型
        ,AUTHOTYPE           --授权方式
        ,BIOMETRICS          --生物识别技术
        ,STATUS              --请求结果状态
        ,PBCDATA             --征信查询结果
        ,MIGTFLAG            --迁移标志：crs rcr ilc upl
        ,AUTHODATE           --授权时间
        ,AUTHOSTRDATE        --授权起始时间
        ,AUTHOENDDATE        --授权结束时间
        ,SUPPLYFLAG          --补录标识YesNo 1-是 ，0-否
        ,SUPPLYCOMPLETE      --影像资料是否补充完全YesNo,1-是，0-否
        ,ISCREDITFLAG        --是否查询征信报告
        ,CRASERIALNO         --征信申请流程关联流水号
        ,XXDYXSERIALNO       --新兴贷用信申请关联流水号
        ,CREDITVALIDATETIME  --征信有效期
        ,ETL_DT              --ETL处理日期
        ,ETL_TIMESTAMP       --ETL处理时间戳
        ,AUTHOBKID           --客户数据授权书编号
    FROM IOL.V_ICMS_BA_IND_CREDIT_INFO --视图-个人客户征信信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_BA_IND_CREDIT_INFO', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_BA_IND_CREDIT_INFO;
/

