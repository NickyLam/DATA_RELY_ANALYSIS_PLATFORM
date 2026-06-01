/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_business_contract
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
create table ${iol_schema}.icms_wph_business_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_business_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_contract_op purge;
drop table ${iol_schema}.icms_wph_business_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_contract where 0=1;

create table ${iol_schema}.icms_wph_business_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_business_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_contract_cl(
            serialno -- 合同流水号
            ,creditappno -- 授信申请编号
            ,occurdate -- 签订日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,term -- 贷款期限
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度);是否循环
            ,islowrisk -- 是否低风险业务
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,executerate -- 执行利率
            ,settlementaccount -- 结算账号
            ,status -- 合同状态
            ,contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
            ,putoutorgid -- 出账机构编号(核心机构)
            ,loanaccountno -- 入账账户
            ,repaydate -- 指定还款日
            ,tenantid -- 租户ID
            ,userid -- 唯品用户编号
            ,wphproductid -- 唯品产品编号
            ,loanamount -- 唯品合同金额
            ,loanamountcrop -- 合作方放款金额
            ,loanuse -- 唯品贷款用途
            ,amortmethod -- 唯品还款方式
            ,tenor -- 唯品贷款期数
            ,loandate -- 唯品放款日期
            ,paymentdate -- 首次还款时间
            ,creditlimit -- 平台对客授信金额
            ,availablelimit -- 客户可用余额
            ,guaranteecontractno -- 担保合同号
            ,voucheecontractno -- 被担保合同号
            ,loancard -- 放款卡
            ,businesstype -- 业务类型
            ,applyid -- 第三方申请编号
            ,loanapplyid -- 用信申请流水号
            ,failreason -- 风控拒绝原因
            ,riskstatus -- 风控结果
            ,vouchtype -- 主担保方式
            ,reqbody -- 风控请求报文
            ,jkstatus -- 接口状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_contract_op(
            serialno -- 合同流水号
            ,creditappno -- 授信申请编号
            ,occurdate -- 签订日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,term -- 贷款期限
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度);是否循环
            ,islowrisk -- 是否低风险业务
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,executerate -- 执行利率
            ,settlementaccount -- 结算账号
            ,status -- 合同状态
            ,contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
            ,putoutorgid -- 出账机构编号(核心机构)
            ,loanaccountno -- 入账账户
            ,repaydate -- 指定还款日
            ,tenantid -- 租户ID
            ,userid -- 唯品用户编号
            ,wphproductid -- 唯品产品编号
            ,loanamount -- 唯品合同金额
            ,loanamountcrop -- 合作方放款金额
            ,loanuse -- 唯品贷款用途
            ,amortmethod -- 唯品还款方式
            ,tenor -- 唯品贷款期数
            ,loandate -- 唯品放款日期
            ,paymentdate -- 首次还款时间
            ,creditlimit -- 平台对客授信金额
            ,availablelimit -- 客户可用余额
            ,guaranteecontractno -- 担保合同号
            ,voucheecontractno -- 被担保合同号
            ,loancard -- 放款卡
            ,businesstype -- 业务类型
            ,applyid -- 第三方申请编号
            ,loanapplyid -- 用信申请流水号
            ,failreason -- 风控拒绝原因
            ,riskstatus -- 风控结果
            ,vouchtype -- 主担保方式
            ,reqbody -- 风控请求报文
            ,jkstatus -- 接口状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同流水号
    ,nvl(n.creditappno, o.creditappno) as creditappno -- 授信申请编号
    ,nvl(n.occurdate, o.occurdate) as occurdate -- 签订日期
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.currency, o.currency) as currency -- 额度/业务币种
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.term, o.term) as term -- 贷款期限
    ,nvl(n.startdate, o.startdate) as startdate -- 合同开始日期
    ,nvl(n.maturity, o.maturity) as maturity -- 合同到期日期
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环(额度);是否循环
    ,nvl(n.islowrisk, o.islowrisk) as islowrisk -- 是否低风险业务
    ,nvl(n.ratemodel, o.ratemodel) as ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,nvl(n.baseratetype, o.baseratetype) as baseratetype -- 基准利率类型
    ,nvl(n.baserate, o.baserate) as baserate -- 基准利率
    ,nvl(n.ratefloattype, o.ratefloattype) as ratefloattype -- 利率浮动方式
    ,nvl(n.rateadjusttype, o.rateadjusttype) as rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.status, o.status) as status -- 合同状态
    ,nvl(n.contracttype, o.contracttype) as contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 出账机构编号(核心机构)
    ,nvl(n.loanaccountno, o.loanaccountno) as loanaccountno -- 入账账户
    ,nvl(n.repaydate, o.repaydate) as repaydate -- 指定还款日
    ,nvl(n.tenantid, o.tenantid) as tenantid -- 租户ID
    ,nvl(n.userid, o.userid) as userid -- 唯品用户编号
    ,nvl(n.wphproductid, o.wphproductid) as wphproductid -- 唯品产品编号
    ,nvl(n.loanamount, o.loanamount) as loanamount -- 唯品合同金额
    ,nvl(n.loanamountcrop, o.loanamountcrop) as loanamountcrop -- 合作方放款金额
    ,nvl(n.loanuse, o.loanuse) as loanuse -- 唯品贷款用途
    ,nvl(n.amortmethod, o.amortmethod) as amortmethod -- 唯品还款方式
    ,nvl(n.tenor, o.tenor) as tenor -- 唯品贷款期数
    ,nvl(n.loandate, o.loandate) as loandate -- 唯品放款日期
    ,nvl(n.paymentdate, o.paymentdate) as paymentdate -- 首次还款时间
    ,nvl(n.creditlimit, o.creditlimit) as creditlimit -- 平台对客授信金额
    ,nvl(n.availablelimit, o.availablelimit) as availablelimit -- 客户可用余额
    ,nvl(n.guaranteecontractno, o.guaranteecontractno) as guaranteecontractno -- 担保合同号
    ,nvl(n.voucheecontractno, o.voucheecontractno) as voucheecontractno -- 被担保合同号
    ,nvl(n.loancard, o.loancard) as loancard -- 放款卡
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 业务类型
    ,nvl(n.applyid, o.applyid) as applyid -- 第三方申请编号
    ,nvl(n.loanapplyid, o.loanapplyid) as loanapplyid -- 用信申请流水号
    ,nvl(n.failreason, o.failreason) as failreason -- 风控拒绝原因
    ,nvl(n.riskstatus, o.riskstatus) as riskstatus -- 风控结果
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.reqbody, o.reqbody) as reqbody -- 风控请求报文
    ,nvl(n.jkstatus, o.jkstatus) as jkstatus -- 接口状态
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
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
from (select * from ${iol_schema}.icms_wph_business_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_business_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.creditappno <> n.creditappno
        or o.occurdate <> n.occurdate
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.productid <> n.productid
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.term <> n.term
        or o.startdate <> n.startdate
        or o.maturity <> n.maturity
        or o.iscycle <> n.iscycle
        or o.islowrisk <> n.islowrisk
        or o.ratemodel <> n.ratemodel
        or o.baseratetype <> n.baseratetype
        or o.baserate <> n.baserate
        or o.ratefloattype <> n.ratefloattype
        or o.rateadjusttype <> n.rateadjusttype
        or o.executerate <> n.executerate
        or o.settlementaccount <> n.settlementaccount
        or o.status <> n.status
        or o.contracttype <> n.contracttype
        or o.putoutorgid <> n.putoutorgid
        or o.loanaccountno <> n.loanaccountno
        or o.repaydate <> n.repaydate
        or o.tenantid <> n.tenantid
        or o.userid <> n.userid
        or o.wphproductid <> n.wphproductid
        or o.loanamount <> n.loanamount
        or o.loanamountcrop <> n.loanamountcrop
        or o.loanuse <> n.loanuse
        or o.amortmethod <> n.amortmethod
        or o.tenor <> n.tenor
        or o.loandate <> n.loandate
        or o.paymentdate <> n.paymentdate
        or o.creditlimit <> n.creditlimit
        or o.availablelimit <> n.availablelimit
        or o.guaranteecontractno <> n.guaranteecontractno
        or o.voucheecontractno <> n.voucheecontractno
        or o.loancard <> n.loancard
        or o.businesstype <> n.businesstype
        or o.applyid <> n.applyid
        or o.loanapplyid <> n.loanapplyid
        or o.failreason <> n.failreason
        or o.riskstatus <> n.riskstatus
        or o.vouchtype <> n.vouchtype
        or o.reqbody <> n.reqbody
        or o.jkstatus <> n.jkstatus
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_business_contract_cl(
            serialno -- 合同流水号
            ,creditappno -- 授信申请编号
            ,occurdate -- 签订日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,term -- 贷款期限
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度);是否循环
            ,islowrisk -- 是否低风险业务
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,executerate -- 执行利率
            ,settlementaccount -- 结算账号
            ,status -- 合同状态
            ,contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
            ,putoutorgid -- 出账机构编号(核心机构)
            ,loanaccountno -- 入账账户
            ,repaydate -- 指定还款日
            ,tenantid -- 租户ID
            ,userid -- 唯品用户编号
            ,wphproductid -- 唯品产品编号
            ,loanamount -- 唯品合同金额
            ,loanamountcrop -- 合作方放款金额
            ,loanuse -- 唯品贷款用途
            ,amortmethod -- 唯品还款方式
            ,tenor -- 唯品贷款期数
            ,loandate -- 唯品放款日期
            ,paymentdate -- 首次还款时间
            ,creditlimit -- 平台对客授信金额
            ,availablelimit -- 客户可用余额
            ,guaranteecontractno -- 担保合同号
            ,voucheecontractno -- 被担保合同号
            ,loancard -- 放款卡
            ,businesstype -- 业务类型
            ,applyid -- 第三方申请编号
            ,loanapplyid -- 用信申请流水号
            ,failreason -- 风控拒绝原因
            ,riskstatus -- 风控结果
            ,vouchtype -- 主担保方式
            ,reqbody -- 风控请求报文
            ,jkstatus -- 接口状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_business_contract_op(
            serialno -- 合同流水号
            ,creditappno -- 授信申请编号
            ,occurdate -- 签订日期
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,productid -- 产品编号
            ,currency -- 额度/业务币种
            ,businesssum -- 合同金额
            ,term -- 贷款期限
            ,startdate -- 合同开始日期
            ,maturity -- 合同到期日期
            ,iscycle -- 是否循环(额度);是否循环
            ,islowrisk -- 是否低风险业务
            ,ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
            ,baseratetype -- 基准利率类型
            ,baserate -- 基准利率
            ,ratefloattype -- 利率浮动方式
            ,rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
            ,executerate -- 执行利率
            ,settlementaccount -- 结算账号
            ,status -- 合同状态
            ,contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
            ,putoutorgid -- 出账机构编号(核心机构)
            ,loanaccountno -- 入账账户
            ,repaydate -- 指定还款日
            ,tenantid -- 租户ID
            ,userid -- 唯品用户编号
            ,wphproductid -- 唯品产品编号
            ,loanamount -- 唯品合同金额
            ,loanamountcrop -- 合作方放款金额
            ,loanuse -- 唯品贷款用途
            ,amortmethod -- 唯品还款方式
            ,tenor -- 唯品贷款期数
            ,loandate -- 唯品放款日期
            ,paymentdate -- 首次还款时间
            ,creditlimit -- 平台对客授信金额
            ,availablelimit -- 客户可用余额
            ,guaranteecontractno -- 担保合同号
            ,voucheecontractno -- 被担保合同号
            ,loancard -- 放款卡
            ,businesstype -- 业务类型
            ,applyid -- 第三方申请编号
            ,loanapplyid -- 用信申请流水号
            ,failreason -- 风控拒绝原因
            ,riskstatus -- 风控结果
            ,vouchtype -- 主担保方式
            ,reqbody -- 风控请求报文
            ,jkstatus -- 接口状态
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同流水号
    ,o.creditappno -- 授信申请编号
    ,o.occurdate -- 签订日期
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.productid -- 产品编号
    ,o.currency -- 额度/业务币种
    ,o.businesssum -- 合同金额
    ,o.term -- 贷款期限
    ,o.startdate -- 合同开始日期
    ,o.maturity -- 合同到期日期
    ,o.iscycle -- 是否循环(额度);是否循环
    ,o.islowrisk -- 是否低风险业务
    ,o.ratemodel -- 利率模式;利率模式(1固定利率；2浮动利率；3组合利率)
    ,o.baseratetype -- 基准利率类型
    ,o.baserate -- 基准利率
    ,o.ratefloattype -- 利率浮动方式
    ,o.rateadjusttype -- 利率调整方式;利率调整方式(1立即;2次年初;3次年对月对日;4按月调;5下一个还款日调整)
    ,o.executerate -- 执行利率
    ,o.settlementaccount -- 结算账号
    ,o.status -- 合同状态
    ,o.contracttype -- 合同类型;合同类型(一般合同/虚拟合同)
    ,o.putoutorgid -- 出账机构编号(核心机构)
    ,o.loanaccountno -- 入账账户
    ,o.repaydate -- 指定还款日
    ,o.tenantid -- 租户ID
    ,o.userid -- 唯品用户编号
    ,o.wphproductid -- 唯品产品编号
    ,o.loanamount -- 唯品合同金额
    ,o.loanamountcrop -- 合作方放款金额
    ,o.loanuse -- 唯品贷款用途
    ,o.amortmethod -- 唯品还款方式
    ,o.tenor -- 唯品贷款期数
    ,o.loandate -- 唯品放款日期
    ,o.paymentdate -- 首次还款时间
    ,o.creditlimit -- 平台对客授信金额
    ,o.availablelimit -- 客户可用余额
    ,o.guaranteecontractno -- 担保合同号
    ,o.voucheecontractno -- 被担保合同号
    ,o.loancard -- 放款卡
    ,o.businesstype -- 业务类型
    ,o.applyid -- 第三方申请编号
    ,o.loanapplyid -- 用信申请流水号
    ,o.failreason -- 风控拒绝原因
    ,o.riskstatus -- 风控结果
    ,o.vouchtype -- 主担保方式
    ,o.reqbody -- 风控请求报文
    ,o.jkstatus -- 接口状态
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
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
from ${iol_schema}.icms_wph_business_contract_bk o
    left join ${iol_schema}.icms_wph_business_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_business_contract_cl d
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
--truncate table ${iol_schema}.icms_wph_business_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_business_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_business_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_business_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_business_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_business_contract_cl;
alter table ${iol_schema}.icms_wph_business_contract exchange partition p_20991231 with table ${iol_schema}.icms_wph_business_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_business_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_business_contract_op purge;
drop table ${iol_schema}.icms_wph_business_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_business_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_business_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
