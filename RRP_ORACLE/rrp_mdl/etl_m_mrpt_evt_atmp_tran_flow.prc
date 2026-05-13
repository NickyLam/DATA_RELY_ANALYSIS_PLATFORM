CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_ATMP_TRAN_FLOW(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_EVT_ATMP_TRAN_FLOW
  *  功能描述：ATMP银联前置交易流水
  *  创建日期：2022/12/07
  *  开发人员：HDY
  *  来源表：  O_IML_EVT_ATMP_UNIONPAY_TRAN_FLOW ATMP银联前置交易流水

  *  目标表：  M_MRPT_EVT_ATMP_TRAN_FLOW
  *
  *  配置表：
  *  修改情况：1  202212/07  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_EVT_ATMP_TRAN_FLOW' ;-- 程序名称
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
  V_TAB_NAME := 'M_MRPT_EVT_ATMP_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_EVT_ATMP_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  V_STEP_DESC := '--M层数据落地 ATMP银联前置交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_EVT_ATMP_TRAN_FLOW
             (DATA_DT                          --01 数据日期
              ,EVT_ID                          --02 事件编号
              ,LP_ID                           --03 法人编号
              ,SEND_ORG_ID                     --04 发送机构编号
              ,SYS_FOLLOW_ID                   --05 系统跟踪编号
              ,TRAN_TM                         --06 交易时间
              ,TRAN_CD                         --07 交易代码
              ,TRAN_TYPE_CD                    --08 交易类型代码
              ,PROC_ORG_ID                     --09 受理机构编号
              ,TRAN_DT                         --10 交易日期
              ,TELLER_ID                       --11 柜员编号
              ,TRAN_ORG_ID                     --12 交易机构编号
              ,CHN_CD                          --13 源系统代码
              ,MSG_TYPE_CD                     --14 报文类型代码
              ,MAIN_ACCT_ID                    --15 主账户编号
              ,PROC_CD                         --16 处理代码
              ,INTNAL_PROC_CD                  --17 内部处理代码
              ,TRAN_AMT                        --18 交易金额
              ,ONL_ACCT_BAL                    --19 联机账户余额
              ,ACCT_TD_AVAL_BAL                --20 账户当日可用余额
              ,ATM_DRAW_TD_AVAL_BAL            --21 atm取款当日可用余额
              ,TRAN_FEE                        --22 交易费用
              ,PROC_ORG_SITE_TM                --23 受理机构所在地时间
              ,PROC_ORG_SITE_DT                --24 受理机构所在地日期
              ,CLEAR_DT                        --25 清算日期
              ,MERCHT_TYPE_CD                  --26 商户类型代码
              ,RETURN_CODE                     --27 返回码
              ,CURR_CD                         --28 币种代码
              ,UNIONPAY_EXCH_RAT               --29 银联汇率
              ,EXPNS_ACCT_ID                   --30 支出账户编号
              ,DEPOT_ACCT_ID                   --31 存入账户编号
              ,ATMC_TRAN_FLOW_NUM              --32 atmc交易流水号
              ,TRAN_STATUS_CD                  --33 交易状态代码
              ,ERR_CD                          --34 错误码
              ,ERR_INFO                        --35 错误信息
              ,TERMN_TYPE_CD                   --36 终端类型代码
              ,INIT_WAY_CD                     --37 发起方式代码
              ,MERCHT_CTY_RG_CD                --38 商户国家地区代码
              ,DEDUCT_AMT                      --39 扣款金额
              ,DEDUCT_EXCH_RAT                 --40 扣款汇率
              ,CLEAR_AMT                       --41 清算金额
              ,CROSS_BOR_FLG                   --42 跨境标志
              ,CARD_SER_NUM                    --43 卡序列号
              ,INTNAL_TRAN_CD                  --44 内部交易代码
              ,FCURR_TRAN_AMT                  --45 外币交易金额
              ,BANK_ACCT_TYPE_CD               --46 银行账户类型代码
              ,OPEN_ACCT_ORG_ID                --47 开户机构编号
              ,COMM_FEE                        --48 手续费
              ,CARD_TYPE_CD                    --49 卡类型代码
              ,CARD_TRAN_TYPE_CD               --50 卡交易类型代码
              ,QR_CODE_PAY_SCENE_CD            --51 二维码付款场景代码
              ,CROSS_BANK_FLG                  --52 跨行标志
              ,DEGR_FLG                        --53 降级标志
              ,BEPS_UNPASEW_FLG                --54 小额免密标志
              ,SUBCLASS_RETURN_CODE            --55 细类返回码
              ,MEMO_CD                         --56 摘要代码
              ,OVA_FLOW_NUM                    --57 全局流水号
              ,TRAN_FLOW_NUM                   --58 交易流水号
              ,INIT_TRAN_FLOW_NUM              --59 原交易流水号
              ,CUST_ID                         --60 交易客户编号
              ,CUST_NAME                       --61 客户名称
              ,MIDGROD_TRAN_DT                 --62 中台交易日期
              ,ACCT_DT                         --63 账务日期
              ,INIT_TRAN_CD                    --64 原交易代码
              ,AMOUNT_CLASS                    --65 单笔金额分级
              ,BARCODE_CODE                    --66 条码付款业务类型
              ,ETL_DT                          --67 etl处理日期
       )
      SELECT    V_P_DATE                       --01 数据日期
              ,EVT_ID                          --02 事件编号
              ,LP_ID                           --03 法人编号
              ,SEND_ORG_ID                     --04 发送机构编号
              ,SYS_FOLLOW_ID                   --05 系统跟踪编号
              ,TRAN_TM                         --06 交易时间
              ,TRAN_CD                         --07 交易代码
              ,TRAN_TYPE_CD                    --08 交易类型代码
              ,PROC_ORG_ID                     --09 受理机构编号
              ,TRAN_DT                         --10 交易日期
              ,TELLER_ID                       --11 柜员编号
              ,TRAN_ORG_ID                     --12 交易机构编号
              ,CHN_CD                          --13 源系统代码
              ,MSG_TYPE_CD                     --14 报文类型代码
              ,MAIN_ACCT_ID                    --15 主账户编号
              ,PROC_CD                         --16 处理代码
              ,INTNAL_PROC_CD                  --17 内部处理代码
              ,TRAN_AMT                        --18 交易金额
              ,ONL_ACCT_BAL                    --19 联机账户余额
              ,ACCT_TD_AVAL_BAL                --20 账户当日可用余额
              ,ATM_DRAW_TD_AVAL_BAL            --21 atm取款当日可用余额
              ,TRAN_FEE                        --22 交易费用
              ,PROC_ORG_SITE_TM                --23 受理机构所在地时间
              ,PROC_ORG_SITE_DT                --24 受理机构所在地日期
              ,CLEAR_DT                        --25 清算日期
              ,MERCHT_TYPE_CD                  --26 商户类型代码
              ,RETURN_CODE                     --27 返回码
              ,CURR_CD                         --28 币种代码
              ,UNIONPAY_EXCH_RAT               --29 银联汇率
              ,EXPNS_ACCT_ID                   --30 支出账户编号
              ,DEPOT_ACCT_ID                   --31 存入账户编号
              ,ATMC_TRAN_FLOW_NUM              --32 atmc交易流水号
              ,TRAN_STATUS_CD                  --33 交易状态代码
              ,ERR_CD                          --34 错误码
              ,ERR_INFO                        --35 错误信息
              ,TERMN_TYPE_CD                   --36 终端类型代码
              ,INIT_WAY_CD                     --37 发起方式代码
              ,MERCHT_CTY_RG_CD                --38 商户国家地区代码
              ,DEDUCT_AMT                      --39 扣款金额
              ,DEDUCT_EXCH_RAT                 --40 扣款汇率
              ,CLEAR_AMT                       --41 清算金额
              ,CROSS_BOR_FLG                   --42 跨境标志
              ,CARD_SER_NUM                    --43 卡序列号
              ,INTNAL_TRAN_CD                  --44 内部交易代码
              ,FCURR_TRAN_AMT                  --45 外币交易金额
              ,BANK_ACCT_TYPE_CD               --46 银行账户类型代码
              ,OPEN_ACCT_ORG_ID                --47 开户机构编号
              ,COMM_FEE                        --48 手续费
              ,CARD_TYPE_CD                    --49 卡类型代码
              ,CARD_TRAN_TYPE_CD               --50 卡交易类型代码
              ,QR_CODE_PAY_SCENE_CD            --51 二维码付款场景代码
              ,CROSS_BANK_FLG                  --52 跨行标志
              ,DEGR_FLG                        --53 降级标志
              ,BEPS_UNPASEW_FLG                --54 小额免密标志
              ,SUBCLASS_RETURN_CODE            --55 细类返回码
              ,MEMO_CD                         --56 摘要代码
              ,OVA_FLOW_NUM                    --57 全局流水号
              ,TRAN_FLOW_NUM                   --58 交易流水号
              ,INIT_TRAN_FLOW_NUM              --59 原交易流水号
              ,CUST_ID                         --60 交易客户编号
              ,CUST_NAME                       --61 客户名称
              ,MIDGROD_TRAN_DT                 --62 中台交易日期
              ,ACCT_DT                         --63 账务日期
              ,INIT_TRAN_CD                    --64 原交易代码
              ,CASE WHEN TRAN_AMT > 0  AND TRAN_AMT <= 500  THEN 'A'
                    WHEN TRAN_AMT >500 AND TRAN_AMT <= 5000 THEN 'B'
                    WHEN TRAN_AMT >5000 THEN 'C'
                    END  AS AMOUNT_CLASS       --65 单笔金额分级
              ,CASE WHEN INTNAL_TRAN_CD = 'ZTSA51F01' THEN '条码取现'
                    WHEN QR_CODE_PAY_SCENE_CD = '232' THEN '条码转账'
                    ELSE '条码消费'
                    END  AS BARCODE_CODE       --66 条码付款业务类型
              ,ETL_DT                          --67 etl处理日期
         FROM RRP_MDL.O_IML_EVT_ATMP_UNIONPAY_TRAN_FLOW  --ATMP银联前置交易流水表
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

END ETL_M_MRPT_EVT_ATMP_TRAN_FLOW;
/

