CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS
  **存储过程创建日期：20251229
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251229    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS NOLOGGING 
  (            INST_ID      
               ,TRADE_ID      
               ,INST_TYPE      
               ,INST_GRP_ID      
               ,TRD_TYPE      
               ,SET_TYPE      
               ,THEORY_SET_DATE      
               ,REAL_SET_DATE      
               ,H_M_TYPE      
               ,H_A_TYPE      
               ,H_I_CODE      
               ,PARTY_ID      
               ,PARTY_NAME      
               ,ORDER_ID      
               ,IS_THEORY_PAYMENT      
               ,BJ_MARKET      
               ,BJ_STATE      
               ,EXT_ORD_ID      
               ,EXE_MARKET      
               ,CREATE_TIME      
               ,UPDATE_TIME      
               ,UPDATE_USER      
               ,ACCOUNT_TIME      
               ,ACCOUNT_USER      
               ,MEMO      
               ,UPDATE_USER_ID      
               ,CAL_DATE      
               ,REF_CASH_INST_ID      
               ,REF_SECU_INST_ID      
               ,INST_SETGRP_ID      
               ,STATE      
               ,OPERATOR_ID      
               ,OPERATOR_NAME      
               ,PRINT_TIMES              --打印次数
               ,DUE_ORDER                --挂账顺序
               ,DUE_OBJ_KEY              --挂账序号
               ,GENERATE_TYPE            --指令生成类型
               ,REF_INST_ID              --
               ,IS_REAL_ACCTG            --
               ,REAL_ACCOUNT_INST_ID     --实际核算主指令号
               ,IS_UNKNOWN_PRICE         --是否未知价格 0：已知价格 1：未知价格
               ,HIS_FLAG                 --历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
               ,CASH_ACCT_ID             --内部资金账户
               ,HIS_INST_ID              --调账主指令号
               ,HIS_REF_INST_ID          --历史关联主指令号
               ,IS_OPERATOR_CHECKED      --是否进行过资金指令编辑金额校验 0:未校验,1:已校验
               ,ORDDATE                  --交易日
               ,CONDATE                  --确认日期
               ,IS_MATCH                 --是否是清算流水durable结算指令，1：是，其他：不是
               ,SETTLEMODE               --结算类型
               ,HOST_MARKET              --托管场所
               ,SPV_ID                   --spv信息id
               ,PROCESS_TYPE             --    
               ,CLEARING_DATE            --清算日
               ,ACCTG_ESTD_COMPLETED     --理论流程是否完成 0：未完成， 1 已完成
               ,ACCTG_REAL_COMPLETED     --实收流程是否完成 0：未完成， 1 已完成
               ,CLEARING_COMPLETED       --清算是否完成 0：未完成， 1 已完成
               ,IS_PERIOD_INST           --0：非存续期指令 1：存续期指令
               ,TSK_ID                   --任务号
               ,APPROVESTATUS            --0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
               ,BIND_INST_ID             --绑定id
               ,TRADER                   --交易员
               ,XCC_LIMIT_TYPE           --限额指令类型
               ,EXH_EXTORDID             --委托编号
               ,CREATE_USER_ID           --创建人员id
               ,Q_ACCNAME      
               ,Q_SECU_ACCT_ID      
               ,Q_PARTY_ZZD_ACCT_CODE      
               ,Q_P_TYPE      
               ,Q_P_CLASS      
               ,Q_CURRENCY      
               ,Q_I_NAME      
               ,Q_I_ID      
               ,Q_SETTLE_AMOUNT      
               ,Q_TWO_EFFECTIVE_CONTRACT      
               ,TRADE_ORDDATE      
               ,TRADE_IDS      
               ,ORDER_IDS      
               ,TRADE_REF_TYPE      
               ,Q_DESCRIPTION      
               ,IS_REFRESHABLE      
               ,ETL_DT                   --ETL处理日期
               ,ETL_TIMESTAMP            --ETL处理时间戳
       )
     SELECT 
             INST_ID      
               ,TRADE_ID      
               ,INST_TYPE      
               ,INST_GRP_ID      
               ,TRD_TYPE      
               ,SET_TYPE      
               ,THEORY_SET_DATE      
               ,REAL_SET_DATE      
               ,H_M_TYPE      
               ,H_A_TYPE      
               ,H_I_CODE      
               ,PARTY_ID      
               ,PARTY_NAME      
               ,ORDER_ID      
               ,IS_THEORY_PAYMENT      
               ,BJ_MARKET      
               ,BJ_STATE      
               ,EXT_ORD_ID      
               ,EXE_MARKET      
               ,CREATE_TIME      
               ,UPDATE_TIME      
               ,UPDATE_USER      
               ,ACCOUNT_TIME      
               ,ACCOUNT_USER      
               ,MEMO      
               ,UPDATE_USER_ID      
               ,CAL_DATE      
               ,REF_CASH_INST_ID      
               ,REF_SECU_INST_ID      
               ,INST_SETGRP_ID      
               ,STATE      
               ,OPERATOR_ID      
               ,OPERATOR_NAME      
               ,PRINT_TIMES              --打印次数
               ,DUE_ORDER                --挂账顺序
               ,DUE_OBJ_KEY              --挂账序号
               ,GENERATE_TYPE            --指令生成类型
               ,REF_INST_ID              --
               ,IS_REAL_ACCTG            --
               ,REAL_ACCOUNT_INST_ID     --实际核算主指令号
               ,IS_UNKNOWN_PRICE         --是否未知价格 0：已知价格 1：未知价格
               ,HIS_FLAG                 --历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
               ,CASH_ACCT_ID             --内部资金账户
               ,HIS_INST_ID              --调账主指令号
               ,HIS_REF_INST_ID          --历史关联主指令号
               ,IS_OPERATOR_CHECKED      --是否进行过资金指令编辑金额校验 0:未校验,1:已校验
               ,ORDDATE                  --交易日
               ,CONDATE                  --确认日期
               ,IS_MATCH                 --是否是清算流水durable结算指令，1：是，其他：不是
               ,SETTLEMODE               --结算类型
               ,HOST_MARKET              --托管场所
               ,SPV_ID                   --spv信息id
               ,PROCESS_TYPE             --    
               ,CLEARING_DATE            --清算日
               ,ACCTG_ESTD_COMPLETED     --理论流程是否完成 0：未完成， 1 已完成
               ,ACCTG_REAL_COMPLETED     --实收流程是否完成 0：未完成， 1 已完成
               ,CLEARING_COMPLETED       --清算是否完成 0：未完成， 1 已完成
               ,IS_PERIOD_INST           --0：非存续期指令 1：存续期指令
               ,TSK_ID                   --任务号
               ,APPROVESTATUS            --0：需要检查差额审批；1：不需要检查差额审批；2：周期指令新建状态提交差额审批；3：周期指令新建状态提交差额审批审批通过；4：周期指令自动确认状态提交差额审批；5：周期指令自动确认状态提交差额审批审批通过；-1:差额审批拒绝；
               ,BIND_INST_ID             --绑定id
               ,TRADER                   --交易员
               ,XCC_LIMIT_TYPE           --限额指令类型
               ,EXH_EXTORDID             --委托编号
               ,CREATE_USER_ID           --创建人员id
               ,Q_ACCNAME      
               ,Q_SECU_ACCT_ID      
               ,Q_PARTY_ZZD_ACCT_CODE      
               ,Q_P_TYPE      
               ,Q_P_CLASS      
               ,Q_CURRENCY      
               ,Q_I_NAME      
               ,Q_I_ID      
               ,Q_SETTLE_AMOUNT      
               ,Q_TWO_EFFECTIVE_CONTRACT      
               ,TRADE_ORDDATE      
               ,TRADE_IDS      
               ,ORDER_IDS      
               ,TRADE_REF_TYPE      
               ,Q_DESCRIPTION      
               ,IS_REFRESHABLE      
               ,ETL_DT                   --ETL处理日期
               ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_IBMS_TTRD_SET_INSTRUCTION_HIS --视图-
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_HIS;
/

