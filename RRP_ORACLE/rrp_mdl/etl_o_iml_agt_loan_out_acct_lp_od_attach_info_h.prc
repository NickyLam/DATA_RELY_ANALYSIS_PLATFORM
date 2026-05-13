CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H
  *  功能描述：贷款出账法人透支附属信息历史
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IML.V_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H
  *  目标表： O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-贷款出账法人透支附属信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H NOLOGGING
    (       APPL_ID                      --申请编号
            ,LP_ID                       --法人编号
            ,OUT_ACCT_FLOW_NUM           --出账流水号
            ,CONT_ID                     --合同编号
            ,TEXT_CONT_ID                --文本合同编号
            ,CONT_AMT                    --合同金额
            ,OD_CUST_ID                  --透支客户编号
            ,OD_ACCT_ID                  --透支账户编号
            ,OD_CUST_NAME                --透支客户名称
            ,OD_SUB_ACCT_NUM             --透支子账号
            ,PROD_ID                     --产品编号
            ,CURR_CD                     --币种代码
            ,OD_LMT                      --透支额度
            ,OD_INT_RAT                  --透支利率
            ,START_OD_AMT                --起透金额
            ,REVAL_WAY_CD                --重定价方式代码
            ,BASE_INT_RAT                --基准利率
            ,BASE_RAT_TYPE_CD            --基准利率类型代码
            ,NOMAL_LOAN_EXEC_INT_RAT     --正常贷款执行利率
            ,NOMAL_LOAN_FLOAT_INT_RAT    --正常贷款浮动利率
            ,COMM_FEE_FEE_RAT            --手续费费率
            ,OD_PROMIS_FEE               --透支承诺费用
            ,OD_REPAY_WAY_CD             --透支还款方式代码
            ,RECVBL_FREQ_CD              --收款频率代码
            ,CHARGE_DT                   --收费日
            ,SIG_OD_VALID_DAYS           --单笔透支有效天数
            ,OVDUE_EXEC_INT_RAT          --逾期执行利率
            ,LP_OD_NACRSM_FREE_INT_DAYS  --法透不跨月免息天数
            ,LP_OD_LMT_BEGIN_DT          --法透额度起始日期
            ,LP_OD_LMT_EXP_DT            --法透额度到期日期
            ,OVDUE_LOAN_FLOAT_INT_RAT    --逾期贷款浮动利率
            ,LP_OD_NOT_ACRS_MON_IDF_CD   --法透不跨月标识代码
            ,LP_OD_TYPE_CD               --法人透支类型代码
            ,TEMP_STORE_FLG              --暂存标志
            ,BUID_BUS_GUAR_LOAN_TYPE_CD  --创业担保贷款类型代码
            ,PRIOR_USE_ACCT_BAL_FLG      --优先使用账户余额标志
            ,BUID_BUS_GUAR_LOAN_FLG      --创业担保贷款标志
            ,NAT_STD_INDUS_DIR_CD        --国标行业投向代码
            ,AGCLT_FLG                   --涉农贷款标志
            ,AGCLT_LOAN_MAIN_TYPE_CD     --涉农贷款主体类型代码
            ,AGCLT_LOAN_DIR_CD           --涉农贷款用途类型代码
            ,LAND_FIN_PLAT_CAP_SRC_CD    --地方融资平台偿债资金来源代码
            ,PLA_TRAST_WAY_CD            --贷款办理方式代码
            ,INT_SET_WAY_CD              --结息方式代码
            ,FILE_INT_FLG                --靠档利息标志
            ,CAP_USAGE_DESCB             --资金用途描述
            ,MOVE_REMARK                 --迁移备注
            ,RGST_DT                     --登记日期
            ,OPER_TELLER_ID              --经办柜员编号
            ,OPER_DT                     --经办日期
            ,RGST_TELLER_ID              --登记柜员编号
            ,RGST_ORG_ID                 --登记机构编号
            ,LOAN_ORG_ID                 --贷款机构编号
            ,UPDATE_TELLER_ID            --更新柜员编号
            ,UPDATE_ORG_ID               --更新机构编号
            ,START_DT                    --开始时间
            ,END_DT                      --结束时间
            ,ID_MARK                     --增删标志
            ,SRC_TABLE_NAME              --源表名称
            ,JOB_CD                      --任务编码
            ,ETL_TIMESTAMP               --ETL处理时间戳
            ,SRC_AGT_ID                  --源协议编号
            ,TASK_STATUS_CD              --任务状态代码
            ,INT_RAT_FLOAT_PED           --利率浮动周期代码
            ,INT_RAT_FLOAT_WAY_CD        --利率浮动方式代码
            ,COMM_FEE_CHARGE_DAY         --手续费收费日
            ,COMM_FEE_COLL_WAY_CD        --手续费收取方式代码
            ,COMM_FEE_CHARGE_FREQ_CD     --手续费收费频率代码
            ,SUP_CHAIN_FIN_BUS_FLG       --供应链金融业务标志
            ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD  --供应链金融业务产品分类代码
            ,NATNAL_ECON_TYPE_CD         --国民经济类型代码
            ,CORP_SIZE_CD                --企业规模代码
            ,RISK_CLS_REST_CD            --风险分类结果代码
            ,DMIC_ST_MSG_SEND_CD         --业务提醒短信发送时机代码
            ,FINAL_UPDATE_DT             --最后更新日期
     )
  SELECT /*+PARALLEL*/
           APPL_ID                      --申请编号
            ,LP_ID                       --法人编号
            ,OUT_ACCT_FLOW_NUM           --出账流水号
            ,CONT_ID                     --合同编号
            ,TEXT_CONT_ID                --文本合同编号
            ,CONT_AMT                    --合同金额
            ,OD_CUST_ID                  --透支客户编号
            ,OD_ACCT_ID                  --透支账户编号
            ,OD_CUST_NAME                --透支客户名称
            ,OD_SUB_ACCT_NUM             --透支子账号
            ,PROD_ID                     --产品编号
            ,CURR_CD                     --币种代码
            ,OD_LMT                      --透支额度
            ,OD_INT_RAT                  --透支利率
            ,START_OD_AMT                --起透金额
            ,REVAL_WAY_CD                --重定价方式代码
            ,BASE_INT_RAT                --基准利率
            ,BASE_RAT_TYPE_CD            --基准利率类型代码
            ,NOMAL_LOAN_EXEC_INT_RAT     --正常贷款执行利率
            ,NOMAL_LOAN_FLOAT_INT_RAT    --正常贷款浮动利率
            ,COMM_FEE_FEE_RAT            --手续费费率
            ,OD_PROMIS_FEE               --透支承诺费用
            ,OD_REPAY_WAY_CD             --透支还款方式代码
            ,RECVBL_FREQ_CD              --收款频率代码
            ,CHARGE_DT                   --收费日
            ,SIG_OD_VALID_DAYS           --单笔透支有效天数
            ,OVDUE_EXEC_INT_RAT          --逾期执行利率
            ,LP_OD_NACRSM_FREE_INT_DAYS  --法透不跨月免息天数
            ,LP_OD_LMT_BEGIN_DT          --法透额度起始日期
            ,LP_OD_LMT_EXP_DT            --法透额度到期日期
            ,OVDUE_LOAN_FLOAT_INT_RAT    --逾期贷款浮动利率
            ,LP_OD_NOT_ACRS_MON_IDF_CD   --法透不跨月标识代码
            ,LP_OD_TYPE_CD               --法人透支类型代码
            ,TEMP_STORE_FLG              --暂存标志
            ,BUID_BUS_GUAR_LOAN_TYPE_CD  --创业担保贷款类型代码
            ,PRIOR_USE_ACCT_BAL_FLG      --优先使用账户余额标志
            ,BUID_BUS_GUAR_LOAN_FLG      --创业担保贷款标志
            ,NAT_STD_INDUS_DIR_CD        --国标行业投向代码
            ,AGCLT_FLG                   --涉农贷款标志
            ,AGCLT_LOAN_MAIN_TYPE_CD     --涉农贷款主体类型代码
            ,AGCLT_LOAN_DIR_CD           --涉农贷款用途类型代码
            ,LAND_FIN_PLAT_CAP_SRC_CD    --地方融资平台偿债资金来源代码
            ,PLA_TRAST_WAY_CD            --贷款办理方式代码
            ,INT_SET_WAY_CD              --结息方式代码
            ,FILE_INT_FLG                --靠档利息标志
            ,CAP_USAGE_DESCB             --资金用途描述
            ,MOVE_REMARK                 --迁移备注
            ,RGST_DT                     --登记日期
            ,OPER_TELLER_ID              --经办柜员编号
            ,OPER_DT                     --经办日期
            ,RGST_TELLER_ID              --登记柜员编号
            ,RGST_ORG_ID                 --登记机构编号
            ,LOAN_ORG_ID                 --贷款机构编号
            ,UPDATE_TELLER_ID            --更新柜员编号
            ,UPDATE_ORG_ID               --更新机构编号
            ,START_DT                    --开始时间
            ,END_DT                      --结束时间
            ,ID_MARK                     --增删标志
            ,SRC_TABLE_NAME              --源表名称
            ,JOB_CD                      --任务编码
            ,ETL_TIMESTAMP               --ETL处理时间戳
            ,SRC_AGT_ID                  --源协议编号
            ,TASK_STATUS_CD              --任务状态代码
            ,INT_RAT_FLOAT_PED           --利率浮动周期代码
            ,INT_RAT_FLOAT_WAY_CD        --利率浮动方式代码
            ,COMM_FEE_CHARGE_DAY         --手续费收费日
            ,COMM_FEE_COLL_WAY_CD        --手续费收取方式代码
            ,COMM_FEE_CHARGE_FREQ_CD     --手续费收费频率代码
            ,SUP_CHAIN_FIN_BUS_FLG       --供应链金融业务标志
            ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD  --供应链金融业务产品分类代码
            ,NATNAL_ECON_TYPE_CD         --国民经济类型代码
            ,CORP_SIZE_CD                --企业规模代码
            ,RISK_CLS_REST_CD            --风险分类结果代码
            ,DMIC_ST_MSG_SEND_CD         --业务提醒短信发送时机代码
            ,FINAL_UPDATE_DT             --最后更新日期
    FROM IML.V_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H   --贷款出账法人透支附属信息历史
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

  END ETL_O_IML_AGT_LOAN_OUT_ACCT_LP_OD_ATTACH_INFO_H;
/

