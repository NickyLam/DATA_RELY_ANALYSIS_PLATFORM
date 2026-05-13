CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_G1102_DDSSF(I_P_DATE      IN INTEGER,
                                         O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_G1102_DDSSF
  *  功能描述：代垫诉讼费整合
  *  创建日期：20250917
  *  开发人员：黄一凡
  *  来源表： CMM_CORP_LOAN_DUBIL_INFO  对公贷款借据信息表
  *           CMM_CORP_LOAN_ACCT_INFO  对公贷款账户信息表
  *           O_ICL_CMM_STD_PROD_INFO  标准产品信息表
  *  目标表：S_G1102_DDSSF 代垫诉讼费整合表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20250917  HYF        创建
  *             2    20251111  HYF        调整机构号取减值系统诉讼费表经办机构
  *             3    20260323  HYF        由于减值准备取T-2,存在减值准备有诉讼费为0的场景，调整取数主表以减值准备T-2表为准
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_G1102_DDSSF'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_TAB_NAME  VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_G1102_DDSSF'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_AGR_REL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_G1102_DDSSF'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  V_STEP := 2;
  V_STEP_DESC := '--加工对公贷款数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源  
  )
    SELECT /*+USE_HASH(A B C D E F F1 G H I J K L T)*/
           V_P_DATE                          AS DATA_DT                   --01 数据日期
          ,A.DUBIL_ID                        AS ID                        --02 主键
          ,A.DUBIL_ID                        AS RCPT_ID                   --03 信贷借据号
          ,B.CUST_ID                         AS CUST_ID                   --04客户号
          ,F.CUST_NAME                       AS CUST_NAME                 --05 客户名称
          ,K.EXECU_ORG_NO                    AS ORG_ID                    --06 机构编号 --MOD BY 20260323
          ,A.CURR_CD                         AS CUR                       --07 币种
          ,DECODE(A.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                             AS LOAN_LEVEL5_CLS_CD        --08 五级分类
          ,GREATEST(B.PRIC_OVDUE_DAYS,B.INT_OVDUE_DAYS) AS OVDUE_DAYS     --09 逾期天数
          ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')    AS DISTR_DT                  --10 贷款实际发放日期
          ,TO_CHAR(A.APOT_EXP_DT,'YYYYMMDD') AS EXP_DT                    --11 贷款原始到期日期
          ,A.STD_PROD_ID                     AS LOAN_STD_PROD_ID          --12 贷款标准产品编号
          ,C.PROD_NAME                       AS LOAN_STD_PROD_NM          --13 贷款标准产品名称
          ,B.SUBJ_ID                         AS SUBJ_ID                   --14 科目号
          ,NVL(E.LAW_BALANCE_BEFORE,0)       AS SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
          ,ROUND(E.LAW_BALANCE_BEFORE*D.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
          ,NVL(K.LAW_ECL_BEFORE,0)           AS LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
          ,ROUND(K.LAW_ECL_BEFORE*D.EXRT,2)  AS LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
          ,'对公信贷'                        AS DATA_SRC                  --19 数据来源
     FROM ICL.V_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
    INNER JOIN ICL.V_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息表
       ON B.DUBIL_NUM = A.DUBIL_ID
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.DUBIL_ID = T.RID
      AND T.DATA_DT = V_P_DATE
     LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D  --汇率表
       ON A.CURR_CD=D.BASE_CUR
      AND D.CNV_CUR='CNY'
      AND D.DATA_DT = V_P_DATE
     LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
                FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
                WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                GROUP BY V_SERIALNO,EXECU_ORG_NO
                ) E
       ON E.V_SERIALNO = A.DUBIL_ID
     LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
                FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
                WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                                 ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
                GROUP BY V_SERIALNO,EXECU_ORG_NO
                ) K
       ON K.V_SERIALNO = A.DUBIL_ID
      AND K.EXECU_ORG_NO = NVL(E.EXECU_ORG_NO,K.EXECU_ORG_NO)       
     LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO F --对公客户基本信息
       ON F.CUST_ID = B.CUST_ID
      AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')      
