CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SDIS_T_2_5(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_SDIS_T_2_5
  *  功能描述：表2.5 个人客户基本情况 取数脚本
  *  目标表  ：
  *  来源表  ：
  *  配置表  ：不涉及
  *  创建日期：20250806
  *  开发人员：chenzw
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250806  chenzw     首次创建
  ***************************************************************************/
AS
  --定义变量--
  V_P_DATE    VARCHAR2(8);                          -- 跑批数据日期
  V_ETL_DATE  DATE;
  V_SYSTEM    VARCHAR2(30) := '一表通';             -- 来源系统
  V_PROC_NAME VARCHAR2(30) := 'ETL_SDIS_T_2_5';     -- 程序名称
  V_STARTTIME DATE;                                 -- 处理开始时间
  V_ENDTIME   DATE;                                 -- 处理结束时间
  V_STEP      INTEGER := 0;                         -- 处理步骤
  V_STEP_DESC VARCHAR2(500);                        -- 步骤描述
  V_SQLCOUNT  INTEGER;                              -- 记录数
  V_SQLMSG    VARCHAR2(500);                        -- SQL执行描述信息
  V_TAB_NAME  VARCHAR2(100) := 'SDIS_T_2_5';        -- 表名
  V_PART_NAME VARCHAR2(100);                        -- 分区名

BEGIN
  -- 获取跑批数据日期 --
  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_ETL_DATE  := TO_DATE(V_P_DATE,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- STEP1：跑批开始 --
  V_STEP      := 1;
  V_STEP_DESC := '跑批开始';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP2: 处理表分区 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '处理分区';
  V_STARTTIME := SYSDATE;
  RRP_YBT.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  RRP_YBT.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TAB_NAME,O_ERRCODE);
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP3: 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表2.5 个人客户基本情况';
  V_STARTTIME := SYSDATE;
        INSERT INTO RRP_YBT.SDIS_T_2_5
                 (
                    RID         --数据主键
                    ,B050001     --客户ID
                    ,B050002     --机构ID
                    ,B050003     --个人客户名称
                    ,B050003_ORIG   --个人客户名称(脱敏前)
                    ,B050004     --个人客户类型
                    ,B050005     --客户身份证
                    ,B050005_ORIG   --客户身份证(脱敏前)
                    ,B050006     --客户护照号
                    ,B050006_ORIG   --客户护照号(脱敏前)
                    ,B050007     --客户其他证件类型
                    ,B050008     --客户其他证件号码
                    ,B050008_ORIG   --客户其他证件号码(脱敏前)
                    ,B050009     --民族
                    ,B050010     --性别
                    ,B050011     --学历
                    ,B050012     --出生日期
                    ,B050013     --已婚标识
                    ,B050014     --电话1
                    ,B050014_ORIG   --电话1(脱敏前)
                    ,B050015     --电话2
                    ,B050015_ORIG   --电话2(脱敏前)
                    ,B050016     --工作单位名称
                    ,B050017     --工作单位电话
                    ,B050018     --工作单位地址
                    ,B050019     --单位性质
                    ,B050020     --职业
                    ,B050021     --职务
                    ,B050022     --个人年收入
                    ,B050023     --家庭收入
                    ,B050024     --通讯地址
                    ,B050037     --个人客户行政区划
                    ,B050026     --本行员工标识
                    ,B050027     --首次建立信贷关系年月
                    ,B050028     --上本行黑名单标识
                    ,B050029     --上黑名单日期
                    ,B050030     --上黑名单原因
                    ,B050031     --居民标识
                    ,B050032     --国家地区
                    ,B050033     --农户及新型农业经营主体标识
                    ,B050034     --已脱贫人口标识
                    ,B050035     --边缘易致贫人口标识
                    ,B050036     --采集日期
                    ,DEPT_NO     --条线
                    ,ISSUED_NO   --填报机构
                    ,RPT_ORG_NO  --报送机构
                    ,DATA_DT     --数据日期
                    ,ORG_ID_CHECK   --内部机构号
                    ,RELA_TB_CHECK  --相关联一表通表格编号
                 )
          SELECT SYS_GUID()                       AS RID        --数据主键
                ,A.CUST_ID                        AS B050001    --客户ID
                ,NVL(B.FIN_ORG_NO,'B1194H24405800')
                                                  AS B050002    --机构ID
                ,NULL                             AS B050003    --个人客户名称
                ,CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                      THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                      ELSE TRIM(A.CUST_NM)
                      END                         AS B050003_ORIG    --个人客户名称(脱敏前)
                ,CASE WHEN A.OPR_CUST_TYP = 'A'  THEN '02'      --A个体工商户标志 B小微企业主标志
                      WHEN A.OPR_CUST_TYP = 'B'  THEN '03'      --A个体工商户标志 B小微企业主标志
                      WHEN A.CTRY_CD <> 'CHN' THEN '04'
                      ELSE '01'
                      END                         AS B050004    --个人客户类型
                ,NULL                             AS B050005    --客户身份证
                ,CASE WHEN CODE4.SRC_VALUE_CODE = '1010' THEN A.CRDL_NO
                      END                         AS B050005_ORIG    --客户身份证(脱敏前)
                ,NULL                             AS B050006    --客户护照号
                ,CASE WHEN CODE4.SRC_VALUE_CODE = '1050' THEN A.CRDL_NO
                      END                         AS B050006_ORIG    --客户护照号(脱敏前)
                ,CASE WHEN CODE4.SRC_VALUE_CODE NOT IN ('1010','1050') THEN NVL(CODE4.TAR_VALUE_CODE,CODE4.SRC_VALUE_CODE)
                      END                         AS B050007    --客户其他证件类型
                ,NULL                             AS B050008    --客户其他证件号码
                ,CASE WHEN CODE4.SRC_VALUE_CODE NOT IN ('1010','1050') THEN A.CRDL_NO
                      END                         AS B050008_ORIG    --客户其他证件号码(脱敏前)
                ,A.ETHNIC                         AS B050009    --民族
                ,DECODE(A.GENDER,'1','01','2','02')
                                                  AS B050010    --性别  --01男男性 02女女性
                ,CASE WHEN A.HIGH_DEGREE = '73' THEN '72'
                      WHEN A.HIGH_DEGREE = '83' THEN '82'
                      WHEN A.HIGH_DEGREE = '00' THEN '90'
                      WHEN A.HIGH_DEGREE = '28' THEN '20'
                      ELSE A.HIGH_DEGREE
                      END                         AS B050011    --学历
                ,CASE WHEN TRIM(A.BIRTH_DT) IS NOT NULL AND TRIM(A.BIRTH_DT) <> '00010101' THEN TO_CHAR(TO_DATE(A.BIRTH_DT,'YYYY-MM-DD'),'YYYY-MM-DD')
                      ELSE '9999-12-31'
                      END                         AS B050012    --出生日期
                ,CASE WHEN SUBSTR(A.MARRIAGE_STAT,1,2) ='02' THEN '1'
            ELSE '0'
                      END                         AS B050013    --已婚标识
                ,NULL                             AS B050014    --电话1
                ,NVL(TRIM(A.PHONE_NUM),G.MOVE_NUM)
                                                  AS B050014_ORIG    --电话1(脱敏前)
                ,NULL                             AS B050015    --电话2
                ,NULL                             AS B050015_ORIG    --电话2(脱敏前)
                ,A.CO_NM                          AS B050016    --工作单位名称
                ,A.CO_TEL                         AS B050017    --工作单位电话
                ,A.CO_ADDR                        AS B050018    --工作单位地址
                ,CASE WHEN A.CO_CHAR = '1' THEN '01'
                      WHEN A.CO_CHAR = '2' THEN '02'
                      WHEN A.CO_CHAR = '3' THEN '03'
                      WHEN A.CO_CHAR = '4' THEN '04'
                      WHEN A.CO_CHAR = '5' THEN '05'
                      WHEN A.CO_CHAR = '6' THEN '06'
                      WHEN A.CO_CHAR = '99' THEN '00'
                      END                         AS B050019    --单位性质                               --如无口径变更后续调整加入码表CODE_MAP
                ,A.OCCUP                          AS B050020    --职业
                ,A.JOB                            AS B050021    --职务
                ,GREATEST(NVL(A.IND_YEAR_INCOME,0),NVL(A.INDV_MON_INCO*12,0))
                                                  AS B050022    --个人年收入
                /*
                ,CASE WHEN A.FAMILY_YEAR_INCOME >= A.IND_YEAR_INCOME THEN A.FAMILY_YEAR_INCOME
                      ELSE A.IND_YEAR_INCOME
                      END                         AS B050023    --家庭收入
                      */
                ,GREATEST(NVL(A.FAMILY_YEAR_INCOME,0),NVL(A.IND_YEAR_INCOME,0),NVL(A.FAMILY_MON_INCO*12,0),NVL(A.INDV_MON_INCO*12,0))
                                                  AS B050023    --家庭收入
                ,A.RSDNC_ADDR                     AS B050024    --通讯地址
                ,COALESCE(TRIM(F.RG_COUNTY_CD),TRIM(A.CUST_BLNG_LAND_AREA_CD),CODE2.SRC_VALUE_CODE)
                                                  AS B050037    --个人客户行政区划
                ,DECODE(A.BANK_EMP_FLG,'Y','1','N','0')
                                                  AS B050026    --本行员工标识
                ,CASE WHEN A.FIRST_ESTBL_CRDT_REL_DT IS NOT NULL
                      THEN SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,1,4) ||'-'|| SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,5,2)
                      END                         AS B050027    --首次建立信贷关系年月
                ,CASE WHEN E.CUST_ID IS NOT NULL THEN '1' ELSE '0'
                      END                         AS B050028    --上本行黑名单标识
                ,NVL(TO_CHAR(TO_DATE(E.CRT_DATE,'YYYY-MM-DD'),'YYYY-MM-DD'),'9999-12-31')
                                                  AS B050029    --上黑名单日期
                ,E.BLOCK_REASON                   AS B050030    --上黑名单原因
                ,DECODE(A.RSDNT_FLG,'Y','1','N','0')
                                                  AS B050031    --居民标识
                ,CASE WHEN TRIM(A.CTRY_CD) IS NOT NULL AND TRIM(A.CTRY_CD)<>'XXX' THEN TRIM(A.CTRY_CD)
                      WHEN TRIM(A.CTRY_CD) = 'XXX' THEN 'CHN'
                      END                         AS B050032    --国家地区
                ,DECODE(A.FARM_FLG,'Y','1','N','0','0')
                                                  AS B050033    --农户及新型农业经营主体标识
                ,CASE WHEN C.REC_POOR_PSN_LOAN_TYP = '201' THEN '1'  --脱贫状态 101-未脱贫 201-脱贫
                      WHEN C.REC_POOR_PSN_LOAN_TYP = '101' THEN '0'
                      ELSE '0'                                             --匹配到清单上的所有客户都显示为已脱贫客户  匹配不到的显示为否
                      END                         AS B050034    --已脱贫人口标识
                ,'0'                              AS B050035    --边缘易致贫人口标识
                ,TO_CHAR(TO_DATE(A.DATA_DT,'YYYY-MM-DD'),'YYYY-MM-DD')
                                                  AS B050036    --采集日期
                ,'LSFXB'                          AS DEPT_NO     --条线
                ,'000000'                         AS ISSUED_NO   --填报机构
                ,'000000'                         AS RPT_ORG_NO  --报送机构
                ,V_P_DATE                         AS DATA_DT     --数据日期
                ,A.ORG_ID                         AS ORG_ID_CHECK     --内部机构号
                ,CU.DATA_SRC                      AS RELA_TB_CHECK    --相关联一表通表格编号

        FROM RRP_MDL.M_CUST_IND_INFO A          --个人客户信息

        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_YBT B              --20251205统一取机构号
               ON B.ORG_ID = A.ORG_ID
              AND B.DATA_DT = V_P_DATE
        /*
        LEFT JOIN (
                    SELECT DISTINCT C.CUST_ID                                       --同一个客户有已脱贫和未脱贫的两条数据导致主键发散
                                   ,C.REC_POOR_PSN_LOAN_TYP
                            FROM RRP_MDL.M_LOAN_POV_ALLE_SUB C --精准扶贫贷款子表
                           WHERE C.DATA_DT = V_P_DATE
                             AND C.REC_POOR_PSN_LOAN_TYP IS NOT NULL
                    ) C
        ON A.CUST_ID = C.CUST_ID
         */
        LEFT JOIN (
                             SELECT C.CUST_ID
                                   ,MAX(C.REC_POOR_PSN_LOAN_TYP) AS REC_POOR_PSN_LOAN_TYP
                            FROM RRP_MDL.M_LOAN_POV_ALLE_SUB C --精准扶贫贷款子表
                           WHERE C.DATA_DT = V_P_DATE
                             AND C.REC_POOR_PSN_LOAN_TYP IS NOT NULL
                             GROUP BY C.CUST_ID
                    ) C
               ON A.CUST_ID = C.CUST_ID

    LEFT JOIN
      (
      SELECT  CUST_CODE AS CUST_ID
           ,CRT_DATE
           ,CONFIRM_DESC --上黑名单原因
           ,ROW_NUMBER() OVER(PARTITION BY CUST_CODE ORDER BY ETL_DT DESC,CRT_DATETIME DESC,CRT_DATE DESC) NUM
        FROM RRP_MDL.O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND --黑名单系统 增量客户命中表
       WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       ) D
               ON A.CUST_ID = D.CUST_ID
              AND D.NUM = 1

     LEFT JOIN
       (
      SELECT CUSTOMER_NO AS CUST_ID
          ,CRT_DATE
          ,BLOCK_REASON
          ,ROW_NUMBER() OVER(PARTITION BY CUSTOMER_NO ORDER BY CRT_DATE DESC) NUM
        FROM RRP_MDL.O_IOL_ALBS_BLS_CUST_ALL_AML --黑名单系统供数给反洗钱系统黑名单表
       WHERE ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      ) E
               ON A.CUST_ID = E.CUST_ID
              AND E.NUM = 1

        LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_PHYS_ADDR_H F --当事人物理地址历史
               ON  F.PARTY_ID = A.CUST_ID
              AND F.START_DT <= V_ETL_DATE
              AND F.END_DT   > V_ETL_DATE
              AND F.PHYS_ADDR_TYPE_CD = '01'
              AND F.SRC_SYS_CD = 'EIFS'
              AND TRIM(F.RG_COUNTY_CD) IS NOT NULL

        LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_ATTACH_INFO G --个人客户补充信息
               ON G.CUST_ID = A.CUST_ID
              AND G.ETL_DT = V_ETL_DATE

        LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO H  --个人客户基本信息
               ON A.CUST_ID = H.CUST_ID
              AND H.ETL_DT = V_ETL_DATE

        LEFT JOIN RRP_MDL.CODE_MAP CODE3
               ON CODE3.SRC_VALUE_CODE = TRIM(F.RG_COUNTY_CD)
              AND CODE3.SRC_CLASS_CODE = 'XZQH'  --行政区划
              AND CODE3.MOD_FLG = 'YBT'

        LEFT JOIN RRP_MDL.CODE_MAP CODE1
               ON CODE1.SRC_VALUE_CODE = TRIM(A.CUST_BLNG_LAND_AREA_CD)
              AND CODE1.SRC_CLASS_CODE = 'XZQH'  --行政区划
              AND CODE1.MOD_FLG = 'YBT'

        LEFT JOIN RRP_MDL.CODE_MAP CODE2
               ON CODE2.SRC_VALUE_CODE = SUBSTR(A.CRDL_NO,1,6)
              AND CODE2.SRC_CLASS_CODE = 'XZQH'  --行政区划
              AND CODE2.MOD_FLG = 'YBT'
              AND A.CRDL_TYP = '1010'

        LEFT JOIN RRP_MDL.CODE_MAP CODE4
               ON CODE4.SRC_VALUE_CODE = A.CRDL_TYP
              AND CODE4.SRC_CLASS_CODE = 'CD1014'  --证件类型
              AND CODE4.MOD_FLG = 'YBT'

      INNER JOIN RRP_YBT.CUSTOMER_FLAG_YBT CU                    --业务客户ID统计表
              ON A.CUST_ID = CU.CUST_ID
             AND CU.DATA_DT = V_P_DATE

           WHERE A.DATA_DT=V_P_DATE
          --AND (A.CUST_STAT <> 'C' --注销
          --OR TRUNC(H.CLOS_ACCT_DT,'YYYY') = TRUNC(V_ETL_DATE,'YYYY'))
        ;

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP4: 表分析 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  RRP_YBT.ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP5: 跑批结束 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
       VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 异常处理 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_SDIS_T_2_5;
/

