CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_CES_QUOTE_DEAL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_CES_QUOTE_DEAL
  *  功能描述：对话报价成交单表
  *  创建日期：20251205
  *  开发人员：于敬艺
  *  来源表： IOL.V_BDMS_CES_QUOTE_DEAL
  *  目标表： O_IOL_BDMS_CES_QUOTE_DEAL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251205  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_CES_QUOTE_DEAL'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_CES_QUOTE_DEAL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对话报价成交单表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_CES_QUOTE_DEAL NOLOGGING
    (       ID                  --ID
           ,BUSS_CONTRACT_ID    --业务表批次ID
           ,DEALED_NO           --成交单编号
           ,TRADE_DIRECT        --交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
           ,BUSI_TYPE           --业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
           ,DRAFT_TYPE          --票据类型： AC01 银承 AC02 商承
           ,DRAFT_ATTR          --票据介质： ME01 纸票 ME02 电票
           ,TRADE_TYPE          --成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
           ,TRADE_DATE          --成交日期
           ,TRADE_TIME          --成交时间
           ,TRADE_STATUS        --成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
           ,SETTLE_STATUS       --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
           ,QUOTE_NO            --报价单编号
           ,BRH_NO              --机构代码
           ,PRODUCT_NO          --非法人产品
           ,TRADER_ID           --交易员ID
           ,FUNDATION_ACCT      --资金账户
           ,ADVER_BRH_NO        --对手机构代码
           ,ADVER_PRO_NO        --对手非法人产品
           ,ADVER_TRADER_ID     --对手交易员ID
           ,ADVER_FUND_ACCT     --对手资金账户
           ,QUOTE_STATUS        --报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
           ,TRACE_REASON        --中止原因
           ,LOCK_FLAG           --锁定标识： 0 否 1 是
           ,MISC                --备注
           ,RESERVER1           --预留域1
           ,RESERVER2           --预留域2
           ,LAST_UPD_OPR        --最后操作员
           ,LAST_UPD_TIME       --最后修改时间
           ,DUE_SETTLE_STATUS   --到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
           ,NESTING_LOCK_FLAG   --嵌套锁标识： 0 否 1 是
           ,ANOCLICK_DEAL_NO    --匿名点击成交单编号
           ,CLICK_TYPE          --点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
           ,OWN_MEM_NO          --所属会员代码
           ,BUSI_BRANCH_NO      --业务机构号
           ,TOP_BRANCH_NO       --总行机构号
           ,DEAL_TENOR_DAYS     --持票期限
           ,DEAL_SETTLE_AMT     --结算金额
           ,DEAL_SUM_COUNT      --票据张数
           ,DEAL_SUM_AMOUNT     --票据总额
           ,DEAL_PAY_INTEREST   --应付利息
           ,DEAL_YIELD_RATE     --收益率
           ,CREATE_TIME         --创建时间
           ,CREATE_BY           --创建人
           ,START_DT            --开始时间
           ,END_DT              --结束时间
           ,ID_MARK             --增删标志
           ,ETL_TIMESTAMP       --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
            ID                  --ID
           ,BUSS_CONTRACT_ID    --业务表批次ID
           ,DEALED_NO           --成交单编号
           ,TRADE_DIRECT        --交易方向： TDD01 转贴现买入 TDD02 转贴现卖出 CRD01 逆回购买入 CRD02 正回购卖出
           ,BUSI_TYPE           --业务类型： BT01 转贴现 BT02 质押式回购 BT03 买断式回购 BT06 央行卖票
           ,DRAFT_TYPE          --票据类型： AC01 银承 AC02 商承
           ,DRAFT_ATTR          --票据介质： ME01 纸票 ME02 电票
           ,TRADE_TYPE          --成交方式: TT01 询价成交 TT02 匿名点击 TT03 点击成交 TT04 应急成交
           ,TRADE_DATE          --成交日期
           ,TRADE_TIME          --成交时间
           ,TRADE_STATUS        --成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时 DS06 提票待确认 DS07 提票确认失败 DS08 提票确认成功
           ,SETTLE_STATUS       --清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
           ,QUOTE_NO            --报价单编号
           ,BRH_NO              --机构代码
           ,PRODUCT_NO          --非法人产品
           ,TRADER_ID           --交易员ID
           ,FUNDATION_ACCT      --资金账户
           ,ADVER_BRH_NO        --对手机构代码
           ,ADVER_PRO_NO        --对手非法人产品
           ,ADVER_TRADER_ID     --对手交易员ID
           ,ADVER_FUND_ACCT     --对手资金账户
           ,QUOTE_STATUS        --报价单状态： 【对话报价或匿名点击】 QS02 已发送 QS03 已接收 QS05 已终止 QS06 已成交 QS07 异常 QS08 发送待确认 QS09 待接收 QS10 成交待确认 QS11 退回机构 QS12 自动终止 【点击成交】 OS00 已保存 OS01 发送待确认 OS02 已作废 OS03 已发送 OS04 已成交 OS05 部分已成交 OS06 已接收 OS07 异常 OS08 撤销成功 OS09 撤销失败 OS10 应答确认成功(或收到通知) OS11 应答确认失败 OS12 应答中 OS13 已记账
           ,TRACE_REASON        --中止原因
           ,LOCK_FLAG           --锁定标识： 0 否 1 是
           ,MISC                --备注
           ,RESERVER1           --预留域1
           ,RESERVER2           --预留域2
           ,LAST_UPD_OPR        --最后操作员
           ,LAST_UPD_TIME       --最后修改时间
           ,DUE_SETTLE_STATUS   --到期清算状态： MS00 待结算确认 MS01 待处理 MS02 清算处理中 MS03 资金排队中 MS04 结算成功 MS05 结算失败 MS06 已撤销
           ,NESTING_LOCK_FLAG   --嵌套锁标识： 0 否 1 是
           ,ANOCLICK_DEAL_NO    --匿名点击成交单编号
           ,CLICK_TYPE          --点击成交类型： 01 买入申请 02 买入签收 03 卖出申请 04 卖出签收
           ,OWN_MEM_NO          --所属会员代码
           ,BUSI_BRANCH_NO      --业务机构号
           ,TOP_BRANCH_NO       --总行机构号
           ,DEAL_TENOR_DAYS     --持票期限
           ,DEAL_SETTLE_AMT     --结算金额
           ,DEAL_SUM_COUNT      --票据张数
           ,DEAL_SUM_AMOUNT     --票据总额
           ,DEAL_PAY_INTEREST   --应付利息
           ,DEAL_YIELD_RATE     --收益率
           ,CREATE_TIME         --创建时间
           ,CREATE_BY           --创建人
           ,START_DT            --开始时间
           ,END_DT              --结束时间
           ,ID_MARK             --增删标志
           ,ETL_TIMESTAMP       --ETL处理时间戳
    FROM IOL.V_BDMS_CES_QUOTE_DEAL   --对话报价成交单表
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

  END ETL_O_IOL_BDMS_CES_QUOTE_DEAL;
/

