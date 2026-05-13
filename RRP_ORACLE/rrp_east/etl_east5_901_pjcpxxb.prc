CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_901_PJCPXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_901_PJCPXXB
  *  功能描述：票据出票信息表
  *  创建日期：20220713
  *  开发人员：王锐
  *  来源表： M_LOAN_BILL_INFO   票据出票表
              M_PUM_ORG_INFO_EAST   机构表
              M_GL_INFO      总账会计科目信息表
              CODE_MAP   码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_901_PJCPXXB 票据出票信息表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *  20221128  LHQ        取结清日期大于等于当期的数据
  ***************************************************************************/
AS
  --定义变量
  V_P_DATE         VARCHAR2(8);           --跑批数据日期
  V_STEP_DESC      VARCHAR2(100);         --处理步骤描述
  V_STEP           INTEGER := 0;          --处理步骤
  V_SQLCOUNT       INTEGER := 0;          --更新或删除影响的记录数
  V_COUNT          INTEGER := 0;          --数据记录条数
  V_STARTTIME      DATE := SYSDATE;       --处理开始时间
  V_ENDTIME        DATE := SYSDATE;       --处理结束时间
  V_SQLMSG         VARCHAR2(300);         --SQL执行描述信息
  V_LAST_DAT       VARCHAR2(8);           --当月月末
  V_FREQ_FLAG      VARCHAR2(10);          --跑批频度
  V_PARTITION_NAME VARCHAR2(100);         --分区名
  V_PROC_NAME      VARCHAR2(30) := 'ETL_EAST5_901_PJCPXXB'; --程序名称
  V_TABLE_NAME     VARCHAR2(100):= 'EAST5_901_PJCPXXB'; --表名称
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  O_ERRCODE := '0';
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(V_P_DATE,V_PROC_NAME); --跑批频度判断
  V_PARTITION_NAME := 'PARTITION_'||V_P_DATE;

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    --增加分区
    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_LAST_DAT,V_TABLE_NAME,1,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --删除当日分区数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_LAST_DAT,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --加工程序
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入结果表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_901_PJCPXXB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      MXKMBH,      --明细科目编号
      MXKMMC,      --明细科目名称
      PJHM,        --票据号码
      PJLX,        --票据类型
      BZ,          --币种
      PMJE,        --票面金额
      PJCPRQ,      --票据出票日期
      PJDQRQ,      --票据到期日期
      CPRBH,       --出票人编号
      CPRMC,       --出票人名称
      CPRZH,       --出票人账号
      CPRKHHMC,    --出票人开户行名称
      SKRMC,       --收款人名称
      SKRZH,       --收款人账号
      SKRKHHMC,    --收款人开户行名称
      SFZBHTX,     --是否在本行贴现
      MYBJ,        --贸易背景
      SXFBZ,       --其他费用币种
      SXFJE,       --其他费用金额
      BZJBL,       --保证金比例
      BZJBZ,       --保证金币种
      BZJJE,       --保证金金额
      BZJZH,       --保证金账号
      PJZT,        --票据状态
      JBYGH,       --经办人工号
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      CPRMC_ORIG,  --出票人名称（脱敏前）
      SKRMC_ORIG,  --收款人账号（脱敏前）
      CPRMC_OTH,   --出票人是否个人
      SKRMC_OTH,   --收款人是否个人
      GSFZJG       --归属分支机构
      )
      WITH LOAN_IN_DUBILL_INFO AS (
    SELECT T.ORIG_RCPT_NO,MAX(T.RCPT_STAT) RCPT_STAT,SUM(T.LOAN_BAL) LOAN_BAL
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
     WHERE T.EAST_FLG = 'Y'
       AND T.AD_CSH_FLG = '0'
       AND T.LOAN_BIZ_TYP LIKE '0205%' --垫款
       AND T.DATA_DT = V_P_DATE
     GROUP BY T.ORIG_RCPT_NO)
    SELECT SYS_GUID()                                                        AS RID,         --数据主键
           B.FIN_PERMIT_NO                                                   AS JRXKZH,      --金融许可证号
           B.ORG_ID                                                          AS NBJGH,       --内部机构号
           B.ORG_NM                                                          AS YHJGMC,      --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                             AS MXKMBH,      --明细科目编号
           C.SUBJ_NM                                                         AS MXKMMC,      --明细科目名称
           REPLACE(REPLACE(A.BILL_NO,CHR(10),''),CHR(13),'')                 AS PJHM,        --票据号码
           REPLACE(REPLACE(CODE.TAR_VALUE_NAME,CHR(10),''),CHR(13),'')       AS PJLX,        --票据类型
           REPLACE(REPLACE(A.CUR,CHR(10),''),CHR(13),'')                     AS BZ,          --币种
           A.BILL_PAR_AMT                                                    AS PMJE,        --票面金额
           NVL(A.BILL_ISU_DT, '99991231')                                    AS PJCPRQ,      --票据出票日期
           --MOD BY LIP 20230802 默认值改成从配置表中获取
           COALESCE(JP.PJDQRQ,A.BILL_EXP_DT,'99991231')                      AS PJDQRQ,      --票据到期日期
           REPLACE(REPLACE(A.DRAWER_ID,CHR(10),''),CHR(13),'')               AS CPRBH,       --出票人编号
           --MOD BY LIP 20230802 默认值改成从配置表中获取
           CASE WHEN REGEXP_REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),CHR(10),''),CHR(13),'')
            END                                                              AS CPRMC,       --出票人名称
           REPLACE(REPLACE(NVL(JP.CPRZH,A.DRAWER_ACC),CHR(10),''),CHR(13),'') AS CPRZH,      --出票人账号
           REPLACE(REPLACE(NVL(JP.CPRKHHMC,A.DRAWER_OPEN_BANK_NM),CHR(10),''),CHR(13),'') AS CPRKHHMC, --出票人开户行名称
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),CHR(10),''),CHR(13),'')
            END                                                              AS SKRMC,       --收款人名称
           REPLACE(REPLACE(NVL(JP.SKRZH,A.PAYEE_ACC),CHR(10),''),CHR(13),'') AS SKRZH,       --收款人账号
           REPLACE(REPLACE(NVL(JP.SKRKHHMC,A.PAYEE_OPEN_BANK_NM),CHR(10),''),CHR(13),'') AS SKRKHHMC, --收款人开户行名称
           --REPLACE(REPLACE(CODE1.TAR_VALUE_CODE,CHR(10),''),CHR(13),'')     AS SFZBHTX,      --是否在本行贴现
           CODE1.TAR_VALUE_NAME                                              AS SFZBHTX,     --是否在本行贴现 --MODIFY BY TANGAN AT 20221205
           TRIM(REPLACE(REPLACE(A.BILL_TRA_BKGD,CHR(10),''),CHR(13),''))     AS MYBJ,        --贸易背景
           A.OTH_COST_CUR                                                    AS SXFBZ,       --其他费用币种
           --A.OTH_COST_AMT                                                    AS SXFJE,       --其他费用金额
           NVL(A.OTH_COST_AMT,0)                                             AS SXFJE,       --其他费用金额
           NVL(A.MRGN_PCT,0)                                                 AS BZJBL,       --保证金比例
           DECODE(TRIM(A.MRGN_CUR),'-','',TRIM(A.MRGN_CUR))                  AS BZJBZ,       --保证金币种
           NVL(A.MRGN,0)                                                     AS BZJJE,       --保证金金额
           CASE WHEN TRIM(A.MRGN_ACC) = '/' THEN ''
                ELSE TRIM(A.MRGN_ACC)
             END                                                             AS BZJZH,       --保证金账号
           CASE WHEN DK.ORIG_RCPT_NO IS NOT NULL AND DK.RCPT_STAT = 'C0201' THEN '核销' --MOD BY LIP 20250820
                WHEN DK.ORIG_RCPT_NO IS NOT NULL THEN '垫款' --MOD BY LIP 20250820
                WHEN A.CURRT_BAL <> 0 THEN '正常'
                ELSE '解付'
            END                                                              AS PJZT,        --票据状态
           NVL(JP.JBYGH,A.HDLR_NO)                                           AS JBYGH,       --经办人工号
           ''                                                                AS BBZ,         --备注
           V_LAST_DAT                                                        AS CJRQ,        --采集日期
           '000'                                                             AS DEPT_NO,     --部门编号
           '01'                                                              AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                          AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                                  AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN  ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                              AS ADDRESS,     --归属地
           /*A.DRAWER_NM                                                       AS CPRMC_ORIG,  --出票人名称（脱敏前）
           A.PAYEE_NM                                                        AS SKRMC_ORIG,  --收款人账号（脱敏前）*/
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(NVL(JP.CPRMC,TRIM(A.DRAWER_NM)),CHR(10),''),CHR(13),'')
            END                                                              AS CPRMC_ORIG,  --出票人名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(NVL(JP.SKRMC,TRIM(A.PAYEE_NM)),CHR(10),''),CHR(13),'')
            END                                                              AS SKRMC_ORIG,  --收款人名称（脱敏前）
           '否'                                                              AS CPRMC_OTH,   --出票人是否个人
           '否'                                                              AS SKRMC_OTH,   --收款人是否个人
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                              AS GSFZJG       --归属分支机构
      FROM RRP_MDL.M_LOAN_BILL_INFO A --票据出票表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.BILL_BIZ_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.BANK_DISC_FLG
       AND CODE1.SRC_CLASS_CODE = 'Z0001' --是否在本行贴现
       AND CODE1.TAR_CLASS_CODE = 'Z0001' --是否在本行贴现
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.BILL_STAT
       AND CODE2.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE2.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE2.MOD_FLG = 'EAST'
      --ADD BY LIP 20230707 根据王璐口径：表内中垫款还未结清的也采集
      LEFT JOIN LOAN_IN_DUBILL_INFO DK
        ON DK.ORIG_RCPT_NO = A.RCPT_ID
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
      LEFT JOIN RRP_EAST.EAST5_901_PJCPXXB_JP JP --ADD BY LIP 20230802
        ON JP.PJHM = A.BILL_NO
     WHERE (A.BILL_EXP_DT >= SUBSTR(V_P_DATE,1,6)||'01' OR A.CURRT_BAL <> 0 --取票据到期日大于等于当期的数据
            OR DK.ORIG_RCPT_NO IS NOT NULL) --表内垫款未还清的数据
       AND A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,PJHM,COUNT(1)
      FROM RRP_EAST.EAST5_901_PJCPXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,PJHM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_901_PJCPXXB(CJRQ,PJHM)数据重复';
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

END ETL_EAST5_901_PJCPXXB;
/

