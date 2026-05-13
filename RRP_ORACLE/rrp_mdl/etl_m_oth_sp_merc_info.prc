CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_OTH_SP_MERC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_OTH_SP_MERC_INFO
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
  *             3    20220905  MW       增加商户状态、商户MCC码值
  *             4    20220906  MW       增加清算商户账号、名称、类型字段
  *             5    20240725  LIP      调整直连商户加工逻辑，增加条码商户加工口径
  *             6    20240912  LIP      调整直连商户的MCC商户名称加工口径
  *             7    20250507  YJY      调整商户MCC名称的取数来源，注释威富通商户信息历史的数据加工
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_OTH_SP_MERC_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_OTH_SP_MERC_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
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
  ETL_PARTITION_ADD(I_P_DATE, 'M_OTH_SP_MERC_INFO', '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_OTH_SP_MERC_INFO'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '特约商户信息--线下POS商户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_OTH_SP_MERC_INFO
    (DATA_DT               --数据日期
    ,LGL_REP_ID            --法人编号
    ,ORG_ID                --机构编号
    ,SPCL_MER_ID           --特约商户编号
    ,MER_CUST_ID           --商户客户编号
    ,MER_NM                --商户名称
    ,SIGN_DT               --签约日期
    ,CNL_DT                --撤销日期
    ,MER_STAT              --商户状态
    ,MER_MCC_CD            --商户MCC码
    ,MER_MCC_NM            --商户MCC名称
    ,MER_RGN_AREA_CD       --商户地区行政区划代码
    ,LIQ_CRD_NO_OR_ACC     --清算卡号或账号
    ,LIQ_ACC_TYP           --清算账号类型
    ,CLR_ACC_NM            --清算账户名称
    ,LIQ_ACC_OPEN_BANK_NM  --清算账号开户行名称
    ,DEPT_LINE             --部门条线
    ,DATA_SRC              --数据来源
    )
  SELECT V_P_DATE                                      AS DATA_DT              --数据日期
        ,'9999'                                        AS LGL_REP_ID           --法人编号
        ,A.BELONG_ORG_ID                               AS ORG_ID               --机构编号
        ,A.MERCHT_ID                                   AS SPCL_MER_ID          --特约商户编号
        ,'2'                                           AS MER_CUST_ID          --商户客户编号
        ,TRIM(A.MERCHT_NAME)                           AS MER_NM               --商户名称
        /*,TO_CHAR(A.MERCHT_START_USE_DT,'YYYYMMDD')     AS SIGN_DT              --签约日期
        ,'99991231'                                    AS CNL_DT               --撤销日期*/
        --MOD BY LIP 20240725 调整
        ,CASE WHEN TO_CHAR(A.MERCHT_SIGN_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.MERCHT_SIGN_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                          AS SIGN_DT              --签约日期
        ,CASE WHEN A.DIC_CONC_CO_STATUS_CD = '10' THEN '99991231'
              WHEN TO_CHAR(A.MERCHT_REVO_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.MERCHT_REVO_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                          AS CNL_DT               --撤销日期
        ,CASE WHEN A.DIC_CONC_CO_STATUS_CD = '10' THEN 'Y' --10：在用
              WHEN A.DIC_CONC_CO_STATUS_CD = '11' THEN 'N' --11：冻结
              WHEN A.DIC_CONC_CO_STATUS_CD = '12' THEN 'N' --12：终止合作
              ELSE 'N'
          END                                          AS MER_STAT             --商户状态
        ,TRIM(A.MERCHT_MCC_CODE)                       AS MER_MCC_CD           --商户MCC码
        --,TRIM(A.MERCHT_MCC_DESCB)                      AS MER_MCC_NM           --商户MCC名称
        /*,TRIM(B.MCC_DISC)                              AS MER_MCC_NM           --商户MCC名称 --MOD BY LIP 20240912 */
        ,TRIM(A.MERCHT_MCC_DESCB)                      AS MER_MCC_NM           --商户MCC名称 --MOD BY YJY  20250507 
        ,TRIM(A.MERCHT_BELONG_RG_CD)                   AS MER_RGN_AREA_CD      --商户地区行政区划代码
        ,TRIM(A.ACCT_ID)                               AS LIQ_CRD_NO_OR_ACC    --清算卡号或账号
        /*,CASE WHEN A.ACCT_TYPE_CD = '0' THEN '其他-机构号'
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
              WHEN A.ACCT_TYPE_CD IN ('99', '-') THEN '其他-其他'
          END                                          AS LIQ_ACC_TYP          --清算账号类型*/
        --MOD BY LIP 20240725 --10：单位银行账户；11：个人银行账户；12：其他账户；19：未约定收单结算账户
        --MOD BY LIP 20240819 CD1986 数仓有进行转码
        ,CASE WHEN A.ACCT_TYPE_CD = '10' THEN '其他-单位银行账户'
              WHEN A.ACCT_TYPE_CD = '14' THEN '其他-个人银行账户'
              WHEN A.ACCT_TYPE_CD = '15' THEN '其他-其他账户'
              WHEN A.ACCT_TYPE_CD = '19' THEN '其他-未约定收单结算账户'
          END                                          AS LIQ_ACC_TYP          --清算账号类型
        ,TRIM(A.ACCT_NAME)                             AS CLR_ACC_NM           --清算账号名称
        ,TRIM(A.OPEN_ACCT_BANK_NAME)                   AS LIQ_ACC_OPEN_BANK_NM --清算账号开户行名称
        ,NULL                                          AS DEPT_LINE            --部门条线
        ,'线下POS商户'                                 AS DATA_SRC             --数据来源
    FROM RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO A  --商户基础信息表
   WHERE A.JH_MERCHT_FLG <> 1
     AND A.DIC_CONC_MERCHT_FLG = '1' --MOD BY LIP 20240722 只取模型中的直连商户 线下POS商户部分
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
 
 -- MOD BY YJY 20250507 O_IML_AGT_WFT_MERCHT_INFO_H威富通商户信息历史下线，相关业务已合并到O_ICL_CMM_POS_MERCHT_INFO商户基础信息表
 /* 
  --ADD BY LIP 20240725 增加条码商户逻辑加工
  V_STEP := 2;
  V_STEP_DESC := '特约商户信息--条码商户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_OTH_SP_MERC_INFO
    (DATA_DT,              --数据日期
    LGL_REP_ID,            --法人编号
    ORG_ID,                --机构编号
    SPCL_MER_ID,           --特约商户编号
    MER_CUST_ID,           --商户客户编号
    MER_NM,                --商户名称
    SIGN_DT,               --签约日期
    CNL_DT,                --撤销日期
    MER_STAT,              --商户状态
    MER_MCC_CD,            --商户MCC码
    MER_MCC_NM,            --商户MCC名称
    MER_RGN_AREA_CD,       --商户地区行政区划代码
    LIQ_CRD_NO_OR_ACC,     --清算卡号或账号
    LIQ_ACC_TYP,           --清算账号类型
    CLR_ACC_NM,            --清算账户名称
    LIQ_ACC_OPEN_BANK_NM,  --清算账号开户行名称
    DEPT_LINE,             --部门条线
    DATA_SRC               --数据来源
    )
  SELECT V_P_DATE                                      AS DATA_DT              --数据日期
        ,'9999'                                        AS LGL_REP_ID           --法人编号
        ,A.BELONG_ORG_ID                               AS ORG_ID               --机构编号
        ,A.MERCHT_ID                                   AS SPCL_MER_ID          --特约商户编号
        ,'2'                                           AS MER_CUST_ID          --商户客户编号
        ,TRIM(A.MERCHT_NAME)                           AS MER_NM               --商户名称
        ,CASE WHEN TO_CHAR(A.INIT_CREATE_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.INIT_CREATE_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                          AS SIGN_DT              --签约日期
        ,CASE WHEN (A.MERCHT_ACTV_STATUS_DESCB = '注销' OR A.MERCHT_ACTV_STATUS_DESCB = '冻结')
                   AND TO_CHAR(A.FINAL_MODIF_DT,'YYYYMMDD') NOT IN ('00010101','29991231')
              THEN TO_CHAR(A.FINAL_MODIF_DT,'YYYYMMDD')
              ELSE '99991231'
          END                                          AS CNL_DT               --撤销日期
        ,CASE WHEN A.MERCHT_ACTV_STATUS_DESCB = '激活成功' THEN 'Y' --10：在用
              WHEN A.MERCHT_ACTV_STATUS_DESCB = '需再次激活' THEN 'Y' --10：在用
              WHEN A.MERCHT_ACTV_STATUS_DESCB = '注销' THEN 'N' --12：终止合作
              ELSE 'N' --11：冻结
          END                                          AS MER_STAT             --商户状态
        ,NULL                                          AS MER_MCC_CD           --商户MCC码
        ,NULL                                          AS MER_MCC_NM           --商户MCC名称
        ,'440000'                                      AS MER_RGN_AREA_CD      --商户地区行政区划代码
        ,TRIM(A.STL_ACCT_ID)                           AS LIQ_CRD_NO_OR_ACC    --清算卡号或账号
        --,DECODE(A.STL_ACCT_TYPE_CD,'个人','11','10')   AS LIQ_ACC_TYP          --清算账号类型
        ,DECODE(A.STL_ACCT_TYPE_CD,'个人','其他-个人银行账户','其他-单位银行账户') AS LIQ_ACC_TYP          --清算账号类型
        ,TRIM(A.STL_ACCT_NAME)                         AS CLR_ACC_NM           --清算账号名称
        ,CASE WHEN TRIM(A.STL_ACCT_OPEN_BANK_NAME) IS NULL THEN '广东华兴银行'
              ELSE TRIM(A.STL_ACCT_OPEN_BANK_NAME)
          END                                          AS LIQ_ACC_OPEN_BANK_NM --清算账号开户行名称
        ,NULL                                          AS DEPT_LINE            --部门条线
        ,'条码商户'                                    AS DATA_SRC             --数据来源
    FROM RRP_MDL.O_IML_AGT_WFT_MERCHT_INFO_H A  --威富通商户信息历史
   WHERE A.ID_MARK <> 'D'
     AND A.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  */  

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_OTH_SP_MERC_INFO;
/

