CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GUA_REL_COLL(I_P_DATE IN INTEGER,
                                               O_ERRCODE OUT VARCHAR2
                                               )
  /**************************************************************************
  *  程序名称：ETL_M_GUA_REL_COLL
  *  功能描述：担保合同与押品对应关系表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_REL_COLL
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE           VARCHAR2(8);                             --跑批数据日期
  V_STARTTIME        DATE;                                    --处理开始时间
  V_ENDTIME          DATE;                                    --处理结束时间
  V_SQLCOUNT         INTEGER := 0;                            --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);                           --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(200);                           --任务名称
  V_PART_NAME        VARCHAR2(100);                           --分区名
  V_STEP             INTEGER := 0;                            --处理步骤
  V_TAB_NAME         VARCHAR2(100) := 'M_GUA_REL_COLL';       --表名
  V_PROC_NAME        VARCHAR2(100) := 'ETL_M_GUA_REL_COLL';   --程序名称
  V_SYSTEM           VARCHAR2(30) := '监管报送';              --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM M_GUA_REL_COLL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_GUA_REL_COLL'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '担保合同与押品对应关系表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_REL_COLL
    (DATA_DT            --数据日期
    ,LGL_REP_ID         --法人编号
    ,GUA_CONT_ID        --担保合同号
    ,COLL_ID            --押品编号
    ,PRI_COMP_AMT       --优先受偿权数额
    ,COLL_SEQ           --担保物顺序
    ,DEPT_LINE          --部门条线
    ,DATA_SRC           --数据来源
    )
  SELECT V_P_DATE                  AS DATA_DT         --数据日期
        ,A.LP_ID                   AS LGL_REP_ID      --法人编号
        ,A.GUAR_CONT_ID            AS GUA_CONT_ID     --担保合同号
        ,A.COL_ID                  AS COLL_ID         --押品编号
        ,B.PRIOR_COMP_WEIGHT_QTTY  AS PRI_COMP_AMT    --优先受偿权数额
        ,CASE WHEN B.PRIOR_COMP_WEIGHT_QTTY = 0 THEN '第一顺位'
              ELSE(CASE WHEN C.HXB_PRIOR_SEQ_COMB_CD IN ('0','1') THEN '第一顺位'
                        WHEN C.HXB_PRIOR_SEQ_COMB_CD = '2' THEN '第二顺位'
                        WHEN C.HXB_PRIOR_SEQ_COMB_CD = '3' THEN '第三顺位'
                        WHEN C.HXB_PRIOR_SEQ_COMB_CD = '4' THEN '第四顺位'
                        WHEN C.HXB_PRIOR_SEQ_COMB_CD = '5' THEN '第五顺位'
                        ELSE '第一顺位'
                    END)
          END                      AS COLL_SEQ        --担保物顺序,目前HXB_PRIOR_SEQ_COMB_CD只有0,1,2
        ,'800919'                  AS DEPT_LINE       --部门条线
        ,SUBSTR(A.JOB_CD,0,4)      AS DATA_SRC        --数据来源
    FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA A --押品与担保合同关系
    LEFT JOIN RRP_MDL.O_ICL_CMM_COL_INFO B --押品信息
      ON B.COL_ID = A.COL_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT C.ASSET_ID
                      ,C.HXB_PRIOR_SEQ_COMB_CD
                      ,ROW_NUMBER()OVER(PARTITION BY C.ASSET_ID ORDER BY C.HXB_PRIOR_SEQ_COMB_CD DESC) AS RN
                 FROM RRP_MDL.O_IML_AST_COL_OBANK_GUAR C --押品他行担保
                WHERE C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') )C --一件押品存在多条记录且每条记录我行优先偿权顺序组合代码不一样
      ON C.ASSET_ID = A.COL_ID
     AND C.RN = 1
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  IF V_P_DATE = TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD') THEN
    --ADD BY 20240229 插入当月内被删除的数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入当月内被删除的数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_GUA_REL_COLL
      (DATA_DT           --数据日期
      ,LGL_REP_ID        --法人编号
      ,GUA_CONT_ID       --担保合同号
      ,COLL_ID           --押品编号
      ,PRI_COMP_AMT      --优先受偿权数额
      ,COLL_SEQ          --担保物顺序
      ,DEPT_LINE         --部门条线
      ,DATA_SRC          --数据来源
      )
     WITH TMP1 AS (
     SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.GUA_CONT_ID,T.COLL_ID ORDER BY T.DATA_DT DESC) RN
       FROM RRP_MDL.M_GUA_REL_COLL T
       LEFT JOIN RRP_MDL.M_GUA_REL_COLL TB
         ON TB.GUA_CONT_ID = T.GUA_CONT_ID
        AND TB.COLL_ID = T.COLL_ID
        AND TB.DATA_DT = V_P_DATE
      WHERE TB.GUA_CONT_ID IS NULL
        AND T.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
        AND T.DATA_DT <= V_P_DATE)
    SELECT V_P_DATE                AS DATA_DT            --数据日期
          ,TA.LGL_REP_ID           AS LGL_REP_ID         --法人编号
          ,TA.GUA_CONT_ID          AS GUA_CONT_ID        --担保合同号
          ,TA.COLL_ID              AS COLL_ID            --押品编号
          ,TA.PRI_COMP_AMT         AS PRI_COMP_AMT       --优先受偿权数额
          ,TA.COLL_SEQ             AS COLL_SEQ           --担保物顺序
          ,TA.DEPT_LINE            AS DEPT_LINE          --部门条线
          ,TA.DATA_SRC             AS DATA_SRC           --数据来源
      FROM TMP1 TA
     WHERE TA.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END IF;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT,GUA_CONT_ID,COLL_ID,COUNT(1)
      FROM RRP_MDL.M_GUA_REL_COLL T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,GUA_CONT_ID,COLL_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

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

END ETL_M_GUA_REL_COLL;
/

