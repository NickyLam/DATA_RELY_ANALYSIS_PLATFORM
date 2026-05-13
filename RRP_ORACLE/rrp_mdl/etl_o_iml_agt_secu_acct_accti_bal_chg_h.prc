CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
  *  功能描述：证券账户核算余额变动历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-证券账户核算余额变动历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
    ( AGT_ID			                    --协议编号
      ,LP_ID			                    --法人编号
      ,CHG_ID			                    --变动编号
      ,TASK_ID			                  --任务编号
      ,REVO_RELA_CHG_ID			          --撤销关联变动编号
      ,CHG_DT			                    --变动日期
      ,CHG_TYPE_CD			              --变动类型代码
      ,ACCTI_OBJ_ID			              --核算对象编号
      ,INSTR_ID			                  --指令编号
      ,EXT_VCH_ACCT_ID			          --外部券账户编号
      ,INTNAL_VCH_ACCT_ID		          --内部券账户编号
      ,COMB_TRAN_ID			              --组合交易编号
      ,FIN_INSTM_ID			              --金融工具编号
      ,ASSET_TYPE_ID			            --资产类型编号
      ,MARKET_TYPE_ID			            --市场类型编号
      ,TRAN_NUM			                  --交易号
      ,EXTRA_DIMEN_CD			            --额外维度代码
      ,ACCTI_TYPE_CD			            --核算类型代码
      ,ACTL_QTTY			                --实际数量
      ,ACTL_BAL			                  --实际余额
      ,NET_PRICE_COST			            --净价成本
      ,ACRU_INT			                  --应计利息
      ,INT_COST			                  --利息成本
      ,ACRU_TURN_RECVBL_UNCOL		   	  --应计转应收未收
      ,RECVBL_UNCOL_TURN_ACTL_RECV	  --应收未收转实收
      ,ACRU_INT_THEORY_ATTACH_PROVI	  --应计利息理论补计提
      ,ACRU_INT_ACTL_ATTACH_PROVI		  --应计利息实际补计提
      ,EVHA_VAL_CHAG			            --公允价值变动
      ,FAIR_VAL_PL_ASSET	          	--公允价值损益(资产部分)
      ,FAIR_VAL_PL_LIAB			          --公允价值损益(负债部分)
      ,RECVBL_UNCOL_BAL			          --应收未收余额
      ,RECVBL_UNCOL_NET_PRICE_COST		--应收未收净价成本
      ,RECVBL_UNCOL_ACRU_INT          --应收未收应计利息
      ,TD_AMORT_BUS_CNT			          --当天摊销业务次数
      ,AMORT_DT			                  --摊销日期
      ,INT_ADJ_AMT			              --利息调整金额
      ,FAIR_VAL_PL		     	          --公允价值损益
      ,BS_PL			                    --买卖损益
      ,INT_INCOME			                --利息收入
      ,ACRU_INT_INT_INCOME	          --应计利息利息收入
      ,AMORT_INT_INCOME			          --摊销利息收入
      ,CURR_POST_ACRU_INT_INT_INCOME	--当前持仓应计利息利息收入
      ,CURR_POST_AMORT_INT_INCOME			--当前持仓摊销利息收入
      ,RECLAFY_FAIR_VAL_PL	          --重分类公允价值损益
      ,FUTURES_MARGIN			            --期货保证金
      ,UPDATE_TM			                --更新时间
      ,FEE			                      --费用
      ,PAYBL_FEE			                --应付费用
      ,FEE_COST			                  --费用成本
      ,AMORT_NET_PRICE_COST	          --摊余净价成本
      ,AMORT_INT_COST			            --摊余利息成本
      ,BUS_DT			                    --业务日期
      ,H_AMORT_START_DT			          --历史摊销开始日期
      ,ACTL_INT_RAT			              --实际利率
      ,INVEST_YLD_RAT			            --投资收益率
      ,OPEN_YLD_RAT			              --开仓收益率
      ,PRE_RECV_INT			              --预收息
      ,NON_AMORT_NET_PRICE_COST		    --不摊销净价成本
      ,NON_AMORT_EVHA_VAL_CHAG		    --不摊销公允价值变动
      ,NON_AMORT_FAIR_VAL_PL			    --不摊销公允价值损益
      ,NON_AMORT_BS_PL			          --不摊销买卖损益
      ,RESET_BF_AMORT_DT	           	--重置前摊销日期
      ,RESET_POST_AMORT_CLOSING_DT    --重置后计提摊销截止日期
      ,RESET_BF_AMORT_CLOSING_DT	    --重置前计提摊销截止日期
      ,WRTN_OFF_COST			            --已核销成本
      ,WRTN_OFF_ACRU_INT		          --已核销应计利息
      ,WRTN_OFF_RECVBL_UNCOL_INT    	--已核销应收未收利息
      ,OFF_BS_ACRU_INT			          --表外应计利息
      ,OFF_BS_RECVBL_UNCOL_INT		    --表外应收未收利息
      ,ACRU_INT_AMT		              	--应计利息发生额
      ,ACRU_VAT			                  --应计增值税
      ,PAYBL_VAT			                --应付增值税
      ,RESET_BF_EVLTION_CURR_CD		    --重置前估值币种代码
      ,RESET_POST_EVLTION_CURR_CD	    --重置后估值币种代码
      ,STL_DT			                    --结算日期
      ,RLIZD_EVHA_VAL_CHAG_PL	        --已实现公允价值变动损益
      ,CURR_POST_INT_TAX			        --当前持仓利息税
      ,OPEN_INT_COST			            --开仓利息成本
      ,OPEN_EX_YLD_RAT			          --开仓行权收益率
      ,PRE_TAX_PRE_RECV_INT_INCOME		--税前预收利息收入
      ,PROVI_INT_INCOME			          --计提利息收入
      ,INT_RECVBL_INCO			          --应收利息收入
      ,ACTL_RECV_INT_INCOME			      --实收利息收入
      ,PROVI_INT_INCOME_PRE_RECV_TAX	--计提利息收入预收税
      ,AMORT_INT_INCOME_PAYBL_VAT			--摊销利息收入应付增值税
      ,BS_PL_PAYBL_VAT			          --买卖损益应付增值税
      ,OFFSET_DLVY_DT			            --平仓交割日期
      ,RESET_BF_OFFSET_DLVY_DT			  --重置前平仓交割日期
      ,EXT_DIMEN_INFO			            --扩展维度信息
      ,INT_INCOME_ESTIM_TAX			      --利息收入暂估税
      ,INT_INCOME_PAYBL_VAT			      --利息收入应付增值税
      ,PL_OBJ_ID			                --损益对象编号
      ,OLD_PL_OBJ_ID			            --老损益对象编号
      ,AT_PRE_RECV_INT_INCOME			    --税后预收息利息收入
      ,START_DT			                  --开始时间
      ,END_DT			                    --结束时间
      ,ID_MARK			                  --增删标志
      ,SRC_TABLE_NAME			            --源表名称
      ,JOB_CD			                    --任务编码
      ,ETL_TIMESTAMP			            --etl处理时间戳
    )
  SELECT 
       AGT_ID			                    --协议编号
      ,LP_ID			                    --法人编号
      ,CHG_ID			                    --变动编号
      ,TASK_ID			                  --任务编号
      ,REVO_RELA_CHG_ID			          --撤销关联变动编号
      ,CHG_DT			                    --变动日期
      ,CHG_TYPE_CD			              --变动类型代码
      ,ACCTI_OBJ_ID			              --核算对象编号
      ,INSTR_ID			                  --指令编号
      ,EXT_VCH_ACCT_ID			          --外部券账户编号
      ,INTNAL_VCH_ACCT_ID		          --内部券账户编号
      ,COMB_TRAN_ID			              --组合交易编号
      ,FIN_INSTM_ID			              --金融工具编号
      ,ASSET_TYPE_ID			            --资产类型编号
      ,MARKET_TYPE_ID			            --市场类型编号
      ,TRAN_NUM			                  --交易号
      ,EXTRA_DIMEN_CD			            --额外维度代码
      ,ACCTI_TYPE_CD			            --核算类型代码
      ,ACTL_QTTY			                --实际数量
      ,ACTL_BAL			                  --实际余额
      ,NET_PRICE_COST			            --净价成本
      ,ACRU_INT			                  --应计利息
      ,INT_COST			                  --利息成本
      ,ACRU_TURN_RECVBL_UNCOL		   	  --应计转应收未收
      ,RECVBL_UNCOL_TURN_ACTL_RECV	  --应收未收转实收
      ,ACRU_INT_THEORY_ATTACH_PROVI	  --应计利息理论补计提
      ,ACRU_INT_ACTL_ATTACH_PROVI		  --应计利息实际补计提
      ,EVHA_VAL_CHAG			            --公允价值变动
      ,FAIR_VAL_PL_ASSET	          	--公允价值损益(资产部分)
      ,FAIR_VAL_PL_LIAB			          --公允价值损益(负债部分)
      ,RECVBL_UNCOL_BAL			          --应收未收余额
      ,RECVBL_UNCOL_NET_PRICE_COST		--应收未收净价成本
      ,RECVBL_UNCOL_ACRU_INT          --应收未收应计利息
      ,TD_AMORT_BUS_CNT			          --当天摊销业务次数
      ,AMORT_DT			                  --摊销日期
      ,INT_ADJ_AMT			              --利息调整金额
      ,FAIR_VAL_PL		     	          --公允价值损益
      ,BS_PL			                    --买卖损益
      ,INT_INCOME			                --利息收入
      ,ACRU_INT_INT_INCOME	          --应计利息利息收入
      ,AMORT_INT_INCOME			          --摊销利息收入
      ,CURR_POST_ACRU_INT_INT_INCOME	--当前持仓应计利息利息收入
      ,CURR_POST_AMORT_INT_INCOME			--当前持仓摊销利息收入
      ,RECLAFY_FAIR_VAL_PL	          --重分类公允价值损益
      ,FUTURES_MARGIN			            --期货保证金
      ,UPDATE_TM			                --更新时间
      ,FEE			                      --费用
      ,PAYBL_FEE			                --应付费用
      ,FEE_COST			                  --费用成本
      ,AMORT_NET_PRICE_COST	          --摊余净价成本
      ,AMORT_INT_COST			            --摊余利息成本
      ,BUS_DT			                    --业务日期
      ,H_AMORT_START_DT			          --历史摊销开始日期
      ,ACTL_INT_RAT			              --实际利率
      ,INVEST_YLD_RAT			            --投资收益率
      ,OPEN_YLD_RAT			              --开仓收益率
      ,PRE_RECV_INT			              --预收息
      ,NON_AMORT_NET_PRICE_COST		    --不摊销净价成本
      ,NON_AMORT_EVHA_VAL_CHAG		    --不摊销公允价值变动
      ,NON_AMORT_FAIR_VAL_PL			    --不摊销公允价值损益
      ,NON_AMORT_BS_PL			          --不摊销买卖损益
      ,RESET_BF_AMORT_DT	           	--重置前摊销日期
      ,RESET_POST_AMORT_CLOSING_DT    --重置后计提摊销截止日期
      ,RESET_BF_AMORT_CLOSING_DT	    --重置前计提摊销截止日期
      ,WRTN_OFF_COST			            --已核销成本
      ,WRTN_OFF_ACRU_INT		          --已核销应计利息
      ,WRTN_OFF_RECVBL_UNCOL_INT    	--已核销应收未收利息
      ,OFF_BS_ACRU_INT			          --表外应计利息
      ,OFF_BS_RECVBL_UNCOL_INT		    --表外应收未收利息
      ,ACRU_INT_AMT		              	--应计利息发生额
      ,ACRU_VAT			                  --应计增值税
      ,PAYBL_VAT			                --应付增值税
      ,RESET_BF_EVLTION_CURR_CD		    --重置前估值币种代码
      ,RESET_POST_EVLTION_CURR_CD	    --重置后估值币种代码
      ,STL_DT			                    --结算日期
      ,RLIZD_EVHA_VAL_CHAG_PL	        --已实现公允价值变动损益
      ,CURR_POST_INT_TAX			        --当前持仓利息税
      ,OPEN_INT_COST			            --开仓利息成本
      ,OPEN_EX_YLD_RAT			          --开仓行权收益率
      ,PRE_TAX_PRE_RECV_INT_INCOME		--税前预收利息收入
      ,PROVI_INT_INCOME			          --计提利息收入
      ,INT_RECVBL_INCO			          --应收利息收入
      ,ACTL_RECV_INT_INCOME			      --实收利息收入
      ,PROVI_INT_INCOME_PRE_RECV_TAX	--计提利息收入预收税
      ,AMORT_INT_INCOME_PAYBL_VAT			--摊销利息收入应付增值税
      ,BS_PL_PAYBL_VAT			          --买卖损益应付增值税
      ,OFFSET_DLVY_DT			            --平仓交割日期
      ,RESET_BF_OFFSET_DLVY_DT			  --重置前平仓交割日期
      ,EXT_DIMEN_INFO			            --扩展维度信息
      ,INT_INCOME_ESTIM_TAX			      --利息收入暂估税
      ,INT_INCOME_PAYBL_VAT			      --利息收入应付增值税
      ,PL_OBJ_ID			                --损益对象编号
      ,OLD_PL_OBJ_ID			            --老损益对象编号
      ,AT_PRE_RECV_INT_INCOME			    --税后预收息利息收入
      ,START_DT			                  --开始时间
      ,END_DT			                    --结束时间
      ,ID_MARK			                  --增删标志
      ,SRC_TABLE_NAME			            --源表名称
      ,JOB_CD			                    --任务编码
      ,ETL_TIMESTAMP			            --etl处理时间戳
    FROM IML.V_AGT_SECU_ACCT_ACCTI_BAL_CHG_H --视图-证券账户核算余额变动历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D'; --MOD BY YJY 20241218

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H;
/

