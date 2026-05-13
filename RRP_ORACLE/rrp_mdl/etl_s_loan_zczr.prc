CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_ZCZR(I_P_DATE      IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_S_LOAN_ZCZR
  *  功能描述：资产转让整合表
  *  创建日期：20250822
  *  开发人员：HYF
  *  来源表： S_LOAN_BAL_CHANGE_EX 贷款变动整合表
  *           O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW 贷款分户计量流水
  *           M_LOAN_TRF_INFO 信贷资产转让信息
  *           M_LOAN_TRF_REL_INFO 资产转让关系信息
  *           M_LOAN_IN_DUBILL_INFO 表内借据表
  *           M_CUST_IND_INFO 个人客户表
  *  目标表：S_LOAN_ZCZR 资产转让整合表
  *
  *  配置表：无
  *  修改情况：序号  修改日期  修改人     修改原因
  *             1    20250822  HYF         创建
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000); -- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_ZCZR'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_ZCZR'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_ZCZR T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_ZCZR'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  V_STEP := 2;
  V_STEP_DESC := '--加工零售转让数据--';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_LOAN_ZCZR
  (    DATA_DT           --1 数据日期
      ,SEQ_NUM           --2 序号
      ,RCPT_ID           --3 借据号
      ,TRF_CONT_ID       --4 转让合同号
      ,CUST_ID           --5 客户号
      ,CUST_NAME         --6 客户名称
      ,ZCLX              --7 资产类型
      ,ORG_ID            --8 机构编号
      ,ORG_NAME          --9 机构名称
      ,LVL5_CL           --10 转让时五级分类代码
      ,LVL5_CL_NAME      --11 转让时五级分类名称
      ,ZRQDKBJ           --12 转让前贷款本金余额
      ,JYDS              --13 交易对手
      ,JYDSLXDM          --14 交易对手类型代码
      ,JYDSLXMC          --15 交易对手类型名称
      ,JYPT              --16 交易平台
      ,ZRSHJK            --17 转让收回价款
      ,ZRSHBJJE          --18 转让收回本金金额
      ,CEHXJE            --19 差额核销金额
      ,SHKX              --20 收回利息
      ,DFFY              --21 垫付费用
      ,DDZZS             --22 代垫增值税
      ,DATA_SRC          --23 数据来源
      ,ASSET_TRAN_DT     --24 账务处理时间
      ,BZ                --25 备注
  )
WITH TMP AS( SELECT /*+USE_HASH(A B C D E F G O P Q )*/
                    A.RCPT_ID
                   ,SUM(A.CZFS_BAL) AS ZRQDKBJ --转让前贷款本金余额
                   ,SUM(CASE WHEN A.CZFS_TYP = '转让' THEN A.CZFS_BAL ELSE 0 END) AS ZRSHBJJE --转让收回本金金额   
                   ,SUM(CASE WHEN A.CZFS_TYP = '差额核销' THEN A.CZFS_BAL ELSE 0 END) AS CEHXJE --差额核销金额       
             FROM RRP_MDL.S_LOAN_BAL_CHANGE_EX A
             WHERE A.DATA_DT = V_P_DATE
             AND A.CZFS_TYP IN ('转让','差额核销')
             GROUP BY A.RCPT_ID
),  
TMP1 AS ( SELECT /*+USE_HASH(A B C D E F G O P Q )*/
                 A.DUBIL_ID
                ,TO_CHAR(A.ETL_DT+1,'YYYYMMDD') ASSET_TRAN_DT
                ,NVL(A.ADV_VAT_AMT,0) ADV_VAT_AMT --代垫增值税
                ,NVL(A.OUTPUT_TAX_LMT,0) OUTPUT_TAX_LMT --销项税
          FROM IML.EVT_LOAN_SUB_ACCT_MEASURE_FLOW A --贷款分户计量流水
          WHERE A.TRAN_WAY_CD = 'N'
          AND A.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND A.ETL_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')      
),
TMP2 AS ( SELECT /*+USE_HASH(A B C D E F G O P Q )*/
                 A.DUBIL_ID
                ,TO_CHAR(A.ETL_DT,'YYYYMMDD') ASSET_TRAN_DT
                ,NVL(A.ADV_VAT_AMT,0) ADV_VAT_AMT --代垫增值税
                ,NVL(A.OUTPUT_TAX_LMT,0) OUTPUT_TAX_LMT --销项税
          FROM RRP_MDL.O_IML_EVT_LOAN_SUB_ACCT_MEASURE_FLOW A --贷款分户计量流水
          WHERE A.TRAN_WAY_CD = 'Y'
          AND A.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
          AND A.ETL_DT >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y')      
),
--代垫增值税等于销项税则报0
TMP3 AS ( SELECT A.DUBIL_ID
                ,A.ASSET_TRAN_DT
                ,CASE WHEN A.ADV_VAT_AMT = ABS(A.OUTPUT_TAX_LMT-B.OUTPUT_TAX_LMT) 
                      THEN 0
                 ELSE A.ADV_VAT_AMT END AS ADV_VAT_AMT
          FROM TMP1 A
          LEFT JOIN TMP2 B
          ON A.DUBIL_ID = B.DUBIL_ID
          AND A.ASSET_TRAN_DT = B.ASSET_TRAN_DT
),           
--一笔转让合同对应多笔借据，代垫费用需取平均数
TMP4 AS (SELECT A.TRF_CONT_ID
               ,COUNT(A.TRF_CONT_ID) NUM 
               ,AVG(A.ADVC_SUIT_FEE)/COUNT(A.TRF_CONT_ID) ADVC_SUIT_FEE
          FROM RRP_MDL.M_LOAN_TRF_INFO  A --信贷资产转让信息
          LEFT JOIN RRP_MDL.M_LOAN_TRF_REL_INFO B --资产转让关系信息
          ON B.TRF_CONT_ID = A.TRF_CONT_ID
          AND B.DATA_DT = V_P_DATE
          WHERE A.DATA_SRC LIKE '%零售%'
          AND A.ASSET_TRAN_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
          AND A.DATA_DT = V_P_DATE
          GROUP BY A.TRF_CONT_ID)
