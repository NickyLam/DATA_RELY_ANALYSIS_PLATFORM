CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_CMS_MERCHANT_DETAIL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_AMSS_CMS_MERCHANT_DETAIL
  *  功能描述：商户详细信息表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_AMSS_CMS_MERCHANT_DETAIL
  *  目标表： O_IOL_AMSS_CMS_MERCHANT_DETAIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_AMSS_CMS_MERCHANT_DETAIL'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_CMS_MERCHANT_DETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-商户详细信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_CMS_MERCHANT_DETAIL NOLOGGING
    (     MERCHANT_DETAIL_ID              --商户详细信息ID.使用 商户编号 做商户详细信息的ID
         ,MERCHANT_SHORT_NAME              --商户简称.
         ,INDUSTR_ID                      --行业类别.关联行业类别表
         ,PROVINCE                            --省份. 
         ,CITY                              --城市.
         ,COUNTY                            --区/县.
         ,ADDRESS                            --地址.
         ,TEL                              --电话.
         ,EMAIL                              --邮箱.
         ,WEB_SITE                            --网址.
         ,PRINCIPAL                            --负责人.
         ,ID_CODE                            --负责人身份证.
         ,PRINCIPAL_MOBILE                  --负责人手机.
         ,CUSTOMER_PHONE                  --客服电话.
         ,FAX                              --传真.
         ,LICENSE_PHOTO                      --营业执照.
         ,INDENTITY_PHOTO                  --身份证照片.
         ,PROTOCOL_PHOTO                  --商户协议照片.
         ,ORG_PHOTO                          --组织机构代码证照片.
         ,OTHER_DOC                          --其他资料.资料包，以zip和rar格式上传和下载
         ,PHYSICS_FLAG                        --物理标识.1:正常;2:删除
         ,DATA_SOURCE                        --数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
         ,REMARK                          --备注.
         ,FLD_S1                          --门头照路径
         ,FLD_S2                          --营业执照注册号/统一社会信用代码图片路径
         ,FLD_S3                          --营业场所照片路径
         ,FLD_N1                          --性别
         ,FLD_N2                          --(subjectType)商户主体类型
         ,FLD_N3                          --数值型保留字段3.
         ,FLD_D1                          --日期型保留字段1.
         ,CREATE_USER                        --创建用户.
         ,CREATE_EMP                        --创建人.
         ,CREATE_TIME                        --创建时间.
         ,UPDATE_TIME                        --更新时间.
         ,INTERFACE_REFUND_AUDIT            --接口退款审核
         ,ID_CODE_TYPE                      --证件类型
         ,BUSINESS_LICENSE_NAME                  --营业执照名称
         ,ACCOUNT_CODE_PHOTO                  --银行卡/开户许可证图片路径
         ,FLD_N4                          --(fixedPlace)小微商户是否有固定经营场所
         ,FLD_N5                          --注册资本金
         ,FLD_N6                          --
         ,FLD_N7                          --
         ,FLD_N8                          --
         ,FLD_S4                          --(alipayAccount)保存支付宝账号
         ,FLD_S5                          --(contacts)保存联系人
         ,FLD_S6                          --(businessScope)经营范围
         ,FLD_S7                          --(actualBusinessAddress)实际经营地址
         ,FLD_S8                          --(registeredAddress)注册地址
         ,ID_CODE_EXPIRE                      --身份证到期日.
         ,BUSINESS_LICENSE_EXPIRE            --营业执照到期日.
         ,LCADDRESS                          --商户定位地址
         ,QUESTIONNAIRE                        --调查表
         ,APPROVAL_FORM                        --审批表
         ,THI_DOC_ID                        --第三方文档ID
         ,NATIONALITY_NUM                      --国籍编号
         ,PRINCIPAL_PROFESSION              --负责人职业
         ,ID_CODE_BEGIN_TIME              --证件有效期开始时间
         ,BUSINESS_LICENSE_BEGIN_TIME          --营业执照有效期开始时间
         ,CONTACTS_IDCODE                    --联系人证件号码
         ,MANAGE_TYPE                      --经营类型
         ,COMPANY_PROVE                      --单位证明函照片
         ,INDOOR_PHOTO                      --内景照
         ,CHECKSTAND_PHOTO                    --收银台照
         ,MANAGER_PRINCIPAL_PHOTO            --客户经理与法人合照
         ,REGISTER_IP                      --登记ip
         ,ICP_NUMBER                      --ICP备案号
         ,MERCHANT_LABEL                    --商户标签
         ,LINE_FLAG                          --条码标识:1公司线，2机构线,3零售线，4数金线
         ,ONLINE_VERIFI_PHOTO              --联网核查照
         ,SIGN_PHOTO                      --签名照
         ,PROTOCOL_PDF                      --影像平台协议PDF地址
         ,CUSTOMER_NO                      --Ecif客户编号
         ,HANDLING_CUSTOMER_MANAGER_NAME    --经办客户经理
         ,HANDLING_CUSTOMER_MANAGER_ID      --经办客户经理工号
         ,HANDLING_BANK_BRANCH              --经办支行
         ,CUSTOMER_ID                      --客户号
         ,TRADE_ABLE_HOURS_BEGIN                --可交易开始时间
         ,TRADE_ABLE_HOURS_END                  --可交易结束时间
         ,POINTS_OFFER                      --是否积分优惠
         ,SUPPORT_FARMER_STATION                --      
         ,SUPPORT_FARMER                    --  
         ,THI_MCH_ID                      --第三方商户号
         ,START_DT                          --开始时间
         ,END_DT                          --结束时间
         ,ID_MARK                          --增删标志
         ,ETL_TIMESTAMP                        --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
             MERCHANT_DETAIL_ID              --商户详细信息ID.使用 商户编号 做商户详细信息的ID
         ,MERCHANT_SHORT_NAME              --商户简称.
         ,INDUSTR_ID                      --行业类别.关联行业类别表
         ,PROVINCE                            --省份. 
         ,CITY                              --城市.
         ,COUNTY                            --区/县.
         ,ADDRESS                            --地址.
         ,TEL                              --电话.
         ,EMAIL                              --邮箱.
         ,WEB_SITE                            --网址.
         ,PRINCIPAL                            --负责人.
         ,ID_CODE                            --负责人身份证.
         ,PRINCIPAL_MOBILE                  --负责人手机.
         ,CUSTOMER_PHONE                  --客服电话.
         ,FAX                              --传真.
         ,LICENSE_PHOTO                      --营业执照.
         ,INDENTITY_PHOTO                  --身份证照片.
         ,PROTOCOL_PHOTO                  --商户协议照片.
         ,ORG_PHOTO                          --组织机构代码证照片.
         ,OTHER_DOC                          --其他资料.资料包，以zip和rar格式上传和下载
         ,PHYSICS_FLAG                        --物理标识.1:正常;2:删除
         ,DATA_SOURCE                        --数据来源.1:界面录入;2:基础资料导入导出:3:数据迁移
         ,REMARK                          --备注.
         ,FLD_S1                          --门头照路径
         ,FLD_S2                          --营业执照注册号/统一社会信用代码图片路径
         ,FLD_S3                          --营业场所照片路径
         ,FLD_N1                          --性别
         ,FLD_N2                          --(subjectType)商户主体类型
         ,FLD_N3                          --数值型保留字段3.
         ,FLD_D1                          --日期型保留字段1.
         ,CREATE_USER                        --创建用户.
         ,CREATE_EMP                        --创建人.
         ,CREATE_TIME                        --创建时间.
         ,UPDATE_TIME                        --更新时间.
         ,INTERFACE_REFUND_AUDIT            --接口退款审核
         ,ID_CODE_TYPE                      --证件类型
         ,BUSINESS_LICENSE_NAME                  --营业执照名称
         ,ACCOUNT_CODE_PHOTO                  --银行卡/开户许可证图片路径
         ,FLD_N4                          --(fixedPlace)小微商户是否有固定经营场所
         ,FLD_N5                          --注册资本金
         ,FLD_N6                          --
         ,FLD_N7                          --
         ,FLD_N8                          --
         ,FLD_S4                          --(alipayAccount)保存支付宝账号
         ,FLD_S5                          --(contacts)保存联系人
         ,FLD_S6                          --(businessScope)经营范围
         ,FLD_S7                          --(actualBusinessAddress)实际经营地址
         ,FLD_S8                          --(registeredAddress)注册地址
         ,ID_CODE_EXPIRE                      --身份证到期日.
         ,BUSINESS_LICENSE_EXPIRE            --营业执照到期日.
         ,LCADDRESS                          --商户定位地址
         ,QUESTIONNAIRE                        --调查表
         ,APPROVAL_FORM                        --审批表
         ,THI_DOC_ID                        --第三方文档ID
         ,NATIONALITY_NUM                      --国籍编号
         ,PRINCIPAL_PROFESSION              --负责人职业
         ,ID_CODE_BEGIN_TIME              --证件有效期开始时间
         ,BUSINESS_LICENSE_BEGIN_TIME          --营业执照有效期开始时间
         ,CONTACTS_IDCODE                    --联系人证件号码
         ,MANAGE_TYPE                      --经营类型
         ,COMPANY_PROVE                      --单位证明函照片
         ,INDOOR_PHOTO                      --内景照
         ,CHECKSTAND_PHOTO                    --收银台照
         ,MANAGER_PRINCIPAL_PHOTO            --客户经理与法人合照
         ,REGISTER_IP                      --登记ip
         ,ICP_NUMBER                      --ICP备案号
         ,MERCHANT_LABEL                    --商户标签
         ,LINE_FLAG                          --条码标识:1公司线，2机构线,3零售线，4数金线
         ,ONLINE_VERIFI_PHOTO              --联网核查照
         ,SIGN_PHOTO                      --签名照
         ,PROTOCOL_PDF                      --影像平台协议PDF地址
         ,CUSTOMER_NO                      --Ecif客户编号
         ,HANDLING_CUSTOMER_MANAGER_NAME    --经办客户经理
         ,HANDLING_CUSTOMER_MANAGER_ID      --经办客户经理工号
         ,HANDLING_BANK_BRANCH              --经办支行
         ,CUSTOMER_ID                      --客户号
         ,TRADE_ABLE_HOURS_BEGIN                --可交易开始时间
         ,TRADE_ABLE_HOURS_END                  --可交易结束时间
         ,POINTS_OFFER                      --是否积分优惠
         ,SUPPORT_FARMER_STATION                --      
         ,SUPPORT_FARMER                    --  
         ,THI_MCH_ID                      --第三方商户号
         ,START_DT                          --开始时间
         ,END_DT                          --结束时间
         ,ID_MARK                          --增删标志
         ,ETL_TIMESTAMP                        --ETL处理时间戳
    FROM IOL.V_AMSS_CMS_MERCHANT_DETAIL   --商户详细信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';  

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IOL_AMSS_CMS_MERCHANT_DETAIL;
/

