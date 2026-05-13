CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_OTH_SP_MERC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_OTH_SP_MERC_INFO
  *  功能描述：监管集市商业银行的商户信息以及商业银行卡在他行商户发生交易的商户信息
  *  创建日期：20220524
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_POS_MERCHT_INFO   --商户基础信息表
  *            ICL.CMM_INTNAL_ORG_INFO  --内部机构信息表
  *  目标表：  M_OTH_SP_MERC_INFO  --特约商户信息
  *
  *  配置表：  IML.REF_PUB  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220507  程序员   EAST5校验规则调整，同步进行程序修改。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20220905  MW       增加商户状态、商户MCC码值
  *             7    20220906  MW       增加清算商户账号、名称、类型字段
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_OTH_SP_MERC_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0;  -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100);  -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_START_DT CHAR(8) ;       --月初日期
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_OTH_SP_MERC_INFO'; --表名
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

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理


  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '特约商户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_OTH_SP_MERC_INFO
  ( DATA_DT,                --数据日期
     LGL_REP_ID,            --法人编号
     ORG_ID,                --机构编号
     SPCL_MER_ID,           --特约商户编号
     MER_CUST_ID,           --商户客户编号
     MER_NM,                --商户名称
     SIGN_DT,               --签约日期
     CNL_DT,                --撤销日期
     MER_STAT,              --商户状态
     MER_MCC_CD,            --商户mcc码
     MER_MCC_NM,            --商户mcc名称
     MER_RGN_AREA_CD,       --商户地区行政区划代码
     LIQ_CRD_NO_OR_ACC,     --清算卡号或账号
     LIQ_ACC_TYP,           --清算账号类型
     CLR_ACC_NM,            --清算账户名称
     LIQ_ACC_OPEN_BANK_NM,  --清算账号开户行名称
     DEPT_LINE,             --部门条线
     DATA_SRC               --数据来源
    )
  SELECT distinct TO_CHAR(A.ETL_DT,'YYYYMMDD')                  AS DATA_DT      --数据日期
       ,'9999'                                         AS LGL_REP_ID   --法人编号
       ,/*KK.ORG_ID  */
       A.BELONG_ORG_ID                                    AS ORG_ID       --机构编号
       ,A.MERCHT_ID                                    AS SPCL_MER_ID  --特约商户编号
       ,'2'                                            AS MER_CUST_ID  --商户客户编号
       ,A.MERCHT_NAME                                  AS MER_NM       --商户名称
       ,TO_CHAR(A.MERCHT_START_USE_DT,'YYYYMMDD')      AS SIGN_DT      --签约日期
       ,'99991231'                                     AS CNL_DT       --撤销日期
       ,TTA.TAR_VALUE_CODE                             AS MER_STAT     --商户状态Y有效N无效
       ,A.MERCHT_MCC_CODE                              AS MER_MCC_CD   --商户MCC码
       ,A.MERCHT_MCC_DESCB                             AS MER_MCC_NM   --商户MCC名称
       ,A.MERCHT_BELONG_RG_CD                          AS MER_RGN_AREA_CD--商户地区行政区划代码
       ,A.ACCT_ID                          AS LIQ_CRD_NO_OR_ACC--清算卡号或账号
       ,CASE WHEN A.ACCT_TYPE_CD = '0' THEN '其他-机构号'
             WHEN A.ACCT_TYPE_CD = '1' THEN '其他-个人户'
             WHEN A.ACCT_TYPE_CD = '11' THEN '其他-一类户'
             WHEN A.ACCT_TYPE_CD = '12' THEN '其他-二类户'
             WHEN A.ACCT_TYPE_CD = '13' THEN '其他-三类户'
             WHEN A.ACCT_TYPE_CD = '2' THEN '其他-银行内部户'
             WHEN A.ACCT_TYPE_CD = '30' THEN '其他-一般户/借记卡'
             WHEN A.ACCT_TYPE_CD = '31' THEN '其他-基本户/内部户'
             WHEN A.ACCT_TYPE_CD = '32' THEN '其他-对公保证金户'
             WHEN A.ACCT_TYPE_CD = '33' THEN '其他-对公活期账户'
             WHEN A.ACCT_TYPE_CD = '34' THEN '其他-电子账户'
             WHEN A.ACCT_TYPE_CD = '39' THEN '其他-虚拟账户'
             WHEN A.ACCT_TYPE_CD IN ('99', '-') THEN '其他-其他' END   AS LIQ_ACC_TYP  --清算账号类型
       ,A.ACCT_NAME                                AS CLR_ACC_NM   --清算账号名称
       ,A.OPEN_ACCT_BANK_NAME                          AS LIQ_ACC_OPEN_BANK_NM--清算账号开户行名称
       ,NULL                                           AS DEPT_LINE   --部门条线
       ,'特约商户信息'                           AS DATA_SRC  --数据来源
  FROM O_ICL_CMM_POS_MERCHT_INFO A  --商户基础信息表
/*  LEFT JOIN O_ICL_CMM_INTNAL_ORG_INFO KK
    ON A.BELONG_ORG_ID = KK.ORG_ID*/
/*  LEFT JOIN O_IML_REF_PUB_CD B
  ON A.ACCT_TYPE_CD = B.CD_VAL
  AND B.CD_ID ='CD1986'*/
  LEFT JOIN RRP_MDL.CODE_MAP TTA  --商户状态转码
  ON TTA.SRC_VALUE_CODE = A.MERCHT_STATUS_CD
  AND TTA.SRC_CLASS_CODE = 'CD2012'
  AND TTA.TAR_CLASS_CODE = 'Z0002'
  AND TTA.MOD_FLG = 'MDM'
  WHERE  A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
  AND A.JH_MERCHT_FLG <> 1
  AND A.DIC_CONC_MERCHT_FLG <> 1
   ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');
 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_INIT_M_OTH_SP_MERC_INFO;
/

