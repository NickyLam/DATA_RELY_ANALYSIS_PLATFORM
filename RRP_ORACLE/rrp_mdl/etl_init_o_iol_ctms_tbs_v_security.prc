CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_CTMS_TBS_V_SECURITY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_CTMS_TBS_V_SECURITY
  *  功能描述：债券基本资料视图
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_CTMS_TBS_V_SECURITY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_CTMS_TBS_V_SECURITY'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --

  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_CTMS_TBS_V_SECURITY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-债券基本资料视图';
  V_STARTTIME := SYSDATE;
INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY NOLOGGING
    ( SECURITY_CODE,                    --债券代码
      SECURITY_NAME,                    --债券名称
      SECURITY_TYPE,                    --债券类别
      ISSUER,                           --发行人
      GUARANTEE,                        --担保人
      CCY,                              --本金币种
      INT_CCY,                          --利息币种
      ISSUE_DATE,                       --发行日
      START_COUPON_DATE,                --起息日
      MATURITY_DATE,                    --到期日
      LOT_SIZE,                         --债券发行最小单位
      DAY_COUNT,                        --计息基准
      RATE_TYPE,                        --利率方式
      FIXED_RATE,                       --票面利率
      FLOATING_RATE,                    --基准利率
      FLOATING_RATE_IND,                --浮动方向
      FLOATING_SPREAD,                  --基本利差
      FIXING_FREQ,                      --重置频率
      FFIXING_DATE,                     --首次利率重置日
      COUPON_FREQ,                      --计息频率
      FCOUPON_DATE,                     --首次付息日
      PAYMENT_FREQ,                     --付息频率
      COMPOUND_FREQ,                    --复利频率
      OPTION_TYPE,                      --选择权类别
      BACK_AMT,                         --每期还本金额
      NUMBER_ISSUED,                    --发行金额
      AUTION_RATE,                      --标售利率
      AUTION_PRICE,                     --发行价格
      FIRST_TRADE_DATE,                 --上市交易日
      MARKET_TYPE,                      --市场类别
      REPO_RATIO,                       --质押比
      SECURITY_SHORT_NAME,              --债券简称
      CONVERTABLE,                      --是否是可转换债券
      CONVERT_SECURITY_CODE,            --转换债券码
      DISCOUNT_RATE,                    --是否贴现债
      CAP,                              --浮动利率上限
      FLOOR,                            --浮动利率下限
      FIXING_RATE_METHOH,               --利率重置方法
      NOTE,                             --债券备注
      FLOATING_RATE_SCALE,              --利率小数位数
      STOP_TRADE_DATE,                  --停止流通日
      COLLATERAL_ID,                    --担保品
      FLOATER_FACTOR_OP,                --浮动利率重算因子运算子
      FLOATER_FACTOR,                   --浮动利率重算因子
      FIXING_RULES,                     --是否有利率重置公式
      ORG_TERM,                         --原始合约上的期限
      ORG_TERM_MULT,                    --原始合约上的期限单位
      ISJX,                             --是否计应收利息
      MODIFY_DATE,                      --修改日期
      COMPOUND,                         --是否复利
      SECURITY_TYPE_NEW,                --债券类别
      START_DT,                         --开始时间
      END_DT,                           --结束时间
      ID_MARK                           --增删标志
     )
  SELECT /*+PARALLEL*/
          SECURITY_CODE,                    --债券代码
          SECURITY_NAME,                    --债券名称
          SECURITY_TYPE,                    --债券类别
          ISSUER,                           --发行人
          GUARANTEE,                        --担保人
          CCY,                              --本金币种
          INT_CCY,                          --利息币种
          ISSUE_DATE,                       --发行日
          START_COUPON_DATE,                --起息日
          MATURITY_DATE,                    --到期日
          LOT_SIZE,                         --债券发行最小单位
          DAY_COUNT,                        --计息基准
          RATE_TYPE,                        --利率方式
          FIXED_RATE,                       --票面利率
          FLOATING_RATE,                    --基准利率
          FLOATING_RATE_IND,                --浮动方向
          FLOATING_SPREAD,                  --基本利差
          FIXING_FREQ,                      --重置频率
          FFIXING_DATE,                     --首次利率重置日
          COUPON_FREQ,                      --计息频率
          FCOUPON_DATE,                     --首次付息日
          PAYMENT_FREQ,                     --付息频率
          COMPOUND_FREQ,                    --复利频率
          OPTION_TYPE,                      --选择权类别
          BACK_AMT,                         --每期还本金额
          NUMBER_ISSUED,                    --发行金额
          AUTION_RATE,                      --标售利率
          AUTION_PRICE,                     --发行价格
          FIRST_TRADE_DATE,                 --上市交易日
          MARKET_TYPE,                      --市场类别
          REPO_RATIO,                       --质押比
          SECURITY_SHORT_NAME,              --债券简称
          CONVERTABLE,                      --是否是可转换债券
          CONVERT_SECURITY_CODE,            --转换债券码
          DISCOUNT_RATE,                    --是否贴现债
          CAP,                              --浮动利率上限
          FLOOR,                            --浮动利率下限
          FIXING_RATE_METHOH,               --利率重置方法
          NOTE,                             --债券备注
          FLOATING_RATE_SCALE,              --利率小数位数
          STOP_TRADE_DATE,                  --停止流通日
          COLLATERAL_ID,                    --担保品
          FLOATER_FACTOR_OP,                --浮动利率重算因子运算子
          FLOATER_FACTOR,                   --浮动利率重算因子
          FIXING_RULES,                     --是否有利率重置公式
          ORG_TERM,                         --原始合约上的期限
          ORG_TERM_MULT,                    --原始合约上的期限单位
          ISJX,                             --是否计应收利息
          MODIFY_DATE,                      --修改日期
          COMPOUND,                         --是否复利
          SECURITY_TYPE_NEW,                --债券类别
          START_DT,                         --开始时间
          END_DT,                           --结束时间
          ID_MARK                           --增删标志
    FROM IOL.V_CTMS_TBS_V_SECURITY   --债券基本资料视图_视图
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_CTMS_TBS_V_SECURITY;
/

