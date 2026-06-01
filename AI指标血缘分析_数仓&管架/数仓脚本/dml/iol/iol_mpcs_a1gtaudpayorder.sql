/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1gtaudpayorder
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
create table ${iol_schema}.mpcs_a1gtaudpayorder_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1gtaudpayorder
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1gtaudpayorder_op purge;
drop table ${iol_schema}.mpcs_a1gtaudpayorder_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1gtaudpayorder_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1gtaudpayorder where 0=1;

create table ${iol_schema}.mpcs_a1gtaudpayorder_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1gtaudpayorder where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1gtaudpayorder_cl(
            trxcode -- 指令代码
            ,transdt -- 交易日期
            ,finaid -- 财政局代码
            ,finano -- 财政流水号
            ,operator -- 操作员
            ,bankid -- 银行标识号
            ,billno -- 单据号
            ,bgorgcode -- 业务科室代码
            ,bgdeptcode -- 预算单位代码
            ,procdate -- 业务日期
            ,captorgion -- 资金性质
            ,fiscal -- 会计年度
            ,fisperd -- 会计期间
            ,paymenttype -- 支付方式 01授权支付 02直接支付
            ,bgacccode -- 预算科目代码
            ,projectcode -- 预算项目代码
            ,typeofpay -- 支出类型
            ,outlaycode -- 经费类型
            ,payusage -- 支出用途
            ,recebankaccount -- 收款人账号
            ,recename -- 收款人名称
            ,recebanknodename -- 收款人开户行
            ,paybankaccount -- 付款人账号
            ,payname -- 付款人名称
            ,paybanknodename -- 付款人开户行
            ,rationsum -- 额度
            ,paysum -- 支付金额
            ,remark -- 备注
            ,transtype -- 业务类型 00=正常支付 01=取消支付
            ,wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
            ,billsno -- 单位支付凭证字号
            ,banktrxcode -- 银行返回码
            ,paydatetime -- 银行处理时间
            ,bankpaystatus -- 银行处理状态
            ,finatrxcode -- 财政返回码
            ,updt -- 最后修改时间
            ,brcno -- 修改机构
            ,tlrno -- 修改柜员
            ,status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
            ,transeqno -- UPP记账的流水号
            ,bgdeptname -- 预算单位名称
            ,projectname -- 预算项目名称
            ,bgorgname -- 业务科室名称
            ,bgaccname -- 预算科目名称
            ,dataid -- 第三方标识号
            ,banksequ -- 银行发送财政的流水号
            ,outlayname -- 经费类型名称
            ,recebanknode -- 收款人开行行号
            ,bankflg -- 行内行外标志 1-行内 0-行外
            ,hostdate -- 主机日期
            ,hostnbr -- 主机流水
            ,cnapstransq -- 支付序号
            ,operationtypecode -- 业务标识
            ,yztype -- 零余额标志
            ,globalseqno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1gtaudpayorder_op(
            trxcode -- 指令代码
            ,transdt -- 交易日期
            ,finaid -- 财政局代码
            ,finano -- 财政流水号
            ,operator -- 操作员
            ,bankid -- 银行标识号
            ,billno -- 单据号
            ,bgorgcode -- 业务科室代码
            ,bgdeptcode -- 预算单位代码
            ,procdate -- 业务日期
            ,captorgion -- 资金性质
            ,fiscal -- 会计年度
            ,fisperd -- 会计期间
            ,paymenttype -- 支付方式 01授权支付 02直接支付
            ,bgacccode -- 预算科目代码
            ,projectcode -- 预算项目代码
            ,typeofpay -- 支出类型
            ,outlaycode -- 经费类型
            ,payusage -- 支出用途
            ,recebankaccount -- 收款人账号
            ,recename -- 收款人名称
            ,recebanknodename -- 收款人开户行
            ,paybankaccount -- 付款人账号
            ,payname -- 付款人名称
            ,paybanknodename -- 付款人开户行
            ,rationsum -- 额度
            ,paysum -- 支付金额
            ,remark -- 备注
            ,transtype -- 业务类型 00=正常支付 01=取消支付
            ,wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
            ,billsno -- 单位支付凭证字号
            ,banktrxcode -- 银行返回码
            ,paydatetime -- 银行处理时间
            ,bankpaystatus -- 银行处理状态
            ,finatrxcode -- 财政返回码
            ,updt -- 最后修改时间
            ,brcno -- 修改机构
            ,tlrno -- 修改柜员
            ,status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
            ,transeqno -- UPP记账的流水号
            ,bgdeptname -- 预算单位名称
            ,projectname -- 预算项目名称
            ,bgorgname -- 业务科室名称
            ,bgaccname -- 预算科目名称
            ,dataid -- 第三方标识号
            ,banksequ -- 银行发送财政的流水号
            ,outlayname -- 经费类型名称
            ,recebanknode -- 收款人开行行号
            ,bankflg -- 行内行外标志 1-行内 0-行外
            ,hostdate -- 主机日期
            ,hostnbr -- 主机流水
            ,cnapstransq -- 支付序号
            ,operationtypecode -- 业务标识
            ,yztype -- 零余额标志
            ,globalseqno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trxcode, o.trxcode) as trxcode -- 指令代码
    ,nvl(n.transdt, o.transdt) as transdt -- 交易日期
    ,nvl(n.finaid, o.finaid) as finaid -- 财政局代码
    ,nvl(n.finano, o.finano) as finano -- 财政流水号
    ,nvl(n.operator, o.operator) as operator -- 操作员
    ,nvl(n.bankid, o.bankid) as bankid -- 银行标识号
    ,nvl(n.billno, o.billno) as billno -- 单据号
    ,nvl(n.bgorgcode, o.bgorgcode) as bgorgcode -- 业务科室代码
    ,nvl(n.bgdeptcode, o.bgdeptcode) as bgdeptcode -- 预算单位代码
    ,nvl(n.procdate, o.procdate) as procdate -- 业务日期
    ,nvl(n.captorgion, o.captorgion) as captorgion -- 资金性质
    ,nvl(n.fiscal, o.fiscal) as fiscal -- 会计年度
    ,nvl(n.fisperd, o.fisperd) as fisperd -- 会计期间
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式 01授权支付 02直接支付
    ,nvl(n.bgacccode, o.bgacccode) as bgacccode -- 预算科目代码
    ,nvl(n.projectcode, o.projectcode) as projectcode -- 预算项目代码
    ,nvl(n.typeofpay, o.typeofpay) as typeofpay -- 支出类型
    ,nvl(n.outlaycode, o.outlaycode) as outlaycode -- 经费类型
    ,nvl(n.payusage, o.payusage) as payusage -- 支出用途
    ,nvl(n.recebankaccount, o.recebankaccount) as recebankaccount -- 收款人账号
    ,nvl(n.recename, o.recename) as recename -- 收款人名称
    ,nvl(n.recebanknodename, o.recebanknodename) as recebanknodename -- 收款人开户行
    ,nvl(n.paybankaccount, o.paybankaccount) as paybankaccount -- 付款人账号
    ,nvl(n.payname, o.payname) as payname -- 付款人名称
    ,nvl(n.paybanknodename, o.paybanknodename) as paybanknodename -- 付款人开户行
    ,nvl(n.rationsum, o.rationsum) as rationsum -- 额度
    ,nvl(n.paysum, o.paysum) as paysum -- 支付金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.transtype, o.transtype) as transtype -- 业务类型 00=正常支付 01=取消支付
    ,nvl(n.wayofpay, o.wayofpay) as wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
    ,nvl(n.billsno, o.billsno) as billsno -- 单位支付凭证字号
    ,nvl(n.banktrxcode, o.banktrxcode) as banktrxcode -- 银行返回码
    ,nvl(n.paydatetime, o.paydatetime) as paydatetime -- 银行处理时间
    ,nvl(n.bankpaystatus, o.bankpaystatus) as bankpaystatus -- 银行处理状态
    ,nvl(n.finatrxcode, o.finatrxcode) as finatrxcode -- 财政返回码
    ,nvl(n.updt, o.updt) as updt -- 最后修改时间
    ,nvl(n.brcno, o.brcno) as brcno -- 修改机构
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 修改柜员
    ,nvl(n.status, o.status) as status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
    ,nvl(n.transeqno, o.transeqno) as transeqno -- UPP记账的流水号
    ,nvl(n.bgdeptname, o.bgdeptname) as bgdeptname -- 预算单位名称
    ,nvl(n.projectname, o.projectname) as projectname -- 预算项目名称
    ,nvl(n.bgorgname, o.bgorgname) as bgorgname -- 业务科室名称
    ,nvl(n.bgaccname, o.bgaccname) as bgaccname -- 预算科目名称
    ,nvl(n.dataid, o.dataid) as dataid -- 第三方标识号
    ,nvl(n.banksequ, o.banksequ) as banksequ -- 银行发送财政的流水号
    ,nvl(n.outlayname, o.outlayname) as outlayname -- 经费类型名称
    ,nvl(n.recebanknode, o.recebanknode) as recebanknode -- 收款人开行行号
    ,nvl(n.bankflg, o.bankflg) as bankflg -- 行内行外标志 1-行内 0-行外
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 主机日期
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 主机流水
    ,nvl(n.cnapstransq, o.cnapstransq) as cnapstransq -- 支付序号
    ,nvl(n.operationtypecode, o.operationtypecode) as operationtypecode -- 业务标识
    ,nvl(n.yztype, o.yztype) as yztype -- 零余额标志
    ,nvl(n.globalseqno, o.globalseqno) as globalseqno -- 
    ,case when
            n.finaid is null
            and n.billno is null
            and n.fiscal is null
            and n.paymenttype is null
            and n.transtype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.finaid is null
            and n.billno is null
            and n.fiscal is null
            and n.paymenttype is null
            and n.transtype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.finaid is null
            and n.billno is null
            and n.fiscal is null
            and n.paymenttype is null
            and n.transtype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1gtaudpayorder_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1gtaudpayorder where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.finaid = n.finaid
            and o.billno = n.billno
            and o.fiscal = n.fiscal
            and o.paymenttype = n.paymenttype
            and o.transtype = n.transtype
