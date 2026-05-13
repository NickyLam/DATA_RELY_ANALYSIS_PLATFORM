CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_509_PJZTXB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/***********************************************************************
  **  存储过程详细说明：票据转贴现表
  **  存储过程名称:  ETL_EAST5_509_PJZTXB
  **  存储过程创建日期:2022-07-13
  **  存储过程创建人:付善斌
  **  来源表:
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_BILL_INFO           --票据票面表
  **        M_CUST_CORP_INFO      --对公客户信息
  **        O_ICL_CMM_BILL_DISCOUNT_INFO A --转贴现信息表
  **        M_CPTL_REPO_LBY_INFO A --回购业务（负债方）信息
  **        M_CPTL_REPO_AST_INFO A --回购业务（资产方）信息
  **        M_CPTL_REDISC_INFO A --再贴现信息表
  **  目标表:
  **         EAST5_509_PJZTXB
  **
  **  修改日期     修改人          修改原因
       20221207      LHQ           修改转贴现买断交易对手名称，交易对手行号取值
  ************************************************************************/
IS
  V_P_DATE           VARCHAR2(8);      --数据日期
  V_START_DT         VARCHAR2(8);      --月初
  V_MONTH_END_DATEID VARCHAR2(8);      --本月月底日期
  V_PARTITION_NAME   VARCHAR2(100);    --分区名称
  V_FREQ_FLAG        VARCHAR2(10);     --跑批频度
  V_STEP             INTEGER := 0;     --任务号
  V_SQLCOUNT         INTEGER := 0;     --更新或删除影响的记录数
  V_STARTTIME        DATE := SYSDATE;  --处理开始时间
  V_ENDTIME          DATE := SYSDATE;  --处理结束时间
  V_SQLMSG           VARCHAR2(300);    --SQL执行描述信息
  V_STEP_DESC        VARCHAR2(100);    --处理步骤描述
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_509_PJZTXB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_509_PJZTXB'; --存储过程名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_START_DT := TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD'); --月初
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')),'YYYYMMDD');
  V_PARTITION_NAME   := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN
    --增加分区
    V_STEP := 1;
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
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE, V_TABLE_NAME, O_ERRCODE); --清空当日分区以便重跑

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-插入转贴现买断正常及到期数据';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_EAST.EAST5_509_PJZTXB_TEMP01';
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
      JRXKZH, --金融许可证号
      NBJGH, --内部机构号
      YHJGMC, --银行机构名称
      XDHTH, --信贷合同号
      XDJJH, --信贷借据号
      PJHM, --票据号码
      PJLX, --票据类型
      BZ, --币种
      PMJE, --票面金额
      PJCPRQ, --票据出票日期
      PJDQRQ, --票据到期日期
      CPRMC, --出票人名称
      CDRMC, --承兑人名称
      TXRMC, --贴现人名称
      TXRQ, --贴现日期
      JYFX, --交易方向
      ZTXLB, --转贴现类别
      ZTXRQ, --转贴现日期
      ZTXJE, --转贴现金额
      ZTXJXTS, --转贴现计息天数
      ZTXLL, --转贴现利率
      ZTXLX, --转贴现利息
      HGRQ, --回购日期
      HGJE, --回购金额
      HGLV, --回购利率
      HGLX, --回购利息
      JYDSMC, --交易对手名称
      JYDSHH, --交易对手行号
      PJZT, --票据状态
      BBZ, --备注
      CJRQ, --采集日期
      DEPT_NO, --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO, --填报机构
      ORG_NO, --报送机构
      ADDRESS, --归属地
      GSFZJG,  --归属分支机构
      PJHM_OLD --票据号码 --ADD BY LIP 20240726
      )
    SELECT SYS_GUID()                                               AS RID, --数据主键
           B.FIN_PERMIT_NO                                          AS JRXKZH, --金融许可证号
           --A.ORG_ID                                                 AS NBJGH, --内部机构号
           B.ORG_ID                                                 AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                                 AS YHJGMC, --银行机构名称
           A.CONT_ID                                                AS XDHTH, --信贷合同号
           A.RCPT_ID                                                AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.BILL_NO)                                AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.BILL_NO
            END                                                     AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                                      AS PJLX, --票据类型
           A.CUR                                                    AS BZ, --币种
           C.BILL_PAR_AMT                                           AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT,'99991231')                            AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                            AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                              AS CPRMC, --出票人名称
           C.ACPTR_NM                                               AS CDRMC, --承兑人名称
           C.ORIG_DISC_PSN_NM                                       AS TXRMC, --贴现人名称
           NVL(NVL(C.ORIG_DISC_DT,A.LOAN_ACT_DSTR_DT),'99991231')   AS TXRQ, --贴现日期 --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
           '买入'                                                   AS JYFX, --交易方向
           '转贴现买断'                                             AS ZTXLB, --转贴现类别
           NVL(A.LOAN_ACT_DSTR_DT,'99991231')                       AS ZTXRQ, --转贴现日期--MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
           A.BILL_ACT_AMT                                           AS ZTXJE, --转贴现金额   添加BILL_ACT_AMT字段后取消注释
           --TO_DATE(C.BILL_EXP_DT,'YYYY-MM-DD')-TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数   --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
           M.ACTL_EXP_DT-TO_DATE(A.LOAN_ACT_DSTR_DT,'YYYY-MM-DD')   AS ZTXJXTS, --转贴现计息天数   --MOD BY LIP 20251225
           A.EXEC_RATE                                              AS ZTXLL, --转贴现利率
           /*C.BILL_PAR_AMT * (TO_DATE(C.BILL_EXP_DT, 'YYYY-MM-DD') -
           TO_DATE(A.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD')) / 360 * A.EXEC_RATE / 100 AS ZTXLX, --转贴现利息*/--这么计算会漏算顺延天数，导致利息对不上，调整为直取 modify by tangan at 20220524
           A.ACCRD_INT                                              AS ZTXLX, --转贴现利息
           '99991231'                                               AS HGRQ, --回购日期
           0                                                        AS HGJE, --回购金额
           0                                                        AS HGLV, --回购利率
           0                                                        AS HGLX, --回购利息
           M.CNTPTY_NAME                                            AS JYDSMC,  --交易对手名称  --20221207 LHQ 修改交易对手行号取值
           M.CNTPTY_BANK_NO                                         AS JYDSHH,  --交易对手行号  --20221207 LHQ 修改交易对手行号取值
           /*D.CUST_NM                                                AS JYDSMC, --交易对手名称 --modify 20220616 根据源系统林旭华和业务确认后，修改口径 laihaiqiang
           D.PBC_NO                                                 AS JYDSHH, --交易对手行号 --modify 20220616 根据源系统林旭华和业务确认后，修改口径 laihaiqiang*/
           --'正常'                                                   AS PJZT, --票据状态
           --CODE1.TAR_VALUE_NAME                                    AS PJZT, --票据状态
           /*CASE WHEN CODE1.TAR_VALUE_NAME = '正常' THEN '正常'
                WHEN C.BILL_STAT = '02' THEN '卖断'
                ELSE '其他-到期'
            END                                                     AS PJZT, --票据状态*/
           --MOD BY LIP 20230602 因票据中心的状态不对，所以改成通过借据的净值判断票据状态
           --CASE WHEN NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0)- NVL(A.INT_ADJ,0) <>0 THEN '正常'
           --MOD BY LIP 20230710 只用票据的余额判断
           CASE WHEN NVL(A.LOAN_BAL,0) <> 0 THEN '正常'
                --WHEN C.BILL_STAT = '02' THEN '卖断'
                WHEN C.BILL_STAT = 'S04' THEN '卖断' --MOD BY LIP 20250826
                WHEN C.BILL_STAT = 'S14' THEN '解付' --MOD BY LIP 20250826
                ELSE '其他-到期'
            END                                                     AS PJZT, --票据状态
           ''                                                       AS BBZ, --备注
           V_MONTH_END_DATEID                                       AS CJRQ, --采集日期
           '000'                                                    AS DEPT_NO, --部门编号
           '01'                                                     AS SRC_SYS_ID, --来源系统ID
           '000000'                                                 AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                           AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                     AS ADDRESS,--归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                     AS GSFZJG,  --归属分支机构
           NVL(C.BILL_NUM,A.BILL_NO)                                AS PJHM_OLD --票据号码 --ADD BY LIP 20240726
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
      LEFT JOIN RRP_MDL.ORG_CONFIG T1 --机构转换表 --ADD BY LIP 20260408
        ON T1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        --ON B.ORG_ID = A.ORG_ID
        ON B.ORG_ID = NVL(T1.ORG_ID1,'800') --MOD BY LIP 20260408
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_BILL_INFO C --票据票面表
        ON C.BILL_NO = A.BILL_NO
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO M --20221207 LHQ 因表内借据表未加工交易对手信息，因此从票据转贴现信息中直取
        ON M.BILL_ID = A.BILL_NO
       AND M.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
       AND M.ENTRY_STATUS_CD = '03'
       AND M.TRAN_DIR_CD = '01'  --买入
       AND M.ETL_DT =  TO_DATE(V_P_DATE,'YYYY-MM-DD')
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.LOAN_BIZ_TYP LIKE '0302%'
       --AND C.BILL_STAT NOT IN ('S04','21') --MODIFY BY TANGAN AT 20221202 模型调整了码值，直取源系统
       AND A.CNL_ACC_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --剔除上月结清数据
       AND (NVL(C.BILL_EXP_DT,'99991231')>= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD')
            OR NVL(A.LOAN_BAL,0) + NVL(A.FAIR_VAL_CHG,0) - NVL(A.INT_ADJ,0) <> 0) --MOD BY LIP 20240911 根据业务要求过滤数据
       AND A.EAST_FLG = 'Y' --ADD 20230103 LHQ 增加月批次标志
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-插入转贴现卖断数据';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
      JRXKZH, --金融许可证号
      NBJGH, --内部机构号
      YHJGMC, --银行机构名称
      XDHTH, --信贷合同号
      XDJJH, --信贷借据号
      PJHM, --票据号码
      PJLX, --票据类型
      BZ, --币种
      PMJE, --票面金额
      PJCPRQ, --票据出票日期
      PJDQRQ, --票据到期日期
      CPRMC, --出票人名称
      CDRMC, --承兑人名称
      TXRMC, --贴现人名称
      TXRQ, --贴现日期
      JYFX, --交易方向
      ZTXLB, --转贴现类别
      ZTXRQ, --转贴现日期
      ZTXJE, --转贴现金额
      ZTXJXTS, --转贴现计息天数
      ZTXLL, --转贴现利率
      ZTXLX, --转贴现利息
      HGRQ, --回购日期
      HGJE, --回购金额
      HGLV, --回购利率
      HGLX, --回购利息
      JYDSMC, --交易对手名称
      JYDSHH, --交易对手行号
      PJZT, --票据状态
      BBZ, --备注
      CJRQ, --采集日期
      DEPT_NO, --部门编号
      SRC_SYS_ID, --来源系统ID
      ISSUED_NO, --填报机构
      ORG_NO, --报送机构
      ADDRESS, --归属地
      GSFZJG,  --归属分支机构
      PJHM_OLD --票据号码  --ADD BY LIP 20240726
      )
    SELECT SYS_GUID()                                                AS RID, ---数据主键
           B.FIN_PERMIT_NO                                           AS JRXKZH, --金融许可证号
           --N.ORG_ID1                                                 AS NBJGH, --内部机构号
           B.ORG_ID                                                  AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                                  AS YHJGMC, --银行机构名称
           /*A.CONT_ID                                                 AS XDHTH, --信贷合同号
           A.RCPT_ID                                                 AS XDJJH, --信贷借据号*/
           NULL                                                      AS XDHTH, --信贷合同号
           NULL                                                      AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.BILL_NUM)                                AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.BILL_NUM
            END                                                      AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                                       AS PJLX, --票据类型
           A.CURR_CD                                                 AS BZ, --币种
           C.BILL_PAR_AMT                                            AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT,'99991231')                             AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                             AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                               AS CPRMC, --出票人名称
           C.ACPTR_NM                                                AS CDRMC, --承兑人名称
           --D.CUST_NM                                                 AS TXRMC, --贴现人名称
           --ORIG_DISC_PSN_NM                                          AS TXRMC, --贴现人名称
           NVL(C.ORIG_DISC_PSN_NM,BF_CNTPTY_NAME)                    AS TXRMC, --贴现人名称    20220804 MODIFY LHQ 转贴现卖断数据
           NVL(C.ORIG_DISC_DT,'99991231')                            AS TXRQ, --贴现日期
           --CASE WHEN C.BILL_STAT = '02' THEN '卖出' ELSE '买入' END  AS JYFX, --交易方向
           '卖出'                                                    AS JYFX, --交易方向
           --CASE WHEN C.BILL_STAT = '02' THEN '转贴现卖断' ELSE '转贴现买断' END AS ZTXLB, --转贴现类别
           '转贴现卖断'                                              AS ZTXLB, --转贴现类别
           --NVL(A.LOAN_ACT_DSTR_DT, '99991231')                       AS ZTXRQ, --转贴现日期  --MODIFY 20220614
           NVL(TO_CHAR(A.BUS_DT,'YYYYMMDD'),'99991231')              AS ZTXRQ, --转贴现日期
           A.STL_AMT                                                 AS ZTXJE, --转贴现金额
           A.ACTL_EXP_DT - A.BUS_DT                                  AS ZTXJXTS, --转贴现计息天数
           A.DISCNT_INT_RAT                                          AS ZTXLL, --转贴现利率
           --\*C.BILL_PAR_AMT *(TO_DATE(C.BILL_EXP_DT,'YYYY-MM-DD') -
           --TO_DATE(A.LOAN_ACT_DSTR_DT, 'YYYY-MM-DD'))/360 * A.EXEC_RATE/100 AS ZTXLX, --转贴现利息*\--这么计算会漏算顺延天数，导致利息对不上，调整为直取 MODIFY BY LAIHAIQIANG AT 202
           A.INT_AMT                                                 AS ZTXLX, --转贴现利息
           '99991231'                                                AS HGRQ, --回购日期
           0                                                         AS HGJE, --回购金额
           0                                                         AS HGLV, --回购利率
           0                                                         AS HGLX, --回购利息
           NVL(A.CNTPTY_NAME,D.CUST_NM)                                                 AS JYDSMC, --交易对手名称
           NVL(A.CNTPTY_BANK_NO,D.PBC_NO)                            AS JYDSHH, --交易对手行号
           --CODE1.TAR_VALUE_NAME                                     AS PJZT, --票据状态
           CASE WHEN C.BILL_STAT = 'S04' THEN '卖断'
                WHEN C.BILL_STAT = 'S21' THEN '解付'
            END                                                      AS PJZT, --票据状态
           ''                                                        AS BBZ, --备注
           V_MONTH_END_DATEID                                        AS CJRQ, --采集日期
           '000'                                                     AS DEPT_NO, --部门编号
           '01'                                                      AS SRC_SYS_ID, --来源系统ID
           '000000'                                                  AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                            AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                      AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                      AS GSFZJG, --归属分支机构 --MODIFY BY LIP
           NVL(C.BILL_NUM,A.BILL_NUM)                                AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO A --转贴现信息表
     INNER JOIN RRP_MDL.M_BILL_INFO C --票据票面表
        ON C.BILL_NUM = A.BILL_NUM
       AND C.BILL_NO = A.BILL_ID
       AND C.BILL_STAT IN ('S04','21') --MODIFY BY TANGAN AT 20221202 模型调整了码值，直取源系统
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG N --机构映射表
        --ON N.ORG_ID = A.BUS_ORG_ID
        ON N.ORG_ID = A.ACCT_INSTIT_ID --MODIFY 20230203 LHQ 应改为取账务机构
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(N.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CNTPTY_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = N.ORG_ID1
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
       AND A.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
       AND A.TRAN_DIR_CD = '02' --转贴现买出
       AND A.BUS_DT >= TO_DATE(V_START_DT,'YYYYMMDD')
       AND A.BUS_DT <= TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD') --跑当月数据
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    /*V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-卖出回购（票据）-其他到期';
    V_STARTTIME := SYSDATE;
    INSERT \*+APPEND*\ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG   --归属分支机构
       )    --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT \*MD5(V_MONTH_END_DATEID || NVL(C.BILL_NO,A.ULYG_PROD_ID) || A.ORG_ID||A.REPO_BIZ_TYP||CODE1.TAR_VALUE_NAME) AS RID, --数据主键*\
           SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           A.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           ''                                                  AS XDHTH, --信贷合同号
           ''                                                  AS XDJJH, --信贷借据号
           NVL(C.BILL_NUM,A.ULYG_PROD_ID)                      AS PJHM, --票据号码
           CODE.TAR_VALUE_NAME                                 AS PJLX, --票据类型
           A.CUR                                               AS BZ, --币种
           A.AMT                                               AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT, '99991231')                      AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT, '99991231')                      AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                         AS CPRMC, --出票人名称
           C.ACPTR_NM                                          AS CDRMC, --承兑人名称
           --D.CUST_NM                                           AS TXRMC, --贴现人名称
           C.ORIG_DISC_PSN_NM                                  AS TXRMC, --贴现人名称
           NVL(C.ORIG_DISC_DT, '99991231')                     AS TXRQ, --贴现日期
           '卖出'                                              AS JYFX, --交易方向
           CASE WHEN A.REPO_BIZ_TYP = '20101' THEN '质押式回购正回购'
                WHEN A.REPO_BIZ_TYP = '20102' THEN '买断式回购正回购'
            END                                                AS ZTXLB, --转贴现类别
           NVL(A.START_DT, '99991231')                         AS ZTXRQ, --转贴现日期
           \*A.BAL                                               AS ZTXJE, --转贴现金额
            SIT回归 20220913 根据新旧对比数据，观察旧数据：回购金额-回购利息与转贴现金额相同，暂改。旧east使用A.STL_AMT 结算金额 ，新 回购业务（负债方）信息无此字段*\
           --A.BAL-A.APPT_RESL_OR_REPO_INT     AS ZTXJE, --转贴现金额
           A.APPT_RESL_OR_REPO_PRC-A.APPT_RESL_OR_REPO_INT     AS ZTXJE, --转贴现金额
           TO_DATE(A.APPT_RESL_OR_REPO_DT,'YYYY-MM-DD')-TO_DATE(A.START_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数
           A.ACT_RATE                                          AS ZTXLL, --转贴现利率
          \*C.BILL_PAR_AMT * (TO_DATE(C.BILL_EXP_DT, 'YYYY-MM-DD') -
           TO_DATE(A.START_DT, 'YYYY-MM-DD')) / 360 * A.ACT_RATE / 100 AS ZTXLX, --转贴现利息*\--这么计算会漏算顺延天数，导致利息对不上，调整为直取 modify by laihaiqiang at 20220602
           \*A.INT                                               AS ZTXLX, --转贴现利息
           SIT回归 20220913 根据旧表暂改，观察旧数据：与回购利息相同，暂改。旧east使用A.INT_AMT 利息金额，新 回购业务（负债方）信息无此字段*\
           A.INT_AMT                                           AS ZTXLX, --转贴现利息
           NVL(A.ACT_END_DT, '99991231')                       AS HGRQ, --回购日期
           A.APPT_RESL_OR_REPO_PRC                             AS HGJE, --回购金额
           A.APPT_RESL_OR_REPO_RATE                            AS HGLV, --回购利率
           A.APPT_RESL_OR_REPO_INT                             AS HGLX, --回购利息
           A.CNTPTY_NAME                                       AS JYDSMC, --交易对手名称  --20221207 LHQ 修改交易对手行号取值
           A.CNTPTY_BANK_NO                                    AS JYDSHH, --交易对手行号   --20221207 LHQ 修改交易对手行号取值
           \*D.CUST_NM                                           AS JYDSMC, --交易对手名称
           D.PBC_NO                                            AS JYDSHH, --交易对手行号*\
           --CODE1.TAR_VALUE_NAME                                AS PJZT, --票据状态
           '其他-到期'                                         AS PJZT, --票据状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           --A.ORG_ID                                            AS ISSUED_NO, --填报机构
            --A.DEPT_LINE                                        AS ISSUED_NO, --填报机构
           '000000'                                            AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           --B.GSFZJG                                            AS GSFZJG--归属分支机构
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG--归属分支机构
      FROM RRP_MDL.M_CPTL_REPO_LBY_INFO A --回购业务（负债方）信息
      --LEFT JOIN RRP_MDL.B_BILL_INFO C --票据票面表
     INNER JOIN RRP_MDL.M_BILL_INFO C --票据票面表 -- MODIFY 20220607 更改关联逻辑 剔除票据票面表失效票据 LAIHAIQIANG
        ON C.BILL_NO = A.ULYG_PROD_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = A.ORG_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.REPO_BIZ_TYP IN ('20101','20102') --卖出回购
       AND A.OPR_TYP = 'A' --自营
       AND A.ULYG_AST_TYP = '2' --票据业务回购 ADD BY 20220629 区分票据和债券业务  LAIHAIQIANG
       --AND CODE1.TAR_VALUE_NAME <> '正常'
       --AND A.APPT_RESL_OR_REPO_DT <= V_DATEDT --跑半年数据
       AND A.APPT_RESL_OR_REPO_DT >= V_START_DT
       AND A.APPT_RESL_OR_REPO_DT <= V_MONTH_END_DATEID --跑批当月数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

    V_STEP    := V_STEP + 1;
    V_STEP_DESC  := '票据转贴现表-卖出回购（票据）-正常';
    V_STARTTIME  := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       ) --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           --A.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_ID                                            AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           ''                                                  AS XDHTH, --信贷合同号
           ''                                                  AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.ULYG_PROD_ID)                      AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.ULYG_PROD_ID
            END                                                AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                                 AS PJLX, --票据类型
           A.CUR                                               AS BZ, --币种
           --A.AMT                                               AS PMJE, --票面金额
           C.BILL_PAR_AMT                                      AS PMJE, --票面金额 --MOD BY LIP 20240726
           NVL(C.BILL_ISU_DT,'99991231')                       AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                       AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                         AS CPRMC, --出票人名称
           C.ACPTR_NM                                          AS CDRMC, --承兑人名称
           --D.CUST_NM                                           AS TXRMC, --贴现人名称
           C.ORIG_DISC_PSN_NM                                  AS TXRMC, --贴现人名称
           NVL(C.ORIG_DISC_DT,'99991231')                      AS TXRQ, --贴现日期
           '卖出'                                              AS JYFX, --交易方向
           CASE WHEN A.REPO_BIZ_TYP = '20101' THEN '质押式回购正回购'
                WHEN A.REPO_BIZ_TYP = '20102' THEN '买断式回购正回购'
            END                                                AS ZTXLB, --转贴现类别
           NVL(A.START_DT,'99991231')                          AS ZTXRQ, --转贴现日期
           A.STL_AMT                                           AS ZTXJE, --转贴现金额
           --A.BAL                                               AS ZTXJE, --转贴现金额  20221207 LHQ
           TO_DATE(A.APPT_RESL_OR_REPO_DT,'YYYY-MM-DD')-TO_DATE(A.START_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数
           A.ACT_RATE                                          AS ZTXLL, --转贴现利率
           /*C.BILL_PAR_AMT * (TO_DATE(C.BILL_EXP_DT, 'YYYY-MM-DD') -
           TO_DATE(A.START_DT, 'YYYY-MM-DD')) / 360 * A.ACT_RATE / 100 AS ZTXLX, --转贴现利息*/--这么计算会漏算顺延天数，导致利息对不上，调整为直取 modify by laihaiqiang at 20220602
           --A.INT                                               AS ZTXLX, --转贴现利息
           A.INT_AMT                                           AS ZTXLX, --转贴现利息    20221207 LHQ
           NVL(A.APPT_RESL_OR_REPO_DT,'99991231')              AS HGRQ, --回购日期
           A.APPT_RESL_OR_REPO_PRC                             AS HGJE, --回购金额
           A.APPT_RESL_OR_REPO_RATE                            AS HGLV, --回购利率
           A.APPT_RESL_OR_REPO_INT                             AS HGLX, --回购利息
           /*D.CUST_NM                                           AS JYDSMC, --交易对手名称
           D.PBC_NO                                            AS JYDSHH, --交易对手行号*/
           A.CNTPTY_NAME                                       AS JYDSMC, --交易对手名称  --20221207 LHQ 修改交易对手行号取值
           A.CNTPTY_BANK_NO                                    AS JYDSHH, --交易对手行号  --20221207 LHQ 修改交易对手行号取值
           --CODE1.TAR_VALUE_NAME                               AS PJZT, --票据状态
           CASE WHEN CODE1.TAR_VALUE_NAME = '正常' THEN '正常'
                ELSE '其他-到期'
            END                                                AS PJZT, --票据状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.ULYG_PROD_ID)                      AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_MDL.M_CPTL_REPO_LBY_INFO A --回购业务（负债方）信息
      --LEFT JOIN B_BILL_INFO C --票据票面表
     INNER JOIN RRP_MDL.M_BILL_INFO C --票据票面表 --MODIFY 20220607 更改关联逻辑 剔除票据票面表失效票据 LAIHAIQIANG
        ON C.BILL_NO = A.ULYG_PROD_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG T1 --机构映射表 --ADD BY LIP 20260408
        ON T1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        --ON B.ORG_ID = A.ORG_ID
        ON B.ORG_ID = NVL(T1.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.REPO_BIZ_TYP IN ('20101','20102') --卖出回购
       AND A.OPR_TYP = 'A' --自营
       AND A.STL_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM'),'YYYYMMDD') --ADD BY 20230206  LAIHAIQIANG  根据业务董碧涛口径修改
       AND A.ULYG_AST_TYP = '2'--票据业务回购  ADD BY 20220629 区分票据和债券业务  LAIHAIQIANG
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC  := '票据转贴现表-买入返售（票据）-到期';
    V_STARTTIME  := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       ) --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT SYS_GUID()                                        AS RID, --数据主键
           B.FIN_PERMIT_NO                                   AS JRXKZH, --金融许可证号
           --A.ORG_ID                                          AS NBJGH, --内部机构号
           B.ORG_ID                                          AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                          AS YHJGMC, --银行机构名称
           ''                                                AS XDHTH, --信贷合同号
           ''                                                AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.ULYG_PROD_ID)                    AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.ULYG_PROD_ID
            END                                              AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                               AS PJLX, --票据类型
           A.CUR                                             AS BZ, --币种
           --A.AMT                                             AS PMJE, --票面金额
           C.BILL_PAR_AMT                                    AS PMJE, --票面金额 --MOD BY LIP 20240726
           NVL(C.BILL_ISU_DT,'99991231')                     AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                     AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                       AS CPRMC, --出票人名称
           C.ACPTR_NM                                        AS CDRMC, --承兑人名称
           --D.CUST_NM                                         AS TXRMC, --贴现人名称
           ORIG_DISC_PSN_NM                                  AS TXRMC, --贴现人名称
           NVL(C.ORIG_DISC_DT,'99991231')                    AS TXRQ, --贴现日期
           '买入'                                            AS JYFX, --交易方向
           CASE WHEN A.REPO_BIZ_TYP = '10101' THEN '质押式回购逆回购'
                WHEN A.REPO_BIZ_TYP = '10102' THEN '买断式回购逆回购'
            END                                              AS ZTXLB, --转贴现类别
           NVL(A.START_DT,'99991231')                        AS ZTXRQ, --转贴现日期
           --A.BAL                                             AS ZTXJE, --转贴现金额
           --MOD BY LIP 20230706 取转贴现的结算金额
           A.AMT                                             AS ZTXJE, --转贴现金额
           TO_DATE(A.APPT_RESL_OR_REPO_DT,'YYYY-MM-DD')-TO_DATE(A.START_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数
           A.ACT_RATE                                        AS ZTXLL, --转贴现利率
           /*C.BILL_PAR_AMT * (TO_DATE(C.BILL_EXP_DT, 'YYYY-MM-DD') -
           TO_DATE(A.START_DT, 'YYYY-MM-DD')) / 360 * A.ACT_RATE / 100 AS ZTXLX, --转贴现利息*/ --这么计算会漏算顺延天数，导致利息对不上，调整为直取 modify by laihaiqiang at 20220602
           A.INT                                             AS ZTXLX, --转贴现利息
           NVL(A.APPT_RESL_OR_REPO_DT,'99991231')            AS HGRQ, --回购日期
           A.APPT_RESL_OR_REPO_PRC                           AS HGJE, --回购金额
           A.APPT_RESL_OR_REPO_RATE                          AS HGLV, --回购利率
           A.APPT_RESL_OR_REPO_INT                           AS HGLX, --回购利息
           /*D.CUST_NM                                         AS JYDSMC, --交易对手名称
           --B.PBC_NO                                          AS JYDSHH, --交易对手行号
           D.PBC_NO                                          AS JYDSHH, --交易对手行号*/
           --MOD BY LIP 20251219 一表通测试发现客户号对应的客户和实际交易对手的不一致
           CASE WHEN REGEXP_REPLACE(TRIM(T8.CNTPTY_NAME),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T8.CNTPTY_NAME),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(TRIM(T8.CNTPTY_NAME),CHR(10),''),CHR(13),'')
            END                                              AS JYDSMC, --交易对手名称
           TRIM(T8.CNTPTY_BANK_NO)                           AS JYDSHH, --交易对手行号
           '其他-到期'                                       AS PJZT, --票据状态
           --CODE1.TAR_VALUE_NAME                             AS PJZT, --票据状态
           ''                                                AS BBZ, --备注
           V_MONTH_END_DATEID                                AS CJRQ, --采集日期
           '000'                                             AS DEPT_NO, --部门编号
           '01'                                              AS SRC_SYS_ID, --来源系统ID
           '000000'                                          AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                              AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                              AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.ULYG_PROD_ID)                    AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_MDL.M_CPTL_REPO_AST_INFO A --回购业务（资产方）信息
     INNER JOIN RRP_MDL.M_BILL_INFO C --票据票面表 --MODIFY 20220607 更改关联逻辑 剔除票据票面表失效票据 LAIHAIQIANG
        ON C.BILL_NO = A.ULYG_PROD_ID
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.ORG_CONFIG T1 --机构映射表 --ADD BY LIP 20260408
        ON T1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(T1.ORG_ID1,'800') --A.ORG_ID --MOD BY LIP 20260408
       AND B.DATA_DT = V_P_DATE
      /*LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE*/
      LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T8 --票据转贴现信息
        ON T8.BUS_ID = A.BUS_ID
       AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.REPO_BIZ_TYP IN ('10101','10102') --买入返售
       AND A.OPR_TYP = 'A' --自营
       AND A.ULYG_AST_TYP = '2' --票据业务回购  ADD BY 20220629 区分票据和债券业务 LAIHAIQIANG
       AND A.APPT_RESL_OR_REPO_DT >= V_START_DT
       AND A.APPT_RESL_OR_REPO_DT <= V_MONTH_END_DATEID --跑批当月数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-买入返售（票据）-正常';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       ) --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT SYS_GUID()                                          AS RID, --数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           --A.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_ID                                            AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           ''                                                  AS XDHTH, --信贷合同号
           ''                                                  AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.ULYG_PROD_ID)                      AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.ULYG_PROD_ID
            END                                                AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                                 AS PJLX, --票据类型
           A.CUR                                               AS BZ, --币种
           --A.AMT                                               AS PMJE, --票面金额
           C.BILL_PAR_AMT                                      AS PMJE, --票面金额 --MOD BY LIP 20240726
           NVL(C.BILL_ISU_DT,'99991231')                       AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                       AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                         AS CPRMC, --出票人名称
           C.ACPTR_NM                                          AS CDRMC, --承兑人名称
           --D.CUST_NM                                           AS TXRMC, --贴现人名称
           ORIG_DISC_PSN_NM                                    AS TXRMC, --贴现人名称
           NVL(C.ORIG_DISC_DT,'99991231')                      AS TXRQ, --贴现日期
           '买入'                                              AS JYFX, --交易方向
           CASE WHEN A.REPO_BIZ_TYP = '10101' THEN '质押式回购逆回购'
                WHEN A.REPO_BIZ_TYP = '10102' THEN '买断式回购逆回购'
            END                                                AS ZTXLB, --转贴现类别
           NVL(A.START_DT,'99991231')                          AS ZTXRQ, --转贴现日期
           --A.BAL                                             AS ZTXJE, --转贴现金额
           --MOD BY LIP 20230706 取转贴现的结算金额
           A.AMT                                               AS ZTXJE, --转贴现金额
           TO_DATE(A.APPT_RESL_OR_REPO_DT,'YYYY-MM-DD')-TO_DATE(A.START_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数
           A.ACT_RATE                                          AS ZTXLL, --转贴现利率
           /* C.BILL_PAR_AMT * (TO_DATE(C.BILL_EXP_DT, 'YYYY-MM-DD') -
           TO_DATE(A.START_DT, 'YYYY-MM-DD')) / 360 * A.ACT_RATE / 100 AS ZTXLX, --转贴现利息*/ --这么计算会漏算顺延天数，导致利息对不上，调整为直取 modify by laihaiqiang at 20220602
           A.INT                                               AS ZTXLX, --转贴现利息
           NVL(A.APPT_RESL_OR_REPO_DT, '99991231')             AS HGRQ, --回购日期
           A.APPT_RESL_OR_REPO_PRC                             AS HGJE, --回购金额
           A.APPT_RESL_OR_REPO_RATE                            AS HGLV, --回购利率
           A.APPT_RESL_OR_REPO_INT                             AS HGLX, --回购利息
           /*D.CUST_NM                                           AS JYDSMC, --交易对手名称
           --B.PBC_NO                                            AS JYDSHH, --交易对手行号
           D.PBC_NO                                            AS JYDSHH, --交易对手行号*/
           --MOD BY LIP 20251219 一表通测试发现客户号对应的客户和实际交易对手的不一致
           CASE WHEN REGEXP_REPLACE(TRIM(T8.CNTPTY_NAME),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T8.CNTPTY_NAME),'(','（'),')','）'),' ','')
                ELSE REPLACE(REPLACE(TRIM(T8.CNTPTY_NAME),CHR(10),''),CHR(13),'')
            END                                              AS JYDSMC, --交易对手名称
           TRIM(T8.CNTPTY_BANK_NO)                           AS JYDSHH, --交易对手行号
           '正常'                                              AS PJZT, --票据状态
           --CODE1.TAR_VALUE_NAME                                AS PJZT, --票据状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.ULYG_PROD_ID)                      AS PJHM_OLD --票据号码 --ADD BY LIP 20240726
      FROM RRP_MDL.M_CPTL_REPO_AST_INFO A --回购业务（资产方）信息
      LEFT JOIN RRP_MDL.ORG_CONFIG T1 --机构映射表 --ADD BY LIP 20260408
        ON T1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(T1.ORG_ID1,'800')--A.ORG_ID
       AND B.DATA_DT = V_P_DATE
     INNER JOIN RRP_MDL.M_BILL_INFO C --票据票面表 --MODIFY 20220607 更改关联逻辑 剔除票据票面表失效票据 LAIHAIQIANG
        ON C.BILL_NO = A.ULYG_PROD_ID
       AND C.DATA_DT = V_P_DATE
      /*LEFT JOIN RRP_MDL.M_CUST_CORP_INFO D --对公客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE*/
      LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO T8 --票据转贴现信息
        ON T8.BUS_ID = A.BUS_ID
       AND T8.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.REPO_BIZ_TYP IN ('10101','10102') --买入返售
       AND A.OPR_TYP = 'A' --自营
       AND A.ULYG_AST_TYP = '2' --票据业务回购  ADD BY 20220629 区分票据和债券业务  LAIHAIQIANG
       AND A.ACT_END_DT IS NULL
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-再贴现-当期余额等于零';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       )   --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT SYS_GUID()                                        AS RID, --数据主键
           B.FIN_PERMIT_NO                                   AS JRXKZH, --金融许可证号
           --A.ORG_ID                                          AS NBJGH, --内部机构号
           B.ORG_ID                                          AS NBJGH, --内部机构号 --MOD BY LIP 20260408
           B.ORG_NM                                          AS YHJGMC, --银行机构名称
           ''                                                AS XDHTH, --信贷合同号
           ''                                                AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.BILL_NO)                         AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.BILL_NO
            END                                              AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                               AS PJLX, --票据类型
           A.CUR                                             AS BZ, --币种
           A.REDISC_AMT                                      AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT,'99991231')                     AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                     AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                       AS CPRMC, --出票人名称
           C.ACPTR_NM                                        AS CDRMC, --承兑人名称
           /*A.REDISC_ORG_NM                                   AS TXRMC, --贴现人名称*/
           C.ORIG_DISC_PSN_NM                                AS TXRMC, --贴现人名称 --MOD BY LIP 20230202
           NVL(C.ORIG_DISC_DT,'99991231')                    AS TXRQ, --贴现日期
           '卖出'                                            AS JYFX, --交易方向
           '再贴现'                                          AS ZTXLB, --转贴现类别
           NVL(A.REDISC_DT,'99991231')                       AS ZTXRQ, --转贴现日期
           A.BILL_ACT_AMT                                    AS ZTXJE, --转贴现金额  新增BILL_ACT_AMT后取消注释
           TO_DATE(A.REPO_EXP_DT,'YYYY-MM-DD')-TO_DATE(A.REDISC_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数
           A.RATE                                            AS ZTXLL, --转贴现利率
           A.REDISC_INT                                      AS ZTXLX, --转贴现利息
           NVL(A.REPO_EXP_DT,'99991231')                     AS HGRQ, --回购日期
           A.REPO_AMT                                        AS HGJE, --回购金额
           A.RATE                                            AS HGLV, --回购利率
           A.REDISC_INT                                      AS HGLX, --回购利息
           A.CNTPR_NM                                        AS JYDSMC, --交易对手名称
           A.CNTPR_PBC_NO                                    AS JYDSHH, --交易对手行号
           --CODE1.TAR_VALUE_NAME                             AS PJZT, --票据状态
           '其他-到期'                                       AS PJZT, --票据状态
           ''                                                AS BBZ, --备注
           V_MONTH_END_DATEID                                AS CJRQ, --采集日期
           '000'                                             AS DEPT_NO, --部门编号
           '01'                                              AS SRC_SYS_ID, --来源系统ID
           '000000'                                          AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                    AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                              AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                              AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.BILL_NO)                         AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_MDL.M_CPTL_REDISC_INFO A --再贴现信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG T1 --机构映射表 --ADD BY LIP 20260408
        ON T1.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(T1.ORG_ID1,'800')--A.ORG_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_BILL_INFO C --票据票面表
        ON C.BILL_NO = A.BILL_NO
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.REPO_EXP_DT >= V_START_DT --回购到期日期
       AND A.REPO_EXP_DT <= V_MONTH_END_DATEID --跑当月数据
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP    := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-再贴现-当期余额不为零';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB_TEMP01
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       )   --MODIFY 20220616 根据源系统林旭华和业务确认后，修改口径 LAIHAIQIANG
    SELECT SYS_GUID()                                          AS RID, ---数据主键
           B.FIN_PERMIT_NO                                     AS JRXKZH, --金融许可证号
           --A.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_ID                                            AS NBJGH, --内部机构号
           B.ORG_NM                                            AS YHJGMC, --银行机构名称
           ''                                                  AS XDHTH, --信贷合同号
           ''                                                  AS XDJJH, --信贷借据号
           --NVL(C.BILL_NUM,A.BILL_NO)                           AS PJHM, --票据号码
           CASE WHEN C.BILL_NO IS NOT NULL AND C.BILL_SUB_INTRV_ID IN ('-','0')
                THEN C.BILL_NUM
                WHEN C.BILL_NO IS NOT NULL
                THEN C.BILL_NUM||C.BILL_SUB_INTRV_ID
                ELSE A.BILL_NO
            END                                                AS PJHM, --票据号码 --MOD BY LIP 20240726
           CODE.TAR_VALUE_NAME                                 AS PJLX, --票据类型
           A.CUR                                               AS BZ, --币种
           A.REDISC_AMT                                        AS PMJE, --票面金额
           NVL(C.BILL_ISU_DT,'99991231')                       AS PJCPRQ, --票据出票日期
           NVL(C.BILL_EXP_DT,'99991231')                       AS PJDQRQ, --票据到期日期
           C.DRAWER_NM                                         AS CPRMC, --出票人名称
           C.ACPTR_NM                                          AS CDRMC, --承兑人名称
           /*A.REDISC_ORG_NM                                     AS TXRMC, --贴现人名称*/
           C.ORIG_DISC_PSN_NM                                  AS TXRMC, --贴现人名称 --MOD BY LIP 20230202
           NVL(C.ORIG_DISC_DT,'99991231')                      AS TXRQ, --贴现日期
           '卖出'                                              AS JYFX, --交易方向
           '再贴现'                                            AS ZTXLB, --转贴现类别
           NVL(A.REDISC_DT,'99991231')                         AS ZTXRQ, --转贴现日期
           A.BILL_ACT_AMT                                      AS ZTXJE, --转贴现金额 新增 BILL_ACT_AMT字段后取消注释
           TO_DATE(A.REPO_DT,'YYYY-MM-DD')-TO_DATE(A.REDISC_DT,'YYYY-MM-DD') AS ZTXJXTS, --转贴现计息天数 --新增REPO_DT字段后取消注释
           A.RATE                                              AS ZTXLL, --转贴现利率
           A.REDISC_INT                                        AS ZTXLX, --转贴现利息
           NVL(A.REPO_DT,'99991231')                           AS HGRQ, --回购日期 --新增 REPO_DT字段后取消注释
           A.REPO_AMT                                          AS HGJE, --回购金额
           A.RATE                                              AS HGLV, --回购利率
           A.REDISC_INT                                        AS HGLX, --回购利息
           A.CNTPR_NM                                          AS JYDSMC, --交易对手名称
           A.CNTPR_PBC_NO                                      AS JYDSHH, --交易对手行号
           --CODE1.TAR_VALUE_NAME                               AS PJZT, --票据状态
           '正常'                                              AS PJZT, --票据状态
           ''                                                  AS BBZ, --备注
           V_MONTH_END_DATEID                                  AS CJRQ, --采集日期
           '000'                                               AS DEPT_NO, --部门编号
           '01'                                                AS SRC_SYS_ID, --来源系统ID
           '000000'                                            AS ISSUED_NO, --填报机构
           NVL(ORG.ORG_ID_LEL_0,'000000')                      AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                                AS ADDRESS, --归属地
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                                AS GSFZJG, --归属分支机构
           NVL(C.BILL_NUM,A.BILL_NO)                           AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_MDL.M_CPTL_REDISC_INFO A --再贴现信息表
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_BILL_INFO C --票据票面表
        ON C.BILL_NO = A.BILL_NO
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = C.BILL_TYP
       AND CODE.SRC_CLASS_CODE = 'D0039' --票据类型
       AND CODE.TAR_CLASS_CODE = 'D0039' --票据类型
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = C.BILL_STAT
       AND CODE1.SRC_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.TAR_CLASS_CODE = 'D0125' --票据状态
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE A.CURRT_BAL > 0
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20220630 汇总到目标表
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '票据转贴现表-汇总到目标表';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND*/ INTO RRP_EAST.EAST5_509_PJZTXB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       PJHM, --票据号码
       PJLX, --票据类型
       BZ, --币种
       PMJE, --票面金额
       PJCPRQ, --票据出票日期
       PJDQRQ, --票据到期日期
       CPRMC, --出票人名称
       CDRMC, --承兑人名称
       TXRMC, --贴现人名称
       TXRQ, --贴现日期
       JYFX, --交易方向
       ZTXLB, --转贴现类别
       ZTXRQ, --转贴现日期
       ZTXJE, --转贴现金额
       ZTXJXTS, --转贴现计息天数
       ZTXLL, --转贴现利率
       ZTXLX, --转贴现利息
       HGRQ, --回购日期
       HGJE, --回购金额
       HGLV, --回购利率
       HGLX, --回购利息
       JYDSMC, --交易对手名称
       JYDSHH, --交易对手行号
       PJZT, --票据状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       GSFZJG,  --归属分支机构
       PJHM_OLD --票据号码  --ADD BY LIP 20240726
       )
    SELECT T.RID                             AS RID, --数据主键
           TB.FIN_PERMIT_NO                  AS JRXKZH, --金融许可证号
           TB.ORG_ID                         AS NBJGH, --内部机构号
           TB.ORG_NM                         AS YHJGMC, --银行机构名称
           T.XDHTH                           AS XDHTH, --信贷合同号
           T.XDJJH                           AS XDJJH, --信贷借据号
           T.PJHM                            AS PJHM, --票据号码
           T.PJLX                            AS PJLX, --票据类型
           T.BZ                              AS BZ, --币种
           T.PMJE                            AS PMJE, --票面金额
           T.PJCPRQ                          AS PJCPRQ, --票据出票日期
           T.PJDQRQ                          AS PJDQRQ, --票据到期日期
           /*T.CPRMC                           AS CPRMC, --出票人名称
           T.CDRMC                           AS CDRMC, --承兑人名称
           T.TXRMC                           AS TXRMC, --贴现人名称*/
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(T.CPRMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.CPRMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.CPRMC)
            END                              AS CPRMC, --出票人名称
           CASE WHEN REGEXP_REPLACE(TRIM(T.CDRMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.CDRMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.CDRMC)
            END                              AS CDRMC, --承兑人名称
           CASE WHEN REGEXP_REPLACE(TRIM(T.TXRMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.TXRMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.TXRMC)
            END                              AS TXRMC, --贴现人名称
           T.TXRQ                            AS TXRQ, --贴现日期
           T.JYFX                            AS JYFX, --交易方向
           T.ZTXLB                           AS ZTXLB, --转贴现类别
           T.ZTXRQ                           AS ZTXRQ, --转贴现日期
           T.ZTXJE                           AS ZTXJE, --转贴现金额
           T.ZTXJXTS                         AS ZTXJXTS, --转贴现计息天数
           T.ZTXLL                           AS ZTXLL, --转贴现利率
           T.ZTXLX                           AS ZTXLX, --转贴现利息
           T.HGRQ                            AS HGRQ, --回购日期
           T.HGJE                            AS HGJE, --回购金额
           T.HGLV                            AS HGLV, --回购利率
           T.HGLX                            AS HGLX, --回购利息
           --TRIM(T.JYDSMC)                    AS JYDSMC, --交易对手名称
           --MOD BY LIP 20230505 当对公客户的名称都是中文名时，将其中的()改为（）
           CASE WHEN REGEXP_REPLACE(TRIM(T.JYDSMC),'[0-9a-zA-Z[:punct:][:space:]]','') IS NOT NULL
                THEN REPLACE(REPLACE(REPLACE(TRIM(T.JYDSMC),'(','（'),')','）'),' ','')
                ELSE TRIM(T.JYDSMC)
            END                              AS JYDSMC, --交易对手名称
           TRIM(T.JYDSHH)                    AS JYDSHH, --交易对手行号
           --TRIM(SUBSTRB(T.PJZT,1,20))        AS PJZT, --票据状态
           TRIM(SUBSTRB(T.PJZT,1,30))        AS PJZT, --票据状态 --MODIFY BY LIP 20240409 改为UTF-8的长度
           T.BBZ                             AS BBZ, --备注
           T.CJRQ                            AS CJRQ, --采集日期
           '000'                             AS DEPT_NO, --部门编号
           T.SRC_SYS_ID                      AS SRC_SYS_ID, --来源系统ID
           '000000'                          AS ISSUED_NO, --填报机构
           T.ORG_NO                          AS ORG_NO, --报送机构
           /*T.ADDRESS                         AS ADDRESS, --归属地
           T.GSFZJG                          AS GSFZJG,  --归属分支机构*/
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                              AS ADDRESS, --归属地 --MOD BY LIP 20260408
           CASE WHEN LIST.FLAG = 1 THEN TB.GSFZJG
                ELSE '9999'
            END                              AS GSFZJG, --归属分支机构 --MOD BY LIP 20260408
           T.PJHM_OLD                        AS PJHM_OLD --票据号码  --ADD BY LIP 20240726
      FROM RRP_EAST.EAST5_509_PJZTXB_TEMP01 T --票据转贴现临时汇总表
      LEFT JOIN RRP_MDL.ORG_CONFIG TA --机构映射表
        ON TA.ORG_ID = T.NBJGH
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST TB
        ON TB.ORG_ID = NVL(TA.ORG_ID1,'800')
       AND TB.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = TB.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON UPPER(LIST.TABLE_NAME) = V_TABLE_NAME;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

END ETL_EAST5_509_PJZTXB;
/

