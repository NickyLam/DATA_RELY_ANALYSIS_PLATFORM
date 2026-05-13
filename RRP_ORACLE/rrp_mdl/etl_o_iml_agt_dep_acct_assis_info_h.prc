CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_DEP_ACCT_ASSIS_INFO_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_DEP_ACCT_ASSIS_INFO_H
  *  功能描述：存款账户附加信息历史
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IML.V_AGT_DEP_ACCT_ASSIS_INFO_H
  *  目标表： O_IML_AGT_DEP_ACCT_ASSIS_INFO_H
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_DEP_ACCT_ASSIS_INFO_H'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_DEP_ACCT_ASSIS_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款账户附加信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_DEP_ACCT_ASSIS_INFO_H NOLOGGING
    (     AGT_ID                                   --协议编号
         ,LP_ID                                    --法人编号
         ,ACCT_ID                                  --账户编号
         ,CUST_ID                                  --客户编号
         ,PCP_DE_INT_FLAG                          --产品细类代码
         ,CLS_PROD_ID                              --分类产品编号
         ,INSIDE_ACCT_CHAR_CD                      --内部账户性质代码
         ,ACCT_CHAR_CD                             --外汇账户性质代码
         ,ACCT_VRIF_STATUS_CD                      --账户核实状态代码
         ,LAST_ACCT_VRIF_STATUS_CD                 --上一账户核实状态代码
         ,ACCT_CHN_IDF_CD                          --账户渠道标识代码
         ,ACCT_BAL_DIR_CD                          --账户余额方向代码
         ,BAL_UPDATE_TYPE_CD                       --余额更新类型代码
         ,BAL_LINKG_CHG_FLG                        --余额联动变动标志
         ,ACCRD_FREQ_PAY_INT_FLG                   --按频率付息标志
         ,TAX_RAT                                  --税率
         ,PED                                      --周期
         ,PED_CORP_CD                              --周期单位代码
         ,SIGN_PROD_CLS_CD                         --签约产品分类代码
         ,SIGN_AGT_ID                              --签约协议编号
         ,SIGN_AGT_STATUS_CD                       --签约协议状态代码
         ,DEP_CHAR_CD                              --存款性质代码
         ,AGT_DEP_TYPE_CD                          --协议存款类型代码
         ,CAP_CHAR                                 --资金性质
         ,PD_CD                                    --期次编号
         ,VERIFY_TYPE_CD                           --查证类型代码
         ,VERIFY_AMT                               --查证金额
         ,DISP_WAY_CD                              --处置方式代码
         ,ST_MSG_SIGN_STATUS_CD                    --短信签约状态代码
         ,CNTPTY_CUST_ID                           --对手客户编号
         ,CNTPTY_ACCT_NUM                          --对手账号
         ,CNTPTY_ACCT_NUM_NAME                     --对手账号名称
         ,CNTPTY_ACCT_OPEN_BANK_NAME               --对手账户开户行名称
         ,CNTPTY_ACCT_OPEN_ACCT_ORG_ID             --对手账户开户机构编号
         ,CNTPTY_ACCT_OPEN_ACCT_DT                 --对手账户开户日期
         ,CNTPTY_BK_OPEN_ACCT_ORG_BELONG_DIST_CD   --对手行开户机构所属行政区域代码
         ,CNTPTY_BANK_BELONG_CTY_RG_CD             --对手行所属国家和地区代码
         ,NON_I_CLASS_ACCT_CHECK_STATUS_CD         --非I类户验证状态代码
         ,SUSPD_WRTOFF_FLG                         --挂销账标志
         ,ON_ACCT_TENOR                            --挂账期限
         ,SUPV_FLG                                 --监管标志
         ,SUPV_TYPE_CD                             --监管类型代码
         ,SUPV_CONTENT_DESCB                       --监管内容描述
         ,OPEN_ACCT_WAY_CD                         --开户方式代码
         ,OPEN_TYPE_CD                             --开立类型代码
         ,REMOTE_OPEN_ACCT_FLG                     --异地开户标志
         ,OPEN_ACCT_CITY                           --开户城市
         ,OPEN_ACCT_PROV                           --开户省份
         ,CAN_OD_FLG                               --可透支标志
         ,ACM_CAN_WDRAW_PRIC_AMT                   --累计可支取本金金额
         ,INT_TAX_IMPOSE_FLG                       --利息税征收标志
         ,ONL_FLG                                  --联机标志
         ,FINAL_BLKLIST_DT                         --最后黑名单日期
         ,BLKLIST_STATUS_CD                        --黑名单状态代码
         ,LEGAL_FLG                                --涉案标志
         ,LEGAL_DT                                 --涉案日期
         ,LEGAL_RS_DESCB                           --涉案原因描述
         ,APV_ODD_NO                               --审批单号
         ,GENERAL_EXCH_ORG_ID                      --通兑机构编号
         ,CLOS_ACCT_REOP_DT                        --销户重开日期
         ,WRTOFF_WAY_CD                            --销账方式代码
         ,CHECK_FAIL_RS_DESCB                      --验证失败原因描述
         ,CERT_AS_FLG                              --证件年检标志
         ,ALDY_AS_FLG                              --已年检标志
         ,LAST_AS_CLOSING_DT                       --上一年检截止日期
         ,LAST_AS_RESET_DT                         --上一年检重置日期
         ,BANK_INTER_ID                            --银行国际编号
         ,PRIVAVY_ACCT_FLG                         --隐私账户标志
         ,EARLIEST_WDRAW_DT                        --最早可支取日期
         ,UNEXP_DRAW_DT                            --提前支取日期
         ,PRECON_PAYOFF_DAY                        --预约结清日
         ,ALLOW_SELL_CHECK_FLG                     --允许出售支票标志
         ,ALLOW_CNTER_CROSS_BANK_DEPOT_PERMIT_FLG  --允许柜面跨行存入许可标志
         ,ALLOW_CNTER_CROSS_BANK_WDRAW_PERMIT_FLG  --允许柜面跨行支取许可标志
         ,ALLOW_MANUAL_ENTRY_FLG                   --允许手工记账标志
         ,ALLOW_ACCT_TURN_LONG_HANG_FLG            --允许账户转久悬标志
         ,ACCT_REDT_TENOR                          --账户转存期限
         ,ACCT_REDT_TENOR_CD                       --账户转存期限代码
         ,TURN_BACK_DT                             --转回日期
         ,NEXT_RENEW_DEP_DAY                       --下一续存日
         ,FTZ_CD                                   --自贸区代码
         ,FTZ_ACCT_FLG                             --自贸区账户标志
         ,PRECON_WDRAW_FLG                         --预约支取标志
         ,PRECON_WDRAW_DT                          --预约支取日期
         ,PRINT_CERT_FLG                           --打印证实书标志
         ,AUTO_RENEW_DEP_FLG                       --自动续存标志
         ,ONE_KEY_OPEN_ACCT_FLG                    --一键开户标志
         ,PREFR_INT_TAX_RAT_EXP_DT                 --优惠利息税率到期日期
         ,DELAY_PAY_INT_FLG                        --延期付息标志
         ,SPEC_DAY                                 --指定日
         ,BI_LMT_LMT_FLG                           --双边限额限制标志
         ,CAP_SRC_ACCT_ID                          --资金来源账户编号
         ,CAP_SRC_ACCT_SUB_ACCT_NUM                --资金来源账户子账号
         ,HOLD_VALID_ID_CARD_FLG                   --持有有效身份证件标志
         ,CDS_PROD_MODIF_FLG                       --大额存单产品变更标志
         ,CASH_MGMT_PROD_FLG                       --现金管理产品标志
         ,START_DT                                 --开始时间
         ,END_DT                                   --结束时间
         ,ID_MARK                                  --增删标志
         ,SRC_TABLE_NAME                           --源表名称
         ,JOB_CD                                   --任务编码
         ,ETL_TIMESTAMP                            --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
          AGT_ID                                   --协议编号
         ,LP_ID                                    --法人编号
         ,ACCT_ID                                  --账户编号
         ,CUST_ID                                  --客户编号
         ,PCP_DE_INT_FLAG                          --产品细类代码
         ,CLS_PROD_ID                              --分类产品编号
         ,INSIDE_ACCT_CHAR_CD                      --内部账户性质代码
         ,ACCT_CHAR_CD                             --外汇账户性质代码
         ,ACCT_VRIF_STATUS_CD                      --账户核实状态代码
         ,LAST_ACCT_VRIF_STATUS_CD                 --上一账户核实状态代码
         ,ACCT_CHN_IDF_CD                          --账户渠道标识代码
         ,ACCT_BAL_DIR_CD                          --账户余额方向代码
         ,BAL_UPDATE_TYPE_CD                       --余额更新类型代码
         ,BAL_LINKG_CHG_FLG                        --余额联动变动标志
         ,ACCRD_FREQ_PAY_INT_FLG                   --按频率付息标志
         ,TAX_RAT                                  --税率
         ,PED                                      --周期
         ,PED_CORP_CD                              --周期单位代码
         ,SIGN_PROD_CLS_CD                         --签约产品分类代码
         ,SIGN_AGT_ID                              --签约协议编号
         ,SIGN_AGT_STATUS_CD                       --签约协议状态代码
         ,DEP_CHAR_CD                              --存款性质代码
         ,AGT_DEP_TYPE_CD                          --协议存款类型代码
         ,CAP_CHAR                                 --资金性质
         ,PD_CD                                    --期次编号
         ,VERIFY_TYPE_CD                           --查证类型代码
         ,VERIFY_AMT                               --查证金额
         ,DISP_WAY_CD                              --处置方式代码
         ,ST_MSG_SIGN_STATUS_CD                    --短信签约状态代码
         ,CNTPTY_CUST_ID                           --对手客户编号
         ,CNTPTY_ACCT_NUM                          --对手账号
         ,CNTPTY_ACCT_NUM_NAME                     --对手账号名称
         ,CNTPTY_ACCT_OPEN_BANK_NAME               --对手账户开户行名称
         ,CNTPTY_ACCT_OPEN_ACCT_ORG_ID             --对手账户开户机构编号
         ,CNTPTY_ACCT_OPEN_ACCT_DT                 --对手账户开户日期
         ,CNTPTY_BK_OPEN_ACCT_ORG_BELONG_DIST_CD   --对手行开户机构所属行政区域代码
         ,CNTPTY_BANK_BELONG_CTY_RG_CD             --对手行所属国家和地区代码
         ,NON_I_CLASS_ACCT_CHECK_STATUS_CD         --非I类户验证状态代码
         ,SUSPD_WRTOFF_FLG                         --挂销账标志
         ,ON_ACCT_TENOR                            --挂账期限
         ,SUPV_FLG                                 --监管标志
         ,SUPV_TYPE_CD                             --监管类型代码
         ,SUPV_CONTENT_DESCB                       --监管内容描述
         ,OPEN_ACCT_WAY_CD                         --开户方式代码
         ,OPEN_TYPE_CD                             --开立类型代码
         ,REMOTE_OPEN_ACCT_FLG                     --异地开户标志
         ,OPEN_ACCT_CITY                           --开户城市
         ,OPEN_ACCT_PROV                           --开户省份
         ,CAN_OD_FLG                               --可透支标志
         ,ACM_CAN_WDRAW_PRIC_AMT                   --累计可支取本金金额
         ,INT_TAX_IMPOSE_FLG                       --利息税征收标志
         ,ONL_FLG                                  --联机标志
         ,FINAL_BLKLIST_DT                         --最后黑名单日期
         ,BLKLIST_STATUS_CD                        --黑名单状态代码
         ,LEGAL_FLG                                --涉案标志
         ,LEGAL_DT                                 --涉案日期
         ,LEGAL_RS_DESCB                           --涉案原因描述
         ,APV_ODD_NO                               --审批单号
         ,GENERAL_EXCH_ORG_ID                      --通兑机构编号
         ,CLOS_ACCT_REOP_DT                        --销户重开日期
         ,WRTOFF_WAY_CD                            --销账方式代码
         ,CHECK_FAIL_RS_DESCB                      --验证失败原因描述
         ,CERT_AS_FLG                              --证件年检标志
         ,ALDY_AS_FLG                              --已年检标志
         ,LAST_AS_CLOSING_DT                       --上一年检截止日期
         ,LAST_AS_RESET_DT                         --上一年检重置日期
         ,BANK_INTER_ID                            --银行国际编号
         ,PRIVAVY_ACCT_FLG                         --隐私账户标志
         ,EARLIEST_WDRAW_DT                        --最早可支取日期
         ,UNEXP_DRAW_DT                            --提前支取日期
         ,PRECON_PAYOFF_DAY                        --预约结清日
         ,ALLOW_SELL_CHECK_FLG                     --允许出售支票标志
         ,ALLOW_CNTER_CROSS_BANK_DEPOT_PERMIT_FLG  --允许柜面跨行存入许可标志
         ,ALLOW_CNTER_CROSS_BANK_WDRAW_PERMIT_FLG  --允许柜面跨行支取许可标志
         ,ALLOW_MANUAL_ENTRY_FLG                   --允许手工记账标志
         ,ALLOW_ACCT_TURN_LONG_HANG_FLG            --允许账户转久悬标志
         ,ACCT_REDT_TENOR                          --账户转存期限
         ,ACCT_REDT_TENOR_CD                       --账户转存期限代码
         ,TURN_BACK_DT                             --转回日期
         ,NEXT_RENEW_DEP_DAY                       --下一续存日
         ,FTZ_CD                                   --自贸区代码
         ,FTZ_ACCT_FLG                             --自贸区账户标志
         ,PRECON_WDRAW_FLG                         --预约支取标志
         ,PRECON_WDRAW_DT                          --预约支取日期
         ,PRINT_CERT_FLG                           --打印证实书标志
         ,AUTO_RENEW_DEP_FLG                       --自动续存标志
         ,ONE_KEY_OPEN_ACCT_FLG                    --一键开户标志
         ,PREFR_INT_TAX_RAT_EXP_DT                 --优惠利息税率到期日期
         ,DELAY_PAY_INT_FLG                        --延期付息标志
         ,SPEC_DAY                                 --指定日
         ,BI_LMT_LMT_FLG                           --双边限额限制标志
         ,CAP_SRC_ACCT_ID                          --资金来源账户编号
         ,CAP_SRC_ACCT_SUB_ACCT_NUM                --资金来源账户子账号
         ,HOLD_VALID_ID_CARD_FLG                   --持有有效身份证件标志
         ,CDS_PROD_MODIF_FLG                       --大额存单产品变更标志
         ,CASH_MGMT_PROD_FLG                       --现金管理产品标志
         ,START_DT                                 --开始时间
         ,END_DT                                   --结束时间
         ,ID_MARK                                  --增删标志
         ,SRC_TABLE_NAME                           --源表名称
         ,JOB_CD                                   --任务编码
         ,ETL_TIMESTAMP                            --ETL处理时间戳
    FROM IML.V_AGT_DEP_ACCT_ASSIS_INFO_H   --存款账户附加信息历史
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

  END ETL_O_IML_AGT_DEP_ACCT_ASSIS_INFO_H;
/

