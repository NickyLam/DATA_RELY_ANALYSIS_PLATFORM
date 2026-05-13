CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_FINC_PROD_BASIC_INFO
(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_FINC_PROD_BASIC_INFO

  *  功能描述：理财产品基本信息
  *  创建日期：20221008
  *  开发人员：MW
  *  来源表：
  *  目标表：  O_ICL_CMM_FINC_PROD_BASIC_INFO

  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_FINC_PROD_BASIC_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  /*-- EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_FINC_PROD_BASIC_INFO
'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
 /* V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'O_ICL_CMM_FINC_PROD_BASIC_INFO
', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-理财产品基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_FINC_PROD_BASIC_INFO

  (
      ETL_DT  --ETL处理日期
      ,LP_ID  --法人编号
      ,PROD_ID  --产品编号
      ,FIN_PROD_ID  --金融产品编号
      ,SELL_PROD_ID  --销售产品编号
      ,PROD_ABBR  --产品简称
      ,PROD_FNAME  --产品全称
      ,PROD_TEPLA_ID  --产品模板编号
      ,PROD_TEPLA_COMNT  --产品模板说明
      ,PROD_CATE_CD  --产品类别代码
      ,PRFT_MODE_CD  --收益模式代码
      ,TRAN_CALN_CD  --交易日历代码
      ,COLL_WAY_CD  --募集方式代码
      ,OPER_MODE_CD  --运作模式代码
      ,ENTR_WAY_CD  --委托方式代码
      ,CSNER_ID  --委托人编号
      ,TRUSTEE_ID  --托管人编号
      ,SELL_ORG_ID  --销售机构编号
      ,SELL_DEPT_ID  --销售部门编号
      ,COLL_START_DT  --募集开始日期
      ,COLL_END_DT  --募集结束日期
      ,PROD_FOUND_DT  --产品成立日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,ACTL_VALUE_DT  --实际起息日期
      ,ACTL_EXP_DT  --实际到期日期
      ,LIQD_DT  --清盘日期
      ,TENOR  --期限
      ,TENOR_KIND_CD  --期限种类代码
      ,INVEST_PED_DAYS  --投资周期天数
      ,PROD_PED_DAYS  --产品周期天数
      ,SUBTN_FLG  --永续标志
      ,SUBTN_CLAUS_DESCB  --永续条款描述
      ,PURCH_CFM_TENOR  --申购确认期限
      ,REDEM_CFM_TENOR  --赎回确认期限
      ,INV_PORT_ID  --投资组合编号
      ,PROD_RGST_CODE  --产品登记编码
      ,CASH_MGMT_FLG  --现金管理标志
      ,PED_PROD_FLG  --周期型产品标志
      ,OPEN_FLG  --开放式标志
      ,CONSMTED_FLG  --可代销标志
      ,REDEMBL_FLG  --可赎回标志
      ,LAYERED_FLG  --分层标志
      ,LAYERED_TYPE_CD  --分层类型代码
      ,INVEST_CHAR_CD  --投资性质代码
      ,PRFT_TYPE_CD  --收益类型代码
      ,ISSUE_STATUS_CD  --发行状态代码
      ,RISK_LEVEL_CD  --风险等级代码
      ,SELL_CHN_CD_COMB  --销售渠道代码组合
      ,SELL_RG_CD_COMB  --销售地区代码组合
      ,SELL_CUST_TYPE_CD_COMB  --销售客户类型代码组合
      ,PROD_MGR_ID  --产品经理编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,PRIC_SUBJ_ID  --本金科目编号
      ,PRFT_ADJ_SUBJ_ID  --收益调整科目编号
      ,CURR_CD  --币种代码
      ,CURR_PRIC_BAL  --当前本金余额
      ,CURRT_ACRU_PRFT  --当期应计收益
      ,EXPE_YLD_RAT  --预期收益率
      ,SEVN_AUAL_YLD  --七日年化收益率
      ,TD_CUST_YLD_RAT  --当日客户收益率
      ,PROD_FEE_F_UNIT_NV  --产品费前单位净值
      ,PROD_FEE_POST_CORP_NV  --产品费后单位净值
      ,PROD_ACM_CORP_NV  --产品累计单位净值
      ,PROD_CURRT_NV  --产品当期净值
      ,SUPT_BUY_WAY_CD  --支持购买方式代码
      ,INDV_ALLOW_BUY_FLG  --个人允许购买标志
      ,CTRL_FLG_COMB  --控制标志组合
      ,PROD_FEE_BF_TEN_THOUS_PRFT  --产品费前万份收益
      ,PROD_FEE_POST_TEN_THOUS_PRFT  --产品费后万份收益
      ,PROD_SCLASS_CD  --产品小类代码
      ,SALE_FEE_RAT  --销售费率
      ,DIFF_PRICE_FEE_RAT  --差价费率

     )
     SELECT
      ETL_DT  --ETL处理日期
      ,LP_ID  --法人编号
      ,PROD_ID  --产品编号
      ,FIN_PROD_ID  --金融产品编号
      ,SELL_PROD_ID  --销售产品编号
      ,PROD_ABBR  --产品简称
      ,PROD_FNAME  --产品全称
      ,PROD_TEPLA_ID  --产品模板编号
      ,PROD_TEPLA_COMNT  --产品模板说明
      ,PROD_CATE_CD  --产品类别代码
      ,PRFT_MODE_CD  --收益模式代码
      ,TRAN_CALN_CD  --交易日历代码
      ,COLL_WAY_CD  --募集方式代码
      ,OPER_MODE_CD  --运作模式代码
      ,ENTR_WAY_CD  --委托方式代码
      ,CSNER_ID  --委托人编号
      ,TRUSTEE_ID  --托管人编号
      ,SELL_ORG_ID  --销售机构编号
      ,SELL_DEPT_ID  --销售部门编号
      ,COLL_START_DT  --募集开始日期
      ,COLL_END_DT  --募集结束日期
      ,PROD_FOUND_DT  --产品成立日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,ACTL_VALUE_DT  --实际起息日期
      ,ACTL_EXP_DT  --实际到期日期
      ,LIQD_DT  --清盘日期
      ,TENOR  --期限
      ,TENOR_KIND_CD  --期限种类代码
      ,INVEST_PED_DAYS  --投资周期天数
      ,PROD_PED_DAYS  --产品周期天数
      ,SUBTN_FLG  --永续标志
      ,SUBTN_CLAUS_DESCB  --永续条款描述
      ,PURCH_CFM_TENOR  --申购确认期限
      ,REDEM_CFM_TENOR  --赎回确认期限
      ,INV_PORT_ID  --投资组合编号
      ,PROD_RGST_CODE  --产品登记编码
      ,CASH_MGMT_FLG  --现金管理标志
      ,PED_PROD_FLG  --周期型产品标志
      ,OPEN_FLG  --开放式标志
      ,CONSMTED_FLG  --可代销标志
      ,REDEMBL_FLG  --可赎回标志
      ,LAYERED_FLG  --分层标志
      ,LAYERED_TYPE_CD  --分层类型代码
      ,INVEST_CHAR_CD  --投资性质代码
      ,PRFT_TYPE_CD  --收益类型代码
      ,ISSUE_STATUS_CD  --发行状态代码
      ,RISK_LEVEL_CD  --风险等级代码
      ,SELL_CHN_CD_COMB  --销售渠道代码组合
      ,SELL_RG_CD_COMB  --销售地区代码组合
      ,SELL_CUST_TYPE_CD_COMB  --销售客户类型代码组合
      ,PROD_MGR_ID  --产品经理编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,PRIC_SUBJ_ID  --本金科目编号
      ,PRFT_ADJ_SUBJ_ID  --收益调整科目编号
      ,CURR_CD  --币种代码
      ,CURR_PRIC_BAL  --当前本金余额
      ,CURRT_ACRU_PRFT  --当期应计收益
      ,EXPE_YLD_RAT  --预期收益率
      ,SEVN_AUAL_YLD  --七日年化收益率
      ,TD_CUST_YLD_RAT  --当日客户收益率
      ,PROD_FEE_F_UNIT_NV  --产品费前单位净值
      ,PROD_FEE_POST_CORP_NV  --产品费后单位净值
      ,PROD_ACM_CORP_NV  --产品累计单位净值
      ,PROD_CURRT_NV  --产品当期净值
      ,SUPT_BUY_WAY_CD  --支持购买方式代码
      ,INDV_ALLOW_BUY_FLG  --个人允许购买标志
      ,CTRL_FLG_COMB  --控制标志组合
      ,PROD_FEE_BF_TEN_THOUS_PRFT  --产品费前万份收益
      ,PROD_FEE_POST_TEN_THOUS_PRFT  --产品费后万份收益
      ,PROD_SCLASS_CD  --产品小类代码
      ,SALE_FEE_RAT  --销售费率
      ,DIFF_PRICE_FEE_RAT  --差价费率
    FROM ICL.V_CMM_FINC_PROD_BASIC_INFO
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

  END ETL_INIT_O_ICL_CMM_FINC_PROD_BASIC_INFO
;
/

