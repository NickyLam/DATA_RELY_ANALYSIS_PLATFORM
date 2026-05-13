CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_PARTITION_ADD(I_DATADATE       IN INTEGER, --跑批日期
                                              I_TABLE_NAME     IN VARCHAR2, --表名称
                                              I_ADD_VALUE_TYPE IN INTEGER, --分区值类型 1：CHAR(8) 2:VARCHAR2(10) 3:DATE
                                              O_ERRCODE        OUT VARCHAR2 --错误代码
                                              )
/***********************************************************************
  ************************************************************************
    **  存储过程详细说明：新增分区
    **  存储过程名称:  ETL_PARTITION_ADD
    **  存储过程创建日期:2022-03-22
    **  存储过程创建人:蔡正伟
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(1);
         BEGIN
           I_DATADATE := '20220101';
           ETL_PARTITION_ADD(I_DATADATE, O_ERRCODE);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **  20220601          迁移                               xucx
    **  20221230          加长V_PROC_NAME变量长度            yangjuan
    ************************************************************************
  ***********************************************************************/
IS
  V_TABLE_NAME          VARCHAR2(100);  --表名称
  V_SCHEMA              VARCHAR2(100);  --模式名称
  V_PARTITION_NAME      VARCHAR2(100);  --分区名称
  V_PARTITION_COUNT     INTEGER;        --分区记录
  V_PARTITION_TYP       VARCHAR2(100);  --分区类型
  V_TABLE_SPACE         VARCHAR2(100);  --表空间
  V_ADD_VALUE_TYPE      INTEGER;        --分区值类型
  V_ADD_VALUE           VARCHAR2(20);   --LIST分区值
  V_ADD_VALUE_LESS      VARCHAR2(20);   --RAGNGE分区值
  V_ADD_VALUE_DATE      VARCHAR2(100);
  V_ADD_VALUE_LESS_DATE VARCHAR2(100);
  V_COUNT               INTEGER;        --数据记录条数
  V_SQL                 VARCHAR2(1000); --创建分区脚本
  V_SPLIT_PARTITION     VARCHAR2(100);  --需要拆的分区名字
  V_STEP                INTEGER := 0;   --处理步骤
  V_STEP_DESC           VARCHAR2(100);  --处理步骤描述
  V_PROC_NAME           VARCHAR2(100);  --程序名称
  V_P_DATE              VARCHAR2(8);    --跑批数据日期
  V_DATE                DATE;           --数据日期
  V_STARTTIME           DATE;           --处理开始时间
  V_ENDTIME             DATE;           --处理结束时间
  V_SQLCOUNT            INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG              VARCHAR2(300);  --SQL执行描述信息
  V_SYSTEM              VARCHAR2(30);   --来源系统
  /*V_LAST_DAT            VARCHAR2(8);    --当月月末
  V_YESTADAY            VARCHAR2(8);    --上日*/
