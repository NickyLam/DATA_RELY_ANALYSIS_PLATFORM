CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_BILL_CENTER_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_BILL_CENTER_INFO
  *  功能描述：票据中心信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BILL_CENTER_INFO
  *  目标表： O_ICL_CMM_BILL_CENTER_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615  梅炜     修改参数
  *             3    20231109  HULJ     优化O层
  *             4    20231206  HULJ     优化O层新增分区
  *             5    20251028  LIP      增加接口字段
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);            --任务名称
  V_PART_NAME VARCHAR2(200);            --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_BILL_CENTER_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_BILL_CENTER_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据中心信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO
    (ETL_DT                  --数据日期
    ,LP_ID                   --法人编号
    ,BILL_ID                 --票据编号
    ,BILL_NUM                --票据号码
    ,BILL_SUB_INTRV_ID       --子票据区间编号
    ,BILL_MED_CD             --票据介质代码
    ,BILL_TYPE_CD            --票据类型代码
    ,BILL_PAY_INT_WAY_CD     --票据付息方式代码
    ,DRAW_DT                 --出票日期
    ,EXP_DT                  --到期日期
    ,DISTR_DT                --放款日期
    ,ACPT_DT                 --承兑日期
    ,CASH_DT                 --兑付日期
    ,CURR_CD                 --币种代码
    ,FAC_VAL_AMT             --票面金额
    ,CUST_ID                 --客户编号
    ,CUST_MGR_ID             --客户经理编号
    ,DRAWER_CUST_ID          --出票人客户编号
    ,DRAWER_NAME             --出票人名称
    ,DRAWER_ACCT_NUM         --出票人账号
    ,DRAWER_OPEN_BANK_NO     --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME   --出票人开户行名称
    ,DRAWER_OPERR_ID         --出票人经办人编号
    ,DRAWER_TYPE_CD          --出票人类型代码
    ,DRAWER_ORGNZ_CD         --出票人组织机构代码
    ,DRAWER_SOCI_CRDT_CD     --出票人社会信用代码
    ,RECVER_NAME             --收款人名称
    ,RECVER_ACCT_NUM         --收款人账号
    ,RECVER_OPEN_BANK_NO     --收款人开户行行号
    ,RECVER_OPEN_BANK_NAME   --收款人开户行名称
    ,PAY_BANK_BANK_NO        --付款行行号
    ,PAY_BANK_NAME           --付款行名称
    ,PAY_ORG_ID              --付款机构编号
    ,PAY_CFM_ORG_ID          --付款确认机构编号
    ,ACCPTOR_NAME            --承兑人名称
    ,ACCPTOR_ACCT_NUM        --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO    --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME  --承兑人开户行名称
    ,ACCPTOR_TYPE_CD         --承兑人类型代码
    ,ACPT_ORG_ID             --承兑机构编号
    ,ACCPTOR_SOCI_CRDT_CD    --承兑人社会信用代码
    ,HOLDER_ORG_ID           --持票人机构编号
    ,HOLDER_ORG_NAME         --持票人机构名称
    ,ENDORS_CNT              --背书次数
    ,LOCK_FLG                --锁定标志
    ,LOSS_FLG                --挂失标志
    ,HXB_ACPT_FLG            --我行承兑标志
    ,PAY_CFM_FLG             --付款确认标志
    ,PAYOFF_FLG              --结清标志
    ,RECS_FLG                --追偿标志
    ,VALET_COLL_FLG          --代客托收标志
    ,RISK_STATUS_CD          --风险状态代码
    ,BILL_SRC_CD             --票据来源代码
    ,BILL_STATUS_CD          --票据状态代码
    ,CCUTION_STATUS_CD       --流转状态代码
    ,INVTRY_STATUS_CD        --库存状态代码
    ,ELE_BILL_STATUS_CD      --电票状态代码
    ,BILL_PROC_MDL_STATUS_CD --票据处理中状态代码
    ,BELONG_ORG_ID           --所属机构编号
    ,RECEIPT_FLG             --小票标志
    ,REDCST_FLG              --再贴现标志
    ,DATA_SRC_CD             --数据来源代码
    ,JOB_CD                  --任务代码
    ,ETL_TIMESTAMP           --数据处理时间
    ,RECVER_SOCI_CRDT_CD     --收款人社会信用代码 --ADD BY LIP 20251028
    ,DISCNT_BANK_ORG_ID      --贴现行机构编号     --ADD BY LIP 20251028
    ,DISCNT_IBANK_NO         --贴现行联行号       --ADD BY LIP 20251028
    ,DISCNT_BANK_NAME        --贴现行名称         --ADD BY LIP 20251028
    )
  SELECT 
     ETL_DT                  --数据日期
    ,LP_ID                   --法人编号
    ,BILL_ID                 --票据编号
    ,BILL_NUM                --票据号码
    ,BILL_SUB_INTRV_ID       --子票据区间编号
    ,BILL_MED_CD             --票据介质代码
    ,BILL_TYPE_CD            --票据类型代码
    ,BILL_PAY_INT_WAY_CD     --票据付息方式代码
    ,DRAW_DT                 --出票日期
    ,EXP_DT                  --到期日期
    ,DISTR_DT                --放款日期
    ,ACPT_DT                 --承兑日期
    ,CASH_DT                 --兑付日期
    ,CURR_CD                 --币种代码
    ,FAC_VAL_AMT             --票面金额
    ,CUST_ID                 --客户编号
    ,CUST_MGR_ID             --客户经理编号
    ,DRAWER_CUST_ID          --出票人客户编号
    ,DRAWER_NAME             --出票人名称
    ,DRAWER_ACCT_NUM         --出票人账号
    ,DRAWER_OPEN_BANK_NO     --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME   --出票人开户行名称
    ,DRAWER_OPERR_ID         --出票人经办人编号
    ,DRAWER_TYPE_CD          --出票人类型代码
    ,DRAWER_ORGNZ_CD         --出票人组织机构代码
    ,DRAWER_SOCI_CRDT_CD     --出票人社会信用代码
    ,RECVER_NAME             --收款人名称
    ,RECVER_ACCT_NUM         --收款人账号
    ,RECVER_OPEN_BANK_NO     --收款人开户行行号
    ,RECVER_OPEN_BANK_NAME   --收款人开户行名称
    ,PAY_BANK_BANK_NO        --付款行行号
    ,PAY_BANK_NAME           --付款行名称
    ,PAY_ORG_ID              --付款机构编号
    ,PAY_CFM_ORG_ID          --付款确认机构编号
    ,ACCPTOR_NAME            --承兑人名称
    ,ACCPTOR_ACCT_NUM        --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO    --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME  --承兑人开户行名称
    ,ACCPTOR_TYPE_CD         --承兑人类型代码
    ,ACPT_ORG_ID             --承兑机构编号
    ,ACCPTOR_SOCI_CRDT_CD    --承兑人社会信用代码
    ,HOLDER_ORG_ID           --持票人机构编号
    ,HOLDER_ORG_NAME         --持票人机构名称
    ,ENDORS_CNT              --背书次数
    ,LOCK_FLG                --锁定标志
    ,LOSS_FLG                --挂失标志
    ,HXB_ACPT_FLG            --我行承兑标志
    ,PAY_CFM_FLG             --付款确认标志
    ,PAYOFF_FLG              --结清标志
    ,RECS_FLG                --追偿标志
    ,VALET_COLL_FLG          --代客托收标志
    ,RISK_STATUS_CD          --风险状态代码
    ,BILL_SRC_CD             --票据来源代码
    ,BILL_STATUS_CD          --票据状态代码
    ,CCUTION_STATUS_CD       --流转状态代码
    ,INVTRY_STATUS_CD        --库存状态代码
    ,ELE_BILL_STATUS_CD      --电票状态代码
    ,BILL_PROC_MDL_STATUS_CD --票据处理中状态代码
    ,BELONG_ORG_ID           --所属机构编号
    ,RECEIPT_FLG             --小票标志
    ,REDCST_FLG              --再贴现标志
    ,DATA_SRC_CD             --数据来源代码
    ,JOB_CD                  --任务代码
    ,ETL_TIMESTAMP           --数据处理时间
    ,RECVER_SOCI_CRDT_CD     --收款人社会信用代码 --ADD BY LIP 20251028
    ,DISCNT_BANK_ORG_ID      --贴现行机构编号     --ADD BY LIP 20251028
    ,DISCNT_IBANK_NO         --贴现行联行号       --ADD BY LIP 20251028
    ,DISCNT_BANK_NAME        --贴现行名称         --ADD BY LIP 20251028
    FROM ICL.V_CMM_BILL_CENTER_INFO  --视图-票据中心信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  --程序跑批结束记录
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

END ETL_O_ICL_CMM_BILL_CENTER_INFO;
/

