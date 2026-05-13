CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO
  *  功能描述：对公贷款业务合同补充信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款业务合同补充信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,LMT_CONT_ID  --额度合同编号
      ,CONT_NAME  --合同名称
      ,CONT_TYPE_CD  --合同类型代码
      ,MARGIN_INT_RAT  --保证金利率
      ,GOVER_CRDT_FLG  --政府授信标志
      ,GOVER_CRDT_SUPT_WAY_CD  --政府授信支持方式代码
      ,GOVER_CRDT_TYPE_CD  --政府授信类型代码
      ,CDB_CRDT_BREED_CD  --国开授信品种代码
      ,LOAN_CHAR_CD  --贷款性质代码
      ,INVEST_CHAR_CD  --投资性质代码
      ,MARGIN_INT_RAT_TYPE_CD  --保证金利率类型代码
      ,MARGIN_INT_ACCR_METHOD_CD  --保证金计息方法代码
      ,M_L_CLAUS_EXIST_FLG  --溢短装条款存在标志
      ,OBANK_OPEN_FLG  --他行代开标志
      ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG  --三旧改造或城市更新项目标志
      ,CONT_BEGIN_DT  --合同起始日期
      ,CONT_EXP_DT  --合同到期日期
      ,START_WORK_DT  --开工日期
      ,BATCH_NO  --批文文号
      ,PLAN_LICS_ID  --规划许可证编号
      ,ARCH_LAND_LICS_ID  --建设用地许可证编号
      ,ENVIR_IM_ASS_LICS_ID  --环评许可证编号
      ,CNSTR_LICS_ID  --施工许可证编号
      ,OTHER_LICS_ID  --其他许可证编号
      ,NCDS_NUM  --同业存单号码
      ,MARGIN_TRAN_OUT_ACCT_NUM  --保证金转出账号
      ,BUS_INFO_DESC  --业务信息描述
      ,BACK_INFO_DESCB  --背景信息描述
      ,CARGO_NAME  --货物名称
      ,CLS_FREQ  --分类频率
      ,M_L_RATIO  --溢短装比例
      ,PROJ_TOT_INVEST  --项目总投资
      ,CAPITAL  --资本金
      ,SETUP_PROJ_BATCH_FILE  --立项批文
      ,OTHER_LICS  --其他许可证
      ,NCDS_ABBR  --同业存单简称
      ,MARGIN_INT_RAT_LEVEL  --保证金利率档次
      ,LAND_USE_CERT_ID  --土地使用证编号
      ,LAND_USE_CERT_DT  --土地使用证日期
      ,LAND_PLAN_LICS_ID  --用地规划许可证编号
      ,LAND_PLAN_LICS_DT  --用地规划许可证日期
      ,CNSTR_LICS_DT  --施工许可证日期
      ,PROJ_PLAN_LICS_DT  --工程规划许可证日期
      ,BUYER_NAME  --购货方名称
      ,SELLER_NAME  --销货方名称
      ,TRADE_TRAN_CONTENT  --贸易交易内容
      ,STAT_USE_OPEN_BAL  --统计用敞口余额
      ,COMMER_INV_INFO_DESC  --商业发票信息描述
      ,COMMER_INV_CURR_CD  --商业发票币种代码
      ,COMMER_INV_AMT  --商业发票金额
      ,COMMER_INV_KIND_CD  --商业发票种类代码
      ,JOB_CD --任务代码
      ,ADV_MAN_INDU_FLG --先进制造业标志
      ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
      ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
      ,CUL_PROPERTY_FLG --文化产业标志
      ,INDU_CORP_TECH_REM_UGD_FLG --工业企业技术改造升级标志
      ,STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码
      ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
      ,SCI_TECH_CORP_FLG  --科技型企业标志
      ,SCI_TECH_INOVT_CORP_FLG --科创企业标志
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CONT_ID  --合同编号
      ,LMT_CONT_ID  --额度合同编号
      ,CONT_NAME  --合同名称
      ,CONT_TYPE_CD  --合同类型代码
      ,MARGIN_INT_RAT  --保证金利率
      ,GOVER_CRDT_FLG  --政府授信标志
      ,GOVER_CRDT_SUPT_WAY_CD  --政府授信支持方式代码
      ,GOVER_CRDT_TYPE_CD  --政府授信类型代码
      ,CDB_CRDT_BREED_CD  --国开授信品种代码
      ,LOAN_CHAR_CD  --贷款性质代码
      ,INVEST_CHAR_CD  --投资性质代码
      ,MARGIN_INT_RAT_TYPE_CD  --保证金利率类型代码
      ,MARGIN_INT_ACCR_METHOD_CD  --保证金计息方法代码
      ,M_L_CLAUS_EXIST_FLG  --溢短装条款存在标志
      ,OBANK_OPEN_FLG  --他行代开标志
      ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG  --三旧改造或城市更新项目标志
      ,CONT_BEGIN_DT  --合同起始日期
      ,CONT_EXP_DT  --合同到期日期
      ,START_WORK_DT  --开工日期
      ,BATCH_NO  --批文文号
      ,PLAN_LICS_ID  --规划许可证编号
      ,ARCH_LAND_LICS_ID  --建设用地许可证编号
      ,ENVIR_IM_ASS_LICS_ID  --环评许可证编号
      ,CNSTR_LICS_ID  --施工许可证编号
      ,OTHER_LICS_ID  --其他许可证编号
      ,NCDS_NUM  --同业存单号码
      ,MARGIN_TRAN_OUT_ACCT_NUM  --保证金转出账号
      ,BUS_INFO_DESC  --业务信息描述
      ,BACK_INFO_DESCB  --背景信息描述
      ,CARGO_NAME  --货物名称
      ,CLS_FREQ  --分类频率
      ,M_L_RATIO  --溢短装比例
      ,PROJ_TOT_INVEST  --项目总投资
      ,CAPITAL  --资本金
      ,SETUP_PROJ_BATCH_FILE  --立项批文
      ,OTHER_LICS  --其他许可证
      ,NCDS_ABBR  --同业存单简称
      ,MARGIN_INT_RAT_LEVEL  --保证金利率档次
      ,LAND_USE_CERT_ID  --土地使用证编号
      ,LAND_USE_CERT_DT  --土地使用证日期
      ,LAND_PLAN_LICS_ID  --用地规划许可证编号
      ,LAND_PLAN_LICS_DT  --用地规划许可证日期
      ,CNSTR_LICS_DT  --施工许可证日期
      ,PROJ_PLAN_LICS_DT  --工程规划许可证日期
      ,BUYER_NAME  --购货方名称
      ,SELLER_NAME  --销货方名称
      ,TRADE_TRAN_CONTENT  --贸易交易内容
      ,STAT_USE_OPEN_BAL  --统计用敞口余额
      ,COMMER_INV_INFO_DESC  --商业发票信息描述
      ,COMMER_INV_CURR_CD  --商业发票币种代码
      ,COMMER_INV_AMT  --商业发票金额
      ,COMMER_INV_KIND_CD  --商业发票种类代码
       ,JOB_CD --任务代码
       ,ADV_MAN_INDU_FLG --先进制造业标志
      ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志
      ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志
      ,CUL_PROPERTY_FLG --文化产业标志
      ,INDU_CORP_TECH_REM_UGD_FLG --工业企业技术改造升级标志
      ,STRATE_NEW_INDUS_TYPE_CD   --战略性新兴产业类型代码
      ,HIGH_NEW_TECH_CORP_FLG  --高新技术企业标志
      ,SCI_TECH_CORP_FLG  --科技型企业标志
      ,SCI_TECH_INOVT_CORP_FLG --科创企业标志
    FROM ICL.V_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO  --视图-对公贷款业务合同补充信息
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO;
/