BEGIN
  V_P_DATE         := TO_CHAR(I_DATADATE);
  V_STARTTIME      := SYSDATE;
  V_PROC_NAME      := UPPER('ETL_'||I_TABLE_NAME);
  V_TABLE_NAME     := UPPER(I_TABLE_NAME);
  V_SCHEMA         := USER;
  V_ADD_VALUE_TYPE := I_ADD_VALUE_TYPE;
  V_STEP_DESC      := '跑批正确';
  O_ERRCODE        := '0';
  V_STEP           := '1';
  V_COUNT          := 0;
  V_STEP_DESC      := '新增' || V_TABLE_NAME || '分区';
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  --V_PARTITION_NAME := 'P_' || V_P_DATE;
  V_P_DATE         := V_P_DATE;   --获取跑批日期
  V_SYSTEM         := '监管报送'; --默认写监管报送系统，有真实来源的按实际写

  --查看是否分区表
  SELECT CASE WHEN PARTITIONED = 'YES' THEN 1 ELSE 0 END INTO V_COUNT
    FROM ALL_TABLES
   WHERE TABLE_NAME = V_TABLE_NAME
     AND OWNER = V_SCHEMA;

  --不是分区表，退出程序
  IF V_COUNT = 0 THEN
     RETURN;
   END IF;

  --查看当日分区是否已存在
  /*SELECT COUNT(0) INTO V_PARTITION_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.PARTITION_NAME = V_PARTITION_NAME;*/
  SELECT NVL(SUM(CASE WHEN T.PARTITION_NAME = V_PARTITION_NAME THEN 1 ELSE 0 END),0),
         NVL(MIN(T.PARTITION_NAME),' ') INTO V_PARTITION_COUNT,V_SPLIT_PARTITION
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.PARTITION_NAME >= V_PARTITION_NAME;

  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE := TO_DATE(I_DATADATE, 'YYYY-MM-DD');
  IF I_ADD_VALUE_TYPE = '2' THEN
    V_ADD_VALUE      := TO_CHAR(V_DATE, 'YYYY-MM-DD');
    V_ADD_VALUE_LESS := TO_CHAR(V_DATE + 1, 'YYYY-MM-DD');

  ELSIF I_ADD_VALUE_TYPE = '1' THEN
    V_ADD_VALUE      := I_DATADATE;
    V_ADD_VALUE_LESS := TO_CHAR(V_DATE + 1, 'YYYYMMDD');

  ELSIF I_ADD_VALUE_TYPE = '3' THEN
    V_ADD_VALUE           := TO_CHAR(V_DATE, 'YYYY-MM-DD');
    V_ADD_VALUE_LESS      := TO_CHAR(V_DATE + 1, 'YYYY-MM-DD');
    V_ADD_VALUE_DATE      := '(' || 'TO_DATE(''' || V_ADD_VALUE || ''',''YYYY-MM-DD'')' || ')';
    V_ADD_VALUE_LESS_DATE := 'TO_DATE(''' || V_ADD_VALUE_LESS || ''',''YYYY-MM-DD'')';
  END IF;

  --查看分区类型
  SELECT PARTITIONING_TYPE INTO V_PARTITION_TYP
    FROM ALL_PART_TABLES T
   WHERE T.OWNER = V_SCHEMA
     AND T.TABLE_NAME = V_TABLE_NAME;

  --查看分区表空间
  SELECT TABLESPACE_NAME INTO V_TABLE_SPACE
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.PARTITION_NAME = 'PARTITION_19000101';
     --AND T.PARTITION_NAME = 'P_19000101';

  IF V_PARTITION_COUNT = 0 THEN

    --创建当日分区
    IF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'LIST' AND V_ADD_VALUE_TYPE IN ('1','2') THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' ADD PARTITION ' || V_PARTITION_NAME || ' VALUES (''' || V_ADD_VALUE ||
               ''') TABLESPACE ' || V_TABLE_SPACE || ' COMPRESS NOLOGGING UPDATE INDEXES';

    ELSIF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'LIST' AND V_ADD_VALUE_TYPE IN ('3') THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' ADD PARTITION ' || V_PARTITION_NAME || ' VALUES ' || V_ADD_VALUE_DATE ||
               ' TABLESPACE ' || V_TABLE_SPACE || ' COMPRESS NOLOGGING  UPDATE INDEXES';
    END IF;

    --IF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('1','2') THEN
    IF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('1','2')
       AND TRIM(V_SPLIT_PARTITION) IS NULL THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' ADD PARTITION ' || V_PARTITION_NAME || ' VALUES LESS THAN (''' ||
               V_ADD_VALUE_LESS || ''') TABLESPACE ' || V_TABLE_SPACE ||
               ' COMPRESS NOLOGGING UPDATE INDEXES';

    --ELSIF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('3') THEN
    ELSIF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('3')
          AND TRIM(V_SPLIT_PARTITION) IS NULL THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' ADD PARTITION ' || V_PARTITION_NAME || ' VALUES LESS THAN (' ||
               V_ADD_VALUE_LESS_DATE || ') TABLESPACE ' || V_TABLE_SPACE ||
               ' COMPRESS NOLOGGING UPDATE INDEXES';

    --ADD BY LIP 20220509  增加RANG分区拆分区功能
    ELSIF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('1','2')
          AND TRIM(V_SPLIT_PARTITION) IS NOT NULL THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' SPLIT PARTITION ' || V_SPLIT_PARTITION ||' AT ('''||V_ADD_VALUE_LESS ||''')
               INTO (PARTITION '|| V_PARTITION_NAME ||',PARTITION '||V_SPLIT_PARTITION ||') UPDATE INDEXES';

    ELSIF V_PARTITION_COUNT = 0 AND V_PARTITION_TYP = 'RANGE' AND V_ADD_VALUE_TYPE IN ('3')
          AND TRIM(V_SPLIT_PARTITION) IS NOT NULL THEN

      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' SPLIT PARTITION ' || V_SPLIT_PARTITION ||' AT ('||V_ADD_VALUE_LESS_DATE ||')
               INTO (PARTITION '|| V_PARTITION_NAME ||',PARTITION '||V_SPLIT_PARTITION ||') UPDATE INDEXES';
    END IF;

    --DBMS_OUTPUT.PUT_LINE(V_SQL);
    EXECUTE IMMEDIATE V_SQL;
    ELSE
      V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' TRUNCATE PARTITION ' || V_SPLIT_PARTITION ||' UPDATE INDEXES'; --新增清空表空间步骤
      EXECUTE IMMEDIATE V_SQL;
  END IF;

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 增加分区程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME     := SYSDATE;
    V_STEP        := V_STEP + 1;
    V_STEP_DESC   := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_PARTITION_ADD;
/

