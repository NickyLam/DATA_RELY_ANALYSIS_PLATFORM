CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_BUSINESS_EXTENSION(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：展期信息表展期信息表
  **存储过程名称：    ETL_O_IOL_ICMS_BUSINESS_EXTENSION
  **存储过程创建日期：20251219
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251219    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_BUSINESS_EXTENSION'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_BUSINESS_EXTENSION';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-展期信息表展期信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_BUSINESS_EXTENSION NOLOGGING 
  (        SERIALNO                 --信息流水号
          ,OCCURTIME                --发生时间
          ,TRANSACTIONFLAG          --交易标志
          ,VOUCHERNO                --凭证号码
          ,OVERDUEFLOAT             --逾期贷款利率浮动比例
          ,EXTENDFLAG               --更新标志
          ,RATEGENRE                --利率重定价
          ,OCCURDATE                --发生日期
          ,EXTENDTERMDAY            --展期期限日
          ,ORGID                    --创建机构
          ,RATEFLOAT                --(Del)浮动利率
          ,LASTMATURITY             --原到期日
          ,PUTOUTNO                 --出帐号
          ,RELATIVEDUEBILLNO        --关联借据号
          ,EXTENDTERMMONTH          --展期期限月
          ,EXTENDRATE               --展期利率
          ,LASTRATE                 --原利率
          ,EXTENSIONSUM             --展期金额
          ,OVERDUERATE              --逾期贷款执行利率
          ,CONTRACTNO               --展期合同号
          ,EXTENDTERMYEAR           --展期期限年
          ,BASERATE                 --(Del)基准利率
          ,LASTPUTOUTDATE           --展期前起始日
          ,MIGTFLAG                 --迁移标志：crsrcrilcupl
          ,BUSINESSRATE             --利率
          ,USERID                   --操作员
          ,EXTENDPUTOUTDATE         --受托支付序号
          ,BASERATETYPE             --(Del)基准利率类型
          ,LASTSUM                  --展期前金额
          ,EXTENDMATURITY           --展期后到期日
          ,REMARK                   --备注
          ,RATEADJUSTFREQUENCY      --利率调整周期
          ,RATEADJUSTTYPE           --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
          ,ORDERNO                  --预约编号
          ,NEXTSETTLEMENTDATE      
          ,EXTENDEFFECTDATE      
          ,EXTENDRATEEFFECTDATE      
          ,EXTENDREPAYPLANEFFECTDATE      
          ,NEWREPAYTYPE      
          ,FINALMERGER      
          ,REPAYDATE      
          ,REPAYCYCLE      
          ,START_DT                 --开始时间
          ,END_DT                   --结束时间
          ,ID_MARK                  --增删标志
          ,ETL_TIMESTAMP            --ETL处理时间戳
    )
  SELECT 
           SERIALNO                 --信息流水号
          ,OCCURTIME                --发生时间
          ,TRANSACTIONFLAG          --交易标志
          ,VOUCHERNO                --凭证号码
          ,OVERDUEFLOAT             --逾期贷款利率浮动比例
          ,EXTENDFLAG               --更新标志
          ,RATEGENRE                --利率重定价
          ,OCCURDATE                --发生日期
          ,EXTENDTERMDAY            --展期期限日
          ,ORGID                    --创建机构
          ,RATEFLOAT                --(Del)浮动利率
          ,LASTMATURITY             --原到期日
          ,PUTOUTNO                 --出帐号
          ,RELATIVEDUEBILLNO        --关联借据号
          ,EXTENDTERMMONTH          --展期期限月
          ,EXTENDRATE               --展期利率
          ,LASTRATE                 --原利率
          ,EXTENSIONSUM             --展期金额
          ,OVERDUERATE              --逾期贷款执行利率
          ,CONTRACTNO               --展期合同号
          ,EXTENDTERMYEAR           --展期期限年
          ,BASERATE                 --(Del)基准利率
          ,LASTPUTOUTDATE           --展期前起始日
          ,MIGTFLAG                 --迁移标志：crsrcrilcupl
          ,BUSINESSRATE             --利率
          ,USERID                   --操作员
          ,EXTENDPUTOUTDATE         --受托支付序号
          ,BASERATETYPE             --(Del)基准利率类型
          ,LASTSUM                  --展期前金额
          ,EXTENDMATURITY           --展期后到期日
          ,REMARK                   --备注
          ,RATEADJUSTFREQUENCY      --利率调整周期
          ,RATEADJUSTTYPE           --利率调整方式利率调整方式(1立即2次年初3次年对月对日4按月调5下一个还款日调整)
          ,ORDERNO                  --预约编号
          ,NEXTSETTLEMENTDATE      
          ,EXTENDEFFECTDATE      
          ,EXTENDRATEEFFECTDATE      
          ,EXTENDREPAYPLANEFFECTDATE      
          ,NEWREPAYTYPE      
          ,FINALMERGER      
          ,REPAYDATE      
          ,REPAYCYCLE      
          ,START_DT                 --开始时间
          ,END_DT                   --结束时间
          ,ID_MARK                  --增删标志
          ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_ICMS_BUSINESS_EXTENSION --视图-展期信息表展期信息表
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_BUSINESS_EXTENSION', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ICMS_BUSINESS_EXTENSION;
/

