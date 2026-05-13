CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_AP_REGISTER_PROGRAM(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_AP_REGISTER_PROGRAM
  *  功能描述：单户资产登记方案表
  *  创建日期：20251126
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_AP_REGISTER_PROGRAM
  *  目标表： O_IOL_ICMS_AP_REGISTER_PROGRAM
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
  *************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_AP_REGISTER_PROGRAM'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_AP_REGISTER_PROGRAM';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-单户资产登记方案表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_AP_REGISTER_PROGRAM NOLOGGING
    (       SERIALNO                      --流水号
           ,PROGRAMNO                     --方案编号
           ,PROGRAMNAME                   --方案名称
           ,CUSTOMERNAME                  --方案涉及借款人
           ,HANDLETYPE                    --处置类型（不良资产转让）
           ,BUSINESSSUM                   --合同金额合计
           ,BALANCESUM                    --合同余额合计
           ,RECEIVEAMONUT                 --财务应收款
           ,ONINTERESTSUM                 --表外利息余额合计
           ,OUTINTERESTSUM                --表外利息余额合计
           ,PECUNIACREDITASUM             --债权金额合计
           ,TRANSFERPRICE                 --转让价格
           ,PAYRECEIVEAMONUT              --偿还财务应收款
           ,PAYLOWAMONUT                  --偿还法律应收款
           ,PAYLOWCOST                    --偿还法律性费用
           ,PAYSUM                        --偿还本金
           ,PAYINTEREST                   --偿还利息
           ,TRANSFERWAY                   --债权转让方式一（CD060034）
           ,OTHERTRANSFERWAY              --债权转让方式二（CD060035）
           ,RESPINVESTIGATIONDATE         --卖方尽职调查基准日
           ,RESPINVESTIGATIONORG          --卖方尽职调查中介机构名称
           ,VENDEENAME                    --买受人名称
           ,REMARK                        --备注
           ,INPUTUSERID                   --登记人
           ,INPUTORGID                    --登记机构
           ,INPUTDATE                     --登记日期
           ,UPDATEDATE                    --更新日期
           ,UPDATEUSERID                  --更新人
           ,UPDATEORGID                   --更新机构
           ,LITIGATIONPHASECOST           --诉讼阶段法律性费用（元）
           ,CANCELACCOUNTCAPBALDEPOS      --账销案存资产本金余额（元）
           ,CANCELACCOUNTCAPINOWEBALANCE  --账销案存资产表内欠息余额（元）
           ,CANCELACCOUNTCAPOUTOWEBALANCE --账销案存资产表外欠息余额（元）
           ,SUMMARIZE                     --方案综述
           ,RISKASSETLIST                 --风险资产清单
           ,SAVEFLAG                      --保存标志
           ,EXECUTESTATUS                 --执行状态(CodeNo:ExecuteResult)
           ,PACKAGEDATE                   --封包日期
           ,TRANSFERFLAG                  --转让标志(CodeNo:TransferFlag)
           ,CURRENCY                      --币种
           ,TRANSFERORG                   --变更后机构
           ,AGENTLEGALFEE                 --代垫诉讼费
           ,REPAYMODE                     --付款方式（一次性付款、分期付款）
           ,DOWNPAYMENT                   --首付金额
           ,ONACCOUNTNO                   --挂账编号
           ,TRANSCONTRACTNO               --转让合同号
           ,COUNTERPARTYACCTNAME          --交易对手名称
           ,COUNTERPARTYACCT              --交易对手账号
           ,OPENBANKNAME                  --交易对手开户行名称
           ,OPENBANKNO                    --交易对手开户行行号
           ,COUNTERPARTYACCTTYPE          --交易对手类型
           ,TRANSCONTRACTSTARTDATE        --转让合同起始日期
           ,TRANSCONTRACTENDDATE          --转让合同到期日期
           ,TRANSTRADPLATFORM             --转让交易平台
           ,TRANSTRADPLATFORMCUS          --转让交易平台（自定义）
           ,COUNTERPARTYPAYDATE           --交易对手转账日期
           ,ISADDREC                      --是否补录
           ,START_DT                      --开始时间
           ,END_DT                        --结束时间
           ,ID_MARK                       --增删标志
           ,ETL_TIMESTAMP                 --ETL处理时间戳
           ,COUNTERPARTYACCTCERTTYPE	    --交易对手证件类型
           ,COUNTERPARTYACCTCERTID	      --交易对手证件号码
     )
  SELECT /*+PARALLEL*/
            SERIALNO                      --流水号
           ,PROGRAMNO                     --方案编号
           ,PROGRAMNAME                   --方案名称
           ,CUSTOMERNAME                  --方案涉及借款人
           ,HANDLETYPE                    --处置类型（不良资产转让）
           ,BUSINESSSUM                   --合同金额合计
           ,BALANCESUM                    --合同余额合计
           ,RECEIVEAMONUT                 --财务应收款
           ,ONINTERESTSUM                 --表外利息余额合计
           ,OUTINTERESTSUM                --表外利息余额合计
           ,PECUNIACREDITASUM             --债权金额合计
           ,TRANSFERPRICE                 --转让价格
           ,PAYRECEIVEAMONUT              --偿还财务应收款
           ,PAYLOWAMONUT                  --偿还法律应收款
           ,PAYLOWCOST                    --偿还法律性费用
           ,PAYSUM                        --偿还本金
           ,PAYINTEREST                   --偿还利息
           ,TRANSFERWAY                   --债权转让方式一（CD060034）
           ,OTHERTRANSFERWAY              --债权转让方式二（CD060035）
           ,RESPINVESTIGATIONDATE         --卖方尽职调查基准日
           ,RESPINVESTIGATIONORG          --卖方尽职调查中介机构名称
           ,VENDEENAME                    --买受人名称
           ,REMARK                        --备注
           ,INPUTUSERID                   --登记人
           ,INPUTORGID                    --登记机构
           ,INPUTDATE                     --登记日期
           ,UPDATEDATE                    --更新日期
           ,UPDATEUSERID                  --更新人
           ,UPDATEORGID                   --更新机构
           ,LITIGATIONPHASECOST           --诉讼阶段法律性费用（元）
           ,CANCELACCOUNTCAPBALDEPOS      --账销案存资产本金余额（元）
           ,CANCELACCOUNTCAPINOWEBALANCE  --账销案存资产表内欠息余额（元）
           ,CANCELACCOUNTCAPOUTOWEBALANCE --账销案存资产表外欠息余额（元）
           ,SUMMARIZE                     --方案综述
           ,RISKASSETLIST                 --风险资产清单
           ,SAVEFLAG                      --保存标志
           ,EXECUTESTATUS                 --执行状态(CodeNo:ExecuteResult)
           ,PACKAGEDATE                   --封包日期
           ,TRANSFERFLAG                  --转让标志(CodeNo:TransferFlag)
           ,CURRENCY                      --币种
           ,TRANSFERORG                   --变更后机构
           ,AGENTLEGALFEE                 --代垫诉讼费
           ,REPAYMODE                     --付款方式（一次性付款、分期付款）
           ,DOWNPAYMENT                   --首付金额
           ,ONACCOUNTNO                   --挂账编号
           ,TRANSCONTRACTNO               --转让合同号
           ,COUNTERPARTYACCTNAME          --交易对手名称
           ,COUNTERPARTYACCT              --交易对手账号
           ,OPENBANKNAME                  --交易对手开户行名称
           ,OPENBANKNO                    --交易对手开户行行号
           ,COUNTERPARTYACCTTYPE          --交易对手类型
           ,TRANSCONTRACTSTARTDATE        --转让合同起始日期
           ,TRANSCONTRACTENDDATE          --转让合同到期日期
           ,TRANSTRADPLATFORM             --转让交易平台
           ,TRANSTRADPLATFORMCUS          --转让交易平台（自定义）
           ,COUNTERPARTYPAYDATE           --交易对手转账日期
           ,ISADDREC                      --是否补录
           ,START_DT                      --开始时间
           ,END_DT                        --结束时间
           ,ID_MARK                       --增删标志
           ,ETL_TIMESTAMP                 --ETL处理时间戳
           ,COUNTERPARTYACCTCERTTYPE	    --交易对手证件类型
           ,COUNTERPARTYACCTCERTID	      --交易对手证件号码
    FROM IOL.V_ICMS_AP_REGISTER_PROGRAM   --单户资产登记方案表
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

  END ETL_O_IOL_ICMS_AP_REGISTER_PROGRAM;
/