,LVL5_CL AS ( SELECT 
                     G.RCPT_ID
                    ,G.CHANGE_DT
                    ,CASE WHEN G.BDQ_LVL5_CL IN ('03','04','05') THEN G.BDQ_LVL5_CL
                     ELSE G.BDS_LVL5_CL END AS BDQ_LVL5_CL
             FROM RRP_MDL.S_LOAN_BAL_CHANGE G --五级分类变动
             WHERE G.CHANGE_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
)
     SELECT /*+USE_HASH(A B C D E F G O P Q )*/
               V_P_DATE                        AS DATA_DT           --1 数据日期
              ,ROWNUM                          AS SEQ_NUM           --2 序号
              ,B.RCPT_ID                       AS RCPT_ID           --3 借据号
              ,A.TRF_CONT_ID                   AS TRF_CONT_ID       --4 转让合同号
              ,C.CUST_ID                       AS CUST_ID           --5 客户号
              ,D.CUST_NM                       AS CUST_NAME         --6 客户名称 
              ,'不良贷款'                      AS ZCLX              --7 资产类型
              ,A.ORG_ID                        AS ORG_ID            --8 机构编号     
              ,REPLACE(O.SSFXMC,'广东华兴银行股份有限公司','') AS ORG_NAME --9 机构名称
              ,G.BDQ_LVL5_CL                   AS LVL5_CL           --10 转让时五级分类代码
              ,CASE WHEN G.BDQ_LVL5_CL = '01' THEN '正常类'
                    WHEN G.BDQ_LVL5_CL = '02' THEN '关注类'
                    WHEN G.BDQ_LVL5_CL = '03' THEN '次级类'
                    WHEN G.BDQ_LVL5_CL = '04' THEN '可疑类'
                    WHEN G.BDQ_LVL5_CL = '05' THEN '损失类'
               END                             AS LVL5_CL_NAME      --11 转让时五级分类 
              ,ROUND(NVL(E.ZRQDKBJ,0),2)       AS ZRQDKBJ           --12 转让前贷款本金余额
              ,A.CNTPR_NM                      AS JYDS              --13 交易对手
              ,A.CRDT_CNTPR_TYP                AS JYDSLXDM          --14 交易对手类型代码 
              ,P.CD_DESCB                      AS JYDSLXMC          --15 交易对手类型名称 
              ,A.OTH_TRA_PLTF                  AS JYPT              --16 交易平台
              ,ROUND(NVL(E.ZRSHBJJE,0)+NVL(H.ADVC_SUIT_FEE,0)+NVL(F.ADV_VAT_AMT,0),2) AS ZRSHJK --17 转让收回价款
              ,ROUND(NVL(E.ZRSHBJJE,0),2)      AS ZRSHBJJE          --18 转让收回本金金额
              ,ROUND(NVL(E.CEHXJE,0),2)        AS CEHXJE            --19 差额核销金额
              ,0                               AS SHKX              --20 收回利息 --默认0
              ,ROUND(NVL(H.ADVC_SUIT_FEE,0),2) AS DFFY              --21 垫付费用
              ,ROUND(NVL(F.ADV_VAT_AMT,0),2)   AS DDZZS             --22 代垫增值税 
              ,A.DATA_SRC                      AS DATA_SRC          --23 数据来源
              ,A.ASSET_TRAN_DT                 AS ASSET_TRAN_DT     --24 账务处理时间
              ,''                              AS BZ                --25 备注
        FROM RRP_MDL.M_LOAN_TRF_INFO  A --信贷资产转让信息账务处理时间
        LEFT JOIN RRP_MDL.M_LOAN_TRF_REL_INFO B --资产转让关系信息
          ON B.TRF_CONT_ID = A.TRF_CONT_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO C --表内借据表
          ON C.RCPT_ID = B.RCPT_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户表
          ON D.CUST_ID = C.CUST_ID
         AND D.DATA_DT = V_P_DATE
        LEFT JOIN TMP E --转让收回本金金额
          ON E.RCPT_ID = B.RCPT_ID
        LEFT JOIN TMP3 F --代垫增值税
          ON F.DUBIL_ID = B.RCPT_ID
         AND F.ASSET_TRAN_DT = B.ASSET_TRAN_DT
        LEFT JOIN LVL5_CL G --五级分类变动
          ON G.RCPT_ID = B.RCPT_ID
         AND G.CHANGE_DT = B.ASSET_TRAN_DT
        LEFT JOIN TMP4 H --代垫诉讼费
          ON H.TRF_CONT_ID = A.TRF_CONT_ID
        LEFT JOIN RRP_MDL.A_FGB_ORG O --机构表
          ON O.NBJGH = A.ORG_ID
         AND O.BGRQ = V_P_DATE
        LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD P --公共代码表
          ON A.CRDT_CNTPR_TYP = P.CD_VAL
         AND CD_ID = 'CD2115' --交易机构类型代码
       WHERE A.DATA_SRC LIKE '%零售%'
         AND A.ASSET_TRAN_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
         AND A.DATA_DT = V_P_DATE
       ORDER BY A.ASSET_TRAN_DT ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  
-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_LOAN_ZCZR;
/

