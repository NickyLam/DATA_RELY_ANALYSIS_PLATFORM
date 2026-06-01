/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_business_contract
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
create table ${iol_schema}.icms_lx_business_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_business_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_contract_op purge;
drop table ${iol_schema}.icms_lx_business_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_contract where 0=1;

create table ${iol_schema}.icms_lx_business_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_business_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_contract_cl(
            serialno -- 合同编号
            ,baserialno -- 授信编号
            ,relacontractno -- 关联合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,productid -- 产品编号
            ,occurdate -- 签订日期
            ,currency -- 币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)
            ,risktype -- 风险类型(额度);风险类型（一般、低风险）
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,applyid -- 用信审批申请编号
            ,availablecontractamt -- 额度可用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_contract_op(
            serialno -- 合同编号
            ,baserialno -- 授信编号
            ,relacontractno -- 关联合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,productid -- 产品编号
            ,occurdate -- 签订日期
            ,currency -- 币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)
            ,risktype -- 风险类型(额度);风险类型（一般、低风险）
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,applyid -- 用信审批申请编号
            ,availablecontractamt -- 额度可用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同编号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 授信编号
    ,nvl(n.relacontractno, o.relacontractno) as relacontractno -- 关联合同编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 额度/业务标志
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 签订日期
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.putoutsum, o.putoutsum) as putoutsum -- 实际放款金额
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 放款日期
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限(月)
    ,nvl(n.termday, o.termday) as termday -- 期限(天)
    ,nvl(n.startdate, o.startdate) as startdate -- 合同开始日期
    ,nvl(n.maturity, o.maturity) as maturity -- 合同到期日期
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度)
    ,nvl(n.risktype, o.risktype) as risktype -- 风险类型(额度);风险类型（一般、低风险）
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,nvl(n.fixedrate, o.fixedrate) as fixedrate -- 固定利率
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,nvl(n.floatrange, o.floatrange) as floatrange -- 浮动幅度
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 担保方式
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
    ,nvl(n.repaycycle, o.repaycycle) as repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.balance, o.balance) as balance -- 合同贷款余额
    ,nvl(n.normalbalance, o.normalbalance) as normalbalance -- 正常余额
    ,nvl(n.overduebalance, o.overduebalance) as overduebalance -- 逾期/垫款金额
    ,nvl(n.status, o.status) as status -- 合同状态
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.finishtype, o.finishtype) as finishtype -- 终结类型
    ,nvl(n.finishflag, o.finishflag) as finishflag -- 结清标志
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.creditno, o.creditno) as creditno -- 资方授信编号
    ,nvl(n.applyid, o.applyid) as applyid -- 用信审批申请编号
    ,nvl(n.availablecontractamt, o.availablecontractamt) as availablecontractamt -- 额度可用金额
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
from (select * from ${iol_schema}.icms_lx_business_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_business_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.baserialno <> n.baserialno
        or o.relacontractno <> n.relacontractno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.businessflag <> n.businessflag
        or o.productid <> n.productid
        or o.occurdate <> n.occurdate
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.putoutsum <> n.putoutsum
        or o.putoutdate <> n.putoutdate
        or o.termmonth <> n.termmonth
        or o.termday <> n.termday
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.iscycle <> n.iscycle
        or o.risktype <> n.risktype
        or o.ratemodel <> n.ratemodel
        or o.fixedrate <> n.fixedrate
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.rateadjusttype <> n.rateadjusttype
        or o.floatrange <> n.floatrange
        or o.executerate <> n.executerate
        or o.vouchtype <> n.vouchtype
        or o.repaytype <> n.repaytype
        or o.repaycycle <> n.repaycycle
        or o.repaydate <> n.repaydate
        or o.settlementaccount <> n.settlementaccount
        or o.paymenttype <> n.paymenttype
        or o.balance <> n.balance
        or o.normalbalance <> n.normalbalance
        or o.overduebalance <> n.overduebalance
        or o.status <> n.status
        or o.finishdate <> n.finishdate
        or o.finishtype <> n.finishtype
        or o.finishflag <> n.finishflag
        or o.approvestatus <> n.approvestatus
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.creditno <> n.creditno
        or o.applyid <> n.applyid
        or o.availablecontractamt <> n.availablecontractamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_business_contract_cl(
            serialno -- 合同编号
            ,baserialno -- 授信编号
            ,relacontractno -- 关联合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,productid -- 产品编号
            ,occurdate -- 签订日期
            ,currency -- 币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)
            ,risktype -- 风险类型(额度);风险类型（一般、低风险）
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,applyid -- 用信审批申请编号
            ,availablecontractamt -- 额度可用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_business_contract_op(
            serialno -- 合同编号
            ,baserialno -- 授信编号
            ,relacontractno -- 关联合同编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,businessflag -- 额度/业务标志
            ,productid -- 产品编号
            ,occurdate -- 签订日期
            ,currency -- 币种
            ,businesssum -- 合同金额
            ,putoutsum -- 实际放款金额
            ,putoutdate -- 放款日期
            ,termmonth -- 期限(月)
            ,termday -- 期限(天)
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度)
            ,risktype -- 风险类型(额度);风险类型（一般、低风险）
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,fixedrate -- 固定利率
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,floatrange -- 浮动幅度
            ,executerate -- 执行利率
            ,vouchtype -- 担保方式
            ,repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
            ,repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
            ,repaydate -- 指定还款日
            ,settlementaccount -- 结算账号
            ,paymenttype -- 支付方式
            ,balance -- 合同贷款余额
            ,normalbalance -- 正常余额
            ,overduebalance -- 逾期/垫款金额
            ,status -- 合同状态
            ,finishdate -- 终结日期
            ,finishtype -- 终结类型
            ,finishflag -- 结清标志
            ,approvestatus -- 审批状态
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,creditno -- 资方授信编号
            ,applyid -- 用信审批申请编号
            ,availablecontractamt -- 额度可用金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同编号
    ,o.baserialno -- 授信编号
    ,o.relacontractno -- 关联合同编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.businessflag -- 额度/业务标志
    ,o.productid -- 产品编号
    ,o.occurdate -- 签订日期
    ,o.currency -- 币种
    ,o.businesssum -- 合同金额
    ,o.putoutsum -- 实际放款金额
    ,o.putoutdate -- 放款日期
    ,o.termmonth -- 期限(月)
    ,o.termday -- 期限(天)
    ,o.startdate -- 合同开始日期
    ,o.maturity -- 合同到期日期
    ,o.iscycle -- 是否循环(额度)
    ,o.risktype -- 风险类型(额度);风险类型（一般、低风险）
    ,o.ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,o.fixedrate -- 固定利率
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,o.floatrange -- 浮动幅度
    ,o.executerate -- 执行利率
    ,o.vouchtype -- 担保方式
    ,o.repaytype -- 还款方式;还款方式(01等额本金；02等额本息；03按期付息到期还款；04标准按期付息到期还本；（还款周期按季、半年、年；还款日在3、6、9、12月）；05利随本清；06灵活等额本息；07组合还款)
    ,o.repaycycle -- 还款周期;还款周期(1月；2季；3一次；4半年；5年；6双月)
    ,o.repaydate -- 指定还款日
    ,o.settlementaccount -- 结算账号
    ,o.paymenttype -- 支付方式
    ,o.balance -- 合同贷款余额
    ,o.normalbalance -- 正常余额
    ,o.overduebalance -- 逾期/垫款金额
    ,o.status -- 合同状态
    ,o.finishdate -- 终结日期
    ,o.finishtype -- 终结类型
    ,o.finishflag -- 结清标志
    ,o.approvestatus -- 审批状态
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.creditno -- 资方授信编号
    ,o.applyid -- 用信审批申请编号
    ,o.availablecontractamt -- 额度可用金额
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
from ${iol_schema}.icms_lx_business_contract_bk o
    left join ${iol_schema}.icms_lx_business_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_business_contract_cl d
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
--truncate table ${iol_schema}.icms_lx_business_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_business_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_business_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_business_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_business_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_business_contract_cl;
alter table ${iol_schema}.icms_lx_business_contract exchange partition p_20991231 with table ${iol_schema}.icms_lx_business_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_business_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_business_contract_op purge;
drop table ${iol_schema}.icms_lx_business_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_business_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_business_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
