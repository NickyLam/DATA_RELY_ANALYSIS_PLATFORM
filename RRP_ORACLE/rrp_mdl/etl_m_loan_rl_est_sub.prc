CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_RL_EST_SUB(I_P_DATE IN INTEGER,
                                                  O_ERRCODE OUT VARCHAR2
                                                 )
/**************************************************************************
 *  程序名称：ETL_M_LOAN_RL_EST_SUB
 *  功能描述：房地产贷款子表
 *  创建日期：20220610
 *  开发人员：梅炜
 *  来源表：O_ICL_CMM_CORP_LOAN_CONT_INFO --对公贷款合同信息
            O_ICL_CMM_CORP_LOAN_DUBIL_INFO --对公贷款借据信息
            O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO --对公贷款业务合同补充信息
            O_ICL_CMM_RETL_LOAN_DUBIL_INFO  --零售贷款借据信息
            O_ICL_CMM_RETL_LOAN_REPAY_DTL  --零售贷款还款明细
 *  目标表：  M_LOAN_RL_EST_SUB
 *  配置表：  CODE_MAP
 *  修改情况：序号  修改日期  修改人   修改原因
 *             1    20220523  梅炜      首次创建
 *             2    20221104  HULJ      增加数据重复校验
 *             3    20221129  HULJ      调整逻辑房产建筑面积和房产月物业费从押品表接数,新增字段房屋总价和房屋首付
 *             4    20221201  HULJ      调整已有住房套数从零售合同表取
               5    20231117  LWB       新增展期未到期贷款
               6    20251211  YJY       调整关联条件
               7    20250209  YJY       更新对公小微产品编号
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;              --处理步骤
  V_P_DATE    VARCHAR2(8);               --跑批数据日期
  V_STARTTIME DATE;                      --处理开始时间
  V_ENDTIME   DATE;                      --处理结束时间
  V_SQLCOUNT  INTEGER := 0;              --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);             --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);             --任务名称
  V_PART_NAME VARCHAR2(100);             --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_RL_EST_SUB'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_LOAN_RL_EST_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
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
  V_STEP_DESC := '插入房地产贷款子表--房地产开发';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_RL_EST_SUB
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,ORG_ID                    --机构编号
    ,RCPT_ID                   --借据编号
    ,RL_EST_LOAN_TYP           --房地产贷款类型
    ,AFP_TYP                   --保障性安居工程类型
    ,CPTL_FND                  --资本金
    ,ALDY_HAVE_HSE_NUM         --已有住房套数
    ,MON_PTY_CHGS              --月物业费
    ,HSE_PTY_BLDG_AREA         --房产建筑面积
    ,OPR_PTY_LOAN_FLG          --经营性物业贷款标志
    ,TERM_ACM_MON              --期限积（月）
    ,SCRTZ_FLG                 --证券化标志
    ,SCRTZ_DT                  --证券化日期
    ,LPR                       --LPR
    ,IND_HSE_LOAN_TYP          --个人住房贷款类型
    ,IND_HSE_MTG_UPD_LOAN_FLG  --个人住房抵押追加贷款标志
    ,FIRST_REPY_DT             --首次还款日期
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,STD_PROD_ID               --标准产品编号
    ,HOUSE_FIRST_PAY_AMT       --房屋首付额
    ,HOUSE_TOT_PRICE           --房屋总价
    ,FINAL_JUD_END_DT          --终审结束时间
    ,CONT_CREATE_DT            --合同创建日期
    ,APPL_AMT                  --申请金额
    ,APPLY_SYS                 --申请状态
    ,APPROVE_AMT               --审批金额
    ,MTG_LOAN_FLG              --抵押贷款标识
    ,LOAN_APPL_FLOW_NUM        --贷款申请流水号
    ,RENEW_FLG_WDQ             --展期未到期贷款
    )
  SELECT V_P_DATE                                        AS DATA_DT                     --数据日期
        ,B.LP_ID                                         AS LGL_REP_ID                  --法人编号
        ,F.ACCT_INSTIT_ID                                AS ORG_ID                      --机构编号
        ,B.DUBIL_ID                                      AS RCPT_ID                     --借据编号
        ,CASE WHEN B.STD_PROD_ID = '203010200002' THEN '2011' --法人房产按揭贷款可映射到2011
              WHEN B.STD_PROD_ID = '203010200001' THEN '501' --企业商业用房贷款 --经营性物业贷款的为'501'
              WHEN B.STD_PROD_ID = '203010300001' AND B.DIR_INDUS_CD LIKE 'K%' THEN '502' --房地产并购贷款的为'502'
              ELSE REPLACE(TRIM(A.ESTATE_LOAN_TYPE_CD),'-',NULL)
          END                                            AS RL_EST_LOAN_TYP             --房地产贷款类型
        ,TTA1.TAR_VALUE_CODE                  	         AS AFP_TYP                     --保障性安居工程类型--20220930 XUXIAOBIN MODIFY
        ,C.CAPITAL                                       AS CPTL_FND                    --资本金
        ,NULL                                            AS ALDY_HAVE_HSE_NUM           --已有住房套数
        ,NULL                                            AS MON_PTY_CHGS                --月物业费
        ,NULL                                            AS HSE_PTY_BLDG_AREA           --房产建筑面积
        ,CASE WHEN A.STD_PROD_ID IN ('203010200001') THEN 'Y'
              ELSE 'N'
          END                                            AS OPR_PTY_LOAN_FLG            --经营性物业贷款标志
        ,A.TENOR*T.LATEST_APV_AMT                        AS TERM_ACM_MON                --期限积（月）
        ,CASE WHEN M.CONT_ID IS NOT NULL AND M.ASSET_POOL_TYPE_CD = '002' --对公
              THEN 'Y'
              ELSE 'N'
          END                                            AS SCRTZ_FLG                   --证券化标志
        ,TO_CHAR(M.BEGIN_DT,'YYYYMMDD')                  AS SCRTZ_DT                    --证券化日期
        ,NULL                                            AS LPR                         --LPR
        ,'9'                                             AS IND_HSE_LOAN_TYP            --个人住房贷款类型
        ,NULL                                            AS IND_HSE_MTG_UPD_LOAN_FLG    --个人住房抵押追加贷款标志
        ,TO_CHAR(D.REPAYBL_DT,'YYYYMMDD')                AS FIRST_REPY_DT               --首次还款日期
        ,NULL                                            AS DEPT_LINE                   --部门条线
        ,'对公'                                          AS DATA_SRC                    --数据来源
         ,B.STD_PROD_ID                                  AS STD_PROD_ID                 --标准产品编号
         ,NULL                                           AS HOUSE_FIRST_PAY_AMT         --房屋首付额
         ,NULL                                           AS HOUSE_TOT_PRICE             --房屋总价
         ,NULL                                           AS FINAL_JUD_END_DT            --终审结束时间
         ,NULL                                           AS CONT_CREATE_DT              --合同创建日期
         ,T.APPL_AMT                                     AS APPL_AMT                    --申请金额
         ,CASE WHEN T.APVED_DT IS NOT NULL THEN '2'
               ELSE '3'
          END                                            AS APPLY_SYS                   --申请状态
         ,T.LATEST_APV_AMT                               AS APPROVE_AMT                 --审批金额
         ,CASE WHEN A.MAJOR_GUAR_WAY_CD LIKE 'B%'--从合同表取抵押贷款标志
               THEN 'Y'
               ELSE 'N'
          END                                            AS MTG_LOAN_FLG                --抵押贷款标识
         ,A.APV_FLOW_NUM                                 AS LOAN_APPL_FLOW_NUM          --贷款申请流水号
         ,CASE WHEN F.RENEW_FLG = '1' AND TO_CHAR(B.APOT_EXP_DT,'YYYYMMDD')> V_P_DATE 
               THEN 'Y'--展期未到期贷款
               ELSE 'N'
          END                                            AS RENEW_FLG_WDQ
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO F --对公贷款账户信息
      ON F.DUBIL_NUM = B.DUBIL_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_CONT_INFO A --对公贷款合同信息
      ON A.CONT_ID = B.CONT_ID
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO M --资产证券化转让合同
      ON M.CONT_ID = A.CONT_ID
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_APPL_INFO  T
      ON T.LOAN_APPL_FLOW_NUM = A.APV_FLOW_NUM
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_BUS_CONT_ATTACH_INFO C --对公贷款业务合同补充信息
      ON C.CONT_ID = A.CONT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT DUBIL_ID,MIN(REPAYBL_DT) REPAYBL_DT
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY DUBIL_ID) D  --对公贷款还款计划
      ON D.DUBIL_ID = B.DUBIL_ID
    LEFT JOIN RRP_MDL.CODE_MAP TTA1  --保障性安居工程类型
      ON TTA1.SRC_VALUE_CODE = A.ESTATE_LOAN_TYPE_CD
     AND TTA1.SRC_CLASS_CODE = 'CD2147'
     AND TTA1.TAR_CLASS_CODE = 'T0022'
     AND TTA1.MOD_FLG = 'MDM'
   WHERE (B.STD_PROD_ID IN('203010200002','203010200003','203010200003','203010200006','203010200001')
          OR (B.STD_PROD_ID IN ('203010300001',/*'203010200007'*/'203010200009') AND B.DIR_INDUS_CD LIKE 'K%')) --mod by yjy 20250209 新增小微产品：203010200009-华兴固贷（小微），非小微仍保留203010200007-其他固定资产贷款
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入房地产贷款子表--购房贷款';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_RL_EST_SUB
    (DATA_DT                   --数据日期
    ,LGL_REP_ID                --法人编号
    ,ORG_ID                    --机构编号
    ,RCPT_ID                   --借据编号
    ,RL_EST_LOAN_TYP           --房地产贷款类型
    ,AFP_TYP                   --保障性安居工程类型
    ,CPTL_FND                  --资本金
    ,ALDY_HAVE_HSE_NUM         --已有住房套数
    ,MON_PTY_CHGS              --月物业费
    ,HSE_PTY_BLDG_AREA         --房产建筑面积
    ,OPR_PTY_LOAN_FLG          --经营性物业贷款标志
    ,TERM_ACM_MON              --期限积（月）
    ,SCRTZ_FLG                 --证券化标志
    ,SCRTZ_DT                  --证券化日期
    ,LPR                       --LPR
    ,IND_HSE_LOAN_TYP          --个人住房贷款类型
    ,IND_HSE_MTG_UPD_LOAN_FLG  --个人住房抵押追加贷款标志
    ,FIRST_REPY_DT             --首次还款日期
    ,DEPT_LINE                 --部门条线
    ,DATA_SRC                  --数据来源
    ,STD_PROD_ID               --标准产品编号
    ,HOUSE_FIRST_PAY_AMT       --房屋首付额
    ,HOUSE_TOT_PRICE           --房屋总价
    ,FINAL_JUD_END_DT          --终审结束时间
    ,CONT_CREATE_DT            --合同创建日期
    ,APPL_AMT                  --申请金额
    ,APPLY_SYS                 --申请状态
    ,APPROVE_AMT               --审批金额
    ,MTG_LOAN_FLG              --抵押贷款标识
    ,LOAN_APPL_FLOW_NUM        --贷款申请流水号
    ,RENEW_FLG_WDQ             --展期未到期贷款
    )
  SELECT V_P_DATE                                       AS DATA_DT                   --数据日期
        ,A.LP_ID                                        AS LGL_REP_ID                --法人编号
        ,F.ACCT_INSTIT_ID                               AS ORG_ID                    --机构编号
        ,A.DUBIL_ID                                     AS RCPT_ID                   --借据编号
        ,CASE WHEN ((NVL(A.STD_PROD_ID, F.STD_PROD_ID) IN ('201030200001','201030200002','201010300037')
                    AND B.BORW_USAGE_TYPE_CD = '100301')
                  OR NVL(A.STD_PROD_ID, F.STD_PROD_ID) IN ('201030100002','201030100001'))    --MDF BY XMZ 20230130
              THEN '2031'  --个人商业用房贷款
              WHEN NVL(A.STD_PROD_ID, F.STD_PROD_ID) = '201030200001' AND B.BORW_USAGE_TYPE_CD <> '100301'
                   AND B.MAJOR_GUAR_WAY_CD LIKE 'B%'
              THEN '2032'  --个人住房新建房抵押贷款（非保障性住房）
              WHEN NVL(A.STD_PROD_ID, F.STD_PROD_ID) = '201030200001' AND B.BORW_USAGE_TYPE_CD <> '100301'
                   AND B.MAJOR_GUAR_WAY_CD NOT LIKE 'B%'
              THEN '2033'  --个人住房新建房非抵押贷款（非保障性住房）
              WHEN NVL(A.STD_PROD_ID, F.STD_PROD_ID) = '201030200002' AND B.BORW_USAGE_TYPE_CD <> '100301'
              THEN '2036'  --个人住房再交易房贷款
              WHEN NVL(A.STD_PROD_ID, F.STD_PROD_ID) = '201020100048' THEN '501'  --经营性物业贷款的为'501'
          END                                           AS RL_EST_LOAN_TYP           --房地产贷款类型   --modify by tangan at 20221024 修改个人购房贷款类型
        ,''                                             AS AFP_TYP                   --保障性安居工程类型20220930 XUXIAOBIN MODIFY 个人找不到取值来源
        ,NULL                                           AS CPTL_FND                  --资本金
        ,DECODE(B.HOUSING_CNT_CD,'1','1','2','2','3','3') AS ALDY_HAVE_HSE_NUM       --已有住房套数 mod by xmz 20230129
        ,S.ESTATE_MON_PROP_FEE                          AS MON_PTY_CHGS            --月物业费 mod by hulj 20221129
        ,S.ESTATE_ARCH_AREA                             AS HSE_PTY_BLDG_AREA       --房产建筑面积 mod by hulj 20221129
        ,CASE WHEN A.STD_PROD_ID IN ('201020100048') THEN 'Y'
              ELSE 'N'
          END                                           AS OPR_PTY_LOAN_FLG        --经营性物业贷款标志
        ,B.TENOR * D.FINAL_JUD_APV_LMT                  AS TERM_ACM_MON            --期限积（月）
        ,CASE WHEN M.CONT_ID IS NOT NULL AND M.ASSET_POOL_TYPE_CD = '001' --个人
              THEN 'Y'
              ELSE 'N'
          END                                           AS SCRTZ_FLG               --证券化标志
        ,TO_CHAR(M.BEGIN_DT,'YYYYMMDD')                 AS SCRTZ_DT                --证券化日期
        ,NULL                                           AS LPR                     --LPR
        ,CASE WHEN A.STD_PROD_ID IN( '201030100001','201030200001') THEN '1'
              WHEN A.STD_PROD_ID IN( '201030100002','201030200002') THEN '2'
              ELSE NULL
          END                                           AS IND_HSE_LOAN_TYP        --个人住房贷款类型
        ,NULL                                           AS IND_HSE_MTG_UPD_LOAN_FLG--个人住房抵押追加贷款标志
        ,TO_CHAR(C.REPAY_DT,'YYYYMMDD')                 AS FIRST_REPY_DT           --首次还款日期
        ,NULL                                           AS DEPT_LINE               --部门条线
        ,'零售'                                         AS DATA_SRC                --数据来源
        ,A.STD_PROD_ID                                  AS STD_PROD_ID             --标准产品编号
        ,D.HOUSE_FIRST_PAY_AMT                          AS HOUSE_FIRST_PAY_AMT     --房屋首付额  ADD BY HULIJ 20221129
        ,D.HOUSE_TOT_PRICE                              AS HOUSE_TOT_PRICE         --房屋总价   ADD BY HULIJ 20221129
        ,TO_CHAR(D.FINAL_JUD_END_TM,'YYYYMMDD')         AS FINAL_JUD_END_DT        --终审结束时间
        ,TO_CHAR(B.CONT_CREATE_DT,'YYYYMMDD')           AS CONT_CREATE_DT          --合同创建日期
        ,D.APPL_AMT                                     AS APPL_AMT                --申请金额
        ,CASE WHEN D.FINAL_JUD_APV_STATUS_CD = 'Finished' THEN '2'
              WHEN D.FINAL_JUD_APV_STATUS_CD = 'Reject' THEN '3'
              ELSE '1'
          END                                           AS APPLY_SYS               --申请状态
        ,D.FINAL_JUD_APV_LMT                            AS APPROVE_AMT             --审批金额
        ,CASE WHEN B.MAJOR_GUAR_WAY_CD LIKE 'B%' THEN 'Y' --从合同表取抵押贷款标志
              ELSE 'N'
          END                                           AS MTG_LOAN_FLG            --抵押贷款标识
        ,B.APV_FLOW_NUM                                 AS LOAN_APPL_FLOW_NUM      --贷款申请流水号
        ,CASE WHEN NVL(F.RENEW_CNT,0)>0 AND F.STD_PROD_ID <> '202010100004' 
               AND TO_CHAR(F.RENEW_EXP_DT,'YYYYMMDD') > V_P_DATE 
              THEN 'Y'             
              ELSE 'N' 
          END                                           AS RENEW_FLG_WDQ           --展期未到期贷款
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO A --零售贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO B  --零售贷款合同信息
      ON B.CONT_ID = A.CONT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO M --资产证券化转让合同
      ON M.CONT_ID = B.CONT_ID
     AND M.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_APPL_INFO D --零售贷款申请信息
      ON D.LOAN_APPL_FLOW_NUM = /*B.APV_FLOW_NUM*/ B.APLV_FLOW_NUM --MOD BY YJY 20251211 一表通反馈应该用申请流水编号关联
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO F --零售贷款账户信息
      ON F.DUBIL_NUM = A.DUBIL_ID
     AND F.ETL_DT =  TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT D.DUBIL_ID
                     ,SUM(NVL(E.ESTATE_MON_PROP_FEE,0)) AS ESTATE_MON_PROP_FEE
                     ,SUM(NVL(E.ESTATE_ARCH_AREA,0)) AS ESTATE_ARCH_AREA
                 FROM RRP_MDL.O_IML_AST_DUBIL_ASSIGN_H D  --资产借据分配历史
                 LEFT JOIN RRP_MDL.O_ICL_CMM_COL_INFO E  --押品信息
                   ON E.COL_ID = D.ASSET_ID
                  AND E.ETL_DT BETWEEN D.START_DT AND D.END_DT
                  AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE D.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND D.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY D.DUBIL_ID) S
      ON S.DUBIL_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO G --个人客户信息
      ON G.CUST_ID = A.CUST_ID
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN (SELECT MIN(T.REPAY_DT) REPAY_DT,T.DUBIL_ID FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL T
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY T.DUBIL_ID) C   --零售贷款还款明细
      ON C.DUBIL_ID = A.DUBIL_ID
   WHERE (A.STD_PROD_ID IN('201020100048',--个人经营性物业抵押贷款
                           '201020100047', --个人物业经营租金贷
                           '201010300037') --个人消费抵押（循环贷款）                           
          OR A.STD_PROD_ID LIKE '20103%')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

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
    SELECT DATA_DT, RCPT_ID,COUNT(1)
      FROM RRP_MDL.M_LOAN_RL_EST_SUB T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, RCPT_ID
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

END ETL_M_LOAN_RL_EST_SUB;
/

