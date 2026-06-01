/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_finance_batch_record
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
create table ${iol_schema}.icms_finance_batch_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_finance_batch_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_finance_batch_record_op purge;
drop table ${iol_schema}.icms_finance_batch_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_finance_batch_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_finance_batch_record where 0=1;

create table ${iol_schema}.icms_finance_batch_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_finance_batch_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_finance_batch_record_cl(
            serialno -- 流水号
            ,baserialno -- 关联子授信编号
            ,objectno -- 关联主授信编号
            ,ftserialno -- 流程表流水号
            ,objecttype -- 关联类型
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,businesscurrency -- 币种
            ,occurtype -- 发生方式
            ,exposuresum -- 敞口金额
            ,businesssum -- 额度金额
            ,termmonth -- 期限月
            ,iscycle -- 是否循环
            ,isagree -- 是否同意
            ,issure -- 是否确认
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,issignificantnegativeinformation -- 是否有重大负面信息
            ,iscontrollerchanged -- 是否有重大负面信息
            ,israterisklevellower -- 评级是否下调
            ,revenuescale -- 营收规模
            ,profitability -- 盈利能力
            ,operationcapability -- 运营能力
            ,rigidliabilities -- 刚性负债
            ,netoperatingcashflow -- 经营性净现金流
            ,bdbusinesssum -- 借据额度金额
            ,enttype -- 企业性质
            ,raterisklevel -- 近期主体评级
            ,onlineamount -- 线上额度
            ,isexistsrisk -- 是否存在其他重大风险
            ,isbusinesschange -- 经营情况是否发生重大变化
            ,searchstatus -- 查询外部数据状态
            ,searcherrorreason -- 查询外部数据异常原因
            ,searchdate -- 外部数据日期
            ,othersum -- 其他有效授信
            ,singlecustomersum -- 单一客户管理限额
            ,belonggroupname -- 归属集团（行内集团）
            ,nominalamount -- 集团管理额度
            ,grouprelationshipcheckresult -- 集团关系探测结果
            ,atualcontroller -- 实际控制人
            ,isshareholderchange -- 控股股东是否发生变化
            ,newratingprospect -- 最新一期评级展望
            ,isissuebondschange -- 近一年是否新发行债券
            ,isincomechange -- 收入构成是否发生重大变化
            ,isnegativeinformationcheck -- 是否命中负面信息校验
            ,isdefaultexist -- 是否存在非标违约
            ,iscomticketoverdueexist -- 是否存在商票逾期
            ,negativeinfo -- 负面信息说明
            ,issignificantnegativeinfomation -- 是否有重大负面信息
            ,outgroupname -- 外部集团
            ,negativeshow -- 负面信息
            ,newopiniondate -- 最近一期审计意见时间
            ,newopinion -- 最近一期审计意见
            ,isredeem -- 是否未赎回二级资本债或永续债
            ,annualauditbusinesssum -- 年审核定额度
            ,annualauditexposuresum -- 年审核定敞口金额
            ,isyeartocheck -- 是否年审
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_finance_batch_record_op(
            serialno -- 流水号
            ,baserialno -- 关联子授信编号
            ,objectno -- 关联主授信编号
            ,ftserialno -- 流程表流水号
            ,objecttype -- 关联类型
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,businesscurrency -- 币种
            ,occurtype -- 发生方式
            ,exposuresum -- 敞口金额
            ,businesssum -- 额度金额
            ,termmonth -- 期限月
            ,iscycle -- 是否循环
            ,isagree -- 是否同意
            ,issure -- 是否确认
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,issignificantnegativeinformation -- 是否有重大负面信息
            ,iscontrollerchanged -- 是否有重大负面信息
            ,israterisklevellower -- 评级是否下调
            ,revenuescale -- 营收规模
            ,profitability -- 盈利能力
            ,operationcapability -- 运营能力
            ,rigidliabilities -- 刚性负债
            ,netoperatingcashflow -- 经营性净现金流
            ,bdbusinesssum -- 借据额度金额
            ,enttype -- 企业性质
            ,raterisklevel -- 近期主体评级
            ,onlineamount -- 线上额度
            ,isexistsrisk -- 是否存在其他重大风险
            ,isbusinesschange -- 经营情况是否发生重大变化
            ,searchstatus -- 查询外部数据状态
            ,searcherrorreason -- 查询外部数据异常原因
            ,searchdate -- 外部数据日期
            ,othersum -- 其他有效授信
            ,singlecustomersum -- 单一客户管理限额
            ,belonggroupname -- 归属集团（行内集团）
            ,nominalamount -- 集团管理额度
            ,grouprelationshipcheckresult -- 集团关系探测结果
            ,atualcontroller -- 实际控制人
            ,isshareholderchange -- 控股股东是否发生变化
            ,newratingprospect -- 最新一期评级展望
            ,isissuebondschange -- 近一年是否新发行债券
            ,isincomechange -- 收入构成是否发生重大变化
            ,isnegativeinformationcheck -- 是否命中负面信息校验
            ,isdefaultexist -- 是否存在非标违约
            ,iscomticketoverdueexist -- 是否存在商票逾期
            ,negativeinfo -- 负面信息说明
            ,issignificantnegativeinfomation -- 是否有重大负面信息
            ,outgroupname -- 外部集团
            ,negativeshow -- 负面信息
            ,newopiniondate -- 最近一期审计意见时间
            ,newopinion -- 最近一期审计意见
            ,isredeem -- 是否未赎回二级资本债或永续债
            ,annualauditbusinesssum -- 年审核定额度
            ,annualauditexposuresum -- 年审核定敞口金额
            ,isyeartocheck -- 是否年审
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 关联子授信编号
    ,nvl(n.objectno, o.objectno) as objectno -- 关联主授信编号
    ,nvl(n.ftserialno, o.ftserialno) as ftserialno -- 流程表流水号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 关联类型
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.occurtype, o.occurtype) as occurtype -- 发生方式
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 敞口金额
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 额度金额
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限月
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 是否循环
    ,nvl(n.isagree, o.isagree) as isagree -- 是否同意
    ,nvl(n.issure, o.issure) as issure -- 是否确认
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.issignificantnegativeinformation, o.issignificantnegativeinformation) as issignificantnegativeinformation -- 是否有重大负面信息
    ,nvl(n.iscontrollerchanged, o.iscontrollerchanged) as iscontrollerchanged -- 是否有重大负面信息
    ,nvl(n.israterisklevellower, o.israterisklevellower) as israterisklevellower -- 评级是否下调
    ,nvl(n.revenuescale, o.revenuescale) as revenuescale -- 营收规模
    ,nvl(n.profitability, o.profitability) as profitability -- 盈利能力
    ,nvl(n.operationcapability, o.operationcapability) as operationcapability -- 运营能力
    ,nvl(n.rigidliabilities, o.rigidliabilities) as rigidliabilities -- 刚性负债
    ,nvl(n.netoperatingcashflow, o.netoperatingcashflow) as netoperatingcashflow -- 经营性净现金流
    ,nvl(n.bdbusinesssum, o.bdbusinesssum) as bdbusinesssum -- 借据额度金额
    ,nvl(n.enttype, o.enttype) as enttype -- 企业性质
    ,nvl(n.raterisklevel, o.raterisklevel) as raterisklevel -- 近期主体评级
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 线上额度
    ,nvl(n.isexistsrisk, o.isexistsrisk) as isexistsrisk -- 是否存在其他重大风险
    ,nvl(n.isbusinesschange, o.isbusinesschange) as isbusinesschange -- 经营情况是否发生重大变化
    ,nvl(n.searchstatus, o.searchstatus) as searchstatus -- 查询外部数据状态
    ,nvl(n.searcherrorreason, o.searcherrorreason) as searcherrorreason -- 查询外部数据异常原因
    ,nvl(n.searchdate, o.searchdate) as searchdate -- 外部数据日期
    ,nvl(n.othersum, o.othersum) as othersum -- 其他有效授信
    ,nvl(n.singlecustomersum, o.singlecustomersum) as singlecustomersum -- 单一客户管理限额
    ,nvl(n.belonggroupname, o.belonggroupname) as belonggroupname -- 归属集团（行内集团）
    ,nvl(n.nominalamount, o.nominalamount) as nominalamount -- 集团管理额度
    ,nvl(n.grouprelationshipcheckresult, o.grouprelationshipcheckresult) as grouprelationshipcheckresult -- 集团关系探测结果
    ,nvl(n.atualcontroller, o.atualcontroller) as atualcontroller -- 实际控制人
    ,nvl(n.isshareholderchange, o.isshareholderchange) as isshareholderchange -- 控股股东是否发生变化
    ,nvl(n.newratingprospect, o.newratingprospect) as newratingprospect -- 最新一期评级展望
    ,nvl(n.isissuebondschange, o.isissuebondschange) as isissuebondschange -- 近一年是否新发行债券
    ,nvl(n.isincomechange, o.isincomechange) as isincomechange -- 收入构成是否发生重大变化
    ,nvl(n.isnegativeinformationcheck, o.isnegativeinformationcheck) as isnegativeinformationcheck -- 是否命中负面信息校验
    ,nvl(n.isdefaultexist, o.isdefaultexist) as isdefaultexist -- 是否存在非标违约
    ,nvl(n.iscomticketoverdueexist, o.iscomticketoverdueexist) as iscomticketoverdueexist -- 是否存在商票逾期
    ,nvl(n.negativeinfo, o.negativeinfo) as negativeinfo -- 负面信息说明
    ,nvl(n.issignificantnegativeinfomation, o.issignificantnegativeinfomation) as issignificantnegativeinfomation -- 是否有重大负面信息
    ,nvl(n.outgroupname, o.outgroupname) as outgroupname -- 外部集团
    ,nvl(n.negativeshow, o.negativeshow) as negativeshow -- 负面信息
    ,nvl(n.newopiniondate, o.newopiniondate) as newopiniondate -- 最近一期审计意见时间
    ,nvl(n.newopinion, o.newopinion) as newopinion -- 最近一期审计意见
    ,nvl(n.isredeem, o.isredeem) as isredeem -- 是否未赎回二级资本债或永续债
    ,nvl(n.annualauditbusinesssum, o.annualauditbusinesssum) as annualauditbusinesssum -- 年审核定额度
    ,nvl(n.annualauditexposuresum, o.annualauditexposuresum) as annualauditexposuresum -- 年审核定敞口金额
    ,nvl(n.isyeartocheck, o.isyeartocheck) as isyeartocheck -- 是否年审
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
from (select * from ${iol_schema}.icms_finance_batch_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_finance_batch_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.objectno <> n.objectno
        or o.ftserialno <> n.ftserialno
        or o.objecttype <> n.objecttype
        or o.customerid <> n.customerid
        or o.productid <> n.productid
        or o.businesscurrency <> n.businesscurrency
        or o.occurtype <> n.occurtype
        or o.exposuresum <> n.exposuresum
        or o.businesssum <> n.businesssum
        or o.termmonth <> n.termmonth
        or o.iscycle <> n.iscycle
        or o.isagree <> n.isagree
        or o.issure <> n.issure
        or o.remark <> n.remark
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.issignificantnegativeinformation <> n.issignificantnegativeinformation
        or o.iscontrollerchanged <> n.iscontrollerchanged
        or o.israterisklevellower <> n.israterisklevellower
        or o.revenuescale <> n.revenuescale
        or o.profitability <> n.profitability
        or o.operationcapability <> n.operationcapability
        or o.rigidliabilities <> n.rigidliabilities
        or o.netoperatingcashflow <> n.netoperatingcashflow
        or o.bdbusinesssum <> n.bdbusinesssum
        or o.enttype <> n.enttype
        or o.raterisklevel <> n.raterisklevel
        or o.onlineamount <> n.onlineamount
        or o.isexistsrisk <> n.isexistsrisk
        or o.isbusinesschange <> n.isbusinesschange
        or o.searchstatus <> n.searchstatus
        or o.searcherrorreason <> n.searcherrorreason
        or o.searchdate <> n.searchdate
        or o.othersum <> n.othersum
        or o.singlecustomersum <> n.singlecustomersum
        or o.belonggroupname <> n.belonggroupname
        or o.nominalamount <> n.nominalamount
        or o.grouprelationshipcheckresult <> n.grouprelationshipcheckresult
        or o.atualcontroller <> n.atualcontroller
        or o.isshareholderchange <> n.isshareholderchange
        or o.newratingprospect <> n.newratingprospect
        or o.isissuebondschange <> n.isissuebondschange
        or o.isincomechange <> n.isincomechange
        or o.isnegativeinformationcheck <> n.isnegativeinformationcheck
        or o.isdefaultexist <> n.isdefaultexist
        or o.iscomticketoverdueexist <> n.iscomticketoverdueexist
        or o.negativeinfo <> n.negativeinfo
        or o.issignificantnegativeinfomation <> n.issignificantnegativeinfomation
        or o.outgroupname <> n.outgroupname
        or o.negativeshow <> n.negativeshow
        or o.newopiniondate <> n.newopiniondate
        or o.newopinion <> n.newopinion
        or o.isredeem <> n.isredeem
        or o.annualauditbusinesssum <> n.annualauditbusinesssum
        or o.annualauditexposuresum <> n.annualauditexposuresum
        or o.isyeartocheck <> n.isyeartocheck
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_finance_batch_record_cl(
            serialno -- 流水号
            ,baserialno -- 关联子授信编号
            ,objectno -- 关联主授信编号
            ,ftserialno -- 流程表流水号
            ,objecttype -- 关联类型
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,businesscurrency -- 币种
            ,occurtype -- 发生方式
            ,exposuresum -- 敞口金额
            ,businesssum -- 额度金额
            ,termmonth -- 期限月
            ,iscycle -- 是否循环
            ,isagree -- 是否同意
            ,issure -- 是否确认
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,issignificantnegativeinformation -- 是否有重大负面信息
            ,iscontrollerchanged -- 是否有重大负面信息
            ,israterisklevellower -- 评级是否下调
            ,revenuescale -- 营收规模
            ,profitability -- 盈利能力
            ,operationcapability -- 运营能力
            ,rigidliabilities -- 刚性负债
            ,netoperatingcashflow -- 经营性净现金流
            ,bdbusinesssum -- 借据额度金额
            ,enttype -- 企业性质
            ,raterisklevel -- 近期主体评级
            ,onlineamount -- 线上额度
            ,isexistsrisk -- 是否存在其他重大风险
            ,isbusinesschange -- 经营情况是否发生重大变化
            ,searchstatus -- 查询外部数据状态
            ,searcherrorreason -- 查询外部数据异常原因
            ,searchdate -- 外部数据日期
            ,othersum -- 其他有效授信
            ,singlecustomersum -- 单一客户管理限额
            ,belonggroupname -- 归属集团（行内集团）
            ,nominalamount -- 集团管理额度
            ,grouprelationshipcheckresult -- 集团关系探测结果
            ,atualcontroller -- 实际控制人
            ,isshareholderchange -- 控股股东是否发生变化
            ,newratingprospect -- 最新一期评级展望
            ,isissuebondschange -- 近一年是否新发行债券
            ,isincomechange -- 收入构成是否发生重大变化
            ,isnegativeinformationcheck -- 是否命中负面信息校验
            ,isdefaultexist -- 是否存在非标违约
            ,iscomticketoverdueexist -- 是否存在商票逾期
            ,negativeinfo -- 负面信息说明
            ,issignificantnegativeinfomation -- 是否有重大负面信息
            ,outgroupname -- 外部集团
            ,negativeshow -- 负面信息
            ,newopiniondate -- 最近一期审计意见时间
            ,newopinion -- 最近一期审计意见
            ,isredeem -- 是否未赎回二级资本债或永续债
            ,annualauditbusinesssum -- 年审核定额度
            ,annualauditexposuresum -- 年审核定敞口金额
            ,isyeartocheck -- 是否年审
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_finance_batch_record_op(
            serialno -- 流水号
            ,baserialno -- 关联子授信编号
            ,objectno -- 关联主授信编号
            ,ftserialno -- 流程表流水号
            ,objecttype -- 关联类型
            ,customerid -- 客户编号
            ,productid -- 产品编号
            ,businesscurrency -- 币种
            ,occurtype -- 发生方式
            ,exposuresum -- 敞口金额
            ,businesssum -- 额度金额
            ,termmonth -- 期限月
            ,iscycle -- 是否循环
            ,isagree -- 是否同意
            ,issure -- 是否确认
            ,remark -- 备注
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,inputdate -- 登记时间
            ,updatedate -- 更新时间
            ,issignificantnegativeinformation -- 是否有重大负面信息
            ,iscontrollerchanged -- 是否有重大负面信息
            ,israterisklevellower -- 评级是否下调
            ,revenuescale -- 营收规模
            ,profitability -- 盈利能力
            ,operationcapability -- 运营能力
            ,rigidliabilities -- 刚性负债
            ,netoperatingcashflow -- 经营性净现金流
            ,bdbusinesssum -- 借据额度金额
            ,enttype -- 企业性质
            ,raterisklevel -- 近期主体评级
            ,onlineamount -- 线上额度
            ,isexistsrisk -- 是否存在其他重大风险
            ,isbusinesschange -- 经营情况是否发生重大变化
            ,searchstatus -- 查询外部数据状态
            ,searcherrorreason -- 查询外部数据异常原因
            ,searchdate -- 外部数据日期
            ,othersum -- 其他有效授信
            ,singlecustomersum -- 单一客户管理限额
            ,belonggroupname -- 归属集团（行内集团）
            ,nominalamount -- 集团管理额度
            ,grouprelationshipcheckresult -- 集团关系探测结果
            ,atualcontroller -- 实际控制人
            ,isshareholderchange -- 控股股东是否发生变化
            ,newratingprospect -- 最新一期评级展望
            ,isissuebondschange -- 近一年是否新发行债券
            ,isincomechange -- 收入构成是否发生重大变化
            ,isnegativeinformationcheck -- 是否命中负面信息校验
            ,isdefaultexist -- 是否存在非标违约
            ,iscomticketoverdueexist -- 是否存在商票逾期
            ,negativeinfo -- 负面信息说明
            ,issignificantnegativeinfomation -- 是否有重大负面信息
            ,outgroupname -- 外部集团
            ,negativeshow -- 负面信息
            ,newopiniondate -- 最近一期审计意见时间
            ,newopinion -- 最近一期审计意见
            ,isredeem -- 是否未赎回二级资本债或永续债
            ,annualauditbusinesssum -- 年审核定额度
            ,annualauditexposuresum -- 年审核定敞口金额
            ,isyeartocheck -- 是否年审
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.baserialno -- 关联子授信编号
    ,o.objectno -- 关联主授信编号
    ,o.ftserialno -- 流程表流水号
    ,o.objecttype -- 关联类型
    ,o.customerid -- 客户编号
    ,o.productid -- 产品编号
    ,o.businesscurrency -- 币种
    ,o.occurtype -- 发生方式
    ,o.exposuresum -- 敞口金额
    ,o.businesssum -- 额度金额
    ,o.termmonth -- 期限月
    ,o.iscycle -- 是否循环
    ,o.isagree -- 是否同意
    ,o.issure -- 是否确认
    ,o.remark -- 备注
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.inputdate -- 登记时间
    ,o.updatedate -- 更新时间
    ,o.issignificantnegativeinformation -- 是否有重大负面信息
    ,o.iscontrollerchanged -- 是否有重大负面信息
    ,o.israterisklevellower -- 评级是否下调
    ,o.revenuescale -- 营收规模
    ,o.profitability -- 盈利能力
    ,o.operationcapability -- 运营能力
    ,o.rigidliabilities -- 刚性负债
    ,o.netoperatingcashflow -- 经营性净现金流
    ,o.bdbusinesssum -- 借据额度金额
    ,o.enttype -- 企业性质
    ,o.raterisklevel -- 近期主体评级
    ,o.onlineamount -- 线上额度
    ,o.isexistsrisk -- 是否存在其他重大风险
    ,o.isbusinesschange -- 经营情况是否发生重大变化
    ,o.searchstatus -- 查询外部数据状态
    ,o.searcherrorreason -- 查询外部数据异常原因
    ,o.searchdate -- 外部数据日期
    ,o.othersum -- 其他有效授信
    ,o.singlecustomersum -- 单一客户管理限额
    ,o.belonggroupname -- 归属集团（行内集团）
    ,o.nominalamount -- 集团管理额度
    ,o.grouprelationshipcheckresult -- 集团关系探测结果
    ,o.atualcontroller -- 实际控制人
    ,o.isshareholderchange -- 控股股东是否发生变化
    ,o.newratingprospect -- 最新一期评级展望
    ,o.isissuebondschange -- 近一年是否新发行债券
    ,o.isincomechange -- 收入构成是否发生重大变化
    ,o.isnegativeinformationcheck -- 是否命中负面信息校验
    ,o.isdefaultexist -- 是否存在非标违约
    ,o.iscomticketoverdueexist -- 是否存在商票逾期
    ,o.negativeinfo -- 负面信息说明
    ,o.issignificantnegativeinfomation -- 是否有重大负面信息
    ,o.outgroupname -- 外部集团
    ,o.negativeshow -- 负面信息
    ,o.newopiniondate -- 最近一期审计意见时间
    ,o.newopinion -- 最近一期审计意见
    ,o.isredeem -- 是否未赎回二级资本债或永续债
    ,o.annualauditbusinesssum -- 年审核定额度
    ,o.annualauditexposuresum -- 年审核定敞口金额
    ,o.isyeartocheck -- 是否年审
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
from ${iol_schema}.icms_finance_batch_record_bk o
    left join ${iol_schema}.icms_finance_batch_record_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_finance_batch_record_cl d
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
--truncate table ${iol_schema}.icms_finance_batch_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_finance_batch_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_finance_batch_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_finance_batch_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_finance_batch_record exchange partition p_${batch_date} with table ${iol_schema}.icms_finance_batch_record_cl;
alter table ${iol_schema}.icms_finance_batch_record exchange partition p_20991231 with table ${iol_schema}.icms_finance_batch_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_finance_batch_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_finance_batch_record_op purge;
drop table ${iol_schema}.icms_finance_batch_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_finance_batch_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_finance_batch_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
