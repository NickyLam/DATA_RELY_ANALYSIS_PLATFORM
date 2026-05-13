CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_905_DLDXJYXXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_905_DLDXJYXXB
  *  功能描述：代理代销交易信息表
  *  创建日期：20220713
  *  开发人员：郑经超
  *  来源表： M_EAST_AGT_CPTL_DTL     代理代销交易信息表
              M_CUST_CORP_INFO        对公客户信息
              M_CUST_IND_INFO         个人客户信息
              M_PUM_ORG_INFO_EAST          机构表
              CODE_MAP CODE        码值配置表
              CONFIG_ORG_REL          机构级次关系表
              CONFIG_TABLE_LIST LIST  分行报送报表配置表
  *  目标表： EAST5_905_DLDXJYXXB     代理代销交易信息表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *  20230307   LHQ       根据银监发文第三期数据长度变更，从C..30变更为C..450，修改发行机构清算行名及融资人名称的字段长度。
  ***************************************************************************/
AS
  V_P_DATE           VARCHAR2(8);    --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);    --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);  --分区名称
  V_FREQ_FLAG        VARCHAR2(10);   --跑批频度
  V_STEP             INTEGER := 0;   --任务号
  V_COUNT            INTEGER := 0;   --数据记录条数
  V_STARTTIME        DATE := SYSDATE;--处理开始时间
  V_ENDTIME          DATE := SYSDATE;--处理结束时间
  V_SQLCOUNT         INTEGER := 0;   --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);  --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);  --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_905_DLDXJYXXB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_905_DLDXJYXXB'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --增加分区
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
    INSERT INTO RRP_EAST.EAST5_905_DLDXJYXXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       KHZH, --客户账号
       KHHMC, --开户行名称
       JYBH, --交易编号
       DLDXJYLX, --代理代销交易类型
       DXCPMC, --代销产品名称
       JYFX, --交易方向
       JYRQ, --交易日期
       BZ, --币种
       JYJE, --交易金额
       FXJGMC, --发行机构名称
       FXJGPJ, --发行机构评级
       FXJGPJJG, --发行机构评级机构
       FXJGQSZH, --发行机构清算账号
       FXJGQSHM, --发行机构清算行名
       RZRMC, --融资人名称
       RZRSSHY, --融资人所属行业
       SXFBZ, --手续费币种
       SXFJE, --手续费金额
       XZBZ, --现转标志
       JYYGH, --经办人工号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       KHMC_OTH, --客户是否个人客户
       GSFZJG, --归属分支机构
       BDH  --保单号
       )
    SELECT SYS_GUID()                                                   AS RID, --数据主键
           B.FIN_PERMIT_NO                                              AS JRXKZH, --金融许可证号
           B.ORG_ID                                                     AS NBJGH, --内部机构号
           B.ORG_NM                                                     AS YHJGMC, --银行机构名称
           A.CUST_ID                                                    AS KHTYBH, --客户统一编号
           --NVL(C.CUST_NM,FUN_DESENSITIZATION(REGEXP_REPLACE(D.CUST_NM,'[[:punct:]]',''),0)) AS KHMC, --客户名称
           --NVL(C.CUST_NM,D.CUST_NM_DESEN)                               AS KHMC, --客户名称 --MODIFY BY LAIHAIQIANG AT 20230403
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM_DESEN IS NOT NULL THEN D.CUST_NM_DESEN
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                         AS KHMC, --客户名称
           REPLACE(REPLACE(A.CUST_ACC,CHR(10),''),CHR(13),'')           AS KHZH, --客户账号
           REPLACE(REPLACE(A.OPEN_BANK_NM,CHR(10),''),CHR(13),'')       AS KHHMC, --开户行名称
           A.TRA_ID                                                     AS JYBH, --交易编号
           CODE.TAR_VALUE_NAME                                          AS DLDXJYLX, --代理代销交易类型
           REPLACE(REPLACE(A.CONSI_PROD_NM,CHR(10),''),CHR(13),'')      AS DXCPMC, --代销产品名称
           CODE1.TAR_VALUE_NAME                                         AS JYFX, --交易方向
           NVL(A.TRA_DT, '99991231')                                    AS JYRQ, --交易日期
           TRIM(A.CUR)                                                  AS BZ, --币种
           A.TRA_AMT                                                    AS JYJE, --交易金额
           REPLACE(REPLACE(A.ISU_ORG_NM,CHR(10),''),CHR(13),'')         AS FXJGMC, --发行机构名称
           REPLACE(REPLACE(A.ISU_ORG_RTG,CHR(10),''),CHR(13),'')        AS FXJGPJ, --发行机构评级
           REPLACE(REPLACE(A.ISU_ORG_RTG_ORG_NM,CHR(10),''),CHR(13),'') AS FXJGPJJG, --发行机构评级机构
           REPLACE(REPLACE(A.ISU_ORG_LIQ_ACC,CHR(10),''),CHR(13),'')    AS FXJGQSZH, --发行机构清算账号
           --TRIM(SUBSTRB(A.ISU_ORG_LIQ_BANK_NM,1,20))                    AS FXJGQSHM, --发行机构清算行名
           --SUBSTRB(TRIM(A.ISU_ORG_LIQ_BANK_NM),1,300)                   AS FXJGQSHM, --发行机构清算行名  --modify 20230307 LHQ  根据银监发文第三期数据长度变更，从C..30变更为C..450
           --SUBSTRB(TRIM(A.ISU_ORG_LIQ_BANK_NM),1,450)                   AS FXJGQSHM, --发行机构清算行名 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN TRIM(A.ISU_ORG_LIQ_BANK_NM) IS NOT NULL THEN SUBSTRB(TRIM(A.ISU_ORG_LIQ_BANK_NM),1,450)
                WHEN TRIM(A.ISU_ORG_LIQ_ACC) = '117011400100089857' THEN 'INDUSTRIAL BANK CO.,LTD.' --MODIFY BY LIP 20241105 美元的行号没有匹配，现针对该行号进行映射
            END                                                         AS FXJGQSHM, --发行机构清算行名
           --TRIM(SUBSTRB(A.FIN_PSN_NM,1,20))                             AS RZRMC, --融资人名称
           --SUBSTRB(TRIM(A.FIN_PSN_NM),1,300)                            AS RZRMC, --融资人名称  modify 20230307 LHQ  根据银监发文第三期数据长度变更，从C..30变更为C..450
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.FIN_PSN_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                /*THEN SUBSTRB(TRIM(REPLACE(REPLACE(REPLACE(TRIM(A.FIN_PSN_NM),'(','（'),')','）'),' ','')),1,300)
                ELSE SUBSTRB(TRIM(A.FIN_PSN_NM),1,300)*/
                --MODIFY BY LIP 20240409 改为UTF-8的长度
                THEN SUBSTRB(TRIM(REPLACE(REPLACE(REPLACE(TRIM(A.FIN_PSN_NM),'(','（'),')','）'),' ','')),1,450)
                ELSE SUBSTRB(TRIM(A.FIN_PSN_NM),1,450)
            END                                                         AS RZRMC, --融资人名称
           TRIM(A.FIN_PSN_BLNG_IDY)                                     AS RZRSSHY, --融资人所属行业
           TRIM(A.COMM_CUR)                                             AS SXFBZ, --手续费币种
           A.COMM_AMT                                                   AS SXFJE, --手续费金额
           CODE2.TAR_VALUE_NAME                                         AS XZBZ, --现转标志
           TRIM(A.HDLR_NO)                                              AS JYYGH, --经办人工号
           ''                                                           AS BBZ, --备注
           --TO_CHAR(LAST_DAY(TO_DATE(A.TRA_DT,'YYYYMMDD')), 'YYYYMMDD')  AS CJRQ, --采集日期
           V_MONTH_END_DATEID                                           AS CJRQ, --采集日期
           '000'                                                        AS DEPT_NO, --部门编号
           '01'                                                         AS SRC_SYS_ID, --来源系统ID
           '000000'                                                     AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                             AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                         AS ADDRESS, --归属地
           --NVL(C.CUST_NM,D.CUST_NM)                                     AS KHMC_ORIG, --客户名称（脱敏前）
           --MOD BY LIP 20230506 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN D.CUST_NM IS NOT NULL THEN D.CUST_NM
                WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                         AS KHMC, --客户名称
           CASE WHEN D.CUST_NM IS NOT NULL THEN '是'
                ELSE '否'
            END                                                         AS KHMC_OTH, --客户是否个人客户
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                         AS GSFZJG,--归属分支机构 --MODIFY BY LIP
           A.INSURE_PL_NUM                                              AS BDH  --保单号 --modify by tangan at 20230201
      FROM RRP_MDL.M_EAST_AGT_CPTL_DTL A --代理代销交易信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.AGCY_CONSI_TRA_TYP
       AND CODE.SRC_CLASS_CODE = 'T0031' --代理代销交易类型
       AND CODE.TAR_CLASS_CODE = 'T0031' --代理代销交易类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_DIR
       AND CODE1.SRC_CLASS_CODE = 'D0133' --交易方向
       AND CODE1.TAR_CLASS_CODE = 'D0133' --交易方向
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.CASH_TRF_FLG
       AND CODE2.SRC_CLASS_CODE = 'Z0019' --现转标志
       AND CODE2.TAR_CLASS_CODE = 'Z0019' --现转标志
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.MON_FLG = 'Y' --月口径标识
       /*AND A.DATA_DT >= V_START_DT
       AND A.DATA_DT <= V_P_DATE*/
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --去掉表的主键，通过语句判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT JYBH,CJRQ,COUNT(1)
      FROM RRP_EAST.EAST5_905_DLDXJYXXB T
     WHERE CJRQ = V_P_DATE
     GROUP BY JYBH,CJRQ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_905_DLDXJYXXB(CJRQ,JYBH)数据重复';
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

  --在过程跑批完成记录表中插入记录，调度查询该表判断过程是是否跑批完成
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '跑批结束';
  V_STARTTIME := SYSDATE;
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

END ETL_EAST5_905_DLDXJYXXB;
/

