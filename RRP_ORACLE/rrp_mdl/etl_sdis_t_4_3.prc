CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_SDIS_T_4_3(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_SDIS_T_4_3
  *  功能描述：表4.3 分户账信息
  *  创建日期：20250822
  *  开发人员：ZHAOSHENGJIE
  *  来源表：
  *  目标表： SDIS_T_4_3
  *  配置表：
  *  修改情况： 序号  修改日期         修改人          修改原因
  *             1    20250822    ZHAOSHENGJIE        首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;                       --处理步骤
  V_P_DATE     VARCHAR2(8);                        --跑批数据日期
  V_P10_DATE   VARCHAR2(10);                       --采集日期
  V_STARTTIME  DATE;                               --处理开始时间
  V_ENDTIME    DATE;                               --处理结束时间
  V_SQLCOUNT   INTEGER := 0;                       --更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);                      --SQL执行描述信息
  V_STEP_DESC  VARCHAR2(200);                      --任务名称
  V_TAB_NAME   VARCHAR2(100) := 'SDIS_T_4_3';      --表名
  V_PROC_NAME  VARCHAR2(50)  := 'ETL_SDIS_T_4_3';  --程序名称
  V_PART_NAME  VARCHAR2(100);                      --分区名称
  V_SYSTEM     VARCHAR2(30)  := '一表通';          --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_P10_DATE := TO_CHAR(TO_DATE(I_P_DATE,'YYYYMMDD'),'YYYY-MM-DD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  O_ERRCODE := '0';

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := 2;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_YBT.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
  RRP_YBT.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TAB_NAME,O_ERRCODE);--清空当天跑批分区

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '插入个人贷款数据';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID           --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
  )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , A.ACC_ID                                             AS  D030002        --  分户账号
      , A.CUST_ID                                             AS  D030003        --  客户ID
      , 1                                                     AS  D030003_OTH    --  分户账是否个人
      , REMOVE_SPECIAL_CHARS(D.CUST_NM）                                             AS  D030004_ORIG        --  分户账名称
      , '02'                                                  AS  D030005        --  分户账类型
      , '1'                                                   AS  D030006        --  计息标识
      , CASE WHEN A.INT_CALC_MODE IN ('01','02''07') THEN  A.INT_CALC_MODE
             WHEN A.INT_CALC_MODE = '06' THEN '03'
             WHEN A.INT_CALC_MODE = '03' THEN '04'
             WHEN A.INT_CALC_MODE = '04' THEN '05'
             --WHEN A.INT_CALC_MODE = '05' THEN '06'
             ELSE '00' END                                    AS  D030007        --  计息方式
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , '01'                                                  AS  D030010        --  借贷标识
      , ''                                                    AS  D030016        --  钞汇类别
      , ''                                                    AS  D030017        --  内部账利率
      , NVL(A.LOAN_BAL,0)                                     AS  D030018        --  借方余额
      , 0                                                     AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(CASE WHEN A.LOAN_PROD_NM LIKE '%债权直转%' THEN  NVL(A.INIT_DISTR_DT,'9999-12-31')
                ELSE NVL(A.OPEN_ACC_DT,'99991231')
            END  ,'YYYYMMDD'),'YYYY-MM-DD')                   AS  D030011        --  开户日期
      , /*TO_CHAR(TO_DATE(
            (CASE WHEN A.LOAN_STD_PROD_ID IN ('202010100004','202010100005') THEN
                CASE WHEN NVL(A.LOAN_BAL,0) + NVL(A.IN_INT_OVD_BAL,0) + NVL(A.OUT_INT_OVD_BAL,0)+ NVL(A.IN_BS_INT,0) + NVL(A.OFF_BS_INT,0) <> 0
                     THEN '99991231'
                     WHEN NVL(A.LAST_REPY_DT,'99991231') IN ('00010101','20991231','29991231')
                     THEN '99991231'
                     ELSE NVL(A.LAST_REPY_DT,'99991231')
                 END
                WHEN NVL(A.CNL_ACC_DT,'29991231') IN ('00010101','20991231','29991231')
                THEN '99991231'
                ELSE A.CNL_ACC_DT END ),'YYYYMMDD'),'YYYY-MM-DD')  */
          NVL(
                CASE WHEN A.RCPT_STAT = 'C01' THEN NVL(TO_CHAR(TO_DATE(A.PAYOFF_DT,'YYYYMMDD'),'YYYY-MM-DD'),NULL)
                      ELSE NULL END,
                NVL(TO_CHAR(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),'YYYY-MM-DD'), '9999-12-31')
          )                   AS  D030012        --  销户日期
       , CASE   WHEN NVL(
                          CASE WHEN A.RCPT_STAT = 'C01' THEN NVL(TO_CHAR(TO_DATE(A.PAYOFF_DT,'YYYYMMDD'),'YYYYMMDD'), NULL)
                                ELSE NULL END,
                          NVL(TO_CHAR(TO_DATE(A.LOAN_ORIG_EXP_DT,'YYYYMMDD'),'YYYY-MM-DD'), '99991231')
                     )   	 <= V_P_DATE    THEN '03' ---新增判断，销户日期在报送期前的，状态设置为销户。
                WHEN NVL(A.ACT_END_DT, '99991231') IN ('00010101','20991231','29991231','99991231') THEN '01'
                WHEN A.ACC_STAT = '01' THEN '01'
                --WHEN A.ACC_STAT = '02' THEN '03'
                WHEN A.ACC_STAT = '03' THEN '02'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '04'
                WHEN A.ACC_STAT = '11' THEN '05'
                ELSE '06' --如果未其他，需要在备注中具体描述
            END                                              AS  D030013        --  账户状态
      ,CASE WHEN A.ACC_STAT IN ('01','02','03','04','05','06','07','11')  THEN ''
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      , 'LSFXB'                                              AS  DEPT_NO              --条线 --800870零售风险部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO  A --表内借据信息
    INNER JOIN RRP_MDL.M_CUST_IND_INFO D ----个人客户信息
       ON D.CUST_ID = A.CUST_ID
      AND D.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
       ON B.ORG_ID = A.ORG_ID
    LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
       ON CODE1.SRC_VALUE_CODE = A.ACC_STAT
      AND CODE1.SRC_CLASS_CODE = 'Z0018' --账户状态
      AND CODE1.TAR_CLASS_CODE = 'Z0018' --账户状态
      AND CODE1.MOD_FLG = 'EAST' --目前以EAST口径为准
      AND CODE1.DATA_DT = V_P_DATE
   WHERE REGEXP_LIKE(A.LOAN_BIZ_TYP,'^(01|90)')
     -- AND NVL(TRIM(A.ACT_END_DT),'99991231') >= SUBSTR(V_P_DATE,1,4)||'0101'
      AND A.SUBJ_ID IN ('30070102','13030201','13030202','13030203')
      AND A.OPEN_ACC_DT <= V_P_DATE
      AND A.YBT_FLG = 'Y'
      AND A.DATA_DT= V_P_DATE

      ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

