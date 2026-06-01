/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_inv_pid_invcwallets
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
create table ${iol_schema}.iers_inv_pid_invcwallets_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_inv_pid_invcwallets
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_inv_pid_invcwallets_op purge;
drop table ${iol_schema}.iers_inv_pid_invcwallets_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_inv_pid_invcwallets_op nologging
for exchange with table
${iol_schema}.iers_inv_pid_invcwallets;

create table ${iol_schema}.iers_inv_pid_invcwallets_cl nologging
for exchange with table
${iol_schema}.iers_inv_pid_invcwallets;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_inv_pid_invcwallets_cl(
            pk_invcwallets -- 
            ,dr -- 
            ,ts -- 
            ,creator -- 录入人
            ,creationtime -- 采集日期
            ,invctype -- 发票类型
            ,srcsystem -- 来源系统
            ,collectmode -- 采集方式
            ,totallev -- 含税金额合计
            ,totalamt -- 不含税金额合计
            ,taxrate -- 税率
            ,totaltax -- 税额合计
            ,totallevbal -- 含税金额合计余额
            ,totaltaxbal -- 发票税额余额
            ,bxstate -- 报销状态
            ,checkstate -- 查验状态
            ,sealspecial -- 发票专用章
            ,sealprod -- 发票监制章
            ,invcurl -- 发票地址
            ,filename -- 附件名
            ,invcdate -- 开票日期
            ,salename -- 销方名称
            ,saletaxno -- 销方税号
            ,saleaddress -- 销方地址、电话
            ,salebank -- 销方开户行及账号
            ,buyname -- 购方名称
            ,buytaxno -- 购方税号
            ,buyaddress -- 购方地址、电话
            ,buybank -- 购方开户行及账号
            ,invcode -- 发票代码
            ,invcno -- 发票号码
            ,chkcode -- 校验码
            ,machcode -- 机器编码
            ,drawer -- 开票人
            ,receiptor -- 收款人
            ,reviewer -- 复核人
            ,remark -- 备注
            ,custname -- 旅客姓名
            ,custidno -- 身份证号码
            ,fromaddr -- 出发地
            ,toaddr -- 目的地
            ,tripcode -- 航班号/车次
            ,startime -- 时间
            ,endtime -- 结束时间
            ,cca_devfund -- 民航发展基金
            ,fuelsrchrg -- 燃油附加费
            ,otherfees -- 其他税费
            ,insurance -- 保险费
            ,seatno -- 座位
            ,seatrank -- 座位等级
            ,price -- 单价
            ,mileage -- 里程数
            ,transfertax -- 转出税额
            ,amt -- 票价
            ,airstate -- 票号状态
            ,category -- 种类
            ,ticketbagid -- 票袋主键
            ,accountno -- 对账单号
            ,billperiod -- 账期
            ,doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
            ,doubtreasons -- 疑票原因
            ,billtype -- 票种类型
            ,taxperiod -- 税款所属期
            ,tick -- 是否勾选
            ,tickdate -- 勾选日期
            ,tickmethod -- 勾选方式
            ,authstatus -- 认证状态
            ,authfailurereason -- 认证失败原因
            ,authdate -- 认证日期
            ,effectivededuction -- 有效抵扣额
            ,def2 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def20 -- 
            ,invcid -- 提供友报账专用主键
            ,createtime -- 创建时间
            ,updatetime -- 修改时间
            ,invcnoprint -- 打印发票号码
            ,pk_org -- 组织编码
            ,carrystatus -- 结转状态
            ,carrydate -- 结转日期
            ,carryno -- 结转凭证号
            ,tickresult -- 勾选结果
            ,authresult -- 认证结果
            ,castatus -- 记账状态
            ,authmethod -- 认证方式
            ,tagid -- 
            ,reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
            ,reimbursementbalance -- 报销余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_inv_pid_invcwallets_op(
            pk_invcwallets -- 
            ,dr -- 
            ,ts -- 
            ,creator -- 录入人
            ,creationtime -- 采集日期
            ,invctype -- 发票类型
            ,srcsystem -- 来源系统
            ,collectmode -- 采集方式
            ,totallev -- 含税金额合计
            ,totalamt -- 不含税金额合计
            ,taxrate -- 税率
            ,totaltax -- 税额合计
            ,totallevbal -- 含税金额合计余额
            ,totaltaxbal -- 发票税额余额
            ,bxstate -- 报销状态
            ,checkstate -- 查验状态
            ,sealspecial -- 发票专用章
            ,sealprod -- 发票监制章
            ,invcurl -- 发票地址
            ,filename -- 附件名
            ,invcdate -- 开票日期
            ,salename -- 销方名称
            ,saletaxno -- 销方税号
            ,saleaddress -- 销方地址、电话
            ,salebank -- 销方开户行及账号
            ,buyname -- 购方名称
            ,buytaxno -- 购方税号
            ,buyaddress -- 购方地址、电话
            ,buybank -- 购方开户行及账号
            ,invcode -- 发票代码
            ,invcno -- 发票号码
            ,chkcode -- 校验码
            ,machcode -- 机器编码
            ,drawer -- 开票人
            ,receiptor -- 收款人
            ,reviewer -- 复核人
            ,remark -- 备注
            ,custname -- 旅客姓名
            ,custidno -- 身份证号码
            ,fromaddr -- 出发地
            ,toaddr -- 目的地
            ,tripcode -- 航班号/车次
            ,startime -- 时间
            ,endtime -- 结束时间
            ,cca_devfund -- 民航发展基金
            ,fuelsrchrg -- 燃油附加费
            ,otherfees -- 其他税费
            ,insurance -- 保险费
            ,seatno -- 座位
            ,seatrank -- 座位等级
            ,price -- 单价
            ,mileage -- 里程数
            ,transfertax -- 转出税额
            ,amt -- 票价
            ,airstate -- 票号状态
            ,category -- 种类
            ,ticketbagid -- 票袋主键
            ,accountno -- 对账单号
            ,billperiod -- 账期
            ,doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
            ,doubtreasons -- 疑票原因
            ,billtype -- 票种类型
            ,taxperiod -- 税款所属期
            ,tick -- 是否勾选
            ,tickdate -- 勾选日期
            ,tickmethod -- 勾选方式
            ,authstatus -- 认证状态
            ,authfailurereason -- 认证失败原因
            ,authdate -- 认证日期
            ,effectivededuction -- 有效抵扣额
            ,def2 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def20 -- 
            ,invcid -- 提供友报账专用主键
            ,createtime -- 创建时间
            ,updatetime -- 修改时间
            ,invcnoprint -- 打印发票号码
            ,pk_org -- 组织编码
            ,carrystatus -- 结转状态
            ,carrydate -- 结转日期
            ,carryno -- 结转凭证号
            ,tickresult -- 勾选结果
            ,authresult -- 认证结果
            ,castatus -- 记账状态
            ,authmethod -- 认证方式
            ,tagid -- 
            ,reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
            ,reimbursementbalance -- 报销余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_invcwallets, o.pk_invcwallets) as pk_invcwallets -- 
    ,nvl(n.dr, o.dr) as dr -- 
    ,nvl(n.ts, o.ts) as ts -- 
    ,nvl(n.creator, o.creator) as creator -- 录入人
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 采集日期
    ,nvl(n.invctype, o.invctype) as invctype -- 发票类型
    ,nvl(n.srcsystem, o.srcsystem) as srcsystem -- 来源系统
    ,nvl(n.collectmode, o.collectmode) as collectmode -- 采集方式
    ,nvl(n.totallev, o.totallev) as totallev -- 含税金额合计
    ,nvl(n.totalamt, o.totalamt) as totalamt -- 不含税金额合计
    ,nvl(n.taxrate, o.taxrate) as taxrate -- 税率
    ,nvl(n.totaltax, o.totaltax) as totaltax -- 税额合计
    ,nvl(n.totallevbal, o.totallevbal) as totallevbal -- 含税金额合计余额
    ,nvl(n.totaltaxbal, o.totaltaxbal) as totaltaxbal -- 发票税额余额
    ,nvl(n.bxstate, o.bxstate) as bxstate -- 报销状态
    ,nvl(n.checkstate, o.checkstate) as checkstate -- 查验状态
    ,nvl(n.sealspecial, o.sealspecial) as sealspecial -- 发票专用章
    ,nvl(n.sealprod, o.sealprod) as sealprod -- 发票监制章
    ,nvl(n.invcurl, o.invcurl) as invcurl -- 发票地址
    ,nvl(n.filename, o.filename) as filename -- 附件名
    ,nvl(n.invcdate, o.invcdate) as invcdate -- 开票日期
    ,nvl(n.salename, o.salename) as salename -- 销方名称
    ,nvl(n.saletaxno, o.saletaxno) as saletaxno -- 销方税号
    ,nvl(n.saleaddress, o.saleaddress) as saleaddress -- 销方地址、电话
    ,nvl(n.salebank, o.salebank) as salebank -- 销方开户行及账号
    ,nvl(n.buyname, o.buyname) as buyname -- 购方名称
    ,nvl(n.buytaxno, o.buytaxno) as buytaxno -- 购方税号
    ,nvl(n.buyaddress, o.buyaddress) as buyaddress -- 购方地址、电话
    ,nvl(n.buybank, o.buybank) as buybank -- 购方开户行及账号
    ,nvl(n.invcode, o.invcode) as invcode -- 发票代码
    ,nvl(n.invcno, o.invcno) as invcno -- 发票号码
    ,nvl(n.chkcode, o.chkcode) as chkcode -- 校验码
    ,nvl(n.machcode, o.machcode) as machcode -- 机器编码
    ,nvl(n.drawer, o.drawer) as drawer -- 开票人
    ,nvl(n.receiptor, o.receiptor) as receiptor -- 收款人
    ,nvl(n.reviewer, o.reviewer) as reviewer -- 复核人
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.custname, o.custname) as custname -- 旅客姓名
    ,nvl(n.custidno, o.custidno) as custidno -- 身份证号码
    ,nvl(n.fromaddr, o.fromaddr) as fromaddr -- 出发地
    ,nvl(n.toaddr, o.toaddr) as toaddr -- 目的地
    ,nvl(n.tripcode, o.tripcode) as tripcode -- 航班号/车次
    ,nvl(n.startime, o.startime) as startime -- 时间
    ,nvl(n.endtime, o.endtime) as endtime -- 结束时间
    ,nvl(n.cca_devfund, o.cca_devfund) as cca_devfund -- 民航发展基金
    ,nvl(n.fuelsrchrg, o.fuelsrchrg) as fuelsrchrg -- 燃油附加费
    ,nvl(n.otherfees, o.otherfees) as otherfees -- 其他税费
    ,nvl(n.insurance, o.insurance) as insurance -- 保险费
    ,nvl(n.seatno, o.seatno) as seatno -- 座位
    ,nvl(n.seatrank, o.seatrank) as seatrank -- 座位等级
    ,nvl(n.price, o.price) as price -- 单价
    ,nvl(n.mileage, o.mileage) as mileage -- 里程数
    ,nvl(n.transfertax, o.transfertax) as transfertax -- 转出税额
    ,nvl(n.amt, o.amt) as amt -- 票价
    ,nvl(n.airstate, o.airstate) as airstate -- 票号状态
    ,nvl(n.category, o.category) as category -- 种类
    ,nvl(n.ticketbagid, o.ticketbagid) as ticketbagid -- 票袋主键
    ,nvl(n.accountno, o.accountno) as accountno -- 对账单号
    ,nvl(n.billperiod, o.billperiod) as billperiod -- 账期
    ,nvl(n.doubtstatus, o.doubtstatus) as doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
    ,nvl(n.doubtreasons, o.doubtreasons) as doubtreasons -- 疑票原因
    ,nvl(n.billtype, o.billtype) as billtype -- 票种类型
    ,nvl(n.taxperiod, o.taxperiod) as taxperiod -- 税款所属期
    ,nvl(n.tick, o.tick) as tick -- 是否勾选
    ,nvl(n.tickdate, o.tickdate) as tickdate -- 勾选日期
    ,nvl(n.tickmethod, o.tickmethod) as tickmethod -- 勾选方式
    ,nvl(n.authstatus, o.authstatus) as authstatus -- 认证状态
    ,nvl(n.authfailurereason, o.authfailurereason) as authfailurereason -- 认证失败原因
    ,nvl(n.authdate, o.authdate) as authdate -- 认证日期
    ,nvl(n.effectivededuction, o.effectivededuction) as effectivededuction -- 有效抵扣额
    ,nvl(n.def2, o.def2) as def2 -- 
    ,nvl(n.def3, o.def3) as def3 -- 
    ,nvl(n.def4, o.def4) as def4 -- 
    ,nvl(n.def5, o.def5) as def5 -- 
    ,nvl(n.def6, o.def6) as def6 -- 
    ,nvl(n.def7, o.def7) as def7 -- 
    ,nvl(n.def8, o.def8) as def8 -- 
    ,nvl(n.def9, o.def9) as def9 -- 
    ,nvl(n.def10, o.def10) as def10 -- 
    ,nvl(n.def11, o.def11) as def11 -- 
    ,nvl(n.def12, o.def12) as def12 -- 
    ,nvl(n.def13, o.def13) as def13 -- 
    ,nvl(n.def14, o.def14) as def14 -- 
    ,nvl(n.def15, o.def15) as def15 -- 
    ,nvl(n.def16, o.def16) as def16 -- 
    ,nvl(n.def17, o.def17) as def17 -- 
    ,nvl(n.def18, o.def18) as def18 -- 
    ,nvl(n.def19, o.def19) as def19 -- 
    ,nvl(n.def20, o.def20) as def20 -- 
    ,nvl(n.invcid, o.invcid) as invcid -- 提供友报账专用主键
    ,nvl(n.createtime, o.createtime) as createtime -- 创建时间
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 修改时间
    ,nvl(n.invcnoprint, o.invcnoprint) as invcnoprint -- 打印发票号码
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织编码
    ,nvl(n.carrystatus, o.carrystatus) as carrystatus -- 结转状态
    ,nvl(n.carrydate, o.carrydate) as carrydate -- 结转日期
    ,nvl(n.carryno, o.carryno) as carryno -- 结转凭证号
    ,nvl(n.tickresult, o.tickresult) as tickresult -- 勾选结果
    ,nvl(n.authresult, o.authresult) as authresult -- 认证结果
    ,nvl(n.castatus, o.castatus) as castatus -- 记账状态
    ,nvl(n.authmethod, o.authmethod) as authmethod -- 认证方式
    ,nvl(n.tagid, o.tagid) as tagid -- 
    ,nvl(n.reimbursementtype, o.reimbursementtype) as reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
    ,nvl(n.reimbursementbalance, o.reimbursementbalance) as reimbursementbalance -- 报销余额
    ,case when
            n.pk_invcwallets is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_invcwallets is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_invcwallets is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_inv_pid_invcwallets_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_inv_pid_invcwallets where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_invcwallets = n.pk_invcwallets
