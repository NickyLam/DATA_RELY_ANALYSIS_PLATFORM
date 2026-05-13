CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_ACCT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：账户基本信息表
  **存储过程名称：    ETL_O_IOL_NCBS_RB_ACCT
  **存储过程创建日期：20251210
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251210    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_NCBS_RB_ACCT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_ACCT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-账户基本信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_ACCT NOLOGGING 
  (    ACCT_NAME                --账户名称
      ,ACCT_SEQ_NO              --账户子账号
      ,ACCT_STATUS              --账户状态
      ,ACCT_TYPE                --账户类型
      ,BASE_ACCT_NO             --交易账号/卡号
      ,BUSINESS_UNIT            --账套
      ,CARD_NO                  --卡号
      ,CLIENT_NO                --客户编号
      ,CLIENT_TYPE              --客户类型
      ,DOC_TYPE                 --凭证类型
      ,DOCUMENT_ID              --证件号码
      ,DOCUMENT_TYPE            --客户证件类型
      ,INTERNAL_KEY             --账户内部键值
      ,PROD_TYPE                --产品编号
      ,PROFIT_CENTER            --利润中心
      ,REASON_CODE              --账户用途
      ,USER_ID                  --交易柜员编号
      ,VOUCHER_STATUS           --凭证状态
      ,TERM                     --存期
      ,TERM_TYPE                --期限单位
      ,ACCT_CLASS               --账户等级
      ,ACCT_DESC                --账户描述
      ,ACCT_EXEC                --银行客户经理编号
      ,ACCT_LICENSE_NO          --账户许可证号
      ,ACCT_NATURE              --存款账户类型
      ,ACCT_REAL_FLAG           --账户虚实标志
      ,ACCT_RES_STATUS          --账户限制标志
      ,ACCT_STATUS_PREV         --账户上一状态
      ,ACCT_STOP_PAY            --账户余额止付标志
      ,ADDTL_PRINCIPAL          --是否允许增加本金
      ,AGREEMENT_ID             --协议编号
      ,ALL_DEP_IND              --通存标志
      ,ALL_DRA_IND              --通兑标志
      ,APPR_FLAG                --复核标志
      ,APPR_LETTER_NO           --核准件编号
      ,AUTO_RENEW_ROLLOVER      --自动转存方式
      ,AUTO_SETTLE_FLAG         --自动结清标志
      ,BAL_TYPE                 --余额类型
      ,CHECKED_FLAG             --黑名单是否已检查标志位
      ,COMPANY                  --法人
      ,CUR_STAGE_NO             --当前期数
      ,DAC_VALUE                --dac值防篡改加密
      ,GL_TYPE                  --总账类型
      ,IMPOUND_FAD              --强制扣划导致违约状态
      ,INDIVIDUAL_FLAG          --对公对私标志
      ,INT_IND_FLAG             --是否计息
      ,JOINT_ACCT_FLAG          --联合账户标志
      ,LAST_MVMT_STATUS         --定期账户上一次更改状态
      ,LEAD_ACCT_FLAG           --主账户标志
      ,MAIN_BAL_FLAG            --主账户是否带余额
      ,MAIN_INT_FLAG            --主账户是否带利息
      ,MANAGEMENT_FREE_FLAG     --对公免收管理费标志，对私免收管理费和卡年费标识
      ,MULTI_BAL_TYPE_FLAG      --是否多余额
      ,NO_TRAN_FLAG             --6个月无交易标志
      ,OSA_FLAG                 --离岸标记
      ,OWNERSHIP_TYPE           --归属种类
      ,PARTIAL_RENEW_ROLL       --是否部分本金转存
      ,PREFIX                   --前缀
      ,RECOVER_FLAG             --实时追缴标志字段
      ,REGION_FLAG              --区内区外标记
      ,RENEW_NO                 --本金转存次数
      ,ROLLOVER_NO              --本息转存次数
      ,SETTLE                   --结算标志
      ,SOURCE_MODULE            --源模块
      ,SOURCE_TYPE              --渠道编号
      ,TERMINAL_ID              --交易终端编号
      ,TIMES_RENEWED            --已本金转存次数
      ,TIMES_ROLLEDOVER         --已本息转存次数
      ,XRATE_ID                 --汇兑方式
      ,ACCOUNTING_STATUS        --核算状态
      ,ACCOUNTING_STATUS_PREV   --上次核算状态
      ,FIXED_CALL               --定期账户细类
      ,ACCOUNTING_STATUS_UPD_DATE  --核算状态变更日期
      ,ACCT_CLOSE_DATE          --销户日期
      ,ACCT_DUE_DATE            --账户有效日期
      ,ACCT_LICENSE_DATE        --账户许可证签发日期
      ,ACCT_OPEN_DATE           --账户开户日期
      ,ACCT_STATUS_UPD_DATE     --账户状态变更日期
      ,APPROVAL_DATE            --复核日期
      ,DORMANT_DATE             --转不动户日期
      ,EFFECT_DATE              --产品生效日期
      ,LAST_CHANGE_DATE         --最后修改日期
      ,LAST_TRAN_DATE           --最后交易日期
      ,MATURITY_DATE            --到期日期
      ,OPEN_TRAN_DATE           --开户后首次交易日期
      ,ORI_MATURITY_DATE        --账户原始到期日期
      ,ORIG_ACCT_OPEN_DATE      --账户原始开立日期
      ,SETTLE_DATE              --结算日期
      ,TRAN_TIMESTAMP           --交易时间戳
      ,ISS_COUNTRY              --发证国家
      ,ACCT_BRANCH              --开户机构编号
      ,ACCT_CCY                 --账户币种
      ,ACCT_CLOSE_REASON        --关闭原因
      ,ACCT_CLOSE_USER_ID       --账户销户操作柜员
      ,ALT_ACCT_NAME            --备用账户名称
      ,APPR_USER_ID             --复核柜员
      ,HOME_BRANCH              --客户管理行
      ,LAST_CHANGE_USER_ID      --最后修改柜员
      ,MAIN_PROD_TYPE           --卡产品代码
      ,MM_REF_NO                --资金交易参考号
      ,NOTICE_PERIOD            --通知期限
      ,OLD_PROD_TYPE            --原产品类型
      ,PARENT_INTERNAL_KEY      --上级账户标识符
      ,SETTLE_USER_ID           --结算柜员
      ,VOUCHER_START_NO         --凭证起始号码
      ,XRATE                    --汇率
      ,APPLY_BRANCH             --申请机构
      ,ACCT_NAME_PREFIX         --账户名称前缀
      ,ACCT_NAME_SUFFIX         --账户名称后缀
      ,OPEN_USER_ID             --开户柜员编号
      ,ACCT_PROPERTY2           --账户性质2
      ,AMEND_DATE               --变更日期
      ,IS_MED_INS_FLAG          --是否医保账户标志
      ,IS_TRAVEL_CARD_FLAG      --是否旅行通账户标志
      ,TRAVEL_DUE_DATE          --旅行通卡有效期
      ,IS_SOC_FIN_FLAG          --是否为社保卡下金融账户标志
      ,START_DT                 --开始时间
      ,END_DT                   --结束时间
      ,ID_MARK                  --增删标志
      ,ETL_TIMESTAMP            --ETL处理时间戳
    )
  SELECT 
       ACCT_NAME                --账户名称
      ,ACCT_SEQ_NO              --账户子账号
      ,ACCT_STATUS              --账户状态
      ,ACCT_TYPE                --账户类型
      ,BASE_ACCT_NO             --交易账号/卡号
      ,BUSINESS_UNIT            --账套
      ,CARD_NO                  --卡号
      ,CLIENT_NO                --客户编号
      ,CLIENT_TYPE              --客户类型
      ,DOC_TYPE                 --凭证类型
      ,DOCUMENT_ID              --证件号码
      ,DOCUMENT_TYPE            --客户证件类型
      ,INTERNAL_KEY             --账户内部键值
      ,PROD_TYPE                --产品编号
      ,PROFIT_CENTER            --利润中心
      ,REASON_CODE              --账户用途
      ,USER_ID                  --交易柜员编号
      ,VOUCHER_STATUS           --凭证状态
      ,TERM                     --存期
      ,TERM_TYPE                --期限单位
      ,ACCT_CLASS               --账户等级
      ,ACCT_DESC                --账户描述
      ,ACCT_EXEC                --银行客户经理编号
      ,ACCT_LICENSE_NO          --账户许可证号
      ,ACCT_NATURE              --存款账户类型
      ,ACCT_REAL_FLAG           --账户虚实标志
      ,ACCT_RES_STATUS          --账户限制标志
      ,ACCT_STATUS_PREV         --账户上一状态
      ,ACCT_STOP_PAY            --账户余额止付标志
      ,ADDTL_PRINCIPAL          --是否允许增加本金
      ,AGREEMENT_ID             --协议编号
      ,ALL_DEP_IND              --通存标志
      ,ALL_DRA_IND              --通兑标志
      ,APPR_FLAG                --复核标志
      ,APPR_LETTER_NO           --核准件编号
      ,AUTO_RENEW_ROLLOVER      --自动转存方式
      ,AUTO_SETTLE_FLAG         --自动结清标志
      ,BAL_TYPE                 --余额类型
      ,CHECKED_FLAG             --黑名单是否已检查标志位
      ,COMPANY                  --法人
      ,CUR_STAGE_NO             --当前期数
      ,DAC_VALUE                --dac值防篡改加密
      ,GL_TYPE                  --总账类型
      ,IMPOUND_FAD              --强制扣划导致违约状态
      ,INDIVIDUAL_FLAG          --对公对私标志
      ,INT_IND_FLAG             --是否计息
      ,JOINT_ACCT_FLAG          --联合账户标志
      ,LAST_MVMT_STATUS         --定期账户上一次更改状态
      ,LEAD_ACCT_FLAG           --主账户标志
      ,MAIN_BAL_FLAG            --主账户是否带余额
      ,MAIN_INT_FLAG            --主账户是否带利息
      ,MANAGEMENT_FREE_FLAG     --对公免收管理费标志，对私免收管理费和卡年费标识
      ,MULTI_BAL_TYPE_FLAG      --是否多余额
      ,NO_TRAN_FLAG             --6个月无交易标志
      ,OSA_FLAG                 --离岸标记
      ,OWNERSHIP_TYPE           --归属种类
      ,PARTIAL_RENEW_ROLL       --是否部分本金转存
      ,PREFIX                   --前缀
      ,RECOVER_FLAG             --实时追缴标志字段
      ,REGION_FLAG              --区内区外标记
      ,RENEW_NO                 --本金转存次数
      ,ROLLOVER_NO              --本息转存次数
      ,SETTLE                   --结算标志
      ,SOURCE_MODULE            --源模块
      ,SOURCE_TYPE              --渠道编号
      ,TERMINAL_ID              --交易终端编号
      ,TIMES_RENEWED            --已本金转存次数
      ,TIMES_ROLLEDOVER         --已本息转存次数
      ,XRATE_ID                 --汇兑方式
      ,ACCOUNTING_STATUS        --核算状态
      ,ACCOUNTING_STATUS_PREV   --上次核算状态
      ,FIXED_CALL               --定期账户细类
      ,ACCOUNTING_STATUS_UPD_DATE  --核算状态变更日期
      ,ACCT_CLOSE_DATE          --销户日期
      ,ACCT_DUE_DATE            --账户有效日期
      ,ACCT_LICENSE_DATE        --账户许可证签发日期
      ,ACCT_OPEN_DATE           --账户开户日期
      ,ACCT_STATUS_UPD_DATE     --账户状态变更日期
      ,APPROVAL_DATE            --复核日期
      ,DORMANT_DATE             --转不动户日期
      ,EFFECT_DATE              --产品生效日期
      ,LAST_CHANGE_DATE         --最后修改日期
      ,LAST_TRAN_DATE           --最后交易日期
      ,MATURITY_DATE            --到期日期
      ,OPEN_TRAN_DATE           --开户后首次交易日期
      ,ORI_MATURITY_DATE        --账户原始到期日期
      ,ORIG_ACCT_OPEN_DATE      --账户原始开立日期
      ,SETTLE_DATE              --结算日期
      ,TRAN_TIMESTAMP           --交易时间戳
      ,ISS_COUNTRY              --发证国家
      ,ACCT_BRANCH              --开户机构编号
      ,ACCT_CCY                 --账户币种
      ,ACCT_CLOSE_REASON        --关闭原因
      ,ACCT_CLOSE_USER_ID       --账户销户操作柜员
      ,ALT_ACCT_NAME            --备用账户名称
      ,APPR_USER_ID             --复核柜员
      ,HOME_BRANCH              --客户管理行
      ,LAST_CHANGE_USER_ID      --最后修改柜员
      ,MAIN_PROD_TYPE           --卡产品代码
      ,MM_REF_NO                --资金交易参考号
      ,NOTICE_PERIOD            --通知期限
      ,OLD_PROD_TYPE            --原产品类型
      ,PARENT_INTERNAL_KEY      --上级账户标识符
      ,SETTLE_USER_ID           --结算柜员
      ,VOUCHER_START_NO         --凭证起始号码
      ,XRATE                    --汇率
      ,APPLY_BRANCH             --申请机构
      ,ACCT_NAME_PREFIX         --账户名称前缀
      ,ACCT_NAME_SUFFIX         --账户名称后缀
      ,OPEN_USER_ID             --开户柜员编号
      ,ACCT_PROPERTY2           --账户性质2
      ,AMEND_DATE               --变更日期
      ,IS_MED_INS_FLAG          --是否医保账户标志
      ,IS_TRAVEL_CARD_FLAG      --是否旅行通账户标志
      ,TRAVEL_DUE_DATE          --旅行通卡有效期
      ,IS_SOC_FIN_FLAG          --是否为社保卡下金融账户标志
      ,START_DT                 --开始时间
      ,END_DT                   --结束时间
      ,ID_MARK                  --增删标志
      ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_NCBS_RB_ACCT --视图-账户基本信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'
      ;

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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_NCBS_RB_ACCT', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_NCBS_RB_ACCT;
/

