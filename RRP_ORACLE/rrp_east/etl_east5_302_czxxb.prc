CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_302_CZXXB(I_P_DATE IN INTEGER, --跑批日期
                                                O_ERRCODE OUT VARCHAR2 --错误代码
                                                )
  /***********************************************************************
  **  存储过程详细说明：存折信息表
  **  存储过程名称:  ETL_EAST5_302_CZXXB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220101';
         ETL_EAST5_302_CZXXB(I_P_DATE,O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改项目          修改人        修改原因
  **  20220618     华兴银行监管      LAIHAIQIANG   修改员工标志逻辑口径问题
  **  20220629     华兴银行监管      LIP          调整格式、修改字段超长、字段换行问题
  **  20230523     华兴银行监管      LIP          将历史的柜员映射为新一代柜员
  ************************************************************************/
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
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_302_CZXXB'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_302_CZXXB'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入存折信息表-对公临时表数据处理';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_302_CZXXB_TMP';
    INSERT INTO RRP_EAST.EAST5_302_CZXXB_TMP
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       CZH, --存折号
       HQCKZH, --存款账号
       CZLX, --存折类型
       YGBZ, --员工标志
       QYRQ, --启用日期
       QYGYH, --启用柜员号
       CZZT, --存折状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       ZJHM_ORIG,--证件号码（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                              AS RID, ---数据主键
           C.FIN_PERMIT_NO                                         AS JRXKZH, --金融许可证号
           --A.ORG_ID                                                AS NBJGH, --内部机构号
           C.ORG_ID                                                AS NBJGH, --内部机构号
           A.CUST_ID                                               AS KHTYBH, --客户统一编号
           B.CUST_NM                                               AS KHMC, --客户名称
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL AND TRIM(B.NATL_ECON_DEPT_CL) NOT LIKE 'E%' THEN '银行机构代码'
                WHEN TRIM(B.PBC_NO) IS NOT NULL AND B.NATL_ECON_DEPT_CL LIKE 'E%' THEN 'SWIFT编码'
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN '金融许可证号'
                ELSE
                  --UPDATE BY CXL 对港澳台通行证做处理，对中国护照和外国护照做处理统一处理成护照
                  CASE WHEN CODE.TAR_VALUE_CODE IN ('15','151','152','16') THEN '其他有效通行旅行证件'
                       WHEN CODE.TAR_VALUE_CODE IN ('121','122') THEN '护照'
                       WHEN CODE.TAR_VALUE_CODE IN ('1D') THEN '文职干部证'
                       WHEN CODE.TAR_VALUE_CODE IN ('1X') THEN TRIM(SUBSTRB('其他-'||CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                       ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                   END
            END                                                    AS ZJLB, --证件类别
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN TRIM(B.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(B.FIN_PERMIT_NO)
                ELSE TRIM(B.CRDL_NO)
            END                                                    AS ZJHM, --证件号码
           --A.MED_ID                                                AS CZH, --存折号
           NVL(TRIM(A.VOUCH_NO),A.MED_ID)                          AS CZH, --存折号 --MOD BY LIP 20241105
           D.ACC_ID                                                AS HQCKZH, --存款账号
           --CODE1.TAR_VALUE_NAME                                   AS CZLX, --存折类型
           --REPLACE(REPLACE(CODE1.TAR_VALUE_NAME,CHR(10),''),CHR(13),'') AS CZLX, --存折类型
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,20))                AS CZLX, --存折类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,30))                AS CZLX, --存折类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           '否'                                                    AS YGBZ, --员工标志
           NVL(A.ENABLE_DT,'99991231')                             AS QYRQ, --启用日期
           NVL(TRIM(A.ENABLE_TLR_NO),'M0001')                      AS QYGYH, --启用柜员号
           CASE WHEN A.MED_STAT = '01' THEN '未激活'
                WHEN A.MED_STAT = '02' THEN '正常'
                WHEN A.MED_STAT = '03' THEN '挂失'
                WHEN A.MED_STAT = '04' THEN '注销'
                WHEN A.MED_STAT = '06' THEN '冻结'
                WHEN A.MED_STAT LIKE '07%' THEN '睡眠'
                WHEN A.MED_STAT = '08' THEN '其他-止付'
                WHEN A.MED_STAT = '05' THEN '其他-过期'
                --ELSE '其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-', '')
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,20)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME, '其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS CZZT, --存折状态
           ''                                                      AS BBZ, --备注
           V_MONTH_END_DATEID                                      AS CJRQ, --采集日期
           '000'                                                   AS DEPT_NO, --部门编号
           '01'                                                    AS SRC_SYS_ID, --来源系统ID
           '000000'                                                AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS, --归属地
           B.CUST_NM                                               AS KHMC_ORIG, --客户名称（脱敏前）
           CASE WHEN TRIM(B.PBC_NO) IS NOT NULL THEN TRIM(B.PBC_NO)
                WHEN TRIM(B.PBC_NO) IS NULL AND TRIM(B.FIN_PERMIT_NO) IS NOT NULL THEN TRIM(B.FIN_PERMIT_NO)
                ELSE TRIM(B.CRDL_NO)
            END                                                    AS ZJHM_ORIG,--证件号码（脱敏前）
           '否'                                                    AS KHMC_OTH, --客户是否个人客户
           C.GSFZJG                                                AS GSFZJG--归属分支机构
      FROM RRP_MDL.M_DEP_ACC_MED_INFO A --存款介质信息
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_DEP_ACC_MED_REL_INFO D --存款账户介质关系信息
        ON D.MED_ID = A.MED_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.ACC_MED
       AND CODE1.SRC_CLASS_CODE = 'D0077' --存折类型
       AND CODE1.TAR_CLASS_CODE = 'D0077' --存折类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.MED_STAT
       AND CODE2.SRC_CLASS_CODE = 'D0042' --存折状态
       AND CODE2.TAR_CLASS_CODE = 'D0042' --存折状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '插入存折信息表--临时表个人数据处理信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_302_CZXXB_TMP
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       CZH, --存折号
       HQCKZH, --存款账号
       CZLX, --存折类型
       YGBZ, --员工标志
       QYRQ, --启用日期
       QYGYH, --启用柜员号
       CZZT, --存折状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       ZJHM_ORIG,--证件号码（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                              AS RID, ---数据主键
           C.FIN_PERMIT_NO                                         AS JRXKZH, --金融许可证号
           C.ORG_ID                                                AS NBJGH, --内部机构号
           A.CUST_ID                                               AS KHTYBH, --客户统一编号
           B.CUST_NM_DESEN                                         AS KHMC, --客户名称 --MODIFY BY LAIHAIQIANG AT 20230403
           CASE --WHEN CODE.TAR_VALUE_CODE IN ('15','151','152','16') THEN '其他有效通行旅行证件'
                WHEN CODE.TAR_VALUE_CODE IN ('121','122') THEN '护照'
                WHEN CODE.TAR_VALUE_CODE IN ('1D') THEN '文职干部证'
                WHEN CODE.TAR_VALUE_CODE IN ('1X')
                /*THEN TRIM(SUBSTRB('其他-' ||CODE.TAR_VALUE_NAME,1,40))
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))*/
                THEN TRIM(SUBSTRB('其他-' ||CODE.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                ELSE TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                 AS ZJLB, --证件类别 UPDATE BY 20220429 CXL 处理港澳台通行证，处理护照
           B.CRDL_NO_DESEN                                      AS ZJHM, --证件号码 --MODIFY BY LAIHAIQIANG AT 20230403
           --A.MED_ID                                               AS CZH, --存折号
           NVL(TRIM(A.VOUCH_NO),A.MED_ID)                         AS CZH, --存折号 --MOD BY LIP 20241105
           D.ACC_ID                                               AS HQCKZH, --存款账号
           --CODE1.TAR_VALUE_NAME                                  AS CZLX, --存折类型
           --REPLACE(REPLACE(CODE1.TAR_VALUE_NAME,CHR(10),''),CHR(13),'') AS CZLX, --存折类型
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,20))               AS CZLX, --存折类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,30))               AS CZLX, --存折类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN B.BANK_EMP_FLG = 'Y' THEN '是'
                ELSE '否'
            END                                                   AS YGBZ, --员工标志 --MODIFY 20220618 修改员工标志逻辑口径问题 LAIHAIQIANG
           NVL(A.ENABLE_DT,'99991231')                            AS QYRQ, --启用日期
           --NVL(TRIM(A.ENABLE_TLR_NO),'M0001')                     AS QYGYH, --启用柜员号
           NVL(TRIM(A.ENABLE_TLR_NO),'S####')                     AS QYGYH, --启用柜员号 --20230201 加默认值 S####
           CASE WHEN A.MED_STAT = '01' THEN '未激活'
                WHEN A.MED_STAT = '02' THEN '正常'
                WHEN A.MED_STAT = '03' THEN '挂失'
                WHEN A.MED_STAT = '04' THEN '注销'
                WHEN A.MED_STAT = '06' THEN '冻结'
                WHEN A.MED_STAT LIKE '07%' THEN '睡眠'
                WHEN A.MED_STAT = '08' THEN '其他-止付'
                WHEN A.MED_STAT = '05' THEN '其他-过期'
                --ELSE '其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-','')
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,20)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS CZZT, --存折状态
           ''                                                      AS BBZ, --备注
           V_MONTH_END_DATEID                                      AS CJRQ, --采集日期
           '000'                                                   AS DEPT_NO, --部门编号
           '01'                                                    AS SRC_SYS_ID, --来源系统ID
           '000000'                                                AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS, --归属地
           B.CUST_NM                                               AS KHMC_ORIG, --客户名称（脱敏前）
           B.CRDL_NO                                               AS ZJHM_ORIG,--证件号码（脱敏前）
           '是'                                                    AS KHMC_OTH, --客户是否个人客户
           C.GSFZJG                                                AS GSFZJG--归属分支机构
      FROM RRP_MDL.M_DEP_ACC_MED_INFO A --存款介质信息
     INNER JOIN RRP_EAST.M_CUST_IND_INFO_EAST B --个人客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_DEP_ACC_MED_REL_INFO D --存款账户介质关系信息
        ON D.MED_ID = A.MED_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = B.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.ACC_MED
       AND CODE1.SRC_CLASS_CODE = 'D0077' --存折类型
       AND CODE1.TAR_CLASS_CODE = 'D0077' --存折类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.MED_STAT
       AND CODE2.SRC_CLASS_CODE = 'D0042' --存折状态
       AND CODE2.TAR_CLASS_CODE = 'D0042' --存折状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = M.ORG_ID1
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC:= '存折信息表--插入目标表信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_302_CZXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       CZH, --存折号
       HQCKZH, --存款账号
       CZLX, --存折类型
       YGBZ, --员工标志
       QYRQ, --启用日期
       QYGYH, --启用柜员号
       CZZT, --存折状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       ZJHM_ORIG, --证件号码（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                       AS RID, ---数据主键
           A.JRXKZH                         AS JRXKZH, --金融许可证号
           A.NBJGH                          AS NBJGH, --内部机构号
           A.KHTYBH                         AS KHTYBH, --客户统一编号
           --A.KHMC                           AS KHMC, --客户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.KHMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.KHMC),'(','（'),')','）'),' ','')
                ELSE TRIM(A.KHMC)
            END                             AS KHMC, --客户名称
           A.ZJLB                           AS ZJLB, --证件类别
           A.ZJHM                           AS ZJHM, --证件号码
           A.CZH                            AS CZH, --存折号
           A.HQCKZH                         AS HQCKZH, --存款账号
           A.CZLX                           AS CZLX, --存折类型
           A.YGBZ                           AS YGBZ, --员工标志
           A.QYRQ                           AS QYRQ, --启用日期
           --A.QYGYH                          AS QYGYH, --启用柜员号
           CASE /*WHEN B.EMP_ID IS NOT NULL THEN B.EMP_ID*/
                WHEN A.QYGYH IN ('M00001') THEN 'M0001'
                ELSE A.QYGYH
            END                             AS QYGYH, --启用柜员号
           A.CZZT                           AS CZZT, --存折状态
           A.BBZ                            AS BBZ, --备注
           A.CJRQ                           AS CJRQ, --采集日期
           A.DEPT_NO                        AS DEPT_NO, --部门编号
           A.SRC_SYS_ID                     AS SRC_SYS_ID, --来源系统ID
           A.ISSUED_NO                      AS ISSUED_NO, --填报机构
           A.ORG_NO                         AS ORG_NO, --报送机构
           A.ADDRESS                        AS ADDRESS, --归属地
           --A.KHMC_ORIG                      AS KHMC_ORIG, --客户名称（脱敏前）
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.KHMC_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.KHMC_ORIG),'(','（'),')','）'),' ','')
                ELSE TRIM(A.KHMC_ORIG)
            END                             AS KHMC_ORIG, --客户名称（脱敏前）
           A.ZJHM_ORIG                      AS ZJHM_ORIG, --证件号码（脱敏前）
           A.KHMC_OTH                       AS KHMC_OTH, --客户是否个人客户
           A.GSFZJG                         AS GSFZJG    --归属分支机构
      FROM RRP_EAST.EAST5_302_CZXXB_TMP A
     WHERE A.CJRQ = V_P_DATE;

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
    SELECT CJRQ,CZH,HQCKZH,COUNT(1)
      FROM RRP_EAST.EAST5_302_CZXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,CZH,HQCKZH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_302_CZXXB(CJRQ,CZH,HQCKZH)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1 ;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

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

END ETL_EAST5_302_CZXXB;
/

