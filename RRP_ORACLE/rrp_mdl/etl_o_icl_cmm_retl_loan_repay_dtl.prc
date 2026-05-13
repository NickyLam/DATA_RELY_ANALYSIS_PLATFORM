CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_RETL_LOAN_REPAY_DTL(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_RETL_LOAN_REPAY_DTL
  *  功能描述：零售贷款还款明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_RETL_LOAN_REPAY_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20240506  YJY      新增冲账标志
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_RETL_LOAN_REPAY_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_RETL_LOAN_REPAY_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款还款明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,ACCT_ID                    --账户编号
    ,DUBIL_ID                   --借据编号
    ,CONT_ID                    --合同编号
    ,CUST_ID                    --客户编号
    ,REPAY_ACCT_ID              --还款账户编号
    ,REPAY_FLOW_ID              --还款流水编号
    ,REPAY_DT                   --还款日期
    ,REPAYBL_DT                 --应还款日期
    ,REPAY_PERDS                --还款期数
    ,REPAY_SUB_PERDS            --还款子期数
    ,ADV_REPAY_FLG              --提前还款标志
    ,OVDUE_REPAY_FLG            --逾期还款标志
    ,COMP_REPAY_FLG             --代偿还款标志
    ,BF_REPAY_STATUS_CD         --还款前还款状态代码
    ,REPAY_POST_REPAY_STATUS_CD --还款后还款状态代码
    ,ACRU_NON_ACRU_CD           --应计非应计代码
    ,TRAN_CD                    --交易代码
    ,CURR_CD                    --币种代码
    ,DTL_SEQ_NUM                --明细序号
    ,REPAY_EVT_CD               --还款事件代码
    ,REPAY_EVT_DESCB            --还款事件描述
    ,CURRT_REPAY_RECVBL_ACRU_INT --当期还款应收应计利息
    ,CURRT_REPAY_COLL_ACRU_INT   --当期还款催收应计利息
    ,CURRT_REPAY_RECVBL_OVER_INT --当期还款应收欠息
    ,CURRT_REPAY_COLL_OVER_INT   --当期还款催收欠息
    ,CURRT_REPAY_RECVBL_ACRU_PNLT --当期还款应收应计罚息
    ,CURRT_REPAY_COLL_ACRU_PNLT  --当期还款催收应计罚息
    ,CURRT_REPAY_RECVBL_PNLT     --当期还款应收罚息
    ,CURRT_REPAY_COLL_PNLT       --当期还款催收罚息
    ,CURRT_REPAY_ACRU_COMP_INT   --当期还款应计复息
    ,CURRT_REPAY_RECVBL_COMP_INT --当期还款应收复息
    ,CURRT_FINE                  --当期罚金
    ,CURRT_WRT_OFF_INT           --当期核销利息
    ,CURR_NOMAL_PRIC_BAL         --当前正常本金余额
    ,CURRT_REPAY_PRIC            --当期还款本金
    ,CURRT_REPAY_INT             --当期还款利息
    ,CURRT_REPAY_PNLT            --当期还款罚息
    ,CURRT_REPAY_COMP_INT        --当期还款复利
    ,CURRT_REPAY_FEE             --当期还款费用
    ,UNBD_INT                    --未入账利息
    ,JOB_CD                      --任务代码
    ,STRK_BAL_FLG                --冲账标志   add by yjy 20240506
    )
  SELECT 
     ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,ACCT_ID                    --账户编号
    ,DUBIL_ID                   --借据编号
    ,CONT_ID                    --合同编号
    ,CUST_ID                    --客户编号
    ,REPAY_ACCT_ID              --还款账户编号
    ,REPAY_FLOW_ID              --还款流水编号
    ,REPAY_DT                   --还款日期
    ,REPAYBL_DT                 --应还款日期
    ,REPAY_PERDS                --还款期数
    ,REPAY_SUB_PERDS            --还款子期数
    ,ADV_REPAY_FLG              --提前还款标志
    ,OVDUE_REPAY_FLG            --逾期还款标志
    ,COMP_REPAY_FLG             --代偿还款标志
    ,BF_REPAY_STATUS_CD         --还款前还款状态代码
    ,REPAY_POST_REPAY_STATUS_CD --还款后还款状态代码
    ,ACRU_NON_ACRU_CD           --应计非应计代码
    ,TRAN_CD                    --交易代码
    ,CURR_CD                    --币种代码
    ,DTL_SEQ_NUM                --明细序号
    ,REPAY_EVT_CD               --还款事件代码
    ,REPAY_EVT_DESCB            --还款事件描述
    ,CURRT_REPAY_RECVBL_ACRU_INT --当期还款应收应计利息
    ,CURRT_REPAY_COLL_ACRU_INT   --当期还款催收应计利息
    ,CURRT_REPAY_RECVBL_OVER_INT --当期还款应收欠息
    ,CURRT_REPAY_COLL_OVER_INT   --当期还款催收欠息
    ,CURRT_REPAY_RECVBL_ACRU_PNLT --当期还款应收应计罚息
    ,CURRT_REPAY_COLL_ACRU_PNLT  --当期还款催收应计罚息
    ,CURRT_REPAY_RECVBL_PNLT     --当期还款应收罚息
    ,CURRT_REPAY_COLL_PNLT       --当期还款催收罚息
    ,CURRT_REPAY_ACRU_COMP_INT   --当期还款应计复息
    ,CURRT_REPAY_RECVBL_COMP_INT --当期还款应收复息
    ,CURRT_FINE                  --当期罚金
    ,CURRT_WRT_OFF_INT           --当期核销利息
    ,CURR_NOMAL_PRIC_BAL         --当前正常本金余额
    ,CURRT_REPAY_PRIC            --当期还款本金
    ,CURRT_REPAY_INT             --当期还款利息
    ,CURRT_REPAY_PNLT            --当期还款罚息
    ,CURRT_REPAY_COMP_INT        --当期还款复利
    ,CURRT_REPAY_FEE             --当期还款费用
    ,UNBD_INT                    --未入账利息
    ,JOB_CD                      --任务代码
    ,STRK_BAL_FLG                --冲账标志   add by yjy 20240506
    FROM ICL.V_CMM_RETL_LOAN_REPAY_DTL  --视图-零售贷款还款明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_O_ICL_CMM_RETL_LOAN_REPAY_DTL;
/

