CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_PUM_ORG_INFO_EAST_TEST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_PUM_ORG_INFO_EAST
  *  功能描述：监管集市银行机构或业务中心信息
  *  创建日期：20220518
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_INTNAL_ORG_INFO --内部机构信息
  *            IML.REF_POSTN_PARA  --职位参数
  *            ICL.CMM_CLERK_INFO  --行员信息表
  *            IOL.MPCS_A08TBANKINFO  --中台机构信息表
  *  目标表：  M_PUM_ORG_INFO_EAST  --机构表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220816  hulj     归属分支机构字段及取数逻辑。
  *             2    20221108  hulj     增加数据重复校验
  *             3    20230804  lip      ORG_CONFIG表中增加中台的机构名
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);                               --处理步骤描述
  V_P_DATE    VARCHAR2(8);                                 --跑批数据日期
  V_DEL_FLAG  VARCHAR2(2);                                 --删除标志
  V_DEL_DATE  CHAR(8);                                     --数据删除日期
  V_STARTTIME DATE;                                        --处理开始时间
  V_ENDTIME   DATE;                                        --处理结束时间
  V_SQLMSG    VARCHAR2(300);                               --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                               --分区名
  V_SQL_STR   VARCHAR2(100);                               --动态语句
  V_STEP      INTEGER := 0;                                --处理步骤
  V_SQLCOUNT  INTEGER := 0;                                --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_PUM_ORG_INFO_EAST';  --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'M_PUM_ORG_INFO_EAST';      --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送';                  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE   := TO_CHAR( I_P_DATE); --获取跑批日期
  V_DEL_FLAG := SUBSTR(V_P_DATE, 7, 2);
  V_DEL_DATE := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  ---删除前一天历史数据，每月1号不删除历史数据
  IF V_DEL_FLAG != '01' THEN
    DELETE FROM RRP_MDL.M_PUM_ORG_INFO_EAST WHERE DATA_DT = V_DEL_DATE;
    COMMIT;
  END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '机构表-临时表数据处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_M_PUM_ORG_INFO';
  INSERT INTO RRP_MDL.TMP_M_PUM_ORG_INFO
    (DATA_DT,              --数据日期
     LGL_REP_ID,           --法人编号
     ORG_ID,               --机构编号
     PBC_NO,               --人行支付行号
     FIN_PERMIT_NO,        --金融许可证号
     USCC,                 --统一社会信用代码
     ORG_NM,               --机构名称
     ORG_TYP,              --机构类型
     OPR_STAT,             --营业状态
     ESTB_DT,              --成立日期
     ORG_ADDR,             --机构地址
     PIC_NM,               --负责人姓名
     PIC_JOB,              --负责人职务
     PIC_TEL,              --负责人联系电话
     UP_ORG_ID,            --上级机构编号
     REGD_LAND_AREA_CD,    --注册地行政区划代码
     ORG_LVL,              --机构级别
     FIN_ORG_ID,           --金融机构编号
     OPR_STAT_END_DT,      --营业状态结束日期
     ORG_TEL,              --机构联系电话
     BSN_LCNS_REGD_NO,     --营业执照注册号
     ORG_CD,               --组织机构代码
     DEPT_LINE,            --部门条线
     DATA_SRC,             --数据来源
     IS_ENTITY             --是否实体机构
     )
    WITH YXJG AS --筛选有效机构
     (SELECT ORG_ID,   --机构编号
             CASE WHEN TRIM(ACCTI_SUPER_ORG_ID) IS NULL OR ACCTI_SUPER_ORG_ID = '800001'
                  THEN ADMIN_SUPER_ORG_ID
                  ELSE ACCTI_SUPER_ORG_ID
              END AS SUPER_ORG_ID --上级机构编号
        FROM RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO --内部机构信息
       WHERE (ACCTI_ORG_FLG = '1' OR ADMIN_SUPER_ORG_ID = '000000' OR ORG_ID IN ('000000', '811'))
         AND ORG_ID NOT IN ('80505', '806994', '800992', '800721', '812811')
         AND (ORG_ID = '896' OR ORG_ID NOT LIKE '896%') --MODIFY BY CYL 20220415 根据EAST4.0逻辑筛选机构 如果业务反馈不报送896开头则再修改
         AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    YXJG_ALL AS --有效机构去重
     (SELECT DISTINCT ORG_ID
        FROM (SELECT ORG_ID FROM YXJG
               UNION ALL
              SELECT SUPER_ORG_ID AS ORG_ID FROM YXJG WHERE SUPER_ORG_ID <> '999999'))
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                    AS DATA_DT,              --数据日期
         A.LP_ID                                          AS LGL_REP_ID,           --法人编号
         A.ORG_ID                                         AS ORG_ID,               --机构编号
         CASE WHEN NVL(A.PBC_PAY_BANK_NO, ' ') <> ' ' THEN TRIM(A.PBC_PAY_BANK_NO)
              WHEN NVL(C.PBC_PAY_BANK_NO, ' ') <> ' ' THEN TRIM(C.PBC_PAY_BANK_NO)
              WHEN NVL(D.PBC_PAY_BANK_NO, ' ') <> ' ' THEN TRIM(D.PBC_PAY_BANK_NO)
              ELSE TRIM(E.PBC_PAY_BANK_NO)
          END                                             AS PBC_NO,               --人行支付行号
         CASE WHEN NVL(A.FIN_LICS_NUM, ' ') <> ' ' THEN TRIM(A.FIN_LICS_NUM)
              WHEN NVL(C.FIN_LICS_NUM, ' ') <> ' ' THEN TRIM(C.FIN_LICS_NUM)
              WHEN NVL(D.FIN_LICS_NUM, ' ') <> ' ' THEN TRIM(D.FIN_LICS_NUM)
              ELSE TRIM(E.FIN_LICS_NUM)
          END                                             AS FIN_PERMIT_NO,        --金融许可证号
         NULL                                             AS USCC,                 --统一社会信用代码
         TRIM(A.ORG_NAME)                                 AS ORG_NM,               --机构名称
         CASE WHEN A.ACCTI_ORG_FLG = '1' THEN '01'
              WHEN A.BUS_ORG_FLG = '1' THEN '02'
              ELSE '04'
          END                                             AS ORG_TYP,              --机构类型
         CASE WHEN A.ORG_STATUS_CD = '2' THEN '01'
              ELSE '02'
          END                                             AS OPR_STAT,             --营业状态
         TO_CHAR(A.ORG_FOUND_DT, 'YYYYMMDD')              AS ESTB_DT,              --成立日期
         TRIM(A.PHYS_ADDR)                                AS ORG_ADDR,             --机构地址
         TRIM(B.CLERK_NAME)                               AS PIC_NM,               --负责人姓名
         TRIM(G.POST_NAME)                                AS PIC_JOB,              --负责人职务
         CASE WHEN B.WORK_TEL_AREA_CD IS NOT NULL AND B.WORK_TEL_AREA_CD <> ' ' AND B.WORK_TEL_NUM IS NOT NULL
                   AND B.WORK_TEL_NUM <> ' ' THEN B.WORK_TEL_AREA_CD || '-' || B.WORK_TEL_NUM
              ELSE B.MOBILE_PHONE_NUM
          END                                             AS PIC_TEL,              --负责人联系电话 MODIFY BY CYL 20220415 根据EAST4.0逻辑修改
         CASE WHEN TRIM(A.ACCTI_SUPER_ORG_ID) IS NULL OR A.ACCTI_SUPER_ORG_ID = '800001'
              THEN A.ADMIN_SUPER_ORG_ID
              ELSE A.ACCTI_SUPER_ORG_ID
          END                                             AS UP_ORG_ID,            --上级机构编号
         CASE WHEN A.COUNTY_CD IS NOT NULL AND A.COUNTY_CD <> ' ' THEN A.COUNTY_CD
              WHEN A.CITY_CD IS NOT NULL AND A.CITY_CD <> ' ' THEN A.CITY_CD
              WHEN A.PROV_CD IS NOT NULL AND A.PROV_CD <> ' ' THEN A.PROV_CD
          END                                             AS REGD_LAND_AREA_CD,    --注册地行政区划代码
         A.ORG_LEV_CD                                     AS ORG_LVL,              --机构级别
         TRIM(A.FIN_INST_CODE)                            AS FIN_ORG_ID,           --金融机构编号
         NULL                                             AS OPR_STAT_END_DT,      --营业状态结束日期
         /*A.PHONE                                          AS ORG_TEL,              --机构联系电话*/
         --MOD BY 20240202
         CASE WHEN TRIM(A.PHONE) IS NOT NULL AND TRIM(A.DDD_AREA_CD) IS NOT NULL THEN TRIM(A.DDD_AREA_CD)||'-'||TRIM(A.PHONE)
              WHEN TRIM(A.PHONE) IS NOT NULL THEN TRIM(A.PHONE)
          END                                                        AS ORG_TEL,   --机构联系电话
         CASE WHEN NVL(A.BUS_LICS_NUM, ' ') <> ' ' THEN TRIM(A.BUS_LICS_NUM)
              WHEN NVL(C.BUS_LICS_NUM, ' ') <> ' ' THEN TRIM(C.BUS_LICS_NUM)
              WHEN NVL(D.BUS_LICS_NUM, ' ') <> ' ' THEN TRIM(D.BUS_LICS_NUM)
              ELSE TRIM(E.BUS_LICS_NUM)
          END                                             AS BSN_LCNS_REGD_NO,     --营业执照注册号
         NULL                                             AS ORG_CD,               --组织机构代码
         '800914'                                         AS DEPT_LINE,            --部门条线 办公室
         SUBSTR(A.JOB_CD, 0, 4)                           AS DATA_SRC,             --数据来源
         CASE WHEN (A.ACCT_INSTIT_FLG ='1' AND A.ORG_ID NOT LIKE '%001' AND A.ORG_NAME NOT LIKE '%团队' AND A.ORG_ID NOT LIKE '%011')
                  OR (LENGTH(A.ORG_ID)=3 AND A.ORG_ID NOT IN ('893','896','897','898','899','800','891'))
              THEN 'Y'
              ELSE 'N'
          END                                             AS IS_ENTITY             --是否实体机构
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO A --内部机构信息
   INNER JOIN YXJG_ALL AA --有效机构
      ON AA.ORG_ID = A.ORG_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CLERK_INFO B --行员信息表
      ON TRIM(B.CLERK_ID) = TRIM(A.PRINC_EMPLY_ID)
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息
      ON C.ORG_ID = A.ADMIN_SUPER_ORG_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO D --内部机构信息
      ON D.ORG_ID = C.ADMIN_SUPER_ORG_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO E --内部机构信息
      ON E.ORG_ID = D.ADMIN_SUPER_ORG_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP F --数仓码值映射表
      ON F.SRC_VALUE_CODE = A.ORG_LEV_CD
     AND F.SRC_CLASS_CODE = 'CD1293'
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_REF_POSTN_PARA G --职位参数
      --ON G.POST_ID = B.POST_CD
      ON G.POST_ID = B.POSTN_CD   --20221208 LHQ  根据缺陷BUG_063430数仓反馈修改
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --20230128 MW 增加数据日期限定
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入目标表-以临时表数据为准';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_ORG_INFO_EAST
    (DATA_DT,              --数据日期
     LGL_REP_ID,           --法人编号
     ORG_ID,               --机构编号
     PBC_NO,               --人行支付行号
     FIN_PERMIT_NO,        --金融许可证号
     USCC,                 --统一社会信用代码
     ORG_NM,               --机构名称
     ORG_TYP,              --机构类型
     OPR_STAT,             --营业状态
     ESTM_DT,              --成立日期
     ORG_ADDR,             --机构地址
     PIC_NM,               --负责人姓名
     PIC_JOB,              --负责人职务
     PIC_TEL,              --负责人联系电话
     UP_ORG_ID,            --上级机构编号
     REGD_LAND_AREA_CD,    --注册地行政区划代码
     ORG_LVL,              --机构级别
     FIN_ORG_ID,           --金融机构编号
     OPR_STAT_END_DT,      --营业状态结束日期
     ORG_TEL,              --机构联系电话
     BSN_LCNS_REGD_NO,     --营业执照注册号
     ORG_CD,               --组织机构代码
     DEPT_LINE,            --部门条线
     DATA_SRC,             --数据来源
     GSFZJG,               --归属分支机构
     IS_ENTITY             --是否实体机构
     )
  SELECT V_P_DATE                                      AS DATA_DT,                   --数据日期
         T.LGL_REP_ID                                  AS LGL_REP_ID,                --法人编号
         T.ORG_ID                                      AS ORG_ID,                    --机构编号
         T.PBC_NO                                      AS PBC_NO,                    --人行支付行号
         T.FIN_PERMIT_NO                               AS FIN_PERMIT_NO,             --金融许可证号
         T.USCC                                        AS USCC,                      --统一社会信用代码
         T.ORG_NM                                      AS ORG_NM,                    --机构名称
         T.ORG_TYP                                     AS ORG_TYP,                   --机构类型
         T.OPR_STAT                                    AS OPR_STAT,                  --营业状态
         T.ESTB_DT                                     AS ESTB_DT,                   --成立日期
         T.ORG_ADDR                                    AS ORG_ADDR,                  --机构地址
         T.PIC_NM                                      AS PIC_NM,                    --负责人姓名
         T.PIC_JOB                                     AS PIC_JOB,                   --负责人职务
         T.PIC_TEL                                     AS PIC_TEL,                   --负责人联系电话
         T.UP_ORG_ID                                   AS UP_ORG_ID,                 --上级机构编号
         T.REGD_LAND_AREA_CD                           AS REGD_LAND_AREA_CD,         --注册地行政区划代码
         T.ORG_LVL                                     AS ORG_LVL,                   --机构级别
         T.FIN_ORG_ID                                  AS FIN_ORG_ID,                --金融机构编号
         T.OPR_STAT_END_DT                             AS OPR_STAT_END_DT,           --营业状态结束日期
         T.ORG_TEL                                     AS ORG_TEL,                   --机构联系电话
         T.BSN_LCNS_REGD_NO                            AS BSN_LCNS_REGD_NO,          --营业执照注册号
         T.ORG_CD                                      AS ORG_CD,                    --组织机构代码
         T.DEPT_LINE                                   AS DEPT_LINE,                 --部门条线
         T.DATA_SRC                                    AS DATA_SRC,                  --数据来源
         NVL(SUBSTR(T.REGD_LAND_AREA_CD,1,4),'4400')   AS GSFZJG,                    --归属分支机构
         NVL(T.IS_ENTITY,'N')                          AS IS_ENTITY                  --是否实体机构
    FROM RRP_MDL.TMP_M_PUM_ORG_INFO T;
  /*SELECT V_P_DATE                                      AS DATA_DT,                   --数据日期
         NVL(A.LGL_REP_ID, T.LGL_REP_ID)               AS LGL_REP_ID,                --法人编号
         NVL(A.ORG_ID, T.ORG_ID)                       AS ORG_ID,                    --机构编号
         NVL(A.PBC_NO, T.PBC_NO)                       AS PBC_NO,                    --人行支付行号
         NVL(A.FIN_PERMIT_NO, T.FIN_PERMIT_NO)         AS FIN_PERMIT_NO,             --金融许可证号
         NVL(A.USCC, T.USCC)                           AS USCC,                      --统一社会信用代码
         NVL(A.ORG_NM, T.ORG_NM)                       AS ORG_NM,                    --机构名称
         NVL(A.ORG_TYP, T.ORG_TYP)                     AS ORG_TYP,                   --机构类型
         NVL(A.OPR_STAT, T.OPR_STAT)                   AS OPR_STAT,                  --营业状态
         NVL(A.ESTB_DT, T.ESTB_DT)                     AS ESTB_DT,                   --成立日期
         NVL(A.ORG_ADDR, T.ORG_ADDR)                   AS ORG_ADDR,                  --机构地址
         NVL(A.PIC_NM, T.PIC_NM)                       AS PIC_NM,                    --负责人姓名
         NVL(A.PIC_JOB, T.PIC_JOB)                     AS PIC_JOB,                   --负责人职务
         NVL(A.PIC_TEL, T.PIC_TEL)                     AS PIC_TEL,                   --负责人联系电话
         NVL(A.UP_ORG_ID, T.UP_ORG_ID)                 AS UP_ORG_ID,                 --上级机构编号
         NVL(A.REGD_LAND_AREA_CD, T.REGD_LAND_AREA_CD) AS REGD_LAND_AREA_CD,         --注册地行政区划代码
         NVL(A.ORG_LVL, T.ORG_LVL)                     AS ORG_LVL,                   --机构级别
         NVL(A.FIN_ORG_ID, T.FIN_ORG_ID)               AS FIN_ORG_ID,                --金融机构编号
         NVL(A.OPR_STAT_END_DT, T.OPR_STAT_END_DT)     AS OPR_STAT_END_DT,           --营业状态结束日期
         NVL(A.ORG_TEL, T.ORG_TEL)                     AS ORG_TEL,                   --机构联系电话
         NVL(A.BSN_LCNS_REGD_NO, T.BSN_LCNS_REGD_NO)   AS BSN_LCNS_REGD_NO,          --营业执照注册号
         NVL(A.ORG_CD, T.ORG_CD)                       AS ORG_CD,                    --组织机构代码
         NVL(A.DEPT_LINE, T.DEPT_LINE)                 AS DEPT_LINE,                 --部门条线
         NVL(A.DATA_SRC, T.DATA_SRC)                   AS DATA_SRC,                  --数据来源
         NVL(SUBSTR(NVL(A.REGD_LAND_AREA_CD,T.REGD_LAND_AREA_CD),1,4),'4400') AS GSFZJG, --归属分支机构
         NVL(T.IS_ENTITY,'N')                          AS IS_ENTITY                  --是否实体机构
    FROM RRP_MDL.TMP_M_PUM_ORG_INFO T
    LEFT JOIN RRP_MDL.ADD_M_PUM_ORG_INFO A
      ON A.ORG_ID = T.ORG_ID
     AND A.START_DT <= V_P_DATE
     AND A.END_DT > V_P_DATE;*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /*-- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入目标表-以静态表数据为准';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_PUM_ORG_INFO_EAST
    (DATA_DT,              --数据日期
     LGL_REP_ID,           --法人编号
     ORG_ID,               --机构编号
     PBC_NO,               --人行支付行号
     FIN_PERMIT_NO,        --金融许可证号
     USCC,                 --统一社会信用代码
     ORG_NM,               --机构名称
     ORG_TYP,              --机构类型
     OPR_STAT,             --营业状态
     ESTM_DT,              --成立日期
     ORG_ADDR,             --机构地址
     PIC_NM,               --负责人姓名
     PIC_JOB,              --负责人职务
     PIC_TEL,              --负责人联系电话
     UP_ORG_ID,            --上级机构编号
     REGD_LAND_AREA_CD,    --注册地行政区划代码
     ORG_LVL,              --机构级别
     FIN_ORG_ID,           --金融机构编号
     OPR_STAT_END_DT,      --营业状态结束日期
     ORG_TEL,              --机构联系电话
     BSN_LCNS_REGD_NO,     --营业执照注册号
     ORG_CD,               --组织机构代码
     DEPT_LINE,            --部门条线
     DATA_SRC,             --数据来源
     GSFZJG,               --归属分支机构
     IS_ENTITY             --是否实体机构
     )
  SELECT V_P_DATE            AS DATA_DT,                        --数据日期
         T.LGL_REP_ID        AS LGL_REP_ID,                     --法人编号
         T.ORG_ID            AS ORG_ID,                         --机构编号
         T.PBC_NO            AS PBC_NO,                         --人行支付行号
         T.FIN_PERMIT_NO     AS FIN_PERMIT_NO,                  --金融许可证号
         T.USCC              AS USCC,                           --统一社会信用代码
         T.ORG_NM            AS ORG_NM,                         --机构名称
         T.ORG_TYP           AS ORG_TYP,                        --机构类型
         T.OPR_STAT          AS OPR_STAT,                       --营业状态
         T.ESTB_DT           AS ESTB_DT,                        --成立日期
         T.ORG_ADDR          AS ORG_ADDR,                       --机构地址
         T.PIC_NM            AS PIC_NM,                         --负责人姓名
         T.PIC_JOB           AS PIC_JOB,                        --负责人职务
         T.PIC_TEL           AS PIC_TEL,                        --负责人联系电话
         T.UP_ORG_ID         AS UP_ORG_ID,                      --上级机构编号
         T.REGD_LAND_AREA_CD AS REGD_LAND_AREA_CD,              --注册地行政区划代码
         T.ORG_LVL           AS ORG_LVL,                        --机构级别
         T.FIN_ORG_ID        AS FIN_ORG_ID,                     --金融机构编号
         T.OPR_STAT_END_DT   AS OPR_STAT_END_DT,                --营业状态结束日期
         T.ORG_TEL           AS ORG_TEL,                        --机构联系电话
         T.BSN_LCNS_REGD_NO  AS BSN_LCNS_REGD_NO,               --营业执照注册号
         T.ORG_CD            AS ORG_CD,                         --组织机构代码
         T.DEPT_LINE         AS DEPT_LINE,                      --部门条线
         T.DATA_SRC          AS DATA_SRC,                       --数据来源
         NVL(SUBSTR(T.REGD_LAND_AREA_CD,1,4),'4400') AS GSFZJG, --归属分支机构
         A.IS_ENTITY         AS IS_ENTITY                       --是否实体机构
    FROM RRP_MDL.ADD_M_PUM_ORG_INFO T
    LEFT JOIN RRP_MDL.TMP_M_PUM_ORG_INFO A
      ON T.ORG_ID = A.ORG_ID
   WHERE A.ORG_ID IS NULL
     AND T.ESTB_DT <= V_P_DATE
     AND T.START_DT <= V_P_DATE
     AND T.END_DT > V_P_DATE;--MODIFY XUXIAOBIN 20220816

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);*/

  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '机构配置';
  V_STARTTIME := SYSDATE;
  V_TAB_NAME := 'ORG_CONFIG';
  /* 清数，支持重跑 */
  V_SQL_STR := 'TRUNCATE TABLE ' || V_TAB_NAME;
  EXECUTE IMMEDIATE V_SQL_STR;
  INSERT INTO RRP_MDL.ORG_CONFIG
    (ORG_ID,          --源机构号
     ORG_ID1,         --目标机构号
     FIN_INST_CODE,   --银行机构代码
     FIN_LICS_NUM,    --金融许可证号
     ORG_NAME,        --银行机构名称
     BKNAME           --中台银行机构全称 --ADD BY LIP 20230804 方便交易表中的对手方信息，通过转换后的人行支付行号取中台的机构名
     )
    WITH JGXX(ORG_ID, SUPER_ORG_ID) AS
     (SELECT TT.ORG_ID,
             CASE WHEN TT.ORG_ID = TT.SUPER_ORG_ID1 THEN TT.SUPER_ORG_ID2
                  ELSE TT.SUPER_ORG_ID1
              END AS SUPER_ORG_ID
        FROM (SELECT T.ORG_ID,
                     CASE WHEN (T1.ACCTI_ORG_FLG = '1' OR T1.ADMIN_SUPER_ORG_ID = '000000' OR T1.ORG_ID = '000000')
                          THEN T1.ORG_ID
                          ELSE T1.ADMIN_SUPER_ORG_ID
                      END AS SUPER_ORG_ID1,
                     CASE WHEN TRIM(T.ACCTI_SUPER_ORG_ID) IS NULL OR T.ACCTI_SUPER_ORG_ID = '800001'
                          THEN T.ADMIN_SUPER_ORG_ID
                          ELSE T.ACCTI_SUPER_ORG_ID
                      END AS SUPER_ORG_ID2
                FROM RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T
                LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO T1
                  ON T1.ORG_ID = SUBSTR(T.ORG_ID, 1, 6)
                 AND T.ETL_DT = T1.ETL_DT
               WHERE T.ORG_ID <> '999999'
                 AND T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')) TT),
    JG (ORG_ID, SUPER_ORG_ID) AS( --递归
      SELECT ORG_ID, SUPER_ORG_ID FROM JGXX
       UNION ALL
      SELECT A.ORG_ID, B.SUPER_ORG_ID FROM JGXX A, JG B WHERE A.SUPER_ORG_ID = B.ORG_ID),
    ORG_INFO_EAST AS (
      SELECT A.ORG_ID,
             A.SUPER_ORG_ID,
             B.ORG_ID AS ORG_ID1,
             C.ORG_ID AS ORG_ID2,
             ROW_NUMBER() OVER(PARTITION BY A.ORG_ID ORDER BY B.ORG_ID, NVL(TRIM(C.ORG_ID), '1') DESC) AS NUM
        FROM JG A
        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B
          ON B.ORG_ID = CASE WHEN A.ORG_ID LIKE '%902' THEN SUBSTR(A.ORG_ID,1,3)||'001' ELSE A.ORG_ID END
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C
          ON C.ORG_ID = CASE WHEN A.SUPER_ORG_ID LIKE '%902' THEN SUBSTR(A.SUPER_ORG_ID,1,3)||'001' ELSE A.SUPER_ORG_ID END
         AND C.DATA_DT = V_P_DATE)
  SELECT T.ORG_ID                           AS ORG_ID,        --源机构号
         NVL(TRIM(T.ORG_ID1), ORG_ID2)      AS ORG_ID1,       --目标机构号
         T1.PBC_NO                          AS FIN_INST_CODE, --银行机构代码
         T1.FIN_PERMIT_NO                   AS FIN_LICS_NUM,  --金融许可证号
         T1.ORG_NM                          AS ORG_NAME,      --银行机构名称
         NVL(TRIM(T2.BKNAME),T1.ORG_NM)     AS BKNAME         --中台银行机构全称 --ADD BY LIP 20230804 因中台数据会有缺失，用机构号补充
    FROM ORG_INFO_EAST T
    LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST T1
      ON T1.ORG_ID = NVL(TRIM(T.ORG_ID1), ORG_ID2)
     AND T1.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T2
      ON T2.BKCD = T1.PBC_NO
     AND T2.ID_MARK <> 'D'
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.NUM = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --记录正常日志
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '机构关系配置';
  V_STARTTIME := SYSDATE;
  V_TAB_NAME := 'CONFIG_ORG_REL';
  /* 清数，支持重跑 */
  V_SQL_STR := 'TRUNCATE TABLE ' || V_TAB_NAME;
  EXECUTE IMMEDIATE V_SQL_STR;
  INSERT INTO RRP_MDL.CONFIG_ORG_REL
    (ORG_ID,       --内部机构号
     ORG_ID_LEL_0, --总行
     ORG_ID_LEL_1  --分行
     )
  SELECT DISTINCT T.ORG_ID1,
         '000000',
         CASE WHEN T.ORG_ID LIKE '805%' THEN 'B1194B244030001'
              ELSE ''
          END
    FROM RRP_MDL.ORG_CONFIG T;
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
    SELECT DATA_DT,ORG_ID,COUNT(1)
      FROM RRP_MDL.M_PUM_ORG_INFO_EAST T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,ORG_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  V_STEP_DESC := '-- 表分析 --';
  ETL_DBMS_STATS(V_P_DATE, 'M_PUM_ORG_INFO_EAST',V_PART_NAME, O_ERRCODE);
  V_STEP_DESC := '-- 跑批完成记录表 --';
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

END ETL_M_PUM_ORG_INFO_EAST_TEST;
/

