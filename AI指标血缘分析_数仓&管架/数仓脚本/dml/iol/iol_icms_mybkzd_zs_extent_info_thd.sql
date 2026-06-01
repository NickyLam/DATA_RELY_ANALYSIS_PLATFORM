/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_mybkzd_zs_extent_info_thd
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
create table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_mybkzd_zs_extent_info_thd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op purge;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_zs_extent_info_thd where 0=1;

create table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_mybkzd_zs_extent_info_thd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl(
            serialno -- 信贷流水号
            ,riskseg -- 风险等级
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
            ,adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
            ,devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
            ,totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
            ,profession -- 职业信息
            ,bankcardnumber -- 银行卡号
            ,depositbankname -- 开户行名称
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,havecarprobgrade -- 有车概率等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
            ,firstloanlengthgrade -- 信贷时长等级
            ,riskscore -- 风险分数
            ,alilast6mtradetotal -- 支付宝交易笔数
            ,custid -- 客户编码
            ,corecustname -- 核心企业名称
            ,corecustid -- 核心企业统一社会信用代码证
            ,custname -- 经销商名称
            ,custcoopmonth -- 合作月数
            ,custfrcode -- 经销商法定代表人身份证件号
            ,custtotalresamtly -- T-1年采购任务
            ,custamountlist -- 采购金额月份
            ,operationalcapgrade -- 营运能力分层
            ,supplychainmgtgrade -- 供应链管理分层
            ,custsegsmffinal -- 采购贷客户分层
            ,smfrepaymentseg -- 采购贷新偿债能力分层
            ,risksmffinal -- 采购贷风险分层
            ,baserepaymentseg -- 综合基础偿债
            ,altrepaymentseg -- 大额经营偿债
            ,liquidasset6mgrade -- 近6个月流动资产价值等级
            ,haveaptprobgrade -- 有房概况等级
            ,bizstartgrade -- 经营时长
            ,bizstabilitygrade -- 近6个月经营稳定性分层
            ,totpaycnt6mgrade -- 近6个月交易笔数等级
            ,avgdaybal6mgrade -- 近6个月日均余额
            ,gmtfirstbilllenthgrade -- 信贷时长
            ,clrbillcnt1yrgrade -- 近一年履约等级
            ,maxovddays6mgrade -- 近6个月逾期天数等级
            ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
            ,starts -- 开店日期
            ,countyid -- 商户所属地区
            ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
            ,finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
            ,personalcreditreport -- 个人征信信息
            ,businesstag -- 业务标识
            ,businessscene -- 业务场景
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,lssuingauthority -- 发证机关(身份证)
            ,issuedate -- 证件签发日期(身份证)
            ,platformadmitlimit -- 建议授信额度上限
            ,totaladmitlimit -- 人维度总授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op(
            serialno -- 信贷流水号
            ,riskseg -- 风险等级
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
            ,adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
            ,devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
            ,totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
            ,profession -- 职业信息
            ,bankcardnumber -- 银行卡号
            ,depositbankname -- 开户行名称
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,havecarprobgrade -- 有车概率等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
            ,firstloanlengthgrade -- 信贷时长等级
            ,riskscore -- 风险分数
            ,alilast6mtradetotal -- 支付宝交易笔数
            ,custid -- 客户编码
            ,corecustname -- 核心企业名称
            ,corecustid -- 核心企业统一社会信用代码证
            ,custname -- 经销商名称
            ,custcoopmonth -- 合作月数
            ,custfrcode -- 经销商法定代表人身份证件号
            ,custtotalresamtly -- T-1年采购任务
            ,custamountlist -- 采购金额月份
            ,operationalcapgrade -- 营运能力分层
            ,supplychainmgtgrade -- 供应链管理分层
            ,custsegsmffinal -- 采购贷客户分层
            ,smfrepaymentseg -- 采购贷新偿债能力分层
            ,risksmffinal -- 采购贷风险分层
            ,baserepaymentseg -- 综合基础偿债
            ,altrepaymentseg -- 大额经营偿债
            ,liquidasset6mgrade -- 近6个月流动资产价值等级
            ,haveaptprobgrade -- 有房概况等级
            ,bizstartgrade -- 经营时长
            ,bizstabilitygrade -- 近6个月经营稳定性分层
            ,totpaycnt6mgrade -- 近6个月交易笔数等级
            ,avgdaybal6mgrade -- 近6个月日均余额
            ,gmtfirstbilllenthgrade -- 信贷时长
            ,clrbillcnt1yrgrade -- 近一年履约等级
            ,maxovddays6mgrade -- 近6个月逾期天数等级
            ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
            ,starts -- 开店日期
            ,countyid -- 商户所属地区
            ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
            ,finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
            ,personalcreditreport -- 个人征信信息
            ,businesstag -- 业务标识
            ,businessscene -- 业务场景
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,lssuingauthority -- 发证机关(身份证)
            ,issuedate -- 证件签发日期(身份证)
            ,platformadmitlimit -- 建议授信额度上限
            ,totaladmitlimit -- 人维度总授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 信贷流水号
    ,nvl(n.riskseg, o.riskseg) as riskseg -- 风险等级
    ,nvl(n.repaymentseg, o.repaymentseg) as repaymentseg -- 偿债能力
    ,nvl(n.mobilefixedgrade, o.mobilefixedgrade) as mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
    ,nvl(n.adrstabilitygrade, o.adrstabilitygrade) as adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
    ,nvl(n.devstabilitygrade, o.devstabilitygrade) as devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
    ,nvl(n.totpayamt6mgrade, o.totpayamt6mgrade) as totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
    ,nvl(n.profession, o.profession) as profession -- 职业信息
    ,nvl(n.bankcardnumber, o.bankcardnumber) as bankcardnumber -- 银行卡号
    ,nvl(n.depositbankname, o.depositbankname) as depositbankname -- 开户行名称
    ,nvl(n.last6mavgassettotalgrade, o.last6mavgassettotalgrade) as last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,nvl(n.havecarprobgrade, o.havecarprobgrade) as havecarprobgrade -- 有车概率等级
    ,nvl(n.havefangprobgrade, o.havefangprobgrade) as havefangprobgrade -- 有房概率等级
    ,nvl(n.ovdordercnt6mgrade, o.ovdordercnt6mgrade) as ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,nvl(n.ovdorderamt6mgrade, o.ovdorderamt6mgrade) as ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,nvl(n.ovdorderdays6mgrade, o.ovdorderdays6mgrade) as ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,nvl(n.positivebizcnt1ygrade, o.positivebizcnt1ygrade) as positivebizcnt1ygrade -- 最近一年履约等级
    ,nvl(n.repayamt6mgrade, o.repayamt6mgrade) as repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
    ,nvl(n.firstloanlengthgrade, o.firstloanlengthgrade) as firstloanlengthgrade -- 信贷时长等级
    ,nvl(n.riskscore, o.riskscore) as riskscore -- 风险分数
    ,nvl(n.alilast6mtradetotal, o.alilast6mtradetotal) as alilast6mtradetotal -- 支付宝交易笔数
    ,nvl(n.custid, o.custid) as custid -- 客户编码
    ,nvl(n.corecustname, o.corecustname) as corecustname -- 核心企业名称
    ,nvl(n.corecustid, o.corecustid) as corecustid -- 核心企业统一社会信用代码证
    ,nvl(n.custname, o.custname) as custname -- 经销商名称
    ,nvl(n.custcoopmonth, o.custcoopmonth) as custcoopmonth -- 合作月数
    ,nvl(n.custfrcode, o.custfrcode) as custfrcode -- 经销商法定代表人身份证件号
    ,nvl(n.custtotalresamtly, o.custtotalresamtly) as custtotalresamtly -- T-1年采购任务
    ,nvl(n.custamountlist, o.custamountlist) as custamountlist -- 采购金额月份
    ,nvl(n.operationalcapgrade, o.operationalcapgrade) as operationalcapgrade -- 营运能力分层
    ,nvl(n.supplychainmgtgrade, o.supplychainmgtgrade) as supplychainmgtgrade -- 供应链管理分层
    ,nvl(n.custsegsmffinal, o.custsegsmffinal) as custsegsmffinal -- 采购贷客户分层
    ,nvl(n.smfrepaymentseg, o.smfrepaymentseg) as smfrepaymentseg -- 采购贷新偿债能力分层
    ,nvl(n.risksmffinal, o.risksmffinal) as risksmffinal -- 采购贷风险分层
    ,nvl(n.baserepaymentseg, o.baserepaymentseg) as baserepaymentseg -- 综合基础偿债
    ,nvl(n.altrepaymentseg, o.altrepaymentseg) as altrepaymentseg -- 大额经营偿债
    ,nvl(n.liquidasset6mgrade, o.liquidasset6mgrade) as liquidasset6mgrade -- 近6个月流动资产价值等级
    ,nvl(n.haveaptprobgrade, o.haveaptprobgrade) as haveaptprobgrade -- 有房概况等级
    ,nvl(n.bizstartgrade, o.bizstartgrade) as bizstartgrade -- 经营时长
    ,nvl(n.bizstabilitygrade, o.bizstabilitygrade) as bizstabilitygrade -- 近6个月经营稳定性分层
    ,nvl(n.totpaycnt6mgrade, o.totpaycnt6mgrade) as totpaycnt6mgrade -- 近6个月交易笔数等级
    ,nvl(n.avgdaybal6mgrade, o.avgdaybal6mgrade) as avgdaybal6mgrade -- 近6个月日均余额
    ,nvl(n.gmtfirstbilllenthgrade, o.gmtfirstbilllenthgrade) as gmtfirstbilllenthgrade -- 信贷时长
    ,nvl(n.clrbillcnt1yrgrade, o.clrbillcnt1yrgrade) as clrbillcnt1yrgrade -- 近一年履约等级
    ,nvl(n.maxovddays6mgrade, o.maxovddays6mgrade) as maxovddays6mgrade -- 近6个月逾期天数等级
    ,nvl(n.maxovdbillamt6mgrade, o.maxovdbillamt6mgrade) as maxovdbillamt6mgrade -- 近6个月逾期金额等级
    ,nvl(n.starts, o.starts) as starts -- 开店日期
    ,nvl(n.countyid, o.countyid) as countyid -- 商户所属地区
    ,nvl(n.finishedvalidexlovamtrm6, o.finishedvalidexlovamtrm6) as finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
    ,nvl(n.finishedvalidexlovamtr12, o.finishedvalidexlovamtr12) as finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
    ,nvl(n.personalcreditreport, o.personalcreditreport) as personalcreditreport -- 个人征信信息
    ,nvl(n.businesstag, o.businesstag) as businesstag -- 业务标识
    ,nvl(n.businessscene, o.businessscene) as businessscene -- 业务场景
    ,nvl(n.custipid, o.custipid) as custipid -- 借款人在网商的会员ID
    ,nvl(n.custiproleid, o.custiproleid) as custiproleid -- 借款人在网商的会员角色ID
    ,nvl(n.lssuingauthority, o.lssuingauthority) as lssuingauthority -- 发证机关(身份证)
    ,nvl(n.issuedate, o.issuedate) as issuedate -- 证件签发日期(身份证)
    ,nvl(n.platformadmitlimit, o.platformadmitlimit) as platformadmitlimit -- 建议授信额度上限
    ,nvl(n.totaladmitlimit, o.totaladmitlimit) as totaladmitlimit -- 人维度总授信额度
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
from (select * from ${iol_schema}.icms_mybkzd_zs_extent_info_thd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_mybkzd_zs_extent_info_thd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.riskseg <> n.riskseg
        or o.repaymentseg <> n.repaymentseg
        or o.mobilefixedgrade <> n.mobilefixedgrade
        or o.adrstabilitygrade <> n.adrstabilitygrade
        or o.devstabilitygrade <> n.devstabilitygrade
        or o.totpayamt6mgrade <> n.totpayamt6mgrade
        or o.profession <> n.profession
        or o.bankcardnumber <> n.bankcardnumber
        or o.depositbankname <> n.depositbankname
        or o.last6mavgassettotalgrade <> n.last6mavgassettotalgrade
        or o.havecarprobgrade <> n.havecarprobgrade
        or o.havefangprobgrade <> n.havefangprobgrade
        or o.ovdordercnt6mgrade <> n.ovdordercnt6mgrade
        or o.ovdorderamt6mgrade <> n.ovdorderamt6mgrade
        or o.ovdorderdays6mgrade <> n.ovdorderdays6mgrade
        or o.positivebizcnt1ygrade <> n.positivebizcnt1ygrade
        or o.repayamt6mgrade <> n.repayamt6mgrade
        or o.firstloanlengthgrade <> n.firstloanlengthgrade
        or o.riskscore <> n.riskscore
        or o.alilast6mtradetotal <> n.alilast6mtradetotal
        or o.custid <> n.custid
        or o.corecustname <> n.corecustname
        or o.corecustid <> n.corecustid
        or o.custname <> n.custname
        or o.custcoopmonth <> n.custcoopmonth
        or o.custfrcode <> n.custfrcode
        or o.custtotalresamtly <> n.custtotalresamtly
        or o.custamountlist <> n.custamountlist
        or o.operationalcapgrade <> n.operationalcapgrade
        or o.supplychainmgtgrade <> n.supplychainmgtgrade
        or o.custsegsmffinal <> n.custsegsmffinal
        or o.smfrepaymentseg <> n.smfrepaymentseg
        or o.risksmffinal <> n.risksmffinal
        or o.baserepaymentseg <> n.baserepaymentseg
        or o.altrepaymentseg <> n.altrepaymentseg
        or o.liquidasset6mgrade <> n.liquidasset6mgrade
        or o.haveaptprobgrade <> n.haveaptprobgrade
        or o.bizstartgrade <> n.bizstartgrade
        or o.bizstabilitygrade <> n.bizstabilitygrade
        or o.totpaycnt6mgrade <> n.totpaycnt6mgrade
        or o.avgdaybal6mgrade <> n.avgdaybal6mgrade
        or o.gmtfirstbilllenthgrade <> n.gmtfirstbilllenthgrade
        or o.clrbillcnt1yrgrade <> n.clrbillcnt1yrgrade
        or o.maxovddays6mgrade <> n.maxovddays6mgrade
        or o.maxovdbillamt6mgrade <> n.maxovdbillamt6mgrade
        or o.starts <> n.starts
        or o.countyid <> n.countyid
        or o.finishedvalidexlovamtrm6 <> n.finishedvalidexlovamtrm6
        or o.finishedvalidexlovamtr12 <> n.finishedvalidexlovamtr12
        or o.personalcreditreport <> n.personalcreditreport
        or o.businesstag <> n.businesstag
        or o.businessscene <> n.businessscene
        or o.custipid <> n.custipid
        or o.custiproleid <> n.custiproleid
        or o.lssuingauthority <> n.lssuingauthority
        or o.issuedate <> n.issuedate
        or o.platformadmitlimit <> n.platformadmitlimit
        or o.totaladmitlimit <> n.totaladmitlimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl(
            serialno -- 信贷流水号
            ,riskseg -- 风险等级
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
            ,adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
            ,devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
            ,totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
            ,profession -- 职业信息
            ,bankcardnumber -- 银行卡号
            ,depositbankname -- 开户行名称
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,havecarprobgrade -- 有车概率等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
            ,firstloanlengthgrade -- 信贷时长等级
            ,riskscore -- 风险分数
            ,alilast6mtradetotal -- 支付宝交易笔数
            ,custid -- 客户编码
            ,corecustname -- 核心企业名称
            ,corecustid -- 核心企业统一社会信用代码证
            ,custname -- 经销商名称
            ,custcoopmonth -- 合作月数
            ,custfrcode -- 经销商法定代表人身份证件号
            ,custtotalresamtly -- T-1年采购任务
            ,custamountlist -- 采购金额月份
            ,operationalcapgrade -- 营运能力分层
            ,supplychainmgtgrade -- 供应链管理分层
            ,custsegsmffinal -- 采购贷客户分层
            ,smfrepaymentseg -- 采购贷新偿债能力分层
            ,risksmffinal -- 采购贷风险分层
            ,baserepaymentseg -- 综合基础偿债
            ,altrepaymentseg -- 大额经营偿债
            ,liquidasset6mgrade -- 近6个月流动资产价值等级
            ,haveaptprobgrade -- 有房概况等级
            ,bizstartgrade -- 经营时长
            ,bizstabilitygrade -- 近6个月经营稳定性分层
            ,totpaycnt6mgrade -- 近6个月交易笔数等级
            ,avgdaybal6mgrade -- 近6个月日均余额
            ,gmtfirstbilllenthgrade -- 信贷时长
            ,clrbillcnt1yrgrade -- 近一年履约等级
            ,maxovddays6mgrade -- 近6个月逾期天数等级
            ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
            ,starts -- 开店日期
            ,countyid -- 商户所属地区
            ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
            ,finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
            ,personalcreditreport -- 个人征信信息
            ,businesstag -- 业务标识
            ,businessscene -- 业务场景
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,lssuingauthority -- 发证机关(身份证)
            ,issuedate -- 证件签发日期(身份证)
            ,platformadmitlimit -- 建议授信额度上限
            ,totaladmitlimit -- 人维度总授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op(
            serialno -- 信贷流水号
            ,riskseg -- 风险等级
            ,repaymentseg -- 偿债能力
            ,mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
            ,adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
            ,devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
            ,totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
            ,profession -- 职业信息
            ,bankcardnumber -- 银行卡号
            ,depositbankname -- 开户行名称
            ,last6mavgassettotalgrade -- 最近六个月流动资产价值等级
            ,havecarprobgrade -- 有车概率等级
            ,havefangprobgrade -- 有房概率等级
            ,ovdordercnt6mgrade -- 最近六个月逾期笔数等级
            ,ovdorderamt6mgrade -- 最近六个月逾期金额等级
            ,ovdorderdays6mgrade -- 最近六个月逾期天数等级
            ,positivebizcnt1ygrade -- 最近一年履约等级
            ,repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
            ,firstloanlengthgrade -- 信贷时长等级
            ,riskscore -- 风险分数
            ,alilast6mtradetotal -- 支付宝交易笔数
            ,custid -- 客户编码
            ,corecustname -- 核心企业名称
            ,corecustid -- 核心企业统一社会信用代码证
            ,custname -- 经销商名称
            ,custcoopmonth -- 合作月数
            ,custfrcode -- 经销商法定代表人身份证件号
            ,custtotalresamtly -- T-1年采购任务
            ,custamountlist -- 采购金额月份
            ,operationalcapgrade -- 营运能力分层
            ,supplychainmgtgrade -- 供应链管理分层
            ,custsegsmffinal -- 采购贷客户分层
            ,smfrepaymentseg -- 采购贷新偿债能力分层
            ,risksmffinal -- 采购贷风险分层
            ,baserepaymentseg -- 综合基础偿债
            ,altrepaymentseg -- 大额经营偿债
            ,liquidasset6mgrade -- 近6个月流动资产价值等级
            ,haveaptprobgrade -- 有房概况等级
            ,bizstartgrade -- 经营时长
            ,bizstabilitygrade -- 近6个月经营稳定性分层
            ,totpaycnt6mgrade -- 近6个月交易笔数等级
            ,avgdaybal6mgrade -- 近6个月日均余额
            ,gmtfirstbilllenthgrade -- 信贷时长
            ,clrbillcnt1yrgrade -- 近一年履约等级
            ,maxovddays6mgrade -- 近6个月逾期天数等级
            ,maxovdbillamt6mgrade -- 近6个月逾期金额等级
            ,starts -- 开店日期
            ,countyid -- 商户所属地区
            ,finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
            ,finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
            ,personalcreditreport -- 个人征信信息
            ,businesstag -- 业务标识
            ,businessscene -- 业务场景
            ,custipid -- 借款人在网商的会员ID
            ,custiproleid -- 借款人在网商的会员角色ID
            ,lssuingauthority -- 发证机关(身份证)
            ,issuedate -- 证件签发日期(身份证)
            ,platformadmitlimit -- 建议授信额度上限
            ,totaladmitlimit -- 人维度总授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 信贷流水号
    ,o.riskseg -- 风险等级
    ,o.repaymentseg -- 偿债能力
    ,o.mobilefixedgrade -- 经营者手机号稳定性等级(手机号稳定等级)
    ,o.adrstabilitygrade -- 经营者地址稳定性等级(地址稳定等级)
    ,o.devstabilitygrade -- 经营者设备稳定性等级(最近六个月设备稳定等级)
    ,o.totpayamt6mgrade -- 近6个月交易金额等级(最近六个月支付金额等级)
    ,o.profession -- 职业信息
    ,o.bankcardnumber -- 银行卡号
    ,o.depositbankname -- 开户行名称
    ,o.last6mavgassettotalgrade -- 最近六个月流动资产价值等级
    ,o.havecarprobgrade -- 有车概率等级
    ,o.havefangprobgrade -- 有房概率等级
    ,o.ovdordercnt6mgrade -- 最近六个月逾期笔数等级
    ,o.ovdorderamt6mgrade -- 最近六个月逾期金额等级
    ,o.ovdorderdays6mgrade -- 最近六个月逾期天数等级
    ,o.positivebizcnt1ygrade -- 最近一年履约等级
    ,o.repayamt6mgrade -- 近6个月还款金额等级(最近六个月还款金额等级)
    ,o.firstloanlengthgrade -- 信贷时长等级
    ,o.riskscore -- 风险分数
    ,o.alilast6mtradetotal -- 支付宝交易笔数
    ,o.custid -- 客户编码
    ,o.corecustname -- 核心企业名称
    ,o.corecustid -- 核心企业统一社会信用代码证
    ,o.custname -- 经销商名称
    ,o.custcoopmonth -- 合作月数
    ,o.custfrcode -- 经销商法定代表人身份证件号
    ,o.custtotalresamtly -- T-1年采购任务
    ,o.custamountlist -- 采购金额月份
    ,o.operationalcapgrade -- 营运能力分层
    ,o.supplychainmgtgrade -- 供应链管理分层
    ,o.custsegsmffinal -- 采购贷客户分层
    ,o.smfrepaymentseg -- 采购贷新偿债能力分层
    ,o.risksmffinal -- 采购贷风险分层
    ,o.baserepaymentseg -- 综合基础偿债
    ,o.altrepaymentseg -- 大额经营偿债
    ,o.liquidasset6mgrade -- 近6个月流动资产价值等级
    ,o.haveaptprobgrade -- 有房概况等级
    ,o.bizstartgrade -- 经营时长
    ,o.bizstabilitygrade -- 近6个月经营稳定性分层
    ,o.totpaycnt6mgrade -- 近6个月交易笔数等级
    ,o.avgdaybal6mgrade -- 近6个月日均余额
    ,o.gmtfirstbilllenthgrade -- 信贷时长
    ,o.clrbillcnt1yrgrade -- 近一年履约等级
    ,o.maxovddays6mgrade -- 近6个月逾期天数等级
    ,o.maxovdbillamt6mgrade -- 近6个月逾期金额等级
    ,o.starts -- 开店日期
    ,o.countyid -- 商户所属地区
    ,o.finishedvalidexlovamtrm6 -- 过去6个月月均完成交易金额
    ,o.finishedvalidexlovamtr12 -- 过去12个月月均完成交易金额
    ,o.personalcreditreport -- 个人征信信息
    ,o.businesstag -- 业务标识
    ,o.businessscene -- 业务场景
    ,o.custipid -- 借款人在网商的会员ID
    ,o.custiproleid -- 借款人在网商的会员角色ID
    ,o.lssuingauthority -- 发证机关(身份证)
    ,o.issuedate -- 证件签发日期(身份证)
    ,o.platformadmitlimit -- 建议授信额度上限
    ,o.totaladmitlimit -- 人维度总授信额度
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
from ${iol_schema}.icms_mybkzd_zs_extent_info_thd_bk o
    left join ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl d
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
--truncate table ${iol_schema}.icms_mybkzd_zs_extent_info_thd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_mybkzd_zs_extent_info_thd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_mybkzd_zs_extent_info_thd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_mybkzd_zs_extent_info_thd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_mybkzd_zs_extent_info_thd exchange partition p_${batch_date} with table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl;
alter table ${iol_schema}.icms_mybkzd_zs_extent_info_thd exchange partition p_20991231 with table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_mybkzd_zs_extent_info_thd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_op purge;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_mybkzd_zs_extent_info_thd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_mybkzd_zs_extent_info_thd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
