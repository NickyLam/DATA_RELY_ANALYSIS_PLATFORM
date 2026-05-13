CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_STD_PROD_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_STD_PROD_INFO
  *  功能描述：标准产品信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_STD_PROD_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_STD_PROD_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_STD_PROD_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_STD_PROD_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-标准产品信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_STD_PROD_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,PROD_ID  --产品编号
      ,PROD_NAME  --产品名称
      ,LEVEL1_PROD_ID  --一级产品编号
      ,LEVEL1_PROD_NAME  --一级产品名称
      ,LEVEL2_PROD_ID  --二级产品编号
      ,LEVEL2_PROD_NAME  --二级产品名称
      ,LEVEL3_PROD_ID  --三级产品编号
      ,LEVEL3_PROD_NAME  --三级产品名称
      ,LEVEL4_PROD_ID  --四级产品编号
      ,LEVEL4_PROD_NAME  --四级产品名称
      ,ISSUE_STATUS_CD  --发布状态代码
      ,PROD_LEV_CD  --产品级别代码
      ,PROD_STATUS_CD  --产品状态代码
      ,EFFECT_DT  --生效日期
      ,INVALID_DT  --失效日期
      ,PROD_SUM  --产品概述
      ,MGMT_DEPT_NAME  --管理部门名称
      ,MAP_RULE_DESCB  --映射规则描述
      ,BASE_PROD_ID  --基础产品编号
      ,COMB_PROD_FLG  --组合产品标志
      ,PROD_RANGE_CD  --产品作用范围代码
      ,PROVI_MERGE_FLG  --计提合并标志
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,PROD_ID  --产品编号
      ,PROD_NAME  --产品名称
      ,LEVEL1_PROD_ID  --一级产品编号
      ,LEVEL1_PROD_NAME  --一级产品名称
      ,LEVEL2_PROD_ID  --二级产品编号
      ,LEVEL2_PROD_NAME  --二级产品名称
      ,LEVEL3_PROD_ID  --三级产品编号
      ,LEVEL3_PROD_NAME  --三级产品名称
      ,LEVEL4_PROD_ID  --四级产品编号
      ,LEVEL4_PROD_NAME  --四级产品名称
      ,ISSUE_STATUS_CD  --发布状态代码
      ,PROD_LEV_CD  --产品级别代码
      ,PROD_STATUS_CD  --产品状态代码
      ,EFFECT_DT  --生效日期
      ,INVALID_DT  --失效日期
      ,PROD_SUM  --产品概述
      ,MGMT_DEPT_NAME  --管理部门名称
      ,MAP_RULE_DESCB  --映射规则描述
      ,BASE_PROD_ID  --基础产品编号
      ,COMB_PROD_FLG  --组合产品标志
      ,PROD_RANGE_CD  --产品作用范围代码
      ,PROVI_MERGE_FLG  --计提合并标志
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_STD_PROD_INFO  --视图-标准产品信息
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_INIT_O_ICL_CMM_STD_PROD_INFO;
/

