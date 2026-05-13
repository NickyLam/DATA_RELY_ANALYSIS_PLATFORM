CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG(   I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG
  *  功能描述：用户登录登出日志表
  *  创建日期：20230307
  *  开发人员：阳娟
  *  来源表： O_IOL_NIBS_IB_UPM_USERLOGIN_LOG
  *  目标表： M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230307  阳娟     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP     INTEGER := 0; -- 处理步骤
  I_SQLCOUNT INTEGER := 0; -- 更新或删除影响的记录数

  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME   DATE; -- 处理结束时间

  I_STEP_DESC VARCHAR2(100); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG'; -- 程序名称 --XZY 新建一个的时候，批量替换成新的名字就行
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  D_P_DATE    DATE; -- ETL数据日期
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  --V_SQL       VARCHAR2(2000); -- 动态SQL

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  D_P_DATE := TO_DATE(V_P_DATE,'YYYY-MM-DD');
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP      := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  DELETE FROM M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  D_ENDTIME  := SYSDATE;
  COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   I_STEP      := 2;
   I_STEP_DESC  := '用户登录登出日志表装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG NOLOGGING
    (         DATA_DT
							,CAUSEFAILURE  --失败原因
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
              V_P_DATE
              ,CAUSEFAILURE  --失败原因
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
    FROM RRP_MDL.O_IOL_NIBS_IB_UPM_USERLOGIN_LOG  --主指令表(视图)_视图
   WHERE ETL_DT = D_P_DATE;

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

   -- 程序跑批结束记录 --
   I_STEP      := 3;
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
    /* I_STEP :=3;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_NIBS_IB_UPM_USERLOGIN_LOG;
/

