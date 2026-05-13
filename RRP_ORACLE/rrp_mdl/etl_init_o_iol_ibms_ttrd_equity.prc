CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TTRD_EQUITY(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_INIT_O_IOL_IBMS_TTRD_EQUITY
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TTRD_EQUITY'; -- 程序名称
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
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_EQUITY';

  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_EQUITY NOLOGGING
    (I_CODE	  --金融工具代码
    ,A_TYPE	  --资产类型：净值型项目SPT_NTP
    ,M_TYPE	  --市场类型
    ,L_CODE	  --本地代码
    ,I_NAME	  --金融工具名称
    ,CURRENCY	  --币种
    ,COUNTRY	  --国家
    ,Q_TYPE	  --发行类型：净值型
    ,P_TYPE	  --产品类型
    ,P_CLASS	  --产品分类
    ,LIST_DATE	  --上市时间
    ,OPEN_DATE	  --开发时间
    ,ISSUER	  --发行人
    ,RISK_RATING	  --风险等级
    ,TRUSTEE	  --托管人
    ,IMP_DATE	  --导入日期
    ,PIPE_ID	  --导入方式
    ,CHINESESPELL	  --拼音简称
    ,UPDATE_USER	  --
    ,UPDATE_TIME	  --
    ,ACCOUNT_USER	  --
    ,ACCOUNT_TIME	  --
    ,ISSUER_ID	  --发行机构ID
    ,TRUSTEE_ID	  --托管机构ID
    ,USABLE_FLAG	  --是否已生效：1： 正常 0： 新增
    ,PRODUCT_RATE	  --产品评级
    ,RATE_INSTITUTION	  --评级机构
    ,OPEN_TYPE	  --每日开放：0,每周开放：1
    ,START_OPEN_DATE	  --开放周期开始日
    ,END_OPEN_DATE	  --开放周期结束日
    ,GUARANTEE_WAY	  --担保方式
    ,GUARANTEE_INFOR	  --担保物情况
    ,CTRCT_ID	  --合同编号
    ,PLATFORM	  --平台
    ,INVEST_DIRECTION	  --投向
    ,FINAL_INVEST	  --最终投向类型
    ,FIVE_CLASS	  --五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,CONTRACT_VERSION	  --合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,EXTORDID	  --外部交易号
    ,MITIGATION_FREQ	  --缓释频率
    ,MANAGER_ID	  --实际管理人ID
    ,MANAGER_VALUE	  --实际管理人
    ,RISK_PROPORTION	  --风险权重占比
    ,MIDDLE_CLASSIFY	  --业务中类
    ,SMALL_CLASSIFY	  --业务小类
    ,CLOSING_START_DATE	  --封闭开始日(对应开放类型为封闭型)
    ,CLOSING_END_DATE	  --封闭结束日(对应开放类型为封闭型)
    ,START_DT	  --开始时间
    ,END_DT	  --结束时间
    ,ID_MARK	  --增删标志

     )
  SELECT /*+PARALLEL*/
      I_CODE	  --金融工具代码
      ,A_TYPE	  --资产类型：净值型项目SPT_NTP
      ,M_TYPE	  --市场类型
      ,L_CODE	  --本地代码
      ,I_NAME	  --金融工具名称
      ,CURRENCY	  --币种
      ,COUNTRY	  --国家
      ,Q_TYPE	  --发行类型：净值型
      ,P_TYPE	  --产品类型
      ,P_CLASS	  --产品分类
      ,LIST_DATE	  --上市时间
      ,OPEN_DATE	  --开发时间
      ,ISSUER	  --发行人
      ,RISK_RATING	  --风险等级
      ,TRUSTEE	  --托管人
      ,IMP_DATE	  --导入日期
      ,PIPE_ID	  --导入方式
      ,CHINESESPELL	  --拼音简称
      ,UPDATE_USER	  --
      ,UPDATE_TIME	  --
      ,ACCOUNT_USER	  --
      ,ACCOUNT_TIME	  --
      ,ISSUER_ID	  --发行机构ID
      ,TRUSTEE_ID	  --托管机构ID
      ,USABLE_FLAG	  --是否已生效：1： 正常 0： 新增
      ,PRODUCT_RATE	  --产品评级
      ,RATE_INSTITUTION	  --评级机构
      ,OPEN_TYPE	  --每日开放：0,每周开放：1
      ,START_OPEN_DATE	  --开放周期开始日
      ,END_OPEN_DATE	  --开放周期结束日
      ,GUARANTEE_WAY	  --担保方式
      ,GUARANTEE_INFOR	  --担保物情况
      ,CTRCT_ID	  --合同编号
      ,PLATFORM	  --平台
      ,INVEST_DIRECTION	  --投向
      ,FINAL_INVEST	  --最终投向类型
      ,FIVE_CLASS	  --五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
      ,CONTRACT_VERSION	  --合同版本号（已审合同:0,送审合同:1,标准合同:2）
      ,EXTORDID	  --外部交易号
      ,MITIGATION_FREQ	  --缓释频率
      ,MANAGER_ID	  --实际管理人ID
      ,MANAGER_VALUE	  --实际管理人
      ,RISK_PROPORTION	  --风险权重占比
      ,MIDDLE_CLASSIFY	  --业务中类
      ,SMALL_CLASSIFY	  --业务小类
      ,CLOSING_START_DATE	  --封闭开始日(对应开放类型为封闭型)
      ,CLOSING_END_DATE	  --封闭结束日(对应开放类型为封闭型)
      ,START_DT	  --开始时间
      ,END_DT	  --结束时间
      ,ID_MARK	  --增删标志

    FROM IOL.V_IBMS_TTRD_EQUITY   --净值型产品信息表_视图
   ;

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


END ETL_INIT_O_IOL_IBMS_TTRD_EQUITY;
/

