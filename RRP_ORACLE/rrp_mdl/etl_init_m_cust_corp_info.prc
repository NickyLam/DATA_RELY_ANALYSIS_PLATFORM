CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_CUST_CORP_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_CUST_CORP_INFO
  *  功能描述：监管集市对公客户，包括所有的对公客户基本信息
  *  创建日期：20220608
  *  开发人员：hulijuan
  *  来源表：  IML.PTY_PARTY_CERT_INFO_H      --当事人证件信息历史
  *            ICL.CMM_CORP_CUST_BASIC_INFO   --对公客户基本信息
  *            IOL.CRSS_ALERT_DATA            --警示数据
  *            IOL.CRSS_ALARMSIGN_INFO        --预警详情
  *            IOL.CRSS_FLOW_OBJECT           --流程对象表
  *            IOL.CRSS_ALERT_WASTEBOOK       --预警信息表
  *            IML.PTY_PARTY_RATING_H         --客户评级表  暂未接入
  *            ICL.CMM_DEP_CUST_ACCT_INFO     --存款主账户信息
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO   --对公贷款借据信息
  *  目标表：  M_CUST_CORP_INFO --对公客户信息
  *
  *  配置表：  CODE_MAP --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   首次创建
  *             2    20220901  MW     增加码值表模块判定
  *             3    20221011  hulj   调整电话号码,证件号码取值，增加临时表逻辑
  *             4    20221028  hulj   修改基本账户开户行名称、基本账户开户行编号 取数逻辑
  *             5    20221101  hulj   修改成立日期,客户所属行业 取数逻辑
  *             6    20221102  xucx   增加字段FIN_ORG_TYP_DIIS取数仓的金融机构类型代码
  *             7    20221103  xucx   增加字段CRDL_TYP_DIIS取数仓的证件类型代码
  *             8    20221111  xucx   增加字段LP_ORG_CUST_ID取法人机构客户编号
  *             9    20221122  hulj   新增客户主办客户经理客户号、客户主办柜员号、客户主办客户经理名称、客户主办客户经理所属机构
  *                                   农村集体经济组织标志、农民专业合作社标志
  *             10   20221130  mw     增加PBOC客户分类及CBRC客户分类
  *             11   20230130  hulj   修改集团成员客户标志取数逻辑
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_CUST_CORP_INFO'; -- 程序名称
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_PART_NAME  VARCHAR2(50);  --表分区名字
  V_TAB_NAME   VARCHAR2(50); -- 表名
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_CUST_CORP_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  ----将参数转化为日期格式，判读输入参数是否符合日期要求
 /*V_DATE    := TO_DATE(SUBSTR(I_P_DATE, 1, 4) || '-' ||
                       SUBSTR(I_P_DATE, 5, 2) || '-' ||
                       SUBSTR(I_P_DATE, 7, 2),
                       'YYYY-MM-DD');*/
    /* 清数，支持重跑 */
  --V_TAB_NAME   := 'M_CUST_IND_INFO';
  --V_PART_NAME :=  'PARTITION_'||V_P_DATE ;
  V_STEP := 1;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  /*判断传入日期参数是否正确*/
  /*IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(I_P_DATE, 'yyyymmdd');
  END IF; */
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

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := ' 插入对公客户信息表--对公客户证件信息临时表初始化 ';

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_CORP_CRDL_INFO';

  INSERT  INTO TMP_CORP_CRDL_INFO
  (
    CUST_ID,          --客户号
    CUST_NM,          --客户名称
    CERT_TYPE_CD,     --数仓证件类型
    EDW_VALUE_NAME,   --数仓证件类型名称
    CRDL_TYP,         --监管证件类型
    RRP_VALUE_NAME,   --监管证件类型名称
    CRDL_NO,          --证件号
    CRDL_EFF_DT,      --证件生效日期
    CRDL_EXP_DT,      --证件失效日期
    CRDL_UPD_DT       --证件更新日期
  )
  SELECT T.CUST_ID
        ,T.CUST_NM
        ,T.CERT_TYPE_CD
        ,T.EDW_VALUE_NAME
        ,T.CRDL_TYP
        ,T.RRP_VALUE_NAME
        ,T.CRDL_NO
        ,T.CRDL_EFF_DT
        ,T.CRDL_EXP_DT
        ,T.CRDL_UPD_DT
  FROM (
    SELECT B.CUST_ID                             AS CUST_ID        --客户号
            ,B.CUST_NAME                           AS CUST_NM        --客户名称
            ,A.CERT_TYPE_CD                        AS CERT_TYPE_CD   --数仓证件类型
            ,C.SRC_VALUE_NAME                      AS EDW_VALUE_NAME --数仓证件类型名称
            ,CASE WHEN (A.CERT_TYPE_CD = '2313' AND LENGTH(A.CERT_NUM)=18 ) --营业执照（统一社会信用代码）
                        OR (A.CERT_TYPE_CD = '2314' AND LENGTH(A.CERT_NUM)=18 ) --20220906 XUXIAOBIN ADD  2314登记证书（18位）
                        OR (A.CERT_TYPE_CD = '2072' AND LENGTH(A.CERT_NUM)=18 ) --地税登记证（18位）
                        OR (A.CERT_TYPE_CD = '2071' AND LENGTH(A.CERT_NUM)=18 ) --国税登记证（18位）
                  THEN '236'--以上归类于社会统一信用代码
                  ELSE C.SRC_VALUE_CODE
              END                                  AS CRDL_TYP       --监管证件类型
            ,CASE WHEN (A.CERT_TYPE_CD = '2313' AND LENGTH(A.CERT_NUM)=18 ) --营业执照（统一社会信用代码）
                        OR (A.CERT_TYPE_CD = '2314' AND LENGTH(A.CERT_NUM)=18 ) --20220906 XUXIAOBIN ADD  2314登记证书（18位）
                        OR (A.CERT_TYPE_CD = '2072' AND LENGTH(A.CERT_NUM)=18 ) --地税登记证（18位）
                        OR (A.CERT_TYPE_CD = '2071' AND LENGTH(A.CERT_NUM)=18 ) --国税登记证（18位）
                  THEN '统一社会信用代码'--以上归类于社会统一信用代码
                  ELSE C.SRC_VALUE_NAME
              END                                  AS RRP_VALUE_NAME --监管证件类型名称
            ,A.CERT_NUM                            AS CRDL_NO        --证件号
            ,TO_CHAR(A.CERT_EFFECT_DT,'YYYYMMDD')  AS CRDL_EFF_DT    --证件生效日期
            ,TO_CHAR(A.CERT_INVALID_DT,'YYYYMMDD') AS CRDL_EXP_DT    --证件失效日期
            ,TO_CHAR(A.START_DT,'YYYYMMDD')        AS CRDL_UPD_DT    --证件更新日期
            ,ROW_NUMBER() OVER(PARTITION BY A.PARTY_ID
                                   ORDER BY CASE WHEN A.SORC_SYS_CD = 'EIFS'
                                   OR ( LENGTHB(A.CERT_NUM)=18 AND A.CERT_STATUS_CD = '1')
                                    THEN 'A' ELSE A.SORC_SYS_CD END,
                                   (CASE WHEN A.CERT_TYPE_CD = '2313' AND LENGTHB(A.CERT_NUM)=18 THEN 1 --营业执照（统一社会信用代码）
                                                  WHEN A.CERT_TYPE_CD = '2314' AND LENGTHB(A.CERT_NUM)=18 THEN 2 --20220906 XUXIAOBIN ADD  2314登记证书（18位）
                                                  WHEN A.CERT_TYPE_CD = '2072' AND LENGTHB(A.CERT_NUM)=18 THEN 3 --地税登记证（18位）
                                                  WHEN A.CERT_TYPE_CD = '2071' AND LENGTHB(A.CERT_NUM)=18 THEN 4 --国税登记证（18位）
                                                  WHEN A.CERT_TYPE_CD = '2020' THEN 4
                                                  WHEN A.CERT_TYPE_CD = '2314' AND LENGTHB(A.CERT_NUM)<>18 THEN 5 --20220906 XUXIAOBIN ADD  2314登记证书（非18位）
                                                  WHEN A.CERT_TYPE_CD = '2072' AND LENGTHB(A.CERT_NUM)<>18 THEN 6 --地税登记证（非18位）
                                                  WHEN A.CERT_TYPE_CD = '2071' AND LENGTHB(A.CERT_NUM)<>18 THEN 7 --国税登记证（非18位）
                                                  WHEN A.CERT_TYPE_CD = '2090' THEN 8
                                                  WHEN A.CERT_TYPE_CD = '2999' THEN 9
                                             END) ASC,A.CERT_INVALID_DT DESC) NUM
        FROM RRP_MDL.O_IML_PTY_PARTY_CERT_INFO_H A --当事人证件信息历史
       INNER JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO B --对公客户基本信息
               ON A.PARTY_ID = B.CUST_ID
              AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN CODE_MAP C
            ON C.SRC_VALUE_CODE = A.CERT_TYPE_CD
            AND C.SRC_CLASS_CODE = 'CD1014'
            AND C.TAR_VALUE_CODE = 'C0001'
            AND C.MOD_FLG = 'MDM'

       WHERE TRIM(A.CERT_NUM) IS NOT NULL
         --AND A.CERT_NUM <> '******'
         AND REPLACE(A.CERT_NUM,'*','') IS NOT NULL
         AND REPLACE(A.CERT_NUM,'0','') IS NOT NULL
         AND TRIM(A.CERT_NUM) IS NOT NULL
         AND TRIM(A.CERT_NUM) <> '/'
         --AND LENGTH(REGEXP_REPLACE(A.CERT_NUM,'[^a-zA-Z0-9]+','')) > 5
         AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) T
  WHERE T.NUM = 1
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入对公客户信息表--对公客户逻辑处理';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_CUST_CORP_INFO
  (
    DATA_DT,                    --数据日期
    LGL_REP_ID,                 --法人编号
    CUST_ID,                    --客户编号
    ORG_ID,                     --机构编号
    CUST_NM,                    --客户名称
    CUST_ENG_NM,                --客户英文名称
    CRDL_TYP,                   --证件类型
    CRDL_NO,                    --证件号码
    CRDL_EFF_DT,                --证件生效日期
    CRDL_EXP_DT,                --证件失效日期
    CRDL_UPD_DT,                --证件更新日期
    CUST_CL,                    --客户分类
    CUST_TYP_RSK,               --客户类型（客户风险）
    NATL_ECON_DEPT_CL,          --国民经济部门分类
    GOV_AFF_INS_FLG,            --事业单位标志
    FIN_ORG_TYP,                --金融机构类型
    FIN_PERMIT_NO,              --金融许可证号
    PBC_NO,                     --人行支付行号
    FIN_ORG_ID,                 --金融机构编号
    ENT_SCALE,                  --企业规模
    ENT_HLDG_TYP,               --企业控股类型
    RSDNT_FLG,                  --居民标志
    REGD_LAND_CTRY_CD,          --注册地国家代码
    REGD_LAND_AREA_CD,          --注册地行政区划代码
    REGD_ADDR,                  --注册地址
    REGD_INFO_UPD_DT,           --注册信息更新日期
    OPR_LAND_CTRY_CD,           --经营地国家代码
    OPR_LAND_AREA_CD,           --经营地行政区划代码
    OPR_ADDR,                   --经营地址
    UPD_WRK_ADDR_DT,            --更新办公地址日期
    CUST_BLNG_IDY,              --客户所属行业
    GRN_LOAN_IDY_CL,            --绿色贷款有关行业分类
    MJR_ENV_SAFE_RSK_ENT_CL,    --重大环境安全风险企业分类
    OPEN_EBANK_FLG,             --开通网银标志
    ENT_CLOSE_FLG,              --企业关停标志
    ENT_GUA_SML_MICRO_ENT_FLG,  --创业担保小微企业标志
    FIT_SML_MICRO_ENT_FLG,      --符合条件的小微企业标志
    CN_CPTL_FLG,                --中资标志
    VIL_CITY_FLG,               --农村城市标志
    FAMILY_FARM_FLG,            --家庭农场标志
    ENT_GROW_UP_STAGE,          --企业成长阶段
    SPV_SUM_CL,                 --SPV细类
    MICROFIN_CO_FLG,            --小额贷款公司标志
    TECH_MID_SML_ENT_FLG,       --科技型中小企业标志
    HIGH_TECH_ENT_FLG,          --高新技术企业标志
    TECH_ENT_FLG,               --科技型企业标志
    TECH_INNO_ENT_FLG,          --科创企业标志
    IPO_CO_FLG,                 --上市公司标志
    BIG_RSK_EXP_CUST_FLG,       --大额风险暴露豁免客户标志
    REL_PTY_FLG,                --关联方标志
    GRP_MBR_CUST_FLG,           --集团成员客户标志
    OPR_SCOPE,                  --经营范围
    ESTM_DT,                    --成立日期
    TEL,                        --联系电话
    REGD_CPTL,                  --注册资本
    REGD_CPTL_CUR,              --注册资本币种
    PAID_IN_CPTL,               --实收资本
    PAID_IN_CPTL_CUR,           --实收资本币种
    BSC_DEP_ACC,                --基本存款账号
    BSC_ACC_OPEN_BANK_NM,       --基本账户开户行名称
    BSC_ACC_OPEN_BANK_ID,       --基本账户开户行编号
    EMP_NUM,                    --员工人数
    RSK_WARN_SGNL,              --风险预警信号
    RSK_WARN_SGNL_DESC,         --风险预警信号描述
    FOC_EVT,                    --关注事件
    PD,                         --违约概率
    INR_RTG,                    --内部评级
    EXT_RTG,                    --外部评级
    CUST_CR_RTG_TOT_GRD,        --客户信用评级总等级数
    CUST_CRDT_RTG,              --客户信用评级
    FIRST_ESTBL_CRDT_REL_DT,    --首次建立信贷关系日期
    LOAN_CERT_NO,               --贷款证号
    OPR_STAT,                   --经营状态
    OPR_STAT_END_DT,            --营业状态结束日期
    CUST_STAT,                  --客户状态
    PRCN_LG_CUST_FLG,           --专精特新小巨人客户标志
    PRCN_CUST_FLG,              --专精特新客户标志
    DEPT_LINE,                  --部门条线
    DATA_SRC,                   --数据来源
    BIO_FLG,                    --境内外标志
    LCL_FIN_PLTF_HIER_TYP,      --地方融资平台层级类型
    BEAR_OR_RED_AMT,            --承担或减免的信贷费用金额
    /*20220425 ADD BY LIP 借据是否科技型需要该字段限制放款日期小于认定日期的*/
    TECH_ENT_IDTFY_DT,          --科技型企业认定日期
    ANL_INCO,                   --企业年收入
    FIN_INST_CODE,              --金融机构编码
    TYBZ,                       --同业标志
    FIN_ORG_TYP_DIIS,           --金融机构类别代码CD1389' add by 20221102 xucx
    CRDL_TYP_DIIS,              --证件类型(存款保险专用)  add by 20221103 xucx
    LP_ORG_CUST_ID,             --法人机构客户编号 add by 20221111 xucx
    LP_ORG_TYPE_CD,             --法人机构类型代码
    CUST_MGR_ID,                --客户主办客户经理客户号 add by hulj 20221123
    CUST_TELLER_ID,             --客户主办柜员号 add by hulj 20221123
    CUST_MGR_NAME,              --客户主办客户经理名称 add by hulj 20221123
    CUST_MGR_BELONG_ORG_ID,     --客户主办客户经理所属机构 add by hulj 20221123
    VIL_COLLTV_ECON_ORG_FLG,    --农村集体经济组织标志 add by hulj 20221123
    FARMER_PROF_COOP_FLG,       --农民专业合作社标志 add by hulj 20221123
    BUS_LICS_NUM,               --营业执照号
    BUS_LICS_RGST_DT,           --营业执照到期日期
    PBOC_CUST_CL,               --PBOC客户分类
    CBRC_CUST_CL,               --CBRC客户分类
    OPEN_ACCT_ORG_ID,           --开户机构号
    C_CUST_TYPE,                --客户类型-银监
    ORGNZ_CD --组织机构代码
  )
      WITH CORP_CUST_RELA_PS_INFO AS
      (SELECT /*+MATERIALIZE*/
              A.CUST_ID,COALESCE(TRIM(A.RELA_PS_WORK_UNIT_TEL_NUM),TRIM(A.RELA_PS_MOBILE_NO),TRIM(A.RELA_PS_TEL_NUM)) DH, --去法定代表人联系方式
              ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY COALESCE(TRIM(A.RELA_PS_WORK_UNIT_TEL_NUM),TRIM(A.RELA_PS_MOBILE_NO),TRIM(A.RELA_PS_TEL_NUM)) DESC) RN
         FROM RRP_MDL.O_ICL_CMM_CORP_CUST_RELA_PS_INFO A
        WHERE A.RELA_TYPE_CD IN ('30101','30105')
          AND COALESCE(A.RELA_PS_WORK_UNIT_TEL_NUM,A.RELA_PS_MOBILE_NO,A.RELA_PS_TEL_NUM) IS NOT NULL),
       BANK_NO_NAME_ALL AS --取机构和人行行号的映射
      (SELECT T.SYS_PRTCPTR_BIGAMT_BANK_NO, T.SYS_PRTCPTR_BIGAMT_BANK_NAME
         FROM RRP_MDL.O_IML_PTY_CPES_MEM T
        WHERE TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
          AND TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL
        UNION ALL
       SELECT T.SYS_PRTCPTR_BIGAMT_BANK_NO, T.ORG_CN_ABBR
         FROM RRP_MDL.O_IML_PTY_CPES_MEM T
        WHERE TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
          AND TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL
        UNION ALL
       SELECT T.SYS_PRTCPTR_BIGAMT_BANK_NO, T.ORG_CN_FNAME
         FROM RRP_MDL.O_IML_PTY_CPES_MEM T
        WHERE TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
          AND TRIM(T.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL
        UNION ALL
       SELECT TRIM(PBC_PAY_BANK_NO) PBC_PAY_BANK_NO, CUST_NAME
         FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
        WHERE TRIM(PBC_PAY_BANK_NO) IS NOT NULL
          AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
      BANK_NO_NAME AS  --对机构去重
      (SELECT MAX(SYS_PRTCPTR_BIGAMT_BANK_NO) SYS_PRTCPTR_BIGAMT_BANK_NO,SYS_PRTCPTR_BIGAMT_BANK_NAME
         FROM BANK_NO_NAME_ALL
        GROUP BY SYS_PRTCPTR_BIGAMT_BANK_NAME)
    SELECT DISTINCT
       TO_CHAR(A.ETL_DT,'YYYYMMDD')                             AS DATA_DT                    --数据日期
      ,A.LP_ID                                                  AS LGL_REP_ID                 --法人编号
      ,A.CUST_ID                                                AS CUST_ID                    --客户编号
      ,A.BELONG_ORG_ID                                          AS ORG_ID                     --机构编号
      ,A.CUST_NAME                                              AS CUST_NM                    --客户名称
      ,A.CUST_EN_NAME                                           AS CUST_ENG_NM                --客户英文名称
      ,/*NVL(TRIM(CASE WHEN C.CRDL_TYP = '236' THEN '2313' --20220906 XUXIAOBIN
                        WHEN C.CERT_TYPE_CD = '2100' THEN '9913'
                        WHEN C.CERT_TYPE_CD = '2319' THEN '9940'
                        WHEN C.CERT_TYPE_CD = '2999' THEN '239'
                        WHEN C.CERT_TYPE_CD = '2314' THEN '23'
                        WHEN C.CERT_TYPE_CD = '2070' THEN '9910'
                        ELSE C.CRDL_TYP END)
              ,CASE WHEN TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTHB(A.SOCI_CRDT_CD) = 18 THEN '236'  --统一社会信用代码
                    WHEN TRIM(A.ORGNZ_CD)     IS NOT NULL THEN '21'  --组织机构代码证
                    WHEN TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN '22'  --营业执照（工商注册号）
                    WHEN TRIM(A.RGSTION_CD)   IS NOT NULL THEN '23'  --登记证书
                    WHEN TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL THEN '28'  --国税税务登记证
                    WHEN TRIM(A.LOCAL_TAX_RGST_CERT_NUM)  IS NOT NULL THEN '29'  --地税税务登记证
                    WHEN TRIM(A.FIN_LICS_NUM)    IS NOT NULL THEN  '2F'  --金融许可证
                    WHEN TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN  '2J'  --人行支付行号
                    ELSE '2X' END)*/
       NVL(TRIM(CASE WHEN C.CRDL_TYP = '236' THEN '2313' --20220906 XUXIAOBIN
                     ELSE C.CERT_TYPE_CD END)
              ,CASE WHEN TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTHB(A.SOCI_CRDT_CD) = 18 THEN '2313'  --统一社会信用代码
                    WHEN TRIM(A.ORGNZ_CD)     IS NOT NULL THEN '2020'  --组织机构代码证
                    WHEN TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN '2010'  --营业执照（工商注册号）
                    WHEN TRIM(A.RGSTION_CD)   IS NOT NULL THEN '2314'  --登记证书
                    WHEN TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL THEN '2071'  --国税税务登记证
                    WHEN TRIM(A.LOCAL_TAX_RGST_CERT_NUM)  IS NOT NULL THEN '2072'  --地税税务登记证
                    WHEN TRIM(A.FIN_LICS_NUM)    IS NOT NULL THEN  '2090'  --金融许可证
                    WHEN TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN  '2080'  --人行支付行号
                    ELSE '2999' END)           AS CRDL_TYP                   --证件类型--20220906 XUXIAOBIN MODIFY
      ,NVL(TRIM(C.CRDL_NO)
         ,CASE WHEN TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTHB(A.SOCI_CRDT_CD) = 18 THEN A.SOCI_CRDT_CD  --modify by hulj
               WHEN TRIM(A.ORGNZ_CD) IS NOT NULL THEN A.ORGNZ_CD
               WHEN TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN A.BUS_LICS_NUM
               WHEN TRIM(A.RGSTION_CD) IS NOT NULL THEN A.RGSTION_CD
               WHEN TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL THEN A.NATION_TAX_RGST_CERT_NUM
               WHEN TRIM(A.LOCAL_TAX_RGST_CERT_NUM) IS NOT NULL THEN A.LOCAL_TAX_RGST_CERT_NUM
               WHEN TRIM(A.FIN_LICS_NUM) IS NOT NULL THEN A.FIN_LICS_NUM
               WHEN TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN A.PBC_PAY_BANK_NO
               ELSE NULL END)                                    AS CRDL_NO                    --证件号码
        /* ,CASE WHEN (TRIM(C.CRDL_TYP)='236' and TRIM(C.CRDL_NO)is not null) or (TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTHB(A.SOCI_CRDT_CD) = 18) THEN '236'  --统一社会信用代码
               WHEN (TRIM(C.CRDL_TYP)='21' and TRIM(C.CRDL_NO)is not null) or TRIM(A.ORGNZ_CD)     IS NOT NULL THEN '21'  --组织机构代码证
               WHEN (TRIM(C.CRDL_TYP)='2J' and TRIM(C.CRDL_NO)is not null) or TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN  '2J'  --人行支付行号
               WHEN (TRIM(C.CRDL_TYP)='2F' and TRIM(C.CRDL_NO)is not null) or TRIM(A.FIN_LICS_NUM)    IS NOT NULL THEN  '2F'  --金融许可证
               WHEN (TRIM(C.CRDL_TYP)='22' and TRIM(C.CRDL_NO)is not null) or TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN '22'  --营业执照（工商注册号）
               WHEN (TRIM(C.CRDL_TYP)='23' and TRIM(C.CRDL_NO)is not null) or TRIM(A.RGSTION_CD)   IS NOT NULL THEN '23'  --登记证书
               WHEN (TRIM(C.CRDL_TYP)='28' and TRIM(C.CRDL_NO)is not null) or TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL THEN '28'  --国税税务登记证
               WHEN (TRIM(C.CRDL_TYP)='29' and TRIM(C.CRDL_NO)is not null) or TRIM(A.LOCAL_TAX_RGST_CERT_NUM)  IS NOT NULL THEN '29'  --地税税务登记证
               ELSE nvl(TRIM(C.CRDL_TYP),'2X') END                                    AS CRDL_TYP                   --证件类型
         ,CASE WHEN TRIM(C.CRDL_TYP)='236' or (TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTH(A.SOCI_CRDT_CD) = 18) THEN nvl(TRIM(C.CRDL_NO),A.SOCI_CRDT_CD)
               WHEN TRIM(C.CRDL_TYP)='21' or TRIM(A.ORGNZ_CD) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.ORGNZ_CD)
               WHEN TRIM(C.CRDL_TYP)='2J' or TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.PBC_PAY_BANK_NO)
               WHEN TRIM(C.CRDL_TYP)='2F' or TRIM(A.FIN_LICS_NUM) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.FIN_LICS_NUM)
               WHEN TRIM(C.CRDL_TYP)='22' or TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.BUS_LICS_NUM)
               WHEN TRIM(C.CRDL_TYP)='23' or TRIM(A.RGSTION_CD) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.RGSTION_CD)
               WHEN TRIM(C.CRDL_TYP)='28' or TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.NATION_TAX_RGST_CERT_NUM)
               WHEN TRIM(C.CRDL_TYP)='29' or TRIM(A.LOCAL_TAX_RGST_CERT_NUM) IS NOT NULL THEN nvl(TRIM(C.CRDL_NO),A.LOCAL_TAX_RGST_CERT_NUM)
               ELSE TRIM(C.CRDL_NO) END                                    AS CRDL_NO                    --证件号码 */
      ,CASE WHEN C.CRDL_EFF_DT = '00010101' THEN NULL
            WHEN TRIM(C.CRDL_NO) IS NOT NULL THEN C.CRDL_EFF_DT
            ELSE NULL
       END                                                       AS CRDL_EFF_DT                --证件生效日期
      ,CASE WHEN TRIM(C.CRDL_NO) IS NOT NULL THEN C.CRDL_EXP_DT
            ELSE NULL
       END                                                       AS CRDL_EXP_DT                --证件失效日期
      ,CASE WHEN TRIM(C.CRDL_NO) IS NOT NULL THEN C.CRDL_UPD_DT
            ELSE NULL
       END                                                       AS CRDL_UPD_DT                --证件更新日期
      ,COALESCE(CASE WHEN TRIM(C.CRDL_TYP) = '236' AND LENGTH(C.CRDL_NO) = 18 AND SUBSTR(C.CRDL_NO,1,2) = '92' THEN 'E'   --统一社会信用代码开头2位为“92”的个体工商户
                     WHEN TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTH(A.SOCI_CRDT_CD) = 18 AND SUBSTR(A.SOCI_CRDT_CD,1,2) = '92' THEN 'E' --统一社会信用代码开头2位为“92”的个体工商户
                     WHEN A.DEPOSITR_CATE_CD IN ('113','114') THEN 'E'         --13 20221020XUXIAOBIN 修复有字号的个体工商户,14 无字号的个体工商户
                     ELSE NULL END
               ,D.TAR_VALUE_CODE   --通过国民经济部门映射客户类型
               ,CASE WHEN A.DEPOSITR_CATE_CD = '101' THEN 'A01'               --01 企业法人
                     WHEN A.DEPOSITR_CATE_CD = '102' THEN 'A02'               --02 非法人企业
                     WHEN A.DEPOSITR_CATE_CD = '103' THEN 'B04'               --03 机关
                     WHEN A.DEPOSITR_CATE_CD IN ('104','105') THEN 'C'        --04 实行预算管理的事业单位,05 非实行预算管理的事业单位
                     WHEN A.DEPOSITR_CATE_CD IN ('106','107') THEN 'F'        --06 团级（含）以上军队及分散执勤的支（分）队,07 团级（含）以上武警部队及分散执勤的支（分）队
                     WHEN A.DEPOSITR_CATE_CD IN ('108','109','115') THEN 'D'  --08 社会团体,09 宗教组织,15 居民委员会、村民委员会、社区委员会
                     WHEN A.DEPOSITR_CATE_CD IN ('110','116','180') THEN 'X'  --10 民办非企业组织,16 单位设立的独立核算的附属机构,17 其它组织
                     WHEN A.DEPOSITR_CATE_CD IN ('111','112') THEN 'B03'      --11 外地常设机构,12 外国驻华机构
                     ELSE NULL
                END,'X')                        AS CUST_CL                    --客户分类
      ,A.DEPOSITR_CATE_CD                       AS CUST_TYP_RSK               --客户类型（客户风险）
      ,CASE WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='A00' THEN 'A'
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='B00' THEN 'B'
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='C00' THEN 'C'
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='D00' THEN 'D'
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='E00' THEN 'E'
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD !='000' THEN A.NATNAL_ECON_DEPT_TYPE_CD --20221119 XUXIAOBIN 调整
            WHEN A.RESDNT_FLG <> '1' OR A.CTY_RG_CD IN ('HKG','TWN','MO') THEN 'E04'-- 根据旧监管20221012 XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('113','114') THEN 'D01'--20220929XUXIAOBIN MODIFY /*THEN 'Z'*/
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('101','102') THEN 'C01'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('103') THEN 'A04'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('104','105') THEN 'C99'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('106','107') THEN 'A05'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('108','109','110','115','116','180') THEN 'C99'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('111','112') THEN 'E02'--20220929XUXIAOBIN MODIFY
            WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' AND A.DEPOSITR_CATE_CD IN ('190') THEN 'E04'--20220929XUXIAOBIN MODIFY
            WHEN A.CRDT_CUST_TYPE_CD = '2' THEN 'C01'--C01公司 --20221119 根据旧监管金数调整
            /*WHEN A.NATNAL_ECON_DEPT_TYPE_CD ='000' THEN 'C99'
            ELSE A.NATNAL_ECON_DEPT_TYPE_CD*/ELSE 'C99'
       END                                      AS NATL_ECON_DEPT_CL          --国民经济部门分类
      ,CASE WHEN A.DEPOSITR_CATE_CD IN ('104','105') THEN 'Y'
            ELSE 'N'
       END                                      AS GOV_AFF_INS_FLG            --事业单位标志
      ,CASE WHEN TY.FIN_INST_CATE_CD = '1C1000'
            THEN 'C11200' --'标识为银行，暂标记为其他银行'
            ELSE E.TAR_VALUE_CODE
            END                                 AS FIN_ORG_TYP                --金融机构类型
      ,TRIM(A.FIN_LICS_NUM)                     AS FIN_PERMIT_NO              --金融许可证号
      ,TRIM(A.PBC_PAY_BANK_NO)                  AS PBC_NO                     --人行支付行号
      ,CASE WHEN A.CORP_TYPE_CD = '3' AND LENGTH(A.FIN_LICS_NUM) <=15 AND TRIM(A.FIN_LICS_NUM) IS NOT NULL THEN A.FIN_LICS_NUM
            ELSE COALESCE(TRIM(A.FIN_LICS_NUM),A.SOCI_CRDT_CD,A.BUS_LICS_NUM) --取不到金融许可证号取统一社会信用代码
       END                                      AS FIN_ORG_ID                 --金融机构编号
      ,CASE WHEN A.CORP_SIZE_CD = '1' THEN 'L'
            WHEN A.CORP_SIZE_CD = '2' THEN 'M'
            WHEN A.CORP_SIZE_CD = '3' THEN 'S'
            WHEN A.CORP_SIZE_CD = '4' THEN 'X'
            ELSE 'Z'
       END                                      AS ENT_SCALE                  --企业规模
      ,F.TAR_VALUE_CODE                         AS ENT_HLDG_TYP               --企业控股类型
      ,/*CASE WHEN (A.RG_CD IN ('810000', '820000', '710000') --地区代码可能有误
      OR A.CTY_RG_CD IN ('HKG','TWN','MO')--20220818 XUXIAOBIN ADD --取国家和地区代码 HKG 香港 TWN 台湾 MO 澳门
      OR NVL(A.INVTOR_CTY_CD, '1111') NOT IN ('CHN', 'XXX', '1111')) THEN 'N'
            ELSE 'Y'
       END */
      CASE WHEN A.RESDNT_FLG = '1'
           THEN 'Y'
           WHEN A.RESDNT_FLG = '0'
           THEN 'N'
           ELSE 'Z'
           END                                    AS RSDNT_FLG                  --居民标志
      ,A.CTY_RG_CD                              AS REGD_LAND_CTRY_CD          --注册地国家代码
      ,/*CASE WHEN A.CTY_RG_CD IN ('HKG') THEN '000344'
            WHEN A.CTY_RG_CD IN ('TWN') THEN '000446'
            WHEN A.CTY_RG_CD IN ('MO') THEN '000446'*/
       A.RG_CD                                  AS REGD_LAND_AREA_CD          --注册地行政区划代码
      ,A.RGST_ADDR                              AS REGD_ADDR                  --注册地址
      ,NULL                                     AS REGD_INFO_UPD_DT           --注册信息更新日期
      ,A.INVTOR_CTY_CD                          AS OPR_LAND_CTRY_CD           --经营地国家代码
      ,A.MANG_SITE_CD                           AS OPR_LAND_AREA_CD           --经营地行政区划代码
      ,A.PROD_MANG_ADDR                         AS OPR_ADDR                   --经营地址
      ,NULL                                     AS UPD_WRK_ADDR_DT            --更新办公地址日期
      ,CASE WHEN TRIM(A.INDUS_TYPE_CD) IS NOT NULL AND TRIM(A.INDUS_TYPE_CD) NOT IN ('-','@')
                    AND LENGTHB(TRIM(A.INDUS_TYPE_CD)) = 5
               THEN TRIM(A.INDUS_TYPE_CD)
               WHEN TRIM(A.INDUS_TYPE_CD_CRDTC) IS NOT NULL AND TRIM(A.INDUS_TYPE_CD_CRDTC) NOT IN ('-','@')
                    AND LENGTHB(TRIM(A.INDUS_TYPE_CD_CRDTC)) = 5 AND A.INDUS_TYPE_CD_CRDTC <> 'U0000'
               THEN TRIM(A.INDUS_TYPE_CD_CRDTC)
               WHEN TRIM(A.INDUS_TYPE_CD) IS NOT NULL AND TRIM(A.INDUS_TYPE_CD) NOT IN ('-','@')
               THEN TRIM(A.INDUS_TYPE_CD)
               WHEN A.INDUS_TYPE_CD = 'U0000' OR TRIM(A.INDUS_TYPE_CD) IN ('-','@')
               THEN 'Z'
               ELSE TRIM(A.INDUS_TYPE_CD)
           END                                  AS CUST_BLNG_IDY              --客户所属行业  --modify by hulj
      ,CASE WHEN TRIM(A.GREEN_CRDT_CLS_CD) IS NOT NULL AND  A.GREEN_CRDT_CLS_CD <> '-' THEN A.GREEN_CRDT_CLS_CD
            ELSE NULL
       END                                      AS GRN_LOAN_IDY_CL            --绿色贷款有关行业分类
      ,NULL                                     AS MJR_ENV_SAFE_RSK_ENT_CL    --重大环境安全风险企业分类
      ,NULL                                     AS OPEN_EBANK_FLG             --开通网银标志
      ,CASE WHEN A.CORP_CLOSE_FLG = '1' THEN 'Y'
            ELSE 'N'
       END                                      AS ENT_CLOSE_FLG              --企业关停标志
      ,NULL                                     AS ENT_GUA_SML_MICRO_ENT_FLG  --创业担保小微企业标志
      ,NULL                                     AS FIT_SML_MICRO_ENT_FLG      --符合条件的小微企业标志
      ,NULL                                     AS CN_CPTL_FLG                --中资标志
      ,CASE WHEN A.CTYSD_CORP_FLG = '1' THEN 'V'
            WHEN A.CTYSD_CORP_FLG = '0' THEN 'C'
              ELSE NULL  END                     AS VIL_CITY_FLG               --农村城市标志
      ,A.CTYSD_CORP_FLG                          AS FAMILY_FARM_FLG            --家庭农场标志
      ,CASE WHEN TRIM(A.CORP_GROW_STAGE_CD) IS NULL OR A.CORP_GROW_STAGE_CD = '-' THEN 'Z'
            ELSE A.CORP_GROW_STAGE_CD
       END                                       AS ENT_GROW_UP_STAGE          --企业成长阶段
      ,/*CASE WHEN A.CRDT_CUST_TYPE_CD LIKE '0701%' THEN 'A'
            WHEN A.CRDT_CUST_TYPE_CD LIKE '0704%' THEN 'B'
            WHEN REGEXP_LIKE(A.CRDT_CUST_TYPE_CD, '(0705|0706|0707|0708|0709)$') THEN 'C'
            ELSE 'Z'
       END*/SPV_TYPE.TAR_VALUE_CODE                              AS SPV_SUM_CL                 --SPV细类
      ,CASE WHEN A.CUST_NAME LIKE '%小额贷款%' OR A.CUST_NAME LIKE '%小额再贷款%' THEN 'Y'
            ELSE 'N'
       END                                       AS MICROFIN_CO_FLG            --小额贷款公司标志
      ,CASE WHEN A.SCI_TECH_CORP_CLS_CD IN ('02','03') AND A.CORP_SIZE_CD IN ('2','3','4') THEN 'Y'
            ELSE 'N'
       END                                       AS TECH_MID_SML_ENT_FLG       --科技型中小企业标志
      ,CASE WHEN A.HIGH_NEW_TECH_CORP_FLG = '1' THEN 'Y'
            ELSE 'N'
       END                                       AS HIGH_NEW_TECH_CORP_FLG     --高新技术企业标志
      ,CASE WHEN A.SCI_TECH_CORP_CLS_CD = '02' THEN 'Y'
            ELSE 'N'
       END                                       AS TECH_ENT_FLG               --科技型企业标志
      ,CASE WHEN A.SCI_TECH_CORP_CLS_CD = '03' THEN 'Y'
            ELSE 'N'
       END                                       AS TECH_INNO_ENT_FLG          --科创企业标志
      ,CASE WHEN A.LIST_CORP_FLG = '1' THEN 'Y'
            ELSE 'N'
       END                                       AS IPO_CO_FLG                 --上市公司标志
      ,NULL                                      AS BIG_RSK_EXP_CUST_FLG       --大额风险暴露豁免客户标志
      ,CASE WHEN A.RELA_PARTY_FLG = '1' THEN 'Y'
            ELSE 'N'
       END                                       AS REL_PTY_FLG                --关联方标志
      ,CASE WHEN /*A.GROUP_CUST_FLG = '1'*/ GROUP_CUST_ID IS NOT NULL THEN 'Y'   --mod by hulj20230130
            ELSE 'N'
       END                                       AS GRP_MBR_CUST_FLG           --集团成员客户标志
      ,A.OPER_RANGE                              AS OPR_SCOPE                  --经营范围
      ,CASE WHEN TO_CHAR(A.RGST_DT,'YYYYMMDD') NOT IN ('00010101','29990101') THEN TO_CHAR(A.RGST_DT,'YYYYMMDD')
            WHEN TO_CHAR(A.CORP_FOUND_DT,'YYYYMMDD') NOT IN ('00010101','29990101') THEN TO_CHAR(A.CORP_FOUND_DT,'YYYYMMDD')
       END                                       AS ESTM_DT                    --成立日期 --modify by hulj
      ,COALESCE(TRIM(A.PHONE_CRDTC),TRIM(A.FIN_DEPT_PHONE),TRIM(GLRDH.DH))     AS TEL    --联系电话
      ,A.RGST_CAP                                AS REGD_CPTL                  --注册资本
      ,A.CURR_CD                                 AS REGD_CPTL_CUR              --注册资本币种
      ,A.PAID_IN_CAPITAL                         AS PAID_IN_CPTL               --实收资本
      ,REPLACE(A.PAID_IN_CAPITAL_CURR_CD,'-','')                 AS PAID_IN_CPTL_CUR           --实收资本币种
      ,TRIM(A.BASIC_ACCT_ACCT_NUM)                               AS BSC_DEP_ACC                --基本存款账号--modify by hulj
      ,NVL(TRIM(Y.ORG_NAME),TRIM(A.BASIC_ACCT_OPEN_BANK_NAME))   AS BSC_ACC_OPEN_BANK_NM       --基本账户开户行名称--modify by hulj
      --,NVL(TRIM(Y.FIN_INST_CODE),TRIM(BANK_TA.SYS_PRTCPTR_BIGAMT_BANK_NO)) AS BSC_ACC_OPEN_BANK_ID       --基本账户开户行编号--modify by hulj
      ,NVL(Y.PBC_PAY_BANK_NO,A.OPEN_ACCT_ORG_ID) AS BSC_ACC_OPEN_BANK_ID       --基本账户开户行编号  --MODIFY  CCH  20221108
      ,nvl(TRIM(A.EMPLY_QTTY),0)                                 AS EMP_NUM                    --员工人数
      ,RISK1.WARN_HIBCHY                         AS RSK_WARN_SGNL              --风险预警信号
      ,RISK2.WARN_DESCB                          AS RSK_WARN_SGNL_DESC         --风险预警信号描述
      ,NULL                                      AS FOC_EVT                    --关注事件
      ,NULL                                      AS PD                         --违约概率
      ,J.TAR_VALUE_CODE                          AS INR_RTG                    --内部评级
      ,REGEXP_REPLACE(TT.RATING_LEVEL_CD,'[^0-9]','')               AS EXT_RTG --外部评级 --20221109 XUXIAOBIN MODIFY
      ,'16'                                      AS CUST_CR_RTG_TOT_GRD        --客户信用评级总等级数
      ,J.TAR_VALUE_NAME                          AS CUST_CRDT_RTG              --客户信用评级
      --,H.RRP_VALUE_CODE                        AS CUST_CRDT_RTG              --客户信用评级 --评级表暂未接入，暂时置空
      ,I.FIRST_ESTBL_CRDT_REL_DT                 AS FIRST_ESTBL_CRDT_REL_DT    --首次建立信贷关系日期
      --,TO_CHAR(A.FIR_LON_DT,'YYYYMMDD')          AS FIRST_ESTBL_CRDT_REL_DT    --首次建立信贷关系日期
      ,A.LOAN_CARD_NO                            AS LOAN_CERT_NO               --贷款证号
      ,/*CASE WHEN A.CORP_CLOSE_FLG = '1' THEN '02'  --停业
            WHEN A.CUST_STATUS_CD = 'A' THEN '01'  --正常运营
            ELSE '99'  --其他
       END                                       AS OPR_STAT                   --经营状态*/
       CASE WHEN A.CUST_STATUS_CD = '2' THEN '02'  --停业
            WHEN A.CUST_STATUS_CD = '1' THEN '01'  --正常运营
            ELSE '99'  --其他
       END                                       AS OPR_STAT                   --经营状态--20220921 XUXIAOBIN MODIFY
      ,NULL                                      AS OPR_STAT_END_DT            --营业状态结束日期
      ,CASE WHEN A.CUST_STATUS_CD='P' THEN 'C'
            ELSE 'A'
       END                                       AS CUST_STAT                  --客户状态
      ,NULL                                      AS PRCN_LG_CUST_FLG           --专精特新小巨人客户标志
      ,NULL                                      AS PRCN_CUST_FLG              --专精特新客户标志
      ,'800926'/*公司银行总部*/                          AS DEPT_LINE                  --部门条线
      ,SUBSTR(A.JOB_CD,0,4)                      AS DATA_SRC                   --数据来源
      ,CASE WHEN A.DOM_OVERS_FLG = '1' THEN 'Y'
            ELSE 'N'
       END                                       AS BIO_FLG                    --境内外标志
      ,NULL                                      AS LCL_FIN_PLTF_HIER_TYP      --地方融资平台层级类型
      ,NULL                                      AS BEAR_OR_RED_AMT            --承担或减免的信贷费用金额
      /*20220425  借据是否科技型需要该字段限制放款日期小于认定日期的*/
      ,TO_CHAR(A.SCI_TECH_CORP_IDTFY_DT,'YYYYMMDD') AS TECH_ENT_IDTFY_DT      --科技型企业认定日期
      ,CASE WHEN A.CORP_ANL_INCO = 0 THEN A.CORP_YEAR_BUS_LMT END                     AS ANL_INCO                   --企业年收入
      --,TRIM(TY.FIN_INST_CODE)                    AS FIN_INST_CODE                --金融机构编码
      ,CASE WHEN LENGTHB(TY.FIN_INST_CODE) = 14
            THEN TY.FIN_INST_CODE
            ELSE ''
        END                                                     AS FIN_INST_CODE     --金融机构编码 md by 20221117 xucx
      ,CASE WHEN A.CUST_TYPE_CD = '3' OR (TY.PARTY_ID IS NOT NULL AND TY.FIN_INST_CATE_CD <> '000000')  THEN 'Y'  --20220927 XUXIAOBIN ADD
      ELSE 'N' END                               AS TYBZ --同业标记
      ,NVL(TY.FIN_INST_CATE_CD,'1Z0000') AS  FIN_ORG_TYP_DIIS  --金融机构类别代码CD1389' add by 20221102 xucx
      ,NVL(CASE WHEN C.CERT_TYPE_CD IN ('2313','2314','2072','2071') AND LENGTHB(TRIM(C.CRDL_NO))=18 THEN '2313'
              ELSE C.CERT_TYPE_CD END
            ,CASE WHEN TRIM(A.SOCI_CRDT_CD) IS NOT NULL AND LENGTHB(A.SOCI_CRDT_CD) = 18 THEN '2313'  --统一社会信用代码
                  WHEN TRIM(A.ORGNZ_CD)     IS NOT NULL THEN '2020'  --组织机构代码证
                  WHEN TRIM(A.BUS_LICS_NUM) IS NOT NULL THEN '2010'  --营业执照（工商注册号）
                  WHEN TRIM(A.RGSTION_CD)   IS NOT NULL AND LENGTHB(TRIM(A.RGSTION_CD))=18  THEN '2313'  --登记证书
                  WHEN TRIM(A.RGSTION_CD)   IS NOT NULL AND LENGTHB(TRIM(A.RGSTION_CD))<>18  THEN '2314'  --登记证书
                  WHEN TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL AND LENGTHB(TRIM(A.NATION_TAX_RGST_CERT_NUM))=18  THEN '2313'
                  WHEN TRIM(A.NATION_TAX_RGST_CERT_NUM) IS NOT NULL AND LENGTHB(TRIM(A.NATION_TAX_RGST_CERT_NUM))<>18  THEN '2071'--国税税务登记证
                  WHEN TRIM(A.LOCAL_TAX_RGST_CERT_NUM)  IS NOT NULL AND LENGTHB(TRIM(A.LOCAL_TAX_RGST_CERT_NUM))=18 THEN '2313'
                  WHEN TRIM(A.LOCAL_TAX_RGST_CERT_NUM)  IS NOT NULL AND LENGTHB(TRIM(A.LOCAL_TAX_RGST_CERT_NUM))<>18 THEN '2072'  --地税税务登记证
                  WHEN TRIM(A.FIN_LICS_NUM)    IS NOT NULL THEN  '2090'  --金融许可证
                  WHEN TRIM(A.PBC_PAY_BANK_NO) IS NOT NULL THEN  '2J'  --人行支付行号
                  ELSE '2X' END)                                   AS CRDL_TYP_DIIS                   --证件类型
      ,TRIM(A.LP_ORG_CUST_ID) AS LP_ORG_CUST_ID               --法人机构客户编号 add by 20221111 xucx
      ,A.LP_ORG_TYPE_CD       AS LP_ORG_TYPE_CD               --法人机构类型     add by mw 20221117
      ,A.CUST_MGR_ID                            AS CUST_MGR_ID       --客户主办客户经理客户号 add by hulj 20221123
      ,T16.TELLER_ID                            AS CUST_TELLER_ID           --客户主办柜员号 add by hulj 20221123
      ,NVL(T17.TELLER_NAME,T16.CLERK_NAME)      AS CUST_MGR_NAME        --客户主办客户经理名称 add by hulj 20221123
      ,NVL(T17.BELONG_ORG_ID,T16.BELONG_ORG_ID) AS CUST_MGR_BELONG_ORG_ID      --客户主办客户经理所属机构 add by hulj 20221123
      ,CASE WHEN SUBSTR(A.SOCI_CRDT_CD,1,2) IN ('N1','N2','N3')
        THEN 'Y' ELSE 'N' END                   AS VIL_COLLTV_ECON_ORG_FLG --农村集体经济组织标志 add by hulj 20221123
       ,CASE WHEN A.SOCI_CRDT_CD LIKE '93%'
        THEN 'Y' ELSE 'N' END                   AS FARMER_PROF_COOP_FLG --农民专业合作社标志 add by hulj 20221123
      ,A.BUS_LICS_NUM                           AS BUS_LICS_NUM         --营业执照号
      ,TO_CHAR(A.CORP_FOUND_DT,'YYYYMMDD')    AS BUS_LICS_RGST_DT      --营业执照注册日期
      ,CASE WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2)='91' THEN '企业' --企业
            WHEN (SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) IN ('91','N1','N2','N3','93','12','51','52','53','81')
                 OR D.SRC_VALUE_CODE  LIKE 'A%') THEN '其他对公客户' --其他对公客户
            WHEN D.SRC_VALUE_CODE IN('B09','B99','D01','D02','E05') THEN '不适用'  --不适用
       END                                      AS PBOC_CUST_CL         --PBOC客户类型
      ,CASE WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2)='91' THEN '企业' --企业
            WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) IN ('N1','N2','N3') THEN  '农村集体经济组织（企业）' --农村集体经济组织（企业）
            WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) = '93' THEN '农民专业合作社（企业）' --农民专业合作社（企业）
            WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) = '12' THEN '事业单位' --事业单位
            WHEN D.SRC_VALUE_CODE LIKE 'A%' THEN '行政机关'  --行政机关
            WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) IN ('51','81') THEN '社会团体' --社会团体
            WHEN SUBSTR(COALESCE(A.SOCI_CRDT_CD,A.NATION_TAX_RGST_CERT_NUM,A.LOCAL_TAX_RGST_CERT_NUM,A.RGSTION_CD),0,2) IN ('52','53') THEN '其他对公客户' --其他对公客户
            WHEN D.SRC_VALUE_CODE IN('B09','B99','D01','D02','E05') THEN '不适用'  --不适用
       END                                     AS CBRC_CUST_CL         --CBRC客户类型
      ,A.OPEN_ACCT_ORG_ID                      AS OPEN_ACCT_ORG_ID     --开户机构编号
      ,CASE WHEN (C.CERT_TYPE_CD = '2313' AND SUBSTR(C.CRDL_NO, 1, 2) IN ('92'))  --统一社会信用代码开头2位为“92”的个体工商户
               THEN '3'
               WHEN A.DEPOSITR_CATE_CD IN ('113', '114')  --13有字号的个体工商户,14无字号的个体工商户
               THEN '3'
               WHEN T4.CUST_TYP IS NOT NULL
               THEN T4.CUST_TYP
               ELSE '9'
          END                                 AS C_CUST_TYPE --客户类型-银监
       ,A.ORGNZ_CD                              AS ORGNZ_CD --组织机构代码
  FROM RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO A --对公客户基本信息
  LEFT JOIN RRP_MDL.TMP_CORP_CRDL_INFO C  --对公客户证件信息临时表
         ON A.CUST_ID = C.CUST_ID
         --MODIFY 付
  left join  RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO X --存款主账户信息
        ON A.BASIC_ACCT_ACCT_NUM=X.CUST_ACCT_ID
        AND  X.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
  left join  RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO Y --内部机构信息表
         ON   X.OPEN_ACCT_ORG_ID=Y.ORG_ID
         AND  Y.ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
         ---MODIFY FU
  LEFT JOIN CORP_CUST_RELA_PS_INFO GLRDH --MODIFY BY hulj 20221011
              /*(SELECT A.CUST_ID,COALESCE(A.RELA_PS_WORK_UNIT_TEL_NUM,A.RELA_PS_MOBILE_NO,A.RELA_PS_TEL_NUM) DH, --去法定代表人联系方式
                      ROW_NUMBER() OVER(PARTITION BY A.CUST_ID ORDER BY COALESCE(A.RELA_PS_WORK_UNIT_TEL_NUM,A.RELA_PS_MOBILE_NO,A.RELA_PS_TEL_NUM) DESC) RN
                 FROM RRP_MDL.O_ICL_CMM_CORP_CUST_RELA_PS_INFO A
                WHERE A.RELA_TYPE_CD IN ('30101','30105')
                  AND COALESCE(A.RELA_PS_WORK_UNIT_TEL_NUM,A.RELA_PS_MOBILE_NO,A.RELA_PS_TEL_NUM) IS NOT NULL)GLRDH --20220803 许晓滨 ADD*/
           ON A.CUST_ID= GLRDH.CUST_ID
          AND GLRDH.RN = 1
  LEFT JOIN RRP_MDL.CODE_MAP D --码值映射表
         ON A.NATNAL_ECON_DEPT_TYPE_CD = D.SRC_VALUE_CODE
        AND D.SRC_CLASS_CODE = 'CD1418' --国民经济部门类型代码
        AND D.TAR_CLASS_CODE = 'C0003'  --对公客户分类
        AND D.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO TY --同业客户特有信息
  ON NVL(TRIM(A.LP_ORG_CUST_ID),A.CUST_ID)=TY.PARTY_ID
  AND TY.ID_MARK <> 'D'
  AND A.ETL_DT>=TY.START_DT
  AND A.ETL_DT<TY.END_DT
  AND TY.FIN_INST_CATE_CD <> '000000' --20220927 XUXIAOBIN ADD
  LEFT JOIN ADD_M_DICT_NATNAL_ECON_DEPT_TYPE_CD T4
         ON T4.NATNAL_ECON_DEPT_TYPE_CD = A.NATNAL_ECON_DEPT_TYPE_CD
  LEFT JOIN RRP_MDL.CODE_MAP E
         ON TY.FIN_INST_CATE_CD = E.SRC_VALUE_CODE
        AND E.SRC_CLASS_CODE = 'CD1389' --金融机构类型
        AND E.TAR_CLASS_CODE = 'C0005'  --金融机构类型
        AND E.MOD_FLG = 'MDM'
  LEFT JOIN RRP_MDL.CODE_MAP F
         ON A.HOLD_TYPE_CD = F.SRC_VALUE_CODE
        AND F.SRC_CLASS_CODE = 'CD1417' --经济成分代码
        AND F.TAR_CLASS_CODE = 'C0004'  --企业控股类型
        AND F.MOD_FLG = 'MDM'
  LEFT JOIN (
    SELECT CUST_ID
          ,TO_CHAR(DISTR_DT,'YYYYMMDD') AS FIRST_ESTBL_CRDT_REL_DT
          ,ROW_NUMBER()OVER(PARTITION BY CUST_ID ORDER BY DISTR_DT ASC) AS NUM
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO
    WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')
    AND TRIM(CUST_ID) IS NOT NULL
  ) I
  ON A.CUST_ID = I.CUST_ID
  AND I.NUM = 1
  LEFT JOIN
  (SELECT H.*,ROW_NUMBER() OVER (PARTITION BY H.PARTY_ID ORDER BY H.RATING_EFFECT_DT DESC,H.RATING_DT DESC) RN FROM --20220926 XUXIAOBIN ADD
  RRP_MDL.O_IML_PTY_PARTY_RATING_H H
  WHERE H.RATING_LEVEL_CD is not null
  AND H.PARTY_RATING_TYPE_CD='09')H
         ON A.CUST_ID=H.PARTY_ID
          AND H.START_DT<= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND H.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
          AND H.RN = 1
  LEFT JOIN (SELECT T.PARTY_ID,T.SRC_TABLE_NAME
                     ,DECODE(T.RATING_LEVEL_CD,'AAA+','1','AAA','2','AAA-','3','AA+','4','AA','5','AA-','6','A+','7','A','8','A-','9','BBB+','10','BBB','11','BBB-',
                                '12','BB','13','B','14','C','15','D','16',T.RATING_LEVEL_CD) AS RATING_LEVEL_CD
                     ,ROW_NUMBER()OVER(PARTITION BY PARTY_ID ORDER BY DECODE(T.RATING_LEVEL_CD,'AAA+','1','AAA','2','AAA-','3','AA+','4','AA','5','AA-','6','A+','7','A','8','A-','9','BBB+','10','BBB','11','BBB-',
                                '12','BB','13','B','14','C','15','D','16',T.RATING_LEVEL_CD)) RN
                FROM O_IML_PTY_PARTY_RATING_H T
               WHERE T.SRC_TABLE_NAME IN('crss_customer_rate_result','nrrs_gs_yearratresult')
                 AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND ID_MARK <> 'D'
                 AND RATING_INVALID_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                 )TT
             ON TT.PARTY_ID = A.CUST_ID
            AND TT.RN = 1
  LEFT JOIN RRP_MDL.CODE_MAP J
         ON J.SRC_VALUE_CODE = H.RATING_LEVEL_CD
        AND J.SRC_CLASS_CODE = 'CD1850'  --内部评级结果代码
        AND J.TAR_CLASS_CODE = 'D0062'   --评级代码
        AND J.MOD_FLG = 'MDM'
  LEFT JOIN BANK_NO_NAME BANK_TA
        ON BANK_TA.SYS_PRTCPTR_BIGAMT_BANK_NAME = A.BASIC_ACCT_OPEN_BANK_NAME
  LEFT JOIN O_ICL_CMM_CLERK_INFO T16
        ON A.CUST_MGR_ID = T16.CLERK_ID
       AND T16.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --add by hulj 20221123
  LEFT JOIN O_ICL_CMM_TELLER_INFO T17
        ON T16.TELLER_ID = T17.TELLER_ID
       AND T17.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')  --add by hulj 20221123
  LEFT JOIN
  (SELECT SPV.*,ROW_NUMBER()OVER(PARTITION BY SPV.PARTY_ID ORDER BY SPV.START_DT DESC) RN from
  O_IML_PTY_SPV_CUST_INFO  SPV
  WHERE SPV.START_DT  <= TO_DATE(V_P_DATE,'YYYYMMDD')
  AND SPV.END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD'))SPV
  ON SPV.PARTY_ID = A.CUST_ID
  AND  SPV.RN=1
  LEFT JOIN (SELECT T.*,ROW_NUMBER()OVER (PARTITION BY CUST_ID ORDER BY WARN_ID DESC)  RN
        FROM  O_IML_PTY_CUST_RISK_WARN_INFO_H T
        WHERE  T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND     T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) RISK1  --客户风险预警信息历史
       ON RISK1.CUST_ID = A.CUST_ID
       AND RISK1.RN = 1
  LEFT JOIN O_IML_REF_RISK_WARN_SGN_DTL_H   RISK2   --风险预警信号详情历史
       ON RISK2.WARN_ID = RISK1.WARN_ID
       AND RISK2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND RISK2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
  LEFT JOIN   RRP_MDL.CODE_MAP SPV_TYPE
     ON SPV_TYPE.SRC_VALUE_CODE = SPV.SPV_TYPE_CD
        AND SPV_TYPE.SRC_CLASS_CODE = 'CD2354'  --特定目的载体类型代码
        AND SPV_TYPE.TAR_CLASS_CODE = 'Z0003'   --SPV细类
        AND SPV_TYPE.MOD_FLG = 'MDM'
  WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND A.CUST_ID IS NOT NULL
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, CUST_ID,COUNT(1)
      FROM M_CUST_CORP_INFO T
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

  END ETL_INIT_M_CUST_CORP_INFO;
/

