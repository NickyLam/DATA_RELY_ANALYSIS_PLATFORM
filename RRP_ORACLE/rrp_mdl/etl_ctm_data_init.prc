CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_CTM_DATA_INIT
(
  II_DATADATE IN PLS_INTEGER, --追数开始日期
  II_RUNDATE  IN PLS_INTEGER --追数结束日期
)
/******************************
*author:hyf
*create-date:2025-07-21
*description:追数跑批处理
*modification history:
*m0.author-create_date-description
*******************************/
 IS              --处理步骤
  I_DATADATE  PLS_INTEGER;  --数据日期(数值型)YYYYMMDD
  V_START_DT  DATE;  --跑批开始日期
  V_END_DT    DATE;
  O_RETURN VARCHAR2(1000);
BEGIN
  V_START_DT := TO_DATE(II_DATADATE,'YYYYMMDD');
  V_END_DT := TO_DATE(II_RUNDATE,'YYYYMMDD');

  IF  V_START_DT <=  V_END_DT THEN
  -- 将需要跑批的过程写在此处
      WHILE V_START_DT <=  V_END_DT  LOOP
      I_DATADATE := TO_CHAR(V_START_DT,'YYYYMMDD');

    ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL(I_DATADATE,O_RETURN);

        V_START_DT := V_START_DT + 1;
        I_DATADATE := TO_NUMBER(TO_CHAR((V_START_DT), 'YYYYMMDD'));

        /*IF V_START_DT = LAST_DAY(V_START_DT) THEN -- 跳过月末
           V_START_DT := V_START_DT + 1;
           I_DATADATE := TO_CHAR(V_START_DT,'YYYYMMDD');
        END IF;*/
      END LOOP;
  END IF;

END ETL_CTM_DATA_INIT;
/

