CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SRC_DATA_HIS(I_P_DATE INTEGER)
IS
T_NUM NUMBER(10);           --表数据量计数
V_P_DATE VARCHAR2(8);       --数据日期
TABLE_NAME VARCHAR2(50);    --表名
V_STEP_DESC VARCHAR2(100);  --步骤描述
V_SQL VARCHAR2(2000);       --执行语句
CONDITION VARCHAR2(1000);   --视图抽数条件
CURSOR LIST_HDW IS SELECT * FROM VIEW_LIST_FROM_HDW ORDER BY ID;  --数据仓库视图接口清单
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);

  V_STEP_DESC := '清空一个月前数据';

  DELETE FROM SRC_DATA_HIS WHERE TO_DATE(DATA_DT,'YYYYMMDD') < ADD_MONTHS(TO_DATE(V_P_DATE,'YYYYMMDD'),-1);
  --清除一个月之前的数据
  V_STEP_DESC := '查询视图数据量';

  FOR TAB IN  LIST_HDW LOOP

  IF TAB.VALID_FLG = 'Y' THEN

  CONDITION := REPLACE(TAB.JUD_CONDITION,'V_P_DATE',V_P_DATE);
     V_SQL :=
     'SELECT COUNT(1) FROM
     '||TAB.VIEW_NAME|| CONDITION ||'' ;

  EXECUTE IMMEDIATE V_SQL INTO T_NUM ;

  V_STEP_DESC := '插入目标表';

  INSERT INTO SRC_DATA_HIS
  (
  ID                      --01接口序号
  ,TABLE_NAME             --02接口名称
  ,TABLE_NAME_CN          --03接口中文名称
  ,DATA_NUM               --04数据量
  ,DATA_DT                --05数据日期
  ,DATA_TIMESTAMP         --06查询时点
  ,SQL_QUERY              --07查询语句
  ,QUERY_DT               --08查询日期
  )
  SELECT
    TAB.ID                 AS ID       	          --01 接口序号
   ,TAB.TABLE_NAME         AS TABLE_NAME          --02 接口名称
   ,TAB.TABLE_NAME_CN      AS TABLE_NAME_CN       --03 接口中文名称
   ,T_NUM                  AS DATA_NUM            --04 数据量
   ,V_P_DATE               AS DATA_DT             --05 数据日期
   ,SYSDATE                AS DATA_TIMESTAMP      --06 查询时点
   ,V_SQL                  AS SQL_QUERY           --07 查询语句
   ,TO_CHAR(SYSDATE,'YYYYMMDD')
                           AS QUERY_DT            --08 查询日期
  FROM DUAL;

  COMMIT;
 END IF;
  END LOOP;


  V_STEP_DESC := '插入目标表结束';


END ETL_SRC_DATA_HIS;
/