WHERE (   E.LAW_BALANCE_BEFORE <> 0
       OR K.LAW_ECL_BEFORE <> 0
      )
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  V_STEP := 3;
  V_STEP_DESC := '--加工零售贷款数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源  
  )
     SELECT  /*+USE_HASH(A B C D E F F1 G H I J K L T)*/
             V_P_DATE                          AS DATA_DT                   --01 数据日期
            ,B.DUBIL_ID                        AS ID                        --02 主键
            ,B.DUBIL_ID                        AS RCPT_ID                   --03 信贷借据号
            ,NVL(A.CUST_ID,B.CUST_ID)          AS CUST_ID                   --04 客户号
            ,F.CUST_NAME                       AS CUST_NAME                 --05 客户名称    
            ,NVL(E.EXECU_ORG_NO,K.EXECU_ORG_NO) AS ORG_ID                    --06 机构编号 --MOD BY 20260323
            ,A.CURR_CD                         AS CUR                       --07 币种
            ,DECODE(B.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                               AS LOAN_LEVEL5_CLS_CD        --08 五级分类
            ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVDUE_DAYS     --09 逾期天数
            ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')    AS DISTR_DT                  --10 贷款实际发放日期
            ,TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD') AS EXP_DT                    --11 贷款原始到期日期
            ,A.STD_PROD_ID                     AS LOAN_STD_PROD_ID          --12 贷款标准产品编号
            ,C.PROD_NAME                       AS LOAN_STD_PROD_NM          --13 贷款标准产品名称
            ,A.SUBJ_ID                         AS SUBJ_ID                   --14 科目号
            ,NVL(E.LAW_BALANCE_BEFORE,0)       AS SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
            ,ROUND(E.LAW_BALANCE_BEFORE*D.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
            ,NVL(K.LAW_ECL_BEFORE,0)           AS LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
            ,ROUND(K.LAW_ECL_BEFORE*D.EXRT,2)  AS LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
            ,'零售贷款'                        AS DATA_SRC                  --16 数据来源            
       FROM ICL.V_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据
       LEFT JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
         ON A.DUBIL_NUM = B.DUBIL_ID
        AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
         ON C.PROD_ID = B.STD_PROD_ID
        AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
         ON B.DUBIL_ID = T.RID
        AND T.DATA_DT = V_P_DATE
       LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D  --汇率表
         ON B.CURR_CD=D.BASE_CUR
        AND D.CNV_CUR='CNY'
        AND D.DATA_DT = V_P_DATE
       LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
                    FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
                   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                   GROUP BY V_SERIALNO,EXECU_ORG_NO
                  ) E
         ON E.V_SERIALNO = B.DUBIL_ID
       LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
                    FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
                   WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                                    ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
                   GROUP BY V_SERIALNO,EXECU_ORG_NO
                  ) K
         ON K.V_SERIALNO = B.DUBIL_ID
        AND K.EXECU_ORG_NO = NVL(E.EXECU_ORG_NO,K.EXECU_ORG_NO)    
       LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO F
         ON F.CUST_ID = A.CUST_ID
        AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')             
      WHERE (   E.LAW_BALANCE_BEFORE <> 0
             OR K.LAW_ECL_BEFORE <> 0
            )
        AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '--加工同业债券数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源
  )
      SELECT   /*+USE_HASH(A B C D E F F1 G H I J K L T)*/
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD AS ID --02 主键
              ,I.DUBIL_ID                           AS RCPT_ID                --03 借据号              
              ,NVL(A.ISSUER_CUST_ID, A.ISSUER_ID)   AS CUST_ID                --04 客户号
              ,L.CUST_NAME                          AS CUST_NAME              --05 客户名称
              ,K.EXECU_ORG_NO                       AS ORG_ID                 --06 机构编号 --MOD BY 20260323
              ,A.CURR_CD                            AS CUR                    --07 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                                    AS LOAN_LEVEL5_CLS_CD     --08 五级分类
              ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS) AS OVDUE_DAYS     --09 逾期天数
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,A.SUBJ_ID                            AS SUBJ_ID                --14 科目号
              ,NVL(E.LAW_BALANCE_BEFORE,0)          AS SUIT_FEE_BAL           --15 代垫诉讼费余额_原币
              ,ROUND(E.LAW_BALANCE_BEFORE*J.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
              ,NVL(K.LAW_ECL_BEFORE,0)              AS LAW_ECL_BEFORE         --17 代垫诉讼费减值准备_原币
              ,ROUND(K.LAW_ECL_BEFORE*J.EXRT,2)     AS LAW_ECL_BEFORE_CNY     --18 代垫诉讼费减值准备_折人民币
              ,'同业债券'                           AS DATA_SRC               --19 数据来源
FROM ICL.V_CMM_IBANK_BOND_INVEST A --同业债券投资
LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_IBANK_SECU_POST F --同业证券持仓
       ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
      AND F.MARKET_TYPE_ID = A.MARKET_TYPE_ID
      AND F.ASSET_TYPE_ID = A.ASSET_TYPE_ID
      AND F.FIN_INSTM_ID||'_'||F.ASSET_THD_CLS_CD||'_'||F.INTNAL_SECU_ACCT_ID = A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.INTNAL_SECU_ACCT_ID
      AND F.OBJ_ID = A.OBJ_ID
      AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO I --对公贷款借据信息
       ON F.ASSET_UNIQ_IDF_ID = I.IBANK_ASSET_UNIQ_IDF_ID
      AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD = T.RID
      AND T.DATA_DT = V_P_DATE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
             FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
            WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) E
       ON E.V_SERIALNO = I.DUBIL_ID
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
             FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
            WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                             ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
            GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) K
       ON K.V_SERIALNO = I.DUBIL_ID
      AND K.EXECU_ORG_NO = NVL(E.EXECU_ORG_NO,K.EXECU_ORG_NO)
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO L --对公客户基本信息
       ON L.CUST_ID = NVL(A.ISSUER_CUST_ID, A.ISSUER_ID)
      AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')      
