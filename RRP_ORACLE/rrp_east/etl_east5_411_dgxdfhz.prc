CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_411_DGXDFHZ(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_EAST5_411_DGXDFHZ
  *  功能描述：对公信贷分户账
  *  创建日期：2022-03-07
  *  开发人员：蔡正伟
  *  来源表：  M_LOAN_IN_DUBILL_INFO
  *            M_CUST_CORP_INFO
  *            M_PUM_ORG_INFO_EAST
  *            M_GL_INFO
  *  目标表：  EAST5_411_DGXDFHZ
  *  配置表：  CODE_MAP
  *            CONFIG_ORG_REL
  *            CONFIG_TABLE_LIST
  *  修改日期     修改人      修改项目
  *  20220511     LIP         修改日志写入方式
  *  20221108     LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
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
  V_PROC_NAME        VARCHAR2(100) := UPPER('ETL_EAST5_411_DGXDFHZ'); --存储过程名称
  V_TABLE_NAME       VARCHAR2(100) := UPPER('EAST5_411_DGXDFHZ'); --表名称
BEGIN
  V_P_DATE  := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG        := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  IF V_FREQ_FLAG = '1' THEN
    --新建分区
    V_STEP := 1;
    V_STEP_DESC := '表分区处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_ADD(V_MONTH_END_DATEID, V_TABLE_NAME, 1, O_ERRCODE); --新建分区

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --支持重跑
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '分区表的重跑处理';
    V_STARTTIME := SYSDATE;
    ETL_PARTITION_TRUNCATE(V_MONTH_END_DATEID,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --程序业务逻辑处理主体部分
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '处理对公信贷分户账信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_411_DGXDFHZ
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       ZHMC, --账户名称
       DKFHZH, --贷款分户账号
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       SJLL, --实际利率
       BZ, --币种
       DKJE, --贷款金额
       DKYE, --贷款余额
       FFRQ, --发放日期
       DQRQ, --到期日期
       KHRQ, --开户日期
       XHRQ, --销户日期
       DKZT, --贷款状态
       ZHZT, --账户状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG --归属分支机构
       )
    SELECT /*+USE_HASH(A,D,B,C,CODE,CODE1,ORG,LIST)*/
           SYS_GUID()                                                AS RID, --数据主键
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           B.ORG_ID                                                  AS NBJGH, --内部机构号
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                                     AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                                 AS MXKMMC, --明细科目名称
           A.CUST_ID                                                 AS KHTYBH, --客户统一编号
           --D.CUST_NM                                                 AS ZHMC, --账户名称
           --MOD BY LIP 20230504 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(D.CUST_NM),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(D.CUST_NM),'(','（'),')','）'),' ','')
                ELSE TRIM(D.CUST_NM)
            END                                                      AS ZHMC, --账户名称
           A.ACC_ID                                                  AS DKFHZH, --贷款分户账号
           A.CONT_ID                                                 AS XDHTH, --信贷合同号
           A.RCPT_ID                                                 AS XDJJH, --信贷借据号
           A.EXEC_RATE                                               AS SJLL, --实际利率
           A.CUR                                                     AS BZ, --币种
           A.LOAN_AMT                                                AS DKJE, --贷款金额
           --A.LOAN_BAL + A.INT_ADJ - A.FAIR_VAL_CHG                 AS DKYE, --贷款余额
           CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
            END                                                      AS DKYE, --贷款余额 MODIFY BY LIP 20220427
           NVL(A.LOAN_ACT_DSTR_DT,'99991231')                        AS FFRQ, --发放日期
           --MOD BY LIP 20221214 根据严希婧口径，票据的按原始到期日报送，不报送遇节假日顺延的到期日
           CASE WHEN A.LOAN_BIZ_TYP LIKE '030201%' THEN NVL(A.LOAN_ORIG_EXP_DT,'99991231')
                ELSE NVL(A.LOAN_ACT_EXP_DT,'99991231')
            END                                                      AS DQRQ, --到期日期
           NVL(A.OPEN_ACC_DT,'99991231')                             AS KHRQ, --开户日期
           CASE /*WHEN NVL(A.ACT_END_DT,'99991231') IN ('00010101','20991231','29991231') THEN '99991231'
                ELSE NVL(A.ACT_END_DT,'99991231')*/
                --ADD BY LIP 20260213 调整销户日期取数字段，且当销户日期大于跑批日时，将销户日期置为默认值
                WHEN NVL(A.CNL_ACC_DT,'29991231') IN ('00010101','20991231','29991231') THEN '99991231'
                WHEN A.CNL_ACC_DT > V_P_DATE THEN '99991231'
                ELSE A.CNL_ACC_DT
            END                                                      AS XHRQ, --销户日期
           CASE WHEN A.RCPT_STAT LIKE 'C0201%' THEN '核销'
                --WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转出'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让'
                WHEN A.LOAN_MODAL_CD = 'WRN' THEN '核销'
                WHEN A.RCPT_STAT LIKE 'A%' THEN '正常'
                WHEN A.RCPT_STAT LIKE 'B%' THEN '逾期'
                WHEN A.RCPT_STAT LIKE 'C01%' THEN '结清'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE.TAR_VALUE_NAME,'其他-',''),1,30))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                      AS DKZT, --贷款状态
           CASE WHEN A.ACC_STAT = '01' THEN '正常'
                WHEN A.ACC_STAT = '02' THEN '销户'
                WHEN A.ACC_STAT = '03' THEN '预销户'
                WHEN A.ACC_STAT IN ('04','05','06','07') THEN '冻结'
                WHEN A.ACC_STAT = '11' THEN '止付'
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE1.TAR_VALUE_NAME,'其他-',''),1,30))--MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                                      AS ZHZT, --账户状态
           /*ADD BY LIP 20220616 严希婧确认
             对公信贷分户账“ 弱校验 贷款余额应当大于或等于零;
             弱校验 当贷款状态为结清、核销、转让，或账户状态为销户时，贷款余额应为0;”
             统一备注“票据转贴现业务已结清，因系统T+1跑批处理导致贷款余额小于0”*/
           CASE WHEN CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                          WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                          ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
                      END < 0 OR
                     (CASE WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID NOT LIKE '1301%' THEN NVL(A.LOAN_BAL,0)
                          WHEN V_P_DATE <= '20201231' AND A.SUBJ_ID LIKE '1301%' THEN NVL(A.LOAN_BAL,0) - NVL(A.INT_ADJ,0)
                          ELSE NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0)
                      END <> 0
                      AND (A.RCPT_STAT LIKE 'C%' OR A.ACC_STAT = '02'))
                 THEN '票据转贴现业务已结清，因系统T+1跑批处理导致贷款余额小于0'
            END                                                      AS BBZ, --备注
           V_MONTH_END_DATEID                                        AS CJRQ, --采集日期
           '000'                                                     AS DEPT_NO, --部门编号
           '01'                                                      AS SRC_SYS_ID, --来源系统ID
           '000000'                                                  AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                                          AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG --归属分支机构
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
     INNER /*LEFT*/ JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8)---科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = A.RCPT_STAT
       AND CODE.SRC_CLASS_CODE = 'D0007' --贷款状态
       AND CODE.TAR_CLASS_CODE = 'D0007' --贷款状态
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.ACC_STAT
       AND CODE1.SRC_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.TAR_CLASS_CODE = 'Z0018' --账户状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE (A.LOAN_BIZ_TYP NOT LIKE '01%' OR A.LOAN_BIZ_TYP LIKE '90%')
       AND A.LOAN_BIZ_TYP <> '99' --ADD 20221129 LHQ  非标的只有金数和存保用,EAST剔除
       AND A.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND A.AD_CSH_FLG = '0' --ADD BY LIP 20230616 剔除过路垫款
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --表分析
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '判断数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT DKFHZH,XDJJH,BZ,CJRQ,COUNT(1)
      FROM RRP_EAST.EAST5_411_DGXDFHZ T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY DKFHZH,XDJJH,BZ,CJRQ
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_411_DGXDFHZ(CJRQ,DKFHZH,XDJJH,BZ)数据重复';
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

END ETL_EAST5_411_DGXDFHZ;
/

