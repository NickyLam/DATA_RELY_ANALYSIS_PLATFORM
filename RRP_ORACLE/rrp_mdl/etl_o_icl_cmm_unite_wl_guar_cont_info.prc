CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO(I_P_DATE IN INTEGER,
                                                                  O_ERRCODE OUT VARCHAR2
                                                                  )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO
  *  功能描述：联合网贷担保合同信息
  *  创建日期：20231009
  *  开发人员：HULIJUAN
  *  来源表： ICL.V_CMM_UNITE_WL_GUAR_CONT_INFO
  *  目标表： O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期   修改人      修改原因
  *             1    20231009   HULIJUAN    首次创建
  *             2    20250820   YJY         针对分期乐产品做接数处理，按照t天进行获取
  *             3    20251126   YJY         调整脚本
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-联合网贷担保合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO
    (ETL_DT                         --数据日期
    ,LP_ID                          --法人编号
    ,GUAR_CONT_ID                   --担保合同编号
    ,GUAR_CONT_TYPE_CD              --担保合同类型代码
    ,GUAR_WAY_CD                    --担保方式代码
    ,GUAR_KIND_CD                   --保证种类代码
    ,STATUS_CD                      --状态代码
    ,CURR_CD                        --币种代码
    ,SIGN_DT                        --签订日期
    ,EFFECT_DT                      --生效日期
    ,EXP_DT                         --到期日期
    ,CUST_ID                        --客户编号
    ,GUARTOR_CUST_ID                --担保人客户编号
    ,GUARTOR_NAME                   --担保人名称
    ,GUARTOR_CERT_TYPE_CD           --担保人证件类型代码
    ,GUARTOR_CERT_NO                --担保人证件号码
    ,GUAR_AMT                       --担保金额
    ,GOVER_FIN_GUAR_CORP_GUAR_FLG   --政府性融资担保公司保证标志
    ,REV_GUAR_FLG                   --反担保标志
    ,GUAR_ORG_NAME                  --担保机构名称
    ,GUAR_ITEM_PROMIS_ID            --担保事项承诺书编号
    ,RGST_ORG_ID                    --登记机构编号
    ,RGSTRAT_ID                     --登记人编号
    ,RGST_DT                        --登记日期
    ,JOB_CD                         --任务代码
    ,ETL_TIMESTAMP                  --数据处理时间
    )
  SELECT /*ETL_DT + 1*/TO_DATE(V_P_DATE,'YYYYMMDD')   --数据日期  MOD BY YJY 20250820
        ,LP_ID                          --法人编号
        ,GUAR_CONT_ID                   --担保合同编号
        ,GUAR_CONT_TYPE_CD              --担保合同类型代码
        ,GUAR_WAY_CD                    --担保方式代码
        ,GUAR_KIND_CD                   --保证种类代码
        ,STATUS_CD                      --状态代码
        ,CURR_CD                        --币种代码
        ,SIGN_DT                        --签订日期
        ,EFFECT_DT                      --生效日期
        ,EXP_DT                         --到期日期
        ,CUST_ID                        --客户编号
        ,GUARTOR_CUST_ID                --担保人客户编号
        ,GUARTOR_NAME                   --担保人名称
        ,GUARTOR_CERT_TYPE_CD           --担保人证件类型代码
        ,GUARTOR_CERT_NO                --担保人证件号码
        ,GUAR_AMT                       --担保金额
        ,GOVER_FIN_GUAR_CORP_GUAR_FLG   --政府性融资担保公司保证标志
        ,REV_GUAR_FLG                   --反担保标志
        ,GUAR_ORG_NAME                  --担保机构名称
        ,GUAR_ITEM_PROMIS_ID            --担保事项承诺书编号
        ,RGST_ORG_ID                    --登记机构编号
        ,RGSTRAT_ID                     --登记人编号
        ,RGST_DT                        --登记日期
        ,JOB_CD                         --任务代码
        ,ETL_TIMESTAMP                  --数据处理时间
    FROM ICL.V_CMM_UNITE_WL_GUAR_CONT_INFO  --视图-联合网贷担保合同信息
   WHERE --ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1;
        (GUAR_CONT_ID NOT LIKE 'LX%' AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1) --其他联合网贷依旧按照t-1接数
      OR (GUAR_CONT_ID  LIKE 'LX%' AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --分期乐乐金卡202010200011、分期乐消费202010200010担保合同号是LX开头的，按照t接数  MOD BY YJY 20250820
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO','', O_ERRCODE);

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

END ETL_O_ICL_CMM_UNITE_WL_GUAR_CONT_INFO;
/

