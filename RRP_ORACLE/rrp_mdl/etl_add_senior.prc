CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_ADD_SENIOR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_ADD_SENIOR
  *  功能描述：银行高管补录表加载数据
  *  创建日期：20250730
  *  开发人员：LTJ
  *  目标表：ADD_SENIOR 银行高管补录表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20250730  LTJ        创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_STEP_DESC VARCHAR2(300);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_FREQ_FLAG VARCHAR2(10);               --跑批频率标识
  V_RPT_NO    VARCHAR2(30) := 'ADD_SENIOR';     --表名
  V_PROC_NAME VARCHAR2(30) := 'ETL_ADD_SENIOR'; --程序名称
  V_YESTADAY  VARCHAR2(8);                      --上日
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := TO_CHAR(I_P_DATE); --获取跑批日期
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.ADD_SENIOR;  --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '补录表数据回流';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ADD_SENIOR
    (CUST_ID       --客户号
    ,CUST_NAME     --客户名称
    ,JOB           --职务
    ,GENDER        --性别
    ,OPEN_ACC_FLG  --是否开户
    ,DATA_DT       --数据时间
    ,ID_CARD       --证件号码
    ,ID_CARD2      --证件号码2
    )
  SELECT CUST_ID            --客户号
        ,CUST_NAME          --客户名称
        ,JOB                --职务
        ,GENDER             --性别
        ,OPEN_ACC_FLG       --是否开户
        ,V_P_DATE           --数据时间
        ,ID_CARD            --证件号码
        ,ID_CARD2           --证件号码2
    FROM RRP_MRPT_APP.MRPT_SG037@LINK_RRP A  --银行高管补录表
   WHERE A.DATA_DT = V_YESTADAY
   ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_ADD_SENIOR;
/

