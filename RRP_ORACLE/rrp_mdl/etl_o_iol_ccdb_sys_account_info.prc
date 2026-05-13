CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CCDB_SYS_ACCOUNT_INFO(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CCDB_SYS_ACCOUNT_INFO
  *  功能描述：用户信息表
  *  创建日期：20231102
  *  开发人员：HULJ
  *  来源表：
  *  目标表： O_IOL_CCDB_SYS_ACCOUNT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231102  HULJ     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CCDB_SYS_ACCOUNT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CCDB_SYS_ACCOUNT_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CCDB_SYS_ACCOUNT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-用户信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_CCDB_SYS_ACCOUNT_INFO
  (
    STATUS			         --状态
    ,PASSWORD			       --登录密码
    ,CREATE_DATE			   --创建日期
    ,UPDATE_DATE			   --修改日期
    ,AGENT_ID			       --agentid
    ,BUSINESS_GROUP_CODE --业务组编号（参数配置）
    ,ACCOUNT_CODE			   --用户账号
    ,EMP_CODE			       --员工编号
    ,SKILL_GROUP_CODE		 --技能组编号（参数配置）
    ,PWD_LAPSE_DATE			 --密码过期时间
    ,CREATER_CODE			   --创建者工号
    ,UPDATE_CODE			   --更新者工号
    ,OPERATOR_TYPE_CODE	 --用户类型编码（参数配置）
    ,ACCOUNT_LOCK			   --锁定用户 0:locked  1:unlock
    ,AWORKSTS			       --工作状态
    ,TSWORKSTSTIME			 --工作状态开始时间
    ,LOGIN_NUM			     --是否首次登录 (新建用户初始值为1)
    ,RESET_PASSWORD_FLAG --是否重置密码 (0:未重置  1:重置)新增用户为1
    ,LOCK_NUM			       --登陆失败次数
    ,LOCK_TIME			     --登陆时间
    ,LOGIN_SERVER			   --签入地址(priserver 代表主中心 bakserver 备中心)
    ,MEDIA_TYPE			     --多媒体类型（chat代表在线video视频media多媒体）
    ,MEDIA_PIC			     --视频客服不开摄像头背景图
    ,TONE_SWITCH			   --在线客服铃声提醒开关
    ,PRO_BANK_TONE_SWITCH			--流程银行提示音提醒开关
    ,SOFTPHONE_TYPE			 --软电话类型（websocket/applet:接入方式为websocket/applet）
    ,TRACKING_REMIND_TONE_SWITCH			--小结继续跟进提示音提醒开关
    ,START_DT			       --开始时间
    ,END_DT			         --结束时间
    ,ID_MARK			       --增删标志
    )
  SELECT 
    STATUS			         --状态
    ,PASSWORD			       --登录密码
    ,CREATE_DATE			   --创建日期
    ,UPDATE_DATE			   --修改日期
    ,AGENT_ID			       --agentid
    ,BUSINESS_GROUP_CODE --业务组编号（参数配置）
    ,ACCOUNT_CODE			   --用户账号
    ,EMP_CODE			       --员工编号
    ,SKILL_GROUP_CODE		 --技能组编号（参数配置）
    ,PWD_LAPSE_DATE			 --密码过期时间
    ,CREATER_CODE			   --创建者工号
    ,UPDATE_CODE			   --更新者工号
    ,OPERATOR_TYPE_CODE	 --用户类型编码（参数配置）
    ,ACCOUNT_LOCK			   --锁定用户 0:locked  1:unlock
    ,AWORKSTS			       --工作状态
    ,TSWORKSTSTIME			 --工作状态开始时间
    ,LOGIN_NUM			     --是否首次登录 (新建用户初始值为1)
    ,RESET_PASSWORD_FLAG --是否重置密码 (0:未重置  1:重置)新增用户为1
    ,LOCK_NUM			       --登陆失败次数
    ,LOCK_TIME			     --登陆时间
    ,LOGIN_SERVER			   --签入地址(priserver 代表主中心 bakserver 备中心)
    ,MEDIA_TYPE			     --多媒体类型（chat代表在线video视频media多媒体）
    ,MEDIA_PIC			     --视频客服不开摄像头背景图
    ,TONE_SWITCH			   --在线客服铃声提醒开关
    ,PRO_BANK_TONE_SWITCH			--流程银行提示音提醒开关
    ,SOFTPHONE_TYPE			 --软电话类型（websocket/applet:接入方式为websocket/applet）
    ,TRACKING_REMIND_TONE_SWITCH			--小结继续跟进提示音提醒开关
    ,START_DT			       --开始时间
    ,END_DT			         --结束时间
    ,ID_MARK			       --增删标志
    FROM IOL.V_CCDB_SYS_ACCOUNT_INFO --视图-用户信息表
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_CCDB_SYS_ACCOUNT_INFO;
/

