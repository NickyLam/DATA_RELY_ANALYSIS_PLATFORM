CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_GUAR_CONT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_GUAR_CONT
  *  功能描述：担保合同
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_GUAR_CONT
  *  目标表： O_ICL_CMM_GUAR_CONT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_GUAR_CONT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_GUAR_CON'; --表名
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_GUAR_CONT ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_GUAR_CONT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-担保合同';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_GUAR_CONT
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,GUAR_CONT_ID  --担保合同编号
      ,GUAR_CONT_TYPE_CD  --担保合同类型代码
      ,GUAR_WAY_CD  --担保方式代码
      ,GUAR_KIND_CD  --保证种类代码
      ,STATUS_CD  --状态代码
      ,SIGN_DT  --签订日期
      ,EFFECT_DT  --生效日期
      ,EXP_DT  --到期日期
      ,CUST_ID  --客户编号
      ,GUARTOR_ID  --担保人编号
      ,GUARTOR_NAME  --担保人名称
      ,GUARTOR_CERT_TYPE_CD  --担保人证件类型代码
      ,GUARTOR_CERT_NO  --担保人证件号码
      ,BRWER_RELA_CD  --与借款人关系代码
      ,CURR_CD  --币种代码
      ,GUAR_AMT  --担保金额
      ,OCUP_AMT  --占用金额
      ,GUAR_START_DT  --担保起始日期
      ,GUAR_EXP_DT  --担保到期日期
      ,GUAR_TENOR  --担保期限
      ,PRI_CONTR_ID  --主合同编号
      ,PRI_CONTR_TYPE_CD  --主合同类型代码
      ,OCUP_GUAR_LMT_FLG  --占用担保额度标志
      ,GUAR_RANGE_CD  --担保范围代码
      ,GCUST_FLG  --代保管标志
      ,OBG_ID  --权利人编号
      ,OBG_NAME  --权利人名称
      ,DIR_GUAR_FLG  --直接向我行担保标志
      ,CUST_MGR_ID  --客户经理编号
      ,DIRECTOR_ORG_ID  --主管机构编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,RGST_ORG_ID  --登记机构编号
      ,RGSTRAT_ID  --登记人员编号
      ,RGST_DT  --登记日期
      ,UPDATE_PERSON_ID  --更新人员编号
      ,UPDATE_DT  --更新日期
      ,GUAR_TYPE_CLS_CD  --担保类型分类代码
      ,GUARTOR_NATNAL_ECON_DEPT_TYPE_CD  --担保人国民经济部门类型代码
      ,GUARTOR_INDUS_TYPE_CD  --担保人行业类型代码
      ,GUARTOR_DIST_CD  --担保人行政区划代码
      ,GUARTOR_CORP_SIZE_CD  --担保人企业规模代码
      ,REV_GUAR_MEASURE_FLG  --反担保措施标志
      ,GUAR_CONT_NAME  --担保合同名称
      ,JOB_CD --任务代码
      ,GUARTOR_CTY_RG_CD --担保人国家和地区代码
      ,GOVER_FIN_GUAR_CORP_GUAR_FLG --政府性融资担保公司保证标志
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,GUAR_CONT_ID  --担保合同编号
      ,GUAR_CONT_TYPE_CD  --担保合同类型代码
      ,GUAR_WAY_CD  --担保方式代码
      ,GUAR_KIND_CD  --保证种类代码
      ,STATUS_CD  --状态代码
      ,SIGN_DT  --签订日期
      ,EFFECT_DT  --生效日期
      ,EXP_DT  --到期日期
      ,CUST_ID  --客户编号
      ,GUARTOR_ID  --担保人编号
      ,GUARTOR_NAME  --担保人名称
      ,GUARTOR_CERT_TYPE_CD  --担保人证件类型代码
      ,GUARTOR_CERT_NO  --担保人证件号码
      ,BRWER_RELA_CD  --与借款人关系代码
      ,CURR_CD  --币种代码
      ,GUAR_AMT  --担保金额
      ,OCUP_AMT  --占用金额
      ,GUAR_START_DT  --担保起始日期
      ,GUAR_EXP_DT  --担保到期日期
      ,GUAR_TENOR  --担保期限
      ,PRI_CONTR_ID  --主合同编号
      ,PRI_CONTR_TYPE_CD  --主合同类型代码
      ,OCUP_GUAR_LMT_FLG  --占用担保额度标志
      ,GUAR_RANGE_CD  --担保范围代码
      ,GCUST_FLG  --代保管标志
      ,OBG_ID  --权利人编号
      ,OBG_NAME  --权利人名称
      ,DIR_GUAR_FLG  --直接向我行担保标志
      ,CUST_MGR_ID  --客户经理编号
      ,DIRECTOR_ORG_ID  --主管机构编号
      ,ACCT_INSTIT_ID  --账务机构编号
      ,RGST_ORG_ID  --登记机构编号
      ,RGSTRAT_ID  --登记人员编号
      ,RGST_DT  --登记日期
      ,UPDATE_PERSON_ID  --更新人员编号
      ,UPDATE_DT  --更新日期
      ,GUAR_TYPE_CLS_CD  --担保类型分类代码
      ,GUARTOR_NATNAL_ECON_DEPT_TYPE_CD  --担保人国民经济部门类型代码
      ,GUARTOR_INDUS_TYPE_CD  --担保人行业类型代码
      ,GUARTOR_DIST_CD  --担保人行政区划代码
      ,GUARTOR_CORP_SIZE_CD  --担保人企业规模代码
      ,REV_GUAR_MEASURE_FLG  --反担保措施标志
      ,GUAR_CONT_NAME  --担保合同名称
    ,JOB_CD --任务代码
    ,GUARTOR_CTY_RG_CD --担保人国家和地区代码
    ,GOVER_FIN_GUAR_CORP_GUAR_FLG --政府性融资担保公司保证标志
    FROM ICL.V_CMM_GUAR_CONT  --视图-担保合同
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

  END ETL_INIT_O_ICL_CMM_GUAR_CONT;
/

