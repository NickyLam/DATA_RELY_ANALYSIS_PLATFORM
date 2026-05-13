CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_MPCS_A1USETPSIGNACCTINFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：商户签约信息表
  **存储过程名称：    ETL_O_IOL_MPCS_A1USETPSIGNACCTINFO
  **存储过程创建日期：20260130
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260130    YJY        创建  
  *****************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_MPCS_A1USETPSIGNACCTINFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_MPCS_A1USETPSIGNACCTINFO';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-商户签约信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_MPCS_A1USETPSIGNACCTINFO NOLOGGING 
    ( TXN_DT                       --交易日期
     ,TXN_TMS                      --交易时间
     ,TXN_CD                       --中台交易码
     ,TRX_SEQ                      --交易流水号
     ,APP_DT                       --操作日期
     ,APP_TM                       --操作日期
     ,APP_ID                       --申请编号
     ,APP_ORD_NBR                  --申请序号
     ,MERCH_STATUS                 --商户状态：0:未启用、1:已启用、2:已停用
     ,APRV_STATUS                  --审批状态:0:待提交、1:待审批、2:已通过、3:未通过
     ,TXN_TYP                      --操作类型：0:商户注册、1:信息变更、2:服务变更
     ,MERCH_ID                     --商户编号
     ,MERCH_NAME                   --商户名称
     ,REGU_MODE                    --监管模式：01银行存管模式、02风险储备金模式、03复合模式；
     ,ACCT_TYP                     --账户类型 01:监管账户 02:保证金账户
     ,REGU_ACCT_NUM                --监管账号信息-账号
     ,REGU_ACT_NM                  --监管账号信息-户名
     ,REGU_OPEN_BK_NAME            --监管账号信息-开户行名称
     ,REGU_OPEN_BK_NUM             --监管账号信息-开户行行号
     ,ACCT_TYP_CD                  --账户类型 01:监管账户 02:保证金账户
     ,MARG_ACCT_NUM                --保证金账号信息-账号
     ,MARG_ACT_NM                  --保证金账号信息-户名
     ,MARG_OPEN_BK_NAME            --保证金账号信息-开户行名称
     ,MARG_OPEN_BK_NUM             --保证金账号信息-开户行行号
     ,CORP_NAME                    --基本信息-公司名称
     ,CSLD_SOCI_CRDT_CD            --基本信息-统一社会信用代码
     ,CORP_LOGIN_ADDR              --基本信息-注册地址
     ,CLOG_ADDR                    --基本信息-办学地址
     ,CORP_ESTAB_DT                --基本信息-成立日期
     ,CORP_TEL_NUM                 --基本信息-办公电话
     ,OPER_SCOPE                   --基本信息-经营范围
     ,OPER_LICENCE_URL             --基本信息-营业执照URL地址
     ,QLFY_PROOF_URL               --基本信息-资质证明URL地址
     ,BLNG_BRAN_NUM                --管理职责-归属分行行号
     ,BLNG_BRAN_NAME               --管理职责-归属分行名称
     ,LP_NAME                      --法人代表信息-姓名
     ,LP_CERT_TYP                  --法人代表信息-证件类型
     ,LP_IDEN_NUM                  --法人代表信息-身份证号码
     ,LP_CEPH_NUM                  --法人代表信息-手机号码
     ,LP_IDEN_FRO_URL              --法人身份证正面URL地址
     ,LP_IDEN_OBV_URL              --法人身份证反面URL地址
     ,OPRT_NAME                    --经办人信息-姓名
     ,OPRT_CEPH_NUM                --经办人信息-手机号码
     ,OPRT_CERT_TYP                --经办人信息-证件类型
     ,OPRT_CERT_NUM                --经办人信息-证件号码
     ,OPRT_CERT_URL                --经办人链接地址
     ,OPRT_CERT_PRINT_PIECE_URL    --经办人打印链接地址
     ,APRV_COMNT                   --审批人意见
     ,INPUT_TELL_NUM               --录入柜员号
     ,INPUT_ORG_ID                 --录入机构号
     ,CHECK_TELL_NUM               --复核柜员号
     ,CHECK_ORG_ID                 --复核机构号
     ,APPRV_TELL_NUM               --审批柜员号
     ,APPRV_ORG_ID                 --审批机构号
     ,MEMO                         --审批备注
     ,BAK1                         --备注字段1
     ,BAK2                         --备注字段2
     ,START_DT                     --开始时间
     ,END_DT                       --结束时间
     ,ID_MARK                      --增删标志
     ,ETL_TIMESTAMP                --ETL处理时间戳
    )
  SELECT
      TXN_DT                       --交易日期
     ,TXN_TMS                      --交易时间
     ,TXN_CD                       --中台交易码
     ,TRX_SEQ                      --交易流水号
     ,APP_DT                       --操作日期
     ,APP_TM                       --操作日期
     ,APP_ID                       --申请编号
     ,APP_ORD_NBR                  --申请序号
     ,MERCH_STATUS                 --商户状态：0:未启用、1:已启用、2:已停用
     ,APRV_STATUS                  --审批状态:0:待提交、1:待审批、2:已通过、3:未通过
     ,TXN_TYP                      --操作类型：0:商户注册、1:信息变更、2:服务变更
     ,MERCH_ID                     --商户编号
     ,MERCH_NAME                   --商户名称
     ,REGU_MODE                    --监管模式：01银行存管模式、02风险储备金模式、03复合模式；
     ,ACCT_TYP                     --账户类型 01:监管账户 02:保证金账户
     ,REGU_ACCT_NUM                --监管账号信息-账号
     ,REGU_ACT_NM                  --监管账号信息-户名
     ,REGU_OPEN_BK_NAME            --监管账号信息-开户行名称
     ,REGU_OPEN_BK_NUM             --监管账号信息-开户行行号
     ,ACCT_TYP_CD                  --账户类型 01:监管账户 02:保证金账户
     ,MARG_ACCT_NUM                --保证金账号信息-账号
     ,MARG_ACT_NM                  --保证金账号信息-户名
     ,MARG_OPEN_BK_NAME            --保证金账号信息-开户行名称
     ,MARG_OPEN_BK_NUM             --保证金账号信息-开户行行号
     ,CORP_NAME                    --基本信息-公司名称
     ,CSLD_SOCI_CRDT_CD            --基本信息-统一社会信用代码
     ,CORP_LOGIN_ADDR              --基本信息-注册地址
     ,CLOG_ADDR                    --基本信息-办学地址
     ,CORP_ESTAB_DT                --基本信息-成立日期
     ,CORP_TEL_NUM                 --基本信息-办公电话
     ,OPER_SCOPE                   --基本信息-经营范围
     ,OPER_LICENCE_URL             --基本信息-营业执照URL地址
     ,QLFY_PROOF_URL               --基本信息-资质证明URL地址
     ,BLNG_BRAN_NUM                --管理职责-归属分行行号
     ,BLNG_BRAN_NAME               --管理职责-归属分行名称
     ,LP_NAME                      --法人代表信息-姓名
     ,LP_CERT_TYP                  --法人代表信息-证件类型
     ,LP_IDEN_NUM                  --法人代表信息-身份证号码
     ,LP_CEPH_NUM                  --法人代表信息-手机号码
     ,LP_IDEN_FRO_URL              --法人身份证正面URL地址
     ,LP_IDEN_OBV_URL              --法人身份证反面URL地址
     ,OPRT_NAME                    --经办人信息-姓名
     ,OPRT_CEPH_NUM                --经办人信息-手机号码
     ,OPRT_CERT_TYP                --经办人信息-证件类型
     ,OPRT_CERT_NUM                --经办人信息-证件号码
     ,OPRT_CERT_URL                --经办人链接地址
     ,OPRT_CERT_PRINT_PIECE_URL    --经办人打印链接地址
     ,APRV_COMNT                   --审批人意见
     ,INPUT_TELL_NUM               --录入柜员号
     ,INPUT_ORG_ID                 --录入机构号
     ,CHECK_TELL_NUM               --复核柜员号
     ,CHECK_ORG_ID                 --复核机构号
     ,APPRV_TELL_NUM               --审批柜员号
     ,APPRV_ORG_ID                 --审批机构号
     ,MEMO                         --审批备注
     ,BAK1                         --备注字段1
     ,BAK2                         --备注字段2
     ,START_DT                     --开始时间
     ,END_DT                       --结束时间
     ,ID_MARK                      --增删标志
     ,ETL_TIMESTAMP                --ETL处理时间戳
    FROM IOL.V_MPCS_A1USETPSIGNACCTINFO --视图-商户签约信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_MPCS_A1USETPSIGNACCTINFO', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
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

END ETL_O_IOL_MPCS_A1USETPSIGNACCTINFO;
/

