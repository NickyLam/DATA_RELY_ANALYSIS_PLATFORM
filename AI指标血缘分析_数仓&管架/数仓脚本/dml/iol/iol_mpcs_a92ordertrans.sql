/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92ordertrans
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
create table ${iol_schema}.mpcs_a92ordertrans_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92ordertrans
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92ordertrans_op purge;
drop table ${iol_schema}.mpcs_a92ordertrans_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92ordertrans_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92ordertrans where 0=1;

create table ${iol_schema}.mpcs_a92ordertrans_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a92ordertrans where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92ordertrans_cl(
            srcseqno -- 前端请求流水号
            ,brokerorderno -- 中台流水号
            ,trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
            ,transtime -- 流水时间
            ,paysys -- 商户简称 YM
            ,instid -- 商户号   1022
            ,channel -- 请求渠道
            ,customno -- 客户号
            ,accountid -- 盈米财富账户ID
            ,paymenttype -- 支付方式
            ,paymentmethodid -- 支付方式ID
            ,usewallet -- 使用盈米宝支付
            ,walletid -- 盈米宝ID
            ,buy -- 购买类型(022)allot-申购(020)subscribe-认购
            ,fundcode -- 基金代码
            ,fundname -- 基金名称
            ,sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
            ,dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
            ,ccy -- 币种    156-人民币
            ,amount -- 金额
            ,shareid -- 份额ID
            ,tradeshare -- 份额
            ,ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
            ,signecontract -- 是否签署电子合同
            ,overtimeflag -- 订单日控制标志
            ,vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
            ,redeemtowallet -- 是否赎回盈米宝
            ,walletfundcode -- 盈米宝基金代码
            ,isidempotent -- 幂等模式标志
            ,orderid -- 订单ID
            ,ordercreatedon -- 订单生成的时间(自然日)
            ,ordercanceledon -- 撤销订单产生的时间（自然日）
            ,ordertradedate -- 订单所属的交易申请日期(T日)
            ,orderexpectedconfirmdate -- 订单的预计确认日期
            ,orderconfirmdate -- 订单确认日期
            ,setupdate -- 基金预计成立日期
            ,transferintodate -- 赎回款项支付日
            ,buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
            ,isduplicated -- 幂等模式是否执行
            ,workcode -- UPP交易码
            ,accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
            ,payeracct -- 转出方账户
            ,payername -- 转出方户名
            ,payeropbk -- 转出方行号
            ,payeeacct -- 转入方账户
            ,payeename -- 转入方户名
            ,payeeopbk -- 转入方行号
            ,uppfreetrace -- UPP止付请求流水
            ,settldate -- 清算日期
            ,freezerecordid -- 冻结编号
            ,upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
            ,hostdate -- UPP主机日期
            ,hostnbr -- UPP主机流水
            ,status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
            ,cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
            ,finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
            ,tzflg -- 交易标志：0-联机交易，1-调账交易
            ,isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
            ,payresultnotetime -- 购买订单支付结果通知的时间（自然日）
            ,successamount -- 已成功金额
            ,successshare -- 已成功份额
            ,cdsystrace -- 撤单中台流水号
            ,cdsystime -- 撤单时间
            ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
            ,noteflag -- 通知标志位 N未知 F失败 S成功
            ,notenum -- 通知次数
            ,updatetime -- 最新更新时间
            ,remark1 -- 确认文件对账状态
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,rspcd -- 错误码
            ,rspmsg -- 错误信息
            ,orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
            ,destfundcode -- 转换目标基金代码
            ,destfundname -- 转换目标基金名称
            ,isriskconfirmhigh -- 最高风险购买确认
            ,isriskconfirmagain -- 二次确认
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,srcglobseqno -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92ordertrans_op(
            srcseqno -- 前端请求流水号
            ,brokerorderno -- 中台流水号
            ,trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
            ,transtime -- 流水时间
            ,paysys -- 商户简称 YM
            ,instid -- 商户号   1022
            ,channel -- 请求渠道
            ,customno -- 客户号
            ,accountid -- 盈米财富账户ID
            ,paymenttype -- 支付方式
            ,paymentmethodid -- 支付方式ID
            ,usewallet -- 使用盈米宝支付
            ,walletid -- 盈米宝ID
            ,buy -- 购买类型(022)allot-申购(020)subscribe-认购
            ,fundcode -- 基金代码
            ,fundname -- 基金名称
            ,sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
            ,dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
            ,ccy -- 币种    156-人民币
            ,amount -- 金额
            ,shareid -- 份额ID
            ,tradeshare -- 份额
            ,ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
            ,signecontract -- 是否签署电子合同
            ,overtimeflag -- 订单日控制标志
            ,vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
            ,redeemtowallet -- 是否赎回盈米宝
            ,walletfundcode -- 盈米宝基金代码
            ,isidempotent -- 幂等模式标志
            ,orderid -- 订单ID
            ,ordercreatedon -- 订单生成的时间(自然日)
            ,ordercanceledon -- 撤销订单产生的时间（自然日）
            ,ordertradedate -- 订单所属的交易申请日期(T日)
            ,orderexpectedconfirmdate -- 订单的预计确认日期
            ,orderconfirmdate -- 订单确认日期
            ,setupdate -- 基金预计成立日期
            ,transferintodate -- 赎回款项支付日
            ,buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
            ,isduplicated -- 幂等模式是否执行
            ,workcode -- UPP交易码
            ,accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
            ,payeracct -- 转出方账户
            ,payername -- 转出方户名
            ,payeropbk -- 转出方行号
            ,payeeacct -- 转入方账户
            ,payeename -- 转入方户名
            ,payeeopbk -- 转入方行号
            ,uppfreetrace -- UPP止付请求流水
            ,settldate -- 清算日期
            ,freezerecordid -- 冻结编号
            ,upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
            ,hostdate -- UPP主机日期
            ,hostnbr -- UPP主机流水
            ,status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
            ,cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
            ,finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
            ,tzflg -- 交易标志：0-联机交易，1-调账交易
            ,isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
            ,payresultnotetime -- 购买订单支付结果通知的时间（自然日）
            ,successamount -- 已成功金额
            ,successshare -- 已成功份额
            ,cdsystrace -- 撤单中台流水号
            ,cdsystime -- 撤单时间
            ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
            ,noteflag -- 通知标志位 N未知 F失败 S成功
            ,notenum -- 通知次数
            ,updatetime -- 最新更新时间
            ,remark1 -- 确认文件对账状态
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,rspcd -- 错误码
            ,rspmsg -- 错误信息
            ,orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
            ,destfundcode -- 转换目标基金代码
            ,destfundname -- 转换目标基金名称
            ,isriskconfirmhigh -- 最高风险购买确认
            ,isriskconfirmagain -- 二次确认
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,srcglobseqno -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.srcseqno, o.srcseqno) as srcseqno -- 前端请求流水号
    ,nvl(n.brokerorderno, o.brokerorderno) as brokerorderno -- 中台流水号
    ,nvl(n.trantype, o.trantype) as trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
    ,nvl(n.transtime, o.transtime) as transtime -- 流水时间
    ,nvl(n.paysys, o.paysys) as paysys -- 商户简称 YM
    ,nvl(n.instid, o.instid) as instid -- 商户号   1022
    ,nvl(n.channel, o.channel) as channel -- 请求渠道
    ,nvl(n.customno, o.customno) as customno -- 客户号
    ,nvl(n.accountid, o.accountid) as accountid -- 盈米财富账户ID
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式
    ,nvl(n.paymentmethodid, o.paymentmethodid) as paymentmethodid -- 支付方式ID
    ,nvl(n.usewallet, o.usewallet) as usewallet -- 使用盈米宝支付
    ,nvl(n.walletid, o.walletid) as walletid -- 盈米宝ID
    ,nvl(n.buy, o.buy) as buy -- 购买类型(022)allot-申购(020)subscribe-认购
    ,nvl(n.fundcode, o.fundcode) as fundcode -- 基金代码
    ,nvl(n.fundname, o.fundname) as fundname -- 基金名称
    ,nvl(n.sharetype, o.sharetype) as sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
    ,nvl(n.dividendmethod, o.dividendmethod) as dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
    ,nvl(n.ccy, o.ccy) as ccy -- 币种    156-人民币
    ,nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.shareid, o.shareid) as shareid -- 份额ID
    ,nvl(n.tradeshare, o.tradeshare) as tradeshare -- 份额
    ,nvl(n.ignoreriskgrade, o.ignoreriskgrade) as ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
    ,nvl(n.signecontract, o.signecontract) as signecontract -- 是否签署电子合同
    ,nvl(n.overtimeflag, o.overtimeflag) as overtimeflag -- 订单日控制标志
    ,nvl(n.vastlyredeemflag, o.vastlyredeemflag) as vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
    ,nvl(n.redeemtowallet, o.redeemtowallet) as redeemtowallet -- 是否赎回盈米宝
    ,nvl(n.walletfundcode, o.walletfundcode) as walletfundcode -- 盈米宝基金代码
    ,nvl(n.isidempotent, o.isidempotent) as isidempotent -- 幂等模式标志
    ,nvl(n.orderid, o.orderid) as orderid -- 订单ID
    ,nvl(n.ordercreatedon, o.ordercreatedon) as ordercreatedon -- 订单生成的时间(自然日)
    ,nvl(n.ordercanceledon, o.ordercanceledon) as ordercanceledon -- 撤销订单产生的时间（自然日）
    ,nvl(n.ordertradedate, o.ordertradedate) as ordertradedate -- 订单所属的交易申请日期(T日)
    ,nvl(n.orderexpectedconfirmdate, o.orderexpectedconfirmdate) as orderexpectedconfirmdate -- 订单的预计确认日期
    ,nvl(n.orderconfirmdate, o.orderconfirmdate) as orderconfirmdate -- 订单确认日期
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 基金预计成立日期
    ,nvl(n.transferintodate, o.transferintodate) as transferintodate -- 赎回款项支付日
    ,nvl(n.buymode, o.buymode) as buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
    ,nvl(n.isduplicated, o.isduplicated) as isduplicated -- 幂等模式是否执行
    ,nvl(n.workcode, o.workcode) as workcode -- UPP交易码
    ,nvl(n.accttype, o.accttype) as accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
    ,nvl(n.payeracct, o.payeracct) as payeracct -- 转出方账户
    ,nvl(n.payername, o.payername) as payername -- 转出方户名
    ,nvl(n.payeropbk, o.payeropbk) as payeropbk -- 转出方行号
    ,nvl(n.payeeacct, o.payeeacct) as payeeacct -- 转入方账户
    ,nvl(n.payeename, o.payeename) as payeename -- 转入方户名
    ,nvl(n.payeeopbk, o.payeeopbk) as payeeopbk -- 转入方行号
    ,nvl(n.uppfreetrace, o.uppfreetrace) as uppfreetrace -- UPP止付请求流水
    ,nvl(n.settldate, o.settldate) as settldate -- 清算日期
    ,nvl(n.freezerecordid, o.freezerecordid) as freezerecordid -- 冻结编号
    ,nvl(n.upptransid, o.upptransid) as upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
    ,nvl(n.hostdate, o.hostdate) as hostdate -- UPP主机日期
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- UPP主机流水
    ,nvl(n.status, o.status) as status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
    ,nvl(n.cdflg, o.cdflg) as cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
    ,nvl(n.finalstatus, o.finalstatus) as finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
    ,nvl(n.tzflg, o.tzflg) as tzflg -- 交易标志：0-联机交易，1-调账交易
    ,nvl(n.isnotesuccess, o.isnotesuccess) as isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
    ,nvl(n.payresultnotetime, o.payresultnotetime) as payresultnotetime -- 购买订单支付结果通知的时间（自然日）
    ,nvl(n.successamount, o.successamount) as successamount -- 已成功金额
    ,nvl(n.successshare, o.successshare) as successshare -- 已成功份额
    ,nvl(n.cdsystrace, o.cdsystrace) as cdsystrace -- 撤单中台流水号
    ,nvl(n.cdsystime, o.cdsystime) as cdsystime -- 撤单时间
    ,nvl(n.checkflag, o.checkflag) as checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
    ,nvl(n.noteflag, o.noteflag) as noteflag -- 通知标志位 N未知 F失败 S成功
    ,nvl(n.notenum, o.notenum) as notenum -- 通知次数
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 最新更新时间
    ,nvl(n.remark1, o.remark1) as remark1 -- 确认文件对账状态
    ,nvl(n.remark2, o.remark2) as remark2 -- 
    ,nvl(n.remark3, o.remark3) as remark3 -- 
    ,nvl(n.remark4, o.remark4) as remark4 -- 
    ,nvl(n.remark5, o.remark5) as remark5 -- 
    ,nvl(n.remark6, o.remark6) as remark6 -- 
    ,nvl(n.rspcd, o.rspcd) as rspcd -- 错误码
    ,nvl(n.rspmsg, o.rspmsg) as rspmsg -- 错误信息
    ,nvl(n.orderstat, o.orderstat) as orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
    ,nvl(n.destfundcode, o.destfundcode) as destfundcode -- 转换目标基金代码
    ,nvl(n.destfundname, o.destfundname) as destfundname -- 转换目标基金名称
    ,nvl(n.isriskconfirmhigh, o.isriskconfirmhigh) as isriskconfirmhigh -- 最高风险购买确认
    ,nvl(n.isriskconfirmagain, o.isriskconfirmagain) as isriskconfirmagain -- 二次确认
    ,nvl(n.terminalip, o.terminalip) as terminalip -- 终端IP地址
    ,nvl(n.terminaltype, o.terminaltype) as terminaltype -- 终端类型
    ,nvl(n.terminalinfo, o.terminalinfo) as terminalinfo -- 终端相关信息
    ,nvl(n.srcglobseqno, o.srcglobseqno) as srcglobseqno -- 全局流水号
    ,nvl(n.unique_seq_num, o.unique_seq_num) as unique_seq_num -- 业务流水号
    ,case when
            n.brokerorderno is null
            and n.transtime is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.brokerorderno is null
            and n.transtime is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.brokerorderno is null
            and n.transtime is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92ordertrans_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a92ordertrans where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.brokerorderno = n.brokerorderno
            and o.transtime = n.transtime
