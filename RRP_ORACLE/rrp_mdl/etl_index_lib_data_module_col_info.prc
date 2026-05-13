CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INDEX_LIB_DATA_MODULE_COL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INDEX_LIB_DATA_MODULE_COL_INFO
  *  功能描述：数据模型字段信息表
  *  创建日期：20240312
  *  开发人员：tzj
  *  来源表：
  *  目标表：
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240312  tzj     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INDEX_LIB_DATA_MODULE_COL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(200);--表名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'INDEX_LIB_DATA_MODULE_COL_INFO';
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM INDEX_LIB_DATA_MODULE_COL_INFO ;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE INDEX_LIB_DATA_MODULE_COL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-数据模型字段信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.INDEX_LIB_DATA_MODULE_COL_INFO
  (
        COL_ID	           --字段ID
       ,MODULE_ID	         --模型ID
       ,COL_NAME_EN	       --字段英文名称
       ,COL_NAME	         --字段名称
       ,COL_TYPE	         --字段类型
       ,COL_LENGTH	       --长度
       ,COL_ACCURACY	     --精度
       ,SEQ	               --排序
       ,IS_NULL	           --是否可为空：可为空Y，不可为空N
       ,IS_PK	             --是否主键，时主键Y，不是主键N
       ,DIM_TYPE	         --维度类型
       ,MEASURE_TYPE	     --度量类型
       ,REMARK	           --备注


  )
  with tab_col as (select /*+ materialize*/owner,table_name,column_name,column_id,data_type,data_length,data_precision,nullable
                   from all_tab_columns
                  where owner in ('RRP_IND','RRP_BFD','RRP_CRRS','RRP_EAST','RRP_IMAS','RRP_MDL','RRP_DIIS')
                    and table_name<>'TAB$'),
     tab_com as (select /*+ materialize*/owner,table_name,column_name,comments
                   from all_col_comments
                  where owner in ('RRP_IND','RRP_BFD','RRP_CRRS','RRP_EAST','RRP_IMAS','RRP_MDL','RRP_DIIS')),
     tab_con as (select /*+ materialize*/owner,table_name,constraint_name
                   from ALL_CONS_COLUMNS
                  where owner in ('RRP_IND','RRP_BFD','RRP_CRRS','RRP_EAST','RRP_IMAS','RRP_MDL','RRP_DIIS'))
SELECT 
        --A.TABLE_NAME||'.'||A.COLUMN_NAME AS COL_ID,
        SYS_GUID()       AS COL_ID,
        A.TABLE_NAME     AS MODULE_ID,
        A.COLUMN_NAME    AS COL_NAME_EN,
        B.COMMENTS       AS COL_NAME,
        A.DATA_TYPE      AS COL_TYPE,
        A.DATA_LENGTH    AS COL_LENGTH,
        A.DATA_PRECISION AS COL_ACCURACY,
        A.COLUMN_ID      AS SEQ,
        A.NULLABLE       AS IS_NULL,
        CASE WHEN C.CONSTRAINT_NAME IS NULL THEN 'N' ELSE 'Y' END IS_PK,
        ''               AS DIM_TYPE,
        ''               AS MEASURE_TYPE,
        ''               AS REMARK
  FROM TAB_COL A
 INNER JOIN TAB_COM B
         ON A.OWNER = B.OWNER
        AND A.TABLE_NAME = B.TABLE_NAME
        AND A.COLUMN_NAME = B.COLUMN_NAME
  LEFT JOIN TAB_CON C
         ON A.OWNER = C.OWNER
        AND A.TABLE_NAME = C.TABLE_NAME
;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);
   V_STEP := 3;
   V_STEP_DESC := '-- 程序跑批结束 --';
   V_STARTTIME := SYSDATE;
   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   -- 程序跑批结束记录 --


   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INDEX_LIB_DATA_MODULE_COL_INFO;
/

