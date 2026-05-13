CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_IBANK_CNTPTY_INFO(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IML_PTY_IBANK_CNTPTY_INFO
  *  功能描述：同业交易对手信息表
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IML.V_PTY_IBANK_CNTPTY_INFO
  *  目标表： O_IML_PTY_IBANK_CNTPTY_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PTY_IBANK_CNTPTY_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业交易对手信息表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_PTY_IBANK_CNTPTY_INFO
    (ORG_CLS_CD           --机构分类代码
    ,DC_PAY_SYS_BANK_NO   --本币支付系统行号
    ,FIN_LICS_ID          --金融许可证编号
    ,PARTY_TYPE_CD        --当事人类型代码
    ,SRC_TABLE_NAME       --源表名称
    ,JOB_CD               --任务编码
    ,ORG_ID               --机构编号
    ,EN_FNAME             --英文全称
    ,LP_ID                --法人编号
    ,PARTY_CD_CERT_ID     --当事人代码证编号
    ,PARTY_CLS_DESCB      --当事人分类描述
    ,PARTY_PINYIN         --当事人拼音
    ,ETL_DT               --ETL处理日期
    ,PARTY_NAME           --当事人名称
    ,CREATE_DT            --创建日期
    ,ID_MARK              --增删标志
    ,PARTY_ID             --当事人编号
    ,MATN_ORG_NAME        --维护机构名称
    ,BUS_LICS_NUM         --营业执照号码
    ,PARTY_ALIAS          --当事人别名
    ,SPV_FLG              --SPV标志
    ,EN_NAME              --英文名称
    ,PARTY_FNAME          --当事人全称
    ,STATUS_CD            --状态代码
    ,FCURR_PAY_SYS_BANK_NO  --外币支付系统行号
    ,MATN_ORG_ID          --维护机构编号
    ,UPDATE_DT            --更新日期
    ,FOUND_DT             --成立日期
    ,RGST                 --注册地
    ,CUST_ID              --客户编号
    ,RWA_CUST_CLS_NAME    --RWA客户分类名称
    ,SRC_PARTY_ID         --源当事人编号
    ,SUPER_ORG_ID         --上级机构编号
    ,MAR_MAKER_FLG        --做市商标志
    ,ORG_LEV_CD           --机构级别代码
    )
  SELECT 
     ORG_CLS_CD           --机构分类代码
    ,DC_PAY_SYS_BANK_NO   --本币支付系统行号
    ,FIN_LICS_ID          --金融许可证编号
    ,PARTY_TYPE_CD        --当事人类型代码
    ,SRC_TABLE_NAME       --源表名称
    ,JOB_CD               --任务编码
    ,ORG_ID               --机构编号
    ,EN_FNAME             --英文全称
    ,LP_ID                --法人编号
    ,PARTY_CD_CERT_ID     --当事人代码证编号
    ,PARTY_CLS_DESCB      --当事人分类描述
    ,PARTY_PINYIN         --当事人拼音
    ,ETL_DT               --ETL处理日期
    ,PARTY_NAME           --当事人名称
    ,CREATE_DT            --创建日期
    ,ID_MARK              --增删标志
    ,PARTY_ID             --当事人编号
    ,MATN_ORG_NAME        --维护机构名称
    ,BUS_LICS_NUM         --营业执照号码
    ,PARTY_ALIAS          --当事人别名
    ,SPV_FLG              --SPV标志
    ,EN_NAME              --英文名称
    ,PARTY_FNAME          --当事人全称
    ,STATUS_CD            --状态代码
    ,FCURR_PAY_SYS_BANK_NO  --外币支付系统行号
    ,MATN_ORG_ID          --维护机构编号
    ,UPDATE_DT            --更新日期
    ,FOUND_DT             --成立日期
    ,RGST                 --注册地
    ,CUST_ID              --客户编号
    ,RWA_CUST_CLS_NAME    --RWA客户分类名称
    ,SRC_PARTY_ID         --源当事人编号
    ,SUPER_ORG_ID         --上级机构编号
    ,MAR_MAKER_FLG        --做市商标志
    ,ORG_LEV_CD           --机构级别代码
    FROM IML.V_PTY_IBANK_CNTPTY_INFO  --视图-同业交易对手信息表
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
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_PTY_IBANK_CNTPTY_INFO;
/

