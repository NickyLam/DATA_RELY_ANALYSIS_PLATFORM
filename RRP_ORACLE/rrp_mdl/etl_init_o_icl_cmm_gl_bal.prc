CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_GL_BAL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_GL_BAL
  *  功能描述：总账余额
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_GL_BAL
  *  目标表： O_ICL_CMM_GL_BAL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_GL_BAL'; -- 程序名称
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
  V_TAB_NAME := 'O_ICL_CMM_GL_BAL'; --表名

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_GL_BAL ;
 --  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_GL_BAL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-总账余额';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_GL_BAL
  (
             ETL_DT  --数据日期
            ,LP_ID  --法人编号
            ,ACCT_SET_ID  --账套编号
            ,ACCT_DURAN  --账务期间
            ,ACCT_COMB_ID  --账户组合编号
            ,STD_PROD_ID  --标准产品编号
            ,TRAN_CHN_CD  --交易渠道代码
            ,CURR_CD  --币种代码
            ,ORG_ID  --机构编号
            ,SUBJ_ID  --科目编号
            ,SUBJ_NAME  --科目名称
            ,BUDGET_SUBJ_ID  --预算科目编号
            ,SUBJ_LEV_CD  --科目级别代码
            ,SUBJ_DIR_CD  --科目方向代码
            ,SUBJ_CHAR_CD  --科目性质代码
            ,DATA_SRC_CD  --数据来源代码
            ,TD_BAL_DIR_CD  --本日余额方向代码
            ,IN_OUT_TAB_FLG  --表内外标志
            ,DTL_SUBJ_FLG  --明细科目标志
            ,YD_OC_DR_BAL  --昨日原币借方余额
            ,YD_OC_CR_BAL  --昨日原币贷方余额
            ,YD_DC_DR_BAL  --昨日本币借方余额
        		,YD_DC_CR_BAL  --昨日本币贷方余额
						,TD_OC_BAL  --本日原币余额
						,TD_OC_DR_BAL  --本日原币借方余额
						,TD_OC_CR_BAL  --本日原币贷方余额
						,TD_DC_DR_BAL  --本日本币借方余额
						,TD_DC_CR_BAL  --本日本币贷方余额
						,TD_OC_DR_AMT  --本日原币借方发生额
						,TD_OC_CR_AMT  --本日原币贷方发生额
						,TD_DC_DR_AMT  --本日本币借方发生额
						,TD_DC_CR_AMT  --本日本币贷方发生额
						,TEN_DYS_BG_DR_OC_BAL  --旬初借方原币余额
						,TEN_DYS_BG_CR_OC_BAL  --旬初贷方原币余额
						,TEN_DYS_BG_DR_DC_BAL  --旬初借方本币余额
						,TEN_DYS_BG_CR_DC_BAL  --旬初贷方本币余额
						,TEN_DYS_BG_OC_DR_AMT  --旬原币借方发生额
						,TEN_DYS_BG_OC_CR_AMT  --旬原币贷方发生额
						,TEN_DYS_BG_DC_DR_AMT  --旬本币借方发生额
						,TEN_DYS_BG_DC_CR_AMT  --旬本币贷方发生额
						,EAR_M_DR_OC_BAL  --月初借方原币余额
						,EAR_M_CR_OC_BAL  --月初贷方原币余额
						,EAR_M_DR_DC_BAL  --月初借方本币余额
						,EAR_M_CR_DC_BAL  --月初贷方本币余额
						,MON_OC_DR_AMT  --月原币借方发生额
						,MON_OC_CR_AMT  --月原币贷方发生额
						,MON_DC_DR_AMT  --月本币借方发生额
						,MON_DC_CR_AMT  --月本币贷方发生额
						,EAR_S_DR_OC_BAL  --季初借方原币余额
						,EAR_S_CR_OC_BAL  --季初贷方原币余额
						,EAR_S_DR_DC_BAL  --季初借方本币余额
						,EAR_S_CR_DC_BAL  --季初贷方本币余额
						,SSN_OC_DR_AMT  --季原币借方发生额
						,SSN_OC_CR_AMT  --季原币贷方发生额
						,SSN_DC_DR_AMT  --季本币借方发生额
						,SSN_DC_CR_AMT  --季本币贷方发生额
						,HALF_Y_TM_BG_DR_OC_BAL  --半年期初借方原币余额
						,HALF_Y_TM_BG_CR_OC_BAL  --半年期初贷方原币余额
						,HALF_Y_TM_BG_DR_DC_BAL  --半年期初借方本币余额
						,HALF_Y_TM_BG_CR_DC_BAL  --半年期初贷方本币余额
						,HALF_Y_OC_DR_AMT  --半年原币借方发生额
						,HALF_Y_OC_CR_AMT  --半年原币贷方发生额
						,HALF_Y_DC_DR_AMT  --半年本币借方发生额
						,HALF_Y_DC_CR_AMT  --半年本币贷方发生额
						,EAR_Y_DR_OC_BAL  --年初借方原币余额
						,EAR_Y_CR_OC_BAL  --年初贷方原币余额
						,EAR_Y_DR_DC_BAL  --年初借方本币余额
						,EAR_Y_CR_DC_BAL  --年初贷方本币余额
						,YEAR_OC_DR_AMT  --年原币借方发生额
						,YEAR_OC_CR_AMT  --年原币贷方发生额
						,YEAR_DC_DR_AMT  --年本币借方发生额
						,YEAR_DC_CR_AMT  --年本币贷方发生额
						,JOB_CD  --任务代码
						,ETL_TIMESTAMP  --数据处理时间

    )
    SELECT
						ETL_DT  --数据日期
						,LP_ID  --法人编号
						,ACCT_SET_ID  --账套编号
						,ACCT_DURAN  --账务期间
						,ACCT_COMB_ID  --账户组合编号
						,STD_PROD_ID  --标准产品编号
						,TRAN_CHN_CD  --交易渠道代码
						,CURR_CD  --币种代码
						,ORG_ID  --机构编号
						,SUBJ_ID  --科目编号
						,SUBJ_NAME  --科目名称
						,BUDGET_SUBJ_ID  --预算科目编号
						,SUBJ_LEV_CD  --科目级别代码
						,SUBJ_DIR_CD  --科目方向代码
						,SUBJ_CHAR_CD  --科目性质代码
						,DATA_SRC_CD  --数据来源代码
						,TD_BAL_DIR_CD  --本日余额方向代码
						,IN_OUT_TAB_FLG  --表内外标志
						,DTL_SUBJ_FLG  --明细科目标志
						,YD_OC_DR_BAL  --昨日原币借方余额
						,YD_OC_CR_BAL  --昨日原币贷方余额
						,YD_DC_DR_BAL  --昨日本币借方余额
						,YD_DC_CR_BAL  --昨日本币贷方余额
						,TD_OC_BAL  --本日原币余额
						,TD_OC_DR_BAL  --本日原币借方余额
						,TD_OC_CR_BAL  --本日原币贷方余额
						,TD_DC_DR_BAL  --本日本币借方余额
						,TD_DC_CR_BAL  --本日本币贷方余额
						,TD_OC_DR_AMT  --本日原币借方发生额
						,TD_OC_CR_AMT  --本日原币贷方发生额
						,TD_DC_DR_AMT  --本日本币借方发生额
						,TD_DC_CR_AMT  --本日本币贷方发生额
						,TEN_DYS_BG_DR_OC_BAL  --旬初借方原币余额
						,TEN_DYS_BG_CR_OC_BAL  --旬初贷方原币余额
						,TEN_DYS_BG_DR_DC_BAL  --旬初借方本币余额
						,TEN_DYS_BG_CR_DC_BAL  --旬初贷方本币余额
						,TEN_DYS_BG_OC_DR_AMT  --旬原币借方发生额
						,TEN_DYS_BG_OC_CR_AMT  --旬原币贷方发生额
						,TEN_DYS_BG_DC_DR_AMT  --旬本币借方发生额
						,TEN_DYS_BG_DC_CR_AMT  --旬本币贷方发生额
						,EAR_M_DR_OC_BAL  --月初借方原币余额
						,EAR_M_CR_OC_BAL  --月初贷方原币余额
						,EAR_M_DR_DC_BAL  --月初借方本币余额
						,EAR_M_CR_DC_BAL  --月初贷方本币余额
						,MON_OC_DR_AMT  --月原币借方发生额
						,MON_OC_CR_AMT  --月原币贷方发生额
						,MON_DC_DR_AMT  --月本币借方发生额
						,MON_DC_CR_AMT  --月本币贷方发生额
						,EAR_S_DR_OC_BAL  --季初借方原币余额
						,EAR_S_CR_OC_BAL  --季初贷方原币余额
						,EAR_S_DR_DC_BAL  --季初借方本币余额
						,EAR_S_CR_DC_BAL  --季初贷方本币余额
						,SSN_OC_DR_AMT  --季原币借方发生额
						,SSN_OC_CR_AMT  --季原币贷方发生额
						,SSN_DC_DR_AMT  --季本币借方发生额
						,SSN_DC_CR_AMT  --季本币贷方发生额
						,HALF_Y_TM_BG_DR_OC_BAL  --半年期初借方原币余额
						,HALF_Y_TM_BG_CR_OC_BAL  --半年期初贷方原币余额
						,HALF_Y_TM_BG_DR_DC_BAL  --半年期初借方本币余额
						,HALF_Y_TM_BG_CR_DC_BAL  --半年期初贷方本币余额
						,HALF_Y_OC_DR_AMT  --半年原币借方发生额
						,HALF_Y_OC_CR_AMT  --半年原币贷方发生额
						,HALF_Y_DC_DR_AMT  --半年本币借方发生额
						,HALF_Y_DC_CR_AMT  --半年本币贷方发生额
						,EAR_Y_DR_OC_BAL  --年初借方原币余额
						,EAR_Y_CR_OC_BAL  --年初贷方原币余额
						,EAR_Y_DR_DC_BAL  --年初借方本币余额
						,EAR_Y_CR_DC_BAL  --年初贷方本币余额
						,YEAR_OC_DR_AMT  --年原币借方发生额
						,YEAR_OC_CR_AMT  --年原币贷方发生额
						,YEAR_DC_DR_AMT  --年本币借方发生额
						,YEAR_DC_CR_AMT  --年本币贷方发生额
						,JOB_CD  --任务代码
						,ETL_TIMESTAMP  --数据处理时间
    FROM ICL.V_CMM_GL_BAL  --视图-总账余额
    WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
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

  END ETL_INIT_O_ICL_CMM_GL_BAL;
/

