CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_TGLS_GLA_VCHR_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IOL_TGLS_GLA_VCHR_H
  *  功能描述：传票信息历史表
  *  创建日期：20230115
  *  开发人员：MW
  *  来源表： IOL.V_TGLS_GLA_VCHR_H
  *  目标表： O_IOL_TGLS_GLA_VCHR_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230115  MW     首次创建
  ***************************************************************************/
AS
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_TGLS_GLA_VCHR_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_TGLS_GLA_VCHR_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_TGLS_GLA_VCHR_H';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-传票信息历史表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_TGLS_GLA_VCHR_H
    (STACID  --账套标记
    ,SYSTID  --来源系统编号
    ,TRANDT  --交易日期
    ,TRANSQ  --交易流水
    ,VCHRSQ  --凭证序号
    ,TRANBR  --交易机构编号
    ,ACCTBR  --账务机构编号
    ,ITEMCD  --科目编号
    ,CRCYCD  --币种代码
    ,IOFLAG  --表内外标志
    ,CENTCD  --责任中心
    ,PRSNCD  --员工编号
    ,CUSTCD  --客户编号
    ,PRDUCD  --产品编号
    ,PRLNCD  --产品线
    ,ACCTNO  --账户
    ,TRANTP  --交易类型
    ,AMNTCD  --借贷方向
    ,TRANAM  --交易金额
    ,TRANBL  --交易余额
    ,BLNCDN  --当前科目余额方向
    ,SMRYTX  --摘要
    ,EXCHCN  --中间价
    ,EXCHUS  --折算汇率
    ,USERCD  --用户代码
    ,SOURDT  --源系统日期
    ,SOURSQ  --源系统流水
    ,SOURST  --源系统标识
    ,SRVCSQ  --源交易流水序号
    ,BEARBL  --承前余额
    ,BEARDN  --承前科目余额方向
    ,TOITEM  --对方科目编号
    ,ASSIS0  --渠道编号
    ,ASSIS1  --产品编号
    ,ASSIS2  --辅助核算2（自定义）
    ,ASSIS3  --辅助核算3（自定义）
    ,ASSIS4  --辅助核算4（自定义）
    ,ASSIS5  --辅助核算5（自定义）
    ,ASSIS6  --辅助核算6（自定义）
    ,ASSIS7  --辅助核算7（自定义）
    ,ASSIS8  --辅助核算8（自定义）
    ,ASSIS9  --辅助核算9（自定义）
    ,TRANNO  --交易流水序号
    ,CLERTG  --清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
    ,CLEROD  --清算批次
    ,CENTSQ  --清算行流水
    ,BRCHSQ  --账户行流水
    ,CLERDT  --清算日期
    ,TRANST  --交易状态
    ,SUBSAC  --子户码
    ,SOURAC  --源账套
    ,STRKST  --冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
    ,ODBSDT  --原业务日期（被冲正业务日期）
    ,ODBSSQ  --原业务流水（被冲正业务流水）
    ,BATHID  --批次号
    ,TRANTI  --时间戳
    ,SMRYCD  --摘要编码
    ,DCMTNO  --凭证编号
    ,BSNSSQ  --BSNSSQ
    ,FOLDCN  --FOLDCN
    ,ITEMNA  --科目名称
    ,ISTBGZ  --是否已同步关账0未同步1同步
    ,ETL_DT  --ETL处理日期
    ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT STACID  --账套标记
        ,SYSTID  --来源系统编号
        ,TRANDT  --交易日期
        ,TRANSQ  --交易流水
        ,VCHRSQ  --凭证序号
        ,TRANBR  --交易机构编号
        ,ACCTBR  --账务机构编号
        ,ITEMCD  --科目编号
        ,CRCYCD  --币种代码
        ,IOFLAG  --表内外标志
        ,CENTCD  --责任中心
        ,PRSNCD  --员工编号
        ,CUSTCD  --客户编号
        ,PRDUCD  --产品编号
        ,PRLNCD  --产品线
        ,ACCTNO  --账户
        ,TRANTP  --交易类型
        ,AMNTCD  --借贷方向
        ,TRANAM  --交易金额
        ,TRANBL  --交易余额
        ,BLNCDN  --当前科目余额方向
        ,SMRYTX  --摘要
        ,EXCHCN  --中间价
        ,EXCHUS  --折算汇率
        ,USERCD  --用户代码
        ,SOURDT  --源系统日期
        ,SOURSQ  --源系统流水
        ,SOURST  --源系统标识
        ,SRVCSQ  --源交易流水序号
        ,BEARBL  --承前余额
        ,BEARDN  --承前科目余额方向
        ,TOITEM  --对方科目编号
        ,ASSIS0  --渠道编号
        ,ASSIS1  --产品编号
        ,ASSIS2  --辅助核算2（自定义）
        ,ASSIS3  --辅助核算3（自定义）
        ,ASSIS4  --辅助核算4（自定义）
        ,ASSIS5  --辅助核算5（自定义）
        ,ASSIS6  --辅助核算6（自定义）
        ,ASSIS7  --辅助核算7（自定义）
        ,ASSIS8  --辅助核算8（自定义）
        ,ASSIS9  --辅助核算9（自定义）
        ,TRANNO  --交易流水序号
        ,CLERTG  --清算状态：0未清算，1待清算，2已清算，3不参与清算，4清算传票
        ,CLEROD  --清算批次
        ,CENTSQ  --清算行流水
        ,BRCHSQ  --账户行流水
        ,CLERDT  --清算日期
        ,TRANST  --交易状态
        ,SUBSAC  --子户码
        ,SOURAC  --源账套
        ,STRKST  --冲正状态（0、正常交易1、该交易已被冲正9、该交易为冲正交易）
        ,ODBSDT  --原业务日期（被冲正业务日期）
        ,ODBSSQ  --原业务流水（被冲正业务流水）
        ,BATHID  --批次号
        ,TRANTI  --时间戳
        ,SMRYCD  --摘要编码
        ,DCMTNO  --凭证编号
        ,BSNSSQ  --BSNSSQ
        ,FOLDCN  --FOLDCN
        ,ITEMNA  --科目名称
        ,ISTBGZ  --是否已同步关账0未同步1同步
        ,ETL_DT  --ETL处理日期
        ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_TGLS_GLA_VCHR_H --视图-传票信息历史表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IOL_TGLS_GLA_VCHR_H;
/

