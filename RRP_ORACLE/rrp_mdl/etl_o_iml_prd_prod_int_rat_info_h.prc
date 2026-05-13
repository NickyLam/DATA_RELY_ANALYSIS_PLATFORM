CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PRD_PROD_INT_RAT_INFO_H(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_IML_PRD_PROD_INT_RAT_INFO_H
  *  功能描述：产品利率信息历史
  *  创建日期：20230728
  *  开发人员：HULIJUAN
  *  来源表： IML.V_PRD_PROD_INT_RAT_INFO_H
  *  目标表： O_IML_PRD_PROD_INT_RAT_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1     20230825  LIP      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PRD_PROD_INT_RAT_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PRD_PROD_INT_RAT_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PRD_PROD_INT_RAT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-产品利率信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PRD_PROD_INT_RAT_INFO_H
    (LP_ID                          --法人编号
    ,PROD_ID                        --产品编号
    ,EVT_CATE_ID                    --事件类别编号
    ,INT_CLS_CD                     --利息分类代码
    ,INT_RAT_TYPE_CD                --利率类型代码
    ,TAX_CATEGORY_CD                --税种代码
    ,USE_SUB_ACCT_INT_RAT_FLG       --使用分户利率标志
    ,INT_ACCR_WAY_CD                --计息方式代码
    ,INT_RAT_FILE_WAY_CD            --利率靠档方式代码
    ,FILE_AMT_TYPE_CD               --靠档金额类型代码
    ,AMT_FILE_DIR_CD                --金额靠档方向代码
    ,AMT_FILE_WAY_CD                --金额靠档方式代码
    ,DAYS_FILE_DIR_CD               --天数靠档方向代码
    ,DAYS_FILE_WAY_CD               --天数靠档方式代码
    ,INT_CALC_AMT_TYPE_CD           --利息计算金额类型代码
    ,VALUE_DAY_GET_VAL_WAY_CD       --起息日取值方式代码
    ,FILE_DAYS_CALC_WAY_CD          --靠档天数计算方式代码
    ,INT_RAT_START_USE_WAY_CD       --利率启用方式代码
    ,MON_INT_ACCR_BASE_CD           --月计息基准代码
    ,GROUPING_RULE_RELA_CD          --分组规则关系代码
    ,INT_DTL_EFFECT_WAY_CD          --利息明细生效方式代码
    ,INT_MODIF_WAY_CD               --利息重算方式代码
    ,MIN_INT_RAT                    --最小利率
    ,MAX_INT_RAT                    --最大利率
    ,INT_RAT_MODIF_DAY              --利率变更日
    ,INT_RAT_MODIF_PED_CD           --利率变更周期代码
    ,SUBSTR_FLG                     --截位标志
    ,START_DT                       --开始时间
    ,END_DT                         --结束时间
    ,ID_MARK                        --增删标志
    ,SRC_TABLE_NAME                 --源表名称
    ,JOB_CD                         --任务编码
    ,ETL_TIMESTAMP                  --ETL处理时间戳
    )
  SELECT LP_ID                          --法人编号
        ,PROD_ID                        --产品编号
        ,EVT_CATE_ID                    --事件类别编号
        ,INT_CLS_CD                     --利息分类代码
        ,INT_RAT_TYPE_CD                --利率类型代码
        ,TAX_CATEGORY_CD                --税种代码
        ,USE_SUB_ACCT_INT_RAT_FLG       --使用分户利率标志
        ,INT_ACCR_WAY_CD                --计息方式代码
        ,INT_RAT_FILE_WAY_CD            --利率靠档方式代码
        ,FILE_AMT_TYPE_CD               --靠档金额类型代码
        ,AMT_FILE_DIR_CD                --金额靠档方向代码
        ,AMT_FILE_WAY_CD                --金额靠档方式代码
        ,DAYS_FILE_DIR_CD               --天数靠档方向代码
        ,DAYS_FILE_WAY_CD               --天数靠档方式代码
        ,INT_CALC_AMT_TYPE_CD           --利息计算金额类型代码
        ,VALUE_DAY_GET_VAL_WAY_CD       --起息日取值方式代码
        ,FILE_DAYS_CALC_WAY_CD          --靠档天数计算方式代码
        ,INT_RAT_START_USE_WAY_CD       --利率启用方式代码
        ,MON_INT_ACCR_BASE_CD           --月计息基准代码
        ,GROUPING_RULE_RELA_CD          --分组规则关系代码
        ,INT_DTL_EFFECT_WAY_CD          --利息明细生效方式代码
        ,INT_MODIF_WAY_CD               --利息重算方式代码
        ,MIN_INT_RAT                    --最小利率
        ,MAX_INT_RAT                    --最大利率
        ,INT_RAT_MODIF_DAY              --利率变更日
        ,INT_RAT_MODIF_PED_CD           --利率变更周期代码
        ,SUBSTR_FLG                     --截位标志
        ,START_DT                       --开始时间
        ,END_DT                         --结束时间
        ,ID_MARK                        --增删标志
        ,SRC_TABLE_NAME                 --源表名称
        ,JOB_CD                         --任务编码
        ,ETL_TIMESTAMP                  --ETL处理时间戳
    FROM IML.V_PRD_PROD_INT_RAT_INFO_H --视图-产品利率信息历史
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_PRD_PROD_INT_RAT_INFO_H;
/

