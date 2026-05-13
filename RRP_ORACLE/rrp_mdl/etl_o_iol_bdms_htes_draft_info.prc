CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_HTES_DRAFT_INFO(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_HTES_DRAFT_INFO
  *  功能描述：票据信息主表
  *  创建日期：20230914
  *  开发人员：LYH
  *  来源表： IOL.BDMS_HTES_DRAFT_INFO
  *  目标表： O_IOL_BDMS_HTES_DRAFT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230914  LYH     首次创建
  *             2    20251108  YJY      新增字段
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_BDMS_HTES_DRAFT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_HTES_DRAFT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IOL_BDMS_HTES_DRAFT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_HTES_DRAFT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据信息主表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_BDMS_HTES_DRAFT_INFO
    (DRAFT_NUMBER        --票据（包）号
    ,DRAFT_ATTR          --票据介质
    ,DRAFT_TYPE          --票据类型
    ,REMIT_DATE          --出票日期
    ,MATURITY_DATE       --票据到期日期
    ,DRAFT_AMOUNT        --票据（包）金额
    ,REMITTER_NAME       --出票人名称
    ,REMITTER_ACCOUNT    --出票人账号
    ,REMITTER_CREDIT_NO  --出票人社会信用代码
    ,REMITTER_BRH_NO     --出票人开户机构代码
    ,REMITTER_BANK_NO    --出票人开户行行号
    ,REMITTER_BANK_NAME  --出票人开户行名称
    ,ACCEPTOR_NAME       --承兑人名称
    ,ACCEPTOR_ACCOUNT    --承兑人账号
    ,ACCEPTOR_CREDIT_NO  --承兑人社会信用代码
    ,ACCEPTOR_BRH_NO     --承兑人开户机构代码
    ,ACCEPTOR_BANK_NO    --承兑人开户行行号
    ,ACCEPTOR_BANK_NAME  --承兑人开户行名称
    ,PAYEE_NAME          --收款人名称
    ,PAYEE_ACCOUNT       --收款人账号
    ,PAYEE_CREDIT_NO     --收款人社会信用代码
    ,PAYEE_BRH_NO        --收款人开户机构代码
    ,PAYEE_BANK_NO       --收款人开户行行号
    ,PAYEE_BANK_NAME     --收款人开户行行名
    ,PAYER_BRH_NO        --付款行机构代码
    ,PAYER_BANK_NO       --付款行行号
    ,GUARANTEE_BRH_NO    --保证增信行机构代码
    ,PAYER_CONFIRM_BRH_NO  --付款确认机构代码
    ,DISCOUNT_BRH_NO       --贴现行行机构代码
    ,ACCEPT_GUA_BRH_NO     --承兑保证行机构代码
    ,DISC_GUA_BRH_NO       --贴现保证机构代码
    ,STORE_BRH_NO          --库存保管机构代码
    ,FLOW_STATUS           --票据流转状态
    ,RISK_STATUS           --风险票据状态
    ,STORE_STATUS          --票据库存状态
    ,STATUS                --票据状态
    ,ORG_FLOW_STATUS       --原流转状态：见中国票据交易系统直连接口规范【概述分册】
    ,ORG_RISK_STATUS       --原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,ORG_STATUS            --原票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,ORG_STORE_STATUS      --原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,LAST_UPD_OPR          --最后操作员
    ,LAST_UPD_TIME         --最后修改时间
    ,MISC                  --备注域
    ,DISC_DATE             --贴现日期
    ,EMERG_FLAG            --是否应急票据： 0 否 1 是
    ,BP_NO                 --供应链票据包编号
    ,FOREHAND_RANGE        --前手区间
    ,CURRENT_RANGE         --当前区间
    ,PRODUCT_TYPE          --票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,CD_RANGE              --子票区间
    ,STANDARD_AMT          --标准金额
    ,DRAFT_REMARK          --票面备注
    ,DRAFT_EXPLAIN         --票面说明
    ,CD_SPLIT              --是否允许分包流转： 0 否 1 是
    ,REMITTER_MEM_NO       --出票人渠道代码
    ,REMITTER_DIST_TP      --出票人识别类型： DT01 票据账户 DT02 银行账户
    ,REMITTER_BRH_NAME     --出票人开户行机构名称
    ,ACCEPTOR_MEM_NO       --承兑人渠道代码
    ,ACCEPTOR_DIST_TP      --承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,ACCEPTOR_BRH_NAME     --承兑人开户行机构名称
    ,PAYEE_MEM_NO          --收款人渠道代码
    ,PAYEE_DIST_TP         --收款人识别类型： DT01 票据账户 DT02 银行账户
    ,PAYEE_BRH_NAME        --收款人开户行机构名称
    ,HOLDER_MEM_NO         --持票人渠道代码
    ,HOLDER_NAME           --持票人名称
    ,HOLDER_CRT_NO         --持票人社会信用代码
    ,HOLDER_DIST_TP        --持票人识别类型： DT01 票据账户 DT02 银行账户
    ,HOLDER_ACCT_NO        --持票人账号
    ,HOLDER_BANK_NO        --持票人开户行行号
    ,HOLDER_BANK_NAME      --持票人开户行名称
    ,HOLDER_BRH_NO         --持票人开户行机构代码
    ,HOLDER_BRH_NAME       --持票人开户行机构名称
    ,TRANSFER_FLAG         --不得转让标志
    ,CONSIGNMENT_CODE      --到期无条件委托
    ,OWERSHIP_FLAG         --权属标识
    ,PAYER_NAME            --付款人名称
    ,PAYER_ACCOUNT         --付款人账号
    ,PAYER_CREDIT_NO       --付款人社会信用代码
    ,PAYER_BANK_NAME       --付款人开户行名称
    ,PAYER_MEM_NO          --付款人渠道代码
    ,PAYER_DIST_TP         --付款人识别类型
    ,PAYER_BRH_NAME        --付款人开户行机构名称
    ,ACCEPTOR_ACCTNAME     --承兑人账户名称
    ,REMITTER_ACCTNAME     --出票人账户名称
    ,PAYEE_ACCTNAME        --收款人账户名称
    ,CREATE_TIME           --创建时间
    ,CREATE_BY             --创建人
    ,REMITTER_ACCOUNT_NAME  --接收人账户名称
    ,ACCEPTOR_ACCOUNT_NAME  --承兑人账户名称
    ,PAYEE_ACCOUNT_NAME     --付款人账户名称
    ,HOLDER_ACCT_NAME       --持票人账户名称
    ,DRAFT_PAY_STATUS       --票据支付状态
    ,PAY_NO                 --票据支付订单编号
    ,SETTLE_DATE            --结清日期
    ,START_DT               --开始时间
    ,END_DT                 --结束时间
    ,ID                     --ID       ADD BY YJY 20251118
    ,MIGRATE_FLAG           --         ADD BY YJY 20251118
    )
  SELECT DRAFT_NUMBER        --票据（包）号
        ,DRAFT_ATTR          --票据介质
        ,DRAFT_TYPE          --票据类型
        ,REMIT_DATE          --出票日期
        ,MATURITY_DATE       --票据到期日期
        ,DRAFT_AMOUNT        --票据（包）金额
        ,REMITTER_NAME       --出票人名称
        ,REMITTER_ACCOUNT    --出票人账号
        ,REMITTER_CREDIT_NO  --出票人社会信用代码
        ,REMITTER_BRH_NO     --出票人开户机构代码
        ,REMITTER_BANK_NO    --出票人开户行行号
        ,REMITTER_BANK_NAME  --出票人开户行名称
        ,ACCEPTOR_NAME       --承兑人名称
        ,ACCEPTOR_ACCOUNT    --承兑人账号
        ,ACCEPTOR_CREDIT_NO  --承兑人社会信用代码
        ,ACCEPTOR_BRH_NO     --承兑人开户机构代码
        ,ACCEPTOR_BANK_NO    --承兑人开户行行号
        ,ACCEPTOR_BANK_NAME  --承兑人开户行名称
        ,PAYEE_NAME          --收款人名称
        ,PAYEE_ACCOUNT       --收款人账号
        ,PAYEE_CREDIT_NO     --收款人社会信用代码
        ,PAYEE_BRH_NO        --收款人开户机构代码
        ,PAYEE_BANK_NO       --收款人开户行行号
        ,PAYEE_BANK_NAME     --收款人开户行行名
        ,PAYER_BRH_NO        --付款行机构代码
        ,PAYER_BANK_NO       --付款行行号
        ,GUARANTEE_BRH_NO    --保证增信行机构代码
        ,PAYER_CONFIRM_BRH_NO  --付款确认机构代码
        ,DISCOUNT_BRH_NO       --贴现行行机构代码
        ,ACCEPT_GUA_BRH_NO     --承兑保证行机构代码
        ,DISC_GUA_BRH_NO       --贴现保证机构代码
        ,STORE_BRH_NO          --库存保管机构代码
        ,FLOW_STATUS           --票据流转状态
        ,RISK_STATUS           --风险票据状态
        ,STORE_STATUS          --票据库存状态
        ,STATUS                --票据状态
        ,ORG_FLOW_STATUS       --原流转状态：见中国票据交易系统直连接口规范【概述分册】
        ,ORG_RISK_STATUS       --原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
        ,ORG_STATUS            --原票据状态：见中国票据交易系统直连接口规范【概述分册】
        ,ORG_STORE_STATUS      --原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
        ,LAST_UPD_OPR          --最后操作员
        ,LAST_UPD_TIME         --最后修改时间
        ,MISC                  --备注域
        ,DISC_DATE             --贴现日期
        ,EMERG_FLAG            --是否应急票据： 0 否 1 是
        ,BP_NO                 --供应链票据包编号
        ,FOREHAND_RANGE        --前手区间
        ,CURRENT_RANGE         --当前区间
        ,PRODUCT_TYPE          --票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
        ,CD_RANGE              --子票区间
        ,STANDARD_AMT          --标准金额
        ,DRAFT_REMARK          --票面备注
        ,DRAFT_EXPLAIN         --票面说明
        ,CD_SPLIT              --是否允许分包流转： 0 否 1 是
        ,REMITTER_MEM_NO       --出票人渠道代码
        ,REMITTER_DIST_TP      --出票人识别类型： DT01 票据账户 DT02 银行账户
        ,REMITTER_BRH_NAME     --出票人开户行机构名称
        ,ACCEPTOR_MEM_NO       --承兑人渠道代码
        ,ACCEPTOR_DIST_TP      --承兑人识别类型： DT01 票据账户 DT02 银行账户
        ,ACCEPTOR_BRH_NAME     --承兑人开户行机构名称
        ,PAYEE_MEM_NO          --收款人渠道代码
        ,PAYEE_DIST_TP         --收款人识别类型： DT01 票据账户 DT02 银行账户
        ,PAYEE_BRH_NAME        --收款人开户行机构名称
        ,HOLDER_MEM_NO         --持票人渠道代码
        ,HOLDER_NAME           --持票人名称
        ,HOLDER_CRT_NO         --持票人社会信用代码
        ,HOLDER_DIST_TP        --持票人识别类型： DT01 票据账户 DT02 银行账户
        ,HOLDER_ACCT_NO        --持票人账号
        ,HOLDER_BANK_NO        --持票人开户行行号
        ,HOLDER_BANK_NAME      --持票人开户行名称
        ,HOLDER_BRH_NO         --持票人开户行机构代码
        ,HOLDER_BRH_NAME       --持票人开户行机构名称
        ,TRANSFER_FLAG         --不得转让标志
        ,CONSIGNMENT_CODE      --到期无条件委托
        ,OWERSHIP_FLAG         --权属标识
        ,PAYER_NAME            --付款人名称
        ,PAYER_ACCOUNT         --付款人账号
        ,PAYER_CREDIT_NO       --付款人社会信用代码
        ,PAYER_BANK_NAME       --付款人开户行名称
        ,PAYER_MEM_NO          --付款人渠道代码
        ,PAYER_DIST_TP         --付款人识别类型
        ,PAYER_BRH_NAME        --付款人开户行机构名称
        ,ACCEPTOR_ACCTNAME     --承兑人账户名称
        ,REMITTER_ACCTNAME     --出票人账户名称
        ,PAYEE_ACCTNAME        --收款人账户名称
        ,CREATE_TIME           --创建时间
        ,CREATE_BY             --创建人
        ,REMITTER_ACCOUNT_NAME  --接收人账户名称
        ,ACCEPTOR_ACCOUNT_NAME  --承兑人账户名称
        ,PAYEE_ACCOUNT_NAME     --付款人账户名称
        ,HOLDER_ACCT_NAME       --持票人账户名称
        ,DRAFT_PAY_STATUS       --票据支付状态
        ,PAY_NO                 --票据支付订单编号
        ,SETTLE_DATE            --结清日期
        ,START_DT               --开始时间
        ,END_DT                 --结束时间
        ,ID                     --ID       ADD BY YJY 20251118
        ,MIGRATE_FLAG           --         ADD BY YJY 20251118
    FROM IOL.V_BDMS_HTES_DRAFT_INFO  --票据信息主表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK = 'I';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_BDMS_HTES_DRAFT_INFO;
/

