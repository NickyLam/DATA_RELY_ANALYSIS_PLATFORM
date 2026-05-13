CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_DEP_ACC_MED_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_DEP_ACC_MED_INFO
  *  功能描述：监管集市银行普通存折，存单，一本通，大额定期存单，其他。
  *  创建日期：20220525
  *  开发人员：HULIJUAN
  *  来源表：  ICL.CMM_DEP_CUST_ACCT_INFO    --存款主账户信息
  *            IML.AGT_VOUCH_ACCT_RELA_H     --凭证账户关系历史
  *            ICL.CMM_DEP_ACCT_INFO         --存款分户信息
  *            ICL.CMM_INDV_CUST_BASIC_INFO  --个人客户基本信息
  *            IML.REF_PUB_CD                --公共码值表
  *  目标表：  M_DEP_ACC_MED_INFO  --存款介质信息表
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  HULJ     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20241105  LIP      增加存折凭证号字段
  *             4    20250929  YJY      调整账户介质，新增凭证类型770-电子存单
  **************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;             --处理步骤
  V_STEP_DESC VARCHAR2(100);            --处理步骤描述
  V_P_DATE    VARCHAR2(8);              --跑批数据日期
  V_STARTTIME DATE;                     --处理开始时间
  V_ENDTIME   DATE;                     --处理结束时间
  V_SQLCOUNT  INTEGER := 0;             --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);            --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);            --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_DEP_ACC_MED_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_DEP_ACC_MED_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_DEP_ACC_MED_INFO T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_DEP_ACC_MED_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理

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
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,'1',O_ERRCODE);
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
  V_STEP_DESC := '存款介质信息表';
  V_STARTTIME := SYSDATE;
  /***普通存折存单***/
  INSERT INTO RRP_MDL.M_DEP_ACC_MED_INFO
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,ORG_ID         --机构编号
    ,MED_ID         --介质编号
    ,CUST_ID        --客户编号
    ,ACC_MED        --账户介质
    ,MED_STAT       --介质状态
    ,ENABLE_DT      --启用日期
    ,ENABLE_TLR_NO  --启用柜员号
    ,DEPT_LINE      --部门条线
    ,DATA_SRC       --数据来源
    ,VOUCH_NO       --凭证号 --ADD BY LIP 20241105 增加存折凭证号字段
    )
    WITH VOUCH_ACCT_RELA_H AS (--账号凭证对照(按照ACCTNO分组，子户号和状态（倒序）排序，取第一条)
  SELECT /*+MATERIALIZE*/AGT_ID,VOUCH_NO,CUST_ACCT_NUM,DEP_VOUCH_CATE_CD,
         --ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_NUM ORDER BY SUB_ACCT_NUM, VOUCH_STATUS_CD DESC) AS ARANK
         ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_NUM ORDER BY DECODE(VOUCH_STATUS_CD,'ACT','Z',VOUCH_STATUS_CD) DESC,SUB_ACCT_NUM) AS ARANK --调整成先按凭证状态排序
    FROM RRP_MDL.O_IML_AGT_VOUCH_ACCT_RELA_H --凭证账户关系历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')),
    DEP_ACCT_INFO AS (
  SELECT /*+MATERIALIZE*/ACCT_ID,CUST_ACCT_ID,DEP_ACCT_STATUS_CD,OPEN_ACCT_TELLER_ID,
         ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY ACCT_ID,OPEN_ACCT_TM) AS ARANK
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                                   AS DATA_DT            --数据日期
         ,A.LP_ID                                    AS LGL_REP_ID         --法人编号
         ,NVL(A.ACCT_BELONG_ORG_ID,B.ORG_ID)         AS ORG_ID             --机构编号
         ,NVL(C.AGT_ID,A.CUST_ACCT_ID)               AS MED_ID             --介质编号
         ,A.CUST_ID                                  AS CUST_ID            --客户编号
         ,CASE WHEN A.VOUCH_KIND_CD IN ('737','771','770') THEN '02' --存单 --MOD BY YJY 20250929 新增凭证类型770-电子存单
               WHEN A.VOUCH_KIND_CD = '735' THEN '03' --一本通
               WHEN A.VOUCH_KIND_CD = '731' THEN '01' --存折
               WHEN A.VOUCH_KIND_CD = '772' THEN '99' --其他
           END                                       AS ACC_MED            --账户介质
         ,NVL(TA.TAR_VALUE_CODE,'00')                AS MED_STAT           --介质状态
         ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')         AS ENABLE_DT          --启用日期
         ,NVL(TRIM(D.OPEN_ACCT_TELLER_ID),TRIM(A.OPEN_ACCT_TELLER_ID)) AS ENABLE_TLR_NO --启用柜员号 --MODIFY 20230306 LHQ 改为优先从存款分户表取对应开户柜员
         ,'800001'                                   AS DEPT_LINE          --部门条线/*营运管理部*/
         ,SUBSTR(A.JOB_CD,0,4)                       AS DATA_SRC           --数据来源
         --NVL(C.VOUCH_NO,A.CUST_ACCT_ID)             AS VOUCH_NO            --凭证号 --ADD BY LIP 20241105 增加存折凭证号字段
         ,NVL(C.DEP_VOUCH_CATE_CD||C.VOUCH_NO,A.CUST_ACCT_ID) AS VOUCH_NO  --凭证号 --MOD BY LIP 20241202 调整存折凭证号，拼接存折类型
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息
      ON B.ORG_ID = A.ACCT_BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN VOUCH_ACCT_RELA_H C --凭证号临时表 --账号凭证对照(按照ACCTNO分组，子户号和状态（倒序）排序，取第一条)
      ON C.CUST_ACCT_NUM = A.CUST_ACCT_ID
     AND C.ARANK = 1
    LEFT JOIN DEP_ACCT_INFO D --存款分户账临时表
      ON D.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND D.ARANK = 1
    LEFT JOIN RRP_MDL.CHG_ACCT_TMP CAT --换卡临时表 沿用存款账户介质关系信息表(ETL_B_DEP_ACC_MED_REL_INFO)中加工好的临时表
      ON CAT.ACCT_ID = D.ACCT_ID
     AND CAT.CUST_ACCT_ID = A.CUST_ACCT_ID/*过滤掉换卡的账户*/
    LEFT JOIN RRP_MDL.TMP_CBS_DECD_TEMP E --大额存单临时表 沿用存款账户介质关系信息表(ETL_B_DEP_ACC_MED_REL_INFO)中加工好的临时表
      ON E.MED_ID = A.CUST_ACCT_ID
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD F --账户状态
      ON F.CD_VAL = A.ACCT_STATUS_CD --更改账户状态
     AND F.CD_ID = 'CD1253'
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD G
      ON G.CD_VAL = A.VOUCH_KIND_CD --凭证种类
     AND G.CD_ID = 'CD1315'
    LEFT JOIN RRP_MDL.CODE_MAP TA
      ON TA.SRC_VALUE_CODE = A.ACCT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD2544'
     AND TA.TAR_CLASS_CODE = 'D0042' --介质
     AND TA.MOD_FLG = 'MDM'
   WHERE E.MED_ID IS NULL --筛选掉大额存单部分
     AND NVL(D.ACCT_ID,CAT.ACCT_ID) IS NOT NULL
     AND A.VOUCH_KIND_CD IN ('731','737','735','771','772','770') --MOD BY YJY 20250929 新增凭证类型770-电子存单
     AND (CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231') THEN '20991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
           END) >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --过滤掉月初前销户的数据
     AND UPPER(A.JOB_CD) <> 'IFCSF1' --去除微众数据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --大额存单
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入存款介质信息-大额存单数据信息';
  V_STARTTIME := SYSDATE;
  /*** 大额存单 ***/
  INSERT INTO RRP_MDL.M_DEP_ACC_MED_INFO
    (DATA_DT                --数据日期
    ,LGL_REP_ID             --法人编号
    ,ORG_ID                 --机构编号
    ,MED_ID                 --介质编号
    ,CUST_ID                --客户编号
    ,ACC_MED                --账户介质
    ,MED_STAT               --介质状态
    ,ENABLE_DT              --启用日期
    ,ENABLE_TLR_NO          --启用柜员号
    ,DEPT_LINE              --部门条线
    ,DATA_SRC               --数据来源
    ,VOUCH_NO               --凭证号 --ADD BY LIP 20241105 增加存折凭证号字段
    )
    WITH DEP_ACCT_INFO AS (
  SELECT /*+MATERIALIZE*/A.CUST_ACCT_ID,A.ACCT_ID,A.BELONG_ORG_ID,A.CUST_ID,A.OPEN_ACCT_DT,
         A.OPEN_ACCT_TELLER_ID,A.STD_PROD_ID,A.JOB_CD,
         ROW_NUMBER() OVER(PARTITION BY A.CUST_ACCT_ID ORDER BY A.ACCT_ID,A.OPEN_ACCT_TM) AS A_RANK
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
   WHERE A.SUBJ_ID IN ('20110103','20110203') --新一代科目 20110103对公大额存单 20110203个人大额存单 LHQ 20221011
     --AND A.SUBJ_ID IN ('20110205','20110206') --EAST5.0旧科目
     AND (CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231') THEN '20991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD')
           END) >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --过滤掉月初前销户的数据
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  V_P_DATE                               AS DATA_DT          --数据日期
         ,'9999'                                 AS LGL_REP_ID       --法人编号
         ,NVL(A.BELONG_ORG_ID,B.ORG_ID)          AS ORG_ID           --机构编号
         ,A.CUST_ACCT_ID                         AS MED_ID           --介质编号
         ,A.CUST_ID                              AS CUST_ID          --客户编号
         ,'04'                                   AS ACC_MED          --账户介质
         ,NVL(TA.TAR_VALUE_CODE,'00')            AS MED_STAT         --介质状态
         ,TO_CHAR(A.OPEN_ACCT_DT,'YYYYMMDD')     AS ENABLE_DT        --启用日期
         ,NVL(TRIM(A.OPEN_ACCT_TELLER_ID),TRIM(C.OPEN_ACCT_TELLER_ID)) AS ENABLE_TLR_NO --启用柜员号 --MODIFY 20230306 LHQ 改为优先从存款分户表取对应开户柜员
         ,'800001'                               AS DEPT_LINE        --部门条线 /*营运管理部*/
         ,SUBSTR(A.JOB_CD,0,4)                   AS DATA_SRC         --数据来源
         ,A.CUST_ACCT_ID                         AS VOUCH_NO         --凭证号 --ADD BY LIP 20241105 增加存折凭证号字段
    FROM DEP_ACCT_INFO A
    LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO B --内部机构信息
      ON B.ORG_ID = A.BELONG_ORG_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO C --存款主账户表
      ON C.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_IML_REF_PUB_CD F --账户状态
      ON F.CD_VAL = C.ACCT_STATUS_CD
     AND F.CD_ID = 'CD1253'
    LEFT JOIN RRP_MDL.CODE_MAP TA
      ON TA.SRC_VALUE_CODE = C.ACCT_STATUS_CD
     AND TA.SRC_CLASS_CODE = 'CD2544'
     AND TA.TAR_CLASS_CODE = 'D0042' --介质
     AND TA.MOD_FLG = 'MDM'
   WHERE A.CUST_ACCT_ID NOT IN (SELECT MED_ID FROM RRP_MDL.M_DEP_ACC_MED_INFO WHERE DATA_DT = V_P_DATE)
     AND A.A_RANK = 1;

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
  SELECT DATA_DT,MED_ID,COUNT(1)
    FROM RRP_MDL.M_DEP_ACC_MED_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,MED_ID
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
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

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
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_DEP_ACC_MED_INFO;
/

