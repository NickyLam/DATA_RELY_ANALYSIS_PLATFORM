CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_205_JTKHB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：集团客户表
  **  存储过程名称:  ETL_EAST5_205_JTKHB
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  返回值:     O_ERRCODE
  **  修改日期     修改人    修改原因
  **  20220521     付善斌    修改成员已用额度为空问题
  **  20220524     付善斌    填报机构源调整
  **  20220525     付善斌    修复已用额有数，授信额度为0的情况
  **  20220601     付善斌    归属机构逻辑添加
  **  20220629     LIP       修改日志记录格式，修改字段超长、字段换行问题
  **  20230427     LIP       将客户名称全是中文的()改为（）
  **  20230427     LIP       去除失效、注销的客户
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_COUNT            INTEGER := 0;     --数据记录条数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_205_JTKHB'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_205_JTKHB'); --表名称
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
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_ADD(V_P_DATE, V_TABLE_NAME, 1, O_ERRCODE);
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE);

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '集团客户表-插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_205_JTKHB(
      RID,         --数据主键
      JRXKZH,      --金融许可证号
      NBJGH,       --内部机构号
      YHJGMC,      --银行机构名称
      JTBH,        --集团编号
      JTMC,        --集团名称
      MGSKHTYBH,   --母公司客户统一编号
      MGSMC,       --母公司名称
      SKRMC,       --实控人名称
      SKRLX,       --实控人类型
      BZ,          --币种
      JTZCZE,      --集团资产总额
      JTFZZE,      --集团负债总额
      JTSXED,      --集团授信额度
      JTYYED,      --集团已用额度
      CYKHTYBH,    --成员客户统一编号
      CYMC,        --成员名称
      CYYYED,      --成员已用额度
      BBZ,         --备注
      CJRQ,        --采集日期
      DEPT_NO,     --部门编号
      SRC_SYS_ID,  --来源系统ID
      ISSUED_NO,   --填报机构
      ORG_NO,      --报送机构
      ADDRESS,     --归属地
      GSFZJG       --归属分支机构
      )
    SELECT SYS_GUID()                                            AS RID,         --数据主键
           C.FIN_PERMIT_NO                                       AS JRXKZH,      --金融许可证号
           C.ORG_ID                                              AS NBJGH,       --内部机构号
           C.ORG_NM                                              AS YHJGMC,      --银行机构名称
           A.CUST_ID                                             AS JTBH,        --集团编号
           --TRIM(B.CUST_NM)                                       AS JTMC,        --集团名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(B.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(B.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(B.CUST_NM)
            END                                                  AS JTMC,        --集团名称
           TRIM(D.MBR_CUST_ID)                                   AS MGSKHTYBH,   --母公司客户统一编号
           --TRIM(D.MBR_NM)                                        AS MGSMC,       --母公司名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.MBR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.MBR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.MBR_NM)
            END                                                  AS MGSMC,       --母公司名称
           /*CASE WHEN TRIM(D.MBR_CUST_ID) IS NOT NULL THEN TRIM(D.MBR_CUST_ID)
                WHEN NVL(D1.CUST_ID,D2.CUST_ID) IS NOT NULL
                THEN TRIM(H.GROUP_PARENT_CORP_ID)
            END                                                  AS MGSKHTYBH,   --母公司客户统一编号 --MOD BY LIP 20260408
           CASE WHEN TRIM(D.MBR_CUST_ID) IS NOT NULL AND REGEXP_REPLACE(TRIM(D.MBR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.MBR_NM),'(','（'),')','）'),' ','')
                WHEN TRIM(D.MBR_CUST_ID) IS NOT NULL
                THEN TRIM(D.MBR_NM)
                WHEN D1.CUST_ID IS NOT NULL AND REGEXP_REPLACE(TRIM(D1.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D1.CUST_NM),'(','（'),')','）'),' ','')
                WHEN D1.CUST_ID IS NOT NULL THEN TRIM(D1.CUST_NM)
                WHEN D2.CUST_ID IS NOT NULL THEN TRIM(D2.CUST_NM)
            END                                                  AS MGSMC,       --母公司名称 --MOD BY LIP 20260408*/
           --TRIM(E.REL_PSN_CUST_NM)                               AS SKRMC,       --实控人名称
           NVL(TRIM(E.REL_PSN_CUST_NM),TRIM(TA.ACTUALCONTROLLER))AS SKRMC,       --实控人名称 --MOD BY LIP 20240726
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))               AS SKRLX,       --实控人类型 --MODIFY BY LIP
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))               AS SKRLX,       --实控人类型 --MODIFY BY LIP 20240409 改为UTF-8的长度
           TRIM(A.CUR)                                           AS BZ,          --币种
           A.AST_TOT_AMT                                         AS JTZCZE,      --集团资产总额
           A.LBY_TOT_AMT                                         AS JTFZZE,      --集团负债总额
           --NVL(NVL(TRIM(F.CRDT_TOTAL_LMT),TRIM(G.CRDT_TOTAL_LMT)),0) AS JTSXED,  --集团授信额度
           --CASE WHEN TRIM(F.CRDT_TOTAL_LMT) IS NULL THEN NVL(TRIM(G.CRDT_TOTAL_LMT),0)
           CASE WHEN TRIM(F.CRDT_TOTAL_LMT) IS NULL THEN NVL(TRIM(F.CRDT_TOTAL_LMT),0)
                WHEN F.CRDT_TOTAL_LMT = 0 THEN NVL(TRIM(G.CRDT_TOTAL_LMT),0)
                ELSE NVL(TRIM(F.CRDT_TOTAL_LMT),0)  --ADD BY LIP
            END                                                  AS JTSXED,      --集团授信额度
           NVL(NVL(TRIM(F.ALDY_USE_LMT),TRIM(G.ALDY_USE_LMT)),0) AS JTYYED,      --集团已用额度
           TRIM(H.MBR_CUST_ID)                                   AS CYKHTYBH,    --成员客户统一编号
           --TRIM(H.MBR_NM)                                        AS CYMC,        --成员名称
           --MOD BY LIP 20230427 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(H.MBR_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(H.MBR_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(H.MBR_NM)
            END                                                  AS CYMC,        --成员名称
           NVL(TRIM(I.ALDY_USE_LMT),0)                           AS CYYYED,      --成员已用额度
           ''                                                    AS BBZ,         --备注
           V_MONTH_END_DATEID                                    AS CJRQ,        --采集日期
           '000'                                                 AS DEPT_NO,     --部门编号
           '01'                                                  AS SRC_SYS_ID,  --来源系统ID
           '000000'                                              AS ISSUED_NO,   --填报机构
           ORG.ORG_ID_LEL_0                                      AS ORG_NO,      --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                  AS ADDRESS,     --归属地
           CASE WHEN LIST.FLAG = 1 THEN C.GSFZJG
                ELSE '9999'
            END                                                  AS GSFZJG       --归属分支机构 --MODIFY BY LIP
      FROM RRP_MDL.M_CUST_CORP_GRP_SUB A --集团客户信息子表
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO B --对公客户信息
        ON B.CUST_ID = A.CUST_ID
       AND B.CUST_STAT NOT IN ('P','2','C') --客户没有失效、注销 --ADD BY LIP 20230719 去除失效、注销的客户
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_CUST_CORP_GRPMBR_SUB H --集团客户成员子表
        ON H.GRP_CUST_ID = A.CUST_ID
       AND H.DATA_DT = V_P_DATE
     --ADD BY LIP 20230719 去除失效、注销的客户
     INNER JOIN RRP_MDL.M_CUST_CORP_INFO HB --对公客户信息
        ON HB.CUST_ID = TRIM(H.MBR_CUST_ID)
       AND HB.CUST_STAT NOT IN ('P','2','C') --客户没有失效、注销
       AND HB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = NVL(M.ORG_ID1,'800')
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN (SELECT GRP_CUST_ID,MBR_CUST_ID,MBR_NM,ROW_NUMBER() OVER(PARTITION BY GRP_CUST_ID ORDER BY MBR_CUST_ID) RN
                   FROM RRP_MDL.M_CUST_CORP_GRPMBR_SUB
                  WHERE PAR_CO_FLG = 'Y' --母公司信息
                    AND DATA_DT = V_P_DATE) D
        ON D.GRP_CUST_ID = A.CUST_ID
       AND D.RN = 1
      /*LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D1 --对公客户信息表 --MOD BY LIP 20260408
        ON D1.CUST_ID = TRIM(H.GROUP_PARENT_CORP_ID)
       AND D1.DATA_DT = V_P_DATE
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D2 --个人客户信息表 --MOD BY LIP 20260409
        ON D2.CUST_ID = TRIM(H.GROUP_PARENT_CORP_ID)
       AND D2.DATA_DT = V_P_DATE*/
      LEFT JOIN RRP_MDL.M_CUST_CORP_REL_SUB E --对公客户关联人子表
        ON E.CUST_ID = A.CUST_ID
       AND E.ACT_CNTLR_FLG = 'Y'
       AND E.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = E.ACT_CNTLR_TYP
       AND CODE.SRC_CLASS_CODE = 'C0054' --实控人类型
       AND CODE.TAR_CLASS_CODE = 'C0054' --实控人类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO F --授信额度主表
        ON F.CUST_ID = A.CUST_ID
       AND F.DATA_DT = V_P_DATE
      LEFT JOIN (--通过集团成员授信计算集团授信
                 SELECT G1.GRP_CUST_ID,SUM(G2.CRDT_TOTAL_LMT) AS CRDT_TOTAL_LMT,SUM(G2.ALDY_USE_LMT) AS ALDY_USE_LMT
                   FROM RRP_MDL.M_CUST_CORP_GRPMBR_SUB G1
                  INNER JOIN RRP_MDL.M_CRDT_LMT_INFO G2
                     ON G2.CUST_ID = G1.MBR_CUST_ID
                    AND G2.DATA_DT = V_P_DATE
                  WHERE G1.DATA_DT = V_P_DATE
                  GROUP BY G1.GRP_CUST_ID) G
        ON G.GRP_CUST_ID = A.CUST_ID
      LEFT JOIN RRP_MDL.M_CRDT_LMT_INFO I --授信额度主表
        ON I.CUST_ID = H.MBR_CUST_ID
       AND I.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_IOL_ICMS_GROUP_INFO TA --集群客户概况信息集群客户概况信息 --ADD BY LIP 20240726
        ON TA.GROUPID = A.CUST_ID
       AND TRIM(TA.ACTUALCONTROLLER) IS NOT NULL
       AND TA.ID_MARK <> 'D'
       AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = C.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.DATA_DT = V_P_DATE;

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
    SELECT CJRQ,JTBH,CYKHTYBH,COUNT(1)
      FROM RRP_EAST.EAST5_205_JTKHB T
     WHERE CJRQ = V_P_DATE
     GROUP BY CJRQ,JTBH,CYKHTYBH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_205_JTKHB(CJRQ,JTBH,CYKHTYBH)数据重复';
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

END ETL_EAST5_205_JTKHB;
/

