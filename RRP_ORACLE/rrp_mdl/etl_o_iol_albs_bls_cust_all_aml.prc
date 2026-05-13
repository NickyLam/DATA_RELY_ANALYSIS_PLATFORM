CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ALBS_BLS_CUST_ALL_AML(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ALBS_BLS_CUST_ALL_AML
  *  功能描述：黑名单系统供数给反洗钱系统黑名单表
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IOL.V_ALBS_BLS_CUST_ALL_AML
  *  目标表： O_IOL_ALBS_BLS_CUST_ALL_AML
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
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
  --V_TAB_NAME  VARCHAR2(200) := 'O_IOL_ALBS_BLS_CUST_ALL_AML'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ALBS_BLS_CUST_ALL_AML'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IOL_ALBS_BLS_CUST_ALL_AML T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ALBS_BLS_CUST_ALL_AML';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-黑名单系统供数给反洗钱系统黑名单表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ALBS_BLS_CUST_ALL_AML
    (STATE                 --国家名称
    ,ORG_CODE              --所属机构号
    ,RECORD_ID             --黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面）  -也就是预警ID
    ,ORG_NAME              --所属机构名称
    ,BLACK_SOURCE_TYPE     --黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
    ,CUSTOMER_NAME         --客户名称
    ,DETECTION_NAME        --侦测等级名称
    ,OP_USER_ID            --操作用户ID
    ,CUSTOMER_NO           --客户号
    ,IDENTITY_NO           --证件号码
    ,ETL_DT                --ETL处理日期
    ,BLOCK_REASON          --备注 也就是拦截原因
    ,INPUT_TYPE            --决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
    ,CUSTOMER_TYPE         --客户类型 00-对公 01-对私
    ,IDENTITY_TYPE         --证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
    ,CRT_DATE              --检索日期：YYYYMMDD
    ,CUSTOMER_ADDRESS      --客户地址
    ,ID                    --主键ID
    )
  SELECT 
           STATE                 --国家名称
          ,ORG_CODE              --所属机构号
          ,RECORD_ID             --黑名单ID（可通过该ID链接到黑名单系统查看记录的明细页面）  -也就是预警ID
          ,ORG_NAME              --所属机构名称
          ,BLACK_SOURCE_TYPE     --黑名单类别:0-回溯检索客户黑名单,1-全球制裁名单,2-中国制裁名单
          ,CUSTOMER_NAME         --客户名称
          ,DETECTION_NAME        --侦测等级名称
          ,OP_USER_ID            --操作用户ID
          ,CUSTOMER_NO           --客户号
          ,IDENTITY_NO           --证件号码
          ,ETL_DT                --ETL处理日期
          ,BLOCK_REASON          --备注 也就是拦截原因
          ,INPUT_TYPE            --决议类型 01-通用格式 09-道琼斯 20-OFAC 77-银行家年鉴
          ,CUSTOMER_TYPE         --客户类型 00-对公 01-对私
          ,IDENTITY_TYPE         --证件类型 A-身份证 B-外国公民护照 C-户口簿（身份证号）...
          ,CRT_DATE              --检索日期：YYYYMMDD
          ,CUSTOMER_ADDRESS      --客户地址
          ,ID                    --主键ID
    FROM IOL.V_ALBS_BLS_CUST_ALL_AML  --视图-黑名单系统供数给反洗钱系统黑名单表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ALBS_BLS_CUST_ALL_AML;
/

