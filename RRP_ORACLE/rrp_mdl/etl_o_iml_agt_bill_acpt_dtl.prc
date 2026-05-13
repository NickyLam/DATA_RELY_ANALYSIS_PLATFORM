CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_BILL_ACPT_DTL(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_BILL_ACPT_DTL
  *  功能描述：票据承兑明细
  *  创建日期：20230302
  *  开发人员：梅炜
  *  来源表： IML.V_AGT_BILL_ACPT_DTL
  *  目标表： O_IML_AGT_BILL_ACPT_DTL
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_BILL_ACPT_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_BILL_ACPT_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_BILL_ACPT_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据承兑明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_BILL_ACPT_DTL
    (AGT_ID                     --协议编号
    ,LP_ID                      --法人编号
    ,ACPT_DTL_ID                --承兑明细编号
    ,BATCH_ID                   --批次编号
    ,BILL_ID                    --票据编号
    ,COMM_FEE                   --手续费
    ,TODOS                      --工本费
    ,EXP_UNCOND_PAY_ENTR_CD     --到期无条件支付委托代码
    ,PAY_BANK_IBANK_NO          --付款行联行号
    ,LMT_DEDUCT_AMT             --额度扣减金额
    ,BILL_ACPT_PROC_STATUS_CD   --票据承兑处理状态代码
    ,RECV_DT                    --签收日期
    ,ENTRY_STATUS_CD            --记账状态代码
    ,RECV_OPINION_CD            --签收意见代码
    ,FINAL_MODIF_TM             --最后修改时间
    ,ACCPTOR_AGENT_REPLY_CD     --承兑人代理回复代码
    ,ENTRY_DT                   --记账日期
    ,REVO_DT                    --撤销日期
    ,DRAW_STATUS_CD             --出票状态代码
    ,PAYOFF_FLG                 --结清标志
    ,BILL_PKG_INTRV_ID          --票据包区间编号
    ,BILL_AMT                   --票据金额
    ,BILL_INTRV_CORP_AMT        --票据区间标准金额
    ,BILL_INTRV_QTTY            --票据区间数量
    ,CRDT_OUT_ACCT_FLOW_NUM     --信贷出账流水号
    ,H_DATA_FLG                 --历史数据标志
    ,BILL_NUM                   --票据号码
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    )
  SELECT 
     AGT_ID                     --协议编号
    ,LP_ID                      --法人编号
    ,ACPT_DTL_ID                --承兑明细编号
    ,BATCH_ID                   --批次编号
    ,BILL_ID                    --票据编号
    ,COMM_FEE                   --手续费
    ,TODOS                      --工本费
    ,EXP_UNCOND_PAY_ENTR_CD     --到期无条件支付委托代码
    ,PAY_BANK_IBANK_NO          --付款行联行号
    ,LMT_DEDUCT_AMT             --额度扣减金额
    ,BILL_ACPT_PROC_STATUS_CD   --票据承兑处理状态代码
    ,RECV_DT                    --签收日期
    ,ENTRY_STATUS_CD            --记账状态代码
    ,RECV_OPINION_CD            --签收意见代码
    ,FINAL_MODIF_TM             --最后修改时间
    ,ACCPTOR_AGENT_REPLY_CD     --承兑人代理回复代码
    ,ENTRY_DT                   --记账日期
    ,REVO_DT                    --撤销日期
    ,DRAW_STATUS_CD             --出票状态代码
    ,PAYOFF_FLG                 --结清标志
    ,BILL_PKG_INTRV_ID          --票据包区间编号
    ,BILL_AMT                   --票据金额
    ,BILL_INTRV_CORP_AMT        --票据区间标准金额
    ,BILL_INTRV_QTTY            --票据区间数量
    ,CRDT_OUT_ACCT_FLOW_NUM     --信贷出账流水号
    ,H_DATA_FLG                 --历史数据标志
    ,BILL_NUM                   --票据号码
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IML.V_AGT_BILL_ACPT_DTL  --视图-票据承兑明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_BILL_ACPT_DTL', '', O_ERRCODE);

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

END ETL_O_IML_AGT_BILL_ACPT_DTL;
/

