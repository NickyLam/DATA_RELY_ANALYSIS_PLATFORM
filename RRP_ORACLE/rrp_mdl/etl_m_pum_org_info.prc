CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_PUM_ORG_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
etl_m_pum_org_info  *  程序名称：ETL_M_PUM_ORG_INFO
  *  功能描述：监管集市银行机构或业务中心信息
  *  创建日期：20221208
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            IML.REF_POSTN_PARA  --职位参数
  *            ICL.CMM_CLERK_INFO  --行员信息表
  *  目标表：  M_PUM_ORG_INFO  --机构表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人        修改原因
  *             1    20221208  xuxiaobin     modify。
  *             2    20250321  linailian     一表通，增加县代码的取数逻辑。
  *             3    20251030  LTJ           增加一表通机构范围标识
  *             5    20251205  xieziyang     新增一表通机构转换表
  *             4    20260320    LAL         监管审检查的临时部门
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  --V_DEL_FLAG  VARCHAR2(2);            --删除标志
  --V_DEL_DATE  CHAR(8);                --数据删除日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(50) := 'M_PUM_ORG_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_PUM_ORG_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := TO_CHAR(I_P_DATE); --获取跑批日期
  --V_DEL_FLAG := SUBSTR(I_P_DATE, 7, 2);
  --V_DEL_DATE := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD') - 1,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --删除前一天历史数据，每月1号不删除历史数据
  /*IF V_DEL_FLAG != '01' THEN
    DELETE FROM RRP_MDL.M_PUM_ORG_INFO WHERE DATA_DT = V_DEL_DATE;
    COMMIT;
	  DELETE FROM RRP_MDL.M_PUM_ORG_INFO_YBT WHERE DATA_DT = V_DEL_DATE;
	  COMMIT;
  END IF;*/

  --支持重跑
  V_STEP := 1;
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
  ETL_PARTITION_ADD(V_P_DATE,'M_PUM_ORG_INFO_YBT', '1', O_ERRCODE); --ADD BY LIP 20251205
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  EXECUTE IMMEDIATE ('ALTER TABLE M_PUM_ORG_INFO_YBT TRUNCATE PARTITION '||V_PART_NAME);--ADD BY XIEZY 一表通机构转换表

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入目标表-内部机构表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_ORG_INFO
    (DATA_DT           --数据日期
     ,LGL_REP_ID        --法人编号
     ,ORG_ID            --机构编号
     ,PBC_NO            --人行支付行号
     ,FIN_PERMIT_NO     --金融许可证号
     ,USCC              --统一社会信用代码
     ,ORG_NM            --机构名称
     ,ORG_TYP           --机构类型
     ,OPR_STAT          --营业状态
     ,ESTM_DT           --成立日期
     ,ORG_ADDR          --机构地址
     ,PIC_NM            --负责人姓名
     ,PIC_JOB           --负责人职务
     ,PIC_TEL           --负责人联系电话
     ,UP_ORG_ID         --上级机构编号
     ,REGD_LAND_AREA_CD --注册地行政区划代码
     ,ORG_LVL           --机构级别
     ,FIN_ORG_ID        --金融机构编号
     ,OPR_STAT_END_DT   --营业状态结束日期
     ,ORG_TEL           --机构联系电话
     ,BSN_LCNS_REGD_NO  --营业执照注册号
     ,ORG_CD            --组织机构代码
     ,DEPT_LINE         --部门条线
     ,DATA_SRC          --数据来源
     ,GSFZJG            --归属分支机构
     ,IS_ENTITY         --是否实体机构
     ,ACCT_INSTIT_FLG   --账务标志
     ,COUNTY_CD         --县指标  ADD LINAL 20250321
     ,YBT_FLG           --一表通标识 ADD LTJ 20251030
    )
  SELECT  V_P_DATE                                                   AS DATA_DT           --数据日期
         ,A.LP_ID                                                    AS LGL_REP_ID        --法人编号
         ,A.ORG_ID                                                   AS ORG_ID            --机构编号
         ,NVL(TRIM(A.PBC_PAY_BANK_NO),T.PBC_NO)                      AS PBC_NO            --人行支付行号
         ,NVL(TRIM(A.FIN_LICS_NUM),T.FIN_PERMIT_NO)                  AS FIN_PERMIT_NO     --金融许可证号
         ,NVL(TRIM(A.BUS_LICS_NUM),T.BSN_LCNS_REGD_NO)               AS USCC              --统一社会信用代码
         ,NVL(TRIM(A.ORG_NAME),T.ORG_NM)                             AS ORG_NM            --机构名称
         ,NVL(CASE WHEN A.ACCTI_ORG_FLG = '1' THEN '01'
                   WHEN A.BUS_ORG_FLG = '1' THEN '02'
                   ELSE '04'
               END,T.ORG_TYP)                                        AS ORG_TYP           --机构类型
         ,NVL(CASE WHEN A.ORG_STATUS_CD = '2' THEN '01'
                   ELSE '02'
               END,T.OPR_STAT)                                       AS OPR_STAT          --营业状态
         ,NVL(TO_CHAR(A.ORG_FOUND_DT, 'YYYYMMDD'),T.ESTB_DT)         AS ESTM_DT           --成立日期
         ,NVL(TRIM(A.PHYS_ADDR),T.ORG_ADDR)                          AS ORG_ADDR          --机构地址
         ,NVL(TRIM(B.CLERK_NAME),T.PIC_NM)                           AS PIC_NM            --负责人姓名
         ,NVL(TRIM(G.POST_NAME),T.PIC_JOB)                           AS PIC_JOB           --负责人职务
         ,NVL(CASE WHEN B.WORK_TEL_AREA_CD IS NOT NULL
                    AND B.WORK_TEL_AREA_CD <> ' ' AND B.WORK_TEL_NUM IS NOT NULL
                    AND B.WORK_TEL_NUM <> ' ' THEN B.WORK_TEL_AREA_CD || '-' || B.WORK_TEL_NUM
                  ELSE B.MOBILE_PHONE_NUM
               END,T.PIC_TEL)                                        AS PIC_TEL           --负责人联系电话
         ,NVL(CASE WHEN TRIM(A.ACCTI_SUPER_ORG_ID) IS NULL OR A.ACCTI_SUPER_ORG_ID = '800001'
                   THEN A.ADMIN_SUPER_ORG_ID
                   ELSE A.ACCTI_SUPER_ORG_ID
               END,T.UP_ORG_ID)                                      AS UP_ORG_ID         --上级机构编号
         ,COALESCE(BL.REGD_LAND_AREA_CD,
                  CASE WHEN A.COUNTY_CD IS NOT NULL AND A.COUNTY_CD <> ' ' THEN A.COUNTY_CD
                       WHEN A.CITY_CD IS NOT NULL AND A.CITY_CD <> ' ' THEN A.CITY_CD
                       WHEN A.PROV_CD IS NOT NULL AND A.PROV_CD <> ' ' THEN A.PROV_CD
                   END,T.REGD_LAND_AREA_CD)                          AS REGD_LAND_AREA_CD --注册地行政区划代码
         ,NVL(TRIM(A.ORG_LEV_CD),T.ORG_LVL)                          AS ORG_LVL           --机构级别
         ,NVL(TRIM(A.FIN_INST_CODE),T.FIN_ORG_ID)                    AS FIN_ORG_ID        --金融机构编号
         ,NVL(TO_CHAR(A.ORG_REVO_DT,'YYYYMMDD'),T.OPR_STAT_END_DT)   AS OPR_STAT_END_DT   --营业状态结束日期
         --NVL(TRIM(A.PHONE),T.ORG_TEL)                               AS ORG_TEL,           --机构联系电话
         ,CASE WHEN TRIM(A.PHONE) IS NOT NULL AND TRIM(A.DDD_AREA_CD) IS NOT NULL THEN TRIM(A.DDD_AREA_CD)||'-'||TRIM(A.PHONE)
               WHEN TRIM(A.PHONE) IS NOT NULL THEN TRIM(A.PHONE)
               ELSE T.ORG_TEL
           END                                                       AS ORG_TEL           --机构联系电话
         ,NVL(CASE WHEN NVL(A.BUS_LICS_NUM, ' ') <> ' ' THEN A.BUS_LICS_NUM
                   WHEN NVL(C.BUS_LICS_NUM, ' ') <> ' ' THEN C.BUS_LICS_NUM
                   WHEN NVL(D.BUS_LICS_NUM, ' ') <> ' ' THEN D.BUS_LICS_NUM
                   ELSE E.BUS_LICS_NUM
               END,T.BSN_LCNS_REGD_NO)                               AS BSN_LCNS_REGD_NO  --营业执照注册号
         ,NVL(TRIM(A.ORGNZ_CD),T.ORG_CD)                             AS ORG_CD            --组织机构代码
         ,NULL                                                       AS DEPT_LINE         --部门条线
         ,'内部机构'                                                 AS DATA_SRC          --数据来源
         ,NULL                                                       AS GSFZJG            --归属分支机构
         ,CASE WHEN (A.ACCT_INSTIT_FLG = '1' AND A.ORG_ID NOT LIKE '%001' AND A.ORG_NAME NOT LIKE '%团队' AND A.ORG_ID NOT LIKE '%011')
                  OR (LENGTH(A.ORG_ID) = 3 AND A.ORG_ID NOT IN ('893','896','897','898','899','800','891'))
               THEN 'Y'
               ELSE 'N'
           END                                                       AS IS_ENTITY         --是否实体机构
         ,A.ACCT_INSTIT_FLG                                          AS ACCT_INSTIT_FLG   --账务机构标志
         ,A.COUNTY_CD                                                AS COUNTY_CD         --县指标  ADD LINAL 20250321
         /*,CASE WHEN (A.ACCTI_ORG_FLG = '1' 
                     OR A.ADMIN_SUPER_ORG_ID = '000000' 
                     OR A.ADMIN_SUPER_ORG_ID LIKE '800%' 
                     OR A.ORG_ID IN ('000000', '811'))
                AND A.ORG_ID NOT IN ('80505', '806994', \*'800992', '800721',*\ '812811')
                AND (A.ORG_ID = '896' OR A.ORG_ID NOT LIKE '896%')
               THEN 'Y' ELSE 'N'
           END                                                       AS YBT_FLG            --一表通标识  ADD LTJ 20251030*/
         ,CASE WHEN (A.ACCTI_ORG_FLG = '1' 
                     OR A.ADMIN_SUPER_ORG_ID = '000000' 
                     OR A.ADMIN_SUPER_ORG_ID LIKE '800%'
                     OR A.ORG_ID IN ('000000','811'))
                    AND A.ORG_ID NOT IN ('80505','806994','812811')
                    AND (A.ORG_ID = '896' OR A.ORG_ID NOT LIKE '896%')
                    AND A.ORG_ID NOT LIKE '%902'
                    AND TRIM(A.ORG_ID) <> '800107' --监管审检查的临时部门不报 MOD BY LAL 20260320
                    AND NVL(CASE WHEN A.ORG_STATUS_CD = '2' THEN '01' ELSE '02' END,T.OPR_STAT) IN ('01','08') --只取正常营业状态
               THEN 'Y' ELSE 'N'
           END                                                       AS YBT_FLG            --一表通标识  ADD LTJ 20251030
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO A --内部机构信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO B --行员信息表
      ON TRIM(B.CLERK_ID) = TRIM(A.PRINC_EMPLY_ID)
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息
      ON C.ORG_ID = A.ADMIN_SUPER_ORG_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO D --内部机构信息
      ON D.ORG_ID = C.ADMIN_SUPER_ORG_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*C.ETL_DT*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E --内部机构信息
      ON E.ORG_ID = D.ADMIN_SUPER_ORG_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*D.ETL_DT*/
    LEFT JOIN RRP_MDL.CODE_MAP F --数仓码值映射表
      ON F.SRC_VALUE_CODE = A.ORG_LEV_CD
     AND F.SRC_CLASS_CODE = 'CD1293'
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.ADD_M_PUM_ORG_INFO BL
      ON BL.ORG_ID = A.ORG_ID
     AND BL.START_DT <= V_P_DATE
     AND BL.END_DT > V_P_DATE
    LEFT JOIN RRP_MDL.O_IML_REF_POSTN_PARA G --职位参数
      ON G.POST_ID = B.POST_CD
    LEFT JOIN RRP_MDL.ADD_M_PUM_ORG_INFO T
      ON T.ORG_ID = A.ORG_ID
     AND T.START_DT <= V_P_DATE
     AND T.END_DT > V_P_DATE
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--MODIFY XUXIAOBIN 20220816

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '一表通机构转换表';--add by xiezy 20251205 新增一表通机构转换表
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_ORG_INFO_YBT
    (DATA_DT        --数据日期
    ,ORG_ID         --机构编号
    ,F_ORG_ID       --所属报送机构编号
    ,FIN_ORG_NO     --金融许可证号
    ,YBT_FLG        --一表通标识
    )
  WITH TMP_ORG_INFO (ST_ORG_ID,F_ORG_ID,ORG_BF,ORG_ID,ORG_AFT,FIN_PERMIT_NO,YBT_FLG,IF_ROLL,LVL)
       AS(SELECT ORG_ID          AS ST_ORG_ID,     --初始机构，用作关联用
                 CASE WHEN A.YBT_FLG = 'Y' THEN A.ORG_ID END AS F_ORG_ID,      --第一个需报送机构
                 ''              AS ORG_BF,        --前置机构
                 ORG_ID          AS ORG_ID,        --本身
                 A.UP_ORG_ID     AS ORG_AFT,       --后置机构（上级机构）
                 A.FIN_PERMIT_NO AS FIN_PERMIT_NO, --金融许可证号
                 A.YBT_FLG       AS YBT_FLG,       --一表通标识
                 CASE WHEN A.FIN_PERMIT_NO IS NOT NULL AND A.YBT_FLG = 'Y' THEN 0
                      ELSE 1
                  END            AS IF_ROLL, --递归标识
                 1               AS LVL            --级别
            FROM RRP_MDL.M_PUM_ORG_INFO A
           WHERE A.DATA_DT = V_P_DATE
          UNION ALL
          SELECT A.ST_ORG_ID     AS ST_ORG_ID,     --初始机构保持不变
                 CASE WHEN A.F_ORG_ID IS NULL AND B.YBT_FLG = 'Y' THEN B.ORG_ID
                      ELSE A.F_ORG_ID
                  END            AS F_ORG_ID,      --第一个需报送机构
                 A.ORG_ID        AS ORG_BF,        --前置机构
                 B.ORG_ID        AS ORG_ID,        --本身
                 B.UP_ORG_ID     AS ORG_AFT,       --后置机构（上级机构）
                 B.FIN_PERMIT_NO AS FIN_PERMIT_NO, --金融许可证号
                 B.YBT_FLG       AS YBT_FLG,       --一表通标识
                 CASE WHEN B.FIN_PERMIT_NO IS NOT NULL AND B.YBT_FLG = 'Y' THEN 0
                      ELSE 1
                  END            AS IF_ROLL, --递归标识
                 LVL+1           AS LVL      --级别
            FROM TMP_ORG_INFO A
           INNER JOIN RRP_MDL.M_PUM_ORG_INFO B
                   ON B.ORG_ID = A.ORG_AFT
                  AND A.IF_ROLL = 1
                  AND A.ORG_ID <> B.ORG_ID
                  AND B.DATA_DT = V_P_DATE),
  CON_YBT_FLG AS(SELECT --ST_ORG_ID AS ORG_ID,SUBSTR(FIN_PERMIT_NO,1,11)||F_ORG_ID  AS FIN_ORG_NO
                        ST_ORG_ID,F_ORG_ID,ORG_BF,ORG_ID,ORG_AFT,FIN_PERMIT_NO,YBT_FLG,IF_ROLL,LVL,
                        SUBSTR(FIN_PERMIT_NO,1,11)||F_ORG_ID AS FIN_ORG_NO
                   FROM TMP_ORG_INFO WHERE IF_ROLL = 0)
  SELECT V_P_DATE                         AS DATA_DT           --数据日期
        ,A.ST_ORG_ID                      AS ORG_ID            --机构编号
        ,A.F_ORG_ID                       AS F_ORG_ID          --所属报送机构编号
        ,SUBSTR(A.FIN_PERMIT_NO,1,11)||A.F_ORG_ID AS FIN_ORG_NO--金融许可证号拼接报送机构号
        ,B.YBT_FLG                        AS YBT_FLG           --一表通标识
    FROM CON_YBT_FLG A
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO B
           ON B.ORG_ID = A.ST_ORG_ID
          AND B.DATA_DT = V_P_DATE;

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
  SELECT DATA_DT,ORG_ID,COUNT(1)
    FROM RRP_MDL.M_PUM_ORG_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ORG_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_SQLMSG  := 'M_PUM_ORG_INFO数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  WITH TMP1 AS (
  SELECT DATA_DT,ORG_ID,COUNT(1)
    FROM RRP_MDL.M_PUM_ORG_INFO_YBT T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ORG_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_SQLMSG  := 'M_PUM_ORG_INFO_YBT数据重复';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析
  ETL_DBMS_STATS(V_P_DATE, 'M_PUM_ORG_INFO_YBT', V_PART_NAME, O_ERRCODE); --表分析

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

END ETL_M_PUM_ORG_INFO;
/

