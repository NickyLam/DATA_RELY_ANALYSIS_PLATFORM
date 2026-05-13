CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_GUA_COLL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_GUA_COLL_INFO
  *  功能描述：抵质押物详细信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_GUA_COLL_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221114  HULJ     增加数据重复校验
  *             3    20221118  XUCX     增加字段取押品入库状态
  *             4    20221118  XUCX     修改数据范围 修改筛选条件和INNER JOIN
  *             5    20221118  XUCX     增加字段取数仓押品类型代码
  *             6    20221125  XUCX     增加字段取存单凭证编号
  *             7    20230210  HULJ     增加字段首次评估日期(客户风险)
  *             8    20230830  LIP      增加权证号码的取数来源
  *             9    20240311  YJY      增加字段保证人类型代码(客户风险)
  *             10   20250708  LIP      资产池明细押品对应的所有人信息取池对应的所有人信息
  *             11   20251013  YJY      1、下线O_IOL_MIMS_SI_VALUEINFOHIS，替换为O_IML_AST_COL_VAL_INFO_H押品价值信息历史
                                        2、下线O_IML_AST_COL_TYPE_DEF，替换为O_IOL_ICMS_CLR_PARAM押品分类参数
                                        3、调整估值周期的码值映射逻辑
  *             12   20251107  YJY      修改评估日期的取值
  *             13   20251203  YJY      对评估日期中的00010101、20991231的数据进行置换
  *             14   20251208  YJY      一表通要求如果评估认定日期仅大于数据日期一天，则用数据日期进行兜底
  *             15   20260107  YJY      上游评估基准日存在时分秒的情况，优化评估日期字段，对日期进行转换
  *             16   20260303  LIP      因资产池会删除数据，调整资产池取所有人信息时不卡时间范围，并调整排序逻辑
  *********************************************************************/
