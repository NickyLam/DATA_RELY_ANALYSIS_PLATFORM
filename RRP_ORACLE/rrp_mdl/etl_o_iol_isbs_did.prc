CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_DID(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：国内证买方信用证业务信息存放短字节
  **存储过程名称：    ETL_O_IOL_ISBS_DID
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_DID'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_DID';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-国内证买方信用证业务信息存放短字节';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_DID NOLOGGING 
  (          INR      
             ,OWNREF      
             ,NAM      
             ,OWNUSR      
             ,CREDAT      
             ,OPNDAT      
             ,CLSDAT      
             ,ADVNAM      
             ,ADVREF      
             ,AMEDAT      
             ,AMENBR      
             ,APLNAM      
             ,APLREF      
             ,AVBBY      
             ,AVBWTH      
             ,BENNAM      
             ,BENREF      
             ,CHATO      
             ,CNFDET      
             ,EXPDAT      
             ,EXPPLC      
             ,LCRTYP      
             ,NOMSPC      
             ,NOMTOP      
             ,NOMTON      
             ,PREADVDT      
             ,RMBACT      
             ,RMBCHA      
             ,RMBFLG      
             ,SHPDAT      
             ,SHPFRO      
             ,PORLOA      
             ,PORDIS      
             ,SHPPAR      
             ,SHPTO      
             ,SHPTRS      
             ,STACTY      
             ,STAGOD      
             ,UTLNBR      
             ,ADVNBR      
             ,REDCLSFLG      
             ,VER      
             ,LCITYP      
             ,B2BINR      
             ,B2BREF      
             ,REVNBR      
             ,REVTIMES      
             ,REVFLG      
             ,REVAWAPL      
             ,REVDAT      
             ,REVCUM      
             ,REVTYP      
             ,INITPTY      
             ,RESFLG      
             ,APPRUL      
             ,APPRULRMB      
             ,APPRULTXT      
             ,AUTDAT      
             ,ETYEXTKEY      
             ,TENMAXDAY      
             ,BRANCHINR      
             ,BCHKEYINR      
             ,DECFLG      
             ,CSHPCT      
             ,ISSTYP      
             ,FINCOD      
             ,FINTYP      
             ,RELCSHPCT      
             ,JJH      
             ,GUAFLG      
             ,TRATYP      
             ,OPNAMO      
             ,AMEFLG      
             ,CRETYP      
             ,TADTYP      
             ,SHPINS      
             ,SERMOD      
             ,SERFRO      
             ,COMFLG      
             ,INSDAT      
             ,CONTRACTNO      
             ,NEGFLG      
             ,ELCFLG      --通过电证标志
             ,CONCUR      --合同币种
             ,CONAMT      --合同金额
             ,REJAME      --拒绝修改标志
             ,CANTYP      --闭卷类型
             ,REJFLG      --拒绝通知标志
             ,TZREF       --通知行编号
             ,NOMTOP1     --上浮金额（elcs）
             ,NOMTON1     --下浮金额（elcs）
             ,ZYTYP       --质押类型
             ,PRODUCTNAME --货物名称
             ,START_DT    --开始时间
             ,END_DT      --结束时间
             ,ID_MARK     --增删标志
             ,ETL_TIMESTAMP    --ETL处理时间戳
    )
  SELECT 
           INR      
             ,OWNREF      
             ,NAM      
             ,OWNUSR      
             ,CREDAT      
             ,OPNDAT      
             ,CLSDAT      
             ,ADVNAM      
             ,ADVREF      
             ,AMEDAT      
             ,AMENBR      
             ,APLNAM      
             ,APLREF      
             ,AVBBY      
             ,AVBWTH      
             ,BENNAM      
             ,BENREF      
             ,CHATO      
             ,CNFDET      
             ,EXPDAT      
             ,EXPPLC      
             ,LCRTYP      
             ,NOMSPC      
             ,NOMTOP      
             ,NOMTON      
             ,PREADVDT      
             ,RMBACT      
             ,RMBCHA      
             ,RMBFLG      
             ,SHPDAT      
             ,SHPFRO      
             ,PORLOA      
             ,PORDIS      
             ,SHPPAR      
             ,SHPTO      
             ,SHPTRS      
             ,STACTY      
             ,STAGOD      
             ,UTLNBR      
             ,ADVNBR      
             ,REDCLSFLG      
             ,VER      
             ,LCITYP      
             ,B2BINR      
             ,B2BREF      
             ,REVNBR      
             ,REVTIMES      
             ,REVFLG      
             ,REVAWAPL      
             ,REVDAT      
             ,REVCUM      
             ,REVTYP      
             ,INITPTY      
             ,RESFLG      
             ,APPRUL      
             ,APPRULRMB      
             ,APPRULTXT      
             ,AUTDAT      
             ,ETYEXTKEY      
             ,TENMAXDAY      
             ,BRANCHINR      
             ,BCHKEYINR      
             ,DECFLG      
             ,CSHPCT      
             ,ISSTYP      
             ,FINCOD      
             ,FINTYP      
             ,RELCSHPCT      
             ,JJH      
             ,GUAFLG      
             ,TRATYP      
             ,OPNAMO      
             ,AMEFLG      
             ,CRETYP      
             ,TADTYP      
             ,SHPINS      
             ,SERMOD      
             ,SERFRO      
             ,COMFLG      
             ,INSDAT      
             ,CONTRACTNO      
             ,NEGFLG      
             ,ELCFLG      --通过电证标志
             ,CONCUR      --合同币种
             ,CONAMT      --合同金额
             ,REJAME      --拒绝修改标志
             ,CANTYP      --闭卷类型
             ,REJFLG      --拒绝通知标志
             ,TZREF       --通知行编号
             ,NOMTOP1     --上浮金额（elcs）
             ,NOMTON1     --下浮金额（elcs）
             ,ZYTYP       --质押类型
             ,PRODUCTNAME --货物名称
             ,START_DT    --开始时间
             ,END_DT      --结束时间
             ,ID_MARK     --增删标志
             ,ETL_TIMESTAMP    --ETL处理时间戳
    FROM IOL.V_ISBS_DID --视图-国内证买方信用证业务信息存放短字节
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_DID', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ISBS_DID;
/

