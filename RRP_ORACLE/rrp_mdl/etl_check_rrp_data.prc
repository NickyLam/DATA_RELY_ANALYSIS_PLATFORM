CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_CHECK_RRP_DATA(I_CHECK_RRP VARCHAR2    --校验模块简称
                                              ,I_P_TABLE VARCHAR2      --校验目标表名，若为空则配置表中全模块的表均校验
                                              ,O_ERRCODE OUT VARCHAR2) --错误代码
/***********************************************************************
    **  存储过程详细说明：对各报送模块的明细新旧数据进行对比，按表和字段找出差异
    **  存储过程名称:  ETL_CHECK_RRP_DATA
    **  存储过程创建日期:2022-11-16
    **  存储过程创建人:WYX
    **  调用方法:
    **  输入参数:   I_CHECK_RRP、I_P_TABLE
    **  输出参数:
    **  返回值:
    **  修改日期          修改项目        修改原因           修改人
    **
***********************************************************************/
IS
  V_DATEID VARCHAR2(8)       := '20220630';
  V_SYSTEM VARCHAR2(30)      := '监管报送新旧数据校验';
  V_PROC_NAME VARCHAR2(50)   := 'ETL_CHECK_RRP_DATA';
  V_START_DATE DATE          := SYSDATE;              --跑批开始时间
  V_END_DATE DATE;                                    --跑批结束时间
  V_STEP_ID INTEGER          := '1';
  V_STEP_DESC VARCHAR2(1000) := UPPER(I_CHECK_RRP) || '监管报表新/旧数据比对校验';
  V_COUNT INTEGER            := 0;
  V_SQLMSG VARCHAR2(300)     := '跑批正确';

  --定义变量
  V_DBLINK_NM                VARCHAR2(20);        --原报送模块DBLINK连接名
  V_DBLINK_ID                VARCHAR2(20);        --原报送模块DBLINK用户名
  V_COL_VAL                  VARCHAR2(4000);      --校验目标表关联字段-原值
  V_COL_LIST                 VARCHAR2(4000);      --校验目标表关联字段-带表别名-日志表展示用
  V_COND_VAL                 VARCHAR2(4000);      --校验目标表关联字段英文名-日志表展示用
  V_COND_VAL_CN              VARCHAR2(4000);      --校验目标表关联字段英文名-日志表展示用
  V_COND_COL                 VARCHAR2(4000);      --校验目标表关联条件
  V_CHECK_SQL                CLOB;                --校验SQL
  V_CHECK_RRP                VARCHAR2(50);        --校验报送模块名
  V_P_TABLE                  VARCHAR2(50);        --校验表英文名
  V_FLAG                     INT;                 --校验标志
  ERR_DESC                   EXCEPTION;           --异常错误

--针对全模块校验时基于配置表通过游标逐表校验，只取启用标志记录
CURSOR C_CFG_INFO IS SELECT * FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE) = UPPER(I_CHECK_RRP) 
  AND VALID_FLG='1' ORDER BY CHECK_TABLE_NM ASC;
V_CHECK_TAB CHECK_RRP_TAB_CONFIG%ROWTYPE;

BEGIN
  O_ERRCODE                  := '0';
  V_CHECK_RRP                := UPPER(I_CHECK_RRP);
--判断校验报送模块是否存在配置表
  SELECT COUNT(1) INTO V_FLAG FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND VALID_FLG='1';
  IF V_FLAG < 1 THEN
    V_STEP_DESC := '发生异常！输入的报送应用-'||UPPER(I_CHECK_RRP)||'未在参数表-CHECK_RRP_TAB_CONFIG中配置(或有效的)校验信息！';
    RAISE ERR_DESC;
   END IF;

