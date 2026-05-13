CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_RETL_LOAN_DUBIL_INFO(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_RETL_LOAN_DUBIL_INFO
  *  功能描述：零售贷款借据信息
  *  创建日期：2023/01/06
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW  贷款金融交易流水

  *  目标表：  M_MRPT_RETL_LOAN_DUBIL_INFO
  *
  *  配置表：
  *  修改情况：1  2023/01/06  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_RETL_LOAN_DUBIL_INFO' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;
  V_SQL       VARCHAR2(2000); -- 动态sql

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_RETL_LOAN_DUBIL_INFO'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_RETL_LOAN_DUBIL_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
 -- DELETE FROM RPT_MRPT_RESULT T WHERE T.DATA_DATE = V_P_DATE AND T.RPT_NO = V_RPT_NO;--手工报表指标结果表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;
  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  V_SQL :='TRUNCATE TABLE M_MRPT_RETL_LOAN_DUBIL_INFO';
  EXECUTE IMMEDIATE V_SQL;
 
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 贷款金融交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_RETL_LOAN_DUBIL_INFO NOLOGGING
             (DATA_DT                                  --01  数据日期
              ,ETL_DT                                  --02  ETL处理日期
              ,LP_ID                                   --03  法人编号
              ,DUBIL_ID                                --04  借据编号
              ,CONT_ID                                 --05  合同编号
              ,STD_PROD_ID                             --06  标准产品编号
              ,BUS_BREED_ID                            --07  业务品种编号
              ,BUS_BREED_NAME                          --08  业务品种名称
              ,CRDTC_SUBM_BUS_BREED_CD                 --09  征信报送业务品种代码
              ,CUST_ID                                 --10  客户编号
              ,CRDTC_SUBM_BUS_BREED_DESCB              --11  征信报送业务品种描述
              ,REPAY_NUM                               --12  还款账号
              ,ENTER_ACCT_NUM                          --13  入账账号
              ,MORTG_FLG                               --14  按揭标志
              ,NPL_FLG                                 --15  不良贷款标志
              ,DEFLT_FLG                               --16  违约标志
              ,CRDT_LMT_USE_FLG                        --17  授信额度使用标志
              ,GRO_LEND_FLG                            --18  联保贷款标志
              ,BLON_LOAN_FLG                           --19  气球贷标志
              ,LEVEL10_CLS_MANU_MED_FLG                --20  十级分类人工干预标志
              ,INSURE_COMP_FLG                         --21  保险代偿标志
              ,PBC_INC_LOAN_FLG                        --22  人行普惠贷款标志
              ,WHITE_LIST_CUST_FLG                     --23  白户标志
              ,FARM_FLG                                --24  农户标志
              ,PROD_TYPE_CD                            --25  产品类型代码
              ,LOAN_HAPP_TYPE_CD                       --26  贷款发生类型代码
              ,LOAN_TYPE_CD                            --27  贷款类型代码
              ,ASSET_THD_CLS_CD                        --28  资产三分类代码
              ,GUAR_WAY_CD                             --29  担保方式代码
              ,SUB_GUAR_WAY_CD                         --30  子担保方式代码
              ,REPAY_WAY_CD                            --31  还款方式代码
              ,DIR_INDUS_CD                            --32  投向行业代码
              ,DUBIL_STATUS_CD                         --33  借据状态代码
              ,REFAC_LOAN_STATUS_CD                    --34  支小再贷款状态代码
              ,COMP_INT_CALC_WAY_CD                    --35  复利计算方式代码
              ,INT_RAT_ADJ_PED_CORP_CD                 --36  利率调整周期单位代码
              ,INT_RAT_ADJ_PED_FREQ                    --37  利率调整周期频率
              ,LOAN_LEVEL4_CLS_CD                      --38  贷款四级分类代码
              ,LOAN_LEVEL5_CLS_CD                      --39  贷款五级分类代码
              ,LOAN_LEVEL10_CLS_CD                     --40  贷款十级分类代码
              ,LOAN_LEVEL12_CLS_CD                     --41  贷款十二级分类代码
              ,INT_RAT_ADJ_WAY_CD                      --42  利率调整方式代码
              ,OVDUE_INT_RAT_ADJ_WAY                   --43  逾期利率调整方式
              ,INT_RAT_ADJ_EFFECT_WAY                  --44  利率调整生效方式
              ,INT_RAT_FLOAT_TENOR_CD                  --45  利率浮动期限代码
              ,ENTER_ACCT_PT_TYPE_CD                   --46  入账账户支付工具类型代码
              ,REPAY_ACCT_PT_TYPE_CD                   --47  还款账户支付工具类型代码
              ,DEDUCT_WAY_CD                           --48  扣款方式代码
              ,MODE_PAY_CD                             --49  支付方式代码
              ,CURR_CD                                 --50  币种代码
              ,CUST_CHAR_CD                            --51  客户性质代码
              ,CUST_CRDT_TOT                           --52  客户授信总额
              ,LOAN_TYPE_DESCB                         --53  贷款类型描述
              ,ENTER_ACCT_NAME                         --54  入账账户名称
              ,CUST_MGR_ID                             --55  客户经理编号
              ,TRUST_CUST_MGR                          --56  托管客户经理
              ,RGST_TELLER_ID                          --57  登记柜员编号
              ,RGST_ORG_ID                             --58  登记机构编号
              ,ACCT_INSTIT_ID                          --59  账务机构编号
              ,MGMT_ORG_ID                             --60  管理机构编号
              ,DUBIL_OPEN_DT                           --61  借据开立日期
              ,DUBIL_EXP_DT                            --62  借据到期日期
              ,FIR_DISTR_DT                            --63  首次放款日期
              ,RECNT_REPAY_DT                          --64  最近还款日期
              ,REPAY_DAY                               --65  还款日
              ,PAYOFF_DT                               --66  结清日期
              ,PRIC_OVDUE_DT                           --67  本金逾期日期
              ,INT_OVDUE_DT                            --68  利息逾期日期
              ,LOAN_LEVEL5_CLS_DT                      --69  贷款五级分类日期
              ,LOAN_LEVEL10_CLS_DT                     --70  贷款十级分类日期
              ,LAST_LEVEL5_CLS_MODIF_DT                --71  上次五级分类变更日期
              ,LAST_RISK_RGST_ADJ_RS                   --72  上次风险登记调整原因
              ,RISK_RGST_APVER_ID                      --73  风险登记审批人编号
              ,BASE_RAT                                --74  基准利率
              ,EXEC_INT_RAT                            --75  执行利率
              ,OVDUE_INT_RAT                           --76  逾期利率
              ,OVDUE_INT_RAT_FLO_VAL                   --77  逾期利率浮动值
              ,INT_RAT_FLO_VAL                         --78  利率浮动值
              ,PRIC_OVDUE_DAYS                         --79  本金逾期天数
              ,INT_OVDUE_DAYS                          --80  利息逾期天数
              ,GRACE_DAYS                              --81  宽限天数
              ,GRACE_PERIOD_START_DT                   --82  宽限期开始日期
              ,GRACE_PERIOD_EXP_DT                     --83  宽限期到期日期
              ,FINAL_PED_RESV_AMT                      --84  最后一期保留金额
              ,DUBIL_AMT                               --85  借据金额
              ,REFAC_LOAN_BATCH_PKG_ID                 --86  支小再贷款批次包编号
              ,REFAC_LOAN_BATCH_EXP_DT                 --87  支小再贷款批次到期日期
              ,REFAC_LOAN_USE_INT_RAT                  --88  支小再贷款使用利率
              ,JOB_CD                                  --89  任务代码
              ,ETL_TIMESTAMP                           --90  数据处理时间
       )
      SELECT  V_P_DATE                                 --01  数据日期
              ,ETL_DT                                  --02  ETL处理日期
              ,LP_ID                                   --03  法人编号
              ,DUBIL_ID                                --04  借据编号
              ,CONT_ID                                 --05  合同编号
              ,STD_PROD_ID                             --06  标准产品编号
              ,BUS_BREED_ID                            --07  业务品种编号
              ,BUS_BREED_NAME                          --08  业务品种名称
              ,CRDTC_SUBM_BUS_BREED_CD                 --09  征信报送业务品种代码
              ,CUST_ID                                 --10  客户编号
              ,CRDTC_SUBM_BUS_BREED_DESCB              --11  征信报送业务品种描述
              ,REPAY_NUM                               --12  还款账号
              ,ENTER_ACCT_NUM                          --13  入账账号
              ,MORTG_FLG                               --14  按揭标志
              ,NPL_FLG                                 --15  不良贷款标志
              ,DEFLT_FLG                               --16  违约标志
              ,CRDT_LMT_USE_FLG                        --17  授信额度使用标志
              ,GRO_LEND_FLG                            --18  联保贷款标志
              ,BLON_LOAN_FLG                           --19  气球贷标志
              ,LEVEL10_CLS_MANU_MED_FLG                --20  十级分类人工干预标志
              ,INSURE_COMP_FLG                         --21  保险代偿标志
              ,PBC_INC_LOAN_FLG                        --22  人行普惠贷款标志
              ,WHITE_LIST_CUST_FLG                     --23  白户标志
              ,FARM_FLG                                --24  农户标志
              ,PROD_TYPE_CD                            --25  产品类型代码
              ,LOAN_HAPP_TYPE_CD                       --26  贷款发生类型代码
              ,LOAN_TYPE_CD                            --27  贷款类型代码
              ,ASSET_THD_CLS_CD                        --28  资产三分类代码
              ,GUAR_WAY_CD                             --29  担保方式代码
              ,SUB_GUAR_WAY_CD                         --30  子担保方式代码
              ,REPAY_WAY_CD                            --31  还款方式代码
              ,DIR_INDUS_CD                            --32  投向行业代码
              ,DUBIL_STATUS_CD                         --33  借据状态代码
              ,REFAC_LOAN_STATUS_CD                    --34  支小再贷款状态代码
              ,COMP_INT_CALC_WAY_CD                    --35  复利计算方式代码
              ,INT_RAT_ADJ_PED_CORP_CD                 --36  利率调整周期单位代码
              ,INT_RAT_ADJ_PED_FREQ                    --37  利率调整周期频率
              ,LOAN_LEVEL4_CLS_CD                      --38  贷款四级分类代码
              ,LOAN_LEVEL5_CLS_CD                      --39  贷款五级分类代码
              ,LOAN_LEVEL10_CLS_CD                     --40  贷款十级分类代码
              ,LOAN_LEVEL12_CLS_CD                     --41  贷款十二级分类代码
              ,INT_RAT_ADJ_WAY_CD                      --42  利率调整方式代码
              ,OVDUE_INT_RAT_ADJ_WAY                   --43  逾期利率调整方式
              ,INT_RAT_ADJ_EFFECT_WAY                  --44  利率调整生效方式
              ,INT_RAT_FLOAT_TENOR_CD                  --45  利率浮动期限代码
              ,ENTER_ACCT_PT_TYPE_CD                   --46  入账账户支付工具类型代码
              ,REPAY_ACCT_PT_TYPE_CD                   --47  还款账户支付工具类型代码
              ,DEDUCT_WAY_CD                           --48  扣款方式代码
              ,MODE_PAY_CD                             --49  支付方式代码
              ,CURR_CD                                 --50  币种代码
              ,CUST_CHAR_CD                            --51  客户性质代码
              ,CUST_CRDT_TOT                           --52  客户授信总额
              ,LOAN_TYPE_DESCB                         --53  贷款类型描述
              ,ENTER_ACCT_NAME                         --54  入账账户名称
              ,CUST_MGR_ID                             --55  客户经理编号
              ,TRUST_CUST_MGR                          --56  托管客户经理
              ,RGST_TELLER_ID                          --57  登记柜员编号
              ,RGST_ORG_ID                             --58  登记机构编号
              ,ACCT_INSTIT_ID                          --59  账务机构编号
              ,MGMT_ORG_ID                             --60  管理机构编号
              ,DUBIL_OPEN_DT                           --61  借据开立日期
              ,DUBIL_EXP_DT                            --62  借据到期日期
              ,FIR_DISTR_DT                            --63  首次放款日期
              ,RECNT_REPAY_DT                          --64  最近还款日期
              ,REPAY_DAY                               --65  还款日
              ,PAYOFF_DT                               --66  结清日期
              ,PRIC_OVDUE_DT                           --67  本金逾期日期
              ,INT_OVDUE_DT                            --68  利息逾期日期
              ,LOAN_LEVEL5_CLS_DT                      --69  贷款五级分类日期
              ,LOAN_LEVEL10_CLS_DT                     --70  贷款十级分类日期
              ,LAST_LEVEL5_CLS_MODIF_DT                --71  上次五级分类变更日期
              ,LAST_RISK_RGST_ADJ_RS                   --72  上次风险登记调整原因
              ,RISK_RGST_APVER_ID                      --73  风险登记审批人编号
              ,BASE_RAT                                --74  基准利率
              ,EXEC_INT_RAT                            --75  执行利率
              ,OVDUE_INT_RAT                           --76  逾期利率
              ,OVDUE_INT_RAT_FLO_VAL                   --77  逾期利率浮动值
              ,INT_RAT_FLO_VAL                         --78  利率浮动值
              ,PRIC_OVDUE_DAYS                         --79  本金逾期天数
              ,INT_OVDUE_DAYS                          --80  利息逾期天数
              ,GRACE_DAYS                              --81  宽限天数
              ,GRACE_PERIOD_START_DT                   --82  宽限期开始日期
              ,GRACE_PERIOD_EXP_DT                     --83  宽限期到期日期
              ,FINAL_PED_RESV_AMT                      --84  最后一期保留金额
              ,DUBIL_AMT                               --85  借据金额
              ,REFAC_LOAN_BATCH_PKG_ID                 --86  支小再贷款批次包编号
              ,REFAC_LOAN_BATCH_EXP_DT                 --87  支小再贷款批次到期日期
              ,REFAC_LOAN_USE_INT_RAT                  --88  支小再贷款使用利率
              ,JOB_CD                                  --89  任务代码
              ,ETL_TIMESTAMP                           --90  数据处理时间
         FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO  --零售贷款借据信息
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_RETL_LOAN_DUBIL_INFO;
/

