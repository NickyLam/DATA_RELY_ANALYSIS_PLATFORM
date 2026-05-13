CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_OTH_PRO_IMPT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_OTH_PRO_IMPT_INFO
  *  功能描述：监管集市自然人客户的证件信息，该表记录了当事人的居民身份证、军人身份证等证件信息历史
  *  创建日期：20220607
  *  开发人员：hulijuan
  *  来源表：  IOL.IFRS_FCT_ECL_RES_DTL --i9减值结果表
  *
  *  目标表：  M_OTH_PRO_IMPT_INFO  --减值准备信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220831  hulj   首次创建。
  *             2    20221114  hulj   新增字段五级分类,借据编号,逾期天数,增加数据重复校验
  *             3    20221130  mw     修改旧科目
  *             4    20241028  YJY    同业债券部分调整RID字段
  *             5    20241223  YJY    新增相关应计利息、应收利息
  *             6    20250526  YJY    诉讼费相关字段从减值系统诉讼费表里获取
  *             7    20260323  YJY    把联合网贷，网贷业务都映射到业务类型是10103。新增产品编号字段
  ***********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_STEP_DESC VARCHAR2(100);        --处理步骤描述
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_OTH_PRO_IMPT_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_OTH_PRO_IMPT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

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

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE,'M_OTH_PRO_IMPT_INFO','1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_OTH_PRO_IMPT_INFO'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --  
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入减值准备信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_OTH_PRO_IMPT_INFO
    (DATA_DT             --01 数据日期
    ,LGL_REP_ID          --02 法人编号
    ,ORG_ID              --03 机构编号
    ,CUR                 --04 币种
    ,BIZ_TYP             --05 业务类型
    ,SUBJ_ID             --06 科目编号
    ,PRO_IMPT            --07 减值准备
    ,DEPT_LINE           --08 部门条线
    ,DATA_SRC            --09 数据来源
    ,LVL5_CL             --10 五级分类
    ,RCPT_ID             --11 借据编号
    ,OVD_DAYS            --12 逾期天数
    ,V_PRODUCK_TYPE_CD   --13 产品大类
    ,V_PRODUCK_TYPE_S_CD --14 产品小类
    ,RID                 --15 主键
    ,TAX_ECL             --16垫付增值税ECL       ADD BY YJY 20241223
    ,TAX_ECL_BEFORE      --17垫付增值税原币ECL   ADD BY YJY 20241223
    ,TAX_BALANCE_BEFORE  --18垫付增值税原币余额  ADD BY YJY 20241223
    ,TAX_BALANCE         --19垫付增值税余额      ADD BY YJY 20241223
    ,LAW_ECL             --20代垫诉讼费ECL       ADD BY YJY 20241223
    ,LAW_ECL_BEFORE      --21代垫诉讼费原币ECL   ADD BY YJY 20241223
    ,LAW_BALANCE_BEFORE  --22代垫诉讼费原币余额  ADD BY YJY 20241223
    ,LAW_BALANCE         --23代垫诉讼费本币余额  ADD BY YJY 20241223
    ,INT_RECVBL_ECL      --24应收利息ECL         ADD BY YJY 20241223
    ,N_INT_RECEIVABLE_BEFORE   --25应收利息原币         ADD BY YJY 20241223
    ,RECVBL_UNCOL_INT_BEFORE   --26应收未收利息原币     ADD BY YJY 20241223
    ,N_INT_ACCRUED_BEFORE      --27应计利息原币         ADD BY YJY 20241223  
    ,N_INT_RECEIVABLE_ECL_BEFORE  --28应收利息ECL原币   ADD BY YJY 20241223
    ,RECVBL_UNCOL_INT_ECL_BEFORE  --29应收未收利息ECL原币 ADD BY YJY 20241223  
    ,N_INT_ACCRUED_ECL_BEFORE     --30应计利息ECL原币     ADD BY YJY 20241223  
    ,PROD_ID           --31产品编号 ADD BY YJY 20260323
    )
   SELECT      V_P_DATE                                    AS DATA_DT             --01 数据日期
              ,'9999'                                      AS LGL_REP_ID          --02 法人编号
              ,A.V_ORG_CD                                  AS ORG_ID              --03 机构编号
              ,A.V_CCY_CD_BEFORE                           AS CUR                 --04 币种
              ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%对公贷款%' THEN '10101'  --对公贷款
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%传统零售%' THEN '10102' --传统零售
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%网贷业务%' 
                         OR A.V_PRODUCK_TYPE_CD LIKE '%联合网贷%' -- ADD BY YJY 20260323 联合网贷，网贷业务都映射到业务类型是10103 
                    THEN '10103' --网贷业务
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%票据贴现%' THEN '10104' --贴现和转贴现
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%福费廷%'   THEN '10105' --福费廷
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%存放同业%' THEN '109' --109 存放同业
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%' 
                    THEN ( CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '11601' --非标-保险公司资本补充债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%北金所债权融资计划%' THEN '11602' --非标-北金所债权融资计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型理财产品%'   THEN '11603' --非标-非净值型理财产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型券商资管计划%' THEN '11604' --非标-非净值型券商资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型信托计划%'   THEN '11605' --非标-非净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债-公募%'        THEN '11606' --非标-公司债-公募
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国际机构债%'         THEN '11607' --非标-国际机构债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%'               THEN '11608' --非标-国债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%货币基金%'           THEN '11609' --非标-货币基金
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型保险资管计划%' THEN '11610' --非标-净值型保险资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型理财产品%'     THEN '11611' --非标-净值型理财产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型期货资管计划%' THEN '11612' --非标-净值型期货资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型信托计划%'     THEN '11613' --非标-净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型资管计划%'     THEN '11614' --非标-净值型资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%可转债%'             THEN '11615' --非标-可转债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%买入返售债券%'       THEN '11616' --非标-买入返售债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%票据资管计划%'       THEN '11617' --非标-票据资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商固定收益凭证%'   THEN '11618' --非标-券商固定收益凭证
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商资管计划%'       THEN '11619' --非标-券商资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%'             THEN '11620' --非标-私募债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-银登中心信贷资产流转项目%' THEN '11605' --非标-非净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-债券基金%'  THEN '11621' --非标-债券基金
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '11622' --非标-证券公司短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他非净值型资产管理产品%' THEN '11629' --非标-其他非净值型资产管理产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%'         THEN '11639' --非标-其他金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他净值型资产管理产品%' THEN '11649' --非标-其他净值型资产管理产品
                                WHEN A.V_SUB_CD LIKE '15039901%' THEN '1165' --1165  其他
                                WHEN A.V_SUB_CD LIKE '15030601%' THEN '1161' --1161  证券公司资产管理计划
                                ELSE '122' -- 122 其他证券投资
                            END )
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%买入返售(债券)%' THEN '112' --112  买入返售资产
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%债券投资%' 
                    THEN ( CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%地方政府债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '103' --103  地方政府债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%'               THEN '102' --102  政府债券（国债）
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%同业存单%' AND NVL(A.V_SUB_CD, '1') <> '11010201' THEN '113' --113  同业存单
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持债券%'       THEN '120' --120  资产支持债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债%'             THEN '1051' --公司债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%企业债%'             THEN '1052' --企业债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%PPN%'                THEN '1053' --PPN
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%中期票据%'           THEN '1054' --中期票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持票据%'       THEN '1055' --资产支持票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%绿色债务融资工具%'   THEN '1056' --绿色债务融资工具
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%超短期融资券%'       THEN '1057' --超短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%标准化票据%'         THEN '1058' --标准化债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政府支持机构债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '10501' --10501 政府机构债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行债%'         THEN '10621' --商业银行债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%混合资本%'           THEN '10622' --混合资本
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行次级债%'     THEN '10623' --商业银行次级债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%二级资本工具%'       THEN '10624' --二级资本工具
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%无固定期限资本债%'   THEN '10625' --无固定期限资本债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信用联结票据%'       THEN '10626' --信用联结票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司债%'         THEN '10627' --混合资本
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '10628' --证券公司短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '10629' --保险公司资本补充债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%财务公司债%'         THEN '10630' --财务公司债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%金融租赁公司金融债%' THEN '10631' --金融租赁公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产管理公司金融债%' THEN '10632' --资产管理公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%汽车金融公司金融债%' THEN '10633' --汽车金融公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%'         THEN '10639' --其他金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政策银行债%'         THEN '1061' --1061  政策性金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%'             THEN '1165' --1165  私募债
                                ELSE '1022' -- 1022 其他证券投资
                          END )
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国内信用证%' THEN '1211' --1211 表外业务(国内信用证)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国际信用证%' THEN '1212' --1212 表外业务(国际信用证)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%非融资%'       THEN '1213' --1213 表外业务(非融资性保函)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%涉外%'         THEN '1214' --1213 表外业务(涉外保函)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(汇票)%' THEN '1215' --1215 表外业务(银行承兑汇票)
                    ELSE '122' --122  其他证券投资（除债券、股票、基金外的其他证券投资）
                END                               AS BIZ_TYP             --05 业务类型
              ,NULL                               AS SUBJ_ID             --06 科目编号
              ,SUM(CASE WHEN A.V_CUST_NAME = '包商银行股份有限公司' THEN A.N_EAD_FIN -- 本期余额
                        ELSE (CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0
                                   ELSE (CASE WHEN A.V_DFC_ECL_CD ='dcf' 
                                              THEN ROUND(A.N_ECL_BEFORE_DCF,2)
                                              ELSE ROUND(A.N_ECL_BEFORE,2)
                                          END) 
                               END) 
                   END)                           AS PRO_IMPT            --07 减值准备
              ,'IFR'                              AS DEPT_LINE           --08 部门条线
              ,'IFR'                              AS DATA_SRC            --09 数据来源
              ,A.V_REGUL_CLASSIF_CD               AS LVL5_CL             --10 五级分类
              ,A.V_ID_NUMBER                      AS RCPT_ID             --11 借据编号
              ,A.N_ODUS_DAYS                      AS OVD_DAYS            --12 逾期天数
              ,A.V_PRODUCK_TYPE_CD                AS V_PRODUCK_TYPE_CD   --13 产品大类  ADD BY XMZ 20230106
              ,A.V_PRODUCK_TYPE_S_CD              AS V_PRODUCK_TYPE_S_CD --14 产品小类  ADD BY XMZ 20230106
              ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%同业债券%'
                    --THEN A.V_FINANCIAL_ID || '_' || A.V_THREE_STAGE_CD || '_' || A.INTNAL_SECU_ACCT_ID
                    THEN A.V_ID_NUMBER   --MOD BY YJY 20241028 
                    WHEN A.V_PRODUCK_TYPE_CD  LIKE '%资金债券%'
                    THEN A.V_ID_NUMBER
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%'
                    THEN A.V_FINANCIAL_ID || '_' ||A.V_THREE_STAGE_CD || '_' || A.V_ID_NUMBER
                    ELSE A.V_ID_NUMBER
                END                               AS RID                 --15业务主键
               ,A.TAX_ECL                         AS TAX_ECL             --16垫付增值税ECL       ADD BY YJY 20241223
               ,A.TAX_ECL_BEFORE                  AS TAX_ECL_BEFORE      --17垫付增值税原币ECL   ADD BY YJY 20241223
               ,A.TAX_BALANCE_BEFORE              AS TAX_BALANCE_BEFORE  --18垫付增值税原币余额  ADD BY YJY 20241223
               ,A.TAX_BALANCE                     AS TAX_BALANCE         --19垫付增值税余额      ADD BY YJY 20241223
               --MOD BY YJY 20250526 诉讼费相关字段从减值系统诉讼费表获取
               /*,B.LAW_ECL                         AS LAW_ECL             --20代垫诉讼费ECL     
               ,B.LAW_ECL_BEFORE                  AS LAW_ECL_BEFORE      --21代垫诉讼费原币ECL   
               ,B.LAW_BALANCE_BEFORE              AS LAW_BALANCE_BEFORE  --22代垫诉讼费原币余额  
               ,B.LAW_BALANCE                     AS LAW_BALANCE         --23代垫诉讼费本币余额*/
               --MOD BY YJY 20250628 取消诉讼费取值口径，1104从s层进行加工
               ,0                                 AS LAW_ECL             --20代垫诉讼费ECL     
               ,0                                 AS LAW_ECL_BEFORE      --21代垫诉讼费原币ECL   
               ,0                                 AS LAW_BALANCE_BEFORE  --22代垫诉讼费原币余额  
               ,0                                 AS LAW_BALANCE         --23代垫诉讼费本币余额
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.INT_RECVBL_ECL  
                END                               AS INT_RECVBL_ECL      --24应收利息ECL         ADD BY YJY 20241223
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.N_INT_RECEIVABLE_BEFORE  
                END                               AS N_INT_RECEIVABLE_BEFORE   --25应收利息原币         ADD BY YJY 20241223
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.RECVBL_UNCOL_INT_BEFORE  
                END                               AS RECVBL_UNCOL_INT_BEFORE   --26应收未收利息原币     ADD BY YJY 20241223
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.N_INT_ACCRUED_BEFORE  
                END                               AS N_INT_ACCRUED_BEFORE       --27应计利息原币     ADD BY YJY 20241223  
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.N_INT_RECEIVABLE_ECL_BEFORE  
                END                               AS N_INT_RECEIVABLE_ECL_BEFORE  --28应收利息ECL原币     ADD BY YJY 20241223
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.RECVBL_UNCOL_INT_ECL_BEFORE  
                END                               AS RECVBL_UNCOL_INT_ECL_BEFORE  --29应收未收利息ECL原币     ADD BY YJY 20241223  
               ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                     ELSE A.N_INT_ACCRUED_ECL_BEFORE  
                END                               AS N_INT_ACCRUED_ECL_BEFORE  --30应计利息ECL原币     ADD BY YJY 20241223          
               ,A.PRODUCT_NO                        AS PROD_ID                --31产品编号 ADD BY YJY 20260323
          FROM RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL A --I9减值结果表
          -- ADD BY YJY 20250526 关联诉讼费表，获取相关诉讼费字段
          /*LEFT JOIN RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_LAW  B  --减值系统诉讼费表
            ON B.V_SERIALNO = A.V_SERIALNO  --MOD BY YJY 20250616 
           AND B.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')*/
         WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
         GROUP BY  A.V_ORG_CD
                  ,A.V_CCY_CD_BEFORE
                  ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%对公贷款%' THEN '10101'  --对公贷款
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%传统零售%' THEN '10102' --传统零售
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%网贷业务%' 
                      OR A.V_PRODUCK_TYPE_CD LIKE '%联合网贷%' -- ADD BY YJY 20260323 联合网贷，网贷业务都映射到业务类型是10103 
                    THEN '10103' --网贷业务
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%票据贴现%' THEN '10104' --贴现和转贴现
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%福费廷%'   THEN '10105' --福费廷
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%存放同业%' THEN '109' --109 存放同业
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%' 
                    THEN ( CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '11601' --非标-保险公司资本补充债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%北金所债权融资计划%' THEN '11602' --非标-北金所债权融资计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型理财产品%'   THEN '11603' --非标-非净值型理财产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型券商资管计划%' THEN '11604' --非标-非净值型券商资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型信托计划%'   THEN '11605' --非标-非净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债-公募%'        THEN '11606' --非标-公司债-公募
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国际机构债%'         THEN '11607' --非标-国际机构债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%'               THEN '11608' --非标-国债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%货币基金%'           THEN '11609' --非标-货币基金
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型保险资管计划%' THEN '11610' --非标-净值型保险资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型理财产品%'     THEN '11611' --非标-净值型理财产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型期货资管计划%' THEN '11612' --非标-净值型期货资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型信托计划%'     THEN '11613' --非标-净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型资管计划%'     THEN '11614' --非标-净值型资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%可转债%'             THEN '11615' --非标-可转债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%买入返售债券%'       THEN '11616' --非标-买入返售债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%票据资管计划%'       THEN '11617' --非标-票据资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商固定收益凭证%'   THEN '11618' --非标-券商固定收益凭证
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商资管计划%'       THEN '11619' --非标-券商资管计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%'             THEN '11620' --非标-私募债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-银登中心信贷资产流转项目%' THEN '11605' --非标-非净值型信托计划
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-债券基金%'  THEN '11621' --非标-债券基金
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '11622' --非标-证券公司短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他非净值型资产管理产品%' THEN '11629' --非标-其他非净值型资产管理产品
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%'         THEN '11639' --非标-其他金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他净值型资产管理产品%' THEN '11649' --非标-其他净值型资产管理产品
                                WHEN A.V_SUB_CD LIKE '15039901%' THEN '1165' --1165  其他
                                WHEN A.V_SUB_CD LIKE '15030601%' THEN '1161' --1161  证券公司资产管理计划
                                ELSE '122' -- 122 其他证券投资
                            END )
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%买入返售(债券)%' THEN '112' --112  买入返售资产
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%债券投资%' 
                    THEN ( CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%地方政府债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '103' --103  地方政府债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%'               THEN '102' --102  政府债券（国债）
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%同业存单%' AND NVL(A.V_SUB_CD, '1') <> '11010201' THEN '113' --113  同业存单
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持债券%'       THEN '120' --120  资产支持债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债%'             THEN '1051' --公司债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%企业债%'             THEN '1052' --企业债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%PPN%'                THEN '1053' --PPN
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%中期票据%'           THEN '1054' --中期票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持票据%'       THEN '1055' --资产支持票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%绿色债务融资工具%'   THEN '1056' --绿色债务融资工具
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%超短期融资券%'       THEN '1057' --超短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%标准化票据%'         THEN '1058' --标准化债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政府支持机构债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '10501' --10501 政府机构债券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行债%'         THEN '10621' --商业银行债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%混合资本%'           THEN '10622' --混合资本
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行次级债%'     THEN '10623' --商业银行次级债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%二级资本工具%'       THEN '10624' --二级资本工具
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%无固定期限资本债%'   THEN '10625' --无固定期限资本债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信用联结票据%'       THEN '10626' --信用联结票据
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司债%'         THEN '10627' --混合资本
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '10628' --证券公司短期融资券
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '10629' --保险公司资本补充债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%财务公司债%'         THEN '10630' --财务公司债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%金融租赁公司金融债%' THEN '10631' --金融租赁公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产管理公司金融债%' THEN '10632' --资产管理公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%汽车金融公司金融债%' THEN '10633' --汽车金融公司金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%'         THEN '10639' --其他金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政策银行债%'         THEN '1061' --1061  政策性金融债
                                WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%'             THEN '1165' --1165  私募债
                                ELSE '1022' -- 1022 其他证券投资
                          END )
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国内信用证%' THEN '1211' --1211 表外业务(国内信用证)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国际信用证%' THEN '1212' --1212 表外业务(国际信用证)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%非融资%'       THEN '1213' --1213 表外业务(非融资性保函)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%涉外%'         THEN '1214' --1213 表外业务(涉外保函)
                    WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(汇票)%' THEN '1215' --1215 表外业务(银行承兑汇票)
                    ELSE '122' --122  其他证券投资（除债券、股票、基金外的其他证券投资）
                   END
                  ,CASE WHEN A.V_CUST_NAME = '包商银行股份有限公司' THEN '5'
                        ELSE A.V_REGUL_CLASSIF_CD
                    END
                  ,CASE WHEN A.V_AROUND_SIGN = '0' THEN '1'
                        WHEN A.V_AROUND_SIGN = '1' THEN '2'
                        ELSE '1'
                   END
                  ,A.V_REGUL_CLASSIF_CD
                  ,A.V_ID_NUMBER
                  ,A.N_ODUS_DAYS
                  ,A.V_PRODUCK_TYPE_CD
                  ,A.V_PRODUCK_TYPE_S_CD
                  ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%同业债券%'
                       --THEN A.V_FINANCIAL_ID || '_' || A.V_THREE_STAGE_CD || '_' || A.INTNAL_SECU_ACCT_ID
                        THEN A.V_ID_NUMBER  --MOD BY YJY 20241028
                        WHEN A.V_PRODUCK_TYPE_CD  LIKE '%资金债券%'
                        THEN A.V_ID_NUMBER
                        WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%'
                        THEN A.V_FINANCIAL_ID || '_' ||A.V_THREE_STAGE_CD || '_' || A.V_ID_NUMBER
                        ELSE A.V_ID_NUMBER
                   END 
                  ,A.TAX_ECL                         --16垫付增值税ECL       ADD BY YJY 20241223
                  ,A.TAX_ECL_BEFORE                  --17垫付增值税原币ECL   ADD BY YJY 20241223
                  ,A.TAX_BALANCE_BEFORE              --18垫付增值税原币余额  ADD BY YJY 20241223
                  ,A.TAX_BALANCE                     --19垫付增值税余额      ADD BY YJY 20241223
                  ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                        ELSE A.INT_RECVBL_ECL  
                   END                               --24应收利息ECL          ADD BY YJY 20241223
                  ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                        ELSE A.N_INT_RECEIVABLE_BEFORE  
                   END                               --25应收利息原币         ADD BY YJY 20241223
                 ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                       ELSE A.RECVBL_UNCOL_INT_BEFORE  
                  END                                --26应收未收利息原币     ADD BY YJY 20241223
                 ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                       ELSE A.N_INT_ACCRUED_BEFORE  
                  END                                 --27应计利息原币        ADD BY YJY 20241223  
                 ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                       ELSE A.N_INT_RECEIVABLE_ECL_BEFORE  
                  END                                 --28应收利息ECL原币     ADD BY YJY 20241223
                 ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                       ELSE A.RECVBL_UNCOL_INT_ECL_BEFORE  
                  END                                 --29应收未收利息ECL原币 ADD BY YJY 20241223  
                 ,CASE WHEN A.V_THREE_STAGE_CD = 'FVTPL' THEN 0 
                       ELSE A.N_INT_ACCRUED_ECL_BEFORE  
                  END
                  ,A.PRODUCT_NO;                                --30应计利息ECL原币     ADD BY YJY 20241223

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
    SELECT DATA_DT,RCPT_ID,CUR,LVL5_CL,OVD_DAYS,RID,COUNT(1)
      FROM RRP_MDL.M_OTH_PRO_IMPT_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT,RCPT_ID,CUR,LVL5_CL,OVD_DAYS,RID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_OTH_PRO_IMPT_INFO;
/

