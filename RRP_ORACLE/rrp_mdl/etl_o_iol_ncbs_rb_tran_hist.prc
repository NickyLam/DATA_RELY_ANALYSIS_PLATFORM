CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_TRAN_HIST(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_TRAN_HIST
  *  功能描述：金融交易流水表
  *  创建日期：20251210
  *  开发人员：YJY
  *  来源表： IOL.V_NCBS_RB_TRAN_HIST
  *  目标表： O_IOL_NCBS_RB_TRAN_HIST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251210  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_NCBS_RB_TRAN_HIST'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_TRAN_HIST'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-金融交易流水表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_TRAN_HIST NOLOGGING 
  (       ACCT_SEQ_NO                  --账户子账号
         ,ACCT_STATUS                  --账户状态
         ,AMT_TYPE                     --金额类型
         ,BASE_ACCT_NO                 --交易账号/卡号
         ,BUSINESS_UNIT                --账套
         ,CCY                          --币种
         ,CLIENT_NAME                  --客户名称
         ,CLIENT_NO                    --客户编号
         ,CLIENT_TYPE                  --客户类型
         ,DOC_TYPE                     --凭证类型
         ,DOCUMENT_ID                  --证件号码
         ,DOCUMENT_TYPE                --客户证件类型
         ,GL_CODE                      --科目代码
         ,INTERNAL_KEY                 --账户内部键值
         ,PROD_TYPE                    --产品编号
         ,PROFIT_CENTER                --利润中心
         ,REFERENCE                    --交易参考号
         ,TRAN_TYPE                    --交易类型
         ,USER_ID                      --交易柜员编号
         ,VOUCHER_NO                   --凭证号码
         ,WITHDRAWAL_TYPE              --支取方式
         ,ACCT_CLASS                   --账户等级
         ,ACCT_DESC                    --账户描述
         ,ACCT_REAL_FLAG               --账户虚实标志
         ,ACCT_TRAN_FLAG               --账户交易标志
         ,AMT_CALC_TYPE                --金额计算类型
         ,AUTO_REVERSAL_FLAG           --自动冲正标志
         ,BAL_TYPE                     --余额类型
         ,BANK_SEQ_NO                  --银行交易序号
         ,BATCH_NO                     --批次号
         ,BILL_NO                      --票据号码
         ,BIZ_TYPE                     --中间业务类型
         ,CASH_ITEM                    --现金项目
         ,CHANNEL_SEQ_NO               --全局流水号
         ,COMMISSION_CLIENT_TEL        --代办/代理人电话
         ,COMPANY                      --法人
         ,CR_DR_IND                    --借贷标志
         ,EVENT_TYPE                   --事件类型
         ,FH_SEQ_NO                    --资金冻结流水号
         ,FIN_TYPE                     --理财类型
         ,FROM_RATE_FLAG               --买方交易汇率标志
         ,GL_POSTED_FLAG               --过账标记
         ,LENDER                       --贷款人
         ,LIMIT_REF                    --限额编码
         ,MEDIUM_FLAG                  --介质标志
         ,MEDIUM_TYPE                  --存款介质类型
         ,NARRATIVE                    --摘要
         ,ORIG_SYSTEM                  --交易发起方业务分类
         ,OTH_ACCT_DESC                --对方账户描述
         ,OTH_BRANCH_REGIONALISM_CODE  --对方金融机构行政区划代码
         ,OTH_REAL_BRANCH_REGION_CODE  --真实对方金融机构行政区划代码
         ,OTH_SEQ_NO                   --对方交易流水号
         ,PAY_UNIT                     --交款单位
         ,PBK_UPD_FLAG                 --是否补登存
         ,PI_FLAG                      --小额免密标志
         ,PREFIX                       --前缀
         ,PRIMARY_EVENT_TYPE           --主事件类型
         ,PRIMARY_TRAN_SEQ_NO          --主交易序号
         ,PRINT_CNT                    --打印次数
         ,PRIORITY                     --优先级
         ,PROGRAM_ID                   --交易代码
         ,QUOTE_TYPE                   --牌价类型
         ,RATE_TYPE                    --汇率类型
         ,RECEIPT_NO                   --回收号
         ,REVERSAL_FLAG                --交易是否已冲正
         ,REVERSAL_SEQ_NO              --冲正流水号
         ,REVERSAL_TRAN_TYPE           --冲正交易类型
         ,SEND_SYSTEM                  --转发系统
         ,SEQ_NO                       --序号
         ,SERV_CHARGE                  --服务费标识
         ,SOURCE_MODULE                --源模块
         ,SOURCE_TYPE                  --渠道编号
         ,SUB_SEQ_NO                   --系统流水号
         ,SYSTEM_CODE                  --来源系统编号
         ,TAE_SUB_SEQ_NO               --tae子流水序号
         ,TERMINAL_ID                  --交易终端编号
         ,TO_ID                        --卖方牌价类型
         ,TO_RATE_FLAG                 --卖方交易汇率标志
         ,TRACE_ID                     --跟踪id
         ,TRAN_DESC                    --交易描述
         ,TRAN_NOTE                    --交易附言
         ,TRAN_STATUS                  --冲补抹标志
         ,TRAN_CATEGORY                --交易种类
         ,CHANNEL                      --渠道
         ,ACCOUNTING_STATUS            --核算状态
         ,CHANNEL_DATE                 --渠道日期
         ,EFFECT_DATE                  --产品生效日期
         ,ORIG_TRAN_TIMESTAMP          --原始交易时间戳
         ,REVERSAL_DATE                --冲正日期
         ,SETTLEMENT_DATE              --清算日期
         ,TRAN_DATE                    --交易日期
         ,TRAN_TIMESTAMP               --交易时间戳
         ,ACCT_BRANCH                  --开户机构编号
         ,ACCT_CCY                     --账户币种
         ,ACTUAL_BAL                   --实际余额
         ,ACTUAL_BAL_AMT_FIN           --交易后余额加理财
         ,APPR_USER_ID                 --复核柜员
         ,AUTH_USER_ID                 --授权柜员
         ,BASE_EQUIV_AMT               --基础等值金额
         ,COMMISSION_CLIENT_NAME       --代办人名称
         ,CONTRA_ACCT_CCY              --对方币种
         ,CONTRA_EQUIV_AMT             --对方等值金额
         ,CROSS_RATE                   --交叉汇率
         ,FROM_AMOUNT                  --移出金额
         ,FROM_CCY                     --起始币种
         ,FROM_XRATE                   --买方汇率值
         ,OTH_ACCT_CCY                 --对方账户币种
         ,OTH_ACCT_SEQ_NO              --对方账户序列号
         ,OTH_BANK_CODE                --对方银行代码
         ,OTH_BANK_NAME                --对方银行名称
         ,OTH_BASE_ACCT_NO             --对方账号/卡号
         ,OTH_BRANCH                   --对方账户开户机构
         ,OTH_DOCUMENT_ID              --交易对手证件号码
         ,OTH_DOCUMENT_TYPE            --交易对手证件类型
         ,OTH_INTERNAL_KEY             --对手账户内部键
         ,OTH_PROD_TYPE                --对方账户产品类型
         ,OTH_REAL_BANK_CODE           --真实对方金融机构代码
         ,OTH_REAL_BANK_NAME           --真实对方金融机构名称
         ,OTH_REAL_BASE_ACCT_NO        --真实交易对手账号
         ,OTH_REAL_DOCUMENT_ID         --真实交易对手证件号码
         ,OTH_REAL_DOCUMENT_TYPE       --真实交易对手证件类型
         ,OTH_REAL_PROD_TYPE           --真实交易对手账户类型
         ,OTH_REAL_TRAN_ADDR           --真实交易发生地
         ,OTH_REAL_TRAN_NAME           --真实交易对手名称
         ,OTH_REFERENCE                --对方交易参考号
         ,OTH_TRAN_ADDR                --交易发生地
         ,OTH_TRAN_NAME                --交易对手名称
         ,OV_CROSS_RATE                --实际交易时修改交叉汇率
         ,OV_TO_AMOUNT                 --根据实际交易时修改交叉汇率计算的金额
         ,PREVIOUS_BAL_AMT             --交易前余额
         ,SUB_ACCT_NO                  --子账户
         ,TO_AMOUNT                    --移入金额
         ,TO_CCY                       --目的币种
         ,TO_XRATE                     --卖方汇率值
         ,TRAN_AMT                     --交易金额
         ,TRAN_BRANCH                  --核心交易机构编号
         ,TRAN_METHOD                  --到账方式
         ,FLAT_RATE                    --平盘汇率
         ,REACCOUNT_CD                 --对账代码
         ,CONTRA_TRAN_DATE             --他行交易日期
         ,BUS_SEQ_NO                   --业务流水号
         ,NARRATIVE_CODE               --摘要码
         ,CHEQUE_DATE                  --支票凭证出票日期
         ,OLD_DATA_REMARK      
         ,CASH_TO_CODE      
         ,CASH_TO_COUNTRY      
         ,CASH_FROM_CODE      
         ,CASH_FROM_COUNTRY      
         ,MAIN_SOURCE_MODULE            --主模块
         ,LOAN_PROD_TYPE                --贷款产品类型
         ,REMARK                        --备注
         ,ORIG_CHANNEL_SEQ_NO            
         ,THIRD_BUS_TYPE      
         ,MARKETING_PROD_DESC            
         ,ETL_DT                        --ETL处理日期
         ,ETL_TIMESTAMP                 --ETL处理时间戳
    )
  SELECT 
        ACCT_SEQ_NO                  --账户子账号
         ,ACCT_STATUS                  --账户状态
         ,AMT_TYPE                     --金额类型
         ,BASE_ACCT_NO                 --交易账号/卡号
         ,BUSINESS_UNIT                --账套
         ,CCY                          --币种
         ,CLIENT_NAME                  --客户名称
         ,CLIENT_NO                    --客户编号
         ,CLIENT_TYPE                  --客户类型
         ,DOC_TYPE                     --凭证类型
         ,DOCUMENT_ID                  --证件号码
         ,DOCUMENT_TYPE                --客户证件类型
         ,GL_CODE                      --科目代码
         ,INTERNAL_KEY                 --账户内部键值
         ,PROD_TYPE                    --产品编号
         ,PROFIT_CENTER                --利润中心
         ,REFERENCE                    --交易参考号
         ,TRAN_TYPE                    --交易类型
         ,USER_ID                      --交易柜员编号
         ,VOUCHER_NO                   --凭证号码
         ,WITHDRAWAL_TYPE              --支取方式
         ,ACCT_CLASS                   --账户等级
         ,ACCT_DESC                    --账户描述
         ,ACCT_REAL_FLAG               --账户虚实标志
         ,ACCT_TRAN_FLAG               --账户交易标志
         ,AMT_CALC_TYPE                --金额计算类型
         ,AUTO_REVERSAL_FLAG           --自动冲正标志
         ,BAL_TYPE                     --余额类型
         ,BANK_SEQ_NO                  --银行交易序号
         ,BATCH_NO                     --批次号
         ,BILL_NO                      --票据号码
         ,BIZ_TYPE                     --中间业务类型
         ,CASH_ITEM                    --现金项目
         ,CHANNEL_SEQ_NO               --全局流水号
         ,COMMISSION_CLIENT_TEL        --代办/代理人电话
         ,COMPANY                      --法人
         ,CR_DR_IND                    --借贷标志
         ,EVENT_TYPE                   --事件类型
         ,FH_SEQ_NO                    --资金冻结流水号
         ,FIN_TYPE                     --理财类型
         ,FROM_RATE_FLAG               --买方交易汇率标志
         ,GL_POSTED_FLAG               --过账标记
         ,LENDER                       --贷款人
         ,LIMIT_REF                    --限额编码
         ,MEDIUM_FLAG                  --介质标志
         ,MEDIUM_TYPE                  --存款介质类型
         ,NARRATIVE                    --摘要
         ,ORIG_SYSTEM                  --交易发起方业务分类
         ,OTH_ACCT_DESC                --对方账户描述
         ,OTH_BRANCH_REGIONALISM_CODE  --对方金融机构行政区划代码
         ,OTH_REAL_BRANCH_REGION_CODE  --真实对方金融机构行政区划代码
         ,OTH_SEQ_NO                   --对方交易流水号
         ,PAY_UNIT                     --交款单位
         ,PBK_UPD_FLAG                 --是否补登存
         ,PI_FLAG                      --小额免密标志
         ,PREFIX                       --前缀
         ,PRIMARY_EVENT_TYPE           --主事件类型
         ,PRIMARY_TRAN_SEQ_NO          --主交易序号
         ,PRINT_CNT                    --打印次数
         ,PRIORITY                     --优先级
         ,PROGRAM_ID                   --交易代码
         ,QUOTE_TYPE                   --牌价类型
         ,RATE_TYPE                    --汇率类型
         ,RECEIPT_NO                   --回收号
         ,REVERSAL_FLAG                --交易是否已冲正
         ,REVERSAL_SEQ_NO              --冲正流水号
         ,REVERSAL_TRAN_TYPE           --冲正交易类型
         ,SEND_SYSTEM                  --转发系统
         ,SEQ_NO                       --序号
         ,SERV_CHARGE                  --服务费标识
         ,SOURCE_MODULE                --源模块
         ,SOURCE_TYPE                  --渠道编号
         ,SUB_SEQ_NO                   --系统流水号
         ,SYSTEM_CODE                  --来源系统编号
         ,TAE_SUB_SEQ_NO               --tae子流水序号
         ,TERMINAL_ID                  --交易终端编号
         ,TO_ID                        --卖方牌价类型
         ,TO_RATE_FLAG                 --卖方交易汇率标志
         ,TRACE_ID                     --跟踪id
         ,TRAN_DESC                    --交易描述
         ,TRAN_NOTE                    --交易附言
         ,TRAN_STATUS                  --冲补抹标志
         ,TRAN_CATEGORY                --交易种类
         ,CHANNEL                      --渠道
         ,ACCOUNTING_STATUS            --核算状态
         ,CHANNEL_DATE                 --渠道日期
         ,EFFECT_DATE                  --产品生效日期
         ,ORIG_TRAN_TIMESTAMP          --原始交易时间戳
         ,REVERSAL_DATE                --冲正日期
         ,SETTLEMENT_DATE              --清算日期
         ,TRAN_DATE                    --交易日期
         ,TRAN_TIMESTAMP               --交易时间戳
         ,ACCT_BRANCH                  --开户机构编号
         ,ACCT_CCY                     --账户币种
         ,ACTUAL_BAL                   --实际余额
         ,ACTUAL_BAL_AMT_FIN           --交易后余额加理财
         ,APPR_USER_ID                 --复核柜员
         ,AUTH_USER_ID                 --授权柜员
         ,BASE_EQUIV_AMT               --基础等值金额
         ,COMMISSION_CLIENT_NAME       --代办人名称
         ,CONTRA_ACCT_CCY              --对方币种
         ,CONTRA_EQUIV_AMT             --对方等值金额
         ,CROSS_RATE                   --交叉汇率
         ,FROM_AMOUNT                  --移出金额
         ,FROM_CCY                     --起始币种
         ,FROM_XRATE                   --买方汇率值
         ,OTH_ACCT_CCY                 --对方账户币种
         ,OTH_ACCT_SEQ_NO              --对方账户序列号
         ,OTH_BANK_CODE                --对方银行代码
         ,OTH_BANK_NAME                --对方银行名称
         ,OTH_BASE_ACCT_NO             --对方账号/卡号
         ,OTH_BRANCH                   --对方账户开户机构
         ,OTH_DOCUMENT_ID              --交易对手证件号码
         ,OTH_DOCUMENT_TYPE            --交易对手证件类型
         ,OTH_INTERNAL_KEY             --对手账户内部键
         ,OTH_PROD_TYPE                --对方账户产品类型
         ,OTH_REAL_BANK_CODE           --真实对方金融机构代码
         ,OTH_REAL_BANK_NAME           --真实对方金融机构名称
         ,OTH_REAL_BASE_ACCT_NO        --真实交易对手账号
         ,OTH_REAL_DOCUMENT_ID         --真实交易对手证件号码
         ,OTH_REAL_DOCUMENT_TYPE       --真实交易对手证件类型
         ,OTH_REAL_PROD_TYPE           --真实交易对手账户类型
         ,OTH_REAL_TRAN_ADDR           --真实交易发生地
         ,OTH_REAL_TRAN_NAME           --真实交易对手名称
         ,OTH_REFERENCE                --对方交易参考号
         ,OTH_TRAN_ADDR                --交易发生地
         ,OTH_TRAN_NAME                --交易对手名称
         ,OV_CROSS_RATE                --实际交易时修改交叉汇率
         ,OV_TO_AMOUNT                 --根据实际交易时修改交叉汇率计算的金额
         ,PREVIOUS_BAL_AMT             --交易前余额
         ,SUB_ACCT_NO                  --子账户
         ,TO_AMOUNT                    --移入金额
         ,TO_CCY                       --目的币种
         ,TO_XRATE                     --卖方汇率值
         ,TRAN_AMT                     --交易金额
         ,TRAN_BRANCH                  --核心交易机构编号
         ,TRAN_METHOD                  --到账方式
         ,FLAT_RATE                    --平盘汇率
         ,REACCOUNT_CD                 --对账代码
         ,CONTRA_TRAN_DATE             --他行交易日期
         ,BUS_SEQ_NO                   --业务流水号
         ,NARRATIVE_CODE               --摘要码
         ,CHEQUE_DATE                  --支票凭证出票日期
         ,OLD_DATA_REMARK      
         ,CASH_TO_CODE      
         ,CASH_TO_COUNTRY      
         ,CASH_FROM_CODE      
         ,CASH_FROM_COUNTRY      
         ,MAIN_SOURCE_MODULE            --主模块
         ,LOAN_PROD_TYPE                --贷款产品类型
         ,REMARK                        --备注
         ,ORIG_CHANNEL_SEQ_NO            
         ,THIRD_BUS_TYPE      
         ,MARKETING_PROD_DESC            
         ,ETL_DT                        --ETL处理日期
         ,ETL_TIMESTAMP                 --ETL处理时间戳
    FROM IOL.V_NCBS_RB_TRAN_HIST --视图-金融交易流水表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_NCBS_RB_TRAN_HIST;
/

