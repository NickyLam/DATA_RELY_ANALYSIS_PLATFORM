CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_EAST5_503_GRXDYWJJB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：个人信贷业务借据表
  **  存储过程名称:  ETL_EAST5_503_GRXDYWJJB
  **  存储过程创建日期:2022-07-13
  **  存储过程创建人:付善斌
  **  来源表:
  **        M_LOAN_IN_DUBILL_INFO --表内借据信息
  **        M_CUST_IND_INFO       --个人客户信息
  **        M_GL_INFO             --总账会计科目信息表
  **        M_LOAN_RP_PLAN_INFO   --贷款还款计划信息
  **        M_CRDT_LMT_INFO       --授信额度主表
  **        M_PUM_ORG_INFO_EAST B      --机构表
  **        CODE_MAP CODE      --码值配置表
  **        CONFIG_ORG_REL ORG    --机构级次关系表
  **        CONFIG_TABLE_LIST     --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
  **
  **  目标表:   EAST5_503_GRXDYWJJB
  **
  **  修改日期      修改人      修改项目
  *   20221108      LIP         模型不过滤数据，改成应用层过滤月初前结清的数据
  *   20241115      LIP         银监报表中个体工商户和小微企业主指标重新纳入个人赎楼贷（经营）
  *   20250928      LIP         是否科技贷款口径调整
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
  V_TABLE_NAME       VARCHAR2(100) := 'EAST5_503_GRXDYWJJB'; --表名称
  V_PROC_NAME        VARCHAR2(100) := 'ETL_EAST5_503_GRXDYWJJB'; --存储过程名称
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE);
  O_ERRCODE := '0';
  V_MONTH_END_DATEID := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD');
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;
  V_FREQ_FLAG := RRP_EAST.FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度
  IF V_FREQ_FLAG = '1' THEN

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

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '删除当日分区数据';
    V_STARTTIME := SYSDATE;
    --删除当日分区数据
    RRP_EAST.ETL_PARTITION_TRUNCATE(V_P_DATE,V_TABLE_NAME,O_ERRCODE); --清空当日分区以便重跑
    --DELETE FROM RRP_EAST.EAST5_503_GRXDYWJJB WHERE CJRQ = V_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '加工将数据装入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_503_GRXDYWJJB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       DKFHZH, --贷款分户账号
       XDYWZL, --信贷业务种类
       DKFFLX, --贷款发放类型
       FKFS, --放款方式
       BZ, --币种
       DKJE, --贷款金额
       DKYE, --贷款余额
       DKWJFL, --贷款五级分类
       ZQS, --总期数
       DQQS, --当前期数
       ZQCS, --展期次数
       DKFFRQ, --贷款发放日期
       DKDQRQ, --贷款到期日期
       ZJRQ, --终结日期
       QBJE, --欠本金额
       QBRQ, --欠本日期
       BNQXYE, --表内欠息余额
       BWQXYE, --表外欠息余额
       QXRQ, --欠息日期
       LXQKQS, --连续欠款期数
       LJQKQS, --累计欠款期数
       SBXDJJH, --上笔信贷借据号
       DKRZZH, --贷款入账账号
       DKRZHM, --贷款入账户名
       RZZHSSHMC, --入账账号所属行名称
       LLLX, --利率类型
       SJLL, --实际利率
       HKFS, --还款方式
       HKZH, --还款账号
       HKZHSSHMC, --还款账号所属行名称
       JXFS, --计息方式
       XQHKRQ, --下期还款日期
       XQYHBJ, --下期应还本金
       XQYHLX, --下期应还利息
       DKTXDQ, --贷款投向地区
       JJDKYT, --借据贷款用途
       DKTXHY, --贷款投向行业
       SFHLWDK, --是否互联网贷款
       SFLSDK, --是否绿色贷款
       SFSNDK, --是否涉农贷款
       SFPHXSNDK, --是否普惠型涉农贷款
       SFPHXXWQYDK, --是否普惠型小微企业贷款
       SFKJDK, --是否科技贷款
       XDYGH, --信贷员工号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       ZJHM_ORIG, --证件号码（脱敏前）
       KHMC_OTH,--客户是否个人客户
       DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款
       GSFZJG,--归属分支机构
       DKRZHM_ORIG, --贷款入账户名（脱敏前）
       DKRZHM_OTH --贷款入账户名是否个人
       )
     --受托支付的入账取受托表中第一个，自主支付的还款账号取受托表中的账号
      WITH LOAN_ENTRS_PAY_SUB AS (
    SELECT /*+MATERIALIZE*/RCPT_ID,             --借据编号
           ENTRS_PAY_AMT,
           ENTRS_PAY_DT,        --受托支付日期
           TRIM(ENTRS_PAY_OBJ_ACC)     ENTRS_PAY_OBJ_ACC,   --受托支付对象账号
           TRIM(ENTRS_PAY_OBJ_ACC_NM)  ENTRS_PAY_OBJ_ACC_NM,  --受托支付对象户名
           TRIM(ENTRS_PAY_OBJ_PBC_NO)  ENTRS_PAY_OBJ_PBC_NO,  --受托支付对象行号
           TRIM(ENTRS_PAY_OBJ_BANK_NM) ENTRS_PAY_OBJ_BANK_NM,  --受托支付对象行名
           ROW_NUMBER() OVER(PARTITION BY RCPT_ID ORDER BY ENTRS_PAY_DT ASC,PAY_FLOW_NUM ASC) AS RN
      FROM RRP_MDL.M_LOAN_ENTRS_PAY_SUB  --受托支付子表
     WHERE DATA_DT = V_P_DATE),
   LOAN_RP_PLAN_INFO AS (
    SELECT /*+MATERIALIZE*/RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT) EXP_DT,INT,PRIN
      FROM RRP_MDL.M_LOAN_RP_PLAN_INFO
     WHERE DATA_DT = V_P_DATE
     GROUP BY RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT),INT,PRIN),
   LOAN_RP_PLAN_INFO1 AS (--MOD BY LIP 20251211 按照业务口径：如果按照期数取下个还款日期取在采集日前，就取采集日之后的第一个还款日期
    SELECT /*+MATERIALIZE*/RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT) EXP_DT,INT,PRIN,
           ROW_NUMBER() OVER(PARTITION BY RCPT_ID ORDER BY LEAST(PRIN_EXP_DT,INT_EXP_DT)) RN
      FROM RRP_MDL.M_LOAN_RP_PLAN_INFO
     WHERE LEAST(PRIN_EXP_DT,INT_EXP_DT) > V_P_DATE
       AND DATA_DT = V_P_DATE
     GROUP BY RCPT_ID,REPY_PRD_NUM,LEAST(PRIN_EXP_DT,INT_EXP_DT),INT,PRIN)
    SELECT /*+USE_HASH(A,D,C,E,F,B,CODE,CODE1,CODE2,CODE3,CODE4,CODE5,CODE6,CODE7,CODE8,CODE9,CODE10,CODE11,ORG)*/
           SYS_GUID()                                  AS RID, --数据主键
           B.FIN_PERMIT_NO                             AS JRXKZH, --金融许可证号
           --A.ORG_ID                                    AS NBJGH, --内部机构号
           B.ORG_ID                                    AS NBJGH, --内部机构号
           B.ORG_NM                                    AS YHJGMC, --银行机构名称
           SUBSTR(A.SUBJ_ID,1,8)                       AS MXKMBH, --明细科目编号
           C.SUBJ_NM                                   AS MXKMMC, --明细科目名称
           A.CUST_ID                                   AS KHTYBH, --客户统一编号
           D.CUST_NM_DESEN                             AS KHMC, --客户名称--MODIFY BY LAIHAIQIANG AT 20230403
           --TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,40))     AS ZJLB, --证件类别
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))     AS ZJLB, --证件类别 --MODIFY BY LIP 20240409 改为UTF-8的长度
           D.CRDL_NO_DESEN                             AS ZJHM, --证件号码
           A.CONT_ID                                   AS XDHTH, --信贷合同号
           A.RCPT_ID                                   AS XDJJH, --信贷借据号
           --A.RCPT_ID                                 AS DKFHZH, --贷款分户账号
           A.ACC_ID                                    AS DKFHZH, --贷款分户账号
           CASE WHEN A.LOAN_BIZ_TYP = '020101' THEN '流动资金贷款'
                WHEN A.LOAN_BIZ_TYP = '0602' THEN '法人账户透支'
                --WHEN A.PROJ_LOAN_FLG = 'Y' THEN '项目贷款'
                WHEN A.PROJ_LOAN_FLG = 'Y' OR A.LOAN_STD_PROD_ID = '203010300001' THEN '项目贷款' --20241021 MOD BY LIP 增加并购贷款
                WHEN A.SYN_LOAN_FLG = 'Y' THEN '项目贷款（银团）'
                /*MODIFY BY LIP 20220718因深圳银监对数要求，增加经营性物业贷款的区分标志 按S67口径
                将对公的一般固定资产贷款中的 203010200001 经营性物业贷款 标记为 其他-经营性物业贷款
                将个人的个人经营性贷款中的 201020100048 个人经营性物业抵押贷款 标记为 其他-经营性物业贷款*/
                WHEN A.LOAN_STD_PROD_ID IN ('203010200001','201020100048') THEN '其他-经营性物业贷款'
                --MOD BY LIP 20240515 调整中山分行的R202204280016106150对应的信贷业务种类
                WHEN A.RCPT_ID IN ('R202204280016106150') THEN '其他-经营性物业贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0202' THEN '一般固定资产贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0101%' THEN '住房按揭贷款'
                WHEN A.LOAN_BIZ_TYP IN ('010201', '010203') THEN '商用房贷款'
                --WHEN A.LOAN_BIZ_TYP IN ('010202', '010301') THEN '汽车贷款'
                WHEN A.LOAN_BIZ_TYP IN ('010301') THEN '汽车贷款' --MOD BY LIP 20260407 根据业务口径调整，汽车贷款只包含消费贷款中的购个人用车和购车+车牌
                WHEN A.LOAN_BIZ_TYP LIKE '0104%' THEN '助学贷款'
                WHEN A.LOAN_BIZ_TYP = '010399' THEN '消费贷款'
                WHEN A.LOAN_BIZ_TYP LIKE '0103%' THEN '消费贷款'
                --WHEN A.LOAN_BIZ_TYP = '010299' THEN '个人经营性贷款'
                WHEN A.LOAN_BIZ_TYP IN ('010202','010299') THEN '个人经营性贷款' --MOD BY LIP 20260407 根据业务口径调整，个人经营性贷款“购商用车”的不纳入“汽车贷款”中而是纳入“个人经营性贷款”
                WHEN A.LOAN_BIZ_TYP LIKE '0301%' THEN '票据贴现'
                WHEN A.LOAN_BIZ_TYP LIKE '030201%' THEN '买断式转贴现'
                WHEN A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_STD_PROD_ID IN ('203030600002','203020300002') THEN '贸易融资业务' --MOD BY LIP 20241021
                --WHEN A.LOAN_BIZ_TYP LIKE '0204%' OR A.LOAN_BIZ_TYP IN ('0399') THEN '贸易融资业务'
                WHEN A.LOAN_BIZ_TYP = '0206' THEN '融资租赁业务'
                WHEN A.LOAN_BIZ_TYP LIKE '0205%' THEN '垫款'
                WHEN A.LOAN_BIZ_TYP = '90' THEN '委托贷款'
                --ELSE '其他-' || REPLACE(CODE9.TAR_VALUE_NAME, '其他-', '')
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE9.TAR_VALUE_NAME, '其他-', ''),1,100))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE9.TAR_VALUE_NAME, '其他-', ''),1,150)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                        AS XDYWZL, --信贷业务种类
           CASE WHEN A.LOAN_PROD_NM LIKE '%债权直转%' THEN '其他-贷款转入' --MOD BY LIP 20230925 网商贷债权直转的默认为转入
                --WHEN A.DATA_SRC = '零售贷款' AND G.LOAN_HAPP_TYPE_CD = '0102' THEN '无还本续贷' --ADD BY LIP 20240304 增加无还本续贷的判断，参考S6301
                WHEN A.LOAN_FRM = '05' THEN '无还本续贷'
                WHEN A.LOAN_FRM = '03' THEN '借新还旧'
                WHEN NVL(A.EXTN_CNT,0) > 0 THEN '其他-展期' --ADD BY LIP 20251219 根据张家伟口径调整
                --WHEN A.LOAN_FRM = '04' THEN '重组贷款'
                WHEN A.LOAN_FRM = '04' OR A.REGROUP_LOAN_FLG = '1' THEN '重组贷款' --MOD BY LIP 20251230 根据张家伟口径调整
                WHEN A.LOAN_FRM = '02' THEN '其他-贷款转入'
                WHEN A.LOAN_FRM = '01' THEN '新增'
                --ELSE '其他-' || REPLACE(CODE10.TAR_VALUE_NAME, '其他-', '')
                --ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE10.TAR_VALUE_NAME, '其他-', ''),1,20))
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE10.TAR_VALUE_NAME, '其他-', ''),1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                        AS DKFFLX, --贷款发放类型
           --CODE1.TAR_VALUE_NAME                       AS FKFS, --放款方式
           --TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,20))    AS FKFS, --放款方式
           CASE WHEN A.LOAN_PROD_NM LIKE '%债权直转%' THEN '其他-贷款转入' --MOD BY LIP 20230925 网商贷债权直转的默认为转入
                --ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,20))
                ELSE TRIM(SUBSTRB(CODE1.TAR_VALUE_NAME,1,30)) --MODIFY BY LIP 20240409 改为UTF-8的长度
            END                                        AS FKFS, --放款方式
           A.CUR                                       AS BZ, --币种
           --MOD BY LIP 20230925 因网商贷债权直转的贷款金额是转入金额，这里改成取原始放款金额
           NVL(A.INIT_DISTR_AMT,0)                     AS DKJE, --贷款金额
           NVL(A.LOAN_BAL,0)                           AS DKYE, --贷款余额
           CODE2.TAR_VALUE_NAME                        AS DKWJFL, --贷款五级分类
           NVL(A.TOT_PRD_NUM,0)                        AS ZQS, --总期数
           NVL(A.CURR_PRD,0)                           AS DQQS, --当前期数
           NVL(A.EXTN_CNT,0)                           AS ZQCS, --展期次数
           --MOD BY LIP 20230925 因网商贷债权直转的发放日期是转入日期，这里改成取原始放款日期
           NVL(A.INIT_DISTR_DT, '99991231')            AS DKFFRQ, --贷款发放日期
           NVL(A.LOAN_ACT_EXP_DT, '99991231')          AS DKDQRQ, --贷款到期日期
           --MOD BY LIP 20230627 按张家伟口径调整京东的终结日期
           --如贷款未结清，则终止时间为999912231，如贷款已结清，则终止日期为最后一期还款记录对应的日期
           CASE WHEN A.LOAN_STD_PROD_ID IN ('202010100004','202010100005')
                THEN CASE WHEN A.RCPT_STAT = 'C0201' AND NVL(A.ACT_END_DT,'29991231') NOT IN ('00010101','20991231','29991231')
                          THEN NVL(A.ACT_END_DT,'99991231')
                          WHEN NVL(A.LOAN_BAL,0) + NVL(A.IN_INT_OVD_BAL,0) + NVL(A.OUT_INT_OVD_BAL,0)+ NVL(A.IN_BS_INT,0) + NVL(A.OFF_BS_INT,0) <> 0
                          THEN '99991231'
                          WHEN NVL(A.LAST_REPY_DT,'99991231') IN ('00010101','20991231','29991231')
                          THEN '99991231'
                          ELSE NVL(A.LAST_REPY_DT,'99991231')
                      END
                WHEN NVL(A.ACT_END_DT,'29991231') IN ('00010101','20991231','29991231')
                THEN '99991231'
                ELSE A.ACT_END_DT
            END                                        AS ZJRQ, --终结日期
           CASE WHEN A.RCPT_STAT = 'C0201' THEN 0
                ELSE NVL(A.OVD_PRIN_BAL,0)
            END                                          AS QBJE, --欠本金额
           CASE WHEN A.RCPT_STAT = 'C0201' THEN '99991231' --MOD BY LIP 20240703
                ELSE NVL(A.PRIN_OVD_DT,'99991231')
            END                                          AS QBRQ, --欠本日期
           --MOD BY LIP 20230605 当核销标志为是时，默认为0
           CASE WHEN A.RCPT_STAT = 'C0201' THEN 0
                ELSE NVL(A.IN_INT_OVD_BAL,0)
            END                                        AS BNQXYE, --表内欠息余额
           CASE WHEN A.RCPT_STAT = 'C0201' THEN 0
                ELSE NVL(A.OUT_INT_OVD_BAL,0)
            END                                        AS BWQXYE, --表外欠息余额
           CASE WHEN A.RCPT_STAT = 'C0201' THEN '99991231' --MOD BY LIP 20240703
                ELSE NVL(A.INT_OVD_DT,'99991231')
            END                                        AS QXRQ, --欠息日期
           NVL(A.CNU_DEBT_PRD_NUM,0)                   AS LXQKQS, --连续欠款期数
           NVL(A.CUM_DEBT_PRD_NUM,0)                   AS LJQKQS, --累计欠款期数
           --A.ORIG_RCPT_NO                              AS SBXDJJH, --上笔信贷借据号
           SUBSTRB(TRIM(A.ORIG_RCPT_NO),1,100)         AS SBXDJJH, --上笔信贷借据号 --MOD BY LIP 20240807
           --MOD BY LIP 20230802 优先取受托支付表中的数据
           CASE WHEN TB.RCPT_ID IS NOT NULL THEN TB.ENTRS_PAY_OBJ_ACC
                ELSE A.ETR_ACC
            END                                        AS DKRZZH, --贷款入账账号
           --MOD BY LIP 20230802 优先取受托支付表中的数据
           CASE WHEN TB.ENTRS_PAY_OBJ_ACC_NM = D.CUST_NM THEN D.CUST_NM_DESEN
                WHEN TB.ENTRS_PAY_OBJ_ACC_NM IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(TB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''), 0))
                WHEN TB.RCPT_ID IS NOT NULL THEN TB.ENTRS_PAY_OBJ_ACC_NM
                --MOD BY LIP 20230717 对入账户名脱敏
                WHEN A.ETR_ACC_NM IS NOT NULL AND A.ETR_ACC_NM = D.CUST_NM THEN D.CUST_NM_DESEN --当入账户名和客户名一致时，直接取脱敏后的客户名称
                WHEN A.ETR_ACC_NM IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(A.ETR_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(A.ETR_ACC_NM,'[[:punct:]]',''), 0))
                WHEN A.ETR_ACC_NM IS NOT NULL THEN A.ETR_ACC_NM
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL AND TA.DKRZHM = D.CUST_NM
                THEN D.CUST_NM_DESEN
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL
                   AND LENGTH(TRIM(REGEXP_REPLACE(TA.DKRZHM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN TRIM(RRP_EAST.FUN_DESENSITIZATION(REGEXP_REPLACE(TA.DKRZHM,'[[:punct:]]',''), 0))
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL
                THEN TA.DKRZHM
            END                                        AS DKRZHM, --贷款入账户名
           --MOD BY LIP 20230802 优先取受托支付表中的数据
           --MOD BY LIP 20230904 因受托支付表中的行名有缺失，如果账号与表内借据表的账号相同，则取表内借据表的行名
           CASE WHEN TB.RCPT_ID IS NOT NULL AND A.ETR_ACC = TB.ENTRS_PAY_OBJ_ACC THEN TRIM(A.LOAN_ETR_ACC_OPEN_BANK_NM)
                WHEN TB.RCPT_ID IS NOT NULL THEN TB.ENTRS_PAY_OBJ_BANK_NM
                WHEN TRIM(A.LOAN_ETR_ACC_OPEN_BANK_NM) IS NOT NULL THEN TRIM(A.LOAN_ETR_ACC_OPEN_BANK_NM)
                WHEN A.CONT_ID = 'R2022040851166382' THEN '渤海银行股份有限公司石家庄分行'
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.LOAN_ETR_ACC_OPEN_BANK_NM) IS NULL THEN TA.RZZHSSHMC
            END                                        AS RZZHSSHMC, --入账账号所属行名称
           CASE WHEN A.PRC_BASE_TYP = 'TR07' THEN 'LPR'
                ELSE '非LPR'
            END                                        AS LLLX, --利率类型
           A.EXEC_RATE                                 AS SJLL, --实际利率
           CODE3.TAR_VALUE_NAME                        AS HKFS, --还款方式
           --A.REPY_ACC                                  AS HKZH, --还款账号
           --A.LOAN_REPY_ACC_OPEN_BANK_NM                AS HKZHSSHMC, --还款账号所属行名称
           --MOD BY LIP 20230802 自主支付的，优先取受托支付表中的数据
           /*CASE WHEN A.DSBR_MODE = '01' AND TB.RCPT_ID IS NOT NULL AND TRIM(TB.ENTRS_PAY_OBJ_BANK_NM) IS NOT NULL
                THEN TRIM(TB.ENTRS_PAY_OBJ_BANK_NM)*/
           CASE WHEN A.DSBR_MODE = '01' AND TB.RCPT_ID IS NOT NULL AND TRIM(TB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                THEN TRIM(TB.ENTRS_PAY_OBJ_ACC)
                ELSE A.REPY_ACC
            END                                        AS HKZH, --还款账号
           --MOD BY LIP 20230802 自主支付的，优先取受托支付表中的数据
           CASE WHEN A.DSBR_MODE = '01' AND TB.RCPT_ID IS NOT NULL AND A.ETR_ACC = TB.ENTRS_PAY_OBJ_ACC
                THEN TRIM(A.LOAN_ETR_ACC_OPEN_BANK_NM)
                WHEN A.DSBR_MODE = '01' AND TB.RCPT_ID IS NOT NULL AND TRIM(TB.ENTRS_PAY_OBJ_ACC) IS NOT NULL
                THEN TB.ENTRS_PAY_OBJ_BANK_NM
                WHEN A.DSBR_MODE = '01' AND TB.RCPT_ID IS NOT NULL AND TRIM(TB.ENTRS_PAY_OBJ_ACC) = TA.DKRZZH
                THEN TA.DKRZHM
                WHEN TRIM(A.LOAN_REPY_ACC_OPEN_BANK_NM) IS NOT NULL
                THEN TRIM(A.LOAN_REPY_ACC_OPEN_BANK_NM)
                WHEN A.CONT_ID = 'R2022040851166382'
                THEN '渤海银行股份有限公司石家庄分行'
            END                                        AS HKZHSSHMC, --还款账号所属行名称
           TRIM(SUBSTRB(CODE4.TAR_VALUE_NAME,1,60))   AS JXFS, --计息方式 --MODIFY BY LIP 20240409 改为UTF-8的长度
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN '99991231'
                WHEN NVL(A.TOT_PRD_NUM,0) = NVL(A.CURR_PRD,0) AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN '99991231'
                --ELSE NVL(E.EXP_DT,'99991231')
                --MOD BY LIP 20251211 如果按照期数取下个还款日期取在采集日前，就取采集日之后的第一个还款日期
                WHEN NVL(E.EXP_DT,'99991231') > V_P_DATE THEN NVL(E.EXP_DT,'99991231')
                ELSE NVL(F.EXP_DT,'99991231')
            END                                        AS XQHKRQ, --下期还款日期
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN 0
                WHEN NVL(A.TOT_PRD_NUM,0) = NVL(A.CURR_PRD,0) AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN 0
                --ELSE NVL(E.PRIN,0)
                --MOD BY LIP 20251211 如果按照期数取下个还款日期取在采集日前，就取采集日之后的第一个还款日期
                WHEN NVL(E.EXP_DT,'99991231') > V_P_DATE THEN NVL(E.PRIN,0)
                ELSE NVL(F.PRIN,0)
            END                                        AS XQYHBJ, --下期应还本金
           CASE WHEN A.ACT_END_DT <= V_P_DATE THEN 0
                WHEN NVL(A.TOT_PRD_NUM,0) = NVL(A.CURR_PRD,0) AND NVL(E.EXP_DT,'99991231') < V_P_DATE THEN 0
                --ELSE NVL(E.INT,0)
                --MOD BY LIP 20251211 如果按照期数取下个还款日期取在采集日前，就取采集日之后的第一个还款日期
                WHEN NVL(E.EXP_DT,'99991231') > V_P_DATE THEN NVL(E.INT,0)
                ELSE NVL(F.INT,0)
            END                                        AS XQYHLX, --下期应还利息
           CASE WHEN TRIM(A.LOAN_DIR_RGN) IS NOT NULL THEN TRIM(A.LOAN_DIR_RGN)
                WHEN A.CUST_ID = '1000280790' THEN '440402' --珠海市香洲区
                WHEN A.CUST_ID = '1000288731' THEN '421087' --荆州市松滋市
            END                                        AS DKTXDQ, --贷款投向地区
           CASE WHEN TRIM(A.LOAN_USEAGE) IS NOT NULL
                THEN TRIM(REPLACE(REPLACE(A.LOAN_USEAGE,CHR(10),''),CHR(13),''))
                WHEN A.LOAN_BIZ_TYP LIKE '0101%' THEN '买房'
                WHEN A.LOAN_BIZ_TYP IN ('010201', '010203') THEN '买房'
                WHEN A.LOAN_BIZ_TYP IN ('010202', '010301') THEN '买车'
                WHEN A.LOAN_BIZ_TYP LIKE '0104%' THEN '教育'
                WHEN A.LOAN_BIZ_TYP = '010399' THEN '日常消费'
                WHEN A.LOAN_BIZ_TYP = '010299' THEN '生产经营'
            END                                        AS JJDKYT, --借据贷款用途 --当用途为空时，给默认值
           --MOD BY LIP 20221230 目前个人没有投向境外的，不能通过客户的境内外判断
           --MOD BY LIP 20241104 将 BIO_LOAN_FLG 调整为 LOAN_DIR_BIO_FLG 改为借据的投向
           CASE WHEN REPLACE(A.LOAN_DIR_BIO_FLG,'N','Y') = 'N' THEN '3.对境外贷款'
                WHEN A.LOAN_BIZ_TYP = '0701' THEN '2.21.1个人贷款-信用卡'
                WHEN A.LOAN_BIZ_TYP = '010301' THEN '2.21.2个人贷款-汽车'
                WHEN A.LOAN_BIZ_TYP = '010101' THEN '2.21.3个人贷款-住房按揭贷款'
                /*WHEN \*A.BIO_LOAN_FLG = 'Y' AND*\ (A.LOAN_BIZ_TYP LIKE '01%' AND A.LOAN_BIZ_TYP NOT IN ('010301','010101')
                     AND A.LOAN_BIZ_TYP NOT LIKE '0102%') OR A.LOAN_BIZ_TYP = '010201' THEN '2.21.4个人贷款-其他'*/--商业住房贷款填写在 2.21.4其他
                --MODIFY BY LIP 20220707 根据张家伟给监管的口径调整 010201商业用房贷款调整过来放在个人经营性贷款
                WHEN (A.LOAN_BIZ_TYP LIKE '01%' AND A.LOAN_BIZ_TYP NOT IN ('010301','010101')
                    AND A.LOAN_BIZ_TYP NOT LIKE '0102%') THEN '2.21.4个人贷款-其他'
                WHEN A.LOAN_BIZ_TYP LIKE '0302%' THEN '2.22买断式转贴现'
                WHEN A.LOAN_BIZ_TYP = '0399' THEN '2.23买断其他票据类资产'
                WHEN A.LOAN_DIR_IDY LIKE 'A%' THEN '2.1农、林、牧、渔业'
                WHEN A.LOAN_DIR_IDY LIKE 'B%' THEN '2.2采矿业'
                WHEN A.LOAN_DIR_IDY LIKE 'C%' THEN '2.3制造业'
                --WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水的生产和供应业'
                WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水生产和供应业' --MOD BY LIP 20221123 20240429
                --WHEN A.LOAN_DIR_IDY LIKE 'D%' THEN '2.4电力、热力、燃气及水的生产和供应业' --MOD BY LTJ 20230829 根据广东省发布的校验规则修改
                WHEN A.LOAN_DIR_IDY LIKE 'E%' THEN '2.5建筑业'
                WHEN A.LOAN_DIR_IDY LIKE 'F%' THEN '2.6批发和零售业'
                WHEN A.LOAN_DIR_IDY LIKE 'G%' THEN '2.7交通运输、仓储和邮政业'
                WHEN A.LOAN_DIR_IDY LIKE 'H%' THEN '2.8住宿和餐饮业'
                WHEN A.LOAN_DIR_IDY LIKE 'I%' THEN '2.9信息传输、软件和信息技术服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'J%' THEN '2.10金融业'
                WHEN A.LOAN_DIR_IDY LIKE 'K%' THEN '2.11房地产业'
                WHEN A.LOAN_DIR_IDY LIKE 'L%' THEN '2.12租赁和商务服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'M%' THEN '2.13科学研究和技术服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'N%' THEN '2.14水利、环境和公共设施管理业'
                WHEN A.LOAN_DIR_IDY LIKE 'O%' THEN '2.15居民服务、修理和其他服务业'
                WHEN A.LOAN_DIR_IDY LIKE 'P%' THEN '2.16教育'
                WHEN A.LOAN_DIR_IDY LIKE 'Q%' THEN '2.17卫生和社会工作'
                WHEN A.LOAN_DIR_IDY LIKE 'R%' THEN '2.18文化、体育和娱乐业'
                WHEN A.LOAN_DIR_IDY LIKE 'S%' THEN '2.19公共管理、社会保障和社会组织'
                WHEN A.LOAN_DIR_IDY LIKE 'T%' THEN '2.20国际组织'
            END                                        AS DKTXHY, --贷款投向行业
           NVL(CODE6.TAR_VALUE_NAME,'否')             AS SFHLWDK, --是否互联网贷款
           CODE7.TAR_VALUE_NAME                       AS SFLSDK, --是否绿色贷款
           --MOD BY LIP 20240524 参考1104数据
           CASE WHEN TD.FKSSNBZ = 'Y' THEN '是'
                WHEN (TD.FKSSNBZ = 'N' AND TD.LOAN_DIR_IDY LIKE 'A%' AND TD.LOAN_BIZ_TYP LIKE '0102%') THEN '是'
                ELSE '否'
            END                                        AS SFSNDK, --是否涉农贷款
           CASE WHEN TD.LOAN_DIR_BIO_FLG = 'Y' --境内外贷款标志 Y境内
                     AND TD.FKSSNBZ = 'Y' --放款时涉农标志  Y-是
                     AND TD.LOAN_BIZ_TYP LIKE '0102%' --个人经营性贷款
                     --AND TD.STD_PROD_ID NOT IN ('201020100049') --剔除个人赎楼贷款（经营） ADD BY HYF 20230808 --mod 20241115
                     AND TD.OPR_CRDT_TOT_AMT <= 5000000 --单户授信金额 500万（含）以下
                THEN '是'
                ELSE '否'
            END                                        AS SFPHXSNDK, --是否普惠型涉农贷款
           CASE WHEN TC.CBRC_FLG = 'Y' --CBRC标志 Y-银保监会
                 AND TC.OPR_CRDT_TOT_AMT <= 10000000 --单户授信金额 1000万（含）以下
                 AND TC.OPR_CUST_TYP IN ('A','B') --个体工商户\小微企业主
                 AND TC.LOAN_BIZ_TYP LIKE '0102%' --个人只取经营性贷款 010201-商业用房贷款 010202-商用车贷款 010203-个人商住两用房贷款 010299-其他个人经营性贷款
                 --AND TC.STD_PROD_ID NOT IN ('201020100049') --剔除个人赎楼贷款（经营） --MOD 20241115
                THEN '是'
                ELSE '否'
            END                                        AS SFPHXXWQYDK, --是否普惠型小微企业贷款
           --'否'                                        AS SFKJDK, --是否科技贷款
           --MOD BY LIP 20250928 调整是否科技贷款口径，按照S70新表样调整，调整与S70新表样的1.科技贷款_贷款余额取数一致
           /*CASE WHEN TC.LOAN_DIR_BIO_FLG = 'Y' AND SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0104','0103','0101') --剔除个人消费贷
                THEN CASE WHEN TC.HIGH_TECH_ENT_FLG = 'Y' THEN '是' --各类科技名单企业标志
                          WHEN TC.INOVT_MED_SIDE_ENTER_FLG = 'Y' THEN '是' --创新型中小企业标志
                          WHEN TC.TECH_MID_SML_ENT_FLG = 'Y' THEN '是' --科技型中小企业标志
                          WHEN TC.PRCN_CUST_FLG = 'Y' THEN '是' --专精特新中小企业标志 “专精特新”中小企业（含专精特新“小巨人”企业）
                          WHEN TC.PRCN_LG_CUST_FLG = 'Y' THEN '是' --专精特新小巨人企业标志 “专精特新”中小企业（含专精特新“小巨人”企业）
                          WHEN TC.CTY_CORP_TECH_CENTER_FLG = 'Y' THEN '是' --国家企业技术中心标志 1.1.6其他科技型企业
                          WHEN TC.CTY_TECH_INOVT_CORP_FLG = 'Y' THEN '是' --国家技术创新示范企业标志 1.1.6其他科技型企业
                          WHEN TC.EACH_CLASS_SCEN_TECH_LIST_CORP_FLG = 'Y' THEN '是' --各类科技名单企业标志
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.HIGH_TECH_IDY_MFG_CL IN ('01','02','03','04','05','06') THEN '是' --高技术制造业
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.HIGH_TECH_IDY_SER_FLG = 'Y' THEN '是' --高技术服务业
                          WHEN TC.LOAN_DIR_BIO_FLG = 'Y'
                               AND SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.STRTG_EMER_IDY_TYP IN ('C','D','E','F','G','H','I','J','K') THEN '是' --战略性新兴产业
                          WHEN SUBSTR(TC.LOAN_BIZ_TYP,1,4) NOT IN ('0101','0103','0104','0302','0399')
                               AND TC.IP_CONC_IDY = 'Y' THEN '是' --知识产权专利密集型产业
                          ELSE '否'
                      END
                ELSE '否'
            END                                        AS SFKJDK, --是否科技贷款*/
           --MOD BY LIP 20260128 根据业务口径调整，1104新制度科技贷款的口径调整，只含单位贷款
           '否'                                        AS SFKJDK, --是否科技贷款
           A.LOAN_OFR_NO                               AS XDYGH, --信贷员工号
           CASE WHEN A.RCPT_STAT = 'C01' THEN '结清'
                WHEN A.RCPT_STAT = 'C0201' THEN '核销'
                WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转让' --MODIFY BY LIP 20220520 修改描述
                WHEN A.RCPT_STAT = 'B' THEN '逾期'
                WHEN A.RCPT_STAT = 'A' AND A.OVD_DAYS > 0 THEN '逾期' --MOD BY LIP 20240702 根据逾期天数判断是否为逾期贷款
                WHEN A.RCPT_STAT = 'A' THEN '正常'
                --WHEN A.RCPT_STAT IN ('C01','D004') THEN '结清'  --MODIFY BY TANGAN AT 20230103添加码值D004--关闭
                --WHEN A.RCPT_STAT LIKE 'C0202%' THEN '转出'
                --ELSE '其他-' || REPLACE(CODE11.TAR_VALUE_NAME,'其他-','')
                ELSE TRIM(SUBSTRB('其他-' || REPLACE(CODE11.TAR_VALUE_NAME,'其他-',''),1,30))
            END                                        AS DKZT, --贷款状态
           ''                                          AS BBZ, --备注
           V_MONTH_END_DATEID                          AS CJRQ, --采集日期
           '000'                                       AS DEPT_NO, --部门编号
           '01'                                        AS SRC_SYS_ID, --来源系统ID
           '000000'                                    AS ISSUED_NO, --填报机构
           ORG.ORG_ID_LEL_0                            AS ORG_NO, --报送机构
           CASE WHEN LIST.FLAG = 1 THEN ORG.ORG_ID_LEL_1
                ELSE LIST.REP_ORG_ID
            END                                        AS ADDRESS, --归属地
           D.CUST_NM                                   AS KHMC_ORIG, --客户名称（脱敏前）
           D.CRDL_NO                                   AS ZJHM_ORIG, --证件号码（脱敏前）
           '是'                                        AS KHMC_OTH,--客户是否个人客户
           /*CASE WHEN A.LOAN_BIZ_TYP LIKE '02%' THEN '对公贷款'
                WHEN A.LOAN_STD_PROD_ID = '202010100003' THEN '花呗'
                WHEN A.LOAN_STD_PROD_ID IN ('202010100006','202010100008','202020100003') THEN '微粒贷'
                WHEN A.LOAN_STD_PROD_ID IN ('202010100001','202010100002') THEN '借呗'
                WHEN A.LOAN_STD_PROD_ID IN ('202010100004','202010100005') THEN '京东'
                --ADD BY LIP 20230919 将网商贷债权直转的区分出来
                WHEN A.LOAN_PROD_NM LIKE '%债权直转%' THEN A.LOAN_PROD_NM
                WHEN A.LOAN_STD_PROD_ID IN ('202020100001','202020200004') THEN '网商贷'
                WHEN A.LOAN_STD_PROD_ID IN ('202020200001') THEN '字节小微贷' --MOD BY LIP 20250115
                WHEN A.LOAN_STD_PROD_ID IN ('201020100057') THEN '华兴快贷经营' --MOD BY LIP 20250115 房抵贷
                WHEN A.LOAN_STD_PROD_ID IN ('202010200011','202010200010') THEN A.LOAN_STD_PROD_NM --MOD BY LIP 20250917 分期乐
                WHEN A.DATA_SRC LIKE '%联合网贷%' THEN A.LOAN_PROD_NM --MOD BY LIP 20250808
                ELSE '行内自营贷款'
            END                                        AS DKCPMC, --贷款产品名称 只用来区分行内外产品 ADD BY LIP 20220427 业务用来区分行内外贷款*/
           A.LOAN_PROD_NM                              AS DKCPMC, --贷款产品名称 --MOD BY LIP 20251216 直接展示所有产品名称
           CASE WHEN LIST.FLAG = 1 THEN B.GSFZJG
                ELSE '9999'
            END                                        AS GSFZJG,--归属分支机构
           CASE WHEN TB.RCPT_ID IS NOT NULL THEN TB.ENTRS_PAY_OBJ_ACC_NM
                WHEN A.ETR_ACC_NM IS NOT NULL THEN A.ETR_ACC_NM
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL
                THEN TA.DKRZHM
            END                                        AS DKRZHM_ORIG,--贷款入账户名（脱敏前）--ADD BY LIP 20230719
           CASE WHEN TB.RCPT_ID IS NOT NULL AND TB.ENTRS_PAY_OBJ_ACC_NM = D.CUST_NM THEN '是'
                WHEN TB.RCPT_ID IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(TB.ENTRS_PAY_OBJ_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                WHEN TB.RCPT_ID IS NOT NULL THEN '否'
                WHEN A.ETR_ACC_NM IS NOT NULL AND A.ETR_ACC_NM = D.CUST_NM THEN '是' --当入账户名和客户名一致时，是个人客户
                WHEN A.ETR_ACC_NM IS NOT NULL AND LENGTH(TRIM(REGEXP_REPLACE(A.ETR_ACC_NM,'[[:punct:]]',''))) BETWEEN 1 AND 3 --个人才需脱敏
                THEN '是'
                WHEN A.ETR_ACC_NM IS NOT NULL THEN '否'
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL AND TA.DKRZHM = D.CUST_NM
                THEN '是'
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL
                   AND LENGTH(TRIM(REGEXP_REPLACE(TA.DKRZHM,'[[:punct:]]',''))) BETWEEN 1 AND 3
                THEN '是'
                WHEN A.ETR_ACC IS NOT NULL AND TRIM(A.ETR_ACC_NM) IS NULL
                THEN '否'
            END                                        AS DKRZHM_OTH --贷款入账户名是否个人 --ADD BY LIP 20230719
      FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO A --表内借据信息
     INNER/*LEFT*/ JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.CUST_ID
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_LOAN TC --ADD BY LIP 20240523 参考1104加工逻辑
        ON TC.RCPT_ID = A.RCPT_ID
       AND TC.CBRC_FLG = 'Y'
       AND TC.DATA_SRC IN ('零售贷款','联合网贷')
       AND TC.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.S_LOAN_AGR_REL TD --ADD BY LIP 20240523 参考1104加工逻辑
        ON TD.RCPT_ID = A.RCPT_ID
       AND TD.CBRC_FLG = 'Y'
       AND TD.DATA_SRC IN ('零售贷款','联合网贷')
       AND TD.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_GL_INFO C --总账会计科目信息表
        ON C.SUBJ_ID = SUBSTR(A.SUBJ_ID,1,8) --科目报送到三级
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN LOAN_RP_PLAN_INFO E --贷款还款计划信息
        ON E.RCPT_ID = A.RCPT_ID
       AND E.REPY_PRD_NUM = A.CURR_PRD
      LEFT JOIN LOAN_RP_PLAN_INFO1 F --ADD BY LIP 20251211
        ON F.RCPT_ID = A.RCPT_ID
       AND F.RN = 1
      LEFT JOIN RRP_MDL.EAST5_503_GRXDYWJJB TA --新一代有些账号销户后不迁移，用20230430的入账账号信息刷数 MOD BY LIP 20230531
        ON TA.XDJJH = A.RCPT_ID
       AND TA.CJRQ = '20230430'
      LEFT JOIN LOAN_ENTRS_PAY_SUB TB --受托支付表
        ON TB.RCPT_ID = A.RCPT_ID
       AND TB.RN = 1
      LEFT JOIN RRP_MDL.ORG_CONFIG M --机构映射表
        ON M.ORG_ID = A.ORG_ID
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST B --机构表
        ON B.ORG_ID = NVL(M.ORG_ID1,'800')
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_LOAN_CONT_INFO G --ADD BY LIP 20240304 根据张家伟口径：增加与S6301口径的无还本续贷
        ON G.CONT_ID = A.CONT_ID
       AND G.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = D.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE1 --码值配置表
        ON CODE1.SRC_VALUE_CODE = A.DSBR_MODE
       AND CODE1.SRC_CLASS_CODE = 'D0104' --放款方式
       AND CODE1.TAR_CLASS_CODE = 'D0104' --放款方式
       AND CODE1.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE2 --码值配置表
        ON CODE2.SRC_VALUE_CODE = A.LVL5_CL
       AND CODE2.SRC_CLASS_CODE = 'D0005' --五级分类
       AND CODE2.TAR_CLASS_CODE = 'D0005' --五级分类
       AND CODE2.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE3 --码值配置表
        ON CODE3.SRC_VALUE_CODE = A.GXH_PAY_TYPE   --modify by tangan at 20230103 根据源系统码值映射
       AND CODE3.SRC_CLASS_CODE = 'CD1072' --还款方式
       AND CODE3.TAR_CLASS_CODE = 'CD1072' --还款方式
       AND CODE3.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE4 --码值配置表
        ON CODE4.SRC_VALUE_CODE = A.INT_CALC_MODE
       AND CODE4.SRC_CLASS_CODE = 'D0061' --计息方式
       AND CODE4.TAR_CLASS_CODE = 'D0061' --计息方式
       AND CODE4.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE5 --码值配置表
        ON CODE5.SRC_VALUE_CODE = A.LOAN_DIR_RGN
       AND CODE5.SRC_CLASS_CODE = 'P0002' --贷款投向地区
       AND CODE5.TAR_CLASS_CODE = 'P0002' --贷款投向地区
       AND CODE5.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE6 --码值配置表
        ON CODE6.SRC_VALUE_CODE = A.NET_LOAN_FLG
       AND CODE6.SRC_CLASS_CODE = 'Z0001' --是否互联网贷款
       AND CODE6.TAR_CLASS_CODE = 'Z0001' --是否互联网贷款
       AND CODE6.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE7 --码值配置表
        ON CODE7.SRC_VALUE_CODE = A.CBRC_GRN_LOAN_FLG
       AND CODE7.SRC_CLASS_CODE = 'Z0001' --是否绿色贷款
       AND CODE7.TAR_CLASS_CODE = 'Z0001' --是否绿色贷款
       AND CODE7.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE8 --码值配置表
        ON CODE8.SRC_VALUE_CODE = A.AGR_REL_LOAN_FLG
       AND CODE8.SRC_CLASS_CODE = 'Z0001' --是否涉农贷款
       AND CODE8.TAR_CLASS_CODE = 'Z0001' --是否涉农贷款
       AND CODE8.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE9 --码值配置表
        ON CODE9.SRC_VALUE_CODE = A.LOAN_BIZ_TYP
       AND CODE9.SRC_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE9.TAR_CLASS_CODE = 'T0001' --信贷业务种类
       AND CODE9.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE10 --码值配置表
        ON CODE10.SRC_VALUE_CODE = A.LOAN_FRM
       AND CODE10.SRC_CLASS_CODE = 'D0008' --贷款发放类型
       AND CODE10.TAR_CLASS_CODE = 'D0008' --贷款发放类型
       AND CODE10.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CODE_MAP CODE11 --码值配置表
        ON CODE11.SRC_VALUE_CODE = A.RCPT_STAT
       AND CODE11.SRC_CLASS_CODE = 'D0007' --借据状态
       AND CODE11.TAR_CLASS_CODE = 'D0007' --借据状态
       AND CODE11.MOD_FLG = 'EAST'
      LEFT JOIN RRP_MDL.CONFIG_ORG_REL ORG --机构级次关系表
        ON ORG.ORG_ID = B.ORG_ID
      LEFT JOIN RRP_MDL.CONFIG_TABLE_LIST LIST --分行报送报表配置表：记录分行报送的报表范围是全行数据还是本行数据 1 只报分行 0 全表报送
        ON 1 = 1
       AND UPPER(LIST.TABLE_NAME) = V_TABLE_NAME
     WHERE REGEXP_LIKE(A.LOAN_BIZ_TYP, '^(01|90)')
       AND A.EAST_FLG = 'Y'
       AND A.DATA_DT = V_P_DATE;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240109
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '更新和入账账号相同的还款账号对应的还款账号所属行名称';
    V_STARTTIME := SYSDATE;
    UPDATE RRP_EAST.EAST5_503_GRXDYWJJB T
       SET T.HKZHSSHMC = T.RZZHSSHMC
     WHERE T.HKZH = T.DKRZZH
       AND T.HKZHSSHMC IS NULL
       AND T.RZZHSSHMC IS NOT NULL
       AND T.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240702 上期状态为有效，在数据失效后再补报一期为失效/终结的数据
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '将上期授信状态为有效本期未采集到的插入目标表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_EAST.EAST5_503_GRXDYWJJB
      (RID, --数据主键
       JRXKZH, --金融许可证号
       NBJGH, --内部机构号
       YHJGMC, --银行机构名称
       MXKMBH, --明细科目编号
       MXKMMC, --明细科目名称
       KHTYBH, --客户统一编号
       KHMC, --客户名称
       ZJLB, --证件类别
       ZJHM, --证件号码
       XDHTH, --信贷合同号
       XDJJH, --信贷借据号
       DKFHZH, --贷款分户账号
       XDYWZL, --信贷业务种类
       DKFFLX, --贷款发放类型
       FKFS, --放款方式
       BZ, --币种
       DKJE, --贷款金额
       DKYE, --贷款余额
       DKWJFL, --贷款五级分类
       ZQS, --总期数
       DQQS, --当前期数
       ZQCS, --展期次数
       DKFFRQ, --贷款发放日期
       DKDQRQ, --贷款到期日期
       ZJRQ, --终结日期
       QBJE, --欠本金额
       QBRQ, --欠本日期
       BNQXYE, --表内欠息余额
       BWQXYE, --表外欠息余额
       QXRQ, --欠息日期
       LXQKQS, --连续欠款期数
       LJQKQS, --累计欠款期数
       SBXDJJH, --上笔信贷借据号
       DKRZZH, --贷款入账账号
       DKRZHM, --贷款入账户名
       RZZHSSHMC, --入账账号所属行名称
       LLLX, --利率类型
       SJLL, --实际利率
       HKFS, --还款方式
       HKZH, --还款账号
       HKZHSSHMC, --还款账号所属行名称
       JXFS, --计息方式
       XQHKRQ, --下期还款日期
       XQYHBJ, --下期应还本金
       XQYHLX, --下期应还利息
       DKTXDQ, --贷款投向地区
       JJDKYT, --借据贷款用途
       DKTXHY, --贷款投向行业
       SFHLWDK, --是否互联网贷款
       SFLSDK, --是否绿色贷款
       SFSNDK, --是否涉农贷款
       SFPHXSNDK, --是否普惠型涉农贷款
       SFPHXXWQYDK, --是否普惠型小微企业贷款
       SFKJDK, --是否科技贷款
       XDYGH, --信贷员工号
       DKZT, --贷款状态
       BBZ, --备注
       CJRQ, --采集日期
       DEPT_NO, --部门编号
       SRC_SYS_ID, --来源系统ID
       ISSUED_NO, --填报机构
       ORG_NO, --报送机构
       ADDRESS, --归属地
       KHMC_ORIG, --客户名称（脱敏前）
       ZJHM_ORIG, --证件号码（脱敏前）
       KHMC_OTH,--客户是否个人客户
       DKCPMC, --贷款产品名称
       GSFZJG,--归属分支机构
       DKRZHM_ORIG, --贷款入账户名（脱敏前）
       DKRZHM_OTH --贷款入账户名是否个人
       )
    SELECT /*+USE_HASH(A,D,C,B,CODE)*/
           SYS_GUID()                                  AS RID, --数据主键
           C.FIN_PERMIT_NO                             AS JRXKZH, --金融许可证号
           C.ORG_ID                                    AS NBJGH, --内部机构号
           C.ORG_NM                                    AS YHJGMC, --银行机构名称
           A.MXKMBH                                    AS MXKMBH, --明细科目编号
           A.MXKMMC                                    AS MXKMMC, --明细科目名称
           A.KHTYBH                                    AS KHTYBH, --客户统一编号
           D.CUST_NM_DESEN                             AS KHMC, --客户名称
           TRIM(SUBSTRB(CODE.TAR_VALUE_NAME,1,60))     AS ZJLB, --证件类别
           D.CRDL_NO_DESEN                             AS ZJHM, --证件号码
           A.XDHTH                                     AS XDHTH, --信贷合同号
           A.XDJJH                                     AS XDJJH, --信贷借据号
           A.DKFHZH                                    AS DKFHZH, --贷款分户账号
           A.XDYWZL                                    AS XDYWZL, --信贷业务种类
           A.DKFFLX                                    AS DKFFLX, --贷款发放类型
           A.FKFS                                      AS FKFS, --放款方式
           A.BZ                                        AS BZ, --币种
           A.DKJE                                      AS DKJE, --贷款金额
           0                                           AS DKYE, --贷款余额
           A.DKWJFL                                    AS DKWJFL, --贷款五级分类
           A.ZQS                                       AS ZQS, --总期数
           A.DQQS                                      AS DQQS, --当前期数
           A.ZQCS                                      AS ZQCS, --展期次数
           A.DKFFRQ                                    AS DKFFRQ, --贷款发放日期
           A.DKDQRQ                                    AS DKDQRQ, --贷款到期日期
           A.ZJRQ                                      AS ZJRQ, --终结日期
           0                                           AS QBJE, --欠本金额
           '99991231'                                  AS QBRQ, --欠本日期
           0                                           AS BNQXYE, --表内欠息余额
           0                                           AS BWQXYE, --表外欠息余额
           '99991231'                                  AS QXRQ, --欠息日期
           0                                           AS LXQKQS, --连续欠款期数
           A.LJQKQS                                    AS LJQKQS, --累计欠款期数
           A.SBXDJJH                                   AS SBXDJJH, --上笔信贷借据号
           A.DKRZZH                                    AS DKRZZH, --贷款入账账号
           A.DKRZHM                                    AS DKRZHM, --贷款入账户名
           A.RZZHSSHMC                                 AS RZZHSSHMC, --入账账号所属行名称
           A.LLLX                                      AS LLLX, --利率类型
           A.SJLL                                      AS SJLL, --实际利率
           A.HKFS                                      AS HKFS, --还款方式
           A.HKZH                                      AS HKZH, --还款账号
           A.HKZHSSHMC                                 AS HKZHSSHMC, --还款账号所属行名称
           A.JXFS                                      AS JXFS, --计息方式
           '99991231'                                  AS XQHKRQ, --下期还款日期
           0                                           AS XQYHBJ, --下期应还本金
           0                                           AS XQYHLX, --下期应还利息
           A.DKTXDQ                                    AS DKTXDQ, --贷款投向地区
           A.JJDKYT                                    AS JJDKYT, --借据贷款用途
           A.DKTXHY                                    AS DKTXHY, --贷款投向行业
           A.SFHLWDK                                   AS SFHLWDK, --是否互联网贷款
           A.SFLSDK                                    AS SFLSDK, --是否绿色贷款
           A.SFSNDK                                    AS SFSNDK, --是否涉农贷款
           A.SFPHXSNDK                                 AS SFPHXSNDK, --是否普惠型涉农贷款
           A.SFPHXXWQYDK                               AS SFPHXXWQYDK, --是否普惠型小微企业贷款
           A.SFKJDK                                    AS SFKJDK, --是否科技贷款
           A.XDYGH                                     AS XDYGH, --信贷员工号
           '结清'                                      AS DKZT, --贷款状态
           ''                                          AS BBZ, --备注
           V_MONTH_END_DATEID                          AS CJRQ, --采集日期
           A.DEPT_NO                                   AS DEPT_NO, --部门编号
           A.SRC_SYS_ID                                AS SRC_SYS_ID, --来源系统ID
           A.ISSUED_NO                                 AS ISSUED_NO, --填报机构
           A.ORG_NO                                    AS ORG_NO, --报送机构
           A.ADDRESS                                   AS ADDRESS, --归属地
           D.CUST_NM                                   AS KHMC_ORIG, --客户名称（脱敏前）
           D.CRDL_NO                                   AS ZJHM_ORIG, --证件号码（脱敏前）
           A.KHMC_OTH                                  AS KHMC_OTH,--客户是否个人客户
           A.DKCPMC                                    AS DKCPMC, --贷款产品名称 只用来区分行内外产品
           A.GSFZJG                                    AS GSFZJG,--归属分支机构
           A.DKRZHM_ORIG                               AS DKRZHM_ORIG,--贷款入账户名（脱敏前）
           A.DKRZHM_OTH                                AS DKRZHM_OTH --贷款入账户名是否个人
      FROM RRP_EAST.EAST5_503_GRXDYWJJB A --表内借据信息
      LEFT JOIN RRP_EAST.EAST5_503_GRXDYWJJB B
        ON B.XDJJH = A.XDJJH
       AND B.CJRQ = V_MONTH_END_DATEID
      LEFT JOIN RRP_EAST.M_CUST_IND_INFO_EAST D --个人客户信息
        ON D.CUST_ID = A.KHTYBH
       AND D.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_PUM_ORG_INFO_EAST C --机构表
        ON C.ORG_ID = A.NBJGH
       AND C.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.CODE_MAP CODE --码值配置表
        ON CODE.SRC_VALUE_CODE = D.CRDL_TYP
       AND CODE.SRC_CLASS_CODE = 'C0001' --证件类别
       AND CODE.TAR_CLASS_CODE = 'C0001' --证件类别
       AND CODE.MOD_FLG = 'EAST'
     WHERE B.XDJJH IS NULL
       AND A.DKZT IN ('正常','逾期')
       AND A.CJRQ = TO_CHAR(TRUNC(TO_DATE(V_MONTH_END_DATEID,'YYYYMMDD'),'MM') - 1,'YYYYMMDD');

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240109
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '更新和入账账号相同的还款账号对应的还款账号所属行名称';
    V_STARTTIME := SYSDATE;
    UPDATE RRP_EAST.EAST5_503_GRXDYWJJB T
       SET T.HKZHSSHMC = T.RZZHSSHMC
     WHERE T.HKZH = T.DKRZZH
       AND T.HKZHSSHMC IS NULL
       AND T.RZZHSSHMC IS NOT NULL
       AND T.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20240815
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '更新旧微粒贷的入账账号相关信息';
    V_STARTTIME := SYSDATE;
    UPDATE RRP_EAST.EAST5_503_GRXDYWJJB T
       SET T.DKRZZH = T.DKRZZH,T.RZZHSSHMC = T.HKZHSSHMC
     WHERE T.DKRZZH = T.XDJJH
       AND EXISTS (SELECT 1 FROM RRP_MDL.M_LOAN_IN_DUBILL_INFO TA
                    WHERE TA.RCPT_ID = T.XDJJH
                      AND TA.LOAN_STD_PROD_ID = '202010100006'
                      AND TA.DATA_DT = V_MONTH_END_DATEID)
       AND T.CJRQ = V_MONTH_END_DATEID;

    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE  := '0';
    V_ENDTIME  := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_TABLE_NAME,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

    --ADD BY LIP 20220603 去掉表的主键，通过语句判断数据是否重复
    V_STEP := V_STEP + 1;
    V_STEP_DESC := '查询数据是否重复';
    V_STARTTIME := SYSDATE;
      WITH TMP1 AS (
    SELECT CJRQ,XDJJH,COUNT(1)
      FROM RRP_EAST.EAST5_503_GRXDYWJJB T
     WHERE CJRQ = V_MONTH_END_DATEID
     GROUP BY CJRQ,XDJJH
    HAVING COUNT(1) > 1)
    SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1;

    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    IF V_COUNT > 0 THEN
       O_ERRCODE := '1';
       V_SQLMSG  := 'EAST5_503_GRXDYWJJB(CJRQ,XDJJH)数据重复';
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

END ETL_EAST5_503_GRXDYWJJB;
/

