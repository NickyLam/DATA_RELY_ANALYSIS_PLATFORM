CREATE OR REPLACE FUNCTION RRP_EAST.FUN_EXP_FREQ(I_DATADATE  IN VARCHAR2,
                                        I_FREQ IN VARCHAR2)
  RETURN VARCHAR2 IS
  /***********************************************************************
  ************************************************************************
    **  存储过程详细说明：获取卸数跑批频度
    **  存储过程名称:  FUN_EXP_FREQ
    **  存储过程创建日期:2022-04-14
    **  存储过程创建人:李萍
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(5);
         BEGIN
           I_DATADATE := '20220101';
           FUN_EXP_FREQ(I_DATADATE, I_FREQ);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **
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
BEGIN
  V_DATE              := TO_DATE(I_DATADATE, 'YYYY-MM-DD');
  V_YEAR_END_DATE     := ADD_MONTHS(TRUNC(V_DATE, 'Y'), 12) - 1;
  V_QUARTER_END_DATE  := TRUNC(ADD_MONTHS(V_DATE, +3), 'Q') - 1;
  V_MONTH_END_DATE    := LAST_DAY(TRUNC(V_DATE));
  V_MONTH_START_DATE  := TRUNC(V_DATE, 'MM');
  V_WEEK_END_DATE     := TRUNC(V_DATE, 'D') + 7;
  V_HALFYEAR_END_DATE := ADD_MONTHS(V_YEAR_END_DATE, -6);

  SELECT CASE
           WHEN UPPER(I_FREQ) = 'D' THEN --日频度：按天跑批
            '1'
           WHEN UPPER(I_FREQ) = 'Y' AND V_DATE = V_YEAR_END_DATE THEN --年频度：年末跑批
            '1'
           WHEN UPPER(I_FREQ) = 'HY' AND V_DATE = V_HALFYEAR_END_DATE THEN --半年频度：上半年6月30号跑批
            '1'
           WHEN UPPER(I_FREQ) = 'HY' AND V_DATE = V_YEAR_END_DATE THEN --半年频度：下半年年末跑批
            '1'
           WHEN UPPER(I_FREQ) = 'Q' AND V_DATE = V_QUARTER_END_DATE THEN --季频度：季末跑批
            '1'
           WHEN UPPER(I_FREQ) = 'M' AND V_DATE = V_MONTH_END_DATE THEN --月频度：月底跑批
            '1'
           WHEN UPPER(I_FREQ) = 'T' AND V_DATE = V_MONTH_START_DATE + 9 THEN --旬频度：上旬
            '1'
           WHEN UPPER(I_FREQ) = 'T' AND V_DATE = V_MONTH_START_DATE + 19 THEN --旬频度：中旬
            '1'
           WHEN UPPER(I_FREQ) = 'T' AND V_DATE = V_MONTH_END_DATE THEN --旬频度：下旬=月末
            '1'
           WHEN UPPER(I_FREQ) = 'W' AND V_DATE = V_WEEK_END_DATE THEN --旬频度：周末最后一天
            '1'
           ELSE
            '0'
         END

    INTO V_RESULT
    FROM DUAL;

  RETURN V_RESULT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    BEGIN
      V_RESULT := 'NO_DATA_FOUND';
      RETURN V_RESULT;
    END;
  WHEN OTHERS THEN
    BEGIN
      V_RESULT := '0';
      RETURN(V_RESULT);
    END;
END;
/

