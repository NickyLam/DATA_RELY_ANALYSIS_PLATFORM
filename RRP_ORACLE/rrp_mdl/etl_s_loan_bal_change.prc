CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_BAL_CHANGE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_BAL_CHANGE
  *  功能描述：不良贷款余额变动表
  *  创建日期：20240322
  *  开发人员：卢伟博
  *  来源表：  M_LOAN_IN_DUBILL_INFO
  *
  *
  *  目标表：  S_LOAN_BAL_CHANGE
  *  配置表：  CONFIG_AREA
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1  20240322    lwb      新增
                 2  20240412    lwb      修改取数口径，以上一天不良贷款的余额变动作为统计口径
                 3  20240424    lwb     新增对公的余额变动，含调整利息及公允价值变动
                 4  20240716    LWB     新增上日正常，跑批日不良，贷款余额变动的场景
                 5  20251114    LWB     修改余额变动的条件
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_BAL_CHANGE'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_YESTADAY VARCHAR2(8);--上一天
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_YESTADAY:=TO_CHAR(TO_DATE(I_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');--上一天
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_BAL_CHANGE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_BAL_CHANGE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_BAL_CHANGE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '记录贷款余额不良变动';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_LOAN_BAL_CHANGE
    (data_dt,
     rcpt_id,
     loan_std_prod_id,
     loan_std_prod_nm,
     bdq_lvl5_cl,
     bds_lvl5_cl,
     loan_bal_change,
     bdq_loan_bal,
     bdh_loan_bal,
     change_dt,
     data_src,
     ORG_ID,
     LOAN_INT_ADJ_CHANGE,
     LOAN_FAIR_VAL_CHG_CHANGE)
    SELECT V_P_DATE   AS DATA_DT,
           A.RCPT_ID  AS rcpt_id,
           A.loan_std_prod_id AS loan_std_prod_id,
           A.loan_std_prod_nm AS loan_std_prod_nm,
           b.lvl5_cl  AS bdq_lvl5_cl,
           A.LVL5_CL  AS bds_lvl5_cl,
          (CASE WHEN SUBSTR(B.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(B.LOAN_BAL,0) END - CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(A.LOAN_BAL,0) END) AS loan_bal_change,
           CASE WHEN SUBSTR(B.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(B.LOAN_BAL,0) END as bdq_loan_bal,
           CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(A.LOAN_BAL,0) END AS bdh_loan_bal,
           A.DATA_DT AS change_dt,
           a.data_src as data_src,
           A.ORG_ID   AS ORG_iD,
           B.INT_ADJ - A.INT_ADJ AS LOAN_INT_ADJ_CHANGE,
           B.FAIR_VAL_CHG - A.FAIR_VAL_CHG as LOAN_FAIR_VAL_CHG_CHANGE
  FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A
 INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO B
    ON A.RCPT_ID = B.RCPT_ID
   AND B.DATA_DT = V_YESTADAY
 WHERE  (B.LVL5_CL IN ('03', '04', '05') --记录当天不良且对比上一天贷款余额发生变动的数据，
        OR A.LVL5_CL IN ('03', '04', '05')) --modify by lwb
   AND A.DATA_DT = V_P_DATE --修改为上一天不良且对比金天贷款余额发生变动的数据
   AND ((CASE WHEN SUBSTR(B.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(B.LOAN_BAL,0) END - CASE WHEN SUBSTR(A.SUBJ_ID,1,6) IN  ('810601','710701') THEN 0
                ELSE NVL(A.LOAN_BAL,0) END)<> 0 
   OR (B.INT_ADJ - A.INT_ADJ)<> 0 OR (B.FAIR_VAL_CHG - A.FAIR_VAL_CHG)<> 0)
   ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;



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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_BAL_CHANGE;
/

