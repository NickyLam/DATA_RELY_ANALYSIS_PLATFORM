CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SDIS_T_2_3(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_SDIS_T_2_3
  *  功能描述：表2.3 同业客户基本情况 取数脚本
  *  目标表  ：
  *  来源表  ：
  *  配置表  ：不涉及
  *  创建日期：20250806
  *  开发人员：chenzw
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250806  chenzw     首次创建
  *             2    20251105  yanyh      调整统一社会信用代码、资本币种、首贷日期等字段逻辑，适应校验规则
  ***************************************************************************/
AS
  --定义变量--
  V_P_DATE    VARCHAR2(8);                          -- 跑批数据日期
  V_ETL_DATE  DATE;                          -- 跑批数据日期
  V_SYSTEM    VARCHAR2(30) := '一表通';             -- 来源系统
  V_PROC_NAME VARCHAR2(30) := 'ETL_SDIS_T_2_3';     -- 程序名称
  V_STARTTIME DATE;                                 -- 处理开始时间
  V_ENDTIME   DATE;                                 -- 处理结束时间
  V_STEP      INTEGER := 0;                         -- 处理步骤
  V_STEP_DESC VARCHAR2(500);                        -- 步骤描述
  V_SQLCOUNT  INTEGER;                              -- 记录数
  V_SQLMSG    VARCHAR2(500);                        -- SQL执行描述信息
  V_TAB_NAME  VARCHAR2(100) := 'SDIS_T_2_3';        -- 表名
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
  V_STEP_DESC := '表2.3 同业客户基本情况';
  V_STARTTIME := SYSDATE;
       INSERT INTO RRP_YBT.SDIS_T_2_3
             (
                 RID         --数据主键
                ,B030001     --同业ID
                ,B030002     --机构ID
                ,B030003     --客户名称
                ,B030004     --机构类型
                ,B030037     --对公客户类型
                ,B030038     --企业控股类型
                ,B030005     --金融许可证件号码
                ,B030006     --SWIFT编码
                ,B030007     --组织机构代码
                ,B030008     --经营范围
                ,B030009     --成立日期
                ,B030010     --注册地址
                ,B030011     --注册地国家地区
                ,B030012     --注册地行政区划
                ,B030013     --法定代表人姓名
                ,B030014     --法定代表人证件类型
                ,B030015_ORIG     --法定代表人证件号码(脱敏前)
                ,B030015     --法定代表人证件号码
                ,B030016     --财务人员姓名
                ,B030017     --财务人员证件类型
                ,B030018_ORIG     --财务人员证件号码(脱敏前)
                ,B030018     --财务人员证件号码
                ,B030019     --基本存款账号
                ,B030020     --基本存款账户开户行行号
                ,B030021     --基本存款账户开户行名称
                ,B030022     --注册资本
                ,B030023     --注册资本币种
                ,B030024     --实收资本
                ,B030025     --实收资本币种
                ,B030026     --上市企业标识
                ,B030027     --员工人数
                ,B030028     --负责人姓名
                ,B030029     --机构联系电话
                ,B030030     --外部评级结果
                ,B030031     --信用评级机构
                ,B030032     --内部评级结果
                ,B030033     --首次授信日期
                ,B030034     --风险预警信号
                ,B030035     --关注事件代码
                ,B030036     --采集日期
                ,DEPT_NO     --条线
                ,ISSUED_NO   --填报机构
                ,RPT_ORG_NO  --报送机构
                ,DATA_DT     --数据日期
                ,MGR_ID_CHECK     --管户经理ID
                ,ORG_ID_CHECK     --内部机构号
                ,ORG_NM_CHECK     --内部机构对应名称
                ,RELA_TB_CHECK    --相关联一表通表格编号
             )
       SELECT SYS_GUID()                                               AS RID              --数据主键
            ,A.CUST_ID                                                 AS B030001          --同业ID
            ,NVL(B.FIN_ORG_NO,'B1194H24405800')                        AS B030002          --机构ID
            ,CASE WHEN REGEXP_REPLACE(A.CUST_NM,'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                  THEN REPLACE(REPLACE(REPLACE(TRIM(A.CUST_NM),'(','（'),')','）'),' ','')
                  ELSE TRIM(A.CUST_NM)
                  END                                                  AS B030003          --客户名称
            ,NVL(CASE WHEN A.LP_ORG_TYPE_CD = '02' AND CODE1.TAR_VALUE_CODE = '10' THEN '11'
                  ELSE CODE1.TAR_VALUE_CODE
                  END
                    ,CASE WHEN SUBSTR(H.FIN_INST_CATE_CD,1,1) = '2' THEN '26'
                          ELSE '24'
                          END)                                         AS B030004          --机构类型
            ,CASE WHEN A.ENT_SCALE = 'L' THEN '01'  -- 01大型企业(码值C0018)
                  WHEN A.ENT_SCALE = 'M' THEN '02'  -- 02中型企业
                  WHEN A.ENT_SCALE = 'S' THEN '03'  -- 03小型企业
                  WHEN A.ENT_SCALE = 'X' THEN '04'  -- 04微型企业
                  WHEN A.NATL_ECON_DEPT_CL IN ('A01','A02')
                  THEN '05'                          -- 05机关
                  WHEN A.CUST_CL like 'C%'
                  THEN '06'                          -- 06事业单位
                  WHEN A.CUST_CL like 'D%'
                  THEN '07'                          -- 07社会团体
                  WHEN  A.NATL_ECON_DEPT_CL LIKE 'E%' AND A.REGD_CPTL_CUR <> 'CNY'
                  THEN '09'                          -- 09境外机构
                  ELSE '08'                          -- 08其他组织机构
                  END                                                  AS B030037          --对公客户类型
            ,CASE WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'A%' THEN '01'
                  WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'B%' THEN '02'
                  WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'C%' THEN '03'
                  WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'D%' THEN '04'
                  WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'E%' THEN '05'
                  WHEN NVL(J.TAR_VALUE_CODE,A.ENT_HLDG_TYP) LIKE 'X%' THEN '06'
                  END                                                  AS B030038          --企业控股类型
            ,CASE WHEN LENGTH(COALESCE(TRIM(A.FIN_PERMIT_NO),TRIM(H.FIN_LICS_NUM),TRIM(H.INSURE_LICS_NUM),TRIM(H.SECU_LICS_NUM))) <= 15
                    AND COALESCE(TRIM(A.FIN_PERMIT_NO),TRIM(H.FIN_LICS_NUM),TRIM(H.INSURE_LICS_NUM),TRIM(H.SECU_LICS_NUM)) IS NOT NULL
				  THEN COALESCE(A.FIN_PERMIT_NO,TRIM(H.FIN_LICS_NUM),H.INSURE_LICS_NUM,H.SECU_LICS_NUM)
                  END                                                  AS B030005          --金融许可证件号码
            ,NVL(TRIM(H.SWIFT_ID),TRIM(A.SWIFT_ID))                    AS B030006          --SWIFT编码
            ,NVL(REGEXP_REPLACE(I.CERT_NUM,'[^0-9a-zA-Z]',''),M.UNIFIED_SOCIAL_CREDIT_CODE)
                                                                       AS B030007          --统一社会信用代码
            ,A.OPR_SCOPE                                               AS B030008          --经营范围
            ,COALESCE(TO_CHAR(TO_DATE(A.ESTM_DT,'YYYY-MM-DD'),'YYYY-MM-DD'),TO_CHAR(M.ESTABLISHED_DATE,'YYYY-MM-DD'),'9999-12-31')
                                                                       AS B030009          --成立日期
            ,SUBSTRB(TRIM(REPLACE(REPLACE(A.REGD_ADDR,CHR(10),''),CHR(13),'')),1,255)
                                                                       AS B030010          --注册地址
            ,CASE WHEN TRIM(A.REGD_LAND_CTRY_CD) IS NOT NULL AND TRIM(A.REGD_LAND_CTRY_CD)<>'XXX' THEN TRIM(A.REGD_LAND_CTRY_CD)
                  WHEN TRIM(A.REGD_LAND_CTRY_CD)='XXX' THEN 'CHN'
                  END                                                  AS B030011          --注册地国家地区
            ,CASE WHEN TRIM(A.REGD_LAND_CTRY_CD) NOT IN ('CHN','XXX') AND TRIM(A.REGD_LAND_CTRY_CD) IS NOT NULL THEN TRIM(A.REGD_LAND_CTRY_CD)
                  ELSE NVL(TRIM(A.REGD_LAND_AREA_CD),TRIM(M.DISTRICT_ENCODE))
                  END                                                  AS B030012          --注册地行政区划
            ,REMOVE_SPECIAL_CHARS(NVL(TRIM(F.REL_PSN_CUST_NM),TRIM(M.LEGAL_REPRESENTATIVE)))
                                                                       AS B030013          --法定代表人姓名
            ,F.REL_PSN_CRDL_TYP                                        AS B030014          --法定代表人证件类型
            ,REPLACE(REPLACE(F.REL_PSN_CRDL_NO,CHR(10),''),CHR(13),'') AS B030015_ORIG     --法定代表人证件号码(脱敏前)
            ,NULL                                                      AS B030015          --法定代表人证件号码
            ,CASE WHEN REGEXP_LIKE(TRIM(G.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                  ELSE REPLACE(REPLACE(G.REL_PSN_CUST_NM,CHR(10),''),CHR(13),'')
                  END                                                  AS B030016          --财务人员姓名
            ,CASE WHEN REGEXP_LIKE(TRIM(G.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                  ELSE G.REL_PSN_CRDL_TYP
                  END                                                  AS B030017          --财务人员证件类型
            ,CASE WHEN REGEXP_LIKE(TRIM(G.REL_PSN_CUST_NM),'^([\-]?[0-9])+$') THEN NULL
                  ELSE REPLACE(REPLACE(G.REL_PSN_CRDL_NO,CHR(10),''),CHR(13),'')
                  END                                                  AS B030018_ORIG     --财务人员证件号码(脱敏前)
            ,NULL                                                      AS B030018          --财务人员证件号码
            ,A.BSC_DEP_ACC                                             AS B030019          --基本存款账号
            --,A.BSC_ACC_OPEN_BANK_ID                                    AS B030020          --基本存款账户开户行行号
            ,N.BASIC_OPEN_BANK_NO                                      AS B030020          --基本存款账户开户行行号
            ,A.BSC_ACC_OPEN_BANK_NM                                    AS B030021          --基本存款账户开户行名称
            ,CASE WHEN A.REGD_CPTL > 0 THEN A.REGD_CPTL
                  END                                                  AS B030022          --注册资本
            ,CASE WHEN TRIM(A.REGD_CPTL_CUR) = 'CCC' THEN 'CNY'
                  WHEN TRIM(A.REGD_CPTL_CUR) IS NOT NULL THEN TRIM(A.REGD_CPTL_CUR)
                  WHEN TRIM(A.REGD_CPTL_CUR) IS NULL AND A.REGD_CPTL > 0 AND (A.BIO_FLG = 'Y' OR A.REGD_LAND_CTRY_CD IN ('CHN','XXX')) THEN 'CNY'
                  --WHEN A.REGD_CPTL_CUR IS NULL AND A.REGD_CPTL IS NOT NULL AND A.BIO_FLG = 'N' THEN                --根据注册国家判断注册资本币种的逻辑在明细层对公客户信息有体现，暂不在报送层做
                  END                                                  AS B030023          --注册资本币种
            ,CASE WHEN A.PAID_IN_CPTL > 0 THEN A.PAID_IN_CPTL
                  END                                                  AS B030024          --实收资本
            ,CASE WHEN TRIM(A.PAID_IN_CPTL_CUR) = 'CCC' THEN 'CNY'
                  WHEN TRIM(A.PAID_IN_CPTL_CUR) IS NOT NULL THEN TRIM(A.PAID_IN_CPTL_CUR)
                  WHEN TRIM(A.PAID_IN_CPTL_CUR) IS NULL AND A.PAID_IN_CPTL > 0 THEN 'CNY'
                  END                                                  AS B030025          --实收资本币种
            ,DECODE(A.IPO_CO_FLG,'Y','1','N','0')                      AS B030026          --上市企业标识
            ,CASE WHEN A.EMP_NUM > 0 THEN  A.EMP_NUM
             END                                                       AS B030027          --员工人数
            ,F.REL_PSN_CUST_NM                                         AS B030028          --负责人姓名
            ,A.TEL                                                     AS B030029          --机构联系电话
            ,L.RATING_LEVEL_CD                                         AS B030030          --外部评级结果
            ,L.RATING_ORG_NAME                                         AS B030031          --信用评级机构
            ,A.INR_RTG                                                 AS B030032          --内部评级结果
            ,CASE WHEN NVL(TO_CHAR(TO_DATE(A.ESTM_DT,'YYYY-MM-DD'),'YYYY-MM-DD'),TO_CHAR(M.ESTABLISHED_DATE,'YYYY-MM-DD'))>TO_CHAR(TO_DATE(E.FIRST_CRDT_DT,'YYYY-MM-DD'),'YYYY-MM-DD')
                    AND TO_CHAR(TO_DATE(E.FIRST_CRDT_DT,'YYYY-MM-DD'),'YYYY-MM-DD') IS NOT NULL
                  THEN NVL(TO_CHAR(TO_DATE(A.ESTM_DT,'YYYY-MM-DD'),'YYYY-MM-DD'),TO_CHAR(M.ESTABLISHED_DATE,'YYYY-MM-DD'))
                  ELSE NVL(TO_CHAR(TO_DATE(E.FIRST_CRDT_DT,'YYYY-MM-DD'),'YYYY-MM-DD'),'9999-12-31')
                  END                                                  AS B030033          --首次授信日期
            ,NULL                                                      AS B030034          --风险预警信号
            ,NULL                                                      AS B030035          --关注事件代码
            ,TO_CHAR(TO_DATE(A.DATA_DT,'YYYY-MM-DD'),'YYYY-MM-DD')     AS B030036          --采集日期
			,'TZYHB'			                                   	   AS DEPT_NO          --条线
            ,'000000'                                                  AS ISSUED_NO        --填报机构
            ,'000000'                                                  AS RPT_ORG_NO       --报送机构
            ,V_P_DATE                                                  AS DATA_DT          --数据日期
            ,A.CUST_MGR_ID                                             AS MGR_ID_CHECK     --管户经理ID
            ,A.ORG_ID                                                  AS ORG_ID_CHECK     --内部机构号
            ,JG.ORG_NM                                                 AS ORG_NM_CHECK     --内部机构对应名称
            ,CU.DATA_SRC                                               AS RELA_TB_CHECK    --相关联一表通表格编号


        FROM RRP_MDL.M_CUST_CORP_INFO A              --对公客户信息

        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO JG           --机构表取辅助字段内部机构
               ON A.ORG_ID = JG.ORG_ID
              --AND JG.OPR_STAT IN ('01','08') --只取正常营业状态
		      --AND JG.YBT_FLG ='Y'
              AND JG.DATA_DT = V_P_DATE

        LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_YBT B              --20251205统一取机构号
               ON B.ORG_ID = A.ORG_ID
              AND B.DATA_DT = V_P_DATE

       LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C --对公客户基本信息
              ON A.CUST_ID = C.CUST_ID
             AND C.ETL_DT = V_ETL_DATE

      LEFT JOIN
      (
      SELECT C.LP_ORG_CUST_ID,MAX(F.TAR_VALUE_CODE) AS TAR_VALUE_CODE
        FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO C
        LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO H --同业客户特有信息
               --ON H.PARTY_ID = NVL(C.LP_ORG_CUST_ID,C.CUST_ID)
               ON H.PARTY_ID = C.CUST_ID
              AND H.START_DT <= V_ETL_DATE
              AND H.END_DT > V_ETL_DATE
        LEFT JOIN RRP_MDL.CODE_MAP F
               ON C.HOLD_TYPE_CD = F.SRC_VALUE_CODE
              AND F.SRC_CLASS_CODE = 'CD1417' --经济成分代码
              AND F.TAR_CLASS_CODE = 'C0004'  --企业控股类型
              AND F.MOD_FLG = 'MDM'
        WHERE SUBSTR(H.FIN_INST_CATE_CD,1,1) <> '2'             --金融机构类型不为境外金融机构且法人机构类型为分支机构的，其控股类型应同对应法人机构的控股类型
          AND C.ETL_DT = V_ETL_DATE
          AND C.LP_ORG_TYPE_CD = '01'
          GROUP BY C.LP_ORG_CUST_ID
         )J
         ON C.LP_ORG_CUST_ID = J.LP_ORG_CUST_ID

      LEFT JOIN RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H D  --当事人证件信息历史
        ON D.PARTY_ID = A.CUST_ID
       AND D.START_DT <= V_ETL_DATE
       AND D.END_DT > V_ETL_DATE
       AND D.CERT_TYPE_CD  = '2020'                 --组织机构代码
       AND D.SORC_SYS_CD = 'EIFS'	                --源系统代码

        LEFT JOIN
            (
            SELECT I.PARTY_ID
                  ,I.CERT_TYPE_CD
                  ,I.CERT_NUM
                  ,I.START_DT
                  ,I.CERT_EFFECT_DT
                  ,ROW_NUMBER() OVER(PARTITION BY I.PARTY_ID ORDER BY
                  (CASE WHEN I.CERT_TYPE_CD = '2313' THEN '1'       --营业执照（统一社会信用代码）
                        WHEN I.CERT_TYPE_CD = '2314' THEN '2'       --登记证书
                        WHEN I.CERT_TYPE_CD = '2072' THEN '3'       --地税登记证（18位）
                        WHEN I.CERT_TYPE_CD = '2071' THEN '4'       --国税登记证（18位）
                        END)
                                    ) AS RN
              FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H I
             WHERE I.START_DT <= V_ETL_DATE
               AND I.END_DT > V_ETL_DATE
               AND I.SORC_SYS_CD = 'EIFS'
               AND (
                    (I.CERT_TYPE_CD = '2313' AND LENGTH(REGEXP_REPLACE(I.CERT_NUM,'[^0-9a-zA-Z]','')) <= 18)
                        OR
                    (I.CERT_TYPE_CD IN ('2314','2072','2071') AND LENGTH(REGEXP_REPLACE(I.CERT_NUM,'[^0-9a-zA-Z]','')) = 18)
                    )
            ) I
            ON I.PARTY_ID = A.CUST_ID
           AND I.RN = 1

        LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E        --授信额度主表
        ON A.CUST_ID=E.CUST_ID
        AND E.DATA_DT=V_P_DATE

        LEFT JOIN
			(
			SELECT
				 B2.CUST_ID
                ,B2.REL_TYP
                ,B2.REL_PSN_TYP
                ,CODE.TAR_VALUE_CODE AS REL_PSN_CRDL_TYP
                ,B2.REL_PSN_CRDL_NO
                ,B2.REL_PSN_CUST_NM
                ,B2.REL_PSN_CUST_ID
				,ROW_NUMBER() OVER(PARTITION BY B2.CUST_ID, B2.REL_TYP, B2.REL_PSN_TYP ORDER BY B2.REL_PSN_TYP,B2.DATA_SRC,B2.REL_PSN_CRDL_TYP NULLS LAST,B2.REL_PSN_CRDL_NO DESC NULLS LAST) AS NUM
			FROM RRP_MDL.M_CUST_CORP_REL_SUB B2         -- 对公客户关联人子表
                LEFT JOIN RRP_MDL.CODE_MAP CODE --码值映射表 机构类型
                       ON CODE.SRC_VALUE_CODE = B2.REL_PSN_CRDL_TYP
                      AND CODE.SRC_CLASS_CODE = 'CD1014' --证件类型
                      AND CODE.TAR_CLASS_CODE = 'CD1014' --证件类型
                      AND CODE.MOD_FLG = 'YBT'
			WHERE B2.REL_PSN_TYP = '01'                 --法定代表人
			AND B2.DATA_DT = V_P_DATE
			AND B2.DATA_SRC ='eifs'
			) F
		ON A.CUST_ID = F.CUST_ID
		AND F.NUM = 1

        LEFT JOIN
			(
			SELECT
				 G2.CUST_ID
                ,G2.REL_TYP
                ,G2.REL_PSN_TYP
                ,CODE.TAR_VALUE_CODE AS REL_PSN_CRDL_TYP
                ,G2.REL_PSN_CRDL_NO
                ,G2.REL_PSN_CUST_NM
                ,G2.REL_PSN_CUST_ID
				,ROW_NUMBER() OVER(PARTITION BY G2.CUST_ID
                ORDER BY G2.REL_PSN_TYP,G2.DATA_SRC,G2.REL_PSN_CRDL_TYP NULLS LAST,G2.REL_PSN_CRDL_NO DESC NULLS LAST
                ) AS NUM
			FROM RRP_MDL.M_CUST_CORP_REL_SUB G2         -- 对公客户关联人子表
                LEFT JOIN RRP_MDL.CODE_MAP CODE --码值映射表 机构类型
                       ON CODE.SRC_VALUE_CODE = G2.REL_PSN_CRDL_TYP
                      AND CODE.SRC_CLASS_CODE = 'CD1014' --证件类型
                      AND CODE.TAR_CLASS_CODE = 'CD1014' --证件类型
                      AND CODE.MOD_FLG = 'YBT'
			WHERE G2.REL_PSN_TYP = '05'                 --财务主管
			AND G2.DATA_DT = V_P_DATE
			AND G2.DATA_SRC ='eifs'
			)G
		ON A.CUST_ID = G.CUST_ID
		AND G.NUM = 1

        LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO H --同业客户特有信息
          ON H.PARTY_ID = NVL(A.LP_ORG_CUST_ID,A.CUST_ID)
         AND H.START_DT <= V_ETL_DATE
         AND H.END_DT > V_ETL_DATE

         LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_ATTACH_INFO N     --对公客户补充信息
         ON A.CUST_ID = N.CUST_ID
         AND N.ETL_DT = V_ETL_DATE

       LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值映射表 机构类型
       ON CODE1.SRC_VALUE_CODE = H.FIN_INST_CATE_CD
       AND CODE1.SRC_CLASS_CODE = 'JRJGLB' --金融机构类别
       AND CODE1.TAR_CLASS_CODE = 'JGLX' --机构类型
       AND CODE1.MOD_FLG = 'YBT'

       LEFT JOIN RRP_MDL.CODE_MAP CODE2
       ON CODE2.SRC_VALUE_CODE = TRIM(A.REGD_LAND_AREA_CD)
       AND CODE2.SRC_CLASS_CODE = 'XZQH'  --行政区划
       AND CODE2.MOD_FLG = 'YBT'

      LEFT JOIN (SELECT L.PARTY_ID
						,L.RATING_ORG_NAME
						,DECODE(L.RATING_LEVEL_CD,'AAA+','1','AAA','2','AAA-','3','AA+','4','AA','5','AA-','6','A+','7',
								'A','8','A-','9','BBB+','10','BBB','11','BBB-','12','BB','13','B','14','C','15','D','16',
								L.RATING_LEVEL_CD
								) AS RATING_LEVEL_CD
						,ROW_NUMBER()OVER(PARTITION BY PARTY_ID ORDER BY DECODE(L.RATING_LEVEL_CD,'AAA+','1','AAA','2',
								'AAA-','3','AA+','4','AA','5','AA-','6','A+','7','A','8','A-','9','BBB+','10','BBB','11',
								'BBB-','12','BB','13','B','14','C','15','D','16',L.RATING_LEVEL_CD)
								) RN
					FROM RRP_MDL.O_IML_PTY_PARTY_RATING_H L  --当事人评级信息
				   WHERE
					     L.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
					 AND L.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
					 AND L.ID_MARK <> 'D'
					 AND L.RATING_INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                     --L.SRC_TABLE_NAME IN('crss_customer_rate_result','nrrs_gs_yearratresult')
					 )L
		  ON L.PARTY_ID = A.CUST_ID
		 AND L.RN = 1

     LEFT JOIN RRP_MDL.O_IOL_UXDS_CORP_BASIC_INFO M                     --应业务要求取同花顺同业客户信息，该表只有一天数据
            --ON I.CERT_NUM = M.UNIFIED_SOCIAL_CREDIT_CODE
            ON A.CUST_NM = M.ORG_NAME_CN
            AND M.ETL_DT = V_ETL_DATE

     INNER JOIN RRP_YBT.CUSTOMER_FLAG_YBT CU                    --业务客户ID统计表
            ON A.CUST_ID = CU.CUST_ID
           AND CU.DATA_DT = V_P_DATE

        WHERE C.CUST_TYPE_CD = '3'       --同业客户
        --A.NATL_ECON_DEPT_CL LIKE 'B%'  --同业客户
        AND A.DATA_DT=V_P_DATE
       --AND A.OPR_STAT <> '02'  --停业
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

END ETL_SDIS_T_2_3;
/

