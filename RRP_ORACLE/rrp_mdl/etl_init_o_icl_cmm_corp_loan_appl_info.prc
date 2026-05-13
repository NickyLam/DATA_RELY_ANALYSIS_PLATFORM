CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_LOAN_APPL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_LOAN_APPL_INFO
  *  功能描述：对公贷款申请信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_LOAN_APPL_INFO
  *  目标表： O_ICL_CMM_CORP_LOAN_APPL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20221615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_CORP_LOAN_APPL_INFO'; -- 程序名称
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
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_LOAN_APPL_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_LOAN_APPL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公贷款申请信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,LOAN_APPL_FLOW_NUM  --贷款申请流水号
      ,RELA_APPL_FLOW_NUM  --关联申请流水号
      ,BUS_BREED_ID  --业务品种编号
      ,STD_PROD_ID  --标准产品号
      ,CUST_ID  --客户编号
      ,APPL_DT  --申请日期
      ,OPER_ORG_CD  --经办机构代码
      ,OPERR_ID  --经办人编号
      ,OPER_DT  --经办日期
      ,RGST_ORG_CD  --登记机构代码
      ,RGSTRAT_ID  --登记人编号
      ,RGST_DT  --登记日期
      ,APPL_WAY_CD  --申请方式代码
      ,TENOR_MON  --期限月份
      ,LOAN_TENOR  --贷款期限
      ,CIRCL_LMT_FLG  --循环额度标志
      ,CURR_CD  --币种代码
      ,APPL_AMT  --申请金额
      ,APVED_DT  --审批通过日期
      ,LATEST_APV_AMT  --最新审批金额
      ,HAPP_TYPE_CD  --发生类型代码
      ,CAP_SRC_CD  --资金来源代码
      ,CRDT_AGT_ID  --授信协议编号
      ,BANK_FIN_TOT  --银行融资总额
      ,MAJOR_GUARTOR_ID  --主要担保人编号
      ,MAJOR_GUAR_WAY_CD  --主要担保方式代码
      ,GUAR_WAY_1  --担保方式1
      ,GUAR_WAY_2  --担保方式2
      ,OTHER_GUAR_WAY_FLG  --其他担保方式标志
      ,MAJOR_GUARTOR_NAME  --主要担保人名称
      ,MAIN_REPAY_WAY_CD  --主还款方式代码
      ,REPAY_PED_CD  --还款周期代码
      ,SUB_REPAY_WAY_CD  --子还款方式代码
      ,DIR_CD  --投向代码
      ,USAGE_DESCB  --用途描述
      ,OTHER_USAGE_DESCB  --其他用途描述
      ,EFFECT_FLG  --生效标志
      ,CUST_TYPE_CD  --客户类型代码
      ,CAMP_CORP_NAME  --营销单位名称
      ,CAMP_CHN_ID  --营销渠道编号
      ,HOST_BANK_NAME  --主办行行名称
      ,PATIP_LOAN_BANK_NAME  --参贷行行名称
      ,AGENT_BANK_NAME  --代理行行名称
      ,AGENT_PATIP_LOAN_FLG  --代理参贷标志
      ,LOW_RISK_BUS_FLG  --低风险业务标志
      ,RISK_TYPE_CD  --风险类型代码
      ,ASSET_RISK_CLS_CD  --资产风险分类代码
      ,CRDT_RG_CD  --授信区域代码
      ,CLASS_CRDT_FLG  --类信贷标志
      ,GROUP_CRDT_CORP_LMT  --集团授信公司额度
      ,GROUP_CRDT_CORP_OPEN  --集团授信公司敞口
      ,GROUP_CRDT_IBANK_LMT  --集团授信同业额度
      ,GROUP_CRDT_IBANK_OPEN  --集团授信同业敞口
      ,LOAN_INSURE_GUAR_FLG  --贷款保险保障标志
      ,REMOTE_LOAN_FLG  --异地贷款标志
      ,ESTATE_FIN_FLG  --房地产融资标志
      ,GOVER_FIN_FLG  --政府类融资标志
      ,CONSM_SERV_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
      ,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
      ,TURN_CRDT_FLG  --转授信标志
      ,BAR_FLG  --随借随还标志
      ,TA_CRDT_FLG  --商圈授信标志
      ,RISK_MGR_SIMUS_OPER_FLG  --风险经理平行操作标志
      ,SM_FLG  --小微标志
      ,KY_L_FLG  --快易贷标志
      ,TS_FLG  --暂存标志
      ,APV_REST_FLOW_NUM  --审批结果流水号
      ,O_USE_LMT_ALL_ID  --他用额度所有人编号
      ,O_USE_LMT_ID  --他用额度编号
      ,O_USE_LMT_TYPE_CD  --他用额度类型代码
      ,JOB_CD --任务代码
      ,LMT_UNDER_SELLBL_PROD_ID  --额度项下可售产品编号
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,LOAN_APPL_FLOW_NUM  --贷款申请流水号
      ,RELA_APPL_FLOW_NUM  --关联申请流水号
      ,BUS_BREED_ID  --业务品种编号
      ,STD_PROD_ID  --标准产品号
      ,CUST_ID  --客户编号
      ,APPL_DT  --申请日期
      ,OPER_ORG_CD  --经办机构代码
      ,OPERR_ID  --经办人编号
      ,OPER_DT  --经办日期
      ,RGST_ORG_CD  --登记机构代码
      ,RGSTRAT_ID  --登记人编号
      ,RGST_DT  --登记日期
      ,APPL_WAY_CD  --申请方式代码
      ,TENOR_MON  --期限月份
      ,LOAN_TENOR  --贷款期限
      ,CIRCL_LMT_FLG  --循环额度标志
      ,CURR_CD  --币种代码
      ,APPL_AMT  --申请金额
      ,APVED_DT  --审批通过日期
      ,LATEST_APV_AMT  --最新审批金额
      ,HAPP_TYPE_CD  --发生类型代码
      ,CAP_SRC_CD  --资金来源代码
      ,CRDT_AGT_ID  --授信协议编号
      ,BANK_FIN_TOT  --银行融资总额
      ,MAJOR_GUARTOR_ID  --主要担保人编号
      ,MAJOR_GUAR_WAY_CD  --主要担保方式代码
      ,GUAR_WAY_1  --担保方式1
      ,GUAR_WAY_2  --担保方式2
      ,OTHER_GUAR_WAY_FLG  --其他担保方式标志
      ,MAJOR_GUARTOR_NAME  --主要担保人名称
      ,MAIN_REPAY_WAY_CD  --主还款方式代码
      ,REPAY_PED_CD  --还款周期代码
      ,SUB_REPAY_WAY_CD  --子还款方式代码
      ,DIR_CD  --投向代码
      ,USAGE_DESCB  --用途描述
      ,OTHER_USAGE_DESCB  --其他用途描述
      ,EFFECT_FLG  --生效标志
      ,CUST_TYPE_CD  --客户类型代码
      ,CAMP_CORP_NAME  --营销单位名称
      ,CAMP_CHN_ID  --营销渠道编号
      ,HOST_BANK_NAME  --主办行行名称
      ,PATIP_LOAN_BANK_NAME  --参贷行行名称
      ,AGENT_BANK_NAME  --代理行行名称
      ,AGENT_PATIP_LOAN_FLG  --代理参贷标志
      ,LOW_RISK_BUS_FLG  --低风险业务标志
      ,RISK_TYPE_CD  --风险类型代码
      ,ASSET_RISK_CLS_CD  --资产风险分类代码
      ,CRDT_RG_CD  --授信区域代码
      ,CLASS_CRDT_FLG  --类信贷标志
      ,GROUP_CRDT_CORP_LMT  --集团授信公司额度
      ,GROUP_CRDT_CORP_OPEN  --集团授信公司敞口
      ,GROUP_CRDT_IBANK_LMT  --集团授信同业额度
      ,GROUP_CRDT_IBANK_OPEN  --集团授信同业敞口
      ,LOAN_INSURE_GUAR_FLG  --贷款保险保障标志
      ,REMOTE_LOAN_FLG  --异地贷款标志
      ,ESTATE_FIN_FLG  --房地产融资标志
      ,GOVER_FIN_FLG  --政府类融资标志
      ,CONSM_SERV_FIN_FLG  --消费服务类融资标志
      ,BR_BUILD_IFIN_FLG  --一带一路建设投融资标志
      ,GREEN_CRDT_FIN_FLG  --绿色信贷融资标志
      ,TURN_CRDT_FLG  --转授信标志
      ,BAR_FLG  --随借随还标志
      ,TA_CRDT_FLG  --商圈授信标志
      ,RISK_MGR_SIMUS_OPER_FLG  --风险经理平行操作标志
      ,SM_FLG  --小微标志
      ,KY_L_FLG  --快易贷标志
      ,TS_FLG  --暂存标志
      ,APV_REST_FLOW_NUM  --审批结果流水号
      ,O_USE_LMT_ALL_ID  --他用额度所有人编号
      ,O_USE_LMT_ID  --他用额度编号
      ,O_USE_LMT_TYPE_CD  --他用额度类型代码
      ,JOB_CD --任务代码
      ,LMT_UNDER_SELLBL_PROD_ID  --额度项下可售产品编号
    FROM ICL.V_CMM_CORP_LOAN_APPL_INFO  --视图-代理代销产品信息
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

  END ETL_INIT_O_ICL_CMM_CORP_LOAN_APPL_INFO;
/

