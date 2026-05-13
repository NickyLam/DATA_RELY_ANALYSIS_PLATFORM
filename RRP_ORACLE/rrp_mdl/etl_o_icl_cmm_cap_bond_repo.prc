CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CAP_BOND_REPO(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CAP_BOND_REPO
  *  功能描述：资金债券回购
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CAP_BOND_REPO
  *  目标表： O_ICL_CMM_CAP_BOND_REPO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CAP_BOND_REPO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_CAP_BOND_REPO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资金债券回购';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CAP_BOND_REPO
    (ETL_DT                       --ETL处理日期
    ,LP_ID                        --法人编号
    ,BUS_ID                       --业务编号
    ,REPO_TYPE_CD                 --回购类型代码
    ,DEPT_ID                      --部门编号
    ,ENTRY_ORG_ID                 --记账机构编号
    ,TRAN_ACCT_B_ID               --交易账簿编号
    ,TRAN_ACCT_B_NAME             --交易账簿名称
    ,STD_PROD_ID                  --标准产品编号
    ,CUST_ID                      --客户编号
    ,CNTPTY_ID                    --交易对手编号
    ,CNTPTY_NAME                  --交易对手名称
    ,PORTF_ID                     --投组编号
    ,PORTF_NAME                   --投组名称
    ,SUBJ_ID                      --科目编号
    ,TRAN_DIR_CD                  --交易方向代码
    ,TRAN_DT                      --交易日期
    ,VALUE_DT                     --起息日期
    ,EXP_DT                       --到期日期
    ,TENOR                        --期限
    ,TRAN_AMT                     --交易金额
    ,EXP_STL_AMT                  --到期结算金额
    ,CURR_CD                      --币种代码
    ,REPO_INT_RAT                 --回购利率
    ,BOND_FAC_VAL_COMB            --债券面值组合
    ,INPWN_RATIO_COMB             --质押比例组合
    ,BOND_ID_COMB                 --债券编号组合
    ,BOND_NAME_COMB               --债券名称组合
    ,ACRU_INT                     --应计利息
    ,FST_STL_WAY_CD               --首期结算方式代码
    ,EXP_STL_WAY_CD               --到期结算方式代码
    ,TRAN_FEE                     --交易费用
    ,TRAN_TAX                     --交易税金
    ,TRAN_COMM                    --交易佣金
    ,DEALER_ID                    --交易员编号
    ,DEALER_NAME                  --交易员名称
    ,TRAN_ID                      --交易编号
    ,BAG_ID                       --成交编号
    ,INT_RECVBL                   --应收利息
    ,TRAN_CLEAR_ACCT_ID           --交易清算账户编号
    ,TRAN_CLEAR_BANK_NO           --交易清算银行行号
    ,ASSET_THD_CLS_CD             --资产三分类代码
    ,INT_RECVBL_SUBJ_ID           --应收利息科目编号
    ,INT_INCOME_SUBJ_ID           --利息收入科目编号
    ,BOOK_BAL                     --账面余额
    ,EXP_NET_PRICE                --到期净价
    ,CURR_BAL                     --当前余额
    ,REPO_ID                      --回购编号
    ,ACCT_B_ATTR_CD               --账簿属性代码
    ,CLEAR_TYPE_CD                --清算类型代码
    ,TRAN_CLEAR_BANK_NAME         --交易清算银行名称
    ,JOB_CD                       --任务代码
    )
  SELECT 
     ETL_DT                       --ETL处理日期
    ,LP_ID                        --法人编号
    ,BUS_ID                       --业务编号
    ,REPO_TYPE_CD                 --回购类型代码
    ,DEPT_ID                      --部门编号
    ,ENTRY_ORG_ID                 --记账机构编号
    ,TRAN_ACCT_B_ID               --交易账簿编号
    ,TRAN_ACCT_B_NAME             --交易账簿名称
    ,STD_PROD_ID                  --标准产品编号
    ,CUST_ID                      --客户编号
    ,CNTPTY_ID                    --交易对手编号
    ,CNTPTY_NAME                  --交易对手名称
    ,PORTF_ID                     --投组编号
    ,PORTF_NAME                   --投组名称
    ,SUBJ_ID                      --科目编号
    ,TRAN_DIR_CD                  --交易方向代码
    ,TRAN_DT                      --交易日期
    ,VALUE_DT                     --起息日期
    ,EXP_DT                       --到期日期
    ,TENOR                        --期限
    ,TRAN_AMT                     --交易金额
    ,EXP_STL_AMT                  --到期结算金额
    ,CURR_CD                      --币种代码
    ,REPO_INT_RAT                 --回购利率
    ,BOND_FAC_VAL_COMB            --债券面值组合
    ,INPWN_RATIO_COMB             --质押比例组合
    ,BOND_ID_COMB                 --债券编号组合
    ,BOND_NAME_COMB               --债券名称组合
    ,ACRU_INT                     --应计利息
    ,FST_STL_WAY_CD               --首期结算方式代码
    ,EXP_STL_WAY_CD               --到期结算方式代码
    ,TRAN_FEE                     --交易费用
    ,TRAN_TAX                     --交易税金
    ,TRAN_COMM                    --交易佣金
    ,DEALER_ID                    --交易员编号
    ,DEALER_NAME                  --交易员名称
    ,TRAN_ID                      --交易编号
    ,BAG_ID                       --成交编号
    ,INT_RECVBL                   --应收利息
    ,TRAN_CLEAR_ACCT_ID           --交易清算账户编号
    ,TRAN_CLEAR_BANK_NO           --交易清算银行行号
    ,ASSET_THD_CLS_CD             --资产三分类代码
    ,INT_RECVBL_SUBJ_ID           --应收利息科目编号
    ,INT_INCOME_SUBJ_ID           --利息收入科目编号
    ,BOOK_BAL                     --账面余额
    ,EXP_NET_PRICE                --到期净价
    ,CURR_BAL                     --当前余额
    ,REPO_ID                      --回购编号
    ,ACCT_B_ATTR_CD               --账簿属性代码
    ,CLEAR_TYPE_CD                --清算类型代码
    ,TRAN_CLEAR_BANK_NAME         --交易清算银行名称
    ,JOB_CD                       --任务代码
    FROM ICL.V_CMM_CAP_BOND_REPO  --视图-资金债券回购
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

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

END ETL_O_ICL_CMM_CAP_BOND_REPO;
/

