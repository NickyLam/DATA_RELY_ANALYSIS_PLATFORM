CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_SECU_BASE_ASSET_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_SECU_BASE_ASSET_H
  *  功能描述：证券基础资产历史
  *  创建日期：20251114
  *  开发人员：于敬艺
  *  来源表： IML.V_AGT_SECU_BASE_ASSET_H
  *  目标表： O_IML_AGT_SECU_BASE_ASSET_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251114  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_SECU_BASE_ASSET_H'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_SECU_BASE_ASSET_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-证券基础资产历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_SECU_BASE_ASSET_H NOLOGGING
    (    AGT_ID                      --协议编号
        ,LP_ID                       --法人编号
        ,BASE_ASSET_ID               --基础资产编号
        ,ASSET_SRC_CD                --资产来源代码
        ,DUBIL_ID                    --借据编号
        ,LOAN_CONT_ID                --合同编号
        ,SRC_CONT_ID                 --源合同编号
        ,ASSET_TYPE_CD               --资产类型代码
        ,DISTR_DT                    --放款日期
        ,DUBIL_EXP_DT                --借据到期日期
        ,LOAN_TOT_PERDS              --贷款总期数
        ,SURP_PERDS                  --剩余期数
        ,EH_ISSUE_REPAY_DAY          --每期还款日
        ,LOAN_AMT                    --贷款金额
        ,BAD_DEBT_AMT                --坏账金额
        ,OVDUE_AMT                   --逾期金额
        ,LOAN_BAL                    --贷款余额
        ,IDLE_AMT                    --呆滞金额
        ,OVDUE_DT                    --逾期日期
        ,OVDUE_DAYS                  --贷款逾期天数
        ,MAX_EXPE_DAYS               --最大预期天数
        ,PROVI_INT                   --计提利息
        ,RPBL_INT                    --应还利息
        ,PRIC_PNLT                   --本金罚息
        ,INT_PNLT                    --利息罚息
        ,CURR_CD                     --币种代码
        ,LOAN_LEVEL5_CLS_CD          --贷款五级分类代码
        ,EXEC_INT_RAT                --执行利率
        ,LOAN_STATUS_CD              --贷款状态代码
        ,BASE_RAT_TYPE_CD            --基准利率类型代码
        ,BASE_RAT                    --基准利率
        ,INT_RAT_FLOAT_WAY_CD        --利率浮动方式代码
        ,FLO_VAL                     --浮动值
        ,CUST_ID                     --客户编号
        ,SRC_CUST_ID                 --源客户编号
        ,ASSET_STATUS_CD             --资产状态代码
        ,PKG_DT                      --封包日期
        ,ISSUE_DT                    --发行日期
        ,TRAN_COSDETN                --转让对价
        ,OVDUE_INT_RAT               --逾期利率
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
        ,BF_PKG_INT_RECVBL_BAL       --封包前应收利息余额
        ,AFTER_PKG_INT_RECVBL_TOT    --封包后应收利息总额
        ,AFTER_PKG_INT_RECVBL_BAL    --封包后应收利息余额
        ,AFTER_RTN_PKG_INT_RECVBL    --已归还封包后应收利息
        ,TRAN_LOAN_INT_TOT           --转让贷款利息总额
        ,ORG_ID                      --机构编号
        ,START_DT                    --开始时间
        ,END_DT                      --结束时间
        ,ID_MARK                     --增删标志
        ,SRC_TABLE_NAME              --源表名称
        ,JOB_CD                      --任务编码
        ,ETL_TIMESTAMP               --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        AGT_ID                      --协议编号
        ,LP_ID                       --法人编号
        ,BASE_ASSET_ID               --基础资产编号
        ,ASSET_SRC_CD                --资产来源代码
        ,DUBIL_ID                    --借据编号
        ,LOAN_CONT_ID                --合同编号
        ,SRC_CONT_ID                 --源合同编号
        ,ASSET_TYPE_CD               --资产类型代码
        ,DISTR_DT                    --放款日期
        ,DUBIL_EXP_DT                --借据到期日期
        ,LOAN_TOT_PERDS              --贷款总期数
        ,SURP_PERDS                  --剩余期数
        ,EH_ISSUE_REPAY_DAY          --每期还款日
        ,LOAN_AMT                    --贷款金额
        ,BAD_DEBT_AMT                --坏账金额
        ,OVDUE_AMT                   --逾期金额
        ,LOAN_BAL                    --贷款余额
        ,IDLE_AMT                    --呆滞金额
        ,OVDUE_DT                    --逾期日期
        ,OVDUE_DAYS                  --贷款逾期天数
        ,MAX_EXPE_DAYS               --最大预期天数
        ,PROVI_INT                   --计提利息
        ,RPBL_INT                    --应还利息
        ,PRIC_PNLT                   --本金罚息
        ,INT_PNLT                    --利息罚息
        ,CURR_CD                     --币种代码
        ,LOAN_LEVEL5_CLS_CD          --贷款五级分类代码
        ,EXEC_INT_RAT                --执行利率
        ,LOAN_STATUS_CD              --贷款状态代码
        ,BASE_RAT_TYPE_CD            --基准利率类型代码
        ,BASE_RAT                    --基准利率
        ,INT_RAT_FLOAT_WAY_CD        --利率浮动方式代码
        ,FLO_VAL                     --浮动值
        ,CUST_ID                     --客户编号
        ,SRC_CUST_ID                 --源客户编号
        ,ASSET_STATUS_CD             --资产状态代码
        ,PKG_DT                      --封包日期
        ,ISSUE_DT                    --发行日期
        ,TRAN_COSDETN                --转让对价
        ,OVDUE_INT_RAT               --逾期利率
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
        ,BF_PKG_INT_RECVBL_BAL       --封包前应收利息余额
        ,AFTER_PKG_INT_RECVBL_TOT    --封包后应收利息总额
        ,AFTER_PKG_INT_RECVBL_BAL    --封包后应收利息余额
        ,AFTER_RTN_PKG_INT_RECVBL    --已归还封包后应收利息
        ,TRAN_LOAN_INT_TOT           --转让贷款利息总额
        ,ORG_ID                      --机构编号
        ,START_DT                    --开始时间
        ,END_DT                      --结束时间
        ,ID_MARK                     --增删标志
        ,SRC_TABLE_NAME              --源表名称
        ,JOB_CD                      --任务编码
        ,ETL_TIMESTAMP               --ETL处理时间戳
    FROM IML.V_AGT_SECU_BASE_ASSET_H   --证券基础资产历史_视图
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

  END ETL_O_IML_AGT_SECU_BASE_ASSET_H;
/

