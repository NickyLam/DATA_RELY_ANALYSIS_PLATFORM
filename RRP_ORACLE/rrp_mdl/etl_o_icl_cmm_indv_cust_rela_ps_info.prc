CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_INDV_CUST_RELA_PS_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_INDV_CUST_RELA_PS_INFO
  *  功能描述：个人客户关联人信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_INDV_CUST_RELA_PS_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250414  YJY      新增关联人创建时间、关联人录入系统时间
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  --V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_INDV_CUST_RELA_PS_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_INDV_CUST_RELA_PS_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-个人客户关联人信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_INDV_CUST_RELA_PS_INFO
    (ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,CUST_ID                     --客户编号
    ,RELA_PS_CUST_ID             --关联人客户编号
    ,RELA_TYPE_CD                --关联类型代码
    ,RELA_PS_NAME                --关联人姓名
    ,RELA_PS_CERT_TYPE_CD        --关联人证件类型代码
    ,RELA_PS_CERT_NO             --关联人证件号码
    ,RELA_PS_GENDER_CD           --关联人性别代码
    ,RELA_PS_BIRTH_DT            --关联人出生日期
    ,RELA_PS_NATI_PLACE          --关联人籍贯
    ,RELA_PS_NATIONTY_CD         --关联人民族代码
    ,RELA_PS_NATION_CD           --关联人国籍代码
    ,RELA_PS_DIST_CD             --关联人行政区划代码
    ,RELA_PS_MARRIAGE_SITU_CD    --关联人婚姻状况代码
    ,RELA_PS_RESD_STATUS_CD      --关联人居住状态代码
    ,RELA_PS_POLITIC_STATUS_CD   --关联人政治面貌代码
    ,RELA_PS_WORK_UNIT_CUST_ID   --关联人工作单位客户编号
    ,RELA_PS_WORK_UNIT_NAME      --关联人工作单位名称
    ,RELA_PS_TEL_NUM             --关联人电话号码
    ,RELA_PS_TEL_EXT_NUM         --关联人电话分机号码
    ,RELA_PS_MOBILE_NO           --关联人手机号码
    ,RELA_PS_WORK_UNIT_ADDR      --关联人工作单位地址
    ,RELA_PS_WORK_UNIT_TEL       --关联人工作单位电话
    ,RELA_PS_ID                  --关联人编号
    ,JOB_CD                      --任务代码
    ,RELA_PS_CREATE_TM           --关联人创建时间  ADD BY YJY 20250414
    ,RELA_PS_INPUT_SYS_TM        --关联人录入系统时间 ADD BY YJY 20250414
    )
  SELECT 
     ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,CUST_ID                     --客户编号
    ,RELA_PS_CUST_ID             --关联人客户编号
    ,RELA_TYPE_CD                --关联类型代码
    ,RELA_PS_NAME                --关联人姓名
    ,RELA_PS_CERT_TYPE_CD        --关联人证件类型代码
    ,RELA_PS_CERT_NO             --关联人证件号码
    ,RELA_PS_GENDER_CD           --关联人性别代码
    ,RELA_PS_BIRTH_DT            --关联人出生日期
    ,RELA_PS_NATI_PLACE          --关联人籍贯
    ,RELA_PS_NATIONTY_CD         --关联人民族代码
    ,RELA_PS_NATION_CD           --关联人国籍代码
    ,RELA_PS_DIST_CD             --关联人行政区划代码
    ,RELA_PS_MARRIAGE_SITU_CD    --关联人婚姻状况代码
    ,RELA_PS_RESD_STATUS_CD      --关联人居住状态代码
    ,RELA_PS_POLITIC_STATUS_CD   --关联人政治面貌代码
    ,RELA_PS_WORK_UNIT_CUST_ID   --关联人工作单位客户编号
    ,RELA_PS_WORK_UNIT_NAME      --关联人工作单位名称
    ,RELA_PS_TEL_NUM             --关联人电话号码
    ,RELA_PS_TEL_EXT_NUM         --关联人电话分机号码
    ,RELA_PS_MOBILE_NO           --关联人手机号码
    ,RELA_PS_WORK_UNIT_ADDR      --关联人工作单位地址
    ,RELA_PS_WORK_UNIT_TEL       --关联人工作单位电话
    ,RELA_PS_ID                  --关联人编号
    ,JOB_CD                      --任务代码
    ,RELA_PS_CREATE_TM           --关联人创建时间  ADD BY YJY 20250414
    ,RELA_PS_INPUT_SYS_TM        --关联人录入系统时间 ADD BY YJY 20250414
    FROM ICL.V_CMM_INDV_CUST_RELA_PS_INFO  --视图-代理代销产品信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_ICL_CMM_INDV_CUST_RELA_PS_INFO;
/

