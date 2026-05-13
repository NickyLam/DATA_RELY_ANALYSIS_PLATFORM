CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_REFAC_LOAN_ATTACH_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_REFAC_LOAN_ATTACH_INFO
  *  功能描述：支小再贷款附加信息
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_REFAC_LOAN_ATTACH_INFO
  *  目标表： O_ICL_CMM_REFAC_LOAN_ATTACH_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_REFAC_LOAN_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-支小再贷款附加信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_REFAC_LOAN_ATTACH_INFO
    (ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,LEVEL1_BATCH_PKG_ID              --一级批次包编号
    ,LEVEL1_BATCH_PKG_NAME            --一级批次包名称
    ,LEVEL2_BATCH_PKG_ID              --二级批次包编号
    ,LEVEL2_BATCH_PKG_NAME            --二级批次包名称
    ,DUBIL_ID                         --借据编号
    ,CUST_ID                          --客户编号
    ,CUST_NAME                        --客户名称
    ,REFAC_INDUS_TYPE_CD              --支小再行业类型代码
    ,INDUS_TYPE_CD                    --行业类型代码
    ,LOAN_TYPE_CD                     --贷款类型代码
    ,CORP_SIZE_CD                     --企业规模代码
    ,CORP_NUMBER                      --企业人数
    ,LAST_YEAR_BUS_INCO               --上年末营业收入
    ,CORP_ASSET_TOT                   --企业资产总额
    ,MANG_MAIN_NAME                   --经营主体名称
    ,MANG_MAIN_CRDT_CD_DESCB          --经营主体信用代码描述
    ,CHECK_SHEET_FLG                  --报账标志
    ,BACKUP_DUBIL_FLG                 --后补借据标志
    ,LOAN_USAGE_DESCB                 --贷款用途描述
    ,REMARK                           --备注
    ,PBC_DOC_NUM                      --人行文件文号
    ,PBC_DOC_NAME                     --人行文件名称
    ,PBC_DOC_DOC_DAY                  --人行文件发文日
    ,PBC_LMT                          --人行额度
    ,APPL_TM                          --申请时间
    ,APPLIT_ID                        --申请人编号
    ,APPL_ORG_ID                      --申请机构编号
    ,REFAC_STATUS_CD                  --支小再状态代码
    ,APV_STATUS_CD                    --审批状态代码
    ,BATCH_PKG_STATUS_CD              --批次包状态代码
    ,REFAC_AMT                        --再贷款金额
    ,SURP_LMT                         --剩余额度
    ,REFAC_CONT_ID                    --再贷款合同编号
    ,REFAC_DISTR_DT                   --再贷款发放日期
    ,REFAC_EXP_DT                     --再贷款到期日期
    ,REFAC_DISTR_MODE_DESCB           --再贷款发放模式描述
    ,REFAC_KIND_DESCB                 --再贷款种类描述
    ,USE_INT_RAT                      --使用利率
    ,INT_ACCR_WAY_DESCB               --计息方式描述
    ,BELONG_LAND_PBC_FIN_INST_CODE    --所属地人民银行金融机构编码
    ,BELONG_LAND_PBC_NAME             --所属地人民银行名称
    ,BELONG_LAND_PBC_CORP_PRINC_NAME  --所属地人民银行单位负责人姓名
    ,CORP_PHONE_NUM                   --单位联系电话号码
    ,CORP_ADDR                        --单位地址
    ,ORG_NAME                         --机构名称
    ,RECVBL_ACCT_ID                   --收款账户编号
    ,PBC_PAY_ACCT_ID                  --人行付款账户编号
    ,PBC_CRED_RHT_TYPE_DESCB          --人民银行债权类型描述
    ,PMO_TYPE_CD                      --抵质押物类型代码
    ,PMO_CONT_ID                      --抵质押物合同编号
    ,PMO_AMT_EVLTION                  --抵质押物金额估值
    ,PMO_AMT_EVLTION_TOT              --抵质押物金额估值汇总
    ,CRED_RHT_BAL                     --债权余额
    ,JOB_CD                           --任务代码
    ,ETL_TIMESTAMP                    --数据处理时间
    ,ACTL_LOAN_DISTR_DT               --实际放款日期
    ,ACTL_LOAN_TERMNT_DT              --实际终止日期
    )
  SELECT 
     ETL_DT                           --数据日期
    ,LP_ID                            --法人编号
    ,LEVEL1_BATCH_PKG_ID              --一级批次包编号
    ,LEVEL1_BATCH_PKG_NAME            --一级批次包名称
    ,LEVEL2_BATCH_PKG_ID              --二级批次包编号
    ,LEVEL2_BATCH_PKG_NAME            --二级批次包名称
    ,DUBIL_ID                         --借据编号
    ,CUST_ID                          --客户编号
    ,CUST_NAME                        --客户名称
    ,REFAC_INDUS_TYPE_CD              --支小再行业类型代码
    ,INDUS_TYPE_CD                    --行业类型代码
    ,LOAN_TYPE_CD                     --贷款类型代码
    ,CORP_SIZE_CD                     --企业规模代码
    ,CORP_NUMBER                      --企业人数
    ,LAST_YEAR_BUS_INCO               --上年末营业收入
    ,CORP_ASSET_TOT                   --企业资产总额
    ,MANG_MAIN_NAME                   --经营主体名称
    ,MANG_MAIN_CRDT_CD_DESCB          --经营主体信用代码描述
    ,CHECK_SHEET_FLG                  --报账标志
    ,BACKUP_DUBIL_FLG                 --后补借据标志
    ,LOAN_USAGE_DESCB                 --贷款用途描述
    ,REMARK                           --备注
    ,PBC_DOC_NUM                      --人行文件文号
    ,PBC_DOC_NAME                     --人行文件名称
    ,PBC_DOC_DOC_DAY                  --人行文件发文日
    ,PBC_LMT                          --人行额度
    ,APPL_TM                          --申请时间
    ,APPLIT_ID                        --申请人编号
    ,APPL_ORG_ID                      --申请机构编号
    ,REFAC_STATUS_CD                  --支小再状态代码
    ,APV_STATUS_CD                    --审批状态代码
    ,BATCH_PKG_STATUS_CD              --批次包状态代码
    ,REFAC_AMT                        --再贷款金额
    ,SURP_LMT                         --剩余额度
    ,REFAC_CONT_ID                    --再贷款合同编号
    ,REFAC_DISTR_DT                   --再贷款发放日期
    ,REFAC_EXP_DT                     --再贷款到期日期
    ,REFAC_DISTR_MODE_DESCB           --再贷款发放模式描述
    ,REFAC_KIND_DESCB                 --再贷款种类描述
    ,USE_INT_RAT                      --使用利率
    ,INT_ACCR_WAY_DESCB               --计息方式描述
    ,BELONG_LAND_PBC_FIN_INST_CODE    --所属地人民银行金融机构编码
    ,BELONG_LAND_PBC_NAME             --所属地人民银行名称
    ,BELONG_LAND_PBC_CORP_PRINC_NAME  --所属地人民银行单位负责人姓名
    ,CORP_PHONE_NUM                   --单位联系电话号码
    ,CORP_ADDR                        --单位地址
    ,ORG_NAME                         --机构名称
    ,RECVBL_ACCT_ID                   --收款账户编号
    ,PBC_PAY_ACCT_ID                  --人行付款账户编号
    ,PBC_CRED_RHT_TYPE_DESCB          --人民银行债权类型描述
    ,PMO_TYPE_CD                      --抵质押物类型代码
    ,PMO_CONT_ID                      --抵质押物合同编号
    ,PMO_AMT_EVLTION                  --抵质押物金额估值
    ,PMO_AMT_EVLTION_TOT              --抵质押物金额估值汇总
    ,CRED_RHT_BAL                     --债权余额
    ,JOB_CD                           --任务代码
    ,ETL_TIMESTAMP                    --数据处理时间
    ,ACTL_LOAN_DISTR_DT               --实际放款日期
    ,ACTL_LOAN_TERMNT_DT              --实际终止日期
    FROM ICL.V_CMM_REFAC_LOAN_ATTACH_INFO  --视图-支小再贷款附加信息
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

END ETL_O_ICL_CMM_REFAC_LOAN_ATTACH_INFO;
/

