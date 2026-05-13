CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_DEBT_PAYMENT_LIST(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：抵债资产信息表
  **存储过程名称：    ETL_O_IOL_ICMS_DEBT_PAYMENT_LIST
  **存储过程创建日期：20251017
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251017    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_DEBT_PAYMENT_LIST'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_DEBT_PAYMENT_LIST';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-抵债资产信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_DEBT_PAYMENT_LIST NOLOGGING 
  (          SERIALNO             --流水号
            ,RELATIVESERIALNO     --关联流水号
            ,CUSTOMERID           --客户编号
            ,CUSTOMERNAME         --客户名称
            ,DEBTREPAYASSETID     --抵债资产编号
            ,DEBTREPAYASSETNAME   --抵债资产名称
            ,DEBTREPAYSUM         --抵扣债权金额
            ,DEBTOFFSETAMOUNT     --抵债金额
            ,RECEIVEDATE          --抵债日期
            ,DEBTREPAYASSETTYPE   --抵债资产类型(code:DebtRepaymentType)
            ,DEBTREPAYMENTTYPE    --抵债类型(code:DebtRepayAssetType)
            ,STATUS               --处理状态(code:CollectResult)
            ,AMOUNT               --数量
            ,STOCKCODE            --股票代码/权证号
            ,PROPERTYLOCATION     --房产位置
            ,REMARK               --备注
            ,INPUTUSERID          --登记人
            ,INPUTORGID           --登记机构
            ,INPUTDATE            --登记日期
            ,OPERATEUSERID        --经办客户经理
            ,OPERATEORGID         --经办客户经理所属机构
            ,OPERATEDATE          --经办时间
            ,UPDATEUSERID         --更新人
            ,UPDATEORGID          --更新机构
            ,UPDATEDATE           --更新日期
            ,PUTOUTORGID          --账务机构
            ,ORIGINALTAXFEES      --原相关税费
            ,LASTEVALTIME         --估值日期
            ,START_DT             --开始时间
            ,END_DT               --结束时间
            ,ID_MARK              --增删标志
            ,ETL_TIMESTAMP        --ETL处理时间戳
    )
    SELECT
             SERIALNO             --流水号
            ,RELATIVESERIALNO     --关联流水号
            ,CUSTOMERID           --客户编号
            ,CUSTOMERNAME         --客户名称
            ,DEBTREPAYASSETID     --抵债资产编号
            ,DEBTREPAYASSETNAME   --抵债资产名称
            ,DEBTREPAYSUM         --抵扣债权金额
            ,DEBTOFFSETAMOUNT     --抵债金额
            ,RECEIVEDATE          --抵债日期
            ,DEBTREPAYASSETTYPE   --抵债资产类型(code:DebtRepaymentType)
            ,DEBTREPAYMENTTYPE    --抵债类型(code:DebtRepayAssetType)
            ,STATUS               --处理状态(code:CollectResult)
            ,AMOUNT               --数量
            ,STOCKCODE            --股票代码/权证号
            ,PROPERTYLOCATION     --房产位置
            ,REMARK               --备注
            ,INPUTUSERID          --登记人
            ,INPUTORGID           --登记机构
            ,INPUTDATE            --登记日期
            ,OPERATEUSERID        --经办客户经理
            ,OPERATEORGID         --经办客户经理所属机构
            ,OPERATEDATE          --经办时间
            ,UPDATEUSERID         --更新人
            ,UPDATEORGID          --更新机构
            ,UPDATEDATE           --更新日期
            ,PUTOUTORGID          --账务机构
            ,ORIGINALTAXFEES      --原相关税费
            ,LASTEVALTIME         --估值日期
            ,START_DT             --开始时间
            ,END_DT               --结束时间
            ,ID_MARK              --增删标志
            ,ETL_TIMESTAMP        --ETL处理时间戳
  FROM IOL.V_ICMS_DEBT_PAYMENT_LIST --视图-抵债资产信息表
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_DEBT_PAYMENT_LIST', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_DEBT_PAYMENT_LIST;
/

