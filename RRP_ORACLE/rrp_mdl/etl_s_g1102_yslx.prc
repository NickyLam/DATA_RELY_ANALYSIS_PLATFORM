CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_G1102_YSLX(I_P_DATE      IN INTEGER,
                                         O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_G1102_YSLX
  *  功能描述：贷款应收利息整合
  *  创建日期：20240328
  *  开发人员：黄一凡
  *  来源表： CMM_CORP_LOAN_DUBIL_INFO  对公贷款借据信息表
  *           CMM_CORP_LOAN_ACCT_INFO  对公贷款账户信息表
  *           O_ICL_CMM_STD_PROD_INFO  标准产品信息表
  *  目标表：S_G1102_YSLX 贷款应收利息整合表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20240328  HYF         创建
  *             2    20241025  lwb         修改应收利息的逻辑，加上应收未收利息
  *             3    20250509  HYF         修改联合网贷应收利息逻辑，取表内利息（逾期90天内的累计应收未收利息金额）
  *             4    20250528  HYF         新增同业部分数据，同RWA逻辑一致
  *             5    20250618  HYF         补充整合代垫诉讼费和代垫增值税
  *             6    20250917  HYF         经减值系统确认诉讼费存在同一笔借据不同机构互转的情况，不能同应收利息整合一起数据会发散，剔除诉讼费
  *             7    20251111  HYF         调整增值税从贷款分户计量流水出数
  *             8    20260323  HYF         针对分期乐、微业贷3.0（好企贷-数据贷）产品做接数处理，按照T-1天进行获取
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_G1102_YSLX'; -- 程序名称
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
  V_TAB_NAME := 'S_G1102_YSLX'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_AGR_REL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_G1102_YSLX'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  V_STEP := 2;
  V_STEP_DESC := '--加工对公贷款数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                   --01 数据日期
  ,ID                        --02 主键
  ,CUST_ID                   --03 客户号
  ,ORG_ID                    --04 机构编号
  ,CUR                       --05 币种
  ,LOAN_LEVEL5_CLS_CD        --06 五级分类
  ,OVDUE_DAYS                --07 逾期天数
  ,CONFMAMT                  --08 保证金与抵押品价值
  ,PRO_IMPT                  --09 减值准备_折币
  ,DISTR_DT                  --10 贷款实际发放日期
  ,EXP_DT                    --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID          --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM          --13 贷款标准产品名称
  ,INT_RECVBL                --14 应收利息_原币
  ,INT_RECVBL_CNY            --15 应收利息_折人民币
  ,DATA_SRC                  --16 数据来源
  ,SUBJ_ID                   --17 科目号
  ,RCPT_ID                   --18 借据号
  ,TAX_BALANCE_BEFORE        --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY    --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE            --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY        --22 代垫增值税减值准备_折人民币 
  )
    SELECT
           V_P_DATE                          AS DATA_DT                   --01 数据日期
          ,A.DUBIL_ID                        AS ID                        --02 主键
          ,B.CUST_ID                         AS CUST_ID                   --03 客户号
          ,B.ACCT_INSTIT_ID                  AS ORG_ID                    --04 机构编号
          ,A.CURR_CD                         AS CUR                       --05 币种
          ,DECODE(A.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                             AS LOAN_LEVEL5_CLS_CD        --06 五级分类
          ,GREATEST(B.PRIC_OVDUE_DAYS,B.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
          ,S.CONFMAMT                        AS CONFMAMT                  --08 保证金与抵押品价值
          ,ROUND((T.PRO_IMPT*D.EXRT),2)      AS PRO_IMPT                  --09 减值准备_折币
          ,TO_CHAR(B.DISTR_DT,'YYYYMMDD')    AS DISTR_DT                  --10 贷款实际发放日期
          ,TO_CHAR(A.APOT_EXP_DT,'YYYYMMDD') AS EXP_DT                    --11 贷款原始到期日期
          ,A.STD_PROD_ID                     AS LOAN_STD_PROD_ID          --12 贷款标准产品编号
          ,C.PROD_NAME                       AS LOAN_STD_PROD_NM          --13 贷款标准产品名称
          ,ROUND((NVL(B.INT_RECVBL,0)+NVL(B.RECVBL_UNCOL_INT,0)),2) 
                                             AS INT_RECVBL                --14 应收利息_原币
          ,ROUND((NVL(B.INT_RECVBL,0)*D.EXRT+NVL(B.RECVBL_UNCOL_INT,0)*D.EXRT),2) 
                                             AS INT_RECVBL_CNY            --15 应收利息_折人民币
          ,'对公信贷'                        AS DATA_SRC                  --16 数据来源
          ,B.SUBJ_ID                         AS SUBJ_ID                   --17 科目号
          ,A.DUBIL_ID                        AS RCPT_ID                   --18 借据号
          ,NVL(Q.ADV_VAT_AMT,0)              AS TAX_BALANCE_BEFORE        --19 代垫增值税余额_原币 
          ,ROUND(Q.ADV_VAT_AMT*D.EXRT,2)     AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
          ,NVL(T.TAX_ECL_BEFORE,0)           AS TAX_ECL_BEFORE            --21 代垫增值税减值准备_原币
          ,ROUND(T.TAX_ECL_BEFORE*D.EXRT,2)  AS TAX_ECL_BEFORE_CNY        --22 代垫增值税减值准备_折人民币 
     FROM ICL.V_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息表
    INNER JOIN ICL.V_CMM_CORP_LOAN_ACCT_INFO B --对公贷款账户信息表
       ON B.DUBIL_NUM = A.DUBIL_ID
      AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
       ON C.PROD_ID = A.STD_PROD_ID
      AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
                 FROM RRP_MDL.S_G13_BASE B
                WHERE B.DATA_DT = V_P_DATE
                GROUP BY B.CREDNO ) S
       ON A.DUBIL_ID = S.CREDNO
     LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.DUBIL_ID = T.RID
      AND T.DATA_DT = V_P_DATE
     LEFT JOIN IML.V_EVT_LOAN_SUB_ACCT_MEASURE_FLOW Q --贷款分户计量流水
       ON Q.DUBIL_ID = B.DUBIL_NUM
      AND Q.CORE_LOAN_NUM = B.LOAN_NUM || B.OUT_ACCT_NUM
      AND Q.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')      
     LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D  --汇率表
       ON A.CURR_CD=D.BASE_CUR
      AND D.CNV_CUR='CNY'
      AND D.DATA_DT = V_P_DATE
    WHERE /*(A.STD_PROD_ID LIKE '2%' OR A.STD_PROD_ID LIKE '6020%' )*/--modify by lwb
         ((B.INT_RECVBL+B.RECVBL_UNCOL_INT) <> 0 
          OR Q.ADV_VAT_AMT <> 0
          OR T.TAX_ECL_BEFORE <> 0
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

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                        --01 数据日期
  ,ID                             --02 主键
  ,CUST_ID                        --03 客户号
  ,ORG_ID                         --04 机构编号
  ,CUR                            --05 币种
  ,LOAN_LEVEL5_CLS_CD             --06 五级分类
  ,OVDUE_DAYS                     --07 逾期天数
  ,CONFMAMT                       --08 保证金与抵押品价值
  ,PRO_IMPT                       --09 减值准备_折币
  ,DISTR_DT                       --10 贷款实际发放日期
  ,EXP_DT                         --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID               --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM               --13 贷款标准产品名称
  ,INT_RECVBL                     --14 应收利息_原币
  ,INT_RECVBL_CNY                 --15 应收利息_折人民币
  ,DATA_SRC                       --16 数据来源
  ,SUBJ_ID                        --17 科目号
  ,RCPT_ID                        --18 借据号
  ,TAX_BALANCE_BEFORE             --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY         --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE                 --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY             --22 代垫增值税减值准备_折人民币    
  )
     SELECT    
             V_P_DATE                          AS DATA_DT                   --01 数据日期
            ,B.DUBIL_ID                        AS ID                        --02 主键
            ,A.CUST_ID                         AS CUST_ID                   --03 客户号
            ,A.ACCT_INSTIT_ID                  AS ORG_ID                    --04 机构编号
            ,A.CURR_CD                         AS CUR                       --05 币种
            ,DECODE(B.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                               AS LOAN_LEVEL5_CLS_CD        --06 五级分类
            ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
            ,S.CONFMAMT                        AS CONFMAMT                  --08 保证金与抵押品价值
            ,ROUND((T.PRO_IMPT*D.EXRT),2)      AS PRO_IMPT                  --09 减值准备_折币
            ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')    AS DISTR_DT                  --10 贷款实际发放日期
            ,TO_CHAR(A.INIT_EXP_DT,'YYYYMMDD') AS EXP_DT                    --11 贷款原始到期日期
            ,A.STD_PROD_ID                     AS LOAN_STD_PROD_ID          --12 贷款标准产品编号
            ,C.PROD_NAME                       AS LOAN_STD_PROD_NM          --13 贷款标准产品名称
            ,ROUND((NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0)),2) 
                                               AS INT_RECVBL                --14 应收利息_原币
            ,ROUND((NVL(A.INT_RECVBL,0)*D.EXRT+NVL(A.RECVBL_UNCOL_INT,0)*D.EXRT),2) 
                                               AS INT_RECVBL_CNY            --15 应收利息_折人民币
            ,'零售贷款'                        AS DATA_SRC                  --16 数据来源
            ,A.SUBJ_ID                         AS SUBJ_ID                   --17 科目号
            ,B.DUBIL_ID                        AS RCPT_ID                   --18 借据号
            ,NVL(Q.ADV_VAT_AMT,0)              AS TAX_BALANCE_BEFORE        --19 代垫增值税余额_原币
            ,ROUND(Q.ADV_VAT_AMT*D.EXRT,2)     AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
            ,NVL(T.TAX_ECL_BEFORE,0)           AS TAX_ECL_BEFORE            --21 代垫增值税减值准备_原币
            ,ROUND(T.TAX_ECL_BEFORE*D.EXRT,2)  AS TAX_ECL_BEFORE_CNY        --22 代垫增值税减值准备_折人民币  
       FROM ICL.V_CMM_RETL_LOAN_DUBIL_INFO B --零售贷款借据
       LEFT JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
         ON A.DUBIL_NUM = B.DUBIL_ID
        AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
         ON C.PROD_ID = B.STD_PROD_ID
        AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
                    FROM RRP_MDL.S_G13_BASE B
                   WHERE B.DATA_DT = V_P_DATE
                   GROUP BY B.CREDNO) S
         ON B.DUBIL_ID = S.CREDNO
       LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
         ON B.DUBIL_ID = T.RID
        AND T.DATA_DT = V_P_DATE
       LEFT JOIN (SELECT DUBIL_ID,SUM(ADV_VAT_AMT) ADV_VAT_AMT
                  FROM IML.V_EVT_LOAN_SUB_ACCT_MEASURE_FLOW  --贷款分户计量流水
                  WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') GROUP BY DUBIL_ID ) Q
        ON Q.DUBIL_ID = B.DUBIL_ID 
       LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D  --汇率表
         ON B.CURR_CD=D.BASE_CUR
        AND D.CNV_CUR='CNY'
        AND D.DATA_DT = V_P_DATE
      WHERE ( (A.INT_RECVBL+A.RECVBL_UNCOL_INT) <> 0
              OR Q.ADV_VAT_AMT <> 0
              OR T.TAX_ECL_BEFORE <> 0
            )
        AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
        
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '--加工联合网贷数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                    --01 数据日期
  ,ID                         --02 主键
  ,CUST_ID                    --03 客户号
  ,ORG_ID                     --04 机构编号
  ,CUR                        --05 币种
  ,LOAN_LEVEL5_CLS_CD         --06 五级分类
  ,OVDUE_DAYS                 --07 逾期天数
  ,CONFMAMT                   --08 保证金与抵押品价值
  ,PRO_IMPT                   --09 减值准备_折币
  ,DISTR_DT                   --10 贷款实际发放日期
  ,EXP_DT                     --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID           --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM           --13 贷款标准产品名称
  ,INT_RECVBL                 --14 应收利息_原币
  ,INT_RECVBL_CNY             --15 应收利息_折人民币
  ,DATA_SRC                   --16 数据来源
  ,SUBJ_ID                    --17 科目号
  ,RCPT_ID                    --18 借据号
  ,TAX_BALANCE_BEFORE         --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY     --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE             --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY         --22 代垫增值税减值准备_折人民币   
  )
      SELECT
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.DUBIL_ID                           AS ID                     --02 主键
              ,A.CUST_ID                            AS CUST_ID                --03 客户号
              ,A.ACCT_INSTIT_ID                     AS ORG_ID                 --04 机构编号
              ,A.CURR_CD                            AS CUR                    --05 币种
              ,DECODE(A.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                                    AS LOAN_LEVEL5_CLS_CD     --06 五级分类
              ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
              ,S.CONFMAMT                           AS CONFMAMT               --08 保证金与抵押品价值
              ,ROUND((T.PRO_IMPT*D.EXRT),2)         AS PRO_IMPT               --09 减值准备_折币
              ,TO_CHAR(A.DISTR_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,ROUND((NVL(A.IN_BS_INT,0)),2)        AS INT_RECVBL             --14 应收利息_原币
              ,ROUND((NVL(A.IN_BS_INT,0)*D.EXRT),2) AS INT_RECVBL_CNY         --15 应收利息_折人民币
              ,'联合网贷'                           AS DATA_SRC               --16 数据来源
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,A.DUBIL_ID                           AS RCPT_ID                --18 借据号
              ,NVL(Q.ADV_VAT_AMT,0)                 AS TAX_BALANCE_BEFORE     --19 代垫增值税余额_原币
              ,ROUND(Q.ADV_VAT_AMT*D.EXRT,2)        AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
              ,NVL(T.TAX_ECL_BEFORE,0)              AS TAX_ECL_BEFORE         --21 代垫增值税减值准备_原币
              ,ROUND(T.TAX_ECL_BEFORE*D.EXRT,2)     AS TAX_ECL_BEFORE_CNY     --22 代垫增值税减值准备_折人民币  
         FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO A --联合网贷借据信息
         LEFT JOIN ICL.V_CMM_STD_PROD_INFO C --标准产品信息表
           ON C.PROD_ID = A.STD_PROD_ID
          AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
                      FROM RRP_MDL.S_G13_BASE B
                     WHERE B.DATA_DT = V_P_DATE
                     GROUP BY B.CREDNO ) S
          ON A.DUBIL_ID = S.CREDNO
        LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
          ON A.DUBIL_ID = T.RID
         AND T.DATA_DT = V_P_DATE
        LEFT JOIN IML.V_EVT_LOAN_SUB_ACCT_MEASURE_FLOW Q --贷款分户计量流水
          ON Q.DUBIL_ID = A.CORE_DUBIL_ID 
         AND Q.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')         
        LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO D  --汇率表
          ON A.CURR_CD=D.BASE_CUR
         AND D.CNV_CUR='CNY'
         AND D.DATA_DT = V_P_DATE      
       WHERE ( A.IN_BS_INT <> 0
              OR Q.ADV_VAT_AMT <> 0
              OR T.TAX_ECL_BEFORE <> 0 )
        --MOD BY YJY 20251106 其他联合网贷依旧按照t-2接数,分期乐、微业贷3.0（好企贷-数据贷）按照T-1天进行获取
          AND (   (A.STD_PROD_ID NOT IN ('202010200011','202010200010','201020100063') AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1) --其他联合网贷
               OR (A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --分期乐、微业贷3.0（好企贷-数据贷）产品                  
              );
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 5;
  V_STEP_DESC := '--加工同业债券数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                    --01 数据日期
  ,ID                         --02 主键
  ,CUST_ID                    --03 客户号
  ,ORG_ID                     --04 机构编号
  ,CUR                        --05 币种
  ,LOAN_LEVEL5_CLS_CD         --06 五级分类
  ,OVDUE_DAYS                 --07 逾期天数
  ,CONFMAMT                   --08 保证金与抵押品价值
  ,PRO_IMPT                   --09 减值准备_折币
  ,DISTR_DT                   --10 贷款实际发放日期
  ,EXP_DT                     --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID           --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM           --13 贷款标准产品名称
  ,INT_RECVBL                 --14 应收利息
  ,INT_RECVBL_CNY             --15 应收利息_折人民币
  ,DATA_SRC                   --16 数据来源
  ,SUBJ_ID                    --17 科目号
  ,RCPT_ID                    --18 借据号
  ,TAX_BALANCE_BEFORE         --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY     --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE             --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY         --22 代垫增值税减值准备_折人民币  
  ,OVDUE_STATUS               --23 逾期状态     
  )
      SELECT
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD AS ID --02 主键
              ,NVL(A.ISSUER_CUST_ID, A.ISSUER_ID)   AS CUST_ID                --03 客户号
              ,A.BELONG_ORG_ID                      AS ORG_ID                 --04 机构编号
              ,A.CURR_CD                            AS CUR                    --05 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                                    AS LOAN_LEVEL5_CLS_CD     --06 五级分类
              ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
              ,S.CONFMAMT                           AS CONFMAMT               --08 保证金与抵押品价值
              ,ROUND((T.PRO_IMPT*J.EXRT),2)         AS PRO_IMPT               --09 减值准备_折币
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,ROUND((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                      ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END),2) 
                                                    AS INT_RECVBL             --14 应收利息_原币
              ,ROUND(((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END)*J.EXRT),2) 
                                                    AS INT_RECVBL_CNY         --15 应收利息_折人民币
              ,'同业债券'                           AS DATA_SRC               --16 数据来源
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,I.DUBIL_ID                           AS RCPT_ID                --18 借据号    
              ,0                                    AS TAX_ECL_BEFORE         --19 代垫增值税余额_原币
              ,0                                    AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
              ,0                                    AS TAX_ECL_BEFORE         --21 代垫增值税减值准备_原币
              ,0                                    AS TAX_ECL_BEFORE_CNY     --22 代垫增值税减值准备_折人民币 
              ,A.OVDUE_STATUS                       AS OVDUE_STATUS           --23 逾期状态        
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
LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
             FROM RRP_MDL.S_G13_BASE B
            WHERE B.DATA_DT = V_P_DATE
            GROUP BY B.CREDNO
            ) S
       ON I.DUBIL_ID = S.CREDNO
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.OBJ_ID || '_' || A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD = T.RID
      AND T.DATA_DT = V_P_DATE      
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE 
WHERE ((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END) <> 0
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
  V_STEP_DESC := '--加工同业净值型数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                    --01 数据日期
  ,ID                         --02 主键
  ,CUST_ID                    --03 客户号
  ,ORG_ID                     --04 机构编号
  ,CUR                        --05 币种
  ,LOAN_LEVEL5_CLS_CD         --06 五级分类
  ,OVDUE_DAYS                 --07 逾期天数
  ,CONFMAMT                   --08 保证金与抵押品价值
  ,PRO_IMPT                   --09 减值准备_折币
  ,DISTR_DT                   --10 贷款实际发放日期
  ,EXP_DT                     --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID           --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM           --13 贷款标准产品名称
  ,INT_RECVBL                 --14 应收利息_原币
  ,INT_RECVBL_CNY             --15 应收利息_折人民币
  ,DATA_SRC                   --16 数据来源
  ,SUBJ_ID                    --17 科目号
  ,RCPT_ID                    --18 借据号
  ,TAX_BALANCE_BEFORE         --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY     --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE             --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY         --22 代垫增值税减值准备_折人民币   
  ,OVDUE_STATUS               --23 逾期状态   
  )
      SELECT
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID   --02 主键
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),
                        TRIM(D.CUST_ID),TRIM(F1.CUST_ID),TRIM(H.CUST_ID),TRIM(G.ACTL_FINER_CUST_ID),
                        TRIM(TRIM(H.SRC_PARTY_ID)),'-') AS CUST_ID            --03 客户号
              ,A.BELONG_ORG_ID                      AS ORG_ID                 --04 机构编号
              ,A.CURR_CD                            AS CUR                    --05 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                                    AS LOAN_LEVEL5_CLS_CD     --06 五级分类
              ,GREATEST(F.PRIC_OVDUE_DAYS,F.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
              ,S.CONFMAMT                           AS CONFMAMT               --08 保证金与抵押品价值
              ,ROUND((T.PRO_IMPT*J.EXRT),2)         AS PRO_IMPT               --09 减值准备_折币
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,ROUND((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0            
                      ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END),2) 
                                                    AS INT_RECVBL             --14 应收利息_原币
              ,ROUND(((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END)*J.EXRT),2) 
                                                    AS INT_RECVBL_CNY         --15 应收利息_折人民币
              ,'同业净值型'                         AS DATA_SRC               --16 数据来源
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,I.DUBIL_ID                           AS RCPT_ID                --18 借据号    
              ,0                                    AS TAX_ECL_BEFORE         --19 代垫增值税余额_原币
              ,0                                    AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
              ,0                                    AS TAX_ECL_BEFORE         --21 代垫增值税减值准备_原币
              ,0                                    AS TAX_ECL_BEFORE_CNY     --22 代垫增值税减值准备_折人民币  
              ,A.OVDUE_STATUS                       AS OVDUE_STATUS           --23 逾期状态       
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
LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
             FROM RRP_MDL.S_G13_BASE B
            WHERE B.DATA_DT = V_P_DATE
            GROUP BY B.CREDNO
            ) S