where (
        o.brokerorderno is null
        and o.transtime is null
    )
    or (
        n.brokerorderno is null
        and n.transtime is null
    )
    or (
        o.srcseqno <> n.srcseqno
        or o.trantype <> n.trantype
        or o.paysys <> n.paysys
        or o.instid <> n.instid
        or o.channel <> n.channel
        or o.customno <> n.customno
        or o.accountid <> n.accountid
        or o.paymenttype <> n.paymenttype
        or o.paymentmethodid <> n.paymentmethodid
        or o.usewallet <> n.usewallet
        or o.walletid <> n.walletid
        or o.buy <> n.buy
        or o.fundcode <> n.fundcode
        or o.fundname <> n.fundname
        or o.sharetype <> n.sharetype
        or o.dividendmethod <> n.dividendmethod
        or o.ccy <> n.ccy
        or o.amount <> n.amount
        or o.shareid <> n.shareid
        or o.tradeshare <> n.tradeshare
        or o.ignoreriskgrade <> n.ignoreriskgrade
        or o.signecontract <> n.signecontract
        or o.overtimeflag <> n.overtimeflag
        or o.vastlyredeemflag <> n.vastlyredeemflag
        or o.redeemtowallet <> n.redeemtowallet
        or o.walletfundcode <> n.walletfundcode
        or o.isidempotent <> n.isidempotent
        or o.orderid <> n.orderid
        or o.ordercreatedon <> n.ordercreatedon
        or o.ordercanceledon <> n.ordercanceledon
        or o.ordertradedate <> n.ordertradedate
        or o.orderexpectedconfirmdate <> n.orderexpectedconfirmdate
        or o.orderconfirmdate <> n.orderconfirmdate
        or o.setupdate <> n.setupdate
        or o.transferintodate <> n.transferintodate
        or o.buymode <> n.buymode
        or o.isduplicated <> n.isduplicated
        or o.workcode <> n.workcode
        or o.accttype <> n.accttype
        or o.payeracct <> n.payeracct
        or o.payername <> n.payername
        or o.payeropbk <> n.payeropbk
        or o.payeeacct <> n.payeeacct
        or o.payeename <> n.payeename
        or o.payeeopbk <> n.payeeopbk
        or o.uppfreetrace <> n.uppfreetrace
        or o.settldate <> n.settldate
        or o.freezerecordid <> n.freezerecordid
        or o.upptransid <> n.upptransid
        or o.hostdate <> n.hostdate
        or o.hostnbr <> n.hostnbr
        or o.status <> n.status
        or o.cdflg <> n.cdflg
        or o.finalstatus <> n.finalstatus
        or o.tzflg <> n.tzflg
        or o.isnotesuccess <> n.isnotesuccess
        or o.payresultnotetime <> n.payresultnotetime
        or o.successamount <> n.successamount
        or o.successshare <> n.successshare
        or o.cdsystrace <> n.cdsystrace
        or o.cdsystime <> n.cdsystime
        or o.checkflag <> n.checkflag
        or o.noteflag <> n.noteflag
        or o.notenum <> n.notenum
        or o.updatetime <> n.updatetime
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.remark4 <> n.remark4
        or o.remark5 <> n.remark5
        or o.remark6 <> n.remark6
        or o.rspcd <> n.rspcd
        or o.rspmsg <> n.rspmsg
        or o.orderstat <> n.orderstat
        or o.destfundcode <> n.destfundcode
        or o.destfundname <> n.destfundname
        or o.isriskconfirmhigh <> n.isriskconfirmhigh
        or o.isriskconfirmagain <> n.isriskconfirmagain
        or o.terminalip <> n.terminalip
        or o.terminaltype <> n.terminaltype
        or o.terminalinfo <> n.terminalinfo
        or o.srcglobseqno <> n.srcglobseqno
        or o.unique_seq_num <> n.unique_seq_num
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92ordertrans_cl(
            srcseqno -- 前端请求流水号
            ,brokerorderno -- 中台流水号
            ,trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
            ,transtime -- 流水时间
            ,paysys -- 商户简称 YM
            ,instid -- 商户号   1022
            ,channel -- 请求渠道
            ,customno -- 客户号
            ,accountid -- 盈米财富账户ID
            ,paymenttype -- 支付方式
            ,paymentmethodid -- 支付方式ID
            ,usewallet -- 使用盈米宝支付
            ,walletid -- 盈米宝ID
            ,buy -- 购买类型(022)allot-申购(020)subscribe-认购
            ,fundcode -- 基金代码
            ,fundname -- 基金名称
            ,sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
            ,dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
            ,ccy -- 币种    156-人民币
            ,amount -- 金额
            ,shareid -- 份额ID
            ,tradeshare -- 份额
            ,ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
            ,signecontract -- 是否签署电子合同
            ,overtimeflag -- 订单日控制标志
            ,vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
            ,redeemtowallet -- 是否赎回盈米宝
            ,walletfundcode -- 盈米宝基金代码
            ,isidempotent -- 幂等模式标志
            ,orderid -- 订单ID
            ,ordercreatedon -- 订单生成的时间(自然日)
            ,ordercanceledon -- 撤销订单产生的时间（自然日）
            ,ordertradedate -- 订单所属的交易申请日期(T日)
            ,orderexpectedconfirmdate -- 订单的预计确认日期
            ,orderconfirmdate -- 订单确认日期
            ,setupdate -- 基金预计成立日期
            ,transferintodate -- 赎回款项支付日
            ,buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
            ,isduplicated -- 幂等模式是否执行
            ,workcode -- UPP交易码
            ,accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
            ,payeracct -- 转出方账户
            ,payername -- 转出方户名
            ,payeropbk -- 转出方行号
            ,payeeacct -- 转入方账户
            ,payeename -- 转入方户名
            ,payeeopbk -- 转入方行号
            ,uppfreetrace -- UPP止付请求流水
            ,settldate -- 清算日期
            ,freezerecordid -- 冻结编号
            ,upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
            ,hostdate -- UPP主机日期
            ,hostnbr -- UPP主机流水
            ,status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
            ,cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
            ,finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
            ,tzflg -- 交易标志：0-联机交易，1-调账交易
            ,isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
            ,payresultnotetime -- 购买订单支付结果通知的时间（自然日）
            ,successamount -- 已成功金额
            ,successshare -- 已成功份额
            ,cdsystrace -- 撤单中台流水号
            ,cdsystime -- 撤单时间
            ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
            ,noteflag -- 通知标志位 N未知 F失败 S成功
            ,notenum -- 通知次数
            ,updatetime -- 最新更新时间
            ,remark1 -- 确认文件对账状态
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,rspcd -- 错误码
            ,rspmsg -- 错误信息
            ,orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
            ,destfundcode -- 转换目标基金代码
            ,destfundname -- 转换目标基金名称
            ,isriskconfirmhigh -- 最高风险购买确认
            ,isriskconfirmagain -- 二次确认
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,srcglobseqno -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92ordertrans_op(
            srcseqno -- 前端请求流水号
            ,brokerorderno -- 中台流水号
            ,trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
            ,transtime -- 流水时间
            ,paysys -- 商户简称 YM
            ,instid -- 商户号   1022
            ,channel -- 请求渠道
            ,customno -- 客户号
            ,accountid -- 盈米财富账户ID
            ,paymenttype -- 支付方式
            ,paymentmethodid -- 支付方式ID
            ,usewallet -- 使用盈米宝支付
            ,walletid -- 盈米宝ID
            ,buy -- 购买类型(022)allot-申购(020)subscribe-认购
            ,fundcode -- 基金代码
            ,fundname -- 基金名称
            ,sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
            ,dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
            ,ccy -- 币种    156-人民币
            ,amount -- 金额
            ,shareid -- 份额ID
            ,tradeshare -- 份额
            ,ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
            ,signecontract -- 是否签署电子合同
            ,overtimeflag -- 订单日控制标志
            ,vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
            ,redeemtowallet -- 是否赎回盈米宝
            ,walletfundcode -- 盈米宝基金代码
            ,isidempotent -- 幂等模式标志
            ,orderid -- 订单ID
            ,ordercreatedon -- 订单生成的时间(自然日)
            ,ordercanceledon -- 撤销订单产生的时间（自然日）
            ,ordertradedate -- 订单所属的交易申请日期(T日)
            ,orderexpectedconfirmdate -- 订单的预计确认日期
            ,orderconfirmdate -- 订单确认日期
            ,setupdate -- 基金预计成立日期
            ,transferintodate -- 赎回款项支付日
            ,buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
            ,isduplicated -- 幂等模式是否执行
            ,workcode -- UPP交易码
            ,accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
            ,payeracct -- 转出方账户
            ,payername -- 转出方户名
            ,payeropbk -- 转出方行号
            ,payeeacct -- 转入方账户
            ,payeename -- 转入方户名
            ,payeeopbk -- 转入方行号
            ,uppfreetrace -- UPP止付请求流水
            ,settldate -- 清算日期
            ,freezerecordid -- 冻结编号
            ,upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
            ,hostdate -- UPP主机日期
            ,hostnbr -- UPP主机流水
            ,status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
            ,cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
            ,finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
            ,tzflg -- 交易标志：0-联机交易，1-调账交易
            ,isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
            ,payresultnotetime -- 购买订单支付结果通知的时间（自然日）
            ,successamount -- 已成功金额
            ,successshare -- 已成功份额
            ,cdsystrace -- 撤单中台流水号
            ,cdsystime -- 撤单时间
            ,checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
            ,noteflag -- 通知标志位 N未知 F失败 S成功
            ,notenum -- 通知次数
            ,updatetime -- 最新更新时间
            ,remark1 -- 确认文件对账状态
            ,remark2 -- 
            ,remark3 -- 
            ,remark4 -- 
            ,remark5 -- 
            ,remark6 -- 
            ,rspcd -- 错误码
            ,rspmsg -- 错误信息
            ,orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
            ,destfundcode -- 转换目标基金代码
            ,destfundname -- 转换目标基金名称
            ,isriskconfirmhigh -- 最高风险购买确认
            ,isriskconfirmagain -- 二次确认
            ,terminalip -- 终端IP地址
            ,terminaltype -- 终端类型
            ,terminalinfo -- 终端相关信息
            ,srcglobseqno -- 全局流水号
            ,unique_seq_num -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.srcseqno -- 前端请求流水号
    ,o.brokerorderno -- 中台流水号
    ,o.trantype -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
    ,o.transtime -- 流水时间
    ,o.paysys -- 商户简称 YM
    ,o.instid -- 商户号   1022
    ,o.channel -- 请求渠道
    ,o.customno -- 客户号
    ,o.accountid -- 盈米财富账户ID
    ,o.paymenttype -- 支付方式
    ,o.paymentmethodid -- 支付方式ID
    ,o.usewallet -- 使用盈米宝支付
    ,o.walletid -- 盈米宝ID
    ,o.buy -- 购买类型(022)allot-申购(020)subscribe-认购
    ,o.fundcode -- 基金代码
    ,o.fundname -- 基金名称
    ,o.sharetype -- 收费方式 A-前端收费  B-后端收费 C-C类收费
    ,o.dividendmethod -- 分红方式   0-红利资金再投 1-现金分红
    ,o.ccy -- 币种    156-人民币
    ,o.amount -- 金额
    ,o.shareid -- 份额ID
    ,o.tradeshare -- 份额
    ,o.ignoreriskgrade -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
    ,o.signecontract -- 是否签署电子合同
    ,o.overtimeflag -- 订单日控制标志
    ,o.vastlyredeemflag -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
    ,o.redeemtowallet -- 是否赎回盈米宝
    ,o.walletfundcode -- 盈米宝基金代码
    ,o.isidempotent -- 幂等模式标志
    ,o.orderid -- 订单ID
    ,o.ordercreatedon -- 订单生成的时间(自然日)
    ,o.ordercanceledon -- 撤销订单产生的时间（自然日）
    ,o.ordertradedate -- 订单所属的交易申请日期(T日)
    ,o.orderexpectedconfirmdate -- 订单的预计确认日期
    ,o.orderconfirmdate -- 订单确认日期
    ,o.setupdate -- 基金预计成立日期
    ,o.transferintodate -- 赎回款项支付日
    ,o.buymode -- 购买类型  (022)allot-申购(020)subscribe-认购
    ,o.isduplicated -- 幂等模式是否执行
    ,o.workcode -- UPP交易码
    ,o.accttype -- 帐号类型 1-实体卡 2-Ⅱ类账户
    ,o.payeracct -- 转出方账户
    ,o.payername -- 转出方户名
    ,o.payeropbk -- 转出方行号
    ,o.payeeacct -- 转入方账户
    ,o.payeename -- 转入方户名
    ,o.payeeopbk -- 转入方行号
    ,o.uppfreetrace -- UPP止付请求流水
    ,o.settldate -- 清算日期
    ,o.freezerecordid -- 冻结编号
    ,o.upptransid -- 作为对账流水、解冻时的原流水号（UPP流水）
    ,o.hostdate -- UPP主机日期
    ,o.hostnbr -- UPP主机流水
    ,o.status -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-UPP超时
    ,o.cdflg -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
    ,o.finalstatus -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
    ,o.tzflg -- 交易标志：0-联机交易，1-调账交易
    ,o.isnotesuccess -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
    ,o.payresultnotetime -- 购买订单支付结果通知的时间（自然日）
    ,o.successamount -- 已成功金额
    ,o.successshare -- 已成功份额
    ,o.cdsystrace -- 撤单中台流水号
    ,o.cdsystime -- 撤单时间
    ,o.checkflag -- 对账标志 是否已对账：N:否(初始)，Y：是
    ,o.noteflag -- 通知标志位 N未知 F失败 S成功
    ,o.notenum -- 通知次数
    ,o.updatetime -- 最新更新时间
    ,o.remark1 -- 确认文件对账状态
    ,o.remark2 -- 
    ,o.remark3 -- 
    ,o.remark4 -- 
    ,o.remark5 -- 
    ,o.remark6 -- 
    ,o.rspcd -- 错误码
    ,o.rspmsg -- 错误信息
    ,o.orderstat -- 0-处理中；1-委托失败；2-委托成功，待TA确认；9-已撤单
    ,o.destfundcode -- 转换目标基金代码
    ,o.destfundname -- 转换目标基金名称
    ,o.isriskconfirmhigh -- 最高风险购买确认
    ,o.isriskconfirmagain -- 二次确认
    ,o.terminalip -- 终端IP地址
    ,o.terminaltype -- 终端类型
    ,o.terminalinfo -- 终端相关信息
    ,o.srcglobseqno -- 全局流水号
    ,o.unique_seq_num -- 业务流水号
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
from ${iol_schema}.mpcs_a92ordertrans_bk o
    left join ${iol_schema}.mpcs_a92ordertrans_op n
        on
            o.brokerorderno = n.brokerorderno
            and o.transtime = n.transtime
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a92ordertrans_cl d
        on
            o.brokerorderno = d.brokerorderno
            and o.transtime = d.transtime
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a92ordertrans;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a92ordertrans') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a92ordertrans drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a92ordertrans add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a92ordertrans exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a92ordertrans_cl;
alter table ${iol_schema}.mpcs_a92ordertrans exchange partition p_20991231 with table ${iol_schema}.mpcs_a92ordertrans_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92ordertrans to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92ordertrans_op purge;
drop table ${iol_schema}.mpcs_a92ordertrans_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92ordertrans_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92ordertrans',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
