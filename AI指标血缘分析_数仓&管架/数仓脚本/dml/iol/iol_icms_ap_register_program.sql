/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_register_program
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
create table ${iol_schema}.icms_ap_register_program_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_register_program
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_register_program_op purge;
drop table ${iol_schema}.icms_ap_register_program_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_register_program_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_register_program where 0=1;

create table ${iol_schema}.icms_ap_register_program_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_register_program where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_register_program_cl(
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,counterpartyacctcerttype -- 交易对手证件类型
            ,counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_register_program_op(
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,counterpartyacctcerttype -- 交易对手证件类型
            ,counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.programname, o.programname) as programname -- 方案名称
    ,nvl(n.customername, o.customername) as customername -- 方案涉及借款人
    ,nvl(n.handletype, o.handletype) as handletype -- 处置类型（不良资产转让）
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额合计
    ,nvl(n.balancesum, o.balancesum) as balancesum -- 合同余额合计
    ,nvl(n.receiveamonut, o.receiveamonut) as receiveamonut -- 财务应收款
    ,nvl(n.oninterestsum, o.oninterestsum) as oninterestsum -- 表外利息余额合计
    ,nvl(n.outinterestsum, o.outinterestsum) as outinterestsum -- 表外利息余额合计
    ,nvl(n.pecuniacreditasum, o.pecuniacreditasum) as pecuniacreditasum -- 债权金额合计
    ,nvl(n.transferprice, o.transferprice) as transferprice -- 转让价格
    ,nvl(n.payreceiveamonut, o.payreceiveamonut) as payreceiveamonut -- 偿还财务应收款
    ,nvl(n.paylowamonut, o.paylowamonut) as paylowamonut -- 偿还法律应收款
    ,nvl(n.paylowcost, o.paylowcost) as paylowcost -- 偿还法律性费用
    ,nvl(n.paysum, o.paysum) as paysum -- 偿还本金
    ,nvl(n.payinterest, o.payinterest) as payinterest -- 偿还利息
    ,nvl(n.transferway, o.transferway) as transferway -- 债权转让方式一（CD060034）
    ,nvl(n.othertransferway, o.othertransferway) as othertransferway -- 债权转让方式二（CD060035）
    ,nvl(n.respinvestigationdate, o.respinvestigationdate) as respinvestigationdate -- 卖方尽职调查基准日
    ,nvl(n.respinvestigationorg, o.respinvestigationorg) as respinvestigationorg -- 卖方尽职调查中介机构名称
    ,nvl(n.vendeename, o.vendeename) as vendeename -- 买受人名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.litigationphasecost, o.litigationphasecost) as litigationphasecost -- 诉讼阶段法律性费用（元）
    ,nvl(n.cancelaccountcapbaldepos, o.cancelaccountcapbaldepos) as cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
    ,nvl(n.cancelaccountcapinowebalance, o.cancelaccountcapinowebalance) as cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
    ,nvl(n.cancelaccountcapoutowebalance, o.cancelaccountcapoutowebalance) as cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
    ,nvl(n.summarize, o.summarize) as summarize -- 方案综述
    ,nvl(n.riskassetlist, o.riskassetlist) as riskassetlist -- 风险资产清单
    ,nvl(n.saveflag, o.saveflag) as saveflag -- 保存标志
    ,nvl(n.executestatus, o.executestatus) as executestatus -- 执行状态(CodeNo:ExecuteResult)
    ,nvl(n.packagedate, o.packagedate) as packagedate -- 封包日期
    ,nvl(n.transferflag, o.transferflag) as transferflag -- 转让标志(CodeNo:TransferFlag)
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.transferorg, o.transferorg) as transferorg -- 变更后机构
    ,nvl(n.agentlegalfee, o.agentlegalfee) as agentlegalfee -- 代垫诉讼费
    ,nvl(n.repaymode, o.repaymode) as repaymode -- 付款方式（一次性付款、分期付款）
    ,nvl(n.downpayment, o.downpayment) as downpayment -- 首付金额
    ,nvl(n.onaccountno, o.onaccountno) as onaccountno -- 挂账编号
    ,nvl(n.transcontractno, o.transcontractno) as transcontractno -- 转让合同号
    ,nvl(n.counterpartyacctname, o.counterpartyacctname) as counterpartyacctname -- 交易对手名称
    ,nvl(n.counterpartyacct, o.counterpartyacct) as counterpartyacct -- 交易对手账号
    ,nvl(n.openbankname, o.openbankname) as openbankname -- 交易对手开户行名称
    ,nvl(n.openbankno, o.openbankno) as openbankno -- 交易对手开户行行号
    ,nvl(n.counterpartyaccttype, o.counterpartyaccttype) as counterpartyaccttype -- 交易对手类型
    ,nvl(n.transcontractstartdate, o.transcontractstartdate) as transcontractstartdate -- 转让合同起始日期
    ,nvl(n.transcontractenddate, o.transcontractenddate) as transcontractenddate -- 转让合同到期日期
    ,nvl(n.transtradplatform, o.transtradplatform) as transtradplatform -- 转让交易平台
    ,nvl(n.transtradplatformcus, o.transtradplatformcus) as transtradplatformcus -- 转让交易平台（自定义）
    ,nvl(n.counterpartypaydate, o.counterpartypaydate) as counterpartypaydate -- 交易对手转账日期
    ,nvl(n.isaddrec, o.isaddrec) as isaddrec -- 是否补录
    ,nvl(n.counterpartyacctcerttype, o.counterpartyacctcerttype) as counterpartyacctcerttype -- 交易对手证件类型
    ,nvl(n.counterpartyacctcertid, o.counterpartyacctcertid) as counterpartyacctcertid -- 交易对手证件号码
    ,case when
            n.serialno is null
            and n.programno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
            and n.programno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
            and n.programno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_register_program_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_register_program where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
            and o.programno = n.programno
