CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_LC_DOC_INFO(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2
                                                      )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_LC_DOC_INFO
  *  功能描述：信用证单据信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_LC_DOC_INFO
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_LC_DOC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_LC_DOC_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_LC_DOC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-信用证单据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_LC_DOC_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,DOC_AGT_ID                 --单据协议编号
    ,DOC_ID                     --单据编号
    ,LC_ACCT_ID                 --信用证账户编号
    ,STD_PROD_ID                --标准产品编号
    ,COMMER_INV_NO              --商业发票号码
    ,SUBJ_ID                    --科目编号
    ,MX_LC_FLG                  --进出口信用证标志
    ,ARRIVE_BILL_FLG            --到单标志
    ,ACPT_FLG                   --承兑标志
    ,SEND_BILL_DT               --寄单日期
    ,ISSUE_DT                   --开证日期
    ,WRTOFF_DT                  --注销日期
    ,ACPT_DT                    --承兑日期
    ,ARRIVE_BILL_DT             --到单日期
    ,PAY_DT                     --付款日期
    ,PAYER_ID                   --付款人编号
    ,CUST_MGR_ID                --客户经理编号
    ,OPER_ORG_ID                --经办机构编号
    ,PAY_ORG_ID                 --付款机构编号
    ,SIGN_ORG_ID                --签署机构编号
    ,ACCT_INSTIT_ID             --账务机构编号
    ,PAYER_NAME                 --付款人名称
    ,ISSUE_BANK_SWIFTCODE       --开证行SWIFTCODE
    ,ISSUE_BANK_CN_NAME         --开证行中文名称
    ,ISSUE_BANK_NAME            --开证行名称
    ,DOC_TYPE_CD                --单据类型代码
    ,DOC_STATUS_CD              --单据状态代码
    ,CURR_CD                    --币种代码
    ,OVERS_DEDUCT_AMT           --国外扣费金额
    ,PAY_AMT                    --付款金额
    ,LC_BAL                     --信用证余额
    ,CL_CURR_LC_BAL             --折本币信用证余额
    ,CLAIM_AMT                  --索偿金额
    ,JOB_CD                     --任务代码
    )
  SELECT 
     ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,DOC_AGT_ID                 --单据协议编号
    ,DOC_ID                     --单据编号
    ,LC_ACCT_ID                 --信用证账户编号
    ,STD_PROD_ID                --标准产品编号
    ,COMMER_INV_NO              --商业发票号码
    ,SUBJ_ID                    --科目编号
    ,MX_LC_FLG                  --进出口信用证标志
    ,ARRIVE_BILL_FLG            --到单标志
    ,ACPT_FLG                   --承兑标志
    ,SEND_BILL_DT               --寄单日期
    ,ISSUE_DT                   --开证日期
    ,WRTOFF_DT                  --注销日期
    ,ACPT_DT                    --承兑日期
    ,ARRIVE_BILL_DT             --到单日期
    ,PAY_DT                     --付款日期
    ,PAYER_ID                   --付款人编号
    ,CUST_MGR_ID                --客户经理编号
    ,OPER_ORG_ID                --经办机构编号
    ,PAY_ORG_ID                 --付款机构编号
    ,SIGN_ORG_ID                --签署机构编号
    ,ACCT_INSTIT_ID             --账务机构编号
    ,PAYER_NAME                 --付款人名称
    ,ISSUE_BANK_SWIFTCODE       --开证行SWIFTCODE
    ,ISSUE_BANK_CN_NAME         --开证行中文名称
    ,ISSUE_BANK_NAME            --开证行名称
    ,DOC_TYPE_CD                --单据类型代码
    ,DOC_STATUS_CD              --单据状态代码
    ,CURR_CD                    --币种代码
    ,OVERS_DEDUCT_AMT           --国外扣费金额
    ,PAY_AMT                    --付款金额
    ,LC_BAL                     --信用证余额
    ,CL_CURR_LC_BAL             --折本币信用证余额
    ,CLAIM_AMT                  --索偿金额
    ,JOB_CD                     --任务代码
    FROM ICL.V_CMM_LC_DOC_INFO  --视图-信用证单据信息
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

END ETL_O_ICL_CMM_LC_DOC_INFO;
/

