CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_OUT_DUBILL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_OUT_DUBILL
  *  功能描述：表外业务整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CUST_CORP_INFO
  *            M_CUST_IND_INFO
  *            M_LOAN_BILL_INFO
  *            M_LOAN_ENTRS_SUB
  *            M_LOAN_IN_DUBILL_INFO
  *            M_LOAN_LGLC_INFO
  *
  *  目标表：  S_OUT_DUBILL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221108  hulj     保函与信用证部分证增加过滤条件
  *             2    20221119  于敬艺   限制只取表外业务里的银行承兑汇票承兑业务
  *             3    20221214  黄一凡   修改信用证、保函、卖断式转贴现部分机构号取账务机构号ACCT_INSTIT_ID，
  *                                      ORG_ID 存的是管理机构
  *             4    20230106  于敬艺   新增单户授信总额，加工银行承兑汇票、保函、信用证部分
  *             5    20230525  于敬艺   修改银行承兑汇票部分的余额，取票面出票表的票面余额
  *             6    20230529  HYF      修改银行承兑汇票部分的余额，改为取借据余额
  *             7    20230724  HYF      修改银行承兑汇票部分的余额，改为取当期余额
  *             8    20230808  HYF      暂时写死剔除5笔已撤票数据不报送，后续数仓模型加字段后按照票据状态判定
  *             9    20230907  HYF      修改银行承兑汇票过滤条件通过票据承兑状态剔除撤票BILL_ACPT_STATUS_CD
  *             10   20240312  LWB      新增到期日期字段
  *             11   20240607  lwb      补充客户授信总额字段
  *             12   20240805  HYF      新增信用证远期期限用于区分信用证一年以内还是一年以上
  *             13   20250207  HYF      m层模型调整，卖断式转帖现取合同状态为02-正常的数据
  *             14   20250903  HYF      调整单户授信总额取授信总额度（系统内转贴现）
  *             15   20260325  HYF      补充五级分类逻辑，直取模型字段
  **************************************************************************/
