CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IBANK_DEP_ACCT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：同业存放账户信息
  **存储过程名称：    ETL_O_ICL_CMM_IBANK_DEP_ACCT_INFO
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_ICL_CMM_IBANK_DEP_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IBANK_DEP_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业存放账户信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_IBANK_DEP_ACCT_INFO NOLOGGING 
  (          ETL_DT                         --数据日期
            ,LP_ID                          --法人编号
            ,ACCT_ID                        --账户编号
            ,CUST_ACCT_ID                   --客户账户编号
            ,CUST_SUB_ACCT_NUM              --客户账户子户号
            ,OPEN_BANK_NO                   --开户行行号
            ,OPEN_BANK_NAME                 --开户行名称
            ,CONT_ID                        --合约编号
            ,INT_SET_WAY_CD                 --结息方式代码
            ,INT_ACCR_WAY_CD                --计息方式代码
            ,ACCT_STATUS_CD                 --账户状态代码
            ,SAV_TYPE_CD                    --储种代码
            ,STD_PROD_ID                    --标准产品编号
            ,DEP_TERM                       --存期
            ,DEP_TERM_TENOR_TYPE_CD         --存期期限类型代码
            ,DEP_TERM_DAYS                  --存期天数
            ,SEG_INT_ACCR_FLG               --分段计息标志
            ,ONL_BUS_FLG                    --线上业务标志
            ,LAST_INT_SET_DT                --上次结息日期
            ,NEXT_INT_SET_DT                --下次结息日期
            ,EXEC_INT_RAT                   --执行利率
            ,NOMAL_INT_RAT                  --正常利率
            ,OVDUE_INT_RAT                  --逾期利率
            ,PART_UNEXP_DRAW_INT_RAT        --部分提前支取利率
            ,PART_UNEXP_DRAW_SURP_INT_RAT   --部分提前支取剩余部分利率
            ,ADVD_WDRAW_FLG                 --可提前支取标志
            ,EARLIEST_ADVD_WDRAW_DT         --最早可提前支取日期
            ,JOB_CD                         --任务代码
            ,ETL_TIMESTAMP                  --数据处理时间
    )
  SELECT 
             ETL_DT                         --数据日期
            ,LP_ID                          --法人编号
            ,ACCT_ID                        --账户编号
            ,CUST_ACCT_ID                   --客户账户编号
            ,CUST_SUB_ACCT_NUM              --客户账户子户号
            ,OPEN_BANK_NO                   --开户行行号
            ,OPEN_BANK_NAME                 --开户行名称
            ,CONT_ID                        --合约编号
            ,INT_SET_WAY_CD                 --结息方式代码
            ,INT_ACCR_WAY_CD                --计息方式代码
            ,ACCT_STATUS_CD                 --账户状态代码
            ,SAV_TYPE_CD                    --储种代码
            ,STD_PROD_ID                    --标准产品编号
            ,DEP_TERM                       --存期
            ,DEP_TERM_TENOR_TYPE_CD         --存期期限类型代码
            ,DEP_TERM_DAYS                  --存期天数
            ,SEG_INT_ACCR_FLG               --分段计息标志
            ,ONL_BUS_FLG                    --线上业务标志
            ,LAST_INT_SET_DT                --上次结息日期
            ,NEXT_INT_SET_DT                --下次结息日期
            ,EXEC_INT_RAT                   --执行利率
            ,NOMAL_INT_RAT                  --正常利率
            ,OVDUE_INT_RAT                  --逾期利率
            ,PART_UNEXP_DRAW_INT_RAT        --部分提前支取利率
            ,PART_UNEXP_DRAW_SURP_INT_RAT   --部分提前支取剩余部分利率
            ,ADVD_WDRAW_FLG                 --可提前支取标志
            ,EARLIEST_ADVD_WDRAW_DT         --最早可提前支取日期
            ,JOB_CD                         --任务代码
            ,ETL_TIMESTAMP                  --数据处理时间
    FROM ICL.V_CMM_IBANK_DEP_ACCT_INFO --视图-同业存放账户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;

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
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_IBANK_DEP_ACCT_INFO', '', O_ERRCODE); --表分析
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

END ETL_O_ICL_CMM_IBANK_DEP_ACCT_INFO;
/

