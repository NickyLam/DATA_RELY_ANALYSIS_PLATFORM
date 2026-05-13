CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TRPT_TBND_EXT(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 债券补录信息表
  **存储过程名称：    ETL_O_IOL_IBMS_TRPT_TBND_EXT
  **存储过程创建日期：20220707
  **存储过程创建人：  赖海强
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250106    YJY        优化脚本
  ** 20251114    YJY        新增字段
  ****************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TRPT_TBND_EXT'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TRPT_TBND_EXT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-债券补录信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TRPT_TBND_EXT NOLOGGING
    (I_CODE	                 --债券代码
    ,A_TYPE	                 --资产类型
    ,M_TYPE	                 --市场类型
    ,P_CLASS_EXT	           --产品分类
    ,HX_BUSINESSMIDDLE	     --业务中类
    ,HX_BUSINESSSMALL	       --业务小类
    ,HX_INVESTCATEGORY	     --投向行业门类
    ,HX_INVESTBROHEADING	   --投向行业大类
    ,HX_ISLOCFINANC	         --是否地方政府融资平台
    ,HX_ISDISTBUS	           --是否异地业务
    ,HX_ISGOVER_FUND	       --是否政府投资基金
    ,HX_ISVC_FUND	           --是否创业投资基金
    ,HX_INCREDIT_TYPE	       --增信方式
    ,HX_CREMAINNAME	         --增信主体名称
    ,HXABS_INVEST1_TYPE	     --投资分类1
    ,HXABS_INVEST2_TYPE	     --投资分类2
    ,HXABS_INVESTAMOUNT	     --原投资产总金额（万元）
    ,HXABS_INVESTINFEAMOUNT	 --原投资产品劣后级金额（万元）
    ,HXABS_CREDITASSECU      --信贷资产支持证券
    ,HXABS_CSRCALLOASSECU    --证监会同意发行的企业资产支持证券
    ,HX_CREDITPARTYID        --授信主体
    ,HX_BASICTRADER          --基础资产客户
    ,HX_UNDATYPE             --底层资产类型
    ,HXABS_PENETRATION_TYPE  --穿透类型
    ,HXABS_ISDEBT_FOR_EQUITY   --是否投向市场化债转股
    ,HXABS_ISCONSUMER_FINANCING   --是否为消费服务类融资
    ,HXABS_AGAINABS          --是否再资产证券化(1:是,0否)
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,HX_IS_GREEN_FINANCE     --ADD BY YJY 20251114
    ,HX_FIRST_OPTION_TYPE    --ADD BY YJY 20251114
    ,HX_SECOND_OPTION_TYPE   --ADD BY YJY 20251114
     )
  SELECT /*+PARALLEL*/
     I_CODE	                 --债券代码
    ,A_TYPE	                 --资产类型
    ,M_TYPE	                 --市场类型
    ,P_CLASS_EXT	           --产品分类
    ,HX_BUSINESSMIDDLE	     --业务中类
    ,HX_BUSINESSSMALL	       --业务小类
    ,HX_INVESTCATEGORY	     --投向行业门类
    ,HX_INVESTBROHEADING	   --投向行业大类
    ,HX_ISLOCFINANC	         --是否地方政府融资平台
    ,HX_ISDISTBUS	           --是否异地业务
    ,HX_ISGOVER_FUND	       --是否政府投资基金
    ,HX_ISVC_FUND	           --是否创业投资基金
    ,HX_INCREDIT_TYPE	       --增信方式
    ,HX_CREMAINNAME	         --增信主体名称
    ,HXABS_INVEST1_TYPE	     --投资分类1
    ,HXABS_INVEST2_TYPE	     --投资分类2
    ,HXABS_INVESTAMOUNT	     --原投资产总金额（万元）
    ,HXABS_INVESTINFEAMOUNT	 --原投资产品劣后级金额（万元）
    ,HXABS_CREDITASSECU      --信贷资产支持证券
    ,HXABS_CSRCALLOASSECU    --证监会同意发行的企业资产支持证券
    ,HX_CREDITPARTYID        --授信主体
    ,HX_BASICTRADER          --基础资产客户
    ,HX_UNDATYPE             --底层资产类型
    ,HXABS_PENETRATION_TYPE  --穿透类型
    ,HXABS_ISDEBT_FOR_EQUITY   --是否投向市场化债转股
    ,HXABS_ISCONSUMER_FINANCING   --是否为消费服务类融资
    ,HXABS_AGAINABS          --是否再资产证券化(1:是,0否)
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,HX_IS_GREEN_FINANCE     --ADD BY YJY 20251114
    ,HX_FIRST_OPTION_TYPE    --ADD BY YJY 20251114
    ,HX_SECOND_OPTION_TYPE   --ADD BY YJY 20251114
    FROM IOL.V_IBMS_TRPT_TBND_EXT   --债券补录信息表_视图
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


END ETL_O_IOL_IBMS_TRPT_TBND_EXT;
/

