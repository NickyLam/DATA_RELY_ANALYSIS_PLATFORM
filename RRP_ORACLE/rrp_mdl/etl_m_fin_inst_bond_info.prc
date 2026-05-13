CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_FIN_INST_BOND_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：ETL_M_FIN_INST_BOND_INFO
 *  功能描述：监管集市银行持有、发行或以回购方式获取的债券的票面信息。
 *  创建日期：20220531
 *  开发人员：hulijuan
 *  来源表：  ICL.CMM_BOND_BASIC_INFO  --债券基本信息
 *            IML.EVT_BOND_ISSUE_TRAN_DTL  --债券发行交易明细
 *            ICL.CMM_IBANK_BOND_INVEST  --同业债券投资
 *  目标表：  M_FIN_INST_BOND_INFO  --债券基础信息
 *
 *  配置表：  CODE_MAP  --码值映射表
 *  修改情况：序号  修改日期  修改人    修改原因
 *             1    20220507  程序员    EAST5校验规则调整，同步进行程序修改。
 *             2    20220830  HULIJUAN  增加同业系统取数逻辑
               3    20220903  MW        增加PROD_CL取数口径和码值
               4    20221114  hulj      增加数据重复校验
               5    20230918  HYF       同业债券部分，债券编号不唯一，增加市场类型编号与投资表保持一致
               6    20231129  hulj      新增房地产债券类型名称
               7    20231213  hyf       修改资金债券部分评级关联条件
               8    20240611  TZJ       取O_ICL_CMM_ISSUER_RATING_INFO 数据时加SORC_SYS_CD\RATING_REST_CD使数据固定
               9    20240909  tzj       数仓新增托管机构代码13-中国证券登记结算有限责任公司北京分公司，模型映射成900-中国证券登记结算有限责任公司
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_FIN_INST_BOND_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_FIN_INST_BOND_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_FIN_INST_BOND_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '债券基础信息';
  V_STARTTIME := SYSDATE;
  /*****************资金系统******************/
  INSERT INTO RRP_MDL.M_FIN_INST_BOND_INFO
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ORG_ID                 --机构编号
    ,BOND_ID                --债券编号
    ,PROD_NM                --产品名称
    ,PROD_CL                --产品分类
    ,FIN_DEBT_SUM_CL        --金融债细类
    ,ISU_SUBJ_BIO_FLG       --发行主体境内境外标志
    ,ISU_SUBJ_RTG           --发行主体评级
    ,ISU_LAND_CTRY_CD       --发行地国家代码
    ,ISU_SIDE_FIN_ORG_TYP   --发行方金融机构类型
    ,BOND_RTG               --债券评级
    ,TERM                   --期限
    ,CUR                    --币种
    ,BILL_PAR_AMT           --票面金额
    ,BILL_PAR_INT_RATE      --票面利率
    ,COUPON_TYP             --息票类型
    ,RATE_FLT_STD           --利率浮动标准
    ,ISU_DT                 --发行日期
    ,VAL_DT                 --起息日期
    ,EXP_DT                 --到期日期
    ,ISU_PRC                --发行价格
    ,RCTLY_ASES_PRC         --最近评估价格
    ,ASES_DT                --评估日期
    ,RCTLY_FAIR_VAL         --最近公允价值
    ,RL_EST_ENT_ISU_FLG     --房地产企业发行标志
    ,BOND_RSK_CL            --债券风险分类
    ,BOND_ISU_MODE          --债券发行方式
    ,SUBST_FLG              --用于置换标志
    ,FLT_RATE_TYP           --浮动利率类型
    ,AST_SCRTZ_TYP          --资产证券化类型
    ,BOND_ISU_LAND          --债券发行地
    ,BOND_TYP_RSK           --债券类型（客户风险）
    ,INR_RTG                --内部评级
    ,BOND_GEN_TS_ORG        --债券总托管机构
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,CUSTM_BOND_ID          --自定义债券编号
    ,ASSET_TYPE_ID          --原始债券类型编号
    ,ASSET_NAME             --资产名称
    ,BOND_TYPE_CD           --债券类型代码 --ADD BY MW 20221116
    ,BOND_MAIN_TYPE         --债券主体类型
    ,ISSUER_NAME            --发行人名称
    ,CN_NAME                --发行人中文名称
    ,BOND_ISU_MODE_WIND     --万德债券发行方式
    ,CTY_CD                 --国别
    ,ID                     --主键
    ,MARKET_TYPE_ID         --市场类型编号
    ,RATING_REST_CD         --债券评级代码add by hulj20231024
    ,ESTATE_BOND_TYPE_NAME  --房地产债券类型名称 add by hulj20231129
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')        AS DATA_DT               --数据日期
        ,A.LP_ID                             AS LGL_REP_ID            --法人编号
        ,S.ENTRY_ORG_ID                      AS ORG_ID                --机构编号
        ,A.BOND_ID                           AS BOND_ID               --债券编号
        ,A.BOND_NAME                         AS PROD_NM               --产品名称
        ,CASE WHEN E1.B_INFO_FULLNAME LIKE '%专项%' THEN 'B0201'
              WHEN E1.B_INFO_FULLNAME LIKE '%一般%' THEN 'B0202'
              ELSE TA.TAR_VALUE_CODE
          END                                AS PROD_CL               --产品分类
        ,NULL                                AS FIN_DEBT_SUB_CL       --金融债细类
        ,CASE WHEN A.ISSUE_MAIN_BELONG_CTY_RG_CD = 'CHN' THEN 'Y'
              ELSE 'N'
          END                                AS ISU_SUBJ_BIO_FLG      --发行主体境内境外标志
        ,CASE WHEN T4.RATING_REST_CD IS NULL THEN 'C00'
              ELSE TD.TAR_VALUE_CODE
          END                                AS ISU_SUBJ_RTG          --发行主体评级
        ,A.ISSUE_MAIN_BELONG_CTY_RG_CD       AS ISU_LAND_CTRY_CD      --发行地国家代码
        ,NULL                                AS ISU_SIDE_FIN_ORG_TYP  --发行方金融机构类型
        ,DECODE(NVL(C.RATING_REST_CD,'C00'),'AAA','C01','AA+','C02','AA','C03','AA-','C04','A+','C05','A','C06','A-','C07','BBB+','C08','BBB','C09','BBB-','C10','BB+','C11','BB',
                                        'C12','BB-','C13','B+','C14','B','C15','B-','C16','CCC+','C17','CCC','C18','CCC-','C19','CC','C20','C','C21','D','C22','A-1','C23','A-2',
                                        'C24','A-3','C25','C00','C00','无','C00','C99')                   
                                             AS BOND_RTG              --债券评级
        ,NULL                                AS TERM                  --期限
        ,A.CURR_CD                           AS CUR                   --币种
        ,B.CERT_FACE_TOT                     AS BILL_PAR_AMT          --票面金额
        ,A.FAC_VAL_INT_RAT                   AS BILL_PAR_INT_RATE     --票面利率
        ,A.INT_RAT_ADJ_WAY_CD                AS COUPON_TYP            --息票类型
        ,NULL                                AS RATE_FLT_STD          --利率浮动标准
        ,TO_CHAR(A.ISSUE_DT,'YYYYMMDD')      AS ISU_DT                --发行日期
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')      AS VAL_DT                --起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')        AS EXP_DT                --到期日期
        ,A.ISSUE_PRICE                       AS ISU_PRC               --发行价格
        ,NULL                                AS RCTLY_ASES_PRC        --最近评估价格
        ,NULL                                AS ASES_DT               --评估日期
        ,NULL                                AS RCTLY_FAIR_VAL        --最近公允价值
        ,NULL                                AS RL_EST_ENT_ISU_FLG    --房地产企业发行标志
        ,NULL                                AS BOND_RSK_CL           --债券风险分类
        ,NVL(TB.TAR_VALUE_CODE,'B')          AS BOND_ISU_MODE         --债券发行方式
        ,NULL                                AS SUBST_FLG             --用于置换标志
        ,CASE WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD <= 0.15 THEN 'A'
              WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD <= 0.3 THEN 'B'
              WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD > 0.3 THEN 'C'
              WHEN A.BOND_ID IN ('1563010','1563039','1563040','1543010','1572003') THEN 'A'
          END                                AS FLT_RATE_TYP          --浮动利率类型
        ,NULL                                AS AST_SCRTZ_TYP         --资产证券化类型
        ,A.ISSUE_RG_CD                       AS BOND_ISU_LAND         --债券发行地
        ,A.BOND_TYPE_CD                      AS BOND_TYP_RSK          --债券类型（客户风险）
        ,C.RATING_REST_CD                    AS INR_RTG               --内部评级
        ,CASE WHEN A.TRUST_ORG_ID = '01' THEN '400'
              WHEN A.TRUST_ORG_ID IN ('02','03','13') THEN '900' --update 20240909  tzj数仓新增托管机构代码13-中国证券登记结算有限责任公司北京分公司
              WHEN A.TRUST_ORG_ID = '04' THEN '300'
              ELSE '000'
          END                                AS BOND_GEN_TS_ORG       --债券总托管机构
        ,'800919'                            AS DEPT_LINE             --部门条线
        ,'资金债券'                          AS DATA_SRC              --数据来源
        ,S.CUSTM_BOND_ID                     AS CUSTM_BOND_ID         --自定义债券编号 --20221017 XUXIAOBIN ADD
        ,A.BOND_TYPE_CD                      AS ASSET_TYPE_ID         --原始债券类型代码
        ,M.PRODUCT_TYPE_NAME                 AS ASSET_NAME            --资产名称
        ,A.BOND_TYPE_CD                      AS BOND_TYPE_CD          --债券类型代码  --ADD BY MW 20221116
        ,D1.S_INFO_COMPTYPE                  AS BOND_MAIN_TYPE        --债券主体类型
        ,A.ISSUER_NAME                       AS ISSUER_NAME           --发行人名称
        ,E.CN_NAME                           AS CN_NAME               --中文名称
        ,E1.B_INFO_ISSUETYPE                 AS BOND_ISU_MODE_WIND    --万德债券发行方式
        ,NVL(REPLACE(TRIM(C1.S_INFO_COUNTRYCODE),'CN','CHN'),'CHN')   --国别
        ,A.BOND_ID||'.'||A.ASSET_TYPE_ID||'.'||A.BOND_MARKET_TYPE_CD AS ID --主键
        ,A.ASSET_TYPE_ID||'_'||A.BOND_MARKET_TYPE_CD AS MARKET_TYPE_ID  --市场类型编号 
        ,CASE WHEN C.RATING_REST_CD IS NULL THEN 'C00'
              ELSE P.SRC_VALUE_CODE
          END                                AS RATING_REST_CD        --债券评级代码 ADD BY HULJ20231024
        ,A.ESTATE_BOND_TYPE_NAME             AS ESTATE_BOND_TYPE_NAME --房地产债券类型名称 ADD BY HULJ20231129
    FROM RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO A --债券基本信息
    LEFT JOIN RRP_MDL.O_IML_EVT_BOND_ISSUE_TRAN_DTL B --债券发行交易明细
      ON B.BOND_ID = A.BOND_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_BOND_ISSUER_INFO E --债券发行人信息 --MDF BY HAP 20201012 用表资金交易对手信息表的话有部分关联不上
      ON E.ISSUER_ID = A.ISSUER_CD
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_BOND_ISSUER_INFO F--债券发行人信息
      ON F.ISSUER_ID = NVL(TRIM(E.ISSUER_ID),'-')
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT S.BOND_ID,S.ENTRY_ORG_ID,S.CUSTM_BOND_ID,ROW_NUMBER() OVER(PARTITION BY BOND_ID ORDER BY S.ISSUE_DT DESC)RN
                 FROM RRP_MDL.O_ICL_CMM_CAP_BOND_INVEST S
                WHERE S.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) S --资金债券投资表 add by hap 20210819取机构号
      ON S.BOND_ID = A.BOND_ID
     AND S.RN = 1
    LEFT JOIN (SELECT ETL_DT,BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD,RATING_REST_CD
                     ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) AS RN
                 FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO  --债券评级信息表
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) C
      ON C.BOND_ID = A.BOND_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.BOND_MARKET_TYPE_CD = A.BOND_MARKET_TYPE_CD
     AND C. RN = 1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP TA --产品类别转码
      ON TA.SRC_VALUE_CODE = A.BOND_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1486'
     AND TA.TAR_CLASS_CODE = 'T0018'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.ADD_BOND_TYPE_CD M --债券类型代码表 add by hyf
      ON M.PRODUCT_TYPE_CODE = A.BOND_TYPE_CD
    LEFT JOIN RRP_MDL.CODE_MAP TB --发行方式转码
      ON TB.SRC_VALUE_CODE =B.ISSUE_STATUS_CD
     AND TB.SRC_CLASS_CODE = 'CD2021'
     AND TB.TAR_CLASS_CODE = 'D0068'
     AND TB.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.ISSUER_CUST_ID,T.RATING_REST_CD,ROW_NUMBER()OVER (PARTITION BY ISSUER_CUST_ID 
                      ORDER BY (CASE WHEN RATING_DT IS NULL THEN TO_DATE('19000101','YYYYMMDD') ELSE RATING_DT END),
                      SORC_SYS_CD DESC,RATING_REST_CD DESC) RN --加SORC_SYS_CD\RATING_REST_CD使数据固定，20240611 by tzj
                 FROM RRP_MDL.O_ICL_CMM_ISSUER_RATING_INFO T
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T4
      ON T4.ISSUER_CUST_ID = A.ISSUER_CUST_ID
     AND T4.RN = 1
    LEFT JOIN RRP_MDL.CODE_MAP TD --发行人主体评级转码
      ON TD.SRC_VALUE_CODE = NVL(T4.RATING_REST_CD,'无评级')
     AND TD.SRC_CLASS_CODE ='CD1850'
     AND TD.TAR_CLASS_CODE = 'D0062'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IOL_WIND_WINDCUSTOMCODE C1  --Wind兼容代码
      ON C1.S_INFO_WINDCODE = REGEXP_REPLACE(A.BOND_ID,'[^0-9]','')||'.'||
                              DECODE(A.BOND_MARKET_TYPE_CD,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')--债券编号去了非数字处理20201113 by hap
     AND C1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND C1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY IS_FIN_INST DESC) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDISSUER T) D1 --中国债券主体表 --mdf by hap 20200928
      ON D1.S_INFO_WINDCODE = REGEXP_REPLACE(A.BOND_ID,'[^0-9]','')||'.'||
                              DECODE(A.BOND_MARKET_TYPE_CD,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')
     AND D1.RN = 1 --mdf by hap 20200928
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY B_ISSUE_FIRSTISSUE) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDDESCRIPTION T) E1 --中国债券基本资料表 --mdf by hap 2021112
      ON E1.S_INFO_WINDCODE = REGEXP_REPLACE(A.BOND_ID,'[^0-9]','')||'.'||
                              DECODE(A.BOND_MARKET_TYPE_CD,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')
     AND E1.B_INFO_ISSUERCODE = D1.S_INFO_COMPCODE
     AND E1.RN = 1 --mdf by hap 20201112
    LEFT JOIN (SELECT TRADE_DT, --交易日期
                      NVL(TO_CHAR(TO_DATE(LAG(TRADE_DT,1)  OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY TRADE_DT DESC),'YYYYMMDD')-1,'YYYYMMDD'),TO_CHAR(SYSDATE,'YYYYMMDD')) MAX_DAY, --当期上限日期
                      B_ANAL_CURVETERM, --标准期限（年）
                      B_ANAL_YIELD, --收益率（%）
                      (LEAD(B_ANAL_YIELD, 1) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前一天
                      +LEAD(B_ANAL_YIELD, 2) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前两天
                      +LEAD(B_ANAL_YIELD, 3) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前三天
                      +LEAD(B_ANAL_YIELD, 4) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前四天
                      +LEAD(B_ANAL_YIELD, 5) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前五天
                      ) / 5 B_AVG_YIELD --每日平均收益率（取前五天的平均值为当天）
                 FROM RRP_MDL.O_IOL_WIND_CBONDCURVECNBD --中债登债券收益率曲线
                WHERE B_ANAL_CURVETERM > 0
                  AND B_ANAL_CURVETERM - TRUNC(B_ANAL_CURVETERM) = 0 --取整
              ) WIND
      ON A.VALUE_DT BETWEEN TO_DATE(WIND.TRADE_DT,'YYYYMMDD') AND TO_DATE(WIND.MAX_DAY,'YYYYMMDD')
     AND WIND.B_ANAL_CURVETERM = (CASE WHEN A.TENOR LIKE '%Y%' THEN TO_NUMBER(REPLACE(A.TENOR,'Y',''))
                                       WHEN A.TENOR LIKE '%D%' THEN (CASE WHEN TO_NUMBER(REPLACE(A.TENOR,'D','')) < 360
                                                                          THEN CEIL(REPLACE(A.TENOR,'D','')/360)
                                                                          WHEN TO_NUMBER(REPLACE(A.TENOR,'D',''))>=360
                                                                          THEN TRUNC(TO_NUMBER(REPLACE(A.TENOR,'D',''))/360)
                                                                      END)
                                   END) --期限
    LEFT JOIN RRP_MDL.CODE_MAP P
      ON P.SRC_VALUE_NAME = NVL(C.RATING_REST_CD,'无评级')
     AND P.SRC_CLASS_CODE = 'D0062'
     AND P.TAR_CLASS_CODE = 'D0062'
   WHERE A.BOND_TYPE_CD <> 'W'
     AND A.DATA_SRC_SYS_IDF = 'CTMS'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '债券基础信息';
  V_STARTTIME := SYSDATE;
  /***************同业系统*****************/
  INSERT INTO RRP_MDL.M_FIN_INST_BOND_INFO
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ORG_ID                 --机构编号
    ,BOND_ID                --债券编号
    ,PROD_NM                --产品名称
    ,PROD_CL                --产品分类
    ,FIN_DEBT_SUM_CL        --金融债细类
    ,ISU_SUBJ_BIO_FLG       --发行主体境内境外标志
    ,ISU_SUBJ_RTG           --发行主体评级
    ,ISU_LAND_CTRY_CD       --发行地国家代码
    ,ISU_SIDE_FIN_ORG_TYP   --发行方金融机构类型
    ,BOND_RTG               --债券评级
    ,TERM                   --期限
    ,CUR                    --币种
    ,BILL_PAR_AMT           --票面金额
    ,BILL_PAR_INT_RATE      --票面利率
    ,COUPON_TYP             --息票类型
    ,RATE_FLT_STD           --利率浮动标准
    ,ISU_DT                 --发行日期
    ,VAL_DT                 --起息日期
    ,EXP_DT                 --到期日期
    ,ISU_PRC                --发行价格
    ,RCTLY_ASES_PRC         --最近评估价格
    ,ASES_DT                --评估日期
    ,RCTLY_FAIR_VAL         --最近公允价值
    ,RL_EST_ENT_ISU_FLG     --房地产企业发行标志
    ,BOND_RSK_CL            --债券风险分类
    ,BOND_ISU_MODE          --债券发行方式
    ,SUBST_FLG              --用于置换标志
    ,FLT_RATE_TYP           --浮动利率类型
    ,AST_SCRTZ_TYP          --资产证券化类型
    ,BOND_ISU_LAND          --债券发行地
    ,BOND_TYP_RSK           --债券类型（客户风险）
    ,INR_RTG                --内部评级
    ,BOND_GEN_TS_ORG        --债券总托管机构
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,ASSET_TYPE_ID          --原始债券类型代码
    ,ASSET_NAME             --资产名称
    ,BOND_TYPE_CD           --债券类型代码
    ,BOND_MAIN_TYPE         --债券主体类型
    ,ISSUER_NAME            --发行人名称
    ,CN_NAME                --发行人中文名称
    ,BOND_ISU_MODE_WIND     --万德债券发行方式
    ,CTY_CD                 --国别
    ,ID                     --主键
    ,MARKET_TYPE_ID         --市场类型编号
    ,RATING_REST_CD         --债券评级代码
    ,ESTATE_BOND_TYPE_NAME  --房地产债券类型名称 add by hulj20231129
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')           AS DATA_DT               --数据日期
        ,A.LP_ID                                AS LGL_REP_ID            --法人编号
        ,NVL(B.BELONG_ORG_ID,A.BELONG_ORG_ID)   AS ORG_ID                --机构编号
        ,A.FIN_INSTM_ID                         AS BOND_ID               --债券编号
        ,A.BOND_NAME                            AS PROD_NM               --产品名称--20221013 XUXIAOBIN 业务孙若真 提议修改
        ,CASE WHEN A.ASSET_TYPE_NAME LIKE '%其他债券%' OR A.ASSET_TYPE_NAME LIKE '%私募债%'
                OR A.ASSET_TYPE_NAME LIKE '%公司债%' THEN 'C02'
              WHEN A.ASSET_TYPE_NAME LIKE '%企业债%' THEN 'C01'
              WHEN A.ASSET_TYPE_NAME LIKE '%资产支持%' THEN 'D02'
              WHEN E1.B_INFO_FULLNAME LIKE '%专项%' THEN 'B0201'
              WHEN E1.B_INFO_FULLNAME LIKE '%一般%' THEN 'B0202'
              ELSE TA.TAR_VALUE_CODE
          END                                   AS PROD_CL               --产品分类 -- XUXIAOBIN 20221013 XUXIAOBIN JS MODIFY
        ,NULL                                   AS FIN_DEBT_SUB_CL       --金融债细类
        ,'Y'                                    AS ISU_SUBJ_BIO_FLG      --发行主体境内境外标志
        ,CASE WHEN T4.RATING_REST_CD IS NULL THEN 'C00'
              ELSE TD.TAR_VALUE_CODE
          END                                   AS ISU_SUBJ_RTG          --发行主体评级
        ,B1.ISSUE_MAIN_BELONG_CTY_RG_CD         AS ISU_LAND_CTRY_CD      --发行地国家代码
        ,T2.FIN_INST_CATE_CD                    AS ISU_SIDE_FIN_ORG_TYP  --发行方金融机构类型
        ,DECODE(NVL(B2.RATING_REST_CD,'C00'),'AAA','C01','AA+','C02','AA','C03','AA-','C04','A+','C05','A','C06','A-','C07','BBB+','C08','BBB','C09','BBB-','C10','BB+','C11','BB',
                'C12','BB-','C13','B+','C14','B','C15','B-','C16','CCC+','C17','CCC','C18','CCC-','C19','CC','C20','C','C21','D','C22','A-1','C23','A-2',
                'C24','A-3','C25','C00','C00','无','C00','C99')
                                                AS BOND_RTG              --债券评级
        ,CASE WHEN B.TENOR_CD LIKE '%Y%' THEN REPLACE(B.TENOR_CD,'Y','') * 12
              WHEN B.TENOR_CD LIKE '%D%'
              THEN CEIL(REPLACE(B.TENOR_CD,'D','') / 30)
          END                                   AS TERM                  --期限
        ,B.CURR_CD                              AS CUR                   --币种
        ,B.FAC_VAL_AMT                          AS BILL_PAR_AMT          --票面金额
        ,B.FAC_VAL_INT_RAT                      AS BILL_PAR_INT_RATE     --票面利率
        ,B.INT_RAT_ADJ_WAY_CD                   AS COUPON_TYP            --息票类型
        ,NULL                                   AS RATE_FLT_STD          --利率浮动标准
        ,TO_CHAR(A.ISSUE_DT,'YYYYMMDD')         AS ISU_DT                --发行日期
        ,TO_CHAR(B.VALUE_DT,'YYYYMMDD')         AS VAL_DT                --起息日期
        ,TO_CHAR(B.EXP_DT,'YYYYMMDD')           AS EXP_DT                --到期日期
        ,B1.ISSUE_PRICE                         AS ISU_PRC               --发行价格
        ,NULL                                   AS RCTLY_ASES_PRC        --最近评估价格
        ,NULL                                   AS ASES_DT               --评估日期
        ,NULL                                   AS RCTLY_FAIR_VAL        --最近公允价值
        ,NULL                                   AS RL_EST_ENT_ISU_FLG    --房地产企业发行标志
        ,NULL                                   AS BOND_RSK_CL           --债券风险分类
        ,TB.TAR_VALUE_CODE                      AS BOND_ISU_MODE         --债券发行方式
        ,NULL                                   AS SUBST_FLG             --用于置换标志
        ,CASE WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD <= 0.15 THEN 'A'
              WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD <= 0.3 THEN 'B'
              WHEN (A.FAC_VAL_INT_RAT - WIND.B_AVG_YIELD)/WIND.B_AVG_YIELD > 0.3 THEN 'C'
              WHEN A.FIN_INSTM_ID IN ('1563010','1563039','1563040','1543010','1572003') THEN 'A'
          END                                   AS FLT_RATE_TYP          --浮动利率类型
        ,NULL                                   AS AST_SCRTZ_TYP         --资产证券化类型
        ,B1.ISSUE_RG_CD                         AS BOND_ISU_LAND         --债券发行地
        ,B1.BOND_TYPE_CD                        AS BOND_TYP_RSK          --债券类型（客户风险）
        ,B2.RATING_REST_CD                      AS INR_RTG               --内部评级
        ,CASE WHEN B1.TRUST_ORG_ID = '01' THEN '400'
              WHEN B1.TRUST_ORG_ID IN ('02','03','13') THEN '900' --update 20240909  tzj数仓新增托管机构代码13-中国证券登记结算有限责任公司北京分公司
              WHEN B1.TRUST_ORG_ID = '04' THEN '300'
              ELSE '000'
          END                                   AS BOND_GEN_TS_ORG       --债券总托管机构20221013 xuxiaobin modify
        ,NULL                                   AS DEPT_LINE             --部门条线
        ,'同业债券'                             AS DATA_SRC              --数据来源
        ,B1.BOND_TYPE_CD                        AS ASSET_TYPE_ID         --原始债券类型代码
        ,B1.BOND_CLS_NAME                       AS ASSET_NAME            --资产名称 20221121 XUXIAOBIN MODIFY 产品名称以债券基本信息比较正确
        ,B1.BOND_TYPE_CD                        AS BOND_TYPE_CD          --债券类型
        ,D.S_INFO_COMPTYPE                      AS BOND_MAIN_TYPE        --债券主体类型
        ,B1.ISSUER_NAME                         AS ISSUER_NAME           --发行人名称
        ,F.CN_NAME                              AS CN_NAME               --发行人中文名称
        ,E1.B_INFO_ISSUETYPE                    AS BOND_ISU_MODE_WIND    --万德债券发行方式
        ,NVL(B.CTY_CD,'CHN')                    AS CTY_CD                --国别代码
        ,A.FIN_INSTM_ID||'.'||A.MARKET_TYPE_ID  AS ID                    --主键
        ,A.MARKET_TYPE_ID                       AS MARKET_TYPE_ID        --市场类型编号 
        ,CASE WHEN C.RATING_REST_CD IS NULL THEN 'C00' 
              ELSE P.SRC_VALUE_CODE
          END                                   AS RATING_REST_CD        --债券评级代码
        ,B1.ESTATE_BOND_TYPE_NAME AS ESTATE_BOND_TYPE_NAME --房地产债券类型名称 add by hulj20231129
    FROM (SELECT ROW_NUMBER() OVER(PARTITION BY T.FIN_INSTM_ID,T.ASSET_TYPE_ID,T.MARKET_TYPE_ID ORDER BY T.LAST_UPDATE_DT DESC)RN,T.*
            FROM RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST T
           WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) A   --同业债券投资表
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM B  --同业金融工具表
      ON B.FIN_INSTM_ID||'.'||B.MARKET_TYPE_ID = A.FIN_INSTM_ID||'.'||A.MARKET_TYPE_ID
     AND B.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B1--债券基本信息 ADD BY HAP 20210819 取托管机构
      ON B1.BOND_ID||'.'||B1.BOND_MARKET_TYPE_CD = A.FIN_INSTM_ID||'.'||A.MARKET_TYPE_ID
     AND B1.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT ETL_DT,BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD,RATING_REST_CD
                     ,ROW_NUMBER() OVER(PARTITION BY BOND_ID,ASSET_TYPE_ID,BOND_MARKET_TYPE_CD ORDER BY RATING_DT DESC) AS RN
                 FROM RRP_MDL.O_ICL_CMM_BOND_RATING_INFO
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) C  --债券评级信息表
      ON C.BOND_ID = B1.BOND_ID
     AND C.ASSET_TYPE_ID = B1.ASSET_TYPE_ID
     AND C.BOND_MARKET_TYPE_CD = B1.BOND_MARKET_TYPE_CD
     AND C. RN = 1
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP P
      ON P.SRC_VALUE_NAME = NVL(C.RATING_REST_CD,'无评级')
     AND P.SRC_CLASS_CODE = 'D0062'
     AND P.TAR_CLASS_CODE = 'D0062'
    LEFT JOIN RRP_MDL.O_IML_PTY_BOND_ISSUER_INFO E -- 债券发行人信息
      ON E.ISSUER_ID = B1.ISSUER_CD
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_PTY_BOND_ISSUER_INFO F --债券发行人信息
      ON F.ISSUER_ID = NVL(TRIM(E.ISSUER_ID),'-')
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT T.ISSUER_CUST_ID,T.RATING_REST_CD,ROW_NUMBER()OVER (PARTITION BY ISSUER_CUST_ID
                      ORDER BY (CASE WHEN RATING_DT IS NULL THEN TO_DATE('19000101','YYYYMMDD') ELSE RATING_DT END),
                      SORC_SYS_CD DESC,RATING_REST_CD DESC) RN --加SORC_SYS_CD\RATING_REST_CD使数据固定，20240611 by tzj
                 FROM RRP_MDL.O_ICL_CMM_ISSUER_RATING_INFO T
                WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) T4
      ON T4.ISSUER_CUST_ID = A.ISSUER_CUST_ID
     AND T4.RN = 1
    LEFT JOIN RRP_MDL.CODE_MAP TD --发行人主体评级转码
      ON TD.SRC_VALUE_CODE = NVL(T4.RATING_REST_CD,'无评级')
     AND TD.SRC_CLASS_CODE ='CD1850'
     AND TD.TAR_CLASS_CODE = 'D0062'
     AND TD.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TA --产品类别转码
      ON TA.SRC_VALUE_CODE = B1.BOND_TYPE_CD
     AND TA.SRC_CLASS_CODE = 'CD1486'
     AND TA.TAR_CLASS_CODE = 'T0018'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP TB --发行方式转码
      ON TA.SRC_VALUE_CODE =A.ISSUE_WAY_CD
     AND TA.SRC_CLASS_CODE = 'CD2021'
     AND TA.TAR_CLASS_CODE = 'D0068'
     AND TA.MOD_FLG = 'MDM'
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY IS_FIN_INST DESC) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDISSUER T
                WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) D --中国债券主体表
      ON D.S_INFO_WINDCODE = REGEXP_REPLACE(A.FIN_INSTM_ID,'[^0-9]','')||'.'||
                             DECODE(A.MARKET_TYPE_ID,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')
     AND D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.RN = 1
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY ANN_DT DESC) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDRATING T)E --中国债券信用评级表
      ON E.S_INFO_WINDCODE = REGEXP_REPLACE(A.FIN_INSTM_ID,'[^0-9]','')||'.'||
                             DECODE(A.MARKET_TYPE_ID,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')
     AND E.RN = 1
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_WINDCODE ORDER BY B_ISSUE_FIRSTISSUE) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDDESCRIPTION T) E1  --中国债券基本资料表
      ON E1.S_INFO_WINDCODE = REGEXP_REPLACE(A.FIN_INSTM_ID,'[^0-9]','')||'.'||
                              DECODE(A.MARKET_TYPE_ID,'XSHG','SH','XSHE','SZ','X_CNBD','IB','DXFX','IB')
     AND E1.B_INFO_ISSUERCODE = D.S_INFO_COMPCODE
     AND E1.RN = 1 --mdf by hap 20201112
    LEFT JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY S_INFO_COMPCODE ORDER BY ANN_DT DESC) AS RN
                 FROM RRP_MDL.O_IOL_WIND_CBONDISSUERRATING T --中国债券发行主体信用评级表
                 WHERE T.ANN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) G --UPDATE BY YJY 20260417  
      ON G.S_INFO_COMPCODE = D.S_INFO_COMPCODE
     AND G.RN = 1
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CUST_CHAT_INFO T2
      ON T2.PARTY_ID= NVL(NVL(SUBSTR(TRIM(A.ISSUER_CUST_ID),1,INSTR(TRIM(A.ISSUER_CUST_ID),'、')-1),TRIM(A.ISSUER_CUST_ID)),A.ISSUER_ID)
     AND T2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    --根据G18_III新增中债登债券收益率表取每日平均收益率
    LEFT JOIN (SELECT TRADE_DT, --交易日期
                      NVL(TO_CHAR(TO_DATE(LAG(TRADE_DT,1)  OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY TRADE_DT DESC),'YYYYMMDD')-1,'YYYYMMDD'),TO_CHAR(SYSDATE,'YYYYMMDD')) MAX_DAY, --当期上限日期
                      B_ANAL_CURVETERM, --标准期限（年）
                      B_ANAL_YIELD, --收益率（%）
                      (LEAD(B_ANAL_YIELD, 1) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前一天
                      +LEAD(B_ANAL_YIELD, 2) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前两天
                      +LEAD(B_ANAL_YIELD, 3) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前三天
                      +LEAD(B_ANAL_YIELD, 4) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前四天
                      +LEAD(B_ANAL_YIELD, 5) OVER(PARTITION BY B_ANAL_CURVETERM ORDER BY B_ANAL_CURVETERM,TRADE_DT DESC) --前五天
                       ) / 5 B_AVG_YIELD --每日平均收益率（取前五天的平均值为当天）
                 FROM RRP_MDL.O_IOL_WIND_CBONDCURVECNBD --中债登债券收益率曲线
                WHERE B_ANAL_CURVETERM > 0
                  AND B_ANAL_CURVETERM - TRUNC(B_ANAL_CURVETERM) = 0 --取整
               ) WIND -- 20210915由肖学良根据G18_III新增中债登债券收益率取每日平均收益率
      ON A.VALUE_DT BETWEEN TO_DATE(WIND.TRADE_DT,'YYYYMMDD') AND TO_DATE(WIND.MAX_DAY,'YYYYMMDD')
     AND WIND.B_ANAL_CURVETERM = (CASE WHEN B.TENOR_CD LIKE '%Y%' THEN TO_NUMBER(REPLACE(B.TENOR_CD,'Y',''))
                                       WHEN B.TENOR_CD LIKE '%D%' THEN (CASE WHEN TO_NUMBER(REPLACE(B.TENOR_CD,'D','')) < 360
                                                                             THEN CEIL(REPLACE(B.TENOR_CD,'D','')/360)
                                                                             WHEN TO_NUMBER(REPLACE(B.TENOR_CD,'D',''))>=360
                                                                             THEN TRUNC(TO_NUMBER(REPLACE(B.TENOR_CD,'D',''))/360)
                                                                         END)
                                   END)  --期限
    LEFT JOIN  (SELECT I_CODE AS BOND_ID,S_GRADE AS RATING_REST_CD,A_TYPE AS ASSET_TYPE_ID,M_TYPE AS BOND_MARKET_TYPE_CD
                      ,ROW_NUMBER() OVER(PARTITION BY I_CODE,A_TYPE,M_TYPE ORDER BY S_GRADE ASC) AS RN
                  FROM RRP_MDL.O_IOL_IBMS_TINSTRUMENT_INST_GRADE
                 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) B2  --债券评级信息表
      ON B2.BOND_ID||'.'||B2.BOND_MARKET_TYPE_CD = B1.BOND_ID||'.'||B1.BOND_MARKET_TYPE_CD
     AND B2.ASSET_TYPE_ID = B1.ASSET_TYPE_ID
     AND B2.RN = 1
   WHERE A.RN = 1;

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
    SELECT DATA_DT,BOND_ID,PROD_NM,ID,COUNT(1)
      FROM RRP_MDL.M_FIN_INST_BOND_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,BOND_ID,PROD_NM,ID
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

END ETL_M_FIN_INST_BOND_INFO;
/

