CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_INTSTL_PARTY(I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IML_PTY_INTSTL_PARTY
  *  功能描述：国结当事人
  *  创建日期：20220317
  *  开发人员：易梓林
  *  来源表： IML.V_PTY_INTSTL_PARTY
  *  目标表： O_IML_PTY_INTSTL_PARTY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220317  易梓林   首次创建
  *             2    20251106  YJY      新增跨境电商标志
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PTY_INTSTL_PARTY'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PTY_INTSTL_PARTY'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_INTSTL_PARTY';
  DELETE FROM RRP_MDL.O_IML_PTY_INTSTL_PARTY T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-国结当事人';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PTY_INTSTL_PARTY NOLOGGING
    (PARTY_ID                   --当事人编号
    ,LP_ID                      --法人编号
    ,CUST_ID                    --客户编号
    ,CUST_NAME                  --客户名称
    ,CN_NAME                    --中文名称
    ,INTSTL_CUST_TYPE_CD_COMB   --国结客户类型代码组合
    ,HQ_PARTY_ID                --总行当事人编号
    ,NATION_CRDT_LEVEL_CD       --国家的信用等级代码
    ,RISK_LEVEL_CD              --风险等级代码
    ,RISK_CTY_CD                --风险国家代码
    ,TRANS_LANG_CD              --传输语言代码
    ,EDIT_ID                    --版本编号
    ,SERV_LEVEL_CD              --服务等级代码
    ,ENTY_GROUP_ID              --实体组编号
    ,ORGNZ_CD                   --组织机构代码
    ,CERT_TYPE_CD               --证件类型代码
    ,CERT_NO                    --证件号码
    ,RESDNT_TYPE_CD             --居民类型代码
    ,BELONG_ORG_ID              --所属机构编号
    ,TRAN_MAIN_CD               --交易主体代码
    ,SRC_PARTY_ID               --源当事人编号
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,CBEC_FLG                   --跨境电商标志  ADD BY YJY 20251106
    )
  SELECT /*+PARALLEL*/
     PARTY_ID                   --当事人编号
    ,LP_ID                      --法人编号
    ,CUST_ID                    --客户编号
    ,CUST_NAME                  --客户名称
    ,CN_NAME                    --中文名称
    ,INTSTL_CUST_TYPE_CD_COMB   --国结客户类型代码组合
    ,HQ_PARTY_ID                --总行当事人编号
    ,NATION_CRDT_LEVEL_CD       --国家的信用等级代码
    ,RISK_LEVEL_CD              --风险等级代码
    ,RISK_CTY_CD                --风险国家代码
    ,TRANS_LANG_CD              --传输语言代码
    ,EDIT_ID                    --版本编号
    ,SERV_LEVEL_CD              --服务等级代码
    ,ENTY_GROUP_ID              --实体组编号
    ,ORGNZ_CD                   --组织机构代码
    ,CERT_TYPE_CD               --证件类型代码
    ,CERT_NO                    --证件号码
    ,RESDNT_TYPE_CD             --居民类型代码
    ,BELONG_ORG_ID              --所属机构编号
    ,TRAN_MAIN_CD               --交易主体代码
    ,SRC_PARTY_ID               --源当事人编号
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,CBEC_FLG                   --跨境电商标志  ADD BY YJY 20251106
    FROM IML.V_PTY_INTSTL_PARTY  --国结当事人_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    AND ID_MARK <> 'D';

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

END ETL_O_IML_PTY_INTSTL_PARTY;
/

