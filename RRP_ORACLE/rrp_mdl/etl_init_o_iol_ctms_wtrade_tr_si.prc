CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_CTMS_WTRADE_TR_SI(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_INIT_O_IOL_CTMS_WTRADE_TR_SI
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_CTMS_WTRADE_TR_SI'; -- 程序名称
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
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_WTRADE_TR_SI NOLOGGING
    (ASPCLIENT_ID	  --
    ,SERIAL_NUMBER	  --
    ,BS	  --
    ,CASH_ACC_ENAME	  --
    ,CASH_ACC_CNAME	  --
    ,CASH_ACC_BANK	  --
    ,CASH_ACC_NO	  --
    ,CASH_ACC_BANK_EX	  --
    ,BOND_ACC_NAME	  --
    ,BOND_ACC_BANK	  --
    ,BOND_ACC_NO	  --
    ,G_CASH_AMT	  --
    ,G_BOND_ID	  --
    ,G_BOND_NAME	  --
    ,G_BOND_AMT	  --
    ,G_BOND_TOTAL_AMT	  --
    ,G_CA_NAME	  --
    ,G_CA_BANK	  --
    ,G_CA_NO	  --
    ,G_CA_BANK_EX	  --
    ,G_BA_NAME	  --
    ,G_BA_BANK	  --
    ,G_BA_NO	  --
    ,G_STL_DATE	  --
    ,G_MGR_BANK	  --
    ,LASTMODIFIED	  --
    ,DATASYMBOL_ID	  --
    ,START_DT	  --开始时间
    ,END_DT	  --结束时间
    ,ID_MARK	  --增删标志
    )
  SELECT /*+PARALLEL*/
    ASPCLIENT_ID	  --
    ,SERIAL_NUMBER	  --
    ,BS	  --
    ,CASH_ACC_ENAME	  --
    ,CASH_ACC_CNAME	  --
    ,CASH_ACC_BANK	  --
    ,CASH_ACC_NO	  --
    ,CASH_ACC_BANK_EX	  --
    ,BOND_ACC_NAME	  --
    ,BOND_ACC_BANK	  --
    ,BOND_ACC_NO	  --
    ,G_CASH_AMT	  --
    ,G_BOND_ID	  --
    ,G_BOND_NAME	  --
    ,G_BOND_AMT	  --
    ,G_BOND_TOTAL_AMT	  --
    ,G_CA_NAME	  --
    ,G_CA_BANK	  --
    ,G_CA_NO	  --
    ,G_CA_BANK_EX	  --
    ,G_BA_NAME	  --
    ,G_BA_BANK	  --
    ,G_BA_NO	  --
    ,G_STL_DATE	  --
    ,G_MGR_BANK	  --
    ,LASTMODIFIED	  --
    ,DATASYMBOL_ID	  --
    ,START_DT	  --开始时间
    ,END_DT	  --结束时间
    ,ID_MARK	  --增删标志
    FROM IOL.V_CTMS_WTRADE_TR_SI   --清算账户信息表_视图

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


END ETL_INIT_O_IOL_CTMS_WTRADE_TR_SI;
/

