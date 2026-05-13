CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_BANK_INT_LADR_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_BANK_INT_LADR_H
  *  功能描述：行内利率阶梯历史
  *  创建日期：20221222
  *  开发人员：梅炜
  *  来源表： IML.V_REF_BANK_INT_LADR_H
  *  目标表： O_IML_REF_BANK_INT_LADR_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221222  梅炜     首次创建
  *             2    20241227  YJY      优化脚本
  *             3    20250114  LIP      优化下级机构取数脚本
  *             4    20250509  LIP      因核心设置不同起存金额数据，会导致数据重复，增加临时表，存放排序后的数据
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_BANK_INT_LADR_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_BANK_INT_LADR_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_BANK_INT_LADR_H';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入总行机构数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H
    (LADR_SEQ_NUM              --阶梯序号
    ,LP_ID                     --法人编号
    ,ORG_ID                    --机构编号
    ,CURR_CD                   --币种代码
    ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
    ,YEAR_BASE_DAYS            --年基准天数
    ,EFFECT_DT                 --生效日期
    ,INVALID_DT                --失效日期
    ,BASE_RAT_TYPE_ID          --基准利率类型编号
    ,BASE_EXCH_RAT             --基础汇率
    ,PED_FREQ_CD               --周期频率代码
    ,EH_ISSUE_DAYS             --每期天数
    ,LADR_AMT                  --阶梯金额
    ,BANK_INT_INT_RAT          --行内利率
    ,INT_RAT_DISCNT            --利率折扣
    ,FLOAT_RATIO               --浮动比例
    ,FLOAT_POINT               --浮动点数
    ,MAX_CU_RATIO              --最大上浮比例
    ,MIN_CU_RATIO              --最小上浮比例
    ,MIN_INT_RAT               --最小利率
    ,MAX_INT_RAT               --最大利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,MIN_FLOAT_POINT           --浮动点差下限
    ,MAX_FLOAT_RATIO           --最大下浮比例
    ,MIN_FLOAT_RATIO           --最小下浮比例
    ,START_DT                  --开始时间
    ,END_DT                    --结束时间
    ,ID_MARK                   --增删标志
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    ,ETL_TIMESTAMP             --ETL处理时间戳
    )
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,T.EFFECT_DT                 --生效日期
        ,T.INVALID_DT                --失效日期
        ,T.BASE_RAT_TYPE_ID          --基准利率类型编号
        ,T.BASE_EXCH_RAT             --基础汇率
        ,T.PED_FREQ_CD               --周期频率代码
        ,T.EH_ISSUE_DAYS             --每期天数
        ,T.LADR_AMT                  --阶梯金额
        ,T.BANK_INT_INT_RAT          --行内利率
        ,T.INT_RAT_DISCNT            --利率折扣
        ,T.FLOAT_RATIO               --浮动比例
        ,T.FLOAT_POINT               --浮动点数
        ,T.MAX_CU_RATIO              --最大上浮比例
        ,T.MIN_CU_RATIO              --最小上浮比例
        ,T.MIN_INT_RAT               --最小利率
        ,T.MAX_INT_RAT               --最大利率
        ,T.MAX_FLOAT_POINT           --浮动点差上限
        ,T.MIN_FLOAT_POINT           --浮动点差下限
        ,T.MAX_FLOAT_RATIO           --最大下浮比例
        ,T.MIN_FLOAT_RATIO           --最小下浮比例
        ,T.START_DT                  --开始时间
        ,T.END_DT                    --结束时间
        ,T.ID_MARK                   --增删标志
        ,T.SRC_TABLE_NAME            --源表名称
        ,T.JOB_CD                    --任务编码
        ,T.ETL_TIMESTAMP             --ETL处理时间戳
    FROM IML.V_REF_BANK_INT_LADR_H T --视图-行内利率阶梯历史
   WHERE T.ORG_ID IN ('800001')
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '取出分行配置的数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP';
  INSERT INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP
    (LADR_SEQ_NUM              --阶梯序号
    ,LP_ID                     --法人编号
    ,ORG_ID                    --机构编号
    ,CURR_CD                   --币种代码
    ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
    ,YEAR_BASE_DAYS            --年基准天数
    ,EFFECT_DT                 --生效日期
    ,INVALID_DT                --失效日期
    ,BASE_RAT_TYPE_ID          --基准利率类型编号
    ,BASE_EXCH_RAT             --基础汇率
    ,PED_FREQ_CD               --周期频率代码
    ,EH_ISSUE_DAYS             --每期天数
    ,LADR_AMT                  --阶梯金额
    ,BANK_INT_INT_RAT          --行内利率
    ,INT_RAT_DISCNT            --利率折扣
    ,FLOAT_RATIO               --浮动比例
    ,FLOAT_POINT               --浮动点数
    ,MAX_CU_RATIO              --最大上浮比例
    ,MIN_CU_RATIO              --最小上浮比例
    ,MIN_INT_RAT               --最小利率
    ,MAX_INT_RAT               --最大利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,MIN_FLOAT_POINT           --浮动点差下限
    ,MAX_FLOAT_RATIO           --最大下浮比例
    ,MIN_FLOAT_RATIO           --最小下浮比例
    ,START_DT                  --开始时间
    ,END_DT                    --结束时间
    ,ID_MARK                   --增删标志
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    ,ETL_TIMESTAMP             --ETL处理时间戳
    )
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,T.EFFECT_DT                 --生效日期
        ,T.INVALID_DT                --失效日期
        ,T.BASE_RAT_TYPE_ID          --基准利率类型编号
        ,T.BASE_EXCH_RAT             --基础汇率
        ,T.PED_FREQ_CD               --周期频率代码
        ,T.EH_ISSUE_DAYS             --每期天数
        ,T.LADR_AMT                  --阶梯金额
        ,T.BANK_INT_INT_RAT          --行内利率
        ,T.INT_RAT_DISCNT            --利率折扣
        ,T.FLOAT_RATIO               --浮动比例
        ,T.FLOAT_POINT               --浮动点数
        ,T.MAX_CU_RATIO              --最大上浮比例
        ,T.MIN_CU_RATIO              --最小上浮比例
        ,T.MIN_INT_RAT               --最小利率
        ,T.MAX_INT_RAT               --最大利率
        ,T.MAX_FLOAT_POINT           --浮动点差上限
        ,T.MIN_FLOAT_POINT           --浮动点差下限
        ,T.MAX_FLOAT_RATIO           --最大下浮比例
        ,T.MIN_FLOAT_RATIO           --最小下浮比例
        ,T.START_DT                  --开始时间
        ,T.END_DT                    --结束时间
        ,T.ID_MARK                   --增删标志
        ,T.SRC_TABLE_NAME            --源表名称
        ,T.JOB_CD                    --任务编码
        ,T.ETL_TIMESTAMP          
    FROM IML.V_REF_BANK_INT_LADR_H T  --视图-行内利率阶梯历史
   INNER JOIN ICL.V_CMM_INTNAL_ORG_INFO TB
      ON TB.ORG_ID = T.ORG_ID
     AND TRIM(TB.ACCTI_SUPER_ORG_ID) = '800001' --取分行机构
     AND TB.ORG_ID <> '800001'
     AND TB.ACCTI_ORG_FLG = '1'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入分行数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H
    (LADR_SEQ_NUM              --阶梯序号
    ,LP_ID                     --法人编号
    ,ORG_ID                    --机构编号
    ,CURR_CD                   --币种代码
    ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
    ,YEAR_BASE_DAYS            --年基准天数
    ,EFFECT_DT                 --生效日期
    ,INVALID_DT                --失效日期
    ,BASE_RAT_TYPE_ID          --基准利率类型编号
    ,BASE_EXCH_RAT             --基础汇率
    ,PED_FREQ_CD               --周期频率代码
    ,EH_ISSUE_DAYS             --每期天数
    ,LADR_AMT                  --阶梯金额
    ,BANK_INT_INT_RAT          --行内利率
    ,INT_RAT_DISCNT            --利率折扣
    ,FLOAT_RATIO               --浮动比例
    ,FLOAT_POINT               --浮动点数
    ,MAX_CU_RATIO              --最大上浮比例
    ,MIN_CU_RATIO              --最小上浮比例
    ,MIN_INT_RAT               --最小利率
    ,MAX_INT_RAT               --最大利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,MIN_FLOAT_POINT           --浮动点差下限
    ,MAX_FLOAT_RATIO           --最大下浮比例
    ,MIN_FLOAT_RATIO           --最小下浮比例
    ,START_DT                  --开始时间
    ,END_DT                    --结束时间
    ,ID_MARK                   --增删标志
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    ,ETL_TIMESTAMP             --ETL处理时间戳
    )
  WITH REF_BANK_INT_LADR_H AS (
  --将上级机构的数据拆分到各下级机构
  SELECT /*+MATERIALIZE*/
         TA.LADR_SEQ_NUM,TA.LP_ID,TB.ORG_ID,TA.CURR_CD,TA.BANK_INT_INT_RAT_TYPE_CD,TA.YEAR_BASE_DAYS,TA.EFFECT_DT,
         TA.INVALID_DT,TA.BASE_RAT_TYPE_ID,TA.BASE_EXCH_RAT,TA.PED_FREQ_CD,TA.EH_ISSUE_DAYS,TA.LADR_AMT,TA.BANK_INT_INT_RAT,
         TA.INT_RAT_DISCNT,TA.FLOAT_RATIO,TA.FLOAT_POINT,TA.MAX_CU_RATIO,TA.MIN_CU_RATIO,TA.MIN_INT_RAT,TA.MAX_INT_RAT,
         TA.MAX_FLOAT_POINT,TA.MIN_FLOAT_POINT,TA.MAX_FLOAT_RATIO,TA.MIN_FLOAT_RATIO,TA.START_DT,TA.END_DT,TA.ID_MARK,
         TA.SRC_TABLE_NAME,TA.JOB_CD,TA.ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA
   INNER JOIN ICL.V_CMM_INTNAL_ORG_INFO TB --只匹配有下级机构的数据
      ON TRIM(TB.ACCTI_SUPER_ORG_ID) = TA.ORG_ID
     AND TB.ORG_ID <> '800001'
     AND TB.ACCTI_ORG_FLG = '1'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.ORG_ID = '800001'
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.ID_MARK <> 'D'),
   TMP_SJJG_END AS (
   --上级机构的最小开始日期和最大结束日期
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         MIN(T.EFFECT_DT) EFFECT_DT,MAX(T.INVALID_DT) INVALID_DT
    FROM REF_BANK_INT_LADR_H T
   GROUP BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT),
  TMP_XJJG_END AS(
  --下级机构的最小开始、结束日期和最大开始、结束日期
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         MIN(T.EFFECT_DT) MIN_EFFECT_DT,MAX(EFFECT_DT) MAX_EFFECT_DT,
         MIN(T.INVALID_DT) MIN_INVALID_DT,MAX(T.INVALID_DT) MAX_INVALID_DT
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
   GROUP BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT),
  TMP_QS AS (
  --找出下级机构的空缺部分
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.INVALID_DT + 1 AS EFFECT_DT,
         --当前记录结束日期+1为开始日期，下一条记录的开始日期-1为结束日期
         NVL(LEAD(T.EFFECT_DT,1) OVER(PARTITION BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT
                                      ORDER BY T.EFFECT_DT)-1,TA.INVALID_DT) AS INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
    LEFT JOIN TMP_SJJG_END TA --定位分组最小最大结束日期
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   UNION ALL
  --获取下级机构本身有配置信息的数据
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,T.EFFECT_DT,T.INVALID_DT,
         T.LADR_SEQ_NUM,T.LP_ID,T.YEAR_BASE_DAYS,T.BASE_RAT_TYPE_ID,T.BASE_EXCH_RAT,T.EH_ISSUE_DAYS,
         T.BANK_INT_INT_RAT,T.INT_RAT_DISCNT,T.FLOAT_RATIO,T.FLOAT_POINT,T.MAX_CU_RATIO,T.MIN_CU_RATIO,
         T.MIN_INT_RAT,T.MAX_INT_RAT,T.MAX_FLOAT_POINT,T.MIN_FLOAT_POINT,T.MAX_FLOAT_RATIO,T.MIN_FLOAT_RATIO,
         T.START_DT,T.END_DT,T.ID_MARK,T.SRC_TABLE_NAME,T.JOB_CD,T.ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
   UNION ALL
  --获取上级机构比下级机构早配置的数据
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.EFFECT_DT,TA.MIN_EFFECT_DT - 1 INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM TMP_SJJG_END T
    LEFT JOIN TMP_XJJG_END TA
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE T.EFFECT_DT <> TA.MIN_EFFECT_DT
   UNION ALL
  --获取上级机构有配置，但是下级机构没有配置的类型
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.EFFECT_DT,T.INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM TMP_SJJG_END T
    LEFT JOIN TMP_XJJG_END TA
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE TA.ORG_ID IS NULL)
  SELECT NVL(A.LADR_SEQ_NUM,B.LADR_SEQ_NUM)                       AS LADR_SEQ_NUM              --阶梯序号
        ,NVL(A.LP_ID,B.LP_ID)                                     AS LP_ID                     --法人编号
        ,A.ORG_ID                                                 AS ORG_ID                    --机构编号
        ,A.CURR_CD                                                AS CURR_CD                   --币种代码
        ,A.BANK_INT_INT_RAT_TYPE_CD                               AS BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,NVL(A.YEAR_BASE_DAYS,B.YEAR_BASE_DAYS)                   AS YEAR_BASE_DAYS            --年基准天数
        ,CASE WHEN A.EFFECT_DT < C.EFFECT_DT THEN B.EFFECT_DT --A表最早开始日期缺失
              WHEN A.EFFECT_DT > D.MAX_EFFECT_DT AND A.EFFECT_DT < B.EFFECT_DT THEN B.EFFECT_DT --A表最晚开始日期缺失，且上级机构开始日期晚于下级开始日期
              WHEN A.EFFECT_DT < B.EFFECT_DT THEN B.EFFECT_DT --拆分后的开始日期早于上级机构的开始日期时，取上级机构的开始日期
              ELSE A.EFFECT_DT --否则取拆分后的开始日期
          END                                                     AS EFFECT_DT                 --生效日期
        ,CASE WHEN A.INVALID_DT < D.MIN_EFFECT_DT AND A.INVALID_DT > B.INVALID_DT THEN B.INVALID_DT --拆分后的开始日期小于最早开始日期，且结束日期早于上级机构的结束日期
              WHEN A.INVALID_DT > D.MAX_INVALID_DT THEN B.INVALID_DT --拆分后的结束日期晚于表中的最大结束日期
              WHEN A.INVALID_DT > B.INVALID_DT THEN B.INVALID_DT --拆分后的结束日期晚于上级机构的结束日期
              ELSE A.INVALID_DT --否则取拆分后的开始日期
          END                                                     AS INVALID_DT                --失效日期
        ,NVL(A.BASE_RAT_TYPE_ID,B.BASE_RAT_TYPE_ID)               AS BASE_RAT_TYPE_ID          --基准利率类型编号
        ,NVL(A.BASE_EXCH_RAT,B.BASE_EXCH_RAT)                     AS BASE_EXCH_RAT             --基础汇率
        ,A.PED_FREQ_CD                                            AS PED_FREQ_CD               --周期频率代码
        ,NVL(A.EH_ISSUE_DAYS,B.EH_ISSUE_DAYS)                     AS EH_ISSUE_DAYS             --每期天数
        ,A.LADR_AMT                                               AS LADR_AMT                  --阶梯金额
        ,A.BANK_INT_INT_RAT                                       AS BANK_INT_INT_RAT          --行内利率
        ,NVL(A.INT_RAT_DISCNT,B.INT_RAT_DISCNT)                   AS INT_RAT_DISCNT            --利率折扣
        ,NVL(A.FLOAT_RATIO,B.FLOAT_RATIO)                         AS FLOAT_RATIO               --浮动比例
        ,NVL(A.FLOAT_POINT,B.FLOAT_POINT)                         AS FLOAT_POINT               --浮动点数
        ,NVL(A.MAX_CU_RATIO,B.MAX_CU_RATIO)                       AS MAX_CU_RATIO              --最大上浮比例
        ,NVL(A.MIN_CU_RATIO,B.MIN_CU_RATIO)                       AS MIN_CU_RATIO              --最小上浮比例
        ,NVL(A.MIN_INT_RAT,B.MIN_INT_RAT)                         AS MIN_INT_RAT               --最小利率
        ,NVL(A.MAX_INT_RAT,B.MAX_INT_RAT)                         AS MAX_INT_RAT               --最大利率
        ,NVL(A.MAX_FLOAT_POINT,B.MAX_FLOAT_POINT)                 AS MAX_FLOAT_POINT           --浮动点差上限
        ,NVL(A.MIN_FLOAT_POINT,B.MIN_FLOAT_POINT)                 AS MIN_FLOAT_POINT           --浮动点差下限
        ,NVL(A.MAX_FLOAT_RATIO,B.MAX_FLOAT_RATIO)                 AS MAX_FLOAT_RATIO           --最大下浮比例
        ,NVL(A.MIN_FLOAT_RATIO,B.MIN_FLOAT_RATIO)                 AS MIN_FLOAT_RATIO           --最小下浮比例
        ,NVL(A.START_DT,B.START_DT)                               AS START_DT                  --开始时间
        ,NVL(A.END_DT,B.END_DT)                                   AS END_DT                    --结束时间
        ,NVL(A.ID_MARK,B.ID_MARK)                                 AS ID_MARK                   --增删标志
        ,NVL(A.SRC_TABLE_NAME,B.SRC_TABLE_NAME)                   AS SRC_TABLE_NAME            --源表名称
        ,NVL(A.JOB_CD,B.JOB_CD)                                   AS JOB_CD                    --任务编码
        ,NVL(A.ETL_TIMESTAMP,B.ETL_TIMESTAMP)                     AS ETL_TIMESTAMP             --ETL处理时间戳
    FROM TMP_QS A --补充后的下级机构
    LEFT JOIN TMP_SJJG_END C  --上级机构的最大最小数据
      ON C.ORG_ID = A.ORG_ID
     AND C.CURR_CD = A.CURR_CD
     AND C.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND C.PED_FREQ_CD = A.PED_FREQ_CD
     AND C.LADR_AMT = A.LADR_AMT
    LEFT JOIN TMP_XJJG_END D --下级机构的最大最小数据
      ON D.ORG_ID = A.ORG_ID
     AND D.CURR_CD = A.CURR_CD
     AND D.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND D.PED_FREQ_CD = A.PED_FREQ_CD
     AND D.LADR_AMT = A.LADR_AMT
    LEFT JOIN REF_BANK_INT_LADR_H B --上级机构
      ON B.ORG_ID = A.ORG_ID
     AND B.CURR_CD = A.CURR_CD
     AND B.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND B.PED_FREQ_CD = A.PED_FREQ_CD
     AND B.LADR_AMT = A.LADR_AMT
     AND (A.EFFECT_DT BETWEEN B.EFFECT_DT AND B.INVALID_DT
         OR A.INVALID_DT BETWEEN B.EFFECT_DT AND B.INVALID_DT
         OR B.EFFECT_DT BETWEEN A.EFFECT_DT AND A.INVALID_DT
         OR B.INVALID_DT BETWEEN A.EFFECT_DT AND A.INVALID_DT)
     AND A.BASE_RAT_TYPE_ID IS NULL
   WHERE A.EFFECT_DT <= A.INVALID_DT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '取出支行配置的数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP';
  INSERT INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP
    (LADR_SEQ_NUM              --阶梯序号
    ,LP_ID                     --法人编号
    ,ORG_ID                    --机构编号
    ,CURR_CD                   --币种代码
    ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
    ,YEAR_BASE_DAYS            --年基准天数
    ,EFFECT_DT                 --生效日期
    ,INVALID_DT                --失效日期
    ,BASE_RAT_TYPE_ID          --基准利率类型编号
    ,BASE_EXCH_RAT             --基础汇率
    ,PED_FREQ_CD               --周期频率代码
    ,EH_ISSUE_DAYS             --每期天数
    ,LADR_AMT                  --阶梯金额
    ,BANK_INT_INT_RAT          --行内利率
    ,INT_RAT_DISCNT            --利率折扣
    ,FLOAT_RATIO               --浮动比例
    ,FLOAT_POINT               --浮动点数
    ,MAX_CU_RATIO              --最大上浮比例
    ,MIN_CU_RATIO              --最小上浮比例
    ,MIN_INT_RAT               --最小利率
    ,MAX_INT_RAT               --最大利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,MIN_FLOAT_POINT           --浮动点差下限
    ,MAX_FLOAT_RATIO           --最大下浮比例
    ,MIN_FLOAT_RATIO           --最小下浮比例
    ,START_DT                  --开始时间
    ,END_DT                    --结束时间
    ,ID_MARK                   --增删标志
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    ,ETL_TIMESTAMP             --ETL处理时间戳
    )
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,T.EFFECT_DT                 --生效日期
        ,T.INVALID_DT                --失效日期
        ,T.BASE_RAT_TYPE_ID          --基准利率类型编号
        ,T.BASE_EXCH_RAT             --基础汇率
        ,T.PED_FREQ_CD               --周期频率代码
        ,T.EH_ISSUE_DAYS             --每期天数
        ,T.LADR_AMT                  --阶梯金额
        ,T.BANK_INT_INT_RAT          --行内利率
        ,T.INT_RAT_DISCNT            --利率折扣
        ,T.FLOAT_RATIO               --浮动比例
        ,T.FLOAT_POINT               --浮动点数
        ,T.MAX_CU_RATIO              --最大上浮比例
        ,T.MIN_CU_RATIO              --最小上浮比例
        ,T.MIN_INT_RAT               --最小利率
        ,T.MAX_INT_RAT               --最大利率
        ,T.MAX_FLOAT_POINT           --浮动点差上限
        ,T.MIN_FLOAT_POINT           --浮动点差下限
        ,T.MAX_FLOAT_RATIO           --最大下浮比例
        ,T.MIN_FLOAT_RATIO           --最小下浮比例
        ,T.START_DT                  --开始时间
        ,T.END_DT                    --结束时间
        ,T.ID_MARK                   --增删标志
        ,T.SRC_TABLE_NAME            --源表名称
        ,T.JOB_CD                    --任务编码
        ,T.ETL_TIMESTAMP          
    FROM IML.V_REF_BANK_INT_LADR_H T  --视图-行内利率阶梯历史
   INNER JOIN ICL.V_CMM_INTNAL_ORG_INFO TB
      ON TB.ORG_ID = T.ORG_ID
     AND TRIM(TB.ACCTI_SUPER_ORG_ID) <> '800001' --取支行机构
     AND TB.ACCTI_ORG_FLG = '1'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入支行数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_REF_BANK_INT_LADR_H
    (LADR_SEQ_NUM              --阶梯序号
    ,LP_ID                     --法人编号
    ,ORG_ID                    --机构编号
    ,CURR_CD                   --币种代码
    ,BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
    ,YEAR_BASE_DAYS            --年基准天数
    ,EFFECT_DT                 --生效日期
    ,INVALID_DT                --失效日期
    ,BASE_RAT_TYPE_ID          --基准利率类型编号
    ,BASE_EXCH_RAT             --基础汇率
    ,PED_FREQ_CD               --周期频率代码
    ,EH_ISSUE_DAYS             --每期天数
    ,LADR_AMT                  --阶梯金额
    ,BANK_INT_INT_RAT          --行内利率
    ,INT_RAT_DISCNT            --利率折扣
    ,FLOAT_RATIO               --浮动比例
    ,FLOAT_POINT               --浮动点数
    ,MAX_CU_RATIO              --最大上浮比例
    ,MIN_CU_RATIO              --最小上浮比例
    ,MIN_INT_RAT               --最小利率
    ,MAX_INT_RAT               --最大利率
    ,MAX_FLOAT_POINT           --浮动点差上限
    ,MIN_FLOAT_POINT           --浮动点差下限
    ,MAX_FLOAT_RATIO           --最大下浮比例
    ,MIN_FLOAT_RATIO           --最小下浮比例
    ,START_DT                  --开始时间
    ,END_DT                    --结束时间
    ,ID_MARK                   --增删标志
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务编码
    ,ETL_TIMESTAMP             --ETL处理时间戳
    )
  WITH REF_BANK_INT_LADR_H AS (
  --将上级机构的数据拆分到各下级机构
  SELECT /*+MATERIALIZE*/
         TA.LADR_SEQ_NUM,TA.LP_ID,TB.ORG_ID,TA.CURR_CD,TA.BANK_INT_INT_RAT_TYPE_CD,TA.YEAR_BASE_DAYS,TA.EFFECT_DT,
         TA.INVALID_DT,TA.BASE_RAT_TYPE_ID,TA.BASE_EXCH_RAT,TA.PED_FREQ_CD,TA.EH_ISSUE_DAYS,TA.LADR_AMT,TA.BANK_INT_INT_RAT,
         TA.INT_RAT_DISCNT,TA.FLOAT_RATIO,TA.FLOAT_POINT,TA.MAX_CU_RATIO,TA.MIN_CU_RATIO,TA.MIN_INT_RAT,TA.MAX_INT_RAT,
         TA.MAX_FLOAT_POINT,TA.MIN_FLOAT_POINT,TA.MAX_FLOAT_RATIO,TA.MIN_FLOAT_RATIO,TA.START_DT,TA.END_DT,TA.ID_MARK,
         TA.SRC_TABLE_NAME,TA.JOB_CD,TA.ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA --目前里面只有总行和分行的数据
   INNER JOIN ICL.V_CMM_INTNAL_ORG_INFO TB  --只匹配有下级机构的数据
      ON TRIM(TB.ACCTI_SUPER_ORG_ID) = TA.ORG_ID
     AND TB.ACCTI_ORG_FLG = '1'
     AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE TA.ORG_ID <> '800001' --分行
     AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TA.ID_MARK <> 'D'),
   TMP_SJJG_END AS (
   --上级机构的最小开始日期和最大结束日期
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         MIN(T.EFFECT_DT) EFFECT_DT,MAX(T.INVALID_DT) INVALID_DT
    FROM REF_BANK_INT_LADR_H T
   GROUP BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT),
  TMP_XJJG_END AS(
  --下级机构的最小开始、结束日期和最大开始、结束日期
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         MIN(T.EFFECT_DT) MIN_EFFECT_DT,MAX(EFFECT_DT) MAX_EFFECT_DT,
         MIN(T.INVALID_DT) MIN_INVALID_DT,MAX(T.INVALID_DT) MAX_INVALID_DT
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
   GROUP BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT),
  TMP_QS AS (
  --找出下级机构的空缺部分
  SELECT /*+MATERIALIZE*/
         T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.INVALID_DT + 1 AS EFFECT_DT,
         --当前记录结束日期+1为开始日期，下一条记录的开始日期-1为结束日期
         NVL(LEAD(T.EFFECT_DT,1) OVER(PARTITION BY T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT
                                      ORDER BY T.EFFECT_DT)-1,TA.INVALID_DT) AS INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
    LEFT JOIN TMP_SJJG_END TA --定位分组最小最大结束日期
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   UNION ALL
  --获取下级机构本身有配置信息的数据
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,T.EFFECT_DT,T.INVALID_DT,
         T.LADR_SEQ_NUM,T.LP_ID,T.YEAR_BASE_DAYS,T.BASE_RAT_TYPE_ID,T.BASE_EXCH_RAT,T.EH_ISSUE_DAYS,
         T.BANK_INT_INT_RAT,T.INT_RAT_DISCNT,T.FLOAT_RATIO,T.FLOAT_POINT,T.MAX_CU_RATIO,T.MIN_CU_RATIO,
         T.MIN_INT_RAT,T.MAX_INT_RAT,T.MAX_FLOAT_POINT,T.MIN_FLOAT_POINT,T.MAX_FLOAT_RATIO,T.MIN_FLOAT_RATIO,
         T.START_DT,T.END_DT,T.ID_MARK,T.SRC_TABLE_NAME,T.JOB_CD,T.ETL_TIMESTAMP
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T
   UNION ALL
  --获取上级机构比下级机构早配置的数据
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.EFFECT_DT,TA.MIN_EFFECT_DT - 1 INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM TMP_SJJG_END T
    LEFT JOIN TMP_XJJG_END TA
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE T.EFFECT_DT <> TA.MIN_EFFECT_DT
   UNION ALL
  --获取上级机构有配置，但是下级机构没有配置的类型
  SELECT T.ORG_ID,T.CURR_CD,T.BANK_INT_INT_RAT_TYPE_CD,T.PED_FREQ_CD,T.LADR_AMT,
         T.EFFECT_DT,T.INVALID_DT,
         NULL LADR_SEQ_NUM,NULL LP_ID,NULL YEAR_BASE_DAYS,NULL BASE_RAT_TYPE_ID,NULL BASE_EXCH_RAT,NULL EH_ISSUE_DAYS,
         NULL BANK_INT_INT_RAT,NULL INT_RAT_DISCNT,NULL FLOAT_RATIO,NULL FLOAT_POINT,NULL MAX_CU_RATIO,NULL MIN_CU_RATIO,
         NULL MIN_INT_RAT,NULL MAX_INT_RAT,NULL MAX_FLOAT_POINT,NULL MIN_FLOAT_POINT,NULL MAX_FLOAT_RATIO,NULL MIN_FLOAT_RATIO,
         NULL START_DT,NULL END_DT,NULL ID_MARK,NULL SRC_TABLE_NAME,NULL JOB_CD,NULL ETL_TIMESTAMP
    FROM TMP_SJJG_END T
    LEFT JOIN TMP_XJJG_END TA
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE TA.ORG_ID IS NULL)
  SELECT NVL(A.LADR_SEQ_NUM,B.LADR_SEQ_NUM)                       AS LADR_SEQ_NUM              --阶梯序号
        ,NVL(A.LP_ID,B.LP_ID)                                     AS LP_ID                     --法人编号
        ,A.ORG_ID                                                 AS ORG_ID                    --机构编号
        ,A.CURR_CD                                                AS CURR_CD                   --币种代码
        ,A.BANK_INT_INT_RAT_TYPE_CD                               AS BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,NVL(A.YEAR_BASE_DAYS,B.YEAR_BASE_DAYS)                   AS YEAR_BASE_DAYS            --年基准天数
        ,CASE WHEN A.EFFECT_DT < C.EFFECT_DT THEN B.EFFECT_DT --A表最早开始日期缺失
              WHEN A.EFFECT_DT > D.MAX_EFFECT_DT AND A.EFFECT_DT < B.EFFECT_DT THEN B.EFFECT_DT --A表最晚开始日期缺失，且上级机构开始日期晚于下级开始日期
              WHEN A.EFFECT_DT < B.EFFECT_DT THEN B.EFFECT_DT --拆分后的开始日期早于上级机构的开始日期时，取上级机构的开始日期
              ELSE A.EFFECT_DT --否则取拆分后的开始日期
          END                                                     AS EFFECT_DT                 --生效日期
        ,CASE WHEN A.INVALID_DT < D.MIN_EFFECT_DT AND A.INVALID_DT > B.INVALID_DT THEN B.INVALID_DT --拆分后的开始日期小于最早开始日期，且结束日期早于上级机构的结束日期
              WHEN A.INVALID_DT > D.MAX_INVALID_DT THEN B.INVALID_DT --拆分后的结束日期晚于表中的最大结束日期
              WHEN A.INVALID_DT > B.INVALID_DT THEN B.INVALID_DT --拆分后的结束日期晚于上级机构的结束日期
              ELSE A.INVALID_DT --否则取拆分后的开始日期
          END                                                     AS INVALID_DT                --失效日期
        ,NVL(A.BASE_RAT_TYPE_ID,B.BASE_RAT_TYPE_ID)               AS BASE_RAT_TYPE_ID          --基准利率类型编号
        ,NVL(A.BASE_EXCH_RAT,B.BASE_EXCH_RAT)                     AS BASE_EXCH_RAT             --基础汇率
        ,A.PED_FREQ_CD                                            AS PED_FREQ_CD               --周期频率代码
        ,NVL(A.EH_ISSUE_DAYS,B.EH_ISSUE_DAYS)                     AS EH_ISSUE_DAYS             --每期天数
        ,A.LADR_AMT                                               AS LADR_AMT                  --阶梯金额
        ,A.BANK_INT_INT_RAT                                       AS BANK_INT_INT_RAT          --行内利率
        ,NVL(A.INT_RAT_DISCNT,B.INT_RAT_DISCNT)                   AS INT_RAT_DISCNT            --利率折扣
        ,NVL(A.FLOAT_RATIO,B.FLOAT_RATIO)                         AS FLOAT_RATIO               --浮动比例
        ,NVL(A.FLOAT_POINT,B.FLOAT_POINT)                         AS FLOAT_POINT               --浮动点数
        ,NVL(A.MAX_CU_RATIO,B.MAX_CU_RATIO)                       AS MAX_CU_RATIO              --最大上浮比例
        ,NVL(A.MIN_CU_RATIO,B.MIN_CU_RATIO)                       AS MIN_CU_RATIO              --最小上浮比例
        ,NVL(A.MIN_INT_RAT,B.MIN_INT_RAT)                         AS MIN_INT_RAT               --最小利率
        ,NVL(A.MAX_INT_RAT,B.MAX_INT_RAT)                         AS MAX_INT_RAT               --最大利率
        ,NVL(A.MAX_FLOAT_POINT,B.MAX_FLOAT_POINT)                 AS MAX_FLOAT_POINT           --浮动点差上限
        ,NVL(A.MIN_FLOAT_POINT,B.MIN_FLOAT_POINT)                 AS MIN_FLOAT_POINT           --浮动点差下限
        ,NVL(A.MAX_FLOAT_RATIO,B.MAX_FLOAT_RATIO)                 AS MAX_FLOAT_RATIO           --最大下浮比例
        ,NVL(A.MIN_FLOAT_RATIO,B.MIN_FLOAT_RATIO)                 AS MIN_FLOAT_RATIO           --最小下浮比例
        ,NVL(A.START_DT,B.START_DT)                               AS START_DT                  --开始时间
        ,NVL(A.END_DT,B.END_DT)                                   AS END_DT                    --结束时间
        ,NVL(A.ID_MARK,B.ID_MARK)                                 AS ID_MARK                   --增删标志
        ,NVL(A.SRC_TABLE_NAME,B.SRC_TABLE_NAME)                   AS SRC_TABLE_NAME            --源表名称
        ,NVL(A.JOB_CD,B.JOB_CD)                                   AS JOB_CD                    --任务编码
        ,NVL(A.ETL_TIMESTAMP,B.ETL_TIMESTAMP)                     AS ETL_TIMESTAMP             --ETL处理时间戳
    FROM TMP_QS A --补充后的下级机构
    LEFT JOIN TMP_SJJG_END C  --上级机构的最大最小数据
      ON C.ORG_ID = A.ORG_ID
     AND C.CURR_CD = A.CURR_CD
     AND C.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND C.PED_FREQ_CD = A.PED_FREQ_CD
     AND C.LADR_AMT = A.LADR_AMT
    LEFT JOIN TMP_XJJG_END D --下级机构的最大最小数据
      ON D.ORG_ID = A.ORG_ID
     AND D.CURR_CD = A.CURR_CD
     AND D.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND D.PED_FREQ_CD = A.PED_FREQ_CD
     AND D.LADR_AMT = A.LADR_AMT
    LEFT JOIN REF_BANK_INT_LADR_H B --上级机构
      ON B.ORG_ID = A.ORG_ID
     AND B.CURR_CD = A.CURR_CD
     AND B.BANK_INT_INT_RAT_TYPE_CD = A.BANK_INT_INT_RAT_TYPE_CD
     AND B.PED_FREQ_CD = A.PED_FREQ_CD
     AND B.LADR_AMT = A.LADR_AMT
     AND (A.EFFECT_DT BETWEEN B.EFFECT_DT AND B.INVALID_DT
         OR A.INVALID_DT BETWEEN B.EFFECT_DT AND B.INVALID_DT
         OR B.EFFECT_DT BETWEEN A.EFFECT_DT AND A.INVALID_DT
         OR B.INVALID_DT BETWEEN A.EFFECT_DT AND A.INVALID_DT)
     AND A.BASE_RAT_TYPE_ID IS NULL
   WHERE A.EFFECT_DT <= A.INVALID_DT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_REF_BANK_INT_LADR_H;
/

