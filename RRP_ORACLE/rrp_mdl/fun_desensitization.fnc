CREATE OR REPLACE FUNCTION RRP_MDL.FUN_DESENSITIZATION(I_CUST_NAME IN VARCHAR2,
                                               I_DES_TYP   IN INTEGER) ---0:取最后一个字段 1：取第一个字段
 RETURN VARCHAR2 DETERMINISTIC IS
  /***********************************************************************
  ************************************************************************
    **  存储过程详细说明：名称脱敏函数
    **  存储过程名称:  FUN_DESENSITIZATION
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
    **
    ************************************************************************
  ***********************************************************************/
  V_RESULT           VARCHAR2(10); --输出结果
  V_CUST_NAME        VARCHAR2(100); ---客户名称
  V_NLS_CHARACTERSET VARCHAR2(100); ---字符集类型
  V_EN_FLAG          VARCHAR2(10); ---客户名称是否英文  Y：是 N：否
  V_DES_TYP          INTEGER; ---脱敏类型  0:取最后一个字段 1：取第一个字段
BEGIN
  V_CUST_NAME := I_CUST_NAME;
  V_DES_TYP   := I_DES_TYP;
  SELECT UPPER(VALUE)
    INTO V_NLS_CHARACTERSET
    FROM NLS_DATABASE_PARAMETERS
   WHERE PARAMETER = 'NLS_CHARACTERSET';

  SELECT CASE
           WHEN /*REGEXP_LIKE(V_CUST_NAME, '.([a-z]+|[A-Z])')*/
            LENGTH(V_CUST_NAME) = LENGTHB(V_CUST_NAME) THEN
            'Y'
           ELSE
            'N'
         END
    INTO V_EN_FLAG
    FROM DUAL;
  /*
    --如果输入参数为空，则返回空值

    IF V_CUST_NAME IS NULL OR V_CUST_NAME = '' THEN
      V_RESULT := '';
    END IF;

    --GBK

    IF V_NLS_CHARACTERSET = 'ZHS16GBK' THEN

      IF V_EN_FLAG = 'Y' AND V_DES_TYP = 1 THEN
        --如果有英文名称，且脱敏类型为第一个字段，则截取字段前三位
        SELECT SUBSTR(V_CUST_NAME, 1, 3) INTO V_RESULT FROM DUAL;
      ELSIF V_EN_FLAG = 'Y' AND V_DES_TYP = 0 THEN
        --如果有英文名称，且脱敏类型为最后字段，则截取字段后三位
        SELECT SUBSTR(V_CUST_NAME, LENGTH(V_CUST_NAME) - 2, 3)
          INTO V_RESULT
          FROM DUAL;
      ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 1 THEN
        --如果无英文名称，且脱敏类型为第一个字段，则截取字段前一位
        SELECT SUBSTR(V_CUST_NAME, 1, 1) INTO V_RESULT FROM DUAL;
      ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 0 THEN
        --如果无英文名称，且脱敏类型为第一个字段，则截取字段后一位
        SELECT SUBSTR(V_CUST_NAME, LENGTH(V_CUST_NAME), 1)
          INTO V_RESULT
          FROM DUAL;
      END IF;
    END IF;

    --UTF8

    IF V_NLS_CHARACTERSET IN ('AL32UTF8', 'UTF8') THEN

      IF \*V_EN_FLAG = 'Y' AND *\
       V_DES_TYP = 1 THEN
        --如果有英文名称，且脱敏类型为第一个字段，则截取字段前三位
        SELECT SUBSTRB(V_CUST_NAME, 1, 3) INTO V_RESULT FROM DUAL;
      ELSIF \*V_EN_FLAG = 'Y' AND *\
       V_DES_TYP = 0 THEN
        --如果有英文名称，且脱敏类型为最后字段，则截取字段后三位
        SELECT SUBSTRB(V_CUST_NAME, LENGTHB(V_CUST_NAME) - 2, 3)
          INTO V_RESULT
          FROM DUAL;
        \*ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 1 THEN
          --如果无英文名称，且脱敏类型为第一个字段，则截取字段前三位
          SELECT SUBSTRB(V_CUST_NAME, 1, 3) INTO V_RESULT FROM DUAL;
        ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 0 THEN
          --如果无英文名称，且脱敏类型为第一个字段，则截取字段后三位
          SELECT SUBSTRB(V_CUST_NAME, LENGTHB(V_CUST_NAME) - 2, 3)
            INTO V_RESULT
            FROM DUAL;*\
      END IF;
    END IF;
  */

--  参数为空处理逻辑  --
  IF V_CUST_NAME IS NULL OR V_CUST_NAME = '' THEN
    V_RESULT := '';

  --  GBK字符类型处理逻辑  --
  ELSIF V_NLS_CHARACTERSET = 'ZHS16GBK' THEN

    IF V_EN_FLAG = 'Y' AND V_DES_TYP = 1 THEN
      --如果有英文名称，且脱敏类型为第一个字段，则截取字段前三位
      SELECT SUBSTR(V_CUST_NAME, 1, 3) INTO V_RESULT FROM DUAL;
    ELSIF V_EN_FLAG = 'Y' AND V_DES_TYP = 0 THEN
      --如果有英文名称，且脱敏类型为最后字段，则截取字段后三位
      SELECT SUBSTR(V_CUST_NAME, LENGTH(V_CUST_NAME) - 2, 3)
        INTO V_RESULT
        FROM DUAL;
    ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 1 THEN
      --如果无英文名称，且脱敏类型为第一个字段，则截取字段前一位
      SELECT SUBSTR(V_CUST_NAME, 1, 1) INTO V_RESULT FROM DUAL;
    ELSIF V_EN_FLAG = 'N' AND V_DES_TYP = 0 THEN
      --如果无英文名称，且脱敏类型为第一个字段，则截取字段后一位
      SELECT SUBSTR(V_CUST_NAME, LENGTH(V_CUST_NAME), 1)
        INTO V_RESULT
        FROM DUAL;
    END IF;

  --  UTF8字符类型处理逻辑  --
  ELSIF V_NLS_CHARACTERSET IN ('AL32UTF8', 'UTF8') THEN

    IF V_DES_TYP = 1 THEN
      --如果有英文名称，且脱敏类型为第一个字段，则截取字段前三位
      SELECT SUBSTRB(V_CUST_NAME, 1, 3) INTO V_RESULT FROM DUAL;
    ELSIF V_DES_TYP = 0 THEN
      --如果有英文名称，且脱敏类型为最后字段，则截取字段后三位
      SELECT SUBSTRB(V_CUST_NAME, LENGTHB(V_CUST_NAME) - 2, 3)
        INTO V_RESULT
        FROM DUAL;
    END IF;

  END IF;

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

