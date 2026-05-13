CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_SCSS_TBL_N_TXN (I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       /*I_P_DATE IN INTEGER, --跑批日期
                                                       O_ERRCODE  OUT VARCHAR2 --错误代码*/
                                                 )
 /*******************************************************************
  **存储过程详细说明： 银联和ATM交易流水表
  **存储过程名称：    ETL_M_MRPT_SCSS_TBL_N_TXN
  **存储过程创建日期：20230104
  **存储过程创建人：  阳娟
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
  AS
  -- 定义变量 --
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_SCSS_TBL_N_TXN'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称

BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_SCSS_TBL_N_TXN'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_SCSS_TBL_N_TXN T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
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
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 2;
  I_STEP_DESC := '-- 数据插入目标表 --';
  D_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.M_MRPT_SCSS_TBL_N_TXN NOLOGGING
    ( DATA_DT
    ,SYS_DATE
    ,SYS_SEQ_NUM
    ,MSG_SRC_ID
    ,MSG_DEST_ID
    ,LOG_UNISTAMP
    ,ORG_BIZ_TXN
    ,TXN_NUM
    ,TRANS_STATE
    ,RESP_CODE
    ,RESP_DESC
    ,REVSAL_FLAG
    ,REVSAL_SSN
    ,CANCEL_FLAG
    ,CANCEL_SSN
    ,KEY_RSP
    ,KEY_REVSAL
    ,KEY_CANCEL
    ,CHANN_NUM
    ,ORG_CHANN_NUM
    ,TRANSNUM
    ,TRANSTYP
    ,CHALDATE
    ,CHECKCODE
    ,MCHNT_TYPE
    ,MCHNT_ID
    ,MCHNT_NAME
    ,TERMNL_ID
    ,ACQINSID
    ,ACQ_INST_ID_CODE
    ,TXN_ACCT_NUM
    ,TXN_CARD_SEQID
    ,TXN_ACCT_ISSCODE
    ,TXN_ACCT_NAME
    ,TXN_ACC_TYPE
    ,CARD_LEVEL
    ,TXN_ACC_SPEC
    ,ACC_STATUS
    ,DATE_EXPR
    ,VRF_FLG
    ,DRW_MODE
    ,DRW_MODE_STATUS
    ,SETT_CARD_FLAG
    ,SETT_CARD_NAME
    ,CASH_CAN
    ,CURRCY_CODE_STLM
    ,AMT_TRANS
    ,CERT_TYPE
    ,CERT_ID
    ,RES_CEPH_NUM
    ,OUT_ACCT_ID
    ,OUT_ACCT_NAME
    ,OUT_ACCT_ISSID
    ,IN_ACCT_ID
    ,IN_ACCT_NAME
    ,IN_ACCT_ISSID
    ,PYE_ACCT_ID1
    ,PYE_ACCTNAME1
    ,PYR_ACCTID1
    ,PYR_ACCTNAME1
    ,PYE2PYR_AMT1
    ,PYE_ACCT_ID2
    ,PYE_ACCT_NAME2
    ,PYR_ACCT_ID2
    ,PYR_ACCT_NAME2
    ,PYE2PYR_AMT2
    ,PYE_ACCT_ID3
    ,PYE_ACCT_NAME3
    ,PYR_ACCT_ID3
    ,PYR_ACCT_NAME3
    ,PYE2PYR_AMT3
    ,PYE_ACCT_ID4
    ,PYE_ACCT_NAME4
    ,PYR_ACCT_ID4
    ,PYR_ACCT_NAME4
    ,PYE2PYR_AMT4
    ,PYE_FEE_ACCT_ID
    ,PYE_FEE_ACCT_NAME
    ,PYR_FEE_ACCT_ID
    ,PYR_FEE_ACCT_NAME
    ,TRAN_FEE_AMT
    ,SCS_CTL_FLG
    ,F55_9A
    ,F55_9C
    ,F55_9F1A
    ,F55_95
    ,F55_9F37
    ,F55_82
    ,F55_9F36
    ,F55_9F10
    ,F55_5F34
    ,F55_5F2A
    ,F55_9F26
    ,F55_9F02
    ,F55_9F03
    ,F55_DF31
    ,F55_91
    ,F55_72
    ,SRV_SRC_SYSID
    ,SRV_DEST_SYSID
    ,SRV_MSGID
    ,SRV_CLLPTY_SYSID
    ,SVR_GLOB_SEQNO
    ,SVR_SOU_SEQNO
    ,SVR_SOU_DATE
    ,SVR_SOU_TIME
    ,SVR_SRC_NAME
    ,SVR_SRC_NUM
    ,SVR_SRC_MSGT
    ,SVR_SRC_PRI
    ,TELL_NO
    ,CITY_CODE
    ,PTYID
    ,PTYBRNO
    ,OUTNUM
    ,AUTHTELID
    ,CHKTELID
    ,AUTHSEQNO
    ,AUTHPWD
    ,PRCSCD
    ,ORISOUSEQNO
    ,ORISOUDATE
    ,ORISOUTIME
    ,ORIUPPNO
    ,ORIUPPDATE
    ,UPPNO
    ,UPPDATE
    ,UPPCODE
    ,UPPTXT
    ,AUTHCODE
    ,COLDDATE
    ,COLDNUM
    ,ORICOLDDATE
    ,ORICOLDNUM
    ,ONLNBAL
    ,ACCTBAL
    ,MSGTYPE
    ,MISCFLAG
    ,MISC1
    ,MISC2
    ,MISC3
    ,MISC4
    ,MISC5
    ,MISC6
    ,RESV1
    ,RESV2
    ,INST_DATE
    ,UPDT_DATE
      )
  SELECT /*+PARALLEL*/
    V_P_DATE
    ,SYS_DATE
    ,SYS_SEQ_NUM
    ,MSG_SRC_ID
    ,MSG_DEST_ID
    ,LOG_UNISTAMP
    ,ORG_BIZ_TXN
    ,TXN_NUM
    ,TRANS_STATE
    ,RESP_CODE
    ,RESP_DESC
    ,REVSAL_FLAG
    ,REVSAL_SSN
    ,CANCEL_FLAG
    ,CANCEL_SSN
    ,KEY_RSP
    ,KEY_REVSAL
    ,KEY_CANCEL
    ,CHANN_NUM
    ,ORG_CHANN_NUM
    ,TRANSNUM
    ,TRANSTYP
    ,CHALDATE
    ,CHECKCODE
    ,MCHNT_TYPE
    ,MCHNT_ID
    ,MCHNT_NAME
    ,TERMNL_ID
    ,ACQINSID
    ,ACQ_INST_ID_CODE
    ,TXN_ACCT_NUM
    ,TXN_CARD_SEQID
    ,TXN_ACCT_ISSCODE
    ,TXN_ACCT_NAME
    ,TXN_ACC_TYPE
    ,CARD_LEVEL
    ,TXN_ACC_SPEC
    ,ACC_STATUS
    ,DATE_EXPR
    ,VRF_FLG
    ,DRW_MODE
    ,DRW_MODE_STATUS
    ,SETT_CARD_FLAG
    ,SETT_CARD_NAME
    ,CASH_CAN
    ,CURRCY_CODE_STLM
    ,AMT_TRANS
    ,CERT_TYPE
    ,CERT_ID
    ,RES_CEPH_NUM
    ,OUT_ACCT_ID
    ,OUT_ACCT_NAME
    ,OUT_ACCT_ISSID
    ,IN_ACCT_ID
    ,IN_ACCT_NAME
    ,IN_ACCT_ISSID
    ,PYE_ACCT_ID1
    ,PYE_ACCTNAME1
    ,PYR_ACCTID1
    ,PYR_ACCTNAME1
    ,PYE2PYR_AMT1
    ,PYE_ACCT_ID2
    ,PYE_ACCT_NAME2
    ,PYR_ACCT_ID2
    ,PYR_ACCT_NAME2
    ,PYE2PYR_AMT2
    ,PYE_ACCT_ID3
    ,PYE_ACCT_NAME3
    ,PYR_ACCT_ID3
    ,PYR_ACCT_NAME3
    ,PYE2PYR_AMT3
    ,PYE_ACCT_ID4
    ,PYE_ACCT_NAME4
    ,PYR_ACCT_ID4
    ,PYR_ACCT_NAME4
    ,PYE2PYR_AMT4
    ,PYE_FEE_ACCT_ID
    ,PYE_FEE_ACCT_NAME
    ,PYR_FEE_ACCT_ID
    ,PYR_FEE_ACCT_NAME
    ,TRAN_FEE_AMT
    ,SCS_CTL_FLG
    ,F55_9A
    ,F55_9C
    ,F55_9F1A
    ,F55_95
    ,F55_9F37
    ,F55_82
    ,F55_9F36
    ,F55_9F10
    ,F55_5F34
    ,F55_5F2A
    ,F55_9F26
    ,F55_9F02
    ,F55_9F03
    ,F55_DF31
    ,F55_91
    ,F55_72
    ,SRV_SRC_SYSID
    ,SRV_DEST_SYSID
    ,SRV_MSGID
    ,SRV_CLLPTY_SYSID
    ,SVR_GLOB_SEQNO
    ,SVR_SOU_SEQNO
    ,SVR_SOU_DATE
    ,SVR_SOU_TIME
    ,SVR_SRC_NAME
    ,SVR_SRC_NUM
    ,SVR_SRC_MSGT
    ,SVR_SRC_PRI
    ,TELL_NO
    ,CITY_CODE
    ,PTYID
    ,PTYBRNO
    ,OUTNUM
    ,AUTHTELID
    ,CHKTELID
    ,AUTHSEQNO
    ,AUTHPWD
    ,PRCSCD
    ,ORISOUSEQNO
    ,ORISOUDATE
    ,ORISOUTIME
    ,ORIUPPNO
    ,ORIUPPDATE
    ,UPPNO
    ,UPPDATE
    ,UPPCODE
    ,UPPTXT
    ,AUTHCODE
    ,COLDDATE
    ,COLDNUM
    ,ORICOLDDATE
    ,ORICOLDNUM
    ,ONLNBAL
    ,ACCTBAL
    ,MSGTYPE
    ,MISCFLAG
    ,MISC1
    ,MISC2
    ,MISC3
    ,MISC4
    ,MISC5
    ,MISC6
    ,RESV1
    ,RESV2
    ,INST_DATE
    ,UPDT_DATE
    FROM RRP_MDL.O_IOL_SCSS_TBL_N_TXN   --视图银联和ATM交易流水表
   WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD')

   ;
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     D_ENDTIME := SYSDATE;
     /*I_STEP := 3;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);


END ETL_M_MRPT_SCSS_TBL_N_TXN;
/

