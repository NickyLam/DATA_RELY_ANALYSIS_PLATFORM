CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_LOAN_NET_COOP_SUB(I_P_DATE IN INTEGER, O_ERRCODE  OUT VARCHAR2  )
/******************************
  **存储过程详细说明：互联网贷款合作协议表
  **存储过程名称：ETL_INIT_M_LOAN_NET_COOP_SUB
  **存储过程创建日期：2022-04-02
  **存储过程创建人：李萍
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220101';
         ETL_INIT_M_LOAN_NET_COOP_SUB(I_P_DATE, O_ERRCODE);
       END;
  **输入参数：I_P_DATE
  **输出参数：O_ERRCODE
  **返回值：O_ERRCODE
  ** 修改日期    修改项目   修改原因   修改人
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_M_LOAN_NET_COOP_SUB'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_LOAN_NET_COOP_SUB'; --表名
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


  /*程序处理过程*/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入互联网贷款合作协议表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.M_LOAN_NET_COOP_SUB
    (DATA_DT                     --数据日期
    ,LGL_REP_ID                  --法人编号
    ,ORG_ID                      --机构编号
    ,COOP_AGRT_ID                --合作协议编号
    ,PNR_NM                      --合作方名称
    ,PNR_CRDL_TYP                --合作方证件类别
    ,PNR_CRDL_NO                 --合作方证件号码
    ,PNR_TYP                     --合作方类型
    ,COOP_MODE                   --合作方式
    ,PNR_FND_PCT                 --合作方出资比例
    ,AGRT_START_DT               --协议起始日期
    ,AGRT_EXP_DT                 --协议到期日期
    ,ACT_END_DT                  --实际终止日期
    ,PNR_REGD_LAND_CD            --合作方注册地代码
    ,RST_FLG                     --限制标志
    ,AGRT_STAT                   --协议状态
    ,COOP_PROD                   --合作产品
    ,DEPT_LINE                   --部门条线
    ,DATA_SRC                    --数据来源
    )
  SELECT  V_P_DATE                                    DATA_DT                    --数据日期
         ,'9999'                                      LGL_REP_ID                 --法人编号
         ,NVL(T.ORG_ID1,TA.ORG_ID)                    ORG_ID                      --机构编号
         ,TA.COOP_AGRT_ID                             COOP_AGRT_ID                --合作协议编号
         ,TA.PNR_NM                                   PNR_NM                      --合作方名称
         ,TA.PNR_CRDL_TYP                             PNR_CRDL_TYP                --合作方证件类别
         ,TA.PNR_CRDL_NO                              PNR_CRDL_NO                 --合作方证件号码
         ,TA.PNR_TYP                                  PNR_TYP                     --合作方类型
         ,TA.COOP_MODE                                COOP_MODE                   --合作方式
         ,TA.PNR_FND_PCT                              PNR_FND_PCT                 --合作方出资比例
         ,TA.AGRT_START_DT                            AGRT_START_DT               --协议起始日期
         ,TA.AGRT_EXP_DT                              AGRT_EXP_DT                 --协议到期日期
         ,TA.ACT_END_DT                               ACT_END_DT                  --实际终止日期
         ,TA.PNR_REGD_LAND_CD                         PNR_REGD_LAND_CD            --合作方注册地代码
         ,TA.RST_FLG                                  RST_FLG                     --限制标志
         ,CASE WHEN TA.ACT_END_DT <=  V_P_DATE  THEN '01'
               ELSE TA.AGRT_STAT
           END                                        AGRT_STAT                   --协议状态
         ,TA.COOP_PROD                                COOP_PROD                   --合作产品
         ,TA.DEPT_LINE                                DEPT_LINE                   --部门条线
         ,TA.DATA_SRC                                 DATA_SRC                    --数据来源
    FROM RRP_MDL.ADD_LOAN_NET_COOP_SUB TA --互联网贷款合作协议表配置表
    LEFT JOIN RRP_MDL.ORG_CONFIG T
      ON T.ORG_ID = TA.ORG_ID
   WHERE (TA.AGRT_START_DT <= V_P_DATE
     OR TA.AGRT_START_DT = '99991231');


  V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


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

END ETL_INIT_M_LOAN_NET_COOP_SUB;
/

