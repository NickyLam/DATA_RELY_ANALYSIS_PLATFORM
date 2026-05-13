CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT
  *  功能描述：押品出入库台账流水表（全量抽取增量表，落地到S层）
  *  创建日期：20230216
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230217  卢伟博     首次创建
  *             2    20251020  YJY        作业下线
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;


  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_01 T WHERE T.SETTLEDATE = V_P_DATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE S_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_01';
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


  V_STEP_DESC  := '装入目标表';
  INSERT  INTO RRP_MDL.S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT NOLOGGING
    (        DATA_DT
            ,BUSINESSINSID  --流程实例号
            ,SCCODE  --押品编号
            ,GUARTYPE  --押品类型
            ,CONFMAMT  --我行确认价值
            ,CONFMCURRENCY  --我行确认价值币种
            ,STATE  --出入库状态
            ,BUSOVETIME  --出入库时间
            ,CREATEUSER  --创建人
            ,DEPTCODE  --所属机构
            ,ETL_DT  --ETL处理日期
            ,ETL_TIMESTAMP  --ETL处理时间戳

     )
  SELECT 
             V_P_DATE
            ,BUSINESSINSID  --流程实例号
            ,SCCODE  --押品编号
            ,GUARTYPE  --押品类型
            ,CONFMAMT  --我行确认价值
            ,CONFMCURRENCY  --我行确认价值币种
            ,STATE  --出入库状态
            ,BUSOVETIME  --出入库时间
            ,CREATEUSER  --创建人
            ,DEPTCODE  --所属机构
            ,ETL_DT  --ETL处理日期
            ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM RRP_MDL.O_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT   --主指令表(视图)_视图
   WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     ;

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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
  --V_STEP := V_STEP + 1;
   --  V_STEP_DESC := '-- 程序跑批异常 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_IOL_MIMS_YP_SECURITYINFOVLAUECOUNT;
/