ON I.DUBIL_ID = S.CREDNO
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE     
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE   
WHERE ((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END) <> 0
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
  V_STEP_DESC := '--加工同业非标数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                    --01 数据日期
  ,ID                         --02 主键
  ,CUST_ID                    --03 客户号
  ,ORG_ID                     --04 机构编号
  ,CUR                        --05 币种
  ,LOAN_LEVEL5_CLS_CD         --06 五级分类
  ,OVDUE_DAYS                 --07 逾期天数
  ,CONFMAMT                   --08 保证金与抵押品价值
  ,PRO_IMPT                   --09 减值准备_折币
  ,DISTR_DT                   --10 贷款实际发放日期
  ,EXP_DT                     --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID           --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM           --13 贷款标准产品名称
  ,INT_RECVBL                 --14 应收利息_原币
  ,INT_RECVBL_CNY             --15 应收利息_折人民币
  ,DATA_SRC                   --16 数据来源
  ,SUBJ_ID                    --17 科目号
  ,RCPT_ID                    --18 借据号
  ,TAX_BALANCE_BEFORE         --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY     --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE             --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY         --22 代垫增值税减值准备_折人民币   
  ,OVDUE_STATUS               --23 逾期状态   
  )
      SELECT
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID AS ID --02 主键
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(A.UDER_ACTL_FINER_CUST_ID),TRIM(G.ISSUER_CUST_ID),TRIM(A.CNTPTY_CUST_ID),
                        TRIM(D.CUST_ID),NVL(TRIM(D.SRC_PARTY_ID),'-')) AS CUST_ID --03 客户号
              ,A.BELONG_ORG_ID                      AS ORG_ID                 --04 机构编号
              ,A.CURR_CD                            AS CUR                    --05 币种
              ,DECODE(T.LVL5_CL,'1','正常','2','关注','3','次级','4','可疑','5','损失','正常') 
                                                    AS LOAN_LEVEL5_CLS_CD     --06 五级分类
    	        ,GREATEST(T1.PRIC_OVDUE_DAYS,T1.INT_OVDUE_DAYS) AS OVDUE_DAYS   --07 逾期天数
              ,S.CONFMAMT                           AS CONFMAMT               --08 保证金与抵押品价值
              ,ROUND((T.PRO_IMPT*J.EXRT),2)         AS PRO_IMPT               --09 减值准备_折币
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,ROUND((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                      ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END),2) 
                                                    AS INT_RECVBL             --14 应收利息_原币
              ,ROUND(((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END)*J.EXRT),2) 
                                                    AS INT_RECVBL_CNY         --15 应收利息_折人民币
              ,'同业非标'                           AS DATA_SRC               --16 数据来源
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,I.DUBIL_ID                           AS RCPT_ID                --18 借据号    
              ,0                                    AS TAX_ECL_BEFORE         --19 代垫增值税余额_原币
              ,0                                    AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
              ,0                                    AS TAX_ECL_BEFORE         --21 代垫增值税减值准备_原币
              ,0                                    AS TAX_ECL_BEFORE_CNY     --22 代垫增值税减值准备_折人民币   
              ,A.OVDUE_STATUS                       AS OVDUE_STATUS           --23 逾期状态       
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
LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
             FROM RRP_MDL.S_G13_BASE B
            WHERE B.DATA_DT = V_P_DATE
            GROUP BY B.CREDNO
            ) S
       ON I.DUBIL_ID = S.CREDNO
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID || '_' || A.ASSET_THD_CLS_CD || '_' || A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE    
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE       
WHERE ((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
       ELSE NVL(A.INT_RECVBL,0)+NVL(A.RECVBL_UNCOL_INT,0) END) <> 0
       )
AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
;   
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 8;
  V_STEP_DESC := '--加工同业证券持仓数据--';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_MDL.S_G1102_YSLX
  (DATA_DT                    --01 数据日期
  ,ID                         --02 主键
  ,CUST_ID                    --03 客户号
  ,ORG_ID                     --04 机构编号
  ,CUR                        --05 币种
  ,LOAN_LEVEL5_CLS_CD         --06 五级分类
  ,OVDUE_DAYS                 --07 逾期天数
  ,CONFMAMT                   --08 保证金与抵押品价值
  ,PRO_IMPT                   --09 减值准备_折币
  ,DISTR_DT                   --10 贷款实际发放日期
  ,EXP_DT                     --11 贷款原始到期日期
  ,LOAN_STD_PROD_ID           --12 贷款标准产品编号
  ,LOAN_STD_PROD_NM           --13 贷款标准产品名称
  ,INT_RECVBL                 --14 应收利息_原币
  ,INT_RECVBL_CNY             --15 应收利息_折人民币
  ,DATA_SRC                   --16 数据来源
  ,SUBJ_ID                    --17 科目号
  ,RCPT_ID                    --18 借据号
  ,TAX_BALANCE_BEFORE         --19 代垫增值税余额_原币
  ,TAX_BALANCE_BEFORE_CNY     --20 代垫增值税余额_折人民币
  ,TAX_ECL_BEFORE             --21 代垫增值税减值准备_原币
  ,TAX_ECL_BEFORE_CNY         --22 代垫增值税减值准备_折人民币   
  ,OVDUE_STATUS               --23 逾期状态   
  )
      SELECT
               V_P_DATE                             AS DATA_DT                --01 数据日期
              ,A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID AS ID   --02 主键
              ,COALESCE(TRIM(G.MGER_CUST_ID),TRIM(G.ISSUER_CUST_ID),D.CUST_ID,F.CUST_ID,
                        TRIM(B.CUST_ID),NVL(TRIM(B.SRC_PARTY_ID), '-')) AS CUST_ID --03 客户号
              ,A.BELONG_ORG_ID                      AS ORG_ID                 --04 机构编号
              ,A.CURR_CD                            AS CUR                    --05 币种
              ,DECODE(I.LOAN_LEVEL5_CLS_CD,'10','正常','20','关注','30','次级','40','可疑','50','损失','正常') 
                                                    AS LOAN_LEVEL5_CLS_CD     --06 五级分类
              ,GREATEST(A.PRIC_OVDUE_DAYS,A.INT_OVDUE_DAYS) AS OVDUE_DAYS     --07 逾期天数
              ,S.CONFMAMT                           AS CONFMAMT               --08 保证金与抵押品价值
              ,ROUND((T.PRO_IMPT*J.EXRT),2)         AS PRO_IMPT               --09 减值准备_折币
              ,TO_CHAR(A.VALUE_DT,'YYYYMMDD')       AS DISTR_DT               --10 贷款实际发放日期
              ,TO_CHAR(A.EXP_DT,'YYYYMMDD')         AS EXP_DT                 --11 贷款原始到期日期
              ,A.STD_PROD_ID                        AS LOAN_STD_PROD_ID       --12 贷款标准产品编号
              ,C.PROD_NAME                          AS LOAN_STD_PROD_NM       --13 贷款标准产品名称
              ,ROUND((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                      ELSE NVL(A.INT_RECVBL,0) END),2) AS INT_RECVBL          --14 应收利息_原币
              ,ROUND(((CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
                       ELSE NVL(A.INT_RECVBL,0) END)*J.EXRT),2) 
                                                    AS INT_RECVBL_CNY         --15 应收利息_折人民币
    	        ,'同业证券持仓'                       AS DATA_SRC               --16 数据来源
              ,A.SUBJ_ID                            AS SUBJ_ID                --17 科目号
              ,I.DUBIL_ID                           AS RCPT_ID                --18 借据号    
              ,0                                    AS TAX_ECL_BEFORE         --19 代垫增值税余额_原币
              ,0                                    AS TAX_BALANCE_BEFORE_CNY --20 代垫增值税余额_折人民币
              ,0                                    AS TAX_ECL_BEFORE         --21 代垫增值税减值准备_原币
              ,0                                    AS TAX_ECL_BEFORE_CNY     --22 代垫增值税减值准备_折人民币 
              ,A.OVDUE_STATUS                       AS OVDUE_STATUS           --23 逾期状态               
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
LEFT JOIN (SELECT B.CREDNO,SUM(B.CONFMAMT) CONFMAMT
             FROM RRP_MDL.S_G13_BASE B
            WHERE B.DATA_DT = V_P_DATE
            GROUP BY B.CREDNO
            ) S
       ON I.DUBIL_ID = S.CREDNO
LEFT JOIN RRP_MDL.M_OTH_PRO_IMPT_INFO T
       ON A.FIN_INSTM_ID||'_'||A.ASSET_THD_CLS_CD||'_'||A.OBJ_ID = T.RID
      AND T.DATA_DT = V_P_DATE      
LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO J  --汇率表
       ON A.CURR_CD=J.BASE_CUR
      AND J.CNV_CUR='CNY'
      AND J.DATA_DT = V_P_DATE   
WHERE ( (CASE WHEN A.OVDUE_STATUS ='OverDue90' THEN 0 
         ELSE NVL(A.INT_RECVBL,0) END) <> 0
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

END ETL_S_G1102_YSLX;
/

