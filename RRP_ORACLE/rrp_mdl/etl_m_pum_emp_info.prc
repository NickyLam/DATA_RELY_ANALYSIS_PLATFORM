CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_PUM_EMP_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_PUM_EMP_INFO
  *  功能描述：监管集市银行机构所有的员工信息
  *  创建日期：20220519
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            IML.REF_POSTN_PARA  --职位参数
  *            ICL.CMM_CLERK_INFO  --行员信息表
  *  目标表：  M_PUM_EMP_INFO  --员工表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  HULJ     调整员工状态，新增员工类型。
  *             2    20221108  HULJ     增加数据重复校验  。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20240606  YJY      新增离职状态代码、离职日期
  *             5    20250321  LINAL    一表通，增加单位电话分机号的取值逻辑。
  *             6    20250811  YJY      一表通，新增出生日期、性别代码字段
  *             7    20250819  LAL      一表通，增加办公电话、手机号码的取值逻辑。
  *             8    20251016  LIP      增加EAST岗位编号字段
  *             9    20251125  LAL      一表通，增加岗位类别、岗位描述及其取数逻辑
  *             10   20260129  LAL      修改高管信息取值逻辑
  *             11   20260209  LAL      补充员工上岗日期的取值
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                          --处理步骤
  V_STEP_DESC VARCHAR2(100);                         --处理步骤描述
  V_P_DATE    VARCHAR2(8);                           --跑批数据日期
  V_STARTTIME DATE;                                  --处理开始时间
  V_ENDTIME   DATE;                                  --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                          --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                         --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                         --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_PUM_EMP_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_PUM_EMP_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';            --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '员工表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_EMP_INFO
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,EMP_ID                --员工编号
    ,ORG_ID                --机构编号
    ,EMP_NM                --员工姓名
    ,CRDL_TYP              --证件类型
    ,CRDL_NO               --证件号码
    ,TEL                   --联系电话
    ,BLNG_DEPT             --所属部门
    ,EMP_STAT              --员工状态
    ,POST_ID               --岗位编号
    ,CTRY_CD               --国家代码
    ,SENIOR_FLG            --高管标志
    ,APP_DT                --批复日期
    ,ASSIGN_DT             --任职日期
    ,EMP_TYP               --员工类型
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    ,EMP_TYPE              --员工类型
    ,DIMISSION_STATUS_CD   --离职状态代码   ADD IN 20240606
    ,DIMISSION_DT          --离职日期       ADD IN 20240606
    /*,WORK_TEL_EXT_NUM      --单位电话分机号 ADD BY LAL 20250321*/--更名为【WORK_TEL 办公电话】
    ,WORK_TEL              --办公电话       MOD BY LAL 20250819 一表通办公电话取“区号-单位电话”
    ,POST_NAME             --职务名称       ADD BY LAL 20250321
    ,BIRTH_DT              --出生日期       ADD BY YJY 20250811
    ,GENDER_CD             --性别代码       ADD BY YJY 20250811
    ,MOBILE_PHONE_NUM      --手机号码       ADD BY LAL 20250819 一表通增加电话号码取值
    ,POST_ID_EAST          --EAST岗位编号   ADD BY LIP 20251016 按照业务口径，EAST的岗位按职位报送
    ,POST_TYPE             --岗位类别       ADD BY LAL 20251125
    ,POST_DESCB            --岗位描述       ADD BY LAL 20251125
    ,POST_DT               --上岗日期       ADD BY LAL 20260209
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')   AS DATA_DT              --数据日期
        ,A.LP_ID                        AS LGL_REP_ID           --法人编号
        ,A.CLERK_ID                     AS EMP_ID               --员工编号
        ,A.BELONG_ORG_ID                AS ORG_ID               --机构编号
        ,A.CLERK_NAME                   AS EMP_NM               --员工姓名
        ,A.CERT_TYPE_CD                 AS CRDL_TYP             --证件类型 取消转码
        ,A.CERT_NO                      AS CRDL_NO              --证件号码
        ,CASE WHEN TRIM(A.MOBILE_PHONE_NUM) IS NOT NULL THEN A.MOBILE_PHONE_NUM
              WHEN TRIM(A.MOBILE_PHONE_NUM_1) IS NOT NULL THEN A.MOBILE_PHONE_NUM_1
              WHEN TRIM(A.MOBILE_PHONE_NUM_2) IS NOT NULL THEN A.MOBILE_PHONE_NUM_2
              WHEN TRIM(A.MOBILE_PHONE_NUM_3) IS NOT NULL THEN A.MOBILE_PHONE_NUM_3
              WHEN TRIM(A.WORK_TEL_AREA_CD) IS NOT NULL AND TRIM(A.WORK_TEL_NUM) IS NOT NULL
              THEN A.WORK_TEL_AREA_CD||'-'||A.WORK_TEL_NUM
              ELSE NULL
         END                            AS TEL                  --联系电话
        ,NVL(F.ORG_NAME,G.BLNG_DEPT)    AS BLNG_DEPT            --所属部门
        ,A.EMPLY_STATUS_CD              AS EMP_STAT             --员工状态 MODIFY BY HULJ CD1596
        ,COALESCE(TRIM(A.JOBS_CD),TRIM(A.POSTN_CD),G.POST_ID)           AS POST_ID --岗位编号 MODIFY BY LJY 20220819
        ,A.CTY_CD                       AS CTRY_CD              --国籍
      /*,CASE WHEN D.EMP_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS SENIOR_FLG --是否高管
        ,D.APP_DT                       AS APP_DT               --批复日期
        ,TO_CHAR(A.EMPYT_DT,'YYYYMMDD') AS ASSIGN_DT            --任职日期*/ -- MOD BY LAL 20260129 上游的高管信息已落地，改为取接口表字段
        ,CASE WHEN D.USER_ID IS NOT NULL THEN 'Y' ELSE 'N' END           AS SENIOR_FLG --是否高管
        ,TO_CHAR(TO_DATE(TRIM(D.APPROVAL_DATE),'YYYY-MM-DD'),'YYYYMMDD') AS APP_DT     --批复日期
        ,TO_CHAR(TO_DATE(TRIM(D.POSITION_DATE),'YYYY-MM-DD'),'YYYYMMDD') AS ASSIGN_DT  --任职日期
        --MOD BY LIP 20230608 根据冯年欢回复的邮件修改 1跟2是正式员工，其它都不是
        ,CASE WHEN A.EMPLY_TYPE_CD IN ('1','2') THEN '1'
              ELSE '3'
          END                           AS EMP_TYP              --员工类型
        ,'800915'                       AS DEPT_LINE            --部门条线\*人力资源部*\
        ,'员工信息'                     AS DATA_SRC             --数据来源
        ,A.EMPLY_TYPE_CD                AS EMP_TYPE             --员工类型 MODIFY BY HULJ 20221107 新增字段CD1595
        ,A.DIMISSION_STATUS_CD          AS DIMISSION_STATUS_CD  --离职状态代码    ADD IN 20240606
        ,A.DIMISSION_DT                 AS DIMISSION_DT         --离职日期        ADD IN 20240606
        /*,A.WORK_TEL_EXT_NUM             AS WORK_TEL_EXT_NUM     --单位电话分机号  ADD LINAL 20250321*/--更名为【WORK_TEL 办公电话】
        ,CASE WHEN TRIM(A.WORK_TEL_AREA_CD) IS NOT NULL AND TRIM(A.WORK_TEL_NUM) IS NOT NULL
                   THEN A.WORK_TEL_AREA_CD||'-'||A.WORK_TEL_NUM
              ELSE TRIM(A.WORK_TEL_NUM)
         END                            AS WORK_TEL             --办公电话        MOD BY LINAL 20250819 一表通办公电话取“区号-单位电话”
        ,A.POST_NAME                    AS POST_NAME            --职务名称        ADD LINAL 20250321
        ,A.BIRTH_DT                     AS BIRTH_DT             --出生日期        ADD BY YJY 20250811
        ,A.GENDER_CD                    AS GENDER_CD            --性别代码        ADD BY YJY 20250811
        ,CASE WHEN TRIM(A.MOBILE_PHONE_NUM) IS NOT NULL THEN A.MOBILE_PHONE_NUM
              WHEN TRIM(A.MOBILE_PHONE_NUM_1) IS NOT NULL THEN A.MOBILE_PHONE_NUM_1
              WHEN TRIM(A.MOBILE_PHONE_NUM_2) IS NOT NULL THEN A.MOBILE_PHONE_NUM_2
              WHEN TRIM(A.MOBILE_PHONE_NUM_3) IS NOT NULL THEN A.MOBILE_PHONE_NUM_3
              ELSE NULL
          END                           AS MOBILE_PHONE_NUM     --手机号码 ADD BY LAL 20250819 一表通增加电话号码取值
        /*,ROW_NUMBER() OVER(PARTITION BY A.CLERK_NAME,A.CERT_NO ORDER BY A.TELLER_ID DESC,A.EMPYT_DT DESC) AS NUM
        ,A.TELLER_FLG                   AS TELLER_FLG*/
        ,TRIM(A.POSTN_CD)               AS POST_ID_EAST         --EAST岗位编号 ADD BY LIP 20251016 按照业务口径，EAST的岗位按职位报送
        ,A.JOBS_DESCB                   AS POST_TYPE            --岗位类别     ADD BY LAL 20251125
        ,A.JOBS_DESCB2                  AS POST_DESCB           --岗位描述     ADD BY LAL 20251125
        ,TO_CHAR(A.EMPYT_DT,'YYYYMMDD') AS POST_DT              --上岗日期     ADD BY LAL 20260209
    FROM RRP_MDL.O_ICL_CMM_CLERK_INFO A --行员信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.ADD_BANK_SENIOR_LIST D --高管信息补录表
      ON D.EMP_ID = A.CLERK_ID*/  -- MOD BY LAL 20260129 上游将补录表落地了，换成下面的接口表
    LEFT JOIN RRP_MDL.O_IOL_NHRS_T_EXECUTIVE_POSITION_INFO D --高管任职信息表 
      ON D.USER_ID = A.CLERK_ID
     AND D.IS_EFFECTIVE = '1'
     AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ADD_M_PUB_EMP_INFO G --离职员工岗位、部门补录表
      ON G.EMP_ID = A.CLERK_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO F --内部机构信息
      ON F.ORG_ID = A.LOCAL_DEPT_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.CLERK_ID IS NOT NULL
     AND A.EMPYT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,EMP_ID,COUNT(1)
    FROM RRP_MDL.M_PUM_EMP_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,EMP_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_SQLMSG  := 'M_PUM_EMP_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
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

END ETL_M_PUM_EMP_INFO;
/

