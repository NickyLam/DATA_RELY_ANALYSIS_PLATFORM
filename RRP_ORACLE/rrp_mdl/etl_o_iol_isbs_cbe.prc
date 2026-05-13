CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_CBE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：CBB对应的发生额信息
  **存储过程名称：    ETL_O_IOL_ISBS_CBE
  **存储过程创建日期：20251224
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251224    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_CBE'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_CBE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-CBB对应的发生额信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_CBE NOLOGGING 
  (        INR          --唯一ID
           ,OBJTYP      --对象类型
           ,OBJINR      --对象INR
           ,EXTID       --外部金额类型
           ,CBT         --金额类型
           ,TRNTYP      --交易表名
           ,TRNINR      --交易表的INR
           ,DAT         --发生日期
           ,CUR         --币种
           ,AMT         --金额
           ,RELFLG      --授权标志
           ,CREDAT      --创建日期
           ,XRFCUR      --折算币种
           ,XRFAMT      --折算后的金额
           ,NAM         --描述
           ,ACC         --账号1
           ,ACC2        --账号2
           ,OPTDAT      --其他可选日期
           ,GLEDAT      --记账日期
           ,NOMPCT      --保证金应收比例
           ,CHKFLG      --检查标志
           ,START_DT    --开始时间
           ,END_DT      --结束时间
           ,ID_MARK     --增删标志
           ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT 
           INR          --唯一ID
           ,OBJTYP      --对象类型
           ,OBJINR      --对象INR
           ,EXTID       --外部金额类型
           ,CBT         --金额类型
           ,TRNTYP      --交易表名
           ,TRNINR      --交易表的INR
           ,DAT         --发生日期
           ,CUR         --币种
           ,AMT         --金额
           ,RELFLG      --授权标志
           ,CREDAT      --创建日期
           ,XRFCUR      --折算币种
           ,XRFAMT      --折算后的金额
           ,NAM         --描述
           ,ACC         --账号1
           ,ACC2        --账号2
           ,OPTDAT      --其他可选日期
           ,GLEDAT      --记账日期
           ,NOMPCT      --保证金应收比例
           ,CHKFLG      --检查标志
           ,START_DT    --开始时间
           ,END_DT      --结束时间
           ,ID_MARK     --增删标志
           ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ISBS_CBE --视图-CBB对应的发生额信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_CBE', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ISBS_CBE;
/

