CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CUST_CORP_MAG_REL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CUST_CORP_MAG_REL_SUB
  *  功能描述：监管集市本部分填报持股5%以上及银行认为重要的股东及关联企业信息。
  *  创建日期：20220610
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_CORP_CUST_SHARD_INFO     --对公客户股东信息
  *            ICL.CMM_CORP_CUST_RELA_PS_INFO   --对公客户关联人信息
  *
  *  目标表：  M_CUST_CORP_MAG_REL_SUB  --重要股东及主要关联企业子表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20220901  MW        增加码值表模块判定
  *             2    20221101  xuxiaobin 修正股东证件类型为模型码值
  *             3    20221107  hulj      增加数据重复校验
  *             4    20221215  MW        存在多条数据为同一股东不同股东客户号，增加股东客户号为主键
  *             5    20250415  XZY       增加股东持股数量
  *             6    20250725  YJY       判断数据重复语句临时新增对持股比例、实际控制人标志的判断，以防数据重复调度报错。
                                         该表只有客户风险使用，后续验证数据再调研口径并调整逻辑
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_STEP_DESC VARCHAR2(100);               --处理步骤描述
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);               --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CUST_CORP_MAG_REL_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CUST_CORP_MAG_REL_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CUST_CORP_MAG_REL_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'B_GENERALIZE_INDEX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入重要股东及主要关联企业子表信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CUST_CORP_MAG_REL_SUB
    (DATA_DT                    --数据日期
    ,LGL_REP_ID                 --法人编号
    ,CUST_ID                    --客户编号
    ,REL_TYP_RSK                --关联类型（客户风险）
    ,SHRH_REL_ENT_NM            --股东/关联企业名称
    ,SHRH_REL_ENT_TYP           --股东/关联企业类型
    ,SHRH_REL_ENT_CRDL_TYP      --股东/关联企业证件类型
    ,SHRH_REL_ENT_CRDL_NO       --股东/关联企业证件号码
    ,REGD_CD                    --登记注册代码
    ,SHRH_REL_ENT_CUST_ID       --股东/关联企业客户编号
    ,CTRY_CD                    --国家代码
    ,HOLD_SHR_PCT               --持股比例
    ,SHRH_STRU_CRPND_DT         --股东结构对应日期
    ,UPD_INFO_DT                --更新信息日期
    ,ACT_CNTLR_FLG              --实际控制人标志
    ,REL_STAT                   --关联关系状态
    ,DEPT_LINE                  --部门条线
    ,DATA_SRC                   --数据来源
    ,SHARD_HOLD_SHARES_QTTY     --股东持股数量 ADD BY XZY 20250415
    )
  SELECT DISTINCT
         TO_CHAR(A.ETL_DT, 'YYYYMMDD')         AS DATA_DT                         --数据日期
        ,A.LP_ID                               AS LGL_REP_ID                      --法人编号
        ,A.CUST_ID                             AS CUST_ID                         --客户编号
        ,'1'                                   AS REL_TYP_RSK                     --关联类型（客户风险）
        ,A.SHARD_NAME                          AS SHRH_REL_ENT_NM                 --股东/关联企业名称
        ,NVL(E.TAR_VALUE_CODE,A.SHARD_TYPE_CD) AS SHRH_REL_ENT_TYP                --股东/关联企业类型
        ,CASE WHEN TRIM(A.NATURE_PS_SHARD_CERT_TYPE_CD) IS NOT NULL
              THEN A.NATURE_PS_SHARD_CERT_TYPE_CD
              WHEN TRIM(A.UNIFY_SOCI_CRDT_CD) IS NOT NULL
              THEN '2313'
              WHEN TRIM(A.SHARD_BUS_LICS_ID) IS NOT NULL
              THEN '2310'
              WHEN TRIM(A.SHARD_ORGNZ_CD) IS NOT NULL
              THEN '2020'
          END                                  AS SHRH_REL_ENT_CRDL_TYP           --股东/关联企业证件类型20221101 xuxiaobin 修正为模型层码值
        ,CASE WHEN TRIM(A.NATURE_PS_SHARD_CERT_NO) IS NOT NULL
              THEN A.NATURE_PS_SHARD_CERT_NO
              WHEN TRIM(A.UNIFY_SOCI_CRDT_CD) IS NOT NULL
              THEN A.UNIFY_SOCI_CRDT_CD
              WHEN TRIM(A.SHARD_BUS_LICS_ID) IS NOT NULL
              THEN A.SHARD_BUS_LICS_ID
              WHEN TRIM(A.SHARD_ORGNZ_CD) IS NOT NULL
              THEN A.SHARD_ORGNZ_CD
          END                                  AS SHRH_REL_ENT_CRDL_NO            --股东/关联企业证件号码
        ,CASE WHEN TRIM(D1.RGSTION_CD) IS NOT NULL
              THEN D1.RGSTION_CD
              WHEN TRIM(D2.RGSTION_CD) IS NOT NULL
              THEN D2.RGSTION_CD
              WHEN TRIM(D3.RGSTION_CD) IS NOT NULL
              THEN D3.RGSTION_CD
          END                                  AS REGD_CD                         --登记注册代码
        ,A.SHARD_CUST_ID                       AS SHRH_REL_ENT_CUST_ID            --股东/关联企业客户编号
        ,CASE WHEN TRIM(D1.CTY_RG_CD) IS NOT NULL
              THEN D1.CTY_RG_CD
              WHEN TRIM(D2.CTY_RG_CD) IS NOT NULL
              THEN D2.CTY_RG_CD
              WHEN TRIM(D3.CTY_RG_CD) IS NOT NULL
              THEN D3.CTY_RG_CD
          END                                  AS CTRY_CD                         --国家代码
        ,A.SHARE_RATIO                         AS HOLD_SHR_PCT                    --持股比例
        ,TO_CHAR(A.HOLD_DT,'YYYYMMDD')         AS SHRH_STRU_CRPND_DT              --股东结构对应日期
        ,NULL                                  AS UPD_INFO_DT                     --更新信息日期
        ,ACTL_CTRLER_FLG                       AS ACT_CNTLR_FLG                   --实际控制人标志
        ,'Y'                                   AS REL_STAT                        --关联关系状态
        ,NULL                                  AS DEPT_LINE                       --部门条线 /*'800926'公司银行总部*/
        ,SUBSTR(A.JOB_CD,0,4)                  AS DATA_SRC                        --数据来源
        ,A.SHARD_HOLD_SHARES_QTTY              AS SHARD_HOLD_SHARES_QTTY          --股东持股数量 ADD BY XZY 20250415
    FROM RRP_MDL.O_ICL_CMM_CORP_CUST_SHARD_INFO A --对公客户股东信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D1  --对公客户信息表
      ON D1.ORGNZ_CD = A.SHARD_ORGNZ_CD
     AND D1.CUST_NAME = A.SHARD_NAME
     AND D1.CUST_ID = A.CUST_ID
     AND TRIM(A.SHARD_ORGNZ_CD) IS NOT NULL
     AND D1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D2  --对公客户信息表
      ON D2.BUS_LICS_NUM = A.SHARD_BUS_LICS_ID
     AND D2.CUST_NAME = A.SHARD_NAME
     AND D2.CUST_ID = A.CUST_ID
     AND TRIM(A.SHARD_BUS_LICS_ID) IS NOT NULL
     AND D2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D3 --对公客户信息表
      ON D3.SOCI_CRDT_CD = A.UNIFY_SOCI_CRDT_CD
     AND D3.CUST_NAME = A.SHARD_NAME
     AND D3.CUST_ID = A.CUST_ID
     AND TRIM(A.SHARD_BUS_LICS_ID) IS NOT NULL
     AND D3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP E
      ON E.SRC_VALUE_CODE = A.SHARD_TYPE_CD
     AND E.SRC_CLASS_CODE = 'CD2030'   --股东类型代码
     AND E.TAR_CLASS_CODE = 'C0027'    --对公关系类型
     AND E.MOD_FLG = 'MDM'
   WHERE A.SHARE_RATIO >= 5
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
    SELECT DATA_DT,CUST_ID,SHRH_REL_ENT_CRDL_TYP,SHRH_REL_ENT_CRDL_NO,SHRH_REL_ENT_NM,SHRH_REL_ENT_CUST_ID,HOLD_SHR_PCT,ACT_CNTLR_FLG,COUNT(1)
      FROM RRP_MDL.M_CUST_CORP_MAG_REL_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,CUST_ID,SHRH_REL_ENT_CRDL_TYP,SHRH_REL_ENT_CRDL_NO,SHRH_REL_ENT_NM,SHRH_REL_ENT_CUST_ID,HOLD_SHR_PCT,ACT_CNTLR_FLG
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_SQLMSG   := '数据重复';
     V_ENDTIME  := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   
  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSDATE,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

END ETL_M_CUST_CORP_MAG_REL_SUB;
/

