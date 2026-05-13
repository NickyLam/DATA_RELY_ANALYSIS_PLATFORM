CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_FX_IB_LEND(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_FX_IB_LEND
  *  功能描述：外汇同业拆借
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_FX_IB_LEND
  *  目标表： O_ICL_CMM_FX_IB_LEND
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_FX_IB_LEND'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_FX_IB_LEND ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_FX_IB_LEND';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-外汇同业拆借';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_FX_IB_LEND
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,BUS_ID  --业务编号
      ,DEPT_ID  --部门编号
      ,ENTRY_ORG_ID  --记账机构编号
      ,TRAN_ACCT_B_ID  --交易账簿编号
      ,STD_PROD_ID  --标准产品编号
      ,CUST_ID  --客户编号
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,PORTF_ID  --投组编号
      ,PORTF_NAME  --投组名称
      ,PORTF_CLASS_NAME  --投组类型名称
      ,INV_PORT_STATUS_CD  --投资组合状态代码
      ,SUBJ_ID  --科目编号
      ,TRAN_AIM_CD  --交易目的代码
      ,TRAN_DIR_CD  --交易方向代码
      ,TRAN_MODE_CD  --交易模式代码
      ,CLEAR_WAY_CD  --清算方式代码
      ,IB_LEND_TYPE_CD  --拆借类型代码
      ,CLEAR_ORG_CD  --清算机构代码
      ,INPUT_DT  --录入日期
      ,TRAN_DT  --交易日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR  --期限
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLOAT_POINT  --利率浮动点数
      ,INT_RAT_TENOR_CD  --利率期限代码
      ,EXEC_INT_RAT  --执行利率
      ,CURR_CD  --币种代码
      ,TRAN_AMT  --交易金额
      ,EXP_AMT  --到期金额
      ,USD_TRAN_AMT  --折美元交易金额
      ,ACRU_INT  --应计利息
      ,CURRT_BAL  --当期余额
      ,TD_ACRU_INT  --当日应计利息
      ,CURRT_ACRU_INT  --当期应计利息
      ,PAY_INT_PED_CD  --付息周期代码
      ,FIR_PAY_INT_DT  --首次付息日期
      ,PAY_STUB_PROC_WAY_CD  --付息残段处理方式代码
      ,BAG_STATUS_CD  --成交状态代码
      ,TRAN_SRC_CD  --交易来源代码
      ,TRAN_SITE_CD  --交易场所代码
      ,BAG_ID  --成交编号
      ,TRAN_ID  --交易编号
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,INT_RECVBL_SUBJ_ID  --应收利息科目编号
      ,INT_INCOME_SUBJ_ID  --利息收入科目编号
      ,INT_RAT_ADJ_FREQ_CD  --利率调整频率代码
      ,BASE_RAT  --基准利率
      ,BOND_ID  --债券编号
      ,BOND_FAC_VAL  --债券面值
      ,BOND_CURR  --债券币种
      ,INPWN_RATIO  --质押比例
      ,INPWN_WAY_CD  --质押方式代码
      ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,BUS_ID  --业务编号
      ,DEPT_ID  --部门编号
      ,ENTRY_ORG_ID  --记账机构编号
      ,TRAN_ACCT_B_ID  --交易账簿编号
      ,STD_PROD_ID  --标准产品编号
      ,CUST_ID  --客户编号
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,PORTF_ID  --投组编号
      ,PORTF_NAME  --投组名称
      ,PORTF_CLASS_NAME  --投组类型名称
      ,INV_PORT_STATUS_CD  --投资组合状态代码
      ,SUBJ_ID  --科目编号（初始化数据为老科目）
      ,TRAN_AIM_CD  --交易目的代码
      ,TRAN_DIR_CD  --交易方向代码
      ,TRAN_MODE_CD  --交易模式代码
      ,CLEAR_WAY_CD  --清算方式代码
      ,IB_LEND_TYPE_CD  --拆借类型代码
      ,CLEAR_ORG_CD  --清算机构代码
      ,INPUT_DT  --录入日期
      ,TRAN_DT  --交易日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR  --期限
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
      ,INT_RAT_FLOAT_POINT  --利率浮动点数
      ,INT_RAT_TENOR_CD  --利率期限代码
      ,EXEC_INT_RAT  --执行利率
      ,CURR_CD  --币种代码
      ,TRAN_AMT  --交易金额
      ,EXP_AMT  --到期金额
      ,USD_TRAN_AMT  --折美元交易金额
      ,ACRU_INT  --应计利息
      ,CURRT_BAL  --当期余额
      ,TD_ACRU_INT  --当日应计利息
      ,CURRT_ACRU_INT  --当期应计利息
      ,PAY_INT_PED_CD  --付息周期代码
      ,FIR_PAY_INT_DT  --首次付息日期
      ,PAY_STUB_PROC_WAY_CD  --付息残段处理方式代码
      ,BAG_STATUS_CD  --成交状态代码
      ,TRAN_SRC_CD  --交易来源代码
      ,TRAN_SITE_CD  --交易场所代码
      ,BAG_ID  --成交编号
      ,TRAN_ID  --交易编号
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,INT_RECVBL_SUBJ_ID  --应收利息科目编号
      ,INT_INCOME_SUBJ_ID  --利息收入科目编号
      ,INT_RAT_ADJ_FREQ_CD  --利率调整频率代码
      ,BASE_RAT  --基准利率
      ,BOND_ID  --债券编号
      ,BOND_FAC_VAL  --债券面值
      ,BOND_CURR  --债券币种
      ,INPWN_RATIO  --质押比例
      ,INPWN_WAY_CD  --质押方式代码
      ,JOB_CD --任务代码
    FROM ICL.V_CMM_FX_IB_LEND  --视图-外汇同业拆借
       WHERE ETL_DT BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1--上月末
        AND TO_DATE(V_P_DATE,'YYYYMMDD') --跑批日
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

  END ETL_INIT_O_ICL_CMM_FX_IB_LEND;
/

