CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_PUB_CD(I_P_DATE IN INTEGER,
                                                 O_ERRCODE OUT VARCHAR2
                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_PUB_CD
  *  功能描述：公共代码表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_REF_PUB_CD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20251103  YJY      新增有效标志
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_PUB_CD'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_PUB_CD'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_REF_PUB_CD T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_PUB_CD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-公共代码表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_PUB_CD
    (ETL_DT           --数据日期
    ,CD_ID            --代码编号
    ,CD_TAB_EN_NAME   --代码表英文名称
    ,CD_TAB_CN_DESCB  --代码表中文描述
    ,CD_VAL           --代码值
    ,CD_DESCB         --代码描述
    ,DATA_STD_FLG     --数据标准标志
    ,QUOTE_DATA_STD   --引用数据标准
    ,REMARK           --备注
    ,JOB_CD           --任务代码
    ,VALID_FLG        --有效标志   ADD BY YJY 20251103
    )
  SELECT ETL_DT          --数据日期
        ,CD_ID           --代码编号
        ,CD_TAB_EN_NAME  --代码表英文名称
        ,CD_TAB_CN_DESCB --代码表中文描述
        ,CD_VAL          --代码值
        ,CD_DESCB        --代码描述
        ,DATA_STD_FLG    --数据标准标志
        ,QUOTE_DATA_STD  --引用数据标准
        ,REMARK          --备注
        ,JOB_CD          --任务代码
        ,VALID_FLG       --有效标志   ADD BY YJY 20251103
    FROM IML.V_REF_PUB_CD;  --视图-公共代码表

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

END ETL_O_IML_REF_PUB_CD;
/

