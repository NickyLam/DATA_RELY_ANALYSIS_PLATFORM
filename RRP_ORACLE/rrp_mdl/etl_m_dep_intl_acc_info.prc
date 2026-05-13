CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_DEP_INTL_ACC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_DEP_INTL_ACC_INFO
  *  功能描述：监管集市银行业银行机构开设的所有内部账户的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ACCT       --内部账户
  *            ICL.CMM_INTNAL_ORG_INFO   --内部机构信息表
  *            ICL.CMM_SUBJ_INFO         --科目信息
  *            ICL.CMM_GL_BAL            --总账余额
  *  目标表：  M_DEP_INTL_ACC_INFO  --内部分户账信息
  *
  *  配置表：  IML.REF_PUB_CD       --公共代码表
  *
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220921  MW       修改EAST是否报送字段口径
  *             2    20221108  HULJ     增加数据重复校验
  *             3    20230527  LIP      核算中台的数据中去除800S机构的数据
  *             4    20241101  LIP      过滤旅通卡母户,虚户从分户表取
  *             5    20241203  LIP      加工主账户账号逻辑
  *             6    20250101  HYF      增加总账套账期间过滤
  *             7    20251014  LIP      核算中台部分数据只采集汇总后的产品数据，避免数据重复计算
  *             8    20260309  LIP      核心数据部分增加利率、计息标志、计息方式的取数
  *             10   20260317  YJY      新增当期应计利息字段
  ************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_DATA_DT   VARCHAR2(10);                    --报送日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLCOUNT2 INTEGER := 0;               --更新或删除影响的记录数
  V_PART_NAME VARCHAR2(100);              --分区名
  V_Y_END_DT       DATE;
  V_TAB_NAME  VARCHAR2(100) := 'M_DEP_INTL_ACC_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_DEP_INTL_ACC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_Y_END_DT  := TO_DATE(SUBSTR(I_P_DATE,1,4)||'-12-31', 'YYYY-MM-DD'); --年末
  V_DATA_DT   := TO_CHAR(TO_DATE(I_P_DATE,'YYYY-MM-DD'), 'YYYY-MM-DD');
  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_DEP_INTL_ACC_INFO T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  ETL_PARTITION_ADD(V_P_DATE,'M_DEP_INTL_ACC_INFO_YBT', '1', O_ERRCODE); --ADD BY ZHAOSJ 20251223
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME); --分区表的重跑处理
  EXECUTE IMMEDIATE ('ALTER TABLE M_DEP_INTL_ACC_INFO_YBT TRUNCATE PARTITION '||V_PART_NAME);--ADD BY ZHAOSJ 20251223一表通内部分户信息（总账数据部分）

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账信息-核心数据信息';
  V_STARTTIME := SYSDATE;
  /*****************核心系统-内部户******************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_INTL_ACC_INFO NOLOGGING
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ACC_ID           --账户编号
    ,ORG_ID           --机构编号
    ,SUBJ_ID          --科目编号
    ,ACC_NM           --账户名称
    ,DR_CR_FLG        --借贷标志
    ,CUR              --币种
    ,STATS_SUBJ_ID    --统计科目编号
    ,DR_BAL           --借方余额
    ,CR_BAL           --贷方余额
    ,INT_CALC_FLG     --计息标志
    ,INT_CALC_MODE    --计息方式
    ,RATE             --利率
    ,OPEN_ACC_DT      --开户日期
    ,CNL_ACC_DT       --销户日期
    ,ACC_STAT         --账户状态
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    ,SUB_ACC_ID       --子账户编号
    ,SEPARATE_ACCT_FLG--是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD   --存款账户状态原码值
    ,ACC_BAL          --账户余额
    ,MAIN_ACCT_ID     --主账户账号 --ADD BY LIP 20241203
    ,CURRT_ACRU_INT   --当期应计利息  --ADD BY YJY 20260317
    )
  SELECT  TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                 AS DATA_DT             --数据日期
         ,A.LP_ID                                                       AS LGL_REP_ID          --法人编号
         ,A.ACCT_ID                                                     AS ACC_ID              --账户编号  modify by xieyugeng 20221020 因核心内部账户进行拆分，继续取MAIN_ACCT_ID会导致账户号重复，经科技区志豪确认区ACCT_ID"
         ,A.BELONG_ORG_ID                                               AS ORG_ID              --机构编号
         ,A.SUBJ_ID                                                     AS SUBJ_ID             --科目编号
         ,A.ACCT_NAME                                                   AS ACC_NM              --账户名称
         ,A.BAL_DIR_CD                                                  AS DR_CR_FLG           --借贷标志
         ,A.CURR_CD                                                     AS CUR                 --币种
         ,NULL                                                          AS STATS_SUBJ_ID       --统计科目编号
         ,CASE WHEN A.BAL_DIR_CD = 'D'
               THEN ABS(NVL(ACCT_BAL, 0.00))
               ELSE 0.00
           END                                                          AS DR_BAL              --借方余额
         ,CASE WHEN A.BAL_DIR_CD = 'C'
               THEN ABS(NVL(ACCT_BAL, 0.00))
               ELSE 0.00
           END                                                          AS CR_BAL              --贷方余额
         /*,'N'                                                           AS INT_CALC_FLG        --计息标志
         ,'05'                                                          AS INT_CALC_MODE       --计息方式 --不计计息
         ,0.0000                                                        AS RATE                --利率*/
         --MOD BY LIP 20260309 根据业务反馈，内部户部分计息
         ,CASE WHEN NVL(T1.EXEC_INT_RAT,0) = 0 THEN '0' --不计息
               ELSE A.INT_ACCR_FLG
           END                                                          AS INT_CALC_FLG        --计息标志
         ,CASE WHEN A.INT_ACCR_FLG = '0' THEN '05' --不计计息
               WHEN NVL(T1.EXEC_INT_RAT,0) = 0 THEN '05' --不计计息
               WHEN T1.INT_SET_FREQ_CD IN ('M1','1M','30D','D30') THEN '01' --按月结息
               WHEN T1.INT_SET_FREQ_CD IN ('M3','3M','90D','D90') THEN '02' --按季结息
               WHEN T1.INT_SET_FREQ_CD IN ('M6','6M','180D','D180') THEN '06' --按半年结息
               WHEN T1.INT_SET_FREQ_CD IN ('Y1','M12','1Y','Y1') THEN '03' --按年结息
               ELSE '99' --其他
           END                                                          AS INT_CALC_MODE       --计息方式 --D0061
         ,NVL(T1.EXEC_INT_RAT,0)                                        AS RATE                --利率
         ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                           AS OPEN_ACC_DT         --开户日期
         ,CASE WHEN A.CLOS_ACCT_DT = TO_DATE('29991231','YYYYMMDD') THEN '99991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD')
           END                                                          AS CNL_ACC_DT          --销户日期
         ,TTA.TAR_VALUE_CODE                                            AS ACC_STAT            --账户状态
         ,'800918'                                                      AS DEPT_LINE           --部门条线 /*计划财务部*/
         ,'核心数据信息'                                                AS DATA_SRC            --数据来源
         ,A.SUB_ACCT_NUM                                                AS SUB_ACC_ID          --子账户编号
         /*,CASE WHEN F.MAIN_ACCT_ID IS NOT NULL THEN '0' ELSE '1' END    AS SEPARATE_ACCT_FLG   --是否单列账标志1报送0不报送*/
         ,'1'                                                           AS SEPARATE_ACCT_FLG   --是否单列账标志1报送0不报送
         ,A.ACCT_STATUS_CD                                              AS ACCT_STATUS_CD      --存款账户状态原码值
         ,A.ACCT_BAL                                                    AS ACC_BAL             --账户余额
         ,A.MAIN_ACCT_ID                                                AS MAIN_ACCT_ID        --主账户账号 --ADD BY LIP 20241203
         ,A.CURRT_ACRU_INT                                              AS CURRT_ACRU_INT      --当期应计利息  --ADD BY YJY 20260317
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
      ON E.CD_VAL = A.ACCT_STATUS_CD
     AND E.CD_ID = 'CD1817'
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
    LEFT JOIN RRP_MDL.O_IML_AGT_DEP_ACCT_INT_DTL T1 --存款账户利息明细 --ADD BY LIP 20260309
      ON T1.ACCT_ID = A.ACCT_ID
     AND T1.INT_CLS_CD = 'INT'
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.OPEN_ACCT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') --MODIFY BY TANGAN AT 20221105 剔除开户日期大于跑批日期的数据
     AND SUBSTR(A.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
     AND NVL(A.TRAVEL_CARD_ACCT_FLG,'0') = '0' --MOD BY LIP 20241101 过滤旅通卡母户,虚户从分户表取
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20241101 加工旅通卡虚户数据
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账信息-旅通卡虚户';
  V_STARTTIME := SYSDATE;
  /*****************核心系统-内部户******************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_INTL_ACC_INFO NOLOGGING
    (DATA_DT          --数据日期
    ,LGL_REP_ID       --法人编号
    ,ACC_ID           --账户编号
    ,ORG_ID           --机构编号
    ,SUBJ_ID          --科目编号
    ,ACC_NM           --账户名称
    ,DR_CR_FLG        --借贷标志
    ,CUR              --币种
    ,STATS_SUBJ_ID    --统计科目编号
    ,DR_BAL           --借方余额
    ,CR_BAL           --贷方余额
    ,INT_CALC_FLG     --计息标志
    ,INT_CALC_MODE    --计息方式
    ,RATE             --利率
    ,OPEN_ACC_DT      --开户日期
    ,CNL_ACC_DT       --销户日期
    ,ACC_STAT         --账户状态
    ,DEPT_LINE        --部门条线
    ,DATA_SRC         --数据来源
    ,SUB_ACC_ID       --子账户编号
    ,SEPARATE_ACCT_FLG--是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD   --存款账户状态原码值
    ,ACC_BAL          --账户余额
    ,MAIN_ACCT_ID     --主账户账号 --ADD BY LIP 20241203
    ,CURRT_ACRU_INT   --当期应计利息  --ADD BY YJY 20260317
    )
  SELECT TO_CHAR(A.ETL_DT, 'YYYYMMDD')                                 AS DATA_DT             --数据日期
        ,A.LP_ID                                                       AS LGL_REP_ID          --法人编号
        ,A.ACCT_ID                                                     AS ACC_ID              --账户编号  modify by xieyugeng 20221020 因核心内部账户进行拆分，继续取MAIN_ACCT_ID会导致账户号重复，经科技区志豪确认区ACCT_ID"
        ,A.BELONG_ORG_ID                                               AS ORG_ID              --机构编号
        ,A.SUBJ_ID                                                     AS SUBJ_ID             --科目编号
        ,A.ACCT_NAME                                                   AS ACC_NM              --账户名称
        ,'C'                                                           AS DR_CR_FLG           --借贷标志
        ,A.CURR_CD                                                     AS CUR                 --币种
        ,NULL                                                          AS STATS_SUBJ_ID       --统计科目编号
        ,0.00                                                          AS DR_BAL              --借方余额
        ,ABS(NVL(A.CURRT_BAL,0.00))                                    AS CR_BAL              --贷方余额
        /*,A.INT_ACCR_FLG                                                AS INT_CALC_FLG        --计息标志
        ,A.INT_ACCR_WAY_CD                                             AS INT_CALC_MODE       --计息方式 --不计计息
        ,A.EXEC_INT_RAT                                                AS RATE                --利率*/
        --MOD BY LIP 20241203 根据业务反馈，旅通卡不计息
        ,'N'                                                           AS INT_CALC_FLG        --计息标志
        ,'05'                                                          AS INT_CALC_MODE       --计息方式 --不计计息
        ,0.0000                                                        AS RATE                --利率
        ,TO_CHAR(A.OPEN_ACCT_DT, 'YYYYMMDD')                           AS OPEN_ACC_DT         --开户日期
        ,CASE WHEN A.CLOS_ACCT_DT = TO_DATE('29991231','YYYYMMDD') THEN '99991231'
              ELSE TO_CHAR(A.CLOS_ACCT_DT, 'YYYYMMDD')
          END                                                          AS CNL_ACC_DT          --销户日期
        ,TTA.TAR_VALUE_CODE                                            AS ACC_STAT            --账户状态
        ,'800918'                                                      AS DEPT_LINE           --部门条线 /*计划财务部*/
        ,'旅通卡虚户'                                                  AS DATA_SRC            --数据来源
        ,A.CUST_ACCT_SUB_ACCT_NUM                                      AS SUB_ACC_ID          --子账户编号
        ,'1'                                                           AS SEPARATE_ACCT_FLG   --是否单列账标志1报送0不报送
        ,A.DEP_ACCT_STATUS_CD                                          AS ACCT_STATUS_CD      --存款账户状态原码值
        ,A.CURRT_BAL                                                   AS ACC_BAL             --账户余额
        ,A.CUST_ACCT_ID                                                AS MAIN_ACCT_ID        --主账户账号 --ADD BY LIP 20241203
        ,A.CURRT_ACRU_INT                                              AS CURRT_ACRU_INT      --当期应计利息  --ADD BY YJY 20260317
   FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
   INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_ATTACH_INFO B --存款账户附加信息
      ON B.ACCT_ID = A.ACCT_ID
     AND B.TRAVEL_CARD_ACCT_FLG = '1' --旅通卡虚户
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息表
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD E
      ON E.CD_VAL = A.DEP_ACCT_STATUS_CD
     AND E.CD_ID = 'CD1817'
    LEFT JOIN RRP_MDL.CODE_MAP TTA --账户状态转码
      ON TTA.SRC_VALUE_CODE = A.DEP_ACCT_STATUS_CD
     AND TTA.SRC_CLASS_CODE = 'CD2554'
     AND TTA.TAR_CLASS_CODE = 'Z0018'
     AND TTA.MOD_FLG = 'MDM'
   WHERE A.OPEN_ACCT_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账信息-总账数据信息';
  V_STARTTIME := SYSDATE;
  /*************************总账*************************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_INTL_ACC_INFO NOLOGGING
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ACC_ID                 --账户编号
    ,ORG_ID                 --机构编号
    ,SUBJ_ID                --科目编号
    ,ACC_NM                 --账户名称
    ,DR_CR_FLG              --借贷标志
    ,CUR                    --币种
    ,STATS_SUBJ_ID          --统计科目编号
    ,DR_BAL                 --借方余额
    ,CR_BAL                 --贷方余额
    ,INT_CALC_FLG           --计息标志
    ,INT_CALC_MODE          --计息方式
    ,RATE                   --利率
    ,OPEN_ACC_DT            --开户日期
    ,CNL_ACC_DT             --销户日期
    ,ACC_STAT               --账户状态
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,SUB_ACC_ID             --子账户编号
    ,SEPARATE_ACCT_FLG      --是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD         --存款账户状态原码值
    ,CURRT_ACRU_INT         --当期应计利息  --ADD BY YJY 20260317
    )
  WITH TMP_SUBJ AS (
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_DEP_ACC_INFO WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID FROM RRP_MDL.M_DEP_INTL_ACC_INFO WHERE DATA_DT = V_P_DATE
    )
  SELECT  TO_CHAR(T1.ETL_DT, 'YYYYMMDD')                    AS DATA_DT --数据日期
         ,'9999'                                            AS LGL_REP_ID--法人编号
         ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS ACC_ID--账户编号
         ,KK.ORG_ID1                                        AS ORG_ID--机构编号
         ,T1.SUBJ_ID                                        AS SUBJ_ID--科目编号
         ,C.SUBJ_NAME                                       AS ACC_NM--账户名称
         ,CASE WHEN T1.SUBJ_DIR_CD = 'R' THEN 'C'
             WHEN T1.SUBJ_DIR_CD = 'P' THEN 'D' --表外业务 收方对应贷方，付方对应借方
             ELSE T1.SUBJ_DIR_CD
          END                                               AS DR_CR_FLG --借贷标志
         ,T1.CURR_CD                                        AS CUR --币种
         ,NULL                                              AS STATS_SUBJ_ID--统计科目编号
         ,NVL(ABS(T1.QMJFYE), 0.00)                         AS DR_BAL--借方余额
         ,NVL(ABS(T1.QMDFYE), 0.00)                         AS CR_BAL --贷方余额
         ,'N'                                               AS INT_CALC_FLG --计息标志
         ,'05'                                              AS INT_CALC_MODE --计息方式 --不计计息
         ,0.0000                                            AS RATE --利率
         --,'99991231'                                        AS  OPEN_ACC_DT          --开户日期
         ,CASE WHEN TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD') = '00010101' THEN TO_CHAR(B1.ORG_FOUND_DT, 'YYYYMMDD')
               ELSE TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD')
           END                                              AS OPEN_ACC_DT          --开户日期
         --MODIFY BY 20220714 LHQ 根据业务口径:机构+科目+币种拼接的账号，没有开户日期取对应机构成立日期
         --MODIFY BY TANGAN AT 20221105 如果机构成立日期为00010101，则取映射后的
         ,'99991231'                                        AS CNL_ACC_DT--销户日期
         ,'01'                                              AS ACC_STAT --账户状态 --正常
         ,'800918'                                          AS DEPT_LINE --部门条线/*计划财务部*/
         ,'总账数据信息'                                    AS DATA_SRC      --数据来源
         ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS SUB_ACC_ID --子账户编号
         ,'1'                                               AS SEPARATE_ACCT_FLG  --是否单列账标志1报送0不报送
         ,'A'                                               AS ACCT_STATUS_CD   --存款账户状态原码值
         ,NULL                                              AS CURRT_ACRU_INT      --当期应计利息  --ADD BY YJY 20260317
   FROM (
        /**本币**/
        SELECT A.ETL_DT                         ETL_DT                --数据日期
              ,A.ACCT_DURAN                     ACCT_DURAN            --数据区间
              ,A.ORG_ID                         ORG_ID                --机构编号
              ,A.SUBJ_ID                        SUBJ_ID               --会计科目编号
              ,A.CURR_CD                        CURR_CD               --币种代码
              ,A.SUBJ_DIR_CD                    SUBJ_DIR_CD
              ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_OC_DR_BAL -A.TD_OC_CR_BAL  --轧差
                        WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL> 0
                                                            THEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL
                                                            ELSE 0
                                                        END)
                        WHEN A.SUBJ_DIR_CD = 'C' THEN 0
                        ELSE A.TD_OC_DR_BAL
                    END)                        QMJFYE
              ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL   --轧差
                        WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL> 0
                                                            THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL
                                                            ELSE 0
                                                        END)
                        WHEN A.SUBJ_DIR_CD = 'D' THEN 0
                        ELSE A.TD_OC_CR_BAL
                    END)                        QMDFYE
              ,SUBSTR(A.JOB_CD, 0, 4) AS JOB_CD
         FROM RRP_MDL.O_ICL_CMM_GL_BAL A  --总账余额
        WHERE A.CURR_CD = 'CNY'
          AND A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_P_DATE,1,4) ||'-12' ELSE SUBSTR(V_DATA_DT,0,7) END --年末取结转后的数据，监管报送也是取的调账后的*/
          AND A.DATA_SRC_CD <> '99'  --modify by tangan at 20230104
          AND A.STD_PROD_ID <> '999999999999'  --modify by tangan at 20230104
          AND LENGTH(A.STD_PROD_ID) = 1 --MOD BY LIP 20251014 只采集汇总的产品数据
          AND A.ORG_ID NOT IN ('800S') --MOD BY LIP 20230527 过滤800S机构（广东华兴银行股份有限公司总行-税专用）
          AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.ETL_DT,A.ACCT_DURAN,A.ORG_ID,A.SUBJ_ID,A.CURR_CD,A.SUBJ_DIR_CD,SUBSTR(A.JOB_CD, 0, 4)
        UNION ALL
       /**本外币**/
       SELECT A.ETL_DT                          ETL_DT                --数据日期
             ,A.ACCT_DURAN                      ACCT_DURAN            --数据区间
             ,A.ORG_ID                          ORG_ID                --机构编号
             ,A.SUBJ_ID                         SUBJ_ID               --会计科目编号
             ,'BWB'                             CURR_CD               --币种代码
             ,A.SUBJ_DIR_CD                     SUBJ_DIR_CD
             ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_DC_DR_BAL -A.TD_DC_CR_BAL  --轧差
                       WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_DC_DR_BAL-A.TD_DC_CR_BAL> 0
                                                           THEN A.TD_DC_DR_BAL-A.TD_DC_CR_BAL
                                                           ELSE 0
                                                       END)
                       WHEN A.SUBJ_DIR_CD = 'C' THEN 0
                       ELSE A.TD_DC_DR_BAL
                   END)                         AS QMJFYE
             ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL   --轧差
                       WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL> 0
                                                           THEN A.TD_DC_CR_BAL-A.TD_DC_DR_BAL
                                                           ELSE 0
                                                       END)
                       WHEN A.SUBJ_DIR_CD = 'D' THEN 0
                       ELSE A.TD_DC_CR_BAL
                   END)                         AS QMDFYE
             ,SUBSTR(A.JOB_CD, 0, 4)            AS JOB_CD
        FROM RRP_MDL.O_ICL_CMM_GL_BAL A  --总账余额
       WHERE A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_P_DATE,1,4)||'-12' ELSE SUBSTR(V_DATA_DT,0,7) END --年末取结转后的数据，监管报送也是取的调账后的*/
         AND A.CURR_CD NOT IN ('CCC','USC','CFC','CUC')  --modify by tangan at 20230104 剔除上游汇总币种数据
         AND A.DATA_SRC_CD <> '99' --MODIFY BY TANGAN AT 20230104
         AND A.STD_PROD_ID <> '999999999999'  --modify by tangan at 20230104
          AND LENGTH(A.STD_PROD_ID) = 1 --MOD BY LIP 20251014 只采集汇总的产品数据
         AND A.ORG_ID NOT IN ('800S') --MOD BY LIP 20230527 过滤800S机构（广东华兴银行股份有限公司总行-税专用）
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       GROUP BY A.ETL_DT,A.ACCT_DURAN,A.ORG_ID,A.SUBJ_ID,A.SUBJ_DIR_CD,SUBSTR(A.JOB_CD, 0, 4)
        ) T1
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = T1.ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C  --科目信息
      ON C.SUBJ_ID = T1.SUBJ_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_REF_PUB_CD D
      ON D.CD_VAL = C.SUBJ_CHAR_CD
     AND D.CD_ID = 'CD1390'
    LEFT JOIN RRP_MDL.ORG_CONFIG KK
      ON KK.ORG_ID = T1.ORG_ID --update by cxl 20220511
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B1  --内部机构信息表  --MODIFY BY TANGAN AT 20221105 如果机构成立日期为00010101，则取映射后的
      ON B1.ORG_ID = KK.ORG_ID1
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE /*C.SUBJ_LEV_CD <= '3' AND*/ --要求只报三级科目
         NOT EXISTS (SELECT 1 FROM TMP_SUBJ E WHERE T1.SUBJ_ID = E.SUBJ_ID)  --UPDATE BY CHENXL 20220401 剔除存贷款科目
     --AND SUBSTR(T1.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
     AND (SUBSTR(T1.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
           OR T1.SUBJ_ID IN ('64110102')) --MOD BY LIP 20230612 根据业务反馈，需要报送 64110102 个人利息支出
     AND T1.ORG_ID <> '999999';  --MODIFY BY TANGAN AT 20221105 剔除999999机构的数据

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账信息-总账数据信息_一表通';
  V_STARTTIME := SYSDATE;
  /*************************总账*************************/
  INSERT /*+APPEND*/ INTO RRP_MDL.M_DEP_INTL_ACC_INFO_YBT NOLOGGING
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ACC_ID                 --账户编号
    ,ORG_ID                 --机构编号
    ,SUBJ_ID                --科目编号
    ,ACC_NM                 --账户名称
    ,DR_CR_FLG              --借贷标志
    ,CUR                    --币种
    ,STATS_SUBJ_ID          --统计科目编号
    ,DR_BAL                 --借方余额
    ,CR_BAL                 --贷方余额
    ,INT_CALC_FLG           --计息标志
    ,INT_CALC_MODE          --计息方式
    ,RATE                   --利率
    ,OPEN_ACC_DT            --开户日期
    ,CNL_ACC_DT             --销户日期
    ,ACC_STAT               --账户状态
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,SUB_ACC_ID             --子账户编号
    ,SEPARATE_ACCT_FLG      --是否单列账标志1报送0不报送
    ,ACCT_STATUS_CD         --存款账户状态原码值
    )
  WITH TMP_SUBJ AS (
    SELECT DISTINCT SUBJ_ID,CUR FROM RRP_MDL.M_DEP_ACC_INFO  WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID,CUR FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO WHERE DATA_DT = V_P_DATE
    UNION ALL
    SELECT DISTINCT SUBJ_ID,CUR FROM RRP_MDL.M_DEP_INTL_ACC_INFO WHERE DATA_SRC <> '总账数据信息' AND  DATA_DT = V_P_DATE
    )
  SELECT  TO_CHAR(T1.ETL_DT, 'YYYYMMDD')                    AS DATA_DT --数据日期
         ,'9999'                                            AS LGL_REP_ID--法人编号
         ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS ACC_ID--账户编号
         ,KK.ORG_ID1                                        AS ORG_ID--机构编号
         ,T1.SUBJ_ID                                        AS SUBJ_ID--科目编号
         ,C.SUBJ_NAME                                       AS ACC_NM--账户名称
         ,CASE WHEN T1.SUBJ_DIR_CD = 'R' THEN 'C'
             WHEN T1.SUBJ_DIR_CD = 'P' THEN 'D' --表外业务 收方对应贷方，付方对应借方
             ELSE T1.SUBJ_DIR_CD
          END                                               AS DR_CR_FLG --借贷标志
         ,T1.CURR_CD                                        AS CUR --币种
         ,NULL                                              AS STATS_SUBJ_ID--统计科目编号
         ,NVL(ABS(T1.QMJFYE), 0.00)                         AS DR_BAL--借方余额
         ,NVL(ABS(T1.QMDFYE), 0.00)                         AS CR_BAL --贷方余额
         ,'N'                                               AS INT_CALC_FLG --计息标志
         ,'05'                                              AS INT_CALC_MODE --计息方式 --不计计息
         ,0.0000                                            AS RATE --利率
         --,'99991231'                                        AS  OPEN_ACC_DT          --开户日期
         ,CASE WHEN TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD') = '00010101' THEN TO_CHAR(B1.ORG_FOUND_DT, 'YYYYMMDD')
               ELSE TO_CHAR(B.ORG_FOUND_DT, 'YYYYMMDD')
           END                                              AS OPEN_ACC_DT          --开户日期
         --MODIFY BY 20220714 LHQ 根据业务口径:机构+科目+币种拼接的账号，没有开户日期取对应机构成立日期
         --MODIFY BY TANGAN AT 20221105 如果机构成立日期为00010101，则取映射后的
         ,'99991231'                                        AS CNL_ACC_DT--销户日期
         ,'01'                                              AS ACC_STAT --账户状态 --正常
         ,'800918'                                          AS DEPT_LINE --部门条线/*计划财务部*/
         ,'总账数据信息'                                    AS DATA_SRC      --数据来源
         ,T1.ORG_ID || T1.SUBJ_ID || T1.CURR_CD             AS SUB_ACC_ID --子账户编号
         ,'1'                                               AS SEPARATE_ACCT_FLG  --是否单列账标志1报送0不报送
         ,'A'                                               AS ACCT_STATUS_CD   --存款账户状态原码值
    FROM (
        /**本币**/
        SELECT A.ETL_DT                         ETL_DT                --数据日期
              ,A.ACCT_DURAN                     ACCT_DURAN            --数据区间
              ,A.ORG_ID                         ORG_ID                --机构编号
              ,A.SUBJ_ID                        SUBJ_ID               --会计科目编号
              ,A.CURR_CD                        CURR_CD               --币种代码
              ,A.SUBJ_DIR_CD                    SUBJ_DIR_CD
              ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'D' THEN A.TD_OC_DR_BAL -A.TD_OC_CR_BAL  --轧差
                        WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL> 0
                                                            THEN A.TD_OC_DR_BAL-A.TD_OC_CR_BAL
                                                            ELSE 0
                                                        END)
                        WHEN A.SUBJ_DIR_CD = 'C' THEN 0
                        ELSE A.TD_OC_DR_BAL
                    END)                        QMJFYE
              ,SUM(CASE WHEN A.SUBJ_DIR_CD = 'C' THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL   --轧差
                        WHEN A.SUBJ_DIR_CD = 'B' THEN (CASE WHEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL> 0
                                                            THEN A.TD_OC_CR_BAL-A.TD_OC_DR_BAL
                                                            ELSE 0
                                                        END)
                        WHEN A.SUBJ_DIR_CD = 'D' THEN 0
                        ELSE A.TD_OC_CR_BAL
                    END)                        QMDFYE
              ,SUBSTR(A.JOB_CD, 0, 4) AS JOB_CD
         FROM RRP_MDL.O_ICL_CMM_GL_BAL A  --总账余额
        WHERE A.CURR_CD NOT IN ('CCC','USC','CFC','CUC')
          AND A.ACCT_DURAN = CASE WHEN A.ETL_DT = V_Y_END_DT THEN SUBSTR(V_P_DATE,1,4) ||'-12' ELSE SUBSTR(V_DATA_DT,0,7) END --年末取结转后的数据，监管报送也是取的调账后的*/
          AND A.DATA_SRC_CD <> '99' 
          AND A.STD_PROD_ID <> '999999999999' 
          AND LENGTH(A.STD_PROD_ID) = 1
          AND A.ORG_ID NOT IN ('800S') 
          AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.ETL_DT,A.ACCT_DURAN,A.ORG_ID,A.SUBJ_ID,A.CURR_CD,A.SUBJ_DIR_CD,SUBSTR(A.JOB_CD, 0, 4)
        ) T1
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B  --内部机构信息表
      ON B.ORG_ID = T1.ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C  --科目信息
      ON C.SUBJ_ID = T1.SUBJ_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_REF_PUB_CD D
      ON D.CD_VAL = C.SUBJ_CHAR_CD
     AND D.CD_ID = 'CD1390'
    LEFT JOIN RRP_MDL.ORG_CONFIG KK
      ON KK.ORG_ID = T1.ORG_ID --update by cxl 20220511
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B1  --内部机构信息表  --MODIFY BY TANGAN AT 20221105 如果机构成立日期为00010101，则取映射后的
      ON B1.ORG_ID = KK.ORG_ID1
     AND B1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE C.SUBJ_LEV_CD = '3' AND--要求只报三级科目
         NOT EXISTS (SELECT 1 FROM TMP_SUBJ E WHERE T1.SUBJ_ID = E.SUBJ_ID AND T1.CURR_CD = E.CUR)
     AND (SUBSTR(T1.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')
           OR T1.SUBJ_ID IN ('64110102')) --MOD BY LIP 20230612 根据业务反馈，需要报送 64110102 个人利息支出
     AND T1.ORG_ID <> '999999'; 

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
    SELECT DATA_DT,ACC_ID,COUNT(1)
      FROM RRP_MDL.M_DEP_INTL_ACC_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT,ACC_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  V_ENDTIME  := SYSDATE;
  O_ERRCODE  := '0';
  IF V_SQLCOUNT > 0 THEN
     V_SQLMSG   := '数据重复';
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --去掉表的主键，通过语句判断M_DEP_INTL_ACC_INFO_YBT数据是否重复
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询M_DEP_INTL_ACC_INFO_YBT是否重复';
  V_STARTTIME := SYSDATE;
    WITH TMP_YBT AS (
  SELECT DATA_DT,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_DEP_INTL_ACC_INFO_YBT T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP_YBT;

  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  IF V_SQLCOUNT > 0 THEN
     V_SQLMSG   := 'M_DEP_INTL_ACC_INFO_YBT数据重复';
     O_ERRCODE  := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --表分析
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  ETL_DBMS_STATS(V_P_DATE, 'M_DEP_INTL_ACC_INFO_YBT', V_PART_NAME, O_ERRCODE); --add by zhaosj 20251226

  --MOD BY 20240122 月批调账后重跑一次后，增加月批的标志
  WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE ETL_DATE = V_P_DATE AND PROC_NAME = V_PROC_NAME)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;
  
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE (ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_DEP_INTL_ACC_INFO;
/

