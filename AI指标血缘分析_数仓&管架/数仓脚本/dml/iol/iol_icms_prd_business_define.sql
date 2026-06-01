/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_business_define
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
create table ${iol_schema}.icms_prd_business_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_business_define
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_business_define_op purge;
drop table ${iol_schema}.icms_prd_business_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_business_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_business_define where 0=1;

create table ${iol_schema}.icms_prd_business_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_business_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_business_define_cl(
            productid -- 可售产品编号
            ,graceperiod -- 宽限期
            ,maxbusinesssum -- 自动放款最大金额
            ,rateeffecttype -- 利率生效方式
            ,isfinterest -- 是否收罚息
            ,guarcontractrelate -- 保函与基础合同的关系
            ,newproductname -- 产品名称
            ,maxloanterm -- 最长贷款期限(月)
            ,ratechangecycle -- 利率变更周期
            ,isassociatebail -- 是否关联保证金
            ,issupprepayment -- 是否支持提前还款
            ,increasegrantapprove -- 增量发放审批
            ,oldproductid -- 产品代码
            ,singlegrant -- 单笔发放
            ,isassets -- 是否资产证券化
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,backflag -- 自动回收标志
            ,guaradvanceproduct -- 保函垫款产品
            ,onceminpaymentflag -- 单次最小发放金额(元)
            ,waivedautopayflag -- 持续扣款标志
            ,acceptinttype -- 前收息标识
            ,domesticoroverseas -- 境内境外
            ,customertype -- 客户类型
            ,termmonthflag -- 贷款期限控制标识
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,isopenautofreezebail -- 开立时是否自动冻结保证金
            ,updateorgid -- 更新机构
            ,industrytype -- 客户所属行业
            ,isautoputoutregister -- 是否自动出账登记
            ,isgrantapproveflag -- 发放是否允许审批标识
            ,ictype -- 计息标志
            ,ratetype -- 利率启用方式
            ,compoundintflag -- 是否收复利
            ,overdueclaimsdays -- 逾期理赔天数
            ,isautopayment -- 是否自动受托支付
            ,claimsraio -- 理赔比例
            ,expirydate -- 产品失效日期
            ,maxyearrate -- 最大年化利率
            ,sinosurename -- 受托支付账户名称
            ,minloanterm -- 最短贷款期限(月)
            ,maxextendcount -- 展期最大次数
            ,effectivedate -- 产品生效日期
            ,maxissuecount -- 最大缩期次数
            ,newproductid -- 新产品代码
            ,sinosureaccount -- 受托支付账户
            ,currency -- 币种
            ,propietaryflag -- 自营标志
            ,isexpireautounfreezebail -- 到期是否自动解冻保证金
            ,hostbanknature -- 银团贷款性质
            ,assettrandflag -- 是否资产转让
            ,accounttype -- 账户类型
            ,borrowaccountcheck -- 借款人账户检查
            ,inputorgid -- 登记机构
            ,mincreditterm -- 额度最小期限
            ,guarattribute -- 保函属性
            ,customerlevel -- 最低客户评级
            ,prepayamt -- 还款金额控制
            ,installmentsmenthod -- 可选还款方式
            ,compountinterest -- 复利的复利
            ,isissue -- 是否允许缩期
            ,cycleflag -- 是否循环
            ,oncepaymentflag -- 单次发放金额控制标识
            ,isextend -- 是否允许展期
            ,minyearrate -- 最小年化利率
            ,issuponlineputout -- 是否支持线上放款申请
            ,productname -- 产品名称
            ,vouchtype -- 可选担保方式
            ,isautorecheckputout -- 是否自动复核放款
            ,discounttype -- 贴现贷款类型
            ,istakebackautounfreezebail -- 收回时是否自动解冻保证金
            ,oncemaxpaymentflag -- 单次最大发放金额(元)
            ,iswaivedcomp -- 罚息的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_business_define_op(
            productid -- 可售产品编号
            ,graceperiod -- 宽限期
            ,maxbusinesssum -- 自动放款最大金额
            ,rateeffecttype -- 利率生效方式
            ,isfinterest -- 是否收罚息
            ,guarcontractrelate -- 保函与基础合同的关系
            ,newproductname -- 产品名称
            ,maxloanterm -- 最长贷款期限(月)
            ,ratechangecycle -- 利率变更周期
            ,isassociatebail -- 是否关联保证金
            ,issupprepayment -- 是否支持提前还款
            ,increasegrantapprove -- 增量发放审批
            ,oldproductid -- 产品代码
            ,singlegrant -- 单笔发放
            ,isassets -- 是否资产证券化
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,backflag -- 自动回收标志
            ,guaradvanceproduct -- 保函垫款产品
            ,onceminpaymentflag -- 单次最小发放金额(元)
            ,waivedautopayflag -- 持续扣款标志
            ,acceptinttype -- 前收息标识
            ,domesticoroverseas -- 境内境外
            ,customertype -- 客户类型
            ,termmonthflag -- 贷款期限控制标识
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,isopenautofreezebail -- 开立时是否自动冻结保证金
            ,updateorgid -- 更新机构
            ,industrytype -- 客户所属行业
            ,isautoputoutregister -- 是否自动出账登记
            ,isgrantapproveflag -- 发放是否允许审批标识
            ,ictype -- 计息标志
            ,ratetype -- 利率启用方式
            ,compoundintflag -- 是否收复利
            ,overdueclaimsdays -- 逾期理赔天数
            ,isautopayment -- 是否自动受托支付
            ,claimsraio -- 理赔比例
            ,expirydate -- 产品失效日期
            ,maxyearrate -- 最大年化利率
            ,sinosurename -- 受托支付账户名称
            ,minloanterm -- 最短贷款期限(月)
            ,maxextendcount -- 展期最大次数
            ,effectivedate -- 产品生效日期
            ,maxissuecount -- 最大缩期次数
            ,newproductid -- 新产品代码
            ,sinosureaccount -- 受托支付账户
            ,currency -- 币种
            ,propietaryflag -- 自营标志
            ,isexpireautounfreezebail -- 到期是否自动解冻保证金
            ,hostbanknature -- 银团贷款性质
            ,assettrandflag -- 是否资产转让
            ,accounttype -- 账户类型
            ,borrowaccountcheck -- 借款人账户检查
            ,inputorgid -- 登记机构
            ,mincreditterm -- 额度最小期限
            ,guarattribute -- 保函属性
            ,customerlevel -- 最低客户评级
            ,prepayamt -- 还款金额控制
            ,installmentsmenthod -- 可选还款方式
            ,compountinterest -- 复利的复利
            ,isissue -- 是否允许缩期
            ,cycleflag -- 是否循环
            ,oncepaymentflag -- 单次发放金额控制标识
            ,isextend -- 是否允许展期
            ,minyearrate -- 最小年化利率
            ,issuponlineputout -- 是否支持线上放款申请
            ,productname -- 产品名称
            ,vouchtype -- 可选担保方式
            ,isautorecheckputout -- 是否自动复核放款
            ,discounttype -- 贴现贷款类型
            ,istakebackautounfreezebail -- 收回时是否自动解冻保证金
            ,oncemaxpaymentflag -- 单次最大发放金额(元)
            ,iswaivedcomp -- 罚息的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.productid, o.productid) as productid -- 可售产品编号
    ,nvl(n.graceperiod, o.graceperiod) as graceperiod -- 宽限期
    ,nvl(n.maxbusinesssum, o.maxbusinesssum) as maxbusinesssum -- 自动放款最大金额
    ,nvl(n.rateeffecttype, o.rateeffecttype) as rateeffecttype -- 利率生效方式
    ,nvl(n.isfinterest, o.isfinterest) as isfinterest -- 是否收罚息
    ,nvl(n.guarcontractrelate, o.guarcontractrelate) as guarcontractrelate -- 保函与基础合同的关系
    ,nvl(n.newproductname, o.newproductname) as newproductname -- 产品名称
    ,nvl(n.maxloanterm, o.maxloanterm) as maxloanterm -- 最长贷款期限(月)
    ,nvl(n.ratechangecycle, o.ratechangecycle) as ratechangecycle -- 利率变更周期
    ,nvl(n.isassociatebail, o.isassociatebail) as isassociatebail -- 是否关联保证金
    ,nvl(n.issupprepayment, o.issupprepayment) as issupprepayment -- 是否支持提前还款
    ,nvl(n.increasegrantapprove, o.increasegrantapprove) as increasegrantapprove -- 增量发放审批
    ,nvl(n.oldproductid, o.oldproductid) as oldproductid -- 产品代码
    ,nvl(n.singlegrant, o.singlegrant) as singlegrant -- 单笔发放
    ,nvl(n.isassets, o.isassets) as isassets -- 是否资产证券化
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.backflag, o.backflag) as backflag -- 自动回收标志
    ,nvl(n.guaradvanceproduct, o.guaradvanceproduct) as guaradvanceproduct -- 保函垫款产品
    ,nvl(n.onceminpaymentflag, o.onceminpaymentflag) as onceminpaymentflag -- 单次最小发放金额(元)
    ,nvl(n.waivedautopayflag, o.waivedautopayflag) as waivedautopayflag -- 持续扣款标志
    ,nvl(n.acceptinttype, o.acceptinttype) as acceptinttype -- 前收息标识
    ,nvl(n.domesticoroverseas, o.domesticoroverseas) as domesticoroverseas -- 境内境外
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.termmonthflag, o.termmonthflag) as termmonthflag -- 贷款期限控制标识
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.isopenautofreezebail, o.isopenautofreezebail) as isopenautofreezebail -- 开立时是否自动冻结保证金
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 客户所属行业
    ,nvl(n.isautoputoutregister, o.isautoputoutregister) as isautoputoutregister -- 是否自动出账登记
    ,nvl(n.isgrantapproveflag, o.isgrantapproveflag) as isgrantapproveflag -- 发放是否允许审批标识
    ,nvl(n.ictype, o.ictype) as ictype -- 计息标志
    ,nvl(n.ratetype, o.ratetype) as ratetype -- 利率启用方式
    ,nvl(n.compoundintflag, o.compoundintflag) as compoundintflag -- 是否收复利
    ,nvl(n.overdueclaimsdays, o.overdueclaimsdays) as overdueclaimsdays -- 逾期理赔天数
    ,nvl(n.isautopayment, o.isautopayment) as isautopayment -- 是否自动受托支付
    ,nvl(n.claimsraio, o.claimsraio) as claimsraio -- 理赔比例
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 产品失效日期
    ,nvl(n.maxyearrate, o.maxyearrate) as maxyearrate -- 最大年化利率
    ,nvl(n.sinosurename, o.sinosurename) as sinosurename -- 受托支付账户名称
    ,nvl(n.minloanterm, o.minloanterm) as minloanterm -- 最短贷款期限(月)
    ,nvl(n.maxextendcount, o.maxextendcount) as maxextendcount -- 展期最大次数
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 产品生效日期
    ,nvl(n.maxissuecount, o.maxissuecount) as maxissuecount -- 最大缩期次数
    ,nvl(n.newproductid, o.newproductid) as newproductid -- 新产品代码
    ,nvl(n.sinosureaccount, o.sinosureaccount) as sinosureaccount -- 受托支付账户
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.propietaryflag, o.propietaryflag) as propietaryflag -- 自营标志
    ,nvl(n.isexpireautounfreezebail, o.isexpireautounfreezebail) as isexpireautounfreezebail -- 到期是否自动解冻保证金
    ,nvl(n.hostbanknature, o.hostbanknature) as hostbanknature -- 银团贷款性质
    ,nvl(n.assettrandflag, o.assettrandflag) as assettrandflag -- 是否资产转让
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 账户类型
    ,nvl(n.borrowaccountcheck, o.borrowaccountcheck) as borrowaccountcheck -- 借款人账户检查
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.mincreditterm, o.mincreditterm) as mincreditterm -- 额度最小期限
    ,nvl(n.guarattribute, o.guarattribute) as guarattribute -- 保函属性
    ,nvl(n.customerlevel, o.customerlevel) as customerlevel -- 最低客户评级
    ,nvl(n.prepayamt, o.prepayamt) as prepayamt -- 还款金额控制
    ,nvl(n.installmentsmenthod, o.installmentsmenthod) as installmentsmenthod -- 可选还款方式
    ,nvl(n.compountinterest, o.compountinterest) as compountinterest -- 复利的复利
    ,nvl(n.isissue, o.isissue) as isissue -- 是否允许缩期
    ,nvl(n.cycleflag, o.cycleflag) as cycleflag -- 是否循环
    ,nvl(n.oncepaymentflag, o.oncepaymentflag) as oncepaymentflag -- 单次发放金额控制标识
    ,nvl(n.isextend, o.isextend) as isextend -- 是否允许展期
    ,nvl(n.minyearrate, o.minyearrate) as minyearrate -- 最小年化利率
    ,nvl(n.issuponlineputout, o.issuponlineputout) as issuponlineputout -- 是否支持线上放款申请
    ,nvl(n.productname, o.productname) as productname -- 产品名称
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 可选担保方式
    ,nvl(n.isautorecheckputout, o.isautorecheckputout) as isautorecheckputout -- 是否自动复核放款
    ,nvl(n.discounttype, o.discounttype) as discounttype -- 贴现贷款类型
    ,nvl(n.istakebackautounfreezebail, o.istakebackautounfreezebail) as istakebackautounfreezebail -- 收回时是否自动解冻保证金
    ,nvl(n.oncemaxpaymentflag, o.oncemaxpaymentflag) as oncemaxpaymentflag -- 单次最大发放金额(元)
    ,nvl(n.iswaivedcomp, o.iswaivedcomp) as iswaivedcomp -- 罚息的复利
    ,case when
            n.productid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.productid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.productid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_business_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_business_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.productid = n.productid
