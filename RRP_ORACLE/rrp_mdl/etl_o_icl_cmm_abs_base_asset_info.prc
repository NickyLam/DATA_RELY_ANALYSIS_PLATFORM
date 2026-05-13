CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_ABS_BASE_ASSET_INFO(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_ABS_BASE_ASSET_INFO
  *  功能描述：资产证券化基础资产信息，将数据从视图落地
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：  ICL.V_CMM_ABS_BASE_ASSET_INFO
  *  目标表：  O_ICL_CMM_ABS_BASE_ASSET_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
                2    20220615  梅炜      修改参数
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_ABS_BASE_ASSET_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'O_ICL_CMM_ABS_BASE_ASSET_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产证券化基础信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_ABS_BASE_ASSET_INFO
    (ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,BASE_ASSET_ID               --基础资产编号
    ,DUBIL_ID                    --借据编号
    ,CONT_ID                     --合同编号
    ,LOAN_CONT_ID                --贷款合同编号
    ,ASSET_POOL_ID               --资产池编号
    ,CURR_CD                     --币种代码
    ,LOAN_AMT                    --贷款金额
    ,BAD_DEBT_AMT                --坏账金额
    ,OVDUE_AMT                   --逾期金额
    ,LOAN_BAL                    --贷款余额
    ,IDLE_AMT                    --呆滞金额
    ,ASSET_STATUS_CD             --资产状态代码
    ,TRAN_COSDETN                --转让对价
    ,PKG_BELONG_HXB_INT          --封包时归属我行利息
    ,PKG_PRIC_BAL                --封包时本金余额
    ,PKG_ASSET_BAL               --封包时资产余额
    ,PKG_BELONG_HXB_INT_RAT      --封包时归属我行利率
    ,REDEM_BELONG_HXB_INT        --赎回时归属我行利息
    ,REDEM_BELONG_TRUST_INT      --赎回时归属信托利息
    ,REDEM_COSDETN               --赎回对价
    ,REDEM_BELONG_TRUST_PRIC     --赎回时归属信托本金
    ,REDEM_COSDETN_PRIC          --赎回对价本金
    ,REDEM_COSDETN_INT           --赎回对价利息
    ,PKG_BF_INT_RECVBL_BAL       --封包前应收利息余额
    ,PKG_POST_INT_RECVBL_TOT     --封包后应收利息总额
    ,PKG_POST_INT_RECVBL_BAL     --封包后应收利息余额
    ,RTN_PKG_POST_INT_RECVBL     --已归还封包后应收利息
    ,TRAN_LOAN_INT_TOT           --转让贷款利息总额
    ,RECVBL_ACCT_ID              --收款账户编号
    ,RECVBL_ACCT_NAME            --收款账户名称
    ,RECVBL_ACCT_BELONG_ORG_ID   --收款账户所属机构编号
    ,JOB_CD                      --任务代码
    ,ETL_TIMESTAMP               --数据处理时间
    ,RPBL_INT                    --
    ,CUST_ID                     --客户编号
    )
  SELECT 
     ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,BASE_ASSET_ID               --基础资产编号
    ,DUBIL_ID                    --借据编号
    ,CONT_ID                     --合同编号
    ,LOAN_CONT_ID                --贷款合同编号
    ,ASSET_POOL_ID               --资产池编号
    ,CURR_CD                     --币种代码
    ,LOAN_AMT                    --贷款金额
    ,BAD_DEBT_AMT                --坏账金额
    ,OVDUE_AMT                   --逾期金额
    ,LOAN_BAL                    --贷款余额
    ,IDLE_AMT                    --呆滞金额
    ,ASSET_STATUS_CD             --资产状态代码
    ,TRAN_COSDETN                --转让对价
    ,PKG_BELONG_HXB_INT          --封包时归属我行利息
    ,PKG_PRIC_BAL                --封包时本金余额
    ,PKG_ASSET_BAL               --封包时资产余额
    ,PKG_BELONG_HXB_INT_RAT      --封包时归属我行利率
    ,REDEM_BELONG_HXB_INT        --赎回时归属我行利息
    ,REDEM_BELONG_TRUST_INT      --赎回时归属信托利息
    ,REDEM_COSDETN               --赎回对价
    ,REDEM_BELONG_TRUST_PRIC     --赎回时归属信托本金
    ,REDEM_COSDETN_PRIC          --赎回对价本金
    ,REDEM_COSDETN_INT           --赎回对价利息
    ,PKG_BF_INT_RECVBL_BAL       --封包前应收利息余额
    ,PKG_POST_INT_RECVBL_TOT     --封包后应收利息总额
    ,PKG_POST_INT_RECVBL_BAL     --封包后应收利息余额
    ,RTN_PKG_POST_INT_RECVBL     --已归还封包后应收利息
    ,TRAN_LOAN_INT_TOT           --转让贷款利息总额
    ,RECVBL_ACCT_ID              --收款账户编号
    ,RECVBL_ACCT_NAME            --收款账户名称
    ,RECVBL_ACCT_BELONG_ORG_ID   --收款账户所属机构编号
    ,JOB_CD                      --任务代码
    ,ETL_TIMESTAMP               --数据处理时间
    ,RPBL_INT                    --
    ,CUST_ID                     --客户编号
    FROM ICL.V_CMM_ABS_BASE_ASSET_INFO
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

END ETL_O_ICL_CMM_ABS_BASE_ASSET_INFO;
/

