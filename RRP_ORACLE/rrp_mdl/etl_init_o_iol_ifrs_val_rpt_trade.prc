CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IFRS_VAL_RPT_TRADE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IFRS_VAL_RPT_TRADE
  *  功能描述：估值报告表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IFRS_VAL_RPT_TRADE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IFRS_VAL_RPT_TRADE'; -- 程序名称
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
  V_P_DATE :=TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_IFRS_VAL_RPT_TRADE ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_IFRS_VAL_RPT_TRADE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-估值报告表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IFRS_VAL_RPT_TRADE
  (      ETL_DT  --ETL处理日期
      ,D_DATA_DT  --数据日期
      ,V_CONTRACT_NO  --资产代码
      ,V_BUSINESSTYPE  --业务品种代码
      ,V_BUSINESSSUBTYPE  --业务子类型
      ,V_CURRENCY_CODE  --币种代码
      ,V_ORG_ID  --机构号
      ,V_THREE_CLASS  --三分类
      ,N_FV_TIER  --公允价值层级
      ,V_ASSET_TYPE  --权益/债务
      ,V_VALUE_TYPE  --净值类型
      ,V_TARGETASSET_IND  --是否可穿透
      ,V_LAYER  --投资层级
      ,N_BALANCE  --账面金额
      ,N_ACTUAL_PAY  --实付金额
      ,N_ACCRUAL_INTEREST  --计提利息
      ,N_PV  --公允价值
      ,N_PV_VARIATION  --公允价值变动
      ,N_DURATION  --久期
      ,N_TIME_TO_MAT  --剩余期限
      ,N_TIME_TO_REPRICING  --重订价期限
      ,V_TRADE_SYSTEM  --源系统
      ,D_PUTOUTDATE  --起息日
      ,D_MATURITY  --到期日
      ,N_BUSINESSRATE  --预期收益率/贴现率
      ,V_VALUE_MODEL  --估值模型代码
      ,V_SUBJECTNO  --科目号
      ,N_VALID  --有效标志
      ,V_CLASSIFYRESULT  --五级分类
      ,V_TRADE_NO  --交易编号
      ,N_PV_LASTDAY  --上一跑批日公允价值
      ,N_PV_ACCTDAY  --上一入账日公允价值
      ,N_PV_MOVE_P_LASTDAY  --较上一跑批日公允价值波动百分比
      ,N_PV_MOVE_P_ACCTDAY  --较上一入账日公允价值波动百分比
      ,V_OPERATE_ORGID  --经办机构号
      ,V_BILL_NO  --票据号
      ,N_INTEREST_ADJUST  --利息调整
      ,N_ZSPREAD  --点差
      ,V_INTEREST_PERIOD  --计息周期
      ,V_COUNTERPARTY_NAME  --交易对手名称
      ,N_PVCNY_VARIATION  --以人民币计价的公允价值变动
      ,V_DEPT_ID  --部门
      ,V_SUBJECT_NAME  --科目名称
      ,N_POSITION_VALUE  --持仓面额
      ,N_ACCOUNT_VALUE  --投资成本/面值
      ,N_NET_PV  --估值净价
      ,N_BASE_POINT_VALUE  --基点价值
      ,N_CONVEXITY  --凸性
      ,N_INTEREST_ACCRUED  --应计利息(错)
      ,V_SERIALNO  --借据号
      ,V_THREE_STAGE_CD  --三分类标识
      ,V_PRODUCK_TYPE_S_CD  --标准产品类型
      ,V_CUST_CODE  --发行人代码
      ,N_DIRTYPRICE  --中债估值（全价）
      ,N_CLEANPRICE  --中债估值（净价）
      ,V_BONDDURATION  --债券敏感度（修正久期）
      ,V_BONDDV01  --债券敏感度（基点价值）
      ,V_BONDCONVEXITY  --债券敏感度（凸性）
      ,V_BOND_RATING  --债券评级
      ,V_OVERDUE_FLAG  --违约标识
      ,N_PAR_RATE  --票面利率
      ,V_GZMETH  --估值方法
      ,V_ASSET_CODE  --资产代码
      ,V_ASSET_NAME  --资产名称
      ,N_PV_FULL_PRICE  --估值全价
      ,N_PV_LASTDAY_DIF  --较上日估值变动
      ,N_PV_LASTMON_DIF  --较上月估值变动
      ,N_PV_LASTYEAR_DIF  --较上年估值变动
      ,N_PV_VARIATION_DIF  --较上日公允价值变动（公允价值变动之差）
      ,V_BOND_NAME  --债项名称
      ,V_BOND_CD  --债项编号
      ,N_FACE_VALUE_BAL  --持仓面值
      ,N_NETVALUE  --当日净值
      ,N_HOLDING_SHARE  --持有份额
      ,V_FUND_NAME  --基金名称
      ,V_FUND_NO  --基金代码
      ,N_ACCRUED_INTEREST  --应收利息
      ,V_TRADE_NAME  --
      ,N_CLEANCOST  --净价成本
      ,N_COST  --本金
      ,V_TRADE_TYPE  --业务分类
      ,N_OVDUE_COST  --逾期本金
      ,N_PVCNY  --以人民币计价的公允价值
      ,N_CURR_CONVT_RATE  --
   -- ,JOB_CD --任务代码
    )
    SELECT

      --ETL_DT  --ETL处理日期
      CASE WHEN SUBSTR(TO_CHAR(D_DATA_DT,'YYYYMMDD'),5)='1231' THEN D_DATA_DT
                        ELSE D_DATA_DT +1 END--数据日期  --MODIFY BY XUXIAOBIN 20220927减估值的日期是对ETL_DT+1
      ,D_DATA_DT  --数据日期
      ,V_CONTRACT_NO  --资产代码
      ,V_BUSINESSTYPE  --业务品种代码
      ,V_BUSINESSSUBTYPE  --业务子类型
      ,V_CURRENCY_CODE  --币种代码
      ,V_ORG_ID  --机构号
      ,V_THREE_CLASS  --三分类
      ,N_FV_TIER  --公允价值层级
      ,V_ASSET_TYPE  --权益/债务
      ,V_VALUE_TYPE  --净值类型
      ,V_TARGETASSET_IND  --是否可穿透
      ,V_LAYER  --投资层级
      ,N_BALANCE  --账面金额
      ,N_ACTUAL_PAY  --实付金额
      ,N_ACCRUAL_INTEREST  --计提利息
      ,N_PV  --公允价值
      ,N_PV_VARIATION  --公允价值变动
      ,N_DURATION  --久期
      ,N_TIME_TO_MAT  --剩余期限
      ,N_TIME_TO_REPRICING  --重订价期限
      ,V_TRADE_SYSTEM  --源系统
      ,D_PUTOUTDATE  --起息日
      ,D_MATURITY  --到期日
      ,N_BUSINESSRATE  --预期收益率/贴现率
      ,V_VALUE_MODEL  --估值模型代码
      ,V_SUBJECTNO  --科目号
      ,N_VALID  --有效标志
      ,V_CLASSIFYRESULT  --五级分类
      ,V_TRADE_NO  --交易编号
      ,N_PV_LASTDAY  --上一跑批日公允价值
      ,N_PV_ACCTDAY  --上一入账日公允价值
      ,N_PV_MOVE_P_LASTDAY  --较上一跑批日公允价值波动百分比
      ,N_PV_MOVE_P_ACCTDAY  --较上一入账日公允价值波动百分比
      ,V_OPERATE_ORGID  --经办机构号
      ,V_BILL_NO  --票据号
      ,N_INTEREST_ADJUST  --利息调整
      ,N_ZSPREAD  --点差
      ,V_INTEREST_PERIOD  --计息周期
      ,V_COUNTERPARTY_NAME  --交易对手名称
      ,N_PVCNY_VARIATION  --以人民币计价的公允价值变动
      ,V_DEPT_ID  --部门
      ,V_SUBJECT_NAME  --科目名称
      ,N_POSITION_VALUE  --持仓面额
      ,N_ACCOUNT_VALUE  --投资成本/面值
      ,N_NET_PV  --估值净价
      ,N_BASE_POINT_VALUE  --基点价值
      ,N_CONVEXITY  --凸性
      ,N_INTEREST_ACCRUED  --应计利息(错)
      ,V_SERIALNO  --借据号
      ,V_THREE_STAGE_CD  --三分类标识
      ,V_PRODUCK_TYPE_S_CD  --标准产品类型
      ,V_CUST_CODE  --发行人代码
      ,N_DIRTYPRICE  --中债估值（全价）
      ,N_CLEANPRICE  --中债估值（净价）
      ,V_BONDDURATION  --债券敏感度（修正久期）
      ,V_BONDDV01  --债券敏感度（基点价值）
      ,V_BONDCONVEXITY  --债券敏感度（凸性）
      ,V_BOND_RATING  --债券评级
      ,V_OVERDUE_FLAG  --违约标识
      ,N_PAR_RATE  --票面利率
      ,V_GZMETH  --估值方法
      ,V_ASSET_CODE  --资产代码
      ,V_ASSET_NAME  --资产名称
      ,N_PV_FULL_PRICE  --估值全价
      ,N_PV_LASTDAY_DIF  --较上日估值变动
      ,N_PV_LASTMON_DIF  --较上月估值变动
      ,N_PV_LASTYEAR_DIF  --较上年估值变动
      ,N_PV_VARIATION_DIF  --较上日公允价值变动（公允价值变动之差）
      ,V_BOND_NAME  --债项名称
      ,V_BOND_CD  --债项编号
      ,N_FACE_VALUE_BAL  --持仓面值
      ,N_NETVALUE  --当日净值
      ,N_HOLDING_SHARE  --持有份额
      ,V_FUND_NAME  --基金名称
      ,V_FUND_NO  --基金代码
      ,N_ACCRUED_INTEREST  --应收利息
      ,V_TRADE_NAME  --
      ,N_CLEANCOST  --净价成本
      ,N_COST  --本金
      ,V_TRADE_TYPE  --业务分类
      ,N_OVDUE_COST  --逾期本金
      ,N_PVCNY  --以人民币计价的公允价值
      ,N_CURR_CONVT_RATE  --
 --   ,JOB_CD --任务代码
    FROM IOL.V_IFRS_VAL_RPT_TRADE  --视图-估值报告表
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

  END ETL_INIT_O_IOL_IFRS_VAL_RPT_TRADE;
/

