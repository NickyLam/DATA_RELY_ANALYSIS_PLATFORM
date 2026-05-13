CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_DPC_DRAFT_TRANS_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：登记中心票据流转信息表
  **存储过程名称：    ETL_O_IOL_BDMS_DPC_DRAFT_TRANS_INFO
  **存储过程创建日期：20251215
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251215    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_BDMS_DPC_DRAFT_TRANS_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_DPC_DRAFT_TRANS_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-登记中心票据流转信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_DPC_DRAFT_TRANS_INFO NOLOGGING 
  (        ID                   --ID
          ,CONTRACT_ID          --业务协议表ID
          ,PROTOCOL_NO          --业务编号（协议号）
          ,DETAILS_ID           --业务协议明细表ID
          ,DRAFT_ID             --票据表ID
          ,PRODUCT_NO           --产品码
          ,DRAFT_ATTR           --票据介质： ME01 纸票 ME02 电票
          ,DRAFT_TYPE           --票据类型： AC01 银承 AC02 商承
          ,BUSI_TYPE            --交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
          ,BUSI_ATTR_NO         --业务属性号
          ,PRODUCT_NAME         --产品名称
          ,DRAFT_NUMBER         --票据（包）号
          ,DRAFT_AMOUNT         --票据（包）金额
          ,CUST_NO              --客户号
          ,TRADE_DIRECT         --交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
          ,TXN_DATE             --交易日期
          ,REQ_TYPE             --请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
          ,REQ_NAME             --请求方名称
          ,REQ_CERT_NO          --请求方社会信用代码
          ,REQ_ACCOUNT          --请求方账号
          ,REQ_MEM_NO           --请求方会员编码
          ,REQ_BRH_NO           --请求方机构编号
          ,REQ_BANK_NO          --请求方支付系统行号
          ,REQ_MISC             --请求方备注
          ,RCV_TYPE             --接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
          ,RCV_NAME             --接收方名称
          ,RCV_CERT_NO          --接收方社会信用代码
          ,RCV_ACCOUNT          --接收方账号
          ,RCV_MEM_NO           --接收方会员编码
          ,RCV_BRH_NO           --接收方机构编号
          ,RCV_BANK_NO          --接收方支付系统行号
          ,RCV_MISC             --接收方备注
          ,PAY_AMOUNT           --实付金额
          ,PAY_TYPE             --付息方式
          ,PAY_INTEREST         --实付利息
          ,PAYMENT_DATE         --计息到期日
          ,DRAWEE_NAME          --付息人名称
          ,DRAWEE_ACCOUNT       --付息人帐号
          ,DRAWEE_BANK_NAME     --付息人开户行
          ,REPURCHASE_RATE      --赎回利率
          ,CHARGE               --手续费
          ,EXPENSES             --工本费
          ,RPD_MK               --是否回购式
          ,AGENT_NAME           --代理人名称
          ,RATE                 --利率
          ,PAYER_SALE           --付息比例
          ,BUYER_INTEREST       --买方付息
          ,INTEREST             --总利息
          ,MOVE_TRS_TYPE        --库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
          ,CONF_PAY_TYPE        --付款确认类型： VM01 影像验证 VM02 实物验证
          ,CONF_PAY_ADD_TYPE    --付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
          ,CONF_PAY_RST         --付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
          ,STOP_PAY_TYPE        --止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
          ,STOP_PAY_RSN         --止付原因
          ,RELIEVE_STP_TYPE     --解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
          ,RELIEVE_STP_RSN      --解除止付原因
          ,TENOR_DAYS           --剩余期限
          ,SETTLE_AMT           --结算金额
          ,BUY_BACK_DATE        --回购到期日
          ,REAL_BACK_DATE       --实际回购日
          ,BUY_BACK_STATUS      --回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
          ,EXCHGE_STATUS        --置换状态： ES01 被他票替换 ES02 替换他票
          ,PRMT_RESULT          --提示付款应答结果： SU00 同意 SU01 拒绝
          ,PRMT_REFUSE_RSN      --提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
          ,PRMT_STL_RST         --提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
          ,REFUSE_RSN           --付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
          ,SIG_MK               --签收意见
          ,ACCT_DATE            --记账日期
          ,TRANS_NAME           --交易名称
          ,LAST_TRANS_ID        --上一笔交易TRANS_ID
          ,INNER_FLAG           --是否系统内： 0 否 1 是
          ,TRANS_STATUS         --交易状态： TS0000 无效 TS0001 有效 TS0002 完成
          ,SETTLE_TYPE          --结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
          ,TRANS_BRANCH_NO      --交易机构号
          ,ACCT_BRANCH_NO       --记账机构号
          ,STORE_BRH_NO         --库存机构号
          ,TOP_BRANCH_NO        --总行机构号
          ,LAST_UPD_OPR         --最后操作人
          ,LAST_UPD_TIME        --最后修改时间
          ,MISC                 --备注域
          ,CD_RANGE             --子票区间
          ,PRODUCT_TYPE         --票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
          ,REQ_BUSS_TYPE        --请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
          ,RCV_BUSS_TYPE        --接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
          ,REQ_DIST_TP          --请求方识别类型 DT01 票据账户 DT02 银行账户
          ,RCV_DIST_TP          --接收方识别类型 DT01 票据账户 DT02 银行账户
          ,CREATE_TIME          --创建时间
          ,CREATE_BY      
          ,START_DT             --开始时间
          ,END_DT               --结束时间
          ,ID_MARK              --增删标志
          ,ETL_TIMESTAMP        --ETL处理时间戳
    )
  SELECT 
           ID                   --ID
          ,CONTRACT_ID          --业务协议表ID
          ,PROTOCOL_NO          --业务编号（协议号）
          ,DETAILS_ID           --业务协议明细表ID
          ,DRAFT_ID             --票据表ID
          ,PRODUCT_NO           --产品码
          ,DRAFT_ATTR           --票据介质： ME01 纸票 ME02 电票
          ,DRAFT_TYPE           --票据类型： AC01 银承 AC02 商承
          ,BUSI_TYPE            --交易种类： 103 登记类 104 库存变更 105 保证增信 106 付款确认 107 保证业务 108 同业质押 109 同业质押解除 110 提示付款 111 追偿 112 出入金 113 系统外对话报价买入 114 系统内对话报价买入 115 系统外对话报价卖出 116 系统内对话报价卖出 117 线下追偿 118 非交易过户 119 意向询价发送 120 意向询价接收 121 质押式赎回发送 122 质押式赎回接收 341 匿名点击质押式回购卖出 342 匿名点击质押式回购买入 350 点击成交转贴现卖出签收 351 点击成交转贴现买入签收 352 点击成交转贴现卖出申请 353 点击成交转贴现买入申请 411 票据存托 412 供应链贴现买断式 413 供应链贴现回购式 513 承兑保证
          ,BUSI_ATTR_NO         --业务属性号
          ,PRODUCT_NAME         --产品名称
          ,DRAFT_NUMBER         --票据（包）号
          ,DRAFT_AMOUNT         --票据（包）金额
          ,CUST_NO              --客户号
          ,TRADE_DIRECT         --交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
          ,TXN_DATE             --交易日期
          ,REQ_TYPE             --请求方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
          ,REQ_NAME             --请求方名称
          ,REQ_CERT_NO          --请求方社会信用代码
          ,REQ_ACCOUNT          --请求方账号
          ,REQ_MEM_NO           --请求方会员编码
          ,REQ_BRH_NO           --请求方机构编号
          ,REQ_BANK_NO          --请求方支付系统行号
          ,REQ_MISC             --请求方备注
          ,RCV_TYPE             --接收方类型： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构
          ,RCV_NAME             --接收方名称
          ,RCV_CERT_NO          --接收方社会信用代码
          ,RCV_ACCOUNT          --接收方账号
          ,RCV_MEM_NO           --接收方会员编码
          ,RCV_BRH_NO           --接收方机构编号
          ,RCV_BANK_NO          --接收方支付系统行号
          ,RCV_MISC             --接收方备注
          ,PAY_AMOUNT           --实付金额
          ,PAY_TYPE             --付息方式
          ,PAY_INTEREST         --实付利息
          ,PAYMENT_DATE         --计息到期日
          ,DRAWEE_NAME          --付息人名称
          ,DRAWEE_ACCOUNT       --付息人帐号
          ,DRAWEE_BANK_NAME     --付息人开户行
          ,REPURCHASE_RATE      --赎回利率
          ,CHARGE               --手续费
          ,EXPENSES             --工本费
          ,RPD_MK               --是否回购式
          ,AGENT_NAME           --代理人名称
          ,RATE                 --利率
          ,PAYER_SALE           --付息比例
          ,BUYER_INTEREST       --买方付息
          ,INTEREST             --总利息
          ,MOVE_TRS_TYPE        --库存变更类型： VT01 行内移库 VT02 行内移库拒收退票 VT03 保证增信拒收退票 VT05 退回瑕疵票据 VT06 退回线下追偿票据 VT07 退回公示催告票据
          ,CONF_PAY_TYPE        --付款确认类型： VM01 影像验证 VM02 实物验证
          ,CONF_PAY_ADD_TYPE    --付款确认增补类型： VN01 自动新建 VN02 手动新建 VN03 应答发起补录影像 VN04 应答发起实物验证
          ,CONF_PAY_RST         --付款确认结果： RR02 需补录影像 RR03 需实物验证 RR05 审批拒绝
          ,STOP_PAY_TYPE        --止付类型： ST01 挂失止付 ST02 公示催告 ST03 司法冻结
          ,STOP_PAY_RSN         --止付原因
          ,RELIEVE_STP_TYPE     --解除止付类型： RT01 挂失止付到期 RT02 除权判决 RT03 解除司法冻结 RT05 公示催告解除
          ,RELIEVE_STP_RSN      --解除止付原因
          ,TENOR_DAYS           --剩余期限
          ,SETTLE_AMT           --结算金额
          ,BUY_BACK_DATE        --回购到期日
          ,REAL_BACK_DATE       --实际回购日
          ,BUY_BACK_STATUS      --回购状态： 1 正常回购 2 未回购 3 提前回购 4 逾期回购
          ,EXCHGE_STATUS        --置换状态： ES01 被他票替换 ES02 替换他票
          ,PRMT_RESULT          --提示付款应答结果： SU00 同意 SU01 拒绝
          ,PRMT_REFUSE_RSN      --提示付款拒绝理由： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
          ,PRMT_STL_RST         --提示付款清算结果： R20 结算成功 R21 结算失败 R23 已撤销
          ,REFUSE_RSN           --付款拒绝理由（通用）： CP01 背书签章未依次前后衔接 CP02 背书记载不清晰 CP03 背书人签章缺少单位印章、法定代表人或其授权的代理人签章 CP04 背书粘单未加盖骑缝章、骑缝章不连续或骑缝章不清 CP05 背书不规范、文字有歧义 CP06 其他 CP07 自动拒付
          ,SIG_MK               --签收意见
          ,ACCT_DATE            --记账日期
          ,TRANS_NAME           --交易名称
          ,LAST_TRANS_ID        --上一笔交易TRANS_ID
          ,INNER_FLAG           --是否系统内： 0 否 1 是
          ,TRANS_STATUS         --交易状态： TS0000 无效 TS0001 有效 TS0002 完成
          ,SETTLE_TYPE          --结清类型： 1 未贴现票据托收结清 2 未贴现票据追索结清 3 其他
          ,TRANS_BRANCH_NO      --交易机构号
          ,ACCT_BRANCH_NO       --记账机构号
          ,STORE_BRH_NO         --库存机构号
          ,TOP_BRANCH_NO        --总行机构号
          ,LAST_UPD_OPR         --最后操作人
          ,LAST_UPD_TIME        --最后修改时间
          ,MISC                 --备注域
          ,CD_RANGE             --子票区间
          ,PRODUCT_TYPE         --票据分类： CS01 ECDS CS02 金融机构 CS03 供应链平台
          ,REQ_BUSS_TYPE        --请求方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
          ,RCV_BUSS_TYPE        --接收方业务主体类别:ZT01-银行、金融机构，ZT02-企业平台，ZT03-企业非平台
          ,REQ_DIST_TP          --请求方识别类型 DT01 票据账户 DT02 银行账户
          ,RCV_DIST_TP          --接收方识别类型 DT01 票据账户 DT02 银行账户
          ,CREATE_TIME          --创建时间
          ,CREATE_BY      
          ,START_DT             --开始时间
          ,END_DT               --结束时间
          ,ID_MARK              --增删标志
          ,ETL_TIMESTAMP        --ETL处理时间戳
    FROM IOL.V_BDMS_DPC_DRAFT_TRANS_INFO --视图-登记中心票据流转信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_BDMS_DPC_DRAFT_TRANS_INFO', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_BDMS_DPC_DRAFT_TRANS_INFO;
/

