CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL
  *  功能描述：同业券指令明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20241225  YJY      优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业券指令明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL
    (EVT_ID                    --事件编号
    ,LP_ID                     --法人编号
    ,SECU_INSTR_SEQ_NUM        --券指令序号
    ,MAIN_INSTR_SEQ_NUM        --主指令序号
    ,EXT_VCH_ACCT_ID           --外部券账户编号
    ,INTNAL_VCH_ACCT_ID        --内部券账户编号
    ,FIN_INSTM_ID              --金融工具编号
    ,FIN_INSTM_NAME            --金融工具名称
    ,ASSET_TYPE_ID             --资产类型编号
    ,MARKET_TYPE_ID            --市场类型编号
    ,CAP_FLOW_DIR_CD           --资金流向代码
    ,CURR_CD                   --币种代码
    ,FEE_COST_CHG              --费用成本变动
    ,ACRU_INT_COST_CHG         --应计利息成本变动
    ,ACTL_ACRU_INT             --实际应计利息
    ,ACTL_NET_PRICE_AMT        --实际净价金额
    ,RECVBL_UNCOL_INT          --应收未收利息
    ,RECVBL_UNCOL_PRIC         --应收未收本金
    ,PL_FEE                    --损益费用
    ,INT_RECVBL_RESV_FLG       --应收利息保留标志
    ,RECVBL_PRIC_RESV_FLG      --应收本金保留标志
    ,BAL_QTTY_CHG              --余额数量变动
    ,FROZ_QTTY                 --冻结数量
    ,CALC_CLOSING_DT           --计算截止日期
    ,STL_DT                    --结算日期
    ,ACTL_STL_DT               --实际结算日期
    ,PROD_CLS_NAME             --产品分类名称
    ,FULL_PRICE_COST_CHG       --全价成本变动
    ,GHB_ZZD_TRUST_ACCT_NUM    --本方中债登托管账号
    ,CNTPTY_ZZD_TRUST_ACCT_NUM --对手中债登托管账号
    ,EFFECT_TM                 --生效时间
    ,STL_DENOM                 --结算面额
    ,ACCTI_TRAN_FLOW_NUM       --核算交易流水号
    ,THEORY_FEE                --理论费用
    ,FEE_COST                  --费用成本
    ,ACCTI_IMPAM_OBJ_FLG       --核算减值对象标志
    ,START_INT_ACCR_DT         --开始计息日期
    ,EXPECT_QTTY               --预计数量
    ,EXPECT_DENOM              --预计面额
    ,OPERR_NAME                --经办人名称
    ,REMARK                    --备注
    ,START_DT                  --开始日期
    ,END_DT                    --结束日期
    ,ID_MARK                   --删除标识
    ,JOB_CD                    --任务代码
    )
  SELECT 
     EVT_ID                    --事件编号
    ,LP_ID                     --法人编号
    ,SECU_INSTR_SEQ_NUM        --券指令序号
    ,MAIN_INSTR_SEQ_NUM        --主指令序号
    ,EXT_VCH_ACCT_ID           --外部券账户编号
    ,INTNAL_VCH_ACCT_ID        --内部券账户编号
    ,FIN_INSTM_ID              --金融工具编号
    ,FIN_INSTM_NAME            --金融工具名称
    ,ASSET_TYPE_ID             --资产类型编号
    ,MARKET_TYPE_ID            --市场类型编号
    ,CAP_FLOW_DIR_CD           --资金流向代码
    ,CURR_CD                   --币种代码
    ,FEE_COST_CHG              --费用成本变动
    ,ACRU_INT_COST_CHG         --应计利息成本变动
    ,ACTL_ACRU_INT             --实际应计利息
    ,ACTL_NET_PRICE_AMT        --实际净价金额
    ,RECVBL_UNCOL_INT          --应收未收利息
    ,RECVBL_UNCOL_PRIC         --应收未收本金
    ,PL_FEE                    --损益费用
    ,INT_RECVBL_RESV_FLG       --应收利息保留标志
    ,RECVBL_PRIC_RESV_FLG      --应收本金保留标志
    ,BAL_QTTY_CHG              --余额数量变动
    ,FROZ_QTTY                 --冻结数量
    ,CALC_CLOSING_DT           --计算截止日期
    ,STL_DT                    --结算日期
    ,ACTL_STL_DT               --实际结算日期
    ,PROD_CLS_NAME             --产品分类名称
    ,FULL_PRICE_COST_CHG       --全价成本变动
    ,GHB_ZZD_TRUST_ACCT_NUM    --本方中债登托管账号
    ,CNTPTY_ZZD_TRUST_ACCT_NUM --对手中债登托管账号
    ,EFFECT_TM                 --生效时间
    ,STL_DENOM                 --结算面额
    ,ACCTI_TRAN_FLOW_NUM       --核算交易流水号
    ,THEORY_FEE                --理论费用
    ,FEE_COST                  --费用成本
    ,ACCTI_IMPAM_OBJ_FLG       --核算减值对象标志
    ,START_INT_ACCR_DT         --开始计息日期
    ,EXPECT_QTTY               --预计数量
    ,EXPECT_DENOM              --预计面额
    ,OPERR_NAME                --经办人名称
    ,REMARK                    --备注
    ,START_DT                  --开始日期
    ,END_DT                    --结束日期
    ,ID_MARK                   --删除标识
    ,JOB_CD                    --任务代码
    FROM IML.V_EVT_IBANK_TRAN_VCH_INSTR_DTL  --视图-同业券指令明细
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_IBANK_TRAN_VCH_INSTR_DTL;
/

