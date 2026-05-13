CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_BANK_INT_LADR_H_BAK20250114(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
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

  /*-- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-行内利率阶梯历史';
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
    FROM IML.V_REF_BANK_INT_LADR_H T  --视图-行内利率阶梯历史
   WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  --MOD BY 20240607
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入有单独配置利率的机构数据';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_BANK_INT_LADR_H';
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
   WHERE T.ORG_ID NOT IN ('800001')
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
  V_STEP_DESC := '给分行有配置信息的支行赋值';
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
  WITH INTNAL_ORG_INFO(ORG_ID,SUPER_ORG,SUPER_ORG1) AS (
  SELECT /*+MATERIALIZE*/T.ORG_ID,TRIM(T.ACCTI_SUPER_ORG_ID) SUPER_ORG,
         NVL(TRIM(TA.ACCTI_SUPER_ORG_ID),'800001') SUPER_ORG1
    FROM ICL.V_CMM_INTNAL_ORG_INFO T
    LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO TA
      ON TA.ORG_ID = NVL(TRIM(T.ACCTI_SUPER_ORG_ID),'800001')
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.ACCTI_ORG_FLG = '1'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,TB.ORG_ID                   --机构编号
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
   INNER JOIN INTNAL_ORG_INFO TB
      ON TB.SUPER_ORG = T.ORG_ID
     AND TB.SUPER_ORG <> '800001'
     AND TB.ORG_ID <> '800001'
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
  V_STEP_DESC := '插入分行有配置的支行机构但是期限不全的插入表中';
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
  WITH REF_BANK_INT_LADR_H AS (
   SELECT /*+MATERIALIZE*/ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT,
          MIN(TA.EFFECT_DT) EFFECT_DT,MAX(TA.INVALID_DT) INVALID_DT
     FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA
    WHERE TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT)
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,T.EFFECT_DT                 --生效日期
        ,CASE WHEN T.INVALID_DT >= TA.EFFECT_DT - 1 THEN TA.EFFECT_DT - 1
              ELSE T.INVALID_DT
          END INVALID_DT             --失效日期
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
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T  --行内利率阶梯历史
    LEFT JOIN REF_BANK_INT_LADR_H TA  --行内利率阶梯历史
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE (T.EFFECT_DT <= TA.EFFECT_DT - 1 OR TA.ORG_ID IS NULL)
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入分行有配置的支行机构但是期限不全的插入表中2';
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
  WITH REF_BANK_INT_LADR_H AS (
   SELECT /*+MATERIALIZE*/ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT,
          MIN(TA.EFFECT_DT) EFFECT_DT,MAX(TA.INVALID_DT) INVALID_DT
     FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA
    WHERE TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT)
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,CASE WHEN T.EFFECT_DT <= TA.INVALID_DT + 1 THEN TA.INVALID_DT + 1
              ELSE T.EFFECT_DT
          END EFFECT_DT              --生效日期
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
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T  --行内利率阶梯历史
    LEFT JOIN REF_BANK_INT_LADR_H TA  --行内利率阶梯历史
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE (T.INVALID_DT >= TA.INVALID_DT + 1 OR TA.ORG_ID IS NULL)
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '将所有机构都按800001机构的格式拆分数据';
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
  WITH INTNAL_ORG_INFO(ORG_ID,SUPER_ORG,SUPER_ORG1) AS (
  SELECT /*+MATERIALIZE*/T.ORG_ID,TRIM(T.ACCTI_SUPER_ORG_ID) SUPER_ORG,
         NVL(TRIM(TA.ACCTI_SUPER_ORG_ID),'800001') SUPER_ORG1
    FROM ICL.V_CMM_INTNAL_ORG_INFO T
    LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO TA
      ON TA.ORG_ID = NVL(TRIM(T.ACCTI_SUPER_ORG_ID),'800001')
     AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.ACCTI_ORG_FLG = '1'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,TB.ORG_ID                   --机构编号
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
    LEFT JOIN INTNAL_ORG_INFO TB
      ON 1 = 1
   WHERE T.ORG_ID = '800001'
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
  V_STEP_DESC := '插入配置了机构但是期限不全的数据且生效日期小于已有生效日期的';
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
  WITH REF_BANK_INT_LADR_H AS (
   SELECT /*+MATERIALIZE*/ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT,
          MIN(TA.EFFECT_DT) EFFECT_DT,MAX(TA.INVALID_DT) INVALID_DT
     FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA
    WHERE TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT)
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,T.EFFECT_DT                 --生效日期
        ,CASE WHEN T.INVALID_DT >= TA.EFFECT_DT - 1 THEN TA.EFFECT_DT - 1
              ELSE T.INVALID_DT
          END INVALID_DT             --失效日期
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
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T  --行内利率阶梯历史
    LEFT JOIN REF_BANK_INT_LADR_H TA  --行内利率阶梯历史
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     --AND TA.BASE_RAT_TYPE_ID = T.BASE_RAT_TYPE_ID
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE (T.EFFECT_DT <= TA.EFFECT_DT - 1 OR TA.ORG_ID IS NULL)
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入配置了机构但是期限不全的数据且失效日期小于已有失效日期的2';
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
  WITH REF_BANK_INT_LADR_H AS (
   SELECT /*+MATERIALIZE*/ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT,
          MIN(TA.EFFECT_DT) EFFECT_DT,MAX(TA.INVALID_DT) INVALID_DT
     FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H TA
    WHERE TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY ORG_ID,CURR_CD,BANK_INT_INT_RAT_TYPE_CD,PED_FREQ_CD,LADR_AMT)
  SELECT T.LADR_SEQ_NUM              --阶梯序号
        ,T.LP_ID                     --法人编号
        ,T.ORG_ID                    --机构编号
        ,T.CURR_CD                   --币种代码
        ,T.BANK_INT_INT_RAT_TYPE_CD  --行内利率类型代码
        ,T.YEAR_BASE_DAYS            --年基准天数
        ,CASE WHEN T.EFFECT_DT <= TA.INVALID_DT + 1 THEN TA.INVALID_DT + 1
              ELSE T.EFFECT_DT
          END EFFECT_DT              --生效日期
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
    FROM RRP_MDL.O_IML_REF_BANK_INT_LADR_H_TMP T  --行内利率阶梯历史
    LEFT JOIN REF_BANK_INT_LADR_H TA  --行内利率阶梯历史
      ON TA.ORG_ID = T.ORG_ID
     AND TA.CURR_CD = T.CURR_CD
     AND TA.BANK_INT_INT_RAT_TYPE_CD = T.BANK_INT_INT_RAT_TYPE_CD
     --AND TA.BASE_RAT_TYPE_ID = T.BASE_RAT_TYPE_ID
     AND TA.PED_FREQ_CD = T.PED_FREQ_CD
     AND TA.LADR_AMT = T.LADR_AMT
   WHERE (T.INVALID_DT >= TA.INVALID_DT + 1 OR TA.ORG_ID IS NULL)
     AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

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

END ETL_O_IML_REF_BANK_INT_LADR_H_BAK20250114;
/

