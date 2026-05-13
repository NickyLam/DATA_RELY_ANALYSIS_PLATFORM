CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_410_GRXDFHZMX(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_410_GRXDFHZMX
  *  功能描述：个人信贷分户账明细记录
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_TRA_LOAN_DTL
  *            M_LOAN_IN_DUBILL_INFO
  *            M_CUST_IND_INFO
  *            M_PUM_ORG_INFO_EAST
  *            M_GL_INFO
  *  目标表：  EAST5_410_GRXDFHZMX
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期     修改人      修改项目
  *  20220511     LIP         修改日志写入方式
  *  20221108     LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
  *  20230714     LIP         调整授权柜员号口径，当授权柜员号和交易柜员号相同时，将授权柜员号置空
  ***************************************************************************/
AS
  V_P_DATE         VARCHAR2(8);    --数据日期
  V_PARTITION_NAME VARCHAR2(100);  --分区名称
  V_FREQ_FLAG      VARCHAR2(10);   --跑批频度
  V_STEP           INTEGER := 0;   --任务号
  V_COUNT          INTEGER := 0;   --数据记录条数
  V_STARTTIME      DATE;           --处理开始时间
  V_ENDTIME        DATE;           --处理结束时间
  V_SQLCOUNT       INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG         VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC      VARCHAR2(100);  --处理步骤描述
  V_LAST_DAT       VARCHAR2(8);    --当月月末
  V_START_DAT      VARCHAR2(8);    --当月月初
  V_TABLE_NAME     VARCHAR2(100) := 'EAST5_410_GRXDFHZMX'; --表名称
  V_PROC_NAME      VARCHAR2(100) := 'ETL_EAST5_410_GRXDFHZMX'; --存储过程名称
BEGIN
  V_P_DATE    := TO_CHAR(I_P_DATE);
  O_ERRCODE   := '0';
  V_LAST_DAT  := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_START_DAT := SUBSTR(V_P_DATE,1,6)||'01'; --当月月初
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --新建分区
    V_STEP := 1;
    V_STEP_DESC := '新建分区';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_LAST_DAT,V_TABLE_NAME,1,O_ERRCODE); --新建分区

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '分区表的重跑处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_TRUNCATE(V_LAST_DAT,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理个人信贷分户账明细记录';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_410_GRXDFHZMX(
      RID, --数据主键
      JYXLH, --交易序列号
      YWBLJGH, --业务办理机构号
      JRXKZH, --金融许可证号
      NBJGH, --内部机构号
      YHJGMC, --银行机构名称
      MXKMBH, --明细科目编号
      MXKMMC, --明细科目名称
      KHTYBH, --客户统一编号
      ZHMC, --账户名称
      ZJLB, --证件类别
      ZJHM, --证件号码
      DKFHZH, --贷款分户账号
      XDJJH, --信贷借据号
      HXJYRQ, --核心交易日期
      HXJYSJ, --核心交易时间
      JYLX, --交易类型
      JYJDBZ, --交易借贷标志
      BZ, --币种
      JYJE, --交易金额
      ZHYE, --账户余额
      DFZH, --对方账号
      DFHM, --对方户名
      DFXH, --对方行号
      DFXM, --对方行名
      ZY, --摘要
      JYQD, --交易渠道
      CBMBZ, --冲补抹标志
      DBRXM, --代办人姓名
      DBRZJLB, --代办人证件类别
      DBRZJHM, --代办人证件号码
      JYGYH, --交易柜员号
      SQGYH, --授权柜员号
      XZBZ, --现转标志
      BBZ, --备注
      CJRQ, --采集日期
      DEPT_NO, --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO, --填报机构
      ORG_NO, --报送机构
      ADDRESS, --归属地
      DBRXM_ORIG, --代办人姓名（脱敏前）
      DBRZJHM_ORIG, --代办人证件号码（脱敏前）
      DFHM_ORIG, --对方户名（脱敏前）
      ZHMC_ORIG, --账户名称（脱敏前）
      ZJHM_ORIG, --证件号码（脱敏前）
      DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
      GSFZJG --归属分支机构
      )
    SELECT /*+USE_HASH(A,DUB,C,B,D,CODE,CODE1,CODE2,CODE3,CODE4,CODE5,CODE6,ORG,LIST)*/
           SYS_GUID()                                               AS RID, --数据主键
           A.TRA_SEQ_NO||A.REPAY_PERDS||A.DTL_SEQ_NUM               AS JYXLH, --交易序列号
           --A.TRA_ORG_ID                                             AS YWBLJGH, --业务办理机构号
           BB.ORG_ID                                                AS YWBLJGH, --业务办理机构号
           B.FIN_PERMIT_NO                                          AS JRXKZH, --金融许可证号
           --A.ORG_ID                                                 AS NBJGH, --内部机构号
           B.ORG_ID                                                 AS NBJGH, --内部机构号
           B.ORG_NM                                                 AS YHJGMC, --银行机构名称
           --SUBSTR(A.SUBJ_ID,1,8)                                    AS MXKMBH, --明细科目编号
           SUBSTR(DUB.SUBJ_ID,1,8)                                  AS MXKMBH, --明细科目编号
           D.SUBJ_NM                                                AS MXKMMC, --明细科目名称
           --A.CUST_ID                                                AS KHTYBH, --客户统一编号
           DUB.CUST_ID                                              AS KHTYBH, --客户统一编号
           C.CUST_NM_DESEN                                          AS ZHMC, --账户名称
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))                  AS ZJLB, --证件类别
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))                  AS ZJLB, --证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           C.CRDL_NO_DESEN                                          AS ZJHM, --证件号码 --modify by laihaiqiang at 20230403
           --A.RCPT_ID                                                AS DKFHZH, --贷款分户账号
           --A.ACC_ID                                                 AS DKFHZH, --贷款分户账号
           DUB.ACC_ID                                               AS DKFHZH, --贷款分户账号 MODIFY BY LIP 20220502
           A.RCPT_ID                                                AS XDJJH, --信贷借据号
           A.TRA_DT                                                 AS HXJYRQ, --核心交易日期
           NVL(TO_CHAR(A.TRA_TM,'HH24MISS'),'000000')               AS HXJYSJ, --核心交易时间
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))                 AS JYLX, --交易类型
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))                 AS JYLX, --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE2.TAR_VALUE_NAME                                     AS JYJDBZ, --交易借贷标志
           A.CUR                                                    AS BZ, --币种
           A.TRA_AMT                                                AS JYJE, --交易金额
           A.ACC_BAL                                                AS ZHYE, --账户余额
           A.OPP_ACC                                                AS DFZH, --对方账号
           /*SUBSTRB(A.OPP_ACC_NM, LENGTHB(A.OPP_ACC_NM) - 2, 3)*/
           CASE WHEN TRIM(A.OPP_ACC_NM) IS NOT NULL
                THEN CASE WHEN LENGTH(TRIM(A.OPP_ACC_NM)) = LENGTHB(TRIM(A.OPP_ACC_NM))
                          THEN SUBSTR(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]','')) - 2, 3)
                          WHEN LENGTH(TRIM(A.OPP_ACC_NM)) > 3
                          --THEN TRIM(A.OPP_ACC_NM)
                          THEN CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                                    THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                                    ELSE TRIM(A.OPP_ACC_NM)
                                END
                          ELSE SUBSTR(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''), LENGTH(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]','')), 1)
                      END
            END                                                     AS DFHM, --对方户名
           A.OPP_PBC_NO                                             AS DFXH, --对方行号
           A.OPP_BANK_NM                                            AS DFXM, --对方行名
           --A.ABSTR                                                  AS ZY, --摘要
           REPLACE(REPLACE(TRIM(A.ABSTR),CHR(10),''),CHR(13),'')    AS ZY, --摘要
           --CODE5.TAR_VALUE_NAME                                     AS JYQD, --交易渠道
           TRIM(SUBSTRB(CASE WHEN CODE5.TAR_VALUE_NAME LIKE '三方支付%'
                             THEN REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付')
                             ELSE CODE5.TAR_VALUE_NAME
            --END,1,40))                                              AS JYQD, --交易渠道 --MODIFY BY LIP
            END,1,60))                                              AS JYQD, --交易渠道 --MODIFY BY LIP 20240409 改为UTF-8的长度
           --TRIM(SUBSTRB(CODE3.TAR_VALUE_NAME,1,40))                 AS CBMBZ, --冲补抹标志
           TRIM(SUBSTRB(CODE3.TAR_VALUE_NAME,1,60))                 AS CBMBZ, --冲补抹标志 --MODIFY BY LIP 20240409 改为UTF-8的长度
           /*SUBSTRB(A.AGT_NM, LENGTHB(A.AGT_NM) - 2, 3)*/
           CASE WHEN TRIM(A.AGT_NM) IS NOT NULL
                --THEN RRP_MDL.FUN_DESENSITIZATION(A.AGT_NM,0)
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.AGT_NM),'[[:punct:]]',''),0))
            END                                                     AS DBRXM, --代办人姓名
           --TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,40))                 AS DBRZJLB, --代办人证件类别
           TRIM(SUBSTRB(CODE6.TAR_VALUE_NAME,1,60))                 AS DBRZJLB, --代办人证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN TRIM(A.AGT_CRDL_NO) IS NOT NULL THEN
             --MOD BY LIP 20240909 调整取身份证件号码UTF-8编码的前6个字节的取数口径
             CASE WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 6 THEN TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 5 THEN '0'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 4 THEN '00'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 3 THEN '000'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 2 THEN '0000'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 1 THEN '00000'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
                  WHEN LENGTHB(TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))) = 0 THEN '000000'||TRIM(SUBSTRB(A.AGT_CRDL_NO,1,6))
              END|| RRP_EAST.SM3_ENCRYPT(/*SUBSTRB(A.AGT_NM,1,3)*/
                    RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.AGT_NM),'[[:punct:]]',''),1)|| UPPER(A.AGT_CRDL_NO))
            END                                                     AS DBRZJHM, --代办人证件号码
           TRIM(A.TRA_TLR_NO)                                       AS JYGYH, --交易柜员号
           --A.GRANT_TLR_NO                                           AS SQGYH, --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           --CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40)) NOT IN ('柜面')
           CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
                THEN NULL
                ELSE TRIM(A.GRANT_TLR_NO)
            END                                                     AS SQGYH, --授权柜员号
           CODE4.TAR_VALUE_NAME                                     AS XZBZ, --现转标志
           CASE WHEN A.ABSTR = '核销' THEN '核销交易'
                WHEN A.ABSTR LIKE '%转让%' THEN '转让交易'
            END                                                     AS BBZ, --备注
           V_LAST_DAT                                               AS CJRQ, --采集日期
           '000'                                                    AS DEPT_NO, --部门编号
           '01'                                                     AS SRC_SYS_ID, --来源系统ID
           '000000'                                                 AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                         AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                     AS ADDRESS, --归属地
           A.AGT_NM                                                 AS DBRXM_ORIG, --代办人姓名（脱敏前）
           A.AGT_CRDL_NO                                            AS DBRZJHM_ORIG, --代办人证件号码（脱敏前）
           --A.OPP_ACC_NM                                             AS DFHM_ORIG, --对方户名（脱敏前）
           CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                     AS DFHM_ORIG, --对方户名（脱敏前）
           C.CUST_NM                                                AS ZHMC_ORIG, --账户名称（脱敏前）
           C.CRDL_NO                                                AS ZJHM_ORIG,--证件号码（脱敏前）
           /*CASE --WHEN A.DATA_SRC LIKE '%联合网贷%' THEN '联合网贷'
                WHEN DUB.LOAN_STD_PROD_ID = '202010100003' THEN '花呗'
                WHEN DUB.LOAN_STD_PROD_ID IN ('202010100006','202010100008','202020100003') THEN '微粒贷'
                WHEN DUB.LOAN_STD_PROD_ID IN ('202010100001','202010100002') THEN '借呗'
                WHEN DUB.LOAN_STD_PROD_ID IN ('202010100004','202010100005') THEN '京东'
                --ADD BY LIP 20230919 将网商贷债权直转的区分出来
                WHEN DUB.LOAN_PROD_NM LIKE '%债权直转%' THEN DUB.LOAN_PROD_NM
                WHEN DUB.LOAN_STD_PROD_ID IN ('202020100001','202020200004') THEN '网商贷'
                WHEN DUB.LOAN_STD_PROD_ID IN ('202020200001') THEN '字节小微贷' --MOD BY LIP 20250115
                WHEN DUB.LOAN_STD_PROD_ID IN ('201020100057') THEN '华兴快贷经营' --MOD BY LIP 20250115 房抵贷
                WHEN DUB.LOAN_STD_PROD_ID IN ('202010200011','202010200010') THEN DUB.LOAN_STD_PROD_NM --MOD BY LIP 20250917 分期乐
                WHEN DUB.DATA_SRC LIKE '%联合网贷%' THEN DUB.LOAN_STD_PROD_NM --MOD BY LIP 20250808
                WHEN DUB.DATA_SRC LIKE '%零售贷款%' THEN '行内自营贷款'
            END                                                     AS DKCPMC, --贷款产品名称 只用来区分行内外产品*/
           DUB.LOAN_STD_PROD_NM                                     AS DKCPMC, --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                     AS GSFZJG --归属分支机构
      FROM RRP_MDL.M_TRA_LOAN_DTL A --信贷账户交易流水
     INNER JOIN RRP_MDL.M_LOAN_IN_DUBILL_INFO DUB --表内借据信息 ADD BY LIP 20220502 用借据限制流水
        ON DUB.RCPT_ID = A.RCPT_ID
       AND NVL(DUB.CNCL_DT,'99991231') >= A.TRA_DT --过滤核销后收回的流水 ADD BY LIP 20230110
       AND DUB.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND DUB.DATA_DT = V_LAST_DAT
     /*INNER JOIN RRP_MDL.M_CUST_IND_INFO C --个人客户信息 MODIFY BY LIP 20220510*/
     INNER JOIN RRP_EAST.M_CUST_IND_INFO_EAST C --个人客户信息 MODIFY BY LIP 20220510
        ON C.CUST_ID = DUB.CUST_ID
       AND C.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.ORG_CONFIG CC1 --机构映射表 --ADD BY LIP 20230523
        ON CC1.ORG_ID = A.TRA_ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST BB --机构表 --ADD BY LIP 20230523
        ON BB.ORG_ID = NVL(CC1.ORG_ID1,'800')
       AND BB.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(DUB.SUBJ_ID,1,8)
       AND D.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_TYP
       AND CODE1.SRC_CLASS_CODE = 'CD1311' --交易类型
       AND CODE1.TAR_CLASS_CODE = 'D0121' --交易类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.TRA_DR_CR_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0017' --交易借贷标志
       AND CODE2.TAR_CLASS_CODE = 'Z0017' --交易借贷标志
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.FLUSH_PATCH_FLG
       AND CODE3.SRC_CLASS_CODE = 'D0128' --冲补抹标志
       AND CODE3.TAR_CLASS_CODE = 'D0128' --冲补抹标志
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.CASH_TRF_FLG
       AND CODE4.SRC_CLASS_CODE = 'Z0019' --现转标志
       AND CODE4.TAR_CLASS_CODE = 'Z0019' --现转标志
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.TRA_CHAN
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
     WHERE A.CORP_IND_FLG = '1' --对私
       AND A.TRA_DT <= V_LAST_DAT
       --AND A.TRA_DT >= V_START_DAT
       AND A.TRA_DT >= TO_CHAR(TO_DATE(V_START_DAT,'YYYYMMDD')-1,'YYYYMMDD') --MOD BY LIP 20230619 联合网贷数据T+2
       AND A.DATA_DT <= V_LAST_DAT
       AND A.DATA_DT >= V_START_DAT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,JYXLH,ZJHM,DKFHZH,XDJJH,HXJYRQ,HXJYSJ,COUNT(1)
      FROM RRP_EAST.EAST5_410_GRXDFHZMX T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,JYXLH,ZJHM,DKFHZH,XDJJH,HXJYRQ,HXJYSJ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_410_GRXDFHZMX(CJRQ,JYXLH,ZJHM,DKFHZH,XDJJH,HXJYRQ,HXJYSJ)数据重复';
       ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);
       RETURN;
    END IF;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表分析开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_DBMS_STATS(V_P_DATE,V_TABLE_NAME,V_PARTITION_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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

END ETL_EAST5_410_GRXDFHZMX;
/

