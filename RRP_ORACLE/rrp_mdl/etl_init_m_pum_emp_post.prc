CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_PUM_EMP_POST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_PUM_EMP_POST
  *  功能描述：监管集市银行机构内设立的所有岗位的相关信息，包括核心系统中的所有岗位信息。
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            IML.REF_POSTN_PARA   --职位参数
  *            IML.REF_PUB_CD   --公共代码表
  *  目标表：  M_PUM_EMP_POST  --岗位表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220816  许晓滨   根据EAST5模型层新增逻辑。
  *             2    20221108  hulj     增加数据重复校验。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_PUM_EMP_POST'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_PUM_EMP_POST'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

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
  V_STEP_DESC := '岗位表-逻辑1';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EMP_POST
  (
    DATA_DT      --数据日期
   ,LGL_REP_ID   --法人编号
   ,POST_ID      --岗位编号
   ,ORG_ID       --机构编号
   ,POST_TYP     --岗位类型
   ,POST_NM      --岗位名称
   ,POST_EXPL    --岗位说明
   ,POST_STAT    --岗位状态
   ,DEPT_LINE    --部门条线
   ,DATA_SRC     --数据来源
  )
  SELECT
     V_P_DATE                               AS DATA_DT     --数据日期
    ,'9999'                                 AS LGL_REP_ID  --法人编号
    ,TRIM(A.POST_ID)                        AS POST_ID     --岗位编号
    ,CASE WHEN SUBSTR(B.ORG_ID1,1,3) = '896' THEN '896'
          ELSE NVL(B.ORG_ID1,'800001')    --800001 营运管理部
     END                                    AS ORG_ID      --机构编号
    ,CASE WHEN TRIM(A.TYPE_CD)='1' THEN '基准岗位'
          WHEN TRIM(A.TYPE_CD) IS NULL THEN '基准岗位'
          ELSE '具体岗' END                 AS POST_TYP    --岗位类型
    ,A.POST_NAME                            AS POST_NM     --岗位名称
    ,A.POST_NAME                            AS POST_EXPL   --岗位说明
    ,CASE WHEN STATUS_CD='2' THEN '未启用'ELSE '启用' END                                 AS POST_STAT   --岗位状态
    ,'800915'                               AS DEPT_LINE   --部门条线
    ,SUBSTR(A.JOB_CD,0,4)                   AS DATA_SRC    --数据来源
  FROM O_IML_REF_POSTN_PARA A  --职位参数
  INNER JOIN ORG_CONFIG B
       ON (CASE WHEN SUBSTR(A.ORG_ID,1,3) = '896' THEN '896' ELSE NVL(TRIM(A.ORG_ID),'800') END)  = B.ORG_ID
 /* INNER JOIN O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息
       ON (CASE WHEN SUBSTR(A.ORG_ID,1,3) = '896' THEN '896' ELSE NVL(TRIM(A.ORG_ID),'800') END)  = B.ORG_ID*/
  WHERE /*A.ETL_DT = TO_DATE(V_DATEID,'YYYYMMDD')
    AND*/ TRIM(A.POST_ID) IS NOT NULL
    AND TRIM(A.POST_NAME) IS NOT NULL
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

--许晓滨新增20220816
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '岗位表-逻辑2';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_PUM_EMP_POST (
    DATA_DT,     --数据日期
    LGL_REP_ID,  --法人编号
    POST_ID,     --岗位编号
    ORG_ID,      --机构编号
    POST_TYP,    --岗位类型
    POST_NM,     --岗位名称
    POST_EXPL,   --岗位说明
    POST_STAT,   --岗位状态
    DEPT_LINE,   --部门条线
    DATA_SRC     --数据来源
  )
  SELECT
     V_P_DATE                               AS DATA_DT     --数据日期
    ,A.LP_ID                                AS LGL_REP_ID  --法人编号
    ,A.JOBS_ID                              AS POST_ID     --岗位编号
    ,CASE WHEN SUBSTR(B.ORG_ID1,1,3) = '896' THEN '896'
          ELSE NVL(B.ORG_ID1,'800001')   --800001 营运管理部
     END                                    AS ORG_ID      --机构编号
    ,NVL(C.CD_DESCB,REGEXP_REPLACE(A.JOBS_NAME,'[0-9,-]')) AS POST_TYP    --岗位类型
    ,A.JOBS_NAME                            AS POST_NM     --岗位名称
    ,REGEXP_REPLACE(A.JOBS_NAME,'[0-9,-]')  AS POST_EXPL   --岗位说明
    ,'启用'                                 AS POST_STAT   --岗位状态
    ,'800915'                               AS DEPT_LINE   --部门条线/*人力资源部*/
    ,SUBSTR(A.JOB_CD,0,4)                   AS DATA_SRC    --数据来源
  FROM O_IML_REF_TELLER_JOBS_INFO_H A  --柜员岗位信息历史
    left /*INNER*/ JOIN ORG_CONFIG B
       ON (CASE WHEN SUBSTR(SUBSTR(A.JOBS_NAME,1,6),1,3) = '896' THEN '896' ELSE SUBSTR(A.JOBS_NAME,1,6) END)  = B.ORG_ID
  LEFT JOIN O_IML_REF_PUB_CD C  --公共代码表
         ON C.CD_VAL= SUBSTR(A.JOBS_TYPE_CD,1,4)
        AND C.CD_ID = 'CD2257'
  WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.JOBS_ID IS NOT NULL
    --AND A.JOBS_TYPE_CD IS NOT NULL
    AND A.JOBS_NAME IS NOT NULL
  ;


  COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, POST_ID,COUNT(1)
      FROM M_PUM_EMP_POST T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, POST_ID
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

  END ETL_INIT_M_PUM_EMP_POST;
/

