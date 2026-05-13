CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS NOLOGGING
  (  ENTRY_ID    --凭证ID
    ,TSK_ID    --任务ID
    ,ENTRY_DATE    --凭证日期
    ,FLOW_ID    --流水号
    ,CHG_ID    --变动ID
    ,INST_ID    --主指令ID
    ,BKKPG_ORG_ID    --记账机构号
    ,SUBJ_ORG_ID    --科目机构码
    ,SUBJ_CODE    --科目码
    ,SUBJ_SUB_CODE    --科目子码
    ,INNER_ACCT_SN    --内部账序号
    ,CORE_ACCT_CODE    --核心账号
    ,STEP    --步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
    ,DEBIT_CREDIT_FLAG    --借贷标识；1：借；2：贷。
    ,RED_BLUE_FLAG    --红蓝字；1：普通；2：红字；3：蓝字。
    ,PENDING_CANCEL_FLAG    --挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
    ,CURRENCY    --币种
    ,VALUE    --借贷值
    ,STATE    --0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
    ,IS_SENDING_CORE    --是否发送核心账号
    ,SECU_ACCT_ID    --券账户
    ,CASH_ACCT_ID    --资金账户
    ,UPDATE_TIME    --更新时间
    ,ESTD_OR_REAL    --理论OR实际核算；E：理论核算；R：实际核算
    ,MEMO    --备注
    ,CORE_ACCT_NAME    --核心账号名称
    ,GRP_FLOW_ID    --合并流水号
    ,ACCTG_OBJ_ID    --核算对象ID
    ,CHG_TYPE    --变动类型
    ,DETAIL_FLAG    --明细标记
    ,SRC_TYPE    --源数据类型
    ,SEND_STATE    --发送状态
    ,IS_MANUAL    --1：手工凭证 0：非手工凭证
    ,EXT_SECU_ACCT_ID    --外部券账户
    ,EXT_CASH_ACCT_ID    --外部资金账户
    ,I9_FLAG    --I9标记
    ,EXT_I_CODE    --金融工具代码
    ,EXT_A_TYPE    --金融工具资产类型
    ,EXT_M_TYPE    --金融工具市场类型
    ,EXT_DIM1    --扩展维度1
    ,EXT_DIM2    --扩展维度2
    ,EXT_DIM3    --扩展维度3
    ,EXT_DIM4    --扩展维度4
    ,EXT_DIM5    --扩展维度5
    ,EXT_DIM6    --扩展维度6
    ,EXT_VALUE1    --扩展值字段1
    ,EXT_VALUE2    --扩展值字段2
    ,EXT_VALUE3    --扩展值3
    ,ETL_DT    --ETL处理日期
    )
  SELECT /*+PARALLEL*/
         ENTRY_ID    --凭证ID
        ,TSK_ID    --任务ID
        ,ENTRY_DATE    --凭证日期
        ,FLOW_ID    --流水号
        ,CHG_ID    --变动ID
        ,INST_ID    --主指令ID
        ,BKKPG_ORG_ID    --记账机构号
        ,SUBJ_ORG_ID    --科目机构码
        ,SUBJ_CODE    --科目码
        ,SUBJ_SUB_CODE    --科目子码
        ,INNER_ACCT_SN    --内部账序号
        ,CORE_ACCT_CODE    --核心账号
        ,STEP    --步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
        ,DEBIT_CREDIT_FLAG    --借贷标识；1：借；2：贷。
        ,RED_BLUE_FLAG    --红蓝字；1：普通；2：红字；3：蓝字。
        ,PENDING_CANCEL_FLAG    --挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
        ,CURRENCY    --币种
        ,VALUE    --借贷值
        ,STATE    --0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
        ,IS_SENDING_CORE    --是否发送核心账号
        ,SECU_ACCT_ID    --券账户
        ,CASH_ACCT_ID    --资金账户
        ,UPDATE_TIME    --更新时间
        ,ESTD_OR_REAL    --理论OR实际核算；E：理论核算；R：实际核算
        ,MEMO    --备注
        ,CORE_ACCT_NAME    --核心账号名称
        ,GRP_FLOW_ID    --合并流水号
        ,ACCTG_OBJ_ID    --核算对象ID
        ,CHG_TYPE    --变动类型
        ,DETAIL_FLAG    --明细标记
        ,SRC_TYPE    --源数据类型
        ,SEND_STATE    --发送状态
        ,IS_MANUAL    --1：手工凭证 0：非手工凭证
        ,EXT_SECU_ACCT_ID    --外部券账户
        ,EXT_CASH_ACCT_ID    --外部资金账户
        ,I9_FLAG    --I9标记
        ,EXT_I_CODE    --金融工具代码
        ,EXT_A_TYPE    --金融工具资产类型
        ,EXT_M_TYPE    --金融工具市场类型
        ,EXT_DIM1    --扩展维度1
        ,EXT_DIM2    --扩展维度2
        ,EXT_DIM3    --扩展维度3
        ,EXT_DIM4    --扩展维度4
        ,EXT_DIM5    --扩展维度5
        ,EXT_DIM6    --扩展维度6
        ,EXT_VALUE1    --扩展值字段1
        ,EXT_VALUE2    --扩展值字段2
        ,EXT_VALUE3    --扩展值3
        ,ETL_DT    --ETL处理日期
   FROM IOL.V_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS   --会计分录历史表_视图
  WHERE ETL_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') --MODIFY BY LIP 20220825 拿当月数据
        /*ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY_HIS;
/

