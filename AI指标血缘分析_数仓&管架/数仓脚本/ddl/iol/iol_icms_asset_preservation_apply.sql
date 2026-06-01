/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_asset_preservation_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_asset_preservation_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_asset_preservation_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_preservation_apply(
    afterlobj number(24,6) -- 减免前本金合计(时点合计)
    ,afterloddfy number(24,6) -- 减免前代垫费用合计(时点合计)
    ,afterlofl number(24,6) -- 减免前复利合计(时点合计)
    ,afterlofx number(24,6) -- 减免前罚息合计(时点合计)
    ,afterlolx number(24,6) -- 减免前利息合计(时点合计)
    ,approvestatus varchar2(64) -- 审批状态
    ,classify varchar2(32) -- 资产分类
    ,condition varchar2(3000) -- 条件(原因)
    ,counterparty varchar2(200) -- 受让方（交易对手）
    ,counterpartyname varchar2(200) -- 受让方（交易对手）
    ,customerid varchar2(3000) -- 客户编号
    ,customername varchar2(3000) -- 客户名称
    ,ddfyamtsum number(24,6) -- 代垫费用合计（本次交易）
    ,duebillnum varchar2(32) -- 借据数量
    ,establishment varchar2(200) -- 内部户开立机构
    ,inputdate date -- 登记日期
    ,inputorgid varchar2(64) -- 登记机构
    ,inputuserid varchar2(64) -- 登记人
    ,intamtsum number(24,6) -- 利息合计（本次交易）
    ,isborrowerrecourse varchar2(32) -- 对借款人是否保留追索权
    ,isgurantyrecourse varchar2(32) -- 对保证人是否保留追索权
    ,ispropertyclue varchar2(32) -- 是否存在财产线索
    ,lastreturnedmoneysum number(24,6) -- 上次累计回款金额
    ,objecttype varchar2(64) -- 对象类型
    ,occurtype varchar2(32) -- 发生类型(01单户，02批量)
    ,odiamtsum number(24,6) -- 复利合计（本次交易）
    ,odpamtsum number(24,6) -- 罚息合计（本次交易）
    ,operatedate date -- 经办时间
    ,operateorgid varchar2(64) -- 经办客户经理所属机构
    ,operateuserid varchar2(64) -- 经办客户经理
    ,priamtsum number(24,6) -- 本金合计（本次交易）
    ,propertyclue varchar2(2000) -- 财产线索简介
    ,relativeserialno varchar2(64) -- 关联流水号（贷款转让流水号）
    ,remark varchar2(3000) -- 备注
    ,returnedaftermoney number(24,6) -- 本次回款后应收款金额
    ,returnedbeforemoney number(24,6) -- 本次回款前应收款金额
    ,returnedmoney number(24,6) -- 本次回款金额
    ,returnedmoneysum number(24,6) -- 累计回款金额
    ,serialno varchar2(64) -- 流水号
    ,sqamount number(24,6) -- 首期回款金额（含保证金）
    ,tradingplatform varchar2(32) -- 交易平台
    ,transferaccount varchar2(200) -- 转让回款账户（内部账户）
    ,transferaccountname varchar2(200) -- 转让回款账户（内部账户）
    ,transferactualprice number(24,6) -- 真实转让对价（元）
    ,transfercontractno varchar2(500) -- 转让合同号
    ,transferprice number(24,6) -- 转让价格
    ,transfertype varchar2(32) -- 转让方式
    ,updatedate date -- 更新日期
    ,updateorgid varchar2(64) -- 更新机构
    ,updateuserid varchar2(64) -- 更新人
    ,usetossfdj number(24,6) -- 用于归还诉讼费的对价（元）
    ,writeofftype varchar2(32) -- 核销类型
    ,ysaccount varchar2(200) -- 应收款账户
    ,ysaccountname varchar2(200) -- 应收款账户名称
    ,ysamount number(24,6) -- 应收款金额
    ,debtrepayassetid varchar2(64) -- 抵债资产编号
    ,debtrepayassetname varchar2(200) -- 抵债资产名称
    ,debtrepaysum number(24,6) -- 抵债金额
    ,receivedate date -- 接收日期
    ,debtrepayassettype varchar2(48) -- 抵债资产类型
    ,debtrepaymenttype varchar2(48) -- 抵债类型
    ,handletype varchar2(48) -- 处置方式
    ,handlebalance number(24,6) -- 处置金额
    ,handledesc varchar2(3000) -- 处置说明
    ,disposaldate varchar2(24) -- 生成时间
    ,creditbalance number(24,6) -- 授信余额
    ,lossamount number(24,6) -- 损失金额
    ,customertype varchar2(20) -- 客户类型
    ,gurantytype varchar2(20) -- 担保方式
    ,gurantorinfo varchar2(4000) -- 保证人
    ,gurantyinfo varchar2(4000) -- 抵（质）押物
    ,ssprogress varchar2(20) -- 诉讼进展
    ,disposalplan varchar2(4000) -- 清收处置方案
    ,disposalprogress varchar2(4000) -- 最新处置进展
    ,nextplan varchar2(4000) -- 下一步工作计划
    ,existdifficulty varchar2(4000) -- 存在的困难
    ,deductsettleaccount varchar2(200) -- 扣款结算账户
    ,deductsettleaccountbalance number(24,6) -- 扣款结算账户余额
    ,deductamount number(24,6) -- 扣划金额
    ,deductreason varchar2(3000) -- 扣划理由
    ,accountno varchar2(64) -- 挂账编号
    ,iscompinterestforgiveness varchar2(4) -- 是否利息全额减免
    ,programno varchar2(64) -- 方案编号"
    ,isinstallment varchar2(10) -- 是否分期付款标识
    ,counterpartycerttype varchar2(20) -- 受让方（交易对手）证件类型
    ,counterpartycertid varchar2(64) -- 受让方（交易对手）证件号
    ,qydate date -- 签约日期
    ,sxdate date -- 生效日期
    ,currency varchar2(20) -- 协议币种
    ,xyamt number(24,6) -- 协议金额（元）
    ,bzjamt number(24,6) -- 保证金金额（元）
    ,bzjrate number(24,6) -- 保证金比例（%）
    ,bzjcurrency varchar2(20) -- 保证金币种
    ,counterpartyzh varchar2(64) -- 交易对手账号
    ,counterpartyzhbank varchar2(64) -- 交易对手账号行号
    ,counterpartyzzdate date -- 交易对手转账日期
    ,fycdsid varchar2(200) -- 法院裁定书编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_asset_preservation_apply to ${iml_schema};
grant select on ${iol_schema}.icms_asset_preservation_apply to ${icl_schema};
grant select on ${iol_schema}.icms_asset_preservation_apply to ${idl_schema};
grant select on ${iol_schema}.icms_asset_preservation_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_asset_preservation_apply is '资产保全（贷后）申请表';
comment on column ${iol_schema}.icms_asset_preservation_apply.afterlobj is '减免前本金合计(时点合计)';
comment on column ${iol_schema}.icms_asset_preservation_apply.afterloddfy is '减免前代垫费用合计(时点合计)';
comment on column ${iol_schema}.icms_asset_preservation_apply.afterlofl is '减免前复利合计(时点合计)';
comment on column ${iol_schema}.icms_asset_preservation_apply.afterlofx is '减免前罚息合计(时点合计)';
comment on column ${iol_schema}.icms_asset_preservation_apply.afterlolx is '减免前利息合计(时点合计)';
comment on column ${iol_schema}.icms_asset_preservation_apply.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_asset_preservation_apply.classify is '资产分类';
comment on column ${iol_schema}.icms_asset_preservation_apply.condition is '条件(原因)';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterparty is '受让方（交易对手）';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartyname is '受让方（交易对手）';
comment on column ${iol_schema}.icms_asset_preservation_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_asset_preservation_apply.customername is '客户名称';
comment on column ${iol_schema}.icms_asset_preservation_apply.ddfyamtsum is '代垫费用合计（本次交易）';
comment on column ${iol_schema}.icms_asset_preservation_apply.duebillnum is '借据数量';
comment on column ${iol_schema}.icms_asset_preservation_apply.establishment is '内部户开立机构';
comment on column ${iol_schema}.icms_asset_preservation_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_asset_preservation_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_asset_preservation_apply.intamtsum is '利息合计（本次交易）';
comment on column ${iol_schema}.icms_asset_preservation_apply.isborrowerrecourse is '对借款人是否保留追索权';
comment on column ${iol_schema}.icms_asset_preservation_apply.isgurantyrecourse is '对保证人是否保留追索权';
comment on column ${iol_schema}.icms_asset_preservation_apply.ispropertyclue is '是否存在财产线索';
comment on column ${iol_schema}.icms_asset_preservation_apply.lastreturnedmoneysum is '上次累计回款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.objecttype is '对象类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.occurtype is '发生类型(01单户，02批量)';
comment on column ${iol_schema}.icms_asset_preservation_apply.odiamtsum is '复利合计（本次交易）';
comment on column ${iol_schema}.icms_asset_preservation_apply.odpamtsum is '罚息合计（本次交易）';
comment on column ${iol_schema}.icms_asset_preservation_apply.operatedate is '经办时间';
comment on column ${iol_schema}.icms_asset_preservation_apply.operateorgid is '经办客户经理所属机构';
comment on column ${iol_schema}.icms_asset_preservation_apply.operateuserid is '经办客户经理';
comment on column ${iol_schema}.icms_asset_preservation_apply.priamtsum is '本金合计（本次交易）';
comment on column ${iol_schema}.icms_asset_preservation_apply.propertyclue is '财产线索简介';
comment on column ${iol_schema}.icms_asset_preservation_apply.relativeserialno is '关联流水号（贷款转让流水号）';
comment on column ${iol_schema}.icms_asset_preservation_apply.remark is '备注';
comment on column ${iol_schema}.icms_asset_preservation_apply.returnedaftermoney is '本次回款后应收款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.returnedbeforemoney is '本次回款前应收款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.returnedmoney is '本次回款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.returnedmoneysum is '累计回款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_asset_preservation_apply.sqamount is '首期回款金额（含保证金）';
comment on column ${iol_schema}.icms_asset_preservation_apply.tradingplatform is '交易平台';
comment on column ${iol_schema}.icms_asset_preservation_apply.transferaccount is '转让回款账户（内部账户）';
comment on column ${iol_schema}.icms_asset_preservation_apply.transferaccountname is '转让回款账户（内部账户）';
comment on column ${iol_schema}.icms_asset_preservation_apply.transferactualprice is '真实转让对价（元）';
comment on column ${iol_schema}.icms_asset_preservation_apply.transfercontractno is '转让合同号';
comment on column ${iol_schema}.icms_asset_preservation_apply.transferprice is '转让价格';
comment on column ${iol_schema}.icms_asset_preservation_apply.transfertype is '转让方式';
comment on column ${iol_schema}.icms_asset_preservation_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_asset_preservation_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_asset_preservation_apply.usetossfdj is '用于归还诉讼费的对价（元）';
comment on column ${iol_schema}.icms_asset_preservation_apply.writeofftype is '核销类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.ysaccount is '应收款账户';
comment on column ${iol_schema}.icms_asset_preservation_apply.ysaccountname is '应收款账户名称';
comment on column ${iol_schema}.icms_asset_preservation_apply.ysamount is '应收款金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.debtrepayassetid is '抵债资产编号';
comment on column ${iol_schema}.icms_asset_preservation_apply.debtrepayassetname is '抵债资产名称';
comment on column ${iol_schema}.icms_asset_preservation_apply.debtrepaysum is '抵债金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.receivedate is '接收日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.debtrepayassettype is '抵债资产类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.debtrepaymenttype is '抵债类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.handletype is '处置方式';
comment on column ${iol_schema}.icms_asset_preservation_apply.handlebalance is '处置金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.handledesc is '处置说明';
comment on column ${iol_schema}.icms_asset_preservation_apply.disposaldate is '生成时间';
comment on column ${iol_schema}.icms_asset_preservation_apply.creditbalance is '授信余额';
comment on column ${iol_schema}.icms_asset_preservation_apply.lossamount is '损失金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.customertype is '客户类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.gurantytype is '担保方式';
comment on column ${iol_schema}.icms_asset_preservation_apply.gurantorinfo is '保证人';
comment on column ${iol_schema}.icms_asset_preservation_apply.gurantyinfo is '抵（质）押物';
comment on column ${iol_schema}.icms_asset_preservation_apply.ssprogress is '诉讼进展';
comment on column ${iol_schema}.icms_asset_preservation_apply.disposalplan is '清收处置方案';
comment on column ${iol_schema}.icms_asset_preservation_apply.disposalprogress is '最新处置进展';
comment on column ${iol_schema}.icms_asset_preservation_apply.nextplan is '下一步工作计划';
comment on column ${iol_schema}.icms_asset_preservation_apply.existdifficulty is '存在的困难';
comment on column ${iol_schema}.icms_asset_preservation_apply.deductsettleaccount is '扣款结算账户';
comment on column ${iol_schema}.icms_asset_preservation_apply.deductsettleaccountbalance is '扣款结算账户余额';
comment on column ${iol_schema}.icms_asset_preservation_apply.deductamount is '扣划金额';
comment on column ${iol_schema}.icms_asset_preservation_apply.deductreason is '扣划理由';
comment on column ${iol_schema}.icms_asset_preservation_apply.accountno is '挂账编号';
comment on column ${iol_schema}.icms_asset_preservation_apply.iscompinterestforgiveness is '是否利息全额减免';
comment on column ${iol_schema}.icms_asset_preservation_apply.programno is '方案编号"';
comment on column ${iol_schema}.icms_asset_preservation_apply.isinstallment is '是否分期付款标识';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartycerttype is '受让方（交易对手）证件类型';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartycertid is '受让方（交易对手）证件号';
comment on column ${iol_schema}.icms_asset_preservation_apply.qydate is '签约日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.sxdate is '生效日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.currency is '协议币种';
comment on column ${iol_schema}.icms_asset_preservation_apply.xyamt is '协议金额（元）';
comment on column ${iol_schema}.icms_asset_preservation_apply.bzjamt is '保证金金额（元）';
comment on column ${iol_schema}.icms_asset_preservation_apply.bzjrate is '保证金比例（%）';
comment on column ${iol_schema}.icms_asset_preservation_apply.bzjcurrency is '保证金币种';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartyzh is '交易对手账号';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartyzhbank is '交易对手账号行号';
comment on column ${iol_schema}.icms_asset_preservation_apply.counterpartyzzdate is '交易对手转账日期';
comment on column ${iol_schema}.icms_asset_preservation_apply.fycdsid is '法院裁定书编号';
comment on column ${iol_schema}.icms_asset_preservation_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_asset_preservation_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_asset_preservation_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_asset_preservation_apply.etl_timestamp is 'ETL处理时间戳';
