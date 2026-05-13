CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TFND(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_INIT_O_IOL_IBMS_TFND
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TFND'; -- 程序名称
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
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TFND';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TFND NOLOGGING
    (I_CODE   --金融工具代码
    ,A_TYPE   --资产类型
    ,M_TYPE   --市场类型
    ,L_CODE   --交易所本地代码
    ,CURRENCY   --币种
    ,COUNTRY   --国家
    ,Q_TYPE   --报价方式
    ,F_NAME   --基金名称
    ,P_CLASS   --产品分类
    ,F_DATE   --上市日期
    ,F_OPENDATE   --开放日期
    ,F_MANAGER   --管理者
    ,F_TRUSTEE   --托管方
    ,IMP_DATE   --导入日期
    ,PIPE_ID   --导入管道
    ,P_TYPE   --产品类型
    ,CHINESESPELL   --拼音
    ,STATE   --产品状态
    ,USER_ID   --操作人ID
    ,USER_NAME   --操作人
    ,UPDATE_TIME   --操作时间
    ,F_MANAGER_CODE   --管理者代码
    ,F_TRUSTEE_CODE   --托管方代码
    ,ISSUER_ID   --管理人ID
    ,F_INVEST_TYPE   --投资类型
    ,F_SETUPDATE   --成立日期
    ,F_MANAGER_NAME   --基金经理
    ,I_ID   --机构ID
    ,IS_IDX   --是否指数型基金(0:否 1:是)
    ,HUGE_REDEMPTION_RATIO   --巨额赎回认定比例
    ,COMPOUNDING_METHOD   --结转复利方式，0：单利；2：连续复利；仅对货币基金有效
    ,S_TYPE   --标准类型
    ,F_MTRDATE   --到期日期
    ,CARRY_FORWORD_TYPE   --结转方式：1：按日结转，2：按月结转，3：按季结转
    ,INV_ORDER_ID   --投金审批单号
    ,PAR_VALUE   --基金面值
    ,PAY_FREQ   --结转频率，仅对货币基金有效
    ,F_GRADE_TYPE   --分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
    ,F_FULLNAME   --资产全称
    ,SALES_CHANNEL   --销售通道0-直销,1-代销
    ,OPEN_TYPE   --每日开放：0,每周开放：1
    ,START_OPEN_DATE   --开放周期开始日
    ,END_OPEN_DATE   --开放周期结束日
    ,MANAGEMENT_MODEL   --管理模式
    ,MITIGATION_FREQ   --缓释频率
    ,MANAGER_VALUE   --
    ,MAIN_CODE   --基金主代码(分级基金相同)
    ,F_NAME_FULL   --
    ,PAY_MONTH   --
    ,PAY_DAY   --
    ,RUN_TERM	  --
    ,P_I_CODE	  --
    ,P_A_TYPE	  --
    ,P_M_TYPE	  --
    ,MANAGER_ID	  --
    ,REDEMPTION_DATE	  --
    ,IS_PUB_OFFER	  --
    ,START_DT	  --开始时间
    ,END_DT	  --结束时间
    ,ID_MARK	  --增删标志

    )
  SELECT /*+PARALLEL*/
      I_CODE	  --金融工具代码
      ,A_TYPE	  --资产类型
      ,M_TYPE	  --市场类型
      ,L_CODE	  --交易所本地代码
      ,CURRENCY	  --币种
      ,COUNTRY	  --国家
      ,Q_TYPE	  --报价方式
      ,F_NAME	  --基金名称
      ,P_CLASS	  --产品分类
      ,F_DATE	  --上市日期
      ,F_OPENDATE	  --开放日期
      ,F_MANAGER	  --管理者
      ,F_TRUSTEE	  --托管方
      ,IMP_DATE	  --导入日期
      ,PIPE_ID	  --导入管道
      ,P_TYPE	  --产品类型
      ,CHINESESPELL	  --拼音
      ,STATE	  --产品状态
      ,USER_ID	  --操作人ID
      ,USER_NAME	  --操作人
      ,UPDATE_TIME	  --操作时间
      ,F_MANAGER_CODE	  --管理者代码
      ,F_TRUSTEE_CODE	  --托管方代码
      ,ISSUER_ID	  --管理人ID
      ,F_INVEST_TYPE	  --投资类型
      ,F_SETUPDATE	  --成立日期
      ,F_MANAGER_NAME	  --基金经理
      ,I_ID	  --机构ID
      ,IS_IDX	  --是否指数型基金(0:否 1:是)
      ,HUGE_REDEMPTION_RATIO	  --巨额赎回认定比例
      ,COMPOUNDING_METHOD	  --结转复利方式，0：单利；2：连续复利；仅对货币基金有效
      ,S_TYPE	  --标准类型
      ,F_MTRDATE	  --到期日期
      ,CARRY_FORWORD_TYPE	  --结转方式：1：按日结转，2：按月结转，3：按季结转
      ,INV_ORDER_ID	  --投金审批单号
      ,PAR_VALUE	  --基金面值
      ,PAY_FREQ	  --结转频率，仅对货币基金有效
      ,F_GRADE_TYPE	  --分级基金类型，0：非分级基金；1：分级母基金；2：分级子基金A类；3：分级子基金B类；
      ,F_FULLNAME	  --资产全称
      ,SALES_CHANNEL	  --销售通道0-直销,1-代销
      ,OPEN_TYPE	  --每日开放：0,每周开放：1
      ,START_OPEN_DATE	  --开放周期开始日
      ,END_OPEN_DATE	  --开放周期结束日
      ,MANAGEMENT_MODEL	  --管理模式
      ,MITIGATION_FREQ	  --缓释频率
      ,MANAGER_VALUE	  --
      ,MAIN_CODE	  --基金主代码(分级基金相同)
      ,F_NAME_FULL	  --
      ,PAY_MONTH	  --
      ,PAY_DAY	  --
      ,RUN_TERM	  --
      ,P_I_CODE	  --
      ,P_A_TYPE	  --
      ,P_M_TYPE	  --
      ,MANAGER_ID	  --
      ,REDEMPTION_DATE	  --
      ,IS_PUB_OFFER	  --
      ,START_DT	  --开始时间
      ,END_DT	  --结束时间
      ,ID_MARK	  --增删标志
    FROM IOL.V_IBMS_TFND   --基金表_视图
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


END ETL_INIT_O_IOL_IBMS_TFND;
/

