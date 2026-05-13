CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_CPTL_CD_ISSUE_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_CPTL_CD_ISSUE_INFO
  *  功能描述：存单发行信息
  *  创建日期：20220608
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_CPTL_CD_ISSUE_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220608  梅炜     首次创建
  *             2    20220822  hulj     调整取数逻辑，修改同业资金客户号取值
  *             3    20220901  hulj     新增字段科目号
  *             4    20221114  hulj     增加数据重复校验
  *             5    20230508  hyf      调整同业存单账目余额字段逻辑，由取实际余额改为取当期余额字段
  *             6    20230605  xuxiaobin 新增开户金额字段取值
  *             7    20240411  HYF      按业务口径调整单位存款类型 C_DEPOSIT_TYPE
  *             8    20240501  HYF      同业存单发行日期原为空值，补上逻辑;新增发行金额
  *             9    20240603  YJY      调整大额存单部分发行日期，发行金额补上逻辑
  *             10   20240615  LWB      修改逻辑大额存单部分发行日期，发行金额补上逻辑
  *             11   20241015  HYF      修改同业存单到期日期逻辑
  *             12   20250813  HYF      新增现金管理类产品标志
  *             13   20250928  YJY      修改单位存款类型的码值
  *             14   20260225  LYH      增加SPV类型代码
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_CPTL_CD_ISSUE_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_CPTL_CD_ISSUE_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_CPTL_CD_ISSUE_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CPTL_CD_ISSUE_INFO '||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存单发行信息--大额存单';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_ISSUE_INFO
    (DATA_DT            --1  数据日期
    ,LGL_REP_ID         --2  法人编号
    ,CUST_ID            --3  客户编号
    ,ORG_ID             --4  机构编号
    ,ACC_ID             --5  账户编号
    ,CNTPR_ID           --6  交易对手编号
    ,CD_NO              --7  存单号
    ,PBC_ACC_TYP        --8  人行账户类型
    ,ACC_TYP            --9  账户类型
    ,PROD_CL            --10  产品分类
    ,CUR                --11  币种
    ,BOOK_BAL           --12  账面余额
    ,PBL_INT            --13  应付利息
    ,ISU_DT             --14  发行日期
    ,VAL_DT             --15  起息日期
    ,EXP_DT             --16  到期日期
    ,MKT_VAL            --17  市场价值
    ,DEP_INS_AMT        --18  被存款保险制度覆盖的金额
    ,DUR                --19  久期
    ,MOD_DUR            --20  修正久期
    ,OPEN_ACC_TLR_NO    --21  开户柜员号
    ,CNL_ACC_DT         --22  销户日期
    ,ACC_STAT           --23  账户状态
    ,LAST_ACC_CHG_DT    --24  上次动户日期
    ,OPEN_ACC_AMT       --25  开户金额
    ,DEP_STABLE_CL      --26  存款稳定性分类
    ,RATE               --27  利率
    ,GL_CL              --28  会计分类
    ,BIO_FLG            --29  境内外标志
    ,DEP_RSV_MODE       --30  缴存准备金方式
    ,DEPT_LINE          --31  部门条线
    ,DATA_SRC           --32  数据来源
    ,SUB_ACC_ID         --33  子账户编号
    ,SUBJ_ID            --34  科目编号
    ,C_DEPOSIT_TYPE     --35  单位存款类型
    ,SRC_CUST_ID        --36 穿透前客户号
    ,FROZ_FLG           --37 冻结标志
    ,STOP_PAY_STATUS_CD --38 止付状态代码
    ,LG_FROZ_FLG        --39 司法冻结标志
    ,ISSUE_AMT          --40 发行金额 --ADD BY 20240603
    )
  WITH TMP AS (
       SELECT C.PD_CD
              ,SUM(C.PD_ISSUE_AMT)   AS PD_ISSUE_AMT
              ,MAX(C.ISSUE_BEGIN_DT) AS ISSUE_BEGIN_DT
        FROM RRP_MDL.O_IML_AGT_CDS_H C --大额存单历史 ADD BY 20240603
       WHERE C.PD_PROD_CATE_CD = 'DC' --期次产品类别代码
         AND C.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
         AND C.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY C.PD_CD )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')              AS DATA_DT            --1  数据日期
        ,A.LP_ID                                   AS LGL_REP_ID         --2  法人编号
        ,A.CUST_ID                                 AS CUST_ID            --3  客户编号
        ,A.BELONG_ORG_ID                           AS ORG_ID             --4  机构编号
        ,A.CUST_ACCT_ID                            AS ACC_ID             --5  账户编号
        ,A.CUST_ID                                 AS CNTPR_ID           --6  交易对手编号
        ,NULL                                      AS CD_NO              --7  存单号
        ,A.ACCT_CLS_CD                             AS PBC_ACC_TYP        --8  人行账户类型
        ,A.ACCT_TYPE_CD                            AS ACC_TYP            --9  账户类型
        ,'2'                                       AS PROD_CL            --10  产品分类 储种代码
        ,A.CURR_CD                                 AS CUR                --11  币种
        ,A.CURRT_BAL                               AS BOOK_BAL           --12  账面余额
        ,A.CURRT_ACRU_INT                          AS PBL_INT            --13  应付利息
        ,TO_CHAR(C.ISSUE_BEGIN_DT,'YYYYMMDD')      AS ISU_DT             --14  发行日期 --MOD BY 20240603
        ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')            AS VAL_DT             --15  起息日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')              AS EXP_DT             --16  到期日期
        ,NULL                                      AS MKT_VAL            --17  市场价值
        ,NULL                                      AS DEP_INS_AMT        --18  被存款保险制度覆盖的金额
        ,NULL                                      AS DUR                --19  久期
        ,NULL                                      AS MOD_DUR            --20  修正久期
        ,A.OPEN_ACCT_TELLER_ID                     AS OPEN_ACC_TLR_NO    --21  开户柜员号
        ,TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')        AS CNL_ACC_DT         --22  销户日期
        ,A.DEP_ACCT_STATUS_CD                      AS ACC_STAT           --23  账户状态 --存款账户状态
        ,TO_CHAR(A.FINAL_ACTIV_ACCT_DT,'YYYYMMDD') AS LAST_ACC_CHG_DT    --24  上次动户日期
        ,A.OPEN_ACCT_AMT                           AS OPEN_ACC_AMT       --25  开户金额
        ,NULL                                      AS DEP_STABLE_CL      --26  存款稳定性分类
        ,A.EXEC_INT_RAT                            AS RATE               --27  利率
        ,NULL                                      AS GL_CL              --28  会计分类
        ,'Y'                                       AS BIO_FLG            --29  境内外标志
        ,NULL                                      AS DEP_RSV_MODE       --30  缴存准备金方式
        ,NULL                                      AS DEPT_LINE          --31  部门条线
        ,'大额存单_存款分户'                       AS DATA_SRC           --32  数据来源
        ,A.CUST_ACCT_SUB_ACCT_NUM                  AS SUB_ACC_ID         --33  子账户编号
        ,A.SUBJ_ID                                 AS SUBJ_ID            --34  科目编号
        ,CASE WHEN SUBSTR(COALESCE(E.SOCI_CRDT_CD,E.NATION_TAX_RGST_CERT_NUM,E.LOCAL_TAX_RGST_CERT_NUM,E.RGSTION_CD),0,2) IN ('N1','N2','N3')
              THEN 'B'
              WHEN E.DEPOSITR_CATE_CD = '101' THEN 'A' --企业法人
              WHEN E.DEPOSITR_CATE_CD IN ('103','104','105','108','109','115') --103 机关 3-其他财政性存款 4-其他--20231107HULJ根据上游调整码值
                   AND A.DEP_CHAR_CD IN ('CZCK','-',/*'4','5'*/'31','32','41') THEN 'B' 
                   --MOD BY YJY 20250928 修改存款性质代码，旧的4-其他财政性存款、5-其他改为31-其他财政性存款-债券质押、32-其他财政性存款-非债券质押、41-其他
              WHEN E.DEPOSITR_CATE_CD = '103' AND A.DEP_CHAR_CD IN (/*'1','2'*/'11','12','JJSB') --'JJSB' 基金社保
                   --MOD BY YJY 20250928 修改存款性质代码，旧的1-社保基金-债券质押、2-社保基金-非债券质押改为11-社保基金-债券质押、12-社保基金-非债券质押
              THEN 'C'
              WHEN E.DEPOSITR_CATE_CD IN ('106','107') THEN 'D'
              WHEN A.DEP_CHAR_CD IN (/*'3'*/'21','22','GJJ') THEN 'E' --MDF BY WZJ 20211228 区分社保基金跟机关团体存款
                  --MOD BY YJY 20250928 修改存款性质代码，旧的3-住房公积金改为21-住房公积金-债券质押、22-住房公积金-非债券质押
              WHEN E.CUST_ID IS NOT NULL THEN 'A'
          END                                      AS C_DEPOSIT_TYPE     --35  单位存款类型
        ,A.CUST_ID                                 AS SRC_CUST_ID        --36 穿透前客户号
        ,A.FROZ_FLG                                AS FROZ_FLG           --37 冻结标志
        ,A.STOP_PAY_STATUS_CD                      AS STOP_PAY_STATUS_CD --38 止付状态代码
        ,CASE WHEN DJ.DEP_SUB_ACCT_ID IS NOT NULL THEN '1'
              ELSE '0'
          END                                      AS LG_FROZ_FLG        --39 司法冻结标志
        ,C.PD_ISSUE_AMT                            AS ISSUE_AMT          --40 发行金额 ADD BY 20240603
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    LEFT JOIN TMP C
      ON C.PD_CD = A.PD_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E --对公客户信息表 区分社保或财政性 ADD BY20220707 XUCX
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DISTINCT DEP_SUB_ACCT_ID
                 FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL --存款账户冻结止付明细
                WHERE FROZ_STOP_PAY_BUS_WAY_CD IN ('004','005') --司法冻结
                  AND FROZ_STOP_PAY_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --冻结开始日期
                  AND FROZ_END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') --冻结截止日期
                  AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) DJ
      ON DJ.DEP_SUB_ACCT_ID = A.ACCT_ID
   WHERE A.SUBJ_ID IN ('20110103','20110203')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入资金系统-同业存单';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_CPTL_CD_ISSUE_INFO
    (DATA_DT            --1  数据日期
    ,LGL_REP_ID         --2  法人编号
    ,CUST_ID            --3  客户编号
    ,ORG_ID             --4  机构编号
    ,ACC_ID             --5  账户编号
    ,CNTPR_ID           --6  交易对手编号
    ,CD_NO              --7  存单号
    ,PBC_ACC_TYP        --8  人行账户类型
    ,ACC_TYP            --9  账户类型
    ,PROD_CL            --10 产品分类
    ,CUR                --11 币种
    ,BOOK_BAL           --12 账面余额
    ,PBL_INT            --13 应付利息
    ,ISU_DT             --14 发行日期
    ,VAL_DT             --15 起息日期
    ,EXP_DT             --16 到期日期
    ,MKT_VAL            --17 市场价值
    ,DEP_INS_AMT        --18 被存款保险制度覆盖的金额
    ,DUR                --19 久期
    ,MOD_DUR            --20 修正久期
    ,OPEN_ACC_TLR_NO    --21 开户柜员号
    ,CNL_ACC_DT         --22 销户日期
    ,ACC_STAT           --23 账户状态
    ,LAST_ACC_CHG_DT    --24 上次动户日期
    ,OPEN_ACC_AMT       --25 开户金额
    ,DEP_STABLE_CL      --26 存款稳定性分类
    ,RATE               --27 利率
    ,GL_CL              --28 会计分类
    ,BIO_FLG            --29 境内外标志
    ,DEP_RSV_MODE       --30 缴存准备金方式
    ,DEPT_LINE          --31 部门条线
    ,DATA_SRC           --32 数据来源
    ,SUB_ACC_ID         --33 子账户编号
    ,SUBJ_ID            --34 科目编号
    ,CNTPTY_NAME        --35 交易对手名称
    ,SRC_CUST_ID        --36 穿透前客户号
    ,SPV_ID             --37 SPV编号
    ,C_DEPOSIT_TYPE     --38 单位存款类型
    ,FROZ_FLG           --39 冻结标志
    ,STOP_PAY_STATUS_CD --40 止付状态代码
    ,LG_FROZ_FLG        --41 司法冻结标志
    ,CNTPTY_FNAME       --42 交易对手全称
    ,SPV_CUST_ID        --43 SPV客户号
    ,ISSUE_AMT          --44 发行金额
    ,CASH_MANAGE_FLG    --45 现金管理类产品标志
    ,SPV_TYPE_CD        --46 SPV类型代码 ADD BY LYH 20260225
    )
  SELECT TO_CHAR(T.ETL_DT,'YYYYMMDD')              AS DATA_DT            --1  数据日期
        ,T.LP_ID                                   AS LGL_REP_ID         --2  法人编号
        ,T.CNTPTY_ID                               AS CUST_ID            --3  客户编号
        ,A.ENTRY_ORG_ID                            AS ORG_ID             --4  机构编号
        ,T.TRAN_ACCT_ID                            AS ACC_ID             --5  账户编号
        ,T.CNTPTY_ID                               AS CNTPR_ID           --6  交易对手编号
        ,T.BOND_ID||'_'||T.TRAN_ACCT_B_ID          AS CD_NO              --7  存单号
        ,NULL                                      AS PBC_ACC_TYP        --8  人行账户类型
        ,NULL                                      AS ACC_TYP            --9  账户类型
        ,'1'                                       AS PROD_CL            --10 产品分类 同业存单
        ,A.CURR_CD                                 AS CUR                --11 币种
        ,T.BOND_FAC_VAL                            AS BOOK_BAL           --12 账面余额 债券面值
        ,T.ACRU_INT                                AS PBL_INT            --13 应付利息
        ,TO_CHAR(B.ISSUE_DT,'YYYYMMDD')            AS ISU_DT             --14 发行日期
        ,TO_CHAR(B.VALUE_DT,'YYYYMMDD')            AS VAL_DT             --15 起息日期
        ,TO_CHAR(B.EXP_DT,'YYYYMMDD')              AS EXP_DT             --16 到期日期
        ,T.BOND_FAC_VAL                            AS MKT_VAL            --17 市场价值 --20230605 XUXIAOBIN MODIFY
        ,NULL                                      AS DEP_INS_AMT        --18 被存款保险制度覆盖的金额
        ,NULL                                      AS DUR                --19 久期
        ,NULL                                      AS MOD_DUR            --20 修正久期
        ,NULL                                      AS OPEN_ACC_TLR_NO    --21 开户柜员号
        ,NULL                                      AS CNL_ACC_DT         --22 销户日期
        ,'01'                                      AS ACC_STAT           --23 账户状态 0新建，1正常，3停用，null未知
        ,NULL                                      AS LAST_ACC_CHG_DT    --24 上次动户日期
        ,T.BOND_FAC_VAL                            AS OPEN_ACC_AMT       --25 开户金额 --20230605 XUXIAOBIN MODIFY
        ,NULL                                      AS DEP_STABLE_CL      --26 存款稳定性分类
        ,B.ISSUE_INT_RAT                           AS RATE               --27 利率
        ,NULL                                      AS GL_CL              --28 会计分类
        ,NULL                                      AS BIO_FLG            --29 境内外标志
        ,NULL                                      AS DEP_RSV_MODE       --30 缴存准备金方式
        ,'Y'                                       AS DEPT_LINE          --31 部门条线
        ,'资金现券交易'                            AS DATA_SRC           --32 数据来源
        ,NULL                                      AS SUB_ACC_ID         --33 子账户编号
        ,A.SUBJ_ID                                 AS SUBJ_ID            --34 科目编号
        ,T.CNTPTY_NAME                             AS CNTPTY_NAME        --35 交易对手名称
        ,NULL                                      AS SRC_CUST_ID        --36 穿透前客户号
        ,NULL                                      AS SPV_ID             --37 SPV编号
        ,NULL                                      AS C_DEPOSIT_TYPE     --38 单位存款类型
        ,NULL                                      AS FROZ_FLG           --49 冻结标志
        ,NULL                                      AS STOP_PAY_STATUS_CD --40 止付状态代码
        ,NULL                                      AS LG_FROZ_FLG        --41 司法冻结标志志
        ,NULL                                      AS CNTPTY_FNAME       --42 交易对手全称
        ,NULL                                      AS SPV_CUST_ID        --43 SPV客户号
        ,0                                         AS ISSUE_AMT          --44 发行金额 逻辑待定
        ,'N'                                       AS CASH_MANAGE_FLG    --45 现金管理类产品标志 ADD BY 20250813
        ,NULL                                      AS SPV_TYPE_CD        --46 SPV类型代码 ADD BY LYH 20260225
    FROM RRP_MDL.O_ICL_CMM_CAP_SEC_TRAN T --资金现券交易
   INNER JOIN RRP_MDL.O_ICL_CMM_CAP_BUS_POST A --资金业务持仓
      ON A.BOND_ID = T.BOND_ID
     AND TRIM(A.SUBJ_ID) IS NOT NULL
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_ICL_CMM_BOND_BASIC_INFO B --债券基本信息
      ON B.BOND_ID = A.BOND_ID
     AND B.BOND_TYPE_CD IN ('7','71','X','Y')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T.BOND_TYPE_CD = 'W' --同业存单发行
     AND T.TRAN_DIR_CD = '02' --交易方向 01买入 02卖出
     AND T.STL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     --20221008 XUXIAOBIN ADD
   UNION ALL
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')              AS DATA_DT            --1  数据日期
        ,A.LP_ID                                   AS LGL_REP_ID         --2  法人编号
        ,COALESCE(TRIM(D.PARTY_ID),TRIM(B.CUST_ID),/*TRIM(CM.CUST_ID),*/TRIM(B.PARTY_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID))
                                                   AS CUST_ID            --3  客户编号
        ,A.BELONG_ORG_ID                           AS ORG_ID             --4  机构编号
        ,A.FIN_INSTM_ID                            AS ACC_ID             --5  账户编号
        ,C.CNTPTY_ID                               AS CNTPR_ID           --6  交易对手编号
        ,A.FIN_INSTM_ID || '.' || A.BUS_ID         AS CD_NO              --7  存单号
        ,''                                        AS PBC_ACC_TYP        --8  人行账户类型
        ,'T'                                       AS ACC_TYP            --9  账户类型
        ,'1'                                       AS PROD_CL            --10 产品分类 同业存单
        ,A.CURR_CD                                 AS CUR                --11 币种
        ,ABS(A.CURRT_BAL + A.INT_ADJ_AMT)          AS BOOK_BAL           --12 账面余额 --20230508 HUANGYIFAN与总账对平调整
        ,ABS(A.CURRT_ACRU_INT)                     AS PBL_INT            --13 应付利息
        ,TO_CHAR(T.ISSUE_DT,'YYYYMMDD')            AS ISU_DT             --14 发行日期
        ,TO_CHAR(E.VALUE_DT,'YYYYMMDD')            AS VAL_DT             --15 起息日期
        ,TO_CHAR(E.EXP_DT,'YYYYMMDD')              AS EXP_DT             --16 到期日期
        ,ABS(A.CURRT_BAL)                          AS MKT_VAL            --17 市场价值 --20230605 XUXIAOBIN MODIFY
        ,NULL                                      AS DEP_INS_AMT        --18 被存款保险制度覆盖的金额
        ,NULL                                      AS DUR                --19 久期
        ,NULL                                      AS MOD_DUR            --20 修正久期
        ,NULL                                      AS OPEN_ACC_TLR_NO    --21 开户柜员号
        ,NULL                                      AS CNL_ACC_DT         --22 销户日期
        ,CASE WHEN A.INTNAL_SECU_ACCT_STATUS_CD IN ('0','1') THEN '01' --0新建，1正常，3停用，NULL未知
              ELSE '99'
          END                                      AS ACC_STAT           --23 账户状态 0新
        ,NULL                                      AS LAST_ACC_CHG_DT    --24 上次动户日期
        ,ABS(A.CURRT_BAL)                          AS OPEN_ACC_AMT       --25 开户金额 --20230605 XUXIAOBIN MODIFY
        ,NULL                                      AS DEP_STABLE_CL      --26 存款稳定性分类
        ,A.ACTL_INT_RAT                            AS RATE               --27 利率
        ,NULL                                      AS GL_CL              --28 会计分类
        ,'Y'                                       AS BIO_FLG            --29 境内外标志
        ,CASE WHEN A.SUBJ_ID LIKE '2015%' THEN 'DR03'
              ELSE 'DR01'
          END                                      AS DEP_RSV_MODE       --30 缴存准备金方式
        ,NULL                                      AS DEPT_LINE          --31 部门条线
        ,'同业证券持仓'                            AS DATA_SRC           --32 数据来源
        ,A.OBJ_ID                                  AS SUB_ACC_ID         --33 子账户编号
        ,A.SUBJ_ID                                 AS SUBJ_ID            --34 科目编号
        ,B.PARTY_NAME                              AS CNTPTY_NAME        --35 交易对手名称
        ,COALESCE(TRIM(B.CUST_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID)) AS SRC_CUST_ID --36 穿透前客户号
        ,D.SPV_ID                                  AS SPV_ID             --37 SPV编号
        ,NULL                                      AS C_DEPOSIT_TYPE     --38 单位存款类型
        ,NULL                                      AS FROZ_FLG           --39 冻结标志
        ,NULL                                      AS STOP_PAY_STATUS_CD --40 止付状态代码
        ,NULL                                      AS LG_FROZ_FLG        --41 司法冻结标志志
        ,B.PARTY_FNAME                             AS CNTPTY_FNAME       --42 交易对手全称
        ,D.SPV_CUST_ID                             AS SPV_CUST_ID        --43 SPV客户号
        ,A.TRAN_AMT                                AS ISSUE_AMT          --44 发行金额
        ,CASE WHEN D.CASH_MGMT_PROD_FLG = '1' THEN 'Y' 
         ELSE 'N' END                              AS CASH_MANAGE_FLG    --45 现金管理类产品标志 ADD BY 20250813
        ,D.SPV_TYPE_CD                             AS SPV_TYPE_CD        --46 SPV类型代码 ADD BY LYH 20260225
    FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST A --同业证券持仓表 A
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN C --同业交易表
      ON C.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND C.TRAN_MARKET_ID = A.MARKET_TYPE_ID
     AND C.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND C.EXT_SECU_ACCT_ID = A.EXT_SECU_ACCT_ID
     AND C.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
     AND C.INTNAL_TRAN_NUM = A.BUS_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_EVT_IBANK_TRAN C1 --同业交易表
      ON C1.TRAN_NUM = C.QUOTE_TRAN_NUM
     AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_AGT_IBANK_DEP_RCPT T --同业存单表
      ON T.DEP_RCPT_CD = A.FIN_INSTM_ID
     AND T.ASSET_TYPE_CD = A.ASSET_TYPE_ID
     AND T.MARKET_TYPE_CD = A.MARKET_TYPE_ID
     AND T.VOUCH_ID = '101007'||C1.INTNAL_TRAN_NUM
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
/*    LEFT JOIN (SELECT SRC_PARTY_ID,CUST_ID,PARTY_ID,PARTY_NAME,PARTY_FNAME,
                      ROW_NUMBER() OVER( PARTITION BY SRC_PARTY_ID ORDER BY ETL_DT DESC) AS RM
                 FROM RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO) B --同业交易对手信息
      ON B.SRC_PARTY_ID = C.CNTPTY_ID
     AND B.RM = 1*/
    --modify by 20250813
    LEFT JOIN RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO B
      ON B.SRC_PARTY_ID = C.CNTPTY_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') 
