CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_BILL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_BILL_INFO
  *  功能描述：监管集市商业票据直贴、转贴、开票等全部票据业务的票面信息
  *  创建日期：20220609
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_BILL_DISCNT_INFO   --票据贴现信息
  *            ICL.CMM_CORP_LOAN_DUBIL_INFO  --对公贷款账户信息
  *            ICL.CMM_BILL_CENTER_INFO  --票据中心信息
  *            ICL.CMM_INTNAL_ORG_INFO  --内部机构信息表
  *
  *  目标表：  M_BILL_INFO  --票据票面信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220824  HULJ     新增字段票据介质代码。
  *             2    20220913  MW       修改取值逻辑 原始贴现日期
  *             3    20221114  HULJ     增加数据重复校验
                4    20240611  TZJ      取O_ICL_CMM_BILL_DISCNT_INFO数据时加 业务编号BUS_ID 使数据固定
  *             5    20251024  LIP      增加结清标志字段
  *             6    20251028  LIP      增加DISCNT_BANK_NAME贴现行名称字段
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);                        --处理步骤描述
  V_P_DATE    VARCHAR2(8);                          --跑批数据日期
  V_SQLMSG    VARCHAR2(300);                        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                        --分区名
  V_STARTTIME DATE;                                 --处理开始时间
  V_ENDTIME   DATE;                                 --处理结束时间
  V_STEP      INTEGER := 0;                         --处理步骤
  V_SQLCOUNT  INTEGER := 0;                         --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_BILL_INFO';   --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'M_BILL_INFO';       --表名
  V_SYSTEM    VARCHAR2(30)  := '监管报送';          --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_BILL_INFO T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入票据票面信息信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_BILL_INFO
    (DATA_DT                         --数据日期
    ,LGL_REP_ID                      --法人编号
    ,BILL_NO                         --票据号码
    ,ORG_ID                          --机构编号
    ,DRAWER_NM                       --出票人名称
    ,DRAWER_ACC                      --出票人账号
    ,DRAWER_OPEN_BANK_NM             --出票人开户行名称
    ,ACPTR_NM                        --承兑人名称
    ,ACPTR_ACC                       --承兑人账号
    ,ACPTR_OPEN_BANK_PBC_NO          --承兑人开户行
    ,ACPTR_OPEN_BANK_NM              --承兑人开户行名称
    ,BILL_TYP                        --票据类型
    ,CUR                             --币种
    ,BILL_PAR_AMT                    --票面金额
    ,BILL_ISU_DT                     --出票日期
    ,BILL_EXP_DT                     --票据到期日期
    ,ACPT_DT                         --承兑日期
    ,PAYEE_NM                        --收款人名称
    ,PAYEE_ACC                       --收款人账号
    ,PAYEE_OPEN_BANK_PBC_NO          --收款人开户行行号
    ,ORIG_DISC_PSN_NM                --原始贴现人名称
    ,ORIG_DISC_DT                    --原始贴现日期
    ,BILL_TRF_FLG                    --票据转让标识
    ,TRA_CONT_ID                     --交易合同号
    ,BILL_STAT                       --票据状态
    ,DEPT_LINE                       --部门条线
    ,DATA_SRC                        --数据来源
    ,BILL_NUM                        --票据号
    ,BILL_SUB_INTRV_ID               --票据子区间号
    ,BILL_MED_CD                     --票据介质代码
    ,DISCNT_WAY                      --贴现方式 20220924 XUXIAOBIN ADD
    ,DRAWER_CRDL_TYP                 --出票人证件类型20220930 XUXIAOBIN ADD
    ,DRAWER_PRIM_CRDL_NO             --出票人主证件号码20220930 XUXIAOBIN ADD
    ,ACPTR_CRDL_TYP                  --承兑人证件类型20220930 XUXIAOBIN ADD
    ,ACPTR_PRIM_CRDL_NO              --承兑人主证件号码20220930 XUXIAOBIN ADD
    ,HXB_ACPT_FLG                    --我行承兑标志
    ,DRAWER_CUST_ID                  --出票人客户号
    ,ORG_CN_FNAME                    --顶级机构全称
    ,CASH_DT                         --兑付日期
    ,BILL_SRC_CD                     --票据来源代码
    ,ORG_CRDL_NO                     --顶级机构社会统一信用证
    ,PAYOFF_FLG                      --结清标志 --ADD BY LIP 20251024
    ,DISCNT_BANK_NAME                --贴现行名称 --ADD BY LIP 20251028
    )
    WITH PTY_CPES_MEM AS (
  SELECT  TRIM(TTA.MEM_ORG_CD)     AS MEM_ORG_CD    --会员机构代码
         ,TRIM(TTA.MEM_ORG_ID)     AS MEM_ORG_ID    --会员机构编号
         ,TRIM(TTA.ORG_CN_FNAME)   AS ORG_CN_FNAME  --机构中文全称
         ,TRIM(TTA.ORG_CN_ABBR)    AS ORG_CN_ABBR   --机构中文简称
         ,TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) AS SYS_PRTCPTR_BIGAMT_BANK_NO   --系统参与者大额行号
         ,TRIM(ORG_LEV_CD)         AS ORG_LEV_CD    --机构级别代码
         ,CASE WHEN NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),'0') <> '0' 
               THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME)
               ELSE TRIM(TTA.ORG_CN_FNAME)
          END                      AS SYS_PRTCPTR_BIGAMT_BANK_NAME   --系统参与者大额行名
         ,ROW_NUMBER() OVER(PARTITION BY CASE WHEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO) IS NOT NULL
                                              THEN TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NO)
                                              ELSE TRIM(TTA.ORG_CN_ABBR) END
                            ORDER BY TRIM(SYS_PRTCPTR_BIGAMT_BANK_NAME) NULLS LAST) AS RN
    FROM RRP_MDL.O_IML_PTY_CPES_MEM TTA --票交所会员 只有一天数据
   WHERE TTA.ID_MARK <> 'D')
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                AS DATA_DT                         --数据日期
        ,A.LP_ID                                      AS LGL_REP_ID                      --法人编号
        ,A.BILL_ID                                    AS BILL_NO                         --票据号码
        ,NVL(A.BELONG_ORG_ID,A.DRAWER_OPEN_BANK_NO)   AS ORG_ID                          --机构编号
        ,A.DRAWER_NAME                                AS DRAWER_NM                       --出票人名称
        ,A.DRAWER_ACCT_NUM                            AS DRAWER_ACC                      --出票人账号
        ,A.DRAWER_OPEN_BANK_NAME                      AS DRAWER_OPEN_BANK_NM             --出票人开户行名称
        ,A.ACCPTOR_NAME                               AS ACPTR_NM                        --承兑人名称
        ,A.ACCPTOR_ACCT_NUM                           AS ACPTR_ACC                       --承兑人账号
        ,A.ACCPTOR_OPEN_BANK_NO                       AS ACPTR_OPEN_BANK_PBC_NO          --承兑人开户行
        ,A.ACCPTOR_OPEN_BANK_NAME                     AS ACPTR_OPEN_BANK_NM              --承兑人开户行名称
        ,CASE WHEN A.BILL_TYPE_CD = 'AC01' 
               AND NVL(TRIM(A.BILL_SUB_INTRV_ID),'-') = '-'
               AND A.ACCPTOR_NAME LIKE '%财务%' 
              THEN '03' --传统票据：承兑人名称中有财务公司
              WHEN A.BILL_TYPE_CD = 'AC01' 
               AND NVL(TRIM(A.BILL_SUB_INTRV_ID),'-') = '-'
               AND A.ACCPTOR_OPEN_BANK_NO LIKE '907%' 
              THEN '03' --传统票据：承兑人行号以“907”开头
              WHEN A.BILL_TYPE_CD = 'AC01' 
               AND NVL(TRIM(A.BILL_SUB_INTRV_ID),'-') <> '-'
               AND TA.ORG_LEV_CD = '301' 
              THEN '03'
              ELSE M.TAR_VALUE_CODE
          END                                         AS BILL_TYP                        --票据类型  --MOD BY LIP 20230207 增加财务公司承兑汇票类型
        --,M.TAR_VALUE_CODE                             AS BILL_TYP                        --票据类型
        ,A.CURR_CD                                    AS CUR                             --币种
        ,A.FAC_VAL_AMT                                AS BILL_PAR_AMT                    --票面金额
        ,TO_CHAR(A.DRAW_DT,'YYYYMMDD')                AS BILL_ISU_DT                     --出票日期
        ,TO_CHAR(A.EXP_DT,'YYYYMMDD')                 AS BILL_EXP_DT                     --票据到期日期
        ,CASE WHEN TO_CHAR(A.ACPT_DT,'YYYYMMDD') IN ('00010101','29991231') THEN NULL
              ELSE TO_CHAR(A.ACPT_DT,'YYYYMMDD')
          END                                         AS ACPT_DT                         --承兑日期
        ,A.RECVER_NAME                                AS PAYEE_NM                        --收款人名称
        ,A.RECVER_ACCT_NUM                            AS PAYEE_ACC                       --收款人账号
        ,A.RECVER_OPEN_BANK_NAME                      AS PAYEE_OPEN_BANK_PBC_NO          --收款人开户行行号
        ,CASE WHEN C.BILL_ID IS NOT NULL THEN NVL(C.CUST_NAME,C.DSCNT_PROPS_NAME)
              WHEN D.BILL_ID IS NOT NULL AND D.DISCNT_PS_NAME IS NOT NULL THEN D.DISCNT_PS_NAME
              WHEN D.BILL_ID IS NOT NULL THEN D.BF_CNTPTY_NAME
          END                                         AS ORIG_DISC_PSN_NM                --原始贴现人名称
        ,CASE WHEN C.BILL_ID IS NOT NULL THEN TO_CHAR(C.VALUE_DT,'YYYYMMDD')
              WHEN D.BILL_ID IS NOT NULL THEN TO_CHAR(D.DISCNT_DT,'YYYYMMDD')
          END                                         AS ORIG_DISC_DT                    --原始贴现日期 先取业务日期，贴现日期等数仓改造
        ,NULL                                         AS BILL_TRF_FLG                    --票据转让标识
        ,NULL                                         AS TRA_CONT_ID                     --交易合同号
        /*,COALESCE(F.TAR_VALUE_CODE,G.TAR_VALUE_CODE,'99') AS BILL_STAT                   --票据状态*/
        ,A.BILL_STATUS_CD                             AS BILL_STAT                       --票据状态
        ,NULL                                         AS DEPT_LINE                       --部门条线 /*公司银行总部*/
        ,'票据中心信息'                               AS DATA_SRC                        --数据来源
        ,A.BILL_NUM                                   AS BILL_NUM                        --票据号
        ,A.BILL_SUB_INTRV_ID                          AS BILL_SUB_INTRV_ID               --票据子区间号
        ,A.BILL_MED_CD                                AS BILL_MED_CD                     --票据介质代码
        ,CASE WHEN E.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002') 
              THEN '01'
              WHEN E.STD_PROD_ID IN ('204010100001','204010100002') 
              THEN '02'
          END                                         AS DISCNT_WAY                      --贴现方式 20220924 XUXIAOBIN ADD
        ,CASE WHEN LENGTH(TRIM(A.DRAWER_ORGNZ_CD)) = 18 THEN '2313'
              WHEN LENGTH(TRIM(A.DRAWER_ORGNZ_CD)) = 10 THEN '2020'
              WHEN SUBSTR(TRIM(A.DRAWER_SOCI_CRDT_CD),1,8) = '00000000' THEN '2020'
              WHEN SUBSTR(TRIM(A.DRAWER_SOCI_CRDT_CD),1,8) <> '00000000' AND LENGTH(A.DRAWER_SOCI_CRDT_CD) = 18 
              THEN '2313'
          END                                         AS DRAWER_CRDL_TYP                 --出票人证件类型20220930 XUXIAOBIN ADD
        ,CASE WHEN TRIM(A.DRAWER_ORGNZ_CD) IS NOT NULL 
              THEN REPLACE(TRIM(A.DRAWER_ORGNZ_CD),'-','')
              WHEN SUBSTR(TRIM(A.DRAWER_SOCI_CRDT_CD),1,8) = '00000000' 
              THEN SUBSTR(TRIM(A.DRAWER_SOCI_CRDT_CD),9,9)
              ELSE TRIM(A.DRAWER_SOCI_CRDT_CD)
          END                                         AS DRAWER_PRIM_CRDL_NO             --出票人主证件号码20220930 XUXIAOBIN ADD
        ,CASE WHEN A.BILL_TYPE_CD = 'AC01' AND SUBSTR(NVL(TRIM(TOP.UNIFY_SOCI_CRDT_CD),TRIM(A.ACCPTOR_SOCI_CRDT_CD)),1,8) = '00000000' 
              THEN '2020'
              WHEN A.BILL_TYPE_CD = 'AC01' AND LENGTH(NVL(TRIM(TOP.UNIFY_SOCI_CRDT_CD),TRIM(A.ACCPTOR_SOCI_CRDT_CD))) = 18 
              THEN '2313'
              WHEN A.BILL_TYPE_CD = 'AC02' AND SUBSTR(TRIM(A.ACCPTOR_SOCI_CRDT_CD),1,8) = '00000000' 
              THEN '2020'
              WHEN A.BILL_TYPE_CD = 'AC02' AND LENGTH(TRIM(A.ACCPTOR_SOCI_CRDT_CD)) = 18 
              THEN '2313'
              WHEN A.BILL_TYPE_CD = 'AC02' AND TRIM(A.ACCPTOR_SOCI_CRDT_CD) IS NULL AND TRIM(A.DRAWER_SOCI_CRDT_CD) IS NOT NULL 
              THEN '2020'
          END                                         AS ACPTR_CRDL_TYP                  --承兑人证件类型20220930 XUXIAOBIN ADD
        ,CASE WHEN A.BILL_TYPE_CD = 'AC01' 
               AND SUBSTR(NVL(TRIM(TOP.UNIFY_SOCI_CRDT_CD),TRIM(A.ACCPTOR_SOCI_CRDT_CD)),1,8) = '00000000'
              THEN SUBSTR(NVL(TRIM(TOP.UNIFY_SOCI_CRDT_CD),TRIM(A.ACCPTOR_SOCI_CRDT_CD)),9,9)
              WHEN A.BILL_TYPE_CD = 'AC01' 
              THEN NVL(TRIM(TOP.UNIFY_SOCI_CRDT_CD),A.ACCPTOR_SOCI_CRDT_CD)
              WHEN A.BILL_TYPE_CD = 'AC02' 
               AND SUBSTR(TRIM(A.ACCPTOR_SOCI_CRDT_CD),1,8) = '00000000' 
              THEN SUBSTR(TRIM(A.ACCPTOR_SOCI_CRDT_CD),9,9)
              WHEN A.BILL_TYPE_CD = 'AC02' 
              THEN NVL(TRIM(A.ACCPTOR_SOCI_CRDT_CD),SUBSTR(TRIM(A.DRAWER_SOCI_CRDT_CD),9,9))
          END                                         AS ACPTR_PRIM_CRDL_NO              --承兑人主证件号码20220930 XUXIAOBIN ADD
        ,A.HXB_ACPT_FLG                               AS HXB_ACPT_FLG                    --我行承兑标志
        ,A.DRAWER_CUST_ID                             AS DRAWER_CUST_ID                  --出票人客户号
        ,TOP.ORG_CN_FNAME                             AS ORG_CN_FNAME                    --顶级机构名称
        ,TO_CHAR(A.CASH_DT,'YYYYMMDD')                AS CASH_DT                         --兑付日期
        ,A.BILL_SRC_CD                                AS BILL_SRC_CD                     --票据来源代码
        ,TOP.UNIFY_SOCI_CRDT_CD                       AS ORG_CRDL_NO                     --顶级机构社会统一信用证
        ,A.PAYOFF_FLG                                 AS PAYOFF_FLG                      --结清标志 --ADD BY LIP 20251024
        ,TRIM(A.DISCNT_BANK_NAME)                     AS DISCNT_BANK_NAME                --贴现行名称 --ADD BY LIP 20251028
    FROM RRP_MDL.O_ICL_CMM_BILL_CENTER_INFO A --票据中心信息
    LEFT JOIN (SELECT AA.*,ROW_NUMBER() OVER(PARTITION BY BILL_ID ORDER BY DUBIL_ID DESC) AS NUM
                 FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO AA
                WHERE AA.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002','204010100001','204010100002')
                  AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) E --对公贷款借据信息
      --ON E.BILL_NUM = A.BILL_NUM --20220930 XUXIAOBIN MODIFY
      ON E.BILL_ID = A.BILL_ID --20220930 XUXIAOBIN MODIFY
     AND E.NUM = 1
    LEFT JOIN (SELECT A.MEM_ORG_CD AS ACPT_ORG_ID,B.*,
                      ROW_NUMBER() OVER(PARTITION BY A.MEM_ORG_CD ORDER BY A.UPDATE_DT DESC) RN
                 FROM RRP_MDL.O_IML_PTY_CPES_MEM A
                INNER JOIN RRP_MDL.O_IML_PTY_CPES_MEM B
                   ON B.MEM_CD = A.MEM_CD 
                  AND B.LP_LEV_CD = 'CC00' 
                  AND B.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
                  AND B.ID_MARK <> 'D'
                WHERE A.ID_MARK <> 'D' 
                  AND A.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')) TOP
      ON TOP.ACPT_ORG_ID = A.ACPT_ORG_ID
     AND TOP.RN = 1
    LEFT JOIN (SELECT T2.*,ROW_NUMBER() OVER(PARTITION BY T2.BILL_NUM ORDER BY TO_CHAR(T2.VALUE_DT,'YYYYMMDD'),BUS_ID DESC) RN --加业务编号BUS_ID使数据固定，20240611 by tzj
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO T2
                WHERE T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) C --票据贴现信息
      ON C.BILL_NUM = A.BILL_NUM
     AND C.RN = 1
    LEFT JOIN (SELECT T1.*,ROW_NUMBER() OVER(PARTITION BY T1.BILL_ID,BILL_SUB_INTRV_ID ORDER BY BUS_ID) RN --20230116 修改贴现人取数口径 LHQ
                 FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T1 --目前数仓反馈 贴现日期 还没有改造出来先不取
                WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) D
      ON D.BILL_ID = A.BILL_ID
     AND NVL(TRIM(D.BILL_SUB_INTRV_ID),'-') = NVL(TRIM(A.BILL_SUB_INTRV_ID),'-')
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND D.RN = 1
    LEFT JOIN PTY_CPES_MEM TA --票交所会员 --ADD BY LIP 20230207 判断是否财务公司承兑汇票
      ON TA.MEM_ORG_CD = A.ACPT_ORG_ID
     AND TA.RN = 1
    LEFT JOIN RRP_MDL.CODE_MAP F
      ON F.SRC_VALUE_CODE = A.BILL_STATUS_CD
     AND F.SRC_CLASS_CODE = 'CD1487'
     AND F.TAR_CLASS_CODE = 'D0125'
     AND F.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP G
      ON G.SRC_VALUE_CODE = A.BILL_STATUS_CD
     AND G.SRC_CLASS_CODE = 'CD1489'
     AND G.TAR_CLASS_CODE = 'D0125'
     AND G.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.CODE_MAP M
      ON M.SRC_VALUE_CODE = A.BILL_TYPE_CD
     AND M.SRC_CLASS_CODE = 'CD1384'
     AND M.TAR_CLASS_CODE = 'D0039'
     AND M.MOD_FLG = 'MDM'
   WHERE /*A.BILL_STATUS_CD NOT IN ('99','S29','53','99','NN','S00','000002') --过滤无效的票据
     AND*/ A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
  SELECT DATA_DT,BILL_NO,COUNT(1)
    FROM RRP_MDL.M_BILL_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,BILL_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_BILL_INFO;
/

