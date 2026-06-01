/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_payment_info
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
create table ${iol_schema}.icms_payment_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_payment_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_info_op purge;
drop table ${iol_schema}.icms_payment_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_info where 0=1;

create table ${iol_schema}.icms_payment_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_info_cl(
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,paymenttype -- 
            ,payeecertid -- 
            ,bcsacctseqnum -- 
            ,commodityamt -- 
            ,businessname -- 
            ,businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_info_op(
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,paymenttype -- 
            ,payeecertid -- 
            ,bcsacctseqnum -- 
            ,commodityamt -- 
            ,businessname -- 
            ,businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 支付流水号
    ,nvl(n.maxpaydate, o.maxpaydate) as maxpaydate -- 最迟支付日
    ,nvl(n.entrustedno, o.entrustedno) as entrustedno -- 受托支付编号
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.zfjyserialno, o.zfjyserialno) as zfjyserialno -- 在线受托支付-止付交易流水号
    ,nvl(n.putoutserialno, o.putoutserialno) as putoutserialno -- 放贷流水号
    ,nvl(n.paymentdate, o.paymentdate) as paymentdate -- 支付日期
    ,nvl(n.payeename, o.payeename) as payeename -- 收款人名称
    ,nvl(n.docid, o.docid) as docid -- 交易代码
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.sequencenum, o.sequencenum) as sequencenum -- 支付序列号
    ,nvl(n.resenddatetime, o.resenddatetime) as resenddatetime -- 重新发送时间
    ,nvl(n.capitalpurpose, o.capitalpurpose) as capitalpurpose -- 资金用途
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.transeqno, o.transeqno) as transeqno -- 平台请求流水号
    ,nvl(n.confirmstatus, o.confirmstatus) as confirmstatus -- 确认状态
    ,nvl(n.isreservepay, o.isreservepay) as isreservepay -- 是否预约受托支付
    ,nvl(n.rowno, o.rowno) as rowno -- 明细流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 受托支付汇总记录编号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.cause, o.cause) as cause -- 支付失败原因
    ,nvl(n.batchno, o.batchno) as batchno -- 受托支付批次号
    ,nvl(n.transformno, o.transformno) as transformno -- 平台交易流水号
    ,nvl(n.freezeseqno, o.freezeseqno) as freezeseqno -- 冻结流水号
    ,nvl(n.isinneraccount, o.isinneraccount) as isinneraccount -- 是否行内账号
    ,nvl(n.actualpaydate, o.actualpaydate) as actualpaydate -- 实际支付日期
    ,nvl(n.zfserialno, o.zfserialno) as zfserialno -- 止付流水号
    ,nvl(n.iskj, o.iskj) as iskj -- 是否跨境
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.payeebank, o.payeebank) as payeebank -- 收款人开户行
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.paystatus, o.paystatus) as paystatus -- 在线受托支付-支付状态码值BillPayStatus
    ,nvl(n.paymenttime, o.paymenttime) as paymenttime -- 支付时间（10/15）
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.zfdate, o.zfdate) as zfdate -- 止付交易日期
    ,nvl(n.plattrxseq, o.plattrxseq) as plattrxseq -- 在线受托支付-原交易平台流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.payeeaccount, o.payeeaccount) as payeeaccount -- 收款账户号
    ,nvl(n.payeebankname, o.payeebankname) as payeebankname -- 转入行名
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.paymentsum, o.paymentsum) as paymentsum -- 支付金额
    ,nvl(n.paymentstatus, o.paymentstatus) as paymentstatus -- 支付状态
    ,nvl(n.trxdate, o.trxdate) as trxdate -- 平台交易日期
    ,nvl(n.entrustedpayid, o.entrustedpayid) as entrustedpayid -- 受托支付序号
    ,nvl(n.isinuse, o.isinuse) as isinuse -- 添加维护标志1正常2不维护
    ,nvl(n.resendstatus, o.resendstatus) as resendstatus -- 重发状态
    ,nvl(n.isbankaccount, o.isbankaccount) as isbankaccount -- 是否是本行客户
    ,nvl(n.payeenameadd, o.payeenameadd) as payeenameadd -- 收款人地址
    ,nvl(n.capitalpurposedesc, o.capitalpurposedesc) as capitalpurposedesc -- 贷款用途描述
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 
    ,nvl(n.payeecertid, o.payeecertid) as payeecertid -- 
    ,nvl(n.bcsacctseqnum, o.bcsacctseqnum) as bcsacctseqnum -- 
    ,nvl(n.commodityamt, o.commodityamt) as commodityamt -- 
    ,nvl(n.businessname, o.businessname) as businessname -- 
    ,nvl(n.businesscertcode, o.businesscertcode) as businesscertcode -- 
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
from (select * from ${iol_schema}.icms_payment_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_payment_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.maxpaydate <> n.maxpaydate
        or o.entrustedno <> n.entrustedno
        or o.pigeonholedate <> n.pigeonholedate
        or o.updateorgid <> n.updateorgid
        or o.corporgid <> n.corporgid
        or o.updatedate <> n.updatedate
        or o.zfjyserialno <> n.zfjyserialno
        or o.putoutserialno <> n.putoutserialno
        or o.paymentdate <> n.paymentdate
        or o.payeename <> n.payeename
        or o.docid <> n.docid
        or o.inputorgid <> n.inputorgid
        or o.sequencenum <> n.sequencenum
        or o.resenddatetime <> n.resenddatetime
        or o.capitalpurpose <> n.capitalpurpose
        or o.inputdate <> n.inputdate
        or o.transeqno <> n.transeqno
        or o.confirmstatus <> n.confirmstatus
        or o.isreservepay <> n.isreservepay
        or o.rowno <> n.rowno
        or o.objectno <> n.objectno
        or o.remark <> n.remark
        or o.cause <> n.cause
        or o.batchno <> n.batchno
        or o.transformno <> n.transformno
        or o.freezeseqno <> n.freezeseqno
        or o.isinneraccount <> n.isinneraccount
        or o.actualpaydate <> n.actualpaydate
        or o.zfserialno <> n.zfserialno
        or o.iskj <> n.iskj
        or o.customerid <> n.customerid
        or o.payeebank <> n.payeebank
        or o.currency <> n.currency
        or o.inputuserid <> n.inputuserid
        or o.paystatus <> n.paystatus
        or o.paymenttime <> n.paymenttime
        or o.updateuserid <> n.updateuserid
        or o.zfdate <> n.zfdate
        or o.plattrxseq <> n.plattrxseq
        or o.migtflag <> n.migtflag
        or o.payeeaccount <> n.payeeaccount
        or o.payeebankname <> n.payeebankname
        or o.customername <> n.customername
        or o.paymentsum <> n.paymentsum
        or o.paymentstatus <> n.paymentstatus
        or o.trxdate <> n.trxdate
        or o.entrustedpayid <> n.entrustedpayid
        or o.isinuse <> n.isinuse
        or o.resendstatus <> n.resendstatus
        or o.isbankaccount <> n.isbankaccount
        or o.payeenameadd <> n.payeenameadd
        or o.capitalpurposedesc <> n.capitalpurposedesc
        or o.paymenttype <> n.paymenttype
        or o.payeecertid <> n.payeecertid
        or o.bcsacctseqnum <> n.bcsacctseqnum
        or o.commodityamt <> n.commodityamt
        or o.businessname <> n.businessname
        or o.businesscertcode <> n.businesscertcode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_info_cl(
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,paymenttype -- 
            ,payeecertid -- 
            ,bcsacctseqnum -- 
            ,commodityamt -- 
            ,businessname -- 
            ,businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_info_op(
            serialno -- 支付流水号
            ,maxpaydate -- 最迟支付日
            ,entrustedno -- 受托支付编号
            ,pigeonholedate -- 归档日期
            ,updateorgid -- 更新机构
            ,corporgid -- 法人机构编号
            ,updatedate -- 更新日期
            ,zfjyserialno -- 在线受托支付-止付交易流水号
            ,putoutserialno -- 放贷流水号
            ,paymentdate -- 支付日期
            ,payeename -- 收款人名称
            ,docid -- 交易代码
            ,inputorgid -- 登记机构
            ,sequencenum -- 支付序列号
            ,resenddatetime -- 重新发送时间
            ,capitalpurpose -- 资金用途
            ,inputdate -- 登记日期
            ,transeqno -- 平台请求流水号
            ,confirmstatus -- 确认状态
            ,isreservepay -- 是否预约受托支付
            ,rowno -- 明细流水号
            ,objectno -- 受托支付汇总记录编号
            ,remark -- 备注
            ,cause -- 支付失败原因
            ,batchno -- 受托支付批次号
            ,transformno -- 平台交易流水号
            ,freezeseqno -- 冻结流水号
            ,isinneraccount -- 是否行内账号
            ,actualpaydate -- 实际支付日期
            ,zfserialno -- 止付流水号
            ,iskj -- 是否跨境
            ,customerid -- 客户编号
            ,payeebank -- 收款人开户行
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,paystatus -- 在线受托支付-支付状态码值BillPayStatus
            ,paymenttime -- 支付时间（10/15）
            ,updateuserid -- 更新人
            ,zfdate -- 止付交易日期
            ,plattrxseq -- 在线受托支付-原交易平台流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,payeeaccount -- 收款账户号
            ,payeebankname -- 转入行名
            ,customername -- 客户名称
            ,paymentsum -- 支付金额
            ,paymentstatus -- 支付状态
            ,trxdate -- 平台交易日期
            ,entrustedpayid -- 受托支付序号
            ,isinuse -- 添加维护标志1正常2不维护
            ,resendstatus -- 重发状态
            ,isbankaccount -- 是否是本行客户
            ,payeenameadd -- 收款人地址
            ,capitalpurposedesc -- 贷款用途描述
            ,paymenttype -- 
            ,payeecertid -- 
            ,bcsacctseqnum -- 
            ,commodityamt -- 
            ,businessname -- 
            ,businesscertcode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 支付流水号
    ,o.maxpaydate -- 最迟支付日
    ,o.entrustedno -- 受托支付编号
    ,o.pigeonholedate -- 归档日期
    ,o.updateorgid -- 更新机构
    ,o.corporgid -- 法人机构编号
    ,o.updatedate -- 更新日期
    ,o.zfjyserialno -- 在线受托支付-止付交易流水号
    ,o.putoutserialno -- 放贷流水号
    ,o.paymentdate -- 支付日期
    ,o.payeename -- 收款人名称
    ,o.docid -- 交易代码
    ,o.inputorgid -- 登记机构
    ,o.sequencenum -- 支付序列号
    ,o.resenddatetime -- 重新发送时间
    ,o.capitalpurpose -- 资金用途
    ,o.inputdate -- 登记日期
    ,o.transeqno -- 平台请求流水号
    ,o.confirmstatus -- 确认状态
    ,o.isreservepay -- 是否预约受托支付
    ,o.rowno -- 明细流水号
    ,o.objectno -- 受托支付汇总记录编号
    ,o.remark -- 备注
    ,o.cause -- 支付失败原因
    ,o.batchno -- 受托支付批次号
    ,o.transformno -- 平台交易流水号
    ,o.freezeseqno -- 冻结流水号
    ,o.isinneraccount -- 是否行内账号
    ,o.actualpaydate -- 实际支付日期
    ,o.zfserialno -- 止付流水号
    ,o.iskj -- 是否跨境
    ,o.customerid -- 客户编号
    ,o.payeebank -- 收款人开户行
    ,o.currency -- 币种
    ,o.inputuserid -- 登记人
    ,o.paystatus -- 在线受托支付-支付状态码值BillPayStatus
    ,o.paymenttime -- 支付时间（10/15）
    ,o.updateuserid -- 更新人
    ,o.zfdate -- 止付交易日期
    ,o.plattrxseq -- 在线受托支付-原交易平台流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.payeeaccount -- 收款账户号
    ,o.payeebankname -- 转入行名
    ,o.customername -- 客户名称
    ,o.paymentsum -- 支付金额
    ,o.paymentstatus -- 支付状态
    ,o.trxdate -- 平台交易日期
    ,o.entrustedpayid -- 受托支付序号
    ,o.isinuse -- 添加维护标志1正常2不维护
    ,o.resendstatus -- 重发状态
    ,o.isbankaccount -- 是否是本行客户
    ,o.payeenameadd -- 收款人地址
    ,o.capitalpurposedesc -- 贷款用途描述
    ,o.paymenttype -- 
    ,o.payeecertid -- 
    ,o.bcsacctseqnum -- 
    ,o.commodityamt -- 
    ,o.businessname -- 
    ,o.businesscertcode -- 
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
from ${iol_schema}.icms_payment_info_bk o
    left join ${iol_schema}.icms_payment_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_payment_info_cl d
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
--truncate table ${iol_schema}.icms_payment_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_payment_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_payment_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_payment_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_payment_info exchange partition p_${batch_date} with table ${iol_schema}.icms_payment_info_cl;
alter table ${iol_schema}.icms_payment_info exchange partition p_20991231 with table ${iol_schema}.icms_payment_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_payment_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_info_op purge;
drop table ${iol_schema}.icms_payment_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_payment_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_payment_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
