CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --

  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
   INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF NOLOGGING
  (  AS_ID                   --序号
    ,ACTING_ENTRY_NAME_1     --一级科目名称
    ,ACTING_ENTRY_NAME_2     --二级科目名称
    ,ACTING_ENTRY_NAME_3     --三级科目名称
    ,ACTING_CODE             --核算码
    ,PROPERTY                --科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
    ,ENTRY_DIRECTION         --科目方向 1：借 2：贷 0：未知
    ,ACTING_ENTRY_CODE_1     --一级科目
    ,ACTING_ENTRY_CODE_2     --二级科目
    ,ACTING_ENTRY_CODE_3     --三级科目
    ,ENTRY_TYPE_3            --"0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税,131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税，231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目"
    ,ENTRY_TYPE              --分录类型
    ,ENTRY_TYPE_1            --00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
    ,ENTRY_TYPE_2            --1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
    ,ENTRY_TYPE_4            --00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
    ,ENTRY_TYPE_5            --会计账户类别默认0, 1:交易类(FVTPL), 2:持有到期类(AMC)
    ,GZB_TYPE                --"0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差，5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他"
    ,ACTING_ENTRY_NAME_4     --四级科目名称
    ,ACTING_ENTRY_NAME_5     --五级科目名称
    ,ACTING_ENTRY_CODE_4     --四级科目
    ,ACTING_ENTRY_CODE_5     --五级科目
    ,ENTRY_TYPE_6            --
    ,ENTRY_TYPE_7            --0  默认值 ；  1_S 期限品种 空头；1_L 期限品种 多头；2 子产品
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    )
  SELECT /*+PARALLEL*/
     AS_ID                   --序号
    ,ACTING_ENTRY_NAME_1     --一级科目名称
    ,ACTING_ENTRY_NAME_2     --二级科目名称
    ,ACTING_ENTRY_NAME_3     --三级科目名称
    ,ACTING_CODE             --核算码
    ,PROPERTY                --科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
    ,ENTRY_DIRECTION         --科目方向 1：借 2：贷 0：未知
    ,ACTING_ENTRY_CODE_1     --一级科目
    ,ACTING_ENTRY_CODE_2     --二级科目
    ,ACTING_ENTRY_CODE_3     --三级科目
    ,ENTRY_TYPE_3            --"0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税,131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税，231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目"
    ,ENTRY_TYPE              --分录类型
    ,ENTRY_TYPE_1            --00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
    ,ENTRY_TYPE_2            --1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
    ,ENTRY_TYPE_4            --00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
    ,ENTRY_TYPE_5            --会计账户类别默认0, 1:交易类(FVTPL), 2:持有到期类(AMC)
    ,GZB_TYPE                --"0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差，5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，X其他"
    ,ACTING_ENTRY_NAME_4     --四级科目名称
    ,ACTING_ENTRY_NAME_5     --五级科目名称
    ,ACTING_ENTRY_CODE_4     --四级科目
    ,ACTING_ENTRY_CODE_5     --五级科目
    ,ENTRY_TYPE_6            --
    ,ENTRY_TYPE_7            --0  默认值 ；  1_S 期限品种 空头；1_L 期限品种 多头；2 子产品
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    FROM IOL.V_IBMS_TTRD_ACCOUNTING_ENTRY_DEF   --待定_视图
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

  END ETL_O_IOL_IBMS_TTRD_ACCOUNTING_ENTRY_DEF;
/

