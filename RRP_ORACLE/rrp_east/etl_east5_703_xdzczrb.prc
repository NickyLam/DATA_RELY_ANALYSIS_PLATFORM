CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_703_XDZCZRB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_703_XDZCZRB
  *  功能描述：信贷资产转让表
  *  创建日期：20220712
  *  开发人员：王锐
  *  来源表： M_LOAN_TRF_INFO  信贷资产转让信息
              M_PUM_ORG_INFO_EAST   机构表
              CODE_MAP   码值配置表
              CONFIG_ORG_REL  机构级次关系表
              CONFIG_TABLE_LIST   分行报送报表配置表
  *  目标表： EAST5_703_XDZCZRB 信贷资产转让表
  *
  *  配置表：
  *  修改日期  修改人     修改原因
  *
  ***************************************************************************/
AS
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
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_703_XDZCZRB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_703_XDZCZRB'; --存储过程名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

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

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '装入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_703_XDZCZRB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       ZRHTH, --转让合同号
       ZCZRFX, --资产转让方向
       ZCZRFS, --资产转让方式
       ZRJKRZZH, --转让价款入账账号
       ZRJKRZMC, --转让价款入账账户名称
       JYDSMC, --交易对手名称
       JYDSZZZH, --交易对手账号
       JYDSKHHMC, --交易对手开户行名称
       BZ, --币种
       ZRDKBJZE, --转让贷款本金总额
       ZRDKLXZE, --转让贷款利息总额
       ZRZJ, --转让总价
       ZRHTQSRQ, --转让合同起始日期
       ZRHTDQRQ, --转让合同到期日期
       JYDSZRRQ, --交易对手转账日期
       JYDSYZFJE, --交易对手已支付金额
       BZJBL, --保证金比例
       BZJBZ, --保证金币种
       BZJJE, --保证金金额
       ZRJYPT, --转让交易平台
       SFZYDZXDJ, --是否在银登中心登记
       ZRHTZT, --转让合同状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       JYDSMC_ORIG, --交易对手名称（脱敏前）
       JYDSMC_OTH, --交易对手是否个人
       GSFZJG,--归属分支机构
       XDZCLX --信贷资产类型 --ADD BY LIP 20240204
       )
    SELECT SYS_GUID()                                                      AS RID, --数据主键
           B.FIN_PERMIT_NO                                                 AS JRXKZH, --金融许可证号
           B.ORG_ID                                                        AS NBJGH, --内部机构号
           A.TRF_CONT_ID                                                   AS ZRHTH, --转让合同号
           REPLACE(REPLACE(CODE.TAR_VALUE_NAME,CHR(10),''),CHR(13),'')     AS ZCZRFX, --资产转让方向
           CASE WHEN A.AST_TRF_MODE IN ('01','02') THEN '直接转让'
                WHEN A.AST_TRF_MODE IN ('03') THEN '信贷资产证券化'
                ELSE '其他-' || REPLACE(CODE2.TAR_VALUE_NAME, '其他-', '')
            END                                                            AS ZCZRFS, --资产转让方式
           REPLACE(REPLACE(A.TRF_ETR_ACC,CHR(10),''),CHR(13),'')           AS ZRJKRZZH, --转让价款入账账号
           REPLACE(REPLACE(A.TRF_ENTR_ACC_NM,CHR(10),''),CHR(13),'')       AS ZRJKRZMC, --转让价款入账账户名称
           CASE WHEN A.CRDT_CNTPR_TYP IN ('30') THEN /*SUBSTRB(A.CNTPR_NM, LENGTHB(A.CNTPR_NM) - 2, 3)*/
                TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.CNTPR_NM,'[[:punct:][:space:]]',''),0))
                --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN REGEXP_REPLACE(TRIM(A.CNTPR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.CNTPR_NM)
            END                                                            AS JYDSMC, --交易对手名称
           REPLACE(REPLACE(A.CNTPR_TRF_ACC,CHR(10),''),CHR(13),'')         AS JYDSZZZH, --交易对手账号
           REPLACE(REPLACE(A.CNTPR_TRF_ACC_NM,CHR(10),''),CHR(13),'')      AS JYDSKHHMC, --交易对手开户行名称
           REPLACE(REPLACE(A.CUR,CHR(10),''),CHR(13),'')                   AS BZ, --币种
           A.TRF_PRIN_TOT_AMT                                              AS ZRDKBJZE, --转让贷款本金总额
           A.TRF_INT_TOT_AMT                                               AS ZRDKLXZE, --转让贷款利息总额
           A.TRF_TOT_PRC                                                   AS ZRZJ, --转让总价
           NVL(A.TRF_CONT_START_DT, '99991231')                            AS ZRHTQSRQ, --转让合同起始日期
           NVL(A.TRF_CONT_EXP_DT, '99991231')                              AS ZRHTDQRQ, --转让合同到期日期
           NVL(A.CNTPR_TRF_DT, '99991231')                                 AS JYDSZRRQ, --交易对手转账日期
           A.CNTPR_ALDY_PAY_AMT                                            AS JYDSYZFJE, --交易对手已支付金额
           A.MRGN_PCT                                                      AS BZJBL, --保证金比例
           A.MRGN_CUR                                                      AS BZJBZ, --保证金币种
           A.MRGN                                                          AS BZJJE, --保证金金额
           --CODE1.TAR_VALUE_NAME                                           AS ZRJYPT, --转让交易平台
           CASE WHEN A.TRA_PLTF NOT IN ('99') THEN CODE1.TAR_VALUE_NAME
                --ELSE SUBSTRB('其他-' || REPLACE(A.OTH_TRA_PLTF, '其他-', ''),1,300)
                --ELSE SUBSTRB('其他-' || REPLACE(A.OTH_TRA_PLTF, '其他-', ''),1,450) --MODIFY BY LIP 20240409 改为UTF-8的长度
                ELSE SUBSTRB('其他-' || NVL(REPLACE(A.OTH_TRA_PLTF, '其他-', ''),'其他'),1,450) --MODIFY BY LIP 20260104
            END                                                            AS ZRJYPT, --转让交易平台
           CASE WHEN CODE1.TAR_VALUE_NAME = '银登中心' THEN '是'
                ELSE '否'
            END                                                            AS SFZYDZXDJ, --是否在银登中心登记
           CASE WHEN A.TRF_CONT_STAT = '01' THEN '未生效'
                WHEN A.TRF_CONT_STAT = '02' THEN '有效'
                WHEN A.TRF_CONT_STAT = '06' THEN '撤销'
                WHEN A.TRF_CONT_STAT = '07' THEN '终结'
                ELSE '其他-' || REPLACE(CODE3.TAR_VALUE_NAME, '其他-', '')
            END                                                            AS ZRHTZT, --转让合同状态
           ''                                                              AS BBZ, --备注
           V_MONTH_END_DATEID                                              AS CJRQ, --采集日期
           '000'                                                           AS DEPT_NO, --部门编号
           '01'                                                            AS SRC_SYS_ID, --来源系统ID
           '000000'                                                        AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                                AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                            AS ADDRESS, --归属地
           --A.CNTPR_NM                                                      AS JYDSMC_ORIG, --交易对手名称（脱敏前）
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.CNTPR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.CNTPR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.CNTPR_NM)
            END                                                            AS JYDSMC_ORIG, --交易对手名称（脱敏前）
           /*CASE WHEN A.CRDT_CNTPR_TYP LIKE 'C%' THEN '是'
                ELSE  '否'
            END                                                            AS JYDSMC_OTH, --交易对手是否个人*/
           CASE WHEN A.CRDT_CNTPR_TYP IN ('30') THEN '是' --CD2115
                ELSE '否'
            END                                                            AS JYDSMC_OTH, --交易对手是否个人
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                            AS GSFZJG,--归属分支机构 --MODIFY BY LIP
           CASE WHEN A.LOAN_BIZ_TYP =  '001' THEN '个人贷款'
                WHEN A.LOAN_BIZ_TYP =  '002' THEN '对公贷款'
           END                                                             AS XDZCLX --信贷资产类型 --ADD BY LIP 20240204
      --FROM RRP_MDL.M_LOAN_TRF_INFO A --信贷资产转让信息
      FROM RRP_MDL.M_LOAN_TRF_INFO_CT A --信贷资产转让信息_合同汇总维度 --MOD BY LIP 20251211
      LEFT JOIN RRP_MDL.ORG_CONFIG M --剔除历史销户数据
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.TRF_DRC
       AND CODE.SRC_CLASS_CODE = 'D0132' --资产转让方向
       AND CODE.TAR_CLASS_CODE = 'D0132' --资产转让方向
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_PLTF
       AND CODE1.SRC_CLASS_CODE = 'D0034' --转让交易平台
       AND CODE1.TAR_CLASS_CODE = 'D0034' --转让交易平台
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.AST_TRF_MODE
       AND CODE2.SRC_CLASS_CODE = 'D0033' --资产转让方式
       AND CODE2.TAR_CLASS_CODE = 'D0033' --资产转让方式
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.TRF_CONT_STAT
       AND CODE3.SRC_CLASS_CODE = 'D0117' --合同状态
       AND CODE3.TAR_CLASS_CODE = 'D0117' --合同状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = 'EAST5_703_XDZCZRB'
     WHERE --A.CNTPR_TRF_END_DT >= SUBSTR(V_P_DATE,1,6)||'01' --MOD BY LIP 根据交易对手最终支付完成的时间
       --AND A.ASSET_TRAN_DT >= SUBSTR(V_P_DATE,1,6)||'01' --根据业务口径 剔除历史已转让的数据 LHQ
           (NVL(A.CNTPR_TRF_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
           OR NVL(A.ASSET_TRAN_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')) --MOD BY LIP 20251216 当月内转让的也需要报送
       AND A.TRF_CONT_ID NOT IN ('GYDY08（信托）2021第001号—01','YCXTJG-HX-XT01','YCXT-HXPH1H-XTHT')--这三笔0630已报送 后续无需再报 20230117
       AND A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,ZRHTH,COUNT(1)
      FROM RRP_EAST.EAST5_703_XDZCZRB T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY CJRQ,ZRHTH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_703_XDZCZRB(CJRQ,ZRHTH)数据重复';
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

END ETL_EAST5_703_XDZCZRB;
/

