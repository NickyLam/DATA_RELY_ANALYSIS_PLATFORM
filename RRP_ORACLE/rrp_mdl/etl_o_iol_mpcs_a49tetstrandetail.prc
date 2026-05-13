CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_MPCS_A49TETSTRANDETAIL(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_MPCS_A49TETSTRANDETAIL
  *  功能描述：社保费明细表
  *  创建日期：20240814
  *  开发人员：YJY
  *  来源表：
  *  目标表： O_IOL_MPCS_A49TETSTRANDETAIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240814  YJY    首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_MPCS_A49TETSTRANDETAIL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_MPCS_A49TETSTRANDETAIL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IOL_MPCS_A49TETSTRANDETAIL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_MPCS_A49TETSTRANDETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-社保费明细表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_MPCS_A49TETSTRANDETAIL
    (MQINSEQ                --中台流水号
    ,CLEARTYPE              --清算模式：BXT201 实时，PETS02批量
    ,CLEARDATE              --ETS资金对数日期
    ,SEQNO                  --序号
    ,ORIGCD                 --征收机关代码
    ,COMMITDATE             --提交日期
    ,ORIGCDSEQNO            --征收机关流水号
    ,OPENBANKNO             --经收处商业银行号
    ,SAPBANKNO              --经收处清算支付行号
    ,TRANTYPE               --交易类型
    ,PAYERACCTNO            --付款账号
    ,TAXINAME               --纳税人名称
    ,TXPYCD                 --纳税人识别号
    ,TXPYNA                 --附加信息
    ,DETAILNO               --扣款明细顺序号
    ,ITEMCD                 --预算外科目
    ,ITEMNM                 --预算外科目名称
    ,RECVBANKNO             --代理财政专户银行的支付行号
    ,INNERPAYERACCTNO       --内部付款账号
    ,INNERPAYERACCTNAME     --内部付款户名
    ,PAYEEACCTNO            --财政专户账号
    ,PAYEEACCTNAME          --财政专户户名
    ,AMOUNT                 --明细金额
    ,TAXNAME                --税种名称
    ,PINMUNA                --品目名称
    ,TAXDATE                --所属时期
    ,ADDINFO                --密押/附言
    ,HOSTNBR                --核心流水号
    ,GLOBALSEQNO            --全局流水号
    ,INSERTTIME             --登记时间
    ,MAGEBRN                --管理机构
    ,START_DT               --开始时间
    ,END_DT                 --结束时间
    ,ID_MARK                --增删标志
    ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT MQINSEQ                --中台流水号
        ,CLEARTYPE              --清算模式：BXT201 实时，PETS02批量
        ,CLEARDATE              --ETS资金对数日期
        ,SEQNO                  --序号
        ,ORIGCD                 --征收机关代码
        ,COMMITDATE             --提交日期
        ,ORIGCDSEQNO            --征收机关流水号
        ,OPENBANKNO             --经收处商业银行号
        ,SAPBANKNO              --经收处清算支付行号
        ,TRANTYPE               --交易类型
        ,PAYERACCTNO            --付款账号
        ,TAXINAME               --纳税人名称
        ,TXPYCD                 --纳税人识别号
        ,TXPYNA                 --附加信息
        ,DETAILNO               --扣款明细顺序号
        ,ITEMCD                 --预算外科目
        ,ITEMNM                 --预算外科目名称
        ,RECVBANKNO             --代理财政专户银行的支付行号
        ,INNERPAYERACCTNO       --内部付款账号
        ,INNERPAYERACCTNAME     --内部付款户名
        ,PAYEEACCTNO            --财政专户账号
        ,PAYEEACCTNAME          --财政专户户名
        ,AMOUNT                 --明细金额
        ,TAXNAME                --税种名称
        ,PINMUNA                --品目名称
        ,TAXDATE                --所属时期
        ,ADDINFO                --密押/附言
        ,HOSTNBR                --核心流水号
        ,GLOBALSEQNO            --全局流水号
        ,INSERTTIME             --登记时间
        ,MAGEBRN                --管理机构
        ,START_DT               --开始时间
        ,END_DT                 --结束时间
        ,ID_MARK                --增删标志
        ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_MPCS_A49TETSTRANDETAIL --视图-社保费明细表
   WHERE ID_MARK <> 'D';

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

END ETL_O_IOL_MPCS_A49TETSTRANDETAIL;
/

