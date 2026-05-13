CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_DEP_ACCT_INFO(I_P_DATE IN INTEGER,
                                                     O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_DEP_ACCT_INFO
  *  功能描述：存款账户信息-手工报表专用
  *  创建日期：20230104
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO 存款账户信息表
  *  目标表：RRP_MDL.M_MRPT_DEP_ACCT_INFO 存款账户信息表-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230104  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_DEP_ACCT_INFO'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql
  V_PART_NAME   VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME    VARCHAR2(100);  --表名称

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_DEP_ACCT_INFO'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  /*--查询分区是否已经存在
  SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  END IF ;*/
  V_SQL :='TRUNCATE TABLE M_MRPT_DEP_ACCT_INFO';
  EXECUTE IMMEDIATE V_SQL;
  
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入存款账户信息表-手工报表专用';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_DEP_ACCT_INFO NOLOGGING
  (
      DATA_DT,                      --数据日期
			ACCT_ID,                      --账户编号
			ACCT_NAME,                    --账户名称
			CUST_ACCT_ID,                 --客户账户编号
			CUST_ACCT_SUB_ACCT_NUM,       --客户账户子户号
			CDS_LIAB_ACCT_NUM,            --负债账户编号
			OLD_ACCT_ID,                  --旧账户编号
			OLD_CUST_ACCT_SUB_ACCT_NUM,   --旧客户账户子户号
			CUST_ACCT_CARD_NO,            --客户账户卡号
			CUST_ID,                      --客户编号
			SUBJ_ID,                      --科目编号
			DEP_KIND_CD,                  --储种代码
			ACCT_CLS_CD,                  --账户分类代码
			ACCT_TYPE_CD,                 --账户类型代码
			ACCT_ATTR_CD,                 --账户属性代码
			STD_PROD_ID,                  --标准产品编号
			EXT_PROD_ID,                  --外部产品编号
			INTNAL_PROD_ID,               --内部产品编号
			DEP_ACCT_STATUS_CD,           --存款账户状态代码
			CUST_TYPE_CD,                 --客户类型代码
			CORP_ACCT_FLG,                --对公账户标志
			STOP_PAY_STATUS_CD,           --止付状态代码
			GENERAL_EXCH_FLG,             --通兑标志
			GENERAL_EXCH_ORG_ID,          --通兑机构编号
			GENERAL_STORAGE_FLG,          --通存标志
			ADVISE_DEP_FLG,               --通知存款标志
			AGT_DEP_FLG,                  --协议存款标志
			FLOAT_INT_RAT_FLG,            --浮动利率标志
			INT_RAT_FLOAT_WAY_CD,         --利率浮动方式代码
			INT_RAT_ADJ_PED_CORP_CD,      --利率调整周期单位代码
			INT_RAT_ADJ_PED_FREQ,         --利率调整周期频率
			CORP_SUPV_ACCT_FLG,           --对公监管户标志
			RC_FLG,                       --定活标志
			MARGIN_FLG,                   --保证金标志
			CURR_CD,                      --币种代码
			OPEN_ACCT_ORG_ID,             --开户机构编号
			CLOSE_ACCT_ORG_ID,            --销户机构编号
			BELONG_ORG_ID,                --所属机构编号
			LOC_FLG,                      --开立存款证实书标志
			EXPE_HIGT_YLD_RAT,            --预期最高收益率
			AGREE_DEP_INIT_AMT,           --协定存款起存金额
			LOWT_BAL,                     --最低余额
			OPEN_ACCT_AMT,                --开户金额
			CURRT_BAL,                    --当期余额
			CL_CURR_CURRT_BAL,            --折本币当期余额
			EAR_D_BAL,                    --日初余额
			EAR_M_BAL,                    --月初余额
			EAR_S_BAL,                    --季初余额
			EAR_Y_BAL,                    --年初余额
			Y_ACM_BAL,                    --年累计余额
			S_ACM_BAL,                    --季累计余额
			M_ACM_BAL,                    --月累计余额
			Y_AVG_BAL,                    --年日均余额
			Q_AVG_BAL,                    --季日均余额
			M_AVG_BAL                     --月日均余额
  )
 SELECT /*+ PARALLEL */
      V_P_DATE, 					          --数据日期
			acct_id,                      --账户编号
			acct_name,                    --账户名称
			cust_acct_id,                 --客户账户编号
			cust_acct_sub_acct_num,       --客户账户子户号
			cds_liab_acct_num,            --负债账户编号
			old_acct_id,                  --旧账户编号
			old_cust_acct_sub_acct_num,   --旧客户账户子户号
			cust_acct_card_no,            --客户账户卡号
			cust_id,                      --客户编号
			subj_id,                      --科目编号
			dep_kind_cd,                  --储种代码
			acct_cls_cd,                  --账户分类代码
			acct_type_cd,                 --账户类型代码
			acct_attr_cd,                 --账户属性代码
			std_prod_id,                  --标准产品编号
			ext_prod_id,                  --外部产品编号
			intnal_prod_id,               --内部产品编号
			dep_acct_status_cd,           --存款账户状态代码
			cust_type_cd,                 --客户类型代码
			corp_acct_flg,                --对公账户标志
			stop_pay_status_cd,           --止付状态代码
			general_exch_flg,             --通兑标志
			general_exch_org_id,          --通兑机构编号
			general_storage_flg,          --通存标志
			advise_dep_flg,               --通知存款标志
			agt_dep_flg,                  --协议存款标志
			float_int_rat_flg,            --浮动利率标志
			int_rat_float_way_cd,         --利率浮动方式代码
			int_rat_adj_ped_corp_cd,      --利率调整周期单位代码
			int_rat_adj_ped_freq,         --利率调整周期频率
			corp_supv_acct_flg,           --对公监管户标志
			rc_flg,                       --定活标志
			margin_flg,                   --保证金标志
			curr_cd,                      --币种代码
			open_acct_org_id,             --开户机构编号
			close_acct_org_id,            --销户机构编号
			belong_org_id,                --所属机构编号
			loc_flg,                      --开立存款证实书标志
			expe_higt_yld_rat,            --预期最高收益率
			agree_dep_init_amt,           --协定存款起存金额
			lowt_bal,                     --最低余额
			open_acct_amt,                --开户金额
			currt_bal,                    --当期余额
			cl_curr_currt_bal,            --折本币当期余额
			ear_d_bal,                    --日初余额
			ear_m_bal,                    --月初余额
			ear_s_bal,                    --季初余额
			ear_y_bal,                    --年初余额
			y_acm_bal,                    --年累计余额
			s_acm_bal,                    --季累计余额
			m_acm_bal,                    --月累计余额
			y_avg_bal,                    --年日均余额
			q_avg_bal,                    --季日均余额
			m_avg_bal                     --月日均余额
  FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
  WHERE ETL_DT=TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

  --调度依赖存储过程的状态
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;

--异常处理
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_MRPT_DEP_ACCT_INFO;
/

