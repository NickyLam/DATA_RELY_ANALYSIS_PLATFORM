CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_FDPS_FDP_COOPERATOR(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：
  **存储过程名称：    ETL_O_IOL_FDPS_FDP_COOPERATOR
  **存储过程创建日期：20260128
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260128    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_FDPS_FDP_COOPERATOR'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_FDPS_FDP_COOPERATOR';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-高管任职信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_FDPS_FDP_COOPERATOR NOLOGGING 
    (   FDP_COOPERATOR_ID       --字段id
       ,PARENT_MERCHANT_ID      --银行合作商编号
       ,PARENT_MERCHANT_NAME    --银行合作商名称
       ,CUSTOMER_TYPE           --客户类型
       ,OLD_REQ_SEQ_NO          --第三方流水
       ,OLD_REQ_ACCOUNT         --第三方客户标识
       ,ECIF_ACCOUNT_ID         --客户号
       ,CUST_ID_TYPE            --证件类型
       ,CUST_ID_NO              --证件号码
       ,CUST_ID_DUE_DATE        --证件到期日
       ,LEGAL_PERSON_NAME       --法定代表人姓名
       ,LEGAL_PERSON_IDTYPE     --法定代表人证件类型
       ,LEGAL_PERSON_IDNO       --法定代表人证件号码
       ,LPID_FROM_DATE          --法人证件开始日期
       ,LPID_TO_DATE            --法人证件到期日期
       ,LEGAL_PERSON_TELNO      --法人联系电话
       ,ACTOR_NAME              --经办人姓名
       ,ACTOR_ID_TYPE           --经办人证件类型
       ,ACTOR_ID_NO             --经办人证件号码
       ,ACTORID_FROM_DATE       --经办人证件开始日期
       ,ACTORID_TO_DATE         --经办人证件到期日期
       ,ACTOR_MOBILE            --经办人手机号
       ,LICENCE_COPY_URL        --营业执照扫描件url
       ,LP_FRONT_COPY_URL       --法人身份证正面复印件url
       ,LP_REAR_COPY_URL        --法人身份证反面复印件url
       ,ACTOR_FRONT_COPY_URL    --经办人身份证正面复印件url
       ,ACTOR_REAR_COPY_URL     --经办人身份证反面复印件url
       ,DETAIL_ADDRESS          --详细地址
       ,POSTAL_CODE             --邮政编码
       ,CONTACT_TEL             --联系电话
       ,CLEAR_ACCOUNT           --合作商监管账号
       ,CLEAR_ACCOUNT_NAME      --合作商监管账户名称
       ,CLEAR_ORG               --合作商监管账户机构号
       ,CLEAR_ORG_NAME          --合作商监管账户机构名称
       ,MID_CLEAR_ACCOUNT       --中间入账账号
       ,MID_ACCOUNT_NAME        --中间入账账号名称
       ,MID_CLEAR_ORG           --中间入账账号机构号
       ,MID_CLEAR_ORG_NAME      --中间入账账号机构名称
       ,DEP_CLEAR_ACCOUNT       --第三方清算入账账号
       ,DEP_ACCOUNT_NAME        --第三方清算入账账号名称
       ,DEP_CLEAR_ORG           --第三方清算入账账号机构号
       ,DEP_CLEAR_ORG_NAME      --第三方清算入账账号机构名称
       ,CUST_STATUS             --合作商状态
       ,ACCOUNT_NO              --主账号
       ,EXT_NAME                --扩展变量名
       ,EXT_VALUE               --扩展变量值
       ,PLATFORM_CODE           --开通渠道
       ,MAX_BIND_CARDS          --绑定卡数量上限
       ,OPERATOR_ID             --操作员编号
       ,OPERATOR_DEPT_ID        --操作员所属机构
       ,CHECKER_ID              --复核操作员编号
       ,CHECKER_DEPT_ID         --复核操作员所属机构
       ,DESCRIPTION             --描述
       ,LAST_UPDATED_STAMP      --最后更新时间
       ,LAST_UPDATED_TX_STAMP   --最后更新事物时间
       ,CREATED_STAMP           --创建时间
       ,CREATED_TX_STAMP        --创建事物时间
       ,PARENT_MERCHANT_SNAME   --银行合作商简称
       ,OWN_ORG_NO              --所属机构号
       ,DEP_OTHER_BANK_FLAG     --
       ,SETTLE_MODEL            --清算模式
       ,ACTIVE_MSM_MODEL        --动账短信模式
       ,EP_CLEAR_AC             --企业结算户账号
       ,EP_CLEAR_AC_NAME        --企业结算户名称
       ,EP_CLEAR_ORG            --企业结算户机构号
       ,EP_CLEAR_ORG_NAME       --企业结算户机构名称
       ,EP_CLIENT_NO            --客户号
       ,MERCHANT_NO             --商户号
       ,MERCHANT_URL            --客户异步通知url
       ,RECHARGE_URL            --充值异步通知url
       ,IN_ACCOUNT_INFO         --允许入账信息
       ,START_DT                --开始时间
       ,END_DT                  --结束时间
       ,ID_MARK                 --增删标志
       ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT 
        FDP_COOPERATOR_ID       --字段id
       ,PARENT_MERCHANT_ID      --银行合作商编号
       ,PARENT_MERCHANT_NAME    --银行合作商名称
       ,CUSTOMER_TYPE           --客户类型
       ,OLD_REQ_SEQ_NO          --第三方流水
       ,OLD_REQ_ACCOUNT         --第三方客户标识
       ,ECIF_ACCOUNT_ID         --客户号
       ,CUST_ID_TYPE            --证件类型
       ,CUST_ID_NO              --证件号码
       ,CUST_ID_DUE_DATE        --证件到期日
       ,LEGAL_PERSON_NAME       --法定代表人姓名
       ,LEGAL_PERSON_IDTYPE     --法定代表人证件类型
       ,LEGAL_PERSON_IDNO       --法定代表人证件号码
       ,LPID_FROM_DATE          --法人证件开始日期
       ,LPID_TO_DATE            --法人证件到期日期
       ,LEGAL_PERSON_TELNO      --法人联系电话
       ,ACTOR_NAME              --经办人姓名
       ,ACTOR_ID_TYPE           --经办人证件类型
       ,ACTOR_ID_NO             --经办人证件号码
       ,ACTORID_FROM_DATE       --经办人证件开始日期
       ,ACTORID_TO_DATE         --经办人证件到期日期
       ,ACTOR_MOBILE            --经办人手机号
       ,LICENCE_COPY_URL        --营业执照扫描件url
       ,LP_FRONT_COPY_URL       --法人身份证正面复印件url
       ,LP_REAR_COPY_URL        --法人身份证反面复印件url
       ,ACTOR_FRONT_COPY_URL    --经办人身份证正面复印件url
       ,ACTOR_REAR_COPY_URL     --经办人身份证反面复印件url
       ,DETAIL_ADDRESS          --详细地址
       ,POSTAL_CODE             --邮政编码
       ,CONTACT_TEL             --联系电话
       ,CLEAR_ACCOUNT           --合作商监管账号
       ,CLEAR_ACCOUNT_NAME      --合作商监管账户名称
       ,CLEAR_ORG               --合作商监管账户机构号
       ,CLEAR_ORG_NAME          --合作商监管账户机构名称
       ,MID_CLEAR_ACCOUNT       --中间入账账号
       ,MID_ACCOUNT_NAME        --中间入账账号名称
       ,MID_CLEAR_ORG           --中间入账账号机构号
       ,MID_CLEAR_ORG_NAME      --中间入账账号机构名称
       ,DEP_CLEAR_ACCOUNT       --第三方清算入账账号
       ,DEP_ACCOUNT_NAME        --第三方清算入账账号名称
       ,DEP_CLEAR_ORG           --第三方清算入账账号机构号
       ,DEP_CLEAR_ORG_NAME      --第三方清算入账账号机构名称
       ,CUST_STATUS             --合作商状态
       ,ACCOUNT_NO              --主账号
       ,EXT_NAME                --扩展变量名
       ,EXT_VALUE               --扩展变量值
       ,PLATFORM_CODE           --开通渠道
       ,MAX_BIND_CARDS          --绑定卡数量上限
       ,OPERATOR_ID             --操作员编号
       ,OPERATOR_DEPT_ID        --操作员所属机构
       ,CHECKER_ID              --复核操作员编号
       ,CHECKER_DEPT_ID         --复核操作员所属机构
       ,DESCRIPTION             --描述
       ,LAST_UPDATED_STAMP      --最后更新时间
       ,LAST_UPDATED_TX_STAMP   --最后更新事物时间
       ,CREATED_STAMP           --创建时间
       ,CREATED_TX_STAMP        --创建事物时间
       ,PARENT_MERCHANT_SNAME   --银行合作商简称
       ,OWN_ORG_NO              --所属机构号
       ,DEP_OTHER_BANK_FLAG     --
       ,SETTLE_MODEL            --清算模式
       ,ACTIVE_MSM_MODEL        --动账短信模式
       ,EP_CLEAR_AC             --企业结算户账号
       ,EP_CLEAR_AC_NAME        --企业结算户名称
       ,EP_CLEAR_ORG            --企业结算户机构号
       ,EP_CLEAR_ORG_NAME       --企业结算户机构名称
       ,EP_CLIENT_NO            --客户号
       ,MERCHANT_NO             --商户号
       ,MERCHANT_URL            --客户异步通知url
       ,RECHARGE_URL            --充值异步通知url
       ,IN_ACCOUNT_INFO         --允许入账信息
       ,START_DT                --开始时间
       ,END_DT                  --结束时间
       ,ID_MARK                 --增删标志
       ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IOL.V_FDPS_FDP_COOPERATOR --视图-
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

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
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_FDPS_FDP_COOPERATOR', '', O_ERRCODE); --表分析
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

END ETL_O_IOL_FDPS_FDP_COOPERATOR;
/