WHERE (   E.LAW_BALANCE_BEFORE <> 0
       OR K.LAW_ECL_BEFORE <> 0
       )
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '--加工同业净值型数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源
  )
      SELECT   /*+USE_HASH(A B C D E F F1 G H I J K L M T)*/
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID   --02 主键
              ,I.DUBIL_ID                           AS RCPT_ID                --03 借据号              
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),
                        TRIM(D.CUST_ID),TRIM(F1.CUST_ID),TRIM(H.CUST_ID),TRIM(G.ACTL_FINER_CUST_ID),
                        TRIM(TRIM(H.SRC_PARTY_ID)),'-') AS CUST_ID            --04 客户号
              ,L.CUST_NAME                          AS CUST_NAME              --05 客户名称                        
              ,K.EXECU_ORG_NO                       AS ORG_ID                 --06 机构编号 -- MOD BY 20260323
              ,A.CURR_CD                            AS CUR                    --07 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                                    AS LOAN_LEVEL5_CLS_CD     --08 五级分类
              ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS) AS OVDUE_DAYS     --09 逾期天数
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,A.SUBJ_ID                            AS SUBJ_ID                --14 科目号
              ,NVL(M.LAW_BALANCE_BEFORE,0)          AS SUIT_FEE_BAL           --15 代垫诉讼费余额_原币
              ,ROUND(M.LAW_BALANCE_BEFORE*J.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
              ,NVL(K.LAW_ECL_BEFORE,0)              AS LAW_ECL_BEFORE         --17 代垫诉讼费减值准备_原币
              ,ROUND(K.LAW_ECL_BEFORE*J.EXRT,2)     AS LAW_ECL_BEFORE_CNY     --18 代垫诉讼费减值准备_折人民币
              ,'同业净值型'                         AS DATA_SRC               --16 数据来源
FROM ICL.V_CMM_IBANK_NV_TYPE_PROD_INVEST A  --同业净值型产品投资
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
       ON D.CUST_ID = A.UDER_ACTL_FINER_CUST_ID
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN IML.V_PTY_SPV_CUST_INFO E --SPV客户信息
       ON E.SPV_CUST_ID = A.UDER_ACTL_FINER_CUST_ID
      AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO F1 --对公客户信息
       ON F1.CUST_ID = E.PARTY_ID
      AND F1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_IBANK_SECU_POST F --同业证券持仓
       ON F.FIN_INSTM_ID = A.FIN_INSTM_ID
      AND F.BUS_ID = A.BUS_ID
      AND F.OBJ_ID = A.OBJ_ID
      AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_IBANK_FIN_INSTM G --同业金融工具表
       ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
      AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
      AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN IML.V_PTY_IBANK_CNTPTY_INFO H
       ON H.SRC_PARTY_ID = G.ISSUE_ORG_ID
      AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO I --对公贷款借据信息
       ON F.ASSET_UNIQ_IDF_ID = I.IBANK_ASSET_UNIQ_IDF_ID
      AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
           FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) M
       ON M.V_SERIALNO = I.DUBIL_ID
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
           FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                            ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) K
       ON K.V_SERIALNO = I.DUBIL_ID
      AND K.EXECU_ORG_NO = NVL(M.EXECU_ORG_NO,K.EXECU_ORG_NO)
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO L --对公客户基本信息
       ON L.CUST_ID = COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),
                               TRIM(D.CUST_ID),TRIM(F1.CUST_ID),TRIM(H.CUST_ID),TRIM(G.ACTL_FINER_CUST_ID),
                               TRIM(TRIM(H.SRC_PARTY_ID)),'-')
      AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')      
