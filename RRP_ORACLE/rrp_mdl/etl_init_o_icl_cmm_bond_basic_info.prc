CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_BOND_BASIC_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_BOND_BASIC_INFO
  *  功能描述：债券基本信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BOND_BASIC_INFO
  *  目标表： O_ICL_CMM_BOND_BASIC_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_BOND_BASIC_INFO'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_BOND_BASIC_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_BOND_BASIC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-债券基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,BOND_ID  --债券编号
      ,ASSET_TYPE_ID  --资产类型编号
      ,BOND_NAME  --债券名称
      ,BOND_ABBR  --债券简称
      ,BOND_TYPE_CD  --债券类型代码
      ,BOND_CLS_NAME  --债券分类名称
      ,TRUST_ORG_ID  --托管机构编号
      ,MGMT_MODE_CD  --管理模式代码
      ,ISSUER_CUST_ID  --发行人客户编号
      ,ISSUER_CD  --发行人代码
      ,ISSUER_NAME  --发行人名称
      ,CURR_CD  --币种代码
      ,ISSUE_CORP  --发行单位
      ,ISSUE_PRICE  --发行价格
      ,ISSUE_INT_RAT  --发行利率
      ,ISSUE_SIZE  --发行规模
      ,FAC_VAL_INT_RAT  --票面利率
      ,FAC_VAL  --票面面值
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,BASE_RAT_ID  --基准利率编号
      ,INT_RAT_FLOAT_POINT  --利率浮动点数
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLOAT_UPLMI  --利率浮动上限
      ,INT_RAT_FLOAT_LOLMI  --利率浮动下限
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_ACCR_CURR_CD  --计息币种代码
      ,INT_ACCR_PED_CD  --计息周期代码
      ,PAY_INT_PED_CD  --付息周期代码
      ,COMP_INT_PED_CD  --复利周期代码
      ,REVAL_PED_CD  --重定价周期代码
      ,FIR_REVAL_DT  --首次重定价日期
      ,REVAL_WAY_CD  --重定价方式代码
      ,LAST_REVAL_DT  --上次重定价日期
      ,NEXT_REVAL_DT  --下次重定价日期
      ,REVAL_START_DT  --重定价开始日期
      ,REVAL_END_DT  --重定价结束日期
      ,REVAL_INT_RAT  --重定价利率
      ,EXP_YLD_RAT  --到期收益率
      ,ISSUE_DT  --发行日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR  --期限
      ,LIST_DT  --上市日期
      ,FIR_PAY_INT_DT  --首次付息日期
      ,LAST_PAY_INT_DT  --上次付息日期
      ,NEXT_PAY_INT_DT  --下次付息日期
      ,NEXT_RPP_AMT  --下次还本金额
      ,NEXT_PAY_INT_AMT  --下次付息金额
      ,STOP_CIRCLT_DT  --停止流通日期
      ,TRANBL_BOND_FLG  --可转换债券标志
      ,DISCNT_DEBT_VCH_FLG  --贴现债券标志
      ,ACRU_INT_FLG  --应计利息标志
      ,SUBTN_BOND_FLG  --永续债标志
      ,EX_CHOICE_TYPE_CD  --行权选择类型代码
      ,BOND_MARKET_TYPE_CD  --债券市场类型代码
      ,GUAR_TYPE_CD  --担保类型代码
      ,GUARTOR_NAME  --担保人名称
      ,INPWNED_RATIO  --可质押比例
      ,CAPTION_TYPE_CD  --资产化类型代码
      ,VALUATION_WAY_CD  --计价方式代码
      ,DATA_SRC_SYS_IDF  --数据来源系统标识
      ,ISSUE_MAIN_BELONG_CTY_RG_CD  --发行主体所属国家地区代码
      ,ISSUE_RG_CD  --发行地区代码
      ,ACTL_MANG_LAND_NATION_CD  --实际经营地国别代码
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,BOND_ID  --债券编号
      ,ASSET_TYPE_ID  --资产类型编号
      ,BOND_NAME  --债券名称
      ,BOND_ABBR  --债券简称
      ,BOND_TYPE_CD  --债券类型代码
      ,BOND_CLS_NAME  --债券分类名称
      ,TRUST_ORG_ID  --托管机构编号
      ,MGMT_MODE_CD  --管理模式代码
      ,ISSUER_CUST_ID  --发行人客户编号
      ,ISSUER_CD  --发行人代码
      ,ISSUER_NAME  --发行人名称
      ,CURR_CD  --币种代码
      ,ISSUE_CORP  --发行单位
      ,ISSUE_PRICE  --发行价格
      ,ISSUE_INT_RAT  --发行利率
      ,ISSUE_SIZE  --发行规模
      ,FAC_VAL_INT_RAT  --票面利率
      ,FAC_VAL  --票面面值
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,BASE_RAT_ID  --基准利率编号
      ,INT_RAT_FLOAT_POINT  --利率浮动点数
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLOAT_UPLMI  --利率浮动上限
      ,INT_RAT_FLOAT_LOLMI  --利率浮动下限
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_ACCR_CURR_CD  --计息币种代码
      ,INT_ACCR_PED_CD  --计息周期代码
      ,PAY_INT_PED_CD  --付息周期代码
      ,COMP_INT_PED_CD  --复利周期代码
      ,REVAL_PED_CD  --重定价周期代码
      ,FIR_REVAL_DT  --首次重定价日期
      ,REVAL_WAY_CD  --重定价方式代码
      ,LAST_REVAL_DT  --上次重定价日期
      ,NEXT_REVAL_DT  --下次重定价日期
      ,REVAL_START_DT  --重定价开始日期
      ,REVAL_END_DT  --重定价结束日期
      ,REVAL_INT_RAT  --重定价利率
      ,EXP_YLD_RAT  --到期收益率
      ,ISSUE_DT  --发行日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR  --期限
      ,LIST_DT  --上市日期
      ,FIR_PAY_INT_DT  --首次付息日期
      ,LAST_PAY_INT_DT  --上次付息日期
      ,NEXT_PAY_INT_DT  --下次付息日期
      ,NEXT_RPP_AMT  --下次还本金额
      ,NEXT_PAY_INT_AMT  --下次付息金额
      ,STOP_CIRCLT_DT  --停止流通日期
      ,TRANBL_BOND_FLG  --可转换债券标志
      ,DISCNT_DEBT_VCH_FLG  --贴现债券标志
      ,ACRU_INT_FLG  --应计利息标志
      ,SUBTN_BOND_FLG  --永续债标志
      ,EX_CHOICE_TYPE_CD  --行权选择类型代码
      ,BOND_MARKET_TYPE_CD  --债券市场类型代码
      ,GUAR_TYPE_CD  --担保类型代码
      ,GUARTOR_NAME  --担保人名称
      ,INPWNED_RATIO  --可质押比例
      ,CAPTION_TYPE_CD  --资产化类型代码
      ,VALUATION_WAY_CD  --计价方式代码
      ,DATA_SRC_SYS_IDF  --数据来源系统标识
      ,ISSUE_MAIN_BELONG_CTY_RG_CD  --发行主体所属国家地区代码
      ,ISSUE_RG_CD  --发行地区代码
      ,ACTL_MANG_LAND_NATION_CD  --实际经营地国别代码
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_BOND_BASIC_INFO  --视图-债券基本信息
    WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')

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

  END ETL_INIT_O_ICL_CMM_BOND_BASIC_INFO;
/

