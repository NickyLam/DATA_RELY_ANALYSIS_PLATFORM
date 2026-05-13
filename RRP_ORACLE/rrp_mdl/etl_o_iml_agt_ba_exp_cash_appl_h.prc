CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_BA_EXP_CASH_APPL_H(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_BA_EXP_CASH_APPL_H
  *  功能描述：银承到期兑付申请历史
  *  创建日期：20230302
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_BA_EXP_CASH_APPL_H
  *  目标表： O_IML_AGT_BA_EXP_CASH_APPL_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250718  YJY      优化脚本
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_BA_EXP_CASH_APPL_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_BA_EXP_CASH_APPL_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_BA_EXP_CASH_APPL_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-银承到期兑付申请历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_BA_EXP_CASH_APPL_H
    (APPL_ID                 --申请编号
    ,LP_ID                   --法人编号
    ,ORG_ID                  --机构编号
    ,BILL_ID                 --票据编号
    ,VOUCH_ID                --凭证编号
    ,BILL_CURR_CD            --票据币种代码
    ,BILL_AMT                --贴现票据金额
    ,MSG_APPL_TYPE_CD        --报文申请类型代码
    ,APPL_DT                 --申请日期
    ,SUGST_PAY_CURR_CD       --提示付款币种代码
    ,CASH_AMT                --兑付金额
    ,ONL_CLEAR_CD            --线上清算代码
    ,VOUCH_QTTY              --所附凭证数量
    ,SUGST_PAYER_CATE_CD     --提示付款人类别代码
    ,SUGST_PAYER_ORGNZ_CD    --提示付款人组织机构代码
    ,SUGST_PAYER_NAME        --提示付款人名称
    ,SUGST_PAYER_ACCT_ID     --提示付款人账户编号
    ,SUGST_PAYER_OPEN_BANK_NO  --提示付款人开户行行号
    ,CASH_CURR_CD            --兑付币种代码
    ,SUGST_PAY_APPL_DT       --提示付款申请日期
    ,REFUSE_PAY_CD           --拒付代码
    ,APV_STATUS_CD           --审批状态代码
    ,RECV_OPINION_CD         --签收意见代码
    ,SEND_OUT_RECV_STATUS_CD --发出签收明细状态代码
    ,ENTRY_STATUS_CD         --记账状态代码
    ,ENTRY_DT                --记账日期
    ,REVO_DT                 --撤销日期
    ,PAY_TRAN_NUM            --支付交易号
    ,SPEC_PRMSSN_PRTCPTR_ID  --特许参与者编号
    ,POS_APV_STATUS_CD       --头寸审批状态代码
    ,SEND_POS_FLOW_NUM       --发送头寸流水号
    ,ADV_SOLU_PAY_FLG        --提前解付标志
    ,TRAN_TM                 --交易时间
    ,TRAN_DT                 --交易日期
    ,REPLY_TELLER_ID         --回复柜员编号
    ,LT_ID                   --清单编号
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,SRC_TABLE_NAME          --源表名称
    ,JOB_CD                  --任务编码
    ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT 
     APPL_ID                 --申请编号
    ,LP_ID                   --法人编号
    ,ORG_ID                  --机构编号
    ,BILL_ID                 --票据编号
    ,VOUCH_ID                --凭证编号
    ,BILL_CURR_CD            --票据币种代码
    ,BILL_AMT                --贴现票据金额
    ,MSG_APPL_TYPE_CD        --报文申请类型代码
    ,APPL_DT                 --申请日期
    ,SUGST_PAY_CURR_CD       --提示付款币种代码
    ,CASH_AMT                --兑付金额
    ,ONL_CLEAR_CD            --线上清算代码
    ,VOUCH_QTTY              --所附凭证数量
    ,SUGST_PAYER_CATE_CD     --提示付款人类别代码
    ,SUGST_PAYER_ORGNZ_CD    --提示付款人组织机构代码
    ,SUGST_PAYER_NAME        --提示付款人名称
    ,SUGST_PAYER_ACCT_ID     --提示付款人账户编号
    ,SUGST_PAYER_OPEN_BANK_NO  --提示付款人开户行行号
    ,CASH_CURR_CD            --兑付币种代码
    ,SUGST_PAY_APPL_DT       --提示付款申请日期
    ,REFUSE_PAY_CD           --拒付代码
    ,APV_STATUS_CD           --审批状态代码
    ,RECV_OPINION_CD         --签收意见代码
    ,SEND_OUT_RECV_STATUS_CD --发出签收明细状态代码
    ,ENTRY_STATUS_CD         --记账状态代码
    ,ENTRY_DT                --记账日期
    ,REVO_DT                 --撤销日期
    ,PAY_TRAN_NUM            --支付交易号
    ,SPEC_PRMSSN_PRTCPTR_ID  --特许参与者编号
    ,POS_APV_STATUS_CD       --头寸审批状态代码
    ,SEND_POS_FLOW_NUM       --发送头寸流水号
    ,ADV_SOLU_PAY_FLG        --提前解付标志
    ,TRAN_TM                 --交易时间
    ,TRAN_DT                 --交易日期
    ,REPLY_TELLER_ID         --回复柜员编号
    ,LT_ID                   --清单编号
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,SRC_TABLE_NAME          --源表名称
    ,JOB_CD                  --任务编码
    ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IML.V_AGT_BA_EXP_CASH_APPL_H  --视图-银承到期兑付申请历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_BA_EXP_CASH_APPL_H', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_AGT_BA_EXP_CASH_APPL_H;
/

