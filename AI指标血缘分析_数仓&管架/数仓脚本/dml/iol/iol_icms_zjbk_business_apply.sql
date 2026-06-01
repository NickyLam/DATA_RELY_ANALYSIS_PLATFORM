/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_apply
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
create table ${iol_schema}.icms_zjbk_business_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_business_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_apply_op purge;
drop table ${iol_schema}.icms_zjbk_business_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_apply where 0=1;

create table ${iol_schema}.icms_zjbk_business_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_apply_cl(
            serialno -- 流水号
            ,lhdreqid -- 联合贷请求ID
            ,zdreqid -- 助贷请求ID
            ,accountid -- 授信ID
            ,credittag -- 授信请求类型
            ,approvestatus -- 授信状态
            ,status -- 授信状态
            ,customerid -- 客户号
            ,name -- 姓名
            ,idnumber -- 身份证
            ,phone -- 手机号
            ,gender -- 性别
            ,nation -- 国籍
            ,productmode -- 产品类别
            ,homephone -- 家庭电话
            ,address -- 居住地址
            ,birthday -- 生日
            ,creditamount -- 授信额度
            ,dailyrate -- 授信日利率
            ,annualrate -- 授信年利率
            ,idcardaddress -- 身份证上的地址信息
            ,idcardstartdate -- 身份证有效期开始时间
            ,idcardenddate -- 身份证有效期结束时间
            ,idcardethnicity -- 民族
            ,idcardauthority -- 签发机关
            ,careerindustry -- 现单位/经营主体所属行业
            ,cardid -- 银行卡号
            ,bankname -- 银行名称
            ,bankphone -- 银行预留手机号
            ,enterprisename -- 企业名称或者法人名称
            ,uniformsocialcreditcode -- 社会信用代码
            ,businesslicense -- 营业执照号
            ,customertype -- 客户属性
            ,companyindustry -- 所属行业类型
            ,ifexeshare -- 是否董监高
            ,xwlabel -- 小微标签
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,businessflag -- 业务类型
            ,loanid -- 借款流水号
            ,appliedamount -- 实际额度
            ,availableamount -- 可用额度
            ,loanamount -- 借款总金额
            ,bankamount -- 联合行金额
            ,period -- 分期数
            ,repaytype -- 计息方式
            ,usage -- 借款用途
            ,currency -- 币种
            ,orderdailyrate -- 日利率
            ,orderannualrate -- 年利率
            ,capitalsetno -- 资金码
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,certtype -- 证件类型
            ,productid -- 产品编号
            ,riskreqtime -- 风控回调时间
            ,creditchannel -- 授信渠道
            ,contractno -- 额度合同号
            ,failcode -- 风控拒绝码
            ,effectdate -- 有效到期日
            ,intraindustrytype -- 投向行业
            ,industrysource -- 所属行业数据来源
            ,totalassets -- 资产总额
            ,operatingrevenue -- 营业收入
            ,colleguesnum -- 从业人数
            ,enterprisescale -- 企业规模
            ,locationinfo -- 客户位置信息
            ,repayday -- 每月还款日
            ,reserveinfo -- 征信预留字段
            ,rdriskstatus -- 融担风控结果
            ,rdfailcode -- 融担风控拒绝码
            ,rdfailreason -- 融担风控拒绝原因
            ,rdriskreqtime -- 融担回调时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_apply_op(
            serialno -- 流水号
            ,lhdreqid -- 联合贷请求ID
            ,zdreqid -- 助贷请求ID
            ,accountid -- 授信ID
            ,credittag -- 授信请求类型
            ,approvestatus -- 授信状态
            ,status -- 授信状态
            ,customerid -- 客户号
            ,name -- 姓名
            ,idnumber -- 身份证
            ,phone -- 手机号
            ,gender -- 性别
            ,nation -- 国籍
            ,productmode -- 产品类别
            ,homephone -- 家庭电话
            ,address -- 居住地址
            ,birthday -- 生日
            ,creditamount -- 授信额度
            ,dailyrate -- 授信日利率
            ,annualrate -- 授信年利率
            ,idcardaddress -- 身份证上的地址信息
            ,idcardstartdate -- 身份证有效期开始时间
            ,idcardenddate -- 身份证有效期结束时间
            ,idcardethnicity -- 民族
            ,idcardauthority -- 签发机关
            ,careerindustry -- 现单位/经营主体所属行业
            ,cardid -- 银行卡号
            ,bankname -- 银行名称
            ,bankphone -- 银行预留手机号
            ,enterprisename -- 企业名称或者法人名称
            ,uniformsocialcreditcode -- 社会信用代码
            ,businesslicense -- 营业执照号
            ,customertype -- 客户属性
            ,companyindustry -- 所属行业类型
            ,ifexeshare -- 是否董监高
            ,xwlabel -- 小微标签
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,businessflag -- 业务类型
            ,loanid -- 借款流水号
            ,appliedamount -- 实际额度
            ,availableamount -- 可用额度
            ,loanamount -- 借款总金额
            ,bankamount -- 联合行金额
            ,period -- 分期数
            ,repaytype -- 计息方式
            ,usage -- 借款用途
            ,currency -- 币种
            ,orderdailyrate -- 日利率
            ,orderannualrate -- 年利率
            ,capitalsetno -- 资金码
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,certtype -- 证件类型
            ,productid -- 产品编号
            ,riskreqtime -- 风控回调时间
            ,creditchannel -- 授信渠道
            ,contractno -- 额度合同号
            ,failcode -- 风控拒绝码
            ,effectdate -- 有效到期日
            ,intraindustrytype -- 投向行业
            ,industrysource -- 所属行业数据来源
            ,totalassets -- 资产总额
            ,operatingrevenue -- 营业收入
            ,colleguesnum -- 从业人数
            ,enterprisescale -- 企业规模
            ,locationinfo -- 客户位置信息
            ,repayday -- 每月还款日
            ,reserveinfo -- 征信预留字段
            ,rdriskstatus -- 融担风控结果
            ,rdfailcode -- 融担风控拒绝码
            ,rdfailreason -- 融担风控拒绝原因
            ,rdriskreqtime -- 融担回调时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.lhdreqid, o.lhdreqid) as lhdreqid -- 联合贷请求ID
    ,nvl(n.zdreqid, o.zdreqid) as zdreqid -- 助贷请求ID
    ,nvl(n.accountid, o.accountid) as accountid -- 授信ID
    ,nvl(n.credittag, o.credittag) as credittag -- 授信请求类型
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 授信状态
    ,nvl(n.status, o.status) as status -- 授信状态
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.idnumber, o.idnumber) as idnumber -- 身份证
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.productmode, o.productmode) as productmode -- 产品类别
    ,nvl(n.homephone, o.homephone) as homephone -- 家庭电话
    ,nvl(n.address, o.address) as address -- 居住地址
    ,nvl(n.birthday, o.birthday) as birthday -- 生日
    ,nvl(n.creditamount, o.creditamount) as creditamount -- 授信额度
    ,nvl(n.dailyrate, o.dailyrate) as dailyrate -- 授信日利率
    ,nvl(n.annualrate, o.annualrate) as annualrate -- 授信年利率
    ,nvl(n.idcardaddress, o.idcardaddress) as idcardaddress -- 身份证上的地址信息
    ,nvl(n.idcardstartdate, o.idcardstartdate) as idcardstartdate -- 身份证有效期开始时间
    ,nvl(n.idcardenddate, o.idcardenddate) as idcardenddate -- 身份证有效期结束时间
    ,nvl(n.idcardethnicity, o.idcardethnicity) as idcardethnicity -- 民族
    ,nvl(n.idcardauthority, o.idcardauthority) as idcardauthority -- 签发机关
    ,nvl(n.careerindustry, o.careerindustry) as careerindustry -- 现单位/经营主体所属行业
    ,nvl(n.cardid, o.cardid) as cardid -- 银行卡号
    ,nvl(n.bankname, o.bankname) as bankname -- 银行名称
    ,nvl(n.bankphone, o.bankphone) as bankphone -- 银行预留手机号
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称或者法人名称
    ,nvl(n.uniformsocialcreditcode, o.uniformsocialcreditcode) as uniformsocialcreditcode -- 社会信用代码
    ,nvl(n.businesslicense, o.businesslicense) as businesslicense -- 营业执照号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户属性
    ,nvl(n.companyindustry, o.companyindustry) as companyindustry -- 所属行业类型
    ,nvl(n.ifexeshare, o.ifexeshare) as ifexeshare -- 是否董监高
    ,nvl(n.xwlabel, o.xwlabel) as xwlabel -- 小微标签
    ,nvl(n.riskstatus, o.riskstatus) as riskstatus -- 风控结果
    ,nvl(n.failreason, o.failreason) as failreason -- 风控拒绝原因
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 业务类型
    ,nvl(n.loanid, o.loanid) as loanid -- 借款流水号
    ,nvl(n.appliedamount, o.appliedamount) as appliedamount -- 实际额度
    ,nvl(n.availableamount, o.availableamount) as availableamount -- 可用额度
    ,nvl(n.loanamount, o.loanamount) as loanamount -- 借款总金额
    ,nvl(n.bankamount, o.bankamount) as bankamount -- 联合行金额
    ,nvl(n.period, o.period) as period -- 分期数
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 计息方式
    ,nvl(n.usage, o.usage) as usage -- 借款用途
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.orderdailyrate, o.orderdailyrate) as orderdailyrate -- 日利率
    ,nvl(n.orderannualrate, o.orderannualrate) as orderannualrate -- 年利率
    ,nvl(n.capitalsetno, o.capitalsetno) as capitalsetno -- 资金码
    ,nvl(n.riskcreditamount, o.riskcreditamount) as riskcreditamount -- 风控授信额度
    ,nvl(n.riskintrate, o.riskintrate) as riskintrate -- 风控利息年利率
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.riskreqtime, o.riskreqtime) as riskreqtime -- 风控回调时间
    ,nvl(n.creditchannel, o.creditchannel) as creditchannel -- 授信渠道
    ,nvl(n.contractno, o.contractno) as contractno -- 额度合同号
    ,nvl(n.failcode, o.failcode) as failcode -- 风控拒绝码
    ,nvl(n.effectdate, o.effectdate) as effectdate -- 有效到期日
    ,nvl(n.intraindustrytype, o.intraindustrytype) as intraindustrytype -- 投向行业
    ,nvl(n.industrysource, o.industrysource) as industrysource -- 所属行业数据来源
    ,nvl(n.totalassets, o.totalassets) as totalassets -- 资产总额
    ,nvl(n.operatingrevenue, o.operatingrevenue) as operatingrevenue -- 营业收入
    ,nvl(n.colleguesnum, o.colleguesnum) as colleguesnum -- 从业人数
    ,nvl(n.enterprisescale, o.enterprisescale) as enterprisescale -- 企业规模
    ,nvl(n.locationinfo, o.locationinfo) as locationinfo -- 客户位置信息
    ,nvl(n.repayday, o.repayday) as repayday -- 每月还款日
    ,nvl(n.reserveinfo, o.reserveinfo) as reserveinfo -- 征信预留字段
    ,nvl(n.rdriskstatus, o.rdriskstatus) as rdriskstatus -- 融担风控结果
    ,nvl(n.rdfailcode, o.rdfailcode) as rdfailcode -- 融担风控拒绝码
    ,nvl(n.rdfailreason, o.rdfailreason) as rdfailreason -- 融担风控拒绝原因
    ,nvl(n.rdriskreqtime, o.rdriskreqtime) as rdriskreqtime -- 融担回调时间
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
from (select * from ${iol_schema}.icms_zjbk_business_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_business_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.lhdreqid <> n.lhdreqid
        or o.zdreqid <> n.zdreqid
        or o.accountid <> n.accountid
        or o.credittag <> n.credittag
        or o.approvestatus <> n.approvestatus
        or o.status <> n.status
        or o.customerid <> n.customerid
        or o.name <> n.name
        or o.idnumber <> n.idnumber
        or o.phone <> n.phone
        or o.gender <> n.gender
        or o.nation <> n.nation
        or o.productmode <> n.productmode
        or o.homephone <> n.homephone
        or o.address <> n.address
        or o.birthday <> n.birthday
        or o.creditamount <> n.creditamount
        or o.dailyrate <> n.dailyrate
        or o.annualrate <> n.annualrate
        or o.idcardaddress <> n.idcardaddress
        or o.idcardstartdate <> n.idcardstartdate
        or o.idcardenddate <> n.idcardenddate
        or o.idcardethnicity <> n.idcardethnicity
        or o.idcardauthority <> n.idcardauthority
        or o.careerindustry <> n.careerindustry
        or o.cardid <> n.cardid
        or o.bankname <> n.bankname
        or o.bankphone <> n.bankphone
        or o.enterprisename <> n.enterprisename
        or o.uniformsocialcreditcode <> n.uniformsocialcreditcode
        or o.businesslicense <> n.businesslicense
        or o.customertype <> n.customertype
        or o.companyindustry <> n.companyindustry
        or o.ifexeshare <> n.ifexeshare
        or o.xwlabel <> n.xwlabel
        or o.riskstatus <> n.riskstatus
        or o.failreason <> n.failreason
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.businessflag <> n.businessflag
        or o.loanid <> n.loanid
        or o.appliedamount <> n.appliedamount
        or o.availableamount <> n.availableamount
        or o.loanamount <> n.loanamount
        or o.bankamount <> n.bankamount
        or o.period <> n.period
        or o.repaytype <> n.repaytype
        or o.usage <> n.usage
        or o.currency <> n.currency
        or o.orderdailyrate <> n.orderdailyrate
        or o.orderannualrate <> n.orderannualrate
        or o.capitalsetno <> n.capitalsetno
        or o.riskcreditamount <> n.riskcreditamount
        or o.riskintrate <> n.riskintrate
        or o.certtype <> n.certtype
        or o.productid <> n.productid
        or o.riskreqtime <> n.riskreqtime
        or o.creditchannel <> n.creditchannel
        or o.contractno <> n.contractno
        or o.failcode <> n.failcode
        or o.effectdate <> n.effectdate
        or o.intraindustrytype <> n.intraindustrytype
        or o.industrysource <> n.industrysource
        or o.totalassets <> n.totalassets
        or o.operatingrevenue <> n.operatingrevenue
        or o.colleguesnum <> n.colleguesnum
        or o.enterprisescale <> n.enterprisescale
        or o.locationinfo <> n.locationinfo
        or o.repayday <> n.repayday
        or o.reserveinfo <> n.reserveinfo
        or o.rdriskstatus <> n.rdriskstatus
        or o.rdfailcode <> n.rdfailcode
        or o.rdfailreason <> n.rdfailreason
        or o.rdriskreqtime <> n.rdriskreqtime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_apply_cl(
            serialno -- 流水号
            ,lhdreqid -- 联合贷请求ID
            ,zdreqid -- 助贷请求ID
            ,accountid -- 授信ID
            ,credittag -- 授信请求类型
            ,approvestatus -- 授信状态
            ,status -- 授信状态
            ,customerid -- 客户号
            ,name -- 姓名
            ,idnumber -- 身份证
            ,phone -- 手机号
            ,gender -- 性别
            ,nation -- 国籍
            ,productmode -- 产品类别
            ,homephone -- 家庭电话
            ,address -- 居住地址
            ,birthday -- 生日
            ,creditamount -- 授信额度
            ,dailyrate -- 授信日利率
            ,annualrate -- 授信年利率
            ,idcardaddress -- 身份证上的地址信息
            ,idcardstartdate -- 身份证有效期开始时间
            ,idcardenddate -- 身份证有效期结束时间
            ,idcardethnicity -- 民族
            ,idcardauthority -- 签发机关
            ,careerindustry -- 现单位/经营主体所属行业
            ,cardid -- 银行卡号
            ,bankname -- 银行名称
            ,bankphone -- 银行预留手机号
            ,enterprisename -- 企业名称或者法人名称
            ,uniformsocialcreditcode -- 社会信用代码
            ,businesslicense -- 营业执照号
            ,customertype -- 客户属性
            ,companyindustry -- 所属行业类型
            ,ifexeshare -- 是否董监高
            ,xwlabel -- 小微标签
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,businessflag -- 业务类型
            ,loanid -- 借款流水号
            ,appliedamount -- 实际额度
            ,availableamount -- 可用额度
            ,loanamount -- 借款总金额
            ,bankamount -- 联合行金额
            ,period -- 分期数
            ,repaytype -- 计息方式
            ,usage -- 借款用途
            ,currency -- 币种
            ,orderdailyrate -- 日利率
            ,orderannualrate -- 年利率
            ,capitalsetno -- 资金码
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,certtype -- 证件类型
            ,productid -- 产品编号
            ,riskreqtime -- 风控回调时间
            ,creditchannel -- 授信渠道
            ,contractno -- 额度合同号
            ,failcode -- 风控拒绝码
            ,effectdate -- 有效到期日
            ,intraindustrytype -- 投向行业
            ,industrysource -- 所属行业数据来源
            ,totalassets -- 资产总额
            ,operatingrevenue -- 营业收入
            ,colleguesnum -- 从业人数
            ,enterprisescale -- 企业规模
            ,locationinfo -- 客户位置信息
            ,repayday -- 每月还款日
            ,reserveinfo -- 征信预留字段
            ,rdriskstatus -- 融担风控结果
            ,rdfailcode -- 融担风控拒绝码
            ,rdfailreason -- 融担风控拒绝原因
            ,rdriskreqtime -- 融担回调时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_apply_op(
            serialno -- 流水号
            ,lhdreqid -- 联合贷请求ID
            ,zdreqid -- 助贷请求ID
            ,accountid -- 授信ID
            ,credittag -- 授信请求类型
            ,approvestatus -- 授信状态
            ,status -- 授信状态
            ,customerid -- 客户号
            ,name -- 姓名
            ,idnumber -- 身份证
            ,phone -- 手机号
            ,gender -- 性别
            ,nation -- 国籍
            ,productmode -- 产品类别
            ,homephone -- 家庭电话
            ,address -- 居住地址
            ,birthday -- 生日
            ,creditamount -- 授信额度
            ,dailyrate -- 授信日利率
            ,annualrate -- 授信年利率
            ,idcardaddress -- 身份证上的地址信息
            ,idcardstartdate -- 身份证有效期开始时间
            ,idcardenddate -- 身份证有效期结束时间
            ,idcardethnicity -- 民族
            ,idcardauthority -- 签发机关
            ,careerindustry -- 现单位/经营主体所属行业
            ,cardid -- 银行卡号
            ,bankname -- 银行名称
            ,bankphone -- 银行预留手机号
            ,enterprisename -- 企业名称或者法人名称
            ,uniformsocialcreditcode -- 社会信用代码
            ,businesslicense -- 营业执照号
            ,customertype -- 客户属性
            ,companyindustry -- 所属行业类型
            ,ifexeshare -- 是否董监高
            ,xwlabel -- 小微标签
            ,riskstatus -- 风控结果
            ,failreason -- 风控拒绝原因
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,businessflag -- 业务类型
            ,loanid -- 借款流水号
            ,appliedamount -- 实际额度
            ,availableamount -- 可用额度
            ,loanamount -- 借款总金额
            ,bankamount -- 联合行金额
            ,period -- 分期数
            ,repaytype -- 计息方式
            ,usage -- 借款用途
            ,currency -- 币种
            ,orderdailyrate -- 日利率
            ,orderannualrate -- 年利率
            ,capitalsetno -- 资金码
            ,riskcreditamount -- 风控授信额度
            ,riskintrate -- 风控利息年利率
            ,certtype -- 证件类型
            ,productid -- 产品编号
            ,riskreqtime -- 风控回调时间
            ,creditchannel -- 授信渠道
            ,contractno -- 额度合同号
            ,failcode -- 风控拒绝码
            ,effectdate -- 有效到期日
            ,intraindustrytype -- 投向行业
            ,industrysource -- 所属行业数据来源
            ,totalassets -- 资产总额
            ,operatingrevenue -- 营业收入
            ,colleguesnum -- 从业人数
            ,enterprisescale -- 企业规模
            ,locationinfo -- 客户位置信息
            ,repayday -- 每月还款日
            ,reserveinfo -- 征信预留字段
            ,rdriskstatus -- 融担风控结果
            ,rdfailcode -- 融担风控拒绝码
            ,rdfailreason -- 融担风控拒绝原因
            ,rdriskreqtime -- 融担回调时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.lhdreqid -- 联合贷请求ID
    ,o.zdreqid -- 助贷请求ID
    ,o.accountid -- 授信ID
    ,o.credittag -- 授信请求类型
    ,o.approvestatus -- 授信状态
    ,o.status -- 授信状态
    ,o.customerid -- 客户号
    ,o.name -- 姓名
    ,o.idnumber -- 身份证
    ,o.phone -- 手机号
    ,o.gender -- 性别
    ,o.nation -- 国籍
    ,o.productmode -- 产品类别
    ,o.homephone -- 家庭电话
    ,o.address -- 居住地址
    ,o.birthday -- 生日
    ,o.creditamount -- 授信额度
    ,o.dailyrate -- 授信日利率
    ,o.annualrate -- 授信年利率
    ,o.idcardaddress -- 身份证上的地址信息
    ,o.idcardstartdate -- 身份证有效期开始时间
    ,o.idcardenddate -- 身份证有效期结束时间
    ,o.idcardethnicity -- 民族
    ,o.idcardauthority -- 签发机关
    ,o.careerindustry -- 现单位/经营主体所属行业
    ,o.cardid -- 银行卡号
    ,o.bankname -- 银行名称
    ,o.bankphone -- 银行预留手机号
    ,o.enterprisename -- 企业名称或者法人名称
    ,o.uniformsocialcreditcode -- 社会信用代码
    ,o.businesslicense -- 营业执照号
    ,o.customertype -- 客户属性
    ,o.companyindustry -- 所属行业类型
    ,o.ifexeshare -- 是否董监高
    ,o.xwlabel -- 小微标签
    ,o.riskstatus -- 风控结果
    ,o.failreason -- 风控拒绝原因
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.businessflag -- 业务类型
    ,o.loanid -- 借款流水号
    ,o.appliedamount -- 实际额度
    ,o.availableamount -- 可用额度
    ,o.loanamount -- 借款总金额
    ,o.bankamount -- 联合行金额
    ,o.period -- 分期数
    ,o.repaytype -- 计息方式
    ,o.usage -- 借款用途
    ,o.currency -- 币种
    ,o.orderdailyrate -- 日利率
    ,o.orderannualrate -- 年利率
    ,o.capitalsetno -- 资金码
    ,o.riskcreditamount -- 风控授信额度
    ,o.riskintrate -- 风控利息年利率
    ,o.certtype -- 证件类型
    ,o.productid -- 产品编号
    ,o.riskreqtime -- 风控回调时间
    ,o.creditchannel -- 授信渠道
    ,o.contractno -- 额度合同号
    ,o.failcode -- 风控拒绝码
    ,o.effectdate -- 有效到期日
    ,o.intraindustrytype -- 投向行业
    ,o.industrysource -- 所属行业数据来源
    ,o.totalassets -- 资产总额
    ,o.operatingrevenue -- 营业收入
    ,o.colleguesnum -- 从业人数
    ,o.enterprisescale -- 企业规模
    ,o.locationinfo -- 客户位置信息
    ,o.repayday -- 每月还款日
    ,o.reserveinfo -- 征信预留字段
    ,o.rdriskstatus -- 融担风控结果
    ,o.rdfailcode -- 融担风控拒绝码
    ,o.rdfailreason -- 融担风控拒绝原因
    ,o.rdriskreqtime -- 融担回调时间
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
from ${iol_schema}.icms_zjbk_business_apply_bk o
    left join ${iol_schema}.icms_zjbk_business_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_business_apply_cl d
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
--truncate table ${iol_schema}.icms_zjbk_business_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_business_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_business_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_business_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_business_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_business_apply_cl;
alter table ${iol_schema}.icms_zjbk_business_apply exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_business_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_business_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_apply_op purge;
drop table ${iol_schema}.icms_zjbk_business_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_business_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_business_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
