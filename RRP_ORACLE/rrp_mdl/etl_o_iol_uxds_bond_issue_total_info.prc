CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：中国债券发行信息总表
  **存储过程名称：    ETL_O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO
  **存储过程创建日期：20250919
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250919    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-中国债券发行信息总表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO NOLOGGING 
  (          SEQ                                  --记录唯一标识
            ,CTIME                                --记录创建日期
            ,MTIME                                --记录修改日期
            ,RTIME                                --记录通讯到用户端日期
            ,BOND_ID                              --债券id
            ,ANNOUNCEMENT_DATE                    --公告日期
            ,ISSUE_SD                             --发行起始日
            ,ISSUE_ED                             --发行终止日
            ,PLAN_ISSUE_TOTAL_VOL                 --计划发行总量
            ,ACTUAL_ISSUE_TOTAL_VOL               --实际发行总量
            ,ISSUE_PRICE                          --发行价格
            ,PAYMENT_DATE                         --缴款截止日
            ,CASHING_COMMI_RATE                   --兑付手续费率
            ,ISSUE_METHOD_CODE                    --发行方式编码
            ,ISSUE_METHOD                         --发行方式
            ,ISSUE_OBJECT                         --发行对象
            ,DISTRIBUTION_METHOD                  --分销方式
            ,DISTRIBUTION_OBJECT                  --分销对象
            ,COMPETITIVE_BIDDING_AMOUNT           --竞争性招标额
            ,BASIC_UNDERWRITING                   --基本承销额
            ,ACTUAL_RC_AMT                        --实际募资金额
            ,TOTAL_ISSUE_FEE                      --发行费用总额
            ,UNDERWRITING_METHOD_CODE             --承销方式编码
            ,UNDERWRITING_METHOD                  --承销方式
            ,ONLINE_PUR_DATE                      --网上申购日期
            ,OFFLINE_SUBSCRIPTION_DATE            --网下认购日期
            ,ONLINE_PUR_CODE                      --网上申购代码
            ,ONLINE_PUR_SHORT_NAME                --网上申购简称
            ,ORIG_HOLDERS_PLACE_AMT_ONLINE        --原股东每股获配金额
            ,OFFLINE_ALLOCATED_AMT                --网下获配金额
            ,ONLINE_ISSUE_VOL                     --网上发售数量
            ,ONLINE_ISSUE_LOTTERY_RATIO           --网上发售中签率
            ,OFFLINE_PLACE_RATIO                  --网下配售比例
            ,CALLBACK_MODE_CODE                   --回拨方式编码
            ,CALLBACK_MODE                        --回拨方式
            ,CALLBACK_NUM                         --回拨数量
            ,ISSUE_FEE_RATE                       --发行费率
            ,ONLINE_RELEASE_DEADLINE              --上网发行截止日期
            ,ONLINE_ISSUE_PUR_LIMIT_EXPLAIN       --网上发行认购数量限制说明
            ,LISTING_AD                           --上市公告日
            ,IEC_PASSED_AD                        --审委审核通过公告日
            ,FORE_ISSUE_COST                      --预计发行费用
            ,ORIG_HOLDERS_PLACE_DATE              --原股东配售日期
            ,ORIG_HOLDERS_PLACE_EQUITY_RD         --原股东配售股权登记日
            ,ORIG_HOLDERS_PLACE_CODE              --原股东配售代码
            ,ORIG_HOLDERS_PLACE_SHORT_NAME        --原股东配售简称
            ,ORIG_HOLDERS_PLACE_EXPLAIN           --原股东配售说明
            ,ONLINE_ISSUE_PUR_PRICE               --网上发行申购价格
            ,ISSUE_RESULT_AD                      --发行结果公告日
            ,ORIG_LS_SHAREHOLDER_PURCHASE         --原限售股股东配购数量
            ,HOLDER_PRFR_ALLOT_NUM                --无限售股股东优先配售数量
            ,ONLINE_VALID_PUR_PEOPLE_NUM          --网上有效申购户数
            ,ONLINE_VALID_PUR_NUM                 --网上有效申购数量
            ,OFFLINE_VALID_PUR_ACCOUNT_NUM        --网下有效申购户数
            ,OFFLINE_VALID_PUR_NUM                --网下有效申购数量
            ,UNDERWRITING_SPONSOR_FEE             --承销保荐费用
            ,UNDERWRITE_BALANCE                   --包销余额
            ,ISSUE_COST_EXPLAIN                   --发行费用说明
            ,OFFLINE_ISSUE_SD                     --网下发行截止日期
            ,ONLINE_PUR_QUANTITY_DL               --网上申购数量下限
            ,ONLINE_PUR_QUANTITY_UL               --网上申购数量上限
            ,ONLINE_PUR_QUANTITY_UNIT             --网上申购数量单位
            ,OFFLINE_PUR_VOL_DL                   --网下申购数量下限
            ,OFFLINE_PUR_VOL_UL                   --网下申购数量上限
            ,OFFLINE_PUR_UNIT                     --网下申购数量单位
            ,OFFLINE_PUR_FONT_MONEY_RATIO         --网下申购定金比例
            ,ONLINE_PUR_FUND_UNFREEZE_DATE        --网上申购资金解冻日
            ,OFFLINE_PURCAPITAL_UNFRZ_DATE        --网下申购资金解冻日
            ,ADD_ISSUE_TOTAL_VOL                  --追加发行总量
            ,DISTRIBUTION_SD                      --分销起始日期
            ,DISTRIBUTION_ED                      --分销截至日期
            ,FUNDS_TO_ACCOUNT_CONFIRM_TIME        --资金到帐确认时间
            ,BOND_TRANSFER_TIME                   --债券过户时间
            ,BASIC_UW_ADD_CONTRACT_FEE_RATE       --基本承销额附加承揽费率
            ,CONTRACT_FEE_RATE                    --承揽费率
            ,IB_FINANCING_TOOL_REG_INFO_NUM       --银行间债务融资工具注册信息记录号
            ,CB_ISSUE_PLAN_RECORD_NUM             --可转债发行预案记录号
            ,CURRENCY_CODE                        --货币代码
            ,CURRENCY_NAME                        --货币名称
            ,RC_USAGE                             --募集资金用途
            ,OLD_HOLDER_PLACE_PAYMENT_DATE        --老股东配售缴款日
            ,ONLINE_ISSUE_ALLOT_TOTAL_NUM         --上网发行配号总数
            ,FLOAT_HOLDER_PLACE_AMOUNT            --流通股股东可配售金额
            ,ISSUE_STATUS                         --发行状态
            ,NAFMII_ACCEPT_REG_NOTICE_NUM         --交易商协会接受注册公告编号
            ,CORP_BOND_ISSUE_REG_INFO_NUM         --企业债券发行注册信息记录号
            ,OFFLINE_ISSUE_LOT_WINNING_NUM        --网上中签号码
            ,ACCOUNTANT_FEE                       --会计师费用
            ,REPAYMENT_ORDER                      --偿付顺序
            ,ISSUE_NUMBER                         --发行期号
            ,LAWYER_FEE                           --律师费用
            ,VALID_BID_PURCHASE_NUM               --有效投标(申购)家数
            ,PAYMENT_SD                           --缴款起始日
            ,ONLINE_WIN_RESULT_AD                 --网上中签结果公告日
            ,ISSUE_TOTAL_AMT                      --发行总额
            ,EXCHANGE_DEBT_ISSUE_PLAN_NUM         --可交换债发行预案记录号
            ,BOOK_BUILDING_DATE                   --簿记建档日
            ,VALID_PURPURCHASE_AMT                --有效申购金额
            ,MAX_PURCHASE_RATE                    --最高申购利率
            ,MIN_PURCHASE_RATE                    --最低申购利率
            ,COMPLIANCE_PURCHASE_AMT              --合规申购金额
            ,COMPLIANCE_PURCHASE_NUM              --合规申购家数
            ,FULL_FIELD_MULTIPLIER                --全场倍数
            ,WGT_BID_INTEREST                     --加权中标利率
            ,MARGINAL_MULTIPLE                    --边际倍数
            ,MARGINAL_RATE                        --边际利率
            ,CSRC_BOND_APPROVAL_REPLY_NUM         --证监会债券核准批复记录号
            ,AMOUNT_UL_TO_BE_ISSUED               --计划发行金额上限
            ,AMOUNT_LL_TO_BE_ISSUED               --计划发行金额下限
            ,BOUNCE_TRIGGER_MULTIPLE              --上弹触发倍数
            ,DOWN_TRIGGER_MULTIPLE                --下弹触发倍数
            ,COMPULSORY_TRIGGER_MULTIPLE          --强制触发倍数
            ,BOOK_BUILDING_ED                     --簿记建档截止日
            ,ISSUE_SD_ANNOUNCE                    --发行起始日(公告)
            ,MIN_PURCHASE_PRICE                   --最低申购价位
            ,MAX_PURCHASE_PRICE                   --最高申购价位
            ,ISSUE_STRUCTURE                      --发行结构
            ,ISSUE_STRUCTURE_CODE                 --发行结构编码
            ,ISSUE_RULE                           --发行规则
            ,ISSUE_RULE_CODE                      --发行规则编码
            ,ORIG_LH_VALID_PUR_NUM                --原限售股股东有效申购数量
            ,UNLIMIT_HOLDER_VALID_PUR_NUM         --无限售股股东有效申购数量
            ,OLD_HOLDER_PUR_ACCOUNT_NUM           --老股东申购户数
            ,EMISSION_REDUCTION_BENEFITS          --减排效益
            ,CSRC_BOND_APPROVAL_NUMBER            --证监会债券核准批复文号
            ,EXCHG_CONFIRM_FILE_SYMBOL            --交易所确认文件文号
            ,CBIRC_BOND_APPROVAL_NUMBER           --银保监会债券批复文号
            ,KPI                                  --关键绩效指标
            ,SPT                                  --可持续发展绩效目标
            ,MAIN_UNDWT_AMOUNT                    --主承销商包销金额
            ,MAIN_UNDWT_RATIO                     --主承销商包销比例
            ,JOINT_MAIN_UNDWT_AMOUNT              --联席主承销商包销金额
            ,JOINT_UNDWT_RATIO                    --联席主承销商包销比例
            ,DEBT_CREDIT_REG_DATE                 --债权债务登记日
            ,MULTIPLE                             --认购倍数
            ,ISVALID                              --是否有效
            ,START_DT                             --开始时间
            ,END_DT                               --结束时间
            ,ID_MARK                              --增删标志
            ,ETL_TIMESTAMP                        --ETL处理时间戳
    )
    SELECT
             SEQ                                  --记录唯一标识
            ,CTIME                                --记录创建日期
            ,MTIME                                --记录修改日期
            ,RTIME                                --记录通讯到用户端日期
            ,BOND_ID                              --债券id
            ,ANNOUNCEMENT_DATE                    --公告日期
            ,ISSUE_SD                             --发行起始日
            ,ISSUE_ED                             --发行终止日
            ,PLAN_ISSUE_TOTAL_VOL                 --计划发行总量
            ,ACTUAL_ISSUE_TOTAL_VOL               --实际发行总量
            ,ISSUE_PRICE                          --发行价格
            ,PAYMENT_DATE                         --缴款截止日
            ,CASHING_COMMI_RATE                   --兑付手续费率
            ,ISSUE_METHOD_CODE                    --发行方式编码
            ,ISSUE_METHOD                         --发行方式
            ,ISSUE_OBJECT                         --发行对象
            ,DISTRIBUTION_METHOD                  --分销方式
            ,DISTRIBUTION_OBJECT                  --分销对象
            ,COMPETITIVE_BIDDING_AMOUNT           --竞争性招标额
            ,BASIC_UNDERWRITING                   --基本承销额
            ,ACTUAL_RC_AMT                        --实际募资金额
            ,TOTAL_ISSUE_FEE                      --发行费用总额
            ,UNDERWRITING_METHOD_CODE             --承销方式编码
            ,UNDERWRITING_METHOD                  --承销方式
            ,ONLINE_PUR_DATE                      --网上申购日期
            ,OFFLINE_SUBSCRIPTION_DATE            --网下认购日期
            ,ONLINE_PUR_CODE                      --网上申购代码
            ,ONLINE_PUR_SHORT_NAME                --网上申购简称
            ,ORIG_HOLDERS_PLACE_AMT_ONLINE        --原股东每股获配金额
            ,OFFLINE_ALLOCATED_AMT                --网下获配金额
            ,ONLINE_ISSUE_VOL                     --网上发售数量
            ,ONLINE_ISSUE_LOTTERY_RATIO           --网上发售中签率
            ,OFFLINE_PLACE_RATIO                  --网下配售比例
            ,CALLBACK_MODE_CODE                   --回拨方式编码
            ,CALLBACK_MODE                        --回拨方式
            ,CALLBACK_NUM                         --回拨数量
            ,ISSUE_FEE_RATE                       --发行费率
            ,ONLINE_RELEASE_DEADLINE              --上网发行截止日期
            ,ONLINE_ISSUE_PUR_LIMIT_EXPLAIN       --网上发行认购数量限制说明
            ,LISTING_AD                           --上市公告日
            ,IEC_PASSED_AD                        --审委审核通过公告日
            ,FORE_ISSUE_COST                      --预计发行费用
            ,ORIG_HOLDERS_PLACE_DATE              --原股东配售日期
            ,ORIG_HOLDERS_PLACE_EQUITY_RD         --原股东配售股权登记日
            ,ORIG_HOLDERS_PLACE_CODE              --原股东配售代码
            ,ORIG_HOLDERS_PLACE_SHORT_NAME        --原股东配售简称
            ,ORIG_HOLDERS_PLACE_EXPLAIN           --原股东配售说明
            ,ONLINE_ISSUE_PUR_PRICE               --网上发行申购价格
            ,ISSUE_RESULT_AD                      --发行结果公告日
            ,ORIG_LS_SHAREHOLDER_PURCHASE         --原限售股股东配购数量
            ,HOLDER_PRFR_ALLOT_NUM                --无限售股股东优先配售数量
            ,ONLINE_VALID_PUR_PEOPLE_NUM          --网上有效申购户数
            ,ONLINE_VALID_PUR_NUM                 --网上有效申购数量
            ,OFFLINE_VALID_PUR_ACCOUNT_NUM        --网下有效申购户数
            ,OFFLINE_VALID_PUR_NUM                --网下有效申购数量
            ,UNDERWRITING_SPONSOR_FEE             --承销保荐费用
            ,UNDERWRITE_BALANCE                   --包销余额
            ,ISSUE_COST_EXPLAIN                   --发行费用说明
            ,OFFLINE_ISSUE_SD                     --网下发行截止日期
            ,ONLINE_PUR_QUANTITY_DL               --网上申购数量下限
            ,ONLINE_PUR_QUANTITY_UL               --网上申购数量上限
            ,ONLINE_PUR_QUANTITY_UNIT             --网上申购数量单位
            ,OFFLINE_PUR_VOL_DL                   --网下申购数量下限
            ,OFFLINE_PUR_VOL_UL                   --网下申购数量上限
            ,OFFLINE_PUR_UNIT                     --网下申购数量单位
            ,OFFLINE_PUR_FONT_MONEY_RATIO         --网下申购定金比例
            ,ONLINE_PUR_FUND_UNFREEZE_DATE        --网上申购资金解冻日
            ,OFFLINE_PURCAPITAL_UNFRZ_DATE        --网下申购资金解冻日
            ,ADD_ISSUE_TOTAL_VOL                  --追加发行总量
            ,DISTRIBUTION_SD                      --分销起始日期
            ,DISTRIBUTION_ED                      --分销截至日期
            ,FUNDS_TO_ACCOUNT_CONFIRM_TIME        --资金到帐确认时间
            ,BOND_TRANSFER_TIME                   --债券过户时间
            ,BASIC_UW_ADD_CONTRACT_FEE_RATE       --基本承销额附加承揽费率
            ,CONTRACT_FEE_RATE                    --承揽费率
            ,IB_FINANCING_TOOL_REG_INFO_NUM       --银行间债务融资工具注册信息记录号
            ,CB_ISSUE_PLAN_RECORD_NUM             --可转债发行预案记录号
            ,CURRENCY_CODE                        --货币代码
            ,CURRENCY_NAME                        --货币名称
            ,RC_USAGE                             --募集资金用途
            ,OLD_HOLDER_PLACE_PAYMENT_DATE        --老股东配售缴款日
            ,ONLINE_ISSUE_ALLOT_TOTAL_NUM         --上网发行配号总数
            ,FLOAT_HOLDER_PLACE_AMOUNT            --流通股股东可配售金额
            ,ISSUE_STATUS                         --发行状态
            ,NAFMII_ACCEPT_REG_NOTICE_NUM         --交易商协会接受注册公告编号
            ,CORP_BOND_ISSUE_REG_INFO_NUM         --企业债券发行注册信息记录号
            ,OFFLINE_ISSUE_LOT_WINNING_NUM        --网上中签号码
            ,ACCOUNTANT_FEE                       --会计师费用
            ,REPAYMENT_ORDER                      --偿付顺序
            ,ISSUE_NUMBER                         --发行期号
            ,LAWYER_FEE                           --律师费用
            ,VALID_BID_PURCHASE_NUM               --有效投标(申购)家数
            ,PAYMENT_SD                           --缴款起始日
            ,ONLINE_WIN_RESULT_AD                 --网上中签结果公告日
            ,ISSUE_TOTAL_AMT                      --发行总额
            ,EXCHANGE_DEBT_ISSUE_PLAN_NUM         --可交换债发行预案记录号
            ,BOOK_BUILDING_DATE                   --簿记建档日
            ,VALID_PURPURCHASE_AMT                --有效申购金额
            ,MAX_PURCHASE_RATE                    --最高申购利率
            ,MIN_PURCHASE_RATE                    --最低申购利率
            ,COMPLIANCE_PURCHASE_AMT              --合规申购金额
            ,COMPLIANCE_PURCHASE_NUM              --合规申购家数
            ,FULL_FIELD_MULTIPLIER                --全场倍数
            ,WGT_BID_INTEREST                     --加权中标利率
            ,MARGINAL_MULTIPLE                    --边际倍数
            ,MARGINAL_RATE                        --边际利率
            ,CSRC_BOND_APPROVAL_REPLY_NUM         --证监会债券核准批复记录号
            ,AMOUNT_UL_TO_BE_ISSUED               --计划发行金额上限
            ,AMOUNT_LL_TO_BE_ISSUED               --计划发行金额下限
            ,BOUNCE_TRIGGER_MULTIPLE              --上弹触发倍数
            ,DOWN_TRIGGER_MULTIPLE                --下弹触发倍数
            ,COMPULSORY_TRIGGER_MULTIPLE          --强制触发倍数
            ,BOOK_BUILDING_ED                     --簿记建档截止日
            ,ISSUE_SD_ANNOUNCE                    --发行起始日(公告)
            ,MIN_PURCHASE_PRICE                   --最低申购价位
            ,MAX_PURCHASE_PRICE                   --最高申购价位
            ,ISSUE_STRUCTURE                      --发行结构
            ,ISSUE_STRUCTURE_CODE                 --发行结构编码
            ,ISSUE_RULE                           --发行规则
            ,ISSUE_RULE_CODE                      --发行规则编码
            ,ORIG_LH_VALID_PUR_NUM                --原限售股股东有效申购数量
            ,UNLIMIT_HOLDER_VALID_PUR_NUM         --无限售股股东有效申购数量
            ,OLD_HOLDER_PUR_ACCOUNT_NUM           --老股东申购户数
            ,EMISSION_REDUCTION_BENEFITS          --减排效益
            ,CSRC_BOND_APPROVAL_NUMBER            --证监会债券核准批复文号
            ,EXCHG_CONFIRM_FILE_SYMBOL            --交易所确认文件文号
            ,CBIRC_BOND_APPROVAL_NUMBER           --银保监会债券批复文号
            ,KPI                                  --关键绩效指标
            ,SPT                                  --可持续发展绩效目标
            ,MAIN_UNDWT_AMOUNT                    --主承销商包销金额
            ,MAIN_UNDWT_RATIO                     --主承销商包销比例
            ,JOINT_MAIN_UNDWT_AMOUNT              --联席主承销商包销金额
            ,JOINT_UNDWT_RATIO                    --联席主承销商包销比例
            ,DEBT_CREDIT_REG_DATE                 --债权债务登记日
            ,MULTIPLE                             --认购倍数
            ,ISVALID                              --是否有效
            ,START_DT                             --开始时间
            ,END_DT                               --结束时间
            ,ID_MARK                              --增删标志
            ,ETL_TIMESTAMP                        --ETL处理时间戳
  FROM IOL.V_UXDS_BOND_ISSUE_TOTAL_INFO --视图-中国债券发行信息总表
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO', '', O_ERRCODE);

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

END ETL_O_IOL_UXDS_BOND_ISSUE_TOTAL_INFO;
/

