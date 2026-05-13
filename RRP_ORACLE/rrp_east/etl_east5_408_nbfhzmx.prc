CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_408_NBFHZMX(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_408_NBFHZMX
  *  功能描述：内部分户账明细记录
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_TRA_INTL_ACC_DTL
  *            M_PUM_ORG_INFO_EAST
  *            M_GL_INFO
  *  目标表：  EAST5_408_NBFHZMX
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期     修改人       修改原因
  *  20220601     付善斌       主键变更
  *  20220630     LIP          修改字段超长、字段换行问题、增量表改为月批
  *  20230714     LIP          调整授权柜员号口径，当授权柜员号和交易柜员号相同时，将授权柜员号置空
  ***************************************************************************/
AS
  V_P_DATE         VARCHAR2(8);      --数据日期
  V_PARTITION_NAME VARCHAR2(100);    --分区名称
  V_FREQ_FLAG      VARCHAR2(10);     --跑批频度
  V_STEP           INTEGER := 0;     --任务号
  V_COUNT          INTEGER := 0;     --数据记录条数
  V_SQLCOUNT       INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME      DATE := SYSDATE;  --处理开始时间
  V_ENDTIME        DATE := SYSDATE;  --处理结束时间
  V_SQLMSG         VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC      VARCHAR2(100);    --处理步骤描述
  V_LAST_DAT       VARCHAR2(8);      --当月月末
  V_START_DAT      VARCHAR2(8);      --当月月初
  V_TABLE_NAME     VARCHAR2(100) := 'EAST5_408_NBFHZMX'; --表名称
  V_PROC_NAME      VARCHAR2(100) := 'ETL_EAST5_408_NBFHZMX'; --存储过程名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);
  V_LAST_DAT  := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_START_DAT := SUBSTR(V_P_DATE,1,6)||'01'; --当月月初
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    /*增加分区*/
    V_STEP := 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    --增加当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --DELETE FROM RRP_EAST.EAST5_408_NBFHZMX T WHERE T.CJRQ = V_P_DATE;--普通表的重跑处理
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理内部户分户账明细数据信息';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_408_NBFHZMX(
      RID,           --数据主键
      JYXLH,         --交易序列号
      JRXKZH,        --金融许可证号
      NBJGH,         --内部机构号
      YHJGMC,        --银行机构名称
      MXKMBH,        --明细科目编号
      MXKMMC,        --明细科目名称
      ZHMC,          --账户名称
      NBFHZZH,       --内部分户账账号
      HXJYRQ,        --核心交易日期
      HXJYSJ,        --核心交易时间
      BZ,            --币种
      JYLX,          --交易类型
      JYJDBZ,        --交易借贷标志
      JYJE,          --交易金额
      JFYE,          --借方余额
      DFYE,          --贷方余额
      DFZH,          --对方账号
      DFKMBH,        --对方科目编号
      DFKMMC,        --对方科目名称
      DFHM,          --对方户名
      DFXH,          --对方行号
      DFXM,          --对方行名
      ZY,            --摘要
      CBMBZ,         --冲补抹标志
      JYQD,          --交易渠道
      XZBZ,          --现转标志
      JYGYH,         --交易柜员号
      SQGYH,         --授权柜员号
      JZRQ,          --进账日期
      XZRQ,          --销账日期
      BBZ,           --备注
      CJRQ,          --采集日期
      DEPT_NO,       --部门编号
      SRC_SYS_ID,    --来源系统ID
      ISSUED_NO,     --填报机构
      ORG_NO,        --报送机构
      ADDRESS,       --归属地
      DFHM_ORIG,     --对方户名（脱敏前）
      ZHMC_ORIG,     --账户名称（脱敏前）
      ZHMC_OTH,      --账户是否自然人名称
      DFHM_OTH,      --对方户名是否自然人名称
      GSFZJG         --归属分支机构
      )
    SELECT /*+USE_HASH(A,B,C,CODE1,CODE2,CODE3,CODE4,CODE5,ORG,LIST)*/
           SYS_GUID()                                                AS RID,           --数据主键
           --A.TRA_SEQ_NO                                              AS JYXLH,         --交易序列号
           A.INIT_TRAN_TIMESTAMP||A.TRA_SEQ_NO                       AS JYXLH,         --交易序列号 --MOD BY LIP 20241024
           B.FIN_PERMIT_NO                                           AS JRXKZH,        --金融许可证号
           B.ORG_ID                                                  AS NBJGH,         --内部机构号
           B.ORG_NM                                                  AS YHJGMC,        --银行机构名称
           SUBSTR(TA.SUBJ_ID,1,8)                                    AS MXKMBH,        --明细科目编号
           C.SUBJ_NM                                                 AS MXKMMC,        --明细科目名称
           --A.ACC_NM                                                  AS ZHMC,          --账户名称
           TA.ACC_NM                                                 AS ZHMC,          --账户名称
           A.ACC_ID                                                  AS NBFHZZH,       --内部分户账账号
           A.TRA_DT                                                  AS HXJYRQ,        --核心交易日期
           NVL(TO_CHAR(A.TRA_TM, 'HH24MISS'), '000000')              AS HXJYSJ,        --核心交易时间
           A.CUR                                                     AS BZ,            --币种
           --NVL(TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40)),'其他-其他') AS JYLX,          --交易类型 --MODIFY BY TANGAN AT 20230105
           NVL(TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60)),'其他-其他') AS JYLX,          --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE2.TAR_VALUE_NAME                                      AS JYJDBZ,        --交易借贷标志
           A.TRA_AMT                                                 AS JYJE,          --交易金额
           A.DR_BAL                                                  AS JFYE,          --借方余额
           A.CR_BAL                                                  AS DFYE,          --贷方余额
           A.OPP_ACC                                                 AS DFZH,          --对方账号
           SUBSTR(A.OPP_SUBJ_ID,1,8)                                 AS DFKMBH,        --对方科目编号
           D.SUBJ_NM                                                 AS DFKMMC,        --对方科目名称
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           --CASE WHEN LENGTH(TRIM(A.OPP_ACC_NM)) > 3 OR A.OPP_CORP_ACCT_FLG = '0' --MOD BY LIP 20241021
           --CASE WHEN (LENGTH(TRIM(A.OPP_ACC_NM)) > 3 AND A.OPP_CORP_ACCT_FLG IS NULL) OR A.OPP_CORP_ACCT_FLG = '1' --MOD BY LIP 20251231
           CASE WHEN (LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:space:]]',''))) > 3 --MOD BY LIP 20260227
                     AND A.OPP_CORP_ACCT_FLG IS NULL) OR A.OPP_CORP_ACCT_FLG = '1'
                THEN CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                              AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                          THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                          ELSE TRIM(A.OPP_ACC_NM)
                      END
                ELSE TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''),0))--MODIFY BY LIP
            END                                                      AS DFHM,          --对方户名
           --TRIM(A.OPP_PBC_NO)                                        AS DFXH,          --对方行号
           TRIM(SUBSTR(A.OPP_PBC_NO,1,30))                           AS DFXH,          --对方行号
           TRIM(A.OPP_BANK_NM)                                       AS DFXM,          --对方行名
           --A.ABSTR                                                   AS ZY,            --摘要
           TRIM(REPLACE(REPLACE(A.ABSTR,CHR(10),''),CHR(13),''))     AS ZY,            --摘要
           CODE3.TAR_VALUE_NAME                                      AS CBMBZ,         --冲补抹标志
           --CODE5.TAR_VALUE_NAME                                      AS JYQD,          --交易渠道
           CASE WHEN CODE5.TAR_VALUE_NAME LIKE '三方支付%'
                --THEN TRIM(SUBSTRB(REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付'),1,40))
                THEN TRIM(SUBSTRB(REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付'),1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                WHEN TRIM(CODE5.TAR_VALUE_NAME) IS NOT NULL
                --THEN TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))
                THEN TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
                ELSE '其他-其他'
            END                                                      AS JYQD,          --交易渠道 --MODIFY BY LIP
           CODE4.TAR_VALUE_NAME                                      AS XZBZ,          --现转标志
           TRIM(A.TRA_TLR_NO)                                        AS JYGYH,         --交易柜员号
           --TRIM(A.GRANT_TLR_NO)                                      AS SQGYH,         --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           --CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40)) NOT IN ('柜面')
           --MOD BY LIP 20251218 根据要求，授权柜员和交易柜员号相同的，授权柜员号置空
           CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) --AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
                THEN NULL
                ELSE TRIM(A.GRANT_TLR_NO)
            END                                                      AS SQGYH,         --授权柜员号
           NVL(A.ENT_ACCT_DT, '99991231')                            AS JZRQ,          --进账日期
           NVL(A.WRT_OFF_DT, '99991231')                             AS XZRQ,          --销账日期
           ''                                                        AS BBZ,           --备注
           V_LAST_DAT                                                AS CJRQ,          --采集日期
           '000'                                                     AS DEPT_NO,       --部门编号
           '01'                                                      AS SRC_SYS_ID,    --来源系统ID
           '000000'                                                  AS ISSUED_NO,     --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO,        --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS,       --归属地
           --A.OPP_ACC_NM                                              AS DFHM_ORIG,     --对方户名（脱敏前）
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN REPLACE(REPLACE(REPLACE(TRIM(A.OPP_ACC_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                      AS DFHM_ORIG,     --对方户名（脱敏前）
           A.ACC_NM                                                  AS ZHMC_ORIG,     --账户名称（脱敏前）
           '否'                                                      AS ZHMC_OTH,      --账户是否自然人名称
           --CASE WHEN LENGTH(A.OPP_ACC_NM) > 3 OR A.OPP_CORP_ACCT_FLG = '0' --MOD BY LIP 20241021
           --CASE WHEN (LENGTH(TRIM(A.OPP_ACC_NM)) > 3 AND A.OPP_CORP_ACCT_FLG IS NULL) OR A.OPP_CORP_ACCT_FLG = '1' --MOD BY LIP 20251231
           CASE WHEN (LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:space:]]',''))) > 3 --MOD BY LIP 20260227
                      AND A.OPP_CORP_ACCT_FLG IS NULL) OR A.OPP_CORP_ACCT_FLG = '1'
                THEN '否'
                ELSE '是'
            END                                                      AS DFHM_OTH,      --对方户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG         --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_TRA_INTL_ACC_DTL A --内部分户账交易流水
     INNER JOIN RRP_MDL.M_DEP_INTL_ACC_INFO TA --ADD BY LIP 20230523 只报送内部分户账报送范围的流水
        ON TA.ACC_ID = A.ACC_ID
       AND TA.CNL_ACC_DT >= V_START_DAT
       AND TA.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(TA.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表 对方科目
        ON D.SUBJ_ID = SUBSTR(A.OPP_SUBJ_ID,1,8)
       AND D.DATA_DT = V_LAST_DAT
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.TRA_TYP
       AND CODE1.SRC_CLASS_CODE = 'D0121' --交易类型
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
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = M.ORG_ID1
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT <= V_LAST_DAT
       AND A.DATA_DT >= V_START_DAT;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20220606 去掉表的主键，通过语句判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,JYXLH,NBFHZZH,HXJYRQ,HXJYSJ,COUNT(1)
      FROM RRP_EAST.EAST5_408_NBFHZMX T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,JYXLH,NBFHZZH,HXJYRQ,HXJYSJ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_408_NBFHZMX(CJRQ,JYXLH,NBFHZZH,HXJYRQ,HXJYSJ)数据重复';
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

END ETL_EAST5_408_NBFHZMX;
/

