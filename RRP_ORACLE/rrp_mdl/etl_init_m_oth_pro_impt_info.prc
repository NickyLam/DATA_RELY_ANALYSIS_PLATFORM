CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_OTH_PRO_IMPT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_OTH_PRO_IMPT_INFO
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
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_OTH_PRO_IMPT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) := 'M_OTH_PRO_IMPT_INFO'; --表名
  V_PART_NAME VARCHAR2(100);
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_OTH_PRO_IMPT_INFO'; --表名
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
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入减值准备信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_OTH_PRO_IMPT_INFO
  (
         DATA_DT         --01  数据日期
        ,LGL_REP_ID      --02  法人编号
        ,ORG_ID          --03  机构编号
        ,CUR             --04  币种
        ,BIZ_TYP         --05  业务类型
        ,SUBJ_ID         --06  科目编号
        ,PRO_IMPT        --07  减值准备
        ,DEPT_LINE       --08  部门条线
        ,DATA_SRC        --09  数据来源
        ,LVL5_CL         --10  五级分类
        ,RCPT_ID         --11  借据编号
        ,OVD_DAYS        --12  逾期天数
        ,V_PRODUCK_TYPE_CD      --13 产品大类
        ,V_PRODUCK_TYPE_S_CD    --14 产品小类
        ,RID                    --15主键
    )
    SELECT
         V_P_DATE                AS DATA_DATE  --01  数据日期
        ,'9999'                  AS LGL_REP_ID --02  法人编号
        ,ORG_ID                  AS ORG_ID     --03  机构编号
        ,CUR                     AS CUR        --04  币种
        ,BIZ_TYP                 AS BIZ_TYP    --05  业务类型
        ,NULL                    AS SUBJ_ID    --06  科目编号
        ,PRO_IMPT                AS PRO_IMPT   --07  减值准备
        ,'IFR'                   AS DEPT_LINE  --08  部门条线
        ,'IFR'                   AS DATA_SRC   --09  数据来源
        ,LVL5_CL                 AS LVL5_CL    --10  五级分类
        ,RCPT_ID                 AS RCPT_ID    --11  借据编号
        ,OVD_DAYS                AS OVD_DAYS   --12  逾期天数
        ,V_PRODUCK_TYPE_CD       AS V_PRODUCK_TYPE_CD --13 产品大类
        ,V_PRODUCK_TYPE_S_CD     AS V_PRODUCK_TYPE_S_CD --14 产品小类
        ,RID                     AS RID                 --15主键
    FROM (
  SELECT ORG_ID                  AS ORG_ID     --03  机构编号
        ,CUR                     AS CUR        --04  币种
        ,BIZ_TYP                 AS BIZ_TYP    --05  业务类型
        ,NULL                    AS SUBJ_ID    --06  科目编号
        ,PRO_IMPT                AS PRO_IMPT   --07  减值准备
        ,'IFR'                   AS DEPT_LINE  --08  部门条线
        ,'IFR'                   AS DATA_SRC   --09  数据来源
        ,LVL5_CL                 AS LVL5_CL    --10  五级分类
        ,RCPT_ID                 AS RCPT_ID    --11  借据编号
        ,OVD_DAYS                AS OVD_DAYS   --12  逾期天数
        ,V_PRODUCK_TYPE_CD       AS V_PRODUCK_TYPE_CD --13 产品大类
        ,V_PRODUCK_TYPE_S_CD     AS V_PRODUCK_TYPE_S_CD --14 产品小类
        ,RID                     AS RID                 --15 主键
  FROM (SELECT A.V_ORG_CD        AS ORG_ID --03  机构号
              ,A.V_CCY_CD_BEFORE AS CUR    --04  币种
              ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%对公贷款%' THEN '10101' -- 对公贷款
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%传统零售%' THEN '10102' -- 传统零售
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%网贷业务%' THEN '10103' -- 网贷业务
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%票据贴现%' THEN '10104' -- 贴现和转贴现
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%福费廷%'   THEN '10105' -- 福费廷
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%存放同业%' THEN '109' --109  存放同业
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%' THEN
                     CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '11601' --非标-保险公司资本补充债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%北金所债权融资计划%' THEN '11602' --非标-北金所债权融资计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型理财产品%' THEN '11603' --非标-非净值型理财产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型券商资管计划%' THEN '11604' --非标-非净值型券商资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型信托计划%' THEN '11605' --非标-非净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债-公募%' THEN '11606' --非标-公司债-公募
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国际机构债%' THEN '11607' --非标-国际机构债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%' THEN '11608' --非标-国债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%货币基金%' THEN '11609' --非标-货币基金
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型保险资管计划%' THEN '11610' --非标-净值型保险资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型理财产品%' THEN '11611' --非标-净值型理财产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型期货资管计划%' THEN '11612' --非标-净值型期货资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型信托计划%' THEN '11613' --非标-净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型资管计划%' THEN '11614' --非标-净值型资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%可转债%' THEN '11615' --非标-可转债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%买入返售债券%' THEN '11616' --非标-买入返售债券
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%票据资管计划%' THEN '11617' --非标-票据资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商固定收益凭证%' THEN '11618' --非标-券商固定收益凭证
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商资管计划%' THEN '11619' --非标-券商资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%' THEN '11620' --非标-私募债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-银登中心信贷资产流转项目%' THEN '11605' --非标-非净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-债券基金%' THEN '11621' --非标-债券基金
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '11622' --非标-证券公司短期融资券
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他非净值型资产管理产品%' THEN '11629' --非标-其他非净值型资产管理产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%' THEN '11639' --非标-其他金融债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他净值型资产管理产品%' THEN '11649' --非标-其他净值型资产管理产品

                          WHEN A.V_SUB_CD LIKE '15039901%' THEN '1165' --1165  其他
                  /*        WHEN A.V_SUB_CD LIKE '15130701%' THEN '1165' --1165  其他*/
                        /*  WHEN A.V_SUB_CD LIKE '150319%'   THEN '1165' --1165  其他*/
                          WHEN (/*A.V_SUB_CD LIKE '15130911%' OR */A.V_SUB_CD LIKE '15030601%') THEN '1161' --1161  证券公司资产管理计划
                          /*WHEN (A.V_SUB_CD LIKE '15131011%' OR A.V_SUB_CD LIKE '15032301%') THEN '114' --114  银行非保本理财产品*/
                       /*   WHEN A.V_SUB_CD LIKE '15131001%' THEN '110' --110  银行保本理财产品*/
                      /*    WHEN A.V_SUB_CD LIKE '15032401%' THEN '108' --108  金融机构股权（含股票）*/
                          ELSE '122' -- 122 其他证券投资
                   END
                   WHEN A.V_PRODUCK_TYPE_CD LIKE '%买入返售(债券)%' THEN '112' --112  买入返售资产
                   WHEN A.V_PRODUCK_TYPE_CD LIKE '%债券投资%' THEN
                   CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%地方政府债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '103' --103  地方政府债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%' THEN '102' --102  政府债券（国债）
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%同业存单%' AND NVL(A.V_SUB_CD, '1') <> '11010201' THEN '113' --113  同业存单
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持债券%' THEN '120' --120  资产支持债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债%' THEN '1051' --公司债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%企业债%' THEN '1052' --企业债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%PPN%' THEN '1053' --PPN
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%中期票据%' THEN '1054' --中期票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持票据%' THEN '1055' --资产支持票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%绿色债务融资工具%' THEN '1056' --绿色债务融资工具
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%超短期融资券%' THEN '1057' --超短期融资券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%标准化票据%' THEN '1058' --标准化债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政府支持机构债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '10501' --10501 政府机构债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行债%' THEN '10621' --商业银行债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%混合资本%' THEN '10622' --混合资本
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行次级债%' THEN '10623' --商业银行次级债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%二级资本工具%' THEN '10624' --二级资本工具
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%无固定期限资本债%' THEN '10625' --无固定期限资本债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信用联结票据%' THEN '10626' --信用联结票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司债%' THEN '10627' --混合资本
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '10628' --证券公司短期融资券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '10629' --保险公司资本补充债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%财务公司债%' THEN '10630' --财务公司债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%金融租赁公司金融债%' THEN '10631' --金融租赁公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产管理公司金融债%' THEN '10632' --资产管理公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%汽车金融公司金融债%' THEN '10633' --汽车金融公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%' THEN '10639' --其他金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政策银行债%' THEN '1061' --1061  政策性金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%' THEN '1165' --1165  私募债
                   ELSE '1022' -- 1022 其他证券投资
                   END
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国内信用证%'
                  THEN '1211' --1211 表外业务(国内信用证)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国际信用证%'
                  THEN '1212' --1212 表外业务(国际信用证)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%'AND A.V_PRODUCK_TYPE_S_CD LIKE '%非融资%'
                   THEN '1213' --1213 表外业务(非融资性保函)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%'AND A.V_PRODUCK_TYPE_S_CD LIKE '%涉外%'
                   THEN '1214' --1213 表外业务(涉外保函)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(汇票)%'THEN '1215' --1215 表外业务(银行承兑汇票)
                     ELSE '122' --122  其他证券投资（除债券、股票、基金外的其他证券投资）
                END                              AS BIZ_TYP --05  业务类型
        -- ,B.G31_INVEST_TYPE     AS    BIZ_TYP --05  业务类型  MDY BY XMZ 20230106
         ,SUM(CASE WHEN A.V_CUST_NAME = '包商银行股份有限公司' THEN A.N_EAD_FIN -- 本期余额
               ELSE CASE WHEN V_THREE_STAGE_CD = 'FVTPL' THEN 0
                    ELSE (CASE
                             WHEN v_dfc_ecl_cd ='dcf' THEN
                              ROUND(N_ECL_BEFORE_DCF, 2)
                             ELSE
                              ROUND(N_ECL_BEFORE, 2)
                           END)
                    END
              END) AS PRO_IMPT --07  减值准备
         ,A.V_REGUL_CLASSIF_CD  AS LVL5_CL    --10  五级分类
         ,A.V_ID_NUMBER         AS RCPT_ID    --11  借据编号
         ,A.N_ODUS_DAYS         AS OVD_DAYS   --12  逾期天数
         ,A.V_PRODUCK_TYPE_CD   AS V_PRODUCK_TYPE_CD--13产品大类  ADD BY XMZ 20230106
         ,A.V_PRODUCK_TYPE_S_CD AS V_PRODUCK_TYPE_S_CD --14产品小类  ADD BY XMZ 20230106
         ,CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%同业债券%'
               THEN A.V_FINANCIAL_ID || '_' || A.V_THREE_STAGE_CD || '_' || A.INTNAL_SECU_ACCT_ID
               WHEN A.V_PRODUCK_TYPE_CD  LIKE '%资金债券%'
               THEN A.V_ID_NUMBER
               WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%'
               THEN A.V_FINANCIAL_ID || '_' ||A.V_THREE_STAGE_CD || '_' || A.V_ID_NUMBER
               ELSE A.V_ID_NUMBER
               END
                                 AS RID --业务主键
        FROM O_IOL_IFRS_FCT_ECL_RES_DTL A --i9减值结果表
        /*INNER join RRP_MDL.S_CPTL_INVEST B --投资业务整合表
                ON A.V_ID_NUMBER=B.ID
               AND B.DATA_DT=V_P_DATE*/
        WHERE A.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD')
        GROUP BY  A.V_ORG_CD,
                  A.V_CCY_CD_BEFORE,
                CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%对公贷款%' THEN '10101' -- 对公贷款
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%传统零售%' THEN '10102' -- 传统零售
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%网贷业务%' THEN '10103' -- 网贷业务
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%票据贴现%' THEN '10104' -- 贴现和转贴现
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%福费廷%'   THEN '10105' -- 福费廷
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%存放同业%' THEN '109' --109  存放同业
                     WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%' THEN
                     CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '11601' --非标-保险公司资本补充债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%北金所债权融资计划%' THEN '11602' --非标-北金所债权融资计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型理财产品%' THEN '11603' --非标-非净值型理财产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型券商资管计划%' THEN '11604' --非标-非净值型券商资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%非净值型信托计划%' THEN '11605' --非标-非净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债-公募%' THEN '11606' --非标-公司债-公募
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国际机构债%' THEN '11607' --非标-国际机构债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%' THEN '11608' --非标-国债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%货币基金%' THEN '11609' --非标-货币基金
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型保险资管计划%' THEN '11610' --非标-净值型保险资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型理财产品%' THEN '11611' --非标-净值型理财产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型期货资管计划%' THEN '11612' --非标-净值型期货资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型信托计划%' THEN '11613' --非标-净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%净值型资管计划%' THEN '11614' --非标-净值型资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%可转债%' THEN '11615' --非标-可转债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%买入返售债券%' THEN '11616' --非标-买入返售债券
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%票据资管计划%' THEN '11617' --非标-票据资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商固定收益凭证%' THEN '11618' --非标-券商固定收益凭证
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%券商资管计划%' THEN '11619' --非标-券商资管计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%' THEN '11620' --非标-私募债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-银登中心信贷资产流转项目%' THEN '11605' --非标-非净值型信托计划
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信托计划-债券基金%' THEN '11621' --非标-债券基金
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '11622' --非标-证券公司短期融资券
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他非净值型资产管理产品%' THEN '11629' --非标-其他非净值型资产管理产品
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%' THEN '11639' --非标-其他金融债
                          WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他净值型资产管理产品%' THEN '11649' --非标-其他净值型资产管理产品

                          WHEN A.V_SUB_CD LIKE '15039901%' THEN '1165' --1165  其他
                  /*        WHEN A.V_SUB_CD LIKE '15130701%' THEN '1165' --1165  其他*/
                        /*  WHEN A.V_SUB_CD LIKE '150319%'   THEN '1165' --1165  其他*/
                          WHEN (/*A.V_SUB_CD LIKE '15130911%' OR */A.V_SUB_CD LIKE '15030601%') THEN '1161' --1161  证券公司资产管理计划
                          /*WHEN (A.V_SUB_CD LIKE '15131011%' OR A.V_SUB_CD LIKE '15032301%') THEN '114' --114  银行非保本理财产品*/
                       /*   WHEN A.V_SUB_CD LIKE '15131001%' THEN '110' --110  银行保本理财产品*/
                      /*    WHEN A.V_SUB_CD LIKE '15032401%' THEN '108' --108  金融机构股权（含股票）*/
                          ELSE '122' -- 122 其他证券投资
                   END
                   WHEN A.V_PRODUCK_TYPE_CD LIKE '%买入返售(债券)%' THEN '112' --112  买入返售资产
                   WHEN A.V_PRODUCK_TYPE_CD LIKE '%债券投资%' THEN
                   CASE WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%地方政府债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '103' --103  地方政府债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%国债%' THEN '102' --102  政府债券（国债）
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%同业存单%' AND NVL(A.V_SUB_CD, '1') <> '11010201' THEN '113' --113  同业存单
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持债券%' THEN '120' --120  资产支持债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%公司债%' THEN '1051' --公司债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%企业债%' THEN '1052' --企业债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%PPN%' THEN '1053' --PPN
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%中期票据%' THEN '1054' --中期票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产支持票据%' THEN '1055' --资产支持票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%绿色债务融资工具%' THEN '1056' --绿色债务融资工具
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%超短期融资券%' THEN '1057' --超短期融资券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%标准化票据%' THEN '1058' --标准化债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政府支持机构债%' AND NVL(A.V_SUB_CD, '1') <> '11010101' THEN '10501' --10501 政府机构债券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行债%' THEN '10621' --商业银行债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%混合资本%' THEN '10622' --混合资本
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%商业银行次级债%' THEN '10623' --商业银行次级债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%二级资本工具%' THEN '10624' --二级资本工具
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%无固定期限资本债%' THEN '10625' --无固定期限资本债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%信用联结票据%' THEN '10626' --信用联结票据
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司债%' THEN '10627' --混合资本
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%证券公司短期融资券%' THEN '10628' --证券公司短期融资券
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%保险公司资本补充债%' THEN '10629' --保险公司资本补充债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%财务公司债%' THEN '10630' --财务公司债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%金融租赁公司金融债%' THEN '10631' --金融租赁公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%资产管理公司金融债%' THEN '10632' --资产管理公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%汽车金融公司金融债%' THEN '10633' --汽车金融公司金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%其他金融债%' THEN '10639' --其他金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%政策银行债%' THEN '1061' --1061  政策性金融债
                   WHEN A.V_PRODUCK_TYPE_S_CD LIKE '%私募债%' THEN '1165' --1165  私募债
                   ELSE '1022' -- 1022 其他证券投资
                   END
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国内信用证%'
                  THEN '1211' --1211 表外业务(国内信用证)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(信用证)%' AND A.V_PRODUCK_TYPE_S_CD LIKE '%国际信用证%'
                  THEN '1212' --1212 表外业务(国际信用证)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%'AND A.V_PRODUCK_TYPE_S_CD LIKE '%非融资%'
                   THEN '1213' --1213 表外业务(非融资性保函)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(保函)%'AND A.V_PRODUCK_TYPE_S_CD LIKE '%涉外%'
                   THEN '1214' --1213 表外业务(涉外保函)
                  WHEN A.V_PRODUCK_TYPE_CD LIKE '%表外业务(汇票)%'THEN '1215' --1215 表外业务(银行承兑汇票)
                     ELSE '122' --122  其他证券投资（除债券、股票、基金外的其他证券投资）
                END,
               CASE WHEN A.V_CUST_NAME = '包商银行股份有限公司' THEN '5'
                    ELSE A.V_REGUL_CLASSIF_CD
                END,
               CASE WHEN A.V_AROUND_SIGN = '0' THEN '1'
                    WHEN A.V_AROUND_SIGN = '1' THEN '2'
                    ELSE '1'
                END,
                A.V_REGUL_CLASSIF_CD,      --10  五级分类
                A.V_ID_NUMBER,             --11  借据编号
                A.N_ODUS_DAYS,              --12  逾期天数
                A.V_PRODUCK_TYPE_CD,         --13产品大类
                A.V_PRODUCK_TYPE_S_CD,       --14产品小类
                CASE WHEN A.V_PRODUCK_TYPE_CD LIKE '%同业债券%'
               THEN A.V_FINANCIAL_ID || '_' || A.V_THREE_STAGE_CD || '_' || A.INTNAL_SECU_ACCT_ID
               WHEN A.V_PRODUCK_TYPE_CD  LIKE '%资金债券%'
               THEN A.V_ID_NUMBER
               WHEN A.V_PRODUCK_TYPE_CD LIKE '%非标投资%'
               THEN A.V_FINANCIAL_ID || '_' ||A.V_THREE_STAGE_CD || '_' || A.V_ID_NUMBER
               ELSE A.V_ID_NUMBER
               END
                                 --15主键
                )
      );
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
    SELECT DATA_DT, RCPT_ID,CUR,LVL5_CL,OVD_DAYS,RID,COUNT(1)
      FROM M_OTH_PRO_IMPT_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, RCPT_ID,CUR,LVL5_CL,OVD_DAYS,RID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');
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
  -- V_STEP := V_STEP + 1;
     --V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_OTH_PRO_IMPT_INFO;
/