WHERE (   M.LAW_BALANCE_BEFORE <> 0
       OR K.LAW_ECL_BEFORE <> 0
       )
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 6;
  V_STEP_DESC := '--加工同业非标数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源
  )
      SELECT   /*+USE_HASH(A B C D E F F1 G H I J K L M T)*/
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID --02 主键
              ,I.DUBIL_ID                           AS RCPT_ID                --03 借据号              
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),TRIM(A.CNTPTY_CUST_ID),
                        TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-')) AS CUST_ID --04 客户号
              ,L.CUST_NAME                          AS CUST_NAME              --05 客户名称                        
              ,K.EXECU_ORG_NO                       AS ORG_ID                 --06 机构编号 --MOD BY 20260323
              ,A.CURR_CD                            AS CUR                    --07 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                                    AS LOAN_LEVEL5_CLS_CD     --08 五级分类
              ,GREATEST(T1.PRIC_OVDUE_DAYS,T1.INT_OVDUE_DAYS) AS OVDUE_DAYS   --09 逾期天数
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,A.SUBJ_ID                            AS SUBJ_ID                --14 科目号
              ,NVL(E.LAW_BALANCE_BEFORE,0)          AS SUIT_FEE_BAL           --15 代垫诉讼费余额_原币
              ,ROUND(E.LAW_BALANCE_BEFORE*J.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
              ,NVL(K.LAW_ECL_BEFORE,0)              AS LAW_ECL_BEFORE         --17 代垫诉讼费减值准备_原币
              ,ROUND(K.LAW_ECL_BEFORE*J.EXRT,2)     AS LAW_ECL_BEFORE_CNY     --18 代垫诉讼费减值准备_折人民币
              ,'同业非标'                           AS DATA_SRC               --19 数据来源
FROM ICL.V_CMM_IBANK_NON_STD_INVEST A --同业非标投资表
LEFT JOIN ICL.V_CMM_IBANK_SECU_POST T1 --同业证券持仓表
       ON T1.FIN_INSTM_ID || '_' || T1.ASSET_THD_CLS_CD || '_' || T1.OBJ_ID = A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID
      AND T1.MARKET_TYPE_ID = A.MARKET_TYPE_ID
      AND T1.BUS_ID = A.BUS_ID
      AND T1.INTNAL_SECU_ACCT_ID = A.INTNAL_SECU_ACCT_ID
      AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_IBANK_FIN_INSTM G --同业金融工具表
       ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
      AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
      AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN IML.V_PTY_IBANK_CNTPTY_INFO D  --同业交易对手信息
       ON D.SRC_PARTY_ID = G.MGER_ID
      AND D.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO I --对公贷款借据信息
       ON T1.ASSET_UNIQ_IDF_ID = I.IBANK_ASSET_UNIQ_IDF_ID
      AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
           FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) E
       ON E.V_SERIALNO = I.DUBIL_ID
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
           FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                            ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) K
       ON K.V_SERIALNO = I.DUBIL_ID
      AND K.EXECU_ORG_NO = NVL(E.EXECU_ORG_NO,K.EXECU_ORG_NO) 
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO L --对公客户基本信息
       ON L.CUST_ID = COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),TRIM(A.CNTPTY_CUST_ID),
                               TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-'))
      AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')        