where (
        o.productid is null
    )
    or (
        n.productid is null
    )
    or (
        o.graceperiod <> n.graceperiod
        or o.maxbusinesssum <> n.maxbusinesssum
        or o.rateeffecttype <> n.rateeffecttype
        or o.isfinterest <> n.isfinterest
        or o.guarcontractrelate <> n.guarcontractrelate
        or o.newproductname <> n.newproductname
        or o.maxloanterm <> n.maxloanterm
        or o.ratechangecycle <> n.ratechangecycle
        or o.isassociatebail <> n.isassociatebail
        or o.issupprepayment <> n.issupprepayment
        or o.increasegrantapprove <> n.increasegrantapprove
        or o.oldproductid <> n.oldproductid
        or o.singlegrant <> n.singlegrant
        or o.isassets <> n.isassets
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.backflag <> n.backflag
        or o.guaradvanceproduct <> n.guaradvanceproduct
        or o.onceminpaymentflag <> n.onceminpaymentflag
        or o.waivedautopayflag <> n.waivedautopayflag
        or o.acceptinttype <> n.acceptinttype
        or o.domesticoroverseas <> n.domesticoroverseas
        or o.customertype <> n.customertype
        or o.termmonthflag <> n.termmonthflag
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.isopenautofreezebail <> n.isopenautofreezebail
        or o.updateorgid <> n.updateorgid
        or o.industrytype <> n.industrytype
        or o.isautoputoutregister <> n.isautoputoutregister
        or o.isgrantapproveflag <> n.isgrantapproveflag
        or o.ictype <> n.ictype
        or o.ratetype <> n.ratetype
        or o.compoundintflag <> n.compoundintflag
        or o.overdueclaimsdays <> n.overdueclaimsdays
        or o.isautopayment <> n.isautopayment
        or o.claimsraio <> n.claimsraio
        or o.expirydate <> n.expirydate
        or o.maxyearrate <> n.maxyearrate
        or o.sinosurename <> n.sinosurename
        or o.minloanterm <> n.minloanterm
        or o.maxextendcount <> n.maxextendcount
        or o.effectivedate <> n.effectivedate
        or o.maxissuecount <> n.maxissuecount
        or o.newproductid <> n.newproductid
        or o.sinosureaccount <> n.sinosureaccount
        or o.currency <> n.currency
        or o.propietaryflag <> n.propietaryflag
        or o.isexpireautounfreezebail <> n.isexpireautounfreezebail
        or o.hostbanknature <> n.hostbanknature
        or o.assettrandflag <> n.assettrandflag
        or o.accounttype <> n.accounttype
        or o.borrowaccountcheck <> n.borrowaccountcheck
        or o.inputorgid <> n.inputorgid
        or o.mincreditterm <> n.mincreditterm
        or o.guarattribute <> n.guarattribute
        or o.customerlevel <> n.customerlevel
        or o.prepayamt <> n.prepayamt
        or o.installmentsmenthod <> n.installmentsmenthod
        or o.compountinterest <> n.compountinterest
        or o.isissue <> n.isissue
        or o.cycleflag <> n.cycleflag
        or o.oncepaymentflag <> n.oncepaymentflag
        or o.isextend <> n.isextend
        or o.minyearrate <> n.minyearrate
        or o.issuponlineputout <> n.issuponlineputout
        or o.productname <> n.productname
        or o.vouchtype <> n.vouchtype
        or o.isautorecheckputout <> n.isautorecheckputout
        or o.discounttype <> n.discounttype
        or o.istakebackautounfreezebail <> n.istakebackautounfreezebail
        or o.oncemaxpaymentflag <> n.oncemaxpaymentflag
        or o.iswaivedcomp <> n.iswaivedcomp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_business_define_cl(
            productid -- 可售产品编号
            ,graceperiod -- 宽限期
            ,maxbusinesssum -- 自动放款最大金额
            ,rateeffecttype -- 利率生效方式
            ,isfinterest -- 是否收罚息
            ,guarcontractrelate -- 保函与基础合同的关系
            ,newproductname -- 产品名称
            ,maxloanterm -- 最长贷款期限(月)
            ,ratechangecycle -- 利率变更周期
            ,isassociatebail -- 是否关联保证金
            ,issupprepayment -- 是否支持提前还款
            ,increasegrantapprove -- 增量发放审批
            ,oldproductid -- 产品代码
            ,singlegrant -- 单笔发放
            ,isassets -- 是否资产证券化
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,backflag -- 自动回收标志
            ,guaradvanceproduct -- 保函垫款产品
            ,onceminpaymentflag -- 单次最小发放金额(元)
            ,waivedautopayflag -- 持续扣款标志
            ,acceptinttype -- 前收息标识
            ,domesticoroverseas -- 境内境外
            ,customertype -- 客户类型
            ,termmonthflag -- 贷款期限控制标识
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,isopenautofreezebail -- 开立时是否自动冻结保证金
            ,updateorgid -- 更新机构
            ,industrytype -- 客户所属行业
            ,isautoputoutregister -- 是否自动出账登记
            ,isgrantapproveflag -- 发放是否允许审批标识
            ,ictype -- 计息标志
            ,ratetype -- 利率启用方式
            ,compoundintflag -- 是否收复利
            ,overdueclaimsdays -- 逾期理赔天数
            ,isautopayment -- 是否自动受托支付
            ,claimsraio -- 理赔比例
            ,expirydate -- 产品失效日期
            ,maxyearrate -- 最大年化利率
            ,sinosurename -- 受托支付账户名称
            ,minloanterm -- 最短贷款期限(月)
            ,maxextendcount -- 展期最大次数
            ,effectivedate -- 产品生效日期
            ,maxissuecount -- 最大缩期次数
            ,newproductid -- 新产品代码
            ,sinosureaccount -- 受托支付账户
            ,currency -- 币种
            ,propietaryflag -- 自营标志
            ,isexpireautounfreezebail -- 到期是否自动解冻保证金
            ,hostbanknature -- 银团贷款性质
            ,assettrandflag -- 是否资产转让
            ,accounttype -- 账户类型
            ,borrowaccountcheck -- 借款人账户检查
            ,inputorgid -- 登记机构
            ,mincreditterm -- 额度最小期限
            ,guarattribute -- 保函属性
            ,customerlevel -- 最低客户评级
            ,prepayamt -- 还款金额控制
            ,installmentsmenthod -- 可选还款方式
            ,compountinterest -- 复利的复利
            ,isissue -- 是否允许缩期
            ,cycleflag -- 是否循环
            ,oncepaymentflag -- 单次发放金额控制标识
            ,isextend -- 是否允许展期
            ,minyearrate -- 最小年化利率
            ,issuponlineputout -- 是否支持线上放款申请
            ,productname -- 产品名称
            ,vouchtype -- 可选担保方式
            ,isautorecheckputout -- 是否自动复核放款
            ,discounttype -- 贴现贷款类型
            ,istakebackautounfreezebail -- 收回时是否自动解冻保证金
            ,oncemaxpaymentflag -- 单次最大发放金额(元)
            ,iswaivedcomp -- 罚息的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_business_define_op(
            productid -- 可售产品编号
            ,graceperiod -- 宽限期
            ,maxbusinesssum -- 自动放款最大金额
            ,rateeffecttype -- 利率生效方式
            ,isfinterest -- 是否收罚息
            ,guarcontractrelate -- 保函与基础合同的关系
            ,newproductname -- 产品名称
            ,maxloanterm -- 最长贷款期限(月)
            ,ratechangecycle -- 利率变更周期
            ,isassociatebail -- 是否关联保证金
            ,issupprepayment -- 是否支持提前还款
            ,increasegrantapprove -- 增量发放审批
            ,oldproductid -- 产品代码
            ,singlegrant -- 单笔发放
            ,isassets -- 是否资产证券化
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,backflag -- 自动回收标志
            ,guaradvanceproduct -- 保函垫款产品
            ,onceminpaymentflag -- 单次最小发放金额(元)
            ,waivedautopayflag -- 持续扣款标志
            ,acceptinttype -- 前收息标识
            ,domesticoroverseas -- 境内境外
            ,customertype -- 客户类型
            ,termmonthflag -- 贷款期限控制标识
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,isopenautofreezebail -- 开立时是否自动冻结保证金
            ,updateorgid -- 更新机构
            ,industrytype -- 客户所属行业
            ,isautoputoutregister -- 是否自动出账登记
            ,isgrantapproveflag -- 发放是否允许审批标识
            ,ictype -- 计息标志
            ,ratetype -- 利率启用方式
            ,compoundintflag -- 是否收复利
            ,overdueclaimsdays -- 逾期理赔天数
            ,isautopayment -- 是否自动受托支付
            ,claimsraio -- 理赔比例
            ,expirydate -- 产品失效日期
            ,maxyearrate -- 最大年化利率
            ,sinosurename -- 受托支付账户名称
            ,minloanterm -- 最短贷款期限(月)
            ,maxextendcount -- 展期最大次数
            ,effectivedate -- 产品生效日期
            ,maxissuecount -- 最大缩期次数
            ,newproductid -- 新产品代码
            ,sinosureaccount -- 受托支付账户
            ,currency -- 币种
            ,propietaryflag -- 自营标志
            ,isexpireautounfreezebail -- 到期是否自动解冻保证金
            ,hostbanknature -- 银团贷款性质
            ,assettrandflag -- 是否资产转让
            ,accounttype -- 账户类型
            ,borrowaccountcheck -- 借款人账户检查
            ,inputorgid -- 登记机构
            ,mincreditterm -- 额度最小期限
            ,guarattribute -- 保函属性
            ,customerlevel -- 最低客户评级
            ,prepayamt -- 还款金额控制
            ,installmentsmenthod -- 可选还款方式
            ,compountinterest -- 复利的复利
            ,isissue -- 是否允许缩期
            ,cycleflag -- 是否循环
            ,oncepaymentflag -- 单次发放金额控制标识
            ,isextend -- 是否允许展期
            ,minyearrate -- 最小年化利率
            ,issuponlineputout -- 是否支持线上放款申请
            ,productname -- 产品名称
            ,vouchtype -- 可选担保方式
            ,isautorecheckputout -- 是否自动复核放款
            ,discounttype -- 贴现贷款类型
            ,istakebackautounfreezebail -- 收回时是否自动解冻保证金
            ,oncemaxpaymentflag -- 单次最大发放金额(元)
            ,iswaivedcomp -- 罚息的复利
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.productid -- 可售产品编号
    ,o.graceperiod -- 宽限期
    ,o.maxbusinesssum -- 自动放款最大金额
    ,o.rateeffecttype -- 利率生效方式
    ,o.isfinterest -- 是否收罚息
    ,o.guarcontractrelate -- 保函与基础合同的关系
    ,o.newproductname -- 产品名称
    ,o.maxloanterm -- 最长贷款期限(月)
    ,o.ratechangecycle -- 利率变更周期
    ,o.isassociatebail -- 是否关联保证金
    ,o.issupprepayment -- 是否支持提前还款
    ,o.increasegrantapprove -- 增量发放审批
    ,o.oldproductid -- 产品代码
    ,o.singlegrant -- 单笔发放
    ,o.isassets -- 是否资产证券化
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.backflag -- 自动回收标志
    ,o.guaradvanceproduct -- 保函垫款产品
    ,o.onceminpaymentflag -- 单次最小发放金额(元)
    ,o.waivedautopayflag -- 持续扣款标志
    ,o.acceptinttype -- 前收息标识
    ,o.domesticoroverseas -- 境内境外
    ,o.customertype -- 客户类型
    ,o.termmonthflag -- 贷款期限控制标识
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.isopenautofreezebail -- 开立时是否自动冻结保证金
    ,o.updateorgid -- 更新机构
    ,o.industrytype -- 客户所属行业
    ,o.isautoputoutregister -- 是否自动出账登记
    ,o.isgrantapproveflag -- 发放是否允许审批标识
    ,o.ictype -- 计息标志
    ,o.ratetype -- 利率启用方式
    ,o.compoundintflag -- 是否收复利
    ,o.overdueclaimsdays -- 逾期理赔天数
    ,o.isautopayment -- 是否自动受托支付
    ,o.claimsraio -- 理赔比例
    ,o.expirydate -- 产品失效日期
    ,o.maxyearrate -- 最大年化利率
    ,o.sinosurename -- 受托支付账户名称
    ,o.minloanterm -- 最短贷款期限(月)
    ,o.maxextendcount -- 展期最大次数
    ,o.effectivedate -- 产品生效日期
    ,o.maxissuecount -- 最大缩期次数
    ,o.newproductid -- 新产品代码
    ,o.sinosureaccount -- 受托支付账户
    ,o.currency -- 币种
    ,o.propietaryflag -- 自营标志
    ,o.isexpireautounfreezebail -- 到期是否自动解冻保证金
    ,o.hostbanknature -- 银团贷款性质
    ,o.assettrandflag -- 是否资产转让
    ,o.accounttype -- 账户类型
    ,o.borrowaccountcheck -- 借款人账户检查
    ,o.inputorgid -- 登记机构
    ,o.mincreditterm -- 额度最小期限
    ,o.guarattribute -- 保函属性
    ,o.customerlevel -- 最低客户评级
    ,o.prepayamt -- 还款金额控制
    ,o.installmentsmenthod -- 可选还款方式
    ,o.compountinterest -- 复利的复利
    ,o.isissue -- 是否允许缩期
    ,o.cycleflag -- 是否循环
    ,o.oncepaymentflag -- 单次发放金额控制标识
    ,o.isextend -- 是否允许展期
    ,o.minyearrate -- 最小年化利率
    ,o.issuponlineputout -- 是否支持线上放款申请
    ,o.productname -- 产品名称
    ,o.vouchtype -- 可选担保方式
    ,o.isautorecheckputout -- 是否自动复核放款
    ,o.discounttype -- 贴现贷款类型
    ,o.istakebackautounfreezebail -- 收回时是否自动解冻保证金
    ,o.oncemaxpaymentflag -- 单次最大发放金额(元)
    ,o.iswaivedcomp -- 罚息的复利
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
from ${iol_schema}.icms_prd_business_define_bk o
    left join ${iol_schema}.icms_prd_business_define_op n
        on
            o.productid = n.productid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_business_define_cl d
        on
            o.productid = d.productid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_business_define;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_business_define') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_business_define drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_business_define add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_business_define exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_business_define_cl;
alter table ${iol_schema}.icms_prd_business_define exchange partition p_20991231 with table ${iol_schema}.icms_prd_business_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_business_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_business_define_op purge;
drop table ${iol_schema}.icms_prd_business_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_business_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_business_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