where (
        o.pk_invcwallets is null
    )
    or (
        n.pk_invcwallets is null
    )
    or (
        o.dr <> n.dr
        or o.ts <> n.ts
        or o.creator <> n.creator
        or o.creationtime <> n.creationtime
        or o.invctype <> n.invctype
        or o.srcsystem <> n.srcsystem
        or o.collectmode <> n.collectmode
        or o.totallev <> n.totallev
        or o.totalamt <> n.totalamt
        or o.taxrate <> n.taxrate
        or o.totaltax <> n.totaltax
        or o.totallevbal <> n.totallevbal
        or o.totaltaxbal <> n.totaltaxbal
        or o.bxstate <> n.bxstate
        or o.checkstate <> n.checkstate
        or o.sealspecial <> n.sealspecial
        or o.sealprod <> n.sealprod
        or o.invcurl <> n.invcurl
        or o.filename <> n.filename
        or o.invcdate <> n.invcdate
        or o.salename <> n.salename
        or o.saletaxno <> n.saletaxno
        or o.saleaddress <> n.saleaddress
        or o.salebank <> n.salebank
        or o.buyname <> n.buyname
        or o.buytaxno <> n.buytaxno
        or o.buyaddress <> n.buyaddress
        or o.buybank <> n.buybank
        or o.invcode <> n.invcode
        or o.invcno <> n.invcno
        or o.chkcode <> n.chkcode
        or o.machcode <> n.machcode
        or o.drawer <> n.drawer
        or o.receiptor <> n.receiptor
        or o.reviewer <> n.reviewer
        or o.remark <> n.remark
        or o.custname <> n.custname
        or o.custidno <> n.custidno
        or o.fromaddr <> n.fromaddr
        or o.toaddr <> n.toaddr
        or o.tripcode <> n.tripcode
        or o.startime <> n.startime
        or o.endtime <> n.endtime
        or o.cca_devfund <> n.cca_devfund
        or o.fuelsrchrg <> n.fuelsrchrg
        or o.otherfees <> n.otherfees
        or o.insurance <> n.insurance
        or o.seatno <> n.seatno
        or o.seatrank <> n.seatrank
        or o.price <> n.price
        or o.mileage <> n.mileage
        or o.transfertax <> n.transfertax
        or o.amt <> n.amt
        or o.airstate <> n.airstate
        or o.category <> n.category
        or o.ticketbagid <> n.ticketbagid
        or o.accountno <> n.accountno
        or o.billperiod <> n.billperiod
        or o.doubtstatus <> n.doubtstatus
        or o.doubtreasons <> n.doubtreasons
        or o.billtype <> n.billtype
        or o.taxperiod <> n.taxperiod
        or o.tick <> n.tick
        or o.tickdate <> n.tickdate
        or o.tickmethod <> n.tickmethod
        or o.authstatus <> n.authstatus
        or o.authfailurereason <> n.authfailurereason
        or o.authdate <> n.authdate
        or o.effectivededuction <> n.effectivededuction
        or o.def2 <> n.def2
        or o.def3 <> n.def3
        or o.def4 <> n.def4
        or o.def5 <> n.def5
        or o.def6 <> n.def6
        or o.def7 <> n.def7
        or o.def8 <> n.def8
        or o.def9 <> n.def9
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def20 <> n.def20
        or o.invcid <> n.invcid
        or o.createtime <> n.createtime
        or o.updatetime <> n.updatetime
        or o.invcnoprint <> n.invcnoprint
        or o.pk_org <> n.pk_org
        or o.carrystatus <> n.carrystatus
        or o.carrydate <> n.carrydate
        or o.carryno <> n.carryno
        or o.tickresult <> n.tickresult
        or o.authresult <> n.authresult
        or o.castatus <> n.castatus
        or o.authmethod <> n.authmethod
        or o.tagid <> n.tagid
        or o.reimbursementtype <> n.reimbursementtype
        or o.reimbursementbalance <> n.reimbursementbalance
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_inv_pid_invcwallets_cl(
            pk_invcwallets -- 
            ,dr -- 
            ,ts -- 
            ,creator -- 录入人
            ,creationtime -- 采集日期
            ,invctype -- 发票类型
            ,srcsystem -- 来源系统
            ,collectmode -- 采集方式
            ,totallev -- 含税金额合计
            ,totalamt -- 不含税金额合计
            ,taxrate -- 税率
            ,totaltax -- 税额合计
            ,totallevbal -- 含税金额合计余额
            ,totaltaxbal -- 发票税额余额
            ,bxstate -- 报销状态
            ,checkstate -- 查验状态
            ,sealspecial -- 发票专用章
            ,sealprod -- 发票监制章
            ,invcurl -- 发票地址
            ,filename -- 附件名
            ,invcdate -- 开票日期
            ,salename -- 销方名称
            ,saletaxno -- 销方税号
            ,saleaddress -- 销方地址、电话
            ,salebank -- 销方开户行及账号
            ,buyname -- 购方名称
            ,buytaxno -- 购方税号
            ,buyaddress -- 购方地址、电话
            ,buybank -- 购方开户行及账号
            ,invcode -- 发票代码
            ,invcno -- 发票号码
            ,chkcode -- 校验码
            ,machcode -- 机器编码
            ,drawer -- 开票人
            ,receiptor -- 收款人
            ,reviewer -- 复核人
            ,remark -- 备注
            ,custname -- 旅客姓名
            ,custidno -- 身份证号码
            ,fromaddr -- 出发地
            ,toaddr -- 目的地
            ,tripcode -- 航班号/车次
            ,startime -- 时间
            ,endtime -- 结束时间
            ,cca_devfund -- 民航发展基金
            ,fuelsrchrg -- 燃油附加费
            ,otherfees -- 其他税费
            ,insurance -- 保险费
            ,seatno -- 座位
            ,seatrank -- 座位等级
            ,price -- 单价
            ,mileage -- 里程数
            ,transfertax -- 转出税额
            ,amt -- 票价
            ,airstate -- 票号状态
            ,category -- 种类
            ,ticketbagid -- 票袋主键
            ,accountno -- 对账单号
            ,billperiod -- 账期
            ,doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
            ,doubtreasons -- 疑票原因
            ,billtype -- 票种类型
            ,taxperiod -- 税款所属期
            ,tick -- 是否勾选
            ,tickdate -- 勾选日期
            ,tickmethod -- 勾选方式
            ,authstatus -- 认证状态
            ,authfailurereason -- 认证失败原因
            ,authdate -- 认证日期
            ,effectivededuction -- 有效抵扣额
            ,def2 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def20 -- 
            ,invcid -- 提供友报账专用主键
            ,createtime -- 创建时间
            ,updatetime -- 修改时间
            ,invcnoprint -- 打印发票号码
            ,pk_org -- 组织编码
            ,carrystatus -- 结转状态
            ,carrydate -- 结转日期
            ,carryno -- 结转凭证号
            ,tickresult -- 勾选结果
            ,authresult -- 认证结果
            ,castatus -- 记账状态
            ,authmethod -- 认证方式
            ,tagid -- 
            ,reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
            ,reimbursementbalance -- 报销余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_inv_pid_invcwallets_op(
            pk_invcwallets -- 
            ,dr -- 
            ,ts -- 
            ,creator -- 录入人
            ,creationtime -- 采集日期
            ,invctype -- 发票类型
            ,srcsystem -- 来源系统
            ,collectmode -- 采集方式
            ,totallev -- 含税金额合计
            ,totalamt -- 不含税金额合计
            ,taxrate -- 税率
            ,totaltax -- 税额合计
            ,totallevbal -- 含税金额合计余额
            ,totaltaxbal -- 发票税额余额
            ,bxstate -- 报销状态
            ,checkstate -- 查验状态
            ,sealspecial -- 发票专用章
            ,sealprod -- 发票监制章
            ,invcurl -- 发票地址
            ,filename -- 附件名
            ,invcdate -- 开票日期
            ,salename -- 销方名称
            ,saletaxno -- 销方税号
            ,saleaddress -- 销方地址、电话
            ,salebank -- 销方开户行及账号
            ,buyname -- 购方名称
            ,buytaxno -- 购方税号
            ,buyaddress -- 购方地址、电话
            ,buybank -- 购方开户行及账号
            ,invcode -- 发票代码
            ,invcno -- 发票号码
            ,chkcode -- 校验码
            ,machcode -- 机器编码
            ,drawer -- 开票人
            ,receiptor -- 收款人
            ,reviewer -- 复核人
            ,remark -- 备注
            ,custname -- 旅客姓名
            ,custidno -- 身份证号码
            ,fromaddr -- 出发地
            ,toaddr -- 目的地
            ,tripcode -- 航班号/车次
            ,startime -- 时间
            ,endtime -- 结束时间
            ,cca_devfund -- 民航发展基金
            ,fuelsrchrg -- 燃油附加费
            ,otherfees -- 其他税费
            ,insurance -- 保险费
            ,seatno -- 座位
            ,seatrank -- 座位等级
            ,price -- 单价
            ,mileage -- 里程数
            ,transfertax -- 转出税额
            ,amt -- 票价
            ,airstate -- 票号状态
            ,category -- 种类
            ,ticketbagid -- 票袋主键
            ,accountno -- 对账单号
            ,billperiod -- 账期
            ,doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
            ,doubtreasons -- 疑票原因
            ,billtype -- 票种类型
            ,taxperiod -- 税款所属期
            ,tick -- 是否勾选
            ,tickdate -- 勾选日期
            ,tickmethod -- 勾选方式
            ,authstatus -- 认证状态
            ,authfailurereason -- 认证失败原因
            ,authdate -- 认证日期
            ,effectivededuction -- 有效抵扣额
            ,def2 -- 
            ,def3 -- 
            ,def4 -- 
            ,def5 -- 
            ,def6 -- 
            ,def7 -- 
            ,def8 -- 
            ,def9 -- 
            ,def10 -- 
            ,def11 -- 
            ,def12 -- 
            ,def13 -- 
            ,def14 -- 
            ,def15 -- 
            ,def16 -- 
            ,def17 -- 
            ,def18 -- 
            ,def19 -- 
            ,def20 -- 
            ,invcid -- 提供友报账专用主键
            ,createtime -- 创建时间
            ,updatetime -- 修改时间
            ,invcnoprint -- 打印发票号码
            ,pk_org -- 组织编码
            ,carrystatus -- 结转状态
            ,carrydate -- 结转日期
            ,carryno -- 结转凭证号
            ,tickresult -- 勾选结果
            ,authresult -- 认证结果
            ,castatus -- 记账状态
            ,authmethod -- 认证方式
            ,tagid -- 
            ,reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
            ,reimbursementbalance -- 报销余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_invcwallets -- 
    ,o.dr -- 
    ,o.ts -- 
    ,o.creator -- 录入人
    ,o.creationtime -- 采集日期
    ,o.invctype -- 发票类型
    ,o.srcsystem -- 来源系统
    ,o.collectmode -- 采集方式
    ,o.totallev -- 含税金额合计
    ,o.totalamt -- 不含税金额合计
    ,o.taxrate -- 税率
    ,o.totaltax -- 税额合计
    ,o.totallevbal -- 含税金额合计余额
    ,o.totaltaxbal -- 发票税额余额
    ,o.bxstate -- 报销状态
    ,o.checkstate -- 查验状态
    ,o.sealspecial -- 发票专用章
    ,o.sealprod -- 发票监制章
    ,o.invcurl -- 发票地址
    ,o.filename -- 附件名
    ,o.invcdate -- 开票日期
    ,o.salename -- 销方名称
    ,o.saletaxno -- 销方税号
    ,o.saleaddress -- 销方地址、电话
    ,o.salebank -- 销方开户行及账号
    ,o.buyname -- 购方名称
    ,o.buytaxno -- 购方税号
    ,o.buyaddress -- 购方地址、电话
    ,o.buybank -- 购方开户行及账号
    ,o.invcode -- 发票代码
    ,o.invcno -- 发票号码
    ,o.chkcode -- 校验码
    ,o.machcode -- 机器编码
    ,o.drawer -- 开票人
    ,o.receiptor -- 收款人
    ,o.reviewer -- 复核人
    ,o.remark -- 备注
    ,o.custname -- 旅客姓名
    ,o.custidno -- 身份证号码
    ,o.fromaddr -- 出发地
    ,o.toaddr -- 目的地
    ,o.tripcode -- 航班号/车次
    ,o.startime -- 时间
    ,o.endtime -- 结束时间
    ,o.cca_devfund -- 民航发展基金
    ,o.fuelsrchrg -- 燃油附加费
    ,o.otherfees -- 其他税费
    ,o.insurance -- 保险费
    ,o.seatno -- 座位
    ,o.seatrank -- 座位等级
    ,o.price -- 单价
    ,o.mileage -- 里程数
    ,o.transfertax -- 转出税额
    ,o.amt -- 票价
    ,o.airstate -- 票号状态
    ,o.category -- 种类
    ,o.ticketbagid -- 票袋主键
    ,o.accountno -- 对账单号
    ,o.billperiod -- 账期
    ,o.doubtstatus -- 疑票状态(0 已放行/1 未放行/2 禁止)
    ,o.doubtreasons -- 疑票原因
    ,o.billtype -- 票种类型
    ,o.taxperiod -- 税款所属期
    ,o.tick -- 是否勾选
    ,o.tickdate -- 勾选日期
    ,o.tickmethod -- 勾选方式
    ,o.authstatus -- 认证状态
    ,o.authfailurereason -- 认证失败原因
    ,o.authdate -- 认证日期
    ,o.effectivededuction -- 有效抵扣额
    ,o.def2 -- 
    ,o.def3 -- 
    ,o.def4 -- 
    ,o.def5 -- 
    ,o.def6 -- 
    ,o.def7 -- 
    ,o.def8 -- 
    ,o.def9 -- 
    ,o.def10 -- 
    ,o.def11 -- 
    ,o.def12 -- 
    ,o.def13 -- 
    ,o.def14 -- 
    ,o.def15 -- 
    ,o.def16 -- 
    ,o.def17 -- 
    ,o.def18 -- 
    ,o.def19 -- 
    ,o.def20 -- 
    ,o.invcid -- 提供友报账专用主键
    ,o.createtime -- 创建时间
    ,o.updatetime -- 修改时间
    ,o.invcnoprint -- 打印发票号码
    ,o.pk_org -- 组织编码
    ,o.carrystatus -- 结转状态
    ,o.carrydate -- 结转日期
    ,o.carryno -- 结转凭证号
    ,o.tickresult -- 勾选结果
    ,o.authresult -- 认证结果
    ,o.castatus -- 记账状态
    ,o.authmethod -- 认证方式
    ,o.tagid -- 
    ,o.reimbursementtype -- 报销方式(0 整单报销 1明细报销 2余额报销)
    ,o.reimbursementbalance -- 报销余额
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
from ${iol_schema}.iers_inv_pid_invcwallets_bk o
    left join ${iol_schema}.iers_inv_pid_invcwallets_op n
        on
            o.pk_invcwallets = n.pk_invcwallets
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_inv_pid_invcwallets_cl d
        on
            o.pk_invcwallets = d.pk_invcwallets
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_inv_pid_invcwallets;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_inv_pid_invcwallets') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_inv_pid_invcwallets drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_inv_pid_invcwallets add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_inv_pid_invcwallets exchange partition p_${batch_date} with table ${iol_schema}.iers_inv_pid_invcwallets_cl;
alter table ${iol_schema}.iers_inv_pid_invcwallets exchange partition p_20991231 with table ${iol_schema}.iers_inv_pid_invcwallets_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_inv_pid_invcwallets to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_inv_pid_invcwallets_op purge;
drop table ${iol_schema}.iers_inv_pid_invcwallets_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_inv_pid_invcwallets_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_inv_pid_invcwallets',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
