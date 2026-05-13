CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_IND_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_IND_INFO
  *  功能描述：监管集市自然人客户基本信息
  *  创建日期：20220607
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INDV_CUST_BASIC_INFO   --个人客户基本信息
  *            IML.PTY_PARTY_CERT_INFO_H  --当事人证件信息历史
  *            IOL.ALBS_BLS_CUST_ALL_AML --黑名单系统供数给反洗钱系统黑名单表
  *
  *  目标表：  M_CUST_IND_INFO --个人客户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_IND_INFO'; -- 程序名称
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
 V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_IND_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

    /* 清数，支持重跑 */
  --V_TAB_NAME   := 'M_CUST_IND_INFO';
  --V_PART_NAME :=  'PARTITION_'||V_P_DATE ;
  V_STEP := 1;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);



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

  --判断跑批频度--


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
  --  程序处理过程--
  V_STEP := 4;
  V_STEP_DESC := '-- TRUNCAT临时表数据 --';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE M_CUST_IND_INFO_TMP';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '-- TRUNCAT信贷临时表 --';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_XD_CUST';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6;
  V_STEP_DESC := '-- 插入个人客户信息-信贷客户临时表 --';

  INSERT INTO TMP_XD_CUST
  SELECT A.CUST_ID, MIN(A.FIR_DISTR_DT) AS DT
  FROM (SELECT CUST_ID, DUBIL_ID, FIR_DISTR_DT
         FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO --零售贷款借据信息
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           AND FIR_DISTR_DT <> DATE '0001-01-01'
           AND TRIM(CUST_ID) IS NOT NULL
        UNION ALL
        SELECT CUST_ID, DUBIL_ID, DISTR_DT
          FROM O_ICL_CMM_UNITE_WL_DUBIL_INFO --联合网贷借据信息  保留当年结清及历史未结清
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND TRIM(CUST_ID) IS NOT NULL
        UNION ALL
        SELECT CUST_ID, DUBIL_ID, DISTR_DT
          FROM O_ICL_CMM_UNITE_WL_DUBIL_INFO_CLEAR --联合网贷借据信息 往年已结清
         WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND  TRIM(CUST_ID) IS NOT NULL
       ) A
  GROUP BY A.CUST_ID;
  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 7;
  V_STEP_DESC := '-- 插入个人客户信息临时表 --';

  INSERT  INTO M_CUST_IND_INFO
  (
     DATA_DT                       --数据日期
    ,LGL_REP_ID                    --法人编号
    ,ORG_ID                        --机构编号
    ,CUST_ID                       --客户编号
    ,CUST_NM                       --客户名称
    ,CUST_ENG_NM                   --客户英文名称
    ,CTRY_CD                       --国家代码
    ,RSDNT_FLG                     --居民标志
    ,CUST_BLNG_LAND_AREA_CD        --客户所属地行政区划代码
    ,CRDL_TYP                      --证件类型
    ,CRDL_NO                       --证件号码
    ,ISU_CERT_OFF_AREA_CD          --发证机关行政区划代码
    ,CRDL_EFF_DT                   --证件生效日期
    ,CRDL_EXP_DT                   --证件失效日期
    ,CRDL_ADDR                     --证件地址
    ,PHONE_NUM                     --手机号码
    ,ETHNIC                        --民族
    ,GENDER                        --性别
    ,BIRTH_DT                      --出生日期
    ,MARRIAGE_STAT                 --婚姻状况
    ,HIGH_DEGREE                   --最高学历
    ,CUST_BLNG_IDY                 --客户所属行业
    ,OCCUP                         --职业
    ,TITLE                         --职称
    ,JOB                           --职务
    ,IND_YEAR_INCOME               --个人年收入
    ,FAMILY_YEAR_INCOME            --家庭年收入
    ,CO_NM                         --单位名称
    ,CO_CHAR                       --单位性质
    ,CO_ADDR                       --单位地址
    ,CO_TEL                        --单位电话
    ,RSDNC_CTRY_CD                 --居住地国家代码
    ,RSDNC_ADDR                    --居住地址
    ,RSDNC_AREA_CD                 --居住地行政区划代码
    ,OPR_CUST_TYP                  --经营性客户类型
    ,BANK_EMP_FLG                  --本行员工标志
    ,FARM_FLG                      --农户标志
    ,CONT_SIDE_FARM_FLG            --承包方农户标志
    ,BLIST_FLG                     --上黑名单标志
    ,BLIST_DT                      --上黑名单日期
    ,BANK_SENIOR_FLG               --银行高管标志
    ,REL_PTY_FLG                   --关联方标志
    ,AGR_REL_LOAN_CERT_ISU_NUM     --发放支农贷款证数量
    ,ECON_ARCH_FLG                 --经济档案标志
    ,CRDT_FLG                      --信用户标志
    ,JUR_FLG                       --辖内标志
    ,OPEN_EBANK_FLG                --开通网银标志
    ,DISABLED_FLG                  --残疾人标志
    ,LOW_INCM_FLG                  --低保户标志
    ,CUST_CRDT_RTG                 --客户信用评级
    ,CUST_CR_RTG_TOT_GRD           --客户信用评级总等级数
    ,CUST_STAT                     --客户状态
    ,FIRST_ESTBL_CRDT_REL_DT       --首次建立信贷关系日期
    ,DEPT_LINE                     --部门条线
    ,DATA_SRC                      --数据来源
    ,BIO_FLG                       --境内外标志
    ,AGE                           --年龄
    ,DIST_CD                       --行政区划代码
    ,FAMILY_MON_INCO               --家庭月收入
    ,INDV_MON_INCO                 --个人月收入
    )
  SELECT
     TO_CHAR(A.ETL_DT,'YYYYMMDD')                         AS DATA_DT                       --数据日期
    ,A.LP_ID                                              AS LGL_REP_ID                    --法人编号
    ,A.BELONG_ORG_ID                                      AS ORG_ID                        --机构编号
    ,A.CUST_ID                                            AS CUST_ID                       --客户编号
    ,replace(replace(A.CUST_NAME,'?',''),'？','')         AS CUST_NM                       --客户名称
    ,A.CUST_EN_NAME                                       AS CUST_ENG_NM                   --客户英文名称
    ,A.NATION_CD                                          AS CTRY_CD                       --国家代码
    ,CASE WHEN A.RESDNT_FLG = '0' THEN 'N' ELSE 'Y' END   AS RSDNT_FLG                     --居民标志
    ,A.RG_CD                                              AS CUST_BLNG_LAND_AREA_CD        --客户所属地行政区划代码
    ,CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO)=18 AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X') THEN '1010'  --身份证
          ELSE A.CERT_TYPE_CD
     END                                                  AS CRDL_TYP                      --证件类型
    ,A.CERT_NO                                            AS CRDL_NO                       --证件号码
    ,C.LICEN_ISSUE_AUTHO_DIST_CD  /*D.RG_CD --表未接入*/   AS ISU_CERT_OFF_AREA_CD          --发证机关行政区划代码
    ,C.CRDL_EFF_DT                                        AS CRDL_EFF_DT                   --证件生效日期
    --,C.CRDL_EXP_DT                                        AS CRDL_EXP_DT                   --证件失效日期
    ,NVL(C.CRDL_EXP_DT,TO_CHAR(A.CERT_EXP_DT,'YYYYMMDD'))
                                                          AS CRDL_EXP_DT                   --证件失效日期
    ,C.CRDL_ADDR                                          AS CRDL_ADDR                     --证件地址
    ,NVL(TRIM(A.OPEN_ACCT_RSRV_MOBILE_NO),A.CONT_NUM)     AS PHONE_NUM                     --手机号码
    ,CASE WHEN A.NATIONTY_CD = '00' THEN NULL
          WHEN A.NATIONTY_CD IN ('58','97') THEN '97'
          ELSE CASE WHEN LENGTH(TRIM(A.NATIONTY_CD))=2 THEN TRIM(A.NATIONTY_CD) END
     END                                                  AS ETHNIC                        --民族
    ,CASE WHEN A.GENDER_CD='1' THEN '1'
               WHEN A.GENDER_CD='2' THEN '2'
               WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=18 THEN (CASE WHEN MOD(SUBSTR(A.CERT_NO,17,1),2)=1 THEN '1' ELSE '2' END)
               WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15 THEN (CASE WHEN MOD(SUBSTR(A.CERT_NO,15,2),2)=1 THEN '1' ELSE '2' END)
               WHEN A.GENDER_CD='0' THEN '0'
               WHEN A.GENDER_CD='9' THEN '9'
     END                                                  AS GENDER                        --性别
    ,CASE WHEN LENGTH(A.CERT_NO)=18 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,8),'^[0-9]+[0-9]$') AND SUBSTR(A.CERT_NO,7,2) IN('19','20')
                    AND ((SUBSTR(A.CERT_NO,11,2) IN ('01','03','05','07','08','10','12') AND SUBSTR(A.CERT_NO,13,2)<32 AND SUBSTR(A.CERT_NO,13,2)>00)
                          OR((SUBSTR(A.CERT_NO,11,2) IN ('02','04','06','09','11') AND SUBSTR(A.CERT_NO,13,2)<31  AND SUBSTR(A.CERT_NO,13,2)>00)))
            THEN SUBSTR(A.CERT_NO,7,8)
          WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,6),'^[0-9]+[0-9]$') AND SUBSTR(A.CERT_NO,9,2)<13 AND SUBSTR(A.CERT_NO,9,2)>00 AND SUBSTR(A.CERT_NO,11,2)<32 AND SUBSTR(A.CERT_NO,11,2)>00
            THEN '19'||SUBSTR(A.CERT_NO,7,6)
          ELSE TO_CHAR(A.BIRTH_DT,'YYYYMMDD')
     END                                                  AS BIRTH_DT                      --出生日期
    ,F.TAR_VALUE_CODE                                     AS MARRIAGE_STAT                 --婚姻状况
    ,CASE WHEN TRIM(A.EDU_CD) IN ('00','95','99') THEN NULL
          WHEN LENGTH(TRIM(A.EDU_CD)) = 2 THEN TRIM(A.EDU_CD)
     END                                                  AS HIGH_DEGREE                   --最高学历
    ,CASE WHEN LENGTHB(SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''), 0, 5)) <= 5   --码值中出现中文等不规范码值处理
            AND A.CORP_BL_INDUTY_TYPE_CD NOT LIKE '%null%'
              AND REGEXP_LIKE(SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''), 0, 1),'(A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T)$')
                THEN SUBSTR(REPLACE(REPLACE(A.CORP_BL_INDUTY_TYPE_CD,'@',''),'-',''), 0, 5)
          ELSE NULL
     END                                                  AS CUST_BLNG_IDY                 --客户所属行业
    ,/*G.TAR_VALUE_CODE*/A.CAREER_CD                      AS OCCUP                         --职业
    ,/*H.TAR_VALUE_CODE */A.TITLE_CD                      AS TITLE                         --职称 --MODIFY BY MW  2022/11/04 改为取数仓原值
    ,A.POST_CD                                            AS JOB                           --职务
    ,A.INDV_ANL_INCO                                      AS IND_YEAR_INCOME               --个人年收入
    ,A.FAMILY_ANL_INCO                                    AS FAMILY_YEAR_INCOME            --家庭年收入
    ,A.WORK_UNIT_NAME                                     AS CO_NM                         --单位名称
    ,J.Tar_VALUE_CODE                                     AS CO_CHAR                       --单位性质
    ,A.WORK_UNIT_ADDR                                     AS CO_ADDR                       --单位地址
    ,A.WORK_UNIT_TEL                                      AS CO_TEL                        --单位电话
    ,A.NATION_CD                                          AS RSDNC_CTRY_CD                 --居住地国家代码
    ,nvl(nvl(NVL(TRIM(A.RESDNT_ADDR),trim(A.RPR_SITE)),trim(A.posta_addr)),A.family_addr)                  AS RSDNC_ADDR                    --居住地址
    ,CASE WHEN A.RG_CD NOT IN ( '000000','999999') AND LENGTH(A.RG_CD) = 6 THEN A.RG_CD
          WHEN A.RG_CD IN ('000000','999999')AND A.DIST_CD NOT IN ('9999','000000') AND A.DIST_CD IS NOT NULL
          AND XZDM2.TAR_VALUE_CODE IS NOT NULL--部分码值取消导致出现空值，空值取身份证前6
          THEN XZDM2.TAR_VALUE_CODE
          WHEN (CASE WHEN A.CERT_TYPE_CD = '1999' AND LENGTH(A.CERT_NO)=18 AND (REGEXP_LIKE(A.CERT_NO,'^[0-9]+[0-9]$') OR A.CERT_NO LIKE '%X') THEN '1010'  --身份证
          ELSE A.CERT_TYPE_CD
     END) = '1010' THEN SUBSTR(A.CERT_NO,1,6)  --截取身份证前6位

     ELSE
    NVL(XZDM.TAR_VALUE_CODE,A.RG_CD)  END              AS RSDNC_AREA_CD                 --居住地行政区划代码
    --地区代码逻辑顺序 数仓地区代码>行政区划代码（4位）转码>截取身份证前6位
    ,CASE WHEN A.INDV_BUS_FLG = '1' THEN 'A' --个体工商户标志
          WHEN A.SM_BUS_OWNER_FLG = '1' THEN 'B' --小微企业主标志
          ELSE 'Z'
     END                                                  AS OPR_CUST_TYP                  --经营性客户类型
    ,CASE WHEN A.GHB_EMPLY_FLG = '1' THEN 'Y'
          ELSE 'N'
     END                                                  AS BANK_EMP_FLG                  --本行员工标志
    ,CASE WHEN A.FARM_FLG = '1' THEN 'Y'
          WHEN A.FARM_FLG = '0' THEN 'N'
     ELSE NULL
     END                                                  AS FARM_FLG                      --农户标志
    ,'N'                                                  AS CONT_SIDE_FARM_FLG            --承包方农户标志
    ,CASE WHEN K.CUSTOMER_NO IS NOT NULL THEN 'Y'
          ELSE 'N'
     END                                                  AS BLIST_FLG                     --上黑名单标志
    ,K.CRT_DATE                                           AS BLIST_DT                      --上黑名单日期
    ,CASE WHEN L.CUST_ID IS NOT NULL THEN 'Y'
          ELSE 'N'
     END                                                  AS BANK_SENIOR_FLG               --银行高管标志
    ,/*A.RELA_TRAN_FLG*/
    CASE WHEN T1.PARTY_ID IS NOT NULL
         THEN 'Y'
         ELSE 'N'
         END                                              AS REL_PTY_FLG                   --关联方标志
    ,NULL                                                 AS AGR_REL_LOAN_CERT_ISU_NUM     --发放支农贷款证数量
    ,NULL                                                 AS ECON_ARCH_FLG                 --经济档案标志
    ,NULL                                                 AS CRDT_FLG                      --信用户标志
    ,A.FARM_FLG                                           AS JUR_FLG                       --辖内标志
    ,NULL                                                 AS OPEN_EBANK_FLG                --开通网银标志
    ,NULL                                                 AS DISABLED_FLG                  --残疾人标志
    ,NULL                                                 AS LOW_INCM_FLG                  --低保户标志
    ,NULL                                                 AS CUST_CRDT_RTG                 --客户信用评级
    ,NULL                                                 AS CUST_CR_RTG_TOT_GRD           --客户信用评级总等级数
    ,CASE WHEN A.CUST_STATUS_CD = 'P' THEN 'C'
          ELSE 'A'
     END                                                  AS CUST_STAT                     --客户状态
    ,CASE WHEN M.CUST_ID IS NOT NULL THEN TO_CHAR(M.DISTR_DT, 'YYYYMMDD')
          ELSE NULL
     END                                                  AS FIRST_ESTBL_CRDT_REL_DT       --首次建立信贷关系日期
    ,'800924' /*零售信贷部(普惠金融部)*/                      AS DEPT_LINE                     --部门条线
    ,SUBSTR(A.JOB_CD, 0, 4)                               AS DATA_SRC                      --数据来源
    ,CASE WHEN A.DOM_OVERS_FLG = '0'
          THEN 'Y'
          ELSE 'N'
          END                                             AS BIO_FLG                       --境内外标志
    ,FLOOR(MONTHS_BETWEEN(TO_DATE(I_P_DATE,'YYYYMMDD')
               ,CASE WHEN LENGTH(A.CERT_NO)=18 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,8),'^[0-9]+[0-9]$') AND SUBSTR(A.CERT_NO,7,2) IN('19','20')
                          AND ((SUBSTR(A.CERT_NO,11,2) IN ('01','03','05','07','08','10','12') AND SUBSTR(A.CERT_NO,13,2)<32 AND SUBSTR(A.CERT_NO,13,2)>00)
                                OR((SUBSTR(A.CERT_NO,11,2) IN ('02','04','06','09','11') AND SUBSTR(A.CERT_NO,13,2)<31  AND SUBSTR(A.CERT_NO,13,2)>00)))
                     THEN TO_DATE(SUBSTR(A.CERT_NO,7,8),'YYYY-MM-DD')
                     WHEN A.CERT_TYPE_CD IN ('1010','1011') AND LENGTH(A.CERT_NO)=15 AND REGEXP_LIKE(SUBSTR(A.CERT_NO,7,6),'^[0-9]+[0-9]$') AND SUBSTR(A.CERT_NO,9,2)<13 AND SUBSTR(A.CERT_NO,9,2)>00 AND SUBSTR(A.CERT_NO,11,2)<32 AND SUBSTR(A.CERT_NO,11,2)>00
                     THEN TO_DATE('19'||SUBSTR(A.CERT_NO,7,6),'YYYY-MM-DD')
                     ELSE A.BIRTH_DT
                END)/12
               )
    ,A.DIST_CD                                             AS DIST_CD                     --行政区划代码
    ,A.FAMILY_MON_INCO                                     AS FAMILY_MON_INCO             --家庭月收入
    ,A.INDV_MON_INCO                                       AS INDV_MON_INCO               --个人月收入
  FROM RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO A  --个人客户基本信息
  LEFT JOIN (
/*    SELECT CC.PARTY_ID,CC.LICEN_ISSUE_AUTHO_DIST_CD,CC.CRDL_EFF_DT,CC.CRDL_EXP_DT,CC.CRDL_ADDR
    FROM (
      SELECT
         PARTY_ID
        ,LICEN_ISSUE_AUTHO_DIST_CD
        ,TO_CHAR(CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
        ,TO_CHAR(CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
        ,CERT_ADDR                           AS CRDL_ADDR      --证件地址
        ,ROW_NUMBER() OVER(PARTITION BY PARTY_ID ORDER BY START_DT,SORC_SYS_CD DESC) AS RN
      FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H  --当事人证件信息历史
      WHERE \*TO_DATE(V_P_DATE,'YYYYMMDD') BETWEEN START_DT AND END_DT
      AND *\TRIM(LICEN_ISSUE_AUTHO_DIST_CD) IS NOT NULL -- 发证机关代码不为空
      ) CC
    WHERE CC.RN = 1*/
      SELECT
         PARTY_ID
        ,CERT_NUM --证件号码
        ,CERT_TYPE_CD --证件类型
        ,LICEN_ISSUE_AUTHO_DIST_CD
        ,TO_CHAR(CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
        ,TO_CHAR(CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
        ,CERT_ADDR                           AS CRDL_ADDR      --证件地址
        ,SORC_SYS_CD
        ,ROW_NUMBER() OVER(PARTITION BY PARTY_ID,CERT_NUM--,CERT_TYPE_CD
                             ORDER BY CASE WHEN SORC_SYS_CD = 'EIFS' THEN 'A' ELSE SORC_SYS_CD END, --优先取Ecif
                             CERT_INVALID_DT DESC) AS RN
      FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H  --当事人证件信息历史
      WHERE /*TO_DATE(V_P_DATE,'YYYYMMDD') BETWEEN START_DT AND END_DT
      AND */TRIM(LICEN_ISSUE_AUTHO_DIST_CD) IS NOT NULL -- 发证机关代码不为空
      AND TRIM(CERT_NUM) IS NOT NULL
      AND REPLACE(CERT_NUM,'*','') IS NOT NULL
      AND REPLACE(CERT_NUM,'0','') IS NOT NULL
      AND TRIM(CERT_NUM) <> '/'
      AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  ) C
         ON A.CUST_ID = C.PARTY_ID
         AND A.CERT_NO = C.CERT_NUM
         AND C.RN = 1
  /*LEFT JOIN ( --4位行政区划转6位  表暂未接入
    SELECT T.RG_CD,T.FOUR_RG_CD,ROW_NUMBER() OVER(PARTITION BY FOUR_RG_CD ORDER BY RG_CD) AS RN
    FROM S_IML_REF_DIST_CD T --行政区划代码表
  ) D
         ON C.LICEN_ISSUE_AUTHO_DIST_CD = D.FOUR_RG_CD
        AND D.RN = 1 */
    LEFT JOIN (SELECT * FROM(
              --SELECT DISTINCT PARTY_ID,CERT_NO,SHARE_RATIO FROM(
              SELECT PARTY_ID,CERT_NO,SHARE_RATIO,ROW_NUMBER()OVER(PARTITION BY CERT_NO ORDER BY NUM) RN FROM(
              SELECT
                   RELA_PARTY_ID AS PARTY_ID
                  ,TRIM(NVL(RELA_PARTY_CERT_ID_1, RELA_PARTY_CERT_ID_2)) AS CERT_NO
                  ,REPLACE(TRIM(RELA_PARTY_SHARE_RATIO),'%','') AS SHARE_RATIO
                  ,'1' NUM
                FROM O_ICL_CMM_RELA_PARTY_BASIC_INFO
                WHERE --RELA_TYPE_CD IN ('10001','10002','20004') --20201216跟BA沟通，去掉次条件 by hap
                 --AND PARTY_ID = 'GHB' --20201216跟BA沟通，去掉次条件 by hap
                 /*AND*/ RELA_STATUS_CD='A'            --20201014 BY WL 生产跑批发现关联方有重复且重复客户的状态未空，暂时置为取状态为 A 的
                 AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                 UNION ALL  --20201216跟BA沟通，加上当事人的信息 by hap
                 SELECT
                   PARTY_ID
                  ,TRIM(NVL(PARTY_CERT_ID_1, PARTY_CERT_ID_2)) AS CERT_NO
                  ,REPLACE(TRIM(PARTY_SHARE_RATIO),'%','') AS SHARE_RATIO
                  ,'2' NUM
                FROM O_ICL_CMM_RELA_PARTY_BASIC_INFO
                WHERE RELA_STATUS_CD='A'            --20201014 BY WL 生产跑批发现关联方有重复且重复客户的状态未空，暂时置为取状态为 A 的
                 AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              ))T WHERE T.RN = 1) T1  --关联方基本信息   --ADD BY ZM 20200728
      ON A.CERT_NO = T1.CERT_NO

  LEFT JOIN RRP_MDL.CODE_MAP F
         ON A.MARRIAGE_SITU_CD = F.SRC_VALUE_CODE
        AND F.SRC_CLASS_CODE = 'CD1002'  --婚姻状况代码
        AND F.TAR_CLASS_CODE = 'C0010'   --婚姻状况
        AND F.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.CODE_MAP XZDM        --地区转行政区划代码
        ON A.RG_CD =  XZDM.SRC_VALUE_CODE
        AND XZDM.SRC_CLASS_CODE = 'CD1730'  --行政区划代码
        AND XZDM.TAR_CLASS_CODE = 'CD1730'   --行政区划代码
        AND XZDM.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP XZDM2       --行政区划代码转行政区划代码
        ON A.DIST_CD =  XZDM2.SRC_VALUE_CODE
        AND XZDM2.SRC_CLASS_CODE = 'CD1730'  --行政区划代码
        AND XZDM2.TAR_CLASS_CODE = 'CD1730'   --行政区划代码
        AND XZDM2.MOD_FLG = 'MDM'
/*  LEFT JOIN RRP_MDL.CODE_MAP G
         ON A.CAREER_CD = G.SRC_VALUE_CODE
        AND G.SRC_CLASS_CODE = 'CD1591'  --职业类型代码
        AND G.TAR_CLASS_CODE = 'C0012'   --职业
         AND G.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.CODE_MAP H
         ON A.TITLE_CD = H.SRC_VALUE_CODE
        AND H.SRC_CLASS_CODE = 'CD1516'  --职称代码
        AND H.TAR_CLASS_CODE = 'C0013'   --职称
        AND H.MOD_FLG = 'MDM'*/
  /*LEFT JOIN RRP_MDL.CODE_MAP I
         ON A.POST_CD = I.SRC_VALUE_CODE
        AND I.SRC_CLASS_CODE = 'CD1517'  --职称代码
        AND I.TAR_CLASS_CODE = 'CD1517'   --职称
        AND I.MOD_FLG = 'MDM'
        */
  LEFT JOIN RRP_MDL.CODE_MAP J
        ON A.WORK_UNIT_CHAR_CD = J.SRC_VALUE_CODE
      --  ON case when A.WORK_UNIT_CHAR_CD='000' then '0' else A.WORK_UNIT_CHAR_CD end = J.SRC_VALUE_CODE
        AND J.SRC_CLASS_CODE = 'CD1407'  --职称代码
        AND J.TAR_CLASS_CODE = 'C0050'   --职称
        AND J.MOD_FLG = 'MDM'
  LEFT JOIN (SELECT CUSTOMER_NO,CRT_DATE
                   ,ROW_NUMBER()OVER(PARTITION BY CUSTOMER_NO ORDER BY CRT_DATE) NUM
             FROM O_IOL_ALBS_BLS_CUST_ALL_AML
             WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
          ) K  --黑名单系统供数给反洗钱系统黑名单表
         ON A.CUST_ID = K.CUSTOMER_NO
        AND K.NUM = 1
  LEFT JOIN RRP_MDL.ADD_SENIOR L  --银行高管补录表,留空后期等业务补录
         ON A.CUST_ID = L.CUST_ID
        --AND L.DATA_DT = V_P_DATE
  LEFT JOIN TMP_XD_CUST M
   ON A.CUST_ID = M.CUST_ID
  WHERE A.ETL_DT = to_date(V_P_DATE,'yyyymmdd') and a.CUST_ID is not null;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  /*-- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入个人客户信息数据';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_CUST_IND_INFO
  (
   DATA_DT                     --数据日期
   ,LGL_REP_ID                 --法人编号
   ,ORG_ID                     --机构编号
   ,CUST_ID                    --客户编号
   ,CUST_NM                    --客户名称
   ,CUST_ENG_NM                --客户英文名称
   ,CTRY_CD                    --国家代码
   ,RSDNT_FLG                  --居民标志
   ,CUST_BLNG_LAND_AREA_CD     --客户所属地行政区划代码
   ,CRDL_TYP                   --证件类型
   ,CRDL_NO                    --证件号码
   ,ISU_CERT_OFF_AREA_CD       --发证机关行政区划代码
   ,CRDL_EFF_DT                --证件生效日期
   ,CRDL_EXP_DT                --证件失效日期
   ,CRDL_ADDR                  --证件地址
   ,PHONE_NUM                  --手机号码
   ,ETHNIC                     --民族
   ,GENDER                     --性别
   ,BIRTH_DT                   --出生日期
   ,MARRIAGE_STAT              --婚姻状况
   ,HIGH_DEGREE                --最高学历
   ,CUST_BLNG_IDY              --客户所属行业
   ,OCCUP                      --职业
   ,TITLE                      --职称
   ,JOB                        --职务
   ,IND_YEAR_INCOME            --个人年收入
   ,FAMILY_YEAR_INCOME         --家庭年收入
   ,CO_NM                      --单位名称
   ,CO_CHAR                    --单位性质
   ,CO_ADDR                    --单位地址
   ,CO_TEL                     --单位电话
   ,RSDNC_CTRY_CD              --居住地国家代码
   ,RSDNC_ADDR                 --居住地址
   ,RSDNC_AREA_CD              --居住地行政区划代码
   ,OPR_CUST_TYP               --经营性客户类型
   ,BANK_EMP_FLG               --本行员工标志
   ,FARM_FLG                   --农户标志
   ,CONT_SIDE_FARM_FLG         --承包方农户标志
   ,BLIST_FLG                  --上黑名单标志
   ,BLIST_DT                   --上黑名单日期
   ,BANK_SENIOR_FLG            --银行高管标志
   ,REL_PTY_FLG                --关联方标志
   ,AGR_REL_LOAN_CERT_ISU_NUM  --发放支农贷款证数量
   ,ECON_ARCH_FLG              --经济档案标志
   ,CRDT_FLG                   --信用户标志
   ,JUR_FLG                    --辖内标志
   ,OPEN_EBANK_FLG             --开通网银标志
   ,DISABLED_FLG               --残疾人标志
   ,LOW_INCM_FLG               --低保户标志
   ,CUST_CRDT_RTG              --客户信用评级
   ,CUST_CR_RTG_TOT_GRD        --客户信用评级总等级数
   ,CUST_STAT                  --客户状态
   ,FIRST_ESTBL_CRDT_REL_DT    --首次建立信贷关系日期
   ,DEPT_LINE                  --部门条线
   ,DATA_SRC                   --数据来源
   ,BIO_FLG                    --境内外标志
   ,CUST_NM_DESEN              --客户名称脱敏
   ,CRDL_NO_DESEN              --证件号码脱敏
   ,PHONE_NUM_DESEN            --手机号码脱敏
   ,AGE                        --年龄
  )
  SELECT   DATA_DT,
           LGL_REP_ID,
           ORG_ID,
           CUST_ID,
           CUST_NM,
           CUST_ENG_NM,
           CTRY_CD,
           RSDNT_FLG,
           CUST_BLNG_LAND_AREA_CD,
           CRDL_TYP,
           CRDL_NO,
           ISU_CERT_OFF_AREA_CD,
           CRDL_EFF_DT,
           CRDL_EXP_DT,
           CRDL_ADDR,
           PHONE_NUM,
           ETHNIC,
           GENDER,
           BIRTH_DT,
           MARRIAGE_STAT,
           HIGH_DEGREE,
           CUST_BLNG_IDY,
           OCCUP,
           TITLE,
           JOB,
           IND_YEAR_INCOME,
           FAMILY_YEAR_INCOME,
           CO_NM,
           CO_CHAR,
           CO_ADDR,
           CO_TEL,
           RSDNC_CTRY_CD,
           RSDNC_ADDR,
           RSDNC_AREA_CD,
           OPR_CUST_TYP,
           BANK_EMP_FLG,
           FARM_FLG,
           CONT_SIDE_FARM_FLG,
           BLIST_FLG,
           BLIST_DT,
           BANK_SENIOR_FLG,
           REL_PTY_FLG,
           AGR_REL_LOAN_CERT_ISU_NUM,
           ECON_ARCH_FLG,
           CRDT_FLG,
           JUR_FLG,
           OPEN_EBANK_FLG,
           DISABLED_FLG,
           LOW_INCM_FLG,
           CUST_CRDT_RTG,
           CUST_CR_RTG_TOT_GRD,
           CUST_STAT,
           FIRST_ESTBL_CRDT_REL_DT,
           DEPT_LINE,
           DATA_SRC,
           BIO_FLG,
           \*CASE WHEN LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))= LENGTHB(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))
              THEN SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]','')) - 2, 3)
              ELSE SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]','')), 1)
              END CUST_NM_DESEN,                                                               --客户名称脱敏
           CASE WHEN REGEXP_REPLACE(LPAD(A.CRDL_NO, 6, '0'),'[0-9a-zA-Z]','') IS NULL
              THEN LPAD(A.CRDL_NO, 6, '0')
              WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,5))) = LENGTH(TRIM(SUBSTRB(A.CRDL_NO,1,5))) + 1
              THEN LPAD(TRIM(SUBSTRB(A.CRDL_NO,1,5)),5,'0')
              WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,4))) = LENGTH(TRIM(SUBSTRB(A.CRDL_NO,1,4))) + 2
              THEN LPAD(TRIM(SUBSTRB(A.CRDL_NO,1,4)),4,'0')
          END
         ||SM3_ENCRYPT(CASE WHEN LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))=LENGTHB(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))
                            THEN SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), 1, 3)
                            ELSE SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), 1, 1)
                        END || UPPER(A.CRDL_NO)) CRDL_NO_DESEN, --证件号码脱敏
         SM3_ENCRYPT(A.PHONE_NUM) PHONE_NUM_DESEN --手机号码脱敏
     *\
     A.CUST_NM,
     A.CRDL_NO,
     A.PHONE_NUM,
     A.AGE
   FROM M_CUST_IND_INFO_TMP A; --个人客户信息

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;*/

      -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,COUNT(1)
      FROM M_CUST_IND_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, CUST_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_CUST_IND_INFO;
/

