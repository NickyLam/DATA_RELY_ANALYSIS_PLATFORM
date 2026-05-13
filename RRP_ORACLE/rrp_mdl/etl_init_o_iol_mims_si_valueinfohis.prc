CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_MIMS_SI_VALUEINFOHIS(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_MIMS_SI_VALUEINFOHIS
  *  功能描述：押品价值历史信息
  *  创建日期：20221205
  *  开发人员：HULIJUAN
  *  来源表：  IOL.V_MIMS_SI_VALUEINFOHIS
  *  目标表： O_IOL_MIMS_SI_VALUEINFOHIS
  *  配置表：
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20221205  HULIJUAN  首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_MIMS_SI_VALUEINFOHIS'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_MIMS_SI_VALUEINFOHIS T WHERE T.START_DT >= TO_DATE(V_P_DATE,'YYYYMMDD') AND T.END_DT<TO_DATE(V_P_DATE,'YYYYMMDD');
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_MIMS_SI_VALUEINFOHIS';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-押品价值历史信息息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_MIMS_SI_VALUEINFOHIS
  (
    SCCODE              --押品编号
   ,EVALMODE            --评估方式 01-外部评估      02-内部评估      03-外部和内部评估
   ,EVALDATE            --评估日期 评估价值评估的日期
   ,CURRENY             --币种
   ,RATE                --汇率
   ,OUTEVALEXPDATE      --外部评估价值有效期截止日
   ,OUTEVALDEPTCODE     --外部评估机构
   ,OUTEVALMETHOD       --外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
   ,OUTEVALFLAG         --是否有外部预评估报告 0-否            1-是
   ,OUTEVALAMT1         --外部预评估报告的评估价值
   ,OUTEVALDATE         --外部正式评估报告评估日期
   ,OUTEVALAMT          --外部正式评估报告的评估价值
   ,EVALAMT             --内部评估价值 根据内部评估方法计算出的内部评估价值
   ,EVALAMT2            --申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
   ,BUSINESSINSID       --流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
   ,CONFMAMT            --我行确认价值
   ,CONDATE             --评估认定日期
   ,FIRSTOUTEVALAMT     --初评外部正式评估价值
   ,FIRSTEVALAMT        --初评内部评估价值 根据内部评估方法计算出的内部评估价值
   ,FIRSTCONFMAMT       --初评我行确认价值
   ,STARTBUSINESSINSID  --初评流程编号
   ,VERECOGINITION      --押品价值认定方式
   ,START_DT            --开始时间
   ,END_DT              --结束时间
   ,ID_MARK             --增删标志
   ,ETL_TIMESTAMP       --ETL处理时间戳
    )
    SELECT
    SCCODE              --押品编号
   ,EVALMODE            --评估方式 01-外部评估      02-内部评估      03-外部和内部评估
   ,EVALDATE            --评估日期 评估价值评估的日期
   ,CURRENY             --币种
   ,RATE                --汇率
   ,OUTEVALEXPDATE      --外部评估价值有效期截止日
   ,OUTEVALDEPTCODE     --外部评估机构
   ,OUTEVALMETHOD       --外部评估方法 01-指数法_外部指数        02-指数法_内部构建指数        03-市场法        04-收益法        05-重置成本法        06-工程进度法        07-非上市公司股权净资产比例法        08-直接引用法_金融质抵质押品        09-直接引用法_动产        10-直接引用法_房地产        11-直接引用法_询价        12-其他
   ,OUTEVALFLAG         --是否有外部预评估报告 0-否            1-是
   ,OUTEVALAMT1         --外部预评估报告的评估价值
   ,OUTEVALDATE         --外部正式评估报告评估日期
   ,OUTEVALAMT          --外部正式评估报告的评估价值
   ,EVALAMT             --内部评估价值 根据内部评估方法计算出的内部评估价值
   ,EVALAMT2            --申请评估确认价值 分析外部评估和内部评估价值后，客户经理得出评估确认价值
   ,BUSINESSINSID       --流程编号 我行确认价值对应的流程编号，如我行确认价值为自动重估得到，则该字段为空
   ,CONFMAMT            --我行确认价值
   ,CONDATE             --评估认定日期
   ,FIRSTOUTEVALAMT     --初评外部正式评估价值
   ,FIRSTEVALAMT        --初评内部评估价值 根据内部评估方法计算出的内部评估价值
   ,FIRSTCONFMAMT       --初评我行确认价值
   ,STARTBUSINESSINSID  --初评流程编号
   ,VERECOGINITION      --押品价值认定方式
   ,START_DT            --开始时间
   ,END_DT              --结束时间
   ,ID_MARK             --增删标志
   ,ETL_TIMESTAMP       --ETL处理时间戳
    FROM IOL.V_MIMS_SI_VALUEINFOHIS  --视图-押品价值历史信息
    --
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

  END ETL_INIT_O_IOL_MIMS_SI_VALUEINFOHIS;
/

