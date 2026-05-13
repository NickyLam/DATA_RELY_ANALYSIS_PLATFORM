CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_LP_OD_SIGN_INFO(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_LP_OD_SIGN_INFO
  *  功能描述：法透签约信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_LP_OD_SIGN_INFO
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_LP_OD_SIGN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_LP_OD_SIGN_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_LP_OD_SIGN_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-法透签约信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_LP_OD_SIGN_INFO
    (ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,CRDT_APPL_ID                     --签约协议编号
    ,DUBIL_ID                         --借据编号
    ,CONT_ID                          --合同编号
    ,OD_ACCT_ID                       --透支账户编号
    ,OD_SUB_ACCT_ID                   --透支子户编号
    ,CUST_ID                          --客户编号
    ,LOAN_ORG_ID                      --贷款机构编号
    ,CUST_MGR_ID                      --客户经理编号
    ,SIGN_FLOW_NUM                    --签约流水号
    ,INT_RAT_REVAL_CD                 --利率重定价代码
    ,INT_SET_WAY_CD                   --结息方式代码
    ,CRDT_STATUS_CD                   --信用状态代码
    ,OD_SERV_STATUS_CD                --透支服务状态代码
    ,LP_OD_TYPE_CD                    --法透类型代码
    --,TENOR_CD                       --期限代码
    ,BASE_RAT_CD                      --基准利率代码
    ,SIGN_DT                          --签约日期
    ,LMT_START_DT                     --额度开始日期
    ,LMT_EXP_DT                       --额度到期日期
    ,SIG_OD_VALID_DAYS                --单笔透支有效天数
    ,OD_LMT_UPLMI                     --透支额度上限
    ,START_OD_AMT                     --起透金额
    ,OD_PROMIS_FEE                    --透支承诺费
    ,OD_LMT                           --透支额度
    ,USED_OD_LMT                      --已用透支额度
    ,SURP_OD_LMT                      --剩余透支额度
    ,NOMAL_INT_RAT_FL_RT              --正常利率浮动比例
    ,OVDUE_INT_RAT_FL_RT              --逾期利率浮动比例
    ,NOMAL_LOAN_INT_RAT               --正常贷款利率
    ,OVDUE_LOAN_INT_RAT               --逾期贷款利率
    ,JOB_CD                           --任务代码
    )
  SELECT 
     ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,CRDT_APPL_ID                     --签约协议编号
    ,DUBIL_ID                         --借据编号
    ,CONT_ID                          --合同编号
    ,OD_ACCT_ID                       --透支账户编号
    ,OD_SUB_ACCT_ID                   --透支子户编号
    ,CUST_ID                          --客户编号
    ,LOAN_ORG_ID                      --贷款机构编号
    ,CUST_MGR_ID                      --客户经理编号
    ,SIGN_FLOW_NUM                    --签约流水号
    ,INT_RAT_REVAL_CD                 --利率重定价代码
    ,INT_SET_WAY_CD                   --结息方式代码
    ,CRDT_STATUS_CD                   --信用状态代码
    ,OD_SERV_STATUS_CD                --透支服务状态代码
    ,LP_OD_TYPE_CD                    --法透类型代码
    --,TENOR_CD                       --期限代码
    ,BASE_RAT_CD                      --基准利率代码
    ,SIGN_DT                          --签约日期
    ,LMT_START_DT                     --额度开始日期
    ,LMT_EXP_DT                       --额度到期日期
    ,SIG_OD_VALID_DAYS                --单笔透支有效天数
    ,OD_LMT_UPLMI                     --透支额度上限
    ,START_OD_AMT                     --起透金额
    ,OD_PROMIS_FEE                    --透支承诺费
    ,OD_LMT                           --透支额度
    ,USED_OD_LMT                      --已用透支额度
    ,SURP_OD_LMT                      --剩余透支额度
    ,NOMAL_INT_RAT_FL_RT              --正常利率浮动比例
    ,OVDUE_INT_RAT_FL_RT              --逾期利率浮动比例
    ,NOMAL_LOAN_INT_RAT               --正常贷款利率
    ,OVDUE_LOAN_INT_RAT               --逾期贷款利率
    ,JOB_CD                           --任务代码
    FROM ICL.V_CMM_LP_OD_SIGN_INFO  --视图-法透签约信息
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

END ETL_O_ICL_CMM_LP_OD_SIGN_INFO;
/

