CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_PUM_EXRT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_PUM_EXRT_INFO
  *  功能描述：监管集市各类币种折币信息
  *  创建日期：20220519
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_EXCH_RAT_INFO  --汇率信息
  *
  *  目标表：  M_PUM_EXRT_INFO  --汇率表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_PUM_EXRT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_RPT_NO    VARCHAR2(100) := 'M_PUM_EXRT_INFO'; -- 表名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  V_TAB_NAME := 'M_PUM_EXRT_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
   -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '汇率表';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EXRT_INFO
  (
     DATA_DT,          --数据日期
     LGL_REP_ID,       --法人编号
     ORG_ID,           --机构编号
     BASE_CUR,         --基准币种
     CNV_CUR,          --折算币种
     MDL_PRC,          --中间价
     BASE_PRC,         --基准价
     EXRT,             --汇率
     DEPT_LINE,        --部门条线
     DATA_SRC,         --数据来源
     OFR_RATE_OF_CCY,  --汇卖价
     BID_RATE_OF_CCY,  --汇买价
     BID_RATE_OF_CASH, --钞买价
     OFR_RATE_OF_CASH, --钞卖价
     CONVT_CORP        --换算单位
     )
  SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT    --数据日期
         ,A.LP_ID               AS LGL_REP_ID         --法人编号
         ,'000000'              AS ORG_ID             --机构编号
         ,A.CURR_CD             AS BASE_CUR           --基准币种
         ,'CNY'                 AS CNV_CUR            --折算币种
         ,COALESCE(A.CNY_EXCH_RAT*100,EV.MDL_PRC,100) AS MDL_PRC --中间价
         ,COALESCE(A.BASE_PRICE,EV.BASE_PRC,100) AS BASE_PRC --基准价
         ,A.CNY_EXCH_RAT        AS EXRT               --汇率
         ,NULL                  AS DEPT_LINE          --部门条线
         ,'汇率信息'             AS DATA_SRC           --数据来源
         ,A.EXCH_SELL_PRICE     AS OFR_RATE_OF_CCY    --汇卖价
         ,A.EXCH_BUY_PRICE      AS BID_RATE_OF_CCY    --汇买价
         ,A.CASH_BUY_PRICE      AS BID_RATE_OF_CASH   --钞买价
         ,A.CASH_SELL_PRICE     AS OFR_RATE_OF_CASH   --钞卖价
         ,A.CONVT_CORP          AS CONVT_CORP         --换算单位
    FROM O_ICL_CMM_EXCH_RAT_INFO A --汇率信息
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EV
         ON EV.BASE_CUR = A.CURR_CD AND TO_DATE(EV.DATA_DT,'YYYYMMDD')=TO_DATE(V_P_DATE,'YYYYMMDD')-1
    WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        UNION ALL
    SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT   --数据日期
         ,A.LP_ID    AS LGL_REP_ID                       --法人编号
         ,'000000'   AS ORG_ID                     --机构编号
         ,A.CURR_CD  AS BASE_CUR                      --基准币种
         ,'USD'      AS CNV_CUR                      --折算币种
         ,COALESCE(A.CNY_EXCH_RAT*100,EV.MDL_PRC,100) AS MDL_PRC --中间价
         ,COALESCE(A.BASE_PRICE,EV.BASE_PRC,100) AS BASE_PRC --基准价
         ,A.USD_EXCH_RAT        AS EXRT                      --汇率
         ,'800976'/*资金交易部*/AS DEPT_LINE                     --部门条线
         ,'汇率信息'             AS DATA_SRC           --数据来源
         ,A.EXCH_SELL_PRICE     AS OFR_RATE_OF_CCY    --汇卖价
         ,A.EXCH_BUY_PRICE      AS BID_RATE_OF_CCY    --汇买价
         ,A.CASH_BUY_PRICE      AS BID_RATE_OF_CASH   --钞买价
         ,A.CASH_SELL_PRICE     AS OFR_RATE_OF_CASH   --钞卖价
         ,A.CONVT_CORP          AS CONVT_CORP         --换算单位
    FROM O_ICL_CMM_EXCH_RAT_INFO A --汇率信息
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EV
         ON EV.BASE_CUR = A.CURR_CD AND TO_DATE(EV.DATA_DT,'YYYYMMDD')=TO_DATE(V_P_DATE,'YYYYMMDD')-1
    WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        UNION ALL
        SELECT  TO_CHAR(A.ETL_DT,'YYYYMMDD')  AS DATA_DT   --数据日期
         ,A.LP_ID    AS LGL_REP_ID                       --法人编号
         ,'000000'   AS ORG_ID                     --机构编号
         ,A.CURR_CD  AS BASE_CUR                      --基准币种
         ,'EUR'      AS CNV_CUR                      --折算币种
         ,COALESCE(A.CNY_EXCH_RAT*100,EV.MDL_PRC,100) AS MDL_PRC --中间价
         ,COALESCE(A.BASE_PRICE,EV.BASE_PRC,100) AS BASE_PRC --基准价
         ,A.EUR_EXCH_RAT        AS EXRT                      --汇率
         ,'800976'   /*资金交易部*/ AS DEPT_LINE                     --部门条线
         ,'汇率信息'             AS DATA_SRC           --数据来源
         ,A.EXCH_SELL_PRICE     AS OFR_RATE_OF_CCY    --汇卖价
         ,A.EXCH_BUY_PRICE      AS BID_RATE_OF_CCY    --汇买价
         ,A.CASH_BUY_PRICE      AS BID_RATE_OF_CASH   --钞买价
         ,A.CASH_SELL_PRICE     AS OFR_RATE_OF_CASH   --钞卖价
         ,A.CONVT_CORP          AS CONVT_CORP         --换算单位
    FROM O_ICL_CMM_EXCH_RAT_INFO A --汇率信息
    LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO EV
         ON EV.BASE_CUR = A.CURR_CD AND TO_DATE(EV.DATA_DT,'YYYYMMDD')=TO_DATE(V_P_DATE,'YYYYMMDD')-1
    WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

