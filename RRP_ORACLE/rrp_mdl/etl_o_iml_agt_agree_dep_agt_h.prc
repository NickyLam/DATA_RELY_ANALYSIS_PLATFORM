CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_AGREE_DEP_AGT_H(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_AGREE_DEP_AGT_H
  *  功能描述：协定存款协议历史
  *  创建日期：20230804
  *  开发人员：许晓滨
  *  来源表： IML.V_AGT_AGREE_DEP_AGT_H
  *  目标表： O_IML_AGT_AGREE_DEP_AGT_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230804  许晓滨   首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_AGREE_DEP_AGT_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_AGREE_DEP_AGT_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_AGREE_DEP_AGT_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-协定存款协议历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_AGREE_DEP_AGT_H
    (   AGT_ID                               --协议编号
       ,LP_ID                                --法人编号
       ,DEP_AGT_ID                           --存款协议编号
       ,SIGN_SEQ_NUM                         --签约序号
       ,EFFECT_DT                            --生效日期
       ,INVALID_DT                           --失效日期
       ,INT_CLS_CD                           --利息分类代码
       ,INT_RAT_TYPE_CD                      --利率类型代码
       ,PROD_ID                              --产品编号
       ,SIGN_AGT_STATUS_CD                   --签约协议状态代码
       ,ACCT_ID                              --账户编号
       ,CUST_ACCT_NUM                        --客户账号
       ,ACCT_PROD_ID                         --账户产品编号
       ,ACCT_CURR_CD                         --账户币种代码
       ,SUB_ACCT_NUM                         --子账号
       ,DEP_TENOR                            --存款期限
       ,TENOR_TYPE_CD                        --期限类型代码
       ,SUB_ACCT_FIX_INT_RAT                 --分户级固定利率
       ,SUB_ACCT_INT_RAT_FLOAT_RATIO         --分户级利率浮动比例
       ,SUB_ACCT_INT_RAT_FLOAT_POINT         --分户级利率浮动点数
       ,BANK_INT_INT_RAT                     --行内利率
       ,FLOAT_INT_RAT                        --浮动利率
       ,FILE_AMT                             --靠档金额
       ,MON_INT_ACCR_BASE_CD                 --月计息基准代码
       ,YEAR_INT_ACCR_BASE_CD                --年计息基准代码
       ,INT_ACCR_BASE_CD                     --计息基准代码
       ,CUST_ID                              --客户编号
       ,START_DT                             --开始时间
       ,END_DT                               --结束时间
       ,ID_MARK                              --增删标志
       ,SRC_TABLE_NAME                       --源表名称
       ,JOB_CD                               --任务编码
       ,ETL_TIMESTAMP                         --etl处理时间戳
    )
  SELECT 
        AGT_ID                               --协议编号
       ,LP_ID                                --法人编号
       ,DEP_AGT_ID                           --存款协议编号
       ,SIGN_SEQ_NUM                         --签约序号
       ,EFFECT_DT                            --生效日期
       ,INVALID_DT                           --失效日期
       ,INT_CLS_CD                           --利息分类代码
       ,INT_RAT_TYPE_CD                      --利率类型代码
       ,PROD_ID                              --产品编号
       ,SIGN_AGT_STATUS_CD                   --签约协议状态代码
       ,ACCT_ID                              --账户编号
       ,CUST_ACCT_NUM                        --客户账号
       ,ACCT_PROD_ID                         --账户产品编号
       ,ACCT_CURR_CD                         --账户币种代码
       ,SUB_ACCT_NUM                         --子账号
       ,DEP_TENOR                            --存款期限
       ,TENOR_TYPE_CD                        --期限类型代码
       ,SUB_ACCT_FIX_INT_RAT                 --分户级固定利率
       ,SUB_ACCT_INT_RAT_FLOAT_RATIO         --分户级利率浮动比例
       ,SUB_ACCT_INT_RAT_FLOAT_POINT         --分户级利率浮动点数
       ,BANK_INT_INT_RAT                     --行内利率
       ,FLOAT_INT_RAT                        --浮动利率
       ,FILE_AMT                             --靠档金额
       ,MON_INT_ACCR_BASE_CD                 --月计息基准代码
       ,YEAR_INT_ACCR_BASE_CD                --年计息基准代码
       ,INT_ACCR_BASE_CD                     --计息基准代码
       ,CUST_ID                              --客户编号
       ,START_DT                             --开始时间
       ,END_DT                               --结束时间
       ,ID_MARK                              --增删标志
       ,SRC_TABLE_NAME                       --源表名称
       ,JOB_CD                               --任务编码
       ,ETL_TIMESTAMP                         --etl处理时间戳
    FROM IML.V_AGT_AGREE_DEP_AGT_H  --视图-协定存款协议历史
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_AGREE_DEP_AGT_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_AGREE_DEP_AGT_H;
/

