CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_301_JJKXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：借记卡信息表
  **  存储过程名称:  ETL_EAST5_301_JJKXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人      修改原因
  **  20220629     LIP         调整格式、修改字段超长、字段换行问题
  **  20230427     LIP         将客户名称全是中文的()改为（）
  **  20240618     LIP         插入上个月有效但是这个月没采集到的数据
  **********************************************************************/
IS
  V_P_DATE           VARCHAR2(8);        --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);        --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);      --分区名称
  V_FREQ_FLAG        VARCHAR2(10);       --跑批频度
  V_STEP             INTEGER := 0;       --任务号
  V_COUNT            INTEGER := 0;       --数据记录条数
  V_STARTTIME        DATE;               --处理开始时间
  V_ENDTIME          DATE;               --处理结束时间
  V_SQLCOUNT         INTEGER := 0;       --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);      --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);      --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_301_JJKXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_301_JJKXXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入借记卡信息表--临时表对公数据处理';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_301_JJKXXB_TMP';
    INSERT INTO RRP_EAST.EAST5_301_JJKXXB_TMP
      (RID,         --数据主键
       JRXKZH,      --金融许可证号
       NBJGH,       --内部机构号
       KHTYBH,      --客户统一编号
       KHMC,        --客户名称
       ZJLB,        --证件类别
       ZJHM,        --证件号码
       KH,          --卡号
       HQCKZH,      --活期存款账号
       JJKCPMC,     --借记卡产品名称
       XNKBZ,       --虚拟卡标志
       YGKBZ,       --员工卡标志
       KKRQ,        --开卡日期
       KKGYH,       --开卡柜员号
       KPZT,        --卡片状态
       BBZ,         --备注
       CJRQ,        --采集日期
       DEPT_NO,     --部门编号
       SRC_SYS_ID,  --来源系统ID
       ISSUED_NO,   --填报机构
       ORG_NO,      --报送机构
       ADDRESS,     --归属地
       KHMC_ORIG,   --客户名称（脱敏前）
       ZJHM_ORIG,   --证件号码（脱敏前）
       KHMC_OTH,    --客户是否个人客户
       GSFZJG       --归属分支机构
       )
      --MOD BY LIP 20230619 一个卡号可能对应多个凭证，取凭证是是已签发，不是挂失的那笔
      WITH CRD_INFO AS (
    SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.CRD_NO ORDER BY T.VOUCH_NO DESC) RN
      FROM RRP_MDL.M_CRD_INFO T
     WHERE T.CRD_MED <> '2' --剔除II类户 MODIFY BY TANGAN AT 20221129
       AND NVL(T.CNL_CRD_DT,'99991231')>= SUBSTR(V_P_DATE,1,6)||'01' --MODIFY BY TANGAN AT 20221119 过滤掉上期销卡的数据
       AND T.DATA_DT = V_P_DATE)
    SELECT SYS_GUID()                                              AS RID,         --数据主键
           C.FIN_PERMIT_NO                                         AS JRXKZH,      --金融许可证号
           --A.ORG_ID                                                AS NBJGH,       --内部机构号
           C.ORG_ID                                                AS NBJGH,       --内部机构号
           A.CUST_ID                                               AS KHTYBH,      --客户统一编号
           B.CUST_NM                                               AS KHMC,        --客户名称
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL AND B.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(B.PBC_NO) IS NOT NULL AND B.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                --ELSE CODE.TAR_VALUE_NAME
                --ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS ZJLB,        --证件类别
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN TRIM(B.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(B.FIN_PERMIT_NO)
                ELSE TRIM(B.CRDL_NO)
            END                                                    AS ZJHM,        --证件号码
           A.CRD_NO                                                AS KH,          --卡号
           D.ACC_ID                                                AS HQCKZH,      --活期存款账号
           --A.PROD_NM                                               AS JJKCPMC,     --借记卡产品名称
           --CODE1.TAR_VALUE_NAME                                    AS XNKBZ,       --虚拟卡标志
           --TRIM(SUBSTRB(A.PROD_NM,1,100))                          AS JJKCPMC,     --借记卡产品名称 --MODIFY BY LIP
           TRIM(SUBSTRB(A.PROD_NM,1,150))                          AS JJKCPMC,     --借记卡产品名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.VRTL_CRD_FLG = '0' THEN '否' ELSE '是' END  AS XNKBZ ,      --虚拟卡标志
           CODE2.TAR_VALUE_NAME                                    AS YGKBZ,       --员工卡标志
           NVL(A.OPEN_CRD_DT, '99991231')                          AS KKRQ,        --开卡日期
           A.OPEN_CRD_TLR_NO                                       AS KKGYH,       --开卡柜员号
           CODE3.TAR_VALUE_NAME                                    AS KPZT,        --卡片状态
           ''                                                      AS BBZ,         --备注
           V_MONTH_END_DATEID                                      AS CJRQ,        --采集日期
           '000'                                                   AS DEPT_NO,     --部门编号
           '01'                                                    AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,     --归属地
           B.CUST_NM                                               AS KHMC_ORIG,   --客户名称（脱敏前）
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN TRIM(B.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(B.FIN_PERMIT_NO)
                ELSE TRIM(B.CRDL_NO)
            END                                                    AS ZJHM_ORIG,   --证件号码（脱敏前）
           '否'                                                    AS KHMC_OTH,    --客户是否个人客户
           C.GSFZJG                                                AS GSFZJG       --归属分支机构
      --FROM RRP_MDL.M_CRD_INFO A --卡基本信息
      FROM CRD_INFO A
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_DEP_ACC_MED_REL_INFO D --存款账户介质关系信息
        ON D.MED_ID = A.CRD_NO
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')/*B.ORG_ID*/
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.VRTL_CRD_FLG
       AND CODE1.SRC_CLASS_CODE = 'Z0001' --虚拟卡标志
       AND CODE1.TAR_CLASS_CODE = 'Z0001' --虚拟卡标志
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.EMP_CRD_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0001' --员工卡标志
       AND CODE2.TAR_CLASS_CODE = 'Z0001' --员工卡标志
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.CRD_STAT
       AND CODE3.SRC_CLASS_CODE = 'D0042' --卡片状态
       AND CODE3.TAR_CLASS_CODE = 'D0042' --卡片状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.RN = 1;
      /*A.CRD_CL = '01' --借记卡 --目前为空，暂注释--20220906 WYB*/

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入借记卡信息表--临时表个人数据处理信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_301_JJKXXB_TMP
      (RID,         --数据主键
       JRXKZH,      --金融许可证号
       NBJGH,       --内部机构号
       KHTYBH,      --客户统一编号
       KHMC,        --客户名称
       ZJLB,        --证件类别
       ZJHM,        --证件号码
       KH,          --卡号
       HQCKZH,      --活期存款账号
       JJKCPMC,     --借记卡产品名称
       XNKBZ,       --虚拟卡标志
       YGKBZ,       --员工卡标志
       KKRQ,        --开卡日期
       KKGYH,       --开卡柜员号
       KPZT,        --卡片状态
       BBZ,         --备注
       CJRQ,        --采集日期
       DEPT_NO,     --部门编号
       SRC_SYS_ID,  --来源系统ID
       ISSUED_NO,   --填报机构
       ORG_NO,      --报送机构
       ADDRESS,     --归属地
       KHMC_ORIG,   --客户名称（脱敏前）
       ZJHM_ORIG,   --证件号码（脱敏前）
       KHMC_OTH,    --客户是否个人客户
       GSFZJG       --归属分支机构
       )
      --MOD BY LIP 20230619 一个卡号可能对应多个凭证，取凭证是是已签发，不是挂失的那笔
      WITH CRD_INFO AS (
    SELECT /*+MATERIALIZE*/T.*,ROW_NUMBER() OVER(PARTITION BY T.CRD_NO ORDER BY T.VOUCH_NO DESC) RN
      FROM RRP_MDL.M_CRD_INFO T
     WHERE T.CRD_MED <> '2' --剔除II类户 MODIFY BY TANGAN AT 20221129
       AND NVL(T.CNL_CRD_DT,'99991231')>= SUBSTR(V_P_DATE,1,6)||'01' --MODIFY BY TANGAN AT 20221119 过滤掉上期销卡的数据
       AND T.DATA_DT = V_P_DATE)
    SELECT SYS_GUID()                                              AS RID,         --数据主键
           C.FIN_PERMIT_NO                                         AS JRXKZH,      --金融许可证号
           --A.ORG_ID                                                AS NBJGH,       --内部机构号
           C.ORG_ID                                                AS NBJGH,       --内部机构号
           A.CUST_ID                                               AS KHTYBH,      --客户统一编号
           B.CUST_NM_DESEN                                         AS KHMC,        --客户名称
           CASE WHEN CODE.TAR_VALUE_CODE IN ('1071','1072') THEN '其他有效通行旅行证件'
                WHEN CODE.TAR_VALUE_CODE IN ('121', '122') THEN '护照'
                WHEN CODE.TAR_VALUE_CODE IN ('1D') THEN '文职干部证'
                /*WHEN CODE.TAR_VALUE_CODE IN ('1X') THEN '其他-' ||CODE.TAR_VALUE_NAME
                ELSE CODE.TAR_VALUE_NAME*/
                --MODIFY BY LIP 处理字段超长问题
                /*WHEN CODE.TAR_VALUE_CODE IN ('1X') THEN TRIM(SUBSTRB('其他-' ||CODE.TAR_VALUE_NAME,1,40))
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))*/
                WHEN CODE.TAR_VALUE_CODE IN ('1X') THEN TRIM(SUBSTRB('其他-' ||CODE.TAR_VALUE_NAME,1,60))
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS ZJLB,        --证件类别
           B.CRDL_NO_DESEN                                         AS ZJHM,        --证件号码--MODIFY BY LAIHAIQIANG AT 20230403
           A.CRD_NO                                                AS KH,          --卡号
           D.ACC_ID                                                AS HQCKZH,      --活期存款账号
           --TRIM(SUBSTRB(A.PROD_NM,1,100))                          AS JJKCPMC,     --借记卡产品名称 --MODIFY BY LIP
           TRIM(SUBSTRB(A.PROD_NM,1,150))                          AS JJKCPMC,     --借记卡产品名称 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.VRTL_CRD_FLG = '0' THEN '否' ELSE '是' END  AS XNKBZ,       --虚拟卡标志 --MODIFY 20220928 LHQ
           CODE2.TAR_VALUE_NAME                                    AS YGKBZ,       --员工卡标志
           NVL(A.OPEN_CRD_DT, '99991231')                          AS KKRQ,        --开卡日期
           A.OPEN_CRD_TLR_NO                                       AS KKGYH,       --开卡柜员号
           CODE3.TAR_VALUE_NAME                                    AS KPZT,        --卡片状态
           ''                                                      AS BBZ,         --备注
           V_MONTH_END_DATEID                                      AS CJRQ,        --采集日期
           '000'                                                   AS DEPT_NO,     --部门编号
           '01'                                                    AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,     --归属地
           B.CUST_NM                                               AS KHMC_ORIG,   --客户名称（脱敏前）
           B.CRDL_NO                                               AS ZJHM_ORIG,   --证件号码（脱敏前）
           '是'                                                    AS KHMC_OTH,    --客户是否个人客户
           C.GSFZJG                                                AS GSFZJG       --归属分支机构
      --FROM RRP_MDL.M_CRD_INFO A --卡基本信息
      FROM CRD_INFO A --卡基本信息
     INNER JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_DEP_ACC_MED_REL_INFO D --存款账户介质关系信息
        ON D.MED_ID = A.CRD_NO
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.EMP_CRD_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0001' --员工卡标志
       AND CODE2.TAR_CLASS_CODE = 'Z0001' --员工卡标志
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.CRD_STAT
       AND CODE3.SRC_CLASS_CODE = 'D0042' --卡片状态
       AND CODE3.TAR_CLASS_CODE = 'D0042' --卡片状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*A.CRD_CL = '01' --借记卡 --目前为空，暂注释--20220906 WYB*/
           A.RN = 1;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '借记卡信息表--插入目标表信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_301_JJKXXB
      (RID,         --数据主键
       JRXKZH,      --金融许可证号
       NBJGH,       --内部机构号
       KHTYBH,      --客户统一编号
       KHMC,        --客户名称
       ZJLB,        --证件类别
       ZJHM,        --证件号码
       KH,          --卡号
       HQCKZH,      --活期存款账号
       JJKCPMC,     --借记卡产品名称
       XNKBZ,       --虚拟卡标志
       YGKBZ,       --员工卡标志
       KKRQ,        --开卡日期
       KKGYH,       --开卡柜员号
       KPZT,        --卡片状态
       BBZ,         --备注
       CJRQ,        --采集日期
       DEPT_NO,     --部门编号
       SRC_SYS_ID,  --来源系统ID
       ISSUED_NO,   --填报机构
       ORG_NO,      --报送机构
       ADDRESS,     --归属地
       KHMC_ORIG,   --客户名称（脱敏前）
       ZJHM_ORIG,   --证件号码（脱敏前）
       KHMC_OTH,    --客户是否个人客户
       GSFZJG       --归属分支机构
       )
    SELECT A.RID                           AS RID,         --数据主键
           --SYS_GUID()                      AS RID,         --数据主键
           A.JRXKZH                        AS JRXKZH,      --金融许可证号
           A.NBJGH                         AS NBJGH,       --内部机构号
           A.KHTYBH                        AS KHTYBH,      --客户统一编号
           --A.KHMC                          AS KHMC,        --客户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.KHMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.KHMC),'(','（'),')','）'),' ','')
                ELSE TRIM(A.KHMC)
            END                            AS KHMC,        --客户名称
           A.ZJLB                          AS ZJLB,        --证件类别
           A.ZJHM                          AS ZJHM,        --证件号码
           A.KH                            AS KH,          --卡号
           A.HQCKZH                        AS HQCKZH,      --活期存款账号
           A.JJKCPMC                       AS JJKCPMC,     --借记卡产品名称
           A.XNKBZ                         AS XNKBZ,       --虚拟卡标志
           A.YGKBZ                         AS YGKBZ,       --员工卡标志
           A.KKRQ                          AS KKRQ,        --开卡日期
           A.KKGYH                         AS KKGYH,       --开卡柜员号
           A.KPZT                          AS KPZT,        --卡片状态
           A.BBZ                           AS BBZ,         --备注
           A.CJRQ                          AS CJRQ,        --采集日期
           A.DEPT_NO                       AS DEPT_NO,     --部门编号
           A.SRC_SYS_ID                    AS SRC_SYS_ID,  --来源系统ID
           A.ISSUED_NO                     AS ISSUED_NO,   --填报机构
           A.ORG_NO                        AS ORG_NO,      --报送机构
           A.ADDRESS                       AS ADDRESS,     --归属地
           --A.KHMC_ORIG                     AS KHMC_ORIG,   --客户名称（脱敏前）
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.KHMC_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.KHMC_ORIG),'(','（'),')','）'),' ','')
                ELSE TRIM(A.KHMC_ORIG)
            END                            AS KHMC_ORIG,   --客户名称（脱敏前）
           A.ZJHM_ORIG                     AS ZJHM_ORIG,   --证件号码（脱敏前）
           A.KHMC_OTH                      AS KHMC_OTH,    --客户是否个人客户
           A.GSFZJG                        AS GSFZJG       --归属分支机构
      FROM RRP_EAST.EAST5_301_JJKXXB_TMP A
     WHERE A.CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240618 插入上个月有效但是这个月没采集到的数据
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '借记卡信息表--插入上个月有效但是这个月没采集到的数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_301_JJKXXB
      (RID,         --数据主键
       JRXKZH,      --金融许可证号
       NBJGH,       --内部机构号
       KHTYBH,      --客户统一编号
       KHMC,        --客户名称
       ZJLB,        --证件类别
       ZJHM,        --证件号码
       KH,          --卡号
       HQCKZH,      --活期存款账号
       JJKCPMC,     --借记卡产品名称
       XNKBZ,       --虚拟卡标志
       YGKBZ,       --员工卡标志
       KKRQ,        --开卡日期
       KKGYH,       --开卡柜员号
       KPZT,        --卡片状态
       BBZ,         --备注
       CJRQ,        --采集日期
       DEPT_NO,     --部门编号
       SRC_SYS_ID,  --来源系统ID
       ISSUED_NO,   --填报机构
       ORG_NO,      --报送机构
       ADDRESS,     --归属地
       KHMC_ORIG,   --客户名称（脱敏前）
       ZJHM_ORIG,   --证件号码（脱敏前）
       KHMC_OTH,    --客户是否个人客户
       GSFZJG       --归属分支机构
       )
    SELECT SYS_GUID()                      AS RID,         --数据主键
           D.FIN_PERMIT_NO                 AS JRXKZH,      --金融许可证号
           A.NBJGH                         AS NBJGH,       --内部机构号
           A.KHTYBH                        AS KHTYBH,      --客户统一编号
           CASE WHEN B.CUST_ID IS NOT NULL THEN TRIM(B.CUST_NM_DESEN)
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(C.CUST_NM) IS NOT NULL THEN TRIM(C.CUST_NM)
            END                            AS KHMC,        --客户名称
           CASE WHEN B.CUST_ID IS NOT NULL AND CODE.TAR_VALUE_CODE IN ('1071','1072') THEN '其他有效通行旅行证件'
                WHEN B.CUST_ID IS NOT NULL AND CODE.TAR_VALUE_CODE IN ('121', '122') THEN '护照'
                WHEN B.CUST_ID IS NOT NULL AND CODE.TAR_VALUE_CODE IN ('1D') THEN '文职干部证'
                WHEN B.CUST_ID IS NOT NULL AND CODE.TAR_VALUE_CODE IN ('1X') THEN TRIM(SUBSTRB('其他-' ||CODE.TAR_VALUE_NAME,1,60))
                WHEN B.CUST_ID IS NOT NULL THEN TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NOT NULL AND C.NATL_ECON_DEPT_CL NOT LIKE 'E%' THEN '银行机构代码'
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NOT NULL AND C.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NULL AND TRIM(C.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                WHEN C.CUST_ID IS NOT NULL THEN TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))
            END                            AS ZJLB,        --证件类别
           CASE WHEN B.CUST_ID IS NOT NULL THEN B.CRDL_NO_DESEN
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NOT NULL THEN TRIM(C.PBC_NO)
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NULL AND TRIM(C.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(C.FIN_PERMIT_NO)
                WHEN C.CUST_ID IS NOT NULL THEN TRIM(C.CRDL_NO)
            END                            AS ZJHM,        --证件号码
           A.KH                            AS KH,          --卡号
           A.HQCKZH                        AS HQCKZH,      --活期存款账号
           A.JJKCPMC                       AS JJKCPMC,     --借记卡产品名称
           A.XNKBZ                         AS XNKBZ,       --虚拟卡标志
           A.YGKBZ                         AS YGKBZ,       --员工卡标志
           A.KKRQ                          AS KKRQ,        --开卡日期
           A.KKGYH                         AS KKGYH,       --开卡柜员号
           '注销'                          AS KPZT,        --卡片状态
           A.BBZ                           AS BBZ,         --备注
           V_MONTH_END_DATEID              AS CJRQ,        --采集日期
           A.DEPT_NO                       AS DEPT_NO,     --部门编号
           A.SRC_SYS_ID                    AS SRC_SYS_ID,  --来源系统ID
           A.ISSUED_NO                     AS ISSUED_NO,   --填报机构
           A.ORG_NO                        AS ORG_NO,      --报送机构
           A.ADDRESS                       AS ADDRESS,     --归属地
           CASE WHEN B.CUST_ID IS NOT NULL THEN TRIM(B.CUST_NM)
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(C.CUST_NM) IS NOT NULL THEN TRIM(C.CUST_NM)
            END                            AS KHMC_ORIG,   --客户名称（脱敏前）
           CASE WHEN B.CUST_ID IS NOT NULL THEN B.CRDL_NO
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NOT NULL THEN TRIM(C.PBC_NO)
                WHEN C.CUST_ID IS NOT NULL AND TRIM(C.PBC_NO) IS NULL AND TRIM(C.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(C.FIN_PERMIT_NO)
                WHEN C.CUST_ID IS NOT NULL THEN TRIM(C.CRDL_NO)
            END                            AS ZJHM_ORIG,   --证件号码（脱敏前）
           A.KHMC_OTH                      AS KHMC_OTH,    --客户是否个人客户
           A.GSFZJG                        AS GSFZJG       --归属分支机构
      FROM RRP_EAST.EAST5_301_JJKXXB A
      LEFT JOIN RRP_EAST.EAST5_301_JJKXXB TA
        ON TA.KH = A.KH
       AND TA.CJRQ = V_MONTH_END_DATEID
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息
        ON B.CUST_ID = A.KHTYBH
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.KHTYBH
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST D --机构表
        ON D.ORG_ID = A.NBJGH
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = NVL(B.CRDL_TYP,C.CRDL_TYP)
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
     WHERE TA.KH IS NULL
       AND A.KPZT IN ('未激活','正常','冻结','睡眠','挂失')
       AND A.CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,KH,HQCKZH,COUNT(1)
      FROM RRP_EAST.EAST5_301_JJKXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,KH,HQCKZH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE  := '1';
       V_SQLMSG  := 'EAST5_301_JJKXXB(CJRQ,KH,HQCKZH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1 ;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE, V_TABLE_NAME, V_PARTITION_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE := '1';
    V_SQLMSG  := '跑批错误：['||SQLCODE||'],描述信息：'||SQLERRM;
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_EAST5_301_JJKXXB;
/