/*  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '汇率表-插入人民币折人民币数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_PUM_EXRT_INFO
       (
     DATA_DT,          --数据日期
     LGL_REP_ID,       --法人编号
     ORG_ID,           --机构编号
     BASE_CUR,         --基准币种
     CNV_CUR,          --折算币种
     MDL_PRC,          --中间价
     BASE_PRC,         --基准价
     EXRT,             --汇率
     DEPT_LINE,        --部门条线
     DATA_SRC,         --数据来源
     OFR_RATE_OF_CCY,  --汇卖价
     BID_RATE_OF_CCY,  --汇买价
     BID_RATE_OF_CASH, --钞买价
     OFR_RATE_OF_CASH,  --钞卖价
     CONVT_CORP        --换算单位
     )
     SELECT
     V_P_DATE        AS DATA_DT,          --数据日期
     '9999'          AS LGL_REP_ID,       --法人编号
     '000000'        AS ORG_ID,           --机构编号
     'CNY'           AS BASE_CUR,         --基准币种
     'CNY'           AS CNV_CUR,          --折算币种
     NULL            AS MDL_PRC,          --中间价
     NULL            AS BASE_PRC,         --基准价
     1.000000        AS EXRT,             --汇率
     '800976'   \*资金交易部*\ AS DEPT_LINE,        --部门条线
     NULL            AS DATA_SRC,         --数据来源
     NULL            AS OFR_RATE_OF_CCY,  --汇卖价
     NULL            AS BID_RATE_OF_CCY,  --汇买价
     NULL            AS BID_RATE_OF_CASH, --钞买价
     NULL            AS OFR_RATE_OF_CASH, --钞卖价
     100.000000      AS CONVT_CORP        --换算单位
    FROM DUAL;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, BASE_CUR,CNV_CUR,COUNT(1)
      FROM M_PUM_EXRT_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, BASE_CUR,CNV_CUR
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

  END ETL_INIT_M_PUM_EXRT_INFO;
/

