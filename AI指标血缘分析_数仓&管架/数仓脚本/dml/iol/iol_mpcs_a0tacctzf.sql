/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0tacctzf
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
create table ${iol_schema}.mpcs_a0tacctzf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0tacctzf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0tacctzf_op purge;
drop table ${iol_schema}.mpcs_a0tacctzf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0tacctzf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0tacctzf where 0=1;

create table ${iol_schema}.mpcs_a0tacctzf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0tacctzf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0tacctzf_cl(
            txcode -- 交易类型编码
            ,transserialnumber -- 传输报文流水号
            ,transdt -- 查询日期
            ,transtm -- 查询时间
            ,status -- 处理状态
            ,applicationid -- 业务申请编号
            ,applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
            ,originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
            ,casenumber -- 案件编号
            ,casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
            ,emergencylevel -- 紧急程度（01-正常；02-加急）
            ,transferoutbankid -- 转出账户所属银行机构编码
            ,transferoutbankname -- 转出账户银行名称
            ,transferoutaccountname -- 转出账户名
            ,transferoutaccountnumber -- 转出帐卡号
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,transferamount -- 转出金额(单位到元)
            ,transfertime -- 转出时间(yyyyMMddHHmmss)
            ,bankid -- 止付账户所属银行机构编码
            ,bankname -- 止付账户所属银行名称
            ,accounttype -- 止付账号类别（01-个人；02-对公）
            ,accountname -- 止付账户名
            ,accountnumber -- 止付帐卡号
            ,reason -- 止付事由
            ,remark -- 止付说明
            ,starttime -- 止付起始时间(yyyymmddhhmmss)
            ,expiretime -- 止付截止时间(yyyymmddhhmmss)
            ,applicationtime -- 申请时间(yyyyMMddHHmmss)
            ,applicationorgid -- 申请机构编码
            ,applicationorgname -- 申请机构名称
            ,operatoridtype -- 经办人证件类型
            ,operatoridnumber -- 经办人证件号
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,investigatoridtype -- 协查人证件类型
            ,investigatorname -- 协查人姓名
            ,withdrawalremark -- 止付解除说明
            ,postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
            ,extendremark -- 止付延期说明
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 核心返回信息
            ,dataid -- 止付唯一标识
            ,messagefrom -- 发送机构编号
            ,acctbal -- 账户余额
            ,zfstartdate -- 实际止付开始日期
            ,zfenddate -- 实际止付到期日
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,openbr -- 开立机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0tacctzf_op(
            txcode -- 交易类型编码
            ,transserialnumber -- 传输报文流水号
            ,transdt -- 查询日期
            ,transtm -- 查询时间
            ,status -- 处理状态
            ,applicationid -- 业务申请编号
            ,applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
            ,originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
            ,casenumber -- 案件编号
            ,casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
            ,emergencylevel -- 紧急程度（01-正常；02-加急）
            ,transferoutbankid -- 转出账户所属银行机构编码
            ,transferoutbankname -- 转出账户银行名称
            ,transferoutaccountname -- 转出账户名
            ,transferoutaccountnumber -- 转出帐卡号
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,transferamount -- 转出金额(单位到元)
            ,transfertime -- 转出时间(yyyyMMddHHmmss)
            ,bankid -- 止付账户所属银行机构编码
            ,bankname -- 止付账户所属银行名称
            ,accounttype -- 止付账号类别（01-个人；02-对公）
            ,accountname -- 止付账户名
            ,accountnumber -- 止付帐卡号
            ,reason -- 止付事由
            ,remark -- 止付说明
            ,starttime -- 止付起始时间(yyyymmddhhmmss)
            ,expiretime -- 止付截止时间(yyyymmddhhmmss)
            ,applicationtime -- 申请时间(yyyyMMddHHmmss)
            ,applicationorgid -- 申请机构编码
            ,applicationorgname -- 申请机构名称
            ,operatoridtype -- 经办人证件类型
            ,operatoridnumber -- 经办人证件号
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,investigatoridtype -- 协查人证件类型
            ,investigatorname -- 协查人姓名
            ,withdrawalremark -- 止付解除说明
            ,postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
            ,extendremark -- 止付延期说明
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 核心返回信息
            ,dataid -- 止付唯一标识
            ,messagefrom -- 发送机构编号
            ,acctbal -- 账户余额
            ,zfstartdate -- 实际止付开始日期
            ,zfenddate -- 实际止付到期日
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,openbr -- 开立机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.txcode, o.txcode) as txcode -- 交易类型编码
    ,nvl(n.transserialnumber, o.transserialnumber) as transserialnumber -- 传输报文流水号
    ,nvl(n.transdt, o.transdt) as transdt -- 查询日期
    ,nvl(n.transtm, o.transtm) as transtm -- 查询时间
    ,nvl(n.status, o.status) as status -- 处理状态
    ,nvl(n.applicationid, o.applicationid) as applicationid -- 业务申请编号
    ,nvl(n.applicationtype, o.applicationtype) as applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
    ,nvl(n.originalapplicationid, o.originalapplicationid) as originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
    ,nvl(n.casenumber, o.casenumber) as casenumber -- 案件编号
    ,nvl(n.casetype, o.casetype) as casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
    ,nvl(n.emergencylevel, o.emergencylevel) as emergencylevel -- 紧急程度（01-正常；02-加急）
    ,nvl(n.transferoutbankid, o.transferoutbankid) as transferoutbankid -- 转出账户所属银行机构编码
    ,nvl(n.transferoutbankname, o.transferoutbankname) as transferoutbankname -- 转出账户银行名称
    ,nvl(n.transferoutaccountname, o.transferoutaccountname) as transferoutaccountname -- 转出账户名
    ,nvl(n.transferoutaccountnumber, o.transferoutaccountnumber) as transferoutaccountnumber -- 转出帐卡号
    ,nvl(n.currency, o.currency) as currency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,nvl(n.transferamount, o.transferamount) as transferamount -- 转出金额(单位到元)
    ,nvl(n.transfertime, o.transfertime) as transfertime -- 转出时间(yyyyMMddHHmmss)
    ,nvl(n.bankid, o.bankid) as bankid -- 止付账户所属银行机构编码
    ,nvl(n.bankname, o.bankname) as bankname -- 止付账户所属银行名称
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 止付账号类别（01-个人；02-对公）
    ,nvl(n.accountname, o.accountname) as accountname -- 止付账户名
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 止付帐卡号
    ,nvl(n.reason, o.reason) as reason -- 止付事由
    ,nvl(n.remark, o.remark) as remark -- 止付说明
    ,nvl(n.starttime, o.starttime) as starttime -- 止付起始时间(yyyymmddhhmmss)
    ,nvl(n.expiretime, o.expiretime) as expiretime -- 止付截止时间(yyyymmddhhmmss)
    ,nvl(n.applicationtime, o.applicationtime) as applicationtime -- 申请时间(yyyyMMddHHmmss)
    ,nvl(n.applicationorgid, o.applicationorgid) as applicationorgid -- 申请机构编码
    ,nvl(n.applicationorgname, o.applicationorgname) as applicationorgname -- 申请机构名称
    ,nvl(n.operatoridtype, o.operatoridtype) as operatoridtype -- 经办人证件类型
    ,nvl(n.operatoridnumber, o.operatoridnumber) as operatoridnumber -- 经办人证件号
    ,nvl(n.operatorname, o.operatorname) as operatorname -- 经办人姓名
    ,nvl(n.operatorphonenumber, o.operatorphonenumber) as operatorphonenumber -- 经办人电话
    ,nvl(n.investigatoridtype, o.investigatoridtype) as investigatoridtype -- 协查人证件类型
    ,nvl(n.investigatorname, o.investigatorname) as investigatorname -- 协查人姓名
    ,nvl(n.withdrawalremark, o.withdrawalremark) as withdrawalremark -- 止付解除说明
    ,nvl(n.postponestarttime, o.postponestarttime) as postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
    ,nvl(n.extendremark, o.extendremark) as extendremark -- 止付延期说明
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 核心日期
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 核心流水
    ,nvl(n.hostcode, o.hostcode) as hostcode -- 核心返回码
    ,nvl(n.erortx, o.erortx) as erortx -- 核心返回信息
    ,nvl(n.dataid, o.dataid) as dataid -- 止付唯一标识
    ,nvl(n.messagefrom, o.messagefrom) as messagefrom -- 发送机构编号
    ,nvl(n.acctbal, o.acctbal) as acctbal -- 账户余额
    ,nvl(n.zfstartdate, o.zfstartdate) as zfstartdate -- 实际止付开始日期
    ,nvl(n.zfenddate, o.zfenddate) as zfenddate -- 实际止付到期日
    ,nvl(n.upptransid, o.upptransid) as upptransid -- UPP流水
    ,nvl(n.subsac, o.subsac) as subsac -- 子账号
    ,nvl(n.accttype, o.accttype) as accttype -- 账户类级
    ,nvl(n.openbr, o.openbr) as openbr -- 开立机构
    ,case when
            n.transserialnumber is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.transserialnumber is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.transserialnumber is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0tacctzf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0tacctzf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.transserialnumber = n.transserialnumber
where (
        o.transserialnumber is null
    )
    or (
        n.transserialnumber is null
    )
    or (
        o.txcode <> n.txcode
        or o.transdt <> n.transdt
        or o.transtm <> n.transtm
        or o.status <> n.status
        or o.applicationid <> n.applicationid
        or o.applicationtype <> n.applicationtype
        or o.originalapplicationid <> n.originalapplicationid
        or o.casenumber <> n.casenumber
        or o.casetype <> n.casetype
        or o.emergencylevel <> n.emergencylevel
        or o.transferoutbankid <> n.transferoutbankid
        or o.transferoutbankname <> n.transferoutbankname
        or o.transferoutaccountname <> n.transferoutaccountname
        or o.transferoutaccountnumber <> n.transferoutaccountnumber
        or o.currency <> n.currency
        or o.transferamount <> n.transferamount
        or o.transfertime <> n.transfertime
        or o.bankid <> n.bankid
        or o.bankname <> n.bankname
        or o.accounttype <> n.accounttype
        or o.accountname <> n.accountname
        or o.accountnumber <> n.accountnumber
        or o.reason <> n.reason
        or o.remark <> n.remark
        or o.starttime <> n.starttime
        or o.expiretime <> n.expiretime
        or o.applicationtime <> n.applicationtime
        or o.applicationorgid <> n.applicationorgid
        or o.applicationorgname <> n.applicationorgname
        or o.operatoridtype <> n.operatoridtype
        or o.operatoridnumber <> n.operatoridnumber
        or o.operatorname <> n.operatorname
        or o.operatorphonenumber <> n.operatorphonenumber
        or o.investigatoridtype <> n.investigatoridtype
        or o.investigatorname <> n.investigatorname
        or o.withdrawalremark <> n.withdrawalremark
        or o.postponestarttime <> n.postponestarttime
        or o.extendremark <> n.extendremark
        or o.hostdate <> n.hostdate
        or o.hostnbr <> n.hostnbr
        or o.hostcode <> n.hostcode
        or o.erortx <> n.erortx
        or o.dataid <> n.dataid
        or o.messagefrom <> n.messagefrom
        or o.acctbal <> n.acctbal
        or o.zfstartdate <> n.zfstartdate
        or o.zfenddate <> n.zfenddate
        or o.upptransid <> n.upptransid
        or o.subsac <> n.subsac
        or o.accttype <> n.accttype
        or o.openbr <> n.openbr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0tacctzf_cl(
            txcode -- 交易类型编码
            ,transserialnumber -- 传输报文流水号
            ,transdt -- 查询日期
            ,transtm -- 查询时间
            ,status -- 处理状态
            ,applicationid -- 业务申请编号
            ,applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
            ,originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
            ,casenumber -- 案件编号
            ,casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
            ,emergencylevel -- 紧急程度（01-正常；02-加急）
            ,transferoutbankid -- 转出账户所属银行机构编码
            ,transferoutbankname -- 转出账户银行名称
            ,transferoutaccountname -- 转出账户名
            ,transferoutaccountnumber -- 转出帐卡号
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,transferamount -- 转出金额(单位到元)
            ,transfertime -- 转出时间(yyyyMMddHHmmss)
            ,bankid -- 止付账户所属银行机构编码
            ,bankname -- 止付账户所属银行名称
            ,accounttype -- 止付账号类别（01-个人；02-对公）
            ,accountname -- 止付账户名
            ,accountnumber -- 止付帐卡号
            ,reason -- 止付事由
            ,remark -- 止付说明
            ,starttime -- 止付起始时间(yyyymmddhhmmss)
            ,expiretime -- 止付截止时间(yyyymmddhhmmss)
            ,applicationtime -- 申请时间(yyyyMMddHHmmss)
            ,applicationorgid -- 申请机构编码
            ,applicationorgname -- 申请机构名称
            ,operatoridtype -- 经办人证件类型
            ,operatoridnumber -- 经办人证件号
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,investigatoridtype -- 协查人证件类型
            ,investigatorname -- 协查人姓名
            ,withdrawalremark -- 止付解除说明
            ,postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
            ,extendremark -- 止付延期说明
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 核心返回信息
            ,dataid -- 止付唯一标识
            ,messagefrom -- 发送机构编号
            ,acctbal -- 账户余额
            ,zfstartdate -- 实际止付开始日期
            ,zfenddate -- 实际止付到期日
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,openbr -- 开立机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0tacctzf_op(
            txcode -- 交易类型编码
            ,transserialnumber -- 传输报文流水号
            ,transdt -- 查询日期
            ,transtm -- 查询时间
            ,status -- 处理状态
            ,applicationid -- 业务申请编号
            ,applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
            ,originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
            ,casenumber -- 案件编号
            ,casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
            ,emergencylevel -- 紧急程度（01-正常；02-加急）
            ,transferoutbankid -- 转出账户所属银行机构编码
            ,transferoutbankname -- 转出账户银行名称
            ,transferoutaccountname -- 转出账户名
            ,transferoutaccountnumber -- 转出帐卡号
            ,currency -- 币种(CNY人民币、USD美元、EUR欧元…)
            ,transferamount -- 转出金额(单位到元)
            ,transfertime -- 转出时间(yyyyMMddHHmmss)
            ,bankid -- 止付账户所属银行机构编码
            ,bankname -- 止付账户所属银行名称
            ,accounttype -- 止付账号类别（01-个人；02-对公）
            ,accountname -- 止付账户名
            ,accountnumber -- 止付帐卡号
            ,reason -- 止付事由
            ,remark -- 止付说明
            ,starttime -- 止付起始时间(yyyymmddhhmmss)
            ,expiretime -- 止付截止时间(yyyymmddhhmmss)
            ,applicationtime -- 申请时间(yyyyMMddHHmmss)
            ,applicationorgid -- 申请机构编码
            ,applicationorgname -- 申请机构名称
            ,operatoridtype -- 经办人证件类型
            ,operatoridnumber -- 经办人证件号
            ,operatorname -- 经办人姓名
            ,operatorphonenumber -- 经办人电话
            ,investigatoridtype -- 协查人证件类型
            ,investigatorname -- 协查人姓名
            ,withdrawalremark -- 止付解除说明
            ,postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
            ,extendremark -- 止付延期说明
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 核心返回信息
            ,dataid -- 止付唯一标识
            ,messagefrom -- 发送机构编号
            ,acctbal -- 账户余额
            ,zfstartdate -- 实际止付开始日期
            ,zfenddate -- 实际止付到期日
            ,upptransid -- UPP流水
            ,subsac -- 子账号
            ,accttype -- 账户类级
            ,openbr -- 开立机构
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.txcode -- 交易类型编码
    ,o.transserialnumber -- 传输报文流水号
    ,o.transdt -- 查询日期
    ,o.transtm -- 查询时间
    ,o.status -- 处理状态
    ,o.applicationid -- 业务申请编号
    ,o.applicationtype -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
    ,o.originalapplicationid -- 原举报申请编号(银行报案时必填，即ApplicationType=02,03,04,05时)
    ,o.casenumber -- 案件编号
    ,o.casetype -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
    ,o.emergencylevel -- 紧急程度（01-正常；02-加急）
    ,o.transferoutbankid -- 转出账户所属银行机构编码
    ,o.transferoutbankname -- 转出账户银行名称
    ,o.transferoutaccountname -- 转出账户名
    ,o.transferoutaccountnumber -- 转出帐卡号
    ,o.currency -- 币种(CNY人民币、USD美元、EUR欧元…)
    ,o.transferamount -- 转出金额(单位到元)
    ,o.transfertime -- 转出时间(yyyyMMddHHmmss)
    ,o.bankid -- 止付账户所属银行机构编码
    ,o.bankname -- 止付账户所属银行名称
    ,o.accounttype -- 止付账号类别（01-个人；02-对公）
    ,o.accountname -- 止付账户名
    ,o.accountnumber -- 止付帐卡号
    ,o.reason -- 止付事由
    ,o.remark -- 止付说明
    ,o.starttime -- 止付起始时间(yyyymmddhhmmss)
    ,o.expiretime -- 止付截止时间(yyyymmddhhmmss)
    ,o.applicationtime -- 申请时间(yyyyMMddHHmmss)
    ,o.applicationorgid -- 申请机构编码
    ,o.applicationorgname -- 申请机构名称
    ,o.operatoridtype -- 经办人证件类型
    ,o.operatoridnumber -- 经办人证件号
    ,o.operatorname -- 经办人姓名
    ,o.operatorphonenumber -- 经办人电话
    ,o.investigatoridtype -- 协查人证件类型
    ,o.investigatorname -- 协查人姓名
    ,o.withdrawalremark -- 止付解除说明
    ,o.postponestarttime -- 止付延期起始时间(yyyymmddhhmmss)
    ,o.extendremark -- 止付延期说明
    ,o.hostdate -- 核心日期
    ,o.hostnbr -- 核心流水
    ,o.hostcode -- 核心返回码
    ,o.erortx -- 核心返回信息
    ,o.dataid -- 止付唯一标识
    ,o.messagefrom -- 发送机构编号
    ,o.acctbal -- 账户余额
    ,o.zfstartdate -- 实际止付开始日期
    ,o.zfenddate -- 实际止付到期日
    ,o.upptransid -- UPP流水
    ,o.subsac -- 子账号
    ,o.accttype -- 账户类级
    ,o.openbr -- 开立机构
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a0tacctzf_bk o
    left join ${iol_schema}.mpcs_a0tacctzf_op n
        on
            o.transserialnumber = n.transserialnumber
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0tacctzf_cl d
        on
            o.transserialnumber = d.transserialnumber
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a0tacctzf;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a0tacctzf exchange partition p_19000101 with table ${iol_schema}.mpcs_a0tacctzf_cl;
alter table ${iol_schema}.mpcs_a0tacctzf exchange partition p_20991231 with table ${iol_schema}.mpcs_a0tacctzf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0tacctzf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0tacctzf_op purge;
drop table ${iol_schema}.mpcs_a0tacctzf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0tacctzf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0tacctzf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
