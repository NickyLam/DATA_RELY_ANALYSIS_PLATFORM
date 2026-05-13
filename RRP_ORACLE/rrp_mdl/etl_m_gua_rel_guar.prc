CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GUA_REL_GUAR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_GUA_REL_GUAR
  *  功能描述：担保合同与担保人对应关系信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_REL_GUAR
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221114  HULJ     增加数据重复校验
  *             3    20231012  HULJ     新增联合网贷担保人对关系逻辑
  *             4    20241009  LIP      调整担保合同和担保人关系的取数口径
  *             5    20260104  YJY      一表通报送要求也要包含本年内失效的担保人编号，将前一天的担保人编号与当前跑批日期的担保人编号对比
                                         没关联到的担保人编号按照失效担保人统计，其数据日期定义为担保人的失效日期
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;        --处理步骤
  V_P_DATE    VARCHAR2(8);         --跑批数据日期
  V_STARTTIME DATE;                --处理开始时间
  V_ENDTIME   DATE;                --处理结束时间
  V_SQLCOUNT  INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);       --任务名称
  V_PART_NAME VARCHAR2(100);       --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_GUA_REL_GUAR'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_GUA_REL_GUAR'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_GUA_REL_GUAR T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入担保合同与担保人对应关系行内贷款部分数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_GUA_REL_GUAR_TMP';
  INSERT INTO RRP_MDL.M_GUA_REL_GUAR_TMP
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,GUA_CONT_ID         --担保合同号
    ,COL_ID              --押品编号
    ,GUAR_ID             --担保人编号
    ,TRD_COLL_OWNER_FLG  --第三方押品权属人标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  SELECT V_P_DATE                   AS DATA_DT              --数据日期
        ,A.LP_ID                    AS LGL_REP_ID           --法人编号
        ,TRIM(A.GUAR_CONT_ID)       AS GUA_CONT_ID          --担保合同号
        ,TRIM(A.COL_ID)             AS COL_ID               --押品编号
        --,A.GUARTOR_ID               AS GUAR_ID              --担保人编号
        ,TRIM(B.GUARTOR_ID)         AS GUAR_ID              --担保人编号 --MOD BY 20241009
        ,NULL                       AS TRD_COLL_OWNER_FLG   --第三方押品权属人标志额
        ,'800919'                   AS DEPT_LINE            --部门条线
        ,SUBSTR(A.JOB_CD,0,4)       AS DATA_SRC             --数据来源
    FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA A --押品与担保合同关系 --MOD BY LIP 20241009
   INNER JOIN RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B --押品保证人评级信息
      ON B.COL_ID = A.COL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(A.GUAR_CONT_ID) IS NOT NULL
     AND TRIM(A.COL_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入担保合同与担保人对应关系信息联合网贷部分数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_REL_GUAR_TMP
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,GUA_CONT_ID         --担保合同号
    ,COL_ID              --押品编号
    ,GUAR_ID             --担保人编号
    ,TRD_COLL_OWNER_FLG  --第三方押品权属人标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  SELECT V_P_DATE                   AS DATA_DT              --数据日期
        ,A.LP_ID                    AS LGL_REP_ID           --法人编号
        ,TRIM(A.GUAR_CONT_ID)       AS GUA_CONT_ID          --担保合同号
        ,TRIM(A.COL_ID)             AS COL_ID               --押品编号
        ,TRIM(B.GUARTOR_ID)         AS GUAR_ID              --担保人编号
        ,NULL                       AS TRD_COLL_OWNER_FLG   --第三方押品权属人标志额
        ,'800919'                   AS DEPT_LINE            --部门条线
        ,'联合网贷'                 AS DATA_SRC             --数据来源
    FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_GUAR_CONT_RELA A --联合网贷贷款与担保合同关系
    LEFT JOIN RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO B --押品保证人评级信息
      ON B.COL_ID = A.COL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TRIM(A.GUAR_CONT_ID) IS NOT NULL
     AND TRIM(A.COL_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入担保合同与担保人对应关系信息数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_REL_GUAR
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,GUA_CONT_ID         --担保合同号
    ,GUAR_ID             --担保人编号
    ,TRD_COLL_OWNER_FLG  --第三方押品权属人标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    )
  WITH TMP1 AS (
  SELECT V_P_DATE                   AS DATA_DT              --数据日期
        ,A.LGL_REP_ID               AS LGL_REP_ID           --法人编号
        ,A.GUA_CONT_ID              AS GUA_CONT_ID          --担保合同号
        ,A.COL_ID                   AS GUAR_ID              --担保人编号
        ,A.TRD_COLL_OWNER_FLG       AS TRD_COLL_OWNER_FLG   --第三方押品权属人标志额
        ,A.DEPT_LINE                AS DEPT_LINE            --部门条线
        ,A.DATA_SRC                 AS DATA_SRC             --数据来源
        ,ROW_NUMBER() OVER(PARTITION BY A.GUA_CONT_ID,A.COL_ID ORDER BY A.GUAR_ID DESC) RN
    FROM RRP_MDL.M_GUA_REL_GUAR_TMP A --担保合同与担保人对应关系信息
   WHERE TRIM(A.GUAR_ID) IS NOT NULL
     AND A.DATA_DT = V_P_DATE)
  SELECT V_P_DATE                   AS DATA_DT              --数据日期
        ,T.LGL_REP_ID               AS LGL_REP_ID           --法人编号
        ,T.GUA_CONT_ID              AS GUA_CONT_ID          --担保合同号
        ,T.GUAR_ID                  AS GUAR_ID              --担保人编号
        ,T.TRD_COLL_OWNER_FLG       AS TRD_COLL_OWNER_FLG   --第三方押品权属人标志额
        ,T.DEPT_LINE                AS DEPT_LINE            --部门条线
        ,T.DATA_SRC                 AS DATA_SRC             --数据来源
    FROM TMP1 T
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;  
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --ADD BY YJY 20260104 本年内失效的担保人信息也要统计
  V_STEP := V_STEP + 1; 
  V_STEP_DESC := '插入前一天失效的担保人数据';
  V_STARTTIME := SYSDATE;  
   INSERT INTO RRP_MDL.M_GUA_REL_GUAR
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,GUA_CONT_ID         --担保合同号
    ,GUAR_ID             --担保人编号
    ,TRD_COLL_OWNER_FLG  --第三方押品权属人标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,GUA_REL_GUAR_END_DT --担保合同和担保人关系的失效日期  --ADD BY YJY 20260104
    )
   WITH TMP1 AS (
  SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.GUA_CONT_ID,T.GUAR_ID ORDER BY T.DATA_DT DESC) RN
    FROM RRP_MDL.M_GUA_REL_GUAR T
    LEFT JOIN RRP_MDL.M_GUA_REL_GUAR TB
      ON TB.GUAR_ID = T.GUAR_ID
     AND TB.GUA_CONT_ID = T.GUA_CONT_ID
     AND TB.DATA_DT = V_P_DATE
   WHERE TB.GUAR_ID IS NULL
     AND NVL(T.GUA_REL_GUAR_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD') --上一天采集的有效数据或者当年内失效的数据
     AND T.DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD'))
  SELECT V_P_DATE                   AS DATA_DT              --数据日期
        ,T.LGL_REP_ID               AS LGL_REP_ID           --法人编号
        ,T.GUA_CONT_ID              AS GUA_CONT_ID          --担保合同号
        ,T.GUAR_ID                  AS GUAR_ID              --担保人编号
        ,T.TRD_COLL_OWNER_FLG       AS TRD_COLL_OWNER_FLG   --第三方押品权属人标志额
        ,T.DEPT_LINE                AS DEPT_LINE            --部门条线
        ,T.DATA_SRC                 AS DATA_SRC             --数据来源
        ,CASE WHEN T.GUA_REL_GUAR_END_DT IS NOT NULL 
              THEN T.GUA_REL_GUAR_END_DT
              ELSE V_P_DATE   
         END     			              AS GUA_REL_GUAR_END_DT  --担保合同和担保人关系的失效日期  --ADD BY YJY 20260104
    FROM TMP1 T
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;  
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT,GUA_CONT_ID,GUAR_ID,COUNT(1)
      FROM RRP_MDL.M_GUA_REL_GUAR T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,GUA_CONT_ID,GUAR_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
     RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_M_GUA_REL_GUAR;
/

