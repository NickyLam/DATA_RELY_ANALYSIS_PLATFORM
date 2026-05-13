CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_M_CUST_IND_INFO_EAST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：人客户信息EAST专用
  **  存储过程名称:  ETL_M_CUST_IND_INFO_EAST
  **  存储过程创建日期:2022-04-03
  **  存储过程创建人:LAIHAIQIANG

  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期   修改人        修改原因
  **  20220424   LAIHAIQIANG   主要用于对证件号码，手机号码及客户名称的脱敏
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);       --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);       --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);     --分区名称
  V_STEP             INTEGER := 0;      --任务号
  V_SQLCOUNT         INTEGER := 0;      --更新或删除影响的记录数
  V_STARTTIME        DATE;              --处理开始时间
  V_ENDTIME          DATE;              --处理结束时间
  V_SQLMSG           VARCHAR2(300);     --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);     --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_M_CUST_IND_INFO_EAST'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('M_CUST_IND_INFO_EAST'); --表名称
BEGIN
  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;

  --判断跑批频度
  IF V_P_DATE = V_MONTH_END_DATEID THEN --月底跑批

    /*增加分区*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入人客户信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.M_CUST_IND_INFO_EAST
      (DATA_DT                     --数据日期
      ,LGL_REP_ID                  --法人编号
      ,ORG_ID                      --机构编号
      ,CUST_ID                     --客户编号
      ,CUST_NM                     --客户名称
      ,CUST_ENG_NM                 --客户英文名称
      ,CTRY_CD                     --国家代码
      ,RSDNT_FLG                   --居民标志
      ,CUST_BLNG_LAND_AREA_CD      --客户所属地行政区划代码
      ,CRDL_TYP                    --证件类型
      ,CRDL_NO                     --证件号码
      ,ISU_CERT_OFF_AREA_CD        --发证机关行政区划代码
      ,CRDL_EFF_DT                 --证件生效日期
      ,CRDL_EXP_DT                 --证件失效日期
      ,CRDL_ADDR                   --证件地址
      ,PHONE_NUM                   --手机号码
      ,ETHNIC                      --民族
      ,GENDER                      --性别
      ,BIRTH_DT                    --出生日期
      ,MARRIAGE_STAT               --婚姻状况
      ,HIGH_DEGREE                 --最高学历
      ,CUST_BLNG_IDY               --客户所属行业
      ,OCCUP                       --职业
      ,TITLE                       --职称
      ,JOB                         --职务
      ,IND_YEAR_INCOME             --个人年收入
      ,FAMILY_YEAR_INCOME          --家庭年收入
      ,CO_NM                       --单位名称
      ,CO_CHAR                     --单位性质
      ,CO_ADDR                     --单位地址
      ,CO_TEL                      --单位电话
      ,RSDNC_CTRY_CD               --居住地国家代码
      ,RSDNC_ADDR                  --居住地址
      ,RSDNC_AREA_CD               --居住地行政区划代码
      ,OPR_CUST_TYP                --经营性客户类型
      ,BANK_EMP_FLG                --本行员工标志
      ,FARM_FLG                    --农户标志
      ,CONT_SIDE_FARM_FLG          --承包方农户标志
      ,BLIST_FLG                   --上黑名单标志
      ,BLIST_DT                    --上黑名单日期
      ,BANK_SENIOR_FLG             --银行高管标志
      ,REL_PTY_FLG                 --关联方标志
      ,AGR_REL_LOAN_CERT_ISU_NUM   --发放支农贷款证数量
      ,ECON_ARCH_FLG               --经济档案标志
      ,CRDT_FLG                    --信用户标志
      ,JUR_FLG                     --辖内标志
      ,OPEN_EBANK_FLG              --开通网银标志
      ,DISABLED_FLG                --残疾人标志
      ,LOW_INCM_FLG                --低保户标志
      ,CUST_CRDT_RTG               --客户信用评级
      ,CUST_CR_RTG_TOT_GRD         --客户信用评级总等级数
      ,CUST_STAT                   --客户状态
      ,FIRST_ESTBL_CRDT_REL_DT     --首次建立信贷关系日期
      ,DEPT_LINE                   --部门条线
      ,DATA_SRC                    --数据来源
      ,BIO_FLG                     --境内外标志
      ,CUST_NM_DESEN               --客户名称脱敏
      ,CRDL_NO_DESEN               --证件号码脱敏
      ,PHONE_NUM_DESEN             --手机号码脱敏
      ,AGE                         --年龄
      ,DIST_CD                     --行政区划代码
      ,FAMILY_MON_INCO             --家庭月收入
      ,INDV_MON_INCO               --个人月收入
      )
    WITH TMP_ALB_TMP1 AS (
    SELECT /*+MATERIALIZE*/CUSTOMER_NO,CRT_DATE,
           ROW_NUMBER() OVER(PARTITION BY CUSTOMER_NO ORDER BY CRT_DATE DESC) NUM
      FROM RRP_MDL.O_IOL_ALBS_BLS_CUST_ALL_AML --黑名单系统供数给反洗钱系统黑名单表
     WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')),
    TMP_ALB_TMP2 AS (
    SELECT /*+MATERIALIZE*/CUST_CODE,CRT_DATE,
           ROW_NUMBER() OVER(PARTITION BY CUST_CODE ORDER BY ETL_DT DESC,CRT_DATETIME DESC,CRT_DATE DESC) NUM
      FROM RRP_MDL.O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND --黑名单系统 增量客户命中表
     WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT /*+USE_HASH(A,B,C) LEADING(A,B,C)*/
           V_P_DATE                             AS DATA_DT                   --数据日期
          ,A.LGL_REP_ID                         AS LGL_REP_ID                --法人编号
          ,A.ORG_ID                             AS ORG_ID                    --机构编号
          ,A.CUST_ID                            AS CUST_ID                   --客户编号
          ,A.CUST_NM                            AS CUST_NM                   --客户名称
          ,A.CUST_ENG_NM                        AS CUST_ENG_NM               --客户英文名称
          ,A.CTRY_CD                            AS CTRY_CD                   --国家代码
          ,A.RSDNT_FLG                          AS RSDNT_FLG                 --居民标志
          ,A.CUST_BLNG_LAND_AREA_CD             AS CUST_BLNG_LAND_AREA_CD    --客户所属地行政区划代码
          ,A.CRDL_TYP                           AS CRDL_TYP                  --证件类型
          ,A.CRDL_NO                            AS CRDL_NO                   --证件号码
          ,A.ISU_CERT_OFF_AREA_CD               AS ISU_CERT_OFF_AREA_CD      --发证机关行政区划代码
          ,A.CRDL_EFF_DT                        AS CRDL_EFF_DT               --证件生效日期
          ,A.CRDL_EXP_DT                        AS CRDL_EXP_DT               --证件失效日期
          ,A.CRDL_ADDR                          AS CRDL_ADDR                 --证件地址
          --,A.PHONE_NUM                          AS PHONE_NUM                 --手机号码
          --MOD BY LIP 20230802 增加手机号码的取数口径
          --,NVL(A.PHONE_NUM,C.TEL_NUM)           AS PHONE_NUM                 --手机号码
          ,COALESCE(TRIM(A.PHONE_NUM),TRIM(C.TEL_NUM),TRIM(B.PHONE_NUM)) AS PHONE_NUM --手机号码
          ,A.ETHNIC                             AS ETHNIC                    --民族
          ,A.GENDER                             AS GENDER                    --性别
          ,A.BIRTH_DT                           AS BIRTH_DT                  --出生日期
          ,A.MARRIAGE_STAT                      AS MARRIAGE_STAT             --婚姻状况
          ,A.HIGH_DEGREE                        AS HIGH_DEGREE               --最高学历
          ,A.CUST_BLNG_IDY                      AS CUST_BLNG_IDY             --客户所属行业
          ,A.OCCUP                              AS OCCUP                     --职业
          ,A.TITLE                              AS TITLE                     --职称
          ,A.JOB                                AS JOB                       --职务
          ,A.IND_YEAR_INCOME                    AS IND_YEAR_INCOME           --个人年收入
          ,A.FAMILY_YEAR_INCOME                 AS FAMILY_YEAR_INCOME        --家庭年收入
          ,A.CO_NM                              AS CO_NM                     --单位名称
          ,A.CO_CHAR                            AS CO_CHAR                   --单位性质
          ,A.CO_ADDR                            AS CO_ADDR                   --单位地址
          ,A.CO_TEL                             AS CO_TEL                    --单位电话
          ,A.RSDNC_CTRY_CD                      AS RSDNC_CTRY_CD             --居住地国家代码
          ,A.RSDNC_ADDR                         AS RSDNC_ADDR                --居住地址
          ,A.RSDNC_AREA_CD                      AS RSDNC_AREA_CD             --居住地行政区划代码
          ,A.OPR_CUST_TYP                       AS OPR_CUST_TYP              --经营性客户类型
          ,A.BANK_EMP_FLG                       AS BANK_EMP_FLG              --本行员工标志
          ,A.FARM_FLG                           AS FARM_FLG                  --农户标志
          ,A.CONT_SIDE_FARM_FLG                 AS CONT_SIDE_FARM_FLG        --承包方农户标志
          /*,A.BLIST_FLG                          AS BLIST_FLG                 --上黑名单标志
          ,A.BLIST_DT                           AS BLIST_DT                  --上黑名单日期*/
          --MOD BY LIP 20230512 因黑名单供数时间较晚，会影响日报报送，所以改为到EAST加工
          ,CASE WHEN KA.CUST_CODE IS NOT NULL THEN 'Y' --MOD BY LIP 20241220 优先取新表数据
                WHEN K.CUSTOMER_NO IS NOT NULL THEN 'Y'
                ELSE 'N'
            END                                 AS BLIST_FLG                 --上黑名单标志
          --,K.CRT_DATE                           AS BLIST_DT                  --上黑名单日期
          ,CASE WHEN TRIM(KA.CRT_DATE) IS NOT NULL THEN KA.CRT_DATE --MOD BY LIP 20241220 优先取新表数据
                WHEN TRIM(K.CRT_DATE) IS NOT NULL THEN K.CRT_DATE
            END                                 AS BLIST_DT                  --上黑名单日期
          ,A.BANK_SENIOR_FLG                    AS BANK_SENIOR_FLG           --银行高管标志
          ,A.REL_PTY_FLG                        AS REL_PTY_FLG               --关联方标志
          ,A.AGR_REL_LOAN_CERT_ISU_NUM          AS AGR_REL_LOAN_CERT_ISU_NUM --发放支农贷款证数量
          ,A.ECON_ARCH_FLG                      AS ECON_ARCH_FLG             --经济档案标志
          ,A.CRDT_FLG                           AS CRDT_FLG                  --信用户标志
          ,A.JUR_FLG                            AS JUR_FLG                   --辖内标志
          ,A.OPEN_EBANK_FLG                     AS OPEN_EBANK_FLG            --开通网银标志
          ,A.DISABLED_FLG                       AS DISABLED_FLG              --残疾人标志
          ,A.LOW_INCM_FLG                       AS LOW_INCM_FLG              --低保户标志
          ,A.CUST_CRDT_RTG                      AS CUST_CRDT_RTG             --客户信用评级
          ,A.CUST_CR_RTG_TOT_GRD                AS CUST_CR_RTG_TOT_GRD       --客户信用评级总等级数
          ,A.CUST_STAT                          AS CUST_STAT                 --客户状态
          ,A.FIRST_ESTBL_CRDT_REL_DT            AS FIRST_ESTBL_CRDT_REL_DT   --首次建立信贷关系日期
          ,A.DEPT_LINE                          AS DEPT_LINE                 --部门条线
          ,A.DATA_SRC                           AS DATA_SRC                  --数据来源
          ,A.BIO_FLG                            AS BIO_FLG                   --境内外标志
          ,TRIM(CASE WHEN B.CUST_NM = A.CUST_NM THEN B.CUST_NM_DESEN --上月已脱敏的数据 MOD BY LHQ 20220404
                WHEN LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]','')) = LENGTHB(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))
                THEN SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''),LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))-2,3)
                ELSE SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''),LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]','')),1)
            END)                                AS CUST_NM_DESEN             --客户名称脱敏
          ,CASE WHEN B.CRDL_NO = A.CRDL_NO AND B.CUST_NM = A.CUST_NM THEN B.CRDL_NO_DESEN  --上月已脱敏的数据 MOD BY LHQ 20220404
                ELSE
                --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                CASE WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                     WHEN NVL(LENGTHB(TRIM(SUBSTRB(A.CRDL_NO,1,6))),0) = 0 THEN '000000'||TRIM(SUBSTRB(A.CRDL_NO,1,6))
                 END||
                RRP_EAST.SM3_ENCRYPT(CASE WHEN LENGTH(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))=LENGTHB(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''))
                                 THEN SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), 1, 3)
                                 ELSE SUBSTR(REGEXP_REPLACE(A.CUST_NM,'[[:punct:]]',''), 1, 1)
                             END || UPPER(A.CRDL_NO))
            END                                 AS CRDL_NO_DESEN             --证件号码脱敏
          ,CASE WHEN TRIM(B.PHONE_NUM) = COALESCE(TRIM(A.PHONE_NUM),TRIM(C.TEL_NUM),TRIM(B.PHONE_NUM)) THEN B.PHONE_NUM_DESEN --优先取上月数据 MOD BY LHQ 20220404
                --ELSE RRP_EAST.SM3_ENCRYPT(NVL(TRIM(A.PHONE_NUM),TRIM(C.TEL_NUM)))
                ELSE RRP_EAST.SM3_ENCRYPT(COALESCE(TRIM(A.PHONE_NUM),TRIM(C.TEL_NUM),TRIM(B.PHONE_NUM)))
            END                                 AS PHONE_NUM_DESEN           --手机号码脱敏
          ,A.AGE                                AS AGE                       --年龄
          ,A.DIST_CD                            AS DIST_CD                   --行政区划代码
          ,A.FAMILY_MON_INCO                    AS FAMILY_MON_INCO           --家庭月收入
          ,A.INDV_MON_INCO                      AS INDV_MON_INCO             --个人月收入
      FROM RRP_MDL.M_CUST_IND_INFO A --个人客户信息
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息EAST专用
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD') --取上月数据月当月数据比对
      LEFT JOIN TMP_ALB_TMP1 K
        ON K.CUSTOMER_NO = A.CUST_ID
       AND K.NUM = 1
      LEFT JOIN TMP_ALB_TMP2 KA
        ON KA.CUST_CODE = A.CUST_ID
       AND KA.NUM = 1
      LEFT JOIN RRP_MDL.O_IML_PTY_TEL_INFO_H C
        ON C.PARTY_ID = A.CUST_ID
       AND C.RN_RANK = 1
       AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       AND C.ID_MARK <> 'D'
     WHERE A.DATA_DT = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := 4;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CUST_IND_INFO_EAST;
/

