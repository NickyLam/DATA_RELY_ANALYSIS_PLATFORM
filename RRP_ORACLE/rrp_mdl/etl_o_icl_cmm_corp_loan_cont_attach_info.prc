CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO(I_P_DATE IN INTEGER,
                                                                             O_ERRCODE  OUT VARCHAR2
                                                                             )
/**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO
  *  功能描述：对公贷款合同补充信息
  *  创建日期：20220408
  *  开发人员：陈宜玲
  *  来源表： ICL.V_CMM_CORP_LOAN_CONT_ATTACH_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             
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
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.'||V_TAB_NAME;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公贷款合同补充信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO NOLOGGING
    ( ETL_DT                                   --数据日期
      ,LP_ID                                   --法人编号
      ,CONT_ID                                 --合同编号
      ,CONT_NAME                               --合同名称
      ,CONT_TYPE_CD                            --合同类型代码
      ,MARGIN_INT_RAT                          --保证金利率
      ,GOVER_CRDT_SUPT_WAY_CD                  --政府授信支持方式代码
      ,GOVER_CRDT_TYPE_CD                      --政府授信类型代码
      ,CDB_CRDT_BREED_CD                       --国开授信品种代码
      ,LOAN_CHAR_CD                            --贷款性质代码
      ,INVEST_CHAR_CD                          --投资性质代码
      ,MARGIN_INT_RAT_TYPE_CD                  --保证金利率类型代码
      ,MARGIN_INT_ACCR_METHOD_CD               --保证金计息方法代码
      ,M_L_CLAUS_EXIST_FLG                     --溢短装条款存在标志
      ,OBANK_OPEN_FLG                          --他行代开标志
      ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG    --三旧改造或城市更新项目标志
      ,OVERS_LOAN_FLG                          --境外贷款标志
      ,CONT_BEGIN_DT                           --合同起始日期
      ,CONT_EXP_DT                             --合同到期日期
      ,START_WORK_DT                           --开工日期
      ,BATCH_NO                                --批文文号
      ,PLAN_LICS_ID                            --规划许可证编号
      ,ARCH_LAND_LICS_ID                       --建设用地许可证编号
      ,ENVIR_IM_ASS_LICS_ID                    --环评许可证编号
      ,CNSTR_LICS_ID                           --施工许可证编号
      ,OTHER_LICS_ID                           --其他许可证编号
      ,NCDS_NUM                                --同业存单号码
      ,MARGIN_TRAN_OUT_ACCT_NUM                --保证金转出账号
      ,BUS_INFO_DESC                           --业务信息描述
      ,BACK_INFO_DESCB                         --背景信息描述
      ,CARGO_NAME                              --货物名称
      ,CLS_FREQ                                --分类频率
      ,M_L_RATIO                               --溢短装比例
      ,PROJ_TOT_INVEST                         --项目总投资
      ,CAPITAL                                 --资本金
      ,SETUP_PROJ_BATCH_FILE                   --立项批文
      ,OTHER_LICS                              --其他许可证
      ,NCDS_ABBR                               --同业存单简称
      ,MARGIN_INT_RAT_LEVEL                    --保证金利率档次
      ,LAND_USE_CERT_ID                        --土地使用证编号
      ,LAND_USE_CERT_DT                        --土地使用证日期
      ,LAND_PLAN_LICS_ID                       --用地规划许可证编号
      ,LAND_PLAN_LICS_DT                       --用地规划许可证日期
      ,CNSTR_LICS_DT                           --施工许可证日期
      ,PROJ_PLAN_LICS_DT                       --工程规划许可证日期
      ,BUYER_NAME                              --购货方名称
      ,SELLER_NAME                             --销货方名称
      ,TRADE_TRAN_CONTENT                      --贸易交易内容
      ,STAT_USE_OPEN_BAL                       --统计用敞口余额
      ,COMMER_INV_INFO_DESC                    --商业发票信息描述
      ,COMMER_INV_CURR_CD                      --商业发票币种代码
      ,COMMER_INV_AMT                          --商业发票金额
      ,COMMER_INV_KIND_CD                      --商业发票种类代码
      ,JOB_CD                                  --任务代码
     )
  SELECT ETL_DT                                   --数据日期
         ,LP_ID                                   --法人编号
         ,REPLACE(REPLACE(CONT_ID,CHR(10),''),CHR(13),'')              AS CONT_ID               --合同编号
         ,REPLACE(REPLACE(CONT_NAME,CHR(10),''),CHR(13),'')            AS CONT_NAME             --合同名称
         ,CONT_TYPE_CD                            --合同类型代码
         ,MARGIN_INT_RAT                          --保证金利率
         ,GOVER_CRDT_SUPT_WAY_CD                  --政府授信支持方式代码
         ,GOVER_CRDT_TYPE_CD                      --政府授信类型代码
         ,CDB_CRDT_BREED_CD                       --国开授信品种代码
         ,LOAN_CHAR_CD                            --贷款性质代码
         ,INVEST_CHAR_CD                          --投资性质代码
         ,MARGIN_INT_RAT_TYPE_CD                  --保证金利率类型代码
         ,MARGIN_INT_ACCR_METHOD_CD               --保证金计息方法代码
         ,M_L_CLAUS_EXIST_FLG                     --溢短装条款存在标志
         ,OBANK_OPEN_FLG                          --他行代开标志
         ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG    --三旧改造或城市更新项目标志
         ,OVERS_LOAN_FLG                          --境外贷款标志
         ,CONT_BEGIN_DT                           --合同起始日期
         ,CONT_EXP_DT                             --合同到期日期
         ,START_WORK_DT                           --开工日期
         ,REPLACE(REPLACE(BATCH_NO,CHR(10),''),CHR(13),'')             AS BATCH_NO               --批文文号
         ,REPLACE(REPLACE(PLAN_LICS_ID,CHR(10),''),CHR(13),'')         AS PLAN_LICS_ID           --规划许可证编号
         ,REPLACE(REPLACE(ARCH_LAND_LICS_ID,CHR(10),''),CHR(13),'')    AS ARCH_LAND_LICS_ID      --建设用地许可证编号
         ,REPLACE(REPLACE(ENVIR_IM_ASS_LICS_ID,CHR(10),''),CHR(13),'') AS ENVIR_IM_ASS_LICS_ID   --环评许可证编号
         ,REPLACE(REPLACE(CNSTR_LICS_ID,CHR(10),''),CHR(13),'')        AS CNSTR_LICS_ID          --施工许可证编号
         ,REPLACE(REPLACE(OTHER_LICS_ID,CHR(10),''),CHR(13),'')        AS OTHER_LICS_ID          --其他许可证编号
         ,REPLACE(REPLACE(NCDS_NUM,CHR(10),''),CHR(13),'')             AS NCDS_NUM               --同业存单号码
         ,REPLACE(REPLACE(MARGIN_TRAN_OUT_ACCT_NUM,CHR(10),''),CHR(13),'') AS MARGIN_TRAN_OUT_ACCT_NUM --保证金转出账号
         ,REPLACE(REPLACE(BUS_INFO_DESC,CHR(10),''),CHR(13),'')        AS BUS_INFO_DESC          --业务信息描述
         ,REPLACE(REPLACE(BACK_INFO_DESCB,CHR(10),''),CHR(13),'')      AS BACK_INFO_DESCB        --背景信息描述
         ,REPLACE(REPLACE(CARGO_NAME,CHR(10),''),CHR(13),'')           AS CARGO_NAME             --货物名称
         ,CLS_FREQ                                --分类频率
         ,M_L_RATIO                               --溢短装比例
         ,PROJ_TOT_INVEST                         --项目总投资
         ,CAPITAL                                 --资本金
         ,REPLACE(REPLACE(SETUP_PROJ_BATCH_FILE,CHR(10),''),CHR(13),'') AS SETUP_PROJ_BATCH_FILE --立项批文
         ,REPLACE(REPLACE(OTHER_LICS,CHR(10),''),CHR(13),'')            AS OTHER_LICS            --其他许可证
         ,REPLACE(REPLACE(NCDS_ABBR,CHR(10),''),CHR(13),'')             AS NCDS_ABBR             --同业存单简称
         ,MARGIN_INT_RAT_LEVEL                    --保证金利率档次
         ,REPLACE(REPLACE(LAND_USE_CERT_ID,CHR(10),''),CHR(13),'')      AS LAND_USE_CERT_ID      --土地使用证编号
         ,LAND_USE_CERT_DT                        --土地使用证日期
         ,REPLACE(REPLACE(LAND_PLAN_LICS_ID,CHR(10),''),CHR(13),'')     AS LAND_PLAN_LICS_ID     --用地规划许可证编号
         ,LAND_PLAN_LICS_DT                       --用地规划许可证日期
         ,CNSTR_LICS_DT                           --施工许可证日期
         ,PROJ_PLAN_LICS_DT                       --工程规划许可证日期
         ,REPLACE(REPLACE(BUYER_NAME,CHR(10),''),CHR(13),'')            AS BUYER_NAME            --购货方名称
         ,REPLACE(REPLACE(SELLER_NAME,CHR(10),''),CHR(13),'')           AS SELLER_NAME           --销货方名称
         ,REPLACE(REPLACE(TRADE_TRAN_CONTENT,CHR(10),''),CHR(13),'')    AS TRADE_TRAN_CONTENT    --贸易交易内容
         ,STAT_USE_OPEN_BAL                       --统计用敞口余额
         ,REPLACE(REPLACE(COMMER_INV_INFO_DESC,CHR(10),''),CHR(13),'')  AS COMMER_INV_INFO_DESC  --商业发票信息描述
         ,COMMER_INV_CURR_CD                      --商业发票币种代码
         ,COMMER_INV_AMT                          --商业发票金额
         ,COMMER_INV_KIND_CD                      --商业发票种类代码
         ,JOB_CD                                  --任务代码
    FROM ICL.V_CMM_CORP_LOAN_CONT_ATTACH_INFO --对公贷款合同补充信息_视图
   WHERE ETL_DT = TO_DATE(I_P_DATE, 'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_CORP_LOAN_CONT_ATTACH_INFO;
/

