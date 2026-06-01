/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_xxd_loanapply_online
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
create table ${iol_schema}.icms_xxd_loanapply_online_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_xxd_loanapply_online
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_xxd_loanapply_online_op purge;
drop table ${iol_schema}.icms_xxd_loanapply_online_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_xxd_loanapply_online_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_xxd_loanapply_online where 0=1;

create table ${iol_schema}.icms_xxd_loanapply_online_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_xxd_loanapply_online where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_xxd_loanapply_online_cl(
            serialno -- 流水号
            ,baserialno -- 授信申请流水号
            ,lmtcontractno -- 额度合同编号
            ,loancontractno -- 借款合同编号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,putouttype -- 提款方式(01--线上提款,02--线下提款)
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customername -- 客户名称
            ,customerid -- 客户号
            ,applyamt -- 申请金额（单位:元）
            ,loanterm -- 申请期数（单位:月）
            ,loanpurpose -- 申请贷款用途
            ,concretepurpose -- 具体用途
            ,repaytype -- 还款方式
            ,applydate -- 申请日期
            ,startdate -- 起始日
            ,enddate -- 到期日
            ,executerate -- 执行利率
            ,rateadd -- 利率加点(%)
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
            ,approvestatus -- 审批状态
            ,channel -- 渠道
            ,customermanagerno -- 客户经理编号
            ,belongorgid -- 所属分行
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,applyno -- 申请流水号（前端业务流水号）
            ,putoutstatus -- 用信状态
            ,payaccount -- 还款账号
            ,payaccountname -- 还款账号姓名
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 客户来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,istimeoutrefuse -- 是否超时拒绝
            ,reason -- 原因
            ,ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
            ,mqrisksendtime -- 发送风控时间
            ,iscollectcredit -- 征信查询情况
            ,finalapplyamount -- 终审审批额度(元)
            ,apprendtime -- 审批结束时间
            ,manualapproval -- 是否人工审批标识
            ,failreason -- 拒绝原因
            ,warninginfo -- 预警信息
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分分值
            ,roomprice -- 评估价值
            ,approvedamt -- 风控审批可用金额
            ,artificialno -- 文本合同编号
            ,paymenttype -- 支付方式 (1-受托支付，2-自主支付)
            ,entryaccount -- 入账账号
            ,entryaccountname -- 入账账号姓名
            ,riskstatus -- 风控状态
            ,imagebatchno -- 影像批次号
            ,orderno -- 订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_xxd_loanapply_online_op(
            serialno -- 流水号
            ,baserialno -- 授信申请流水号
            ,lmtcontractno -- 额度合同编号
            ,loancontractno -- 借款合同编号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,putouttype -- 提款方式(01--线上提款,02--线下提款)
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customername -- 客户名称
            ,customerid -- 客户号
            ,applyamt -- 申请金额（单位:元）
            ,loanterm -- 申请期数（单位:月）
            ,loanpurpose -- 申请贷款用途
            ,concretepurpose -- 具体用途
            ,repaytype -- 还款方式
            ,applydate -- 申请日期
            ,startdate -- 起始日
            ,enddate -- 到期日
            ,executerate -- 执行利率
            ,rateadd -- 利率加点(%)
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
            ,approvestatus -- 审批状态
            ,channel -- 渠道
            ,customermanagerno -- 客户经理编号
            ,belongorgid -- 所属分行
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,applyno -- 申请流水号（前端业务流水号）
            ,putoutstatus -- 用信状态
            ,payaccount -- 还款账号
            ,payaccountname -- 还款账号姓名
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 客户来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,istimeoutrefuse -- 是否超时拒绝
            ,reason -- 原因
            ,ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
            ,mqrisksendtime -- 发送风控时间
            ,iscollectcredit -- 征信查询情况
            ,finalapplyamount -- 终审审批额度(元)
            ,apprendtime -- 审批结束时间
            ,manualapproval -- 是否人工审批标识
            ,failreason -- 拒绝原因
            ,warninginfo -- 预警信息
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分分值
            ,roomprice -- 评估价值
            ,approvedamt -- 风控审批可用金额
            ,artificialno -- 文本合同编号
            ,paymenttype -- 支付方式 (1-受托支付，2-自主支付)
            ,entryaccount -- 入账账号
            ,entryaccountname -- 入账账号姓名
            ,riskstatus -- 风控状态
            ,imagebatchno -- 影像批次号
            ,orderno -- 订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.baserialno, o.baserialno) as baserialno -- 授信申请流水号
    ,nvl(n.lmtcontractno, o.lmtcontractno) as lmtcontractno -- 额度合同编号
    ,nvl(n.loancontractno, o.loancontractno) as loancontractno -- 借款合同编号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.putouttype, o.putouttype) as putouttype -- 提款方式(01--线上提款,02--线下提款)
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.applyamt, o.applyamt) as applyamt -- 申请金额（单位:元）
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 申请期数（单位:月）
    ,nvl(n.loanpurpose, o.loanpurpose) as loanpurpose -- 申请贷款用途
    ,nvl(n.concretepurpose, o.concretepurpose) as concretepurpose -- 具体用途
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款方式
    ,nvl(n.applydate, o.applydate) as applydate -- 申请日期
    ,nvl(n.startdate, o.startdate) as startdate -- 起始日
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日
    ,nvl(n.executerate, o.executerate) as executerate -- 执行利率
    ,nvl(n.rateadd, o.rateadd) as rateadd -- 利率加点(%)
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.incomingcode, o.incomingcode) as incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.customermanagerno, o.customermanagerno) as customermanagerno -- 客户经理编号
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 所属分行
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.applyno, o.applyno) as applyno -- 申请流水号（前端业务流水号）
    ,nvl(n.putoutstatus, o.putoutstatus) as putoutstatus -- 用信状态
    ,nvl(n.payaccount, o.payaccount) as payaccount -- 还款账号
    ,nvl(n.payaccountname, o.payaccountname) as payaccountname -- 还款账号姓名
    ,nvl(n.qryusertype, o.qryusertype) as qryusertype -- 征信查询人类型
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 征信查询操作申请类型
    ,nvl(n.partner, o.partner) as partner -- 客户来源
    ,nvl(n.reportusernm, o.reportusernm) as reportusernm -- 报告使用人姓名
    ,nvl(n.reportuseroff, o.reportuseroff) as reportuseroff -- 报告使用人所属部门
    ,nvl(n.istimeoutrefuse, o.istimeoutrefuse) as istimeoutrefuse -- 是否超时拒绝
    ,nvl(n.reason, o.reason) as reason -- 原因
    ,nvl(n.ismqrisk, o.ismqrisk) as ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
    ,nvl(n.mqrisksendtime, o.mqrisksendtime) as mqrisksendtime -- 发送风控时间
    ,nvl(n.iscollectcredit, o.iscollectcredit) as iscollectcredit -- 征信查询情况
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 终审审批额度(元)
    ,nvl(n.apprendtime, o.apprendtime) as apprendtime -- 审批结束时间
    ,nvl(n.manualapproval, o.manualapproval) as manualapproval -- 是否人工审批标识
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.warninginfo, o.warninginfo) as warninginfo -- 预警信息
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联人
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分分值
    ,nvl(n.roomprice, o.roomprice) as roomprice -- 评估价值
    ,nvl(n.approvedamt, o.approvedamt) as approvedamt -- 风控审批可用金额
    ,nvl(n.artificialno, o.artificialno) as artificialno -- 文本合同编号
    ,nvl(n.paymenttype, o.paymenttype) as paymenttype -- 支付方式 (1-受托支付，2-自主支付)
    ,nvl(n.entryaccount, o.entryaccount) as entryaccount -- 入账账号
    ,nvl(n.entryaccountname, o.entryaccountname) as entryaccountname -- 入账账号姓名
    ,nvl(n.riskstatus, o.riskstatus) as riskstatus -- 风控状态
    ,nvl(n.imagebatchno, o.imagebatchno) as imagebatchno -- 影像批次号
    ,nvl(n.orderno, o.orderno) as orderno -- 订单号
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
from (select * from ${iol_schema}.icms_xxd_loanapply_online_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_xxd_loanapply_online where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.lmtcontractno <> n.lmtcontractno
        or o.loancontractno <> n.loancontractno
        or o.prdcode <> n.prdcode
        or o.prdname <> n.prdname
        or o.putouttype <> n.putouttype
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.customername <> n.customername
        or o.customerid <> n.customerid
        or o.applyamt <> n.applyamt
        or o.loanterm <> n.loanterm
        or o.loanpurpose <> n.loanpurpose
        or o.concretepurpose <> n.concretepurpose
        or o.repaytype <> n.repaytype
        or o.applydate <> n.applydate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.executerate <> n.executerate
        or o.rateadd <> n.rateadd
        or o.authotype <> n.authotype
        or o.biometrics <> n.biometrics
        or o.authotime <> n.authotime
        or o.authostrdate <> n.authostrdate
        or o.authoenddate <> n.authoenddate
        or o.incomingcode <> n.incomingcode
        or o.approvestatus <> n.approvestatus
        or o.channel <> n.channel
        or o.customermanagerno <> n.customermanagerno
        or o.belongorgid <> n.belongorgid
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.applyno <> n.applyno
        or o.putoutstatus <> n.putoutstatus
        or o.payaccount <> n.payaccount
        or o.payaccountname <> n.payaccountname
        or o.qryusertype <> n.qryusertype
        or o.qryopertp <> n.qryopertp
        or o.partner <> n.partner
        or o.reportusernm <> n.reportusernm
        or o.reportuseroff <> n.reportuseroff
        or o.istimeoutrefuse <> n.istimeoutrefuse
        or o.reason <> n.reason
        or o.ismqrisk <> n.ismqrisk
        or o.mqrisksendtime <> n.mqrisksendtime
        or o.iscollectcredit <> n.iscollectcredit
        or o.finalapplyamount <> n.finalapplyamount
        or o.apprendtime <> n.apprendtime
        or o.manualapproval <> n.manualapproval
        or o.failreason <> n.failreason
        or o.warninginfo <> n.warninginfo
        or o.isbankrel <> n.isbankrel
        or o.autoscore <> n.autoscore
        or o.roomprice <> n.roomprice
        or o.approvedamt <> n.approvedamt
        or o.artificialno <> n.artificialno
        or o.paymenttype <> n.paymenttype
        or o.entryaccount <> n.entryaccount
        or o.entryaccountname <> n.entryaccountname
        or o.riskstatus <> n.riskstatus
        or o.imagebatchno <> n.imagebatchno
        or o.orderno <> n.orderno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_xxd_loanapply_online_cl(
            serialno -- 流水号
            ,baserialno -- 授信申请流水号
            ,lmtcontractno -- 额度合同编号
            ,loancontractno -- 借款合同编号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,putouttype -- 提款方式(01--线上提款,02--线下提款)
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customername -- 客户名称
            ,customerid -- 客户号
            ,applyamt -- 申请金额（单位:元）
            ,loanterm -- 申请期数（单位:月）
            ,loanpurpose -- 申请贷款用途
            ,concretepurpose -- 具体用途
            ,repaytype -- 还款方式
            ,applydate -- 申请日期
            ,startdate -- 起始日
            ,enddate -- 到期日
            ,executerate -- 执行利率
            ,rateadd -- 利率加点(%)
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
            ,approvestatus -- 审批状态
            ,channel -- 渠道
            ,customermanagerno -- 客户经理编号
            ,belongorgid -- 所属分行
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,applyno -- 申请流水号（前端业务流水号）
            ,putoutstatus -- 用信状态
            ,payaccount -- 还款账号
            ,payaccountname -- 还款账号姓名
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 客户来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,istimeoutrefuse -- 是否超时拒绝
            ,reason -- 原因
            ,ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
            ,mqrisksendtime -- 发送风控时间
            ,iscollectcredit -- 征信查询情况
            ,finalapplyamount -- 终审审批额度(元)
            ,apprendtime -- 审批结束时间
            ,manualapproval -- 是否人工审批标识
            ,failreason -- 拒绝原因
            ,warninginfo -- 预警信息
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分分值
            ,roomprice -- 评估价值
            ,approvedamt -- 风控审批可用金额
            ,artificialno -- 文本合同编号
            ,paymenttype -- 支付方式 (1-受托支付，2-自主支付)
            ,entryaccount -- 入账账号
            ,entryaccountname -- 入账账号姓名
            ,riskstatus -- 风控状态
            ,imagebatchno -- 影像批次号
            ,orderno -- 订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_xxd_loanapply_online_op(
            serialno -- 流水号
            ,baserialno -- 授信申请流水号
            ,lmtcontractno -- 额度合同编号
            ,loancontractno -- 借款合同编号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,putouttype -- 提款方式(01--线上提款,02--线下提款)
            ,certtype -- 证件类型
            ,certid -- 证件编号
            ,customername -- 客户名称
            ,customerid -- 客户号
            ,applyamt -- 申请金额（单位:元）
            ,loanterm -- 申请期数（单位:月）
            ,loanpurpose -- 申请贷款用途
            ,concretepurpose -- 具体用途
            ,repaytype -- 还款方式
            ,applydate -- 申请日期
            ,startdate -- 起始日
            ,enddate -- 到期日
            ,executerate -- 执行利率
            ,rateadd -- 利率加点(%)
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
            ,approvestatus -- 审批状态
            ,channel -- 渠道
            ,customermanagerno -- 客户经理编号
            ,belongorgid -- 所属分行
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,applyno -- 申请流水号（前端业务流水号）
            ,putoutstatus -- 用信状态
            ,payaccount -- 还款账号
            ,payaccountname -- 还款账号姓名
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 客户来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,istimeoutrefuse -- 是否超时拒绝
            ,reason -- 原因
            ,ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
            ,mqrisksendtime -- 发送风控时间
            ,iscollectcredit -- 征信查询情况
            ,finalapplyamount -- 终审审批额度(元)
            ,apprendtime -- 审批结束时间
            ,manualapproval -- 是否人工审批标识
            ,failreason -- 拒绝原因
            ,warninginfo -- 预警信息
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分分值
            ,roomprice -- 评估价值
            ,approvedamt -- 风控审批可用金额
            ,artificialno -- 文本合同编号
            ,paymenttype -- 支付方式 (1-受托支付，2-自主支付)
            ,entryaccount -- 入账账号
            ,entryaccountname -- 入账账号姓名
            ,riskstatus -- 风控状态
            ,imagebatchno -- 影像批次号
            ,orderno -- 订单号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.baserialno -- 授信申请流水号
    ,o.lmtcontractno -- 额度合同编号
    ,o.loancontractno -- 借款合同编号
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.putouttype -- 提款方式(01--线上提款,02--线下提款)
    ,o.certtype -- 证件类型
    ,o.certid -- 证件编号
    ,o.customername -- 客户名称
    ,o.customerid -- 客户号
    ,o.applyamt -- 申请金额（单位:元）
    ,o.loanterm -- 申请期数（单位:月）
    ,o.loanpurpose -- 申请贷款用途
    ,o.concretepurpose -- 具体用途
    ,o.repaytype -- 还款方式
    ,o.applydate -- 申请日期
    ,o.startdate -- 起始日
    ,o.enddate -- 到期日
    ,o.executerate -- 执行利率
    ,o.rateadd -- 利率加点(%)
    ,o.authotype -- 授权方式
    ,o.biometrics -- 生物识别技术
    ,o.authotime -- 授权时间
    ,o.authostrdate -- 授权开始时间
    ,o.authoenddate -- 授权结束时间
    ,o.incomingcode -- 进件模式（0：团购企业模式 1：战略客户模式）
    ,o.approvestatus -- 审批状态
    ,o.channel -- 渠道
    ,o.customermanagerno -- 客户经理编号
    ,o.belongorgid -- 所属分行
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.applyno -- 申请流水号（前端业务流水号）
    ,o.putoutstatus -- 用信状态
    ,o.payaccount -- 还款账号
    ,o.payaccountname -- 还款账号姓名
    ,o.qryusertype -- 征信查询人类型
    ,o.qryopertp -- 征信查询操作申请类型
    ,o.partner -- 客户来源
    ,o.reportusernm -- 报告使用人姓名
    ,o.reportuseroff -- 报告使用人所属部门
    ,o.istimeoutrefuse -- 是否超时拒绝
    ,o.reason -- 原因
    ,o.ismqrisk -- 是否风控中（0--未发送,1--风控中，2--风控完成）
    ,o.mqrisksendtime -- 发送风控时间
    ,o.iscollectcredit -- 征信查询情况
    ,o.finalapplyamount -- 终审审批额度(元)
    ,o.apprendtime -- 审批结束时间
    ,o.manualapproval -- 是否人工审批标识
    ,o.failreason -- 拒绝原因
    ,o.warninginfo -- 预警信息
    ,o.isbankrel -- 是否我行关联人
    ,o.autoscore -- 评分分值
    ,o.roomprice -- 评估价值
    ,o.approvedamt -- 风控审批可用金额
    ,o.artificialno -- 文本合同编号
    ,o.paymenttype -- 支付方式 (1-受托支付，2-自主支付)
    ,o.entryaccount -- 入账账号
    ,o.entryaccountname -- 入账账号姓名
    ,o.riskstatus -- 风控状态
    ,o.imagebatchno -- 影像批次号
    ,o.orderno -- 订单号
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
from ${iol_schema}.icms_xxd_loanapply_online_bk o
    left join ${iol_schema}.icms_xxd_loanapply_online_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_xxd_loanapply_online_cl d
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
--truncate table ${iol_schema}.icms_xxd_loanapply_online;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_xxd_loanapply_online') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_xxd_loanapply_online drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_xxd_loanapply_online add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_xxd_loanapply_online exchange partition p_${batch_date} with table ${iol_schema}.icms_xxd_loanapply_online_cl;
alter table ${iol_schema}.icms_xxd_loanapply_online exchange partition p_20991231 with table ${iol_schema}.icms_xxd_loanapply_online_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_xxd_loanapply_online to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_xxd_loanapply_online_op purge;
drop table ${iol_schema}.icms_xxd_loanapply_online_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_xxd_loanapply_online_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_xxd_loanapply_online',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
