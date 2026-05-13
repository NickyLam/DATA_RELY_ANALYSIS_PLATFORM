CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MID_TRA_CNTPTY_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MID_TRA_CNTPTY_INFO
  *  功能描述：监管集市交易对手信息中间表
  *  创建日期：20230207
  *  开发人员：TANGAN
  *  来源表：  O_ICL_CMM_DEP_ACCT_TRAN_DTL               --存款账户交易明细
  *            O_IOL_IBMS_TTRD_HX_COUNTERPARTY_REGISTRY  --同业系统华兴交易对手登记簿
  *            O_IOL_FAMS_FAM_TX_CNTPTY_INFO             --资管系统交易对手信息
  *            O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO       --票据系统交易对手信息视图
  *            O_IOL_ISBS_OPPNET                         --国结系统对手方信息表
  *            O_IOL_CTMS_VI_FBS_ACCOUNT_CPTYS_INFO      --资金系统交易对手_外币
  *            O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO      --资金系统交易对手_本币
  *            O_ICL_CMM_PBC_PASS_TRAN_FLOW              --人行通道交易流水表
  *            O_ICL_CMM_SUBJ_INFO                       --科目信息
  *            ORG_CONFIG                                --机构中间表
  *            O_IOL_MPCS_A08TBANKINFO                   --
  *  目标表：  M_MID_TRA_CNTPTY_INFO  --交易对手信息中间表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20241106  LIP      增加对方对公账户标志
  *             2    20250106  LIP      调整交易对手取数，不对最开始取数部分进行过滤，全部插入临时表，最后对结果数据进行排序取数
  *             3    20250206  LIP      调整限制对方账号不为空
  *             4    20250902  LIP      将取核算中台的相同逻辑合并，并增加利息取数的产品
  *             5    20260410  LIP      调整贴现、票据到期解付的交易对手取数
  *             6    20260417  LIP      对方行名中增加核心交易对手登记簿中的对方行名取数
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);                                --处理步骤描述
  V_P_DATE    VARCHAR2(8);                                  --跑批数据日期
  V_STARTTIME DATE;                                         --处理开始时间
  V_ENDTIME   DATE;                                         --处理结束时间
  V_SQLMSG    VARCHAR2(300);                                --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);                                --分区名
  V_STEP      INTEGER := 0;                                 --处理步骤
  V_SQLCOUNT  INTEGER := 0;                                 --更新或删除影响的记录数
  V_SQLCOUNT2 INTEGER := 0;                                 --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_MID_TRA_CNTPTY_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_MID_TRA_CNTPTY_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送';                  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE    := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  --MOD BY LIP 20250106
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '存款交易对手信息';
  V_STARTTIME := SYSDATE;
  --INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
    ,NUMB                      --序号 --ADD BY LIP 20250106
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH CORP_LOAN AS ( --贷款 --MOD BY LIP 20241106
  SELECT /*+MATERIALIZE*/T1.TRAN_REF_NO
        ,T1.OVA_FLOW_NUM
        ,T1.ACCT_ID
        ,COALESCE(TRIM(T1.ACCT_NAME),T2.ACCT_NAME,T3.ACCT_NAME) AS ACCT_NAME
        ,COALESCE(TRIM(T1.OPEN_ACCT_ORG_ID),T2.OPEN_ACCT_ORG_ID,T3.OPEN_ACCT_ORG_ID) AS OPEN_ACCT_ORG_ID
        ,COALESCE(T2.DUBIL_NUM,T3.DUBIL_NUM) DUBIL_NUM
        ,COALESCE(T2.SUBJ_ID,T3.SUBJ_ID) SUBJ_ID
        ,T5.SUBJ_NAME
        ,T4.FIN_INST_CODE
        --,T4.ORG_NAME
        ,T4.BKNAME AS ORG_NAME--MOD BY LIP 20230804
        ,ROW_NUMBER() OVER(PARTITION BY T1.TRAN_REF_NO,T1.OVA_FLOW_NUM ORDER BY T1.TRAN_AMT DESC) AS RN
        ,CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '1'
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '0'
          END OPP_CORP_ACCT_FLG
    FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW T1
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T2
      ON T2.ACCT_ID = T1.ACCT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO T3
      ON T3.ACCT_ID = T1.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG T4
      ON T4.ORG_ID = COALESCE(TRIM(T1.OPEN_ACCT_ORG_ID),T2.OPEN_ACCT_ORG_ID,T3.OPEN_ACCT_ORG_ID)
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO T5 --科目信息
      ON T5.SUBJ_ID = COALESCE(T2.SUBJ_ID,T3.SUBJ_ID)
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                         AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                       AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,CASE WHEN TRIM(B.HOST_FLOW_NUM) IS NOT NULL             THEN TRIM(B.HOST_FLOW_NUM)          --人行
              WHEN TRIM(ISBS.BIZ_SEQ_NUM) IS NOT NULL            THEN TRIM(ISBS.BIZ_SEQ_NUM)         --国结
              WHEN TRIM(BDMS.TRANSQ) IS NOT NULL                 THEN TRIM(BDMS.TRANSQ)              --新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.BIZ_SEQ_NUM)         --资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.FLOW_NO)             --同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.BIZ_SEQ_NUM)     --资金本币
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.BIZ_SEQ_NUM)     --资金外币
              ELSE A.TRAN_FLOW_NUM                                                            --核心
          END                                                                 AS SRC_SEQ_NUM               --源系统流水号
        ,CASE WHEN TRIM(B.OUT_LINE_PAY_TRAN_SEQ_NUM) IS NOT NULL THEN TRIM(B.OUT_LINE_PAY_TRAN_SEQ_NUM)  --人行
              WHEN TRIM(ISBS.BIZ_SEQ_NO) IS NOT NULL             THEN TRIM(ISBS.BIZ_SEQ_NO)              --国结
              WHEN TRIM(BDMS.SERINO) IS NOT NULL                 THEN TRIM(BDMS.SERINO)                  --新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TRAN_NUM)                --资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.FLOW_INNER_SN)           --同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.SEQ)                 --资金本币
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.SEQ)                 --资金外币
              ELSE '0'
          END                                                                 AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD)     AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                   THEN A.TRAN_ORG_ID||C.SUBJ_ID||A.TRAN_CURR_CD --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                  THEN A.TRAN_ORG_ID||C1.SUBJ_ID||A.TRAN_CURR_CD --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                 THEN TRIM(NCBS.OTH_REAL_BASE_ACCT_NO)         --11、核心的交易对手登记簿
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                 THEN TRIM(BDMS.CUST_ACCT)                     --5、外围交易数据--新票据
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)              --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              --MOD BY 20240327 当是行内账号时，优先取账号ID
              WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)        --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)                   --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL          THEN TRIM(B.RECVER_ACCT_NUM)                  --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(ISBS.TX_CNTPTY_ACCT_NUM)            --4、外围交易数据--国结
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TX_CNTPTY_ACCT_NUM)            --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.PARTY_ACCT_CODE)               --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.TX_CNTPTY_ACCT_NUM)        --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.TX_CNTPTY_ACCT_NUM)        --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL              THEN TRIM(LOAN.DUBIL_NUM)                     --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                   THEN TRIM(C.SUBJ_NAME)              --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                  THEN TRIM(C1.SUBJ_NAME)             --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                 THEN TRIM(NCBS.OTH_REAL_TRAN_NAME)  --11、核心的交易对手登记簿
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                 THEN TRIM(BDMS.CUST_NAME)                         --5、外围交易数据--新票据
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)  --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              --因有对方户名放到真实户名的情况，特此判断
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL AND TRIM(A.CNTPTY_ACCT_NAME) IS NULL AND TRIM(A.REAL_CNTPTY_ACCT_NAME) IS NOT NULL 
                AND COALESCE(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.REAL_CNTPTY_FIN_INST_CD),TRIM(A.REAL_CNTPTY_FIN_INST_NAME)) IS NULL
              THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)                     --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME) --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL          THEN TRIM(B.RECVER_NAME)                          --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(ISBS.TX_CNTPTY_NAME)                    --4、外围交易数据--国结
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TX_CNTPTY_NAME)                    --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.PARTY_ACCT_NAME)                   --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.TX_CNTPTY_NAME)                --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.TX_CNTPTY_NAME)                --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL              THEN TRIM(LOAN.ACCT_NAME)                         --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                        THEN TRIM(D.FIN_INST_CODE)                   --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                       THEN TRIM(D.FIN_INST_CODE)                   --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                      THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(NCBS.CONTRA_BANK_CODE)) --11、核心的交易对手登记簿
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                      THEN TRIM(BDMS.CUST_BANK_NO)                 --5、外围交易数据--新票据
              --因存在国结没将行号送到核心的情况，特此判断
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL AND TRIM(ISBS.TX_CNTPTY_ACCT_NUM) IS NOT NULL 
                   AND TRIM(ISBS.TX_CNTPTY_ACCT_NUM) = TRIM(A.REAL_CNTPTY_ACCT_ID)
              THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_CD) --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)         --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              --WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL                 THEN TRIM(A.CNTPTY_OPEN_BANK_ID)             --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              --MOD BY LIP 20260205
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL                 THEN NVL(TRIM(A.CNTPTY_OPEN_BANK_ID),TRIM(A.CNTPTY_ACCT_OPEN_BANK_CD)) --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL               THEN TRIM(B.RECVER_OPEN_BANK_NO)             --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL          THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_CD)      --4、外围交易数据--国结
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL          THEN TRIM(FAMS.CNTPTY_FIN_INST_BRAC_CD)      --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL              THEN TRIM(IBMS.PARTY_BANK_CODE)              --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN TRIM(CTMS_TBS.CNTPTY_FIN_INST_BRAC_CD)  --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN TRIM(CTMS_FBS.CNTPTY_FIN_INST_BRAC_CD)  --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL                   THEN TRIM(LOAN.FIN_INST_CODE)                --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_PBC_NO                --对方行号
        ,CASE /*WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                         THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                        THEN TRIM(B1.ORG_NAME)                         --11、核心的交易对手登记簿
              WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息*/
              --MOD BY LIP 20230804 机构名称优先取中台的机构名
              WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.BKNAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                         THEN TRIM(D.BKNAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL AND TRIM(NCBS.CONTRA_BANK_NAME) IS NOT NULL THEN TRIM(NCBS.CONTRA_BANK_NAME) --MOD BY LIP 20260417
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL AND TRIM(B1.BKNAME) IS NOT NULL THEN TRIM(B1.BKNAME)                  --11、核心的交易对手登记簿
              --ADD BY LIP 20230804 机构名为空时，关联中台的机构名
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                        THEN TRIM(B2.BKNAME)                           --11、核心的交易对手登记簿
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                        THEN TRIM(BDMS.CUST_BANK_NAME)                 --5、外围交易数据--新票据
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL              THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)         --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL                   THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)             --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL                 THEN TRIM(B.RECVER_OPEN_BANK_NAME)             --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL            THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_NAME)      --4、外围交易数据--国结
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL            THEN TRIM(FAMS.CNTPTY_FIN_INST_BRAC_NAME)      --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL                THEN TRIM(IBMS.PARTY_BANK_NAME)                --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL        THEN TRIM(CTMS_TBS.CNTPTY_FIN_INST_BRAC_NAME)  --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL        THEN TRIM(CTMS_FBS.CNTPTY_FIN_INST_BRAC_NAME)  --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL                     THEN TRIM(LOAN.ORG_NAME)                       --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_BANK_NM               --对方行名
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL               THEN C.SUBJ_ID        --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL              THEN C1.SUBJ_ID       --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL          THEN TRIM(LOAN.SUBJ_ID) --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,CASE WHEN TRIM(C.SUBJ_NAME) IS NOT NULL             THEN C.SUBJ_NAME     --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_NAME) IS NOT NULL            THEN C1.SUBJ_NAME     --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL          THEN TRIM(LOAN.SUBJ_NAME) --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_SUBJ_NM               --对方科目名称
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                    THEN '按科目拼接内部户'
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL           THEN '社保和缴税'
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL  THEN '资金系统本币'
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL  THEN '资金系统外币'
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN '国结系统'
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                  THEN '票据系统'
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN '资管系统'
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL          THEN '同业系统'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GIER'            THEN '智能报销系统'
              ELSE '核心系统'
          END                                                                 AS SRC_FLG                   --源系统标志
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                   THEN '1'       --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                  THEN '1'       --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                 THEN NULL      --11、核心的交易对手登记簿
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                 THEN '1'       --5、外围交易数据--新票据
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN NULL      --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN NULL --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN NULL      --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL          THEN NULL      --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN NULL      --4、外围交易数据--国结
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN NULL      --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN '1'       --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN '1'       --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN '1'       --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL              THEN LOAN.OPP_CORP_ACCT_FLG --10、从核心贷款流水获取交易对手信息
          END                                                                 AS OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
        ,1                                                                    AS NUMB                      --序号 --ADD BY LIP 20250106
        ,A.TRAN_KIND_CD                                                       AS TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,A.MEMO_CD                                                            AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,TRIM(A.MEMO_CD_DESCB)                                                AS MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    --MOD BY LIP 20250120 按照雄爷指示优化取数
    LEFT JOIN (SELECT CASE WHEN SUBSTR(BB.HOST_FLOW_NUM,1,5) = 'SNCBS' THEN BB.HOST_FLOW_NUM
                           ELSE TO_CHAR(BB.TRAN_DT,'YYYYMMDD')||BB.HOST_FLOW_NUM
                       END AS TRAN_FLOW_NUM_BB,BB.*,
                      ROW_NUMBER() OVER(PARTITION BY TO_CHAR(BB.TRAN_DT,'YYYYMMDD')||BB.HOST_FLOW_NUM ORDER BY BB.JOB_CD DESC) AS RN
                 FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW BB --人行通道交易流水表
                INNER JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL AA 
                   ON AA.TRAN_FLOW_NUM = CASE WHEN SUBSTR(BB.HOST_FLOW_NUM,1,5) = 'SNCBS' THEN BB.HOST_FLOW_NUM
                                              ELSE TO_CHAR(BB.TRAN_DT,'YYYYMMDD')||BB.HOST_FLOW_NUM
                                          END
                  AND TRIM(AA.MEMO_CD_DESCB) IN ('缴税','社保费','社保')
                  AND AA.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND AA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE TRIM(BB.HOST_FLOW_NUM) IS NOT NULL
                  AND BB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) B
      ON B.TRAN_FLOW_NUM_BB = A.TRAN_FLOW_NUM
     --AND TRIM(A.MEMO_CD_DESCB) IN ('缴税','社保费','社保')
     AND B.TRAN_DT = A.TRAN_DT
     AND B.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C --科目信息
      ON C.SUBJ_ID = TRIM(A.CNTPTY_ACCT_ID)
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C1 --科目信息
      ON C1.SUBJ_ID = TRIM(A.REAL_CNTPTY_ACCT_ID)
     AND C1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = A.TRAN_ORG_ID
    LEFT JOIN RRP_MDL.O_IOL_ISBS_OPPNET ISBS --国结系统对手方信息表
      ON ISBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM --全局流水号
     AND ISBS.PTY_ACCT_NUM = A.CUST_ACCT_ID   --交易账号
     AND ISBS.TRAN_TYPE = A.DEBIT_CRDT_DIR_CD --交易方向
     AND ISBS.BIZ_CCY = A.TRAN_CURR_CD        --交易币种
     AND ISBS.BIZ_AMT = A.TRAN_AMT            --交易金额
     AND ISBS.GLDATE = V_P_DATE--TO_CHAR(A.TRAN_DT,'YYYYMMDD') --交易时间
    LEFT JOIN (SELECT PJ.*,ROW_NUMBER() OVER(PARTITION BY PJ.BSNSSQ,ISCUSTACCT,PJ.EVETDN ORDER BY PJ.SERINO DESC) AS RN
                 FROM RRP_MDL.O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO PJ --票据系统交易对手信息视图
                WHERE TRIM(PJ.CUST_ACCT) IS NOT NULL) BDMS
      ON BDMS.BSNSSQ = A.OVA_FLOW_NUM --全局流水号
     AND BDMS.EVETDN = A.DEBIT_CRDT_DIR_CD
     AND BDMS.ISCUSTACCT = DECODE(A.CUST_TYPE_CD,'-','0','1')
     AND BDMS.RN = 1
    LEFT JOIN (SELECT ZG.*,ROW_NUMBER() OVER(PARTITION BY ZG.CORE_TRAN_FLOW_NUM ORDER BY ZG.TRAN_NUM DESC) AS RN
                 FROM RRP_MDL.O_IOL_FAMS_FAM_TX_CNTPTY_INFO ZG --资管系统交易对手信息
                /*WHERE ZG.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND ZG.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/) FAMS
      ON FAMS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM --全局流水号
     AND FAMS.RN = 1
    LEFT JOIN (SELECT CASE WHEN TY.DEBIT_CREDIT_FLAG = '1' THEN 'D'  --借
                           WHEN TY.DEBIT_CREDIT_FLAG = '2' THEN 'C'  --贷
                           ELSE TY.DEBIT_CREDIT_FLAG
                       END AS DEBIT_CRDT_DIR_CD,TY.*,
                      ROW_NUMBER() OVER(PARTITION BY TY.GLOBAL_FLOW_NO,TY.ENTRY_DATE,TY.CURRENCY,TY.VALUE,TY.DEBIT_CREDIT_FLAG
                       ORDER BY TY.FLOW_INNER_SN DESC) AS RN
                 FROM RRP_MDL.O_IOL_IBMS_TTRD_HX_COUNTERPARTY_REGISTRY TY --同业系统华兴交易对手登记簿
                /*WHERE TY.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND TY.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/) IBMS
      ON IBMS.GLOBAL_FLOW_NO = A.OVA_FLOW_NUM --全局流水号
     AND IBMS.ENTRY_DATE = TO_CHAR(A.TRAN_DT,'YYYY-MM-DD') --交易时间
     AND IBMS.CURRENCY = A.TRAN_CURR_CD --交易币种
     AND IBMS.VALUE = A.TRAN_AMT --交易金额
     AND IBMS.DEBIT_CRDT_DIR_CD = A.DEBIT_CRDT_DIR_CD --交易方向
     AND IBMS.RN = 1
    LEFT JOIN (SELECT ZJBB.*,ROW_NUMBER() OVER(PARTITION BY ZJBB.CORE_TRAN_FLOW_NUM ORDER BY ZJBB.SEQ DESC) AS RN
                 FROM RRP_MDL.O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO ZJBB --资金系统交易对手_本币
                /*WHERE ZJBB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                 AND ZJBB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/) CTMS_TBS
      ON CTMS_TBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM --全局流水号
     AND CTMS_TBS.RN = 1
    LEFT JOIN (SELECT ZJWB.*,ROW_NUMBER() OVER(PARTITION BY ZJWB.CORE_TRAN_FLOW_NUM ORDER BY ZJWB.SEQ DESC) AS RN
                 FROM RRP_MDL.O_IOL_CTMS_VI_FBS_ACCOUNT_CPTYS_INFO ZJWB --资金系统交易对手_外币
                /*WHERE ZJWB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND ZJWB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')*/) CTMS_FBS
      ON CTMS_FBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM --全局流水号
     AND CTMS_FBS.RN = 1
    /*LEFT JOIN IERS --智能报销系统 待接入*/
    LEFT JOIN CORP_LOAN LOAN
      ON LOAN.TRAN_REF_NO = A.TRAN_FLOW_NUM
     AND LOAN.OVA_FLOW_NUM = A.OVA_FLOW_NUM
     AND LOAN.RN = 1
    LEFT JOIN (SELECT SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO,OTH_REAL_BASE_ACCT_NO,OTH_REAL_TRAN_NAME,CONTRA_BANK_CODE,TRAN_AMT,
                      OTH_REAL_ACCT_SEQ_NO,REGISTER_SEQ_NO,TRAN_TIMESTAMP,COMPANY,SOURCE_MODULE,START_DT,END_DT,ID_MARK,ETL_TIMESTAMP,
                      CONTRA_BANK_NAME, --真实对手行名 --ADD BY LIP 20260417
                      ROW_NUMBER() OVER(PARTITION BY SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO ORDER BY TRAN_AMT DESC) AS RN
                 FROM RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG) NCBS --核心交易对手登记簿 ADD BY TANGAN AT 20230209
      ON NCBS.SEQ_NO = A.ACCT_BILL_FLOW_NUM
     AND NCBS.REFERENCE = A.TRAN_FLOW_NUM
     AND NCBS.CHANNEL_SEQ_NO = A.OVA_FLOW_NUM
     AND NCBS.SUB_SEQ_NO = A.TRAN_FLG_NUM
     AND NCBS.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG B1 --ADD BY TANGAN AT 20230209
      ON B1.ORG_ID = TRIM(NCBS.CONTRA_BANK_CODE)
    --ADD BY LIP 20230804 行号不为空，行名为空的数据，用中台机构表的信息补全
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO B2
      ON B2.BKCD = TRIM(NCBS.CONTRA_BANK_CODE)
     AND B2.ID_MARK <> 'D'
     AND B2.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B2.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '存息对手信息1';
  V_STARTTIME := SYSDATE;
  --INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
    ,NUMB                      --序号 --ADD BY LIP 20250106
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH TGLS_GLA_VCHR_H AS (
  SELECT /*+MATERIALIZE*/SOURSQ,REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ,BSNSSQ,TRANAM,ITEMCD,ITEMNA--,AMNTCD
        ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
        ,ITEMNA                     AS OPP_ACC_NM
        ,TA.FIN_INST_CODE           AS OPP_PBC_NO --MOD BY LIP 20230804 对内部机构进行转换
        ,TA.BKNAME                  AS OPP_BANK_NM
        ,T.ASSIS1                   AS ASSIS1
        ,CASE WHEN AMNTCD = 'D' THEN 'C' WHEN AMNTCD = 'C' THEN 'D' ELSE AMNTCD END AS AMNTCD
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
    LEFT JOIN RRP_MDL.ORG_CONFIG TA --ADD BY LIP 20230804 对机构进行转换
      ON TA.ORG_ID = T.ACCTBR
   WHERE T.STACID = 1
     AND T.SYSTID = 'NCBS'
     --AND T.AMNTCD = 'D' --借方
     AND T.ASSIS1 <> '999999999999'
     AND T.TRANDT = V_P_DATE
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                         AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                       AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                      AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                  AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL      THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL             THEN TRIM(B.OPP_ACC)
          END                                                                 AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL      THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL             THEN TRIM(B.OPP_ACC_NM)
          END                                                                 AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL      THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL             THEN TRIM(B.OPP_PBC_NO)
          END                                                                 AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL      THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL             THEN TRIM(B.OPP_BANK_NM)
          END                                                                 AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                             AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                             AS OPP_SUBJ_NM               --对方科目名称
        /*,CASE WHEN A.MEMO_CD = 'IN' THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
          END                                                                 AS SRC_FLG                   --源系统标志*/
        ,CASE WHEN A.MEMO_CD IN ('IN','DQI') THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('5001') THEN '5001贷方利息调整入账' --ADD BY LIP 20231208
              WHEN A.TRAN_KIND_CD IN ('2201') THEN '2201结算户转久悬户' --ADD BY LIP 20231220
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
              WHEN A.TRAN_KIND_CD IN ('Z099') THEN '票据业务资金清算往来款-贷记' --ADD BY LIP 20240119
              WHEN A.TRAN_KIND_CD IN ('Z021') THEN '银承兑付专户-借记' --ADD BY LIP 20240119
          END                                                                 AS SRC_FLG                   --源系统标志
        ,'1'                                                                  AS OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
        ,2                                                                    AS NUMB                      --序号 --ADD BY LIP 20250106
        ,A.TRAN_KIND_CD                                                       AS TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,A.MEMO_CD                                                            AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,TRIM(A.MEMO_CD_DESCB)                                                AS MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.AMNTCD = A.DEBIT_CRDT_DIR_CD --ADD BY LIP 20250902
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     --AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND (A.MEMO_CD IN ('IN','DQI') --MOD BY LIP 20231107 增加存息的DQI类型
          --MOD BY LIP 20231208 2201 结算户转久悬户
          OR A.TRAN_KIND_CD IN ('CK01','DK01','5001','2201')) --长款处理交易类型CK01,短款处理交易类型DK01 5001贷方利息调整入账(单户结息)
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '转账收费对手信息';
  V_STARTTIME := SYSDATE;
  --INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
    ,NUMB                      --序号 --ADD BY LIP 20250106
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH TGLS_GLA_VCHR_H AS (
  SELECT /*+MATERIALIZE*/
         SOURSQ,REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ,BSNSSQ,TRANAM,ITEMCD,ITEMNA--,AMNTCD
        ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
        ,ITEMNA                     AS OPP_ACC_NM
        ,TA.FIN_INST_CODE           AS OPP_PBC_NO
        ,TA.BKNAME                  AS OPP_BANK_NM
        ,T.ASSIS1                   AS ASSIS1
        ,CASE WHEN AMNTCD = 'D' THEN 'C' WHEN AMNTCD = 'C' THEN 'D' ELSE AMNTCD END AS AMNTCD
        --,ROW_NUMBER() OVER(PARTITION BY BSNSSQ,SOURSQ ORDER BY TRANAM DESC) AS RN
        ,ROW_NUMBER() OVER(PARTITION BY BSNSSQ,SOURSQ,AMNTCD ORDER BY TRANAM DESC,ASSIS1) AS RN --MOD BY LIP 20251105
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
    --ADD BY LIP 20230804 对机构进行转换
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ACCTBR
   WHERE T.STACID = 1
     AND T.SYSTID = 'NCBS'
     --AND T.AMNTCD = 'C' --贷方
     AND (T.ASSIS1 LIKE '5%' --5开头的产品为收费产品
         OR T.ASSIS1 LIKE '2%' --利息调整，要求跟贷款产品关联上 2开头的是贷款产品 --ADD BY LIP 20260209
         OR T.ITEMCD LIKE '6%' --损益
         OR T.ASSIS1 LIKE '963%' --票据清算
         OR T.ASSIS1 LIKE '9990501%' --提前还款违约金
         OR T.ASSIS1 IN ('999999999999','103010300005','201010300035','201010300040') --ADD BY LIP 20250902 --MOD BY LIP 20250909 增加好易贷的手续费和利息调整
         )
     AND T.TRANDT = V_P_DATE
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                         AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                       AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                      AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                  AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
         END                                                                  AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
         END                                                                  AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
         END                                                                  AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
         END                                                                  AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                             AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                             AS OPP_SUBJ_NM               --对方科目名称
        ,CASE WHEN A.TRAN_KIND_CD LIKE 'FEE%' THEN '转账收费'
              WHEN A.TRAN_KIND_CD IN ('FX64') THEN '结售汇收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX72') THEN '市场平盘收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX67') THEN '市场平盘损失贷方'
              WHEN A.TRAN_KIND_CD IN ('4189') THEN '行内转账存入(非支票)' --MOD BY LIP 20250909
              --WHEN A.MEMO_CD IN ('DQ') THEN '承兑解付'
          END                                                                 AS SRC_FLG                   --源系统标志
        ,'1'                                                                  AS OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
        ,3                                                                    AS NUMB                      --序号 --ADD BY LIP 20250106
        ,A.TRAN_KIND_CD                                                       AS TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,A.MEMO_CD                                                            AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,TRIM(A.MEMO_CD_DESCB)                                                AS MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.AMNTCD = A.DEBIT_CRDT_DIR_CD --ADD BY LIP 20250902
     AND B.RN = 1
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     --AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
     --MOD BY LIP 20230804 经与核心确认，只要交易类型是FEE开头的，都是收费
     --MOD BY LIP 20230831 增加结售汇收益借方的数据
     AND (A.TRAN_KIND_CD LIKE 'FEE%'
          --MOD BY LIP 20231208
          OR A.TRAN_KIND_CD IN ('FX64','FX72','FX67','Z099','Z021','4189') --FX72 市场平盘收益借方 FX67 市场平盘损失贷方 --4189新增
          /*OR A.MEMO_CD IN ('DQ')*/) --MOD BY 20231110 增加承兑解付的取数 --MOD BY LIP 20241205 DQ承兑到期解付不从核算中台取数
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '久悬户激活对手信息';
  V_STARTTIME := SYSDATE;
  --INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
    ,NUMB                      --序号 --ADD BY LIP 20250106
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH TGLS_GLA_VCHR_H AS (
  SELECT /*+MATERIALIZE*/SOURSQ,REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ,BSNSSQ,AMNTCD,TRANAM,ITEMCD,ITEMNA
        ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
        ,ITEMNA                     AS OPP_ACC_NM
        /*,ACCTBR                     AS OPP_PBC_NO
        ,NULL                       AS OPP_BANK_NM*/
        --MOD BY LIP 20230804 对内部机构进行转换
        ,TA.FIN_INST_CODE           AS OPP_PBC_NO
        ,TA.BKNAME                  AS OPP_BANK_NM
        ,ROW_NUMBER() OVER(PARTITION BY T.SOURSQ,T.SRVCSQ,T.BSNSSQ ORDER BY T.ASSIS1) AS RN
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
    --ADD BY LIP 20230804 对机构进行转换
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ACCTBR
   WHERE T.STACID = 1
     AND T.SYSTID = 'NCBS'
     AND T.AMNTCD = 'D' --借方
     --AND T.ASSIS1 <> '999999999999'
     AND T.TRANDT = V_P_DATE
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                         AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                       AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                      AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                  AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              --MOD BY LIP 20231221 根据陈旭颖给的规则，兜底规则：取不到就组固定值，借方科目是 22410201久悬未取款
              ELSE TRIM(A.TRAN_ORG_ID)||'22410201'||TRIM(A.TRAN_CURR_CD)
         END                                                                  AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              ELSE '久悬未取款'
         END                                                                  AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              ELSE C.FIN_INST_CODE
         END                                                                  AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              ELSE C.BKNAME
         END                                                                  AS OPP_BANK_NM               --对方行名
        ,NVL(B.ITEMCD,'22410201')                                             AS OPP_SUBJ_ID               --对方科目编号
        ,NVL(B.ITEMNA,'久悬未取款')                                           AS OPP_SUBJ_NM               --对方科目名称
        --,'久悬户激活和费用支出'                                               AS SRC_FLG                   --源系统标志
        ,'久悬户激活'                                                         AS SRC_FLG                   --源系统标志
        ,'1'                                                                  AS OPP_CORP_ACCT_FLG         --对方对公账户标志 --ADD BY LIP 20241106
        ,4                                                                    AS NUMB                      --序号 --ADD BY LIP 20250106
        ,A.TRAN_KIND_CD                                                       AS TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,A.MEMO_CD                                                            AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,TRIM(A.MEMO_CD_DESCB)                                                AS MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = TRIM(A.TRAN_ORG_ID)
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     --AND A.CASH_TRANS_FLG = '0' --转
     AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     --AND (A.TRAN_DESCB = '久悬户激活' OR A.TRAN_DESCB  LIKE '%费用支出%')
     --MOD BY LIP 20230815 改成用代码框数
     AND (A.TRAN_KIND_CD = '2204' /*OR A.TRAN_DESCB LIKE '%费用支出%'*/) --费用支出和上面的FEE有冲突，注释该部分
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260410 LIP 一表通需求，调整贴现、承兑到期解付的交易对手取数
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '贴现、承兑到期解付对手信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志
    ,NUMB                      --序号
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH TGLS_GLA_VCHR_H AS (
  SELECT /*+MATERIALIZE*/SOURSQ,REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ,BSNSSQ,TRANAM,ITEMCD,ITEMNA
        ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
        ,ITEMNA                     AS OPP_ACC_NM
        ,TA.FIN_INST_CODE           AS OPP_PBC_NO
        ,TA.BKNAME                  AS OPP_BANK_NM
        ,CASE WHEN T.AMNTCD = 'D' THEN 'C' WHEN T.AMNTCD = 'C' THEN 'D' ELSE T.AMNTCD END AS AMNTCD
        ,ROW_NUMBER() OVER(PARTITION BY T.SOURSQ,T.AMNTCD ORDER BY T.TRANAM DESC) AS RN
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ACCTBR
   WHERE T.STACID = 1
     AND T.SYSTID = 'NCBS'
     AND T.TRANDT = V_P_DATE
     AND T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                         AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                      AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                       AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                      AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                 AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                  AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
         END                                                                  AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
         END                                                                  AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              ELSE C.FIN_INST_CODE
         END                                                                  AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              ELSE C.BKNAME
         END                                                                  AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                             AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                             AS OPP_SUBJ_NM               --对方科目名称
        ,A.MEMO_CD_DESCB                                                      AS SRC_FLG                   --源系统标志
        ,'1'                                                                  AS OPP_CORP_ACCT_FLG         --对方对公账户标志
        ,5                                                                    AS NUMB                      --序号 --ADD BY LIP 20250106
        ,A.TRAN_KIND_CD                                                       AS TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,A.MEMO_CD                                                            AS MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,TRIM(A.MEMO_CD_DESCB)                                                AS MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.AMNTCD = A.DEBIT_CRDT_DIR_CD
     AND B.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = TRIM(A.TRAN_ORG_ID)
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.MEMO_CD_DESCB IN ('贴现','承兑到期解付')
     AND NVL(TRIM(A.REAL_CNTPTY_FIN_INST_NAME),'华兴') LIKE '%华兴%' --交易对手账号名称是我行的
     AND A.CUST_TYPE_CD NOT IN ('-') --剔除内部户交易
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --MOD BY LIP 20250106
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '将数据插入目标表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MID_TRA_CNTPTY_INFO
    (DATA_DT                   --数据日期
    ,TRA_DT                    --交易日期
    ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
    ,TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM        --核心账单流水号
    ,CORE_TRAN_FLOW_NUM        --全局流水号
    ,SRC_SEQ_NUM               --源系统流水号
    ,SRC_TRA_SEQ_NO            --源系统交易序号
    ,TRA_DR_CR_FLG             --交易借贷标志
    ,OPP_ACC                   --对方账号
    ,OPP_ACC_NM                --对方户名
    ,OPP_PBC_NO                --对方行号
    ,OPP_BANK_NM               --对方行名
    ,OPP_SUBJ_ID               --对方科目编号
    ,OPP_SUBJ_NM               --对方科目名称
    ,SRC_FLG                   --源系统标志
    ,OPP_CORP_ACCT_FLG         --对方对公账户标志
    ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
    ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
    ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    )
    WITH TMP1 AS (
  SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.TRA_SEQ_NO ORDER BY T.DATA_DT,
         CASE WHEN T.MEMO_CD_DESCB IN ('贴现','承兑到期解付') AND T.NUMB = 1 AND T.OPP_ACC = '0' THEN 99
              ELSE T.NUMB END) AS RN --MOD BY LIP 20260410 贴现和承兑解付的对方是我行且对方账号是0时，优先取科目做为对手方
    FROM RRP_MDL.M_MID_TRA_CNTPTY_INFO_TMP T
   WHERE TRIM(T.OPP_ACC) IS NOT NULL --MOD BY 20250206
     AND T.DATA_DT = V_P_DATE)
  SELECT DATA_DT                   --数据日期
        ,TRA_DT                    --交易日期
        ,TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,TRAN_FLOW_NUM             --核心交易流水号
        ,ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,CORE_TRAN_FLOW_NUM        --全局流水号
        ,SRC_SEQ_NUM               --源系统流水号
        ,SRC_TRA_SEQ_NO            --源系统交易序号
        ,TRA_DR_CR_FLG             --交易借贷标志
        ,OPP_ACC                   --对方账号
        ,OPP_ACC_NM                --对方户名
        ,OPP_PBC_NO                --对方行号
        ,OPP_BANK_NM               --对方行名
        ,OPP_SUBJ_ID               --对方科目编号
        ,OPP_SUBJ_NM               --对方科目名称
        ,SRC_FLG                   --源系统标志
        ,OPP_CORP_ACCT_FLG         --对方对公账户标志
        ,TRAN_KIND_CD              --交易种类代码 --ADD BY LIP 20260410
        ,MEMO_CD                   --摘要代码 --ADD BY LIP 20260410
        ,MEMO_CD_DESCB             --摘要代码描述 --ADD BY LIP 20260410
    FROM TMP1 A
   WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260209 因国结的交易对手登记簿中的对方账号和送核心的真实对方账号不一致
  --核心的接口是送一条记录，一条记录只能有一个交易对手；
  --可以理解为：结售汇接口没有借贷的区分，是一条信息，核心自己从这条信息里面去拿借方信息和贷方信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新对方行号为空数据--国结部分';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT * FROM RRP_MDL.M_MID_TRA_CNTPTY_INFO
               WHERE OPP_ACC IS NOT NULL
                 AND (OPP_PBC_NO IS NULL OR OPP_BANK_NM IS NULL) --有账号没有行号或者行名的数据
                 AND DATA_DT = V_P_DATE) TA
  USING (SELECT T.CORE_TRAN_FLOW_NUM,
                TRIM(T.TX_CNTPTY_ACCT_NUM) AS OPP_ACC,
                TRIM(T.TX_CNTPTY_NAME) AS OPP_ACC_NM,
                TRIM(T.CNTPTY_FIN_INST_BRAC_CD) AS OPP_PBC_NO,
                TRIM(T.CNTPTY_FIN_INST_BRAC_NAME) AS OPP_BANK_NM,
                ROW_NUMBER() OVER(PARTITION BY T.CORE_TRAN_FLOW_NUM,TRIM(T.TX_CNTPTY_ACCT_NUM) ORDER BY GLINR) RN
           FROM RRP_MDL.O_IOL_ISBS_OPPNET T --国结系统对手方信息表
          WHERE TRIM(T.TX_CNTPTY_ACCT_NUM) IS NOT NULL
            AND T.GLDATE = V_P_DATE) TB
     ON (TB.CORE_TRAN_FLOW_NUM = TA.CORE_TRAN_FLOW_NUM AND TB.OPP_ACC = TA.OPP_ACC AND TB.RN = 1)
   WHEN MATCHED THEN UPDATE SET
     TA.OPP_PBC_NO = TB.OPP_PBC_NO,
     TA.OPP_BANK_NM = TB.OPP_BANK_NM;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 20260209 有行名没有行号的数据,用行名到中台机构信息表匹配行号
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '更新对方行号为空数据--有行名没有行号的数据';
  V_STARTTIME := SYSDATE;
  MERGE INTO (SELECT * FROM RRP_MDL.M_MID_TRA_CNTPTY_INFO
               WHERE OPP_BANK_NM IS NOT NULL
                 AND OPP_PBC_NO IS NULL --有行名没有行号的数据
                 AND DATA_DT = V_P_DATE) TA
  USING (SELECT T.BKCD,T.BKNAME,ROW_NUMBER() OVER(PARTITION BY T.BKNAME ORDER BY FCTVDT DESC,BKCD) RN
           FROM RRP_MDL.O_IOL_MPCS_A08TBANKINFO T --中台机构信息表
          WHERE T.ID_MARK <> 'D'
            AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
            AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) TB
     ON (TB.BKNAME = TA.OPP_BANK_NM AND TB.RN = 1)
   WHEN MATCHED THEN UPDATE SET
     TA.OPP_PBC_NO = TB.BKCD;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询是否有数据重复';
  V_STARTTIME := SYSDATE;
  WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,COUNT(1)
    FROM RRP_MDL.M_MID_TRA_CNTPTY_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  --如需要分析表，请用如下代码
  RRP_MDL.ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  --MOD BY LIP 20231010 月批调账后重跑一次后，增加月批的标志
  WITH TMP2 AS (
  SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE PROC_NAME = V_PROC_NAME AND ETL_DATE = V_P_DATE)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
 WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MID_TRA_CNTPTY_INFO;
/

