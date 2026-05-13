CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO
  *  功能描述：互联网贷款产品合作协议信息表
  *  创建日期：20251030
  *  开发人员：梅炜
  *  来源表： IOL.V_ICMS_HLW_LOAN_AGREEMENT_INFO
  *  目标表： O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251030  YJY     首次创建
  *             2    20251128  YJY     调整合作方类型
  *************************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送';  --默认写监管报送系统，有真实来源的按实际写 --来源系统
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-互联网贷款产品合作协议信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO NOLOGGING
    (SERIALNO                   --流水号
    ,PRODUCTID                  --产品编号
    ,PRODUCTNAME                --产品名称
    ,BELONGORGID                --所属机构
    ,AGREEMENTNO                --合作协议编号
    ,ISMAINAGREEMENT            --是否属于主协议
    ,MAINAGREEMENTNO            --对应的主合作协议编号
    ,COOPERATENAME              --合作方名称
    ,COOPERATECERTTYPE          --合作方证件类型
    ,COOPERATECERTID            --合作方证件号码
    ,COOPERATETYPE              --合作方类型
    ,COOPERATEMETHOD            --合作方式
    ,PROVIDECREDITMODEL         --提供增信的模式
    ,COOPERATEREGISTERADDRESS   --合作方注册地行政区划
    ,STARTDATE                  --合作协议起始日期
    ,MATURITYDATE               --合作协议到期日期
    ,ACTUALMATURITYDATE         --合作协议实际终止日期
    ,LIMITFLAG                  --限制标识
    ,COOPERATESTATUS            --协议状态
    ,OPERATIONTYPE              --数据操作类型:01-新增02-编辑
    ,OLDSERIALNO                --原数据流水号
    ,DATASTATUS                 --数据状态：01-启用；02-停用
    ,APPROVESTATUS              --流程状态
    ,INPUTUSERID                --登记人
    ,INPUTORGID                 --登记机构
    ,INPUTDATE                  --登记时间
    ,UPDATEUSERID               --更新人
    ,UPDATEORGID                --更新机构
    ,UPDATEDATE                 --更新时间
    ,INVESTMENTPROP             --对我行出资部分进行担保的比例
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,ETL_TIMESTAMP              --ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
         SERIALNO                   --流水号
        ,REPLACE(PRODUCTID,'/',',') PRODUCTID --产品编号
        ,PRODUCTNAME                --产品名称
        ,BELONGORGID                --所属机构
        ,AGREEMENTNO                --合作协议编号
        ,ISMAINAGREEMENT            --是否属于主协议
        ,MAINAGREEMENTNO            --对应的主合作协议编号
        ,COOPERATENAME              --合作方名称
        ,COOPERATECERTTYPE          --合作方证件类型
        ,COOPERATECERTID            --合作方证件号码
        ,CASE WHEN LENGTH(TRIM(COOPERATETYPE)) = 1 THEN '0'||COOPERATETYPE
              ELSE COOPERATETYPE
          END AS COOPERATETYPE      --合作方类型 MOD BY 20251128
        ,COOPERATEMETHOD            --合作方式
        ,PROVIDECREDITMODEL         --提供增信的模式
        ,COOPERATEREGISTERADDRESS   --合作方注册地行政区划
        ,STARTDATE                  --合作协议起始日期
        ,MATURITYDATE               --合作协议到期日期
        ,ACTUALMATURITYDATE         --合作协议实际终止日期
        ,LIMITFLAG                  --限制标识
        ,CASE WHEN LENGTH(TRIM(COOPERATESTATUS)) = 1 THEN '0'||COOPERATESTATUS
              ELSE COOPERATESTATUS
          END AS COOPERATESTATUS    --协议状态
        ,OPERATIONTYPE              --数据操作类型:01-新增02-编辑
        ,OLDSERIALNO                --原数据流水号
        ,TRIM(DATASTATUS) AS DATASTATUS --数据状态：01-启用；02-停用
        ,APPROVESTATUS              --流程状态
        ,INPUTUSERID                --登记人
        ,INPUTORGID                 --登记机构
        ,INPUTDATE                  --登记时间
        ,UPDATEUSERID               --更新人
        ,UPDATEORGID                --更新机构
        ,UPDATEDATE                 --更新时间
        ,INVESTMENTPROP             --对我行出资部分进行担保的比例
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
        ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IOL.V_ICMS_HLW_LOAN_AGREEMENT_INFO   --互联网贷款产品合作协议信息表_视图
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
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

END ETL_O_IOL_ICMS_HLW_LOAN_AGREEMENT_INFO;
/

