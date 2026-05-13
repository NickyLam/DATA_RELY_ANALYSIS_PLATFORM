CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_RPT_REPORT_RESULT_TO_MDL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
IS
  V_P_DATE VARCHAR2(8);
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RPT_REPORT_RESULT';

  INSERT INTO RPT_REPORT_RESULT(
    INDEX_NO,
    DATA_DATE,
    ORG_NO,
    DIM1,
    DIM2,
    DIM3,
    DIM4,
    DIM5,
    DIM6,
    DIM7,
    DIM8,
    DIM9,
    DIM10,
    INDEX_VAL,
    TEMPLATE_ID,
    CURRENCY
    )
  SELECT INDEX_NO,
         DATA_DATE,
         ORG_NO,
         DIM1,
         DIM2,
         DIM3,
         DIM4,
         DIM5,
         DIM6,
         DIM7,
         DIM8,
         DIM9,
         DIM10,
         INDEX_VAL,
         TEMPLATE_ID,
         CURRENCY
    FROM RRP_PLAT.RPT_REPORT_RESULT@LINK_RRP
   WHERE (INDEX_NO LIKE 'GF0102%'
          OR INDEX_NO LIKE 'G0102%'
          OR INDEX_NO LIKE 'G03%'
          OR INDEX_NO LIKE 'G01%'
          OR INDEX_NO LIKE 'G12%'
          OR INDEX_NO LIKE 'G1101%'
          );
    -- AND DATA_DATE = V_P_DATE
  COMMIT;
  O_ERRCODE := '0';

END;
/

