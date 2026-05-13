CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IFRS_FCT_ECL_RES_DTL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IFRS_FCT_ECL_RES_DTL
  *  功能描述：减值结果表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IFRS_FCT_ECL_RES_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IFRS_FCT_ECL_RES_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_IFRS_FCT_ECL_RES_DTL T WHERE T.D_DATE_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_IFRS_FCT_ECL_RES_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-减值结果表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IFRS_FCT_ECL_RES_DTL
  (
          D_DATE_DT  --数据日期
          ,N_ASSET_CLASS_CD  --敞口类型划分代码
          ,V_ID_NUMBER  --借据号(唯一标识)
          ,V_CUST_CD  --客户号
          ,V_CUST_NAME  --客户名
          ,V_PD_INTERNAL  --PD模型
          ,V_REGUL_CLASSIF_CD  --五级分类
          ,V_INTERNAL_RATING  --内部评级
          ,V_ISSUER_RATING  --发行人评级
          ,V_OBLIGATION_RATING  --债项评级
          ,N_ODUS_DAYS  --逾期天数
          ,N_PHASE_DIVISION_CD  --阶段划分
          ,N_CUR  --折币后本期余额
          ,N_INT  --折币后本期利息
          ,N_SLOW  --缓释品金额
          ,N_EAD_FIN  --EAD
          ,N_PD  --PD
          ,N_LGD_FIN  --LGD
          ,N_ECL  --ECL
          ,V_THREE_STAGE_CD  --三分类代码
          ,V_PRODUCK_TYPE_CD  --产品大类
          ,V_PRODUCK_TYPE_S_CD  --产品小类
          ,V_CCY_CD  --折币后币种
          ,D_ACCT_OPEN_DATE  --起息日
        	,D_ACCT_EXPIRE_DATE  --到期日
					,N_RESIDUAL_MATURITY  --剩余期限
					,N_ODUE_DAYS_CUR  --本金逾期天数
					,N_ODUE_DAYS_INT  --利息逾期天数
					,V_BLICK  --是否铁骑清单
					,V_SUB_CD  --科目代码
					,V_SUB_NAME  --科目名称
					,V_ORG_CD  --机构代码
					,V_ORG_NAME  --结构名称
					,BEFORE_ADJUSTMENT_COEFFICIENT  --调整ECL系数(OLD)
					,BEFORE_N_ADJUSTMENT_ECL  --调整后ECL(OLD)
					,N_EAD_FIN_BEFORE  --原币EAD
					,N_ECL_BEFORE  --原币ECL
					,V_CCY_CD_BEFORE  --原币币种
					,N_CUR_BEFORE  --原币本期余额
					,N_INT_BEFORE  --原币利息
					,N_SLOW_BEFORE  --原币缓释品金额
					,V_AROUND_SIGN  --表内外标识
					,V_INVEST_INDUST_CD  --国际行业
					,N_LGD_BEFORE  --基础LGD
					,V_ACCOUNT_AGEING  --账龄(网贷业务)
					,V_DFC_ECL_CD  --是否DCF规则调整标识
					,INDUSTRY_NAME  --行业名称(报表用)
					,N_ECL_DCF  --DCF调整后的折币后ECL
					,N_ECL_BEFORE_DCF  --DCF调整后的原币ECL
					,ISSUE_BANK_CN_NAME  --开证行名称
					,RATE_FIN  --最终评级
					,V_FINANCIAL_ID  --金融工具表编号
					,V_BOND_ID  --债券编号
					,V_FORECAST_MOD  --旧版模型分组 预测用
					,V_BILL_NO  --
					,EXECU_ORG_NO  --经办机构
					,EXECU_ORG_NAME  --经办机构名称
					,N_PV_VARIATION  --公允价值变动
					,N_BALANCE_FACE  --面值
					,N_INT_ADJ_BAL  --利息调整
					,N_INT_RECEIVABLE  --应收利息
					,N_INT_ACCRUED  --应计利息
					,N_PV_VARIATION_LASTDAY  --前一天公允价值变动_折人民币
					,PV_VARIATION_LASTDAY  --前一天公允价值变动_原币
					,V_SERIALNO  --减值借据号_物理展示
					,BIZ_NO  --贴现转贴现主键
					,LEVEL5_CLASS_CD  --五级分类代码
					,PRODUCT_NO  --产品编号
					,FIN_INSTM_NAME  --金融工具名称
					,ASSET_TYPE_NAME  --产品分类
					,GUARTOR_CUST_NAME  --担保客户名称
					,V_VALUE_MODEL_NAME  --估值模型名称
					,PV_VARIATION  --原币公允价值
					,INTNAL_SECU_ACCT_ID  --内部证券账户编号
					,GLOB_SEQ_NUM  --全局流水号
					,UNIQUE_SEQ_NUM  --业务流水号
					,V_TX_CUST_NAME  --贴现人客户名称
					,V_GROUP_CUST_NO  --集团客户号
					,V_GROUP_CUST_NAME  --集团客户名称
					,BILL_NO  --票据编号BILL_NO
					,BILL_SUB_INTRV_ID  --子票据区间编号
					,ETL_DT  --ETL处理日期
					,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT

     		  D_DATE_DT + 1  --数据日期
					,N_ASSET_CLASS_CD  --敞口类型划分代码
					,V_ID_NUMBER  --借据号(唯一标识)
					,V_CUST_CD  --客户号
					,V_CUST_NAME  --客户名
					,V_PD_INTERNAL  --PD模型
					,V_REGUL_CLASSIF_CD  --五级分类
					,V_INTERNAL_RATING  --内部评级
					,V_ISSUER_RATING  --发行人评级
					,V_OBLIGATION_RATING  --债项评级
					,N_ODUS_DAYS  --逾期天数
					,N_PHASE_DIVISION_CD  --阶段划分
					,N_CUR  --折币后本期余额
					,N_INT  --折币后本期利息
					,N_SLOW  --缓释品金额
					,N_EAD_FIN  --EAD
					,N_PD  --PD
					,N_LGD_FIN  --LGD
					,N_ECL  --ECL
					,V_THREE_STAGE_CD  --三分类代码
					,V_PRODUCK_TYPE_CD  --产品大类
					,V_PRODUCK_TYPE_S_CD  --产品小类
					,V_CCY_CD  --折币后币种
					,D_ACCT_OPEN_DATE  --起息日
					,D_ACCT_EXPIRE_DATE  --到期日
					,N_RESIDUAL_MATURITY  --剩余期限
					,N_ODUE_DAYS_CUR  --本金逾期天数
					,N_ODUE_DAYS_INT  --利息逾期天数
					,V_BLICK  --是否铁骑清单
					,V_SUB_CD  --科目代码
					,V_SUB_NAME  --科目名称
					,V_ORG_CD  --机构代码
					,V_ORG_NAME  --结构名称
					,BEFORE_ADJUSTMENT_COEFFICIENT  --调整ECL系数(OLD)
					,BEFORE_N_ADJUSTMENT_ECL  --调整后ECL(OLD)
					,N_EAD_FIN_BEFORE  --原币EAD
					,N_ECL_BEFORE  --原币ECL
					,V_CCY_CD_BEFORE  --原币币种
					,N_CUR_BEFORE  --原币本期余额
					,N_INT_BEFORE  --原币利息
					,N_SLOW_BEFORE  --原币缓释品金额
					,V_AROUND_SIGN  --表内外标识
					,V_INVEST_INDUST_CD  --国际行业
					,N_LGD_BEFORE  --基础LGD
					,V_ACCOUNT_AGEING  --账龄(网贷业务)
					,V_DFC_ECL_CD  --是否DCF规则调整标识
					,INDUSTRY_NAME  --行业名称(报表用)
					,N_ECL_DCF  --DCF调整后的折币后ECL
					,N_ECL_BEFORE_DCF  --DCF调整后的原币ECL
					,ISSUE_BANK_CN_NAME  --开证行名称
					,RATE_FIN  --最终评级
					,V_FINANCIAL_ID  --金融工具表编号
					,V_BOND_ID  --债券编号
					,V_FORECAST_MOD  --旧版模型分组 预测用
					,V_BILL_NO  --
					,EXECU_ORG_NO  --经办机构
					,EXECU_ORG_NAME  --经办机构名称
					,N_PV_VARIATION  --公允价值变动
					,N_BALANCE_FACE  --面值
					,N_INT_ADJ_BAL  --利息调整
					,N_INT_RECEIVABLE  --应收利息
					,N_INT_ACCRUED  --应计利息
					,N_PV_VARIATION_LASTDAY  --前一天公允价值变动_折人民币
					,PV_VARIATION_LASTDAY  --前一天公允价值变动_原币
					,V_SERIALNO  --减值借据号_物理展示
					,BIZ_NO  --贴现转贴现主键
					,LEVEL5_CLASS_CD  --五级分类代码
					,PRODUCT_NO  --产品编号
					,FIN_INSTM_NAME  --金融工具名称
					,ASSET_TYPE_NAME  --产品分类
					,GUARTOR_CUST_NAME  --担保客户名称
					,V_VALUE_MODEL_NAME  --估值模型名称
					,PV_VARIATION  --原币公允价值
					,INTNAL_SECU_ACCT_ID  --内部证券账户编号
					,GLOB_SEQ_NUM  --全局流水号
					,UNIQUE_SEQ_NUM  --业务流水号
					,V_TX_CUST_NAME  --贴现人客户名称
					,V_GROUP_CUST_NO  --集团客户号
					,V_GROUP_CUST_NAME  --集团客户名称
					,BILL_NO  --票据编号BILL_NO
					,BILL_SUB_INTRV_ID  --子票据区间编号
					,D_DATE_DT+1  --ETL处理日期
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_IFRS_FCT_ECL_RES_DTL  --视图-减值结果表
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

  END ETL_INIT_O_IOL_IFRS_FCT_ECL_RES_DTL;
/

