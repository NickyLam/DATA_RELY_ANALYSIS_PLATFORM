CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_PURCH_RESALE(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_PURCH_RESALE
  *  功能描述：买入反售业务表（G13报表使用）
  *  创建日期：20230130
  *  开发人员：卢伟博
  *  来源表：
  *
  *  目标表：  S_PURCH_RESALE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230130  卢伟博    新建
  *
  *********************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_PURCH_RESALE'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_MONTH_START_DATE := TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');
  V_TAB_NAME := 'S_PURCH_RESALE'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;


/*  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM S_PURCH_RESALE T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_PURCH_RESALE'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

 -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '买入反售（同业部分）';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO S_PURCH_RESALE NOLOGGING
  (   DATA_DT, --数据日期
      SYS_ID,  --系统代码
      BOND_CODE, --债券代码
      BOND_NAME,--债券名称
      CTMS_BOND_TYPE_CD,--资金系统债券类型代码
      G13_TYPE_CD,--G13买入反售类型
      INIT_VALUE,--起始估值
      LAST_VALUE,--最新估值
      AMOUNT   --买入反售余额
  )
  WITH SECU_OBJ AS
     (SELECT I_CODE, A_TYPE, M_TYPE, TRADE_ID
        FROM RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS--增量表
       WHERE BEG_DATE =TO_CHAR(TO_DATE(V_P_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
         AND REAL_CP + DUE_CP + AI + DUE_AI <> 0)

    SELECT V_P_DATE AS DATA_DT, --数据日期
           'IBMS'   AS SYS_ID, --系统代码
           TB.I_CODE, --债券代码
           TB.B_NAME, --债券名称
           '1', --债券类型代码
           '1.3.1', --G13买入返售类型
           T.ORDAMOUNT AS  INIT_VALUE, --起始估值（万元）
           T.ORDAMOUNT AS  LAST_VALUE, --最新估值（万元）
           T.ORDAMOUNT AS  AMOUNT --买入返售余额（万元）
      FROM SECU_OBJ A
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE T --增量表
        ON T.INTORDID = A.TRADE_ID
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_INSTRUMENT I--全量表
        ON I.I_CODE = T.I_CODE
       AND I.A_TYPE = T.A_TYPE
       AND I.M_TYPE = T.M_TYPE
       AND I.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                    AND I.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TTRD_PLEDGEBOND PB--全量
        ON PB.I_CODE = A.I_CODE
       AND PB.A_TYPE = A.A_TYPE
       AND PB.M_TYPE = A.M_TYPE
       AND PB.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_IOL_IBMS_TBND TB--全量
        ON PB.P_I_CODE = TB.I_CODE
       AND PB.P_A_TYPE = TB.A_TYPE
       AND PB.P_M_TYPE = TB.M_TYPE
       AND TB.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                    AND TB.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
     WHERE I.P_TYPE IN ('0123', '0220', '0150', '0158')
       AND T.M_TYPE IN ('XSHG', 'XSHE')/*取交易所直投: XSHG-上交所, XSHE-深交所*/;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_PURCH_RESALE字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '买入反售（资金系统部分）';
  V_STARTTIME := SYSDATE;

   INSERT /*+APPEND*/ INTO S_PURCH_RESALE NOLOGGING
  (   DATA_DT, --数据日期
      SYS_ID,  --系统代码
      BOND_CODE, --债券代码
      BOND_NAME,--债券名称
      CTMS_BOND_TYPE_CD,--资金系统债券类型代码
      G13_TYPE_CD,--G13买入反售类型
      INIT_VALUE,--起始估值
      LAST_VALUE,--最新估值
      AMOUNT   --买入反售余额
  )
  SELECT   V_P_DATE DATE_ID, --数据日期
           'CTMS' SYS_ID, --系统代码
           T.BONDSCODE, --债券代码
           T.BONDSNAME, --债券名称
           A.SECURITY_TYPE, --资金系统债券类型代码
           DECODE(C.G13_TYPE_CD,
                  '1.3.7',
                  CASE
                    WHEN R.RATING IN ('AAA+', 'AAA', 'AAA-', 'AA+') THEN
                     '1.3.7.1' --1.3.7.1评级在AA+（含）以上
                    WHEN R.RATING IN ('AA', 'AA-', 'A+') THEN
                     '1.3.7.2' --1.3.7.2评级在AA+至A之间
                    ELSE
                     '1.3.7.3' --1.3.7.3评级在A以下或无评级
                  END,
                  C.G13_TYPE_CD), --g13买入返售类型
           T.FACE_AMOUNT AS INIT_VALUE, --起始估值（万元）
           T.LAST_VALUE  AS LAST_VALUE, --最新估值（万元）
           --T.FACE_AMOUNT * F.CP / 100 LAST_VALUE, --最新估值（万元）
           /*20221122：依据黎江浩提供口径按最新估值占组合交易总最新估值比例为权重分配AMOUNT*/
           T.LAST_VALUE / T.SUM_VALUE * T.AMOUNT AS AMOUNT --买入返售余额
           --T.FACE_AMOUNT * T.REPO_RATE AMOUNT --买入返售余额
      FROM (SELECT T1.SERIAL_NUMBER,
                   T1.BONDSCODE,
                   T1.BONDSNAME,
                   T1.FACE_AMOUNT,
                   T1.AMOUNT,
                   SUM(T1.FACE_AMOUNT * T2.CP / 100) OVER(PARTITION BY SERIAL_NUMBER) SUM_VALUE,
                   T1.FACE_AMOUNT * T2.CP / 100 LAST_VALUE
              FROM (SELECT SERIAL_NUMBER,
                           REGEXP_SUBSTR(BONDSCODE, '[^,]+', 1, LEVEL, 'i') BONDSCODE,
                           REGEXP_SUBSTR(BONDSNAME, '[^,]+', 1, LEVEL, 'i') BONDSNAME,
                           REGEXP_SUBSTR(FACE_AMOUNT, '[^,]+', 1, LEVEL, 'i') FACE_AMOUNT,
                           AMOUNT
                      FROM RRP_MDL.O_IOL_CTMS_TBS_V_LDREPODEALS L --增量表
                     WHERE TRADE_DATE <= V_P_DATE
                       AND MATURITY_DATE > V_P_DATE
                       AND BUYORSELL = 'S'
                       AND ID_MARK <> 'D' --删除标识 <> 'D'
                       AND START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                       AND END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
                    CONNECT BY SERIAL_NUMBER = PRIOR SERIAL_NUMBER
                           AND PRIOR DBMS_RANDOM.VALUE IS NOT NULL
                           AND LEVEL <=
                               LENGTH(BONDSCODE) -
                               LENGTH(REGEXP_REPLACE(BONDSCODE, ',', '')) + 1) T1
              LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_CDC_FP T2--增量供数
                ON T2.ETL_DT =TO_DATE(V_P_DATE, 'YYYYMMDD')-- --取最近有效公允价值日期值
               AND T1.BONDSCODE = T2.SECURITY_CODE) T
      LEFT JOIN RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY A--全量供数
        ON A.START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                    AND A.END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')
       AND T.BONDSCODE = A.SECURITY_CODE
      LEFT JOIN RRP_MDL.G13_BOND_TYPE_CFG C
        ON A.SECURITY_TYPE = C.CTMS_BOND_TYPE_CD
      LEFT JOIN (SELECT SECURITY_CODE,
                        RATING,
                        ROW_NUMBER() OVER(PARTITION BY SECURITY_CODE ORDER BY RATING_DATE DESC) RN
                   FROM RRP_MDL.O_IOL_CTMS_TBS_V_SECURITY_RATING--全量供数
                  WHERE  ID_MARK <> 'D' --删除标识 <> 'D'
                    AND START_DT <= TO_DATE(V_P_DATE, 'YYYYMMDD')
                    AND END_DT > TO_DATE(V_P_DATE, 'YYYYMMDD')) R
        ON R.RN = 1
       AND T.BONDSCODE = R.SECURITY_CODE;


  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
-- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     --V_STEP := V_STEP + 1;
     --V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_PURCH_RESALE;
/