--判断校验类型
if nvl(I_P_TABLE,'A')<>'A' then
---------------------------------------------------指定表校验-------------------------------------------------------
   V_P_TABLE := UPPER(I_P_TABLE);

   --表存在校验
  SELECT COUNT(1) INTO V_FLAG FROM USER_TABLES WHERE TABLE_NAME=V_P_TABLE;
  IF V_FLAG < 1 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在数据库中不存在！';
    RAISE ERR_DESC;
  END IF;

  --表配置校验
  SELECT COUNT(JOIN_KEY) INTO V_FLAG FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  IF V_FLAG < 1 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中未配置！';
    RAISE ERR_DESC;
  END IF;

  --表重复配置校验
  SELECT COUNT(1) INTO V_FLAG FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  IF V_FLAG > 1 THEN
     V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的校验表-'||UPPER(V_P_TABLE)||'存在多条配置记录！';
      RAISE ERR_DESC;
  END IF;

  --脚本参数赋值
  SELECT DBLINK_NM INTO V_DBLINK_NM FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT DBLINK_ID||'.' INTO V_DBLINK_ID FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT UPPER(JOIN_KEY) INTO V_COL_VAL FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT 'A.'||REPLACE(UPPER(JOIN_KEY),',','||''+''||A.') INTO V_COL_LIST FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT ''''||REPLACE(UPPER(JOIN_KEY),',','+')||'''' INTO V_COND_VAL FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';

  --业务主键关联字段存在校验
  SELECT COUNT(1) INTO V_FLAG
  FROM USER_TAB_COLUMNS
  WHERE TABLE_NAME=V_P_TABLE
  AND COLUMN_NAME IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')
                      FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                      CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(replace(JOIN_KEY,',',''))+1
                      );
  IF V_FLAG != LENGTH(V_COND_VAL)-LENGTH(replace(V_COND_VAL,'+',''))+1 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的关联字段不存在！';
    RAISE ERR_DESC;
  END IF;

    --业务主键关联字段存在数据重复校验
  V_CHECK_SQL := 'SELECT COUNT(CNT) FROM (SELECT COUNT(1) AS CNT FROM '||V_P_TABLE||' GROUP BY '||V_COL_VAL||' HAVING COUNT(1)>1) WHERE ROWNUM<2';
  execute immediate V_CHECK_SQL INTO V_FLAG;
  IF V_FLAG > 0 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的关联字段数据重复！';
    RAISE ERR_DESC;
  END IF;

  --继续脚本参数赋值
  SELECT listagg(B.COMMENTS,'+') INTO V_COND_VAL_CN
  FROM
  (
    SELECT DISTINCT CHECK_TABLE_NM,UPPER(CHECK_TABLE_NM),regexp_substr(JOIN_KEY,'[^,]+',1,LEVEL,'i') AS COND_COL
    FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
    WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
    AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
    AND VALID_FLG='1') A
    CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(regexp_replace(JOIN_KEY,',',''))+1
  ) A
    INNER JOIN USER_COL_COMMENTS B
    ON A.CHECK_TABLE_NM= B.table_name AND A.COND_COL=B.COLUMN_NAME;

  SELECT RTRIM(listagg(COND_COL,''),' AND ') INTO V_COND_COL FROM
  (
    SELECT DISTINCT 'A.'||regexp_substr(JOIN_KEY,'[^,]+',1,LEVEL)||'=B.'||regexp_substr(JOIN_KEY,'[^,]+',1,LEVEL) ||' AND ' AS COND_COL
    FROM(SELECT * FROM CHECK_RRP_TAB_CONFIG
    WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
    AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
    AND VALID_FLG='1')
    CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(regexp_replace(JOIN_KEY,',',''))+1
  );

