CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_407_NBFHZ(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_407_NBFHZ
  *  功能描述：内部分户账
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_DEP_INTL_ACC_INFO
  *            M_PUM_ORG_INFO_EAST
  *            M_GL_INFO
  *  目标表：  EAST5_407_NBFHZ
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期   修改人     修改原因
  *  20220601   付善斌     主键变更
  *  20220608   付善斌     增加有效数据限制条件，剔除上月之前销户的数据
  *  20220628    LIP       修改字段超长、字段换行问题
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
  V_TABLE_NAME     VARCHAR2(100) := 'EAST5_407_NBFHZ'; --表名称
  V_PROC_NAME      VARCHAR2(100) := 'ETL_EAST5_407_NBFHZ'; --存储过程名称
BEGIN
  O_ERRCODE   := '0';
  V_P_DATE    := TO_CHAR(I_P_DATE);
  V_START_DAT := SUBSTR(V_P_DATE,1,6)||'01'; --当月月初
  V_LAST_DAT  := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD'); --当月月底
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);
  V_PARTITION_NAME := 'PARTITION_' || V_LAST_DAT;

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --增加分区
    V_STEP := 1;
    V_STEP_DESC := '程序跑批开始';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE,V_TABLE_NAME,1,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP +1;
    V_STARTTIME := SYSDATE;
    V_STEP_DESC := '删除当日分区数据';
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理核心系统个人客户信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_407_NBFHZ
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       ZHMC, --账户名称
       NBFHZZH, --内部分户账账号
       BZ, --币种
       JDBZ, --借贷标志
       JFYE, --借方余额
       DFYE, --贷方余额
       JXBZ, --计息标志
       JXFS, --计息方式
       LL, --利率
       KHRQ, --开户日期
       XHRQ, --销户日期
       ZHZT, --账户状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       ZHMC_ORIG,--账户名称（脱敏前）
       ZHMC_OTH, --户名是否自然人名称
       GSFZJG, --归属分支机构
       ACCTNO   --主账户账号
       )
    SELECT SYS_GUID()                                              AS RID, --数据主键
           B.FIN_PERMIT_NO                                         AS JRXKZH, --金融许可证号
           B.ORG_ID                                                AS NBJGH, --内部机构号
           B.ORG_NM                                                AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                   AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                               AS MXKMMC, --明细科目名称
           A.ACC_NM                                                AS ZHMC, --账户名称
           A.ACC_ID                                                AS NBFHZZH, --内部分户账账号
           A.CUR                                                   AS BZ, --币种
           CODE.TAR_VALUE_NAME                                     AS JDBZ, --借贷标志
           A.DR_BAL                                                AS JFYE, --借方余额
           A.CR_BAL                                                AS DFYE, --贷方余额
           CODE1.TAR_VALUE_NAME                                    AS JXBZ, --计息标志
           CODE2.TAR_VALUE_NAME                                    AS JXFS, --计息方式
           A.RATE                                                  AS LL, --利率
           NVL(A.OPEN_ACC_DT, '99991231')                          AS KHRQ, --开户日期
           NVL(A.CNL_ACC_DT, '99991231')                           AS XHRQ, --销户日期
           CASE WHEN A.ACC_STAT = '01' THEN '正常'
                WHEN A.ACC_STAT = '02' THEN '销户'
                WHEN A.ACC_STAT = '03' THEN '预销户'
                WHEN A.ACC_STAT IN ('04', '05', '06', '07') THEN '冻结'
                WHEN A.ACC_STAT = '11' THEN '止付'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,20)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                    AS ZHZT, --账户状态
           ''                                                      AS BBZ, --备注
           V_LAST_DAT                                              AS CJRQ, --采集日期
           '000'                                                   AS DEPT_NO, --部门编号
           '01'                                                    AS SRC_SYS_ID, --来源系统ID
           '000000'                                                AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                        AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                    AS ADDRESS, --归属地
           A.ACC_NM                                                AS ZHMC_ORIG,--账户名称（脱敏前）
           '否'                                                    AS ZHMC_OTH, --户名是否自然人名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                    AS GSFZJG,--归属分支机构 --MODIFY BY LIP
            A.MAIN_ACCT_ID                                         AS ACCTNO --主账户账号  --ADD LHQ  at 20230407 区志豪要求加的
      FROM RRP_MDL.M_DEP_INTL_ACC_INFO A --内部分户账信息
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)--科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.DR_CR_FLG
       AND CODE.SRC_CLASS_CODE = 'Z0017' --借贷标志
       AND CODE.TAR_CLASS_CODE = 'Z0017' --借贷标志
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.INT_CALC_FLG
       AND CODE1.SRC_CLASS_CODE = 'Z0001' --计息标志
       AND CODE1.TAR_CLASS_CODE = 'Z0001' --计息标志
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.INT_CALC_MODE
       AND CODE2.SRC_CLASS_CODE = 'D0061' --计息方式
       AND CODE2.TAR_CLASS_CODE = 'D0061' --计息方式
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE3.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CNL_ACC_DT >= V_START_DAT
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
    SELECT CJRQ,NBFHZZH,BZ,COUNT(1)
      FROM RRP_EAST.EAST5_407_NBFHZ T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,NBFHZZH,BZ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_407_NBFHZ(CJRQ,NBFHZZH,BZ)数据重复';
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

END ETL_EAST5_407_NBFHZ;
/

