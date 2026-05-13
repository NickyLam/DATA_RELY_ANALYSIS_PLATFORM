CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CRSS_CODE_LIBRARY(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CRSS_CODE_LIBRARY
  *  功能描述：引入信贷代码表
  *  创建日期：20220511
  *  开发人员：易梓林
  *  来源表： IOL.V_CRSS_CODE_LIBRARY
  *  目标表： O_IOL_CRSS_CODE_LIBRARY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220511  易梓林 首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CRSS_CODE_LIBRARY'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CRSS_CODE_LIBRARY'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CRSS_CODE_LIBRARY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-引入信贷代码表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CRSS_CODE_LIBRARY NOLOGGING
    (CODENO
    ,ITEMNO
    ,ITEMNAME
    ,BANKNO
    ,SORTNO
    ,ISINUSE
    ,ITEMDESCRIBE
    ,ITEMATTRIBUTE
    ,RELATIVECODE
    ,ATTRIBUTE1
    ,ATTRIBUTE2
    ,ATTRIBUTE3
    ,ATTRIBUTE4
    ,ATTRIBUTE5
    ,ATTRIBUTE6
    ,ATTRIBUTE7
    ,ATTRIBUTE8
    ,INPUTUSER
    ,INPUTORG
    ,INPUTTIME
    ,UPDATEUSER
    ,UPDATETIME
    ,REMARK
    ,HELPTEXT
    ,GUARANTYINFO
    ,REMARK2
    ,DSCODE
    ,START_DT
    ,END_DT
    ,ID_MARK
    )
  SELECT /*+PARALLEL*/
         CODENO
        ,ITEMNO
        ,ITEMNAME
        ,BANKNO
        ,SORTNO
        ,ISINUSE
        ,ITEMDESCRIBE
        ,ITEMATTRIBUTE
        ,RELATIVECODE
        ,ATTRIBUTE1
        ,ATTRIBUTE2
        ,ATTRIBUTE3
        ,ATTRIBUTE4
        ,ATTRIBUTE5
        ,ATTRIBUTE6
        ,ATTRIBUTE7
        ,ATTRIBUTE8
        ,INPUTUSER
        ,INPUTORG
        ,INPUTTIME
        ,UPDATEUSER
        ,UPDATETIME
        ,REMARK
        ,HELPTEXT
        ,GUARANTYINFO
        ,REMARK2
        ,DSCODE
        ,START_DT
        ,END_DT
        ,ID_MARK
    FROM IOL.V_CRSS_CODE_LIBRARY --引入信贷代码表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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

END ETL_O_IOL_CRSS_CODE_LIBRARY;
/

