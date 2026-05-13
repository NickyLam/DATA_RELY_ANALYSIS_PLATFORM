CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02
  *  功能描述：花呗汇总记账文件
  *  创建日期：20230114
  *  开发人员：MW
  *  来源表： IOL.V_ICMS_MYHB_AC_SUMMARY_TRANS_02
  *  目标表： O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230114  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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
  --DELETE FROM O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02 T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-花呗汇总记账文件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02
  (
							SETTLEDATE  --业务日期
							,REGIONCODE  --行政区划代码
							,PAYABLEFEEAMT  --应付平台服务费汇总金额
							,FEEAMT  --实付平台服务费汇总金额
							,RECEIVABLESUBSIDYINTAMT  --贴息计提(表内)
							,PAIDSUBSIDYINTAMT  --实还贴息(表内)
							,ACCRUEDINTAMT  --短期正常/逾期90天以内(含)贷款计提每日利息(表内)
							,NONACCRUEDINTAMT  --短期逾期90天以上贷款计提每日利息(表外)
							,ENCASHAMT  --当天贷款发放金额
							,ACCRUEDOVDPRINPNLTAMT  --短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)
							,NONACCRUEDOVDPRINPNLTAMT  --短期逾期90天以上贷款计提每日逾期本金罚息(表外)
							,ACCRUEDOVDINTPNLTAMT  --短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)
							,NONACCRUEDOVDINTPNLTAMT  --短期逾期90天以上贷款计提每日逾期利息罚息(表外)
							,PRINTOOVDPRINAMT  --正常本金转逾期本金
							,INTTOOVDINTAMT  --正常利息转逾期利息
							,NONPRINTONONOVDPRINAMT  --正常本金(非应计)转逾期本金(非应计)
							,OUTINTTOOUTOVDINTAMT  --正常利息(表外)转逾期利息(表外)
							,ACCRUEDTONONPRINAMT  --正常本金(应计)转正常本金(非应计)
							,ACCRUEDTONONOVDPRINAMT  --逾期本金(应计)转逾期本金(非应计)
							,INTERNALTOOUTINTAMT  --正常利息(表内)转正常利息(表外)
							,INTERNALTOOUTOVDINTAMT  --逾期利息(表内)转逾期利息(表外)
							,INTERNALTOOUTOVDPRINPNLTAMT  --逾期本金罚息(表内)转逾期本金罚息(表外)
							,INTERNALTOOUTOVDINTPNLTAMT  --逾期利息罚息(表内)转逾期利息罚息(表外)
							,NONTOACCRUEDPRINAMT  --正常本金(非应计)转正常本金(应计)
							,NONTOACCRUEDOVDPRINAMT  --逾期本金(非应计)转逾期本金(应计)
							,OUTTOINTERNALINTAMT  --正常利息(表外)转正常利息(表内)
							,OUTTOINTERNALOVDINTAMT  --逾期利息(表外)转逾期利息(表内)
							,OUTTOINTERNALOVDPRINPNLTAMT  --逾期本金罚息(表外)转逾本金罚息(表内)
							,OUTTOINTERNALOVDINTPNLTAMT  --逾期利息罚息(表外)转逾期利息罚息(表内)
							,PAIDPRINAMT  --实还正常本金(应计)
							,PAIDNONACCRUEDPRINAMT  --实还正常本金(非应计)
							,PAIDACCRUEDOVDPRINAMT  --实还逾期本金(应计)
							,PAIDNONACCRUEDOVDPRINAMT  --实还逾期本金(非应计)
							,PAIDINTAMT  --实还正常利息(表内)
							,PAIDOUTINTAMT  --实还正常利息(表外)
							,PAIDINTERNALOVDINTAMT  --实还逾期利息(表内)
							,PAIDOUTOVDINTAMT  --实还逾期利息(表外)
							,PAIDINTERNALOVDPRINPNLTINTAMT  --实还逾期本金罚息(表内)
							,PAIDOUTOVDPRINPNLTINTAMT  --实还逾期本金罚息(表外)
							,PAIDINTERNALOVDINTPNLTINTAMT  --实还逾期利息罚息(表内)
							,PAIDOUTOVDINTPNLTINTAMT  --实还逾期利息罚息(表外)
							,EXEMPTINTAMT  --减免正常利息(表内)
							,EXEMPTOUTINTAMT  --减免正常利息(表外)
							,EXEMPTINTERNALOVDINTAMT  --减免逾期利息(表内)
							,EXEMPTOUTOVDINTAMT  --减免逾期利息(表外)
							,EXEMPTINTERNALOVDPRINPNLTINTAMT  --减免逾期本金罚息(表内)
							,EXEMPTOUTOVDPRINPNLTINTAMT  --减免逾期本金罚息(表外)
							,EXEMPTINTERNALOVDINTPNLTINTAMT  --减免逾期利息罚息(表内)
							,EXEMPTOUTOVDINTPNLTINTAMT  --减免逾期利息罚息(表外)
							,PRINTOPRINAMTRLV  --正常本金转正常本金
							,OVDPRINTOPRINAMTRLV  --逾期本金转正常本金
							,NONTOPRINAMTRLV  --正常本金(非应计)转正常本金
							,NONPRINTOPRINAMTRLV  --逾期本金(非应计)转正常本金
							,INTTOINTAMTRLV  --正常利息转正常利息
							,OUTINTTOINTAMTRLV  --正常利息(表外)转正常利息
							,OVDINTTOINTAMTRLV  --逾期利息(表内)转正常利息
							,OUTOVDINTTOINTAMTRLV  --逾期利息(表外)转正常利息
							,WRITEOFFOVDPRINTOPRINAMTRLV  --逾期本金（核销）转正常本金
							,WRITEOFFOVDINTTOINTAMTRLV  --逾期利息（核销）转正常利息
							,PRINTOPRINAMTINST  --正常本金转正常本金
							,OVDPRINTOPRINAMTINST  --逾期本金转正常本金
							,NONACCRUEDPRINAMTINST  --正常本金(非应计)转正常本金
							,NONACCRUEDTOPRINAMTINST  --逾期本金(非应计)转正常本金
							,WRITEOFFPRINTOPRINAMTINST  --正常本金（核销）转正常本金
							,PRINTOPRINMEDIUM  --正常本金转正常本金
							,NONPRINTOPRINMEDIUM  --正常本金（非应计）转正常本金（应计）
							,WFPRINTOPRINMEDIUM  --正常本金（核销）转正常本金（应计）
							,WRITEOFFNONPRINAMT  --已减值正常贷款本金核销
							,WRITEOFFNONOVDPRINAMT  --已减值逾期贷款本金核销
							,WRITEOFFOUTINTAMT  --正常贷款利息（表外）核销
							,WRITEOFFOUTOVDINTAMT  --逾期贷款利息（表外）核销
							,WRITEOFFOUTOVDPRINPNLTAMT  --逾期本金罚息（表外）核销
							,WRITEOFFOUTOVDINTPNLTAMT  --逾期利息罚息（表外）核销
							,WRITEOFFINTAMT  --已核销的贷款正常利息计提
							,WRITEOFFOVDPRINPNLTAMT  --已核销的贷款逾期本金罚息计提
							,WRITEOFFOVDINTPNLTAMT  --已核销的贷款逾期利息罚息计提
							,WRITEOFFPRINTOOVDPRINAMT  --已核销的贷款本金转逾期
							,WRITEOFFINTTOOVDINTAMT  --已核销的贷款利息转逾期
							,PAIDWRITEOFFPRINAMT  --实还已核销正常本金
							,PAIDWRITEOFFOVDPRINAMT  --实还已核销逾期本金
							,PAIDWRITEOFFINTAMT  --实还已核销正常利息
							,PAIDWRITEOFFOVDINTAMT  --实还已核销逾期利息
							,PAIDWRITEOFFOVDPRINPNLTINTAMT  --实还已核销本金罚息
							,PAIDWRITEOFFOVDINTPNLTINTAMT  --实还已核销利息罚息
							,EXEMPTWRITEOFFINTAMT  --减免已核销正常利息
							,EXEMPTWRITEOFFOVDINTAMT  --减免已核销逾期利息
							,EXEMPTWRITEOFFOVDPRINPNLTINTAMT  --减免已核销本金罚息
							,EXEMPTWRITEOFFOVDINTPNLTINTAMT  --减免已核销利息罚息
							,LOANTRANSITDEPOSIT  --放款待结算调拨回流金额
							,REPAYTRANSITWITHDRAW  --还款待结算调拨流入金额
							,LOANTRANSITWITHDRAW  --放款待结算调拨回流金额
							,ETL_DT  --ETL处理日期
							,ETL_TIMESTAMP  --ETL处理时间戳


	)
    SELECT
							SETTLEDATE  --业务日期
							,REGIONCODE  --行政区划代码
							,PAYABLEFEEAMT  --应付平台服务费汇总金额
							,FEEAMT  --实付平台服务费汇总金额
							,RECEIVABLESUBSIDYINTAMT  --贴息计提(表内)
							,PAIDSUBSIDYINTAMT  --实还贴息(表内)
							,ACCRUEDINTAMT  --短期正常/逾期90天以内(含)贷款计提每日利息(表内)
							,NONACCRUEDINTAMT  --短期逾期90天以上贷款计提每日利息(表外)
							,ENCASHAMT  --当天贷款发放金额
							,ACCRUEDOVDPRINPNLTAMT  --短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)
							,NONACCRUEDOVDPRINPNLTAMT  --短期逾期90天以上贷款计提每日逾期本金罚息(表外)
							,ACCRUEDOVDINTPNLTAMT  --短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)
							,NONACCRUEDOVDINTPNLTAMT  --短期逾期90天以上贷款计提每日逾期利息罚息(表外)
							,PRINTOOVDPRINAMT  --正常本金转逾期本金
							,INTTOOVDINTAMT  --正常利息转逾期利息
							,NONPRINTONONOVDPRINAMT  --正常本金(非应计)转逾期本金(非应计)
							,OUTINTTOOUTOVDINTAMT  --正常利息(表外)转逾期利息(表外)
							,ACCRUEDTONONPRINAMT  --正常本金(应计)转正常本金(非应计)
							,ACCRUEDTONONOVDPRINAMT  --逾期本金(应计)转逾期本金(非应计)
							,INTERNALTOOUTINTAMT  --正常利息(表内)转正常利息(表外)
							,INTERNALTOOUTOVDINTAMT  --逾期利息(表内)转逾期利息(表外)
							,INTERNALTOOUTOVDPRINPNLTAMT  --逾期本金罚息(表内)转逾期本金罚息(表外)
							,INTERNALTOOUTOVDINTPNLTAMT  --逾期利息罚息(表内)转逾期利息罚息(表外)
							,NONTOACCRUEDPRINAMT  --正常本金(非应计)转正常本金(应计)
							,NONTOACCRUEDOVDPRINAMT  --逾期本金(非应计)转逾期本金(应计)
							,OUTTOINTERNALINTAMT  --正常利息(表外)转正常利息(表内)
							,OUTTOINTERNALOVDINTAMT  --逾期利息(表外)转逾期利息(表内)
							,OUTTOINTERNALOVDPRINPNLTAMT  --逾期本金罚息(表外)转逾本金罚息(表内)
							,OUTTOINTERNALOVDINTPNLTAMT  --逾期利息罚息(表外)转逾期利息罚息(表内)
							,PAIDPRINAMT  --实还正常本金(应计)
							,PAIDNONACCRUEDPRINAMT  --实还正常本金(非应计)
							,PAIDACCRUEDOVDPRINAMT  --实还逾期本金(应计)
							,PAIDNONACCRUEDOVDPRINAMT  --实还逾期本金(非应计)
							,PAIDINTAMT  --实还正常利息(表内)
							,PAIDOUTINTAMT  --实还正常利息(表外)
							,PAIDINTERNALOVDINTAMT  --实还逾期利息(表内)
							,PAIDOUTOVDINTAMT  --实还逾期利息(表外)
							,PAIDINTERNALOVDPRINPNLTINTAMT  --实还逾期本金罚息(表内)
							,PAIDOUTOVDPRINPNLTINTAMT  --实还逾期本金罚息(表外)
							,PAIDINTERNALOVDINTPNLTINTAMT  --实还逾期利息罚息(表内)
							,PAIDOUTOVDINTPNLTINTAMT  --实还逾期利息罚息(表外)
							,EXEMPTINTAMT  --减免正常利息(表内)
							,EXEMPTOUTINTAMT  --减免正常利息(表外)
							,EXEMPTINTERNALOVDINTAMT  --减免逾期利息(表内)
							,EXEMPTOUTOVDINTAMT  --减免逾期利息(表外)
							,EXEMPTINTERNALOVDPRINPNLTINTAMT  --减免逾期本金罚息(表内)
							,EXEMPTOUTOVDPRINPNLTINTAMT  --减免逾期本金罚息(表外)
							,EXEMPTINTERNALOVDINTPNLTINTAMT  --减免逾期利息罚息(表内)
							,EXEMPTOUTOVDINTPNLTINTAMT  --减免逾期利息罚息(表外)
							,PRINTOPRINAMTRLV  --正常本金转正常本金
							,OVDPRINTOPRINAMTRLV  --逾期本金转正常本金
							,NONTOPRINAMTRLV  --正常本金(非应计)转正常本金
							,NONPRINTOPRINAMTRLV  --逾期本金(非应计)转正常本金
							,INTTOINTAMTRLV  --正常利息转正常利息
							,OUTINTTOINTAMTRLV  --正常利息(表外)转正常利息
							,OVDINTTOINTAMTRLV  --逾期利息(表内)转正常利息
							,OUTOVDINTTOINTAMTRLV  --逾期利息(表外)转正常利息
							,WRITEOFFOVDPRINTOPRINAMTRLV  --逾期本金（核销）转正常本金
							,WRITEOFFOVDINTTOINTAMTRLV  --逾期利息（核销）转正常利息
							,PRINTOPRINAMTINST  --正常本金转正常本金
							,OVDPRINTOPRINAMTINST  --逾期本金转正常本金
							,NONACCRUEDPRINAMTINST  --正常本金(非应计)转正常本金
							,NONACCRUEDTOPRINAMTINST  --逾期本金(非应计)转正常本金
							,WRITEOFFPRINTOPRINAMTINST  --正常本金（核销）转正常本金
							,PRINTOPRINMEDIUM  --正常本金转正常本金
							,NONPRINTOPRINMEDIUM  --正常本金（非应计）转正常本金（应计）
							,WFPRINTOPRINMEDIUM  --正常本金（核销）转正常本金（应计）
							,WRITEOFFNONPRINAMT  --已减值正常贷款本金核销
							,WRITEOFFNONOVDPRINAMT  --已减值逾期贷款本金核销
							,WRITEOFFOUTINTAMT  --正常贷款利息（表外）核销
							,WRITEOFFOUTOVDINTAMT  --逾期贷款利息（表外）核销
							,WRITEOFFOUTOVDPRINPNLTAMT  --逾期本金罚息（表外）核销
							,WRITEOFFOUTOVDINTPNLTAMT  --逾期利息罚息（表外）核销
							,WRITEOFFINTAMT  --已核销的贷款正常利息计提
							,WRITEOFFOVDPRINPNLTAMT  --已核销的贷款逾期本金罚息计提
							,WRITEOFFOVDINTPNLTAMT  --已核销的贷款逾期利息罚息计提
							,WRITEOFFPRINTOOVDPRINAMT  --已核销的贷款本金转逾期
							,WRITEOFFINTTOOVDINTAMT  --已核销的贷款利息转逾期
							,PAIDWRITEOFFPRINAMT  --实还已核销正常本金
							,PAIDWRITEOFFOVDPRINAMT  --实还已核销逾期本金
							,PAIDWRITEOFFINTAMT  --实还已核销正常利息
							,PAIDWRITEOFFOVDINTAMT  --实还已核销逾期利息
							,PAIDWRITEOFFOVDPRINPNLTINTAMT  --实还已核销本金罚息
							,PAIDWRITEOFFOVDINTPNLTINTAMT  --实还已核销利息罚息
							,EXEMPTWRITEOFFINTAMT  --减免已核销正常利息
							,EXEMPTWRITEOFFOVDINTAMT  --减免已核销逾期利息
							,EXEMPTWRITEOFFOVDPRINPNLTINTAMT  --减免已核销本金罚息
							,EXEMPTWRITEOFFOVDINTPNLTINTAMT  --减免已核销利息罚息
							,LOANTRANSITDEPOSIT  --放款待结算调拨回流金额
							,REPAYTRANSITWITHDRAW  --还款待结算调拨流入金额
							,LOANTRANSITWITHDRAW  --放款待结算调拨回流金额
							,ETL_DT  --ETL处理日期
							,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ICMS_MYHB_AC_SUMMARY_TRANS_02  --视图-花呗汇总记账文件
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
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

  END ETL_O_IOL_ICMS_MYHB_AC_SUMMARY_TRANS_02;
/

