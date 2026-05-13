CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_FGB_CUST
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_FGB_CUST
  *  功能描述：对公客户的信息，包括企事业单位、政府、机关、部队、团体、国际组织、大使馆以及金融同业客户等等。
  *  创建日期：20221103
  *  开发人员：徐菲
  *  来源表： M_CUST_CORP_INFO A --对公客户信息
  *  目标表：A_FGB_CUST --客户基表_对公
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221103   xufei      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_FGB_CUST';
                                 -- 程序名称
  V_TAB_NAME   VARCHAR2(100) ;    --表名
  V_PART_NAME  VARCHAR2(100);     --分区名
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME   := 'A_FGB_CUST'; --表名,写目标表表名
  V_PART_NAME  := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT  := SQL%ROWCOUNT;
  V_SQLMSG    := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
 V_STEP_DESC := '分区处理';
 V_STARTTIME := SYSDATE;

 ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

 V_SQLCOUNT := SQL%ROWCOUNT;
 V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
 V_ENDTIME := SYSDATE;
 COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入主表';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_FGB_CUST
    (
        BGRQ                      --报告日期
       ,TJKHLB                    --统计客户类别
       ,HXKHH                     --核心客户号
       ,KHMC                      --客户名称
       ,ZJLX                      --证件类型
       ,ZJHM                      --证件号码
       ,TJDWLB                    --统计单位类别
       ,KHPJ                      --客户评级
       ,QYGM                      --企业规模
       ,DGKHATJFL                 --对公客户按统计分类
       ,QYCZRJJCFDL               --企业出资人经济成分大类
       ,QYCZRJJCFZL               --企业出资人经济成分中类
       ,QYCZRJJCFXL               --企业出资人经济成分小类
       ,DGKHSJJYDZ                --对公客户实际经营地址
       ,DGKHZCDZ                  --对公客户注册地址
       ,KHSZSJXZQ                 --客户所在省级行政区
       ,KHSZDJXZQ                 --客户所在地级行政区
       ,KHSZDXZQHDM               --客户所在地行政区划代码
       ,KHSZXJXZQ                 --客户所在县级行政区
       ,KHSFWYYTPDQ               --客户是否位于已脱贫地区
       ,KHSFWYCDBFX               --客户是否位于重点帮扶县
       ,KHSFWYXY                  --客户是否位于县域
       ,SFDFZFTRZPT               --是否地方政府投融资平台
       ,SFGTQY                    --是否关停企业
       ,SFKCQY                    --是否科创企业
       ,KJXQYFL                   --科技型企业分类
       ,SFLSXDKH                  --是否绿色信贷客户
       ,GMJJBMYJMC                --国民经济部门一级名称
       ,GMJJBMYJDM                --国民经济部门一级代码
       ,GMJJBMEJMC                --国民经济部门二级名称
       ,GMJJBMEJDM                --国民经济部门二级代码
       ,SSGMJJXYMLMC              --所属国民经济行业门类名称
       ,SSGMJJXYMLDM              --所属国民经济行业门类代码
       ,SSGMJJXYDLMC              --所属国民经济行业大类名称
       ,SSGMJJXYDLDM              --所属国民经济行业大类代码
       ,SSGMJJXYZLMC              --所属国民经济行业中类名称
       ,SSGMJJXYZLDM              --所属国民经济行业中类代码
       ,SSGMJJXYXLMC              --所属国民经济行业小类名称
       ,SSGMJJXYXLDM              --所属国民经济行业小类代码
       ,BXCDYJMFYLB               --本行承担与减免费用类別
       ,BNLJCDHJMDXDXGFYJE        --本年累计承担或减免的信贷相关费用金额（元）
       -- 新增字段 授信基表字段加到客户基表
       ,SXZED                     --授信总额度（元）
       ,YXYE                      --用信余额（元）
       ,CNLB                      --承诺类别
       ,CNYE                      --承诺余额（元）
    )
    SELECT
        A.DATA_DT                                                     AS BGRQ    --报告日期
       ,CASE WHEN A.TYBZ = 'Y' THEN '同业客户' --同业客户
             WHEN A.CUST_ID IS NOT NULL THEN
                '对公客户' --对公客户
             END                                                      AS TJKHLB  --统计客户类别
       ,A.CUST_ID                                                     AS HXKHH   --核心客户号
       ,A.CUST_NM                                                     AS KHMC    --客户名称
       ,M3.SRC_VALUE_NAME                                             AS ZJLX    --证件类型
       ,A.CRDL_NO                                                     AS ZJHM    --证件号码
       ,CASE WHEN A.CRDL_NO LIKE '91%' THEN '企业法人'  --企业法人
             WHEN A.CRDL_NO LIKE '52%' THEN '事业单位法人'  --事业单位法人
             WHEN A.CRDL_NO LIKE '11%' THEN '机关法人'  --机关法人
             WHEN A.CRDL_NO LIKE '51%' THEN '社会团体和其他成员组织法人'  --社会团体和其他成员组织法人
             WHEN SUBSTR(A.CRDL_NO,1,2) NOT IN ('91','93','51','52','11') THEN '其他法人'  --其他法人
             ELSE '其他个人'  --其他个人
        END                                                            AS TJDWLB   --统计单位类别
       ,M11.SRC_VALUE_NAME                                             AS KHPJ    --客户评级
        --按照非金融企业债券要求取外部评级，数据治理中
       /*CASE WHEN A.CBRC_CUST_CL IN ('企业','农村集体经济组织（企业）','农民专业合作社（企业）' ) THEN
             DECODE(A.ENT_SCALE,'L','大型企业','M','中型企业','S','小型企业','X','微型企业','其他法人客户')
             ELSE '其他法人客户'
        END */ -- 客户基表中企业规模直接取数
       ,DECODE(A.ENT_SCALE,'L','大型企业','M','中型企业','S','小型企业','X','微型企业','其他法人客户')
                                                                       AS QYGM    --企业规模
       ,A.CBRC_CUST_CL                                                 AS DGKHATJFL   --对公客户按统计分类  --系统取值不准，补录
       ,CASE WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('A','B') THEN '公用控股经济'  --公用控股经济
             ELSE '非公用控股经济'  --非公用控股经济
        END                                                            AS QYCZRJJCFDL  --企业出资人经济成分大类
       ,CASE WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('A') THEN '国有控股'  --国有控股
             WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('B') THEN '集体控股'  --集体控股
             WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('C') THEN '私人控股'  --私人控股
             WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('D') THEN '港澳台商控股'  --港澳台商控股
             WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('E') THEN '外商控股'  --外商控股
             WHEN SUBSTR(A.ENT_HLDG_TYP,1,1) IN ('X') THEN '其他'  --其他
             ELSE '不适用'  --不适用
        END                                                             AS QYCZRJJCFZL   --企业出资人经济成分中类
       ,M4.SRC_VALUE_NAME                                               AS QYCZRJJCFXL   --企业出资人经济成分小类
       ,D.WORK_ADDR                                                     AS DGKHSJJYDZ    --对公客户实际经营地址
       ,A.REGD_ADDR                                                     AS DGKHZCDZ      --对公客户注册地址
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.REGD_LAND_AREA_CD),1,2))=2
             THEN SUBSTR(TRIM(A.REGD_LAND_AREA_CD),1,2)||'0000'
        END                                                             AS KHSZSJXZQ     --客户所在省级行政区
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.REGD_LAND_AREA_CD),1,4))=4
             THEN SUBSTR(A.REGD_LAND_AREA_CD,1,4)||'00'
        END                                                             AS KHSZDJXZQ      --客户所在地级行政区
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.REGD_LAND_AREA_CD),1,4))=4
             THEN SUBSTR(A.REGD_LAND_AREA_CD,1,4)||'00'
        END                                                             AS KHSZDXZQHDM    --客户所在地行政区划代码
       ,TRIM(A.REGD_LAND_AREA_CD)                                       AS KHSZXJXZQ      --客户所在县级行政区
       ,'否'                                                            AS KHSFWYYTPDQ    --客户是否位于已脱贫地区
       ,'否'                                                            AS KHSFWYCDBFX    --客户是否位于重点帮扶县
       ,DECODE(C.CNTY_DMN,'Y','是','否')                                AS KHSFWYXY       --客户是否位于县域
       ,''                                                              AS SFDFZFTRZPT    --是否地方政府投融资平台  --补录
       ,NVL(DECODE(M9.SFGTQY,'Y','是','N','否',M9.SFGTQY),DECODE(A.ENT_CLOSE_FLG,'Y','是','否'))
                                                                        AS SFGTQY         --是否关停企业  -- 系统取值不准，补录
       ,DECODE(A.TECH_INNO_ENT_FLG,'Y','是','否')                       AS SFKCQY         --是否科创企业  --系统取值不准，补录
       --张唯新口径 以最新ECIF为准
       ,CASE WHEN A.TECH_INNO_ENT_FLG = 'Y' THEN '科创企业'
             WHEN A.TECH_ENT_FLG = 'Y' THEN '非科创企业'
             ELSE '不适用'
        END                                                             AS KJXQYFL        --科技型企业分类
       --张唯新口径 以最新ECIF为准
       ,DECODE(A.GRN_LOAN_IDY_CL,'是','否')                             AS SFLSXDKH       --是否绿色信贷客户
       ,M2.SRC_VALUE_NAME                                               AS GMJJBMYJMC     --国民经济部门一级名称
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.NATL_ECON_DEPT_CL),1,1))=1 THEN SUBSTR(TRIM(A.NATL_ECON_DEPT_CL),1,1)||'00' END
                                                                        AS GMJJBMYJDM     --国民经济部门一级代码
       ,M1.SRC_VALUE_NAME                                               AS GMJJBMEJMC     --国民经济部门二级名称
       ,TRIM(A.NATL_ECON_DEPT_CL)                                       AS GMJJBMEJDM     --国民经济部门二级代码
       ,M8.SRC_VALUE_NAME                                               AS SSGMJJXYMLMC   --所属国民经济行业门类名称
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.CUST_BLNG_IDY),1,1))=1 THEN SUBSTR(TRIM(A.CUST_BLNG_IDY),1,1) END
                                                                        AS SSGMJJXYMLDM   --所属国民经济行业门类代码
       ,M7.SRC_VALUE_NAME                                               AS SSGMJJXYDLMC   --所属国民经济行业大类名称
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.CUST_BLNG_IDY),1,3))=3 THEN SUBSTR(TRIM(A.CUST_BLNG_IDY),1,3) END
                                                                        AS SSGMJJXYDLDM    --所属国民经济行业大类代码
       ,M6.SRC_VALUE_NAME                                               AS SSGMJJXYZLMC    --所属国民经济行业中类名称
       ,CASE WHEN LENGTH(SUBSTR(TRIM(A.CUST_BLNG_IDY),1,4))=4 THEN SUBSTR(TRIM(A.CUST_BLNG_IDY),1,4) END
                                                                        AS SSGMJJXYZLDM    --所属国民经济行业中类代码
       ,M5.SRC_VALUE_NAME                                               AS SSGMJJXYXLMC    --所属国民经济行业小类名称
       ,TRIM(A.CUST_BLNG_IDY)                                           AS SSGMJJXYXLDM    --所属国民经济行业小类代码
       ,/*A.BEAR_OR_RED_AMT*/
        DECODE(M9.BXCDJMFYLB,'01','抵押登记费'--抵押登记费(承担)
        										,'02','押品评估费'--押品评估费(承担)
        										,'03','其他信贷相关承担费用'--其他信贷相关承担费用(承担)
        										,'04','客户承担'--客户承担(承担)
        										,'05','咨询费'--咨询费(减免)
        										,'06','财务顾问费'--财务顾问费(减免)
        									  ,'07','其他信贷相关减免费用'--其他信贷相关减免费用(减免)
        										,'08','其他表外费用减免'--其他表外费用减免(减免)
		        								,'不适用')                                  AS BXCDYJMFYLB     --本行承担与减免费用类別
       ,M9.BNLJCDHJMDXDXGFYJE                                           AS BNLJCDHJMDXDXGFYJE  --本年累计承担或减免的信贷相关费用金额（元） --补录
       ,NVL(L.CRDT_TOTAL_LMT,0)                                         AS SXZED               --授信总额度（元）
       ,NVL(M10.YYED,0)                                                 AS YXYE                --用信余额（元）
       ,'可随时无条件撤销的贷款承诺'                                    AS CNLB                --承诺类别
       ,NVL(M10.CNYE,0)                                                 AS CNYE                --承诺余额（元）
   FROM RRP_MDL.M_CUST_CORP_INFO A --对公客户信息
  INNER JOIN (SELECT DISTINCT CUST_ID
                FROM RRP_MDL.S_LOAN T1 -- 贷款业务整合表
               WHERE T1.DATA_DT = V_P_DATE
                 AND T1.DATA_SRC NOT IN ('零售贷款', '联合网贷', '非标其他债券')
               UNION
              SELECT DISTINCT CUST_ID
                FROM RRP_MDL.S_OUT_DUBILL T2 --表外业务整合表
               WHERE T2.DATA_DT = V_P_DATE
               UNION
              SELECT DISTINCT T3.CUST_ID
                FROM RRP_MDL.M_CRDT_LMT_INFO T3  -- 由于客户基表合并授信基表，取全部有效的授信并入客户基表
               INNER JOIN RRP_MDL.M_CUST_CORP_INFO D
                  ON T3.CUST_ID = D.CUST_ID
                 AND D.DATA_DT = V_P_DATE
               WHERE T3.DATA_DT = V_P_DATE
                 AND T3.CRDT_STAT = 'Y' ) B
     ON B.CUST_ID = A.CUST_ID
    AND B.CUST_ID IS NOT NULL
   LEFT JOIN CONFIG_AREA     C --中国行政区划2020
     ON C.NEW_AREA_CD = A.REGD_LAND_AREA_CD
   LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO D --对公客户基本信息
     ON D.CUST_ID = A.CUST_ID
    AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO L --授信汇总
     ON L.CUST_ID = A.CUST_ID
    AND L.DATA_DT = V_P_DATE
   LEFT JOIN RRP_MDL.CODE_MAP M1 --码值映射表
     ON M1.SRC_VALUE_CODE = A.NATL_ECON_DEPT_CL
    AND M1.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
    AND M1.TAR_CLASS_CODE = 'C0003' --对公客户分类
    AND M1.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP M2 --码值映射表
     ON SUBSTR(TRIM(A.NATL_ECON_DEPT_CL), 1, 1) || '00' = M2.SRC_VALUE_CODE
    AND M2.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
    AND M2.TAR_CLASS_CODE = 'C0003' --对公客户分类
    AND M2.MOD_FLG = 'MDM'
   LEFT JOIN RRP_MDL.CODE_MAP M3 --码值映射表
     ON M3.SRC_VALUE_CODE = A.CRDL_TYP
    AND M3.SRC_CLASS_CODE = 'C0001' --证件类型
    AND M3.TAR_CLASS_CODE = 'C0001' --证件类型
    AND M3.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.CODE_MAP M4 --码值映射表
     ON M4.SRC_VALUE_CODE = A.ENT_HLDG_TYP
    AND M4.SRC_CLASS_CODE = 'C0004' --经济成分代码
    AND M4.TAR_CLASS_CODE = 'C0004' --经济成分代码
    AND M4.MOD_FLG = 'BFD'
   LEFT JOIN RRP_MDL.CODE_MAP M5 --码值映射表
     ON M5.SRC_VALUE_CODE = A.CUST_BLNG_IDY
    AND M5.SRC_CLASS_CODE = 'P0003' --行业类别 小类
    AND M5.TAR_CLASS_CODE = 'P0003' --行业类别
    AND M5.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.CODE_MAP M6 --码值映射表
     ON SUBSTR(TRIM(A.CUST_BLNG_IDY), 1, 4) = M6.SRC_VALUE_CODE
    AND M6.SRC_CLASS_CODE = 'P0003' --行业类别 中类
    AND M6.TAR_CLASS_CODE = 'P0003' --行业类别
    AND M6.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.CODE_MAP M7 --码值映射表
     ON M7.SRC_VALUE_CODE =  SUBSTR(TRIM(A.CUST_BLNG_IDY), 1, 3)
    AND M7.SRC_CLASS_CODE = 'P0003' --行业类别 大类
    AND M7.TAR_CLASS_CODE = 'P0003' --行业类别
    AND M7.MOD_FLG = 'EAST'
   LEFT JOIN RRP_MDL.CODE_MAP M8 --码值映射表
     ON M8.SRC_VALUE_CODE = SUBSTR(TRIM(A.CUST_BLNG_IDY), 1, 1)
    AND M8.SRC_CLASS_CODE = 'P0003' --行业类别 门类
    AND M8.TAR_CLASS_CODE = 'P0003' --行业类别
    AND M8.MOD_FLG = 'EAST'
   LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY KHWYM ORDER BY KHWYM ) AS RN
                FROM RRP_MDL.M_ADD_DG_001_CUST T
               WHERE T.DATA_DATE = V_P_DATE ) M9 --补录表-对公-客户基表
     ON M9.KHWYM = A.CUST_ID
    AND M9.RN = 1 -- 应急去重
    AND M9.DATA_DATE = V_P_DATE
   LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER(PARTITION BY KHWYM ORDER BY KHWYM ) AS RN
                FROM RRP_MDL.M_ADD_DG_002_CREDIT T
               WHERE T.DATA_DATE = V_P_DATE ) M10 --补录表-对公-授信基表
     ON M10.KHWYM = A.CUST_ID
    AND M10.RN = 1 -- 应急去重
    AND M10.DATA_DATE = V_P_DATE
   LEFT JOIN RRP_MDL.CODE_MAP M11
     ON M11.SRC_VALUE_CODE = A.EXT_RTG
    AND M11.SRC_CLASS_CODE = 'CD1850'  --内部评级结果代码
    AND M11.TAR_CLASS_CODE = 'D0062'   --评级代码
    AND M11.MOD_FLG = 'MDM'
  WHERE A.DATA_DT = V_P_DATE;
  COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


   V_STEP := V_STEP + 1;
   V_STEP_DESC := 'A_FGB_CUST是否重复'; --22
   WITH TMP1 AS (
    SELECT BGRQ,HXKHH,COUNT(1) AS CT
      FROM A_FGB_CUST A
     WHERE BGRQ = V_P_DATE
     GROUP BY BGRQ, HXKHH
    HAVING COUNT(1) > 1)

  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
     V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_A_FGB_CUST;
/

