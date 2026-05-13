CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CRSS_CAPITALPURPOSE(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CRSS_CAPITALPURPOSE
  *  功能描述：资金用途
  *  创建日期：20220325
  *  开发人员：易梓林
  *  来源表： IOL.V_CRSS_CAPITALPURPOSE
  *  目标表： O_IOL_CRSS_CAPITALPURPOSE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220325  易梓林  首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CRSS_CAPITALPURPOSE'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CRSS_CAPITALPURPOSE'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CRSS_CAPITALPURPOSE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资金用途';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CRSS_CAPITALPURPOSE NOLOGGING
    (SERIALNO               --流水号
    ,OBJECTNO               --对象号
    ,PAYMETHOD              --支付方式
    ,PAYEE                  --收款人
    ,TRANSSUM               --转款金额
    ,PAYMENTTIME            --支付时间
    ,ACTUALPURPOSE          --实际用途
    ,REMARK                 --备注
    ,ISOK                   --是否符合合同约定
    ,INPUTUSERID            --登记人
    ,INPUTORGID             --登记机构
    ,INPUTDATE              --登记日期
    ,UPDATEDATE             --更新日期
    ,PAYMENTNO              --支付流水号
    ,OVERSEEAPPLYSERIALNO   --监测申请流水号
    ,OVERSEEOBJECTTYPE      --监测对象类型
    ,START_DT               --开始时间
    ,END_DT                 --结束时间
    ,ID_MARK                --增删标志
    )
  SELECT /*+PARALLEL*/
         SERIALNO               --流水号
        ,OBJECTNO               --对象号
        ,PAYMETHOD              --支付方式
        ,PAYEE                  --收款人
        ,TRANSSUM               --转款金额
        ,PAYMENTTIME            --支付时间
        ,ACTUALPURPOSE          --实际用途
        ,REMARK                 --备注
        ,ISOK                   --是否符合合同约定
        ,INPUTUSERID            --登记人
        ,INPUTORGID             --登记机构
        ,INPUTDATE              --登记日期
        ,UPDATEDATE             --更新日期
        ,PAYMENTNO              --支付流水号
        ,OVERSEEAPPLYSERIALNO   --监测申请流水号
        ,OVERSEEOBJECTTYPE      --监测对象类型
        ,START_DT               --开始时间
        ,END_DT                 --结束时间
        ,ID_MARK                --增删标志
    FROM IOL.V_CRSS_CAPITALPURPOSE  --资金用途表_视图
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

END ETL_O_IOL_CRSS_CAPITALPURPOSE;
/

