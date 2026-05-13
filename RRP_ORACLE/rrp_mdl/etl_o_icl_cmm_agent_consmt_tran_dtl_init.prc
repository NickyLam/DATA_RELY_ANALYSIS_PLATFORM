CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_AGENT_CONSMT_TRAN_DTL_INIT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_AGENT_CONSMT_TRAN_DTL_INIT
  *  功能描述：代理代销交易明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_AGENT_CONSMT_TRAN_DTL
  *  目标表： O_ICL_CMM_AGENT_CONSMT_TRAN_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_AGENT_CONSMT_TRAN_DTL_INIT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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
  --DELETE FROM O_ICL_CMM_AGENT_CONSMT_TRAN_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_AGENT_CONSMT_TRAN_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-代理代销交易明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_AGENT_CONSMT_TRAN_DTL
  (    ETL_DT                   --数据日期
      ,LP_ID                    --法人编号
      ,TA_CD                    --TA代码
      ,TA_CFM_DT                --TA确认日期
      ,TA_CFM_FLOW_NUM          --TA确认流水号
      ,RELA_FLOW_NUM            --关联流水号
      ,APPL_FORM_ID             --申请单编号
      ,INIT_APPL_FORM_ID        --原申请单编号
      ,CUST_ID                  --客户编号
      ,PROD_ACCT_ID             --产品账户编号
      ,TRAN_ACCT_ID             --交易账户编号
      ,BANK_ACCT_ID             --银行账户编号
      ,PROD_ID                  --产品编号
      ,STD_PROD_ID              --标准产品编号
      ,PROD_NAME                --产品名称
      ,CUST_MGR_ID              --客户经理编号
      ,CONSMT_BUS_TYPE_CD       --代销业务类型代码
      ,SELL_MODE_CD             --销售模式代码
      ,BUS_CD                   --业务代码
      ,CUST_TYPE_CD             --客户类型代码
      ,CURR_CD                  --币种代码
      ,DIVD_WAY_CD              --分红方式代码
      ,HUGE_REDEM_PROC_CD       --巨额赎回处理代码
      ,TRAN_CHN_CD              --交易渠道代码
      ,TRAN_STATUS_CD           --交易状态代码
      ,TRAN_CD                  --交易代码
      ,APPL_LOT                 --申请份额
      ,APPL_AMT                 --申请金额
      ,CFM_LOT                  --确认份额
      ,CFM_AMT                  --确认金额
      ,TRAN_COMM_FEE            --交易手续费
      ,TRAN_RETURN_CODE         --交易返回码
      ,TRAN_RETURN_INFO         --交易返回信息
      ,TRAN_SUBRCH_ID           --交易支行编号
      ,TRAN_ORG_ID              --交易机构编号
      ,TRAN_TELLER_ID           --交易柜员编号
      ,AUTH_TELLER_ID           --授权柜员编号
      ,TRAN_HAPP_DT             --交易发生日期
      ,TRAN_HAPP_TM             --交易发生时间
      ,PROD_NV                  --产品净值
      ,TRAN_AGENT_FEE           --交易代理费
      ,TRAN_BELONG_ORG_ID       --交易归属机构编号
      ,JOB_CD                   --任务代码
    )
    SELECT
       ETL_DT                   --数据日期
      ,LP_ID                    --法人编号
      ,TA_CD                    --TA代码
      ,TA_CFM_DT                --TA确认日期
      ,TA_CFM_FLOW_NUM          --TA确认流水号
      ,RELA_FLOW_NUM            --关联流水号
      ,APPL_FORM_ID             --申请单编号
      ,INIT_APPL_FORM_ID        --原申请单编号
      ,CUST_ID                  --客户编号
      ,PROD_ACCT_ID             --产品账户编号
      ,TRAN_ACCT_ID             --交易账户编号
      ,BANK_ACCT_ID             --银行账户编号
      ,PROD_ID                  --产品编号
      ,STD_PROD_ID              --标准产品编号
      ,PROD_NAME                --产品名称
      ,CUST_MGR_ID              --客户经理编号
      ,CONSMT_BUS_TYPE_CD       --代销业务类型代码
      ,SELL_MODE_CD             --销售模式代码
      ,BUS_CD                   --业务代码
      ,CUST_TYPE_CD             --客户类型代码
      ,CURR_CD                  --币种代码
      ,DIVD_WAY_CD              --分红方式代码
      ,HUGE_REDEM_PROC_CD       --巨额赎回处理代码
      ,TRAN_CHN_CD              --交易渠道代码
      ,TRAN_STATUS_CD           --交易状态代码
      ,TRAN_CD                  --交易代码
      ,APPL_LOT                 --申请份额
      ,APPL_AMT                 --申请金额
      ,CFM_LOT                  --确认份额
      ,CFM_AMT                  --确认金额
      ,TRAN_COMM_FEE            --交易手续费
      ,TRAN_RETURN_CODE         --交易返回码
      ,TRAN_RETURN_INFO         --交易返回信息
      ,TRAN_SUBRCH_ID           --交易支行编号
      ,TRAN_ORG_ID              --交易机构编号
      ,TRAN_TELLER_ID           --交易柜员编号
      ,AUTH_TELLER_ID           --授权柜员编号
      ,TRAN_HAPP_DT             --交易发生日期
      ,TRAN_HAPP_TM             --交易发生时间
      ,PROD_NV                  --产品净值
      ,TRAN_AGENT_FEE           --交易代理费
      ,TRAN_BELONG_ORG_ID       --交易归属机构编号
      ,JOB_CD                   --任务代码
    FROM ICL.V_CMM_AGENT_CONSMT_TRAN_DTL;  --视图-代理代销交易明细

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

  END ETL_O_ICL_CMM_AGENT_CONSMT_TRAN_DTL_INIT;
/

