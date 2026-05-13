CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_RGST_CTER_BILL_INFO_PARA(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_RGST_CTER_BILL_INFO_PARA
  *  功能描述：登记中心票据信息参数
  *  创建日期：20230113
  *  开发人员：MW
  *  来源表： IML.V_REF_RGST_CTER_BILL_INFO_PARA
  *  目标表： O_IML_REF_RGST_CTER_BILL_INFO_PARA
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230113  MW     首次创建
  *             2    20241226  YJY    优化脚本
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_RGST_CTER_BILL_INFO_PARA'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_RGST_CTER_BILL_INFO_PARA'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_REF_RGST_CTER_BILL_INFO_PARA T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_RGST_CTER_BILL_INFO_PARA';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-登记中心票据信息参数';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_RGST_CTER_BILL_INFO_PARA
    (RGST_ID                --登记编号
    ,LP_ID                  --法人编号
    ,INIT_BILL_SYS_BILL_ID  --原票据系统票据编号
    ,BILL_NUM               --票据号码
    ,BILL_MED_CD            --票据介质代码
    ,BILL_TYPE_CD           --票据类型代码
    ,DRAW_DT                --出票日期
    ,EXP_DT                 --到期日期
    ,BILL_AMT               --贴现票据金额
    ,DRAWER_NAME            --出票人名称
    ,DRAWER_ACCT_NUM        --出票人账号
    ,DRAWER_OPEN_BANK_NO    --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME  --出票人开户行名称
    ,DRAWER_SOCI_CRDT_CD    --出票人社会信用代码
    ,ACCPTOR_NAME           --承兑人名称
    ,ACCPTOR_ACCT_NUM       --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO   --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME --承兑人开户行名称
    ,ACCPTOR_SOCI_CRDT_CD   --承兑人社会信用代码
    ,RECVER_NAME            --收款人名称
    ,RECVER_OPEN_BANK_NAME  --收款人开户行名称
    ,RECVER_ACCT_NUM        --收款人账号
    ,RECVER_OPEN_BANK_NO    --收款人开户行行号
    ,RECVER_SOCI_CRDT_CD    --收款人社会信用代码
    ,PAY_BANK_NO            --付款行行号
    ,PAY_BANK_ORG_CD        --付款行机构代码
    ,PAY_BANK_NAME          --付款行名称
    ,PAY_CFM_ORG_CD         --付款确认机构代码
    ,ACPT_GUAR_BANK_NO      --承兑保证行行号
    ,COLL_BANK_NO           --托收行行号
    ,HOLDER_NAME            --持票人名称
    ,HOLDER_SOCI_CRDT_CD    --持票人社会信用代码
    ,HOLDER_ACCT_NUM        --持票人账号
    ,HOLDER_ORG_CD          --持票人机构代码
    ,HOLDER_ORG_NAME        --持票人机构名称
    ,RISK_BILL_STATUS_CD    --风险票据状态代码
    ,BILL_INVTRY_STATUS_CD  --票据库存状态代码
    ,BILL_SRC_CD            --票据来源代码
    ,BILL_CCUTION_STATUS_CD --票据流转状态代码
    ,BILL_STATUS_CD         --票据状态代码
    ,COMB_STATUS_CD         --组合状态代码
    ,DISCNT_BK_ORG_CD       --贴现行机构代码
    ,DISCNT_BANK_NAME       --贴现行名称
    ,INVTRY_ORG_CD          --库存机构代码
    ,INIT_BELONG_RGST_ORG_CD  --初始权属登记机构代码
    ,BILL_BELONG_ORG_ID     --票据所属机构编号
    ,HQ_ORG_ID              --总行机构编号
    ,HXB_ACPT_FLG           --我行承兑标志
    ,PAY_CFM_FLG            --付款确认标志
    ,LOCK_FLG               --锁定标志
    ,PAYOFF_FLG             --结清标志
    ,RECS_FLG               --追偿标志
    ,DISCNT_DT              --贴现日期
    ,TRAN_CD                --转让代码
    ,RECEIPT_FLG            --小票标志
    ,BILL_SUB_INTRV_ID      --票据子区间号
    ,BILL_INTRV_STD_AMT     --票据区间标准金额
    ,INIT_BILL_ID           --原始票据编号
    ,SELECT_ID              --挑票编号
    ,ACTL_BF_SPLIT_BILL_ID  --实际拆前票据编号
    ,ACTL_BF_SPLIT_INTRV_ID --实际拆前区间编号
    ,REMARK_1               --备注1
    ,START_DT               --开始时间
    ,END_DT                 --结束时间
    ,ID_MARK                --增删标志
    ,SRC_TABLE_NAME         --源表名称
    ,JOB_CD                 --任务编码
    ,ETL_TIMESTAMP          --ETL处理时间戳
    ,PAYOFF_DT              --结清日期
    )
  SELECT 
     RGST_ID                --登记编号
    ,LP_ID                  --法人编号
    ,INIT_BILL_SYS_BILL_ID  --原票据系统票据编号
    ,BILL_NUM               --票据号码
    ,BILL_MED_CD            --票据介质代码
    ,BILL_TYPE_CD           --票据类型代码
    ,DRAW_DT                --出票日期
    ,EXP_DT                 --到期日期
    ,BILL_AMT               --贴现票据金额
    ,DRAWER_NAME            --出票人名称
    ,DRAWER_ACCT_NUM        --出票人账号
    ,DRAWER_OPEN_BANK_NO    --出票人开户行行号
    ,DRAWER_OPEN_BANK_NAME  --出票人开户行名称
    ,DRAWER_SOCI_CRDT_CD    --出票人社会信用代码
    ,ACCPTOR_NAME           --承兑人名称
    ,ACCPTOR_ACCT_NUM       --承兑人账号
    ,ACCPTOR_OPEN_BANK_NO   --承兑人开户行行号
    ,ACCPTOR_OPEN_BANK_NAME --承兑人开户行名称
    ,ACCPTOR_SOCI_CRDT_CD   --承兑人社会信用代码
    ,RECVER_NAME            --收款人名称
    ,RECVER_OPEN_BANK_NAME  --收款人开户行名称
    ,RECVER_ACCT_NUM        --收款人账号
    ,RECVER_OPEN_BANK_NO    --收款人开户行行号
    ,RECVER_SOCI_CRDT_CD    --收款人社会信用代码
    ,PAY_BANK_NO            --付款行行号
    ,PAY_BANK_ORG_CD        --付款行机构代码
    ,PAY_BANK_NAME          --付款行名称
    ,PAY_CFM_ORG_CD         --付款确认机构代码
    ,ACPT_GUAR_BANK_NO      --承兑保证行行号
    ,COLL_BANK_NO           --托收行行号
    ,HOLDER_NAME            --持票人名称
    ,HOLDER_SOCI_CRDT_CD    --持票人社会信用代码
    ,HOLDER_ACCT_NUM        --持票人账号
    ,HOLDER_ORG_CD          --持票人机构代码
    ,HOLDER_ORG_NAME        --持票人机构名称
    ,RISK_BILL_STATUS_CD    --风险票据状态代码
    ,BILL_INVTRY_STATUS_CD  --票据库存状态代码
    ,BILL_SRC_CD            --票据来源代码
    ,BILL_CCUTION_STATUS_CD --票据流转状态代码
    ,BILL_STATUS_CD         --票据状态代码
    ,COMB_STATUS_CD         --组合状态代码
    ,DISCNT_BK_ORG_CD       --贴现行机构代码
    ,DISCNT_BANK_NAME       --贴现行名称
    ,INVTRY_ORG_CD          --库存机构代码
    ,INIT_BELONG_RGST_ORG_CD  --初始权属登记机构代码
    ,BILL_BELONG_ORG_ID     --票据所属机构编号
    ,HQ_ORG_ID              --总行机构编号
    ,HXB_ACPT_FLG           --我行承兑标志
    ,PAY_CFM_FLG            --付款确认标志
    ,LOCK_FLG               --锁定标志
    ,PAYOFF_FLG             --结清标志
    ,RECS_FLG               --追偿标志
    ,DISCNT_DT              --贴现日期
    ,TRAN_CD                --转让代码
    ,RECEIPT_FLG            --小票标志
    ,BILL_SUB_INTRV_ID      --票据子区间号
    ,BILL_INTRV_STD_AMT     --票据区间标准金额
    ,INIT_BILL_ID           --原始票据编号
    ,SELECT_ID              --挑票编号
    ,ACTL_BF_SPLIT_BILL_ID  --实际拆前票据编号
    ,ACTL_BF_SPLIT_INTRV_ID --实际拆前区间编号
    ,REMARK_1               --备注1
    ,START_DT               --开始时间
    ,END_DT                 --结束时间
    ,ID_MARK                --增删标志
    ,SRC_TABLE_NAME         --源表名称
    ,JOB_CD                 --任务编码
    ,ETL_TIMESTAMP          --ETL处理时间戳
    ,PAYOFF_DT              --结清日期
    FROM IML.V_REF_RGST_CTER_BILL_INFO_PARA  --视图-登记中心票据信息参数
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

END ETL_O_IML_REF_RGST_CTER_BILL_INFO_PARA;
/

