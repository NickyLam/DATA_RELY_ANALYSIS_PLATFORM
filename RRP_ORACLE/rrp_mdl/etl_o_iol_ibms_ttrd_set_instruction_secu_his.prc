CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：是否已做过理论核算
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-是否已做过理论核算';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS NOLOGGING 
  (            SECU_INST_ID      
              ,SECU_INST_GRP_ID      
              ,INST_ID      
              ,BIZ_TYPE      
              ,DIRECTION      
              ,TRADE_GRP_ID      
              ,SECU_ACCT_ID      
              ,EXT_SECU_ACCT_ID      
              ,I_CODE      
              ,A_TYPE      
              ,M_TYPE      
              ,CURRENCY      
              ,REAL_FEE      
              ,ESTD_AI      
              ,RECEIVED_AI      
              ,ESTD_CP      
              ,REAL_AI      
              ,REAL_CP      
              ,DUE_AI      
              ,DUE_CP      
              ,PRFT_FEE      
              ,IS_REMAIN_DUE_AI      
              ,IS_REMAIN_DUE_CP      
              ,VOLUME      
              ,FREEZE_VOLUME      
              ,IS_FIXED      
              ,CAL_DATE      
              ,SET_DATE      
              ,SET_FINISH_DATE      
              ,I_NAME      
              ,P_CLASS      
              ,COST      
              ,COST_AI_HIS_REAL      
              ,ZZD_ACCT_CODE      
              ,PARTY_ZZD_ACCT_CODE      
              ,CREATE_TIME      
              ,UPDATE_TIME      
              ,UPDATE_USER      
              ,CONFIRM_TIME      
              ,CONFIRM_USER      
              ,ACCOUNT_TIME      
              ,ACCOUNT_USER      
              ,MEMO      
              ,AMOUNT      
              ,CLOSE_TRADE_ID      
              ,BLC_STATE      
              ,ACCTG_STATE      
              ,ESTD_FEE      
              ,FEE      
              ,OPR_STATE      
              ,SECU_INST_SETGRP_ID      
              ,HIS_FLAG      
              ,HIS_SECU_INST_ID      
              ,HIS_SET_FINISH_DATE      
              ,ACCTG_INST_ID      
              ,CANCEL_FLAG      
              ,VOLUME_TERMCUR      
              ,AMOUNT_TERMCUR      
              ,ESTD_CP_TERMCUR      
              ,REAL_CP_TERMCUR      
              ,AMRT_METHOD      
              ,REAL_MARGIN      
              ,FPML      
              ,IS_IMPAIR      
              ,IS_THEORY_ACCT            --是否已做过理论核算
              ,IS_THEORY_BLC             --是否已做权责业务
              ,CL_STATUS                 --占用状态-20代表冻结或者实占-30代表冻结转实占
              ,PARTY_PSET                --结算场所代码
              ,PARTY_PSET_COUNTRY        --国家代码
              ,PARTY_AGENT_CODE_TYPE     --代理行代码类型
              ,PARTY_AGENT_CODE_DSS      --代理行代码编码集合名称
              ,PARTY_AGENT_CODE          --代理行代码
              ,PARTY_AGENT_ACCOUNT       --代理行账号
              ,PARTY_CODE_TYPE           --交易主体代码类型
              ,PARTY_CODE_DSS            --交易主体代码编码集合名称
              ,PARTY_CODE                --交易主体代码
              ,PARTY_ACCOUNT             --交易主体账号
              ,SI_ID                     --证券结算要素ID
              ,CAL_START_DATE            --计息开始日期
              ,ORD_LIMIT_SECU_INST_ID    --审批单限额券指令号
              ,IS_CALC_TAX_4_PRFT_TRD    --卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
              ,ESTD_VOLUME               --预计数量
              ,ESTD_AMOUNT               --预计面额
              ,MODULE_TYPE               --核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
              ,PARTY_PSET_NAME           --结算场所名称
              ,VOLUME_GENINST            --生成指令时持仓数量
              ,CUSTOM_DIM1               --扩展维度1
              ,XCC_MODULE_TYPE           --核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
              ,IS_EDITABLE               --前台是否可修改
              ,MEMO_SECU                 --理论实收付备注信息
              ,DTL_DUE_TYPE              --明细due类型
              ,ETL_DT                    --ETL处理日期
              ,ETL_TIMESTAMP             --ETL处理时间戳
       )
     SELECT 
               SECU_INST_ID      
              ,SECU_INST_GRP_ID      
              ,INST_ID      
              ,BIZ_TYPE      
              ,DIRECTION      
              ,TRADE_GRP_ID      
              ,SECU_ACCT_ID      
              ,EXT_SECU_ACCT_ID      
              ,I_CODE      
              ,A_TYPE      
              ,M_TYPE      
              ,CURRENCY      
              ,REAL_FEE      
              ,ESTD_AI      
              ,RECEIVED_AI      
              ,ESTD_CP      
              ,REAL_AI      
              ,REAL_CP      
              ,DUE_AI      
              ,DUE_CP      
              ,PRFT_FEE      
              ,IS_REMAIN_DUE_AI      
              ,IS_REMAIN_DUE_CP      
              ,VOLUME      
              ,FREEZE_VOLUME      
              ,IS_FIXED      
              ,CAL_DATE      
              ,SET_DATE      
              ,SET_FINISH_DATE      
              ,I_NAME      
              ,P_CLASS      
              ,COST      
              ,COST_AI_HIS_REAL      
              ,ZZD_ACCT_CODE      
              ,PARTY_ZZD_ACCT_CODE      
              ,CREATE_TIME      
              ,UPDATE_TIME      
              ,UPDATE_USER      
              ,CONFIRM_TIME      
              ,CONFIRM_USER      
              ,ACCOUNT_TIME      
              ,ACCOUNT_USER      
              ,MEMO      
              ,AMOUNT      
              ,CLOSE_TRADE_ID      
              ,BLC_STATE      
              ,ACCTG_STATE      
              ,ESTD_FEE      
              ,FEE      
              ,OPR_STATE      
              ,SECU_INST_SETGRP_ID      
              ,HIS_FLAG      
              ,HIS_SECU_INST_ID      
              ,HIS_SET_FINISH_DATE      
              ,ACCTG_INST_ID      
              ,CANCEL_FLAG      
              ,VOLUME_TERMCUR      
              ,AMOUNT_TERMCUR      
              ,ESTD_CP_TERMCUR      
              ,REAL_CP_TERMCUR      
              ,AMRT_METHOD      
              ,REAL_MARGIN      
              ,FPML      
              ,IS_IMPAIR      
              ,IS_THEORY_ACCT            --是否已做过理论核算
              ,IS_THEORY_BLC             --是否已做权责业务
              ,CL_STATUS                 --占用状态-20代表冻结或者实占-30代表冻结转实占
              ,PARTY_PSET                --结算场所代码
              ,PARTY_PSET_COUNTRY        --国家代码
              ,PARTY_AGENT_CODE_TYPE     --代理行代码类型
              ,PARTY_AGENT_CODE_DSS      --代理行代码编码集合名称
              ,PARTY_AGENT_CODE          --代理行代码
              ,PARTY_AGENT_ACCOUNT       --代理行账号
              ,PARTY_CODE_TYPE           --交易主体代码类型
              ,PARTY_CODE_DSS            --交易主体代码编码集合名称
              ,PARTY_CODE                --交易主体代码
              ,PARTY_ACCOUNT             --交易主体账号
              ,SI_ID                     --证券结算要素ID
              ,CAL_START_DATE            --计息开始日期
              ,ORD_LIMIT_SECU_INST_ID    --审批单限额券指令号
              ,IS_CALC_TAX_4_PRFT_TRD    --卖出时买卖损益是否拆税。枚举值：0此字段无效，向前兼容，老项目使用。1拆税，2不拆税
              ,ESTD_VOLUME               --预计数量
              ,ESTD_AMOUNT               --预计面额
              ,MODULE_TYPE               --核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
              ,PARTY_PSET_NAME           --结算场所名称
              ,VOLUME_GENINST            --生成指令时持仓数量
              ,CUSTOM_DIM1               --扩展维度1
              ,XCC_MODULE_TYPE           --核算模块类型,0：做业务余额核算；1：只做业务余额；2：只做核算
              ,IS_EDITABLE               --前台是否可修改
              ,MEMO_SECU                 --理论实收付备注信息
              ,DTL_DUE_TYPE              --明细due类型
              ,ETL_DT                    --ETL处理日期
              ,ETL_TIMESTAMP             --ETL处理时间戳
    FROM IOL.V_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS --视图-是否已做过理论核算
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_IBMS_TTRD_SET_INSTRUCTION_SECU_HIS;
/

