CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_DEP(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_DEP
  *  功能描述：存款业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CPTL_CD_ISSUE_INFO
  *            M_CPTL_LBY_INFO
  *            M_CUST_CORP_INFO
  *            M_PUB_ORG_INFO
  *            M_CUST_IND_INFO
  *
  *
  *  目标表：  S_DEP
  *  配置表：  CONFIG_AREA
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1  20230201  HYF     新增 委托贷款基金细类  ENTRS_LOAN_FUND_SUM_CL 字段
  *              2  20230331  HYF     新增 新增客户账户子户号 用于数据重复主键检查
  *              3  20241010  HYF     调整存款余额取值，取含电子现金的存款余额
  *              4  20241021  HYF     存款分户余额不为0过滤条件调整为取含电子现金的存款余额过滤
  *              5  20250211  HYF     新增现金管理类产品标志
  *              6  20250813  HYF     同业存放新增现金管理类产品标志
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_DEP'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_DEP'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_DEP T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_DEP'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '存款业务整合表--开发逻辑1-普通存款';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_DEP
      ( DATA_DT                 --数据日期
       ,LGL_REP_ID              --法人编号
       ,ORG_ID                  --机构编号
       ,CUST_ID                 --客户编号
       ,ACC_ID                  --账户编号
       ,ACC_CUR                 --账户币种
       ,ACC_BAL                 --账户余额
       ,PBL_INT                 --应付利息
       /*STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
       ,DEP_PROD_TYP            --存款产品类型
       ,IND_SETL_ACC_TYP        --个人结算账户类型
       ,SPCL_DEP_TYP            --专项存款类型
       ,DEP_START_DT            --存款起始日期
       ,DEP_EXP_DT              --存款到期日期
       ,CUST_LRG_CL             --客户大类
       ,CORP_CUST_TYP           --对公客户类型
       ,BIO_FLG                 --境内外标志
       ,RSDNT_FLG               --居民标志
       ,OPR_CUST_TYP            --经营性客户类型
       ,ENT_SCALE               --企业规模
       ,FIN_ORG_TYP             --金融机构类型
       ,OPEN_ACC_CHAN           --开户渠道
       ,CBRC_FLG                --CBRC标志
       ,PBOC_FLG                --PBOC标志
       ,BANK_CRD_MED_FLG        --银行卡介质标志
       ,REC_POOR_DEP_TYP        --建档立卡贫困户存款类型
       ,CNTY_DMN_RGN_FLG        --县域地区标志
       ,ALDY_OFF_POV_RGN_FLG    --已脱贫地区标志
       ,POV_ALLE_CNTY_FLG       --重点帮扶县标志
       ,DEPT_LINE               --部门条线
       ,DATA_SRC                --数据来源
       ,SUBJ_ID
       ,STD_PROD_ID
       ,TIME_DMD_FLG            --定活标志
       ,C_DEPOSIT_TYP           --单位存款类型
       ,ENTRS_LOAN_FUND_SUM_CL  --委托贷款基金细类
       ,AGRT_DEP_PSN_TYP        --协议存款人类型
       ,CUST_ACCT_SUB_ACCT_NUM  --客户账户子户号
       ,CASH_MANAGE_FLG         --现金管理类产品标志 ADD BY HYF 20250211
       )
      SELECT  A.DATA_DT                 AS DATA_DT           --数据日期
             ,A.LGL_REP_ID              AS LGL_REP_ID        --法人编号
             ,A.ORG_ID                  AS ORG_ID            --机构编号
             ,A.CUST_ID                 AS CUST_ID           --客户编号
             ,A.ACC_ID                  AS ACC_ID            --账户编号
             ,A.CUR                     AS ACC_CUR           --账户币种
             ,A.DEP_CASH_BAL            AS ACC_BAL           --账户余额
             ,A.PBL_INT                 AS PBL_INT           --应付利息
             ,A.DEP_PROD_TYP            AS DEP_PROD_TYP      --存款产品类型
             ,A.IND_DMD_DEP_ACC_TYP     AS IND_SETL_ACC_TYP  --个人结算账户类型
             ,A.SPCL_DEP_TYP            AS SPCL_DEP_TYP      --专项存款类型
             ,A.VAL_DT                  AS DEP_START_DT      --存款起始日期
             ,A.DEP_EXP_DT              AS DEP_EXP_DT        --存款到期日期
             ,CASE WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' 
                   THEN '01' --对私客户(含个体工商户)
                   WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' 
                   THEN '02' --对公客户（剔除个体工商户）
               END                      AS CUST_LRG_CL        --客户大类
             ,B.CUST_CL                 AS CORP_CUST_TYP      --对公客户类型
             ,NVL(B.BIO_FLG, C.BIO_FLG) AS BIO_FLG            --境内外标志
             ,NVL(B.RSDNT_FLG, C.RSDNT_FLG) AS RSDNT_FLG      --居民标志
             ,CASE WHEN B.CUST_CL = 'E' THEN 'A'
                   ELSE C.OPR_CUST_TYP
               END                      AS OPR_CUST_TYP       --经营性客户类型
             ,B.ENT_SCALE               AS ENT_SCALE          --企业规模
             ,B.FIN_ORG_TYP             AS FIN_ORG_TYP        --金融机构类型
             ,A.OPEN_ACC_CHAN           AS OPEN_ACC_CHAN      --开户渠道
             ,'Y'                       AS CBRC_FLG           --CBRC标志
             ,'Y'                       AS PBOC_FLG           --PBOC标志
             ,DECODE(A.ACCT_MED,'1','Y','N') AS BANK_CRD_MED_FLG--银行卡介质标志
             ,A.REC_POOR_DEP_TYP        AS REC_POOR_DEP_TYP    -- 建档立卡贫困户存款类型
            /* CASE WHEN Z1.CNTY_DMN          = 'Y'                        THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z2.CNTY_DMN = 'Y' THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z3.CNTY_DMN = 'Y' THEN 'Y' ELSE 'N' END AS CNTY_DMN_RGN_FLG    , -- 县域地区标志
             CASE WHEN Z1.POOR_CNTY         = 'Y'                        THEN 'Y'
                  WHEN Z2.POOR_CNTY         = 'Y'                        THEN 'Y'
                  WHEN Z3.POOR_CNTY         = 'Y'                        THEN 'Y' ELSE 'N' END AS ALDY_OFF_POV_RGN_FLG, -- 已脱贫地区标志
             CASE WHEN Z1.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y'
                  WHEN Z2.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y'
                  WHEN Z3.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y' ELSE 'N' END AS POV_ALLE_CNTY_FLG   , -- 重点帮扶县标志
             */
            ,NULL                       AS CNTY_DMN_RGN_FLG     --县域地区标志
            ,NULL                       AS ALDY_OFF_POV_RGN_FLG --已脱贫地区标志
            ,NULL                       AS POV_ALLE_CNTY_FLG    --重点帮扶县标志
            ,A.DEPT_LINE                AS DEPT_LINE            --部门条线
            ,A.DATA_SRC                 AS DATA_SRC             --数据来源
            ,A.SUBJ_ID
            ,A.STD_PROD_ID
            ,A.TIME_DMD_FLG                                     --定活标志
            ,A.C_DEPOSIT_TYPE                                   --单位存款类型
            ,A.ENTRS_LOAN_FUND_SUM_CL                           --委托贷款基金细类
            ,A.AGRT_DEP_PSN_TYP                                 --协议存款人类型
            ,A.CUST_ACCT_SUB_ACCT_NUM                           --客户账户子户号
            ,A.CASH_MANAGE_FLG                                  --现金管理类产品标志 ADD BY HYF 20250211
        FROM RRP_MDL.M_DEP_ACC_INFO A --存款账户信息表
        LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
/*        LEFT JOIN M_PUB_ORG_INFO  J  --机构表
          ON A.ORG_ID = J.ORG_ID*/
/*        LEFT JOIN CONFIG_AREA     Z1 --中国行政区划2020
          ON J.REGD_LAND_AREA_CD = Z1.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z2 --中国行政区划2020
          ON B.REGD_LAND_AREA_CD = Z2.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z3 --中国行政区划2020
          ON C.RSDNC_AREA_CD     = Z3.NEW_AREA_CD*/
       WHERE NOT REGEXP_LIKE(A.DEP_PROD_TYP, '^(11)') --委托存款/财政性存款
         AND A.DEP_CASH_BAL > 0
         AND A.DATA_DT = V_P_DATE;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_DEP字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '存款业务整合表--开发逻辑2-保险业金融机构存放';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_DEP
      ( DATA_DT                     --数据日期
       ,LGL_REP_ID                  --法人编号
       ,ORG_ID                      --机构编号
       ,CUST_ID                     --客户编号
       ,ACC_ID                      --账户编号
       ,ACC_CUR                     --账户币种
       ,ACC_BAL                     --账户余额
       ,PBL_INT                     --应付利息
       /*STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
       ,DEP_PROD_TYP                --存款产品类型
       ,IND_SETL_ACC_TYP            --个人结算账户类型
       ,SPCL_DEP_TYP                --专项存款类型
       ,DEP_START_DT                --存款起始日期
       ,DEP_EXP_DT                  --存款到期日期
       ,CUST_LRG_CL                 --客户大类
       ,CORP_CUST_TYP               --对公客户类型
       ,BIO_FLG                     --境内外标志
       ,RSDNT_FLG                   --居民标志
       ,OPR_CUST_TYP                --经营性客户类型
       ,ENT_SCALE                   --企业规模
       ,FIN_ORG_TYP                 --金融机构类型
       ,OPEN_ACC_CHAN               --开户渠道
       ,CBRC_FLG                    --CBRC标志
       ,PBOC_FLG                    --PBOC标志
       ,BANK_CRD_MED_FLG            --银行卡介质标志
       -- REC_POOR_DEP_TYP    , -- 建档立卡贫困户存款类型
       ,CNTY_DMN_RGN_FLG            --县域地区标志
       ,ALDY_OFF_POV_RGN_FLG        --已脱贫地区标志
       ,POV_ALLE_CNTY_FLG           --重点帮扶县标志
       ,DEPT_LINE                   --部门条线
       ,DATA_SRC                    --数据来源
       ,SUBJ_ID
       ,STD_PROD_ID
       --TIME_DMD_FLG --定活标志
       ,CUST_ACCT_SUB_ACCT_NUM      --客户账户子户号
       ,CASH_MANAGE_FLG             --现金管理类产品标志 ADD BY HYF 20250211
       )
      SELECT  A.DATA_DT            AS DATA_DT    --数据日期
             ,A.LGL_REP_ID         AS LGL_REP_ID --法人编号
             ,A.ORG_ID             AS ORG_ID     --机构编号
             ,A.CUST_ID            AS CUST_ID    --客户编号
             ,A.ACC_ID             AS ACC_ID     --账户编号
             ,A.CUR                AS ACC_CUR    --账户币种
             ,A.BAL                AS ACC_BAL    --账户余额
             ,A.INT                AS PBL_INT    --应付利息
             /*CASE
               WHEN 存款稳定性分类 LIKE 'A%' THEN
                A.DEP_BAL
               ELSE
                0
             END AS STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
             ,'1303'               AS DEP_PROD_TYP     --存款产品类型
             ,''                   AS IND_SETL_ACC_TYP --个人结算账户类型
             ,''                   AS SPCL_DEP_TYP     --专项存款类型
             ,A.START_DT           AS DEP_START_DT     --存款起始日期
             ,A.EXP_DT             AS DEP_EXP_DT       --存款到期日期
             ,'02'                 AS CUST_LRG_CL      --客户大类
             ,B.CUST_CL            AS CORP_CUST_TYP    --对公客户类型
             ,B.BIO_FLG            AS BIO_FLG          --境内外标志
             ,B.RSDNT_FLG          AS RSDNT_FLG        --居民标志
             ,CASE WHEN B.CUST_CL = 'E' THEN 'A'
                   ELSE ''
               END                 AS OPR_CUST_TYP     --经营性客户类型
             ,B.ENT_SCALE          AS ENT_SCALE        --企业规模
             ,B.FIN_ORG_TYP        AS FIN_ORG_TYP      --金融机构类型
             ,'2099'               AS OPEN_ACC_CHAN    --开户渠道
             ,'Y'                  AS CBRC_FLG         --CBRC标志
             ,'Y'                  AS PBOC_FLG         --PBOC标志
             ,'N'                  AS BANK_CRD_MED_FLG --银行卡介质标志
           /*  '2' AS REC_POOR_DEP_TYP , -- 建档立卡贫困户存款类型
             CASE WHEN Z1.CNTY_DMN          = 'Y'                        THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z2.CNTY_DMN = 'Y' THEN 'Y' ELSE 'N' END AS CNTY_DMN_RGN_FLG    , -- 县域地区标志
             CASE WHEN Z1.POOR_CNTY         = 'Y'                        THEN 'Y'
                  WHEN Z2.POOR_CNTY         = 'Y'                        THEN 'Y' ELSE 'N' END AS ALDY_OFF_POV_RGN_FLG, -- 已脱贫地区标志
             CASE WHEN Z1.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y'
                  WHEN Z2.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y' ELSE 'N' END AS POV_ALLE_CNTY_FLG   , -- 重点帮扶县标志*/
            ,NULL                   AS CNTY_DMN_RGN_FLG     -- 县域地区标志
            ,NULL                   AS ALDY_OFF_POV_RGN_FLG -- 已脱贫地区标志
            ,NULL                   AS POV_ALLE_CNTY_FLG    -- 重点帮扶县标志
            ,A.DEPT_LINE            AS DEPT_LINE            --部门条线
            ,A.DATA_SRC             AS DATA_SRC             --数据来源
            ,A.SUBJ_ID
            ,A.STD_PROD_ID
             -- A.TIME_DMD_FLG --定活标志
            ,A.CUST_ACCT_SUB_ACCT_NUM                       --客户账户子户号
            ,A.CASH_MANAGE_FLG      AS CASH_MANAGE_FLG      --现金管理类产品标志 ADD BY HYF 20250813
        FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
        JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
/*        LEFT JOIN M_PUB_ORG_INFO  J  --机构表
          ON A.ORG_ID = J.ORG_ID*/
      /*  LEFT JOIN CONFIG_AREA     Z1 --中国行政区划2020
          ON J.REGD_LAND_AREA_CD = Z1.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z2 --中国行政区划2020
          ON B.REGD_LAND_AREA_CD = Z2.NEW_AREA_CD*/
       WHERE A.BIZ_TYP LIKE '201%' --同业存放
         AND B.FIN_ORG_TYP IN ('F10000', --财产保险公司
                               'F20000', --人身保险公司
                               'F30000' --再保险公司
                               )
         AND A.BAL > 0
         AND A.DATA_DT = V_P_DATE;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_DEP字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '存款业务整合表--开发逻辑3-邮储协议存款';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_DEP
      ( DATA_DT                    --数据日期
       ,LGL_REP_ID                 --法人编号
       ,ORG_ID                     --机构编号
       ,CUST_ID                    --客户编号
       ,ACC_ID                     --账户编号
       ,ACC_CUR                    --账户币种
       ,ACC_BAL                    --账户余额
       ,PBL_INT                    --应付利息
       /*STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
       ,DEP_PROD_TYP               --存款产品类型
       ,IND_SETL_ACC_TYP           --个人结算账户类型
       ,SPCL_DEP_TYP               --专项存款类型
       ,DEP_START_DT               --存款起始日期
       ,DEP_EXP_DT                 --存款到期日期
       ,CUST_LRG_CL                --客户大类
       ,CORP_CUST_TYP              --对公客户类型
       ,BIO_FLG                    --境内外标志
       ,RSDNT_FLG                  --居民标志
       ,OPR_CUST_TYP               --经营性客户类型
       ,ENT_SCALE                  --企业规模
       ,FIN_ORG_TYP                --金融机构类型
       ,OPEN_ACC_CHAN              --开户渠道
       ,CBRC_FLG                   --CBRC标志
       ,PBOC_FLG                   --PBOC标志
       ,BANK_CRD_MED_FLG           --银行卡介质标志
       ,REC_POOR_DEP_TYP           -- 建档立卡贫困户存款类型
       ,CNTY_DMN_RGN_FLG           -- 县域地区标志
       ,ALDY_OFF_POV_RGN_FLG       -- 已脱贫地区标志
       ,POV_ALLE_CNTY_FLG          -- 重点帮扶县标志
       ,DEPT_LINE                  --部门条线
       ,DATA_SRC                   --数据来源
       ,SUBJ_ID
       ,STD_PROD_ID
       ,CUST_ACCT_SUB_ACCT_NUM     --客户账户子户号
       ,CASH_MANAGE_FLG            --现金管理类产品标志 ADD BY HYF 20250211
       )
      SELECT  A.DATA_DT              AS DATA_DT    --数据日期
             ,A.LGL_REP_ID           AS LGL_REP_ID --法人编号
             ,A.ORG_ID               AS ORG_ID     --机构编号
             ,A.CUST_ID              AS CUST_ID    --客户编号
             ,A.ACC_ID               AS ACC_ID     --账户编号
             ,A.CUR                  AS ACC_CUR    --账户币种
             ,A.BAL                  AS ACC_BAL    --账户余额
             ,A.INT                  AS PBL_INT    --应付利息
             /*CASE
               WHEN 存款稳定性分类 LIKE 'A%' THEN
                A.DEP_BAL
               ELSE
                0
             END AS STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
             ,'1302'                 AS DEP_PROD_TYP     --存款产品类型
             ,''                     AS IND_SETL_ACC_TYP --个人结算账户类型
             ,''                     AS SPCL_DEP_TYP     --专项存款类型
             ,A.START_DT             AS DEP_START_DT     --存款起始日期
             ,A.EXP_DT               AS DEP_EXP_DT       --存款到期日期
             ,'02'                   AS CUST_LRG_CL      --客户大类
             ,B.CUST_CL              AS CORP_CUST_TYP    --对公客户类型
             ,B.BIO_FLG              AS BIO_FLG          --境内外标志
             ,B.RSDNT_FLG            AS RSDNT_FLG        --居民标志
             ,CASE WHEN B.CUST_CL = 'E' THEN 'A'
                   ELSE ''
               END                   AS OPR_CUST_TYP     --经营性客户类型
             ,B.ENT_SCALE            AS ENT_SCALE        --企业规模
             ,B.FIN_ORG_TYP          AS FIN_ORG_TYP      --金融机构类型
             ,'2099'                 AS OPEN_ACC_CHAN    --开户渠道
             ,'Y'                    AS CBRC_FLG         --CBRC标志
             ,'Y'                    AS PBOC_FLG         --PBOC标志
             ,'N'                    AS BANK_CRD_MED_FLG --银行卡介质标志
             ,'2'                    AS REC_POOR_DEP_TYP --建档立卡贫困户存款类型
           /*  CASE WHEN Z1.CNTY_DMN          = 'Y'                        THEN 'Y'
                  WHEN Z1.CNTY_DMN          = 'N' AND  Z2.CNTY_DMN = 'Y' THEN 'Y' ELSE 'N' END AS CNTY_DMN_RGN_FLG    , -- 县域地区标志
             CASE WHEN Z1.POOR_CNTY         = 'Y'                        THEN 'Y'
                  WHEN Z2.POOR_CNTY         = 'Y'                        THEN 'Y' ELSE 'N' END AS ALDY_OFF_POV_RGN_FLG, -- 已脱贫地区标志
             CASE WHEN Z1.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y'
                  WHEN Z2.NATL_REVITAL_CNTY = 'Y'                        THEN 'Y' ELSE 'N' END AS POV_ALLE_CNTY_FLG   , -- 重点帮扶县标志*/
             ,NULL                   AS CNTY_DMN_RGN_FLG     -- 县域地区标志
             ,NULL                   AS ALDY_OFF_POV_RGN_FLG -- 已脱贫地区标志
             ,NULL                   AS POV_ALLE_CNTY_FLG    -- 重点帮扶县标志
             ,A.DEPT_LINE            AS DEPT_LINE         --部门条线
             ,A.DATA_SRC             AS DATA_SRC          --数据来源
             ,A.SUBJ_ID
             ,A.STD_PROD_ID
             ,A.CUST_ACCT_SUB_ACCT_NUM                    --客户账户子户号
             ,A.CASH_MANAGE_FLG      AS CASH_MANAGE_FLG   --现金管理类产品标志 ADD BY HYF 20250813
        FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
        JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
/*        LEFT JOIN M_PUB_ORG_INFO  J  --机构表
          ON A.ORG_ID = J.ORG_ID*/
/*        LEFT JOIN CONFIG_AREA     Z1 --中国行政区划2020
          ON J.REGD_LAND_AREA_CD = Z1.NEW_AREA_CD
        LEFT JOIN CONFIG_AREA     Z2 --中国行政区划2020
          ON B.REGD_LAND_AREA_CD = Z2.NEW_AREA_CD*/
       WHERE A.BIZ_TYP = '20107' --邮政储蓄银行协议存款
         AND B.FIN_ORG_TYP = 'C12141'
         AND A.BAL > 0
         AND A.START_DT < '20090101'
         AND A.DATA_DT = V_P_DATE;
         
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_DEP字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6;
  V_STEP_DESC := '存款业务整合表--开发逻辑4-金融控股公司';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_DEP
      ( DATA_DT                  --数据日期
       ,LGL_REP_ID               --法人编号
       ,ORG_ID                   --机构编号
       ,CUST_ID                  --客户编号
       ,ACC_ID                   --账户编号
       ,ACC_CUR                  --账户币种
       ,ACC_BAL                  --账户余额
       ,PBL_INT                  --应付利息
       /*STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
       ,DEP_PROD_TYP             --存款产品类型
       ,IND_SETL_ACC_TYP         --个人结算账户类型
       ,SPCL_DEP_TYP             --专项存款类型
       ,DEP_START_DT             --存款起始日期
       ,DEP_EXP_DT               --存款到期日期
       ,CUST_LRG_CL              --客户大类
       ,CORP_CUST_TYP            --对公客户类型
       ,BIO_FLG                  --境内外标志
       ,RSDNT_FLG                --居民标志
       ,OPR_CUST_TYP             --经营性客户类型
       ,ENT_SCALE                --企业规模
       ,FIN_ORG_TYP              --金融机构类型
       ,OPEN_ACC_CHAN            --开户渠道
       ,CBRC_FLG                 --CBRC标志
       ,PBOC_FLG                 --PBOC标志
       ,BANK_CRD_MED_FLG         --银行卡介质标志
       ,REC_POOR_DEP_TYP         --建档立卡贫困户存款类型
       ,CNTY_DMN_RGN_FLG         --县域地区标志
       ,ALDY_OFF_POV_RGN_FLG     --已脱贫地区标志
       ,POV_ALLE_CNTY_FLG        --重点帮扶县标志
       ,DEPT_LINE                --部门条线
       ,DATA_SRC                 --数据来源
       ,SUBJ_ID
       ,STD_PROD_ID
       ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
       ,CASH_MANAGE_FLG          --现金管理类产品标志
       )
      SELECT  A.DATA_DT              AS DATA_DT        --数据日期
             ,A.LGL_REP_ID           AS LGL_REP_ID     --法人编号
             ,A.ORG_ID               AS ORG_ID         --机构编号
             ,A.CUST_ID              AS CUST_ID        --客户编号
             ,A.ACC_ID               AS ACC_ID         --账户编号
             ,A.CUR                  AS ACC_CUR        --账户币种
             ,A.BAL                  AS ACC_BAL        --账户余额
             ,A.INT                  AS PBL_INT        --应付利息
             /*CASE
               WHEN 存款稳定性分类 LIKE 'A%' THEN
                A.DEP_BAL
               ELSE
                0
             END AS STABLE_DMD_DEP_BAL, --稳定活期存款余额*/
             ,'1301'                 AS DEP_PROD_TYP     --存款产品类型
             ,''                     AS IND_SETL_ACC_TYP --个人结算账户类型
             ,''                     AS SPCL_DEP_TYP     --专项存款类型
             ,A.START_DT             AS DEP_START_DT     --存款起始日期
             ,A.EXP_DT               AS DEP_EXP_DT       --存款到期日期
             ,'02'                   AS CUST_LRG_CL      --客户大类
             ,B.CUST_CL              AS CORP_CUST_TYP    --对公客户类型
             ,B.BIO_FLG              AS BIO_FLG          --境内外标志
             ,B.RSDNT_FLG            AS RSDNT_FLG        --居民标志
             ,CASE WHEN B.CUST_CL = 'E' THEN 'A'
                   ELSE ''
               END                   AS OPR_CUST_TYP     --经营性客户类型
             ,B.ENT_SCALE            AS ENT_SCALE        --企业规模
             ,B.FIN_ORG_TYP          AS FIN_ORG_TYP      --金融机构类型
             ,'2099'                 AS OPEN_ACC_CHAN    --开户渠道
             ,'Y'                    AS CBRC_FLG         --CBRC标志
             ,'Y'                    AS PBOC_FLG         --PBOC标志
             ,'N'                    AS BANK_CRD_MED_FLG --银行卡介质标志
             ,''                     AS REC_POOR_DEP_TYP -- 建档立卡贫困户存款类型
             ,'N'                    AS CNTY_DMN_RGN_FLG -- 县域地区标志
             ,'N'                    AS ALDY_OFF_POV_RGN_FLG -- 已脱贫地区标志
             ,'N'                    AS POV_ALLE_CNTY_FLG -- 重点帮扶县标志
             ,A.DEPT_LINE            AS DEPT_LINE        --部门条线
             ,A.DATA_SRC             AS DATA_SRC         --数据来源
             ,A.SUBJ_ID
             ,A.STD_PROD_ID
             ,A.CUST_ACCT_SUB_ACCT_NUM                   --客户账户子户号
             ,A.CASH_MANAGE_FLG      AS CASH_MANAGE_FLG --现金管理类产品标志 ADD BY 20250813
        FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
        JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.BIZ_TYP = '20107' --邮政储蓄银行协议存款
         AND B.FIN_ORG_TYP LIKE 'H%' --金融控股公司
         AND A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => 'S_DEP字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


 /* V_STEP := 7;
  V_STEP_DESC := '存款业务整合表--开发逻辑5-非存款类金融机构持有的同业存单';
  V_STARTTIME := SYSDATE;
  -- MODIFY BY LUZM 20221203 大额存单数据在分户表已出，无需从存单发行模型取数
  INSERT INTO S_DEP
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       ACC_ID, --账户编号
       ACC_CUR, --账户币种
       ACC_BAL, --账户余额
       PBL_INT, --应付利息
       \*STABLE_DMD_DEP_BAL, --稳定活期存款余额*\
       DEP_PROD_TYP, --存款产品类型
       IND_SETL_ACC_TYP, --个人结算账户类型
       SPCL_DEP_TYP, --专项存款类型
       DEP_START_DT, --存款起始日期
       DEP_EXP_DT, --存款到期日期
       CUST_LRG_CL, --客户大类
       CORP_CUST_TYP, --对公客户类型
       BIO_FLG, --境内外标志
       RSDNT_FLG, --居民标志
       OPR_CUST_TYP, --经营性客户类型
       ENT_SCALE, --企业规模
       FIN_ORG_TYP, --金融机构类型
       OPEN_ACC_CHAN, --开户渠道
       CBRC_FLG, --CBRC标志
       PBOC_FLG, --PBOC标志
       BANK_CRD_MED_FLG,--银行卡介质标志

       REC_POOR_DEP_TYP    , -- 建档立卡贫困户存款类型
       CNTY_DMN_RGN_FLG    , -- 县域地区标志
       ALDY_OFF_POV_RGN_FLG, -- 已脱贫地区标志
       POV_ALLE_CNTY_FLG   , -- 重点帮扶县标志

       DEPT_LINE, --部门条线
       DATA_SRC, --数据来源
       SUBJ_ID,
       STD_PROD_ID
       )
      SELECT A.DATA_DT    AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID     AS ORG_ID, --机构编号
             A.CUST_ID    AS CUST_ID, --客户编号
             A.ACC_ID     AS ACC_ID, --账户编号
             A.CUR        AS ACC_CUR, --账户币种
             A.BOOK_BAL   AS ACC_BAL, --账户余额
             A.PBL_INT    AS PBL_INT, --应付利息
             \*CASE
               WHEN 存款稳定性分类 LIKE 'A%' THEN
                A.DEP_BAL
               ELSE
                0
             END AS STABLE_DMD_DEP_BAL, --稳定活期存款余额*\
             '1500' AS DEP_PROD_TYP, --存款产品类型
             '' AS IND_SETL_ACC_TYP, --个人结算账户类型
             '' AS SPCL_DEP_TYP, --专项存款类型
             A.VAL_DT AS DEP_START_DT, --存款起始日期
             A.EXP_DT AS DEP_EXP_DT, --存款到期日期
             '02' AS CUST_LRG_CL, --客户大类
             B.CUST_CL AS CORP_CUST_TYP, --对公客户类型
             B.BIO_FLG AS BIO_FLG, --境内外标志
             B.RSDNT_FLG AS RSDNT_FLG, --居民标志
             CASE
               WHEN B.CUST_CL = 'E' THEN
                'A'
               ELSE
                ''
             END AS OPR_CUST_TYP, --经营性客户类型
             B.ENT_SCALE AS ENT_SCALE, --企业规模
             B.FIN_ORG_TYP AS FIN_ORG_TYP, --金融机构类型
             '2099' AS OPEN_ACC_CHAN, --开户渠道
             'Y' AS CBRC_FLG, --CBRC标志
             'Y' AS PBOC_FLG, --PBOC标志
             'N' AS BANK_CRD_MED_FLG,--银行卡介质标志

             ''  AS REC_POOR_DEP_TYP    , -- 建档立卡贫困户存款类型
             'N' AS CNTY_DMN_RGN_FLG    , -- 县域地区标志
             'N' AS ALDY_OFF_POV_RGN_FLG, -- 已脱贫地区标志
             'N' AS POV_ALLE_CNTY_FLG   , -- 重点帮扶县标志

             A.DEPT_LINE AS DEPT_LINE, --部门条线
             A.DATA_SRC AS DATA_SRC, --数据来源
             A.SUBJ_ID,
             '' AS STD_PROD_ID
        FROM M_CPTL_CD_ISSUE_INFO A --存单发行
        JOIN M_CUST_CORP_INFO B --对公客户信息表
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
       WHERE A.PROD_CL = '2' --同业存单
         AND A.DATA_DT = V_P_DATE;*/
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

     -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT,ACC_ID, CUST_ACCT_SUB_ACCT_NUM,COUNT(1)
      FROM S_DEP T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT,ACC_ID,CUST_ACCT_SUB_ACCT_NUM
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
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_DEP;
/

