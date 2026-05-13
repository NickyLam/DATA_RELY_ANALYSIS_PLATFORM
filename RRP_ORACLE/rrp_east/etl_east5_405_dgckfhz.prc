CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_405_DGCKFHZ(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：对公存款分户账
  **  存储过程名称:  ETL_EAST5_405_DGCKFHZ
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期   修改人     修改原因
  **  20220613   王锐       存款账户类型,数据有误
  **  20220628   LIP        修改字段超长、字段换行问题
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
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_405_DGCKFHZ'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_405_DGCKFHZ'); --表名称
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
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

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
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC:= '插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_405_DGCKFHZ(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      MXKMBH,      --明细科目编号
      MXKMMC,      --明细科目名称
      KHTYBH,      --客户统一编号
      ZHMC,        --账户名称
      DGCKZH,      --对公存款账号
      DGCKZHLX,    --对公存款账户类型
      BZJZHBZ,     --保证金账户标志
      LL,          --利率
      BZ,          --币种
      CKYE,        --存款余额
      KHRQ,        --开户日期
      KHGYH,       --开户柜员号
      XHRQ,        --销户日期
      SCDHRQ,      --上次动户日期
      CHLB,        --钞汇类别
      ZHZT,        --账户状态
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                              AS RID,         --数据主键
           B.FIN_PERMIT_NO                                         AS JRXKZH,      --金融许可证号
           B.ORG_ID                                                AS NBJGH,       --内部机构号
           B.ORG_NM                                                AS YHJGMC,      --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                   AS MXKMBH,      --明细科目编号
           D.SUBJ_NM                                               AS MXKMMC,      --明细科目名称
           A.CUST_ID                                               AS KHTYBH,      --客户统一编号
           --C.CUST_NM                                               AS ZHMC,        --账户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                    AS ZHMC,        --账户名称
           --A.ACC_ID_EAST                                           AS DGCKZH,      --对公存款账号
           --MOD BY LIP 20240618 将ACCT_ID长度小于4位的，改为用旧账号ID
           CASE WHEN LENGTH(A.ACC_ID_EAST) <= 4 AND TRIM(A.OLD_ACCT_ID) IS NOT NULL THEN TRIM(A.OLD_ACCT_ID)
                ELSE A.ACC_ID_EAST
            END                                                    AS DGCKZH,      --对公存款账号
           CASE WHEN C.NATL_ECON_DEPT_CL = 'A03' THEN '社会保障基金'
                WHEN A.DEP_PROD_TYP = '0501' THEN '单位活期存款'
                WHEN A.DEP_PROD_TYP IN ('0101','1402') THEN '单位定期存款'
                WHEN A.DEP_PROD_TYP IN ('0401','0402','0400') THEN '单位通知存款'
                WHEN A.DEP_PROD_TYP IN ('0201','0202','0200') THEN '单位协议存款'
                WHEN A.DEP_PROD_TYP IN ('0601','0602','0600') THEN '单位协定存款'
                WHEN A.DEP_PROD_TYP LIKE '07%' THEN '单位保证金存款'
                WHEN A.DEP_PROD_TYP = '1000' THEN '单位结构性存款（不含保本理财）'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,40))--MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,60))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS DGCKZHLX,    --对公存款账户类型
           CASE WHEN A.DEP_PROD_TYP LIKE '07%' THEN '是'
                ELSE '否'
            END                                                    AS BZJZHBZ,     --保证金账户标志
           A.RATE                                                  AS LL,          --利率
           A.CUR                                                   AS BZ,          --币种
           A.DEP_BAL                                               AS CKYE,        --存款余额
           NVL(A.OPEN_ACC_DT,'99991231')                           AS KHRQ,        --开户日期
           A.OPEN_ACC_TLR_NO                                       AS KHGYH,       --开户柜员号
           --NVL(A.CNL_ACC_DT,'99991231')                            AS XHRQ,        --销户日期
           --MOD BY LIP 20231020
           CASE WHEN A.CNL_ACC_DT IN ('29991231') THEN '99991231'
                ELSE NVL(A.CNL_ACC_DT,'99991231')
            END                                                    AS XHRQ,        --销户日期
           NVL(A.LAST_ACC_CHG_DT,'99991231')                       AS SCDHRQ,      --上次动户日期
           CASE WHEN A.CUR = 'CNY' THEN '人民币'
                ELSE CODE.TAR_VALUE_NAME
            END                                                    AS CHLB,        --钞汇类别
           CASE WHEN A.DEP_ACC_STAT = '01' THEN '正常'
                WHEN A.DEP_ACC_STAT = '02' THEN '销户'
                WHEN A.DEP_ACC_STAT = '03' THEN '预销户'
                WHEN A.DEP_ACC_STAT IN ('04','05','06','07') THEN '冻结'
                WHEN A.DEP_ACC_STAT = '11' THEN '止付'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,20))--MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS ZHZT,        --账户状态
           ''                                                      AS BBZ,         --备注
           V_MONTH_END_DATEID                                      AS CJRQ,        --采集日期
           '000'                                                   AS DEPT_NO,     --部门编号
           '01'                                                    AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,     --归属地
           B.GSFZJG                                                AS GSFZJG       --归属分支机构
      FROM RRP_MDL.M_DEP_ACC_INFO A --存款账户信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CASH_REMIT_TYP
       AND CODE.SRC_CLASS_CODE = 'D0057' --钞汇类别
       AND CODE.TAR_CLASS_CODE = 'D0057' --钞汇类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.DEP_PROD_TYP
       AND CODE1.SRC_CLASS_CODE = 'T0015' --个人存款账户类型
       AND CODE1.TAR_CLASS_CODE = 'T0015' --个人存款账户类型
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.DEP_ACC_STAT
       AND CODE2.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CORP_IND_FLG = '2' --对公
       AND (NVL(A.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,6)||'01' OR A.DEP_BAL > 0) /*WUHB 20220418增加销户日期判断*/
       AND A.OPEN_ACC_DT <= V_P_DATE
       AND A.SUBJ_ID NOT IN('30070101','20100102','20050201','20150101','20150102','20150104','20150105','20150106','20150107','20150199','20150201')--update by czk 20220824
       AND A.DATA_DT = V_P_DATE;
      --同业存款的业务从资金业务（负债方）信息取，这是两个表也业务重叠部分
      --AND SUBSTR(A.SUBJ_ID,1,8) <> '20170107'; 20050201代理财政预算专项存款，20100102地方国库定期存款 30070101委托存款

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC:= '对公存款分户账--同业存款';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_405_DGCKFHZ(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      MXKMBH,      --明细科目编号
      MXKMMC,      --明细科目名称
      KHTYBH,      --客户统一编号
      ZHMC,        --账户名称
      DGCKZH,      --对公存款账号
      DGCKZHLX,    --对公存款账户类型
      BZJZHBZ,     --保证金账户标志
      LL,          --利率
      BZ,          --币种
      CKYE,        --存款余额
      KHRQ,        --开户日期
      KHGYH,       --开户柜员号
      XHRQ,        --销户日期
      SCDHRQ,      --上次动户日期
      CHLB,        --钞汇类别
      ZHZT,        --账户状态
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                              AS RID,         --数据主键
           B.FIN_PERMIT_NO                                         AS JRXKZH,      --金融许可证号
           B.ORG_ID                                                AS NBJGH,       --内部机构号
           B.ORG_NM                                                AS YHJGMC,      --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                   AS MXKMBH,      --明细科目编号
           D.SUBJ_NM                                               AS MXKMMC,      --明细科目名称
           A.CUST_ID                                               AS KHTYBH,      --客户统一编号
           --C.CUST_NM                                               AS ZHMC,        --账户名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(C.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(C.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(C.CUST_NM)
            END                                                    AS ZHMC,        --账户名称
           --A.ACC_ID                                                AS DGCKZH,      --对公存款账号
           A.ACCT_ID                                               AS DGCKZH,      --对公存款账号 --TANQ 20220103
           CASE WHEN A.BIZ_TYP LIKE '201%' AND C.FIN_ORG_TYP IN ('F10000','F20000','F30000') THEN '保险公司存放款'
                WHEN SUBSTR(A.SUBJ_ID,1,8) IN ('20150102','20160102') THEN '保险公司存放款'
                ELSE '同业存放款'
            END                                                    AS DGCKZHLX,    --对公存款账户类型
           CASE WHEN A.BIZ_TYP = '20111' THEN '是'
                ELSE '否'
            END                                                    AS BZJZHBZ,     --保证金账户标志
           A.ACT_RATE                                              AS LL,          --利率
           A.CUR                                                   AS BZ,          --币种
           A.BAL                                                   AS CKYE,        --存款余额
           NVL(A.OPEN_ACC_DT,'99991231')                           AS KHRQ,        --开户日期
           A.OPEN_ACC_TLR_NO                                       AS KHGYH,       --开户柜员号
           --NVL(A.CNL_ACC_DT,'99991231')                            AS XHRQ,        --销户日期
           --MOD BY LIP 20231020
           CASE WHEN A.CNL_ACC_DT IN ('29991231') THEN '99991231'
                ELSE NVL(A.CNL_ACC_DT,'99991231')
            END                                                    AS XHRQ,        --销户日期
           NVL(A.LAST_ACC_CHG_DT, '99991231')                      AS SCDHRQ,      --上次动户日期
           CASE WHEN A.CUR = 'CNY' THEN '人民币'
                ELSE CODE.TAR_VALUE_NAME
            END                                                    AS CHLB,        --钞汇类别
           CASE /*WHEN A.ACC_STAT = '01' THEN '正常'
                WHEN A.ACC_STAT = '02' THEN '销户'
                WHEN A.ACC_STAT = '03' THEN '预销户'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '冻结'
                WHEN A.ACC_STAT = '11' THEN '止付'*/
                WHEN CODE2A.TAR_VALUE_CODE = '01' THEN '正常'
                WHEN CODE2A.TAR_VALUE_CODE = '02' THEN '销户'
                WHEN CODE2A.TAR_VALUE_CODE = '03' THEN '预销户'
                WHEN CODE2A.TAR_VALUE_CODE IN ('04','05','06','07') THEN '冻结'
                WHEN CODE2A.TAR_VALUE_CODE = '11' THEN '止付'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,20))--MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE2.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS ZHZT,        --账户状态
           ''                                                      AS BBZ,         --备注
           V_MONTH_END_DATEID                                      AS CJRQ,        --采集日期
           '000'                                                   AS DEPT_NO,     --部门编号
           '01'                                                    AS SRC_SYS_ID,  --来源系统ID
           '000000'                                                AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                    AS GSFZJG       --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_CPTL_LBY_INFO A --资金业务（负债方）信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO C --对公客户信息
        ON C.CUST_ID = A.CUST_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO D --总账会计科目信息表
        ON D.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)---科目报送到三级
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.CASH_REMIT_FLG
       AND CODE.SRC_CLASS_CODE = 'D0057' --钞汇类别
       AND CODE.TAR_CLASS_CODE = 'D0057' --钞汇类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2A --码值配置表 --ADD BY LIP 20230524 模型层没转码
        ON CODE2A.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE2A.SRC_CLASS_CODE = 'CD2554' --账户状态
       AND CODE2A.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2A.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        --ON CODE2.SRC_VALUE_CODE = A.ACC_STAT
        ON CODE2.SRC_VALUE_CODE = CODE2A.TAR_VALUE_CODE
       AND CODE2.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.BIZ_TYP LIKE '201%' --同业存放
       AND (NVL(A.CNL_ACC_DT,'99991231') >= SUBSTR(V_P_DATE,1,6)||'01' OR A.BAL>0)/*UPDATE BY 20220501 CXL 保留第三方监管账户余额>0的数据*/
       AND A.OPEN_ACC_DT <= V_P_DATE
       --AND SUBSTR(A.SUBJ_ID,1,8) <> '20170107'
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
    SELECT CJRQ,DGCKZH,BZ,CHLB,COUNT(1)
      FROM RRP_EAST.EAST5_405_DGCKFHZ T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,DGCKZH,BZ,CHLB
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_405_DGCKFHZ(CJRQ,DGCKZH,BZ,CHLB)数据重复';
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

END ETL_EAST5_405_DGCKFHZ;
/

