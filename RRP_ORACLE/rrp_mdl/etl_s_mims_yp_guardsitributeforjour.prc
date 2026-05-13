CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_MIMS_YP_GUARDSITRIBUTEFORJOUR(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_S_MIMS_YP_GUARDSITRIBUTEFORJOUR
  *  功能描述：G13押品系统表
  *  创建日期：20221124
  *  开发人员：卢伟博
  *  来源表：
  *  目标表： S_MIMS_YP_GUARDSITRIBUTEFORJOUR
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221124  卢伟博   首次创建
  *             2    20231117  HYF      增加删除标志过滤
  *             3    20251020  YJY      作业下线
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_S_MIMS_YP_GUARDSITRIBUTEFORJOUR'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  /*  --MOD BY YJY 20251020
  -- 处理参数及月末等判断逻辑 --

  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_MIMS_YP_GUARDSITRIBUTEFORJOUR'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE ETL_S_MIMS_YP_GUARDSITRIBUTEFORJOUR';
  --DELETE FROM RRP_MDL.S_MIMS_YP_GUARDSITRIBUTEFORJOUR WHERE DATA_DT=V_P_DATE;
  COMMIT;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, 'S_MIMS_YP_GUARDSITRIBUTEFORJOUR', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;


  INSERT  INTO RRP_MDL.S_MIMS_YP_GUARDSITRIBUTEFORJOUR NOLOGGING
    (
      DATA_DT       ,
      SCCODE        ,
      CONTRACTNO    ,
      BALANCE       ,
      DISTVALUE     ,
      CONTGUARTYPE  ,
      GUARTYPE      ,
      CREDITTYPE    ,
      BARSIGN       ,
      INTERINDUSTRY ,
      CUSTSCALE     ,
      REPORTTYPE    ,
      DEPTCODE      ,
      FIVECLASS     ,
      CREDNO        ,
      BAL           ,
      CONFMAMT      ,
      FIRSTCONFMAMT ,
      DATECODE      ,
      START_DT      ,
      END_DT        ,
      ID_MARK
    )
  SELECT 
          V_P_DATE      ,
          SCCODE        ,
          CONTRACTNO    ,
          BALANCE       ,
          DISTVALUE     ,
          CONTGUARTYPE  ,
          GUARTYPE      ,
          CREDITTYPE    ,
          BARSIGN       ,
          INTERINDUSTRY ,
          CUSTSCALE     ,
          REPORTTYPE    ,
          DEPTCODE      ,
          FIVECLASS     ,
          CREDNO        ,
          BAL           ,
          CONFMAMT      ,
          FIRSTCONFMAMT ,
          DATECODE      ,
          START_DT      ,
          END_DT        ,
          ID_MARK
    FROM RRP_MDL.O_IOL_MIMS_YP_GUARDSITRIBUTEFORJOUR   --按业务规则分配G13结果表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT>TO_DATE(V_P_DATE,'YYYYMMDD')
     AND SUBSTR(DATECODE,1,6)=SUBSTR(V_P_DATE,1,6)
     AND ID_MARK <> 'D';

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

     -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, SCCODE,CREDNO,COUNT(1)
      FROM RRP_MDL.S_MIMS_YP_GUARDSITRIBUTEFORJOUR T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, SCCODE,CREDNO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_LOAN_GREEN字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  */
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
  V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_MIMS_YP_GUARDSITRIBUTEFORJOUR;
/

