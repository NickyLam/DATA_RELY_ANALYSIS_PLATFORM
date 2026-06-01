/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_asset_preservation_apply
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_asset_preservation_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_asset_preservation_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_preservation_apply_op purge;
drop table ${iol_schema}.icms_asset_preservation_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_preservation_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_preservation_apply where 0=1;

create table ${iol_schema}.icms_asset_preservation_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_preservation_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_preservation_apply_cl(
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵债金额
            ,receivedate -- 接收日期
            ,debtrepayassettype -- 抵债资产类型
            ,debtrepaymenttype -- 抵债类型
            ,handletype -- 处置方式
            ,handlebalance -- 处置金额
            ,handledesc -- 处置说明
            ,disposaldate -- 生成时间
            ,creditbalance -- 授信余额
            ,lossamount -- 损失金额
            ,customertype -- 客户类型
            ,gurantytype -- 担保方式
            ,gurantorinfo -- 保证人
            ,gurantyinfo -- 抵（质）押物
            ,ssprogress -- 诉讼进展
            ,disposalplan -- 清收处置方案
            ,disposalprogress -- 最新处置进展
            ,nextplan -- 下一步工作计划
            ,existdifficulty -- 存在的困难
            ,deductsettleaccount -- 扣款结算账户
            ,deductsettleaccountbalance -- 扣款结算账户余额
            ,deductamount -- 扣划金额
            ,deductreason -- 扣划理由
            ,accountno -- 挂账编号
            ,iscompinterestforgiveness -- 是否利息全额减免
            ,programno -- 方案编号"
            ,isinstallment -- 是否分期付款标识
            ,counterpartycerttype -- 受让方（交易对手）证件类型
            ,counterpartycertid -- 受让方（交易对手）证件号
            ,qydate -- 签约日期
            ,sxdate -- 生效日期
            ,currency -- 协议币种
            ,xyamt -- 协议金额（元）
            ,bzjamt -- 保证金金额（元）
            ,bzjrate -- 保证金比例（%）
            ,bzjcurrency -- 保证金币种
            ,counterpartyzh -- 交易对手账号
            ,counterpartyzhbank -- 交易对手账号行号
            ,counterpartyzzdate -- 交易对手转账日期
            ,fycdsid -- 法院裁定书编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_preservation_apply_op(
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵债金额
            ,receivedate -- 接收日期
            ,debtrepayassettype -- 抵债资产类型
            ,debtrepaymenttype -- 抵债类型
            ,handletype -- 处置方式
            ,handlebalance -- 处置金额
            ,handledesc -- 处置说明
            ,disposaldate -- 生成时间
            ,creditbalance -- 授信余额
            ,lossamount -- 损失金额
            ,customertype -- 客户类型
            ,gurantytype -- 担保方式
            ,gurantorinfo -- 保证人
            ,gurantyinfo -- 抵（质）押物
            ,ssprogress -- 诉讼进展
            ,disposalplan -- 清收处置方案
            ,disposalprogress -- 最新处置进展
            ,nextplan -- 下一步工作计划
            ,existdifficulty -- 存在的困难
            ,deductsettleaccount -- 扣款结算账户
            ,deductsettleaccountbalance -- 扣款结算账户余额
            ,deductamount -- 扣划金额
            ,deductreason -- 扣划理由
            ,accountno -- 挂账编号
            ,iscompinterestforgiveness -- 是否利息全额减免
            ,programno -- 方案编号"
            ,isinstallment -- 是否分期付款标识
            ,counterpartycerttype -- 受让方（交易对手）证件类型
            ,counterpartycertid -- 受让方（交易对手）证件号
            ,qydate -- 签约日期
            ,sxdate -- 生效日期
            ,currency -- 协议币种
            ,xyamt -- 协议金额（元）
            ,bzjamt -- 保证金金额（元）
            ,bzjrate -- 保证金比例（%）
            ,bzjcurrency -- 保证金币种
            ,counterpartyzh -- 交易对手账号
            ,counterpartyzhbank -- 交易对手账号行号
            ,counterpartyzzdate -- 交易对手转账日期
            ,fycdsid -- 法院裁定书编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.afterlobj, o.afterlobj) as afterlobj -- 减免前本金合计(时点合计)
    ,nvl(n.afterloddfy, o.afterloddfy) as afterloddfy -- 减免前代垫费用合计(时点合计)
    ,nvl(n.afterlofl, o.afterlofl) as afterlofl -- 减免前复利合计(时点合计)
    ,nvl(n.afterlofx, o.afterlofx) as afterlofx -- 减免前罚息合计(时点合计)
    ,nvl(n.afterlolx, o.afterlolx) as afterlolx -- 减免前利息合计(时点合计)
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.classify, o.classify) as classify -- 资产分类
    ,nvl(n.condition, o.condition) as condition -- 条件(原因)
    ,nvl(n.counterparty, o.counterparty) as counterparty -- 受让方（交易对手）
    ,nvl(n.counterpartyname, o.counterpartyname) as counterpartyname -- 受让方（交易对手）
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.ddfyamtsum, o.ddfyamtsum) as ddfyamtsum -- 代垫费用合计（本次交易）
    ,nvl(n.duebillnum, o.duebillnum) as duebillnum -- 借据数量
    ,nvl(n.establishment, o.establishment) as establishment -- 内部户开立机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.intamtsum, o.intamtsum) as intamtsum -- 利息合计（本次交易）
    ,nvl(n.isborrowerrecourse, o.isborrowerrecourse) as isborrowerrecourse -- 对借款人是否保留追索权
    ,nvl(n.isgurantyrecourse, o.isgurantyrecourse) as isgurantyrecourse -- 对保证人是否保留追索权
    ,nvl(n.ispropertyclue, o.ispropertyclue) as ispropertyclue -- 是否存在财产线索
    ,nvl(n.lastreturnedmoneysum, o.lastreturnedmoneysum) as lastreturnedmoneysum -- 上次累计回款金额
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生类型(01单户，02批量)
    ,nvl(n.odiamtsum, o.odiamtsum) as odiamtsum -- 复利合计（本次交易）
    ,nvl(n.odpamtsum, o.odpamtsum) as odpamtsum -- 罚息合计（本次交易）
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办时间
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办客户经理所属机构
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办客户经理
    ,nvl(n.priamtsum, o.priamtsum) as priamtsum -- 本金合计（本次交易）
    ,nvl(n.propertyclue, o.propertyclue) as propertyclue -- 财产线索简介
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号（贷款转让流水号）
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.returnedaftermoney, o.returnedaftermoney) as returnedaftermoney -- 本次回款后应收款金额
    ,nvl(n.returnedbeforemoney, o.returnedbeforemoney) as returnedbeforemoney -- 本次回款前应收款金额
    ,nvl(n.returnedmoney, o.returnedmoney) as returnedmoney -- 本次回款金额
    ,nvl(n.returnedmoneysum, o.returnedmoneysum) as returnedmoneysum -- 累计回款金额
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.sqamount, o.sqamount) as sqamount -- 首期回款金额（含保证金）
    ,nvl(n.tradingplatform, o.tradingplatform) as tradingplatform -- 交易平台
    ,nvl(n.transferaccount, o.transferaccount) as transferaccount -- 转让回款账户（内部账户）
    ,nvl(n.transferaccountname, o.transferaccountname) as transferaccountname -- 转让回款账户（内部账户）
    ,nvl(n.transferactualprice, o.transferactualprice) as transferactualprice -- 真实转让对价（元）
    ,nvl(n.transfercontractno, o.transfercontractno) as transfercontractno -- 转让合同号
    ,nvl(n.transferprice, o.transferprice) as transferprice -- 转让价格
    ,nvl(n.transfertype, o.transfertype) as transfertype -- 转让方式
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.usetossfdj, o.usetossfdj) as usetossfdj -- 用于归还诉讼费的对价（元）
    ,nvl(n.writeofftype, o.writeofftype) as writeofftype -- 核销类型
    ,nvl(n.ysaccount, o.ysaccount) as ysaccount -- 应收款账户
    ,nvl(n.ysaccountname, o.ysaccountname) as ysaccountname -- 应收款账户名称
    ,nvl(n.ysamount, o.ysamount) as ysamount -- 应收款金额
    ,nvl(n.debtrepayassetid, o.debtrepayassetid) as debtrepayassetid -- 抵债资产编号
    ,nvl(n.debtrepayassetname, o.debtrepayassetname) as debtrepayassetname -- 抵债资产名称
    ,nvl(n.debtrepaysum, o.debtrepaysum) as debtrepaysum -- 抵债金额
    ,nvl(n.receivedate, o.receivedate) as receivedate -- 接收日期
    ,nvl(n.debtrepayassettype, o.debtrepayassettype) as debtrepayassettype -- 抵债资产类型
    ,nvl(n.debtrepaymenttype, o.debtrepaymenttype) as debtrepaymenttype -- 抵债类型
    ,nvl(n.handletype, o.handletype) as handletype -- 处置方式
    ,nvl(n.handlebalance, o.handlebalance) as handlebalance -- 处置金额
    ,nvl(n.handledesc, o.handledesc) as handledesc -- 处置说明
    ,nvl(n.disposaldate, o.disposaldate) as disposaldate -- 生成时间
    ,nvl(n.creditbalance, o.creditbalance) as creditbalance -- 授信余额
    ,nvl(n.lossamount, o.lossamount) as lossamount -- 损失金额
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.gurantytype, o.gurantytype) as gurantytype -- 担保方式
    ,nvl(n.gurantorinfo, o.gurantorinfo) as gurantorinfo -- 保证人
    ,nvl(n.gurantyinfo, o.gurantyinfo) as gurantyinfo -- 抵（质）押物
    ,nvl(n.ssprogress, o.ssprogress) as ssprogress -- 诉讼进展
    ,nvl(n.disposalplan, o.disposalplan) as disposalplan -- 清收处置方案
    ,nvl(n.disposalprogress, o.disposalprogress) as disposalprogress -- 最新处置进展
    ,nvl(n.nextplan, o.nextplan) as nextplan -- 下一步工作计划
    ,nvl(n.existdifficulty, o.existdifficulty) as existdifficulty -- 存在的困难
    ,nvl(n.deductsettleaccount, o.deductsettleaccount) as deductsettleaccount -- 扣款结算账户
    ,nvl(n.deductsettleaccountbalance, o.deductsettleaccountbalance) as deductsettleaccountbalance -- 扣款结算账户余额
    ,nvl(n.deductamount, o.deductamount) as deductamount -- 扣划金额
    ,nvl(n.deductreason, o.deductreason) as deductreason -- 扣划理由
    ,nvl(n.accountno, o.accountno) as accountno -- 挂账编号
    ,nvl(n.iscompinterestforgiveness, o.iscompinterestforgiveness) as iscompinterestforgiveness -- 是否利息全额减免
    ,nvl(n.programno, o.programno) as programno -- 方案编号"
    ,nvl(n.isinstallment, o.isinstallment) as isinstallment -- 是否分期付款标识
    ,nvl(n.counterpartycerttype, o.counterpartycerttype) as counterpartycerttype -- 受让方（交易对手）证件类型
    ,nvl(n.counterpartycertid, o.counterpartycertid) as counterpartycertid -- 受让方（交易对手）证件号
    ,nvl(n.qydate, o.qydate) as qydate -- 签约日期
    ,nvl(n.sxdate, o.sxdate) as sxdate -- 生效日期
    ,nvl(n.currency, o.currency) as currency -- 协议币种
    ,nvl(n.xyamt, o.xyamt) as xyamt -- 协议金额（元）
    ,nvl(n.bzjamt, o.bzjamt) as bzjamt -- 保证金金额（元）
    ,nvl(n.bzjrate, o.bzjrate) as bzjrate -- 保证金比例（%）
    ,nvl(n.bzjcurrency, o.bzjcurrency) as bzjcurrency -- 保证金币种
    ,nvl(n.counterpartyzh, o.counterpartyzh) as counterpartyzh -- 交易对手账号
    ,nvl(n.counterpartyzhbank, o.counterpartyzhbank) as counterpartyzhbank -- 交易对手账号行号
    ,nvl(n.counterpartyzzdate, o.counterpartyzzdate) as counterpartyzzdate -- 交易对手转账日期
    ,nvl(n.fycdsid, o.fycdsid) as fycdsid -- 法院裁定书编号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_asset_preservation_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_asset_preservation_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.afterlobj <> n.afterlobj
        or o.afterloddfy <> n.afterloddfy
        or o.afterlofl <> n.afterlofl
        or o.afterlofx <> n.afterlofx
        or o.afterlolx <> n.afterlolx
        or o.approvestatus <> n.approvestatus
        or o.classify <> n.classify
        or o.condition <> n.condition
        or o.counterparty <> n.counterparty
        or o.counterpartyname <> n.counterpartyname
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.ddfyamtsum <> n.ddfyamtsum
        or o.duebillnum <> n.duebillnum
        or o.establishment <> n.establishment
        or o.inputdate <> n.inputdate
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.intamtsum <> n.intamtsum
        or o.isborrowerrecourse <> n.isborrowerrecourse
        or o.isgurantyrecourse <> n.isgurantyrecourse
        or o.ispropertyclue <> n.ispropertyclue
        or o.lastreturnedmoneysum <> n.lastreturnedmoneysum
        or o.objecttype <> n.objecttype
        or o.occurtype <> n.occurtype
        or o.odiamtsum <> n.odiamtsum
        or o.odpamtsum <> n.odpamtsum
        or o.operatedate <> n.operatedate
        or o.operateorgid <> n.operateorgid
        or o.operateuserid <> n.operateuserid
        or o.priamtsum <> n.priamtsum
        or o.propertyclue <> n.propertyclue
        or o.relativeserialno <> n.relativeserialno
        or o.remark <> n.remark
        or o.returnedaftermoney <> n.returnedaftermoney
        or o.returnedbeforemoney <> n.returnedbeforemoney
        or o.returnedmoney <> n.returnedmoney
        or o.returnedmoneysum <> n.returnedmoneysum
        or o.sqamount <> n.sqamount
        or o.tradingplatform <> n.tradingplatform
        or o.transferaccount <> n.transferaccount
        or o.transferaccountname <> n.transferaccountname
        or o.transferactualprice <> n.transferactualprice
        or o.transfercontractno <> n.transfercontractno
        or o.transferprice <> n.transferprice
        or o.transfertype <> n.transfertype
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.usetossfdj <> n.usetossfdj
        or o.writeofftype <> n.writeofftype
        or o.ysaccount <> n.ysaccount
        or o.ysaccountname <> n.ysaccountname
        or o.ysamount <> n.ysamount
        or o.debtrepayassetid <> n.debtrepayassetid
        or o.debtrepayassetname <> n.debtrepayassetname
        or o.debtrepaysum <> n.debtrepaysum
        or o.receivedate <> n.receivedate
        or o.debtrepayassettype <> n.debtrepayassettype
        or o.debtrepaymenttype <> n.debtrepaymenttype
        or o.handletype <> n.handletype
        or o.handlebalance <> n.handlebalance
        or o.handledesc <> n.handledesc
        or o.disposaldate <> n.disposaldate
        or o.creditbalance <> n.creditbalance
        or o.lossamount <> n.lossamount
        or o.customertype <> n.customertype
        or o.gurantytype <> n.gurantytype
        or o.gurantorinfo <> n.gurantorinfo
        or o.gurantyinfo <> n.gurantyinfo
        or o.ssprogress <> n.ssprogress
        or o.disposalplan <> n.disposalplan
        or o.disposalprogress <> n.disposalprogress
        or o.nextplan <> n.nextplan
        or o.existdifficulty <> n.existdifficulty
        or o.deductsettleaccount <> n.deductsettleaccount
        or o.deductsettleaccountbalance <> n.deductsettleaccountbalance
        or o.deductamount <> n.deductamount
        or o.deductreason <> n.deductreason
        or o.accountno <> n.accountno
        or o.iscompinterestforgiveness <> n.iscompinterestforgiveness
        or o.programno <> n.programno
        or o.isinstallment <> n.isinstallment
        or o.counterpartycerttype <> n.counterpartycerttype
        or o.counterpartycertid <> n.counterpartycertid
        or o.qydate <> n.qydate
        or o.sxdate <> n.sxdate
        or o.currency <> n.currency
        or o.xyamt <> n.xyamt
        or o.bzjamt <> n.bzjamt
        or o.bzjrate <> n.bzjrate
        or o.bzjcurrency <> n.bzjcurrency
        or o.counterpartyzh <> n.counterpartyzh
        or o.counterpartyzhbank <> n.counterpartyzhbank
        or o.counterpartyzzdate <> n.counterpartyzzdate
        or o.fycdsid <> n.fycdsid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_preservation_apply_cl(
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵债金额
            ,receivedate -- 接收日期
            ,debtrepayassettype -- 抵债资产类型
            ,debtrepaymenttype -- 抵债类型
            ,handletype -- 处置方式
            ,handlebalance -- 处置金额
            ,handledesc -- 处置说明
            ,disposaldate -- 生成时间
            ,creditbalance -- 授信余额
            ,lossamount -- 损失金额
            ,customertype -- 客户类型
            ,gurantytype -- 担保方式
            ,gurantorinfo -- 保证人
            ,gurantyinfo -- 抵（质）押物
            ,ssprogress -- 诉讼进展
            ,disposalplan -- 清收处置方案
            ,disposalprogress -- 最新处置进展
            ,nextplan -- 下一步工作计划
            ,existdifficulty -- 存在的困难
            ,deductsettleaccount -- 扣款结算账户
            ,deductsettleaccountbalance -- 扣款结算账户余额
            ,deductamount -- 扣划金额
            ,deductreason -- 扣划理由
            ,accountno -- 挂账编号
            ,iscompinterestforgiveness -- 是否利息全额减免
            ,programno -- 方案编号"
            ,isinstallment -- 是否分期付款标识
            ,counterpartycerttype -- 受让方（交易对手）证件类型
            ,counterpartycertid -- 受让方（交易对手）证件号
            ,qydate -- 签约日期
            ,sxdate -- 生效日期
            ,currency -- 协议币种
            ,xyamt -- 协议金额（元）
            ,bzjamt -- 保证金金额（元）
            ,bzjrate -- 保证金比例（%）
            ,bzjcurrency -- 保证金币种
            ,counterpartyzh -- 交易对手账号
            ,counterpartyzhbank -- 交易对手账号行号
            ,counterpartyzzdate -- 交易对手转账日期
            ,fycdsid -- 法院裁定书编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_preservation_apply_op(
            afterlobj -- 减免前本金合计(时点合计)
            ,afterloddfy -- 减免前代垫费用合计(时点合计)
            ,afterlofl -- 减免前复利合计(时点合计)
            ,afterlofx -- 减免前罚息合计(时点合计)
            ,afterlolx -- 减免前利息合计(时点合计)
            ,approvestatus -- 审批状态
            ,classify -- 资产分类
            ,condition -- 条件(原因)
            ,counterparty -- 受让方（交易对手）
            ,counterpartyname -- 受让方（交易对手）
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,ddfyamtsum -- 代垫费用合计（本次交易）
            ,duebillnum -- 借据数量
            ,establishment -- 内部户开立机构
            ,inputdate -- 登记日期
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,intamtsum -- 利息合计（本次交易）
            ,isborrowerrecourse -- 对借款人是否保留追索权
            ,isgurantyrecourse -- 对保证人是否保留追索权
            ,ispropertyclue -- 是否存在财产线索
            ,lastreturnedmoneysum -- 上次累计回款金额
            ,objecttype -- 对象类型
            ,occurtype -- 发生类型(01单户，02批量)
            ,odiamtsum -- 复利合计（本次交易）
            ,odpamtsum -- 罚息合计（本次交易）
            ,operatedate -- 经办时间
            ,operateorgid -- 经办客户经理所属机构
            ,operateuserid -- 经办客户经理
            ,priamtsum -- 本金合计（本次交易）
            ,propertyclue -- 财产线索简介
            ,relativeserialno -- 关联流水号（贷款转让流水号）
            ,remark -- 备注
            ,returnedaftermoney -- 本次回款后应收款金额
            ,returnedbeforemoney -- 本次回款前应收款金额
            ,returnedmoney -- 本次回款金额
            ,returnedmoneysum -- 累计回款金额
            ,serialno -- 流水号
            ,sqamount -- 首期回款金额（含保证金）
            ,tradingplatform -- 交易平台
            ,transferaccount -- 转让回款账户（内部账户）
            ,transferaccountname -- 转让回款账户（内部账户）
            ,transferactualprice -- 真实转让对价（元）
            ,transfercontractno -- 转让合同号
            ,transferprice -- 转让价格
            ,transfertype -- 转让方式
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,usetossfdj -- 用于归还诉讼费的对价（元）
            ,writeofftype -- 核销类型
            ,ysaccount -- 应收款账户
            ,ysaccountname -- 应收款账户名称
            ,ysamount -- 应收款金额
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵债金额
            ,receivedate -- 接收日期
            ,debtrepayassettype -- 抵债资产类型
            ,debtrepaymenttype -- 抵债类型
            ,handletype -- 处置方式
            ,handlebalance -- 处置金额
            ,handledesc -- 处置说明
            ,disposaldate -- 生成时间
            ,creditbalance -- 授信余额
            ,lossamount -- 损失金额
            ,customertype -- 客户类型
            ,gurantytype -- 担保方式
            ,gurantorinfo -- 保证人
            ,gurantyinfo -- 抵（质）押物
            ,ssprogress -- 诉讼进展
            ,disposalplan -- 清收处置方案
            ,disposalprogress -- 最新处置进展
            ,nextplan -- 下一步工作计划
            ,existdifficulty -- 存在的困难
            ,deductsettleaccount -- 扣款结算账户
            ,deductsettleaccountbalance -- 扣款结算账户余额
            ,deductamount -- 扣划金额
            ,deductreason -- 扣划理由
            ,accountno -- 挂账编号
            ,iscompinterestforgiveness -- 是否利息全额减免
            ,programno -- 方案编号"
            ,isinstallment -- 是否分期付款标识
            ,counterpartycerttype -- 受让方（交易对手）证件类型
            ,counterpartycertid -- 受让方（交易对手）证件号
            ,qydate -- 签约日期
            ,sxdate -- 生效日期
            ,currency -- 协议币种
            ,xyamt -- 协议金额（元）
            ,bzjamt -- 保证金金额（元）
            ,bzjrate -- 保证金比例（%）
            ,bzjcurrency -- 保证金币种
            ,counterpartyzh -- 交易对手账号
            ,counterpartyzhbank -- 交易对手账号行号
            ,counterpartyzzdate -- 交易对手转账日期
            ,fycdsid -- 法院裁定书编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.afterlobj -- 减免前本金合计(时点合计)
    ,o.afterloddfy -- 减免前代垫费用合计(时点合计)
    ,o.afterlofl -- 减免前复利合计(时点合计)
    ,o.afterlofx -- 减免前罚息合计(时点合计)
    ,o.afterlolx -- 减免前利息合计(时点合计)
    ,o.approvestatus -- 审批状态
    ,o.classify -- 资产分类
    ,o.condition -- 条件(原因)
    ,o.counterparty -- 受让方（交易对手）
    ,o.counterpartyname -- 受让方（交易对手）
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.ddfyamtsum -- 代垫费用合计（本次交易）
    ,o.duebillnum -- 借据数量
    ,o.establishment -- 内部户开立机构
    ,o.inputdate -- 登记日期
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.intamtsum -- 利息合计（本次交易）
    ,o.isborrowerrecourse -- 对借款人是否保留追索权
    ,o.isgurantyrecourse -- 对保证人是否保留追索权
    ,o.ispropertyclue -- 是否存在财产线索
    ,o.lastreturnedmoneysum -- 上次累计回款金额
    ,o.objecttype -- 对象类型
    ,o.occurtype -- 发生类型(01单户，02批量)
    ,o.odiamtsum -- 复利合计（本次交易）
    ,o.odpamtsum -- 罚息合计（本次交易）
    ,o.operatedate -- 经办时间
    ,o.operateorgid -- 经办客户经理所属机构
    ,o.operateuserid -- 经办客户经理
    ,o.priamtsum -- 本金合计（本次交易）
    ,o.propertyclue -- 财产线索简介
    ,o.relativeserialno -- 关联流水号（贷款转让流水号）
    ,o.remark -- 备注
    ,o.returnedaftermoney -- 本次回款后应收款金额
    ,o.returnedbeforemoney -- 本次回款前应收款金额
    ,o.returnedmoney -- 本次回款金额
    ,o.returnedmoneysum -- 累计回款金额
    ,o.serialno -- 流水号
    ,o.sqamount -- 首期回款金额（含保证金）
    ,o.tradingplatform -- 交易平台
    ,o.transferaccount -- 转让回款账户（内部账户）
    ,o.transferaccountname -- 转让回款账户（内部账户）
    ,o.transferactualprice -- 真实转让对价（元）
    ,o.transfercontractno -- 转让合同号
    ,o.transferprice -- 转让价格
    ,o.transfertype -- 转让方式
    ,o.updatedate -- 更新日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.usetossfdj -- 用于归还诉讼费的对价（元）
    ,o.writeofftype -- 核销类型
    ,o.ysaccount -- 应收款账户
    ,o.ysaccountname -- 应收款账户名称
    ,o.ysamount -- 应收款金额
    ,o.debtrepayassetid -- 抵债资产编号
    ,o.debtrepayassetname -- 抵债资产名称
    ,o.debtrepaysum -- 抵债金额
    ,o.receivedate -- 接收日期
    ,o.debtrepayassettype -- 抵债资产类型
    ,o.debtrepaymenttype -- 抵债类型
    ,o.handletype -- 处置方式
    ,o.handlebalance -- 处置金额
    ,o.handledesc -- 处置说明
    ,o.disposaldate -- 生成时间
    ,o.creditbalance -- 授信余额
    ,o.lossamount -- 损失金额
    ,o.customertype -- 客户类型
    ,o.gurantytype -- 担保方式
    ,o.gurantorinfo -- 保证人
    ,o.gurantyinfo -- 抵（质）押物
    ,o.ssprogress -- 诉讼进展
    ,o.disposalplan -- 清收处置方案
    ,o.disposalprogress -- 最新处置进展
    ,o.nextplan -- 下一步工作计划
    ,o.existdifficulty -- 存在的困难
    ,o.deductsettleaccount -- 扣款结算账户
    ,o.deductsettleaccountbalance -- 扣款结算账户余额
    ,o.deductamount -- 扣划金额
    ,o.deductreason -- 扣划理由
    ,o.accountno -- 挂账编号
    ,o.iscompinterestforgiveness -- 是否利息全额减免
    ,o.programno -- 方案编号"
    ,o.isinstallment -- 是否分期付款标识
    ,o.counterpartycerttype -- 受让方（交易对手）证件类型
    ,o.counterpartycertid -- 受让方（交易对手）证件号
    ,o.qydate -- 签约日期
    ,o.sxdate -- 生效日期
    ,o.currency -- 协议币种
    ,o.xyamt -- 协议金额（元）
    ,o.bzjamt -- 保证金金额（元）
    ,o.bzjrate -- 保证金比例（%）
    ,o.bzjcurrency -- 保证金币种
    ,o.counterpartyzh -- 交易对手账号
    ,o.counterpartyzhbank -- 交易对手账号行号
    ,o.counterpartyzzdate -- 交易对手转账日期
    ,o.fycdsid -- 法院裁定书编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_asset_preservation_apply_bk o
    left join ${iol_schema}.icms_asset_preservation_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_asset_preservation_apply_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_asset_preservation_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_asset_preservation_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_asset_preservation_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_asset_preservation_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_asset_preservation_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_asset_preservation_apply_cl;
alter table ${iol_schema}.icms_asset_preservation_apply exchange partition p_20991231 with table ${iol_schema}.icms_asset_preservation_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_asset_preservation_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_preservation_apply_op purge;
drop table ${iol_schema}.icms_asset_preservation_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_asset_preservation_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_asset_preservation_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
