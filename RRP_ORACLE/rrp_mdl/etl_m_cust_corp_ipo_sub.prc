CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_CORP_IPO_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_CORP_IPO_SUB
  *  功能描述：监管集市单一法人客户的上市信息。
  *  创建日期：20220610
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO     --对公客户基本信息
  *
  *
  *  目标表：  M_CUST_CORP_IPO_SUB  --单一法人客户上市情况子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
                6    20220901  MW       增加码值表模块判定
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_STEP_DESC VARCHAR2(100);        --处理步骤描述
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_DATE      DATE;                 --数据日期(判断输入参数日期格式是否准确)
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CUST_CORP_IPO_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_CORP_IPO_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑--
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_DATE   := TO_DATE(I_P_DATE,'YYYY-MM-DD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CUST_CORP_IPO_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入单一法人客户上市情况子表信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CUST_CORP_IPO_SUB
    (DATA_DT         --数据日期
    ,LGL_REP_ID      --法人编号
    ,CUST_ID         --客户编号
    ,IPO_TYP         --上市类型
    ,CTRY_CD         --国家代码
    ,IPO_CO_STK_CD   --上市公司股票代码
    ,DEPT_LINE       --部门条线
    ,DATA_SRC        --数据来源
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')    AS DATA_DT                         --数据日期
        ,A.LP_ID                          AS LGL_REP_ID                      --法人编号
        ,A.CUST_ID                        AS CUST_ID                         --客户编号
        ,A.LIST_CORP_TYPE_CD              AS IPO_TYP                         --上市类型
        ,A.CTY_RG_CD                      AS CTRY_CD                         --国家代码
        ,A.STOCK_CD                       AS IPO_CO_STK_CD                   --上市公司股票代码
        ,NULL                             AS DEPT_LINE                       --部门条线 /*'800926'公司银行总部*/
        ,SUBSTR(A.JOB_CD, 0, 4)           AS DATA_SRC                        --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息
   WHERE TRIM(A.STOCK_CD) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,IPO_TYP,IPO_CO_STK_CD,COUNT(1)
      FROM RRP_MDL.M_CUST_CORP_IPO_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, CUST_ID,IPO_TYP,IPO_CO_STK_CD
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

--程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CUST_CORP_IPO_SUB;
/

