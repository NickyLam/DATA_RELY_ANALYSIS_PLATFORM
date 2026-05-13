CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_BOND_REPO_SUB(I_P_DATE IN INTEGER, --跑批日期
                                     O_ERRCODE  OUT VARCHAR2 --错误代码
                                     )
/***********************************************************************
  ************************************************************************
    **  存储过程详细说明：债券回购子表
    **  存储过程名称:  ETL_INIT_M_BOND_REPO_SUB
    **  存储过程创建日期:2022-7-13
    **  存储过程创建人:
    **  调用方法:
         DECLARE
           I_P_DATE INTEGER;
           O_ERRCODE  CHAR(5);
         BEGIN
           I_P_DATE := '20220307';
           ETL_INIT_M_BOND_REPO_SUB(I_P_DATE, O_ERRCODE);
         END;
    **  输入参数:   I_P_DATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **  20221123          新旧迁移                           xucx
    ************************************************************************
  ***********************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_BOND_REPO_SUB'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_COUNT_NUM INTEGER ; --数据数量
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_BOND_REPO_SUB'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

    -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '拆分资金债券表内组合数据';
  V_STARTTIME := SYSDATE;



  EXECUTE IMMEDIATE('TRUNCATE TABLE CMM_CAP_BOND_REPO ');
  SELECT COUNT(*) INTO V_COUNT_NUM FROM RRP_MDL.O_ICL_CMM_CAP_BOND_REPO;
  INSERT INTO CMM_CAP_BOND_REPO
  (ETL_DT,
  LP_ID,
  BUS_ID,
  CUST_ID,
  CURR_CD,
  BOND_FAC_VAL,
  BOND_ID,
  INPWN_RATIO,
  BOND_NAME,
  TRAN_ID,
  TRAN_AMT,
  JOB_CD,
  SUBJ_ID,
  STD_PROD_ID
  )
select * from
(SELECT
   A.ETL_DT,
   A.LP_ID,
   A.BUS_ID,
   A.CUST_ID,
   A.CURR_CD,
  substr(a.BOND_FAC_VAL_COMB, instr(a.BOND_FAC_VAL_COMB, ',', 1, levels.lvl) + 1,
  instr(a.BOND_FAC_VAL_COMB, ',', 1, levels.lvl + 1) -(instr(a.BOND_FAC_VAL_COMB, ',', 1, levels.lvl) + 1)) as BOND_FAC_VAL,

  substr(a.BOND_ID_COMB, instr(a.BOND_ID_COMB, ',', 1, levels.lvl) + 1,
  instr(a.BOND_ID_COMB, ',', 1, levels.lvl + 1) -(instr(a.BOND_ID_COMB, ',', 1, levels.lvl) + 1)) as BOND_ID,

  substr(a.INPWN_RATIO_COMB, instr(a.INPWN_RATIO_COMB, ',', 1, levels.lvl) + 1,
  instr(a.INPWN_RATIO_COMB, ',', 1, levels.lvl + 1) -(instr(a.INPWN_RATIO_COMB, ',', 1, levels.lvl) + 1)) as INPWN_RATIO,

  substr(a.BOND_NAME_COMB, instr(a.BOND_NAME_COMB, ',', 1, levels.lvl) + 1,
  instr(a.BOND_NAME_COMB, ',', 1, levels.lvl + 1) -(instr(a.BOND_NAME_COMB, ',', 1, levels.lvl) + 1)) as BOND_NAME,
   TRAN_ID,
   TRAN_AMT,
   JOB_CD,
   A.SUBJ_ID,
   A.STD_PROD_ID
FROM
(SELECT ETL_DT,LP_ID,BUS_ID,CUST_ID,CURR_CD,',' || BOND_FAC_VAL_COMB || ',' AS BOND_FAC_VAL_COMB,',' || BOND_ID_COMB || ',' AS BOND_ID_COMB,',' || INPWN_RATIO_COMB || ',' as INPWN_RATIO_COMB ,',' || BOND_NAME_COMB || ',' AS BOND_NAME_COMB,length(BOND_ID_COMB) - nvl(length(REPLACE(BOND_ID_COMB, ',')), 0) + 1 AS cnt --取待拆分字段每行按照分隔符','分割后的记录数，用于connect by
, TRAN_ID,
  TRAN_AMT,
  JOB_CD,
  SUBJ_ID,
  STD_PROD_ID
FROM O_ICL_CMM_CAP_BOND_REPO) a,
(SELECT rownum AS lvl --产生一个待拆分字段分割后最大记录数的序列
FROM (SELECT MAX(length(BOND_ID_COMB || ',') - nvl(length(REPLACE(BOND_ID_COMB, ',')), 0)) max_len FROM O_ICL_CMM_CAP_BOND_REPO )
CONNECT BY LEVEL <= max_len) levels
WHERE levels.lvl <= a.cnt --笛卡尔连接
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
ORDER BY BUS_ID);


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  /*程序处理过程*/
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入债券回购子表信息';
  V_STARTTIME := SYSDATE;


  INSERT INTO M_BOND_REPO_SUB
    (DATA_DT  --数据日期
    ,LGL_REP_ID  --法人编号
    ,BOND_ID  --债券编号
    ,BOND_NM  --债券名称
    ,BOND_TYP  --债券类型
    ,INPWN_RATIO  --质押比例
    ,BOND_FAC_VAL  --债券面值
    ,DEPT_LINE  --部门条线
    ,DATA_SRC  --数据来源
    ,TRA_ID  --交易编号
    ,TRA_AMT  --交易金额
    ,BUS_ID   --业务编号
    ,BOND_TYP_NM --债券类型名称
    ,COLL_TYP_CD --押品类型标志
   )
  SELECT
     TO_CHAR(A.ETL_DT,'YYYYMMDD') DATA_DT  --数据日期
    ,A.LP_ID                      LGL_REP_ID  --法人编号
    ,A.BOND_ID                    BOND_ID  --债券编号
    ,A.BOND_NAME                  BOND_NM  --债券名称
    ,B.BOND_TYPE_CD               BOND_TYP  --债券类型
    ,A.INPWN_RATIO                INPWN_RATIO  --质押比例
    ,A.BOND_FAC_VAL               BOND_FAC_VAL  --债券面值
    ,NULL                         DEPT_LINE  --部门条线
    ,SUBSTR(A.JOB_CD,0,4)         DATA_SRC  --数据来源
    ,A.TRAN_ID                    TRA_ID  --交易编号
    ,A.TRAN_AMT                   TRA_AMT  --交易金额
    ,A.BUS_ID                     BUS_ID  --业务编号
    ,B.BOND_CLS_NAME              BOND_TYP_NM --债券类型名称
    ,CASE WHEN A.SUBJ_ID IS NOT NULL AND A.STD_PROD_ID LIKE  '402030%' THEN '01'
          WHEN A.SUBJ_ID IS NOT NULL AND A.STD_PROD_ID LIKE  '401030%' THEN '02'
            END AS                COLL_TYP_CD --押品类型标志 (01--买入返售押品，02--卖出回购押品)
      FROM CMM_CAP_BOND_REPO A
      LEFT JOIN O_ICL_CMM_BOND_BASIC_INFO B
      ON A.BOND_ID = B.BOND_ID
      AND A.BOND_NAME = B.BOND_NAME
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND B.BOND_ID IS NOT NULL
     WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    -- AND B.BOND_TYPE_CD <> 'W' --取押卷类型，带W的是存单，用债卷编号关联BOND_TYPE_CD=BOND_ID
     --AND B.BOND_ID IS NOT NULL
     ;

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
    SELECT DATA_DT, BOND_ID,BUS_ID,TRA_ID,COUNT(1)
      FROM M_BOND_REPO_SUB T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, BOND_ID,BUS_ID,TRA_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;


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
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


END ETL_INIT_M_BOND_REPO_SUB;
/

