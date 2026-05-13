CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_DEP_ACCT_TRAN_DTL(I_P_DATE IN INTEGER,
                       O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_DEP_ACCT_TRAN_DTL
  *  功能描述：存款账户交易明细表
  *  创建日期：2023/01/06
  *  开发人员：HDY
  *  来源表：  RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL  存款账户交易明细表

  *  目标表：  M_MRPT_DEP_ACCT_TRAN_DTL
  *
  *  配置表：
  *  修改情况：1  2023/01/06  HDY   首次创建
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数
  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(100) := 'ETL_M_MRPT_DEP_ACCT_TRAN_DTL' ;-- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  V_TAB_NAME    VARCHAR2(100);  --表名称
  D_STARTTIME   DATE;
  D_ENDTIME     DATE;

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_MRPT_DEP_ACCT_TRAN_DTL'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_DEP_ACCT_TRAN_DTL T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
 -- DELETE FROM RPT_MRPT_RESULT T WHERE T.DATA_DATE = V_P_DATE AND T.RPT_NO = V_RPT_NO;--手工报表指标结果表的重跑处理
  /*EXECUTE IMMEDIATE ('ALTER TABLE '||'M_CRD_INFO'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/

  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;
  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  V_STEP_DESC := '--M层数据落地 贷款金融交易流水--';
  D_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_MRPT_DEP_ACCT_TRAN_DTL NOLOGGING
             (DATA_DT                                 --01 数据日期
             ,ETL_DT                                  --02 ETL处理日期
             ,LP_ID                                   --03 法人编号
             ,TRAN_FLOW_NUM                           --04 交易流水号
             ,TRAN_DT                                 --05 交易日期
             ,TRAN_TIMESTAMP                          --06 交易时间戳
             ,ACCT_BILL_FLOW_NUM                      --07 账单流水号
             ,OVA_FLOW_NUM                            --08 全局流水号
             ,TRAN_FLG_NUM                            --09 交易标识号
             ,ACCT_ORG_ID                             --10 账务机构
             ,DEP_SUB_ACCT_ID                         --11 存款子户编号
             ,CUST_ACCT_ID                            --12 账户编号
             ,SUB_ACCT_ID                             --13 子户编号
             ,OLD_ACCT_ID                             --14 旧账户编号
             ,OLD_SUB_ACCT_ID                         --15 旧子户编号
             ,CUST_ID                                 --16 客户号
             ,CUST_NAME                               --17 客户名称
             ,CUST_TYPE_CD                            --18 客户类型代码
             ,TRAN_KIND_CD                            --19 交易种类代码
             ,ELEC_TRAN_KIND_CD                       --20 电子交易种类代码
             ,TRAN_STATUS_CD                          --21 交易状态代码
             ,DEBIT_CRDT_DIR_CD                       --22 借贷方向代码
             ,CASH_PROJ_CD                            --23 现金项目代码
             ,TRAN_VOUCH_ID                           --24 交易凭证编号
             ,VOUCH_KIND_CD                           --25 凭证种类代码
             ,MEMO_CD                                 --26 摘要代码
             ,MEMO_CD_DESCB                           --27 摘要代码描述
             ,CHN_CD                                  --28 渠道代码
             ,CNTPTY_ACCT_ID                          --29 对手方账户编号
             ,CNTPTY_SUB_ACCT_ID                      --30 交易对手子账户编号
             ,CNTPTY_ACCT_NAME                        --31 交易对手账户名称
             ,CNTPTY_OPEN_BANK_ID                     --32 交易对手账户开户行编号
             ,CNTPTY_ACCT_OPEN_BANK_CD                --33 交易对手账户开户行代码
             ,CNTPTY_OPEN_BANK_NAME                   --34 交易对手开户行名称
             ,REAL_CNTPTY_ACCT_ID                     --35 真实交易对手账户编号
             ,REAL_CNTPTY_ACCT_NAME                   --36 真实交易对手账户名称
             ,REAL_CNTPTY_FIN_INST_CD                 --37 真实交易对手金融机构代码
             ,REAL_CNTPTY_FIN_INST_NAME               --38 真实交易对手金融机构名称
             ,TRAN_ORG_ID                             --39 交易机构编号
             ,TRAN_CURR_CD                            --40 交易币种代码
             ,TRAN_AMT                                --41 交易金额
             ,TRAN_BAL                                --42 交易余额
             ,TRAN_TELLER_ID                          --43 交易柜员编号
             ,CHECK_TELLER_ID                         --44 复核柜员编号
             ,AUTH_TELLER_ID                          --45 授权柜员编号
             ,ENTRY_TELLER_ID                         --46 记帐柜员编号
             ,ERASE_ACCT_FLG                          --47 抹账标志
             ,REVS_FLG                                --48 冲正标志
             ,CASH_TRANS_FLG                          --49 现转标志
             ,UNEXP_DRAW_FLG                          --50 提前支取标志
             ,BEPS_UNPASEW_FLG                        --51 小额免密标志
             ,BAL_CHK_FLG                             --52 勾对标志
             ,TERMN_ID                                --53 终端编号
             ,TRAN_CD                                 --54 交易代码
             ,TRAN_DESCB                              --55 交易描述
             ,RECE_TYPE_CD                            --56 回单类型代码
             ,TRAN_NAME                               --57 交易名称
             ,PRPERY_SYS_CODE                         --58 外围系统编码
             ,RECE_ID                                 --59 回单编号
             ,RECE_DESCB_INFO                         --60 回单描述信息
             ,AGENT_CUST_ID                           --61 代理人客户编号
             ,AGENT_NAME                              --62 代理人名称
             ,AGENT_CERT_TYPE_CD                      --63 代理人证件类型代码
             ,AGENT_CERT_NO                           --64 代办人证件号码
             ,AGENT_GENDER_CD                         --65 代办人性别代码
             ,AGENT_NATION_CD                         --66 代办人国籍代码
             ,AGENT_CERT_START_DT                     --67 代办人证件开始日期
             ,AGENT_CERT_EXP_DT                       --68 交易代办人证件到期日期
             ,AGENT_PHONE                             --69 代理人联系电话
             ,AGENT_LICEN_ISSUE_AUTHO_SITE            --70 代理人发证机关所在地
             ,AGENT_RS                                --71 代理原因
             ,AGENT_TYPE_CD                           --72 代理类型代码
             ,OPERR_CERT_TYPE_CD                      --73 经办人证件类型代码
             ,OPERR_CERT_NO                           --74 经办人证件号码
             ,OPERR_NAME                              --75 经办人名称
             ,CLIENT_IP_ADDR                          --76 客户端ip地址
             ,CUST_TERMN_MAC_ADDR                     --77 客户终端mac地址
             ,ENTRY_FLG                               --78 记账标志
             ,REVS_TRAN_DT                            --79 冲正交易日期
             ,REVS_TRAN_FLOW_NUM                      --80 冲正交易流水号
             ,REVS_TRAN_CODE                          --81 冲正交易码
             ,JOB_CD                                  --82 任务代码
               )
      SELECT  V_P_DATE                                --01 数据日期
             ,ETL_DT                                  --02 ETL处理日期
             ,LP_ID                                   --03 法人编号
             ,TRAN_FLOW_NUM                           --04 交易流水号
             ,TRAN_DT                                 --05 交易日期
             ,TRAN_TIMESTAMP                          --06 交易时间戳
             ,ACCT_BILL_FLOW_NUM                      --07 账单流水号
             ,OVA_FLOW_NUM                            --08 全局流水号
             ,TRAN_FLG_NUM                            --09 交易标识号
             ,ACCT_ORG_ID                             --10 账务机构
             ,DEP_SUB_ACCT_ID                         --11 存款子户编号
             ,CUST_ACCT_ID                            --12 账户编号
             ,SUB_ACCT_ID                             --13 子户编号
             ,OLD_ACCT_ID                             --14 旧账户编号
             ,OLD_SUB_ACCT_ID                         --15 旧子户编号
             ,CUST_ID                                 --16 客户号
             ,CUST_NAME                               --17 客户名称
             ,CUST_TYPE_CD                            --18 客户类型代码
             ,TRAN_KIND_CD                            --19 交易种类代码
             ,ELEC_TRAN_KIND_CD                       --20 电子交易种类代码
             ,TRAN_STATUS_CD                          --21 交易状态代码
             ,DEBIT_CRDT_DIR_CD                       --22 借贷方向代码
             ,CASH_PROJ_CD                            --23 现金项目代码
             ,TRAN_VOUCH_ID                           --24 交易凭证编号
             ,VOUCH_KIND_CD                           --25 凭证种类代码
             ,MEMO_CD                                 --26 摘要代码
             ,MEMO_CD_DESCB                           --27 摘要代码描述
             ,CHN_CD                                  --28 渠道代码
             ,CNTPTY_ACCT_ID                          --29 对手方账户编号
             ,CNTPTY_SUB_ACCT_ID                      --30 交易对手子账户编号
             ,CNTPTY_ACCT_NAME                        --31 交易对手账户名称
             ,CNTPTY_OPEN_BANK_ID                     --32 交易对手账户开户行编号
             ,CNTPTY_ACCT_OPEN_BANK_CD                --33 交易对手账户开户行代码
             ,CNTPTY_OPEN_BANK_NAME                   --34 交易对手开户行名称
             ,REAL_CNTPTY_ACCT_ID                     --35 真实交易对手账户编号
             ,REAL_CNTPTY_ACCT_NAME                   --36 真实交易对手账户名称
             ,REAL_CNTPTY_FIN_INST_CD                 --37 真实交易对手金融机构代码
             ,REAL_CNTPTY_FIN_INST_NAME               --38 真实交易对手金融机构名称
             ,TRAN_ORG_ID                             --39 交易机构编号
             ,TRAN_CURR_CD                            --40 交易币种代码
             ,TRAN_AMT                                --41 交易金额
             ,TRAN_BAL                                --42 交易余额
             ,TRAN_TELLER_ID                          --43 交易柜员编号
             ,CHECK_TELLER_ID                         --44 复核柜员编号
             ,AUTH_TELLER_ID                          --45 授权柜员编号
             ,ENTRY_TELLER_ID                         --46 记帐柜员编号
             ,ERASE_ACCT_FLG                          --47 抹账标志
             ,REVS_FLG                                --48 冲正标志
             ,CASH_TRANS_FLG                          --49 现转标志
             ,UNEXP_DRAW_FLG                          --50 提前支取标志
             ,BEPS_UNPASEW_FLG                        --51 小额免密标志
             ,BAL_CHK_FLG                             --52 勾对标志
             ,TERMN_ID                                --53 终端编号
             ,TRAN_CD                                 --54 交易代码
             ,TRAN_DESCB                              --55 交易描述
             ,RECE_TYPE_CD                            --56 回单类型代码
             ,TRAN_NAME                               --57 交易名称
             ,PRPERY_SYS_CODE                         --58 外围系统编码
             ,RECE_ID                                 --59 回单编号
             ,RECE_DESCB_INFO                         --60 回单描述信息
             ,AGENT_CUST_ID                           --61 代理人客户编号
             ,AGENT_NAME                              --62 代理人名称
             ,AGENT_CERT_TYPE_CD                      --63 代理人证件类型代码
             ,AGENT_CERT_NO                           --64 代办人证件号码
             ,AGENT_GENDER_CD                         --65 代办人性别代码
             ,AGENT_NATION_CD                         --66 代办人国籍代码
             ,AGENT_CERT_START_DT                     --67 代办人证件开始日期
             ,AGENT_CERT_EXP_DT                       --68 交易代办人证件到期日期
             ,AGENT_PHONE                             --69 代理人联系电话
             ,AGENT_LICEN_ISSUE_AUTHO_SITE            --70 代理人发证机关所在地
             ,AGENT_RS                                --71 代理原因
             ,AGENT_TYPE_CD                           --72 代理类型代码
             ,OPERR_CERT_TYPE_CD                      --73 经办人证件类型代码
             ,OPERR_CERT_NO                           --74 经办人证件号码
             ,OPERR_NAME                              --75 经办人名称
             ,CLIENT_IP_ADDR                          --76 客户端ip地址
             ,CUST_TERMN_MAC_ADDR                     --77 客户终端mac地址
             ,ENTRY_FLG                               --78 记账标志
             ,REVS_TRAN_DT                            --79 冲正交易日期
             ,REVS_TRAN_FLOW_NUM                      --80 冲正交易流水号
             ,REVS_TRAN_CODE                          --81 冲正交易码
             ,JOB_CD                                  --82 任务代码
         FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL  --存款账户交易明细表
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    I_STEP := 4;
    V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_DEP_ACCT_TRAN_DTL;
/

