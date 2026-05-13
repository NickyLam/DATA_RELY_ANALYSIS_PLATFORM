CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AST_COL_GUAR_CORP_ENSURE(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AST_COL_GUAR_CORP_ENSURE
  *  功能描述：押品担保公司保证
  *  创建日期：20220318
  *  开发人员：易梓林
  *  来源表：
  *  目标表： O_IML_AST_COL_GUAR_CORP_ENSURE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220318  易梓林   首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AST_COL_GUAR_CORP_ENSURE'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AST_COL_GUAR_CORP_ENSURE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品担保公司保证';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AST_COL_GUAR_CORP_ENSURE NOLOGGING
    (ASSET_ID                              --资产编号
    ,LP_ID                                 --法人编号
    ,GUARTOR_TYPE_CD                       --保证人类型代码
    ,GUARTOR_ID                            --保证人编号
    ,GUARTOR_NAME                          --保证人名称
    ,GUARTOR_ORGNZ_CD                      --保证人组织机构代码
    ,GUARTOR_NAT_STD_INDUS_CLS_CD          --保证人国标行业分类代码
    ,GUARTOR_NET_ASSET_AMT                 --保证人净资产金额
    ,GUARTOR_ECON_COMPNT_CD                --保证人经济成分代码
    ,GUARTOR_GUAR_INDEP_CD                 --保证人担保独立性代码
    ,GUARTOR_RGST_CD                       --保证人注册地代码
    ,GUARTOR_RGST_EXT_RATING_CD            --保证人注册地外部评级结果代码
    ,GUARTOR_EXT_RATING_DT                 --保证人外部评级日期
    ,GUARTOR_EXT_RATING_REST_CD            --保证人外部评级结果代码
    ,GUARTOR_INTNAL_RATING_DT              --保证人内部评级日期
    ,GUARTOR_INTNAL_RATING_REST_CD         --保证人内部评级结果代码
    ,GUAR_AIM_CD                           --保证目的代码
    ,STAGE_GUAR_FLG                        --阶段性担保标志
    ,GUAR_CORP_MARGIN_AMT                  --担保公司保证金金额
    ,OTHER_COMNT                           --其他说明
    ,GUAR_TOT_AMT                          --担保总额度
    ,CURR_CD                               --币种代码
    ,RESDNT_FLG                            --是否居民标志
    ,CREATE_DT                             --创建日期
    ,UPDATE_DT                             --更新日期
    ,ETL_DT                                --数据日期
    ,ID_MARK                               --删除标识
    ,SRC_TABLE_NAME                        --源表名称
    ,JOB_CD                                --任务代码
    )
  SELECT /*+PARALLEL*/
         ASSET_ID                              --资产编号
        ,LP_ID                                 --法人编号
        ,GUARTOR_TYPE_CD                       --保证人类型代码
        ,GUARTOR_ID                            --保证人编号
        ,GUARTOR_NAME                          --保证人名称
        ,GUARTOR_ORGNZ_CD                      --保证人组织机构代码
        ,GUARTOR_NAT_STD_INDUS_CLS_CD          --保证人国标行业分类代码
        ,GUARTOR_NET_ASSET_AMT                 --保证人净资产金额
        ,GUARTOR_ECON_COMPNT_CD                --保证人经济成分代码
        ,GUARTOR_GUAR_INDEP_CD                 --保证人担保独立性代码
        ,GUARTOR_RGST_CD                       --保证人注册地代码
        ,GUARTOR_RGST_EXT_RATING_CD            --保证人注册地外部评级结果代码
        ,GUARTOR_EXT_RATING_DT                 --保证人外部评级日期
        ,GUARTOR_EXT_RATING_REST_CD            --保证人外部评级结果代码
        ,GUARTOR_INTNAL_RATING_DT              --保证人内部评级日期
        ,GUARTOR_INTNAL_RATING_REST_CD         --保证人内部评级结果代码
        ,GUAR_AIM_CD                           --保证目的代码
        ,STAGE_GUAR_FLG                        --阶段性担保标志
        ,GUAR_CORP_MARGIN_AMT                  --担保公司保证金金额
        ,OTHER_COMNT                           --其他说明
        ,GUAR_TOT_AMT                          --担保总额度
        ,CURR_CD                               --币种代码
        ,RESDNT_FLG                            --是否居民标志
        ,CREATE_DT                             --创建日期
        ,UPDATE_DT                             --更新日期
        ,ETL_DT                                --数据日期
        ,ID_MARK                               --删除标识
        ,SRC_TABLE_NAME                        --源表名称
        ,JOB_CD                                --任务代码
    FROM IML.V_AST_COL_GUAR_CORP_ENSURE   --押品担保公司保证_视图
   /*WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/; --BY CHENRUIQIANG 2020-08-04 因联合网贷数据是T+2供数，因此需要-1

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AST_COL_GUAR_CORP_ENSURE', '', O_ERRCODE);

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

END ETL_O_IML_AST_COL_GUAR_CORP_ENSURE;
/

