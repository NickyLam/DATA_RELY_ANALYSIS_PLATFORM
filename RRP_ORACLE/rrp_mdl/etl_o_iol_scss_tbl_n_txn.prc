CREATE OR REPLACE PROCEDURE RRP_MDL."ETL_O_IOL_SCSS_TBL_N_TXN" (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 银联和ATM交易流水表
  **存储过程名称：    ETL_O_IOL_SCSS_TBL_N_TXN
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ******************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_SCSS_TBL_N_TXN'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
 EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_SCSS_TBL_N_TXN';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_SCSS_TBL_N_TXN NOLOGGING
    (
     SYS_DATE
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
    ,ETL_DT
    ,ETL_TIMESTAMP
      )
  SELECT /*+PARALLEL*/
        SYS_DATE
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
    ,ETL_DT
    ,ETL_TIMESTAMP
    FROM IOL.V_SCSS_TBL_N_TXN   --视图银联和ATM交易流水表
   WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD'); 

   
  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序跑批结束记录 --
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


END ETL_O_IOL_SCSS_TBL_N_TXN;
/

