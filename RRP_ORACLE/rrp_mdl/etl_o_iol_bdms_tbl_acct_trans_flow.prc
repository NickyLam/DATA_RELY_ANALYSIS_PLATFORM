CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_BDMS_TBL_ACCT_TRANS_FLOW(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_BDMS_TBL_ACCT_TRANS_FLOW
  *  功能描述：交易流水中间表
  *  创建日期：20230216
  *  开发人员：梅炜
  *  来源表： IOL.V_BDMS_TBL_ACCT_TRANS_FLOW
  *  目标表： O_IOL_BDMS_TBL_ACCT_TRANS_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230216  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_BDMS_TBL_ACCT_TRANS_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_BDMS_TBL_ACCT_TRANS_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_BDMS_TBL_ACCT_TRANS_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-交易流水中间表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_BDMS_TBL_ACCT_TRANS_FLOW NOLOGGING
    (ID      --主键
    ,SYSTID  --系统代号
    ,TRANDT  --交易日期
    ,BSNSSQ  --全局流水
    ,TRANSQ  --交易流水
    ,SERINO  --序号
    ,TRANBR  --交易机构编号
    ,ACCTBR  --账务机构编号
    ,PRCSCD  --交易码
    ,PRODCD  --解析产品
    ,LOANP1  --产品属性1
    ,LOANP2  --产品属性2
    ,LOANP3  --产品属性3
    ,LOANP4  --产品属性4
    ,LOANP5  --产品属性5
    ,LOANP6  --产品属性6
    ,LOANP7  --产品属性7
    ,LOANP8  --产品属性8
    ,LOANP9  --产品属性9
    ,EVETDN  --交易方向
    ,TRPRCD  --金额类型
    ,CRCYCD  --币种
    ,TRANAM  --交易金额
    ,CUSTCD  --客户号
    ,ACCTNO  --协议编号
    ,ASSIS0  --渠道
    ,ASSIS1  --可售产品
    ,ASSIS2  --辅助核算2
    ,ASSIS3  --辅助核算3
    ,ASSIS4  --辅助核算4
    ,ASSIS5  --辅助核算5
    ,ASSIS6  --辅助核算6
    ,ASSIS7  --辅助核算7
    ,ASSIS9  --辅助核算9
    ,DATEX0  --交易时间
    ,CHREX0  --交易用户
    ,CHREX1  --授权用户
    ,CHREX2  --冲正标志
    ,CHREX3  --冲抹原交易流水号
    ,DATEX1  --冲抹原交易日期
    ,BATCHNO  --数据文件批次号
    ,STATUS  --数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
    ,ERORCD  --错误码
    ,ERORTX  --错误信息
    ,LOANPA  --产品属性10
    ,CONTRACT_NO  --批次号
    ,DETAILS_ID   --明细ID
    ,TGLSCNT      --发送核算中台批次
    ,TGLS_END_CNT --发送核算中台日终批次
    ,END_STATUS   --日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
    ,FILE_NAME    --发送核算中台文件名称
    ,DRAFT_NUMBER --票据号码
    ,START_DT     --开始时间
    ,END_DT       --结束时间
    ,ID_MARK      --增删标志
    ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
     ID      --主键
    ,SYSTID  --系统代号
    ,TRANDT  --交易日期
    ,BSNSSQ  --全局流水
    ,TRANSQ  --交易流水
    ,SERINO  --序号
    ,TRANBR  --交易机构编号
    ,ACCTBR  --账务机构编号
    ,PRCSCD  --交易码
    ,PRODCD  --解析产品
    ,LOANP1  --产品属性1
    ,LOANP2  --产品属性2
    ,LOANP3  --产品属性3
    ,LOANP4  --产品属性4
    ,LOANP5  --产品属性5
    ,LOANP6  --产品属性6
    ,LOANP7  --产品属性7
    ,LOANP8  --产品属性8
    ,LOANP9  --产品属性9
    ,EVETDN  --交易方向
    ,TRPRCD  --金额类型
    ,CRCYCD  --币种
    ,TRANAM  --交易金额
    ,CUSTCD  --客户号
    ,ACCTNO  --协议编号
    ,ASSIS0  --渠道
    ,ASSIS1  --可售产品
    ,ASSIS2  --辅助核算2
    ,ASSIS3  --辅助核算3
    ,ASSIS4  --辅助核算4
    ,ASSIS5  --辅助核算5
    ,ASSIS6  --辅助核算6
    ,ASSIS7  --辅助核算7
    ,ASSIS9  --辅助核算9
    ,DATEX0  --交易时间
    ,CHREX0  --交易用户
    ,CHREX1  --授权用户
    ,CHREX2  --冲正标志
    ,CHREX3  --冲抹原交易流水号
    ,DATEX1  --冲抹原交易日期
    ,BATCHNO  --数据文件批次号
    ,STATUS  --数据状态(00-数据保存，01-数据发送，02-数据发送失败，03-数据反馈成功，04-数据反馈失败)
    ,ERORCD  --错误码
    ,ERORTX  --错误信息
    ,LOANPA  --产品属性10
    ,CONTRACT_NO  --批次号
    ,DETAILS_ID   --明细ID
    ,TGLSCNT      --发送核算中台批次                                     
    ,TGLS_END_CNT --发送核算中台日终批次
    ,END_STATUS   --日终反馈状态(01-日终状态发送，02-日终状态反馈失败，03-日终状态反馈成功)
    ,FILE_NAME    --发送核算中台文件名称
    ,DRAFT_NUMBER --票据号码
    ,START_DT     --开始时间
    ,END_DT       --结束时间
    ,ID_MARK      --增删标志
    ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_BDMS_TBL_ACCT_TRANS_FLOW   --交易流水中间表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D' --MOD BY YJY 20250610
     ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_BDMS_TBL_ACCT_TRANS_FLOW;
/

