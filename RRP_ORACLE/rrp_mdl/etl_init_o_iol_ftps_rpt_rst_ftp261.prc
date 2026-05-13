CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_FTPS_RPT_RST_FTP261 (I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_FTPS_RPT_RST_FTP261
  *  功能描述：FTP初级报表账户明细结果集
  *  创建日期：20221208
  *  开发人员：梅炜
  *  来源表： IOL.V_FTPS_RPT_RST_FTP261
  *  目标表： O_IOL_FTPS_RPT_RST_FTP261
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_FTPS_RPT_RST_FTP261'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_FTPS_RPT_RST_FTP261  ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_FTPS_RPT_RST_FTP261 ';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-客户账户注册手机号历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_FTPS_RPT_RST_FTP261
  (
				ACCT_NO  --账号
				,S_ACCT_NO  --拆分前账号
				,T_ACCT_NO  --源账号
				,DATA_DT  --数据日期
				,SHARE_PERCENT  --分成比例
				,PRICE_UNIT_CD  --定价单元
				,PROD_CD  --产品代码
				,CORE_PROD_CD  --核心系统产品码
				,CREDIT_PROD_CD  --信贷系统产品码
				,INDUSTRY_CD  --行业代码
				,SUBJECT_CD  --科目代码
				,CURRENCY_CD  --币种代码
				,ACCT_ORG_CD  --核算机构
				,ASSESS_ORG_CD  --考核机构代码
				,BOND_CATEG_CD  --债券种类代码
				,AL_FLAG  --资产负债标志
				,BIZ_FLAG  --对公对私业务标识
				,BIZ_LINE_CD  --业务条线代码
				,DATA_SRC  --数据来源
				,CHANNEL_CD  --渠道代码
				,INTEREST_ADJUST_TYPE_CD  --利率调整方式代码
				,CUST_ID  --客户号
				,CUST_NAME  --客户名称
				,MGR_ID  --客户经理号
				,MGR_NAME  --客户经理名称
				,CUST_SIZE_CD  --客户规模
				,CUST_TYPE_CD  --客户类型代码
				,ACCRUAL_BASIS_CD  --计息方式代码
				,ORIGINAL_TERM  --原始期限
				,ORIGINAL_TERM_MULT  --原始期限单位
				,START_DT  --起息日
				,MATURITY_DT  --到期日
				,OPEN_DT  --开户日
				,CLOSE_DT  --销户日
				,LAST_PAYMENT_DT  --上次还款日
				,NEXT_PAYMENT_DT  --下次还款日
				,PAYMENT_TYPE_CD  --还款方式代码
				,PAYMENT_FREQ  --还款频率
				,PAYMENT_FREQ_MULT  --还款频率单位
				,LAST_REPRICING_DT  --上次重定价日
				,NEXT_REPRICING_DT  --下次重定价日
				,REPRICING_FREQ  --重定价频率
				,REPRICING_FREQ_MULT  --重定价频率单位
				,OVERDUE_FLAG  --逾期标志
				,POSITION_INC_DT  --业务新增日期
				,AGMT_DEPOSIT_FLAG  --是否协定存款标志
				,EXCESS_RESERCE_FLAG  --是否超额准备金标志
				,IFLOCK_FLAG  --是否锁定利差标志
				,LOAN_CLASS_CD  --贷款质量分类
				,CUR_BAL  --当前余额
				,ACCBAL_MONTH  --月累计余额
				,ACCBAL_QUAR  --季累计余额
				,ACCBAL_YEAR  --年累计余额
				,EXERCISE_INTEREST_RATE  --执行利率
				,BASE_FTP_RATE  --原始FTP利率
				,MID_FTP_RATE  --内生性调节后FTP利率
				,FINAL_FTP_RATE  --最终FTP利率
				,LOCK_SPREAD  --锁定利差值
				,BASE_UNLOCK_FTP_RATE  --原始非锁定FTP利率
				,MID_UNLOCK_FTP_RATE  --内生性调节后非锁定FTP利率
				,FINAL_UNLOCK_FTP_RATE  --最终非锁定FTP利率
				,ACCINT_DAY  --利息收支日累计
				,ACCINT_MONTH  --利息收支月累计
				,ACCINT_QUAR  --利息收支季累计
				,ACCINT_YEAR  --利息收支年累计
				,BASE_FTP_ACCINT_DAY  --原始FTP利息日累计
				,BASE_FTP_ACCINT_MONTH  --原始FTP利息月累计
				,BASE_FTP_ACCINT_QUAR  --原始FTP利息季累计
				,BASE_FTP_ACCINT_YEAR  --原始FTP利息年累计
				,MID_FTP_ACCINT_DAY  --内生性调节后FTP利息日累计
				,MID_FTP_ACCINT_MONTH  --内生性调节后FTP利息月累计
				,MID_FTP_ACCINT_QUAR  --内生性调节后FTP利息季累计
				,MID_FTP_ACCINT_YEAR  --内生性调节后FTP利息年累计
				,FINAL_FTP_ACCINT_DAY  --最终FTP利息日累计
				,FINAL_FTP_ACCINT_MONTH  --最终FTP利息月累计
				,FINAL_FTP_ACCINT_QUAR  --最终FTP利息季累计
				,FINAL_FTP_ACCINT_YEAR  --最终FTP利息年累计
				,BASE_UNLOCK_FTP_ACCINT_DAY  --原始非锁定FTP利息日累计
				,BASE_UNLOCK_FTP_ACCINT_MONTH  --原始非锁定FTP利息月累计
				,BASE_UNLOCK_FTP_ACCINT_QUAR  --原始非锁定FTP利息季累计
				,BASE_UNLOCK_FTP_ACCINT_YEAR  --原始非锁定FTP利息年累计
				,MID_UNLOCK_FTP_ACCINT_DAY  --内生性调节后非锁定FTP利息日累计
				,MID_UNLOCK_FTP_ACCINT_MONTH  --内生性调节后非锁定FTP利息月累计
				,MID_UNLOCK_FTP_ACCINT_QUAR  --内生性调节后非锁定FTP利息季累计
				,MID_UNLOCK_FTP_ACCINT_YEAR  --内生性调节后非锁定FTP利息年累计
				,FINAL_UNLOCK_FTP_ACCINT_DAY  --最终非锁定FTP利息日累计
        ,FINAL_UNLOCK_FTP_ACCINT_MONTH  --最终非锁定FTP利息月累计
        ,FINAL_UNLOCK_FTP_ACCINT_QUAR  --最终非锁定FTP利息季累计
        ,FINAL_UNLOCK_FTP_ACCINT_YEAR  --最终非锁定FTP利息年累计
        ,ADJUST_01_RATE  --调节项1点差
        ,ADJUST_01_ACCINT_DAY  --调节项1金额日累计
        ,ADJUST_01_ACCINT_MONTH  --调节项1金额月累计
        ,ADJUST_01_ACCINT_QUAR  --调节项1金额季累计
        ,ADJUST_01_ACCINT_YEAR  --调节项1金额年累计
        ,ADJUST_02_RATE  --调节项2点差
        ,ADJUST_02_ACCINT_DAY  --调节项2金额日累计
        ,ADJUST_02_ACCINT_MONTH  --调节项2金额月累计
        ,ADJUST_02_ACCINT_QUAR  --调节项2金额季累计
        ,ADJUST_02_ACCINT_YEAR  --调节项2金额年累计
        ,ADJUST_03_RATE  --调节项3点差
        ,ADJUST_03_ACCINT_DAY  --调节项3金额日累计
        ,ADJUST_03_ACCINT_MONTH  --调节项3金额月累计
        ,ADJUST_03_ACCINT_QUAR  --调节项3金额季累计
        ,ADJUST_03_ACCINT_YEAR  --调节项3金额年累计
        ,ADJUST_04_RATE  --调节项4点差
        ,ADJUST_04_ACCINT_DAY  --调节项4金额日累计
        ,ADJUST_04_ACCINT_MONTH  --调节项4金额月累计
        ,ADJUST_04_ACCINT_QUAR  --调节项4金额季累计
        ,ADJUST_04_ACCINT_YEAR  --调节项4金额年累计
        ,ADJUST_05_RATE  --调节项5点差
        ,ADJUST_05_ACCINT_DAY  --调节项5金额日累计
        ,ADJUST_05_ACCINT_MONTH  --调节项5金额月累计
        ,ADJUST_05_ACCINT_QUAR  --调节项5金额季累计
        ,ADJUST_05_ACCINT_YEAR  --调节项5金额年累计
        ,ADJUST_06_RATE  --调节项6点差
        ,ADJUST_06_ACCINT_DAY  --调节项6金额日累计
        ,ADJUST_06_ACCINT_MONTH  --调节项6金额月累计
        ,ADJUST_06_ACCINT_QUAR  --调节项6金额季累计
        ,ADJUST_06_ACCINT_YEAR  --调节项6金额年累计
        ,ADJUST_07_RATE  --调节项7点差
        ,ADJUST_07_ACCINT_DAY  --调节项7金额日累计
        ,ADJUST_07_ACCINT_MONTH  --调节项7金额月累计
        ,ADJUST_07_ACCINT_QUAR  --调节项7金额季累计
        ,ADJUST_07_ACCINT_YEAR  --调节项7金额年累计
        ,ADJUST_08_RATE  --调节项8点差
        ,ADJUST_08_ACCINT_DAY  --调节项8金额日累计
        ,ADJUST_08_ACCINT_MONTH  --调节项8金额月累计
        ,ADJUST_08_ACCINT_QUAR  --调节项8金额季累计
        ,ADJUST_08_ACCINT_YEAR  --调节项8金额年累计
        ,ADJUST_09_RATE  --调节项9点差
        ,ADJUST_09_ACCINT_DAY  --调节项9金额日累计
        ,ADJUST_09_ACCINT_MONTH  --调节项9金额月累计
        ,ADJUST_09_ACCINT_QUAR  --调节项9金额季累计
        ,ADJUST_09_ACCINT_YEAR  --调节项9金额年累计
        ,ADJUST_10_RATE  --调节项10点差
        ,ADJUST_10_ACCINT_DAY  --调节项10金额日累计
        ,ADJUST_10_ACCINT_MONTH  --调节项10金额月累计
        ,ADJUST_10_ACCINT_QUAR  --调节项10金额季累计
        ,ADJUST_10_ACCINT_YEAR  --调节项10金额年累计
        ,ADJUST_11_RATE  --调节项11点差
        ,ADJUST_11_ACCINT_DAY  --调节项11金额日累计
        ,ADJUST_11_ACCINT_MONTH  --调节项11金额月累计
        ,ADJUST_11_ACCINT_QUAR  --调节项11金额季累计
        ,ADJUST_11_ACCINT_YEAR  --调节项11金额年累计
        ,ADJUST_12_RATE  --调节项12点差
        ,ADJUST_12_ACCINT_DAY  --调节项12金额日累计
        ,ADJUST_12_ACCINT_MONTH  --调节项12金额月累计
        ,ADJUST_12_ACCINT_QUAR  --调节项12金额季累计
        ,ADJUST_12_ACCINT_YEAR  --调节项12金额年累计
        ,ADJUST_13_RATE  --调节项13点差
        ,ADJUST_13_ACCINT_DAY  --调节项13金额日累计
        ,ADJUST_13_ACCINT_MONTH  --调节项13金额月累计
        ,ADJUST_13_ACCINT_QUAR  --调节项13金额季累计
        ,ADJUST_13_ACCINT_YEAR  --调节项13金额年累计
        ,ADJUST_14_RATE  --调节项14点差
        ,ADJUST_14_ACCINT_DAY  --调节项14金额日累计
        ,ADJUST_14_ACCINT_MONTH  --调节项14金额月累计
        ,ADJUST_14_ACCINT_QUAR  --调节项14金额季累计
        ,ADJUST_14_ACCINT_YEAR  --调节项14金额年累计
        ,ADJUST_15_RATE  --调节项15点差
        ,ADJUST_15_ACCINT_DAY  --调节项15金额日累计
        ,ADJUST_15_ACCINT_MONTH  --调节项15金额月累计
        ,ADJUST_15_ACCINT_QUAR  --调节项15金额季累计
        ,ADJUST_15_ACCINT_YEAR  --调节项15金额年累计
        ,ADJUST_16_RATE  --调节项16点差
        ,ADJUST_16_ACCINT_DAY  --调节项16金额日累计
        ,ADJUST_16_ACCINT_MONTH  --调节项16金额月累计
        ,ADJUST_16_ACCINT_QUAR  --调节项16金额季累计
        ,ADJUST_16_ACCINT_YEAR  --调节项16金额年累计
        ,ADJUST_17_RATE  --调节项17点差
        ,ADJUST_17_ACCINT_DAY  --调节项17金额日累计
        ,ADJUST_17_ACCINT_MONTH  --调节项17金额月累计
        ,ADJUST_17_ACCINT_QUAR  --调节项17金额季累计
        ,ADJUST_17_ACCINT_YEAR  --调节项17金额年累计
        ,ADJUST_18_RATE  --调节项18点差
        ,ADJUST_18_ACCINT_DAY  --调节项18金额日累计
        ,ADJUST_18_ACCINT_MONTH  --调节项18金额月累计
        ,ADJUST_18_ACCINT_QUAR  --调节项18金额季累计
        ,ADJUST_18_ACCINT_YEAR  --调节项18金额年累计
        ,ADJUST_19_RATE  --调节项19点差
        ,ADJUST_19_ACCINT_DAY  --调节项19金额日累计
        ,ADJUST_19_ACCINT_MONTH  --调节项19金额月累计
        ,ADJUST_19_ACCINT_QUAR  --调节项19金额季累计
        ,ADJUST_19_ACCINT_YEAR  --调节项19金额年累计
        ,ADJUST_20_RATE  --调节项20点差
        ,ADJUST_20_ACCINT_DAY  --调节项20金额日累计
        ,ADJUST_20_ACCINT_MONTH  --调节项20金额月累计
        ,ADJUST_20_ACCINT_QUAR  --调节项20金额季累计
        ,ADJUST_20_ACCINT_YEAR  --调节项20金额年累计
        ,INC_SPRED_ACCINT_DAY  --价差收益日累计
        ,INC_SPRED_ACCINT_MONTH  --价差收益月累计
        ,INC_SPRED_ACCINT_QUAR  --价差收益季累计
        ,INC_SPRED_ACCINT_YEAR  --价差收益年累计
        ,EXCHANGE_TO_CNY_RATE  --折人民币汇率
        ,EXCHANGE_TO_USD_RATE  --折美元汇率
        ,ETL_DT  --ETL处理日期
        ,ETL_TIMESTAMP  --ETL处理时间戳


    )
    SELECT
        ACCT_NO  --账号
        ,S_ACCT_NO  --拆分前账号
        ,T_ACCT_NO  --源账号
        ,DATA_DT  --数据日期
        ,SHARE_PERCENT  --分成比例
        ,PRICE_UNIT_CD  --定价单元
        ,PROD_CD  --产品代码
        ,CORE_PROD_CD  --核心系统产品码
        ,CREDIT_PROD_CD  --信贷系统产品码
        ,INDUSTRY_CD  --行业代码
        ,SUBJECT_CD  --科目代码
        ,CURRENCY_CD  --币种代码
        ,ACCT_ORG_CD  --核算机构
        ,ASSESS_ORG_CD  --考核机构代码
        ,BOND_CATEG_CD  --债券种类代码
        ,AL_FLAG  --资产负债标志
        ,BIZ_FLAG  --对公对私业务标识
        ,BIZ_LINE_CD  --业务条线代码
        ,DATA_SRC  --数据来源
        ,CHANNEL_CD  --渠道代码
        ,INTEREST_ADJUST_TYPE_CD  --利率调整方式代码
        ,CUST_ID  --客户号
        ,CUST_NAME  --客户名称
        ,MGR_ID  --客户经理号
        ,MGR_NAME  --客户经理名称
        ,CUST_SIZE_CD  --客户规模
        ,CUST_TYPE_CD  --客户类型代码
        ,ACCRUAL_BASIS_CD  --计息方式代码
        ,ORIGINAL_TERM  --原始期限
        ,ORIGINAL_TERM_MULT  --原始期限单位
        ,START_DT  --起息日
        ,MATURITY_DT  --到期日
        ,OPEN_DT  --开户日
        ,CLOSE_DT  --销户日
        ,LAST_PAYMENT_DT  --上次还款日
        ,NEXT_PAYMENT_DT  --下次还款日
        ,PAYMENT_TYPE_CD  --还款方式代码
        ,PAYMENT_FREQ  --还款频率
        ,PAYMENT_FREQ_MULT  --还款频率单位
        ,LAST_REPRICING_DT  --上次重定价日
        ,NEXT_REPRICING_DT  --下次重定价日
        ,REPRICING_FREQ  --重定价频率
        ,REPRICING_FREQ_MULT  --重定价频率单位
        ,OVERDUE_FLAG  --逾期标志
        ,POSITION_INC_DT  --业务新增日期
        ,AGMT_DEPOSIT_FLAG  --是否协定存款标志
        ,EXCESS_RESERCE_FLAG  --是否超额准备金标志
        ,IFLOCK_FLAG  --是否锁定利差标志
        ,LOAN_CLASS_CD  --贷款质量分类
        ,CUR_BAL  --当前余额
        ,ACCBAL_MONTH  --月累计余额
        ,ACCBAL_QUAR  --季累计余额
        ,ACCBAL_YEAR  --年累计余额
        ,EXERCISE_INTEREST_RATE  --执行利率
        ,BASE_FTP_RATE  --原始FTP利率
        ,MID_FTP_RATE  --内生性调节后FTP利率
        ,FINAL_FTP_RATE  --最终FTP利率
        ,LOCK_SPREAD  --锁定利差值
        ,BASE_UNLOCK_FTP_RATE  --原始非锁定FTP利率
        ,MID_UNLOCK_FTP_RATE  --内生性调节后非锁定FTP利率
        ,FINAL_UNLOCK_FTP_RATE  --最终非锁定FTP利率
        ,ACCINT_DAY  --利息收支日累计
        ,ACCINT_MONTH  --利息收支月累计
        ,ACCINT_QUAR  --利息收支季累计
        ,ACCINT_YEAR  --利息收支年累计
        ,BASE_FTP_ACCINT_DAY  --原始FTP利息日累计
        ,BASE_FTP_ACCINT_MONTH  --原始FTP利息月累计
        ,BASE_FTP_ACCINT_QUAR  --原始FTP利息季累计
        ,BASE_FTP_ACCINT_YEAR  --原始FTP利息年累计
        ,MID_FTP_ACCINT_DAY  --内生性调节后FTP利息日累计
        ,MID_FTP_ACCINT_MONTH  --内生性调节后FTP利息月累计
        ,MID_FTP_ACCINT_QUAR  --内生性调节后FTP利息季累计
        ,MID_FTP_ACCINT_YEAR  --内生性调节后FTP利息年累计
        ,FINAL_FTP_ACCINT_DAY  --最终FTP利息日累计
        ,FINAL_FTP_ACCINT_MONTH  --最终FTP利息月累计
        ,FINAL_FTP_ACCINT_QUAR  --最终FTP利息季累计
        ,FINAL_FTP_ACCINT_YEAR  --最终FTP利息年累计
        ,BASE_UNLOCK_FTP_ACCINT_DAY  --原始非锁定FTP利息日累计
        ,BASE_UNLOCK_FTP_ACCINT_MONTH  --原始非锁定FTP利息月累计
        ,BASE_UNLOCK_FTP_ACCINT_QUAR  --原始非锁定FTP利息季累计
        ,BASE_UNLOCK_FTP_ACCINT_YEAR  --原始非锁定FTP利息年累计
        ,MID_UNLOCK_FTP_ACCINT_DAY  --内生性调节后非锁定FTP利息日累计
        ,MID_UNLOCK_FTP_ACCINT_MONTH  --内生性调节后非锁定FTP利息月累计
        ,MID_UNLOCK_FTP_ACCINT_QUAR  --内生性调节后非锁定FTP利息季累计
        ,MID_UNLOCK_FTP_ACCINT_YEAR  --内生性调节后非锁定FTP利息年累计
        ,FINAL_UNLOCK_FTP_ACCINT_DAY  --最终非锁定FTP利息日累计
        ,FINAL_UNLOCK_FTP_ACCINT_MONTH  --最终非锁定FTP利息月累计
        ,FINAL_UNLOCK_FTP_ACCINT_QUAR  --最终非锁定FTP利息季累计
        ,FINAL_UNLOCK_FTP_ACCINT_YEAR  --最终非锁定FTP利息年累计
        ,ADJUST_01_RATE  --调节项1点差
        ,ADJUST_01_ACCINT_DAY  --调节项1金额日累计
        ,ADJUST_01_ACCINT_MONTH  --调节项1金额月累计
        ,ADJUST_01_ACCINT_QUAR  --调节项1金额季累计
        ,ADJUST_01_ACCINT_YEAR  --调节项1金额年累计
        ,ADJUST_02_RATE  --调节项2点差
        ,ADJUST_02_ACCINT_DAY  --调节项2金额日累计
        ,ADJUST_02_ACCINT_MONTH  --调节项2金额月累计
        ,ADJUST_02_ACCINT_QUAR  --调节项2金额季累计
        ,ADJUST_02_ACCINT_YEAR  --调节项2金额年累计
        ,ADJUST_03_RATE  --调节项3点差
        ,ADJUST_03_ACCINT_DAY  --调节项3金额日累计
        ,ADJUST_03_ACCINT_MONTH  --调节项3金额月累计
        ,ADJUST_03_ACCINT_QUAR  --调节项3金额季累计
        ,ADJUST_03_ACCINT_YEAR  --调节项3金额年累计
        ,ADJUST_04_RATE  --调节项4点差
        ,ADJUST_04_ACCINT_DAY  --调节项4金额日累计
        ,ADJUST_04_ACCINT_MONTH  --调节项4金额月累计
        ,ADJUST_04_ACCINT_QUAR  --调节项4金额季累计
        ,ADJUST_04_ACCINT_YEAR  --调节项4金额年累计
        ,ADJUST_05_RATE  --调节项5点差
        ,ADJUST_05_ACCINT_DAY  --调节项5金额日累计
        ,ADJUST_05_ACCINT_MONTH  --调节项5金额月累计
        ,ADJUST_05_ACCINT_QUAR  --调节项5金额季累计
        ,ADJUST_05_ACCINT_YEAR  --调节项5金额年累计
        ,ADJUST_06_RATE  --调节项6点差
        ,ADJUST_06_ACCINT_DAY  --调节项6金额日累计
        ,ADJUST_06_ACCINT_MONTH  --调节项6金额月累计
        ,ADJUST_06_ACCINT_QUAR  --调节项6金额季累计
        ,ADJUST_06_ACCINT_YEAR  --调节项6金额年累计
        ,ADJUST_07_RATE  --调节项7点差
        ,ADJUST_07_ACCINT_DAY  --调节项7金额日累计
        ,ADJUST_07_ACCINT_MONTH  --调节项7金额月累计
        ,ADJUST_07_ACCINT_QUAR  --调节项7金额季累计
        ,ADJUST_07_ACCINT_YEAR  --调节项7金额年累计
        ,ADJUST_08_RATE  --调节项8点差
        ,ADJUST_08_ACCINT_DAY  --调节项8金额日累计
        ,ADJUST_08_ACCINT_MONTH  --调节项8金额月累计
        ,ADJUST_08_ACCINT_QUAR  --调节项8金额季累计
        ,ADJUST_08_ACCINT_YEAR  --调节项8金额年累计
        ,ADJUST_09_RATE  --调节项9点差
        ,ADJUST_09_ACCINT_DAY  --调节项9金额日累计
        ,ADJUST_09_ACCINT_MONTH  --调节项9金额月累计
        ,ADJUST_09_ACCINT_QUAR  --调节项9金额季累计
        ,ADJUST_09_ACCINT_YEAR  --调节项9金额年累计
        ,ADJUST_10_RATE  --调节项10点差
        ,ADJUST_10_ACCINT_DAY  --调节项10金额日累计
        ,ADJUST_10_ACCINT_MONTH  --调节项10金额月累计
        ,ADJUST_10_ACCINT_QUAR  --调节项10金额季累计
        ,ADJUST_10_ACCINT_YEAR  --调节项10金额年累计
        ,ADJUST_11_RATE  --调节项11点差
        ,ADJUST_11_ACCINT_DAY  --调节项11金额日累计
        ,ADJUST_11_ACCINT_MONTH  --调节项11金额月累计
        ,ADJUST_11_ACCINT_QUAR  --调节项11金额季累计
        ,ADJUST_11_ACCINT_YEAR  --调节项11金额年累计
        ,ADJUST_12_RATE  --调节项12点差
        ,ADJUST_12_ACCINT_DAY  --调节项12金额日累计
        ,ADJUST_12_ACCINT_MONTH  --调节项12金额月累计
        ,ADJUST_12_ACCINT_QUAR  --调节项12金额季累计
        ,ADJUST_12_ACCINT_YEAR  --调节项12金额年累计
        ,ADJUST_13_RATE  --调节项13点差
        ,ADJUST_13_ACCINT_DAY  --调节项13金额日累计
        ,ADJUST_13_ACCINT_MONTH  --调节项13金额月累计
        ,ADJUST_13_ACCINT_QUAR  --调节项13金额季累计
        ,ADJUST_13_ACCINT_YEAR  --调节项13金额年累计
        ,ADJUST_14_RATE  --调节项14点差
        ,ADJUST_14_ACCINT_DAY  --调节项14金额日累计
        ,ADJUST_14_ACCINT_MONTH  --调节项14金额月累计
        ,ADJUST_14_ACCINT_QUAR  --调节项14金额季累计
        ,ADJUST_14_ACCINT_YEAR  --调节项14金额年累计
        ,ADJUST_15_RATE  --调节项15点差
        ,ADJUST_15_ACCINT_DAY  --调节项15金额日累计
        ,ADJUST_15_ACCINT_MONTH  --调节项15金额月累计
        ,ADJUST_15_ACCINT_QUAR  --调节项15金额季累计
        ,ADJUST_15_ACCINT_YEAR  --调节项15金额年累计
        ,ADJUST_16_RATE  --调节项16点差
        ,ADJUST_16_ACCINT_DAY  --调节项16金额日累计
        ,ADJUST_16_ACCINT_MONTH  --调节项16金额月累计
        ,ADJUST_16_ACCINT_QUAR  --调节项16金额季累计
        ,ADJUST_16_ACCINT_YEAR  --调节项16金额年累计
        ,ADJUST_17_RATE  --调节项17点差
        ,ADJUST_17_ACCINT_DAY  --调节项17金额日累计
        ,ADJUST_17_ACCINT_MONTH  --调节项17金额月累计
        ,ADJUST_17_ACCINT_QUAR  --调节项17金额季累计
        ,ADJUST_17_ACCINT_YEAR  --调节项17金额年累计
        ,ADJUST_18_RATE  --调节项18点差
        ,ADJUST_18_ACCINT_DAY  --调节项18金额日累计
        ,ADJUST_18_ACCINT_MONTH  --调节项18金额月累计
        ,ADJUST_18_ACCINT_QUAR  --调节项18金额季累计
        ,ADJUST_18_ACCINT_YEAR  --调节项18金额年累计
        ,ADJUST_19_RATE  --调节项19点差
        ,ADJUST_19_ACCINT_DAY  --调节项19金额日累计
        ,ADJUST_19_ACCINT_MONTH  --调节项19金额月累计
        ,ADJUST_19_ACCINT_QUAR  --调节项19金额季累计
        ,ADJUST_19_ACCINT_YEAR  --调节项19金额年累计
        ,ADJUST_20_RATE  --调节项20点差
        ,ADJUST_20_ACCINT_DAY  --调节项20金额日累计
        ,ADJUST_20_ACCINT_MONTH  --调节项20金额月累计
        ,ADJUST_20_ACCINT_QUAR  --调节项20金额季累计
        ,ADJUST_20_ACCINT_YEAR  --调节项20金额年累计
        ,INC_SPRED_ACCINT_DAY  --价差收益日累计
        ,INC_SPRED_ACCINT_MONTH  --价差收益月累计
        ,INC_SPRED_ACCINT_QUAR  --价差收益季累计
        ,INC_SPRED_ACCINT_YEAR  --价差收益年累计
        ,EXCHANGE_TO_CNY_RATE  --折人民币汇率
        ,EXCHANGE_TO_USD_RATE  --折美元汇率
        ,ETL_DT  --ETL处理日期
        ,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IOL.V_FTPS_RPT_RST_FTP261
       --视图-FTP初级报表账户明细结果集
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

  END ETL_INIT_O_IOL_FTPS_RPT_RST_FTP261 ;
/

