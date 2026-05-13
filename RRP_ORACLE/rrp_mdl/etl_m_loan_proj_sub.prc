CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_PROJ_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_PROJ_SUB
  *  功能描述：项目贷款子表
  *  创建日期：20220523
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_PROJ_SUB
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220523  梅炜      首次创建
  *             2    20221101  hulj      OTH_PERMIT --其他许可证调整取值
  *             3    20251226  LIP       调整项目名称取数
  ***************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;           --处理步骤
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);          --任务名称
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_PROJ_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_PROJ_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_LOAN_PROJ_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'ETL_M_LOAN_PROJ_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入项目贷款子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_PROJ_SUB
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,CONT_ID          --合同编号
    ,PROJ_NM          --项目名称
    ,PROJ_TYP         --项目类型
    ,PROJ_TOT_INVEST  --项目总投资
    ,CPTL_FND         --资本金
    ,APRV_NO          --批文文号
    ,PROJ_APRV        --立项批文
    ,LUPP_ID          --建设用地规划许可证编号
    ,LUPP_DT          --建设用地规划许可证日期
    ,EPP_ID           --建设工程规划许可证编号
    ,EPP_DT           --建设工程规划许可证日期
    ,CP_ID            --建筑工程施工许可证编号
    ,CP_DT            --建筑工程施工许可证日期
    ,SOLURC_ID        --国有土地使用证编号
    ,SOLURC_DT        --国有土地使用证日期
    ,OTH_PERMIT       --其他许可证
    ,OTH_PERMIT_ID    --其他许可证编号
    ,STRT_WORK_DT     --开工日期
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    )
  SELECT TO_CHAR(B.ETL_DT,'YYYYMMDD')       AS DATA_DT          --数据日期
        ,B.LP_ID                            AS LGL_REP_ID       --法人编号
        ,B.CONT_ID                          AS CONT_ID          --合同编号
        --,C.PROD_NAME                        AS PROJ_NM          --项目名称
        ,REPLACE(REPLACE(NVL(TRIM(T1.PROJECTNAME),C.PROD_NAME),CHR(10),''),CHR(13),'') AS PROJ_NM --项目名称 --MOD BY LIP 20251226
        ,CASE WHEN B.STD_PROD_ID = '203010200003' THEN '02' --房地产开发贷款
              WHEN B.STD_PROD_ID = '203010200004' THEN '01' --基础建设贷款
              WHEN B.STD_PROD_ID = '203010200005' THEN '03' --技术改造贷款
              WHEN B.STD_PROD_ID = '203010200006' THEN '06' --土地储备项目贷款
              WHEN B.STD_PROD_ID = '203010300001' THEN '05' --并购贷款
              ELSE '99'
          END                               AS PROJ_TYP         --项目类型
        ,D.PROJ_TOT_INVEST                  AS PROJ_TOT_INVEST  --项目总投资
        ,D.CAPITAL                          AS CPTL_FND         --资本金
        ,D.BATCH_NO                         AS APRV_NO          --批文文号
        ,D.SETUP_PROJ_BATCH_FILE            AS PROJ_APRV        --立项批文
        ,D.ARCH_LAND_LICS_ID                AS LUPP_ID          --建设用地规划许可证编号
        ,CASE WHEN TO_CHAR(D.LAND_PLAN_LICS_DT,'YYYYMMDD') IN ('00010101','29991231') THEN ''
              ELSE TO_CHAR(D.LAND_PLAN_LICS_DT,'YYYYMMDD')
          END                               AS LUPP_DT          --建设用地规划许可证日期
        ,D.PLAN_LICS_ID                     AS EPP_ID           --建设工程规划许可证编号
        ,CASE WHEN TO_CHAR(D.PROJ_PLAN_LICS_DT,'YYYYMMDD') IN ('00010101','29991231') THEN ''
              ELSE TO_CHAR(D.PROJ_PLAN_LICS_DT,'YYYYMMDD')
          END                               AS EPP_DT           --建设工程规划许可证日期
        ,D.CNSTR_LICS_ID                    AS CP_ID            --建筑工程施工许可证编号
        ,CASE WHEN TO_CHAR(D.CNSTR_LICS_DT,'YYYYMMDD') IN ('00010101','29991231') THEN ''
              ELSE TO_CHAR(D.CNSTR_LICS_DT,'YYYYMMDD')
          END                               AS CP_DT            --建筑工程施工许可证日期
        ,D.LAND_USE_CERT_ID                 AS SOLURC_ID        --国有土地使用证编号
        ,CASE WHEN TO_CHAR(D.LAND_USE_CERT_DT,'YYYYMMDD') IN ('00010101','29991231') THEN ''
              ELSE TO_CHAR(D.LAND_USE_CERT_DT,'YYYYMMDD')
          END                               AS SOLURC_DT        --国有土地使用证日期
        ,D.OTHER_LICS                       AS OTH_PERMIT       --其他许可证
        ,D.OTHER_LICS_ID                    AS OTH_PERMIT_ID    --其他许可证编号
        ,CASE WHEN TO_CHAR(D.START_WORK_DT,'YYYYMMDD') IN ('00010101','29991231') THEN ''
              ELSE TO_CHAR(D.START_WORK_DT,'YYYYMMDD')
          END                               AS STRT_WORK_DT     --开工日期
        ,'800919'                           AS DEPT_LINE        --部门条线/*风险管理部*/
        ,'项目贷款'                         AS DATA_SRC         --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO B  --对公贷款合同信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_STD_PROD_INFO C --标准产品信息
      ON C.PROD_ID = B.STD_PROD_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO D --对公贷款合同补充信息
      ON D.CONT_ID = B.CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IOL_ICMS_BC_EXTEND_D T1 --对公传统信贷业务合同个性化信息 --ADD BY LIP 20251226
      ON T1.SERIALNO = B.CONT_ID
     AND TRIM(T1.PROJECTNAME) IS NOT NULL
     AND T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.STD_PROD_ID IN ('203010200003','203010200004','203010200005','203010200006','203010300001')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_LOAN_PROJ_SUB;
/

