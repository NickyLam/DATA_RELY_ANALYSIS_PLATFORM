CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_601_BNWYWDBHTB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************=
  **  存储过程详细说明：表内外业务担保合同表
  **  存储过程名称:  ETL_EAST5_601_BNWYWDBHTB
  **  存储过程创建日期:2022-07-14
  **  存储过程创建人:付善斌
  **        M_GUA_CONT_INFO A --担保合同表
  **        M_PUM_ORG_INFO_EAST B --机构表
  **        M_GUA_REL_BSN_CONT C --担保合同和业务合同对应关系表
  **  目标表:
  **         EAST5_601_BNWYWDBHTB
  **  修改日期     修改人      修改原因
  **  20251212     LIP         根据业务要求，剔除未签合同的担保合同
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);         --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);         --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);       --分区名称
  V_FREQ_FLAG        VARCHAR2(10);        --跑批频度
  V_STEP             INTEGER := 0;        --任务号
  V_COUNT            INTEGER := 0;        --数据记录条数
  V_STARTTIME        DATE;                --处理开始时间
  V_ENDTIME          DATE;                --处理结束时间
  V_SQLCOUNT         INTEGER := 0;        --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);       --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(500);       --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_601_BNWYWDBHTB'; --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_601_BNWYWDBHTB'; --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

    /*增加分区*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '增加分区';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    /*删除当日分区数据*/
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '表内外业务担保合同表--插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_601_BNWYWDBHTB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       BDBHTH, --被担保合同号
       BDBYWLX, --被担保业务类型
       DBHTH, --担保合同号
       DBHTLX, --担保合同类型
       DBLX, --担保类型
       DBBZ, --担保币种
       DBJE, --担保金额
       DBQSRQ, --担保起始日期
       DBDQRQ, --担保到期日期
       JBRGH, --经办人工号
       DBHTZT, --担保合同状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG, --归属分支机构
       BDBRSFGR  --被担保人是否个人
       )
    --MOD BY LIP 20240711 因担保合同与业务合同关系表中有业务合同的状态和实际终止日期，所以不用这段判断
    /*WITH SX_CONT AS (--失效的担保合同，先判断其下业务合同或额度合同是否完全失效，全失效再根据更新时间判断，是否为在当前报送时间内
  SELECT \*+MATERIALIZE*\GUAR_CONT_ID,MAX_DT
    FROM (SELECT \*BC.CONT_STATUS_CD,BC.MODIF_DT,BC.LMT_CONT_FLG,BC.CONT_ID,*\
                 GC.GUAR_CONT_ID,
                 COUNT(1) AS NUM1,
                 SUM(CASE WHEN BC.CONT_STATUS_CD = '4' THEN 1 ELSE 0 END) NUM2, --BC.CONT_STATUS_CD = '4' 为合同失效的终结状态
                 MAX(MODIF_DT) MAX_DT --取最大的更新日期
            FROM RRP_MDL.O_ICL_CMM_GUAR_CONT GC   --担保合同
           INNER JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_RELA_TAB_INFO_H CR --贷款合同关联表信息历史
              ON CR.OBJ_ID = GC.GUAR_CONT_ID
             AND CR.OBJ_TYPE_NAME = 'GuarantyContract'
             AND CR.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND CR.END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
           INNER JOIN RRP_MDL.O_IML_AGT_LOAN_CONT_INFO_H BC --贷款合同信息历史
              ON BC.CONT_ID = CR.CONT_ID
             AND BC.LMT_CONT_FLG IN ('01','02') --额度合同下的担保合同 BUSINESSFLAG = '01' 业务合同下的担保合同 BUSINESSFLAG = '02'
             AND BC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
             AND BC.END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
           WHERE \*GC.GUAR_AMT <> 0
             AND*\ GC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
           GROUP BY GC.GUAR_CONT_ID)
   --当合同总条数等于失效状态总条数时，确认该担保合同为失效状态,并更新时间小于当期报送日期
   WHERE NUM1 = NUM2 AND TO_CHAR(MAX_DT,'YYYYMMDD') < SUBSTR(V_P_DATE,1,6)||'01')*/
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           --A.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_ID                                            AS NBJGH, --内部机构号
           C.BIZ_CONT_ID                                       AS BDBHTH, --被担保合同号
           --CODE2.TAR_VALUE_NAME                                AS BDBYWLX, --被担保业务类型
           --TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,20))            AS BDBYWLX, --被担保业务类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE2.TAR_VALUE_NAME,1,30))            AS BDBYWLX, --被担保业务类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           A.GUA_CONT_ID                                       AS DBHTH, --担保合同号
           --CODE.TAR_VALUE_NAME                                 AS DBHTLX, --担保合同类型
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,20))             AS DBHTLX, --担保合同类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,30))             AS DBHTLX, --担保合同类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.GUA_TYP = 'A' THEN '抵押'
                WHEN A.GUA_TYP = 'B' THEN '质押'
                WHEN A.GUA_TYP LIKE 'C%' THEN '保证'
                WHEN A.GUA_TYP = 'D' THEN '混合'
                --ELSE '其他-' || REPLACE(CODE3.TAR_VALUE_NAME, '其他-', '')
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,40)) --MODIFY BY LIP
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE3.TAR_VALUE_NAME,'其他-',''),1,60)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                AS DBLX, --担保类型
           TRIM(DECODE(A.CUR,'-','',A.CUR))                    AS DBBZ, --担保币种
           A.GUA_CONT_AMT                                      AS DBJE, --担保金额
           --NVL(A.GUA_CONT_EFF_DT, '99991231')                  AS DBQSRQ, --担保起始日期
           CASE WHEN A.GUA_CONT_EFF_DT NOT IN ('00010101','29991231','20991231') THEN A.GUA_CONT_EFF_DT
                WHEN A.GUA_CONT_SIGN_DT NOT IN ('00010101','29991231','20991231') THEN A.GUA_CONT_SIGN_DT
                ELSE '99991231'
            END                                                AS DBQSRQ, --担保起始日期 --MODIFY BY LIP 20221221
           CASE WHEN A.GUA_CONT_EXP_DT NOT IN ('00010101','29991231','20991231') THEN A.GUA_CONT_EXP_DT
                ELSE '99991231'
            END                                                AS DBDQRQ, --担保到期日期
           TRIM(A.ESTBL_EMP_NO)                                AS JBRGH, --经办人工号
           CASE --WHEN SUBSTR(TO_CHAR(SX.MAX_DT,'YYYYMMDD'),1,6)||'01' = SUBSTR(V_P_DATE,1,6)||'01' THEN '失效'
                WHEN NVL(C.BIZ_ACT_END_DT,'99991231') <= V_P_DATE THEN '失效'
                --当担保合同旗下所有业务合同和额度合同的状态均为4（即失效）是和最大更新日期等于当月，担保合同状态更新为失效
                WHEN A.GUA_CONT_STAT = 'Y' THEN '有效'
                WHEN A.GUA_CONT_STAT = 'N' THEN '失效'
            END                                                AS DBHTZT, --担保合同状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG,   --归属分支机构
           NVL(TRIM(DD.KHMC_OTH),'否')                         AS BDBRSFGR  --被担保人是否个人 --MODIFY BY TANGAN AT 20230201
      FROM RRP_MDL.M_GUA_CONT_INFO A --担保合同表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
     INNER/*LEFT*/ JOIN RRP_MDL.M_GUA_REL_BSN_CONT C --担保合同和业务合同对应关系表
        ON C.GUA_CONT_ID = A.GUA_CONT_ID
       AND NVL(C.GUA_REL_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND C.DATA_DT = V_P_DATE
      --MODIFY BY TANGAN AT 20230201
      LEFT JOIN RRP_EAST.EAST5_501_XDHTB DD
        ON DD.XDHTH = C.BIZ_CONT_ID
       AND DD.CJRQ = V_P_DATE
      /*LEFT JOIN SX_CONT SX --担保合同旗下所有业务合同和额度合同的状态和最大更新日期
        ON SX.GUAR_CONT_ID = A.GUA_CONT_ID*/
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.GUA_CONT_TYP
       AND CODE.SRC_CLASS_CODE = 'D0038' --担保合同类型
       AND CODE.TAR_CLASS_CODE = 'D0038' --担保合同类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.GUA_CONT_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE1.TAR_CLASS_CODE = 'Z0002' --担保合同状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.GUA_BIZ_TYP
       AND CODE2.SRC_CLASS_CODE = 'D0130' --被担保业务类型
       AND CODE2.TAR_CLASS_CODE = 'D0130' --被担保业务类型
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.GUA_TYP
       AND CODE3.SRC_CLASS_CODE = 'D0037' --担保类型
       AND CODE3.TAR_CLASS_CODE = 'D0037' --担保类型
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE /*NOT EXISTS (SELECT * FROM SX_CONT A1 WHERE A.GUA_CONT_ID = A1.GUAR_CONT_ID)*/ --ADD 20230306 LHQ 根据信贷口径，过滤不符合条件的担保合同
           (/*SX.GUAR_CONT_ID IS NULL OR*/ DD.XDHTH IS NOT NULL OR A.LOAN_MON_FLAG = 'Y') --MOD BY LIP 20240315
       --AND (NVL(C.CONT_STAT,' ') NOT IN ('01','06') OR DD.XDHTH IS NOT NULL) --ADD BY LIP 20230609 排除掉零售合同未生效或撤销的数据
       AND (NVL(C.BIZ_ACT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') OR DD.XDHTH IS NOT NULL)
       AND NVL(A.GUA_CONT_STAT_YBT,'1') NOT IN ('110') --未签合同 --MOD BY LIP 20251212 根据业务要求，剔除未签合同的担保合同
       AND NVL(A.GUA_CONT_END_DT,'99991231') >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --MOD BY LIP 20251229 因一表通的范围需要取当年内有效数据，EAST只卡当月内有效的数据
       AND CASE WHEN A.GUA_CONT_EFF_DT NOT IN ('00010101','29991231','20991231') THEN A.GUA_CONT_EFF_DT
                WHEN A.GUA_CONT_SIGN_DT NOT IN ('00010101','29991231','20991231') THEN A.GUA_CONT_SIGN_DT
                ELSE '99991231'
            END <= V_P_DATE --MOD BY LIP 20260323 根据业务需求，剔除合同起始日录入有问题大于采集日期的数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240719 插入上月有效但当月没采集到的数据
    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '将上月有效但当月没采集到的数据插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_601_BNWYWDBHTB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       BDBHTH, --被担保合同号
       BDBYWLX, --被担保业务类型
       DBHTH, --担保合同号
       DBHTLX, --担保合同类型
       DBLX, --担保类型
       DBBZ, --担保币种
       DBJE, --担保金额
       DBQSRQ, --担保起始日期
       DBDQRQ, --担保到期日期
       JBRGH, --经办人工号
       DBHTZT, --担保合同状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG, --归属分支机构
       BDBRSFGR  --被担保人是否个人
       )
    SELECT SYS_GUID()                                          AS RID, --数据主键
           C.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           A.NBJGH                                             AS NBJGH, --内部机构号
           A.BDBHTH                                            AS BDBHTH, --被担保合同号
           A.BDBYWLX                                           AS BDBYWLX, --被担保业务类型
           A.DBHTH                                             AS DBHTH, --担保合同号
           A.DBHTLX                                            AS DBHTLX, --担保合同类型
           A.DBLX                                              AS DBLX, --担保类型
           A.DBBZ                                              AS DBBZ, --担保币种
           A.DBJE                                              AS DBJE, --担保金额
           A.DBQSRQ                                            AS DBQSRQ, --担保起始日期
           A.DBDQRQ                                            AS DBDQRQ, --担保到期日期
           A.JBRGH                                             AS JBRGH, --经办人工号
           '失效'                                              AS DBHTZT, --担保合同状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG,   --归属分支机构
           A.BDBRSFGR                                          AS BDBRSFGR  --被担保人是否个人
      FROM RRP_EAST.EAST5_601_BNWYWDBHTB A --担保合同表
      LEFT JOIN RRP_EAST.EAST5_601_BNWYWDBHTB B --机构映射表
        ON B.BDBHTH = A.BDBHTH
       AND B.DBHTH = A.DBHTH
       AND B.CJRQ = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = A.NBJGH
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE B.BDBHTH IS NULL
       AND A.DBHTZT = '有效'
       AND A.CJRQ = TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM') - 1,'YYYYMMDD');

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
    SELECT CJRQ,BDBHTH,DBHTH,COUNT(1)
      FROM RRP_EAST.EAST5_601_BNWYWDBHTB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,BDBHTH,DBHTH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_601_BNWYWDBHTB(CJRQ,BDBHTH,DBHTH)数据重复';
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

END ETL_EAST5_601_BNWYWDBHTB;
/

