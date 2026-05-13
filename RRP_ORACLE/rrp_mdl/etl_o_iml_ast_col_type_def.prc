CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AST_COL_TYPE_DEF(I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AST_COL_TYPE_DEF
  *  功能描述：押品类型定义表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AST_COL_TYPE_DEF
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20241227  YJY      优化脚本
  *             3    20251020  YJY      作业下线
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AST_COL_TYPE_DEF'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  
 /*  --MOD BY YJY 20251020
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_AST_COL_TYPE_DEF T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AST_COL_TYPE_DEF';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-押品类型定义表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AST_COL_TYPE_DEF
    (ETL_DT                  --数据日期
    ,COL_TYPE_CD             --押品类型代码
    ,COL_TYPE_NAME           --押品类型名称
    ,UP_LEVEL_NODE_TYPE_CD   --上层节点类型代码
    ,LEV                     --级别
    ,BASE_CATE_FLG           --基础类别标志
    ,SPCL_INFO_TYPE_CD       --专项信息类型代码
    ,KEYW_A                  --关键字段A
    ,EFFECT_WAY_CD           --生效方式代码
    ,COL_DESCB               --押品描述
    ,STATUS_DESCB            --状态描述
    ,ADMIT_CLS               --准入分类
    ,MODIF_DT                --修改日期
    ,MODIF_ORG_ID            --修改机构编号
    ,DATA_TYPE_CD            --数据类型代码
    ,GUAR_ADMIT_CLS_CD       --担保准入分类代码
    ,MODIF_EMPLY_ID          --修改员工编号
    ,REVAL_FREQ_CD           --重估频率代码
    ,HIGT_PM_RAT             --最高抵质押率
    ,KEYW_B                  --关键字段B
    ,GEN_CD                  --大类代码
    ,MANU_IDTFY_FLG          --人工认定标志
    ,TSHOLD                  --阀值
    ,STRIP_LINE_CD           --条线代码
    ,AB_DIVD_CD              --AB类划分代码
    ,KEYW_COMB_USE_FLG       --关键字段结合使用标志
    ,CREATE_DT               --创建日期
    ,UPDATE_DT               --更新日期
    ,ID_MARK                 --删除标识
    ,JOB_CD                  --任务代码
    )
  SELECT 
     ETL_DT                  --数据日期
    ,COL_TYPE_CD             --押品类型代码
    ,COL_TYPE_NAME           --押品类型名称
    ,UP_LEVEL_NODE_TYPE_CD   --上层节点类型代码
    ,LEV                     --级别
    ,BASE_CATE_FLG           --基础类别标志
    ,SPCL_INFO_TYPE_CD       --专项信息类型代码
    ,KEYW_A                  --关键字段A
    ,EFFECT_WAY_CD           --生效方式代码
    ,COL_DESCB               --押品描述
    ,STATUS_DESCB            --状态描述
    ,ADMIT_CLS               --准入分类
    ,MODIF_DT                --修改日期
    ,MODIF_ORG_ID            --修改机构编号
    ,DATA_TYPE_CD            --数据类型代码
    ,GUAR_ADMIT_CLS_CD       --担保准入分类代码
    ,MODIF_EMPLY_ID          --修改员工编号
    ,REVAL_FREQ_CD           --重估频率代码
    ,HIGT_PM_RAT             --最高抵质押率
    ,KEYW_B                  --关键字段B
    ,GEN_CD                  --大类代码
    ,MANU_IDTFY_FLG          --人工认定标志
    ,TSHOLD                  --阀值
    ,STRIP_LINE_CD           --条线代码
    ,AB_DIVD_CD              --AB类划分代码
    ,KEYW_COMB_USE_FLG       --关键字段结合使用标志
    ,CREATE_DT               --创建日期
    ,UPDATE_DT               --更新日期
    ,ID_MARK                 --删除标识
    ,JOB_CD                  --任务代码
    FROM IML.V_AST_COL_TYPE_DEF  --视图-押品类型定义表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AST_COL_TYPE_DEF', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
  */
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

END ETL_O_IML_AST_COL_TYPE_DEF;
/

