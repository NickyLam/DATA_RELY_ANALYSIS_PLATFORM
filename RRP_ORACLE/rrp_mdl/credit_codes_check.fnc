CREATE OR REPLACE FUNCTION RRP_MDL.CREDIT_CODES_CHECK(organizationCode VARCHAR2)
    /*
   organizationCode：要验证的统一社会信用代码
 */
    RETURN VARCHAR2 IS
    codeSum  NUMBER(10) := 0;
    code     VARCHAR(100);
    n_Length NUMBER(2);
    code_jy  varchar(1);
    code_end varchar(1);
    jycode   NUMBER(2);
    /*字符与字符的值，每个字符后两位为该字符的字符数值*/
    Ci       CHAR(35)   := '0123456789ABCDEFGHJKLMNPQRTUWXY';
    /*字符的加权因子*/
    --后面没用，加权因子通过算式算出来了
    type v_ar is varray(18) of number;
    Wi       v_ar       := v_ar(1, 3, 9, 27, 19, 26, 16, 17, 20, 29, 25, 13, 8, 24, 10, 30, 28);
BEGIN
    /*判断是否为null*/
    IF (organizationCode is NULL) THEN
        BEGIN
            RETURN '为空！';
        END;
    END IF;
    code := RTRIM(LTRIM(REPLACE(organizationCode, '-', ''))); /*把-,前后空格去掉*/
    n_Length := Length(code);
    /*验证长度是否正确*/
    /*验证机构代码是由数字和大写字母组成*/
    IF NOT Regexp_Like(code, '^[1-9A-Z]{1}[1239]{1}[0-9]{6}[0-9A-Z]{10}$') THEN
        RETURN '长度不正确或格式不对';
    END IF;
    /*字符的字符数值分别乘于该位的加权因子，然后求和*/
    for i in 1 .. (n_Length - 1)
        loop
            codeSum := codeSum + MOD(Power(3, (i - 1)), 31) * (to_Number(INSTR(Ci, Substr(code, i, 1))) - 1);
        end loop;
    /* 计算校验码jycode*/
    jycode := 31 - MOD(codeSum, 31);
    if (jycode = 31) then
        jycode := 0;
    end if;
    code_jy := Substr(Ci, To_Number(jycode + 1), 1);
    --获取最后一位校验码
    code_end := substr(code, -1);
    /*验证校验码code_end*/
    /*验证计算出的校验结果*/
    if (code_jy <> to_char(code_end)) then
        return '校验合法性失败';
    end if;
    RETURN 'true';
EXCEPTION
    WHEN OTHERS THEN
        raise;
END CREDIT_CODES_CHECK;
/

