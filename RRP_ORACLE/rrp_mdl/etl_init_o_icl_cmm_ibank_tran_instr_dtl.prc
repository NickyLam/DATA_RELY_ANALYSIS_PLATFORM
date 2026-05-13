CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_IBANK_TRAN_INSTR_DTL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_IBANK_TRAN_INSTR_DTL
  *  功能描述：同业交易指令明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_IBANK_TRAN_INSTR_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_IBANK_TRAN_INSTR_DTL'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_IBANK_TRAN_INSTR_DTL ;
 --  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_IBANK_TRAN_INSTR_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-同业交易指令明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_TRAN_INSTR_DTL
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,INSTR_SEQ_NUM  --指令序号
      ,PARENT_INSTR_SEQ_NUM  --父指令序号
      ,EXT_INSTR_SEQ_NUM  --外部指令序号
      ,RELA_CAP_INSTR_SEQ_NUM  --关联资金指令序号
      ,RELA_VCH_INSTR_SEQ_NUM  --关联券指令序号
      ,RELA_MAIN_INSTR_SEQ_NUM  --关联主指令序号
      ,ACTL_ACCTI_MAIN_SEQ_NUM  --实际核算主指令序号
      ,ADJ_ENTRY_MAIN_SEQ_NUM  --调账主指令序号
      ,INTNAL_TRAN_FLOW_NUM  --内部交易流水号
      ,OBJ_ID  --对象编号
      ,INSTR_BUS_TYPE_CD  --指令业务类型代码
      ,EXT_SECU_ACCT_ID  --外部证券账户编号
      ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
      ,INTNAL_CAP_ACCT_ID  --内部资金账户编号
      ,PARENT_INSTM_MARKET_TYPE_ID  --父金融工具市场类型编号
      ,PARENT_INSTM_ASSET_TYPE_ID  --父金融工具资产类型编号
      ,PARENT_FIN_INSTM_ID  --父金融工具编号
      ,INSTR_TYPE_CD  --指令类型代码
      ,INSTR_STATUS_CD  --指令状态代码
      ,ACPT_PAY_INSTR_CD  --收付款指令代码
      ,TRAN_BUS_TYPE_CD  --交易业务类型代码
      ,STL_WAY_CD  --结算方式代码
      ,STL_TYPE_CD  --结算类型代码
      ,APV_STATUS_CD  --审批状态代码
      ,ACTL_RP_FLG  --实收付标志
      ,CLEAR_FLOW_FLG  --清算流水标志
      ,SURVIV_TERM_FLG  --存续期标志
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,EXEC_MARKET_ID  --执行市场编号
      ,MEMO_INFO  --摘要信息
      ,THEORY_CLEAR_DT  --理论清算日期
      ,THEORY_STL_DT  --理论结算日期
      ,ACTL_STL_DT  --实际结算日期
      ,TRAN_DT  --交易日期
      ,CFM_DT  --确认日期
      ,REPAY_DT  --还款日期
      ,FINAL_MENDER_ID  --最后修改人编号
      ,FINAL_MENDER_NAME  --最后修改人名称
      ,CHECKER_ID  --复核人编号
      ,OPERR_ID  --经办人编号
      ,OPERR_NAME  --经办人名称
      ,CURR_CD  --币种代码
      ,ACRU_INT  --应计利息
      ,PRIC_BAL  --本金余额
      ,RECVBL_UNCOL_INT  --应收未收利息
      ,RECVBL_UNCOL_PRIC  --应收未收本金
      ,CHG_QTTY  --变动数量
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,INSTR_SEQ_NUM  --指令序号
      ,PARENT_INSTR_SEQ_NUM  --父指令序号
      ,EXT_INSTR_SEQ_NUM  --外部指令序号
      ,RELA_CAP_INSTR_SEQ_NUM  --关联资金指令序号
      ,RELA_VCH_INSTR_SEQ_NUM  --关联券指令序号
      ,RELA_MAIN_INSTR_SEQ_NUM  --关联主指令序号
      ,ACTL_ACCTI_MAIN_SEQ_NUM  --实际核算主指令序号
      ,ADJ_ENTRY_MAIN_SEQ_NUM  --调账主指令序号
      ,INTNAL_TRAN_FLOW_NUM  --内部交易流水号
      ,OBJ_ID  --对象编号
      ,INSTR_BUS_TYPE_CD  --指令业务类型代码
      ,EXT_SECU_ACCT_ID  --外部证券账户编号
      ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
      ,INTNAL_CAP_ACCT_ID  --内部资金账户编号
      ,PARENT_INSTM_MARKET_TYPE_ID  --父金融工具市场类型编号
      ,PARENT_INSTM_ASSET_TYPE_ID  --父金融工具资产类型编号
      ,PARENT_FIN_INSTM_ID  --父金融工具编号
      ,INSTR_TYPE_CD  --指令类型代码
      ,INSTR_STATUS_CD  --指令状态代码
      ,ACPT_PAY_INSTR_CD  --收付款指令代码
      ,TRAN_BUS_TYPE_CD  --交易业务类型代码
      ,STL_WAY_CD  --结算方式代码
      ,STL_TYPE_CD  --结算类型代码
      ,APV_STATUS_CD  --审批状态代码
      ,ACTL_RP_FLG  --实收付标志
      ,CLEAR_FLOW_FLG  --清算流水标志
      ,SURVIV_TERM_FLG  --存续期标志
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,EXEC_MARKET_ID  --执行市场编号
      ,MEMO_INFO  --摘要信息
      ,THEORY_CLEAR_DT  --理论清算日期
      ,THEORY_STL_DT  --理论结算日期
      ,ACTL_STL_DT  --实际结算日期
      ,TRAN_DT  --交易日期
      ,CFM_DT  --确认日期
      ,REPAY_DT  --还款日期
      ,FINAL_MENDER_ID  --最后修改人编号
      ,FINAL_MENDER_NAME  --最后修改人名称
      ,CHECKER_ID  --复核人编号
      ,OPERR_ID  --经办人编号
      ,OPERR_NAME  --经办人名称
      ,CURR_CD  --币种代码
      ,ACRU_INT  --应计利息
      ,PRIC_BAL  --本金余额
      ,RECVBL_UNCOL_INT  --应收未收利息
      ,RECVBL_UNCOL_PRIC  --应收未收本金
      ,CHG_QTTY  --变动数量
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_IBANK_TRAN_INSTR_DTL  --视图-同业交易指令明细
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

  END ETL_INIT_O_ICL_CMM_IBANK_TRAN_INSTR_DTL;
/