--生成数据差异比较语句
SELECT 'INSERT INTO CHECK_RRP_TAB_RESULT '||T1_SQL||T2.COL_LIST||')) WHERE COLUMN_NM<>''Y''' INTO V_CHECK_SQL
FROM
(
  SELECT A.TABLE_NAME,
         'SELECT SYSDATE AS CHECK_DT,'''||V_CHECK_RRP||''' AS RRP_TYPE,'''||V_P_TABLE||''' AS CHECK_TABLE_NM,'''||A.TAB_COMMENT||''' AS CHECK_TABLE_NM_CN,'''
         ||V_COND_VAL_CN||''','||V_COND_VAL||',JOIN_KEY,CHECK_RESULT'||',null'||',SUBSTR(COLUMN_NM,1,INSTR(COLUMN_NM,''^'')-1) AS CHECK_COLUMN_VAL,
         SUBSTR(COLUMN_NM,INSTR(COLUMN_NM,''^'')+2) AS SRC_COLUMN_VAL FROM ('||'SELECT '||V_COL_LIST||' AS JOIN_KEY,'||
         RTRIM(XMLAGG(XMLPARSE(CONTENT TAB_COL_NM||',' WELLFORMED)).GETCLOBVAL(),',')||' FROM '||V_P_TABLE||' A INNER JOIN '||
         V_DBLINK_ID||V_P_TABLE||V_DBLINK_NM||' B ON '||V_COND_COL||
         ') UNPIVOT(COLUMN_NM FOR CHECK_RESULT IN(' AS T1_SQL
  FROM (
        SELECT A.TABLE_NAME
               ,'DECODE(A.'||A.COLUMN_NAME||',B.'||A.COLUMN_NAME||',''Y'',A.'||A.COLUMN_NAME||'||''^^''||B.'||A.COLUMN_NAME||') AS '||A.COLUMN_NAME AS TAB_COL_NM
               ,C.COMMENTS AS TAB_COMMENT
        FROM USER_TAB_COLUMNS A
        LEFT JOIN USER_TAB_COMMENTS C
             ON A.TABLE_NAME=C.TABLE_NAME
             AND C.TABLE_NAME=V_P_TABLE
        WHERE A.TABLE_NAME=V_P_TABLE
        AND A.COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')  --关联业务键不校验
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(replace(JOIN_KEY,',',''))+1)
          AND A.COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(NVL(UPPER(EXCP_COL),'999999'),'[^,]+',1,LEVEL,'i') --剔除不需要校验字段
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(NVL(EXCP_COL,'999999')) - LENGTH(replace(NVL(EXCP_COL,'999999'),',',''))+1)
        ORDER BY A.COLUMN_ID
  ) A
  GROUP BY A.TABLE_NAME,A.TAB_COMMENT
) T1
INNER JOIN (SELECT V_P_TABLE AS TABLE_NAME,LISTAGG(COLUMN_NAME,',') AS COL_LIST
           FROM USER_TAB_COLUMNS
           WHERE TABLE_NAME=V_P_TABLE
           AND COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(replace(JOIN_KEY,',',''))+1)
           AND COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(NVL(UPPER(EXCP_COL),'999999'),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(NVL(EXCP_COL,'999999')) - LENGTH(replace(NVL(EXCP_COL,'999999'),',',''))+1)
           ORDER BY COLUMN_ID
           ) T2
           ON T1.TABLE_NAME=T2.TABLE_NAME
;

  V_STEP_ID  := '1';
--删除日志重跑
  DELETE FROM CHECK_RRP_TAB_RESULT WHERE RRP_TYPE=V_CHECK_RRP AND CHECK_TABLE_NM=V_P_TABLE;  --监管明细数据集校验结果表
  COMMIT;

  V_STEP_ID  := '2';
--执行校验脚本
  DBMS_OUTPUT.PUT_LINE('200:'||V_CHECK_SQL);
  EXECUTE IMMEDIATE V_CHECK_SQL;
  COMMIT;

  V_STEP_ID  := '3';
  --更新字段中文名
  UPDATE CHECK_RRP_TAB_RESULT A
  SET A.CHECK_COLUMN_NM_CN=(SELECT B.COMMENTS FROM USER_COL_COMMENTS B
      WHERE B.TABLE_NAME=V_P_TABLE
      AND B.COLUMN_NAME=A.CHECK_COLUMN_NM)
  WHERE A.RRP_TYPE=V_CHECK_RRP
  AND A.CHECK_TABLE_NM=V_P_TABLE
  AND EXISTS(SELECT 'A'
             FROM USER_COL_COMMENTS B
             WHERE B.TABLE_NAME=V_P_TABLE
             AND B.COLUMN_NAME=A.CHECK_COLUMN_NM);
  COMMIT;

ELSE
---------------------------------------------------全模块校验-------------------------------------------------------
OPEN C_CFG_INFO;
LOOP

   FETCH C_CFG_INFO INTO V_CHECK_TAB;
   EXIT WHEN C_CFG_INFO%NOTFOUND;
   --获取模块下的报送表名
   V_START_DATE  := SYSDATE;
   V_P_TABLE     :=UPPER(V_CHECK_TAB.CHECK_TABLE_NM);

   --表存在校验
  SELECT COUNT(1) INTO V_FLAG FROM USER_TABLES WHERE TABLE_NAME=V_P_TABLE;
  IF V_FLAG < 1 THEN
     V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的校验表-'||UPPER(V_P_TABLE)||'在数据库中不存在！';
     --RAISE ERR_DESC;
      O_ERRCODE  := '1';
      V_END_DATE := SYSDATE;
      V_SQLMSG   := '跑批异常';
      V_COUNT    := 1;
      V_STEP_ID  := '0';
      ETL_YUSYS_LOG(V_DATEID,
                    V_SYSTEM,
                    V_PROC_NAME,
                    V_START_DATE,
                    V_END_DATE,
                    V_STEP_ID,
                    V_STEP_DESC,
                    V_COUNT,
                    O_ERRCODE,
                    V_SQLMSG);
      CONTINUE;
  END IF;

  --表配置校验
  SELECT COUNT(JOIN_KEY) INTO V_FLAG FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  IF V_FLAG < 1 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中未配置！';
    --RAISE ERR_DESC;
      O_ERRCODE  := '1';
      V_END_DATE := SYSDATE;
      V_SQLMSG   := '跑批异常';
      V_COUNT    := 1;
      V_STEP_ID  := '0';
      ETL_YUSYS_LOG(V_DATEID,
                    V_SYSTEM,
                    V_PROC_NAME,
                    V_START_DATE,
                    V_END_DATE,
                    V_STEP_ID,
                    V_STEP_DESC,
                    V_COUNT,
                    O_ERRCODE,
                    V_SQLMSG);
      CONTINUE;
  END IF;

  --表重复配置校验
  SELECT COUNT(1) INTO V_FLAG FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  IF V_FLAG > 1 THEN
     V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的校验表-'||UPPER(V_P_TABLE)||'存在多条配置记录！';
     --RAISE ERR_DESC;
      O_ERRCODE  := '1';
      V_END_DATE := SYSDATE;
      V_SQLMSG   := '跑批异常';
      V_COUNT    := 1;
      V_STEP_ID  := '0';
      ETL_YUSYS_LOG(V_DATEID,
                    V_SYSTEM,
                    V_PROC_NAME,
                    V_START_DATE,
                    V_END_DATE,
                    V_STEP_ID,
                    V_STEP_DESC,
                    V_COUNT,
                    O_ERRCODE,
                    V_SQLMSG);
      CONTINUE;
  END IF;

  --脚本参数赋值
  SELECT DBLINK_NM INTO V_DBLINK_NM FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT DBLINK_ID||'.' INTO V_DBLINK_ID FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT UPPER(JOIN_KEY) INTO V_COL_VAL FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT 'A.'||REPLACE(UPPER(JOIN_KEY),',','||''+''||A.') INTO V_COL_LIST FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';
  SELECT ''''||REPLACE(UPPER(JOIN_KEY),',','+')||'''' INTO V_COND_VAL FROM CHECK_RRP_TAB_CONFIG WHERE UPPER(RRP_TYPE)=V_CHECK_RRP AND UPPER(CHECK_TABLE_NM)=V_P_TABLE AND VALID_FLG='1';

  --业务主键关联字段存在校验
  SELECT COUNT(1) INTO V_FLAG
  FROM USER_TAB_COLUMNS
  WHERE TABLE_NAME=V_P_TABLE
  AND COLUMN_NAME IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(regexp_replace(JOIN_KEY,',',''))+1
                      );
  IF V_FLAG != LENGTH(V_COND_VAL)-LENGTH(replace(V_COND_VAL,'+',''))+1 THEN
     V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的关联字段不存在！';
      --RAISE ERR_DESC;
      O_ERRCODE  := '1';
      V_END_DATE := SYSDATE;
      V_SQLMSG   := '跑批异常';
      V_COUNT    := 1;
      V_STEP_ID  := '0';
      ETL_YUSYS_LOG(V_DATEID,
                    V_SYSTEM,
                    V_PROC_NAME,
                    V_START_DATE,
                    V_END_DATE,
                    V_STEP_ID,
                    V_STEP_DESC,
                    V_COUNT,
                    O_ERRCODE,
                    V_SQLMSG);
      CONTINUE;
  END IF;

  --业务主键关联字段存在数据重复校验
  V_CHECK_SQL := 'SELECT COUNT(CNT) FROM (SELECT COUNT(1) AS CNT FROM '||V_P_TABLE||' GROUP BY '||V_COL_VAL||' HAVING COUNT(1)>1) WHERE ROWNUM<2';
  execute immediate V_CHECK_SQL INTO V_FLAG;
  IF V_FLAG > 0 THEN
    V_STEP_DESC := '发生异常！报送应用'||UPPER(I_CHECK_RRP)||'指定的校验表-'||UPPER(V_P_TABLE)||'在参数表-CHECK_RRP_TAB_CONFIG中配置的关联字段数据重复！';
    --RAISE ERR_DESC;
      O_ERRCODE  := '1';
      V_END_DATE := SYSDATE;
      V_SQLMSG   := '跑批异常';
      V_COUNT    := 1;
      V_STEP_ID  := '0';
      ETL_YUSYS_LOG(V_DATEID,
                    V_SYSTEM,
                    V_PROC_NAME,
                    V_START_DATE,
                    V_END_DATE,
                    V_STEP_ID,
                    V_STEP_DESC,
                    V_COUNT,
                    O_ERRCODE,
                    V_SQLMSG);
      CONTINUE;
  END IF;

  --继续脚本参数赋值
  SELECT LISTAGG(B.COMMENTS,'+') INTO V_COND_VAL_CN
  FROM
  (
    SELECT DISTINCT CHECK_TABLE_NM,REGEXP_SUBSTR(JOIN_KEY,'[^,]+',1,LEVEL,'i') AS COND_COL
    FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
    WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
    AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
    AND VALID_FLG='1')
    CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(REPLACE(JOIN_KEY,',',''))+1
  ) A
    INNER JOIN USER_COL_COMMENTS B
    ON A.CHECK_TABLE_NM= B.TABLE_NAME AND A.COND_COL=B.COLUMN_NAME;

  SELECT RTRIM(LISTAGG(COND_COL,''),' AND ') INTO V_COND_COL FROM
  (
    SELECT DISTINCT 'A.'||REGEXP_SUBSTR(JOIN_KEY,'[^,]+',1,LEVEL)||'=B.'||REGEXP_SUBSTR(JOIN_KEY,'[^,]+',1,LEVEL) ||' AND ' AS COND_COL
    FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
    WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
    AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
    AND VALID_FLG='1')
    CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(REGEXP_REPLACE(JOIN_KEY,',',''))+1
  );

  --生成数据差异比较语句
  SELECT 'INSERT INTO CHECK_RRP_TAB_RESULT '||T1_SQL||T2.COL_LIST||')) WHERE COLUMN_NM<>''Y''' INTO V_CHECK_SQL
  FROM
  (
    SELECT A.TABLE_NAME,
           'SELECT SYSDATE AS CHECK_DT,'''||V_CHECK_RRP||''' AS RRP_TYPE,'''||V_P_TABLE||''' AS CHECK_TABLE_NM,'''||A.TAB_COMMENT||''' AS CHECK_TABLE_NM_CN,'''
           ||V_COND_VAL_CN||''','||V_COND_VAL||',JOIN_KEY,CHECK_RESULT'||',null'||',SUBSTR(COLUMN_NM,1,INSTR(COLUMN_NM,''^'')-1) AS CHECK_COLUMN_VAL,
           SUBSTR(COLUMN_NM,INSTR(COLUMN_NM,''^'')+2) AS SRC_COLUMN_VAL FROM ('||'SELECT '||V_COL_LIST||' AS JOIN_KEY,'||
           RTRIM(XMLAGG(XMLPARSE(CONTENT TAB_COL_NM||',' WELLFORMED)).GETCLOBVAL(),',')||' FROM '||V_P_TABLE||' A INNER JOIN '||
           V_DBLINK_ID||V_P_TABLE||V_DBLINK_NM||' B ON '||V_COND_COL||
           ') UNPIVOT(COLUMN_NM FOR CHECK_RESULT IN(' AS T1_SQL
    FROM (
          SELECT A.TABLE_NAME
                 ,'DECODE(A.'||A.COLUMN_NAME||',B.'||A.COLUMN_NAME||',''Y'',A.'||A.COLUMN_NAME||'||''^^''||B.'||A.COLUMN_NAME||') AS '||A.COLUMN_NAME AS TAB_COL_NM
                 ,C.COMMENTS AS TAB_COMMENT
          FROM USER_TAB_COLUMNS A
          LEFT JOIN USER_TAB_COMMENTS C
               ON A.TABLE_NAME=C.TABLE_NAME
               AND C.TABLE_NAME=V_P_TABLE
          WHERE A.TABLE_NAME=V_P_TABLE
          AND A.COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(regexp_replace(JOIN_KEY,',',''))+1)
          AND A.COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(NVL(UPPER(EXCP_COL),'999999'),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(NVL(EXCP_COL,'999999')) - LENGTH(regexp_replace(NVL(EXCP_COL,'999999'),',',''))+1)
          ORDER BY A.COLUMN_ID
    ) A
    GROUP BY A.TABLE_NAME,A.TAB_COMMENT
  ) T1
  INNER JOIN (SELECT V_P_TABLE AS TABLE_NAME,LISTAGG(COLUMN_NAME,',') AS COL_LIST
             FROM USER_TAB_COLUMNS
             WHERE TABLE_NAME=V_P_TABLE
             AND COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(UPPER(JOIN_KEY),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(JOIN_KEY) - LENGTH(regexp_replace(JOIN_KEY,',',''))+1)
             AND COLUMN_NAME NOT IN(SELECT DISTINCT regexp_substr(NVL(UPPER(EXCP_COL),'999999'),'[^,]+',1,LEVEL,'i')
                            FROM (SELECT * FROM CHECK_RRP_TAB_CONFIG
                            WHERE UPPER(RRP_TYPE)=V_CHECK_RRP
                            AND UPPER(CHECK_TABLE_NM)=V_P_TABLE
                            AND VALID_FLG='1')
                            CONNECT BY LEVEL <=LENGTH(NVL(EXCP_COL,'999999')) - LENGTH(regexp_replace(NVL(EXCP_COL,'999999'),',',''))+1)
             ORDER BY COLUMN_ID
             ) T2
             ON T1.TABLE_NAME=T2.TABLE_NAME
  ;

  V_STEP_ID  := '1';
  ----删除日志重跑
  DELETE FROM CHECK_RRP_TAB_RESULT WHERE RRP_TYPE=V_CHECK_RRP AND CHECK_TABLE_NM=V_P_TABLE;  --监管明细数据集校验结果表
  COMMIT;

  V_STEP_ID  := '2';
  --执行校验脚本
  DBMS_OUTPUT.PUT_LINE('448:'||V_CHECK_SQL);
  EXECUTE IMMEDIATE V_CHECK_SQL;
  COMMIT;

  --更新字段中文名
  UPDATE CHECK_RRP_TAB_RESULT A
  SET A.CHECK_COLUMN_NM_CN=(SELECT B.COMMENTS FROM USER_COL_COMMENTS B
      WHERE B.TABLE_NAME=V_P_TABLE
      AND B.COLUMN_NAME=A.CHECK_COLUMN_NM)
  WHERE A.RRP_TYPE=V_CHECK_RRP
  AND A.CHECK_TABLE_NM=V_P_TABLE
  AND EXISTS(SELECT 'A'
             FROM USER_COL_COMMENTS B
             WHERE B.TABLE_NAME=V_P_TABLE
             AND B.COLUMN_NAME=A.CHECK_COLUMN_NM);
  COMMIT;

  ---记录正常日志
    V_END_DATE  := SYSDATE;
    V_STEP_DESC := '跑批提示：报送应用'||UPPER(I_CHECK_RRP)||'的表:'||V_P_TABLE||'明细数据差异对比生成！';
    V_SQLMSG    := '跑批提示';
  ETL_YUSYS_LOG(V_DATEID,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG);

  END LOOP;
  CLOSE C_CFG_INFO;

 END IF;

  ---记录正常日志
    V_END_DATE  := SYSDATE;
    V_STEP_DESC := '报送应用'||UPPER(I_CHECK_RRP)||'校验脚本跑批完成！';
    V_SQLMSG    := '跑批完成';
  ETL_YUSYS_LOG(V_DATEID,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG);

  --记录异常信息
  EXCEPTION
  WHEN ERR_DESC THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_END_DATE  := SYSDATE;
    V_COUNT     := 1;
    V_SQLMSG := '跑批异常';
  ETL_YUSYS_LOG(V_DATEID,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG);
  WHEN OTHERS THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_STEP_DESC := '发生异常！在'||V_P_TABLE||'表步骤：'||V_STEP_ID||',详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    V_END_DATE  := SYSDATE;
    V_COUNT     := 1;
    V_SQLMSG := '跑批异常';
    DBMS_OUTPUT.PUT_LINE('448:'||V_CHECK_SQL);
  ETL_YUSYS_LOG(V_DATEID,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG);

END ETL_CHECK_RRP_DATA;
/