AS
  --定义变量 --
  V_STEP      INTEGER := 0;            --处理步骤
  V_P_DATE    VARCHAR2(8);             --跑批数据日期
  V_STARTTIME DATE;                    --处理开始时间
  V_ENDTIME   DATE;                    --处理结束时间
  V_SQLCOUNT  INTEGER := 0;            --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);           --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);           --任务名称
  V_PART_NAME VARCHAR2(100);           --分区名
  V_TAB_NAME  VARCHAR2(100) := 'S_OUT_DUBILL'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_OUT_DUBILL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统  --默认写监管报送系统，有真实来源的按实际写
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '--程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_OUT_DUBILL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_PARTITION_ADD(I_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '表外业务整合表--开发逻辑1-银行承兑汇票';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_OUT_DUBILL(
    DATA_DT,                 --数据日期
    LGL_REP_ID,              --法人编号
    ORG_ID,                  --机构编号
    ACC_ID,                  --账户编号
    CUST_ID,                 --客户编号
    CUR,                     --币种
    AMT,                     --金额
    BAL,                     --余额
    OCCUR_DT,                --发生日期
    OUT_BIZ_VRTY,            --表外业务品种
    CUST_LRG_CL,             --客户大类
    ENT_HLDG_TYP,            --企业控股类型
    CORP_CUST_TYP,           --对公客户类型
    OPR_CUST_TYP,            --经营性客户类型
    ENT_SCALE,               --企业规模
    CUST_BLNG_IDY,           --客户所属行业
    DIR_IDY,                 --投向行业
    BIO_FLG,                 --境内外标志
    PAY_TERM,                --支付期限
    MRGN,                    --保证金
    --PRO_IMPT,                --减值准备
    GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
    CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
    ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
    HIGH_TECH_ENT_FLG,       --高新企业标志
    DEPT_LINE,               --部门条线
    DATA_SRC,                --数据来源
    HIGH_TECH_IDY_MFG_CL,    --高新技术企业(制造业)分类
    MIC_COP_FLG,             --小额贷款公司标志
    SUBJ_ID,                 --科目编号
    RCPT_ID,                 --借据编号
    SGL_CRDT_AMT,            --单户授信总额
    ACCT_TYP,                --账户类型
    GRN_CRDT_USEAGE_CL,      --绿色授信用途分类 --ADD BY 于敬艺 20230131
    EXP_DT,                  --到期日期
    LVL5_CL                  --五级分类
    )
  SELECT A.DATA_DT                              AS DATA_DT,                 --数据日期
         A.LGL_REP_ID                           AS LGL_REP_ID,              --法人编号
         A.ORG_ID                               AS ORG_ID,                  --机构编号
         A.BILL_NO                              AS ACC_ID,                  --账户编号
         A.DRAWER_ID                            AS CUST_ID,                 --客户编号
         A.CUR                                  AS CUR,                     --币种
         A.BILL_PAR_AMT                         AS AMT,                     --金额
         CASE WHEN A.SUBJ_ID LIKE '7102%' AND A.CURRT_BAL = 0 THEN 0
              WHEN A.SUBJ_ID LIKE '7102%' THEN A.DUBIL_BAL
              ELSE A.CURRT_BAL
          END                                   AS BAL,                     --余额 MODIFY BY HYF 改为取当期余额
         A.BILL_ISU_DT                          AS OCCUR_DT,                --发生日期
         'A01'                                  AS OUT_BIZ_VRTY,            --表外业务品种
         CASE WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' THEN '01' --对私客户(含个体工商户)
              WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' THEN '02' --对公客户（剔除个体工商户）
          END                                   AS CUST_LRG_CL,             --客户大类
         B.ENT_HLDG_TYP                         AS ENT_HLDG_TYP,            --企业控股类型
         B.CUST_CL                              AS CORP_CUST_TYP,           --对公客户类型
         CASE WHEN B.CUST_CL = 'E' THEN 'A'
              ELSE C.OPR_CUST_TYP
          END                                   AS OPR_CUST_TYP,            --经营性客户类型
         B.ENT_SCALE                            AS ENT_SCALE,               --企业规模
         NVL(B.CUST_BLNG_IDY,C.CUST_BLNG_IDY)   AS CUST_BLNG_IDY,           --客户所属行业
         A.DIR_IDY                              AS DIR_IDY,                 --投向行业
         NVL(B.BIO_FLG,C.BIO_FLG)               AS BIO_FLG,                 --境内外标志
         0                                      AS PAY_TERM,                --支付期限
         A.MRGN                                 AS MRGN,                    --保证金
         --PRO_IMPT                               AS PRO_IMPT,                --减值准备
         A.GRN_CRDT_USEAGE_CL_1104              AS GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
         A.CER_MTG_CRDT_FLG                     AS CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
         A.ER_MTG_CRDT_FLG                      AS ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
         NVL(B.HIGH_TECH_ENT_FLG,'N')           AS HIGH_TECH_ENT_FLG,       --高新企业标志
         A.DEPT_LINE                            AS DEPT_LINE,               --部门条线
         '银行承兑汇票'                         AS DATA_SRC,                --数据来源
         CODE3.TAR_VALUE_CODE                   AS HIGH_TECH_IDY_MFG_CL,    --高技术产业（制造业）分类
         CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%' THEN 'Y'
              ELSE 'N'
          END                                   AS MIC_COP_FLG,             --小额贷款公司标志
         A.SUBJ_ID                              AS SUBJ_ID,                 --科目编号
         A.RCPT_ID                              AS RCPT_ID,                 --借据编号
         NVL(E.CRDT_TOTAL_LMT_ZT,0)             AS SGL_CRDT_AMT,            --单户授信总额 --MDF BY 20250903
         A.ACCT_TYP                             AS ACCT_TYP,                --账户类型
         A.GRN_CRDT_USEAGE_CL                   AS GRN_CRDT_USEAGE_CL,      --绿色授信用途分类 --ADD BY 于敬艺 20230131
         A.BILL_EXP_DT                          AS EXP_DT,                  --到期日期
         A.LVL5_CL                              AS LVL5_CL                  --五级分类
    FROM RRP_MDL.M_LOAN_BILL_INFO A --票据出票表
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
      ON B.CUST_ID = A.DRAWER_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
      ON C.CUST_ID = A.DRAWER_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = A.DRAWER_ID
     AND E.DATA_DT = V_P_DATE    
    LEFT JOIN RRP_MDL.CODE_MAP CODE3 --配置表
      ON CODE3.SRC_VALUE_CODE = A.DIR_IDY
     AND CODE3.SRC_CLASS_CODE = 'P0003' --行业分类
     AND CODE3.TAR_CLASS_CODE = 'T0025' --高技术产业（制造业）分类
     AND CODE3.MOD_FLG = 'MDM'
   WHERE A.BILL_BIZ_TYP = '01' --银行承兑汇票
     AND A.STD_PROD_ID = '601010100001' --表外业务 银行承兑汇票承兑业务
     --AND A.RCPT_ID NOT IN ('20230728000170005','20230728000170002','20230728000170004','20230728000170001','20230728000170003') --剔除撤票
     AND A.BILL_ACPT_STATUS_CD <> '09' --剔除撤票
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '表外业务整合表--开发逻辑2-保函与信用证';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_OUT_DUBILL(
    DATA_DT,                 --数据日期
    LGL_REP_ID,              --法人编号
    ORG_ID,                  --机构编号
    ACC_ID,                  --账户编号
    CUST_ID,                 --客户编号
    CUR,                     --币种
    AMT,                     --金额
    BAL,                     --余额
    OCCUR_DT,                --发生日期
    OUT_BIZ_VRTY,            --表外业务品种
    CUST_LRG_CL,             --客户大类
    ENT_HLDG_TYP,            --企业控股类型
    CORP_CUST_TYP,           --对公客户类型
    OPR_CUST_TYP,            --经营性客户类型
    ENT_SCALE,               --企业规模
    CUST_BLNG_IDY,           --客户所属行业
    DIR_IDY,                 --投向行业
    BIO_FLG,                 --境内外标志
    PAY_TERM,                --支付期限
    MRGN,                    --保证金
    --PRO_IMPT,                --减值准备
    GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
    CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
    ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
    HIGH_TECH_ENT_FLG,       --高新企业标志
    DEPT_LINE,               --部门条线
    DATA_SRC,                --数据来源
    HIGH_TECH_IDY_MFG_CL,    --高新技术企业(制造业)分类
    ORIG_TERM_CODE,          --原始期限类型
    MIC_COP_FLG,             --小额贷款公司标志
    SUBJ_ID,                 --科目编号
    RCPT_ID,                 --借据编号
    SGL_CRDT_AMT,            --单户授信总额
    ACCT_TYP,                --账户类型
    GRN_CRDT_USEAGE_CL,      --绿色授信用途分类 --ADD BY 于敬艺 20230131
    EXP_DT,                  --到期日期
    FWD_TENOR,               --远期期限
    LVL5_CL                  --五级分类
    )
  SELECT A.DATA_DT                              AS DATA_DT,                 --数据日期
         A.LGL_REP_ID                           AS LGL_REP_ID,              --法人编号
         A.ACCT_INSTIT_ID                       AS ORG_ID,                  --机构编号
         A.BIZ_ID                               AS ACC_ID,                  --账户编号
         A.APP_PSN_ID                           AS CUST_ID,                 --客户编号
         A.CUR                                  AS CUR,                     --币种
         --A.CONT_AMT                             AS AMT,                     --金额
         A.TRAN_AMT                             AS AMT,                     --金额
         A.BAL                                  AS BAL,                     --余额
         A.CONT_START_DT                        AS OCCUR_DT,                --发生日期
         A.OUT_BIZ_TYP                          AS OUT_BIZ_VRTY,            --表外业务品种
         CASE WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' THEN '01' --对私客户(含个体工商户)
              WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' THEN '02' --对公客户（剔除个体工商户）
          END                                   AS CUST_LRG_CL,             --客户大类
         B.ENT_HLDG_TYP                         AS ENT_HLDG_TYP,            --企业控股类型
         B.CUST_CL                              AS CORP_CUST_TYP,           --对公客户类型
         CASE WHEN B.CUST_CL = 'E' THEN 'A'
              ELSE C.OPR_CUST_TYP
          END                                   AS OPR_CUST_TYP,            --经营性客户类型
         B.ENT_SCALE                            AS ENT_SCALE,               --企业规模
         NVL(B.CUST_BLNG_IDY,C.CUST_BLNG_IDY)   AS CUST_BLNG_IDY,           --客户所属行业
         A.DIR_IDY                              AS DIR_IDY,                 --投向行业
         NVL(B.BIO_FLG,C.BIO_FLG)               AS BIO_FLG,                 --境内外标志
         A.PAY_TERM                             AS PAY_TERM,                --支付期限
         A.MRGN                                 AS MRGN,                    --保证金
         --PRO_IMPT                               AS PRO_IMPT,                --减值准备
         A.GRN_CRDT_USEAGE_CL_1104              AS GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
         A.CER_MTG_CRDT_FLG                     AS CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
         A.ER_MTG_CRDT_FLG                      AS ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
         NVL(B.HIGH_TECH_ENT_FLG,'N')           AS HIGH_TECH_ENT_FLG,       --高新企业标志
         A.DEPT_LINE                            AS DEPT_LINE,               --部门条线
         '保函与信用证'                         AS DATA_SRC,                --数据来源
         CODE3.TAR_VALUE_CODE                   AS HIGH_TECH_IDY_MFG_CL,    --高技术产业（制造业）分类
         A.ORIG_TERM_CODE                       AS ORIG_TERM_CODE,          --原始期限类型
         CASE WHEN B.CUST_NM LIKE '%小额贷款%' OR B.CUST_NM LIKE '%小额再贷款%' THEN 'Y'
              ELSE 'N'
          END                                   AS MIC_COP_FLG,             --小额贷款公司标志
         A.SUBJ_ID                              AS SUBJ_ID,                 --科目编号
         A.DUBIL_ID                             AS RCPT_ID,                 --借据编号
         NVL(E.CRDT_TOTAL_LMT_ZT,0)             AS SGL_CRDT_AMT,            --单户授信总额 --ADD BY 于敬艺 20230106
         A.ACCT_TYP                             AS ACCT_TYP,                --账户类型
         A.GRN_CRDT_USEAGE_CL                   AS GRN_CRDT_USEAGE_CL,      --绿色授信用途分类 --ADD BY 于敬艺 20230131
         A.EXP_DT                               AS EXP_DT,                  --到期日期
         A.FWD_TENOR                            AS FWD_TENOR,               --远期期限
         A.LVL5_CL                              AS LVL5_CL                  --五级分类
    FROM RRP_MDL.M_LOAN_LGLC_INFO A --保函与信用证信息表
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息表
      ON B.CUST_ID = A.APP_PSN_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息
      ON C.CUST_ID = A.APP_PSN_ID
     AND C.DATA_DT = V_P_DATE       
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO E --授信额度主表
      ON E.CUST_ID = A.APP_PSN_ID
     AND E.DATA_DT = V_P_DATE     
    LEFT JOIN RRP_MDL.CODE_MAP CODE3 --配置表
      ON CODE3.SRC_VALUE_CODE = A.DIR_IDY
     AND CODE3.SRC_CLASS_CODE = 'P0003' --行业分类
     AND CODE3.TAR_CLASS_CODE = 'T0025' --高技术产业（制造业）分类
     AND CODE3.MOD_FLG = 'MDM'
   WHERE A.DATA_SRC IN ('保函','信用证')
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 5;
  V_STEP_DESC := '表外业务整合表--开发逻辑3-委托贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_OUT_DUBILL(
    DATA_DT,                 --数据日期
    LGL_REP_ID,              --法人编号
    ORG_ID,                  --机构编号
    ACC_ID,                  --账户编号
    CUST_ID,                 --客户编号
    CUR,                     --币种
    AMT,                     --金额
    BAL,                     --余额
    OCCUR_DT,                --发生日期
    OUT_BIZ_VRTY,            --表外业务品种
    CUST_LRG_CL,             --客户大类
    ENT_HLDG_TYP,            --企业控股类型
    CORP_CUST_TYP,           --对公客户类型
    OPR_CUST_TYP,            --经营性客户类型
    ENT_SCALE,               --企业规模
    CUST_BLNG_IDY,           --客户所属行业
    DIR_IDY,                 --投向行业
    BIO_FLG,                 --境内外标志
    PAY_TERM,                --支付期限
    MRGN,                    --保证金
    --PRO_IMPT,                --减值准备
    GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
    CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
    ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
    HIGH_TECH_ENT_FLG,       --高新企业标志
    DEPT_LINE,               --部门条线
    DATA_SRC,                --数据来源
    MIC_COP_FLG,             --小额贷款公司标志
    SUBJ_ID,                 --科目编号
    RCPT_ID,                 --借据编号
    EXP_DT,                  --到期日期
    SGL_CRDT_AMT,            --单户授信金额
    LVL5_CL                  --五级分类
    )
  SELECT A.DATA_DT                              AS DATA_DT,                 --数据日期
         A.LGL_REP_ID                           AS LGL_REP_ID,              --法人编号
         A.ORG_ID                               AS ORG_ID,                  --机构编号
         A.RCPT_ID                              AS ACC_ID,                  --账户编号
         A.CUST_ID                              AS CUST_ID,                 --客户编号
         A.CUR                                  AS CUR,                     --币种
         A.LOAN_AMT                             AS AMT,                     --金额
         A.LOAN_BAL                             AS BAL,                     --余额
         A.LOAN_ACT_DSTR_DT                     AS OCCUR_DT,                --发生日期
         CASE /*WHEN M1.JYWYM IS NOT NULL THEN DECODE(NVL(M1.SFXJGLXX,'N'),'Y','C0201') --补录表出现金管理项下委托贷款*/
              WHEN B.ENTRS_LOAN_SUM_CL = '9011' THEN 'C0201' --现金管理项下委托贷款
              WHEN B.ENTRS_LOAN_SUM_CL = '9012' AND E.FIN_ORG_TYP IS NOT NULL THEN 'C0202' --金融机构委托贷款
              WHEN B.ENTRS_LOAN_SUM_CL = '9012' AND B.CONSR_TYP = '04' THEN 'C020301' --公积金委托贷款
              ELSE 'C020302' --其他非金融机构委托贷款
          END                                   AS OUT_BIZ_VRTY,            --表外业务品种
         CASE WHEN D.CUST_ID IS NOT NULL OR C.CUST_CL = 'E' THEN '01' --对私客户(含个体工商户)
              WHEN C.CUST_ID IS NOT NULL AND C.CUST_CL != 'E' THEN '02' --对公客户（剔除个体工商户）
          END                                   AS CUST_LRG_CL,             --客户大类
         C.ENT_HLDG_TYP                         AS ENT_HLDG_TYP,            --企业控股类型
         C.CUST_CL                              AS CORP_CUST_TYP,           --对公客户类型
         CASE WHEN C.CUST_CL = 'E' THEN 'A'
              ELSE D.OPR_CUST_TYP
          END                                   AS OPR_CUST_TYP,            --经营性客户类型
         C.ENT_SCALE                            AS ENT_SCALE,               --企业规模
         NVL(C.CUST_BLNG_IDY,D.CUST_BLNG_IDY)   AS CUST_BLNG_IDY,           --客户所属行业
         A.LOAN_DIR_IDY                         AS DIR_IDY,                 --投向行业
         NVL(C.BIO_FLG,C.BIO_FLG)               AS BIO_FLG,                 --境内外标志
         0                                      AS PAY_TERM,                --支付期限
         A.MRGN                                 AS MRGN,                    --保证金
         --PRO_IMPT                               AS PRO_IMPT,                --减值准备
         G.GRN_LOAN_USEAGE_CL_1104              AS GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
         'N'                                    AS CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
         'N'                                    AS ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
         NVL(C.HIGH_TECH_ENT_FLG,'N')           AS HIGH_TECH_ENT_FLG,       --高新企业标志
         A.DEPT_LINE                            AS DEPT_LINE,               --部门条线
         '委托贷款'                             AS DATA_SRC,                --数据来源
         CASE WHEN C.CUST_NM LIKE '%小额贷款%' OR C.CUST_NM LIKE '%小额再贷款%' THEN 'Y'
              ELSE 'N'
          END                                   AS MIC_COP_FLG,             --小额贷款公司标志
          A.SUBJ_ID                             AS SUBJ_ID,                 --科目编号
          A.RCPT_ID                             AS RCPT_ID,                 --借据编号
          A.LOAN_ORIG_EXP_DT                    AS EXP_DT,                  --到期日期
          NVL(F.CRDT_TOTAL_LMT_ZT,0)            AS SGL_CRDT_AMT,            --单户授信金额
          A.LVL5_CL                             AS LVL5_CL                  --五级分类
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
    LEFT JOIN RRP_MDL.M_LOAN_ENTRS_SUB B --委托贷款子表
      ON B.RCPT_ID = A.RCPT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_LOAN_GREEN_SUB G --绿色贷款子表
      ON G.RCPT_ID = A.RCPT_ID
     AND G.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = A.CUST_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO E --对公客户信息表
      ON E.CUST_ID = B.CONSR_CUST_ID
     AND E.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO F --授信额度主表
      ON F.CUST_ID = A.CUST_ID
     AND F.DATA_DT = V_P_DATE
   WHERE A.LOAN_BIZ_TYP = '90' --委托贷款
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 6;
  V_STEP_DESC := '表外业务整合表--卖断式转贴现';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_OUT_DUBILL(
    DATA_DT,                 --数据日期
    LGL_REP_ID,              --法人编号
    ORG_ID,                  --机构编号
    ACC_ID,                  --账户编号
    CUST_ID,                 --客户编号
    CUR,                     --币种
    AMT,                     --金额
    BAL,                     --余额
    OCCUR_DT,                --发生日期
    OUT_BIZ_VRTY,            --表外业务品种
    CUST_LRG_CL,             --客户大类
    ENT_HLDG_TYP,            --企业控股类型
    CORP_CUST_TYP,           --对公客户类型
    OPR_CUST_TYP,            --经营性客户类型
    ENT_SCALE,               --企业规模
    CUST_BLNG_IDY,           --客户所属行业
    DIR_IDY,                 --投向行业
    BIO_FLG,                 --境内外标志
    PAY_TERM,                --支付期限
    MRGN,                    --保证金
    --PRO_IMPT,                --减值准备
    GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
    CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
    ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
    HIGH_TECH_ENT_FLG,       --高新企业标志
    DEPT_LINE,               --部门条线
    DATA_SRC,                --数据来源
    MIC_COP_FLG,             --小额贷款公司标识
    SUBJ_ID,                 --科目编号
    RCPT_ID,                 --借据编号
    EXP_DT,                  --到期日期
    SGL_CRDT_AMT,            --单户授信金额
    LVL5_CL                  --五级分类
    )
  SELECT A.DATA_DT                              AS DATA_DT,                 --数据日期
         A.LGL_REP_ID                           AS LGL_REP_ID,              --法人编号
         A.ACCT_INSTIT_ID                       AS ORG_ID,                  --机构编号
         A.BIZ_ID                               AS ACC_ID,                  --账户编号
         A.CUST_ID                              AS CUST_ID,                 --客户编号
         A.CUR                                  AS CUR,                     --币种
         A.TRAN_AMT                             AS AMT,                     --金额
         A.BAL                                  AS BAL,                     --余额
         A.BUS_DT                               AS OCCUR_DT,                --发生日期
         A.OUT_BIZ_TYP                          AS OUT_BIZ_VRTY,            --表外业务品种
         CASE WHEN D.CUST_ID IS NOT NULL OR C.CUST_CL = 'E' THEN '01' --对私客户(含个体工商户)
              WHEN C.CUST_ID IS NOT NULL AND C.CUST_CL != 'E' THEN '02' --对公客户（剔除个体工商户）
          END                                   AS CUST_LRG_CL,             --客户大类
         C.ENT_HLDG_TYP                         AS ENT_HLDG_TYP,            --企业控股类型
         C.CUST_CL                              AS CORP_CUST_TYP,           --对公客户类型
         CASE WHEN C.CUST_CL = 'E' THEN 'A'
              ELSE D.OPR_CUST_TYP
          END                                   AS OPR_CUST_TYP,            --经营性客户类型
        --C.ENT_SCALE                             AS ENT_SCALE,               --企业规模
        CASE WHEN SUBSTR(A.OUT_BIZ_TYP,1,3) = 'A04'
             THEN NVL(C.ENT_SCALE,'M')--MODIFY 于敬艺 20221229 根据严希婧要求修改销售协议业务无直贴人企业规模，默认为M:中型企业
             ELSE C.ENT_SCALE
          END                                   AS ENT_SCALE,               --企业规模
         NVL(C.CUST_BLNG_IDY,D.CUST_BLNG_IDY)   AS CUST_BLNG_IDY,           --客户所属行业
         NULL                                   AS DIR_IDY,                 --投向行业
         NVL(C.BIO_FLG,C.BIO_FLG)               AS BIO_FLG,                 --境内外标志
         0                                      AS PAY_TERM,                --支付期限
         A.MRGN                                 AS MRGN,                    --保证金
         --PRO_IMPT                               AS PRO_IMPT,                --减值准备
         A.GRN_CRDT_USEAGE_CL_1104              AS GRN_CRDT_USEAGE_CL_1104, --绿色授信用途分类1104
         'N'                                    AS CER_MTG_CRDT_FLG,        --以碳排放权为抵押的授信标志
         'N'                                    AS ER_MTG_CRDT_FLG,         --以环境权益为抵押的授信标志
         NVL(C.HIGH_TECH_ENT_FLG,'N')           AS HIGH_TECH_ENT_FLG,       --高新企业标志
         A.DEPT_LINE                            AS DEPT_LINE,               --部门条线
         '卖断式转贴现'                         AS DATA_SRC,                --数据来源
         CASE WHEN C.CUST_NM LIKE '%小额贷款%' OR C.CUST_NM LIKE '%小额再贷款%' THEN 'Y'
              ELSE 'N'
          END                                   AS MIC_COP_FLG,             --小额贷款公司标志
         A.SUBJ_ID                              AS SUBJ_ID,                 --科目编号
         A.DUBIL_ID                             AS RCPT_ID,                 --借据编号
         A.EXP_DT                               AS EXP_DT,                  --到期日期
         NVL(F.CRDT_TOTAL_LMT_ZT,0)             AS SGL_CRDT_AMT,            --单户授信金额
         A.LVL5_CL                              AS LVL5_CL                  --五级分类
    FROM RRP_MDL.M_LOAN_LGLC_INFO A --保函与信用证信息      
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息表
      ON C.CUST_ID = A.CUST_ID
     AND C.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
      ON D.CUST_ID = A.CUST_ID
     AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO F --授信额度主表
      ON F.CUST_ID = A.CUST_ID
     AND F.DATA_DT = V_P_DATE   
   WHERE A.CONT_STAT = '02'
     AND A.DATA_SRC = '卖断式转贴现' --卖断式转贴现
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '--程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  --插入过程跑批完成记录表
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_OUT_DUBILL;
/

