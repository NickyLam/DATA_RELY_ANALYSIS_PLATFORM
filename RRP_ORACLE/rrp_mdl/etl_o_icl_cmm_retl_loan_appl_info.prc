CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_RETL_LOAN_APPL_INFO(I_P_DATE IN INTEGER,
                                                              O_ERRCODE OUT VARCHAR2
                                                              )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_RETL_LOAN_APPL_INFO
  *  功能描述：零售贷款申请信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_RETL_LOAN_APPL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20230208  hulj     新增字段入账账户清算银行行号
  *             3    20250904  YJY      新增白户标志  
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_RETL_LOAN_APPL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款申请信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO
    (ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,LOAN_APPL_FLOW_NUM          --贷款申请流水号
    ,BUS_FLOW_NUM                --业务流水号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户姓名
    ,PROD_ID                     --产品编号
    ,PROD_NAME                   --产品名称
    ,BELONG_ORG_ID               --所属机构编号
    ,BELONG_BRCH_ID              --所属分行编号
    ,ACCESS_CHN_ID               --接入渠道编号
    ,CHN_ID                      --渠道编号
    ,LOAN_USAGE_CD               --贷款用途代码
    ,SPEC_USAGE                  --具体用途
    ,REPAY_SRC_CD                --还款来源代码
    ,GHB_EMPLY_FLG               --本行员工标志
    ,FINAL_JUD_ADVISE_SUCS_FLG   --终审通知成功标志
    ,DISTR_ADVISE_SUCS_FLG       --放款通知成功标志
    ,BLIP_DOC_FLG                --有影像文件标志
    ,OPEN_ACCT_SUCS_FLG          --开户成功标志
    ,NETW_VRFCTION_STATUS_FLG    --联网核查状态标志
    ,CRDTC_QUE_SITU_FLG          --征信查询情况标志
    ,MAIN_DEBIT_PS_CERT_TYPE_CD  --主借人证件类型代码
    ,MAIN_DEBIT_PS_CERT_ID       --主借人证件编号
    ,ACCT_INSTIT_ID              --账务机构编号
    ,MGMT_ORG_ID                 --管理机构编号
    ,APPL_AMT                    --申请金额
    ,CRDT_AMT                    --授信金额
    ,SCORE_VAL                   --评分分值
    ,FIRST_TRIAL_APV_STATUS_CD   --初审审批状态代码
    ,FIRST_TRIAL_APPL_DT         --初审申请日期
    ,FIRST_TRIAL_APPL_TM         --初审申请时间
    ,FIRST_TRIAL_END_TM          --初审结束时间
    ,FINAL_JUD_APPL_DT           --终审申请日期
    ,FINAL_JUD_APPL_TM           --终审申请时间
    ,FINAL_JUD_APV_LMT           --终审审批额度
    ,FINAL_JUD_APV_STATUS_CD     --终审审批状态代码
    ,APV_OPINION                 --审批意见
    ,APV_CONCUS                  --审批结论
    ,FINAL_JUD_END_TM            --终审结束时间
    ,REFUSE_RS                   --拒绝原因
    ,ESPEC_LOAN_FLG              --特殊贷款标志
    ,TAX_NUM                     --纳税人识别号
    ,HOUSING_CNT_CD              --住房套数代码
    ,HOUSE_FIRST_PAY_AMT         --房屋首付额
    ,HOUSE_TOT_PRICE             --房屋总价
    ,JOB_CD                      --任务代码
    ,LOAN_USAGE_SUBCLASS_CD      --贷款用途细类
    ,ENTER_CLEAR_BK_NO           --入账账户清算银行行号
    ,ACCT_FLG                    --白户标志 MOD BY YJY 20250904
    )
  SELECT 
     ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,LOAN_APPL_FLOW_NUM          --贷款申请流水号
    ,BUS_FLOW_NUM                --业务流水号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户姓名
    ,PROD_ID                     --产品编号
    ,PROD_NAME                   --产品名称
    ,BELONG_ORG_ID               --所属机构编号
    ,BELONG_BRCH_ID              --所属分行编号
    ,ACCESS_CHN_ID               --接入渠道编号
    ,CHN_ID                      --渠道编号
    ,LOAN_USAGE_CD               --贷款用途代码
    ,SPEC_USAGE                  --具体用途
    ,REPAY_SRC_CD                --还款来源代码
    ,GHB_EMPLY_FLG               --本行员工标志
    ,FINAL_JUD_ADVISE_SUCS_FLG   --终审通知成功标志
    ,DISTR_ADVISE_SUCS_FLG       --放款通知成功标志
    ,BLIP_DOC_FLG                --有影像文件标志
    ,OPEN_ACCT_SUCS_FLG          --开户成功标志
    ,NETW_VRFCTION_STATUS_FLG    --联网核查状态标志
    ,CRDTC_QUE_SITU_FLG          --征信查询情况标志
    ,MAIN_DEBIT_PS_CERT_TYPE_CD  --主借人证件类型代码
    ,MAIN_DEBIT_PS_CERT_ID       --主借人证件编号
    ,ACCT_INSTIT_ID              --账务机构编号
    ,MGMT_ORG_ID                 --管理机构编号
    ,APPL_AMT                    --申请金额
    ,CRDT_AMT                    --授信金额
    ,SCORE_VAL                   --评分分值
    ,FIRST_TRIAL_APV_STATUS_CD   --初审审批状态代码
    ,FIRST_TRIAL_APPL_DT         --初审申请日期
    ,FIRST_TRIAL_APPL_TM         --初审申请时间
    ,FIRST_TRIAL_END_TM          --初审结束时间
    ,FINAL_JUD_APPL_DT           --终审申请日期
    ,FINAL_JUD_APPL_TM           --终审申请时间
    ,FINAL_JUD_APV_LMT           --终审审批额度
    ,FINAL_JUD_APV_STATUS_CD     --终审审批状态代码
    ,APV_OPINION                 --审批意见
    ,APV_CONCUS                  --审批结论
    ,FINAL_JUD_END_TM            --终审结束时间
    ,REFUSE_RS                   --拒绝原因
    ,ESPEC_LOAN_FLG              --特殊贷款标志
    ,TAX_NUM                     --纳税人识别号
    ,HOUSING_CNT_CD              --住房套数代码
    ,HOUSE_FIRST_PAY_AMT         --房屋首付额
    ,HOUSE_TOT_PRICE             --房屋总价
    ,JOB_CD                      --任务代码
    ,LOAN_USAGE_SUBCLASS_CD      --贷款用途细类
    ,ENTER_CLEAR_BK_NO           --入账账户清算银行行号
    ,ACCT_FLG                    --白户标志 MOD BY YJY 20250904
    FROM ICL.V_CMM_RETL_LOAN_APPL_INFO  --视图-零售贷款申请信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_RETL_LOAN_APPL_INFO','', O_ERRCODE);

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

END ETL_O_ICL_CMM_RETL_LOAN_APPL_INFO;
/