AS
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE := SYSDATE;            --处理开始时间
  V_ENDTIME   DATE := SYSDATE;            --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_GUA_COLL_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_GUA_COLL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入抵质押物详细信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_GUA_COLL_INFO
    (DATA_DT     					   --01数据日期
    ,LGL_REP_ID  					   --02法人编号
    ,COLL_ID     					   --03押品编号
    ,CUST_ID     					   --04客户编号
    ,ORG_ID      					   --05机构编号
    ,COLL_TYP    					   --06押品类型
    ,COLL_NM     					   --07押品名称
    ,CUR         					   --08币种
    ,COLL_ORIG_VAL  		     --09押品原始价值
    ,INIT_VALT      		     --10起始估值
    ,BANK_IDNT_PRC_VAL       --11银行认定价值
    ,ALDY_MTG_VAL            --12已抵押价值
    ,ASES_VAL                --13评估价值
    ,ASES_DT                 --14评估日期
    ,ASES_ORG_NM             --15评估机构名称
    ,FIRST_VALT_DT           --16首次估值日期
    ,VALT_EXP_DT             --17估值到期日期
    ,REGD_ORG_ID             --18登记机构
    ,OPR_ORG_ID              --19操作机构编号
    ,COLL_EFF_DT             --20押品生效日期
    ,COLL_EXP_DT             --21押品到期日期
    ,PLG_TKT_ACC             --22质押票证账号
    ,PLG_TKT_TYP             --23质押票证类型
    ,PLG_TKT_NO              --24质押票证号码
    ,PLG_TKT_AMT             --25质押票证金额
    ,PLG_TKT_ISU_ORG_ID      --26质押票证签发机构
    ,PLG_TKT_ESTM_DT         --27质押票证开立日期
    ,WRNT_REGD_NO            --28权证登记号码
    ,WRNT_NM                 --29权证名称
    ,WRNT_VALID_EXP_DT       --30权证有效到期日期
    ,REGD_VALID_END_DT       --31登记有效终止日期
    ,COLL_CUST_RSK_RTG_CL    --32担保品客户风险评级分类
    ,DIR_ACQ_FLG             --33定向收购标志
    ,QUAL_MTGN_FLG           --34合格缓释品标志
    ,RE_MTG_PLG_FIN_COLL_FLG --35可再抵质押融资押品标志
    ,REGD_DT                 --36登记日期
    ,MTRL_OBJ_COLL_DT        --37实物收取日期
    ,ASES_MODE               --38评估方式
    ,ASES_METHOD             --39评估方法
    ,VALT_CYC                --40估值周期
    ,WRNT_REGD_AREA          --41权证登记面积
    ,COLL_OWNER_NM           --42押品所有人名称
    ,COLL_OWNER_CRDL_TYP     --43押品所有人证件类别
    ,COLL_OWNER_CRDL_NO      --44押品所有人证件号码
    ,TRD_COLL_OWNER_FLG      --45第三方押品权属人标志
    ,COLL_STAT               --46押品状态
    ,DEPT_LINE               --47部门条线
    ,DATA_SRC                --48数据来源
    ,INSTO_STATUS_CD         --49押品入库状态 ADD BY 20221118 XCX
    ,COL_TYPE_ID             --50数仓押品类型代码 ADD BY 20221118 XUCX
    ,HIGT_MTG_RAT            --51最高抵质押率
    ,PLG_EQTY_NUM            --52质押股权数量
    ,DEP_RCPT_VOUCH_ID       --53存单凭证编号 ADD BY 20221125 XUCX
    ,BELONG_CERT_NO          --54权属证件号码
    ,MTG_RAT                 --55抵质押率
    ,OBANK_SET_SEC_RIGHT_AMT --56他行设定担保权金额
    ,ESTIM_DT                --57首次评估日期(客户风险)
    ,PRIOR_COMP_WEIGHT_QTTY  --58优先受偿权数额
    ,COL_EXP_DT              --59押品到期日期
    ,GUARTOR_TYPE_CD         --60保证人类型代码
    )
    WITH COL_GUAR_CONT_RELA AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(C,D)*/
         C.COL_ID,MAX(D.CUST_ID) AS CUST_ID,
         MIN(D.EFFECT_DT) EFFECT_DT,MAX(D.EXP_DT) EXP_DT
    FROM RRP_MDL.O_ICL_CMM_COL_GUAR_CONT_RELA C --押品与担保合同关系
   INNER JOIN RRP_MDL.O_ICL_CMM_GUAR_CONT D
      ON D.GUAR_CONT_ID = C.GUAR_CONT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   GROUP BY C.COL_ID),
  COL_ALL_INFO_H AS (--对押品所有人去重
  SELECT /*+MATERIALIZE*/
         E.PROP_PS_ID
        ,E.PLEDGOR_CERT_NO
        ,E.PLEDGOR_CERT_TYPE_CD
        ,ROW_NUMBER() OVER(PARTITION BY E.PROP_PS_ID 
                           ORDER BY CASE WHEN E.PLEDGOR_CERT_TYPE_CD = '2313' THEN '1'
                                         ELSE E.PLEDGOR_CERT_TYPE_CD END) AS RN
    FROM RRP_MDL.O_ICL_CMM_COL_INFO E --押品信息
   WHERE NVL(E.PLEDGOR_CERT_NO,' ') <> ' '
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
  AST_COL_SPLT_RELA_H AS (--资产池明细押品对应的所有人信息取池对应的所有人信息 --ADD BY LIP 20250708
  SELECT /*+MATERIALIZE*/
          T1.POOL_ASSET_ID        AS POOL_ASSET_ID        --池资产编号
         ,T1.SUB_ASSET_ID         AS SUB_ASSET_ID         --子资产编号
         ,T2.PROP_PS_NAME         AS PROP_PS_NAME         --押品所有人名称
         ,T2.PLEDGOR_CERT_TYPE_CD AS PLEDGOR_CERT_TYPE_CD --押品所有人证件类别
         ,T2.PLEDGOR_CERT_NO      AS PLEDGOR_CERT_NO      --押品所有人证件号码
         --,ROW_NUMBER() OVER(PARTITION BY T1.SUB_ASSET_ID ORDER BY T1.POOL_ASSET_ID) RN
         ,ROW_NUMBER() OVER(PARTITION BY T1.SUB_ASSET_ID ORDER BY T1.START_DT DESC,T1.POOL_ASSET_ID) RN --MOD BY LIP 20260303
    FROM RRP_MDL.O_IML_AST_COL_SPLT_RELA_H T1
   INNER JOIN RRP_MDL.O_ICL_CMM_COL_INFO T2
      ON T2.COL_ID = T1.POOL_ASSET_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   /*WHERE T1.ID_MARK <> 'D'
     AND T1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/)
  SELECT DISTINCT
         V_P_DATE                                             AS DATA_DT     					   --01数据日期
        ,A.LP_ID                                              AS LGL_REP_ID              --02法人编号
        ,A.COL_ID                                             AS COLL_ID                 --03押品编号
        ,C.CUST_ID                                            AS CUST_ID                 --04客户编号
        ,A.ORG_ID                                             AS ORG_ID                  --05机构编号
        ,D.TAR_VALUE_CODE                                     AS COLL_TYP                --06押品类型
        ,CASE WHEN NVL(A.COL_NAME,' ') = ' ' THEN /*D.TAR_VALUE_CODE*/ D.SRC_VALUE_NAME  --MOD BY YJY 20251013
              ELSE A.COL_NAME
          END                                                 AS COLL_NMCOLL_NM          --07押品名称
        ,DECODE(A.ESTIM_CURR_CD,'-','CNY',A.ESTIM_CURR_CD)    AS CUR                     --08币种
        ,A.COL_VAL                                            AS COLL_ORIG_VAL           --09押品原始价值
        ,A.HXB_PA_CFM_VAL                                     AS INIT_VALT               --10起始估值
        ,A.HXB_CFM_VAL                                        AS BANK_IDNT_PRC_VAL       --11银行认定价值
        ,NVL(A.MTGED_VAL, 0)                                  AS ALDY_MTG_VAL            --12已抵押价值
        ,A.ESTIM_VAL                                          AS ASES_VAL                --13评估价值
        /*,CASE WHEN A.ESTIM_IDTFY_DT = TO_DATE('20991231','YYYYMMDD') THEN NULL
              ELSE TO_CHAR(A.ESTIM_IDTFY_DT,'YYYYMMDD')
          END                                                 AS ASES_DT                 --14评估日期*/
        --MOD BY YJY 20251107 评估认定日期大于统计日期时，取创建日期为评估日期
        ,CASE WHEN --A.ESTIM_IDTFY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
                   TO_CHAR(A.ESTIM_IDTFY_DT,'YYYYMMDD') <= V_P_DATE
               AND TO_CHAR(A.ESTIM_IDTFY_DT,'YYYYMMDD') NOT IN ('00010101','20991231') 
               --MOD BY YJY 20251208 一表通要求如果评估认定日期仅大于数据日期一天，则用数据日期进行兜底
              THEN CASE WHEN TO_CHAR(A.ESTIM_IDTFY_DT,'YYYYMMDD') = V_P_DATE + 1 THEN V_P_DATE
                        ELSE TO_CHAR(A.ESTIM_IDTFY_DT,'YYYYMMDD') END      
              --ELSE TO_CHAR(A.SETUP_DT,'YYYYMMDD')
              WHEN TO_CHAR(A.SETUP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
              THEN TO_CHAR(A.SETUP_DT,'YYYYMMDD') --MOD BY YJY 20251203
          END                                                 AS ASES_DT                 --14评估日期
        ,A.ESTIM_ORG_NAME                                     AS ASES_ORG_NM             --15评估机构名称
        /*,F.FIRST_ESTIM_DT                                     AS FIRST_VALT_DT           --16首次估值日期*/  
        --MOD BY YJY 20251107 评估认定日期大于统计日期时，取创建日期为评估日期
        ,CASE WHEN F.FIRST_ESTIM_DT <= V_P_DATE AND F.FIRST_ESTIM_DT NOT IN ('00010101','20991231')
              THEN F.FIRST_ESTIM_DT
              --ELSE TO_CHAR(A.SETUP_DT,'YYYYMMDD')
              WHEN TO_CHAR(A.SETUP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
              THEN TO_CHAR(A.SETUP_DT,'YYYYMMDD')  --MOD BY YJY 20251203
         END                                                  AS FIRST_VALT_DT           --16首次估值日期
        ,TO_CHAR(A.ESTIM_EXP_DT,'YYYYMMDD')                   AS VALT_EXP_DT             --17估值到期日期
        ,A.RGST_ORG_NAME                                      AS REGD_ORG_ID             --18登记机构
        ,A.OPER_ORG_ID                                        AS OPR_ORG_ID              --19操作机构编号
        --MOD BY LIP 20230830 表关联重复，改成从C表出数
        ,TO_CHAR(C.EFFECT_DT,'YYYYMMDD')                      AS COLL_EFF_DT             --20押品生效日期
        ,TO_CHAR(C.EXP_DT,'YYYYMMDD')                         AS COLL_EXP_DT             --21押品到期日期
        ,B.DRAWER_ACCT_NUM                                    AS PLG_TKT_ACC             --22质押票证账号
        ,B.BILL_TYPE_CD                                       AS PLG_TKT_TYP             --23质押票证类型
        ,CASE WHEN NVL(TRIM(A.DEP_RCPT_VOUCH_ID),' ') <> ' ' THEN A.DEP_RCPT_VOUCH_ID
              ELSE NVL(B.BILL_NUM,A.BELONG_CERT_NO)
          END                                                 AS PLG_TKT_NO              --24质押票证号码
        ,B.FAC_VAL_AMT                                        AS PLG_TKT_AMT             --25质押票证金额
        ,B.DRAWER_OPEN_BANK_NO                                AS PLG_TKT_ISU_ORG_ID      --26质押票证签发机构
        ,TO_CHAR(B.BILL_ISSUE_DT,'YYYYMMDD')                  AS PLG_TKT_ESTM_DT         --27质押票证开立日期
        --MOD BY LIP 20230830 增加取数来源
        ,CASE WHEN NVL(TRIM(A.WAT_RGST_NUM),'-') NOT IN ('-')
              THEN TRIM(REPLACE(REPLACE(A.WAT_RGST_NUM,CHR(10),''),CHR(13),''))
              WHEN NVL(TRIM(T11.REL_ESAT_WAT_ID),'-') NOT IN ('-')
              THEN TRIM(REPLACE(REPLACE(T11.REL_ESAT_WAT_ID,CHR(10),''),CHR(13),''))
          END                                                 AS WRNT_REGD_NO            --28权证登记号码
        ,A.WAT_NAME                                           AS WRNT_NM                 --29权证名称
        ,TO_CHAR(A.RGST_EXP_DT,'YYYYMMDD')                    AS WRNT_VALID_EXP_DT       --30权证有效到期日期
        ,TO_CHAR(A.RGST_EXP_DT,'YYYYMMDD')                    AS REGD_VALID_END_DT       --31登记有效终止日期
        ,NULL                                                 AS COLL_CUST_RSK_RTG_CL    --32担保品客户风险评级分类
        ,NULL                                                 AS DIR_ACQ_FLG             --33定向收购标志
        ,NULL                                                 AS QUAL_MTGN_FLG           --34合格缓释品标志
        ,NULL                                                 AS RE_MTG_PLG_FIN_COLL_FLG --35可再抵质押融资押品标志
        ,TO_CHAR(A.RIGHT_RGST_DT,'YYYYMMDD')                  AS REGD_DT                 --36登记日期
        ,TO_CHAR(A.ENTY_COLL_DT,'YYYYMMDD')                   AS MTRL_OBJ_COLL_DT        --37实物收取日期
        ,A.ESTIM_WAY_CD                                       AS ASES_MODE               --38评估方式
        ,CASE WHEN FF.EXT_ESTIM_METHOD_CD = '04' THEN '01'
              WHEN FF.EXT_ESTIM_METHOD_CD = '03' THEN '02'
              WHEN FF.EXT_ESTIM_METHOD_CD = '05' THEN '03'
              ELSE '09'
          END                                                 AS ASES_METHOD             --39评估方法
        /*,CASE WHEN M.REVAL_FREQ_CD = 'D' THEN '07'
              WHEN M.REVAL_FREQ_CD = 'W' THEN '06'
              WHEN M.REVAL_FREQ_CD = 'T' THEN '05'
              WHEN M.REVAL_FREQ_CD = 'M' THEN '04'
              WHEN M.REVAL_FREQ_CD = 'Q' THEN '03'
              WHEN M.REVAL_FREQ_CD = 'H' THEN '02'
              WHEN M.REVAL_FREQ_CD = 'Y' THEN '01'
              ELSE '99'
          END                                                 AS VALT_CYC                --40估值周期*/ 
        --MOD BY YJY 20251013 修改重估频率单位的取数来源  询问信贷系统刘顺：REEVALFRQUNIT重估频率单位+REEVALFRQTHEN重估频率=组合得出重估频率 01-天、02-月、03-年 
        ,CASE WHEN M.REEVALFRQUNIT = '01' AND M.REEVALFRQ = '1' THEN '07' --天   
              WHEN M.REEVALFRQUNIT = '01' AND M.REEVALFRQ = '7' THEN '06' --周
              WHEN M.REEVALFRQUNIT = '01' AND M.REEVALFRQ = '10'THEN '05' --旬
              WHEN M.REEVALFRQUNIT = '02' AND M.REEVALFRQ = '1' THEN '04' --月
              WHEN M.REEVALFRQUNIT = '02' AND M.REEVALFRQ = '3' THEN '03' --季
              WHEN M.REEVALFRQUNIT = '02' AND M.REEVALFRQ = '6' THEN '02' --半年
              WHEN M.REEVALFRQUNIT = '03' AND M.REEVALFRQ = '1' THEN '01' --年
              ELSE '99'
          END                                                 AS VALT_CYC                --40估值周期
        ,A.ESTATE_ARCH_AREA                                   AS WRNT_REGD_AREA          --41权证登记面积
        /*,A.PROP_PS_NAME                                       AS COLL_OWNER_NM           --42押品所有人名称
        ,A.PLEDGOR_CERT_TYPE_CD                               AS COLL_OWNER_CRDL_TYP     --43押品所有人证件类别
        ,A.PLEDGOR_CERT_NO                                    AS COLL_OWNER_CRDL_NO      --44押品所有人证件号码*/
        --MOD BY LIP 20250708 资产池明细押品对应的所有人信息取池对应的所有人信息
        ,NVL(TRIM(A.PROP_PS_NAME),TRIM(T13.PROP_PS_NAME))     AS COLL_OWNER_NM           --42押品所有人名称
        ,NVL(TRIM(A.PLEDGOR_CERT_TYPE_CD),TRIM(T13.PLEDGOR_CERT_TYPE_CD)) AS COLL_OWNER_CRDL_TYP --43押品所有人证件类别
        ,NVL(TRIM(A.PLEDGOR_CERT_NO),TRIM(T13.PLEDGOR_CERT_NO)) AS COLL_OWNER_CRDL_NO    --44押品所有人证件号码
        ,CASE WHEN T9.PMO_OBG_BRWER_RELA_CD IN ('02','03') THEN 'Y'
              ELSE 'N'
          END                                                 AS TRD_COLL_OWNER_FLG      --45第三方押品权属人标志
        ,CASE WHEN A.ESPEC_STATUS_CD = '01' THEN '01'
              WHEN A.ESPEC_STATUS_CD = '02' THEN '02'
              WHEN A.ESPEC_STATUS_CD = '03' THEN '03'
              WHEN A.ESPEC_STATUS_CD = '04' THEN '04'
              ELSE '99'
          END                                                 AS COLL_STAT               --46押品状态
        ,NULL                                                 AS DEPT_LINE               --47部门条线
        ,SUBSTR(A.JOB_CD,0,4)                                 AS DATA_SRC                --48数据来源
        ,A.INSTO_STATUS_CD                                    AS INSTO_STATUS_CD         --49押品入库状态 AD BY 20221118 XCX
        ,A.COL_TYPE_ID                                        AS COL_TYPE_ID             --50数仓押品类型代码 AD BY 20221118 XUCX
        ,A.HIGT_MTG_RAT                                       AS HIGT_MTG_RAT            --51最高抵押率
        ,F1.INPWN_STOCK_QTTY                                  AS PLG_EQTY_NUM            --52质押股权数量
        ,COALESCE(TRIM(A.DEP_RCPT_VOUCH_ID),TRIM(B.BILL_NUM),TRIM(A.BELONG_CERT_NO)) AS DEP_RCPT_VOUCH_ID --53存单凭证编号 ADD BY 20221125 XUCX
        ,TRIM(REPLACE(REPLACE(A.BELONG_CERT_NO,CHR(10),''),CHR(13),'')) AS BELONG_CERT_NO --54权属证件号码
        ,A.PM_RAT                                             AS MTG_RAT                 --55抵质押率
        ,T10.OBANK_SET_SEC_RIGHT_AMT                          AS OBANK_SET_SEC_RIGHT_AMT --56他行设定担保权金额
        /*,TO_CHAR(A.ESTIM_DT,'YYYYMMDD')                       AS ESTIM_DT                --57首次评估日期(客户风险)*/ 
        --MOD BY YJY 20251107 评估认定日期大于统计日期时，取创建日期为评估日期
        ,CASE WHEN --A.ESTIM_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
                   TO_CHAR(A.ESTIM_DT,'YYYYMMDD') <= V_P_DATE
               AND TO_CHAR(A.ESTIM_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
              THEN TO_CHAR(A.ESTIM_DT,'YYYYMMDD')
              --ELSE TO_CHAR(A.SETUP_DT,'YYYYMMDD')
              WHEN TO_CHAR(A.SETUP_DT,'YYYYMMDD') NOT IN ('00010101','20991231')
              THEN TO_CHAR(A.SETUP_DT,'YYYYMMDD')   --MOD BY YJY 20251203
          END                                                 AS ESTIM_DT                --57首次评估日期(客户风险)add by HULJ 20230210 
        ,A.PRIOR_COMP_WEIGHT_QTTY                             AS PRIOR_COMP_WEIGHT_QTTY  --58优先优先受偿权数额
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                         AS COL_EXP_DT              --59押品到期日期
        ,T12.GUARTOR_TYPE_CD                                  AS GUARTOR_TYPE_CD         --60保证人类型代码
    FROM RRP_MDL.O_ICL_CMM_COL_INFO A
    LEFT JOIN COL_GUAR_CONT_RELA C --MD BY 20221118 XUCX 修改关联方式 释放资产池和票据池中的子资产(A.COL_ID LIKE '%ZCC')
      ON C.COL_ID = A.COL_ID
    LEFT JOIN RRP_MDL.O_IML_AST_COL_ACCPT_BIL_INFO_H B --押品承兑汇票信息历史
      ON B.ASSET_ID = A.COL_ID
     AND B.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN COL_ALL_INFO_H E --押品所有人信息历史
      ON E.PROP_PS_ID = A.PROP_PS_ID
     AND E.RN = 1
    /*LEFT JOIN (SELECT SCCODE,MIN(NVL(REPLACE(CONDATE,'-',''),'99991231')) FIRST_ESTIM_DT
                 FROM RRP_MDL.O_IOL_MIMS_SI_VALUEINFOHIS
                GROUP BY SCCODE) F
       ON F.SCCODE = A.COL_ID 
     LEFT JOIN RRP_MDL.O_IML_AST_COL_TYPE_DEF M
       ON M.COL_TYPE_CD = A.COL_TYPE_ID
      AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
    --MOD BY YJY 20251013 下线O_IOL_MIMS_SI_VALUEINFOHIS，替换为O_IML_AST_COL_VAL_INFO_H押品价值信息历史
    LEFT JOIN (SELECT ASSET_ID,MIN(TO_CHAR(ESTIM_IDTFY_DT,'YYYYMMDD'))  FIRST_ESTIM_DT
                 FROM RRP_MDL.O_IML_AST_COL_VAL_INFO_H --押品价值信息历史
                WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY ASSET_ID) F
      ON F.ASSET_ID = A.COL_ID
    --MOD BY YJY 20251013 下线O_IML_AST_COL_TYPE_DEF，替换为O_IOL_ICMS_CLR_PARAM押品分类参数
    LEFT JOIN RRP_MDL.O_IOL_ICMS_CLR_PARAM M  --押品分类参数
      ON M.CLRTYPEID = A.COL_TYPE_ID
     AND M.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND M.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.CODE_MAP D --码值映射表(押品类型)
      ON D.SRC_VALUE_CODE = A.COL_TYPE_ID
     AND D.SRC_CLASS_CODE = 'CD1244'
     AND D.TAR_CLASS_CODE = 'T0008'
     AND D.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_AST_COL_VAL_INFO_H FF --押品价值信息历史
      ON FF.ASSET_ID = A.COL_ID
     AND FF.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND FF.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AST_COL_LIST_STOCK_INPWN_INFO F1 --押品上市公司股权质押信息
      ON F1.ASSET_ID = A.COL_ID
     AND F1.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND F1.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT T.ASSET_ID,T.PMO_OBG_BRWER_RELA_CD,T.COL_ALL_TYPE_CD,T.ALL_CUST_ID,
                      ROW_NUMBER()OVER(PARTITION BY T.ASSET_ID ORDER BY SEQ_NUM) RN
                 FROM RRP_MDL.O_IML_AST_COL_ALL_INFO_H T --押品所有人信息历史
                WHERE T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) T9
      ON T9.ASSET_ID = A.COL_ID
     AND T9.RN = 1
    LEFT JOIN (SELECT ASSET_ID,SUM(COALESCE(OBANK_SET_SEC_RIGHT_AMT,0)) OBANK_SET_SEC_RIGHT_AMT --他行设定担保权金额
                 FROM RRP_MDL.O_IML_AST_COL_OBANK_GUAR
                WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY ASSET_ID) T10 --押品他行担保
      ON T10.ASSET_ID = A.COL_ID
    LEFT JOIN RRP_MDL.O_IML_AST_COL_RESD_BUILD_INFO T11 --押品居住用房信息 --ADD BY LIP 20230830
      ON T11.ASSET_ID = A.COL_ID
     AND T11.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_COL_GUARTOR_RATING_INFO T12 --押品保证人评级信息 ADD BY YJY 20240311
      ON T12.COL_ID = A.COL_ID
     AND T12.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN AST_COL_SPLT_RELA_H T13 --ADD BY LIP 20250708 资产池明细押品对应的所有人信息取池对应的所有人信息
      ON T13.SUB_ASSET_ID = A.COL_ID
     AND T13.RN = 1
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260302 更新迁移前能取到现在没取到权属证件号码的数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新迁移前能取到现在没取到权属证件号码的数据';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT * FROM RRP_MDL.M_GUA_COLL_INFO WHERE BELONG_CERT_NO IS NULL AND DATA_DT = V_P_DATE) TA
  USING (SELECT COLL_ID,BELONG_CERT_NO FROM RRP_MDL.M_GUA_COLL_INFO WHERE BELONG_CERT_NO IS NOT NULL
            AND DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD')) TB
     ON (TB.COLL_ID = TA.COLL_ID)
   WHEN MATCHED THEN UPDATE SET
     TA.BELONG_CERT_NO = TB.BELONG_CERT_NO;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '查询数据是否重复';
    WITH TMP1 AS (
  SELECT DATA_DT,COLL_ID,COUNT(1)
    FROM RRP_MDL.M_GUA_COLL_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,COLL_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE);
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

END ETL_M_GUA_COLL_INFO;
/

