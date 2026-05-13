CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_902_BHYXYZB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_902_BHYXYZB
  *  功能描述：保函与信用证表
  *  创建日期：20220713
  *  开发人员：王锐
  *  来源表： M_LOAN_LGLC_INFO    --保函与信用证信息表
              M_PUM_ORG_INFO_EAST --机构表
              M_GL_INFO           --总账会计科目信息表
              M_CUST_CORP_INFO    --对公客户信息
              CODE_MAP            --码值配置表
              CONFIG_ORG_REL      --机构级次关系表
              CONFIG_TABLE_LIST   --分行报送报表配置表
  *  目标表： EAST5_902_BHYXYZB --保函与信用证表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *  20230424  LIP        根据严希婧口径修改保证金相关字段：涉及信用风险仍在银行的销售协议，没有保证金，填写默认值0
  ***************************************************************************/
AS
  V_P_DATE             VARCHAR2(8);    --数据日期
  V_MONTH_START_DATEID VARCHAR2(8);    --本月月初日期
  V_MONTH_END_DATEID   VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME     VARCHAR2(100);  --分区名称
  V_FREQ_FLAG          VARCHAR2(10);   --跑批频度
  V_STEP               INTEGER := 0;   --任务号
  V_COUNT              INTEGER := 0;   --数据记录条数
  V_STARTTIME          DATE := SYSDATE;--处理开始时间
  V_ENDTIME            DATE := SYSDATE;--处理结束时间
  V_SQLCOUNT           INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG             VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC          VARCHAR2(100);  --处理步骤描述
  V_TABLE_NAME         VARCHAR2(100) := 'EAST5_902_BHYXYZB'; --表名称
  V_PROC_NAME          VARCHAR2(100) := 'ETL_EAST5_902_BHYXYZB'; --存储过程名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_START_DATEID := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');
  V_MONTH_END_DATEID   := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME     := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG          := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --支持重跑
    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

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
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

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
    INSERT INTO RRP_EAST.EAST5_902_BHYXYZB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       HTBH, --合同编号
       YWZL, --业务种类
       XYZBZDM, --币种
       XYZJE, --合同金额
       YDFJE, --已兑付金额
       XYZYE, --待支付金额
       KTQSRQ, --合同起始日期
       KTDQRQ, --合同到期日期
       SQRBH, --申请人编号
       SQRMC, --申请人名称
       SQRGJDM, --申请人国家代码
       SYRMC, --受益人名称
       SYRGJDM, --受益人国家代码
       SYRZH, --受益人开户行账号
       SYRKHHMC, --受益人开户行名称
       ZFQX, --支付期限
       HTMYBJ, --合同贸易背景
       SXFJE, --手续费金额
       SXFBZ, --手续费币种
       BZJBL, --保证金比例
       BZJBZ, --保证金币种
       BZJJE, --保证金金额
       HTZT, --合同状态
       JBYGH, --经办人工号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       SQRMC_ORIG, --申请人名称（脱敏前）
       SYRMC_ORIG, --受益人名称（脱敏前）
       SQRMC_OTH, --申请人是否个人
       SYRMC_OTH, --受益人是否个人
       GSFZJG, --归属分支机构
       XDJJH --信贷借据号
       )
      WITH LOAN_IN_DUBILL_INFO AS (
    SELECT T.ORIG_RCPT_NO,MAX(T.RCPT_STAT) RCPT_STAT,SUM(T.LOAN_BAL) LOAN_BAL
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO T
     WHERE T.EAST_FLG = 'Y'
       AND T.AD_CSH_FLG = '0'
       AND T.LOAN_BIZ_TYP LIKE '0205%' --垫款
       AND T.DATA_DT = V_P_DATE
     GROUP BY T.ORIG_RCPT_NO)
    SELECT SYS_GUID()                                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                                     AS JRXKZH, --金融许可证号
           B.ORG_ID                                                            AS NBJGH, --内部机构号
           B.ORG_NM                                                            AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                               AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                                           AS MXKMMC, --明细科目名称
           --REPLACE(REPLACE(A.CONT_ID,CHR(10),''),CHR(13),'')                   AS HTBH, --合同编号
           --MOD BY LIP 20230620 调整合同编号字段的取数口径
           CASE WHEN A.OUT_BIZ_TYP = 'A0401' THEN A.CONT_ID
                ELSE A.BIZ_ID
            END                                                                AS HTBH, --合同编号
           CASE WHEN A.LC_TYP = '01'         THEN '国内信用证'
                WHEN A.LC_TYP = '02'         THEN '国际信用证'
                WHEN A.OUT_BIZ_TYP = 'A0202' THEN '备用信用证'
                WHEN A.OUT_BIZ_TYP = 'A0301' THEN '融资性保函'
                WHEN A.OUT_BIZ_TYP = 'A0302' THEN '非融资性保函'
                WHEN A.OUT_BIZ_TYP = 'A0401' THEN '销售协议'
                WHEN A.OUT_BIZ_TYP = 'A040101' THEN '销售协议' --票据转贴现卖断未到期 --ADD BY LIP 20240423 根据资本新规相关报表统计口径要求增加
                WHEN A.OUT_BIZ_TYP = 'A0402' THEN '购买协议'
                WHEN A.OUT_BIZ_TYP = 'A0201' THEN '提货担保'
                ELSE'其他-' || REPLACE(CODE1.TAR_VALUE_NAME, '其他-', '')
            END                                                                AS YWZL, --业务种类
           A.CUR                                                               AS XYZBZDM, --币种
           A.CONT_AMT                                                          AS XYZJE, --合同金额
           A.ALDY_CASH_AMT                                                     AS YDFJE, --已兑付金额
           A.TD_PAY_AMT                                                        AS XYZYE, --待支付金额
           NVL(A.CONT_START_DT, '99991231')                                    AS KTQSRQ, --合同起始日期
           NVL(A.CONT_EXP_DT, '99991231')                                      AS KTDQRQ, --合同到期日期
           REPLACE(REPLACE(A.APP_PSN_ID,CHR(10),''),CHR(13),'')                AS SQRBH, --申请人编号
           --REPLACE(REPLACE(A.APP_PSN_NM,CHR(10),''),CHR(13),'')                AS SQRMC, --申请人名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(CASE WHEN REGEXP_REPLACE(TRIM(A.APP_PSN_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.APP_PSN_NM),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(A.APP_PSN_NM,CHR(10),''),CHR(13),'')
            END)                                                               AS SQRMC, --申请人名称
           NVL(D.REGD_LAND_CTRY_CD,'CHN')                                      AS SQRGJDM, --申请人国家代码
           --REPLACE(REPLACE(A.BNF_NM,CHR(10),''),CHR(13),'')                    AS SYRMC, --受益人名称
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(CASE WHEN REGEXP_REPLACE(TRIM(A.BNF_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.BNF_NM),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(A.BNF_NM,CHR(10),''),CHR(13),'')
            END)                                                               AS SYRMC, --受益人名称
           TRIM(REPLACE(REPLACE(A.BNF_CTRY_CD,CHR(10),''),CHR(13),''))         AS SYRGJDM, --受益人国家代码
           TRIM(REPLACE(REPLACE(A.BNF_ACC,CHR(10),''),CHR(13),''))             AS SYRZH, --受益人开户行账号
           TRIM(REPLACE(REPLACE(A.BNF_OPEN_BANK_NM,CHR(10),''),CHR(13),''))    AS SYRKHHMC, --受益人开户行名称
           A.APP_PSN_PAY_TERM                                                  AS ZFQX, --支付期限
           TRIM(REPLACE(REPLACE(A.CONT_TRA_BKGD,CHR(10),''),CHR(13),''))       AS HTMYBJ, --合同贸易背景
           A.COMM_AMT                                                          AS SXFJE, --手续费金额
           DECODE(A.COMM_CUR,'-','',TRIM(A.COMM_CUR))                          AS SXFBZ, --手续费币种
           /*A.MRGN_PCT                                                          AS BZJBL, --保证金比例
           A.MRGN_CUR                                                          AS BZJBZ, --保证金币种
           A.COMM_AMT                                                          AS BZJJE, --保证金金额*/
           --MOD BY LIP 20230424 销售协议保证金为空时默认为0
           CASE WHEN A.MRGN_PCT IS NOT NULL THEN A.MRGN_PCT
                WHEN A.OUT_BIZ_TYP = 'A0401' THEN 0
            END                                                                AS BZJBL, --保证金比例
           CASE WHEN DECODE(A.MRGN_CUR,'-','',TRIM(A.MRGN_CUR)) IS NOT NULL THEN A.MRGN_CUR
                WHEN A.OUT_BIZ_TYP = 'A0401' THEN DECODE(A.CUR,'-','',TRIM(A.CUR))
            END                                                                AS BZJBZ, --保证金币种
           CASE WHEN A.COMM_AMT IS NOT NULL THEN A.COMM_AMT
                WHEN A.OUT_BIZ_TYP = 'A0401' THEN 0
            END                                                                AS BZJJE, --保证金金额
           CASE WHEN DK.ORIG_RCPT_NO IS NOT NULL AND DK.RCPT_STAT = 'C0201' THEN '核销' --MOD BY LIP 20250820
                WHEN DK.ORIG_RCPT_NO IS NOT NULL THEN '垫款' --MOD BY LIP 20250820
                WHEN A.CONT_STAT = '01' THEN '未生效'
                WHEN A.CONT_STAT = '02' THEN '正常'
                WHEN A.CONT_STAT = '06' THEN '撤销'
                WHEN A.CONT_STAT = '07' THEN '终结'
                WHEN A.CONT_STAT = '03' THEN '失效'
                WHEN A.CONT_STAT = '04' THEN '垫款'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME, '其他-', ''),1,40))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME, '其他-', ''),1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                                AS HTZT, --合同状态
           --A.HDLR_NO                                                           AS JBYGH, --经办人工号
           CASE WHEN E.EMP_ID IS NOT NULL THEN E.EMP_ID
                ELSE A.HDLR_NO
            END                                                                AS JBYGH, --经办人工号
           ''                                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                                  AS CJRQ, --采集日期
           '000'                                                               AS DEPT_NO, --部门编号
           '01'                                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                                            AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                                AS ADDRESS, --归属地
           /*A.APP_PSN_NM                                                        AS SQRMC_ORIG, --申请人名称（脱敏前）
           A.BNF_NM                                                            AS SYRMC_ORIG, --受益人名称（脱敏前）*/
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           TRIM(CASE WHEN REGEXP_REPLACE(TRIM(A.APP_PSN_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.APP_PSN_NM),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(A.APP_PSN_NM,CHR(10),''),CHR(13),'')
            END)                                                               AS SQRMC_ORIG, --申请人名称（脱敏前）
           TRIM(CASE WHEN REGEXP_REPLACE(TRIM(A.BNF_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.BNF_NM),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(A.BNF_NM,CHR(10),''),CHR(13),'')
            END)                                                               AS SYRMC_ORIG, --受益人名称（脱敏前）
           '否'                                                                AS SQRMC_OTH, --申请人是否个人
           '否'                                                                AS SYRMC_OTH, --受益人是否个人
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                                AS GSFZJG,--归属分支机构
           A.DUBIL_ID                                                          AS XDJJH --信贷借据号  --modify by tangan at 20230201
      FROM RRP_MDL.M_LOAN_LGLC_INFO A --保函与信用证信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG K --机构映射表  modify by tangan at 20221108 添加机构映射
        ON K.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(K.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.APP_PSN_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CONT_STAT
       AND CODE.SRC_CLASS_CODE = 'D0117' --合同状态
       AND CODE.TAR_CLASS_CODE = 'D0117' --合同状态
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.OUT_BIZ_TYP
       AND CODE1.SRC_CLASS_CODE = 'T0002' --业务种类
       AND CODE1.TAR_CLASS_CODE = 'T0002' --业务种类
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.ADD_EMP_TLR E
        ON E.TLR_NO = A.HDLR_NO
      --ADD BY LIP 20230707 根据王璐口径：表内中垫款还未结清的也采集
      LEFT JOIN LOAN_IN_DUBILL_INFO DK
        ON DK.ORIG_RCPT_NO = A.DUBIL_ID
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (NVL(A.ACT_EXP_DT,'99991231') >= V_MONTH_START_DATEID
            OR A.BAL > 0 OR DK.ORIG_RCPT_NO IS NOT NULL) --MOD BY LIP 20241210 调整为实际到期日过滤数据
       --(NVL(A.CONT_EXP_DT,'99991231') >= V_MONTH_START_DATEID OR A.BAL > 0 OR DK.ORIG_RCPT_NO IS NOT NULL) --表内垫款未还清的数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --删除销售协议中终结数据 --MOD BY LIP 20250213 根据严希婧口径调整
    V_STEP := V_STEP + 1 ;
    V_STEP_DESC := '删除销售协议中终结数据';
    V_STARTTIME := SYSDATE;
    DELETE FROM RRP_EAST.EAST5_902_BHYXYZB T WHERE YWZL = '销售协议' AND HTZT = '终结' AND CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '判断数据是否重复';
    V_STARTTIME := SYSDATE;
    WITH TMP1 AS (
    SELECT CJRQ,HTBH,XYZBZDM,COUNT(1)
      FROM RRP_EAST.EAST5_902_BHYXYZB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,HTBH,XYZBZDM
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_902_BHYXYZB(CJRQ,HTBH,XYZBZDM)数据重复';
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

  --判断跑批是否完成
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

END ETL_EAST5_902_BHYXYZB;
/

