CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_GL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_GL_INFO
  *  功能描述：监管集市银行机构仅报送有余额、有变动的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_SUBJ_INFO   --科目信息
  *
  *  目标表：  M_GL_INFO  --总账会计科目信息表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj    增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_GL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_GL_INFO'; --表名
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
  V_STEP_DESC := '总账会计科目信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_GL_INFO
  (
    DATA_DT             --数据日期
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
  )
  SELECT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD')        AS DATA_DT       --数据日期
   ,A.LP_ID                              AS LGL_REP_ID     --法人编号
   ,A.SUBJ_ID                            AS SUBJ_ID        --科目编号
   ,A.SUBJ_NAME                          AS SUBJ_NM        --科目名称
   ,DECODE(TRIM(A.SUBJ_LEV_CD), '', NULL, TRIM(A.SUBJ_LEV_CD))             AS SUBJ_LVL   --科目级次
   ,CASE WHEN TRIM(A.SUBJ_LEV_CD) = '1' THEN '0' ELSE A.SUPER_SUBJ_ID END  AS UP_SUBJ_ID --上级科目编号
   ,C.BLNG_BIZ_LRG_CL_CD                 AS BLNG_BIZ_LRG_CL     --归属业务大类
   ,C.BLNG_BIZ_SUB_CL                    AS BLNG_BIZ_SUM_CL     --归属业务子类 update by cxl 20220510 只取业务子类码值，不取代码
   ,CASE WHEN A.SUBJ_BAL_DIR_CD = 'R' THEN 'C'
         WHEN A.SUBJ_BAL_DIR_CD = 'P' THEN 'D' --表外业务 收方对应贷方，付方对应借方
         ELSE A.SUBJ_BAL_DIR_CD
     END                                  AS SUBJ_DR_CR_FLG    --科目借贷标志
   ,'800918'   /*计划财务部*/             AS DEPT_LINE         --部门条线
   ,SUBSTR(A.JOB_CD, 0, 4)                AS DATA_SRC          --数据来源
  FROM RRP_MDL.O_ICL_CMM_SUBJ_INFO A   --科目信息
  LEFT JOIN RRP_MDL.ADD_SUBJ_MAP C
   ON A.SUBJ_ID = C.SUBJ_ID
   AND C.IS_VALID = '1' --有效
  /*LEFT JOIN RRP_MDL.ADD_SUBJ_MAP D
   ON A.SUBJ_ID = D.SUBJ_ID
   AND D.IS_VALID = '0' --update by cxl 20220510 过滤掉停用的科目 */
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --AND D.SUBJ_ID IS NULL
    AND A.SUBJ_ID <> '9999' --update by cxl 20220510 过滤掉 补平科目
--   ADD_SUBJ_MAP_TMP备份表
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
    SELECT DATA_DT, SUBJ_ID,COUNT(1)
      FROM M_GL_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, SUBJ_ID
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

  END ETL_INIT_M_GL_INFO;
/

