CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_CORP_CRDL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_CORP_CRDL_SUB
  *  功能描述：监管集市对公客户的证件子表
  *  创建日期：20220608
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_CORP_CUST_BASIC_INFO   --对公客户基本信息
  *            IML.PTY_PARTY_CERT_INFO_H      --当事人证件信息历史
  *
  *  目标表：  M_CUST_CORP_CRDL_SUB --对公客户证件子表
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  *             2    20220901  MW     增加码值表模块判定
  *             3    20221020  HULJ   增加证件号过滤条件
  *             4    20221107  HULJ   增加数据重复校验
  *             5    20260210  LIP    增加证件有效标志，排序时增加状态的排序
  **************************************************************************/
AS
  --定义变量
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STEP_DESC VARCHAR2(100);            --处理步骤描述
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_STEP      INTEGER := 0;             --处理步骤
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CUST_CORP_CRDL_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_CORP_CRDL_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 3;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

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
  V_STEP_DESC := '插入对公客户证件子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CUST_CORP_CRDL_SUB
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,CUST_ID        --客户编号
    ,CRDL_TYP       --证件类型
    ,CRDL_NO        --证件号码
    ,CRDL_EFF_DT    --证件生效日期
    ,CRDL_EXP_DT    --证件失效日期
    ,CRDL_UPD_DT    --证件更新日期
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,CRDL_TYP_ORIG  --原始证件类型
    ,CRDL_VAILD_FLG --证件有效标志 --ADD BY LIP 20260210
    )
    WITH TMP AS (
  SELECT /*+MATERIALIZE*/
         V_P_DATE                                     AS DATA_DT        --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID     --法人编号
        ,A.CUST_ID                                    AS CUST_ID        --客户编号
        ,B.CERT_TYPE_CD                               AS CRDL_TYP       --证件类型
        ,B.CERT_NUM                                   AS CRDL_NO        --证件号码        
        ,TO_CHAR(B.CERT_EFFECT_DT,'YYYYMMDD')         AS CRDL_EFF_DT    --证件生效日期
        ,TO_CHAR(B.CERT_INVALID_DT,'YYYYMMDD')        AS CRDL_EXP_DT    --证件失效日期
        ,NULL                                         AS CRDL_UPD_DT    --证件更新日期
        ,'04'                                         AS DEPT_LINE      --部门条线
        --,SUBSTR(A.JOB_CD,0,4)                         AS DATA_SRC       --数据来源
        ,SUBSTR(B.SORC_SYS_CD,0,4)                    AS DATA_SRC       --数据来源
        ,B.CERT_TYPE_CD                               AS CRDL_TYP_ORIG  --原始证件类型
        ,CASE WHEN B.CERT_VALID_FLG = '1' THEN 'Y'
              WHEN B.CERT_STATUS_CD = '1' THEN 'Y'
              ELSE 'N'
          END                                         AS CRDL_VAILD_FLG --证件有效标志 --ADD BY LIP 20260210
        --,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,C.TAR_VALUE_CODE,B.CERT_NUM ORDER BY B.CERT_EFFECT_DT DESC) AS ROWNUMBER
        ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ID,B.CERT_TYPE_CD,B.CERT_NUM
                           ORDER BY CASE WHEN B.CERT_VALID_FLG = '1' THEN '1' WHEN B.CERT_STATUS_CD = '1' THEN '1' ELSE '2' END,
                           B.CERT_EFFECT_DT DESC) AS ROWNUMBER --ADD BY LIP 20260210
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息
    LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H B --当事人证件信息历史
      ON B.PARTY_ID = A.CUST_ID
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    /*LEFT JOIN RRP_MDL.CODE_MAP C
      ON C.SRC_VALUE_CODE = B.CERT_TYPE_CD
     AND C.SRC_CLASS_CODE = 'CD1014'
     AND C.MOD_FLG = 'MDM'*/
   WHERE TRIM(B.CERT_NUM) IS NOT NULL
     AND B.CERT_TYPE_CD IS NOT NULL
     AND TRIM(B.CERT_NUM) <> '/'
     AND REPLACE(B.CERT_NUM,'*','') IS NOT NULL
     AND REPLACE(B.CERT_NUM,'0','') IS NOT NULL --MODIFY BY HLJ 20221020
     AND A.CUST_ID IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT DISTINCT DATA_DT
         ,LGL_REP_ID
         ,CUST_ID
         ,CRDL_TYP
         ,CRDL_NO
         ,CRDL_EFF_DT
         ,CRDL_EXP_DT
         ,CRDL_UPD_DT
         ,DEPT_LINE
         ,DATA_SRC
         ,CRDL_TYP_ORIG
         ,CRDL_VAILD_FLG --证件有效标志 --ADD BY LIP 20260210
    FROM TMP
   WHERE ROWNUMBER = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT,CUST_ID,CRDL_NO,CRDL_TYP,COUNT(1)
      FROM RRP_MDL.M_CUST_CORP_CRDL_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,CUST_ID,CRDL_NO,CRDL_TYP
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_ENDTIME  := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

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

END ETL_M_CUST_CORP_CRDL_SUB;
/

