CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_COL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_COL_INFO
  *  功能描述：押品信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_COL_INFO
  *  目标表： O_ICL_CMM_COL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_INIT_O_ICL_CMM_COL_INFO'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_COL_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_COL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-押品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_COL_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,COL_ID  --押品编号
      ,COL_TYPE_ID  --押品类型编号
      ,COL_NAME  --押品名称
      ,GUAR_WAY_CD  --担保方式代码
      ,COL_MGMT_ID  --押品管理员工编号
      ,ORG_ID  --机构编号
      ,COM_PROT_FLG  --共同财产标志
      ,ASSET_OBG_LOT  --资产权利人所占份额
      ,GUAR_EFFECT_WAY_CD  --担保生效方式代码
      ,TRAST_INSURE_FLG  --办理保险标志
      ,RGST_TRAST_STATUS_CD  --登记办理状态代码
      ,INSURE_TRAST_STATUS_CD  --保险办理状态代码
      ,INSTO_STATUS_CD  --入库状态代码
      ,RELA_STATUS_CD  --关联状态代码
      ,ESPEC_STATUS_CD  --特殊状态代码
      ,WT_MD_CASH_ABILITY_CD  --权重法变现能力代码
      ,NP_CASH_ABILITY_CD  --内评初级法变现能力代码
      ,OBANK_GUAR_FLG  --他行担保标志
      ,GCUST_FLG  --代保管标志
      ,ESTIM_CURR_CD  --评估币种代码
      ,ESTIM_VAL  --评估价值
      ,ESTIM_WAY_CD  --评估方式代码
      ,ESTIM_DT  --评估日期
      ,HXB_CFM_VAL  --我行确认价值
      ,ESTIM_IDTFY_DT  --评估认定日期
      ,HXB_PA_CFM_VAL  --我行初评确认价值
      ,SAVE_HXB_FLG  --保存我行标志
      ,SETUP_DT  --建立日期
      ,MODIF_EMPLY_ID  --修改员工编号
      ,MAIN_COL_FLG  --主押品标志
      ,BELONG_CUST_ID  --权属人客户编号
      ,INSTO_ENTRY_ORG_ID  --入库记账机构编号
      ,INSTO_ENTRY_VAL  --入库记账价值
      ,INSTO_ENTRY_CURR_CD  --入库记账币种代码
      ,EXP_DT  --到期日期
      ,DEP_RCPT_VOUCH_ID  --存单凭证编号
      ,DEP_RCPT_EFFECT_DT  --存单生效日期
      ,DEP_RCPT_EXP_DT  --存单到期日期
      ,DEP_RCPT_TERM  --存单存期
      ,DEP_RCPT_TERM_DAYS  --存单存期天数
      ,DEP_RCPT_INT_RAT  --存单利率
      ,DEP_RCPT_CURR_CD  --存单币种代码
      ,DEP_RCPT_AVAL_AMT  --存单可用金额
      ,DEP_RCPT_ACCT_BAL  --存单账户余额
      ,ESTATE_MON_PROP_FEE  --房产月物业费
      ,ESTATE_ARCH_AREA  --房产建筑面积
      ,HXB_DEP_RCPT_FLG  --我行存单标志
      ,PROP_PS_ID  --所有权人编号
      ,PROP_PS_NAME  --所有权人名称
      ,PRIOR_COMP_WEIGHT_QTTY  --优先受偿权数额
      ,ESTIM_PS_NAME  --评估人名称
      ,ESTIM_EXP_DT  --评估到期日期
      ,COL_VAL  --押品价值
      ,MTGED_VAL  --已抵押价值
      ,RIGHT_RGST_DT  --权利登记日期
      ,CHECK_GUAR_DT  --核保日期
      ,CTFER_NAME_1  --核保人姓名1
      ,CTFER_NAME_2  --核保人姓名2
      ,OPER_ORG_ID  --操作机构编号
      ,RGST_ORG_NAME  --登记机构名称
      ,ENTY_COLL_DT  --实物收取日期
      ,PM_RAT  --抵质押率
      ,HIGT_MTG_RAT  --最高抵押率
      ,COL_ESTIM_CURR_CD  --押品评估币种代码
      ,COL_ESTIM_VAL  --押品评估价值
      ,COL_STORE_ADDR  --押品存放地址
      ,COL_BELONG_TYPE_CD  --押品权属类型代码
      ,ESTIM_ORG_NAME  --评估机构名称
      ,ESTIM_ORG_ORGNZ_CD  --评估机构组织机构代码
      ,ESTIM_ORG_RGST_ORG_NAME  --评估机构登记机关名称
      ,PLEDGOR_NAME  --出质人姓名
      ,PLEDGOR_CERT_TYPE_CD  --出质人证件类型代码
      ,PLEDGOR_CERT_NO  --出质人证件号码
      ,BELONG_CERT_TYPE  --权属证件类型
      ,BELONG_CERT_NO  --权属证件号
      ,BELONG_RGST_ORG  --权属登记机关
      ,WAT_RGST_NUM  --权证登记号码
      ,WAT_NAME  --权证名称
      ,RENT_FLG  --租赁标志
      ,GUARA_TENTRY  --担保品承租人
      ,RENT_BEGIN_DT  --租赁起始日期
      ,RENT_EXP_DT  --租赁到期日期
      ,RENT_SITU_DESCB  --租赁情况描述
      ,RGST_EXP_DT  --登记到期日期
      ,RGST_TENOR  --登记期限
      ,RGSTRAT_ID  --登记人编号
      ,INSTO_DT  --入库日期
      ,REMARK  --备注
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,COL_ID  --押品编号
      ,COL_TYPE_ID  --押品类型编号
      ,COL_NAME  --押品名称
      ,GUAR_WAY_CD  --担保方式代码
      ,COL_MGMT_ID  --押品管理员工编号
      ,ORG_ID  --机构编号
      ,COM_PROT_FLG  --共同财产标志
      ,ASSET_OBG_LOT  --资产权利人所占份额
      ,GUAR_EFFECT_WAY_CD  --担保生效方式代码
      ,TRAST_INSURE_FLG  --办理保险标志
      ,RGST_TRAST_STATUS_CD  --登记办理状态代码
      ,INSURE_TRAST_STATUS_CD  --保险办理状态代码
      ,INSTO_STATUS_CD  --入库状态代码
      ,RELA_STATUS_CD  --关联状态代码
      ,ESPEC_STATUS_CD  --特殊状态代码
      ,WT_MD_CASH_ABILITY_CD  --权重法变现能力代码
      ,NP_CASH_ABILITY_CD  --内评初级法变现能力代码
      ,OBANK_GUAR_FLG  --他行担保标志
      ,GCUST_FLG  --代保管标志
      ,ESTIM_CURR_CD  --评估币种代码
      ,ESTIM_VAL  --评估价值
      ,ESTIM_WAY_CD  --评估方式代码
      ,ESTIM_DT  --评估日期
      ,HXB_CFM_VAL  --我行确认价值
      ,ESTIM_IDTFY_DT  --评估认定日期
      ,HXB_PA_CFM_VAL  --我行初评确认价值
      ,SAVE_HXB_FLG  --保存我行标志
      ,SETUP_DT  --建立日期
      ,MODIF_EMPLY_ID  --修改员工编号
      ,MAIN_COL_FLG  --主押品标志
      ,BELONG_CUST_ID  --权属人客户编号
      ,INSTO_ENTRY_ORG_ID  --入库记账机构编号
      ,INSTO_ENTRY_VAL  --入库记账价值
      ,INSTO_ENTRY_CURR_CD  --入库记账币种代码
      ,EXP_DT  --到期日期
      ,DEP_RCPT_VOUCH_ID  --存单凭证编号
      ,DEP_RCPT_EFFECT_DT  --存单生效日期
      ,DEP_RCPT_EXP_DT  --存单到期日期
      ,DEP_RCPT_TERM  --存单存期
      ,DEP_RCPT_TERM_DAYS  --存单存期天数
      ,DEP_RCPT_INT_RAT  --存单利率
      ,DEP_RCPT_CURR_CD  --存单币种代码
      ,DEP_RCPT_AVAL_AMT  --存单可用金额
      ,DEP_RCPT_ACCT_BAL  --存单账户余额
      ,ESTATE_MON_PROP_FEE  --房产月物业费
      ,ESTATE_ARCH_AREA  --房产建筑面积
      ,HXB_DEP_RCPT_FLG  --我行存单标志
      ,PROP_PS_ID  --所有权人编号
      ,PROP_PS_NAME  --所有权人名称
      ,PRIOR_COMP_WEIGHT_QTTY  --优先受偿权数额
      ,ESTIM_PS_NAME  --评估人名称
      ,ESTIM_EXP_DT  --评估到期日期
      ,COL_VAL  --押品价值
      ,MTGED_VAL  --已抵押价值
      ,RIGHT_RGST_DT  --权利登记日期
      ,CHECK_GUAR_DT  --核保日期
      ,CTFER_NAME_1  --核保人姓名1
      ,CTFER_NAME_2  --核保人姓名2
      ,OPER_ORG_ID  --操作机构编号
      ,RGST_ORG_NAME  --登记机构名称
      ,ENTY_COLL_DT  --实物收取日期
      ,PM_RAT  --抵质押率
      ,HIGT_MTG_RAT  --最高抵押率
      ,COL_ESTIM_CURR_CD  --押品评估币种代码
      ,COL_ESTIM_VAL  --押品评估价值
      ,COL_STORE_ADDR  --押品存放地址
      ,COL_BELONG_TYPE_CD  --押品权属类型代码
      ,ESTIM_ORG_NAME  --评估机构名称
      ,ESTIM_ORG_ORGNZ_CD  --评估机构组织机构代码
      ,ESTIM_ORG_RGST_ORG_NAME  --评估机构登记机关名称
      ,PLEDGOR_NAME  --出质人姓名
      ,PLEDGOR_CERT_TYPE_CD  --出质人证件类型代码
      ,PLEDGOR_CERT_NO  --出质人证件号码
      ,BELONG_CERT_TYPE  --权属证件类型
      ,BELONG_CERT_NO  --权属证件号
      ,BELONG_RGST_ORG  --权属登记机关
      ,WAT_RGST_NUM  --权证登记号码
      ,WAT_NAME  --权证名称
      ,RENT_FLG  --租赁标志
      ,GUARA_TENTRY  --担保品承租人
      ,RENT_BEGIN_DT  --租赁起始日期
      ,RENT_EXP_DT  --租赁到期日期
      ,RENT_SITU_DESCB  --租赁情况描述
      ,RGST_EXP_DT  --登记到期日期
      ,RGST_TENOR  --登记期限
      ,RGSTRAT_ID  --登记人编号
      ,INSTO_DT  --入库日期
      ,REMARK  --备注
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_COL_INFO  --视图-押品信息
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

  END ETL_INIT_O_ICL_CMM_COL_INFO;
/

