CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_404_GRCKFHZMX(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：个人存款分户账明细记录
  **  存储过程名称:  ETL_EAST5_404_GRCKFHZMX
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人           修改原因
  **  20220505     LIUYU            科目号取值逻辑，改从B层存款账户表取科目号
  **  20220516     LAIHAIQIANG      增加机构映射表，从机构映射表取机构号
  **  20220629     LIP              调整格式、修改字段超长、字段换行问题
  **  20220817     XUCHANGXIN       调整证件类别的码值取数逻辑
  **  20220817     XUCHANGXIN       调整交易类型的码值取数逻辑以及增加码值
  **  20220817     XUCHANGXIN       调整交易借贷标志的逻辑
  **  20220817     XUCHANGXIN       调整冲补抹标志的逻辑
  **  20220817     XUCHANGXIN       调整现转标志的逻辑
  **  20220817     XUCHANGXIN       调整交易渠道的码值取数逻辑以及调整码值表映射关系
  **  20220817     XUCHANGXIN       调整代办人证件类别的码值取数
  **  20230714     LIP              调整授权柜员号口径，当授权柜员号和交易柜员号相同时，将授权柜员号置空
  **  20241018     LIP              对方户名是否对公标识识别口径调整
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_ETL_DATE         VARCHAR2(8);      --系统时间对应月初日期
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_404_GRCKFHZMX'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_404_GRCKFHZMX'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_ETL_DATE         := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    V_STEP := 1;
    V_STEP_DESC := '程序加工';
    V_STARTTIME := SYSDATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    /*增加分区*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);
    --DELETE /*+FULL(T)*/ FROM RRP_EAST.EAST5_404_GRCKFHZMX T WHERE/* T.HXJYRQ = V_P_DATE AND*/ T.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   WHILE V_ETL_DATE <= V_MONTH_END_DATEID LOOP

    V_P_DATE    := V_ETL_DATE ;
    V_STEP      := V_STEP+ 1;
    V_STEP_DESC := '清空临时表数据';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_404_GRCKFHZMX_TMP';

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP     := V_STEP+ 1;
    V_STEP_DESC := '插入临时表数据';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_404_GRCKFHZMX_TMP
      (RID, --主键
       JYXLH, --交易序列号
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YWBLJGH, --业务办理机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       GRCKZH, --个人存款账号
       WBZH, --外部账号
       JYLX, --交易类型
       JYJDBZ, --交易借贷标志
       HXJYRQ, --核心交易日期
       HXJYSJ, --核心交易时间
       BZ, --币种
       JYJE, --交易金额
       ZHYE, --账户余额
       DFZH, --对方账号
       DFHM, --对方户名
       DFXH, --对方行号
       DFXM, --对方行名
       ZY, --摘要
       FY, --附言
       CBMBZ, --冲补抹标志
       XZBZ, --现转标志
       JYQD, --交易渠道
       IPDZ, --IP地址
       MACDZ, --MAC地址
       DBRXM, --代办人姓名
       DBRZJLB, --代办人证件类别
       DBRZJHM, --代办人证件号码
       JYGYH, --交易柜员号
       SQGYH, --授权柜员号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       DBRXM_ORIG, --代办人姓名（脱敏前）
       DBRZJHM_ORIG, --代办人证件号码（脱敏前）
       ZJHM_ORIG, --证件号码（脱敏前）
       ZHMC_ORIG, --账户名称（脱敏前）
       DFHM_ORIG, --对方户名（脱敏前）
       DFHM_OTH, --对方户名是否自然人名称
       GSFZJG --归属分支机构
       )
    SELECT /*+USE_HASH(A B C E D C1 CODE CODE1 CODE2 CODE3 CODE4 CODE5 CODE6 ORG LIST)*/
           SYS_GUID()                                                AS RID, --数据主键
           --A.TRA_SEQ_NO                                              AS JYXLH, --交易序列号
           A.INIT_TRAN_TIMESTAMP||A.TRA_SEQ_NO                       AS JYXLH, --交易序列号 --MOD BY LIP 20241024
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           B.ORG_ID                                                  AS NBJGH, --内部机构号
           --A.HDL_ORG_ID                                              AS YWBLJGH, --业务办理机构号
           BB.ORG_ID                                                 AS YWBLJGH, --业务办理机构号
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           D.SUBJ_ID                                                 AS MXKMBH,--明细科目编号
           D.SUBJ_NM                                                 AS MXKMMC, --明细科目名称
           --MOD BY LIUYU 账户号关联存款账户表，取账户表科目关联科目表取科目名称
           A.CUST_ID                                                 AS KHTYBH, --客户统一编号
           C.CUST_NM_DESEN                                           AS ZHMC, --账户名称
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))                   AS ZJLB, --证件类别
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))                   AS ZJLB, --证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           C.CRDL_NO_DESEN                                           AS ZJHM, --证件号码
           /*A.ACC_ID                                                AS GRCKZH, --个人存款账号
           A.EXT_ACC                                                 AS WBZH, --外部账号*/
           --A.EXT_ACC                                                 AS GRCKZH, --个人存款账号
           --MOD BY LIP 20240618 将ACCT_ID长度小于4位的，改为用旧账号ID
           CASE WHEN LENGTH(A.ACC_ID_EAST) <= 4 AND TRIM(E.OLD_ACCT_ID) IS NOT NULL THEN TRIM(E.OLD_ACCT_ID)
                ELSE A.ACC_ID_EAST
            END                                                      AS GRCKZH, --个人存款账号
           A.ACC_ID                                                  AS WBZH, --外部账号
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))                  AS JYLX, --交易类型
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))                  AS JYLX, --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.TRA_DR_CR_FLG = 'D' THEN '借'
                WHEN A.TRA_DR_CR_FLG = 'C' THEN '贷'
           END                                                       AS JYJDBZ, --交易借贷标志
           NVL(A.TRA_DT,'99991231')                                  AS HXJYRQ, --核心交易日期
           NVL(TO_CHAR(A.TRA_TM,'HH24MISS'),'000000')                AS HXJYSJ, --核心交易时间
           A.CUR                                                     AS BZ, --币种
           A.TRA_AMT                                                 AS JYJE, --交易金额
           A.ACC_BAL                                                 AS ZHYE, --账户余额
           A.OPP_ACC                                                 AS DFZH, --对方账号
           A.OPP_ACC_NM                                              AS DFHM, --对方户名
           TRIM(A.OPP_PBC_NO)                                        AS DFXH, --对方行号
           A.OPP_BANK_NM                                             AS DFXM, --对方行名
           --MOD BY LIUYU 存在摘要为空，默认转账
           --NVL(TRIM(A.ABSTR),'转账')                                 AS ZY, --摘要
           --A.POSTSCRIPT                                              AS FY, --附言
           --MODIFY BY LIP
           TRIM(REPLACE(REPLACE(NVL(TRIM(A.ABSTR),'转账'),CHR(10),''),CHR(13),'')) AS ZY, --摘要
           --TRIM(REPLACE(REPLACE(TRIM(A.POSTSCRIPT),CHR(10),''),CHR(13),'')) AS FY, --附言
           TRIM(SUBSTRB(A.TRAN_MEMO_DESCB,1,600))                    AS FY, --附言 --MOD BY LIP 20260414
           CASE WHEN A.FLUSH_PATCH_FLG = 'N' THEN '正常'
               ELSE '冲补抹'
            END                                                      AS CBMBZ, --冲补抹标志
           CASE WHEN A.CASH_TRF_FLG = '1' THEN '现'
                WHEN A.CASH_TRF_FLG = '2' THEN '转'
            END                                                      AS XZBZ, --现转标志
           --TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))                  AS JYQD, --交易渠道--MODIFY BY LIP
           TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60))                  AS JYQD, --交易渠道 --MODIFY BY LIP 20240409 改为UTF-8的长度
           --MOD BY LIP 20240710 截取IP和MAC长度
           TRIM(SUBSTRB(A.IP,1,40))                                  AS IPDZ, --IP地址
           TRIM(SUBSTRB(A.MAC,1,60))                                 AS MACDZ, --MAC地址
           TRIM(A.AGT_NM)                                            AS DBRXM, --代办人姓名
           --TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,40))                  AS DBRZJLB, --代办人证件类别--MODIFY BY LIP
           TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,60))                  AS DBRZJLB, --代办人证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(A.AGT_CRDL_NO)                                       AS DBRZJHM, --代办人证件号码
           --MOD BY LIUYU 20220511 代办人证件号码有空格，去空格
           TRIM(A.TRA_TLR_NO)                                        AS JYGYH, --交易柜员号
           --TRIM(A.GRANT_TLR_NO)                                      AS SQGYH, --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           CASE --WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40)) NOT IN ('柜面')
                WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
                THEN NULL
                ELSE TRIM(A.GRANT_TLR_NO)
            END                                                      AS SQGYH, --授权柜员号
           ''                                                        AS BBZ, --备注
           V_MONTH_END_DATEID                                        AS CJRQ, --采集日期
           '000'                                                     AS DEPT_NO, --部门编号
           '01'                                                      AS SRC_SYS_ID, --来源系统ID
           '000000'                                                  AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS, --归属地
           A.AGT_NM                                                  AS DBRXM_ORIG, --代办人姓名（脱敏前）
           A.AGT_CRDL_NO                                             AS DBRZJHM_ORIG, --代办人证件号码（脱敏前）
           C.CRDL_NO                                                 AS ZJHM_ORIG, --证件号码（脱敏前）
           C.CUST_NM                                                 AS ZHMC_ORIG, --账户名称（脱敏前）
           --A.OPP_ACC_NM                                              AS DFHM_ORIG, --对方户名（脱敏前）
           A.OPP_ACC_NM                                              AS DFHM_ORIG, --对方户名（脱敏前）   --  TANQ  20230203
           --'是'                                                      AS DFHM_OTH, --户名是否自然人名称
           --MOD BY LIP 20230427 判断对方户名是否自然人名称
           CASE WHEN A.OPP_CORP_ACCT_FLG = '1' THEN '否' --MOD BY LIP 20241018
                WHEN A.OPP_CORP_ACCT_FLG = '0' THEN '是' --MOD BY LIP 20241018
                WHEN LENGTH(TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                ELSE '否'
            END                                                      AS DFHM_OTH, --对方户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_TRA_DEP_ACC_DTL A --存款账户交易流水
     INNER JOIN RRP_MDL.M_DEP_ACC_INFO E --存款账户信息 --ADD BY LIUYU 20220505
        ON E.ACC_ID_EAST = A.ACC_ID_EAST
       AND E.SUBJ_ID <> '30070101' --剔除委托存款
       AND E.DATA_DT = V_MONTH_END_DATEID
     INNER JOIN RRP_EAST.M_CUST_IND_INFO_EAST C --个人客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.ORG_CONFIG C1 --机构映射表
        ON C1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表 --MODIFY BY LAIHAIQIANG 20220516  A.ORG_ID改为 C1.ORG_ID1
        ON B.ORG_ID = NVL(C1.ORG_ID1,'800')
       AND B.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.ORG_CONFIG CC1 --机构映射表 --ADD BY LAIHAIQIANG 20220516
        ON CC1.ORG_ID = A.HDL_ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST BB --机构表 --MODIFY BY LAIHAIQIANG 20220516 A.ORG_ID改为 C1.ORG_ID1
        ON BB.ORG_ID = NVL(CC1.ORG_ID1,'800')
       AND BB.DATA_DT = V_MONTH_END_DATEID
      --MODFY BY LIUYU 由于总账会计科目表只报送三级科目，需要截取后关联取三级科目号和名称
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(E.SUBJ_ID,1,8) --科目报送到三级
       AND D.DATA_DT = V_MONTH_END_DATEID
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_TYP
       AND CODE1.SRC_CLASS_CODE = 'D0121' --交易类型
       AND CODE1.TAR_CLASS_CODE = 'D0121' --交易类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.TAR_VALUE_CODE = A.TRA_CHAN
       AND CODE5.SRC_CLASS_CODE = 'Z0014' --交易渠道
       AND CODE5.TAR_CLASS_CODE = 'Z0014' --交易渠道
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表
        ON CODE6.SRC_VALUE_CODE = A.AGT_CRDL_TYP
       AND CODE6.SRC_CLASS_CODE = 'C0001' --代办人证件类别
       AND CODE6.TAR_CLASS_CODE = 'C0001' --代办人证件类别
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*A.CORP_IND_FLG = '1' --对私
       AND*/ A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '个人存款分户账明细记录--插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT /*APPEND*/ INTO RRP_EAST.EAST5_404_GRCKFHZMX
      (RID, --主键
       JYXLH, --交易序列号
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YWBLJGH, --业务办理机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       GRCKZH, --个人存款账号
       WBZH, --外部账号
       JYLX, --交易类型
       JYJDBZ, --交易借贷标志
       HXJYRQ, --核心交易日期
       HXJYSJ, --核心交易时间
       BZ, --币种
       JYJE, --交易金额
       ZHYE, --账户余额
       DFZH, --对方账号
       DFHM, --对方户名
       DFXH, --对方行号
       DFXM, --对方行名
       ZY, --摘要
       FY, --附言
       CBMBZ, --冲补抹标志
       XZBZ, --现转标志
       JYQD, --交易渠道
       IPDZ, --IP地址
       MACDZ, --MAC地址
       DBRXM, --代办人姓名
       DBRZJLB, --代办人证件类别
       DBRZJHM, --代办人证件号码
       JYGYH, --交易柜员号
       SQGYH, --授权柜员号
       BBZ, --备注
       DEPT_NO, --部门编号
       CJRQ, --采集日期
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       DBRXM_ORIG, --代办人姓名（脱敏前）
       DBRZJHM_ORIG, --代办人证件号码（脱敏前）
       ZJHM_ORIG, --证件号码（脱敏前）
       ZHMC_ORIG, --账户名称（脱敏前）
       DFHM_OTH, --对方户名是否自然人名称
       DFHM_ORIG, --对方户名（脱敏前）
       GSFZJG --归属分支机构
       )
    SELECT A.RID                                                  AS RID, --主键
           A.JYXLH                                                AS JYXLH, --交易序列号
           A.JRXKZH                                               AS JRXKZH, --金融许可证号
           A.NBJGH                                                AS NBJGH, --内部机构号
           A.YWBLJGH                                              AS YWBLJGH, --业务办理机构号
           A.YHJGMC                                               AS YHJGMC, --银行机构名称
           A.MXKMBH                                               AS MXKMBH, --明细科目编号
           A.MXKMMC                                               AS MXKMMC, --明细科目名称
           A.KHTYBH                                               AS KHTYBH, --客户统一编号
           A.ZHMC                                                 AS ZHMC, --账户名称
           A.ZJLB                                                 AS ZJLB, --证件类别
           A.ZJHM                                                 AS ZJHM, --证件号码
           A.GRCKZH                                               AS GRCKZH, --个人存款账号
           A.WBZH                                                 AS WBZH, --外部账号
           A.JYLX                                                 AS JYLX, --交易类型
           A.JYJDBZ                                               AS JYJDBZ, --交易借贷标志
           A.HXJYRQ                                               AS HXJYRQ, --核心交易日期
           A.HXJYSJ                                               AS HXJYSJ, --核心交易时间
           A.BZ                                                   AS BZ, --币种
           A.JYJE                                                 AS JYJE, --交易金额
           A.ZHYE                                                 AS ZHYE, --账户余额
           A.DFZH                                                 AS DFZH, --对方账号
           CASE WHEN A.DFHM_OTH = '是' --ADD BY LIP 20241018
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.DFHM_ORIG,'[[:punct:]]',''), 0))
                WHEN REGEXP_REPLACE(TRIM(A.DFHM_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.DFHM_ORIG),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.DFHM_ORIG,'(','（'),')','）'),' ',''))
                ELSE TRIM(A.DFHM_ORIG)
            END                                                   AS DFHM, --对方户名 --MODIFY BY LIP
           TRIM(A.DFXH)                                           AS DFXH, --对方行号
           --A.DFXM                                                 AS DFXM, --对方行名
           CASE WHEN TRIM(A.DFXM) IS NOT NULL THEN TRIM(A.DFXM)
                WHEN A.DFXH = '313586000006' THEN '广东华兴银行股份有限公司'
            END                                                   AS DFXM, --对方行名 --MODIFY BY LIP 202207
           --A.ZY                                                   AS ZY, --摘要
           --TRIM(SUBSTRB(A.FY,1,400))                              AS FY, --附言
           TRIM(REPLACE(REPLACE(A.ZY,CHR(10),''),CHR(13),''))     AS ZY, --摘要
           TRIM(SUBSTRB(REPLACE(REPLACE(A.FY,CHR(10),''),CHR(13),''),1,400)) AS FY, --附言
           A.CBMBZ                                                AS CBMBZ, --冲补抹标志
           A.XZBZ                                                 AS XZBZ, --现转标志
           --A.JYQD                                                 AS JYQD, --交易渠道
           --CASE WHEN A.JYQD LIKE '第三方支付%' THEN REPLACE(A.JYQD,'第三方支付','三方支付')
           CASE WHEN A.JYQD LIKE '三方支付%' THEN REPLACE(A.JYQD,'三方支付','第三方支付')
                WHEN A.JYQD IS NOT NULL THEN A.JYQD
            END                                                   AS JYQD, --交易渠道 --MODIFY BY LIP
           A.IPDZ                                                 AS IPDZ, --IP地址
           A.MACDZ                                                AS MACDZ, --MAC地址
           --RRP_MDL.FUN_DESENSITIZATION(A.DBRXM_ORIG, 0)           AS DBRXM, --代办人姓名
           CASE WHEN TRIM(A.DBRXM_ORIG) IS NOT NULL
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.DBRXM_ORIG,'[[:punct:]]',''), 0))
            END                                                   AS DBRXM, --代办人姓名 --MODIFY BY LIP
           CASE WHEN TRIM(A.DBRZJLB) IS NOT NULL THEN A.DBRZJLB
            END                                                   AS DBRZJLB, --代办人证件类别 --MODIFY BY LIP
           /*LPAD(A.DBRZJHM_ORIG,6,'0') || RRP_MDL.SM3_ENCRYPT(RRP_MDL.FUN_DESENSITIZATION(A.DBRXM_ORIG, 1) ||
                 UPPER(A.DBRZJHM_ORIG))                           AS DBRZJHM, --代办人证件号码*/
           --MODIFY BY LIP 证件号脱敏，判断名字中是否有特殊字符
           CASE WHEN TRIM(A.DBRXM_ORIG) IS NOT NULL AND TRIM(A.DBRZJHM_ORIG) IS NOT NULL THEN
                --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
                CASE WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 6 THEN TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                     WHEN LENGTHB(TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(A.DBRXM_ORIG,1,6))
                 END||RRP_EAST.SM3_ENCRYPT(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.DBRXM_ORIG,'[[:punct:]]',''), 1) ||
                            UPPER(A.DBRZJHM_ORIG))
            END                                                    AS DBRZJHM, --代办人证件号码
           TRIM(A.JYGYH)                                           AS JYGYH, --交易柜员号
           TRIM(A.SQGYH)                                           AS SQGYH, --授权柜员号
           A.BBZ                                                   AS BBZ, --备注
           A.DEPT_NO                                               AS DEPT_NO, --部门编号
           A.CJRQ                                                  AS CJRQ, --采集日期
           A.SRC_SYS_ID                                            AS SRC_SYS_ID, --来源系统ID
           A.ISSUED_NO                                             AS ISSUED_NO, --填报机构
           A.ORG_NO                                                AS ORG_NO, --报送机构
           A.ADDRESS                                               AS ADDRESS, --归属地
           A.DBRXM_ORIG                                            AS DBRXM_ORIG, --代办人姓名（脱敏前）
           A.DBRZJHM_ORIG                                          AS DBRZJHM_ORIG, --代办人证件号码（脱敏前）
           A.ZJHM_ORIG                                             AS ZJHM_ORIG, --证件号码（脱敏前）
           A.ZHMC_ORIG                                             AS ZHMC_ORIG, --账户名称（脱敏前）
           A.DFHM_OTH                                              AS DFHM_OTH, --对方户名是否自然人名称
           --A.DFHM_ORIG                                             AS DFHM_ORIG, --对方户名（脱敏前）
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.DFHM_ORIG),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.DFHM_ORIG),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.DFHM_ORIG,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(A.DFHM_ORIG,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(A.DFHM_ORIG)
            END                                                    AS DFHM_ORIG, --对方户名（脱敏前）
           A.GSFZJG                                                AS GSFZJG --归属分支机构
      FROM RRP_EAST.EAST5_404_GRCKFHZMX_TMP A;

      V_SQLCOUNT := SQL%ROWCOUNT;
      V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
      O_ERRCODE  := '0';
      V_ENDTIME  := SYSDATE;
      COMMIT;
      ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

      V_ETL_DATE := V_ETL_DATE + 1;
    END LOOP;

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT JYXLH,ZJHM,GRCKZH,HXJYRQ,HXJYSJ,CJRQ,COUNT(1)
      FROM RRP_EAST.EAST5_404_GRCKFHZMX T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY JYXLH,ZJHM,GRCKZH,HXJYRQ,HXJYSJ,CJRQ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    IF V_COUNT > 0 THEN
      O_ERRCODE := '1';
      V_ENDTIME := SYSDATE;
      V_SQLMSG  := '数据重复';
      ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
      RETURN;
    END IF;

    --表分析
    V_STEP := V_STEP + 1;
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

  V_STEP    := V_STEP + 1;
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

END ETL_EAST5_404_GRCKFHZMX;
/

