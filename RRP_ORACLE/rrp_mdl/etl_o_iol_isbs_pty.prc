CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_PTY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：当事人信息
  **存储过程名称：    ETL_O_IOL_ISBS_PTY
  **存储过程创建日期：20251229
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251229    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ISBS_PTY'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ISBS_PTY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-当事人信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ISBS_PTY NOLOGGING 
  (          INR             --内部唯一id号
            ,EXTKEY          --客户号
            ,NAM             --客户名称
            ,PTYTYP          --客户类型
            ,ACCUSR          --用户帐户的id
            ,HBKACCFLG       --housebank帐户标志
            ,HBKCONFLG       --housebank用户环境标志
            ,HBKINR          --银行inr
            ,HEQACCFLG       --总行帐户标志
            ,HEQCONFLG       --总行环境标志
            ,HEQINR          --总行inr
            ,PRFCTR          --收益中心
            ,RESUSR          --客户经理
            ,RSKCLS          --风险等级
            ,RSKCTY          --风险国家
            ,RSKTXT          --风险文本描述
            ,UIL             --传输的语言
            ,VER             --版本号
            ,AKKBRA          --akk商业区域
            ,AKKCOM          --akk公司id
            ,AKKREG          --akk地区编号
            ,LIDCNDFLG       --特别l/c情况
            ,LIDMAXDUR       --l/c最大期限日
            ,TRDCNDFLG       --特别交易情况
            ,TRDTENTOT       --汇票的最大期限日maximum
            ,TRDTENINI       --最初汇票期限initial
            ,TRDTENEXT       --汇票的最大延期日maximum
            ,TRDEXTNMB       --汇票最大延期数
            ,BADCNDFLG       --特别ba情况
            ,BADTENEXT       --ba最大期限日
            ,ADRSTA          --地址状态
            ,SELTYP          --客户信贷利率
            ,BUYTYP          --客户借贷利率
            ,SLA             --服务等级
            ,ETGEXTKEY       --实体组
            ,NAM1            --中文名称chinese
            ,JUSCOD          --技术监督局编号
            ,BILVVV          --上浮比率
            ,CUNQII          --流动资金贷款利率档次
            ,IDCODE          --身份证号码
            ,IDTYPE          --客户类型
            ,BCHKEYINR       --所属分行inr
            ,CLSCTY          --国家的信用等级credit
            ,PROCOD          --区域代码province
            ,TRNMAN          --交易主体
            ,SPEECO          --特殊经济区域
            ,IDTYP1          --id类型1
            ,RATSTM          --
            ,BANKTYP         --银行类型
            ,GODCUS          --
            ,IMGINR          --影像流水号
            ,BANKNO          --人行行号
            ,DRCCOD          --所属直接参与机构
            ,BNKKEY          --联系地址外部关键字
            ,BNKREF          --ECIF同业客户号
            ,RISRAN          --反洗钱等级
            ,IMGINR2         --新客户签约书
            ,RISRANTXT       --反洗钱等级描述
            ,IDCODLST        --证件号码集合
            ,IDTYPLST        --证件类型集合
            ,ISCRB           --跨境电商/跨境B2B
            ,START_DT        --开始时间
            ,END_DT          --结束时间
            ,ID_MARK         --增删标志
            ,ETL_TIMESTAMP   --ETL处理时间戳
       )
     SELECT 
            INR              --内部唯一id号
            ,EXTKEY          --客户号
            ,NAM             --客户名称
            ,PTYTYP          --客户类型
            ,ACCUSR          --用户帐户的id
            ,HBKACCFLG       --housebank帐户标志
            ,HBKCONFLG       --housebank用户环境标志
            ,HBKINR          --银行inr
            ,HEQACCFLG       --总行帐户标志
            ,HEQCONFLG       --总行环境标志
            ,HEQINR          --总行inr
            ,PRFCTR          --收益中心
            ,RESUSR          --客户经理
            ,RSKCLS          --风险等级
            ,RSKCTY          --风险国家
            ,RSKTXT          --风险文本描述
            ,UIL             --传输的语言
            ,VER             --版本号
            ,AKKBRA          --akk商业区域
            ,AKKCOM          --akk公司id
            ,AKKREG          --akk地区编号
            ,LIDCNDFLG       --特别l/c情况
            ,LIDMAXDUR       --l/c最大期限日
            ,TRDCNDFLG       --特别交易情况
            ,TRDTENTOT       --汇票的最大期限日maximum
            ,TRDTENINI       --最初汇票期限initial
            ,TRDTENEXT       --汇票的最大延期日maximum
            ,TRDEXTNMB       --汇票最大延期数
            ,BADCNDFLG       --特别ba情况
            ,BADTENEXT       --ba最大期限日
            ,ADRSTA          --地址状态
            ,SELTYP          --客户信贷利率
            ,BUYTYP          --客户借贷利率
            ,SLA             --服务等级
            ,ETGEXTKEY       --实体组
            ,NAM1            --中文名称chinese
            ,JUSCOD          --技术监督局编号
            ,BILVVV          --上浮比率
            ,CUNQII          --流动资金贷款利率档次
            ,IDCODE          --身份证号码
            ,IDTYPE          --客户类型
            ,BCHKEYINR       --所属分行inr
            ,CLSCTY          --国家的信用等级credit
            ,PROCOD          --区域代码province
            ,TRNMAN          --交易主体
            ,SPEECO          --特殊经济区域
            ,IDTYP1          --id类型1
            ,RATSTM          --
            ,BANKTYP         --银行类型
            ,GODCUS          --
            ,IMGINR          --影像流水号
            ,BANKNO          --人行行号
            ,DRCCOD          --所属直接参与机构
            ,BNKKEY          --联系地址外部关键字
            ,BNKREF          --ECIF同业客户号
            ,RISRAN          --反洗钱等级
            ,IMGINR2         --新客户签约书
            ,RISRANTXT       --反洗钱等级描述
            ,IDCODLST        --证件号码集合
            ,IDTYPLST        --证件类型集合
            ,ISCRB           --跨境电商/跨境B2B
            ,START_DT        --开始时间
            ,END_DT          --结束时间
            ,ID_MARK         --增删标志
            ,ETL_TIMESTAMP   --ETL处理时间戳
    FROM IOL.V_ISBS_PTY --视图-当事人信息
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ISBS_PTY', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_ISBS_PTY;
/

