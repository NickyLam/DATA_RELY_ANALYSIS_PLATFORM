CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ISBS_OPPNET(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ISBS_OPPNET
  *  功能描述：国结对手方信息表
  *  创建日期：20230112
  *  开发人员：梅炜
  *  来源表： IOL.V_ISBS_OPPNET
  *  目标表： O_IOL_ISBS_OPPNET
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230112  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                 --处理步骤
  V_P_DATE    VARCHAR2(8);                  --跑批数据日期
  V_STARTTIME DATE;                         --处理开始时间
  V_ENDTIME   DATE;                         --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                 --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ISBS_OPPNET'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';   --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_ISBS_OPPNET T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ISBS_OPPNET';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-国结对手方信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ISBS_OPPNET
    (INR                             --主键INR
    ,GLTYP                           --接口表
    ,GLINR                           --接口表的INR
    ,GLDATE                          --记账日期
    ,TRNINR                          --TRN表的INR
    ,CORE_TRAN_FLOW_NUM              --全局流水号
    ,BIZ_SEQ_NUM                     --系统流水号
    ,BIZ_SEQ_NO                      --交易序号
    ,BIZ_CCY                         --币种
    ,BIZ_AMT                         --金额
    ,PTY_EXTKEY                      --分录账号的客户号
    ,PTY_NAME                        --分录账号的名称
    ,PTY_ACCT_NUM                    --分录账号
    ,PTY_ACCT_NO                     --分录账号序号
    ,TRAN_TYPE                       --借贷方向
    ,TX_CNTPTY_ACCT_NUM              --交易对手账号
    ,TX_CNTPTY_NAME                  --交易对手名称
    ,CNTPTY_FIN_INST_BRAC_CD         --交易对手行号
    ,CNTPTY_FIN_INST_BRAC_NAME       --交易对手行名
    ,DIST                            --对手银行所在地行政区划
    ,TX_CNTPTY_CERT_TYPE             --交易对手证件类型
    ,TX_CNTPTY_CERT_TYPE_TXT         --交易对手证件类型中文描述
    ,TX_CNTPTY_CERT_NO               --交易对手证件号码
    ,CD_TYP                          --交易对手行号类型
    ,START_DT                        --开始时间
    ,END_DT                          --结束时间
    ,ID_MARK                         --增删标志
    ,ETL_TIMESTAMP                   --ETL处理时间戳
    )
  SELECT INR                             --主键INR
        ,GLTYP                           --接口表
        ,GLINR                           --接口表的INR
        ,GLDATE                          --记账日期
        ,TRNINR                          --TRN表的INR
        ,CORE_TRAN_FLOW_NUM              --全局流水号
        ,BIZ_SEQ_NUM                     --系统流水号
        ,BIZ_SEQ_NO                      --交易序号
        ,BIZ_CCY                         --币种
        ,BIZ_AMT                         --金额
        ,PTY_EXTKEY                      --分录账号的客户号
        ,PTY_NAME                        --分录账号的名称
        ,PTY_ACCT_NUM                    --分录账号
        ,PTY_ACCT_NO                     --分录账号序号
        ,TRAN_TYPE                       --借贷方向
        ,TX_CNTPTY_ACCT_NUM              --交易对手账号
        ,TX_CNTPTY_NAME                  --交易对手名称
        ,CNTPTY_FIN_INST_BRAC_CD         --交易对手行号
        ,CNTPTY_FIN_INST_BRAC_NAME       --交易对手行名
        ,DIST                            --对手银行所在地行政区划
        ,TX_CNTPTY_CERT_TYPE             --交易对手证件类型
        ,TX_CNTPTY_CERT_TYPE_TXT         --交易对手证件类型中文描述
        ,TX_CNTPTY_CERT_NO               --交易对手证件号码
        ,CD_TYP                          --交易对手行号类型
        ,START_DT                        --开始时间
        ,END_DT                          --结束时间
        ,ID_MARK                         --增删标志
        ,ETL_TIMESTAMP                   --ETL处理时间戳
    FROM IOL.V_ISBS_OPPNET  --视图-国结对手方信息表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'; --MOD BY YJY 20250610

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

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

END ETL_O_IOL_ISBS_OPPNET;
/

