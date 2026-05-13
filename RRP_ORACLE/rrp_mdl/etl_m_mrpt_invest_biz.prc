CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_INVEST_BIZ(I_P_DATE IN INTEGER,
                                                  O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_INVEST_BIZ
  *  功能描述：非标投资持仓明细-手工报表专用
  *  创建日期：20221230
  *  开发人员：CYK
  *  来源表：RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST 同业非标投资
             RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST 同业净值型产品投资
  *  目标表：RRP_MDL.M_MRPT_INVEST_BIZ 非标投资持仓明细-手工报表专用
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221230  CYK     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  I_STEP        INTEGER := 0;   -- 处理步骤
  I_SQLCOUNT    INTEGER := 0;   -- 更新或删除影响的记录数

  V_STEP_DESC   VARCHAR2(100);  -- 处理步骤描述
  V_PROC_NAME   VARCHAR2(30) := 'ETL_M_MRPT_INVEST_BIZ'; -- 程序名称
  V_P_DATE      VARCHAR2(8);    -- 跑批数据日期
  V_SQLMSG      VARCHAR2(300);  -- SQL执行描述信息
  V_SYSTEM      VARCHAR2(30);   -- 来源系统
  D_STARTTIME   DATE;
  V_SQL         VARCHAR2(2000); -- 动态sql

BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送';          -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  I_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;

  --清空目标表
  V_SQL :='TRUNCATE TABLE RRP_MDL.M_MRPT_INVEST_BIZ';
  EXECUTE IMMEDIATE V_SQL;

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入同业非标投资数据';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_INVEST_BIZ NOLOGGING
  (
			DATA_DT, 					    	    --数据日期
			BUS_NO,                     --业务编号
			OJB_NO,                     --对象编号
			UDER_ACTL_FINER_CUST_ID,    --实际融资人编号
			UDER_ACTL_FINER_NAME,       --实际融资人名称
			ASSET_TYPE_NAME,            --资产类型名称
			BELONG_ORG_NO,              --所属机构编号
			ACCT_NAME,                  --账户名称
			CLASS_CREDIT_IND,           --类信贷业务标志
			EXT_SECU_ACCT_NO,           --外部证券账户编号
			INTNAL_SECU_ACCT_NO,        --内部证券账户编号
			FIN_INSTM_NO,               --金融工具编号
			ASSET_TYPE_NO,              --资产类型编号
			MARKET_TYPE_NO,             --市场类型编号
			CURR_CD                     --币种代码
  )
  SELECT /*+ PARALLEL */
        V_P_DATE                          --数据日期
			  ,T1.BUS_ID                                --业务编号
			  ,T1.OBJ_ID                                --对象编号
			  ,T1.UDER_ACTL_FINER_CUST_ID               --实际融资客户编号
			  ,T1.UDER_ACTL_FINER_NAME                  --实际融资客户名称
			  ,T1.ASSET_TYPE_NAME                       --资产类型名称
			  ,T1.BELONG_ORG_ID                         --所属机构编号
			  ,T1.ACCT_NAME                             --账户名称
			  ,T1.CLASS_CRDT_FLG                        --类信贷业务标志
			  ,T1.EXT_SECU_ACCT_ID                      --外部证券账户编号
			  ,T1.INTNAL_SECU_ACCT_ID                   --内部证券账户编号
				,T1.FIN_INSTM_ID                          --金融工具编号
			  ,T1.ASSET_TYPE_ID                         --资产类型编号
			  ,T1.MARKET_TYPE_ID                        --市场类型编号
			  ,T1.CURR_CD                               --币种代码
  FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST T1        --同业非标投资
  WHERE ETL_DT= TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  I_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入同业净值型产品投资数据';
  D_STARTTIME := SYSDATE;

  INSERT /*+ APPEND */ INTO RRP_MDL.M_MRPT_INVEST_BIZ NOLOGGING
  (
			DATA_DT, 					    	    --数据日期
			BUS_NO,                     --业务编号
			OJB_NO,                     --对象编号
			UDER_ACTL_FINER_CUST_ID,    --实际融资人编号
			UDER_ACTL_FINER_NAME,       --实际融资人名称
			ASSET_TYPE_NAME,            --资产类型名称
			BELONG_ORG_NO,              --所属机构编号
			ACCT_NAME,                  --账户名称
			CLASS_CREDIT_IND,           --类信贷业务标志
			EXT_SECU_ACCT_NO,           --外部证券账户编号
			INTNAL_SECU_ACCT_NO,        --内部证券账户编号
			FIN_INSTM_NO,               --金融工具编号
			ASSET_TYPE_NO,              --资产类型编号
			MARKET_TYPE_NO,             --市场类型编号
			CURR_CD                     --币种代码
  )
  SELECT /*+ PARALLEL */
        V_P_DATE                          --数据日期
			  ,T1.BUS_ID                                --业务编号
			  ,T1.OBJ_ID                                --对象编号
			  ,T1.UDER_ACTL_FINER_CUST_ID               --实际融资客户编号
			  ,T1.UDER_ACTL_FINER_NAME                  --实际融资客户名称
			  ,T1.ASSET_TYPE_NAME                       --资产类型名称
			  ,T1.BELONG_ORG_ID                         --所属机构编号
			  ,T1.ACCT_NAME                             --账户名称
			  ,T1.CLASS_CRDT_FLG                        --类信贷业务标志
			  ,T1.EXT_SECU_ACCT_ID                      --外部证券账户编号
			  ,T1.INTNAL_SECU_ACCT_ID                   --内部证券账户编号
				,T1.FIN_INSTM_ID                          --金融工具编号
			  ,T1.ASSET_TYPE_ID                         --资产类型编号
			  ,T1.MARKET_TYPE_ID                        --市场类型编号
			  ,T1.CURR_CD                               --币种代码
  FROM RRP_MDL.O_ICL_CMM_IBANK_NV_TYPE_PROD_INVEST T1        --同业净值型产品投资
  WHERE ETL_DT= TO_DATE(V_P_DATE,'YYYYMMDD');

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  COMMIT;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,SYSDATE,I_STEP,V_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --程序结束标记
  I_STEP := 4;
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

END ETL_M_MRPT_INVEST_BIZ;
/

