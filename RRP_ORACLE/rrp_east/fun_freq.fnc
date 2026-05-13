CREATE OR REPLACE FUNCTION RRP_EAST.FUN_FREQ(I_DATADATE  IN INTEGER,
                                    I_PROC_NAME IN VARCHAR2)
  RETURN VARCHAR2 IS
  /***********************************************************************
  ************************************************************************
    **  存储过程详细说明：获取跑批频度
    **  存储过程名称:  FUN_FREQ
    **  存储过程创建日期:2022-03-07
    **  存储过程创建人:蔡正伟
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(5);
         BEGIN
           I_DATADATE := '20220101';
           ETL_EAST5_101_JGXXB(I_DATADATE, O_ERRCODE);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **  20220608          返回值     NO_DATA_FOUND超过长度   徐畅欣
    ************************************************************************
  ***********************************************************************/
  V_DATE              DATE; --数据日期
  V_YEAR_END_DATE     DATE; --年末日期
  V_HALFYEAR_END_DATE DATE; --上半年末日期
  V_QUARTER_END_DATE  DATE; --季末日期
  V_MONTH_START_DATE  DATE; --月末日期
  V_MONTH_END_DATE    DATE; --旬末日期
  V_WEEK_END_DATE     DATE; --周末日期
  V_RESULT            VARCHAR2(10); --输出结果
  V_PROC_NAME         VARCHAR2(100); ---存过名称
BEGIN
  V_PROC_NAME         := UPPER(I_PROC_NAME);
  V_DATE              := TO_DATE(I_DATADATE, 'YYYY-MM-DD');
  V_YEAR_END_DATE     := ADD_MONTHS(TRUNC(V_DATE, 'Y'), 12) - 1;
  V_QUARTER_END_DATE  := TRUNC(ADD_MONTHS(V_DATE, +3), 'Q') - 1;
  V_MONTH_END_DATE    := LAST_DAY(TRUNC(V_DATE));
  V_MONTH_START_DATE  := TRUNC(V_DATE, 'MM');
  V_WEEK_END_DATE     := TRUNC(V_DATE, 'D') + 7;
  V_HALFYEAR_END_DATE := ADD_MONTHS(V_YEAR_END_DATE, -6);
  SELECT CASE
           WHEN UPPER(FREQ_TYP) = 'D' THEN --日频度：按天跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'Y' AND V_DATE = V_YEAR_END_DATE THEN --年频度：年末跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'HY' AND V_DATE = V_HALFYEAR_END_DATE THEN --半年频度：上半年6月30号跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'HY' AND V_DATE = V_YEAR_END_DATE THEN --半年频度：下半年年末跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'Q' AND V_DATE = V_QUARTER_END_DATE THEN --季频度：季末跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'M' AND V_DATE = V_MONTH_END_DATE THEN --月频度：月底跑批
            '1'
           WHEN UPPER(FREQ_TYP) = 'T' AND V_DATE = V_MONTH_START_DATE + 9 THEN --旬频度：上旬
            '1'
           WHEN UPPER(FREQ_TYP) = 'T' AND V_DATE = V_MONTH_START_DATE + 19 THEN --旬频度：中旬
            '1'
           WHEN UPPER(FREQ_TYP) = 'T' AND V_DATE = V_MONTH_END_DATE THEN --旬频度：下旬=月末
            '1'
           WHEN UPPER(FREQ_TYP) = 'W' AND V_DATE = V_WEEK_END_DATE THEN --旬频度：周末最后一天
            '1'
           ELSE
            '0'
         END

    INTO V_RESULT
    FROM RRP_MDL.CONFIG_ETL_FREQ T
   WHERE UPPER(T.PROC_NAME) = V_PROC_NAME;
  RETURN V_RESULT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      --V_RESULT := 'NO_DATA_FOUND';
      V_RESULT := 'NO_FOUND';  /*20220608 xucx*/
      RETURN V_RESULT;
    END;
  WHEN OTHERS THEN
    BEGIN
      V_RESULT := '0';
      RETURN(V_RESULT);
    END;
END;
/