where (
        o.serialno is null
        and o.programno is null
    )
    or (
        n.serialno is null
        and n.programno is null
    )
    or (
        o.programname <> n.programname
        or o.customername <> n.customername
        or o.handletype <> n.handletype
        or o.businesssum <> n.businesssum
        or o.balancesum <> n.balancesum
        or o.receiveamonut <> n.receiveamonut
        or o.oninterestsum <> n.oninterestsum
        or o.outinterestsum <> n.outinterestsum
        or o.pecuniacreditasum <> n.pecuniacreditasum
        or o.transferprice <> n.transferprice
        or o.payreceiveamonut <> n.payreceiveamonut
        or o.paylowamonut <> n.paylowamonut
        or o.paylowcost <> n.paylowcost
        or o.paysum <> n.paysum
        or o.payinterest <> n.payinterest
        or o.transferway <> n.transferway
        or o.othertransferway <> n.othertransferway
        or o.respinvestigationdate <> n.respinvestigationdate
        or o.respinvestigationorg <> n.respinvestigationorg
        or o.vendeename <> n.vendeename
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updatedate <> n.updatedate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.litigationphasecost <> n.litigationphasecost
        or o.cancelaccountcapbaldepos <> n.cancelaccountcapbaldepos
        or o.cancelaccountcapinowebalance <> n.cancelaccountcapinowebalance
        or o.cancelaccountcapoutowebalance <> n.cancelaccountcapoutowebalance
        or o.summarize <> n.summarize
        or o.riskassetlist <> n.riskassetlist
        or o.saveflag <> n.saveflag
        or o.executestatus <> n.executestatus
        or o.packagedate <> n.packagedate
        or o.transferflag <> n.transferflag
        or o.currency <> n.currency
        or o.transferorg <> n.transferorg
        or o.agentlegalfee <> n.agentlegalfee
        or o.repaymode <> n.repaymode
        or o.downpayment <> n.downpayment
        or o.onaccountno <> n.onaccountno
        or o.transcontractno <> n.transcontractno
        or o.counterpartyacctname <> n.counterpartyacctname
        or o.counterpartyacct <> n.counterpartyacct
        or o.openbankname <> n.openbankname
        or o.openbankno <> n.openbankno
        or o.counterpartyaccttype <> n.counterpartyaccttype
        or o.transcontractstartdate <> n.transcontractstartdate
        or o.transcontractenddate <> n.transcontractenddate
        or o.transtradplatform <> n.transtradplatform
        or o.transtradplatformcus <> n.transtradplatformcus
        or o.counterpartypaydate <> n.counterpartypaydate
        or o.isaddrec <> n.isaddrec
        or o.counterpartyacctcerttype <> n.counterpartyacctcerttype
        or o.counterpartyacctcertid <> n.counterpartyacctcertid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_register_program_cl(
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,counterpartyacctcerttype -- 交易对手证件类型
            ,counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_register_program_op(
            serialno -- 流水号
            ,programno -- 方案编号
            ,programname -- 方案名称
            ,customername -- 方案涉及借款人
            ,handletype -- 处置类型（不良资产转让）
            ,businesssum -- 合同金额合计
            ,balancesum -- 合同余额合计
            ,receiveamonut -- 财务应收款
            ,oninterestsum -- 表外利息余额合计
            ,outinterestsum -- 表外利息余额合计
            ,pecuniacreditasum -- 债权金额合计
            ,transferprice -- 转让价格
            ,payreceiveamonut -- 偿还财务应收款
            ,paylowamonut -- 偿还法律应收款
            ,paylowcost -- 偿还法律性费用
            ,paysum -- 偿还本金
            ,payinterest -- 偿还利息
            ,transferway -- 债权转让方式一（CD060034）
            ,othertransferway -- 债权转让方式二（CD060035）
            ,respinvestigationdate -- 卖方尽职调查基准日
            ,respinvestigationorg -- 卖方尽职调查中介机构名称
            ,vendeename -- 买受人名称
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updatedate -- 更新日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,litigationphasecost -- 诉讼阶段法律性费用（元）
            ,cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
            ,cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
            ,cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
            ,summarize -- 方案综述
            ,riskassetlist -- 风险资产清单
            ,saveflag -- 保存标志
            ,executestatus -- 执行状态(CodeNo:ExecuteResult)
            ,packagedate -- 封包日期
            ,transferflag -- 转让标志(CodeNo:TransferFlag)
            ,currency -- 币种
            ,transferorg -- 变更后机构
            ,agentlegalfee -- 代垫诉讼费
            ,repaymode -- 付款方式（一次性付款、分期付款）
            ,downpayment -- 首付金额
            ,onaccountno -- 挂账编号
            ,transcontractno -- 转让合同号
            ,counterpartyacctname -- 交易对手名称
            ,counterpartyacct -- 交易对手账号
            ,openbankname -- 交易对手开户行名称
            ,openbankno -- 交易对手开户行行号
            ,counterpartyaccttype -- 交易对手类型
            ,transcontractstartdate -- 转让合同起始日期
            ,transcontractenddate -- 转让合同到期日期
            ,transtradplatform -- 转让交易平台
            ,transtradplatformcus -- 转让交易平台（自定义）
            ,counterpartypaydate -- 交易对手转账日期
            ,isaddrec -- 是否补录
            ,counterpartyacctcerttype -- 交易对手证件类型
            ,counterpartyacctcertid -- 交易对手证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.programno -- 方案编号
    ,o.programname -- 方案名称
    ,o.customername -- 方案涉及借款人
    ,o.handletype -- 处置类型（不良资产转让）
    ,o.businesssum -- 合同金额合计
    ,o.balancesum -- 合同余额合计
    ,o.receiveamonut -- 财务应收款
    ,o.oninterestsum -- 表外利息余额合计
    ,o.outinterestsum -- 表外利息余额合计
    ,o.pecuniacreditasum -- 债权金额合计
    ,o.transferprice -- 转让价格
    ,o.payreceiveamonut -- 偿还财务应收款
    ,o.paylowamonut -- 偿还法律应收款
    ,o.paylowcost -- 偿还法律性费用
    ,o.paysum -- 偿还本金
    ,o.payinterest -- 偿还利息
    ,o.transferway -- 债权转让方式一（CD060034）
    ,o.othertransferway -- 债权转让方式二（CD060035）
    ,o.respinvestigationdate -- 卖方尽职调查基准日
    ,o.respinvestigationorg -- 卖方尽职调查中介机构名称
    ,o.vendeename -- 买受人名称
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updatedate -- 更新日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.litigationphasecost -- 诉讼阶段法律性费用（元）
    ,o.cancelaccountcapbaldepos -- 账销案存资产本金余额（元）
    ,o.cancelaccountcapinowebalance -- 账销案存资产表内欠息余额（元）
    ,o.cancelaccountcapoutowebalance -- 账销案存资产表外欠息余额（元）
    ,o.summarize -- 方案综述
    ,o.riskassetlist -- 风险资产清单
    ,o.saveflag -- 保存标志
    ,o.executestatus -- 执行状态(CodeNo:ExecuteResult)
    ,o.packagedate -- 封包日期
    ,o.transferflag -- 转让标志(CodeNo:TransferFlag)
    ,o.currency -- 币种
    ,o.transferorg -- 变更后机构
    ,o.agentlegalfee -- 代垫诉讼费
    ,o.repaymode -- 付款方式（一次性付款、分期付款）
    ,o.downpayment -- 首付金额
    ,o.onaccountno -- 挂账编号
    ,o.transcontractno -- 转让合同号
    ,o.counterpartyacctname -- 交易对手名称
    ,o.counterpartyacct -- 交易对手账号
    ,o.openbankname -- 交易对手开户行名称
    ,o.openbankno -- 交易对手开户行行号
    ,o.counterpartyaccttype -- 交易对手类型
    ,o.transcontractstartdate -- 转让合同起始日期
    ,o.transcontractenddate -- 转让合同到期日期
    ,o.transtradplatform -- 转让交易平台
    ,o.transtradplatformcus -- 转让交易平台（自定义）
    ,o.counterpartypaydate -- 交易对手转账日期
    ,o.isaddrec -- 是否补录
    ,o.counterpartyacctcerttype -- 交易对手证件类型
    ,o.counterpartyacctcertid -- 交易对手证件号码
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
from ${iol_schema}.icms_ap_register_program_bk o
    left join ${iol_schema}.icms_ap_register_program_op n
        on
            o.serialno = n.serialno
            and o.programno = n.programno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_register_program_cl d
        on
            o.serialno = d.serialno
            and o.programno = d.programno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_register_program;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_register_program') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_register_program drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_register_program add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_register_program exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_register_program_cl;
alter table ${iol_schema}.icms_ap_register_program exchange partition p_20991231 with table ${iol_schema}.icms_ap_register_program_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_register_program to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_register_program_op purge;
drop table ${iol_schema}.icms_ap_register_program_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_register_program_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_register_program',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
