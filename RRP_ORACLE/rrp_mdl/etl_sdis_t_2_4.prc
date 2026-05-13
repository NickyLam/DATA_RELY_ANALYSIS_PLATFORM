CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SDIS_T_2_4(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_SDIS_T_2_4
  *  功能描述：表2.4 个体工商户及小微企业主基本情况 取数脚本
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
  V_ETL_DATE  DATE ;                                -- 跑批数据日期
  V_DATE      DATE;                                 -- 当前日期
  V_SYSTEM    VARCHAR2(30) := '一表通';              -- 来源系统
  V_PROC_NAME VARCHAR2(30) := 'ETL_SDIS_T_2_4';     -- 程序名称
  V_STARTTIME DATE;                                 -- 处理开始时间
  V_ENDTIME   DATE;                                 -- 处理结束时间
  V_STEP      INTEGER := 0;                         -- 处理步骤
  V_STEP_DESC VARCHAR2(500);                        -- 步骤描述
  V_SQLCOUNT  INTEGER;                              -- 记录数
  V_SQLMSG    VARCHAR2(500);                        -- SQL执行描述信息
  V_TAB_NAME  VARCHAR2(100) := 'SDIS_T_2_4';        -- 表名
  V_PART_NAME VARCHAR2(100);                        -- 分区名

BEGIN
  -- 获取跑批数据日期 --
  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_ETL_DATE    := TO_DATE(V_P_DATE,'YYYY-MM-DD');
  V_DATE      := TRUNC(SYSDATE);
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

  -- STEP3: 程序业务逻辑处理主体部分(个体工商户)
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表2.4 个体工商户及小微企业主基本情况(对公个体工商户)';
  V_STARTTIME := SYSDATE;
        INSERT INTO RRP_YBT.SDIS_T_2_4
             (
             RID            --数据主键
            ,B040001        --客户ID
            ,B040002        --机构ID
            ,B040034        --经营户个人ID
            ,B040003        --经营者姓名
            ,B040003_ORIG   --经营者姓名(脱敏前)
            ,B040004        --经营者证件类型
            ,B040005        --经营者证件号码
            ,B040005_ORIG   --经营者证件号码(脱敏前)
            ,B040006        --经营者从业年限
            ,B040033        --经营主体名称
            ,B040019        --经营范围
            ,B040020        --行业类型
            ,B040021        --经营户客户类型
            ,B040022        --经营地址
            ,B040023        --经营地所在行政区划
            ,B040032        --联系电话
            ,B040032_ORIG   --联系电话(脱敏前)
            ,B040024        --资产总额
            ,B040025        --负债总额
            ,B040026        --税前利润
            ,B040027        --主营业务收入
            ,B040028        --财务报表日期
            ,B040029        --信用评级结果
            ,B040030        --首次建立信贷关系年月
            ,B040031        --采集日期
            ,DEPT_NO        --条线
            ,ISSUED_NO      --填报机构
            ,RPT_ORG_NO     --报送机构
            ,DATA_DT        --数据日期
            ,ORG_ID_CHECK   --内部机构号
            ,RELA_TB_CHECK  --相关联一表通表格编号
             )
       SELECT
             SYS_GUID()                     AS RID                --数据主键
            ,A.CUST_ID                      AS B040001            --客户ID
            ,NVL(F.FIN_ORG_NO,'B1194H24405800')
                                            AS B040002            --机构ID
            ,NVL(TRIM(B.REL_PSN_CUST_ID),B.REL_PSN_CRDL_NO)
                                            AS B040034            --经营户个人ID
            ,NULL                           AS B040003            --经营者姓名
            ,CASE WHEN REGEXP_REPLACE(B.REL_PSN_CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                  THEN REPLACE(REPLACE(REPLACE(TRIM(B.REL_PSN_CUST_NM),'(','（'),')','）'),' ','')
                  ELSE TRIM(B.REL_PSN_CUST_NM)
             END                            AS B040003_ORIG       --经营者姓名(脱敏前)
            ,NVL(CODE4.TAR_VALUE_CODE,CODE4.SRC_VALUE_CODE)
                                            AS B040004            --经营者证件类型
            ,NULL                           AS B040005            --经营者证件号码
            ,B.REL_PSN_CRDL_NO              AS B040005_ORIG       --经营者证件号码(脱敏前)
            --,CASE WHEN SUBSTR(A.ESTM_DT,1,4)<'1949' THEN ROUND(MONTHS_BETWEEN(V_DATE,TO_DATE(A.ESTM_DT,'YYYY-MM-DD'))/12,2) END
            ,NULL                           AS B040006            --经营者从业年限         --20251126张家伟：问题数据较多先置空处理
            --,REPLACE(REPLACE(REMOVE_SPECIAL_CHARS(A.CUST_NM),CHR(10),''),CHR(13),'')
            ,CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                  THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                  ELSE TRIM(A.CUST_NM)
                  END                       AS B040033            --经营主体名称
            ,A.OPR_SCOPE                    AS B040019            --经营范围
            ,CODE5.SRC_VALUE_CODE           AS B040020            --行业类型
            ,'02'                           AS B040021            --经营户客户类型
            ,COALESCE(TRIM(D.WORK_ADDR),TRIM(D.RGST_ADDR),TRIM(D.POSTA_ADDR),TRIM(A.OPR_ADDR))     --20251210张家伟：优先取办公地址 （证件）注册地址  然后是生产经营地址 最后通讯地址
                                            AS B040022            --经营地址
            ,TRIM(A.OPR_LAND_AREA_CD)       AS B040023            --经营地所在行政区划
            ,NULL                           AS B040032            --联系电话
            ,A.TEL                          AS B040032_ORIG       --联系电话(脱敏前)
            ,C.AST_TOT_AMT                  AS B040024            --资产总额
            ,C.LBY_TOT_AMT                  AS B040025            --负债总额
            ,C.PRE_TAX_PROFIT               AS B040026            --税前利润
            ,C.MAIN_BIZ_INCOME              AS B040027            --主营业务收入
            ,TO_CHAR(TO_DATE(C.FIN_RPT_DT,'YYYY-MM-DD'),'YYYY-MM-DD')
                                            AS B040028            --财务报表日期
            ,A.CUST_CRDT_RTG                AS B040029            --信用评级结果
            ,CASE WHEN A.FIRST_ESTBL_CRDT_REL_DT IS NOT NULL
                  THEN SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,1,4)||'-'||SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,5,2)
                  END                       AS B040030            --首次建立信贷关系年月
            ,TO_CHAR(TO_DATE(V_P_DATE,'YYYY-MM-DD'),'YYYY-MM-DD')
                                            AS B040031            --采集日期
            ,'LSFXB'                        AS DEPT_NO            --条线
            ,'000000'                       AS ISSUED_NO          --填报机构
            ,'000000'                       AS RPT_ORG_NO         --报送机构
            ,V_P_DATE                       AS DATA_DT            --数据日期
            ,A.ORG_ID                       AS ORG_ID_CHECK       --内部机构号
            ,CU.DATA_SRC                    AS RELA_TB_CHECK      --相关联一表通表格编号

        FROM RRP_MDL.M_CUST_CORP_INFO A --对公客户信息

        LEFT JOIN (
                    SELECT
                         B1.CUST_ID
                        ,B1.REL_PSN_TYP
                        ,B1.REL_PSN_CRDL_NO
                        ,B1.REL_PSN_CUST_NM
                        ,B1.REL_PSN_CRDL_TYP
                        ,B1.REL_PSN_CUST_ID
                        ,ROW_NUMBER() OVER(PARTITION BY B1.CUST_ID,B1.REL_TYP,B1.REL_PSN_TYP
                                          ORDER BY B1.DATA_SRC,B1.REL_PSN_CRDL_TYP NULLS LAST,B1.REL_PSN_CRDL_NO DESC NULLS LAST
                                         ) AS NUM
                    FROM RRP_MDL.M_CUST_CORP_REL_SUB       B1 --对公客户关联人子表
                    WHERE B1.REL_PSN_TYP = '01' --法定代表人
                    AND B1.DATA_DT=V_P_DATE
                  )B --对公客户关联人子表
        ON A.CUST_ID = B.CUST_ID
        AND NUM = 1

        LEFT JOIN RRP_MDL.M_CUST_CORP_FIN_SUB C --对公客户财务信息子表
        ON A.CUST_ID=C.CUST_ID
        AND C.DATA_DT=V_P_DATE

        LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO D  --对公客户基本信息
        ON A.CUST_ID=D.CUST_ID
        AND D.ETL_DT=V_ETL_DATE

        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_YBT F              --20251205统一取机构号
               ON F.ORG_ID = A.ORG_ID
              AND F.DATA_DT = V_P_DATE

      LEFT JOIN RRP_MDL.CODE_MAP CODE1
             ON CODE1.SRC_VALUE_CODE = TRIM(A.OPR_LAND_AREA_CD)
            AND CODE1.SRC_CLASS_CODE = 'XZQH'  --行政区划
            AND CODE1.MOD_FLG = 'YBT'

      LEFT JOIN RRP_MDL.CODE_MAP CODE4
             ON CODE4.SRC_VALUE_CODE = B.REL_PSN_CRDL_TYP
            AND CODE4.SRC_CLASS_CODE = 'CD1014'  --证件类型
            AND CODE4.MOD_FLG = 'YBT'

      LEFT JOIN RRP_MDL.CODE_MAP CODE5
             ON CODE5.SRC_VALUE_CODE = TRIM(A.CUST_BLNG_IDY）   --如无需保留不规范值取CODE5.SRC_VALUE_CODE
            AND CODE5.SRC_CLASS_CODE = 'HYLX'  --行业类型
            AND CODE5.MOD_FLG = 'YBT'

     INNER JOIN RRP_YBT.CUSTOMER_FLAG_YBT CU                    --业务客户ID统计表
            ON A.CUST_ID = CU.CUST_ID
           AND CU.DATA_DT = V_P_DATE

        WHERE A.DATA_DT = V_P_DATE
        --AND A.INDIV_MERCHANT_FLG = '1' --有字号的个体工商户 无字号的个体工商户
        AND A.CUST_CL = 'E'
        --AND A.OPR_STAT <> '02'  --停业
        ;

  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- STEP4: 程序业务逻辑处理主体部分(小微企业主)
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '表2.4 个体工商户及小微企业主基本情况(个人客户)';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_YBT.SDIS_T_2_4
             (
             RID            --数据主键
            ,B040001        --客户ID
            ,B040002        --机构ID
            ,B040034        --经营户个人ID
            ,B040003        --经营者姓名
            ,B040003_ORIG   --经营者姓名(脱敏前)
            ,B040004        --经营者证件类型
            ,B040005        --经营者证件号码
            ,B040005_ORIG   --经营者证件号码(脱敏前)
            ,B040006        --经营者从业年限
            ,B040033        --经营主体名称
            ,B040019        --经营范围
            ,B040020        --行业类型
            ,B040021        --经营户客户类型
            ,B040022        --经营地址
            ,B040023        --经营地所在行政区划
            ,B040032        --联系电话
            ,B040032_ORIG   --联系电话(脱敏前)
            ,B040024        --资产总额
            ,B040025        --负债总额
            ,B040026        --税前利润
            ,B040027        --主营业务收入
            ,B040028        --财务报表日期
            ,B040029        --信用评级结果
            ,B040030        --首次建立信贷关系年月
            ,B040031        --采集日期
            ,DEPT_NO        --条线
            ,ISSUED_NO      --填报机构
            ,RPT_ORG_NO     --报送机构
            ,DATA_DT        --数据日期
            ,ORG_ID_CHECK   --内部机构号
            ,RELA_TB_CHECK  --相关联一表通表格编号
             )
       SELECT SYS_GUID()                            AS RID                  --数据主键
                ,A.CUST_ID                          AS B040001              --客户ID
                ,NVL(F.FIN_ORG_NO,'B1194H24405800') AS B040002              --机构ID
                ,A.CUST_ID                          AS B040034              --经营户个人ID
                ,NULL                               AS B040003              --经营者姓名
                ,CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                      THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                      ELSE TRIM(A.CUST_NM)
                      END                           AS B040003_ORIG         --经营者姓名(脱敏前)
                ,NVL(CODE4.TAR_VALUE_CODE,CODE4.SRC_VALUE_CODE)
                                                    AS B040004              --经营者证件类型
                ,NULL                               AS B040005              --经营者证件号码
                ,A.CRDL_NO                          AS B040005_ORIG         --经营者证件号码(脱敏前)
                --,ROUND(MONTHS_BETWEEN(V_DATE,H.CORP_FOUND_DT)/12,2)
                ,NULL                               AS B040006              --经营者从业年限
                --,REPLACE(REPLACE(REMOVE_SPECIAL_CHARS(COALESCE(H.CORP_NAME,A.CO_NM)),CHR(10),''),CHR(13),'')
                ,CASE WHEN REGEXP_REPLACE(NVL(H.CORP_NAME,A.CO_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                      THEN REPLACE(REPLACE(REPLACE(TRIM(NVL(H.CORP_NAME,A.CO_NM)),'(','（'),')','）'),' ','')
                      ELSE TRIM(NVL(H.CORP_NAME,A.CO_NM))
                      END                           AS B040033              --经营主体名称
                ,C.OPR_SCOPE                        AS B040019              --经营范围
                ,CODE5.SRC_VALUE_CODE               AS B040020              --行业类型
                ,CASE WHEN A.OPR_CUST_TYP = 'A' THEN '01'
                      WHEN A.OPR_CUST_TYP = 'B' THEN '03'
                      END                           AS B040021              --经营户客户类型
                ,NVL(C.OPR_ADDR,A.CO_ADDR)          AS B040022              --经营地址
                ,NVL(TRIM(A.CUST_BLNG_LAND_AREA_CD),CODE2.SRC_VALUE_CODE)
                                                    AS B040023              --经营地所在行政区划
                ,NULL                               AS B040032              --联系电话
                ,A.PHONE_NUM                        AS B040032_ORIG         --联系电话(脱敏前)
                ,NVL(D.AST_TOT_AMT,H.TOT_ASSET)     AS B040024              --资产总额
                ,D.LBY_TOT_AMT                      AS B040025              --负债总额
                ,D.PRE_TAX_PROFIT                   AS B040026              --税前利润
                ,D.MAIN_BIZ_INCOME                  AS B040027              --主营业务收入
                ,TO_CHAR(TO_DATE(D.FIN_RPT_DT,'YYYY-MM-DD'),'YYYY-MM-DD') AS B040028        --财务报表日期
                ,C.CUST_CRDT_RTG                    AS B040029              --信用评级结果
                ,CASE WHEN A.FIRST_ESTBL_CRDT_REL_DT IS NOT NULL
                      THEN SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,1,4)||'-'||SUBSTR(A.FIRST_ESTBL_CRDT_REL_DT,5,2)
                      END                           AS B040030              --首次建立信贷关系年月
                ,TO_CHAR(TO_DATE(V_P_DATE,'YYYY-MM-DD'),'YYYY-MM-DD')
                                                    AS B040031              --采集日期
                ,'LSFXB'                            AS DEPT_NO              --条线
                ,'000000'                           AS ISSUED_NO            --填报机构
                ,'000000'                           AS RPT_ORG_NO           --报送机构
                ,V_P_DATE                           AS DATA_DT              --数据日期
                ,A.ORG_ID                           AS ORG_ID_CHECK         --内部机构号
                ,CU.DATA_SRC                        AS RELA_TB_CHECK        --相关联一表通表格编号
            FROM RRP_MDL.M_CUST_IND_INFO A  --个人客户基本信息

            LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C         --对公客户信息表
            ON  A.CRDL_NO = C.CRDL_NO
            AND C.DATA_DT = V_P_DATE

            LEFT JOIN RRP_MDL.M_CUST_CORP_FIN_SUB D --对公客户财务信息子表
            ON A.CUST_ID=D.CUST_ID
            AND D.DATA_DT=V_P_DATE

            LEFT JOIN RRP_MDL.O_IML_PTY_INDV_CUST_CORP_H H --个人客户经营实体历史
            ON A.CUST_ID=H.CUST_ID
            AND H.START_DT <= V_ETL_DATE
            AND H.END_DT > V_ETL_DATE

        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_YBT F              --20251205统一取机构号
               ON F.ORG_ID = A.ORG_ID
              AND F.DATA_DT = V_P_DATE

            LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_ATTACH_INFO G  --个人客户补充信息
            ON A.CUST_ID = G.CUST_ID
            AND G.ETL_DT = V_ETL_DATE

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

      LEFT JOIN RRP_MDL.CODE_MAP CODE5
             ON CODE5.SRC_VALUE_CODE = NVL(A.CUST_BLNG_IDY,G.MANG_ENTY_BL_INDUTY_TYPE_CD)
            AND CODE5.SRC_CLASS_CODE = 'HYLX'  --行业类型
            AND CODE5.MOD_FLG = 'YBT'

     INNER JOIN RRP_YBT.CUSTOMER_FLAG_YBT CU                    --业务客户ID统计表
            ON A.CUST_ID = CU.CUST_ID
           AND CU.DATA_DT = V_P_DATE

            WHERE A.DATA_DT = V_P_DATE
            AND A.OPR_CUST_TYP IN ('A','B')     --经营性客户类型 A个体工商户标志 B小微企业主标志
            --AND (A.CUST_STAT <> 'C' --注销
            --        OR TRUNC(H.CLOS_ACCT_DT,'YYYY') = TRUNC(V_ETL_DATE,'YYYY'))
         ;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- STEP5: 表分析 --
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

  -- STEP6: 跑批结束 --
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

END ETL_SDIS_T_2_4;
/