/*    LEFT JOIN (SELECT ROW_NUMBER() OVER(PARTITION BY SPV_CUST_ID ORDER BY END_DT DESC) AS RM,
                      SPV_CUST_ID,PARTY_ID,SPV_ID
                 FROM RRP_MDL.O_IML_PTY_SPV_CUST_INFO) D --SPV 客户号
      ON D.SPV_CUST_ID = COALESCE(TRIM(B.CUST_ID),TRIM(B.SRC_PARTY_ID),TRIM(A.OBJ_ID))
     AND D.RM = 1 --MD 20220820 XUCX*/
    --modify by 20250813
    LEFT JOIN RRP_MDL.O_IML_PTY_SPV_CUST_INFO D
      ON D.SPV_CUST_ID = COALESCE(TRIM(B.CUST_ID),TRIM(B.SRC_PARTY_ID)) 
     AND D.START_DT < = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.ID_MARK <> 'D'
    LEFT JOIN RRP_MDL.O_ICL_CMM_IBANK_FIN_INSTM E --同业金融工具表
      ON E.FIN_INSTM_ID = A.FIN_INSTM_ID
     AND E.MARKET_TYPE_ID = A.MARKET_TYPE_ID
     AND E.ASSET_TYPE_ID = A.ASSET_TYPE_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')/*A.ETL_DT*/
   WHERE A.ASSET_TYPE_NAME LIKE '%同业存单%'
     --AND TRIM(A.SUBJ_ID) IS NOT NULL
     --AND ABS(A.CURRT_BAL) > 0 --20221031发生额不能剔除0余额
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT,ACC_ID||SUB_ACC_ID,COUNT(1)
      FROM RRP_MDL.M_CPTL_CD_ISSUE_INFO T
     WHERE T.PROD_CL = '2'
       AND DATA_DT = V_P_DATE
     GROUP BY DATA_DT,ACC_ID||SUB_ACC_ID
    HAVING COUNT(1) > 1
     UNION ALL
    SELECT DATA_DT,CD_NO,COUNT(1)
      FROM RRP_MDL.M_CPTL_CD_ISSUE_INFO T
     WHERE T.PROD_CL = '1'
       AND DATA_DT = V_P_DATE
     GROUP BY DATA_DT,CD_NO
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE  := '1';
     V_ENDTIME  := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE); --表分析
  
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_CPTL_CD_ISSUE_INFO;
/

