CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL
  *  功能描述：存款账户交易明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_DEP_ACCT_TRAN_DTL
  *  目标表： O_ICL_CMM_DEP_ACCT_TRAN_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221615           修改参数
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_DEP_ACCT_TRAN_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-存款账户交易明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL
    (ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,TRAN_FLOW_NUM               --交易流水号
    ,TRAN_DT                     --交易日期
    ,TRAN_TIMESTAMP              --交易时间戳
    ,ACCT_BILL_FLOW_NUM          --账单流水号
    ,OVA_FLOW_NUM                --全局流水号
    ,TRAN_FLG_NUM                --交易标识号
    ,ACCT_ORG_ID                 --账户机构编号
    ,DEP_SUB_ACCT_ID             --存款分户编号
    ,CUST_ACCT_ID                --客户账户编号
    ,SUB_ACCT_ID                 --子户编号
    ,INIT_DEP_SUB_ACCT_ID        --原分户编号
    ,INIT_SUB_ACCT_ID            --原子户编号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户名称
    ,CUST_TYPE_CD                --客户类型代码
    ,BUS_PROD_ID                 --业务产品编号
    ,TRAN_KIND_CD                --交易种类代码
    ,ELEC_TRAN_KIND_CD           --电子交易种类代码
    ,TRAN_STATUS_CD              --交易状态代码
    ,DEBIT_CRDT_DIR_CD           --借贷方向代码
    ,CASH_PROJ_CD                --现金项目代码
    ,TRAN_VOUCH_ID               --交易凭证编号
    ,VOUCH_KIND_CD               --凭证种类代码
    ,MEMO_CD                     --摘要代码
    ,MEMO_CD_DESCB               --摘要代码描述
    ,CHN_CD                      --渠道代码
    ,CNTPTY_INTER_ACCT_ID        --交易对手分户编号
    ,CNTPTY_ACCT_ID              --交易对手账户编号
    ,CNTPTY_SUB_ACCT_ID          --交易对手子账户编号
    ,CNTPTY_ACCT_NAME            --交易对手账户名称
    ,CNTPTY_OPEN_BANK_ID         --交易对手账户开户行编号
    ,CNTPTY_ACCT_OPEN_BANK_CD    --交易对手账户开户行代码
    ,CNTPTY_OPEN_BANK_NAME       --交易对手账户开户行名称
    ,REAL_CNTPTY_ACCT_ID         --真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME       --真实交易对手账户名称
    ,REAL_CNTPTY_FIN_INST_CD     --真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME   --真实交易对手金融机构名称
    ,TRAN_ORG_ID                 --交易机构编号
    ,TRAN_CURR_CD                --交易币种代码
    ,TRAN_AMT                    --交易金额
    ,TRAN_BAL                    --交易余额
    ,TRAN_TELLER_ID              --交易柜员编号
    ,CHECK_TELLER_ID             --复核柜员编号
    ,AUTH_TELLER_ID              --授权柜员编号
    ,ENTRY_TELLER_ID             --记帐柜员编号
    ,ERASE_ACCT_FLG              --抹账标志
    ,REVS_FLG                    --冲正标志
    ,CASH_TRANS_FLG              --现转标志
    ,UNEXP_DRAW_FLG              --提前支取标志
    ,BEPS_UNPASEW_FLG            --小额免密标志
    ,BAL_CHK_FLG                 --勾对标志
    ,TERMN_ID                    --终端编号
    ,TRAN_CD                     --交易代码
    ,TRAN_DESCB                  --交易描述
    ,RECE_TYPE_CD                --回单类型代码
    ,TRAN_NAME                   --交易名称
    ,PRPERY_SYS_CODE             --外围系统编码
    ,RECE_ID                     --回单编号
    ,RECE_DESCB_INFO             --回单描述信息
    ,AGENT_CUST_ID               --代理人客户编号
    ,AGENT_NAME                  --代理人名称
    ,AGENT_CERT_TYPE_CD          --代理人证件类型代码
    ,AGENT_CERT_NO               --代理人证件号码
    ,AGENT_GENDER_CD             --代理人性别代码
    ,AGENT_NATION_CD             --代理人国籍代码
    ,AGENT_CERT_START_DT         --代理人证件开始日
    ,AGENT_CERT_EXP_DT           --代理人证件到期日
    ,AGENT_PHONE                 --代理人联系电话
    ,AGENT_LICEN_ISSUE_AUTHO_SITE--代理人发证机关所在地
    ,AGENT_RS                    --代理原因
    ,AGENT_TYPE_CD               --代理类型代码
    ,OPERR_CERT_TYPE_CD          --经办人证件类型代码
    ,OPERR_CERT_NO               --经办人证件号码
    ,OPERR_NAME                  --经办人名称
    ,CLIENT_IP_ADDR              --客户端IP地址
    ,CUST_TERMN_MAC_ADDR         --客户终端MAC地址
    ,ENTRY_FLG                   --记账标志
    ,REVS_TRAN_DT                --冲正交易日期
    ,REVS_TRAN_FLOW_NUM          --冲正交易流水号
    ,REVS_TRAN_CODE              --冲正交易码
    ,INIT_TRAN_TIMESTAMP         --原交易时间戳
    )
  SELECT 
     ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,TRAN_FLOW_NUM               --交易流水号
    ,TRAN_DT                     --交易日期
    ,TRAN_TIMESTAMP              --交易时间戳
    ,ACCT_BILL_FLOW_NUM          --账单流水号
    ,OVA_FLOW_NUM                --全局流水号
    ,TRAN_FLG_NUM                --交易标识号
    ,ACCT_ORG_ID                 --账户机构编号
    ,DEP_SUB_ACCT_ID             --存款分户编号
    ,CUST_ACCT_ID                --客户账户编号
    ,SUB_ACCT_ID                 --子户编号
    ,INIT_DEP_SUB_ACCT_ID        --原分户编号
    ,INIT_SUB_ACCT_ID            --原子户编号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户名称
    ,CUST_TYPE_CD                --客户类型代码
    ,BUS_PROD_ID                 --业务产品编号
    ,TRAN_KIND_CD                --交易种类代码
    ,ELEC_TRAN_KIND_CD           --电子交易种类代码
    ,TRAN_STATUS_CD              --交易状态代码
    ,DEBIT_CRDT_DIR_CD           --借贷方向代码
    ,CASH_PROJ_CD                --现金项目代码
    ,TRAN_VOUCH_ID               --交易凭证编号
    ,VOUCH_KIND_CD               --凭证种类代码
    ,MEMO_CD                     --摘要代码
    ,MEMO_CD_DESCB               --摘要代码描述
    ,CHN_CD                      --渠道代码
    ,CNTPTY_INTER_ACCT_ID        --交易对手分户编号
    ,CNTPTY_ACCT_ID              --交易对手账户编号
    ,CNTPTY_SUB_ACCT_ID          --交易对手子账户编号
    ,CNTPTY_ACCT_NAME            --交易对手账户名称
    ,CNTPTY_OPEN_BANK_ID         --交易对手账户开户行编号
    ,CNTPTY_ACCT_OPEN_BANK_CD    --交易对手账户开户行代码
    ,CNTPTY_OPEN_BANK_NAME       --交易对手账户开户行名称
    ,REAL_CNTPTY_ACCT_ID         --真实交易对手账户编号
    ,REAL_CNTPTY_ACCT_NAME       --真实交易对手账户名称
    ,REAL_CNTPTY_FIN_INST_CD     --真实交易对手金融机构代码
    ,REAL_CNTPTY_FIN_INST_NAME   --真实交易对手金融机构名称
    ,TRAN_ORG_ID                 --交易机构编号
    ,TRAN_CURR_CD                --交易币种代码
    ,TRAN_AMT                    --交易金额
    ,TRAN_BAL                    --交易余额
    ,TRAN_TELLER_ID              --交易柜员编号
    ,CHECK_TELLER_ID             --复核柜员编号
    ,AUTH_TELLER_ID              --授权柜员编号
    ,ENTRY_TELLER_ID             --记帐柜员编号
    ,ERASE_ACCT_FLG              --抹账标志
    ,REVS_FLG                    --冲正标志
    ,CASH_TRANS_FLG              --现转标志
    ,UNEXP_DRAW_FLG              --提前支取标志
    ,BEPS_UNPASEW_FLG            --小额免密标志
    ,BAL_CHK_FLG                 --勾对标志
    ,TERMN_ID                    --终端编号
    ,TRAN_CD                     --交易代码
    ,TRAN_DESCB                  --交易描述
    ,RECE_TYPE_CD                --回单类型代码
    ,TRAN_NAME                   --交易名称
    ,PRPERY_SYS_CODE             --外围系统编码
    ,RECE_ID                     --回单编号
    ,RECE_DESCB_INFO             --回单描述信息
    ,AGENT_CUST_ID               --代理人客户编号
    ,AGENT_NAME                  --代理人名称
    ,AGENT_CERT_TYPE_CD          --代理人证件类型代码
    ,AGENT_CERT_NO               --代理人证件号码
    ,AGENT_GENDER_CD             --代理人性别代码
    ,AGENT_NATION_CD             --代理人国籍代码
    ,AGENT_CERT_START_DT         --代理人证件开始日
    ,AGENT_CERT_EXP_DT           --代理人证件到期日
    ,AGENT_PHONE                 --代理人联系电话
    ,AGENT_LICEN_ISSUE_AUTHO_SITE--代理人发证机关所在地
    ,AGENT_RS                    --代理原因
    ,AGENT_TYPE_CD               --代理类型代码
    ,OPERR_CERT_TYPE_CD          --经办人证件类型代码
    ,OPERR_CERT_NO               --经办人证件号码
    ,OPERR_NAME                  --经办人名称
    ,CLIENT_IP_ADDR              --客户端IP地址
    ,CUST_TERMN_MAC_ADDR         --客户终端MAC地址
    ,ENTRY_FLG                   --记账标志
    ,REVS_TRAN_DT                --冲正交易日期
    ,REVS_TRAN_FLOW_NUM          --冲正交易流水号
    ,REVS_TRAN_CODE              --冲正交易码
    ,INIT_TRAN_TIMESTAMP         --原交易时间戳
    FROM ICL.V_CMM_DEP_ACCT_TRAN_DTL --视图-存款账户交易明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL;
/