WHERE (   E.LAW_BALANCE_BEFORE <> 0
       OR K.LAW_ECL_BEFORE <> 0
       )
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 7;
  V_STEP_DESC := '--加工同业证券持仓数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_DDSSF
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,RCPT_ID                   --03 信贷借据号  
  ,CUST_ID                   --04 客户号
  ,CUST_NAME                 --05 客户名称  
  ,ORG_ID                    --06 机构编号
  ,CUR                       --07 币种
  ,LOAN_LEVEL5_CLS_CD        --08 五级分类
  ,OVDUE_DAYS                --09 逾期天数
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,SUBJ_ID                   --14 科目号
  ,SUIT_FEE_BAL              --15 代垫诉讼费余额_原币
  ,SUIT_FEE_BAL_CNY          --16 代垫诉讼费余额_折人民币
  ,LAW_ECL_BEFORE            --17 代垫诉讼费减值准备_原币
  ,LAW_ECL_BEFORE_CNY        --18 代垫诉讼费减值准备_折人民币
  ,DATA_SRC                  --19 数据来源
  )
      SELECT   /*+USE_HASH(A B C D E F F1 G H I J K L M T)*/
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID   --02 主键
              ,I.DUBIL_ID                           AS RCPT_ID                --03 借据号              
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(G.ISSUER_CUST_ID),D.CUST_ID,F.CUST_ID,
                        TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-')) AS CUST_ID --04 客户号
              ,L.CUST_NAME                          AS CUST_NAME              --05 客户名称                        
              ,K.EXECU_ORG_NO                       AS ORG_ID                 --06 机构编号 --MOD BY 20260323
              ,A.CURR_CD                            AS CUR                    --07 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常')
                                                    AS LOAN_LEVEL5_CLS_CD     --08 五级分类
              ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVDUE_DAYS     --09 逾期天数
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,NVL(M.LAW_BALANCE_BEFORE,0)          AS SUIT_FEE_BAL           --15 代垫诉讼费余额_原币
              ,ROUND(M.LAW_BALANCE_BEFORE*J.EXRT,2) AS SUIT_FEE_BAL_CNY       --16 代垫诉讼费余额_折人民币
              ,NVL(K.LAW_ECL_BEFORE,0)              AS LAW_ECL_BEFORE         --17 代垫诉讼费减值准备_原币
              ,ROUND(K.LAW_ECL_BEFORE*J.EXRT,2)     AS LAW_ECL_BEFORE_CNY     --18 代垫诉讼费减值准备_折人民币
              ,'同业证券持仓'                       AS DATA_SRC               --16 数据来源态
FROM ICL.V_CMM_IBANK_SECU_POST A --同业证券持仓表
LEFT JOIN IML.V_PTY_IBANK_CNTPTY_INFO B --同业交易对手信息
       ON B.SRC_PARTY_ID = A.ISSUER_ID
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_IBANK_FIN_INSTM G --同业金融工具表
       ON G.FIN_INSTM_ID = A.FIN_INSTM_ID
      AND G.MARKET_TYPE_ID = A.MARKET_TYPE_ID
      AND G.ASSET_TYPE_ID = A.ASSET_TYPE_ID
      AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO D --对公客户信息
       ON D.CUST_ID = NVL(TRIM(B.CUST_ID), NVL(TRIM(B.SRC_PARTY_ID), '-'))
      AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN IML.V_PTY_SPV_CUST_INFO E --SPV客户信息
       ON E.SPV_CUST_ID = NVL(TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-'))
      AND E.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND E.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO F --对公客户信息
       ON F.CUST_ID = E.PARTY_ID
      AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO I --对公贷款借据信息
       ON A.ASSET_UNIQ_IDF_ID = I.IBANK_ASSET_UNIQ_IDF_ID
      AND I.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_BALANCE_BEFORE,0)) LAW_BALANCE_BEFORE 
            FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) M
      ON  M.V_SERIALNO = I.DUBIL_ID
LEFT JOIN (SELECT V_SERIALNO, EXECU_ORG_NO,SUM(NVL(LAW_ECL_BEFORE,0)) LAW_ECL_BEFORE 
           FROM IOL.V_IFRS_FCT_ECL_RES_LAW 
           WHERE ETL_DT = ( CASE WHEN SUBSTR(V_P_DATE,5,4) = 1231 THEN TO_DATE(V_P_DATE,'YYYYMMDD')
                            ELSE TO_DATE(V_P_DATE,'YYYYMMDD')-1 END )
           GROUP BY V_SERIALNO,EXECU_ORG_NO
           ) K
       ON K.V_SERIALNO = I.DUBIL_ID
      AND K.EXECU_ORG_NO = NVL(M.EXECU_ORG_NO,K.EXECU_ORG_NO)
LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO L --对公客户基本信息
       ON L.CUST_ID = COALESCE(TRIM(G.MGER_CUST_ID),TRIM(G.ISSUER_CUST_ID),D.CUST_ID,F.CUST_ID,
                               TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-'))
      AND L.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')      
WHERE (   M.LAW_BALANCE_BEFORE <> 0
       OR K.LAW_ECL_BEFORE <> 0
       )
AND A.ASSET_TYPE_NAME LIKE '%货币基金%'
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := 8;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_G1102_DDSSF;
/

