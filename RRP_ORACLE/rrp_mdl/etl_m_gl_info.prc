CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_GL_INFO
  *  功能描述：监管集市银行机构仅报送有余额、有变动的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_SUBJ_INFO   --科目信息
  *
  *  目标表：  M_GL_INFO  --总账会计科目信息表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20230526  LIP      修改大类的取数口径
  *             7    20250923  LIP      增加贴源的科目余额方向代码字段
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                     --处理步骤
  V_STEP_DESC VARCHAR2(100);                    --处理步骤描述
  V_P_DATE    VARCHAR2(8);                      --跑批数据日期
  V_STARTTIME DATE;                             --处理开始时间
  V_ENDTIME   DATE;                             --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                     --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                    --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                    --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_GL_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_GL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';       --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_GL_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_GL_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '总账会计科目信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GL_INFO
    (DATA_DT             --数据日期
    ,LGL_REP_ID          --法人编号
    ,SUBJ_ID             --科目编号
    ,SUBJ_NM             --科目名称
    ,SUBJ_LVL            --科目级次
    ,UP_SUBJ_ID          --上级科目编号
    ,BLNG_BIZ_LRG_CL     --归属业务大类
    ,BLNG_BIZ_SUM_CL     --归属业务子类
    ,SUBJ_DR_CR_FLG      --科目借贷标志
    ,DEPT_LINE           --部门条线
    ,DATA_SRC            --数据来源
    ,SUBJ_BAL_DIR_CD     --科目余额方向代码 --ADD BY LIP 20250923
    )
  SELECT  TO_CHAR(A.ETL_DT, 'YYYYMMDD')                           AS DATA_DT        --数据日期
         ,A.LP_ID                                                 AS LGL_REP_ID     --法人编号
         ,A.SUBJ_ID                                               AS SUBJ_ID        --科目编号
         ,A.SUBJ_NAME                                             AS SUBJ_NM        --科目名称
         ,DECODE(TRIM(A.SUBJ_LEV_CD),'',NULL,TRIM(A.SUBJ_LEV_CD)) AS SUBJ_LVL       --科目级次
         ,CASE WHEN TRIM(A.SUBJ_LEV_CD) = '1' THEN '0'
               ELSE A.SUPER_SUBJ_ID
           END                                                    AS UP_SUBJ_ID     --上级科目编号
         ,CASE WHEN C.BLNG_BIZ_LRG_CL_CD IS NOT NULL THEN C.BLNG_BIZ_LRG_CL_CD
               WHEN B.BLNG_BIZ_LRG_CL_CD IS NOT NULL THEN B.BLNG_BIZ_LRG_CL_CD --MOD BY LIP 20230526
               WHEN E.BLNG_BIZ_LRG_CL_CD IS NOT NULL THEN E.BLNG_BIZ_LRG_CL_CD --MOD BY LIP 20230526
           END                                                    AS BLNG_BIZ_LRG_CL--归属业务大类
         ,CASE WHEN C.BLNG_BIZ_SUB_CL IS NOT NULL THEN C.BLNG_BIZ_SUB_CL
               WHEN B.BLNG_BIZ_SUB_CL IS NOT NULL THEN B.BLNG_BIZ_SUB_CL
               WHEN E.BLNG_BIZ_SUB_CL IS NOT NULL THEN E.BLNG_BIZ_SUB_CL
           END                                                    AS BLNG_BIZ_SUM_CL--归属业务子类 UPDATE BY CXL 20220510 只取业务子类码值，不取代码
         ,CASE WHEN A.SUBJ_BAL_DIR_CD = 'R' THEN 'C'
               WHEN A.SUBJ_BAL_DIR_CD = 'P' THEN 'D' --表外业务 收方对应贷方，付方对应借方
               ELSE A.SUBJ_BAL_DIR_CD
           END                                                    AS SUBJ_DR_CR_FLG --科目借贷标志
         ,'800918'                                                AS DEPT_LINE      --部门条线 /*计划财务部*/
         ,SUBSTR(A.JOB_CD, 0, 4)                                  AS DATA_SRC       --数据来源
         ,A.SUBJ_BAL_DIR_CD                                       AS SUBJ_BAL_DIR_CD --科目余额方向代码 --ADD BY LIP 20250923
    FROM RRP_MDL.O_ICL_CMM_SUBJ_INFO A --科目信息
    LEFT JOIN RRP_MDL.ADD_SUBJ_MAP C --业务提供的科目映射表
      ON C.SUBJ_ID = A.SUBJ_ID
     AND C.IS_VALID = '1' --有效
    LEFT JOIN RRP_MDL.ADD_SUBJ_MAP B --下级科目没有大类、子类时取上级科目的大类、子类 --ADD_SUBJ_MAP_TMP备份表
      ON B.SUBJ_ID = A.SUPER_SUBJ_ID
     AND B.IS_VALID = '1'
     AND A.SUBJ_LEV_CD <= 3
    LEFT JOIN RRP_MDL.ADD_SUBJ_MAP E --下级科目没有大类、子类时取上级科目的大类、子类
      ON E.SUBJ_ID = SUBSTR(A.SUPER_SUBJ_ID,0,4)
     AND E.IS_VALID = '1'
     AND A.SUBJ_LEV_CD <= 3
   WHERE A.SUBJ_ID <> '9999' 
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, SUBJ_ID,COUNT(1)
      FROM RRP_MDL.M_GL_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, SUBJ_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_GL_INFO;
/

