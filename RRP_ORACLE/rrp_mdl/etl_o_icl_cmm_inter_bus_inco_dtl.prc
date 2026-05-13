CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_INTER_BUS_INCO_DTL(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_INTER_BUS_INCO_DTL
  *  功能描述：中间业务收入明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_INTER_BUS_INCO_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_INTER_BUS_INCO_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_INTER_BUS_INCO_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_INTER_BUS_INCO_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-中间业务收入明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_INTER_BUS_INCO_DTL
    (ETL_DT                          --数据日期
    ,LP_ID                           --法人编号
    ,ACCT_BILL_FLOW_NUM              --账单流水号
    ,TRAN_FLOW_NUM                   --交易流水号
    ,TRAN_DT                         --交易日期
    ,ACCT_DT                         --账务日期
    ,AMORT_FLOW_NUM                  --摊销流水号
    ,SUBJ_ID                         --科目编号
    ,STD_PROD_ID                     --标准产品编号
    ,CUST_ID                         --客户编号
    ,BUS_ACCT_ID                     --业务账户编号
    ,INTNAL_ACCT_ID                  --内部账户编号
    ,INTNAL_ACCT_NAME                --内部账户名称
    ,INTNAL_MAIN_ACCT_ID             --内部主账户编号
    ,TRAN_MAIN_ACCT_ID               --交易主账户编号
    ,TRAN_SUB_ACCT_ID                --交易子账户编号
    ,TRAN_CHN_CD                     --交易渠道代码
    ,BAL_DIR_CD                      --余额方向代码
    ,SORC_SYS_CD                     --源系统代码
    ,CUST_MGR_ID                     --客户经理编号
    ,CHARGE_CD                       --收费代码
    ,CHARGE_NAME                     --收费名称
    ,CHARGE_CATE_CD                  --收费类别代码
    ,AMORT_FLG                       --摊销标志
    ,DEBIT_CRDT_FLG                  --借贷标志
    ,ERASE_ACCT_FLG                  --抹账标志
    ,REVS_FLG                        --冲正标志
    ,TRAN_ORG_ID                     --交易机构编号
    ,ACCT_INSTIT_ID                  --账务机构编号
    ,CURR_CD                         --币种代码
    ,TRAN_AMT                        --交易金额
    ,RECVBL_COMM_FEE_AMT             --应收手续费金额
    ,TRAN_REMARK_INFO                --交易备注信息
    ,JOB_CD                          --任务代码
    )
  SELECT 
     ETL_DT                          --数据日期
    ,LP_ID                           --法人编号
    ,ACCT_BILL_FLOW_NUM              --账单流水号
    ,TRAN_FLOW_NUM                   --交易流水号
    ,TRAN_DT                         --交易日期
    ,ACCT_DT                         --账务日期
    ,AMORT_FLOW_NUM                  --摊销流水号
    ,SUBJ_ID                         --科目编号
    ,STD_PROD_ID                     --标准产品编号
    ,CUST_ID                         --客户编号
    ,BUS_ACCT_ID                     --业务账户编号
    ,INTNAL_ACCT_ID                  --内部账户编号
    ,INTNAL_ACCT_NAME                --内部账户名称
    ,INTNAL_MAIN_ACCT_ID             --内部主账户编号
    ,TRAN_MAIN_ACCT_ID               --交易主账户编号
    ,TRAN_SUB_ACCT_ID                --交易子账户编号
    ,TRAN_CHN_CD                     --交易渠道代码
    ,BAL_DIR_CD                      --余额方向代码
    ,SORC_SYS_CD                     --源系统代码
    ,CUST_MGR_ID                     --客户经理编号
    ,CHARGE_CD                       --收费代码
    ,CHARGE_NAME                     --收费名称
    ,CHARGE_CATE_CD                  --收费类别代码
    ,AMORT_FLG                       --摊销标志
    ,DEBIT_CRDT_FLG                  --借贷标志
    ,ERASE_ACCT_FLG                  --抹账标志
    ,REVS_FLG                        --冲正标志
    ,TRAN_ORG_ID                     --交易机构编号
    ,ACCT_INSTIT_ID                  --账务机构编号
    ,CURR_CD                         --币种代码
    ,TRAN_AMT                        --交易金额
    ,RECVBL_COMM_FEE_AMT             --应收手续费金额
    ,TRAN_REMARK_INFO                --交易备注信息
    ,JOB_CD                          --任务代码
    FROM ICL.V_CMM_INTER_BUS_INCO_DTL  --视图-中间业务收入明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_ICL_CMM_INTER_BUS_INCO_DTL;
/

