/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_hqd_iqp_loan_app
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
create table ${iol_schema}.icms_hqd_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_hqd_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hqd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_hqd_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hqd_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hqd_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_hqd_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_hqd_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hqd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 业务品种
            ,applyamt -- 申请金额
            ,termmonth -- 贷款期限
            ,appchannel -- 接入渠道
            ,channelno -- 产品分类标志（渠道号）
            ,inputuserid -- 客户经理号
            ,inputorgid -- 客户经理所属机构
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,entlegalercusid -- 法人代表人客户号
            ,entcusid -- 企业客户号
            ,enterprisename -- 企业名称
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,registerprov -- 经营地址所属省
            ,registercity -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 注册详细地址
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,informflag -- 终审通知成功与否
            ,managerquest -- 客户经理意见
            ,isrelateent -- 是否关联企业
            ,iscycle -- 额度是否循环
            ,vouchtype -- 主担保方式
            ,annualempsnum -- 本年度从业人数（人）
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,predictsalerevenueflowyear -- 预测次年销售收入
            ,otherchannelworkcapit -- 其他渠道提供的营运资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
            ,nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,knowagepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,lmtserno -- 额度合同编号
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,updateuserid -- 更新客户经理号
            ,updateorgid -- 更新客户经理所属机构
            ,updatedate -- 更新时间
            ,belongorgid -- 所属分行
            ,zsapplyenddate -- 终审结束时间
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bano -- 授信流水号
            ,idexpirydate -- 企业证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hqd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 业务品种
            ,applyamt -- 申请金额
            ,termmonth -- 贷款期限
            ,appchannel -- 接入渠道
            ,channelno -- 产品分类标志（渠道号）
            ,inputuserid -- 客户经理号
            ,inputorgid -- 客户经理所属机构
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,entlegalercusid -- 法人代表人客户号
            ,entcusid -- 企业客户号
            ,enterprisename -- 企业名称
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,registerprov -- 经营地址所属省
            ,registercity -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 注册详细地址
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,informflag -- 终审通知成功与否
            ,managerquest -- 客户经理意见
            ,isrelateent -- 是否关联企业
            ,iscycle -- 额度是否循环
            ,vouchtype -- 主担保方式
            ,annualempsnum -- 本年度从业人数（人）
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,predictsalerevenueflowyear -- 预测次年销售收入
            ,otherchannelworkcapit -- 其他渠道提供的营运资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
            ,nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,knowagepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,lmtserno -- 额度合同编号
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,updateuserid -- 更新客户经理号
            ,updateorgid -- 更新客户经理所属机构
            ,updatedate -- 更新时间
            ,belongorgid -- 所属分行
            ,zsapplyenddate -- 终审结束时间
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bano -- 授信流水号
            ,idexpirydate -- 企业证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 业务品种
    ,nvl(n.applyamt, o.applyamt) as applyamt -- 申请金额
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 贷款期限
    ,nvl(n.appchannel, o.appchannel) as appchannel -- 接入渠道
    ,nvl(n.channelno, o.channelno) as channelno -- 产品分类标志（渠道号）
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 客户经理号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 客户经理所属机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 终审申请日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 终审审批状态
    ,nvl(n.entlegalercusid, o.entlegalercusid) as entlegalercusid -- 法人代表人客户号
    ,nvl(n.entcusid, o.entcusid) as entcusid -- 企业客户号
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.enterprisecerttype, o.enterprisecerttype) as enterprisecerttype -- 企业身份标识类型
    ,nvl(n.enterprisecertid, o.enterprisecertid) as enterprisecertid -- 企业身份标识号码
    ,nvl(n.registerprov, o.registerprov) as registerprov -- 经营地址所属省
    ,nvl(n.registercity, o.registercity) as registercity -- 经营地址所属市
    ,nvl(n.registerarea, o.registerarea) as registerarea -- 经营地址所属县（区）
    ,nvl(n.registeraddress, o.registeraddress) as registeraddress -- 注册详细地址
    ,nvl(n.warninginfo, o.warninginfo) as warninginfo -- 预警信息
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 终审审批额度(元)
    ,nvl(n.informflag, o.informflag) as informflag -- 终审通知成功与否
    ,nvl(n.managerquest, o.managerquest) as managerquest -- 客户经理意见
    ,nvl(n.isrelateent, o.isrelateent) as isrelateent -- 是否关联企业
    ,nvl(n.iscycle, o.iscycle) as iscycle -- 额度是否循环
    ,nvl(n.vouchtype, o.vouchtype) as vouchtype -- 主担保方式
    ,nvl(n.annualempsnum, o.annualempsnum) as annualempsnum -- 本年度从业人数（人）
    ,nvl(n.actualcontrollerempyears, o.actualcontrollerempyears) as actualcontrollerempyears -- 实控人从业年限（年）
    ,nvl(n.flowannualsalesrevenue, o.flowannualsalesrevenue) as flowannualsalesrevenue -- 流水推算的年销售收入
    ,nvl(n.predictsalerevenueflowyear, o.predictsalerevenueflowyear) as predictsalerevenueflowyear -- 预测次年销售收入
    ,nvl(n.otherchannelworkcapit, o.otherchannelworkcapit) as otherchannelworkcapit -- 其他渠道提供的营运资金
    ,nvl(n.nocrediteachdebtaccubalance, o.nocrediteachdebtaccubalance) as nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
    ,nvl(n.nocreditmonthaccurepaydebt, o.nocreditmonthaccurepaydebt) as nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
    ,nvl(n.entmonthrepaybalance, o.entmonthrepaybalance) as entmonthrepaybalance -- 企业月还款额
    ,nvl(n.ispledgedreceiveaccount, o.ispledgedreceiveaccount) as ispledgedreceiveaccount -- 企业应收账款是否质押
    ,nvl(n.pledgereceiveamt, o.pledgereceiveamt) as pledgereceiveamt -- 应收账款质押贷款金额
    ,nvl(n.knowagepledgereceiveamt, o.knowagepledgereceiveamt) as knowagepledgereceiveamt -- 知识产权质押贷款金额
    ,nvl(n.isstockpledged, o.isstockpledged) as isstockpledged -- 股权是否质押
    ,nvl(n.stockpledgedamt, o.stockpledgedamt) as stockpledgedamt -- 股权质押贷款金额
    ,nvl(n.lmtserno, o.lmtserno) as lmtserno -- 额度合同编号
    ,nvl(n.sysid, o.sysid) as sysid -- 系统来源
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 查询操作申请类型
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新客户经理号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新客户经理所属机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.belongorgid, o.belongorgid) as belongorgid -- 所属分行
    ,nvl(n.zsapplyenddate, o.zsapplyenddate) as zsapplyenddate -- 终审结束时间
    ,nvl(n.tradecode, o.tradecode) as tradecode -- 行业类型
    ,nvl(n.empcountyear, o.empcountyear) as empcountyear -- 从业人数
    ,nvl(n.tatalasset, o.tatalasset) as tatalasset -- 资产合计
    ,nvl(n.proceeds, o.proceeds) as proceeds -- 营业收入
    ,nvl(n.scale, o.scale) as scale -- 企业规模
    ,nvl(n.bano, o.bano) as bano -- 授信流水号
    ,nvl(n.idexpirydate, o.idexpirydate) as idexpirydate -- 企业证件到期日
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
from (select * from ${iol_schema}.icms_hqd_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_hqd_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applyno <> n.applyno
        or o.prdcode <> n.prdcode
        or o.applyamt <> n.applyamt
        or o.termmonth <> n.termmonth
        or o.appchannel <> n.appchannel
        or o.channelno <> n.channelno
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.approvestatus <> n.approvestatus
        or o.entlegalercusid <> n.entlegalercusid
        or o.entcusid <> n.entcusid
        or o.enterprisename <> n.enterprisename
        or o.enterprisecerttype <> n.enterprisecerttype
        or o.enterprisecertid <> n.enterprisecertid
        or o.registerprov <> n.registerprov
        or o.registercity <> n.registercity
        or o.registerarea <> n.registerarea
        or o.registeraddress <> n.registeraddress
        or o.warninginfo <> n.warninginfo
        or o.failreason <> n.failreason
        or o.finalapplyamount <> n.finalapplyamount
        or o.informflag <> n.informflag
        or o.managerquest <> n.managerquest
        or o.isrelateent <> n.isrelateent
        or o.iscycle <> n.iscycle
        or o.vouchtype <> n.vouchtype
        or o.annualempsnum <> n.annualempsnum
        or o.actualcontrollerempyears <> n.actualcontrollerempyears
        or o.flowannualsalesrevenue <> n.flowannualsalesrevenue
        or o.predictsalerevenueflowyear <> n.predictsalerevenueflowyear
        or o.otherchannelworkcapit <> n.otherchannelworkcapit
        or o.nocrediteachdebtaccubalance <> n.nocrediteachdebtaccubalance
        or o.nocreditmonthaccurepaydebt <> n.nocreditmonthaccurepaydebt
        or o.entmonthrepaybalance <> n.entmonthrepaybalance
        or o.ispledgedreceiveaccount <> n.ispledgedreceiveaccount
        or o.pledgereceiveamt <> n.pledgereceiveamt
        or o.knowagepledgereceiveamt <> n.knowagepledgereceiveamt
        or o.isstockpledged <> n.isstockpledged
        or o.stockpledgedamt <> n.stockpledgedamt
        or o.lmtserno <> n.lmtserno
        or o.sysid <> n.sysid
        or o.qryopertp <> n.qryopertp
        or o.authotype <> n.authotype
        or o.biometrics <> n.biometrics
        or o.authotime <> n.authotime
        or o.authostrdate <> n.authostrdate
        or o.authoenddate <> n.authoenddate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.belongorgid <> n.belongorgid
        or o.zsapplyenddate <> n.zsapplyenddate
        or o.tradecode <> n.tradecode
        or o.empcountyear <> n.empcountyear
        or o.tatalasset <> n.tatalasset
        or o.proceeds <> n.proceeds
        or o.scale <> n.scale
        or o.bano <> n.bano
        or o.idexpirydate <> n.idexpirydate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_hqd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 业务品种
            ,applyamt -- 申请金额
            ,termmonth -- 贷款期限
            ,appchannel -- 接入渠道
            ,channelno -- 产品分类标志（渠道号）
            ,inputuserid -- 客户经理号
            ,inputorgid -- 客户经理所属机构
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,entlegalercusid -- 法人代表人客户号
            ,entcusid -- 企业客户号
            ,enterprisename -- 企业名称
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,registerprov -- 经营地址所属省
            ,registercity -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 注册详细地址
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,informflag -- 终审通知成功与否
            ,managerquest -- 客户经理意见
            ,isrelateent -- 是否关联企业
            ,iscycle -- 额度是否循环
            ,vouchtype -- 主担保方式
            ,annualempsnum -- 本年度从业人数（人）
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,predictsalerevenueflowyear -- 预测次年销售收入
            ,otherchannelworkcapit -- 其他渠道提供的营运资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
            ,nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,knowagepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,lmtserno -- 额度合同编号
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,updateuserid -- 更新客户经理号
            ,updateorgid -- 更新客户经理所属机构
            ,updatedate -- 更新时间
            ,belongorgid -- 所属分行
            ,zsapplyenddate -- 终审结束时间
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bano -- 授信流水号
            ,idexpirydate -- 企业证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_hqd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 业务品种
            ,applyamt -- 申请金额
            ,termmonth -- 贷款期限
            ,appchannel -- 接入渠道
            ,channelno -- 产品分类标志（渠道号）
            ,inputuserid -- 客户经理号
            ,inputorgid -- 客户经理所属机构
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,entlegalercusid -- 法人代表人客户号
            ,entcusid -- 企业客户号
            ,enterprisename -- 企业名称
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,registerprov -- 经营地址所属省
            ,registercity -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 注册详细地址
            ,warninginfo -- 预警信息
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,informflag -- 终审通知成功与否
            ,managerquest -- 客户经理意见
            ,isrelateent -- 是否关联企业
            ,iscycle -- 额度是否循环
            ,vouchtype -- 主担保方式
            ,annualempsnum -- 本年度从业人数（人）
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,predictsalerevenueflowyear -- 预测次年销售收入
            ,otherchannelworkcapit -- 其他渠道提供的营运资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
            ,nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,knowagepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,lmtserno -- 额度合同编号
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,updateuserid -- 更新客户经理号
            ,updateorgid -- 更新客户经理所属机构
            ,updatedate -- 更新时间
            ,belongorgid -- 所属分行
            ,zsapplyenddate -- 终审结束时间
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bano -- 授信流水号
            ,idexpirydate -- 企业证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.applyno -- 信贷申请流水号
    ,o.prdcode -- 业务品种
    ,o.applyamt -- 申请金额
    ,o.termmonth -- 贷款期限
    ,o.appchannel -- 接入渠道
    ,o.channelno -- 产品分类标志（渠道号）
    ,o.inputuserid -- 客户经理号
    ,o.inputorgid -- 客户经理所属机构
    ,o.inputdate -- 终审申请日期
    ,o.approvestatus -- 终审审批状态
    ,o.entlegalercusid -- 法人代表人客户号
    ,o.entcusid -- 企业客户号
    ,o.enterprisename -- 企业名称
    ,o.enterprisecerttype -- 企业身份标识类型
    ,o.enterprisecertid -- 企业身份标识号码
    ,o.registerprov -- 经营地址所属省
    ,o.registercity -- 经营地址所属市
    ,o.registerarea -- 经营地址所属县（区）
    ,o.registeraddress -- 注册详细地址
    ,o.warninginfo -- 预警信息
    ,o.failreason -- 拒绝原因
    ,o.finalapplyamount -- 终审审批额度(元)
    ,o.informflag -- 终审通知成功与否
    ,o.managerquest -- 客户经理意见
    ,o.isrelateent -- 是否关联企业
    ,o.iscycle -- 额度是否循环
    ,o.vouchtype -- 主担保方式
    ,o.annualempsnum -- 本年度从业人数（人）
    ,o.actualcontrollerempyears -- 实控人从业年限（年）
    ,o.flowannualsalesrevenue -- 流水推算的年销售收入
    ,o.predictsalerevenueflowyear -- 预测次年销售收入
    ,o.otherchannelworkcapit -- 其他渠道提供的营运资金
    ,o.nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债余额
    ,o.nocreditmonthaccurepaydebt -- 征信中未体现的各类负债月还款额
    ,o.entmonthrepaybalance -- 企业月还款额
    ,o.ispledgedreceiveaccount -- 企业应收账款是否质押
    ,o.pledgereceiveamt -- 应收账款质押贷款金额
    ,o.knowagepledgereceiveamt -- 知识产权质押贷款金额
    ,o.isstockpledged -- 股权是否质押
    ,o.stockpledgedamt -- 股权质押贷款金额
    ,o.lmtserno -- 额度合同编号
    ,o.sysid -- 系统来源
    ,o.qryopertp -- 查询操作申请类型
    ,o.authotype -- 授权方式
    ,o.biometrics -- 生物识别技术
    ,o.authotime -- 授权时间
    ,o.authostrdate -- 授权开始时间
    ,o.authoenddate -- 授权结束时间
    ,o.updateuserid -- 更新客户经理号
    ,o.updateorgid -- 更新客户经理所属机构
    ,o.updatedate -- 更新时间
    ,o.belongorgid -- 所属分行
    ,o.zsapplyenddate -- 终审结束时间
    ,o.tradecode -- 行业类型
    ,o.empcountyear -- 从业人数
    ,o.tatalasset -- 资产合计
    ,o.proceeds -- 营业收入
    ,o.scale -- 企业规模
    ,o.bano -- 授信流水号
    ,o.idexpirydate -- 企业证件到期日
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
from ${iol_schema}.icms_hqd_iqp_loan_app_bk o
    left join ${iol_schema}.icms_hqd_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_hqd_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_hqd_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_hqd_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_hqd_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_hqd_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_hqd_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_hqd_iqp_loan_app_cl;
alter table ${iol_schema}.icms_hqd_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_hqd_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_hqd_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_hqd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_hqd_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_hqd_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_hqd_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
