CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_ASSET_PRESERVATION_APPLY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_ASSET_PRESERVATION_APPLY
  *  功能描述：资产保全（贷后）申请表
  *  创建日期：20251117
  *  开发人员：于敬艺
  *  来源表： IOL.V_ICMS_ASSET_PRESERVATION_APPLY
  *  目标表： O_IOL_ICMS_ASSET_PRESERVATION_APPLY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251117  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_ASSET_PRESERVATION_APPLY'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_ASSET_PRESERVATION_APPLY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-资产保全（贷后）申请表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_ASSET_PRESERVATION_APPLY NOLOGGING
    (    AFTERLOBJ                      --减免前本金合计(时点合计)
        ,AFTERLODDFY                   --减免前代垫费用合计(时点合计)
        ,AFTERLOFL                     --减免前复利合计(时点合计)
        ,AFTERLOFX                     --减免前罚息合计(时点合计)
        ,AFTERLOLX                     --减免前利息合计(时点合计)
        ,APPROVESTATUS                 --审批状态
        ,CLASSIFY                      --资产分类
        ,CONDITION                     --条件(原因)
        ,COUNTERPARTY                  --受让方（交易对手）
        ,COUNTERPARTYNAME              --受让方（交易对手）
        ,CUSTOMERID                    --客户编号
        ,CUSTOMERNAME                  --客户名称
        ,DDFYAMTSUM                    --代垫费用合计（本次交易）
        ,DUEBILLNUM                    --借据数量
        ,ESTABLISHMENT                 --内部户开立机构
        ,INPUTDATE                     --登记日期
        ,INPUTORGID                    --登记机构
        ,INPUTUSERID                   --登记人
        ,INTAMTSUM                     --利息合计（本次交易）
        ,ISBORROWERRECOURSE            --对借款人是否保留追索权
        ,ISGURANTYRECOURSE             --对保证人是否保留追索权
        ,ISPROPERTYCLUE                --是否存在财产线索
        ,LASTRETURNEDMONEYSUM          --上次累计回款金额
        ,OBJECTTYPE                    --对象类型
        ,OCCURTYPE                     --发生类型(01单户，02批量)
        ,ODIAMTSUM                     --复利合计（本次交易）
        ,ODPAMTSUM                     --罚息合计（本次交易）
        ,OPERATEDATE                   --经办时间
        ,OPERATEORGID                  --经办客户经理所属机构
        ,OPERATEUSERID                 --经办客户经理
        ,PRIAMTSUM                     --本金合计（本次交易）
        ,PROPERTYCLUE                  --财产线索简介
        ,RELATIVESERIALNO              --关联流水号（贷款转让流水号）
        ,REMARK                        --备注
        ,RETURNEDAFTERMONEY            --本次回款后应收款金额
        ,RETURNEDBEFOREMONEY           --本次回款前应收款金额
        ,RETURNEDMONEY                 --本次回款金额
        ,RETURNEDMONEYSUM              --累计回款金额
        ,SERIALNO                      --流水号
        ,SQAMOUNT                      --首期回款金额（含保证金）
        ,TRADINGPLATFORM               --交易平台
        ,TRANSFERACCOUNT               --转让回款账户（内部账户）
        ,TRANSFERACCOUNTNAME           --转让回款账户（内部账户）
        ,TRANSFERACTUALPRICE           --真实转让对价（元）
        ,TRANSFERCONTRACTNO            --转让合同号
        ,TRANSFERPRICE                 --转让价格
        ,TRANSFERTYPE                  --转让方式
        ,UPDATEDATE                    --更新日期
        ,UPDATEORGID                   --更新机构
        ,UPDATEUSERID                  --更新人
        ,USETOSSFDJ                    --用于归还诉讼费的对价（元）
        ,WRITEOFFTYPE                  --核销类型
        ,YSACCOUNT                     --应收款账户
        ,YSACCOUNTNAME                 --应收款账户名称
        ,YSAMOUNT                      --应收款金额
        ,DEBTREPAYASSETID              --抵债资产编号
        ,DEBTREPAYASSETNAME            --抵债资产名称
        ,DEBTREPAYSUM                  --抵债金额
        ,RECEIVEDATE                   --接收日期
        ,DEBTREPAYASSETTYPE            --抵债资产类型
        ,DEBTREPAYMENTTYPE             --抵债类型
        ,HANDLETYPE                    --处置方式
        ,HANDLEBALANCE                 --处置金额
        ,HANDLEDESC                    --处置说明
        ,DISPOSALDATE                  --生成时间
        ,CREDITBALANCE                 --授信余额
        ,LOSSAMOUNT                    --损失金额
        ,CUSTOMERTYPE                  --客户类型
        ,GURANTYTYPE                   --担保方式
        ,GURANTORINFO                  --保证人
        ,GURANTYINFO                   --抵（质）押物
        ,SSPROGRESS                    --诉讼进展
        ,DISPOSALPLAN                  --清收处置方案
        ,DISPOSALPROGRESS              --最新处置进展
        ,NEXTPLAN                      --下一步工作计划
        ,EXISTDIFFICULTY               --存在的困难
        ,DEDUCTSETTLEACCOUNT           --扣款结算账户
        ,DEDUCTSETTLEACCOUNTBALANCE    --扣款结算账户余额
        ,DEDUCTAMOUNT                  --扣划金额
        ,DEDUCTREASON                  --扣划理由
        ,ACCOUNTNO                     --挂账编号
        ,ISCOMPINTERESTFORGIVENESS     --是否利息全额减免
        ,PROGRAMNO                     --方案编号
        ,ISINSTALLMENT                 --是否分期付款标识
        ,COUNTERPARTYCERTTYPE          --受让方（交易对手）证件类型
        ,COUNTERPARTYCERTID            --受让方（交易对手）证件号
        ,QYDATE                        --签约日期
        ,SXDATE                        --生效日期
        ,CURRENCY                      --协议币种
        ,XYAMT                         --协议金额（元）
        ,BZJAMT                        --保证金金额（元）
        ,BZJRATE                       --保证金比例（%）
        ,BZJCURRENCY                   --保证金币种
        ,COUNTERPARTYZH                --交易对手账号
        ,COUNTERPARTYZHBANK            --交易对手账号行号
        ,COUNTERPARTYZZDATE            --交易对手转账日期
        ,FYCDSID                       --法院裁定书编号
        ,START_DT                      --开始时间
        ,END_DT                        --结束时间
        ,ID_MARK                       --增删标志
        ,ETL_TIMESTAMP                 --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
        AFTERLOBJ                      --减免前本金合计(时点合计)
        ,AFTERLODDFY                   --减免前代垫费用合计(时点合计)
        ,AFTERLOFL                     --减免前复利合计(时点合计)
        ,AFTERLOFX                     --减免前罚息合计(时点合计)
        ,AFTERLOLX                     --减免前利息合计(时点合计)
        ,APPROVESTATUS                 --审批状态
        ,CLASSIFY                      --资产分类
        ,CONDITION                     --条件(原因)
        ,COUNTERPARTY                  --受让方（交易对手）
        ,COUNTERPARTYNAME              --受让方（交易对手）
        ,CUSTOMERID                    --客户编号
        ,CUSTOMERNAME                  --客户名称
        ,DDFYAMTSUM                    --代垫费用合计（本次交易）
        ,DUEBILLNUM                    --借据数量
        ,ESTABLISHMENT                 --内部户开立机构
        ,INPUTDATE                     --登记日期
        ,INPUTORGID                    --登记机构
        ,INPUTUSERID                   --登记人
        ,INTAMTSUM                     --利息合计（本次交易）
        ,ISBORROWERRECOURSE            --对借款人是否保留追索权
        ,ISGURANTYRECOURSE             --对保证人是否保留追索权
        ,ISPROPERTYCLUE                --是否存在财产线索
        ,LASTRETURNEDMONEYSUM          --上次累计回款金额
        ,OBJECTTYPE                    --对象类型
        ,OCCURTYPE                     --发生类型(01单户，02批量)
        ,ODIAMTSUM                     --复利合计（本次交易）
        ,ODPAMTSUM                     --罚息合计（本次交易）
        ,OPERATEDATE                   --经办时间
        ,OPERATEORGID                  --经办客户经理所属机构
        ,OPERATEUSERID                 --经办客户经理
        ,PRIAMTSUM                     --本金合计（本次交易）
        ,PROPERTYCLUE                  --财产线索简介
        ,RELATIVESERIALNO              --关联流水号（贷款转让流水号）
        ,REMARK                        --备注
        ,RETURNEDAFTERMONEY            --本次回款后应收款金额
        ,RETURNEDBEFOREMONEY           --本次回款前应收款金额
        ,RETURNEDMONEY                 --本次回款金额
        ,RETURNEDMONEYSUM              --累计回款金额
        ,SERIALNO                      --流水号
        ,SQAMOUNT                      --首期回款金额（含保证金）
        ,TRADINGPLATFORM               --交易平台
        ,TRANSFERACCOUNT               --转让回款账户（内部账户）
        ,TRANSFERACCOUNTNAME           --转让回款账户（内部账户）
        ,TRANSFERACTUALPRICE           --真实转让对价（元）
        ,TRANSFERCONTRACTNO            --转让合同号
        ,TRANSFERPRICE                 --转让价格
        ,TRANSFERTYPE                  --转让方式
        ,UPDATEDATE                    --更新日期
        ,UPDATEORGID                   --更新机构
        ,UPDATEUSERID                  --更新人
        ,USETOSSFDJ                    --用于归还诉讼费的对价（元）
        ,WRITEOFFTYPE                  --核销类型
        ,YSACCOUNT                     --应收款账户
        ,YSACCOUNTNAME                 --应收款账户名称
        ,YSAMOUNT                      --应收款金额
        ,DEBTREPAYASSETID              --抵债资产编号
        ,DEBTREPAYASSETNAME            --抵债资产名称
        ,DEBTREPAYSUM                  --抵债金额
        ,RECEIVEDATE                   --接收日期
        ,DEBTREPAYASSETTYPE            --抵债资产类型
        ,DEBTREPAYMENTTYPE             --抵债类型
        ,HANDLETYPE                    --处置方式
        ,HANDLEBALANCE                 --处置金额
        ,HANDLEDESC                    --处置说明
        ,DISPOSALDATE                  --生成时间
        ,CREDITBALANCE                 --授信余额
        ,LOSSAMOUNT                    --损失金额
        ,CUSTOMERTYPE                  --客户类型
        ,GURANTYTYPE                   --担保方式
        ,GURANTORINFO                  --保证人
        ,GURANTYINFO                   --抵（质）押物
        ,SSPROGRESS                    --诉讼进展
        ,DISPOSALPLAN                  --清收处置方案
        ,DISPOSALPROGRESS              --最新处置进展
        ,NEXTPLAN                      --下一步工作计划
        ,EXISTDIFFICULTY               --存在的困难
        ,DEDUCTSETTLEACCOUNT           --扣款结算账户
        ,DEDUCTSETTLEACCOUNTBALANCE    --扣款结算账户余额
        ,DEDUCTAMOUNT                  --扣划金额
        ,DEDUCTREASON                  --扣划理由
        ,ACCOUNTNO                     --挂账编号
        ,ISCOMPINTERESTFORGIVENESS     --是否利息全额减免
        ,PROGRAMNO                     --方案编号
        ,ISINSTALLMENT                 --是否分期付款标识
        ,COUNTERPARTYCERTTYPE          --受让方（交易对手）证件类型
        ,COUNTERPARTYCERTID            --受让方（交易对手）证件号
        ,QYDATE                        --签约日期
        ,SXDATE                        --生效日期
        ,CURRENCY                      --协议币种
        ,XYAMT                         --协议金额（元）
        ,BZJAMT                        --保证金金额（元）
        ,BZJRATE                       --保证金比例（%）
        ,BZJCURRENCY                   --保证金币种
        ,COUNTERPARTYZH                --交易对手账号
        ,COUNTERPARTYZHBANK            --交易对手账号行号
        ,COUNTERPARTYZZDATE            --交易对手转账日期
        ,FYCDSID                       --法院裁定书编号
        ,START_DT                      --开始时间
        ,END_DT                        --结束时间
        ,ID_MARK                       --增删标志
        ,ETL_TIMESTAMP                 --ETL处理时间戳
    FROM IOL.V_ICMS_ASSET_PRESERVATION_APPLY   --资产保全（贷后）申请表_视图
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

  END ETL_O_IOL_ICMS_ASSET_PRESERVATION_APPLY;
/

