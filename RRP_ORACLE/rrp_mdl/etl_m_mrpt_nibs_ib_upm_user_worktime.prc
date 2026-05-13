CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_NIBS_IB_UPM_USER_WORKTIME (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_NIBS_IB_UPM_USER_WORKTIME
  *  功能描述：柜员工作时长统计
  *  创建日期：20230731
  *  开发人员：XIEMEIYI
  *  来源表： O_IOL_NIBS_IB_UPM_USER_WORKTIME
  *  目标表： M_MRPT_NIBS_IB_UPM_USER_WORKTIME
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230731  XIEMEIYI     首次创建
  ***************************************************************************/
  -- 定义变量 --
  AS
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_NIBS_IB_UPM_USER_WORKTIME'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称
  V_FREQ_FLAG   VARCHAR2(10);    --跑批频度标识
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_NIBS_IB_UPM_USER_WORKTIME'; --表名称

  --跑批频率
  V_FREQ_FLAG := FUN_FREQ(V_P_DATE, V_PROC_NAME);
  IF V_FREQ_FLAG = '1' THEN
    
  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  I_STEP := I_STEP + 1; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '数据落地-柜员工作时长统计';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_NIBS_IB_UPM_USER_WORKTIME
  (    DATA_DT, --数据日期
       USERNUM,                --柜员号
       BRANCHNUM,              --机构号
       LOGINDATESTR,           --登入日期 YYYYMMDD
       LOGINTIME,              --登入时间 YYYYMMDD HHMMSS
       LOGOUTTIME,             --登出时间 YYYYMMDD HHMMSS
       TOTALTIMESECOND,        --总时长 秒
       TRANTIMESECOND,         --交易时长 秒
       LEVELTIMESECOND,        --离柜时长 秒
       ONLINELEISURESECOND,    --在线空闲时长 秒
       SINGOUTFALG,            --是否进行进行了日终签退 0-否 1-是
       USERSTATUS,             --柜员在登陆状态|O-在线 L-离线
       START_DT,               --开始时间
       END_DT                  --结束时间

    )
    SELECT
       V_P_DATE,  --数据日期
       USERNUM,                --柜员号
       BRANCHNUM,              --机构号
       LOGINDATESTR,           --登入日期 YYYYMMDD
       LOGINTIME,              --登入时间 YYYYMMDD HHMMSS
       LOGOUTTIME,             --登出时间 YYYYMMDD HHMMSS
       TOTALTIMESECOND,        --总时长 秒
       TRANTIMESECOND,         --交易时长 秒
       LEVELTIMESECOND,        --离柜时长 秒
       ONLINELEISURESECOND,    --在线空闲时长 秒
       SINGOUTFALG,            --是否进行进行了日终签退 0-否 1-是
       USERSTATUS,             --柜员在登陆状态|O-在线 L-离线
       START_DT,               --开始时间
       END_DT                  --结束时间
    FROM  RRP_MDL.O_IOL_NIBS_IB_UPM_USER_WORKTIME; --柜员工作时长统计

   I_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   D_ENDTIME := SYSDATE;
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;  
   END IF;
   
   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   O_ERRCODE   := '0';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');
   COMMIT; 
   
   -- 程序异常处理部分 --
  EXCEPTION
  WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_NIBS_IB_UPM_USER_WORKTIME ;
/

