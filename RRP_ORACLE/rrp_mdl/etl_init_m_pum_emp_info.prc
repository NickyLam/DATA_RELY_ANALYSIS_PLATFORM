CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_PUM_EMP_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_PUM_EMP_INFO
  *  功能描述：监管集市银行机构所有的员工信息
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            IML.REF_POSTN_PARA  --职位参数
  *            ICL.CMM_CLERK_INFO  --行员信息表
  *  目标表：  M_PUM_EMP_INFO  --员工表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  hulj     调整员工状态，新增员工类型。
  *             2    20221108  hulj     增加数据重复校验  。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_PUM_EMP_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_PUM_EMP_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;



   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '员工表';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_INFO
  (
   DATA_DT     --数据日期
  ,LGL_REP_ID  --法人编号
  ,EMP_ID      --员工编号
  ,ORG_ID      --机构编号
  ,EMP_NM      --员工姓名
  ,CRDL_TYP    --证件类型
  ,CRDL_NO     --证件号码
  ,TEL         --联系电话
  ,BLNG_DEPT   --所属部门
  ,EMP_STAT    --员工状态
  ,POST_ID     --岗位编号
  ,CTRY_CD     --国家代码
  ,SENIOR_FLG  --高管标志
  ,APP_DT      --批复日期
  ,ASSIGN_DT   --任职日期
  ,EMP_TYP     --员工类型
  ,DEPT_LINE   --部门条线
  ,DATA_SRC    --数据来源
  ,EMP_TYPE    --员工类型
   )
   SELECT T.DATA_DT,     --数据日期
         T.LGL_REP_ID,   --法人编号
         T.EMP_ID,       --员工编号
         T.ORG_ID,       --机构编号
         T.EMP_NM,       --员工姓名
         T.CRDL_TYP,     --证件类型
         T.CRDL_NO,      --证件号码
         T.TEL,          --联系电话
         T.BLNG_DEPT,    --所属部门
         T.EMP_STAT,     --员工状态
         T.POST_ID,      --岗位编号
         T.CTRY_CD,      --国籍
         T.SENIOR_FLG,   --是否高管
         T.APP_DT,       --批复日期
         T.ASSIGN_DT,    --任职日期
         T.EMP_TYP,      --员工类型
         T.DEPT_LINE,    --部门条线
         T.DATA_SRC,     --数据来源
         T.EMP_TYPE      --员工类型
   FROM (
    SELECT
       TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT      --数据日期
      ,A.LP_ID                      AS LGL_REP_ID   --法人编号
      ,A.CLERK_ID                   AS EMP_ID       --员工编号
      ,A.BELONG_ORG_ID              AS ORG_ID       --机构编号
      ,A.CLERK_NAME                 AS EMP_NM       --员工姓名
      ,A.CERT_TYPE_CD               AS CRDL_TYP     --证件类型   --取消转码
      ,A.CERT_NO                    AS CRDL_NO      --证件号码
      ,CASE WHEN TRIM(A.MOBILE_PHONE_NUM) IS NOT NULL THEN A.MOBILE_PHONE_NUM
            WHEN TRIM(A.MOBILE_PHONE_NUM_1) IS NOT NULL THEN A.MOBILE_PHONE_NUM_1
            WHEN TRIM(A.MOBILE_PHONE_NUM_2) IS NOT NULL THEN A.MOBILE_PHONE_NUM_2
            WHEN TRIM(A.MOBILE_PHONE_NUM_3) IS NOT NULL THEN A.MOBILE_PHONE_NUM_3
            WHEN TRIM(A.WORK_TEL_AREA_CD) IS NOT NULL AND TRIM(A.WORK_TEL_NUM) IS NOT NULL THEN A.WORK_TEL_AREA_CD||'-'||A.WORK_TEL_NUM
            ELSE NULL
       END                          AS TEL          --联系电话
      ,NVL(F.ORG_NAME,G.BLNG_DEPT)  AS BLNG_DEPT    --所属部门
      /*,CASE WHEN A.EMPLY_STATUS_CD ='1' AND A.EMPLY_TYPE_CD NOT IN ('3','5') THEN '02'
            WHEN A.EMPLY_STATUS_CD ='1' AND A.EMPLY_TYPE_CD IN ('3','5') THEN '04'
            WHEN A.EMPLY_STATUS_CD ='2' AND A.EMPLY_TYPE_CD NOT IN ('3','5') THEN '01'
            WHEN A.EMPLY_STATUS_CD ='2' AND A.EMPLY_TYPE_CD IN ('3','5') THEN '03'
       END                          AS EMP_STAT     --员工状态*/
      ,A.EMPLY_STATUS_CD            AS EMP_STAT     --员工状态     --modify by hulj  CD1596
      ,COALESCE(TRIM(A.JOBS_CD),TRIM(A.POSTN_CD),G.POST_ID)
                                    AS POST_ID      --岗位编号  --modify by ljy 20220819
    -- ,/*A.JOBS_CD*/ NVL(TRIM(A.JOBS_CD),TRIM(A.POST_CD))                   AS POST_ID      --岗位编号  --modify by caizhengwei 调整岗位编号逻辑 20220611
      ,A.CTY_CD                     AS CTRY_CD      --国籍
      ,CASE WHEN D.EMP_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END                          AS SENIOR_FLG   --是否高管
      ,D.APP_DT                     AS APP_DT       --批复日期
      ,TO_CHAR(A.EMPYT_DT,'YYYYMMDD')/*D.ASSIGN_DT  */          AS ASSIGN_DT    --任职日期
      ,CASE WHEN A.EMPLY_TYPE_CD IN ('3','5') THEN '3'
            ELSE '1'
       END                          AS EMP_TYP      --员工类型
      ,NULL                         AS DEPT_LINE    --部门条线
      ,'员工信息'                    AS DATA_SRC     --数据来源
      ,ROW_NUMBER() OVER(PARTITION BY A.CLERK_NAME,A.CERT_NO ORDER BY A.TELLER_ID DESC,A.EMPYT_DT DESC) AS NUM
      ,A.TELLER_FLG
      ,A.EMPLY_TYPE_CD              AS EMP_TYPE      --员工类型 --modify by hulj 20221107 新增字段CD1595
    FROM O_ICL_CMM_CLERK_INFO A   --行员信息
    LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO B   --内部机构信息
           ON B.ORG_ID = A.BELONG_ORG_ID
           AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ADD_BANK_SENIOR_LIST D --高管信息补录表
           ON A.CLERK_ID = D.EMP_ID
    LEFT JOIN RRP_MDL.ADD_M_PUB_EMP_INFO G --离职员工岗位、部门补录表
                 ON G.EMP_ID = A.CLERK_ID
/*    LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO E   --内部机构信息
           ON E.ORG_ID = '800001'*/
    LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO F  --内部机构信息
           ON A.LOCAL_DEPT_ID = F.ORG_ID
           AND A.ETL_DT = F.ETL_DT
    WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND A.EMPYT_DT <= A.ETL_DT
      AND A.CLERK_ID IS NOT NULL
  ) T
  --WHERE (T.NUM = 1 OR T.TELLER_FLG = 1)  --modify by 蔡正伟  一个员工多个工号全计入 20220519
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, EMP_ID,COUNT(1)
      FROM M_PUM_EMP_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, EMP_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_INIT_M_PUM_EMP_INFO;
/