V_STEP := 4;
  V_STEP_DESC := '插入对公贷款数据';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID           --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
  )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , A.ACC_ID                                             AS  D030002        --  分户账号
      , A.CUST_ID                                             AS  D030003        --  客户ID
      , -- CASE WHEN D.CUST_CL = 'E' THEN 1 ELSE 0 END         AS  D030003_OTH    --  分户账是否个人
        0                        AS  D030003_OTH    --  分户账是否个人     20251218 个体工商户的分户账类型为个人，但是分户账名称不能脱敏（杨媛媛）
      , REMOVE_SPECIAL_CHARS(D.CUST_NM)                                             AS  D030004_ORIG        --  分户账名称
      , CASE WHEN D.CUST_CL = 'E' THEN '02' ELSE '01'   END                                               AS  D030005        --  分户账类型
      , '1'                                                   AS  D030006        --  计息标识
      , CASE WHEN A.INT_CALC_MODE IN ('01','02''07') THEN  A.INT_CALC_MODE
             WHEN A.INT_CALC_MODE = '06' THEN '03'
             WHEN A.INT_CALC_MODE = '03' THEN '04'
             WHEN A.INT_CALC_MODE = '04' THEN '05'
             --WHEN A.INT_CALC_MODE = '05' THEN '06'
             ELSE '00' END                                    AS  D030007        --  计息方式
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , '01'                                                  AS  D030010        --  借贷标识
      , ''                                                    AS  D030016        --  钞汇类别
      , ''                                                    AS  D030017        --  内部账利率
      , CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
            END                                     AS  D030018        --  借方余额
      , 0                                                     AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(A.OPEN_ACC_DT,'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , /*TO_CHAR(TO_DATE(
            (CASE WHEN NVL(A.ACT_END_DT, '99991231') IN ('00010101','20991231','29991231')
                THEN '99991231'
                  WHEN A.ACT_END_DT > V_P_DATE THEN '99991231'
                ELSE NVL(A.ACT_END_DT, '99991231')
            END ),'YYYYMMDD'),'YYYY-MM-DD') */
         NVL(
              (CASE WHEN TO_CHAR(TO_DATE(A.PAYOFF_DT,'YYYYMMDD'),'YYYY-MM-DD')='2999-12-31' THEN NULL
              WHEN A.RCPT_STAT = 'C01' THEN NVL(TO_CHAR(TO_DATE(A.PAYOFF_DT,'YYYYMMDD'),'YYYY-MM-DD'), NULL)
             ELSE NULL END )
             ,(TO_CHAR(TO_DATE(NVL(A.LOAN_ORIG_EXP_DT, '99991231'),'YYYY-MM-DD'),'YYYY-MM-DD'))
             )           AS  D030012        --  销户日期
       , CASE   WHEN A.ACT_END_DT <= V_P_DATE AND NVL(A.ACT_END_DT, '99991231') <> '00010101'THEN '03' ---新增判断，销户日期在报送期前的，状态设置为销户。 THEN '03' ---新增判断，销户日期在报送期前的，状态设置为销户。
                WHEN NVL(A.ACT_END_DT, '99991231') IN ('00010101','20991231','29991231') THEN '01'
                WHEN A.ACC_STAT = '01' THEN '01'
                --WHEN A.ACC_STAT = '02' THEN '03'
                WHEN A.ACC_STAT = '03' THEN '02'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '04'
                WHEN A.ACC_STAT = '11' THEN '05'
                ELSE '06' --如果未其他，需要在备注中具体描述
            END                                               AS  D030013        --  账户状态
      ,CASE WHEN A.ACC_STAT IN ('01','02','03','04','05','06','07','11')  THEN ''
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      , 'FXGLB'                                                AS  DEPT_NO              --条线 --800919风险管理部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
    FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO  A --表内借据信息
    INNER JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
       ON D.CUST_ID = A.CUST_ID
      AND D.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
       ON B.ORG_ID = CASE WHEN SUBSTR(A.ORG_ID,1,3) = '896' THEN '896' ELSE A.ORG_ID END
    LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.MOD_FLG = 'EAST'--目前以EAST口径为准
       AND CODE1.DATA_DT = V_P_DATE
    WHERE (A.LOAN_BIZ_TYP NOT LIKE '01%' OR A.LOAN_BIZ_TYP LIKE '90%')--(因M_LOAN_IN_DUBILL_INFO A --表内借据信息目前该字段为空，暂时注释)
     -- AND NVL(TRIM(A.ACT_END_DT),'99991231') >= SUBSTR(V_P_DATE,1,4)||'0101'
       AND A.LOAN_BIZ_TYP <> '99'
       AND A.AD_CSH_FLG = '0'
       AND A.OPEN_ACC_DT <= V_P_DATE
       AND A.YBT_FLG = 'Y'
       AND A.DATA_DT= V_P_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


  V_STEP := 5;
  V_STEP_DESC := '插入个人存款数据';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID            --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
       ,org_no_check          --业务类型，用于业务测试
  )
  WITH ZHZT_INFO AS (
  SELECT ZT.ACC_ID,ZHZT,ZT.ACC_ID_EAST,
         ROW_NUMBER() OVER(PARTITION BY ZT.ACC_ID_EAST ORDER BY DECODE(ZHZT,'03',1,'04',2,'05',3,'01',4,99)) AS RN --03销户>04冻结>05止付>01正常>06其他
  FROM (
  SELECT A.ACC_ID,A.ACC_ID_EAST,
         CASE WHEN NVL(A.CNL_ACC_DT,'99991231') <= V_P_DATE THEN '03' ---到期时间在报送期前的默认销户
            WHEN NVL(A.CNL_ACC_DT,'99991231') = '99991231' AND TRIM(A.DEP_ACCT_STATUS_CD) = 'C' THEN '06' --如果到期时间为99991231 但是状态为C销户，设置为 06其他
            WHEN TRIM(CODE2.TAR_VALUE_CODE) IS NULL AND TRIM(A.DEP_ACCT_STATUS_CD) IS NOT NULL
                 THEN DECODE(TRIM(A.DEP_ACCT_STATUS_CD),'A','01','H','05','S','05','D','05','C','03','06') --无账户（客户）限制类型是，通过账户类型判断
            ELSE NVL(TRIM(CODE2.TAR_VALUE_CODE),'06') --否则通过账户（客户）限制类型和账户类型拼接判断。兜底为“其他”
         END  AS ZHZT --账户状态
    FROM RRP_MDL.M_DEP_ACC_INFO  A --存款账户信息
    LEFT JOIN ( SELECT FS.ACCT_ID,FS.FROZ_STOP_PAY_BUS_WAY_CD
    FROM RRP_MDL.O_ICL_CMM_DEP_FROZ_STOP_PAY_DTL FS
    WHERE ETL_DT =  TO_DATE(V_P_DATE,'YYYYMMDD')
    GROUP BY  FS.ACCT_ID,FS.FROZ_STOP_PAY_BUS_WAY_CD
    ) T2   --存款账户冻结止付明细
      ON A.ACC_ID = T2.ACCT_ID
    LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表 关联存款账户冻结止付明细取账户状态
      ON TRIM(T2.FROZ_STOP_PAY_BUS_WAY_CD||A.DEP_ACCT_STATUS_CD) = CODE2.SRC_VALUE_CODE
     AND CODE2.SRC_CLASS_CODE='CD2783_CD2554'
     AND CODE2.TAR_CLASS_CODE='ZCZT'
     AND CODE2.MOD_FLG = 'YBT'
  WHERE  A.CORP_IND_FLG = '1' --对私
       /*WUHB 20220418增加销户日期判断*/ /*UPDATE BY CXL 保留第三方监管账户余额>0的数据*/
       AND A.OPEN_ACC_DT <= V_P_DATE
      -- AND A.SUBJ_ID <> '30070101' --剔除委托存款 modify by tangan at 20221119
       AND (NVL(A.CNL_ACC_DT,'99991231')>= SUBSTR(V_P_DATE,1,4)||'01' OR A.DEP_BAL>0)
       AND A.DATA_DT= V_P_DATE
    )ZT
  )


SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , CASE WHEN LENGTH(A.ACC_ID_EAST) <= 4 AND TRIM(A.OLD_ACCT_ID) IS NOT NULL THEN TRIM(A.OLD_ACCT_ID)
                ELSE A.ACC_ID_EAST
            END                                              AS  D030002        --  分户账号
      , A.CUST_ID                                             AS  D030003        --  客户ID
      , 1                                                     AS  D030003_OTH    --  分户账是否个人
      , REMOVE_SPECIAL_CHARS( NVL(D.CUST_NM,C.CUST_NM))                               AS  D030004_ORIG        --  分户账名称
      , '02'                                                  AS  D030005        --  分户账类型
      , '1'                                                   AS  D030006        --  计息标识
      , CASE WHEN T.INT_SET_FREQ_CD IN ('M1','1M','30D','D30') THEN '01'
             WHEN T.INT_SET_FREQ_CD IN ('M3','3M','90D','D90') THEN '02'
             WHEN T.INT_SET_FREQ_CD IN ( 'M6','6M','180D','D180') THEN '03'
             WHEN T.INT_SET_FREQ_CD IN ('Y1','M12','1Y','Y1') THEN '04'
             --WHEN NVL(T1.INT_SET_FREQ_CD,T.INT_SET_FREQ_CD) IS NULL THEN '06'
             ELSE '00'
        END                                                   AS  D030007              --  计息方式    --根据高培能提供的口径，只能根据频率划分，05不定期结息 和07利随本清的口径不清楚，同时原系统对应的码值可能没有列举全
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , '02'                                                  AS  D030010        --  借贷标识
      , CASE WHEN A.CUR NOT IN ('CNY','BWB') THEN '02' ELSE NULL END         AS  D030016        --  钞汇类别
      , ''                                                    AS  D030017        --  内部账利率
      , 0                       AS  D030018        --  借方余额
      , A.DEP_BAL                                             AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(NVL(A.OPEN_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , TO_CHAR(TO_DATE(
            (CASE WHEN A.CNL_ACC_DT IN ('29991231') THEN '99991231'
                ELSE NVL(A.CNL_ACC_DT,'99991231')
            END),'YYYYMMDD'),'YYYY-MM-DD')                    AS  D030012        --  销户日期
       ,T2.ZHZT                                   AS  D030013        --  账户状态
      ,/*CASE WHEN NVL(A.CNL_ACC_DT,'99991231') <= V_P_DATE THEN '03'
            WHEN TRIM(CODE2.TAR_VALUE_CODE) IS NULL AND TRIM(A.DEP_ACCT_STATUS_CD) IS NOT NULL
                 THEN DECODE(TRIM(A.DEP_ACCT_STATUS_CD),'A','01','H','05','S','05','D','05','C','03','00')
            ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30))
        END  */
        NULL                                           AS  D030014        --  备注
      , NULL                                                 AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      ,/* CASE WHEN A.DEP_PROD_CD = '101010100005' THEN 'LSJRB' --101010100005/医保个账注资
            ELSE  'CFGLB'  END  */
       'LSJRB'                                                  AS  DEPT_NO              --条线  800957财富管理部/800721零售金融部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
      ,CASE WHEN  A.DEP_PROD_CD = '101010100005' THEN '医保个账注资' END      org_no_check          --业务类型，用于业务测试
    FROM RRP_MDL.M_DEP_ACC_INFO  A --存款账户信息
    LEFT JOIN RRP_MDL.M_CUST_IND_INFO D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
      AND D.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.CUST_CL = 'E'  --个体工商户
       AND C.DATA_DT = V_P_DATE
    LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
       ON B.ORG_ID = A.ORG_ID
/*    LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.DEP_ACC_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.MOD_FLG = 'EAST' --目前以EAST口径为准
       AND CODE1.DATA_DT = V_P_DATE*/
    LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL T  --存款账户利息明细
      ON T.ACCT_ID = A.ACC_ID_EAST
     AND T.INT_CLS_CD = 'INT'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     LEFT JOIN ZHZT_INFO T2
      ON T2.ACC_ID_EAST = A.ACC_ID_EAST
     AND RN = 1
    WHERE  A.CORP_IND_FLG = '1' --对私
       /*WUHB 20220418增加销户日期判断*/ /*UPDATE BY CXL 保留第三方监管账户余额>0的数据*/
       AND A.OPEN_ACC_DT <= V_P_DATE
      -- AND A.SUBJ_ID <> '30070101' --剔除委托存款 modify by tangan at 20221119
       AND (NVL(A.CNL_ACC_DT,'99991231')>= SUBSTR(V_P_DATE,1,4)||'01' OR A.DEP_BAL>0)
       AND A.DATA_DT= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 6;
  V_STEP_DESC := '插入对公存款数据（非同业）';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID            --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
       , ORG_NO_CHECK         --机构号，用于业务测试
  )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , CASE WHEN LENGTH(A.ACC_ID_EAST) <= 4 AND TRIM(A.OLD_ACCT_ID) IS NOT NULL THEN TRIM(A.OLD_ACCT_ID)
                ELSE A.ACC_ID_EAST
            END                                               AS  D030002        --  分户账号
      , A.CUST_ID                                             AS  D030003        --  客户ID
      ,-- CASE WHEN  C.CUST_CL = 'E' THEN 1 ELSE 0 END          AS  D030003_OTH    --  分户账是否个人   20251218 个体工商户的分户账类型为个人，但是分户账名称不能脱敏（杨媛媛）
        0                                                     AS  D030003_OTH    --  分户账是否个人
      , CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM ),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                              AS  D030004_ORIG        --  分户账名称
      ,CASE WHEN  C.CUST_CL = 'E' THEN '02'   --个体工商户算个人存款
            ELSE '01'  END                                               AS  D030005        --  分户账类型
      , '1'                                                   AS  D030006        --  计息标识
      , CASE WHEN T.INT_SET_FREQ_CD IN ('M1','1M','30D','D30') THEN '01'
             WHEN T.INT_SET_FREQ_CD IN ('M3','3M','90D','D90') THEN '02'
             WHEN T.INT_SET_FREQ_CD IN ( 'M6','6M','180D','D180') THEN '03'
             WHEN T.INT_SET_FREQ_CD IN ('Y1','M12','1Y','Y1') THEN '04'
             --WHEN NVL(T1.INT_SET_FREQ_CD,T.INT_SET_FREQ_CD) IS NULL THEN '06'
             ELSE '00'
        END                                                       AS  D030007        --  计息方式    --根据高培能提供的口径，只能根据频率划分，05不定期结息 和07利随本清的口径不清楚，同时原系统对应的码值可能没有列举全
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , '02'                                                  AS  D030010        --  借贷标识
      , /*CASE WHEN A.CASH_REMIT_TYP = '01' THEN NULL
             WHEN A.CASH_REMIT_TYP = '02' THEN '01'
             WHEN A.CASH_REMIT_TYP = '03' THEN '02'
             WHEN A.CASH_REMIT_TYP = '04' THEN '03'
        ELSE NULL END  */
        CASE WHEN A.CUR NOT IN ('CNY','BWB') THEN '02' ELSE NULL END                                       AS  D030016        --  钞汇类别
      , ''                                                    AS  D030017        --  内部账利率
      , 0                                             AS  D030018        --  借方余额
      , A.DEP_BAL                                                     AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(NVL(A.OPEN_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , TO_CHAR(TO_DATE(
            (CASE WHEN A.CNL_ACC_DT IN ('29991231') THEN '99991231'
                ELSE NVL(A.CNL_ACC_DT,'99991231')
            END),'YYYYMMDD'),'YYYY-MM-DD')                    AS  D030012        --  销户日期
       , CASE   WHEN NVL(A.CNL_ACC_DT,'99991231') <= V_P_DATE THEN '03'
                WHEN NVL(A.CNL_ACC_DT,'99991231') IN ('99991231','29991231') THEN '01'
                WHEN A.DEP_ACC_STAT = '01' THEN '01'
                WHEN A.DEP_ACC_STAT = '02' THEN '03'
                WHEN A.DEP_ACC_STAT = '03' THEN '02'
                WHEN A.DEP_ACC_STAT IN ('04','05','06','07') THEN '04'
                WHEN A.DEP_ACC_STAT = '11' THEN '05'
                ELSE '06' --如果未其他，需要在备注中具体描述
            END                                               AS  D030013        --  账户状态
      ,CASE WHEN A.DEP_ACC_STAT IN ('01','02','03','04','05','06','07','11')  THEN ''
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      , 'GSYHB'                                              AS  DEPT_NO              --条线             800976资金交易部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
      ,B.ORG_ID                                               AS  ORG_NO_CHECK         --机构号，用于业务测试

    FROM RRP_MDL.M_DEP_ACC_INFO A --存款账户信息
      LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
        ON B.ORG_ID = (CASE WHEN A.ORG_ID LIKE '896%' THEN '896' ELSE A.ORG_ID END)
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8)*/--科目报送到三级
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.DEP_ACC_STAT
       AND CODE2.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.MOD_FLG = 'EAST'
       AND CODE2.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL T  --存款账户利息明细
      ON T.ACCT_ID = A.ACC_ID_EAST
     AND T.INT_CLS_CD = 'INT'
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
/*
     LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO T2 --存款客户账户信息
      ON T2.CUST_ACCT_CARD_NO = A.ACC_ID
     AND TRIM(T2.CUST_ACCT_CARD_NO) IS NOT NULL
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     */
     WHERE A.CORP_IND_FLG = '2' --对公
       AND (NVL(A.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,4)||'0101' OR A.DEP_BAL > 0)  /*WUHB 20220418增加销户日期判断*/
       AND A.OPEN_ACC_DT <= V_P_DATE
       AND A.SUBJ_ID NOT IN('30070101','20100102','20050201','20150101','20150102','20150104','20150105','20150106','20150107','20150199','20150201')--update by czk 20220824
       AND A.DATA_DT= V_P_DATE

       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 7;
  V_STEP_DESC := '插入同业存款数据';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID            --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
       ,ORG_NO_CHECK          --机构号，用于业务测试
  )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , A.ACCT_ID                                             AS  D030002        --  分户账号
      , A.CUST_ID                                             AS  D030003        --  客户ID
      , 0                                                     AS  D030003_OTH    --  分户账是否个人
      , CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                             AS  D030004_ORIG        --  分户账名称
      , '01'                                                  AS  D030005        --  分户账类型
      , '1'                                                   AS  D030006        --  计息标识
      , CASE WHEN T1.INT_SET_FREQ_CD IN ('M1','1M','30D','D30') THEN '01'
             WHEN T1.INT_SET_FREQ_CD IN ('M3','3M','90D','D90') THEN '02'
             WHEN T1.INT_SET_FREQ_CD IN ( 'M6','6M','180D','D180') THEN '03'
             WHEN T1.INT_SET_FREQ_CD IN ('Y1','M12','1Y','Y1') THEN '04'
             --WHEN NVL(T1.INT_SET_FREQ_CD,T.INT_SET_FREQ_CD) IS NULL THEN '06'
             ELSE '07'
        END                                                   AS  D030007        --  计息方式
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , '02'                                                  AS  D030010        --  借贷标识
      , /*CASE WHEN A.CASH_REMIT_FLG = '01' THEN NULL
             WHEN A.CASH_REMIT_FLG = '02' THEN '01'
             WHEN A.CASH_REMIT_FLG = '03' THEN '02'
             WHEN A.CASH_REMIT_FLG = '04' THEN '03'
        ELSE NULL END */
        CASE WHEN A.CUR NOT IN ('CNY','BWB') THEN '02' ELSE NULL END                                         AS  D030016        --  钞汇类别
      , ''                                                    AS  D030017        --  内部账利率
      , 0                                             AS  D030018        --  借方余额
      , NVL(A.BAL,0)                                                     AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(NVL(A.OPEN_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , TO_CHAR(TO_DATE(
            (CASE WHEN A.CNL_ACC_DT IN ('29991231') THEN '99991231'
                ELSE NVL(A.CNL_ACC_DT,'99991231')
            END),'YYYYMMDD'),'YYYY-MM-DD')                    AS  D030012        --  销户日期
       , CASE   WHEN NVL(A.CNL_ACC_DT,'99991231') <= V_P_DATE THEN '03'
                WHEN A.ACC_STAT IN ('A','H','I','N','P','') THEN '01'
                WHEN A.ACC_STAT = 'C' THEN '03'
                WHEN A.ACC_STAT = 'R' THEN '02'
                WHEN A.ACC_STAT IN ('D','S') THEN '06'
                ELSE '01' --如果未其他，需要在备注中具体描述
            END                                               AS  D030013        --  账户状态
      ,CASE WHEN A.ACC_STAT = 'D' THEN '其他-不动户'
            WHEN A.ACC_STAT = 'S' THEN '其他-久悬户'
            ELSE NULL
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      , 'TZYHB'                                              AS  DEPT_NO              --条线 --800975投资银行部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
      ,B.ORG_ID                                               AS  ORG_NO_CHECK          --机构号，用于业务测试
      FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
      LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
        ON B.ORG_ID = (CASE WHEN A.ORG_ID LIKE '896%' THEN '896' ELSE A.ORG_ID END)
      /*LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = A.ORG_ID
       AND B.DATA_DT = V_P_DATE*/
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8)*/---科目报送到三级
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE2A --码值配置表 --ADD BY LIP 20230524 模型层没转码
        ON CODE2A.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE2A.SRC_CLASS_CODE = 'CD2554' --账户状态
       AND CODE2A.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2A.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        --ON A.ACC_STAT = CODE2.SRC_VALUE_CODE
        ON CODE2.SRC_VALUE_CODE = CODE2A.TAR_VALUE_CODE
       AND CODE2.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.MOD_FLG = 'EAST'
       LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL T1  --存款账户利息明细
        ON T1.ACCT_ID = A.ACCT_ID
       AND T1.INT_CLS_CD = 'INT'
       AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE A.BIZ_TYP LIKE '201%' --同业存放
       AND (NVL(A.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,4)||'0101' OR A.BAL>0)/*UPDATE BY 20220501 CXL 保留第三方监管账户余额>0的数据*/
       AND A.OPEN_ACC_DT <= V_P_DATE

       AND A.DATA_DT= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');


  V_STEP := 8;
  V_STEP_DESC := '插入内部分户账数据(非科目虚拟部分)';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID            --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
  )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , SUBSTR(B.FIN_PERMIT_NO,1,11)||B.ORG_ID                AS  D030001                --  机构ID
      , A.ACC_ID                                              AS  D030002        --  分户账号
      , NULL                                                    AS  D030003        --  客户ID
      , 0                                                     AS  D030003_OTH    --  分户账是否个人
      , REMOVE_SPECIAL_CHARS(
              REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(TRIM(A.ACC_NM),'（',''),'）',''),' ',''),'“',''),'”',''),'-','')
               )                                              AS  D030004_ORIG        --  分户账名称
      , '03'                                                  AS  D030005        --  分户账类型
      ,  CASE WHEN A.INT_CALC_FLG IN ('1','Y') THEN '1'
             ELSE '0' END                                     AS  D030006        --  计息标识
      , CASE WHEN A.INT_CALC_FLG NOT IN ('1','Y') THEN '06'
             WHEN A.INT_CALC_MODE IN ('01','02','07') THEN A.INT_CALC_MODE
             WHEN A.INT_CALC_MODE = '03' THEN '04'
             WHEN A.INT_CALC_MODE = '04' THEN '05'
             WHEN A.INT_CALC_MODE = '05' THEN '06'
             WHEN A.INT_CALC_MODE = '06' THEN '03'
             ELSE '00'
         END                                                  AS  D030007        --  计息方式
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , CASE WHEN SUBSTR(A.SUBJ_ID,1,1) IN ('7','8') THEN '01'  --陈天骏提的需求，把表外科目（7,8开头的)借贷标识设为借。
             WHEN A.DR_CR_FLG = 'D' THEN '01'
             WHEN A.DR_CR_FLG = 'C' THEN '02'
             WHEN A.DR_CR_FLG = 'B' THEN '03'
        END                                                   AS  D030010        --  借贷标识
      , NULL                                                    AS  D030016        --  钞汇类别     --EAST中没有相关口径
      ,  NVL(A.RATE,0)
       -- CASE WHEN A.INT_CALC_FLG NOT IN ('1','Y')         THEN NULL ELSE A.RATE END
                  AS  D030017        --  内部账利率
        ,CASE WHEN T.BAL_DIR_CD = 'D'
               THEN NVL(T.ACCT_BAL, 0.00)
               ELSE 0.00
           END                                AS  D030018        --  借方余额
      , CASE WHEN T.BAL_DIR_CD = 'C'
               THEN NVL(T.ACCT_BAL, 0.00)
               ELSE 0.00
           END                                                      AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(NVL(A.OPEN_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , TO_CHAR(TO_DATE(NVL(A.CNL_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030012        --  销户日期
       , CASE   WHEN A.ACC_STAT = '01' THEN '01'
                WHEN A.ACC_STAT = '02' THEN '03'
                WHEN A.ACC_STAT = '03' THEN '02'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '04'
                WHEN A.ACC_STAT = '11' THEN '05'
                ELSE '06' --如果未其他，需要在备注中具体描述
            END                                               AS  D030013        --  账户状态
      ,CASE WHEN A.ACC_STAT IN ('01','02','03','04','05','06','07','11')  THEN ''
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      ,CASE WHEN A.DATA_SRC = '旅通卡虚户' THEN 'LSJRB'
       ELSE 'YYGLB' END           AS  DEPT_NO               --条线  800918计划财务部/800902营运管理部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
     FROM RRP_MDL.M_DEP_INTL_ACC_INFO A --内部分户账信息
      LEFT JOIN (SELECT CC.ORG_ID,CC.FIN_PERMIT_NO FROM  RRP_MDL.M_PUM_ORG_INFO CC WHERE CC.DATA_DT = V_P_DATE) B --机构表
        ON B.ORG_ID = (CASE WHEN A.ORG_ID LIKE '896%' THEN '896' ELSE A.ORG_ID END)
      /*LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = A.ORG_ID
       AND B.DATA_DT = V_P_DATE*/
      LEFT JOIN  RRP_MDL.O_ICL_CMM_INTNAL_ACCT T --内部账户
        ON T.ACCT_ID = A.ACC_ID
       AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8)*/---科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.MOD_FLG = 'EAST'
       AND CODE3.DATA_DT = V_P_DATE
     WHERE --MODIFY BY 蔡正伟 增加有效数据限制条件，剔除上月之前销户的数据  20220608 BEGIN
          ( A.CNL_ACC_DT >= SUBSTR(V_P_DATE,1,4)||'0101' OR ABS(A.DR_BAL)+ABS(A.CR_BAL) <> 0 )

        AND A.DATA_SRC <> '总账数据信息'
       AND A.DATA_DT= V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');



  V_STEP := 9;
  V_STEP_DESC := '插入内部分户账数据(科目虚拟部分)';
  V_STARTTIME := SYSDATE;

INSERT INTO RRP_YBT.SDIS_T_4_3(
         RID            --数据主键
      ,  D030001        --  机构ID
      ,  D030002        --  分户账号
      ,  D030003        --  客户ID
      ,  D030003_OTH    --  分户账是否个人
      ,  D030004_ORIG   --  分户账名称_脱敏前
      ,  D030005        --  分户账类型
      ,  D030006        --  计息标识
      ,  D030007        --  计息方式
      ,  D030008        --  科目ID
      ,  D030009        --  币种
      ,  D030010        --  借贷标识
      ,  D030016        --  钞汇类别
      ,  D030017        --  内部账利率
      ,  D030018        --  借方余额
      ,  D030019        --  贷方余额
      ,  D030011        --  开户日期
      ,  D030012        --  销户日期
      ,  D030013        --  账户状态
      ,  D030014        --  备注
       ,ADDRESS               --地区
       ,D030015               --采集日期
       ,DEPT_NO               --条线
       ,ISSUED_NO             --填报机构
       ,RPT_ORG_NO            --报送机构
       ,DATA_DT               --数据日期
  )
  WITH GL_BAL AS (  SELECT /*+PARALLEL(A,4)*/
        --使用长度不超过24位数字与字母组合，前11位与金融许可证号前11位相同，后13位使用内部机构号，不足部分不用补齐
         T3.ORG_ID
        ,T1.SUBJ_ID
        ,SUM(T1.BGN_DR_BAL)  BGN_DR_BAL
        ,SUM(T1.BGN_CR_BAL)  BGN_CR_BAL
        ,SUM(T1.CURR_DR_AMT) CURR_DR_AMT
        ,SUM(T1.CURR_CR_AMT) CURR_CR_AMT
        ,SUM(T1.END_DR_BAL)  END_DR_BAL
        ,SUM(T1.END_CR_BAL)  END_CR_BAL
        ,CASE WHEN T1.CUR = 'CCC' THEN 'BWB' --折合人民币
              ELSE T1.CUR END CUR
        ,MAX(T2.SUBJ_BAL_DIR_CD)                            AS SUBJ_BAL_DIR_CD
    FROM RRP_MDL.M_GL_BAL T1 --总账会计科目余额表
   INNER JOIN RRP_MDL.M_GL_INFO T2 --总账会计科目信息表
      ON T2.SUBJ_ID = T1.SUBJ_ID
     AND T2.DATA_DT = V_P_DATE
   INNER JOIN RRP_MDL.M_PUM_ORG_INFO T3 --改成取EAST的机构表
      ON T3.ORG_ID = T1.ORG_ID
     AND T3.DATA_DT = V_P_DATE
   WHERE T1.CUR NOT IN ('USC','CFC','CUC') --USC外折美元 CFC外折人民币 CUC外合美元
     AND T1.ORG_ID NOT IN ('999999','800S') --去除掉999999 800S机构
     AND LENGTH(T1.STD_PROD_ID) = 1 --只要汇总后的产品数据
     AND LENGTH(T1.SUBJ_ID) = 8
     --AND LENGTH(T1.ORG_ID) = 6
  --   AND (ABS(T1.CURR_DR_AMT)+ABS(T1.CURR_CR_AMT)+ABS(T1.END_DR_BAL)+ABS(T1.END_CR_BAL) <> 0 --有余额、有变动的信息
   --      OR T1.SUBJ_ID LIKE '222104%')----20251212 监管校验上期有，本期必须报，故不应该按余额判断
     AND T1.DATA_DT = V_P_DATE
   GROUP BY T3.ORG_ID,
            T1.SUBJ_ID,
            CASE WHEN T1.CUR = 'CCC' THEN 'BWB' --折合人民币
                 ELSE T1.CUR
             END
    )
SELECT  SYS_GUID()                                            AS  RID                  --数据主键
      , NVL(B.FIN_ORG_NO,'B1194H24405800')                AS  D030001                --  机构ID
      , A.ACC_ID                                              AS  D030002        --  分户账号
      , ''                                                    AS  D030003        --  客户ID
      , 0                                                     AS  D030003_OTH    --  分户账是否个人
      , A.ACC_NM                                              AS  D030004_ORIG        --  分户账名称
      , '03'                                                  AS  D030005        --  分户账类型
      , CASE WHEN A.INT_CALC_FLG IN ('1','Y') THEN '1'
             ELSE '0' END                                     AS  D030006        --  计息标识
      , CASE WHEN A.INT_CALC_FLG NOT IN ('1','Y') THEN '06'
             WHEN A.INT_CALC_MODE IN ('01','02','07') THEN A.INT_CALC_MODE
             WHEN A.INT_CALC_MODE = '03' THEN '04'
             WHEN A.INT_CALC_MODE = '04' THEN '05'
             WHEN A.INT_CALC_MODE = '05' THEN '06'
             WHEN A.INT_CALC_MODE = '06' THEN '03'
             ELSE '00'
         END                                                  AS  D030007        --  计息方式
      , A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8) */                   AS  D030008        --  科目ID
      , A.CUR                                                 AS  D030009        --  币种
      , CASE WHEN SUBSTR(A.SUBJ_ID,1,1) IN ('7','8') THEN '01'  --陈天骏提的需求，把表外科目（7,8开头的)借贷标识设为借。
             WHEN A.DR_CR_FLG = 'D' THEN '01'
             WHEN A.DR_CR_FLG = 'C' THEN '02'
             WHEN A.DR_CR_FLG = 'B' THEN '03'
        END                                                   AS  D030010        --  借贷标识
      , NULL                                                    AS  D030016        --  钞汇类别     --EAST中没有相关口径
      ,-- CASE WHEN A.INT_CALC_FLG NOT IN ('1','Y')         THEN NULL ELSE A.RATE END
      --  DECODE(A.RATE,0,NULL,A.RATE)
        NVL(A.RATE,0)                 AS  D030017        --  内部账利率
      , CASE WHEN T.SUBJ_BAL_DIR_CD IN ('D','R') THEN   NVL(T.END_DR_BAL,0)
              WHEN T.SUBJ_BAL_DIR_CD IN ('C','P') THEN 0
              WHEN T.SUBJ_BAL_DIR_CD = 'B' AND   NVL(T.END_DR_BAL,0) -   NVL(T.END_CR_BAL,0) >0
              THEN   NVL(T.END_DR_BAL,0) -   NVL(T.END_CR_BAL,0)
              ELSE 0
          END                                AS  D030018        --  借方余额
      , CASE WHEN T.SUBJ_BAL_DIR_CD IN ('D','R') THEN 0
              WHEN T.SUBJ_BAL_DIR_CD IN ('C','P') THEN NVL(T.END_CR_BAL,0)
              WHEN T.SUBJ_BAL_DIR_CD = 'B' AND   NVL(T.END_CR_BAL,0) -   NVL(T.END_DR_BAL,0) >0
              THEN   NVL(T.END_CR_BAL,0) -   NVL(T.END_DR_BAL,0)
              ELSE 0
          END                                                      AS  D030019        --  贷方余额
      , TO_CHAR(TO_DATE(NVL(A.OPEN_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030011        --  开户日期
      , TO_CHAR(TO_DATE(NVL(A.CNL_ACC_DT, '99991231'),'YYYYMMDD'),'YYYY-MM-DD')     AS  D030012        --  销户日期
       , CASE   WHEN A.ACC_STAT = '01' THEN '01'
                WHEN A.ACC_STAT = '02' THEN '03'
                WHEN A.ACC_STAT = '03' THEN '02'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '04'
                WHEN A.ACC_STAT = '11' THEN '05'
                ELSE '06' --如果未其他，需要在备注中具体描述
            END                                               AS  D030013        --  账户状态
      ,CASE WHEN A.ACC_STAT IN ('01','02','03','04','05','06','07','11')  THEN ''
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                               AS  D030014        --  备注
      , ''                                                    AS  ADDRESS              --地区
      , V_P10_DATE                                            AS  D030015              --采集日期
      , 'JHCWB'           AS  DEPT_NO              --条线  800918计划财务部/800902营运管理部
      ,'000000'                                                     AS  ISSUED_NO            --填报机构
      ,'000000'                                                     AS  RPT_ORG_NO           --报送机构
      ,V_P_DATE                                               AS  DATA_DT              --数据日期
     FROM RRP_MDL.M_DEP_INTL_ACC_INFO_YBT A --内部分户账信息         --20251223 增加新表，将BWB换成原币
     INNER JOIN RRP_MDL.M_PUM_ORG_INFO_YBT B --机构表
      ON B.ORG_ID = (CASE WHEN A.ORG_ID LIKE '896%' THEN '896' ELSE A.ORG_ID END)
    -- AND (LENGTH(B.ORG_ID) = 6)
     AND B.DATA_DT = V_P_DATE
     INNER JOIN  GL_BAL T --总账会计科目余额表
       ON T.SUBJ_ID = A.SUBJ_ID
      AND T.ORG_ID = A.ORG_ID
      AND T.CUR = A.CUR
     /* AND (ABS(BGN_DR_BAL - BGN_CR_BAL) +ABS(CURR_DR_AMT) + ABS(CURR_CR_AMT) + ABS(END_DR_BAL-END_CR_BAL) > 0
          OR T.SUBJ_ID LIKE '222104%')*/

      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = A.SUBJ_ID/*SUBSTR(A.SUBJ_ID,1,8)*/---科目报送到三级
       AND C.DATA_DT = V_P_DATE

      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.MOD_FLG = 'EAST'
       AND CODE3.DATA_DT = V_P_DATE
     WHERE --MODIFY BY 蔡正伟 增加有效数据限制条件，剔除上月之前销户的数据  20220608 BEGIN
         ( A.CNL_ACC_DT >= SUBSTR(V_P_DATE,1,4)||'0101' OR ABS(A.DR_BAL)+ABS(A.CR_BAL) <> 0 )--本年+有余额
/*         AND EXISTS(SELECT 1 FROM RRP_MDL.M_PUM_ORG_INFO BB
                            WHERE  BB.DATA_DT = V_P_DATE
        --AND BB.ORG_ID = (CASE WHEN LENGTH(A.ACC_ID) = 17 THEN SUBSTR(A.ACC_ID,1,6) ELSE SUBSTR(A.ACC_ID,1,3) END))
                              AND BB.ORG_ID = B.ORG_ID--SUBSTR(A.ACC_ID,1,6)

        --AND (LENGTH(A.ACC_ID) = 17 AND A.ACC_ID NOT LIKE '896%' ) OR  (LENGTH(A.ACC_ID) = 14 AND BB.ORG_ID = '896' )
                                )*/
        AND LENGTH(A.ACC_ID) = 17 ----目的是为了剔除896本级，6位机构+8位科目+3位币别
        AND A.ORG_ID <> '000000' AND (LENGTH(B.ORG_ID) = 6 OR B.ORG_ID = '896')
        AND A.DATA_SRC = '总账数据信息' AND C.SUBJ_LVL = 3
        AND A.DATA_DT= V_P_DATE

        ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');



  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '增加表分析及跑批过程完成表';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE,V_TAB_NAME,V_PART_NAME,O_ERRCODE); --表分析
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
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

END ETL_SDIS_T_4_3;
/