where (
        o.finaid is null
        and o.billno is null
        and o.fiscal is null
        and o.paymenttype is null
        and o.transtype is null
    )
    or (
        n.finaid is null
        and n.billno is null
        and n.fiscal is null
        and n.paymenttype is null
        and n.transtype is null
    )
    or (
        o.trxcode <> n.trxcode
        or o.transdt <> n.transdt
        or o.finano <> n.finano
        or o.operator <> n.operator
        or o.bankid <> n.bankid
        or o.bgorgcode <> n.bgorgcode
        or o.bgdeptcode <> n.bgdeptcode
        or o.procdate <> n.procdate
        or o.captorgion <> n.captorgion
        or o.fisperd <> n.fisperd
        or o.bgacccode <> n.bgacccode
        or o.projectcode <> n.projectcode
        or o.typeofpay <> n.typeofpay
        or o.outlaycode <> n.outlaycode
        or o.payusage <> n.payusage
        or o.recebankaccount <> n.recebankaccount
        or o.recename <> n.recename
        or o.recebanknodename <> n.recebanknodename
        or o.paybankaccount <> n.paybankaccount
        or o.payname <> n.payname
        or o.paybanknodename <> n.paybanknodename
        or o.rationsum <> n.rationsum
        or o.paysum <> n.paysum
        or o.remark <> n.remark
        or o.wayofpay <> n.wayofpay
        or o.billsno <> n.billsno
        or o.banktrxcode <> n.banktrxcode
        or o.paydatetime <> n.paydatetime
        or o.bankpaystatus <> n.bankpaystatus
        or o.finatrxcode <> n.finatrxcode
        or o.updt <> n.updt
        or o.brcno <> n.brcno
        or o.tlrno <> n.tlrno
        or o.status <> n.status
        or o.transeqno <> n.transeqno
        or o.bgdeptname <> n.bgdeptname
        or o.projectname <> n.projectname
        or o.bgorgname <> n.bgorgname
        or o.bgaccname <> n.bgaccname
        or o.dataid <> n.dataid
        or o.banksequ <> n.banksequ
        or o.outlayname <> n.outlayname
        or o.recebanknode <> n.recebanknode
        or o.bankflg <> n.bankflg
        or o.hostdate <> n.hostdate
        or o.hostnbr <> n.hostnbr
        or o.cnapstransq <> n.cnapstransq
        or o.operationtypecode <> n.operationtypecode
        or o.yztype <> n.yztype
        or o.globalseqno <> n.globalseqno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1gtaudpayorder_cl(
            trxcode -- 指令代码
            ,transdt -- 交易日期
            ,finaid -- 财政局代码
            ,finano -- 财政流水号
            ,operator -- 操作员
            ,bankid -- 银行标识号
            ,billno -- 单据号
            ,bgorgcode -- 业务科室代码
            ,bgdeptcode -- 预算单位代码
            ,procdate -- 业务日期
            ,captorgion -- 资金性质
            ,fiscal -- 会计年度
            ,fisperd -- 会计期间
            ,paymenttype -- 支付方式 01授权支付 02直接支付
            ,bgacccode -- 预算科目代码
            ,projectcode -- 预算项目代码
            ,typeofpay -- 支出类型
            ,outlaycode -- 经费类型
            ,payusage -- 支出用途
            ,recebankaccount -- 收款人账号
            ,recename -- 收款人名称
            ,recebanknodename -- 收款人开户行
            ,paybankaccount -- 付款人账号
            ,payname -- 付款人名称
            ,paybanknodename -- 付款人开户行
            ,rationsum -- 额度
            ,paysum -- 支付金额
            ,remark -- 备注
            ,transtype -- 业务类型 00=正常支付 01=取消支付
            ,wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
            ,billsno -- 单位支付凭证字号
            ,banktrxcode -- 银行返回码
            ,paydatetime -- 银行处理时间
            ,bankpaystatus -- 银行处理状态
            ,finatrxcode -- 财政返回码
            ,updt -- 最后修改时间
            ,brcno -- 修改机构
            ,tlrno -- 修改柜员
            ,status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
            ,transeqno -- UPP记账的流水号
            ,bgdeptname -- 预算单位名称
            ,projectname -- 预算项目名称
            ,bgorgname -- 业务科室名称
            ,bgaccname -- 预算科目名称
            ,dataid -- 第三方标识号
            ,banksequ -- 银行发送财政的流水号
            ,outlayname -- 经费类型名称
            ,recebanknode -- 收款人开行行号
            ,bankflg -- 行内行外标志 1-行内 0-行外
            ,hostdate -- 主机日期
            ,hostnbr -- 主机流水
            ,cnapstransq -- 支付序号
            ,operationtypecode -- 业务标识
            ,yztype -- 零余额标志
            ,globalseqno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1gtaudpayorder_op(
            trxcode -- 指令代码
            ,transdt -- 交易日期
            ,finaid -- 财政局代码
            ,finano -- 财政流水号
            ,operator -- 操作员
            ,bankid -- 银行标识号
            ,billno -- 单据号
            ,bgorgcode -- 业务科室代码
            ,bgdeptcode -- 预算单位代码
            ,procdate -- 业务日期
            ,captorgion -- 资金性质
            ,fiscal -- 会计年度
            ,fisperd -- 会计期间
            ,paymenttype -- 支付方式 01授权支付 02直接支付
            ,bgacccode -- 预算科目代码
            ,projectcode -- 预算项目代码
            ,typeofpay -- 支出类型
            ,outlaycode -- 经费类型
            ,payusage -- 支出用途
            ,recebankaccount -- 收款人账号
            ,recename -- 收款人名称
            ,recebanknodename -- 收款人开户行
            ,paybankaccount -- 付款人账号
            ,payname -- 付款人名称
            ,paybanknodename -- 付款人开户行
            ,rationsum -- 额度
            ,paysum -- 支付金额
            ,remark -- 备注
            ,transtype -- 业务类型 00=正常支付 01=取消支付
            ,wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
            ,billsno -- 单位支付凭证字号
            ,banktrxcode -- 银行返回码
            ,paydatetime -- 银行处理时间
            ,bankpaystatus -- 银行处理状态
            ,finatrxcode -- 财政返回码
            ,updt -- 最后修改时间
            ,brcno -- 修改机构
            ,tlrno -- 修改柜员
            ,status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
            ,transeqno -- UPP记账的流水号
            ,bgdeptname -- 预算单位名称
            ,projectname -- 预算项目名称
            ,bgorgname -- 业务科室名称
            ,bgaccname -- 预算科目名称
            ,dataid -- 第三方标识号
            ,banksequ -- 银行发送财政的流水号
            ,outlayname -- 经费类型名称
            ,recebanknode -- 收款人开行行号
            ,bankflg -- 行内行外标志 1-行内 0-行外
            ,hostdate -- 主机日期
            ,hostnbr -- 主机流水
            ,cnapstransq -- 支付序号
            ,operationtypecode -- 业务标识
            ,yztype -- 零余额标志
            ,globalseqno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trxcode -- 指令代码
    ,o.transdt -- 交易日期
    ,o.finaid -- 财政局代码
    ,o.finano -- 财政流水号
    ,o.operator -- 操作员
    ,o.bankid -- 银行标识号
    ,o.billno -- 单据号
    ,o.bgorgcode -- 业务科室代码
    ,o.bgdeptcode -- 预算单位代码
    ,o.procdate -- 业务日期
    ,o.captorgion -- 资金性质
    ,o.fiscal -- 会计年度
    ,o.fisperd -- 会计期间
    ,o.paymenttype -- 支付方式 01授权支付 02直接支付
    ,o.bgacccode -- 预算科目代码
    ,o.projectcode -- 预算项目代码
    ,o.typeofpay -- 支出类型
    ,o.outlaycode -- 经费类型
    ,o.payusage -- 支出用途
    ,o.recebankaccount -- 收款人账号
    ,o.recename -- 收款人名称
    ,o.recebanknodename -- 收款人开户行
    ,o.paybankaccount -- 付款人账号
    ,o.payname -- 付款人名称
    ,o.paybanknodename -- 付款人开户行
    ,o.rationsum -- 额度
    ,o.paysum -- 支付金额
    ,o.remark -- 备注
    ,o.transtype -- 业务类型 00=正常支付 01=取消支付
    ,o.wayofpay -- 结算方式 01=现金 02=转账 9=公务卡
    ,o.billsno -- 单位支付凭证字号
    ,o.banktrxcode -- 银行返回码
    ,o.paydatetime -- 银行处理时间
    ,o.bankpaystatus -- 银行处理状态
    ,o.finatrxcode -- 财政返回码
    ,o.updt -- 最后修改时间
    ,o.brcno -- 修改机构
    ,o.tlrno -- 修改柜员
    ,o.status -- 交易状态 01-待处理 011-账务处理中 02-记账成功 021-记账失败 03-凭证确认成功 031-凭证确认失败 04-凭证冲销成功 041-凭证冲销失败 042-核心冲正失败 05-冲销处理完成 06-凭证已取消
    ,o.transeqno -- UPP记账的流水号
    ,o.bgdeptname -- 预算单位名称
    ,o.projectname -- 预算项目名称
    ,o.bgorgname -- 业务科室名称
    ,o.bgaccname -- 预算科目名称
    ,o.dataid -- 第三方标识号
    ,o.banksequ -- 银行发送财政的流水号
    ,o.outlayname -- 经费类型名称
    ,o.recebanknode -- 收款人开行行号
    ,o.bankflg -- 行内行外标志 1-行内 0-行外
    ,o.hostdate -- 主机日期
    ,o.hostnbr -- 主机流水
    ,o.cnapstransq -- 支付序号
    ,o.operationtypecode -- 业务标识
    ,o.yztype -- 零余额标志
    ,o.globalseqno -- 
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
from ${iol_schema}.mpcs_a1gtaudpayorder_bk o
    left join ${iol_schema}.mpcs_a1gtaudpayorder_op n
        on
            o.finaid = n.finaid
            and o.billno = n.billno
            and o.fiscal = n.fiscal
            and o.paymenttype = n.paymenttype
            and o.transtype = n.transtype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1gtaudpayorder_cl d
        on
            o.finaid = d.finaid
            and o.billno = d.billno
            and o.fiscal = d.fiscal
            and o.paymenttype = d.paymenttype
            and o.transtype = d.transtype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1gtaudpayorder;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1gtaudpayorder') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1gtaudpayorder drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1gtaudpayorder add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1gtaudpayorder exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1gtaudpayorder_cl;
alter table ${iol_schema}.mpcs_a1gtaudpayorder exchange partition p_20991231 with table ${iol_schema}.mpcs_a1gtaudpayorder_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1gtaudpayorder to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1gtaudpayorder_op purge;
drop table ${iol_schema}.mpcs_a1gtaudpayorder_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1gtaudpayorder_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1gtaudpayorder',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
