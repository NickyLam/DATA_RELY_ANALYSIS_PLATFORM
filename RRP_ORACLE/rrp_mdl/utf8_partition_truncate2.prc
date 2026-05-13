CREATE OR REPLACE PROCEDURE RRP_MDL.UTF8_PARTITION_TRUNCATE2(I_DATADATE       IN INTEGER, --跑批日期
                                              I_SCHEMA         IN VARCHAR2,--表用户
                                              I_TABLE_NAME     IN VARCHAR2, --表名称
                                              O_ERRCODE        OUT VARCHAR2 --错误代码
                                              )
/***********************************************************************

  ***********************************************************************/
IS
  V_TABLE_NAME          VARCHAR2(100); --表名称
  V_SCHEMA              VARCHAR2(100); --模式名称
  V_PARTITION_NAME      VARCHAR2(100); --分区名称
  V_COUNT               INTEGER; --数据记录条数
  V_SQL                 VARCHAR2(1000); --创建分区脚本
  V_P_DATE    VARCHAR2(8);                              -- 跑批数据日期
  V_SQLMSG    VARCHAR2(300);                            -- SQL执行描述信息


BEGIN
  V_P_DATE         := TO_CHAR(I_DATADATE);
  V_TABLE_NAME     := UPPER(I_TABLE_NAME);
  V_SCHEMA         := I_SCHEMA;
  O_ERRCODE        := '0';
  V_COUNT          := 0;
  V_P_DATE   := V_P_DATE;                               -- 获取跑批日期


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
  SELECT count(1) INTO V_COUNT
    FROM ALL_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.TABLE_OWNER = V_SCHEMA
     AND T.PARTITION_NAME like '%'||V_P_DATE||'%';
  IF V_COUNT = 0 THEN
     insert into er_log values (to_date(V_P_DATE,'yyyymmdd'),V_SCHEMA||'.'||V_TABLE_NAME||V_P_DATE||'partition not exists');
     commit;
     RETURN;
  END IF;

  --查看当日分区是否已存在
  SELECT T.PARTITION_NAME INTO V_PARTITION_NAME
    FROM ALL_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.TABLE_OWNER = V_SCHEMA
     AND T.PARTITION_NAME like '%'||V_P_DATE||'%'
   GROUP BY T.PARTITION_NAME;

  IF V_PARTITION_NAME is null THEN
     RETURN;
  ELSE
      V_SQL := 'ALTER TABLE ' || V_SCHEMA || '.' || V_TABLE_NAME || ' TRUNCATE PARTITION ' || V_PARTITION_NAME ||' UPDATE INDEXES'; --新增清空表空间步骤
      EXECUTE IMMEDIATE V_SQL;
      DBMS_OUTPUT.PUT_LINE(V_SQL);
  END IF;


  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE        := '1';
    ROLLBACK;
    insert into er_log values (to_date(V_P_DATE,'yyyymmdd'),V_SQLMSG);
    commit;
END UTF8_PARTITION_TRUNCATE2;
/

