CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_FEP(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：费用明细
  **存储过程名称：    ETL_O_IOL_ISBS_FEP
  **存储过程创建日期：20251223
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251223    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_FEP'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_FEP';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-费用明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_FEP NOLOGGING 
  (           INR          --内部唯一ID
             ,FEECOD       --费用代码
             ,OBJTYP       --对象表名称
             ,OBJINR       --对象表INR
             ,RELOBJTYP    --相关对象类型
             ,RELOBJINR    --相关对象的INR
             ,EXTKEY       --外部可见名
             ,NAM          --费用文本信息
             ,RELCUR       --相关币种
             ,RELAMT       --相关金额
             ,DAT1         --费用收取起始日
             ,DAT2         --费用收取截止日
             ,MODFLG       --修改标志（费用变化状态）
             ,UNT          --费用收取的份数
             ,UNTAMT       --每份费用的金额
             ,RATCAL       --计算使用的费率
             ,RAT          --费率
             ,MINMAXFLG    --最低最高费率使用标示
             ,CUR          --费用币种
             ,AMT          --费用金额
             ,XRFCUR       --费用折算后的币种
             ,XRFAMT       --费用折算后的金额
             ,FEEACC       --费用入账的账号
             ,INFDETSTM    --费用计算细节
             ,PTYINR       --支付实体的INR
             ,SRCTRNINR    --创建或者修改该费用的交易的TRN表INR
             ,SRCDAT       --创建日期
             ,RPLTRNINR    --取代交易的TRNINR
             ,RPLDAT       --取代日期
             ,DONTRNINR    --结算费用交易的TRN表INR
             ,DONDAT       --结算日期
             ,ADVTRNINR    --通知费用交易的TRN表INR
             ,ADVDAT       --通知日期
             ,ACRINR       --循环计算的INR
             ,SEPINR       --对应的临时结算的INR
             ,ROL          --角色
             ,OGIAMT       --应收金额
             ,DCTAMT       --优惠金额
             ,AMOFLG      
             ,AMOREF      
             ,AMOSTA      
             ,START_DT      --开始时间
             ,END_DT        --结束时间
             ,ID_MARK       --增删标志
             ,ETL_TIMESTAMP --ETL处理时间戳
    )
  SELECT 
           INR          --内部唯一ID
             ,FEECOD       --费用代码
             ,OBJTYP       --对象表名称
             ,OBJINR       --对象表INR
             ,RELOBJTYP    --相关对象类型
             ,RELOBJINR    --相关对象的INR
             ,EXTKEY       --外部可见名
             ,NAM          --费用文本信息
             ,RELCUR       --相关币种
             ,RELAMT       --相关金额
             ,DAT1         --费用收取起始日
             ,DAT2         --费用收取截止日
             ,MODFLG       --修改标志（费用变化状态）
             ,UNT          --费用收取的份数
             ,UNTAMT       --每份费用的金额
             ,RATCAL       --计算使用的费率
             ,RAT          --费率
             ,MINMAXFLG    --最低最高费率使用标示
             ,CUR          --费用币种
             ,AMT          --费用金额
             ,XRFCUR       --费用折算后的币种
             ,XRFAMT       --费用折算后的金额
             ,FEEACC       --费用入账的账号
             ,INFDETSTM    --费用计算细节
             ,PTYINR       --支付实体的INR
             ,SRCTRNINR    --创建或者修改该费用的交易的TRN表INR
             ,SRCDAT       --创建日期
             ,RPLTRNINR    --取代交易的TRNINR
             ,RPLDAT       --取代日期
             ,DONTRNINR    --结算费用交易的TRN表INR
             ,DONDAT       --结算日期
             ,ADVTRNINR    --通知费用交易的TRN表INR
             ,ADVDAT       --通知日期
             ,ACRINR       --循环计算的INR
             ,SEPINR       --对应的临时结算的INR
             ,ROL          --角色
             ,OGIAMT       --应收金额
             ,DCTAMT       --优惠金额
             ,AMOFLG      
             ,AMOREF      
             ,AMOSTA      
             ,START_DT      --开始时间
             ,END_DT        --结束时间
             ,ID_MARK       --增删标志
             ,ETL_TIMESTAMP --ETL处理时间戳
    FROM IOL.V_ISBS_FEP --视图-费用明细
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_FEP', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ISBS_FEP;
/

