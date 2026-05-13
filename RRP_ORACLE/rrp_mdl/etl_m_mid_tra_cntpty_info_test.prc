CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MID_TRA_CNTPTY_INFO_TEST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MID_TRA_CNTPTY_INFO
  *  功能描述：监管集市交易对手信息中间表
  *  创建日期：20230207
  *  开发人员：tangan
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
  *            O_IOL_MPCS_A08TBANKINFO                   --中台机构信息表
  *  目标表：  M_MID_TRA_CNTPTY_INFO  --交易对手信息中间表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  *
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);                                --处理步骤描述
  V_P_DATE    VARCHAR2(8);                                  --跑批数据日期
  V_STARTTIME DATE;                                         --处理开始时间
  V_ENDTIME   DATE;                                         --处理结束时间
  V_SQLMSG    VARCHAR2(300);                                --SQL执行描述信息
  V_DATE      DATE;                                         --数据日期(判断输入参数日期格式是否准确)
  V_PART_NAME VARCHAR2(100);                                --分区名
  V_STEP      INTEGER := 0;                                 --处理步骤
  V_SQLCOUNT  INTEGER := 0;                                 --更新或删除影响的记录数
  V_SQLCOUNT2 INTEGER := 0;                                 --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'M_MID_TRA_CNTPTY_INFO';     --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_MID_TRA_CNTPTY_INFO_TEST'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送';                  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE    := TO_CHAR( I_P_DATE); --获取跑批日期
  V_DATE      := TO_DATE(I_P_DATE,'YYYYMMDD');
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '存款交易对手信息';
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
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,CASE WHEN TRIM(B.HOST_FLOW_NUM) IS NOT NULL             THEN TRIM(B.HOST_FLOW_NUM)      --人行
              WHEN TRIM(ISBS.BIZ_SEQ_NUM) IS NOT NULL            THEN TRIM(ISBS.BIZ_SEQ_NUM)     --国结
              WHEN TRIM(BDMS.TRANSQ) IS NOT NULL                 THEN TRIM(BDMS.TRANSQ)          --新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.BIZ_SEQ_NUM)     --资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.FLOW_NO)         --同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.BIZ_SEQ_NUM) --资金本币
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.BIZ_SEQ_NUM) --资金外币
              ELSE A.TRAN_FLOW_NUM                                                               --核心
         END                                                                      AS SRC_SEQ_NUM               --源系统流水号
        ,CASE WHEN TRIM(B.OUT_LINE_PAY_TRAN_SEQ_NUM) IS NOT NULL THEN TRIM(B.OUT_LINE_PAY_TRAN_SEQ_NUM)  --人行
              WHEN TRIM(ISBS.BIZ_SEQ_NO) IS NOT NULL             THEN TRIM(ISBS.BIZ_SEQ_NO)              --国结
              WHEN TRIM(BDMS.SERINO) IS NOT NULL                 THEN TRIM(BDMS.SERINO)                  --新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TRAN_NUM)                --资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.FLOW_INNER_SN)           --同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.SEQ)                 --资金本币
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.SEQ)                 --资金外币
              ELSE '0'
         END                                                                      AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD)         AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                   THEN A.TRAN_ORG_ID||C.SUBJ_ID||A.TRAN_CURR_CD --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                  THEN A.TRAN_ORG_ID||C1.SUBJ_ID||A.TRAN_CURR_CD --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                 THEN TRIM(NCBS.OTH_REAL_BASE_ACCT_NO)         --11、核心的交易对手登记簿
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)              --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)        --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)                   --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL          THEN TRIM(B.RECVER_ACCT_NUM)                  --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(ISBS.TX_CNTPTY_ACCT_NUM)            --4、外围交易数据--国结
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                 THEN TRIM(BDMS.CUST_ACCT)                     --5、外围交易数据--新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TX_CNTPTY_ACCT_NUM)            --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.PARTY_ACCT_CODE)               --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.TX_CNTPTY_ACCT_NUM)        --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.TX_CNTPTY_ACCT_NUM)        --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL              THEN TRIM(LOAN.DUBIL_NUM)                     --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                   THEN TRIM(C.SUBJ_NAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                  THEN TRIM(C1.SUBJ_NAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                 THEN TRIM(NCBS.OTH_REAL_TRAN_NAME)                --11、核心的交易对手登记簿
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)                --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              --因有对方户名放到真实户名的情况，特此判断
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL AND TRIM(A.CNTPTY_ACCT_NAME) IS NULL AND TRIM(A.REAL_CNTPTY_ACCT_NAME) IS NOT NULL
                AND COALESCE(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.REAL_CNTPTY_FIN_INST_CD),TRIM(A.REAL_CNTPTY_FIN_INST_NAME)) IS NULL
              THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)                     --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME) --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL          THEN TRIM(B.RECVER_NAME)                          --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(ISBS.TX_CNTPTY_NAME)                    --4、外围交易数据--国结
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                 THEN TRIM(BDMS.CUST_NAME)                         --5、外围交易数据--新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL     THEN TRIM(FAMS.TX_CNTPTY_NAME)                    --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL         THEN TRIM(IBMS.PARTY_ACCT_NAME)                   --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_TBS.TX_CNTPTY_NAME)                --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL THEN TRIM(CTMS_FBS.TX_CNTPTY_NAME)                --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL              THEN TRIM(LOAN.ACCT_NAME)                         --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL                        THEN TRIM(D.FIN_INST_CODE)                   --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                       THEN TRIM(D.FIN_INST_CODE)                   --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                      THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(NCBS.CONTRA_BANK_CODE)) --11、核心的交易对手登记簿
              --因存在国结没将行号送到核心的情况，特此判断
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL AND TRIM(ISBS.TX_CNTPTY_ACCT_NUM) IS NOT NULL
                   AND TRIM(ISBS.TX_CNTPTY_ACCT_NUM) = TRIM(A.REAL_CNTPTY_ACCT_ID)
              THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_CD)                   --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)         --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL                 THEN TRIM(A.CNTPTY_OPEN_BANK_ID)             --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL               THEN TRIM(B.RECVER_OPEN_BANK_NO)             --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL          THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_CD)      --4、外围交易数据--国结
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                      THEN TRIM(BDMS.CUST_BANK_NO)                 --5、外围交易数据--新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL          THEN TRIM(FAMS.CNTPTY_FIN_INST_BRAC_CD)      --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL              THEN TRIM(IBMS.PARTY_BANK_CODE)              --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN TRIM(CTMS_TBS.CNTPTY_FIN_INST_BRAC_CD)  --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL      THEN TRIM(CTMS_FBS.CNTPTY_FIN_INST_BRAC_CD)  --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL                   THEN TRIM(LOAN.FIN_INST_CODE)                --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE /*WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                         THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                        THEN TRIM(B1.ORG_NAME)                         --11、核心的交易对手登记簿
              WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.ORG_NAME)                          --2、手续费等业务按科目拼接对手方信息*/
              --MOD BY LIP 20230804 机构名称优先取中台的机构名
              WHEN TRIM(C.SUBJ_ID) IS NOT NULL                          THEN TRIM(D.BKNAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL                         THEN TRIM(D.BKNAME)                            --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                        THEN TRIM(B1.BKNAME)                           --11、核心的交易对手登记簿
              --ADD BY LIP 20230804 机构名为空时，关联中台的机构名
              WHEN TRIM(NCBS.SEQ_NO) IS NOT NULL                        THEN TRIM(B2.BKNAME)                           --11、核心的交易对手登记簿
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL              THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)         --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL                   THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)             --1、取核心本身数据，优先取真实交易对手，其次取交易对手
              WHEN TRIM(B.TRAN_FLOW_NUM_BB) IS NOT NULL                 THEN TRIM(B.RECVER_OPEN_BANK_NAME)             --3、缴税、社保费、社保从人行通道交易流水表取
              WHEN TRIM(ISBS.CORE_TRAN_FLOW_NUM) IS NOT NULL            THEN TRIM(ISBS.CNTPTY_FIN_INST_BRAC_NAME)      --4、外围交易数据--国结
              WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL                        THEN TRIM(BDMS.CUST_BANK_NAME)                 --5、外围交易数据--新票据
              WHEN TRIM(FAMS.CORE_TRAN_FLOW_NUM) IS NOT NULL            THEN TRIM(FAMS.CNTPTY_FIN_INST_BRAC_NAME)      --6、外围交易数据--资管
              WHEN TRIM(IBMS.GLOBAL_FLOW_NO) IS NOT NULL                THEN TRIM(IBMS.PARTY_BANK_NAME)                --7、外围交易数据--同业
              WHEN TRIM(CTMS_TBS.CORE_TRAN_FLOW_NUM) IS NOT NULL        THEN TRIM(CTMS_TBS.CNTPTY_FIN_INST_BRAC_NAME)  --8、外围交易数据--资金本币系统
              WHEN TRIM(CTMS_FBS.CORE_TRAN_FLOW_NUM) IS NOT NULL        THEN TRIM(CTMS_FBS.CNTPTY_FIN_INST_BRAC_NAME)  --9、外围交易数据--资金外币系统
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL                     THEN TRIM(LOAN.ORG_NAME)                       --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL               THEN C.SUBJ_ID       --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_ID) IS NOT NULL              THEN C1.SUBJ_ID       --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL          THEN TRIM(LOAN.SUBJ_ID)                       --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_SUBJ_ID               --对方科目编号
        ,CASE WHEN TRIM(C.SUBJ_NAME) IS NOT NULL             THEN C.SUBJ_NAME     --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(C1.SUBJ_NAME) IS NOT NULL            THEN C1.SUBJ_NAME     --2、手续费等业务按科目拼接对手方信息
              WHEN TRIM(LOAN.DUBIL_NUM) IS NOT NULL          THEN TRIM(LOAN.SUBJ_NAME)                       --10、从核心贷款流水获取交易对手信息
         END                                                                      AS OPP_SUBJ_NM               --对方科目名称
        /*,CASE WHEN TRIM(C.SUBJ_ID) IS NOT NULL THEN '按科目拼接内部户'
              WHEN TRIM(A.MEMO_CD_DESCB) IN ('缴税','社保费','社保') THEN '社保和缴税'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GCTM' AND TRAN_CURR_CD = 'CNY' THEN '资金系统本币'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GCTM' AND TRAN_CURR_CD <> 'CNY' THEN '资金系统外币'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GISB' THEN '国结系统'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GBDM' THEN '票据系统'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GFAM' THEN '资管系统'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GIBM' THEN '同业系统'
              WHEN SUBSTR(A.OVA_FLOW_NUM,1,4) = 'GIER' THEN '智能报销系统'
              ELSE '核心系统'
         END                                                                      AS SRC_FLG                   --源系统标志*/
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
         END                                                                      AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN (
         SELECT CASE WHEN SUBSTR(HOST_FLOW_NUM,1,5) = 'SNCBS' THEN HOST_FLOW_NUM
                     ELSE TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM
                END  AS TRAN_FLOW_NUM_BB
               ,ROW_NUMBER() OVER(PARTITION BY TO_CHAR(TRAN_DT,'YYYYMMDD')||HOST_FLOW_NUM ORDER BY JOB_CD DESC) AS RN
               ,BB.*
         FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW BB --人行通道交易流水表
         WHERE TRIM(HOST_FLOW_NUM) IS NOT NULL
           AND ETL_DT = V_DATE) B
      ON B.TRAN_FLOW_NUM_BB = A.TRAN_FLOW_NUM
     AND TRIM(A.MEMO_CD_DESCB) IN ('缴税','社保费','社保')
     AND B.TRAN_DT = A.TRAN_DT
     AND B.RN = 1
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C --科目信息
      ON C.SUBJ_ID = TRIM(A.CNTPTY_ACCT_ID)
     AND C.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO C1 --科目信息
      ON C1.SUBJ_ID = TRIM(A.REAL_CNTPTY_ACCT_ID)
     AND C1.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = A.TRAN_ORG_ID
    LEFT JOIN RRP_MDL.O_IOL_ISBS_OPPNET ISBS --国结系统对手方信息表
      ON ISBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM    --全局流水号
     AND ISBS.GLDATE = TO_CHAR(A.TRAN_DT,'YYYYMMDD') --交易时间
     AND ISBS.PTY_ACCT_NUM = A.CUST_ACCT_ID   --交易账号
     AND ISBS.TRAN_TYPE = A.DEBIT_CRDT_DIR_CD --交易方向
     AND ISBS.BIZ_CCY = A.TRAN_CURR_CD        --交易币种
     AND ISBS.BIZ_AMT = A.TRAN_AMT            --交易金额
    LEFT JOIN (SELECT PJ.*,ROW_NUMBER() OVER(PARTITION BY PJ.BSNSSQ ORDER BY PJ.SERINO DESC) AS RN
                 FROM RRP_MDL.O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO PJ --票据系统交易对手信息视图
               ) BDMS
      ON BDMS.BSNSSQ = A.OVA_FLOW_NUM    --全局流水号
     AND BDMS.RN = 1
    LEFT JOIN (SELECT ZG.*,ROW_NUMBER() OVER(PARTITION BY ZG.CORE_TRAN_FLOW_NUM ORDER BY ZG.TRAN_NUM DESC) AS RN
                 FROM RRP_MDL.O_IOL_FAMS_FAM_TX_CNTPTY_INFO ZG --资管系统交易对手信息
               ) FAMS
      ON FAMS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM    --全局流水号
     AND FAMS.RN = 1
    LEFT JOIN (SELECT TY.*,
                      CASE WHEN TY.DEBIT_CREDIT_FLAG = '1' THEN 'D'  --借
                           WHEN TY.DEBIT_CREDIT_FLAG = '2' THEN 'C'  --贷
                           ELSE TY.DEBIT_CREDIT_FLAG
                       END AS DEBIT_CRDT_DIR_CD,
                      ROW_NUMBER() OVER(PARTITION BY TY.GLOBAL_FLOW_NO,TY.ENTRY_DATE,TY.CURRENCY,TY.VALUE,TY.DEBIT_CREDIT_FLAG ORDER BY TY.FLOW_INNER_SN DESC) AS RN
                 FROM RRP_MDL.O_IOL_IBMS_TTRD_HX_COUNTERPARTY_REGISTRY TY) IBMS --同业系统华兴交易对手登记簿
      ON IBMS.GLOBAL_FLOW_NO = A.OVA_FLOW_NUM    --全局流水号
     AND IBMS.ENTRY_DATE = TO_CHAR(A.TRAN_DT,'YYYY-MM-DD') --交易时间
     AND IBMS.CURRENCY = A.TRAN_CURR_CD        --交易币种
     AND IBMS.VALUE = A.TRAN_AMT            --交易金额
     AND IBMS.DEBIT_CRDT_DIR_CD = A.DEBIT_CRDT_DIR_CD --交易方向
     AND IBMS.RN = 1
    LEFT JOIN (SELECT ZJBB.*,ROW_NUMBER() OVER(PARTITION BY ZJBB.CORE_TRAN_FLOW_NUM ORDER BY ZJBB.SEQ DESC) AS RN
                 FROM RRP_MDL.O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO ZJBB) CTMS_TBS --资金系统交易对手_本币
      ON CTMS_TBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM    --全局流水号
     AND CTMS_TBS.RN = 1
    LEFT JOIN (SELECT ZJWB.*
                      ,ROW_NUMBER() OVER(PARTITION BY ZJWB.CORE_TRAN_FLOW_NUM ORDER BY ZJWB.SEQ DESC) AS RN
                  FROM RRP_MDL.O_IOL_CTMS_VI_FBS_ACCOUNT_CPTYS_INFO ZJWB --资金系统交易对手_外币
               ) CTMS_FBS
      ON CTMS_FBS.CORE_TRAN_FLOW_NUM = A.OVA_FLOW_NUM    --全局流水号
     AND CTMS_FBS.RN = 1
    /*LEFT JOIN IERS  --智能报销系统  待接入*/
    LEFT JOIN ( --贷款
          SELECT T1.TRAN_REF_NO
                ,T1.OVA_FLOW_NUM
                ,T1.ACCT_ID
                ,NVL(TRIM(T1.ACCT_NAME),T2.ACCT_NAME) AS ACCT_NAME
                ,NVL(TRIM(T1.OPEN_ACCT_ORG_ID),T2.OPEN_ACCT_ORG_ID) AS OPEN_ACCT_ORG_ID
                ,T2.DUBIL_NUM
                ,T2.SUBJ_ID
                ,T4.SUBJ_NAME
                ,T3.FIN_INST_CODE
                --,T3.ORG_NAME
                ,T3.BKNAME AS ORG_NAME--MOD BY LIP 20230804
                ,ROW_NUMBER() OVER(PARTITION BY T1.TRAN_REF_NO,T1.OVA_FLOW_NUM ORDER BY T1.TRAN_AMT DESC) AS RN
          FROM RRP_MDL.O_IML_EVT_LOAN_FIN_TRAN_FLOW T1
          LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO T2
            ON T2.ACCT_ID = T1.ACCT_ID
           AND T2.ETL_DT = V_DATE
          LEFT JOIN RRP_MDL.ORG_CONFIG T3
            ON T3.ORG_ID = NVL(TRIM(T1.OPEN_ACCT_ORG_ID),T2.OPEN_ACCT_ORG_ID)
          LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO T4 --科目信息
            ON T4.SUBJ_ID = T2.SUBJ_ID
           AND T4.ETL_DT = V_DATE
         WHERE T1.ETL_DT = V_DATE) LOAN
      ON LOAN.TRAN_REF_NO = A.TRAN_FLOW_NUM
     AND LOAN.OVA_FLOW_NUM = A.OVA_FLOW_NUM
     AND LOAN.RN = 1
    LEFT JOIN (SELECT SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO,OTH_REAL_BASE_ACCT_NO,OTH_REAL_TRAN_NAME,CONTRA_BANK_CODE,TRAN_AMT,
                      OTH_REAL_ACCT_SEQ_NO,REGISTER_SEQ_NO,TRAN_TIMESTAMP,COMPANY,SOURCE_MODULE,START_DT,END_DT,ID_MARK,ETL_TIMESTAMP,
                      ROW_NUMBER() OVER(PARTITION BY SEQ_NO,REFERENCE,CHANNEL_SEQ_NO,SUB_SEQ_NO ORDER BY TRAN_AMT DESC) AS RN
                 FROM RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG) NCBS --核心交易对手登记簿 ADD BY TANGAN AT 20230209
      ON NCBS.SEQ_NO = A.ACCT_BILL_FLOW_NUM
     AND NCBS.REFERENCE = A.TRAN_FLOW_NUM
     AND NCBS.CHANNEL_SEQ_NO = A.OVA_FLOW_NUM
     AND NCBS.SUB_SEQ_NO = A.TRAN_FLG_NUM
     AND NCBS.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG B1  --ADD BY TANGAN AT 20230209
      ON B1.ORG_ID = TRIM(NCBS.CONTRA_BANK_CODE)
    --ADD BY LIP 20230804 行号不为空，行名为空的数据，用中台机构表的信息补全
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO B2
      ON B2.BKCD = TRIM(NCBS.CONTRA_BANK_CODE)
     AND B2.ID_MARK <> 'D'
     AND B2.START_DT <= V_DATE
     AND B2.END_DT > V_DATE
   WHERE --A.MEMO_CD <> 'IN' --IN-存息
         A.MEMO_CD NOT IN ('IN','DQI','DQ') --存息 --票据解付
     --AND A.CASH_TRANS_FLG = '0' --转
     AND NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.TRAN_DESCB NOT IN ('转账收费'/*,'久悬户激活'*/)
     AND A.TRAN_DESCB NOT LIKE '%费用收入%'
     AND A.TRAN_DESCB NOT LIKE '%费用支出%'
     --MOD BY LIP 20230804 经与核心确认，FEE开头的交易类型均为费用
     AND A.TRAN_KIND_CD NOT LIKE 'FEE%'
     AND A.TRAN_KIND_CD NOT IN ('CK01','DK01','2204','FX64') --现金长短款的和存息类似,久悬户激活，在核算中台中取数,结售汇收益借方
     AND A.TRAN_KIND_CD NOT IN ('5001','FX72','FX67','2201') --MOD BY LIP 20231208 5001贷方利息调整入账(单户结息) FX72 市场平盘收益借方 FX67 市场平盘损失贷方
     AND A.TRAN_KIND_CD NOT IN ('Z099','Z021') --票据业务资金清算往来款-贷记,银承兑付专户-借记
     AND A.TRAN_DT = V_DATE
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '存息对手信息1';
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
    )
    WITH TGLS_GLA_VCHR_H AS (
    SELECT /*+MATERIALIZE*/SOURSQ, REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ, BSNSSQ, AMNTCD, TRANAM, ITEMCD, ITEMNA
          ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
          ,ITEMNA AS OPP_ACC_NM
          /*,ACCTBR AS OPP_PBC_NO
          ,NULL     AS OPP_BANK_NM*/
          --MOD BY LIP 20230804 对内部机构进行转换
          ,TA.FIN_INST_CODE AS OPP_PBC_NO
          ,TA.BKNAME        AS OPP_BANK_NM
      FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
      --ADD BY LIP 20230804 对机构进行转换
      LEFT JOIN RRP_MDL.ORG_CONFIG TA
        ON TA.ORG_ID = T.ACCTBR
     WHERE STACID = 1
       AND SYSTID = 'NCBS'
       AND AMNTCD = 'D' --借方
       AND ASSIS1 <> '999999999999'
       AND TRANDT = V_P_DATE)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                          AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                      AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                                 AS OPP_SUBJ_NM               --对方科目名称
        --,'存息'                                                                   AS SRC_FLG                   --源系统标志
        /*,CASE WHEN A.MEMO_CD = 'IN' THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
          END                                                                     AS SRC_FLG                   --源系统标志*/
        ,CASE WHEN A.MEMO_CD IN ('IN','DQI') THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('5001') THEN '5001贷方利息调整入账' --ADD BY LIP 20231208
              WHEN A.TRAN_KIND_CD IN ('2201') THEN '2201结算户转久悬户' --ADD BY LIP 20231220
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
              WHEN A.TRAN_KIND_CD IN ('Z099') THEN '票据业务资金清算往来款-贷记' --ADD BY LIP 20240119
              WHEN A.TRAN_KIND_CD IN ('Z021') THEN '银承兑付专户-借记' --ADD BY LIP 20240119
          END                                                                     AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON A.OVA_FLOW_NUM = B.BSNSSQ
     AND A.ACCT_BILL_FLOW_NUM = B.SRVCSQ
     AND A.TRAN_FLOW_NUM = B.SOURSQ
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     --AND A.MEMO_CD = 'IN' --IN-存息
     AND (/*A.MEMO_CD = 'IN' --IN-存息*/
          --MOD BY LIP 20231107 增加存息的类型
          A.MEMO_CD IN ('IN','DQI')
          --OR A.TRAN_KIND_CD IN ('CK01','DK01')) --长款处理交易类型CK01， 短款处理交易类型DK01
          --MOD BY LIP 20231208 2201 结算户转久悬户
          OR A.TRAN_KIND_CD IN ('CK01','DK01','5001','2201')) --长款处理交易类型CK01， 短款处理交易类型DK01 5001贷方利息调整入账(单户结息)
     --AND TRIM(A.CNTPTY_ACCT_ID) IS NULL
     --AND TRIM(A.REAL_CNTPTY_ACCT_ID) IS NULL
     --AND A.CASH_TRANS_FLG = '0' --转
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '存息对手信息2';
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
    )
    WITH TGLS_GLA_VCHR_H AS (
    SELECT /*+MATERIALIZE*/SOURSQ, REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ, BSNSSQ, AMNTCD, TRANAM, ITEMCD, ITEMNA
          ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
          ,ITEMNA AS OPP_ACC_NM
          ,TA.FIN_INST_CODE AS OPP_PBC_NO
          ,TA.BKNAME        AS OPP_BANK_NM
      FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
      LEFT JOIN RRP_MDL.ORG_CONFIG TA
        ON TA.ORG_ID = T.ACCTBR
     WHERE STACID = 1
       AND SYSTID = 'NCBS'
       AND AMNTCD = 'C' --贷方
       AND ASSIS1 <> '999999999999'
       AND TRANDT = V_P_DATE)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                          AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                      AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                                 AS OPP_SUBJ_NM               --对方科目名称
        --,'存息'                                                                   AS SRC_FLG                   --源系统标志
        /*,CASE WHEN A.MEMO_CD = 'IN' THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
          END                                                                     AS SRC_FLG                   --源系统标志*/
        ,CASE WHEN A.MEMO_CD IN ('IN','DQI') THEN '存息'
              WHEN A.TRAN_KIND_CD IN ('5001') THEN '5001贷方利息调整入账' --ADD BY LIP 20231208
              WHEN A.TRAN_KIND_CD IN ('2201') THEN '2201结算户转久悬户' --ADD BY LIP 20231220
              WHEN A.TRAN_KIND_CD IN ('CK01','DK01') THEN '现金长短款' --ADD BY LIP 20230815
              WHEN A.TRAN_KIND_CD IN ('Z099') THEN '票据业务资金清算往来款-贷记' --ADD BY LIP 20240119
              WHEN A.TRAN_KIND_CD IN ('Z021') THEN '银承兑付专户-借记' --ADD BY LIP 20240119
          END                                                                     AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON A.OVA_FLOW_NUM = B.BSNSSQ
     AND A.ACCT_BILL_FLOW_NUM = B.SRVCSQ
     AND A.TRAN_FLOW_NUM = B.SOURSQ
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND (--A.MEMO_CD = 'IN' --IN-存息
          --MOD BY LIP 20231107 增加存息的类型
          A.MEMO_CD IN ('IN','DQI')
          --OR A.TRAN_KIND_CD IN ('CK01','DK01')) --长款处理交易类型CK01， 短款处理交易类型DK01
          --MOD BY LIP 20231208 2201 结算户转久悬户
          OR A.TRAN_KIND_CD IN ('CK01','DK01','5001','2201')) --长款处理交易类型CK01， 短款处理交易类型DK01 5001贷方利息调整入账(单户结息)
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '转账收费借方对手信息';
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
    )
    WITH TGLS_GLA_VCHR_H AS (
    SELECT /*+MATERIALIZE*/SOURSQ, REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ, BSNSSQ, AMNTCD, TRANAM, ITEMCD, ITEMNA
          ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
          ,ITEMNA AS OPP_ACC_NM
          /*,ACCTBR AS OPP_PBC_NO
          ,NULL   AS OPP_BANK_NM*/
          --MOD BY LIP 20230804 对内部机构进行转换
          ,TA.FIN_INST_CODE AS OPP_PBC_NO
          ,TA.BKNAME        AS OPP_BANK_NM
          ,ROW_NUMBER() OVER(PARTITION BY SOURSQ ORDER BY TRANAM DESC) AS RN
      FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
      --ADD BY LIP 20230804 对机构进行转换
      LEFT JOIN RRP_MDL.ORG_CONFIG TA
        ON TA.ORG_ID = T.ACCTBR
     WHERE STACID = 1
       AND SYSTID = 'NCBS'
       AND AMNTCD = 'C' --贷方
       AND (ASSIS1 LIKE '5%'  --5开头的产品为收费产品
           OR ASSIS1 LIKE '9990501%' --提前还款违约金
           OR ASSIS1 LIKE '963%' --票据清算
           OR T.ITEMCD LIKE '6%') --损益
       AND TRANDT = V_P_DATE)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                          AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                      AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                                 AS OPP_SUBJ_NM               --对方科目名称
        ,CASE WHEN A.TRAN_KIND_CD LIKE 'FEE%' THEN '转账收费'
              WHEN A.TRAN_KIND_CD IN ('FX64') THEN '结售汇收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX72') THEN '市场平盘收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX67') THEN '市场平盘损失贷方'
              WHEN A.MEMO_CD IN ('DQ') THEN '承兑解付'
          END                                                                     AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.RN = 1
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     --AND A.CASH_TRANS_FLG = '0' --转
     AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
     --AND (A.TRAN_DESCB = '转账收费' OR A.TRAN_DESCB LIKE '%费用收入%')
     --MOD BY LIP 20230804 经与核心确认，只要交易类型是FEE开头的，都是收费
     --MOD BY LIP 20230831 增加结售汇收益借方的数据
     AND (A.TRAN_KIND_CD LIKE 'FEE%'
          --OR A.TRAN_KIND_CD IN ('FX64')
          --MOD BY LIP 20231208
          OR A.TRAN_KIND_CD IN ('FX64','FX72','FX67','Z099','Z021') --FX72 市场平盘收益借方 FX67 市场平盘损失贷方
          OR A.MEMO_CD IN ('DQ')) --MOD BY 20231110 增加承兑解付的取数
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '转账收费贷方对手信息';
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
    )
    WITH TGLS_GLA_VCHR_H AS (
    SELECT /*+MATERIALIZE*/SOURSQ, REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ, BSNSSQ, AMNTCD, TRANAM, ITEMCD, ITEMNA
          ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
          ,ITEMNA AS OPP_ACC_NM
          /*,ACCTBR AS OPP_PBC_NO
          ,NULL   AS OPP_BANK_NM*/
          --MOD BY LIP 20230804 对内部机构进行转换
          ,TA.FIN_INST_CODE AS OPP_PBC_NO
          ,TA.BKNAME        AS OPP_BANK_NM
          ,ROW_NUMBER() OVER(PARTITION BY SOURSQ ORDER BY TRANAM DESC) AS RN
      FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
      --ADD BY LIP 20230804 对机构进行转换
      LEFT JOIN RRP_MDL.ORG_CONFIG TA
        ON TA.ORG_ID = T.ACCTBR
     WHERE STACID = 1
       AND SYSTID = 'NCBS'
       AND AMNTCD = 'D' --贷方
       AND (ASSIS1 LIKE '5%'  --5开头的产品为收费产品
           OR ASSIS1 LIKE '9990501%' --提前还款违约金
           OR ASSIS1 LIKE '963%' --票据清算
           OR T.ITEMCD LIKE '6%') --损益
       AND TRANDT = V_P_DATE)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                          AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                      AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,B.ITEMCD                                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,B.ITEMNA                                                                 AS OPP_SUBJ_NM               --对方科目名称
        ,CASE WHEN A.TRAN_KIND_CD LIKE 'FEE%' THEN '转账收费'
              WHEN A.TRAN_KIND_CD IN ('FX64') THEN '结售汇收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX72') THEN '市场平盘收益借方'
              WHEN A.TRAN_KIND_CD IN ('FX67') THEN '市场平盘损失贷方'
              WHEN A.MEMO_CD IN ('DQ') THEN '承兑解付'
          END                                                                     AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.SOURSQ = A.TRAN_FLOW_NUM
     AND B.RN = 1
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND (A.TRAN_KIND_CD LIKE 'FEE%'
          --OR A.TRAN_KIND_CD IN ('FX64')
          --MOD BY LIP 20231208
          OR A.TRAN_KIND_CD IN ('FX64','FX72','FX67','Z099','Z021') --FX72 市场平盘收益借方 FX67 市场平盘损失贷方
          OR A.MEMO_CD IN ('DQ')) --MOD BY 20231110 增加承兑解付的取数
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '久悬户激活对手信息';
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
    )
    WITH TGLS_GLA_VCHR_H AS (
    SELECT /*+MATERIALIZE*/SOURSQ, REGEXP_SUBSTR(SRVCSQ,'[0-9]+') AS SRVCSQ, BSNSSQ, AMNTCD, TRANAM, ITEMCD, ITEMNA
          ,ACCTBR || ITEMCD || CRCYCD AS OPP_ACC
          ,ITEMNA AS OPP_ACC_NM
          /*,ACCTBR AS OPP_PBC_NO
          ,NULL   AS OPP_BANK_NM*/
          --MOD BY LIP 20230804 对内部机构进行转换
          ,TA.FIN_INST_CODE AS OPP_PBC_NO
          ,TA.BKNAME        AS OPP_BANK_NM
          ,ROW_NUMBER() OVER(PARTITION BY SOURSQ,SRVCSQ,BSNSSQ ORDER BY ASSIS1) AS RN
      FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H T
      --ADD BY LIP 20230804 对机构进行转换
      LEFT JOIN RRP_MDL.ORG_CONFIG TA
        ON TA.ORG_ID = T.ACCTBR
     WHERE STACID = 1
       AND SYSTID = 'NCBS'
       AND AMNTCD = 'D' --借方
       --AND ASSIS1 <> '999999999999'
       AND TRANDT = V_P_DATE)
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD')                                             AS DATA_DT                   --数据日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                            AS TRA_DT                    --交易日期
        ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM     AS TRA_SEQ_NO                --交易流水号（唯一，用于关联）
        ,A.TRAN_FLOW_NUM                                                          AS TRAN_FLOW_NUM             --核心交易流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS ACCT_BILL_FLOW_NUM        --核心账单流水号
        ,A.OVA_FLOW_NUM                                                           AS CORE_TRAN_FLOW_NUM        --全局流水号
        ,A.TRAN_FLOW_NUM                                                          AS SRC_SEQ_NUM               --源系统流水号
        ,A.ACCT_BILL_FLOW_NUM                                                     AS SRC_TRA_SEQ_NO            --源系统交易序号
        ,A.DEBIT_CRDT_DIR_CD                                                      AS TRA_DR_CR_FLG             --交易借贷标志
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_ID)
              --MOD BY LIP 20231221 根据陈旭颖给的规则，兜底规则：取不到就组固定值，借方科目是 22410201久悬未取款
              ELSE TRIM(A.TRAN_ORG_ID)||'22410201'||TRIM(A.TRAN_CURR_CD)
         END                                                                      AS OPP_ACC                   --对方账号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_ACC_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_ACCT_NAME)
              ELSE '久悬未取款'
         END                                                                      AS OPP_ACC_NM                --对方户名
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_PBC_NO)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_CD)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_ID)
              ELSE C.FIN_INST_CODE
         END                                                                      AS OPP_PBC_NO                --对方行号
        ,CASE WHEN TRIM(B.OPP_ACC) IS NOT NULL                   THEN TRIM(B.OPP_BANK_NM)
              WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL       THEN TRIM(A.REAL_CNTPTY_FIN_INST_NAME)
              WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL            THEN TRIM(A.CNTPTY_OPEN_BANK_NAME)
              ELSE C.BKNAME
         END                                                                      AS OPP_BANK_NM               --对方行名
        ,NVL(B.ITEMCD,'22410201')                                                 AS OPP_SUBJ_ID               --对方科目编号
        ,NVL(B.ITEMNA,'久悬未取款')                                               AS OPP_SUBJ_NM               --对方科目名称
        --,'久悬户激活和费用支出'                                                   AS SRC_FLG                   --源系统标志
        ,'久悬户激活'                                                             AS SRC_FLG                   --源系统标志
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    LEFT JOIN TGLS_GLA_VCHR_H B
      ON A.OVA_FLOW_NUM = B.BSNSSQ
     AND A.ACCT_BILL_FLOW_NUM = B.SRVCSQ
     AND A.TRAN_FLOW_NUM = B.SOURSQ
     AND B.RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = TRIM(A.TRAN_ORG_ID)
   WHERE NVL(TRIM(A.CASH_TRANS_FLG),0) <> '1' --现
     --AND A.CASH_TRANS_FLG = '0' --转
     AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     --AND (A.TRAN_DESCB = '久悬户激活' OR A.TRAN_DESCB  LIKE '%费用支出%')
     --MOD BY LIP 20230815 改成用代码框数
     AND (A.TRAN_KIND_CD = '2204' /*OR A.TRAN_DESCB LIKE '%费用支出%'*/)  --费用支出和上面的FEE有冲突，注释该部分
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询是否有数据重复';
  V_STARTTIME := SYSDATE;

  WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,COUNT(1)
    FROM RRP_MDL.M_MID_TRA_CNTPTY_INFO T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
     RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  --MOD BY LIP 20231010 月批调账后重跑一次后，增加月批的标志
    WITH TMP2 AS (
    SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE ETL_DATE = V_P_DATE AND PROC_NAME = V_PROC_NAME)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE (ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
 WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MID_TRA_CNTPTY_INFO_TEST;
/

