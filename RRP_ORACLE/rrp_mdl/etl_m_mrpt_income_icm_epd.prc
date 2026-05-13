CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_INCOME_ICM_EPD(I_P_DATE IN INTEGER,
                                                      O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_INCOME_ICM_EPD
  *  功能描述：利息收支表-统计利息-手工报表专用
  *  创建日期：20221229
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO  利息收支信息
  *  目标表：RRP_MDL.M_MRPT_INCOME_ICM_EPD 利息收支表-统计利息-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221229  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_INCOME_ICM_EPD'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_PART_NAME   VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME    VARCHAR2(100);  --表名称

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_INCOME_ICM_EPD'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  /*--查询分区是否已经存在
  SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入利息收支表-统计利息-手工报表专用';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_INCOME_ICM_EPD NOLOGGING
  (
			DATA_DT, 	--数据日期
			RELA_FIELD, --关联字段
			BUS_TYPE_CD,--业务类型代码
			INCOME      --利息合计
  )
  SELECT /*+PARALLEL*/
         V_P_DATE DATA_DT,
         A.RELA_FIELD,
         A.BUS_TYPE_CD,
         SUM(CASE
               WHEN (A.INT_INCOME_EXPNSSUBJ_NO LIKE '6%' OR
                    (A.PRIN_SUBJ_NO NOT IN ('60110111', '64110204') AND
                    A.PRIN_SUBJ_NO LIKE '6%' AND
                    A.SOURCE_TABLE NOT IN
                    ('FTL_V_CMM_UNITE_DL_PROD_ENTRY_INFO-核心贷款'))) THEN
                A.INT_INCOME_EXPNS_D
               WHEN A.INT_ADJ_INCOME_EXPNS_SUBJ_NO LIKE '6%' THEN
                A.INT_ADJ_INCOME_EXPNS_D
               WHEN A.SPD_PL_SUBJ_NO LIKE '6%' THEN
                A.SPD_PL_D
               ELSE 0
             END) INCOME
    FROM RRP_MDL.O_FDW_FML_F03_INT_INCOME_EXPNS_INFO A --利息收支信息
   WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
     AND A.BUS_TYPE_CD <> 'UNIO'
   GROUP BY A.RELA_FIELD, A.BUS_TYPE_CD;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_INCOME_ICM_EPD;
/

