CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LVL5_CL_CHANGE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LVL5_CL_CHANGE
  *  功能描述：五级分类变动表
  *  创建日期：20231023
  *  开发人员：tzj
  *  来源表：
  *  目标表：  S_LVL5_CL_CHANGE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231023  tzj      新增 零售和网商贷的五级分类变动表,该表存每天的五级分类变动的增量数据.
                2    20240422  lwb      新增对公信贷的五级分类变动
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP        INTEGER := 0;                                  -- 处理步骤
  V_PROC_NAME   VARCHAR2(100) := 'ETL_S_LVL5_CL_CHANGE';     -- 程序名称
  V_P_DATE      VARCHAR2(8);                                   -- 跑批数据日期
  V_STARTTIME   DATE;                                          -- 处理开始时间
  V_ENDTIME     DATE;                                          -- 处理结束时间
  V_SQLCOUNT    INTEGER := 0;                                  -- 更新或删除影响的记录数
  V_SQLMSG      VARCHAR2(300);                                 -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);                                  -- 来源系统
  V_STEP_DESC   VARCHAR2(200);                                 --任务名称
  V_TAB_NAME    VARCHAR2(100) ;                                --表名
  V_PART_NAME   VARCHAR2(100);                                 --分区名
  V_LDAY        VARCHAR2(8);                                   --上日
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE);                                -- 获取跑批日期
  V_SYSTEM := '监管报送';                                       -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LVL5_CL_CHANGE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LDAY   := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');  --上日

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
  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据，支持重跑
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  -- 程序业务逻辑处理主体部分 --

  V_STEP := 3;
  V_STEP_DESC := '零售&对公五级分类变动表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO S_LVL5_CL_CHANGE NOLOGGING
  (
        DATA_DT                                               --数据日期
        ,RID	                                                  --流水号RID
        ,CUST_ID	                                            --客户号
        ,CUST_NM	                                            --客户名称
        ,RCPT_ID	                                            --借据号
        ,LOAN_STD_PROD_ID	                                    --贷款产品编号
        ,CUR	                                                --业务币种代码
        ,LOAN_NET_VAL_BF                                      --调整前余额
        ,LOAN_NET_VAL	                                        --调整后余额
        ,LVL5_CL_BF	                                          --调整前五级分类代码
        ,LVL5_CL	                                            --调整后五级分类代码
        ,ADJ_DT                                            	  --调整日期
        ,DATA_SRC                                             --数据来源
          )
       SELECT
             V_P_DATE                       AS DATA_DT               --数据日期
            ,SYS_GUID()                     AS RID                   --流水号
            ,T1.CUST_ID                     AS CUST_ID               --客户号
            ,''                             AS CUST_NM               --客户名称
            ,T1.RCPT_ID                     AS RCPT_ID               --借据号
            ,T1.LOAN_STD_PROD_ID            AS LOAN_STD_PROD_ID      --贷款产品编号
            ,T1.CUR                         AS CUR                   --币种
            ,CASE WHEN SUBSTR(T1.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                    ELSE NVL(T1.LOAN_BAL,0) + NVL(T1.FAIR_VAL_CHG,0) - NVL(T1.INT_ADJ,0)
               END                          AS LOAN_NET_VAL_BF         --调整前余额
            ,CASE WHEN SUBSTR(T3.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                    ELSE NVL(T3.LOAN_BAL,0) + NVL(T3.FAIR_VAL_CHG,0) - NVL(T3.INT_ADJ,0)
               END                          AS LOAN_NET_VAL           --调整后余额
            ,T1.LVL5_CL                     AS LVL5_CL_BF             --调整前五级分类代码
            ,T3.LVL5_CL                     AS LVL5_CL                --调整后五级分类代码
            ,V_P_DATE                       AS ADJ_DT                 --调整日期
            ,T1.DATA_SRC                    AS DATA_SRC               --数据来源
       FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO  T1    --表内借据信息
 INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO  T3
        ON T3.RCPT_ID = T1.RCPT_ID
       AND T3.DATA_DT = V_P_DATE
       AND T3.DATA_SRC IN ('对公信贷','零售贷款','联合网贷')--modify by lwb
     WHERE T1.DATA_DT = V_LDAY
       AND T1.DATA_SRC IN ('对公信贷','零售贷款','联合网贷')
       AND T1.LVL5_CL <> T3.LVL5_CL
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := 4;
   V_STEP_DESC := '跑批状态更新';
   V_ENDTIME := SYSDATE;
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
    V_STEP := 5;
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

  END ETL_S_LVL5_CL_CHANGE;
/

