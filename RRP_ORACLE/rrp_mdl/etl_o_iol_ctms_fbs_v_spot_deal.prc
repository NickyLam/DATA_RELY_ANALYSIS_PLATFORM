CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_FBS_V_SPOT_DEAL(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_FBS_V_SPOT_DEAL
  *  功能描述：即期视图
  *  创建日期：20220317
  *  开发人员：易梓林
  *  来源表： IOL.V_CTMS_FBS_V_SPOT_DEAL
  *  目标表： O_IOL_CTMS_FBS_V_SPOT_DEAL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220317  易梓林   首次创建
  *             2    20250610  YJY      剔除删除数据
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CTMS_FBS_V_SPOT_DEAL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_FBS_V_SPOT_DEAL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_FBS_V_SPOT_DEAL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-即期视图';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_FBS_V_SPOT_DEAL NOLOGGING
    (CUS_NUMBER           --机构的唯一标识号
    ,BRANCH_NUMBER        --分支机构的唯一标识号
    ,DEAL_SQNO            --投组交易流水号，交易的FMS内部唯一编号
    ,DEAL_DATE            --交易日期和时间
    ,VALUE_DATE           --起息日
    ,CRNCY_PAIR_ID        --货币对的SRNO
    ,SPOT_RATE            --成交汇率
    ,CHILD_RATE           --分行汇率
    ,COST_RATE            --成本汇率
    ,FIRST_AMNT           --货币1交易金额
    ,SECOND_AMNT          --货币2交易金额
    ,TRADE_PURPOSE        --交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,BUSINESS_DATE        --系统交易日，交易录入时的系统日期和时间
    ,COUNTER_PARTY_ID     --交易对手编码
    ,COUNTER_PARTY_SCNAME --交易对手中文简称
    ,SPLIT_TYPE           --交易拆分的类型
    ,UPDATE_TIME          --记录修改日期
    ,DEAL_DIR             --交易方向 1买 -1 卖
    ,PDD_DEAL_SQNO        --原始交易流水号，交易的FMS内部唯一编号
    ,DEAL_STATUS          --成交单状态
    ,FIRST_CRNCY          --第一货币
    ,SECOND_CRNCY         --第二货币
    ,CLIENT_DEAL_SQNO     --业务成交编号，来源如下
    ,TRADE_TYPE           --交易模式
    ,DEAL_SOURCE          --交易来源
    ,DEAL_MARKET          --交易场所
    ,SETTLE_TYPE          --清算方式
    ,DEAL_LINK_SQNO       --交易修改删除的序列关系
    ,MODIFY_DATE          --更新日期
    ,PORTFOLIO_SQNO       --投组交易编号
    ,PORTFOLIO_ID         --投资组合ID
    ,PORTFOLIO_NAME       --投资组合名称
    ,PORTFOLIO_TYPE       --投组类型： 交易 对冲  自营买卖 市场平盘
    ,PORTFOLIO_STATUS     --投资组合状态：
    ,PORTFOLIO_LINK_SQNO  --投组交易链接编号
    ,CLEAR_DEP            --清算机构 ZZ：其它； AA：上清所
    ,EVENT_TYPE           --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,EVENT_DATE           --事件日期
    ,EVENT_LINK_SQNO      --事件(违约，展期，提前交割)关联交易编号
    ,EVENT_MASK           --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,LINK_DEAL_SQNO       --期权的投组交易编号（SQNO）
    ,CONFIRM_INDC         --交易后确认标识
    ,START_DT             --开始时间
    ,END_DT               --结束时间
    ,ID_MARK              --增删标志
    ,DEALER
    )
  SELECT /*+PARALLEL*/
     CUS_NUMBER           --机构的唯一标识号
    ,BRANCH_NUMBER        --分支机构的唯一标识号
    ,DEAL_SQNO            --投组交易流水号，交易的FMS内部唯一编号
    ,DEAL_DATE            --交易日期和时间
    ,VALUE_DATE           --起息日
    ,CRNCY_PAIR_ID        --货币对的SRNO
    ,SPOT_RATE            --成交汇率
    ,CHILD_RATE           --分行汇率
    ,COST_RATE            --成本汇率
    ,FIRST_AMNT           --货币1交易金额
    ,SECOND_AMNT          --货币2交易金额
    ,TRADE_PURPOSE        --交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
    ,BUSINESS_DATE        --系统交易日，交易录入时的系统日期和时间
    ,COUNTER_PARTY_ID     --交易对手编码
    ,COUNTER_PARTY_SCNAME --交易对手中文简称
    ,SPLIT_TYPE           --交易拆分的类型
    ,UPDATE_TIME          --记录修改日期
    ,DEAL_DIR             --交易方向 1买 -1 卖
    ,PDD_DEAL_SQNO        --原始交易流水号，交易的FMS内部唯一编号
    ,DEAL_STATUS          --成交单状态
    ,FIRST_CRNCY          --第一货币
    ,SECOND_CRNCY         --第二货币
    ,CLIENT_DEAL_SQNO     --业务成交编号，来源如下
    ,TRADE_TYPE           --交易模式
    ,DEAL_SOURCE          --交易来源
    ,DEAL_MARKET          --交易场所
    ,SETTLE_TYPE          --清算方式
    ,DEAL_LINK_SQNO       --交易修改删除的序列关系
    ,MODIFY_DATE          --更新日期
    ,PORTFOLIO_SQNO       --投组交易编号
    ,PORTFOLIO_ID         --投资组合ID
    ,PORTFOLIO_NAME       --投资组合名称
    ,PORTFOLIO_TYPE       --投组类型： 交易 对冲  自营买卖 市场平盘
    ,PORTFOLIO_STATUS     --投资组合状态：
    ,PORTFOLIO_LINK_SQNO  --投组交易链接编号
    ,CLEAR_DEP            --清算机构 ZZ：其它； AA：上清所
    ,EVENT_TYPE           --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,EVENT_DATE           --事件日期
    ,EVENT_LINK_SQNO      --事件(违约，展期，提前交割)关联交易编号
    ,EVENT_MASK           --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
    ,LINK_DEAL_SQNO       --期权的投组交易编号（SQNO）
    ,CONFIRM_INDC         --交易后确认标识
    ,START_DT             --开始时间
    ,END_DT               --结束时间
    ,ID_MARK              --增删标志
    ,DEALER
  FROM IOL.V_CTMS_FBS_V_SPOT_DEAL   --即期视图_视图
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D' --MOD BY YJY 20250610
   ;

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

END ETL_O_IOL_CTMS_FBS_V_SPOT_DEAL;
/

