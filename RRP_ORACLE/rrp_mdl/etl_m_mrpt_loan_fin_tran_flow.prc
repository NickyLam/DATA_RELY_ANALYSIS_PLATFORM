CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_LOAN_FIN_TRAN_FLOW(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_LOAN_FIN_TRAN_FLOW
  *  功能描述：贷款金融交易流水
  *  创建日期：2023/01/06
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW  贷款金融交易流水

  *  目标表：  M_MRPT_LOAN_FIN_TRAN_FLOW
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
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_LOAN_FIN_TRAN_FLOW' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_LOAN_FIN_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_LOAN_FIN_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 贷款金融交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_LOAN_FIN_TRAN_FLOW NOLOGGING
             (DATA_DT                      --01   数据日期
             ,ETL_DT                       --02   etl处理日期
             ,EVT_ID                       --03   事件编号
             ,TRAN_FLOW_NUM                --04   交易流水号
             ,LP_ID                        --05   法人编号
             ,CAP_FROZ_FLOW_NUM            --06   资金冻结流水号
             ,MAIN_EVT_CLS_CD              --07   主事件分类代码
             ,MAIN_TRAN_SEQ_NUM            --08   主交易序号
             ,INTER_BUS_TYPE_CD            --09   中间业务类型代码
             ,EXCH_RAT_TYPE_CD             --10   汇率类型代码
             ,WDRAW_WAY_CD                 --11   支取方式代码
             ,CERT_TYPE_CD                 --12   证件类型代码
             ,CERT_NO                      --13   证件号码
             ,SOB_CATE_CD                  --14   账套类别代码
             ,SRC_MODULE_TYPE_CD           --15   源模块类型代码
             ,ACCT_STATUS_CD               --16   账户状态代码
             ,ACCT_NAME                    --17   账户名称
             ,ACCT_PROD_ID                 --18   账户产品编号
             ,ACCT_ID                      --19   账户编号
             ,ACCT_CURR_CD                 --20   账户币种代码
             ,PRIOR_LEVEL                  --21   优先等级
             ,CAMP_PROD_NAME               --22   营销产品名称
             ,CAMP_PROD_ID                 --23   营销产品编号
             ,BANK_TRAN_SEQ_NUM            --24   银行交易序号
             ,BUS_TRAN_BATCH_NO            --25   业务交易批次号
             ,BUS_PROC_STATUS_CD           --26   业务处理状态代码
             ,VTUAL_ACCT_FLG               --27   虚户标志
             ,LMT_CODE                     --28   限额编码
             ,CASH_PROJ_CD                 --29   现金项目代码
             ,CASH_TRAN_FLG                --30   现金交易标志
             ,CROSS_AMT                    --31   套算金额
             ,AUTH_TELLER_ID               --32   授权柜员编号
             ,EVT_CATE_ID                  --33   事件类别编号
             ,ACTL_BAL                     --34   实际余额
             ,ACTL_CROSS_EXCH_RAT          --35   实际交叉汇率
             ,EFFECT_DT                    --36   生效日期
             ,OVA_FLOW_NUM                 --37   全局流水号
             ,CHN_SUB_FLOW_NUM             --38   渠道子流水号
             ,CHN_ID                       --39   渠道编号
             ,CLEAR_DT                     --40   清算日期
             ,BEGIN_CURR_CD                --41   起始币种代码
             ,VOUCH_NO                     --42   凭证号码
             ,SELLER_QUOT_TYPE_CD          --43   卖方牌价类型代码
             ,SELLER_EXCH_RAT_VAL          --44   卖方汇率值
             ,SELLER_EXCH_RAT_CLS_CD       --45   卖方汇率分类代码
             ,SELL_AMT                     --46   卖出金额
             ,SELL_CURR_CD                 --47   卖出币种代码
             ,BUY_AMT                      --48   买入金额
             ,BUYER_QUOT_TYPE_CD           --49   买方牌价类型代码
             ,BUYER_EXCH_RAT_VAL           --50   买方汇率值
             ,BUYER_EXCH_RAT_CLS_CD        --51   买方汇率分类代码
             ,CUST_NAME                    --52   客户名称
             ,CUST_TYPE_CD                 --53   客户类型代码
             ,CUST_ECON_TYPE_CD            --54   客户经济类型代码
             ,CUST_ID                      --55   客户编号
             ,OPEN_ACCT_ORG_ID             --56   开户机构编号
             ,AMT_TYPE_CD                  --57   金额类型代码
             ,AMT_CALC_TYPE_CD             --58   金额计算类型代码
             ,DEBIT_CRDT_FLG               --59   借贷标志
             ,TRAN_KIND_CD                 --60   交易种类代码
             ,TRAN_TERMN_ID                --61   交易终端编号
             ,TRAN_MEMO_DESCB              --62   交易摘要描述
             ,TRAN_COMNT                   --63   交易说明
             ,TRAN_TM                      --64   交易时间
             ,TRAN_DT                      --65   交易日期
             ,BEF_TRAN_BAL                 --66   交易前余额
             ,TRAN_CD                      --67   交易码
             ,TRAN_AMT                     --68   交易金额
             ,TRAN_ORG_ID                  --69   交易机构编号
             ,TRAN_TELLER_ID               --70   交易柜员编号
             ,TRAN_POSTSC                  --71   交易附言
             ,TRAN_REF_NO                  --72   交易参考号
             ,PAYMENT_CORP_NAME            --73   交款单位名称
             ,CROSS_EXCH_RAT               --74   交叉汇率
             ,BASE_EQUVL_AMT               --75   基础等值金额
             ,EXCH_RAT_CLS_CD              --76   汇率分类代码
             ,CALLBK_ID                    --77   回收编号
             ,ACCTI_STATUS_CD              --78   核算状态代码
             ,POST_FLG                     --79   过账标志
             ,FOLLOW_ID                    --80   跟踪编号
             ,CHECK_TELLER_ID              --81   复核柜员编号
             ,SERV_FEE_FLG                 --82   服务费标志
             ,DISTR_FLOW_NUM               --83   放款流水号
             ,CNTPTY_ACCT_SUB_ACCT_NUM     --84   对手账户子账号
             ,CNTPTY_ACCT_NAME             --85   对手账户名称
             ,CNTPTY_ACCT_PROD_ID          --86   对手账户产品编号
             ,CNTPTY_ACCT_ID               --87   对手账户编号
             ,CNTPTY_ACCT_CURR_CD          --88   对手账户币种代码
             ,CNTPTY_BANK_NAME             --89   对手银行名称
             ,CNTPTY_BANK_NO               --90   对手银行行号
             ,CNTPTY_CUST_ACCT_NUM         --91   对手客户账号
             ,CNTPTY_OPEN_ACCT_ORG_ID      --92   对手开户机构编号
             ,CNTPTY_TRAN_FLOW_NUM         --93   对手交易流水号
             ,CNTPTY_EQUVL_AMT             --94   对手等值金额
             ,CNTPTY_CURR_CD               --95   对手币种代码
             ,CNTPTY_TRAN_REF_NO           --96   对方交易参考号
             ,AVL_WAY_CD                   --97   到账方式代码
             ,LOAN_NUM                     --98   贷款号
             ,PUBLIC_AGENT_NAME            --99   代办人名称
             ,PUBLIC_AGENT_TEL_NUM         --100  代办人电话号码
             ,DEP_VOUCH_CATE_CD            --101  存款凭证类别代码
             ,REVS_DT                      --102  冲正日期
             ,REVS_FLOW_NUM                --103  冲正流水号
             ,REVS_TRAN_CD                 --104  冲正交易码
             ,REVS_FLG                     --105  冲正标志
             ,BAL_TYPE_CD                  --106  钞汇余额代码
             ,ATTACH_RGST_DEP_FLG          --107  补登存标志
             ,CURR_CD                      --108  币种代码
             ,CHECK_ENTRY_CODE             --109  对账编码
             ,BUS_FLOW_NUM                 --110  业务流水号
             ,JOB_CD                       --111  任务代码
       )
      SELECT  V_P_DATE                     --01   数据日期
             ,ETL_DT                       --02   etl处理日期
             ,EVT_ID                       --03   事件编号
             ,TRAN_FLOW_NUM                --04   交易流水号
             ,LP_ID                        --05   法人编号
             ,CAP_FROZ_FLOW_NUM            --06   资金冻结流水号
             ,MAIN_EVT_CLS_CD              --07   主事件分类代码
             ,MAIN_TRAN_SEQ_NUM            --08   主交易序号
             ,INTER_BUS_TYPE_CD            --09   中间业务类型代码
             ,EXCH_RAT_TYPE_CD             --10   汇率类型代码
             ,WDRAW_WAY_CD                 --11   支取方式代码
             ,CERT_TYPE_CD                 --12   证件类型代码
             ,CERT_NO                      --13   证件号码
             ,SOB_CATE_CD                  --14   账套类别代码
             ,SRC_MODULE_TYPE_CD           --15   源模块类型代码
             ,ACCT_STATUS_CD               --16   账户状态代码
             ,ACCT_NAME                    --17   账户名称
             ,ACCT_PROD_ID                 --18   账户产品编号
             ,ACCT_ID                      --19   账户编号
             ,ACCT_CURR_CD                 --20   账户币种代码
             ,PRIOR_LEVEL                  --21   优先等级
             ,CAMP_PROD_NAME               --22   营销产品名称
             ,CAMP_PROD_ID                 --23   营销产品编号
             ,BANK_TRAN_SEQ_NUM            --24   银行交易序号
             ,BUS_TRAN_BATCH_NO            --25   业务交易批次号
             ,BUS_PROC_STATUS_CD           --26   业务处理状态代码
             ,VTUAL_ACCT_FLG               --27   虚户标志
             ,LMT_CODE                     --28   限额编码
             ,CASH_PROJ_CD                 --29   现金项目代码
             ,CASH_TRAN_FLG                --30   现金交易标志
             ,CROSS_AMT                    --31   套算金额
             ,AUTH_TELLER_ID               --32   授权柜员编号
             ,EVT_CATE_ID                  --33   事件类别编号
             ,ACTL_BAL                     --34   实际余额
             ,ACTL_CROSS_EXCH_RAT          --35   实际交叉汇率
             ,EFFECT_DT                    --36   生效日期
             ,OVA_FLOW_NUM                 --37   全局流水号
             ,CHN_SUB_FLOW_NUM             --38   渠道子流水号
             ,CHN_ID                       --39   渠道编号
             ,CLEAR_DT                     --40   清算日期
             ,BEGIN_CURR_CD                --41   起始币种代码
             ,VOUCH_NO                     --42   凭证号码
             ,SELLER_QUOT_TYPE_CD          --43   卖方牌价类型代码
             ,SELLER_EXCH_RAT_VAL          --44   卖方汇率值
             ,SELLER_EXCH_RAT_CLS_CD       --45   卖方汇率分类代码
             ,SELL_AMT                     --46   卖出金额
             ,SELL_CURR_CD                 --47   卖出币种代码
             ,BUY_AMT                      --48   买入金额
             ,BUYER_QUOT_TYPE_CD           --49   买方牌价类型代码
             ,BUYER_EXCH_RAT_VAL           --50   买方汇率值
             ,BUYER_EXCH_RAT_CLS_CD        --51   买方汇率分类代码
             ,CUST_NAME                    --52   客户名称
             ,CUST_TYPE_CD                 --53   客户类型代码
             ,CUST_ECON_TYPE_CD            --54   客户经济类型代码
             ,CUST_ID                      --55   客户编号
             ,OPEN_ACCT_ORG_ID             --56   开户机构编号
             ,AMT_TYPE_CD                  --57   金额类型代码
             ,AMT_CALC_TYPE_CD             --58   金额计算类型代码
             ,DEBIT_CRDT_FLG               --59   借贷标志
             ,TRAN_KIND_CD                 --60   交易种类代码
             ,TRAN_TERMN_ID                --61   交易终端编号
             ,TRAN_MEMO_DESCB              --62   交易摘要描述
             ,TRAN_COMNT                   --63   交易说明
             ,TRAN_TM                      --64   交易时间
             ,TRAN_DT                      --65   交易日期
             ,BEF_TRAN_BAL                 --66   交易前余额
             ,TRAN_CD                      --67   交易码
             ,TRAN_AMT                     --68   交易金额
             ,TRAN_ORG_ID                  --69   交易机构编号
             ,TRAN_TELLER_ID               --70   交易柜员编号
             ,TRAN_POSTSC                  --71   交易附言
             ,TRAN_REF_NO                  --72   交易参考号
             ,PAYMENT_CORP_NAME            --73   交款单位名称
             ,CROSS_EXCH_RAT               --74   交叉汇率
             ,BASE_EQUVL_AMT               --75   基础等值金额
             ,EXCH_RAT_CLS_CD              --76   汇率分类代码
             ,CALLBK_ID                    --77   回收编号
             ,ACCTI_STATUS_CD              --78   核算状态代码
             ,POST_FLG                     --79   过账标志
             ,FOLLOW_ID                    --80   跟踪编号
             ,CHECK_TELLER_ID              --81   复核柜员编号
             ,SERV_FEE_FLG                 --82   服务费标志
             ,DISTR_FLOW_NUM               --83   放款流水号
             ,CNTPTY_ACCT_SUB_ACCT_NUM     --84   对手账户子账号
             ,CNTPTY_ACCT_NAME             --85   对手账户名称
             ,CNTPTY_ACCT_PROD_ID          --86   对手账户产品编号
             ,CNTPTY_ACCT_ID               --87   对手账户编号
             ,CNTPTY_ACCT_CURR_CD          --88   对手账户币种代码
             ,CNTPTY_BANK_NAME             --89   对手银行名称
             ,CNTPTY_BANK_NO               --90   对手银行行号
             ,CNTPTY_CUST_ACCT_NUM         --91   对手客户账号
             ,CNTPTY_OPEN_ACCT_ORG_ID      --92   对手开户机构编号
             ,CNTPTY_TRAN_FLOW_NUM         --93   对手交易流水号
             ,CNTPTY_EQUVL_AMT             --94   对手等值金额
             ,CNTPTY_CURR_CD               --95   对手币种代码
             ,CNTPTY_TRAN_REF_NO           --96   对方交易参考号
             ,AVL_WAY_CD                   --97   到账方式代码
             ,LOAN_NUM                     --98   贷款号
             ,PUBLIC_AGENT_NAME            --99   代办人名称
             ,PUBLIC_AGENT_TEL_NUM         --100  代办人电话号码
             ,DEP_VOUCH_CATE_CD            --101  存款凭证类别代码
             ,REVS_DT                      --102  冲正日期
             ,REVS_FLOW_NUM                --103  冲正流水号
             ,REVS_TRAN_CD                 --104  冲正交易码
             ,REVS_FLG                     --105  冲正标志
             ,BAL_TYPE_CD                  --106  钞汇余额代码
             ,ATTACH_RGST_DEP_FLG          --107  补登存标志
             ,CURR_CD                      --108  币种代码
             ,CHECK_ENTRY_CODE             --109  对账编码
             ,BUS_FLOW_NUM                 --110  业务流水号
             ,JOB_CD                       --111  任务代码
         FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW  --贷款金融交易流水
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --V_SQL :='TRUNCATE TABLE TMP_M_MFD_ASSURANCE_DP';
 -- EXECUTE IMMEDIATE V_SQL;

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

END ETL_M_MRPT_LOAN_FIN_TRAN_FLOW;
/

