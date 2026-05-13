CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_CTMS_TBS_V_BONDSDEALS(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_INIT_O_IOL_CTMS_TBS_V_BONDSDEALS
  **存储过程创建日期：20220707
  **存储过程创建人：  赖海强
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_CTMS_TBS_V_BONDSDEALS'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

   SELECT CASE WHEN V_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN V_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN V_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN V_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN V_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN V_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;

  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS';

  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_TBS_V_BONDSDEALS NOLOGGING
    (DEAL_ID   --引用表ID
    ,DEAL_TABLENAME   --引用表名
    ,ASPCLIENT_ID   --部门编号
    ,BONDSCODE   --债券代码
    ,BONDSNAME   --债券名称
    ,BONDSTYPE   --债券类型
    ,SERIAL_NUMBER   --交易号
    ,TRADEDATE   --交易日
    ,SETTLEDATE   --交割日
    ,BUYORSELL   --买卖方向
    ,CLEANPRICE   --交易净价
    ,DIRTYPRICE   --交易全价
    ,YIELDTOMATURITY   --到期收益率
    ,SETTLEAMOUNT   --结算金额
    ,PORTFOLIO_ID   --交易组别
    ,PORTFOLIO_NAME   --交易组别名称
    ,KEEPFOLDER_ID   --账户ID
    ,KEEPFOLDER_SHORTNAME   --账户名称
    ,FOLDERATTS   --账户属性
    ,CLASSFYNAME	  --四分类名称
    ,CPTYS_SHORTNAME	  --交易对手名称
    ,CPTYS_ID	  --交易对手ID
    ,SETTLETYPE	  --结算方式
    ,DEALER_ID	  --交易员
    ,DEALER_NAME	  --交易员名称
    ,REF_NUMBER	  --成交编号
    ,FEEAMOUNT	  --手续费
    ,TAXAMOUNT	  --税金
    ,BROKERAMOUNT	  --佣金
    ,NOTE	  --备注
    ,NOMINAL	  --券面总额
    ,ACCRUEDAMOUNT	  --应计利息总额
    ,CFETS_FROM	  --是否是CFETS交易
    ,SOURCE	  --交易来源
    ,LASTMODIFIED	  --最后修改时间
    ,DATASYMBOL_ID	  --数据源ID
    ,ASSETTYPE_ID	  --资产类型ID
    ,BONDSDEALS_ID_GRAND	  --原始交易ID
    ,STOCK_ID	  --股票代码
    ,CONVERT_PRICE	  --转股价格
    ,STOCK_PRICE	  --正股价格
    ,CONVERT_QUANTITY	  --转股数量
    ,DN_DEALER	  --本币交易员
    ,START_DT	  --开始时间
    ,END_DT	  --结束时间
    ,ID_MARK	  --增删标志
    )
  SELECT /*+PARALLEL*/
      DEAL_ID	  --引用表ID
      ,DEAL_TABLENAME	  --引用表名
      ,ASPCLIENT_ID	  --部门编号
      ,BONDSCODE	  --债券代码
      ,BONDSNAME	  --债券名称
      ,BONDSTYPE	  --债券类型
      ,SERIAL_NUMBER	  --交易号
      ,TRADEDATE	  --交易日
      ,SETTLEDATE	  --交割日
      ,BUYORSELL	  --买卖方向
      ,CLEANPRICE	  --交易净价
      ,DIRTYPRICE	  --交易全价
      ,YIELDTOMATURITY	  --到期收益率
      ,SETTLEAMOUNT	  --结算金额
      ,PORTFOLIO_ID	  --交易组别
      ,PORTFOLIO_NAME	  --交易组别名称
      ,KEEPFOLDER_ID	  --账户ID
      ,KEEPFOLDER_SHORTNAME	  --账户名称
      ,FOLDERATTS	  --账户属性
      ,CLASSFYNAME	  --四分类名称
      ,CPTYS_SHORTNAME	  --交易对手名称
      ,CPTYS_ID	  --交易对手ID
      ,SETTLETYPE	  --结算方式
      ,DEALER_ID	  --交易员
      ,DEALER_NAME	  --交易员名称
      ,REF_NUMBER	  --成交编号
      ,FEEAMOUNT	  --手续费
      ,TAXAMOUNT	  --税金
      ,BROKERAMOUNT	  --佣金
      ,NOTE	  --备注
      ,NOMINAL	  --券面总额
      ,ACCRUEDAMOUNT	  --应计利息总额
      ,CFETS_FROM	  --是否是CFETS交易
      ,SOURCE	  --交易来源
      ,LASTMODIFIED	  --最后修改时间
      ,DATASYMBOL_ID	  --数据源ID
      ,ASSETTYPE_ID	  --资产类型ID
      ,BONDSDEALS_ID_GRAND	  --原始交易ID
      ,STOCK_ID	  --股票代码
      ,CONVERT_PRICE	  --转股价格
      ,STOCK_PRICE	  --正股价格
      ,CONVERT_QUANTITY	  --转股数量
      ,DN_DEALER	  --本币交易员
      ,START_DT	  --开始时间
      ,END_DT	  --结束时间
      ,ID_MARK	  --增删标志
    FROM IOL.V_CTMS_TBS_V_BONDSDEALS   --现券交易_视图

   ;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


END ETL_INIT_O_IOL_CTMS_TBS_V_BONDSDEALS;
/

