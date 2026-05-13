CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TFND_NAV(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 基金收益行情
  **存储过程名称：    ETL_O_IOL_IBMS_TFND_NAV
  **存储过程创建日期：20220707
  **存储过程创建人：  赖海强
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20241227    YJY        优化脚本
  *******************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TFND_NAV'; -- 程序名称
  V_DATE   DATE := TO_DATE(I_P_DATE,'YYYY-MM-DD');
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
   SELECT CASE WHEN V_P_DATE = '20191231' THEN TO_DATE('20191231', 'YYYYMMDD')
              WHEN V_P_DATE = '20200630' THEN TO_DATE('20200101', 'YYYYMMDD')
              WHEN V_P_DATE = '20201231' THEN TO_DATE('20200701', 'YYYYMMDD')
              WHEN V_P_DATE = '20210630' THEN TO_DATE('20210101', 'YYYYMMDD')
              WHEN V_P_DATE = '20211231' THEN TO_DATE('20210701', 'YYYYMMDD')
              WHEN V_P_DATE = '20220430' THEN TO_DATE('20220101', 'YYYYMMDD')
              ELSE TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM')
          END INTO V_MONTH_START_DATE
   FROM DUAL;
   
  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TFND_NAV';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-基金收益行情';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TFND_NAV NOLOGGING
    (F_ID	       --主键
    ,I_CODE	     --基金代码
    ,A_TYPE	     --资产类型
    ,M_TYPE	     --市场类型
    ,F_TOTALNAV	 --总净价
    ,F_YIELD_7D	 --七天年化收益率
    ,F_PUBDATE	 --公布日期
    ,BEG_DATE	   --开始日期
    ,END_DATE	   --结束日期
    ,IMP_DATE	   --导入时间
    ,PIPE_ID	   --管道ID
    ,F_CUMU_NAV	 --累积单位净值
    ,F_PROFIT_1W --七天万分收益
    ,F_UNITNAV	 --单位净价
    ,F_SCAL	     --基金规模（元）
    ,F_COUNT	   --基金总份额
    ,START_DT	   --开始时间
    ,END_DT	     --结束时间
    ,ID_MARK	   --增删标志
    )
  SELECT /*+PARALLEL*/
     F_ID	       --主键
    ,I_CODE	     --基金代码
    ,A_TYPE	     --资产类型
    ,M_TYPE	     --市场类型
    ,F_TOTALNAV	 --总净价
    ,F_YIELD_7D	 --七天年化收益率
    ,F_PUBDATE	 --公布日期
    ,BEG_DATE	   --开始日期
    ,END_DATE	   --结束日期
    ,IMP_DATE	   --导入时间
    ,PIPE_ID	   --管道ID
    ,F_CUMU_NAV	 --累积单位净值
    ,F_PROFIT_1W --七天万分收益
    ,F_UNITNAV	 --单位净价
    ,F_SCAL	     --基金规模（元）
    ,F_COUNT	   --基金总份额
    ,START_DT	   --开始时间
    ,END_DT	     --结束时间
    ,ID_MARK	   --增删标志
    FROM IOL.V_IBMS_TFND_NAV   --基金收益行情_视图
   WHERE BEG_DATE <= TO_CHAR(V_DATE,'YYYY-MM-DD') --ADD BY LIP 20220825 加上BEG_DATE,END_DATE的限制，减少数据量
     AND END_DATE > TO_CHAR(V_DATE,'YYYY-MM-DD')
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';
     
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
     
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


END ETL_O_IOL_IBMS_TFND_NAV;
/

