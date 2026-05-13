CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_ASSET_BUS_BREED(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_ASSET_BUS_BREED
  *  功能描述：资产业务品种表
  *  创建日期：20220315
  *  开发人员：严唯正
  *  来源表： IML.V_REF_ASSET_BUS_BREED
  *  目标表： O_IML_REF_ASSET_BUS_BREED
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220315  严唯正 首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_ASSET_BUS_BREED'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_ASSET_BUS_BREED'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_ASSET_BUS_BREED';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产业务品种表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_REF_ASSET_BUS_BREED NOLOGGING
    (ASSET_BUS_BREED_ID    --资产业务品种编号
    ,SORT_ID               --排序编号
    ,ASSET_BUS_BREED_NAME  --资产业务品种名称
    ,TYPE_SORT_ID          --类型排序编号
    ,SUB_TYPE              --子类型
    ,ATTR1                 --属性1
    ,ATTR2                 --属性2
    ,ATTR3                 --属性3
    ,ATTR4                 --属性4
    ,ATTR5                 --属性5
    ,ATTR6                 --属性6
    ,ATTR7                 --属性7
    ,ATTR8                 --属性8
    ,ATTR9                 --属性9
    ,ATTR10                --属性10
    ,ATTR11                --属性11
    ,ASSET_THD_CLS_CD      --资产三分类代码
    ,ATTR13                --属性13
    ,ATTR14                --属性14
    ,ATTR15                --属性15
    ,ATTR16                --属性16
    ,ATTR17                --属性17
    ,ATTR18                --属性18
    ,ATTR19                --属性19
    ,ATTR20                --属性20
    ,ATTR21                --属性21
    ,ATTR22                --属性22
    ,ATTR23                --属性23
    ,ATTR24                --属性24
    ,ATTR25                --属性25
    ,USE_FLG               --使用标志
    ,LOAN_SIZE_CTRL_FLG    --贷款规模控制标志
    ,PROD_CATLG_ID         --产品目录编号
    ,CREATE_DT             --创建日期
    ,UPDATE_DT             --更新日期
    ,ETL_DT                --数据日期
    ,ID_MARK               --删除标识
    ,SRC_TABLE_NAME        --源表名称
    ,JOB_CD                --任务代码
    )
  SELECT /*+PARALLEL*/
         ASSET_BUS_BREED_ID    --资产业务品种编号
        ,SORT_ID               --排序编号
        ,ASSET_BUS_BREED_NAME  --资产业务品种名称
        ,TYPE_SORT_ID          --类型排序编号
        ,SUB_TYPE              --子类型
        ,ATTR1                 --属性1
        ,ATTR2                 --属性2
        ,ATTR3                 --属性3
        ,ATTR4                 --属性4
        ,ATTR5                 --属性5
        ,ATTR6                 --属性6
        ,ATTR7                 --属性7
        ,ATTR8                 --属性8
        ,ATTR9                 --属性9
        ,ATTR10                --属性10
        ,ATTR11                --属性11
        ,ASSET_THD_CLS_CD      --资产三分类代码
        ,ATTR13                --属性13
        ,ATTR14                --属性14
        ,ATTR15                --属性15
        ,ATTR16                --属性16
        ,ATTR17                --属性17
        ,ATTR18                --属性18
        ,ATTR19                --属性19
        ,ATTR20                --属性20
        ,ATTR21                --属性21
        ,ATTR22                --属性22
        ,ATTR23                --属性23
        ,ATTR24                --属性24
        ,ATTR25                --属性25
        ,USE_FLG               --使用标志
        ,LOAN_SIZE_CTRL_FLG    --贷款规模控制标志
        ,PROD_CATLG_ID         --产品目录编号
        ,CREATE_DT             --创建日期
        ,UPDATE_DT             --更新日期
        ,ETL_DT                --数据日期
        ,ID_MARK               --删除标识
        ,SRC_TABLE_NAME        --源表名称
        ,JOB_CD                --任务代码
    FROM IML.V_REF_ASSET_BUS_BREED;  --资产业务品种表_视图
   --WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_REF_ASSET_BUS_BREED;
/

