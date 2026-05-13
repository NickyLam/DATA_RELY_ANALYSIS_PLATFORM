CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY
  **存储过程创建日期：20220707
  **存储过程创建人：  赖海强
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

   SELECT CASE WHEN V_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN V_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN V_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN V_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN V_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN V_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;

  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
 EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY NOLOGGING
  (  ENTRY_ID   --凭证ID
    ,TSK_ID   --任务ID
    ,ENTRY_DATE   --凭证日期
    ,FLOW_ID   --流水号
    ,CHG_ID   --变动ID
    ,INST_ID   --主指令ID
    ,BKKPG_ORG_ID   --记账机构号
    ,SUBJ_ORG_ID   --科目机构码
    ,SUBJ_CODE   --科目码
    ,SUBJ_SUB_CODE   --科目子码
    ,INNER_ACCT_SN   --内部账序号
    ,CORE_ACCT_CODE   --核心账号
    ,STEP   --步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
    ,DEBIT_CREDIT_FLAG   --借贷标识；1：借；2：贷。
    ,RED_BLUE_FLAG   --红蓝字；1：普通；2：红字；3：蓝字。
    ,PENDING_CANCEL_FLAG   --挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
    ,CURRENCY   --币种
    ,VALUE   --借贷值
    ,STATE   --0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
    ,IS_SENDING_CORE   --是否发送核心账号
    ,SECU_ACCT_ID   --券账户
    ,CASH_ACCT_ID   --资金账户
    ,UPDATE_TIME   --更新时间
    ,ESTD_OR_REAL   --理论OR实际核算；E：理论核算；R：实际核算
    ,MEMO   --备注
    ,CORE_ACCT_NAME   --核心账号名称
    ,GRP_FLOW_ID   --合并流水号
    ,ACCTG_OBJ_ID   --核算对象ID
    ,CHG_TYPE   --变动类型
    ,DETAIL_FLAG	  --明细标记
    ,SRC_TYPE	  --源数据类型
    ,SEND_STATE	  --发送状态
    ,IS_MANUAL	  --1：手工凭证 0：非手工凭证
    ,EXT_SECU_ACCT_ID	  --外部券账户
    ,EXT_CASH_ACCT_ID	  --外部资金账户
    ,I9_FLAG	  --I9标记
    ,EXT_I_CODE	  --金融工具代码
    ,EXT_A_TYPE	  --金融工具资产类型
    ,EXT_M_TYPE	  --金融工具市场类型
    ,EXT_DIM1	  --扩展维度1
    ,EXT_DIM2	  --扩展维度2
    ,EXT_DIM3	  --扩展维度3
    ,EXT_DIM4	  --扩展维度4
    ,EXT_DIM5	  --扩展维度5
    ,EXT_DIM6	  --扩展维度6
    ,EXT_VALUE1	  --扩展值字段1
    ,EXT_VALUE2	  --扩展值字段2
    ,EXT_VALUE3	  --扩展值3
    ,ETL_DT	  --ETL处理日期
    )
  SELECT /*+PARALLEL*/
      ENTRY_ID	  --凭证ID
      ,TSK_ID	  --任务ID
      ,ENTRY_DATE	  --凭证日期
      ,FLOW_ID	  --流水号
      ,CHG_ID	  --变动ID
      ,INST_ID	  --主指令ID
      ,BKKPG_ORG_ID	  --记账机构号
      ,SUBJ_ORG_ID	  --科目机构码
      ,SUBJ_CODE	  --科目码
      ,SUBJ_SUB_CODE	  --科目子码
      ,INNER_ACCT_SN	  --内部账序号
      ,CORE_ACCT_CODE	  --核心账号
      ,STEP	  --步骤；0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
      ,DEBIT_CREDIT_FLAG	  --借贷标识；1：借；2：贷。
      ,RED_BLUE_FLAG	  --红蓝字；1：普通；2：红字；3：蓝字。
      ,PENDING_CANCEL_FLAG	  --挂销账标识；0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
      ,CURRENCY	  --币种
      ,VALUE	  --借贷值
      ,STATE	  --0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
      ,IS_SENDING_CORE	  --是否发送核心账号
      ,SECU_ACCT_ID	  --券账户
      ,CASH_ACCT_ID	  --资金账户
      ,UPDATE_TIME	  --更新时间
      ,ESTD_OR_REAL	  --理论OR实际核算；E：理论核算；R：实际核算
      ,MEMO	  --备注
      ,CORE_ACCT_NAME	  --核心账号名称
      ,GRP_FLOW_ID	  --合并流水号
      ,ACCTG_OBJ_ID	  --核算对象ID
      ,CHG_TYPE	  --变动类型
      ,DETAIL_FLAG	  --明细标记
      ,SRC_TYPE	  --源数据类型
      ,SEND_STATE	  --发送状态
      ,IS_MANUAL	  --1：手工凭证 0：非手工凭证
      ,EXT_SECU_ACCT_ID	  --外部券账户
      ,EXT_CASH_ACCT_ID	  --外部资金账户
      ,I9_FLAG	  --I9标记
      ,EXT_I_CODE	  --金融工具代码
      ,EXT_A_TYPE	  --金融工具资产类型
      ,EXT_M_TYPE	  --金融工具市场类型
      ,EXT_DIM1	  --扩展维度1
      ,EXT_DIM2	  --扩展维度2
      ,EXT_DIM3	  --扩展维度3
      ,EXT_DIM4	  --扩展维度4
      ,EXT_DIM5	  --扩展维度5
      ,EXT_DIM6	  --扩展维度6
      ,EXT_VALUE1	  --扩展值字段1
      ,EXT_VALUE2	  --扩展值字段2
      ,EXT_VALUE3	  --扩展值3
      ,ETL_DT	  --ETL处理日期

    FROM IOL.V_IBMS_TTRD_BOOKKEEPING_ENTRY   --会计分录表_视图
    WHERE ETL_DT = V_DATE
   ;
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


END ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_ENTRY;
/

