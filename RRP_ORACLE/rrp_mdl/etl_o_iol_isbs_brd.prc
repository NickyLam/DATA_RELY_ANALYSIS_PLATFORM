CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_BRD(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：进口信用证下单据业务信息存放短字节内容
  **存储过程名称：    ETL_O_IOL_ISBS_BRD
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_BRD'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_BRD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-进口信用证下单据业务信息存放短字节内容';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_BRD NOLOGGING 
  (          INR         --进口单据INR号
            ,OWNREF      --来单参考号
            ,NAM         --来单名称
            ,OWNUSR      --负责人
            ,CREDAT      --寄单日期
            ,OPNDAT      --开证日期
            ,CLSDAT      --结束日期
            ,PNTTYP      --父类类型
            ,PNTINR      --父类交易INR号
            ,PREDAT      --寄单行寄单日期
            ,SHPDAT      --最迟装运日期
            ,SPDDAT      --过期日期
            ,TOTDAT      --总天数
            ,ADVDAT      --通知日期
            ,MATDAT      --效期
            ,RCVDAT      --提单收到日期
            ,DISDAT      --不符点通知日期
            ,DOCFLG      --到单标志
            ,REJFLG      --拒付标志
            ,APPROVCOD   --是否批准
            ,RELGODFLG   --货物授权标志
            ,RELGODDAT   --授权日期
            ,TRPDOCNUM   --传送单据数目
            ,FREPAYFLG   --免付款交单标志
            ,VER         --版本号
            ,ADVTYP      --接收的的通知类型
            ,RELTYP      --授权类型
            ,EXPDAT      --提货担保开立日期
            ,RTOAPLFLG   --货物授权申请人标志
            ,TRPDOCTYP   --提单类型
            ,TRADAT      --提单日期
            ,TRAMOD      --运输类型
            ,MATTXTFLG   --多期限标志
            ,DSCINSFLG   --单据差异标志
            ,DOCPRBROL   --提交角色
            ,DOCSTA      --单据类型
            ,IGNDISFLG   --忽略不符点标志
            ,TOTCUR      --付款总金额币种
            ,TOTAMT      --付款总金额
            ,PAYROL      --付款人
            ,ACPNOWFLG   --承兑标志
            ,ORDDAT      --来单日期
            ,ADVDOCFLG   --退单标志
            ,ETYEXTKEY   --实体组
            ,BCHKEYINR   --经办机构号
            ,BRANCHINR   --所属机构号
            ,NGRCOD      --货物代码
            ,SGDINR      --提货担保inr
            ,BLNUM       --提单号
            ,SHGREF      --提货担保参考号
            ,FINCOD      --借据号
            ,FINTYP      --业务品种
            ,NRAFLG      --NRA付款标志
            ,QSQDBH      --清算渠道
            ,INVNUM      --
            ,START_DT    --开始时间
            ,END_DT      --结束时间
            ,ID_MARK     --增删标志
            ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT 
            INR         --进口单据INR号
            ,OWNREF      --来单参考号
            ,NAM         --来单名称
            ,OWNUSR      --负责人
            ,CREDAT      --寄单日期
            ,OPNDAT      --开证日期
            ,CLSDAT      --结束日期
            ,PNTTYP      --父类类型
            ,PNTINR      --父类交易INR号
            ,PREDAT      --寄单行寄单日期
            ,SHPDAT      --最迟装运日期
            ,SPDDAT      --过期日期
            ,TOTDAT      --总天数
            ,ADVDAT      --通知日期
            ,MATDAT      --效期
            ,RCVDAT      --提单收到日期
            ,DISDAT      --不符点通知日期
            ,DOCFLG      --到单标志
            ,REJFLG      --拒付标志
            ,APPROVCOD   --是否批准
            ,RELGODFLG   --货物授权标志
            ,RELGODDAT   --授权日期
            ,TRPDOCNUM   --传送单据数目
            ,FREPAYFLG   --免付款交单标志
            ,VER         --版本号
            ,ADVTYP      --接收的的通知类型
            ,RELTYP      --授权类型
            ,EXPDAT      --提货担保开立日期
            ,RTOAPLFLG   --货物授权申请人标志
            ,TRPDOCTYP   --提单类型
            ,TRADAT      --提单日期
            ,TRAMOD      --运输类型
            ,MATTXTFLG   --多期限标志
            ,DSCINSFLG   --单据差异标志
            ,DOCPRBROL   --提交角色
            ,DOCSTA      --单据类型
            ,IGNDISFLG   --忽略不符点标志
            ,TOTCUR      --付款总金额币种
            ,TOTAMT      --付款总金额
            ,PAYROL      --付款人
            ,ACPNOWFLG   --承兑标志
            ,ORDDAT      --来单日期
            ,ADVDOCFLG   --退单标志
            ,ETYEXTKEY   --实体组
            ,BCHKEYINR   --经办机构号
            ,BRANCHINR   --所属机构号
            ,NGRCOD      --货物代码
            ,SGDINR      --提货担保inr
            ,BLNUM       --提单号
            ,SHGREF      --提货担保参考号
            ,FINCOD      --借据号
            ,FINTYP      --业务品种
            ,NRAFLG      --NRA付款标志
            ,QSQDBH      --清算渠道
            ,INVNUM      --
            ,START_DT    --开始时间
            ,END_DT      --结束时间
            ,ID_MARK     --增删标志
            ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ISBS_BRD --视图-进口信用证下单据业务信息存放短字节内容
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_BRD', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ISBS_BRD;
/

