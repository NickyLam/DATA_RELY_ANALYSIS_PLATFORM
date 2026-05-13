CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_406_DGCKFHZMX(I_P_DATE IN INTEGER, --跑批日期
                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                    )
/***********************************************************************
  **  存储过程详细说明：对公存款分户账明细记录
  **  存储过程名称:  ETL_EAST5_406_DGCKFHZMX
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(5);
       BEGIN
         I_P_DATE := '20220101';
         ETL_EAST5_406_DGCKFHZMX(I_P_DATE, O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人           修改原因
  **  20220505                      同业存款逻辑注释，修改科目号取值关联B层存款账户表取科目号,原因：主键重复
  **  20220521     LAIHAIQIANG      修改机构映射关系
  **  20220630     LIP              修改字段超长、字段换行问题、增量表改为月批
  **  20230714     LIP              调整授权柜员号口径，当授权柜员号和交易柜员号相同时，将授权柜员号置空
  **  20241018     LIP              对方户名是否对公标识识别口径调整
  ************************************************************************/
IS
  V_P_DATE             VARCHAR2(8);       --数据日期
  V_MONTH_END_DATEID   VARCHAR2(8);       --本月月底日期
  V_PARTITION_NAME     VARCHAR2(100);     --分区名称
  V_FREQ_FLAG          VARCHAR2(10);      --跑批频度
  V_STEP               INTEGER := 0;      --任务号
  V_COUNT              INTEGER := 0;      --数据记录条数
  V_STARTTIME          DATE;              --处理开始时间
  V_ENDTIME            DATE;              --处理结束时间
  V_SQLCOUNT           INTEGER := 0;      --更新或删除影响的记录数
  V_SQLMSG             VARCHAR2(300);     --SQL执行描述信息
  V_STEP_DESC          VARCHAR2(100);     --处理步骤描述
  V_MONTH_START_DATEID VARCHAR2(8);       --本月月初日期
  V_PROC_NAME          VARCHAR2(100) := 'ETL_EAST5_406_DGCKFHZMX'; --存储过程名称
  V_TABLE_NAME         VARCHAR2(100) := 'EAST5_406_DGCKFHZMX'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID   := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_MONTH_START_DATEID := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD');
  V_PARTITION_NAME     := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG          := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --增加分区
    V_STEP    :=  1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --删除当日分区数据
    V_STEP    := V_STEP +  1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);
    --DELETE FROM RRP_EAST.EAST5_406_DGCKFHZMX WHERE CJRQ = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表--非同业存款部分';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_406_DGCKFHZMX
      (RID, --数据主键
       JYXLH, --交易序列号
       YWBLJGH, --业务办理机构号
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       DGCKZH, --对公存款账号
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
       CBMBZ, --冲补抹标志
       XZBZ, --现转标志
       JYQD, --交易渠道
       IPDZ, --IP地址
       MACDZ, --MAC地址
       JYGYH, --交易柜员号
       SQGYH, --授权柜员号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       FY, --附言
       DFHM_ORIG, --对方户名（脱敏前）
       DFHM_OTH, --对方户名是否自然人名称
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                                AS RID, ---数据主键
           --A.TRA_SEQ_NO                                              AS JYXLH, --交易序列号
           A.INIT_TRAN_TIMESTAMP||A.TRA_SEQ_NO                       AS JYXLH, --交易序列号 --MOD BY LIP 20241024
           --A.HDL_ORG_ID                                              AS YWBLJGH, --业务办理机构号
           BB.ORG_ID                                                 AS YWBLJGH, --业务办理机构号
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           B.ORG_ID                                                  AS NBJGH, --内部机构号
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           D.SUBJ_ID                                                 AS MXKMBH, --明细科目编号
           D.SUBJ_NM                                                 AS MXKMMC, --明细科目名称
           --MOD BY LIUYU 账户号关联存款账户表，取账户表科目关联科目表取科目名称
           --A.CUST_ID                                                 AS KHTYBH, --客户统一编号
           E.CUST_ID                                                 AS KHTYBH, --客户统一编号
           --C.CUST_NM                                                 AS ZHMC, --账户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN TRIM(REPLACE(REPLACE(REPLACE(C.CUST_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(C.CUST_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(C.CUST_NM)
            END                                                      AS ZHMC, --账户名称
           /*CASE WHEN LENGTH(A.EXT_ACC) = 7 THEN LPAD(A.EXT_ACC,12,0)
                ELSE A.EXT_ACC
             END                                                     AS DGCKZH, --对公存款账号*/
           --A.EXT_ACC                                                 AS DGCKZH, --对公存款账号
           --MOD BY LIP 20240618 将ACCT_ID长度小于4位的，改为用旧账号ID
           CASE WHEN LENGTH(A.ACC_ID_EAST) <= 4 AND TRIM(E.OLD_ACCT_ID) IS NOT NULL THEN TRIM(E.OLD_ACCT_ID)
                ELSE A.ACC_ID_EAST
            END                                                      AS DGCKZH, --对公存款账号
           A.ACC_ID                                                  AS WBZH, --外部账号
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))                  AS JYLX, --交易类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))                  AS JYLX, --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE2.TAR_VALUE_NAME                                      AS JYJDBZ, --交易借贷标志
           NVL(A.TRA_DT, '99991231')                                 AS HXJYRQ, --核心交易日期
           NVL(TO_CHAR(A.TRA_TM, 'HH24MISS'), '000000')              AS HXJYSJ, --核心交易时间
           A.CUR                                                     AS BZ, --币种
           A.TRA_AMT                                                 AS JYJE, --交易金额
           A.ACC_BAL                                                 AS ZHYE, --账户余额
           TRIM(A.OPP_ACC)                                           AS DFZH, --对方账号
           --TRIM(A.OPP_ACC_NM)                                        AS DFHM, --对方户名
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE --WHEN LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                WHEN (LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                      AND A.OPP_CORP_ACCT_FLG IS NULL) --MOD BY LIP 20260108
                     OR A.OPP_CORP_ACCT_FLG = '0' --MOD BY LIP 20241018
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''), 0))
                --ELSE TRIM(REGEXP_REPLACE(A.DFHM_ORIG,'[[:punct:]]',''))
                --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.OPP_ACC_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                      AS DFHM, --对方户名 --MODIFY BY LIP
           TRIM(A.OPP_PBC_NO)                                        AS DFXH, --对方行号
           TRIM(A.OPP_BANK_NM)                                       AS DFXM, --对方行名
           --A.ABSTR                                                   AS ZY, --摘要
           TRIM(REPLACE(REPLACE(A.ABSTR,CHR(10),''),CHR(13),''))     AS ZY, --摘要--MODIFY BY LIP
           CODE3.TAR_VALUE_NAME                                      AS CBMBZ, --冲补抹标志
           CODE4.TAR_VALUE_NAME                                      AS XZBZ, --现转标志
           --TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))                 AS JYQD, --交易渠道 --MODIFY BY LIP
           TRIM(SUBSTRB(CASE WHEN CODE5.TAR_VALUE_NAME LIKE '三方支付%'
                             THEN REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付')
                             ELSE CODE5.TAR_VALUE_NAME
            --END,1,40))                                               AS JYQD, --交易渠道 --MODIFY BY LIP
            END,1,60))                                               AS JYQD, --交易渠道 --MODIFY BY LIP 20240409 改为UTF-8的长度
           --MOD BY LIP 20240710 截取IP和MAC长度
           TRIM(SUBSTRB(A.IP,1,40))                                  AS IPDZ, --IP地址
           TRIM(SUBSTRB(A.MAC,1,60))                                 AS MACDZ, --MAC地址
           TRIM(A.TRA_TLR_NO)                                        AS JYGYH, --交易柜员号
           --TRIM(A.GRANT_TLR_NO)                                      AS SQGYH, --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           --CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40)) NOT IN ('柜面')
           CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
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
           --A.POSTSCRIPT                                              AS FY, --附言
           --A.OPP_ACC_NM                                              AS DFHM_ORIG, --对方户名（脱敏前）
           --NVL(TRIM(A.REAL_CNTPTY_ACCT_NAME),A.OPP_ACC_NM)           AS DFHM_ORIG, --对方户名（脱敏前）  -- TANQING20230203
           --TRIM(REPLACE(REPLACE(A.POSTSCRIPT,CHR(10),''),CHR(13),'')) AS FY, --附言--MODIFY BY LIP
           TRIM(SUBSTRB(A.TRAN_MEMO_DESCB,1,600))                    AS FY, --附言 --MOD BY LIP 20260414
           --TRIM(OPP_ACC_NM)                                          AS DFHM_ORIG, --对方户名（脱敏前）  -- TANQING20230203
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.OPP_ACC_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                      AS DFHM_ORIG, --对方户名（脱敏前）
           --'否'                                                      AS DFHM_OTH, --对方户名是否自然人名称
           CASE WHEN A.OPP_CORP_ACCT_FLG = '1' THEN '否'
                WHEN A.OPP_CORP_ACCT_FLG = '0' THEN '是'
                WHEN LENGTH(TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                ELSE '否'
            END                                                      AS DFHM_OTH, --对方户名是否自然人名称 --MOD BY LIP 20241018
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_TRA_DEP_ACC_DTL A --存款账户交易流水
     INNER JOIN RRP_MDL.M_DEP_ACC_INFO E --存款账户信息
        ON E.ACC_ID_EAST = A.ACC_ID_EAST
       --MOD BY LIP 20230609 与分户保持一致
       AND E.SUBJ_ID NOT IN ('30070101','20100102','20050201','20150101','20150102','20150104','20150105','20150106','20150107','20150199','20150201')
       AND (NVL(E.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,6)||'01' OR E.DEP_BAL > 0)
       AND E.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = E.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG CC --机构映射表 --MODIFY 20220521 修改机构映射关系 LAIHAIQIANG
        ON CC.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = CC.ORG_ID1
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG CC1 --机构映射表 --MODIFY BY LIP 20230523
        ON CC1.ORG_ID = A.HDL_ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST BB --机构表 --MODIFY BY LIP 20230523
        ON BB.ORG_ID = NVL(CC1.ORG_ID1,'800')
       AND BB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(E.SUBJ_ID,1,8)
        --MODFY BY LIUYU 由于总账会计科目表只报送三级科目，需要截取后关联取三级科目号和名称
       AND D.DATA_DT = V_P_DATE
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
        ON CODE3.SRC_VALUE_CODE = CASE WHEN A.FLUSH_PATCH_FLG = 'N' THEN '1' ELSE '4' END
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
        ON ORG.ORG_ID = CC.ORG_ID1 --MODIFY 20220521 修改机构映射关系 LAIHAIQIANG
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CORP_IND_FLG = '2' --对公
       --AND A.DATA_DT = V_P_DATE
       --AND A.POSTSCRIPT NOT LIKE '%失败%' --MODIFY BY TANGAN AT 20230311 银承开票批量开保证金失败场景对公不报送
       --AND NVL(A.POSTSCRIPT,' ') NOT LIKE '%失败%' --MOD BY LIP 20251023 一表通核对数据后，与业务及上游确认，需要报送
       AND A.DATA_DT <= V_MONTH_END_DATEID
       AND A.DATA_DT >= V_MONTH_START_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入目标表--同业存款部分';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_406_DGCKFHZMX
      (RID, --数据主键
       JYXLH, --交易序列号
       YWBLJGH, --业务办理机构号
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       DGCKZH, --对公存款账号
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
       CBMBZ, --冲补抹标志
       XZBZ, --现转标志
       JYQD, --交易渠道
       IPDZ, --IP地址
       MACDZ, --MAC地址
       JYGYH, --交易柜员号
       SQGYH, --授权柜员号
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       FY, --附言
       DFHM_ORIG, --对方户名（脱敏前）
       DFHM_OTH, --对方户名是否自然人名称
       GSFZJG --归属分支机构
       )
    SELECT SYS_GUID()                                                AS RID, --数据主键
           --A.TRA_SEQ_NO                                              AS JYXLH, --交易序列号
           A.INIT_TRAN_TIMESTAMP||A.TRA_SEQ_NO                       AS JYXLH, --交易序列号 --MOD BY LIP 20241024
           --A.HDL_ORG_ID                                              AS YWBLJGH, --业务办理机构号
           BB.ORG_ID                                                 AS YWBLJGH, --业务办理机构号
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           B.ORG_ID                                                  AS NBJGH, --内部机构号
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           D.SUBJ_ID                                                 AS MXKMBH, --明细科目编号
           D.SUBJ_NM                                                 AS MXKMMC, --明细科目名称
           --MOD BY LIUYU 账户号关联存款账户表，取账户表科目关联科目表取科目名称
           --A.CUST_ID                                                 AS KHTYBH, --客户统一编号
           E.CUST_ID                                                 AS KHTYBH, --客户统一编号
           --C.CUST_NM                                                 AS ZHMC, --账户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN TRIM(REPLACE(REPLACE(REPLACE(C.CUST_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(C.CUST_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(C.CUST_NM)
            END                                                      AS ZHMC, --账户名称
           /*CASE WHEN LENGTH(A.EXT_ACC) = 7 THEN LPAD(A.EXT_ACC,12,0)
                ELSE A.EXT_ACC
             END                                                     AS DGCKZH, --对公存款账号*/
           A.EXT_ACC                                                 AS DGCKZH, --对公存款账号
           A.ACC_ID                                                  AS WBZH, --外部账号
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,40))                  AS JYLX, --交易类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,60))                  AS JYLX, --交易类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CODE2.TAR_VALUE_NAME                                      AS JYJDBZ, --交易借贷标志
           NVL(A.TRA_DT,'99991231')                                  AS HXJYRQ, --核心交易日期
           NVL(TO_CHAR(A.TRA_TM, 'HH24MISS'),'000000')               AS HXJYSJ, --核心交易时间
           A.CUR                                                     AS BZ, --币种
           A.TRA_AMT                                                 AS JYJE, --交易金额
           A.ACC_BAL                                                 AS ZHYE, --账户余额
           TRIM(A.OPP_ACC)                                           AS DFZH, --对方账号 --TANQ 20230427
           CASE --WHEN LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                WHEN (LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                      AND A.OPP_CORP_ACCT_FLG IS NULL) --MOD BY LIP 20260108
                     OR A.OPP_CORP_ACCT_FLG = '0' --MOD BY LIP 20241018
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''), 0))
                --ELSE TRIM(REGEXP_REPLACE(A.DFHM_ORIG,'[[:punct:]]',''))
                --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
                WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.OPP_ACC_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                      AS DFHM, --对方户名 --MODIFY BY LIP
           TRIM(A.OPP_PBC_NO)                                        AS DFXH, --对方行号   --TANQ  20230427
           TRIM(A.OPP_BANK_NM)                                       AS DFXM, --对方行名   --TANQ  20230427
           --A.ABSTR                                                   AS ZY, --摘要
           TRIM(REPLACE(REPLACE(A.ABSTR,CHR(10),''),CHR(13),''))     AS ZY, --摘要--MODIFY BY LIP
           CODE3.TAR_VALUE_NAME                                      AS CBMBZ, --冲补抹标志
           CODE4.TAR_VALUE_NAME                                      AS XZBZ, --现转标志
           --TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,40))                  AS JYQD, --交易渠道 --MODIFY BY LIP
           TRIM(SUBSTRB(CASE WHEN CODE5.TAR_VALUE_NAME LIKE '三方支付%'
                             THEN REPLACE(CODE5.TAR_VALUE_NAME,'三方支付','第三方支付')
                             ELSE CODE5.TAR_VALUE_NAME
            --END,1,40))                                               AS JYQD, --交易渠道 --MODIFY BY LIP
            END,1,60))                                               AS JYQD, --交易渠道 --MODIFY BY LIP 20240409 改为UTF-8的长度
           /*TRIM(A.IP)                                                AS IPDZ, --IP地址
           TRIM(A.MAC)                                               AS MACDZ, --MAC地址*/
           --MOD BY LIP 20240710 截取IP和MAC长度
           TRIM(SUBSTRB(A.IP,1,40))                                  AS IPDZ, --IP地址
           TRIM(SUBSTRB(A.MAC,1,60))                                 AS MACDZ, --MAC地址
           TRIM(A.TRA_TLR_NO)                                        AS JYGYH, --交易柜员号
           --TRIM(A.GRANT_TLR_NO)                                      AS SQGYH, --授权柜员号
           --MOD BY LIP 20230714 授权柜员号和交易柜员号相同且交易渠道不是柜面时，将授权柜员号置空
           CASE WHEN TRIM(A.GRANT_TLR_NO) = TRIM(A.TRA_TLR_NO) AND TRIM(SUBSTRB(CODE5.TAR_VALUE_NAME,1,60)) NOT IN ('柜面')
                THEN NULL
                ELSE TRIM(A.GRANT_TLR_NO)
            END                                                      AS SQGYH, --授权柜员号
           ''                                                        AS BBZ, --备注
           V_MONTH_END_DATEID                                        AS CJRQ, --采集日期
           '000'                                                     AS DEPT_NO, --部门编号
           '01'                                                      AS SRC_SYS_ID, --来源系统ID
            '000000'                                                 AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS, --归属地
           --A.POSTSCRIPT                                              AS FY, --附言
           --TRIM(REPLACE(REPLACE(A.POSTSCRIPT,CHR(10),''),CHR(13),'')) AS FY, --附言--MODIFY BY LIP
           TRIM(SUBSTRB(A.TRAN_MEMO_DESCB,1,600))                    AS FY, --附言 --MOD BY LIP 20260414
           --A.OPP_ACC_NM                                               AS DFHM_ORIG, --对方户名（脱敏前）
           --NVL(TRIM(A.REAL_CNTPTY_ACCT_NAME),A.OPP_ACC_NM)           AS DFHM_ORIG, --对方户名（脱敏前）  -- TANQING20230203
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                    AND NOT REGEXP_LIKE(TRIM(A.OPP_ACC_NM),'[a-zA-Z]') --当客户名中含有数字和字母时不改()
                THEN TRIM(REPLACE(REPLACE(REPLACE(A.OPP_ACC_NM,'(','（'),')','）'),' ',''))
                --ELSE TRIM(REGEXP_REPLACE(A.OPP_ACC_NM,'[[:punct:]]',''))
                --MOD BY LIP 20230713
                ELSE TRIM(A.OPP_ACC_NM)
            END                                                      AS DFHM_ORIG, --对方户名（脱敏前）  -- TANQING20230203
           --'否'                                                      AS DFHM_OTH, --对方户名是否自然人名称
           --MOD BY LIP 20230427
           CASE WHEN A.OPP_CORP_ACCT_FLG = '1' THEN '否' --MOD BY LIP 20241018
                WHEN A.OPP_CORP_ACCT_FLG = '0' THEN '是' --MOD BY LIP 20241018
                WHEN LENGTH(TRIM(REGEXP_REPLACE(TRIM(A.OPP_ACC_NM),'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                ELSE '否'
            END                                                      AS DFHM_OTH, --对方户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG ELSE '9999' END     AS GSFZJG --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_TRA_DEP_ACC_DTL A --存款账户交易流水
     INNER JOIN RRP_MDL.M_CPTL_LBY_INFO E --资金业务（负债方）信息
        ON E.ACCT_ID = A.ACC_ID_EAST
       AND E.BIZ_TYP LIKE '201%' --同业存放
       AND (NVL(E.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,6)||'01' OR E.BAL > 0)
       AND E.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = E.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG CC --机构映射表 --MODIFY 20220521 修改机构映射关系 LAIHAIQIANG
        ON CC.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(CC.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG CC1 --机构映射表 --MODIFY BY LIP 20230523
        ON CC1.ORG_ID = A.HDL_ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST BB --机构表 --MODIFY BY LIP 20230523
        ON BB.ORG_ID = NVL(CC1.ORG_ID1,'800')
       AND BB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(E.SUBJ_ID,1,8)
        --MODFY BY LIUYU 由于总账会计科目表只报送三级科目，需要截取后关联取三级科目号和名称
       AND D.DATA_DT = V_P_DATE
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
        ON CODE3.SRC_VALUE_CODE = CASE WHEN A.FLUSH_PATCH_FLG = 'N' THEN '1' ELSE '4' END
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
        ON ORG.ORG_ID = B.ORG_ID --MODIFY 20220521 修改机构映射关系 LAIHAIQIANG
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CORP_IND_FLG = '2' --对公
       --AND A.DATA_DT = V_P_DATE
       --AND A.POSTSCRIPT NOT LIKE '%失败%' --MODIFY BY TANGAN AT 20230311 银承开票批量开保证金失败场景对公不报送
       --AND NVL(A.POSTSCRIPT,' ') NOT LIKE '%失败%' --MOD BY LIP 20251023 一表通核对数据后，与业务及上游确认，需要报送
       AND A.DATA_DT <= V_MONTH_END_DATEID
       AND A.DATA_DT >= V_MONTH_START_DATEID;

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
    SELECT CJRQ,JYXLH,DGCKZH,HXJYRQ,HXJYSJ,COUNT(1)
      FROM RRP_EAST.EAST5_406_DGCKFHZMX T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,JYXLH,DGCKZH,HXJYRQ,HXJYSJ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_406_DGCKFHZMX(CJRQ,JYXLH,DGCKZH,HXJYRQ,HXJYSJ)数据重复';
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

END ETL_EAST5_406_DGCKFHZMX;
/

