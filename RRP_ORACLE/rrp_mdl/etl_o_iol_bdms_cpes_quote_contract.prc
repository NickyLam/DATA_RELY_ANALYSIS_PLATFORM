CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_CPES_QUOTE_CONTRACT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_CPES_QUOTE_CONTRACT
  *  功能描述：对话报价协议表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_BDMS_CPES_QUOTE_CONTRACT
  *  目标表： O_IOL_BDMS_CPES_QUOTE_CONTRACT
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_CPES_QUOTE_CONTRACT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_CPES_QUOTE_CONTRACT';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-对话报价协议表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_CPES_QUOTE_CONTRACT NOLOGGING
    (ID      
    ,TOP_BRANCH_NO        --总行机构号
    ,CONTRACT_NO          --协议号
    ,APPLY_DATE           --申请日期
    ,PRODUCT_NO           --产品号
    ,CUST_PRO_NO          --交易对手非法人产品号
    ,CUST_PRO_NAME        --交易对手非法人产品名称
    ,BUSI_DATE            --
    ,QUOTE_NO             --报价单编号
    ,BUSI_TYPE            --业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
    ,INNER_FLAG           --系统内外标识： 0 否 1 是
    ,IS_SEND              --是否发送报文： 0 否 1 是
    ,QUOTE_MODE           --报价方式： 0 定向报价 1 全市场报价
    ,DEAL_ID              --成交单编号
    ,TRADE_DIRECT         --交易方向： TDD01 买入 TDD02 卖出
    ,BUSI_BRANCH_NO       --业务机构号
    ,BRANCH_ACCT          --资金账户
    ,ACCT_BRANCH_NO       --账务机构号
    ,USER_ID              --交易员ID
    ,FACCT_NO             --
    ,MANAGER_NO           --客户经理
    ,DEPARTMENT_NO        --部门编号
    ,CUST_NO              --客户号
    ,CUST_USER_ID         --交易员ID
    ,CUST_NAME            --客户名称
    ,CUST_ACCT            --客户帐号
    ,CUST_BANK_NO         --  
    ,CUST_BRH_NO          --
    ,DRAFT_TYPE           --票据类型： AC01 银承 AC02 商承
    ,DRAFT_ATTR           --票据介质： ME01 纸票 ME02 电票
    ,SUM_COUNT            --票据张数
    ,SUM_AMOUNT           --票据总额
    ,BUY_BACK_AMT         --回购金额
    ,TENOR_DAYS           --持票期限
    ,SUB_DEAL_FLAG        --部分成交选项： 0 否 1 是
    ,QUOTE_VALID_TM       --报价有效时间
    ,CLEAR_SPEED          --清算速度： CS00 T+0 CS01 T+1
    ,CLEAR_TYPE           --清算类型： CT01 全额清算 CT02 净额清算
    ,SETTLE_TIME          --最晚结算时间
    ,SETTLE_MODE          --结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
    ,SETTLE_AMT           --结算金额
    ,DUE_SETTLE_AMT       --到期结算金额
    ,SETTLE_DATE          --结算日期
    ,DUE_SETTLE_DATE      --到期结算日期
    ,RATE                 --利率
    ,DUE_RATE             --到期利率
    ,PAY_INTEREST         --应付利息
    ,DUE_PAY_INTEREST     --到期应付利息
    ,YIELD_RATE           --收益率
    ,SELECT_TYPE          --挑票类型： CSM01 单票 CSM02 票据包
    ,PACKAGE_NO           --票据包编号
    ,CHECK_STATUS         --检查状态
    ,CREDIT_CHECK_STATUS  --额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
    ,CREDIT_NO            --额度编号
    ,ACCOUNT_STATUS       --记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,MESSAGE_STATUS       --报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
    ,SETTLE_STATUS        --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
    ,LAST_UPD_OPR         --最后操作员
    ,LAST_UPD_TIME        --最后修改时间
    ,MISC                 --备注
    ,RESERVER1            --预留域1
    ,RESERVER2            --预留域2
    ,CONTRACT_STATUS      --审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,MODIFY_FLAG          --是否修改： 0 否 1 是
    ,CREATED_BY           --创建人
    ,I9_TYPE              --I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
    ,OWN_PRO_NO           --本方非法人产品
    ,OWN_PRO_NAME         --本方非法人产品名称
    ,START_DT             --开始时间
    ,END_DT               --结束时间
    ,ID_MARK              --增删标志
    ,ETL_TIMESTAMP        --ETL处理时间戳
    ,BUSSINESS_TYPE       --业务所属分行
     )
  SELECT /*+PARALLEL*/
         ID      
         ,TOP_BRANCH_NO        --总行机构号
         ,CONTRACT_NO          --协议号
         ,APPLY_DATE           --申请日期
         ,PRODUCT_NO           --产品号
         ,CUST_PRO_NO          --交易对手非法人产品号
         ,CUST_PRO_NAME        --交易对手非法人产品名称
         ,BUSI_DATE            --
         ,QUOTE_NO             --报价单编号
         ,BUSI_TYPE            --业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
         ,INNER_FLAG           --系统内外标识： 0 否 1 是
         ,IS_SEND              --是否发送报文： 0 否 1 是
         ,QUOTE_MODE           --报价方式： 0 定向报价 1 全市场报价
         ,DEAL_ID              --成交单编号
         ,TRADE_DIRECT         --交易方向： TDD01 买入 TDD02 卖出
         ,BUSI_BRANCH_NO       --业务机构号
         ,BRANCH_ACCT          --资金账户
         ,ACCT_BRANCH_NO       --账务机构号
         ,USER_ID              --交易员ID
         ,FACCT_NO             --
         ,MANAGER_NO           --客户经理
         ,DEPARTMENT_NO        --部门编号
         ,CUST_NO              --客户号
         ,CUST_USER_ID         --交易员ID
         ,CUST_NAME            --客户名称
         ,CUST_ACCT            --客户帐号
         ,CUST_BANK_NO         --  
         ,CUST_BRH_NO          --
         ,DRAFT_TYPE           --票据类型： AC01 银承 AC02 商承
         ,DRAFT_ATTR           --票据介质： ME01 纸票 ME02 电票
         ,SUM_COUNT            --票据张数
         ,SUM_AMOUNT           --票据总额
         ,BUY_BACK_AMT         --回购金额
         ,TENOR_DAYS           --持票期限
         ,SUB_DEAL_FLAG        --部分成交选项： 0 否 1 是
         ,QUOTE_VALID_TM       --报价有效时间
         ,CLEAR_SPEED          --清算速度： CS00 T+0 CS01 T+1
         ,CLEAR_TYPE           --清算类型： CT01 全额清算 CT02 净额清算
         ,SETTLE_TIME          --最晚结算时间
         ,SETTLE_MODE          --结算方式： ST01 票款对付（DVP） ST02 纯票过户（FOP）
         ,SETTLE_AMT           --结算金额
         ,DUE_SETTLE_AMT       --到期结算金额
         ,SETTLE_DATE          --结算日期
         ,DUE_SETTLE_DATE      --到期结算日期
         ,RATE                 --利率
         ,DUE_RATE             --到期利率
         ,PAY_INTEREST         --应付利息
         ,DUE_PAY_INTEREST     --到期应付利息
         ,YIELD_RATE           --收益率
         ,SELECT_TYPE          --挑票类型： CSM01 单票 CSM02 票据包
         ,PACKAGE_NO           --票据包编号
         ,CHECK_STATUS         --检查状态
         ,CREDIT_CHECK_STATUS  --额度检查状态： 00 未处理 01 占用中 02 占用成功 03 占用失败 04 释放成功 05 释放失败
         ,CREDIT_NO            --额度编号
         ,ACCOUNT_STATUS       --记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
         ,MESSAGE_STATUS       --报文状态： 01 已发送申请报文 00 未处理 02 收到确认 03 成交通知 04 终止通知 05 申请撤销 06 已发送撤销报文收到人行确认成功 11 已发送签收报文 21 已发送申请收到人行确认失败 22 已发送撤销报文收到人行确认失败 23 已发送签收报文收到人行确认失败 24 已发送申请收到人行签收拒绝（再贴现） 12 已发送签收收到人行确认成功
         ,SETTLE_STATUS        --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
         ,LAST_UPD_OPR         --最后操作员
         ,LAST_UPD_TIME        --最后修改时间
         ,MISC                 --备注
         ,RESERVER1            --预留域1
         ,RESERVER2            --预留域2
         ,CONTRACT_STATUS      --审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
         ,MODIFY_FLAG          --是否修改： 0 否 1 是
         ,CREATED_BY           --创建人
         ,I9_TYPE              --I9新会计准则资产类型，转贴现业务默认为FVOCI，买入返售默认AC分类
         ,OWN_PRO_NO           --本方非法人产品
         ,OWN_PRO_NAME         --本方非法人产品名称
         ,START_DT             --开始时间
         ,END_DT               --结束时间
         ,ID_MARK              --增删标志
         ,ETL_TIMESTAMP        --ETL处理时间戳
         ,BUSSINESS_TYPE       --业务所属分行
    FROM IOL.V_BDMS_CPES_QUOTE_CONTRACT --对话报价协议表
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_BDMS_CPES_QUOTE_CONTRACT', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_BDMS_CPES_QUOTE_CONTRACT;
/

