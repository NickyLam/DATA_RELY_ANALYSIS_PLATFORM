CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_TRA_BANK_ACCOUNT(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：银行结算账户表
  **存储过程名称：    ETL_O_IOL_AMSS_TRA_BANK_ACCOUNT
  **存储过程创建日期：20250916
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250916    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_AMSS_TRA_BANK_ACCOUNT'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_TRA_BANK_ACCOUNT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-银行结算账户表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_TRA_BANK_ACCOUNT NOLOGGING 
  (          ACCOUNT_ID                    --账户ID
            ,ORG_ID                        --机构ID-对应渠道编号或商户编号
            ,ACCOUNT_CODE                  --银行卡号
            ,BANK_ID                       --开户银行-关联银行表( CMS_BANK )
            ,ACCOUNT_NAME                  --开户人
            ,ACCOUNT_TYPE                  --帐户类型1:企业 ;2:个人;5:内部户
            ,CONTACT_LINE                  --联行号网点号、联行号
            ,REMIT_ACCOUNT_CODE            --汇出方银行卡号-兴业叫汇出方银行卡号，浦发叫现代支付号
            ,IS_INLINE                     --是否行内账号true:是，false:不是
            ,BANK_NAME                     --开户支行名称
            ,PROVINCE                      --开户支行所在省
            ,CITY                          --开户支行所在市
            ,ID_CARD_TYPE                  --持卡人证件类型:从系统类型表来
            ,ID_CARD                       --持卡人证件号码
            ,ADDRESS                       --持卡人地址
            ,TEL                           --手机号码
            ,EXAMINE_STATUS                --审核状态0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,EXAMINE_TIME                  --审核时间
            ,EXAMINE_STATUS_REMARK         --审核备注
            ,EXAMINE_EMP                   --审核人
            ,ENABLED                       --是否启用
            ,DATA_SIGN                     --数据签名
            ,DATA_SOURCE                   --数据来源1:界面录入;2:基础资料导入导出:3:数据迁移
            ,FLD_S1                        --结算账户的支出户名
            ,FLD_S2                        --字符型保留字段2
            ,FLD_S3                        --字符型保留字段3
            ,FLD_N1                        --是否收支分离
            ,FLD_N2                        --结算卡审核状态0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,FLD_N3                        --数值型保留字段3
            ,FLD_D1                        --日期型保留字段1
            ,CREATE_USER                   --创建用户
            ,CREATE_EMP                    --创建人
            ,CREATE_TIME                   --创建时间
            ,UPDATE_TIME                   --更新时间
            ,CHECK_AUTH                    --是否鉴权
            ,E_ACCOUNT_CODE                --电子账户
            ,ACCOUNT_EN_NAME               --开户人英文名
            ,ACCOUNT_EXPIRED_DATE          --开户人证件有效期
            ,ACCOUNT_POSTCODE              --邮编
            ,CHECK_AUTH3                   --3要素实名状态
            ,CHECK_AUTH4                   --4要素实名状态
            ,E_ACCOUNT_ENABLED             --是否开启电子账号
            ,SFT_MERCHANT_ID               --盛付通商户号
            ,FEE_CODE                      --费项代码
            ,FEE_CODE2                     --费项代码2
            ,SUBJECT_ACCOUNT               --科目账号
            ,UNIT_PROP                     --单位性质
            ,NEW_ACCOUNT_CODE              --新账号或主账号
            ,ACCOUNT_PROPERTIES            --轧差入账属性字段，按位使用
            ,NEW_REMIT_ACCOUNT_CODE        --新汇出方卡号
            ,POINT_PAYMENT                 --开通积分支付
            ,POINTS_OFFER                  --是否积分优惠
            ,START_DT                      --开始时间
            ,END_DT                        --结束时间
            ,ID_MARK                       --增删标志
            ,ETL_TIMESTAMP                 --ETL处理时间戳
    )
    SELECT
             ACCOUNT_ID                    --账户ID
            ,ORG_ID                        --机构ID-对应渠道编号或商户编号
            ,ACCOUNT_CODE                  --银行卡号
            ,BANK_ID                       --开户银行-关联银行表( CMS_BANK )
            ,ACCOUNT_NAME                  --开户人
            ,ACCOUNT_TYPE                  --帐户类型1:企业 ;2:个人;5:内部户
            ,CONTACT_LINE                  --联行号网点号、联行号
            ,REMIT_ACCOUNT_CODE            --汇出方银行卡号-兴业叫汇出方银行卡号，浦发叫现代支付号
            ,IS_INLINE                     --是否行内账号true:是，false:不是
            ,BANK_NAME                     --开户支行名称
            ,PROVINCE                      --开户支行所在省
            ,CITY                          --开户支行所在市
            ,ID_CARD_TYPE                  --持卡人证件类型:从系统类型表来
            ,ID_CARD                       --持卡人证件号码
            ,ADDRESS                       --持卡人地址
            ,TEL                           --手机号码
            ,EXAMINE_STATUS                --审核状态0:未审核;1:审核通过;2:审核不通过;3:需再次审核
            ,EXAMINE_TIME                  --审核时间
            ,EXAMINE_STATUS_REMARK         --审核备注
            ,EXAMINE_EMP                   --审核人
            ,ENABLED                       --是否启用
            ,DATA_SIGN                     --数据签名
            ,DATA_SOURCE                   --数据来源1:界面录入;2:基础资料导入导出:3:数据迁移
            ,FLD_S1                        --结算账户的支出户名
            ,FLD_S2                        --字符型保留字段2
            ,FLD_S3                        --字符型保留字段3
            ,FLD_N1                        --是否收支分离
            ,FLD_N2                        --结算卡审核状态0:未提交审核,1:提交未审核,2:提交审核未通过,3:提交审核已通过,4:新增未审核
            ,FLD_N3                        --数值型保留字段3
            ,FLD_D1                        --日期型保留字段1
            ,CREATE_USER                   --创建用户
            ,CREATE_EMP                    --创建人
            ,CREATE_TIME                   --创建时间
            ,UPDATE_TIME                   --更新时间
            ,CHECK_AUTH                    --是否鉴权
            ,E_ACCOUNT_CODE                --电子账户
            ,ACCOUNT_EN_NAME               --开户人英文名
            ,ACCOUNT_EXPIRED_DATE          --开户人证件有效期
            ,ACCOUNT_POSTCODE              --邮编
            ,CHECK_AUTH3                   --3要素实名状态
            ,CHECK_AUTH4                   --4要素实名状态
            ,E_ACCOUNT_ENABLED             --是否开启电子账号
            ,SFT_MERCHANT_ID               --盛付通商户号
            ,FEE_CODE                      --费项代码
            ,FEE_CODE2                     --费项代码2
            ,SUBJECT_ACCOUNT               --科目账号
            ,UNIT_PROP                     --单位性质
            ,NEW_ACCOUNT_CODE              --新账号或主账号
            ,ACCOUNT_PROPERTIES            --轧差入账属性字段，按位使用
            ,NEW_REMIT_ACCOUNT_CODE        --新汇出方卡号
            ,POINT_PAYMENT                 --开通积分支付
            ,POINTS_OFFER                  --是否积分优惠
            ,START_DT                      --开始时间
            ,END_DT                        --结束时间
            ,ID_MARK                       --增删标志
            ,ETL_TIMESTAMP                 --ETL处理时间戳
  FROM IOL.V_AMSS_TRA_BANK_ACCOUNT --视图-银行结算账户表
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') 
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D';
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_AMSS_TRA_BANK_ACCOUNT', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IOL_AMSS_TRA_BANK_ACCOUNT;
/

