CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_CRDT_LMT_APV_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_CRDT_LMT_APV_INFO
  *  功能描述：对公授信额度审批信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：  ICL.V_CMM_CORP_CRDT_LMT_APV_INFO
  *  目标表： O_ICL_CMM_CORP_CRDT_LMT_APV_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_CRDT_LMT_APV_INFO'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_CRDT_LMT_APV_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_CRDT_LMT_APV_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公授信额度审批信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_CRDT_LMT_APV_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CRDT_LMT_APV_FLOW_NUM  --授信额度审批流水号
      ,RELA_CRDT_LMT_APV_FLOW_NUM  --关联授信额度审批流水号
      ,BUS_BREED_ID  --业务品种编号
      ,CUST_ID  --客户编号
      ,HAPP_TYPE_CD  --发生类型代码
      ,CRDT_RG_RG_CD  --授信区域地区代码
      ,CRDT_APV_STATUS_CD  --授信审批状态代码
      ,RGST_ORG_CD  --登记机构代码
      ,RGSTRAT_ID  --登记人编号
      ,OPER_ORG_CD  --经办机构代码
      ,OPERR_ID  --经办人编号
      ,FINAL_APVER_ID  --最终审批人编号
      ,LOAN_TENOR  --贷款期限
      ,CURR_CD  --币种代码
      ,CRDT_APV_AMT  --授信审批金额
      ,CRDT_APV_OPEN_AMT  --授信审批敞口金额
      ,RGST_DT  --登记日期
      ,APV_DT  --审批日期
      ,APVED_DT  --审批通过日期
      ,CRDT_LMT_BEGIN_DT  --授信额度起始日期
      ,CRDT_LMT_EXP_DT  --授信额度到期日期
      ,APVED_REPLY_ID  --审批通过批复编号
      ,CRDT_LMT_EFFECT_FLG  --授信额度生效标志
      ,LMT_CIRCL_FLG  --额度可循环标志
      ,GROUP_CRDT_FLG  --集团授信标志
      ,ESTATE_CLASS_FIN_FLG  --房地产类融资标志
      ,GOVER_CLASS_FIN_FLG  --政府类融资标志
      ,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_CLASS_FIN_FLG  --一带一路建设类融资标志
      ,GREEN_CRDT_CLASS_FIN_FLG  --绿色信贷类融资标志
      ,CRDT_LMT_APV_OPINION  --授信额度审批意见
      ,CRDT_LMT_USAGE_DESCB  --授信额度用途描述
      ,CRDT_LMT_SPENT_PLAN  --授信额度用款计划
      ,MAIN_GUAR_WAY_CD  --主担保方式代码
      ,LOW_RISK_BIZ_IND  --低风险业务标志
      ,LOW_RISK_BIZ_TYPE_CD  --低风险业务类型代码
      ,REPLY_TYPE_CD  --批复类型代码
      ,CONT_REGI_IND  --合同登记标志
      ,TEXT_CONT_ID  --文本合同编号
      ,AVAL_O_USE_LMT  --可用他用额度
      ,O_USE_LMT_ID  --他用额度编号
      ,O_USE_LMT_TYPE_CD  --他用额度类型代码
      ,O_USE_LMT_ALL_ID  --他用额度所有人编号
      ,GROUP_CRDT_LMT_CORP_PART  --集团授信额度公司部分
      ,GROUP_CRDT_EXPOS_CORP_PART  --集团授信敞口公司部分
      ,GROUP_CRDT_LMT_IBANK_PART  --集团授信额度同业部分
      ,GROUP_CRDT_EXPOS_IBANK_PART  --集团授信敞口同业部分
      ,RELA_GROUP_REPLY_ID  --关联集团批复编号
     -- ,OCUP_O_USE_LMT_FLG  --占用他用额度标志
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CRDT_LMT_APV_FLOW_NUM  --授信额度审批流水号
      ,RELA_CRDT_LMT_APV_FLOW_NUM  --关联授信额度审批流水号
      ,BUS_BREED_ID  --业务品种编号
      ,CUST_ID  --客户编号
      ,HAPP_TYPE_CD  --发生类型代码
      ,CRDT_RG_RG_CD  --授信区域地区代码
      ,CRDT_APV_STATUS_CD  --授信审批状态代码
      ,RGST_ORG_CD  --登记机构代码
      ,RGSTRAT_ID  --登记人编号
      ,OPER_ORG_CD  --经办机构代码
      ,OPERR_ID  --经办人编号
      ,FINAL_APVER_ID  --最终审批人编号
      ,LOAN_TENOR  --贷款期限
      ,CURR_CD  --币种代码
      ,CRDT_APV_AMT  --授信审批金额
      ,CRDT_APV_OPEN_AMT  --授信审批敞口金额
      ,RGST_DT  --登记日期
      ,APV_DT  --审批日期
      ,APVED_DT  --审批通过日期
      ,CRDT_LMT_BEGIN_DT  --授信额度起始日期
      ,CRDT_LMT_EXP_DT  --授信额度到期日期
      ,APVED_REPLY_ID  --审批通过批复编号
      ,CRDT_LMT_EFFECT_FLG  --授信额度生效标志
      ,LMT_CIRCL_FLG  --额度可循环标志
      ,GROUP_CRDT_FLG  --集团授信标志
      ,ESTATE_CLASS_FIN_FLG  --房地产类融资标志
      ,GOVER_CLASS_FIN_FLG  --政府类融资标志
      ,CONSM_SERV_CLASS_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_CLASS_FIN_FLG  --一带一路建设类融资标志
      ,GREEN_CRDT_CLASS_FIN_FLG  --绿色信贷类融资标志
      ,CRDT_LMT_APV_OPINION  --授信额度审批意见
      ,CRDT_LMT_USAGE_DESCB  --授信额度用途描述
      ,CRDT_LMT_SPENT_PLAN  --授信额度用款计划
      ,MAIN_GUAR_WAY_CD  --主担保方式代码
      ,LOW_RISK_BIZ_IND  --低风险业务标志
      ,LOW_RISK_BIZ_TYPE_CD  --低风险业务类型代码
      ,REPLY_TYPE_CD  --批复类型代码
      ,CONT_REGI_IND  --合同登记标志
      ,TEXT_CONT_ID  --文本合同编号
      ,AVAL_O_USE_LMT  --可用他用额度
      ,O_USE_LMT_ID  --他用额度编号
      ,O_USE_LMT_TYPE_CD  --他用额度类型代码
      ,O_USE_LMT_ALL_ID  --他用额度所有人编号
      ,GROUP_CRDT_LMT_CORP_PART  --集团授信额度公司部分
      ,GROUP_CRDT_EXPOS_CORP_PART  --集团授信敞口公司部分
      ,GROUP_CRDT_LMT_IBANK_PART  --集团授信额度同业部分
      ,GROUP_CRDT_EXPOS_IBANK_PART  --集团授信敞口同业部分
      ,RELA_GROUP_REPLY_ID  --关联集团批复编号
     -- ,OCUP_O_USE_LMT_FLG  --占用他用额度标志
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_CORP_CRDT_LMT_APV_INFO  --视图-对公授信额度审批信息
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

  END ETL_INIT_O_ICL_CMM_CORP_CRDT_LMT_APV_INFO;
/

