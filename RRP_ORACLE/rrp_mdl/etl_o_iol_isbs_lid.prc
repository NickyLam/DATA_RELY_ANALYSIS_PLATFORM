CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_LID(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：进口信用证业务信息(存放短字节)
  **存储过程名称：    ETL_O_IOL_ISBS_LID
  **存储过程创建日期：20251215
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251215    YJY        创建  
  *  20251222    YJY        新增字段
  *  20251225    YJY        新增字段
  ***************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_LID'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_LID';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-进口信用证业务信息(存放短字节)';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_LID NOLOGGING 
  (        INR          --进口信用证ID号
           ,OWNREF      --参考号
           ,NAM         --标识交易的外部显示名称
           ,OWNUSR      --参考号
           ,CREDAT      --开证或注册日期
           ,OPNDAT      --开证日期
           ,CLSDAT      --结束日期
           ,ADVNAM      --通知行名称
           ,ADVREF      --通知行参考号
           ,AMEDAT      --上次修改日期
           ,AMENBR      --修改次数
           ,APLNAM      --申请人名称
           ,APLREF      --申请人参考号
           ,AVBBY       --指定方式
           ,AVBWTH      --指定方式
           ,BENNAM      --收益人名字
           ,BENREF      --受益人参考号
           ,CHATO       --费用流向
           ,CNFDET      --保兑状态
           ,EXPDAT      --效期，指定信用证的效期
           ,EXPPLC      --交单地点
           ,LCRTYP      --信用证的格式
           ,NOMSPC      --规格数量
           ,NOMTOP      --溢短装
           ,NOMTON      --溢短装
           ,PREADVDT    --预通知日期
           ,RMBACT      --偿付行用户帐号
           ,RMBCHA      --偿付行费用
           ,RMBFLG      --偿付标志
           ,SHPDAT      --装船日期
           ,SHPFRO      --装船地点
           ,PORLOA      --装货港
           ,PORDIS      --卸货港
           ,SHPPAR      --分装
           ,SHPTO       --运货地点
           ,SHPTRS      --转载[SHPTRS]
           ,STACTY      --国家代码
           ,STAGOD      --货物代码
           ,UTLNBR      --利用数目
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
           ,DFLG      
           ,GUAFLG      
           ,TRATYP      
           ,OPNAMO      
           ,AMEFLG      
           ,CRETYP      
           ,TADTYP      
           ,SHPINS      
           ,SERMOD      
           ,SERFRO      
           ,NEGFLG      
           ,COMFLG      
           ,INSDAT      
           ,SHPPARS18      
           ,SHPTRSS18      
           ,SPCBENFLG      
           ,SPCRCBFLG      
           ,PREPERTXTS18      
           ,PREPERS18      
           ,START_DT     --开始时间
           ,END_DT       --结束时间
           ,ID_MARK      --增删标志
           ,ETL_TIMESTAMP  --ETL处理时间戳
           ,ZYTYP      
           ,PRODUCTNAME  --产品名称  ADD BY YJY 20251222
           ,CONTRACTNO   --合同编号  ADD BY YJY 20251225
           ,CONCUR       --合同币种  ADD BY YJY 20251225
           ,CONAMT       --合同金额  ADD BY YJY 20251225
    )
  SELECT 
            INR         --进口信用证ID号
           ,OWNREF      --参考号
           ,NAM         --标识交易的外部显示名称
           ,OWNUSR      --参考号
           ,CREDAT      --开证或注册日期
           ,OPNDAT      --开证日期
           ,CLSDAT      --结束日期
           ,ADVNAM      --通知行名称
           ,ADVREF      --通知行参考号
           ,AMEDAT      --上次修改日期
           ,AMENBR      --修改次数
           ,APLNAM      --申请人名称
           ,APLREF      --申请人参考号
           ,AVBBY       --指定方式
           ,AVBWTH      --指定方式
           ,BENNAM      --收益人名字
           ,BENREF      --受益人参考号
           ,CHATO       --费用流向
           ,CNFDET      --保兑状态
           ,EXPDAT      --效期，指定信用证的效期
           ,EXPPLC      --交单地点
           ,LCRTYP      --信用证的格式
           ,NOMSPC      --规格数量
           ,NOMTOP      --溢短装
           ,NOMTON      --溢短装
           ,PREADVDT    --预通知日期
           ,RMBACT      --偿付行用户帐号
           ,RMBCHA      --偿付行费用
           ,RMBFLG      --偿付标志
           ,SHPDAT      --装船日期
           ,SHPFRO      --装船地点
           ,PORLOA      --装货港
           ,PORDIS      --卸货港
           ,SHPPAR      --分装
           ,SHPTO       --运货地点
           ,SHPTRS      --转载[SHPTRS]
           ,STACTY      --国家代码
           ,STAGOD      --货物代码
           ,UTLNBR      --利用数目
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
           ,DFLG      
           ,GUAFLG      
           ,TRATYP      
           ,OPNAMO      
           ,AMEFLG      
           ,CRETYP      
           ,TADTYP      
           ,SHPINS      
           ,SERMOD      
           ,SERFRO      
           ,NEGFLG      
           ,COMFLG      
           ,INSDAT      
           ,SHPPARS18      
           ,SHPTRSS18      
           ,SPCBENFLG      
           ,SPCRCBFLG      
           ,PREPERTXTS18      
           ,PREPERS18      
           ,START_DT     --开始时间
           ,END_DT       --结束时间
           ,ID_MARK      --增删标志
           ,ETL_TIMESTAMP  --ETL处理时间戳
           ,ZYTYP      
           ,PRODUCTNAME  --产品名称  ADD BY YJY 20251222
           ,CONTRACTNO   --合同编号  ADD BY YJY 20251225
           ,CONCUR       --合同币种  ADD BY YJY 20251225
           ,CONAMT       --合同金额  ADD BY YJY 20251225
    FROM IOL.V_ISBS_LID --视图-进口信用证业务信息(存放短字节)
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_LID', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ISBS_LID;
/

