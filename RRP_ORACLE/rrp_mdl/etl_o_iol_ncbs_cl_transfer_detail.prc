CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_CL_TRANSFER_DETAIL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_CL_TRANSFER_DETAIL
  *  功能描述：资产转让合同明细表
  *  创建日期：20230509
  *  开发人员：梅炜
  *  来源表： IOL.V_NCBS_CL_TRANSFER_DETAIL
  *  目标表： O_IOL_NCBS_CL_TRANSFER_DETAIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    2023/05/31  梅炜     首次创建
  *             2    20250106   YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_CL_TRANSFER_DETAIL'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1 ; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-资产转让合同明细表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_NCBS_CL_TRANSFER_DETAIL
  (  ASSET_ACCT_STATUS			--资产账户状态
    ,BALANCE			          --余额
    ,CCY			              --币种
    ,CLIENT_NO			        --客户编号
    ,DD_NO			            --发放号
    ,INTERNAL_KEY			      --账户内部键值
    ,PROD_TYPE			        --产品编号
    ,CMISLOAN_NO			      --客户借据编号
    ,COMPANY			          --法人
    ,NARRATIVE			        --摘要
    ,SALE_BATCH_NO			    --发行批次号
    ,ACCOUNTING_STATUS			--核算状态
    ,LAST_CHANGE_DATE			  --最后修改日期
    ,TRAN_TIMESTAMP			    --交易时间戳
    ,LOAN_NO			          --贷款号
    ,PACK_REFERENCE			    --资产证券化封包流水号
    ,SALE_REFERENCE			    --发行流水号
    ,SALE_CANCEL_BATCH_NO		--发行撤销批次号
    ,AMORTIZED_INT			    --已摊销利息
    ,CIRCLE_BUY_FLAG			  --循环购买标志
    ,CIRCLE_BUY_REFERENCE		--循环购买流水号
    ,PACK_CANCEL_BATCH_NO		--撤包批次号
    ,CIRCLE_BUY_DATE			  --循环购买日期
    ,SALE_FLOAT_AMOUNT			--发行折溢价
    ,CIRCLE_BUY_BATCH_NO		--循环购买批次号
    ,SALE_CANCEL_REFERENCE	--资产发行撤销交易参考号
    ,REDEEM_REFERENCE			  --赎回交易流水号
    ,PACK_BATCH_NO			    --封包批次号
    ,PACK_CANCEL_REFERENCE	--撤包交易流水号
    ,ASSET_DETAIL_SEQ_NO		--资产包合同明细序号
    ,REDEEM_DATE			      --资产赎回日期
    ,REDEEM_BATCH_NO			  --赎回批次号
    ,PACK_TRAN_DATE			    --封包交易日期
    ,ASSET_CONTRACT_SEQ_NO	--资产包合同序号
    ,REDEEM_FLOAT_AMOUNT		--赎回折溢价
    ,START_DT			          --开始时间
    ,END_DT			            --结束时间
    ,ID_MARK			          --增删标志
    )
    SELECT
     ASSET_ACCT_STATUS			--资产账户状态
    ,BALANCE			          --余额
    ,CCY			              --币种
    ,CLIENT_NO			        --客户编号
    ,DD_NO			            --发放号
    ,INTERNAL_KEY			      --账户内部键值
    ,PROD_TYPE			        --产品编号
    ,CMISLOAN_NO			      --客户借据编号
    ,COMPANY			          --法人
    ,NARRATIVE			        --摘要
    ,SALE_BATCH_NO			    --发行批次号
    ,ACCOUNTING_STATUS			--核算状态
    ,LAST_CHANGE_DATE			  --最后修改日期
    ,TRAN_TIMESTAMP			    --交易时间戳
    ,LOAN_NO			          --贷款号
    ,PACK_REFERENCE			    --资产证券化封包流水号
    ,SALE_REFERENCE			    --发行流水号
    ,SALE_CANCEL_BATCH_NO		--发行撤销批次号
    ,AMORTIZED_INT			    --已摊销利息
    ,CIRCLE_BUY_FLAG			  --循环购买标志
    ,CIRCLE_BUY_REFERENCE		--循环购买流水号
    ,PACK_CANCEL_BATCH_NO		--撤包批次号
    ,CIRCLE_BUY_DATE			  --循环购买日期
    ,SALE_FLOAT_AMOUNT			--发行折溢价
    ,CIRCLE_BUY_BATCH_NO		--循环购买批次号
    ,SALE_CANCEL_REFERENCE	--资产发行撤销交易参考号
    ,REDEEM_REFERENCE			  --赎回交易流水号
    ,PACK_BATCH_NO			    --封包批次号
    ,PACK_CANCEL_REFERENCE	--撤包交易流水号
    ,ASSET_DETAIL_SEQ_NO		--资产包合同明细序号
    ,REDEEM_DATE			      --资产赎回日期
    ,REDEEM_BATCH_NO			  --赎回批次号
    ,PACK_TRAN_DATE			    --封包交易日期
    ,ASSET_CONTRACT_SEQ_NO	--资产包合同序号
    ,REDEEM_FLOAT_AMOUNT		--赎回折溢价
    ,START_DT			          --开始时间
    ,END_DT			            --结束时间
    ,ID_MARK			          --增删标志
    FROM IOL.V_NCBS_CL_TRANSFER_DETAIL  --视图-资产转让合同明细表
    WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
      AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      AND ID_MARK <> 'D';


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


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

  END ETL_O_IOL_NCBS_CL_TRANSFER_DETAIL;
/

