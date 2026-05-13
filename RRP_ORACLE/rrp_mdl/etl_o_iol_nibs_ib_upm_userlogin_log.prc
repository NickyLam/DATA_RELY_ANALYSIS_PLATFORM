CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NIBS_IB_UPM_USERLOGIN_LOG(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NIBS_IB_UPM_USERLOGIN_LOG
  *  功能描述：用户登录登出日志表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_NIBS_IB_UPM_USERLOGIN_LOG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NIBS_IB_UPM_USERLOGIN_LOG'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NIBS_IB_UPM_USERLOGIN_LOG';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NIBS_IB_UPM_USERLOGIN_LOG NOLOGGING
    (
							CAUSEFAILURE  --失败原因
							,NOTE1  --备注1
							,NOTE2  --备注2
							,NOTE3  --备注3
							,NOTE4  --备注4
							,NOTE5  --备注5
							,LOGINSTATE  --登录状态 : 0失败 1成功
							,REGTYPE  --登记类型 : 登记类型：0登出 1登入
							,REGTIME  --登记时间-HHMMSS
							,DATEREG  --登记日期-YYYYMMDD
							,DEVICEOID  --设备OID
							,HOSTNAME  --主机名
							,LOGINIP  --登录IP
							,SESSIONID  --SESSIONID
							,OUTFLAG  --1-本人登出，2-强制登出
							,USERNAME  --用户名称
							,USERNUM  --用户编号
							,APPNUM  --渠道编号
							,BRANCHNUM  --机构号
							,ETL_DT  --ETL处理日期


     )
  SELECT /*+PARALLEL*/
              CAUSEFAILURE  --失败原因
              ,NOTE1  --备注1
              ,NOTE2  --备注2
              ,NOTE3  --备注3
              ,NOTE4  --备注4
              ,NOTE5  --备注5
              ,LOGINSTATE  --登录状态 : 0失败 1成功
              ,REGTYPE  --登记类型 : 登记类型：0登出 1登入
              ,REGTIME  --登记时间-HHMMSS
              ,DATEREG  --登记日期-YYYYMMDD
              ,DEVICEOID  --设备OID
              ,HOSTNAME  --主机名
              ,LOGINIP  --登录IP
              ,SESSIONID  --SESSIONID
              ,OUTFLAG  --1-本人登出，2-强制登出
              ,USERNAME  --用户名称
              ,USERNUM  --用户编号
              ,APPNUM  --渠道编号
              ,BRANCHNUM  --机构号
              ,ETL_DT  --ETL处理日期
    FROM IOL.V_NIBS_IB_UPM_USERLOGIN_LOG   --主指令表(视图)_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   --插入跑批完成记录--
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

  END ETL_O_IOL_NIBS_IB_UPM_USERLOGIN_LOG;
/

