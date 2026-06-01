/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_bc_cl_info
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
create table ${iol_schema}.icms_bc_cl_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_bc_cl_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_cl_info_op purge;
drop table ${iol_schema}.icms_bc_cl_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_cl_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_cl_info where 0=1;

create table ${iol_schema}.icms_bc_cl_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_bc_cl_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_cl_info_cl(
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,sqdkze -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_cl_info_op(
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,sqdkze -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.lineclass, o.lineclass) as lineclass -- 额度种类综合/专项/其他)
    ,nvl(n.currencyrange, o.currencyrange) as currencyrange -- 项下业务币种范围
    ,nvl(n.lngotimes, o.lngotimes) as lngotimes -- 借新还旧次数
    ,nvl(n.occupynominalsum, o.occupynominalsum) as occupynominalsum -- 已用名义金额自动计算)
    ,nvl(n.afterloanuserid, o.afterloanuserid) as afterloanuserid -- 贷后管理人员
    ,nvl(n.creditflowtype, o.creditflowtype) as creditflowtype -- 授信业务流程类型
    ,nvl(n.creditarea, o.creditarea) as creditarea -- 授信区域
    ,nvl(n.approvalsuggestion, o.approvalsuggestion) as approvalsuggestion -- 建议审批等级
    ,nvl(n.useterm, o.useterm) as useterm -- 额度项下业务最迟到期日期
    ,nvl(n.freezeflag, o.freezeflag) as freezeflag -- 冻结标志
    ,nvl(n.bizlongestterm, o.bizlongestterm) as bizlongestterm -- 额度下业务最长期限月)
    ,nvl(n.occupyexposuresum, o.occupyexposuresum) as occupyexposuresum -- 已用敞口金额自动计算)
    ,nvl(n.limitusecondition, o.limitusecondition) as limitusecondition -- 额度使用条件
    ,nvl(n.classifytype2, o.classifytype2) as classifytype2 -- 风险暴露分类
    ,nvl(n.bizextendedterm, o.bizextendedterm) as bizextendedterm -- 额度下业务延展期限月)
    ,nvl(n.outclassifydate, o.outclassifydate) as outclassifydate -- 外部评级日期
    ,nvl(n.termtype, o.termtype) as termtype -- 期限申请类型额度)
    ,nvl(n.availablenominalsum, o.availablenominalsum) as availablenominalsum -- 可用名义金额
    ,nvl(n.afterloanorgid, o.afterloanorgid) as afterloanorgid -- 贷后管理机构
    ,nvl(n.outclassifyorg, o.outclassifyorg) as outclassifyorg -- 外部评级机构
    ,nvl(n.investway, o.investway) as investway -- 投资方式
    ,nvl(n.bizlowestfloatrate, o.bizlowestfloatrate) as bizlowestfloatrate -- 额度下业务利率最低浮动
    ,nvl(n.guarantybailsubaccount, o.guarantybailsubaccount) as guarantybailsubaccount -- 押品转保证金子户号
    ,nvl(n.isrz, o.isrz) as isrz -- 是否融资合同
    ,nvl(n.isgovernfinance, o.isgovernfinance) as isgovernfinance -- 是否涉及政府类融资
    ,nvl(n.isgreenfinance, o.isgreenfinance) as isgreenfinance -- 是否为绿色信贷融资
    ,nvl(n.maxnominalamount, o.maxnominalamount) as maxnominalamount -- 单一最高授信额度名义金额
    ,nvl(n.usewithoutcondition, o.usewithoutcondition) as usewithoutcondition -- 能否直接使用额度)
    ,nvl(n.businesstype2, o.businesstype2) as businesstype2 -- 专业贷款分类
    ,nvl(n.fundsource, o.fundsource) as fundsource -- 资金来源
    ,nvl(n.playtype, o.playtype) as playtype -- 参与方式
    ,nvl(n.bizmostmortgagerate, o.bizmostmortgagerate) as bizmostmortgagerate -- 额度下业务最高抵质押率
    ,nvl(n.bizbailinitialrate, o.bizbailinitialrate) as bizbailinitialrate -- 额度下业务初始保证金比例
    ,nvl(n.availableexposuresum, o.availableexposuresum) as availableexposuresum -- 可用敞口金额
    ,nvl(n.syndicatetotalsum, o.syndicatetotalsum) as syndicatetotalsum -- 银团贷款总金额
    ,nvl(n.isbeltroadfinance, o.isbeltroadfinance) as isbeltroadfinance -- 是否为一带一路建设投融资
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.istrans, o.istrans) as istrans -- 是否转授信
    ,nvl(n.linecontrolmode, o.linecontrolmode) as linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,nvl(n.otherlimitflag, o.otherlimitflag) as otherlimitflag -- 是否占用他用额度
    ,nvl(n.singlebizmostamount, o.singlebizmostamount) as singlebizmostamount -- 额度下业务单笔最大金额
    ,nvl(n.exposuresum, o.exposuresum) as exposuresum -- 额度敞口金额
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 放贷机构
    ,nvl(n.riskexposuresum, o.riskexposuresum) as riskexposuresum -- 其中，一般风险敞口金额(元)
    ,nvl(n.isquerycreditreport, o.isquerycreditreport) as isquerycreditreport -- 是否自动查询贷后报告
    ,nvl(n.onlineamount, o.onlineamount) as onlineamount -- 线上额度(元)
    ,nvl(n.isconsumerfinance, o.isconsumerfinance) as isconsumerfinance -- 是否为消费服务类融资
    ,nvl(n.maxexposureamount, o.maxexposureamount) as maxexposureamount -- 单一最高授信额度敞口金额
    ,nvl(n.ispubliccredit, o.ispubliccredit) as ispubliccredit -- 是否公开授信额度)
    ,nvl(n.creditauthno, o.creditauthno) as creditauthno -- 征信授权影像流水号
    ,nvl(n.islikeloan, o.islikeloan) as islikeloan -- 是否类信贷
    ,nvl(n.lowriskexposuresum, o.lowriskexposuresum) as lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,nvl(n.drtimes, o.drtimes) as drtimes -- 债务重组次数
    ,nvl(n.guarantybailaccount, o.guarantybailaccount) as guarantybailaccount -- 押品转保证金账号
    ,nvl(n.nominalsum, o.nominalsum) as nominalsum -- 额度名义金额
    ,nvl(n.latestusedate, o.latestusedate) as latestusedate -- 额度最迟使用日期
    ,nvl(n.outclassifylevel, o.outclassifylevel) as outclassifylevel -- 外部债项评级
    ,nvl(n.isestatefinance, o.isestatefinance) as isestatefinance -- 是否涉及房地产融资
    ,nvl(n.noeffectreason, o.noeffectreason) as noeffectreason -- 失效原因
    ,nvl(n.changetype, o.changetype) as changetype -- 变更原因
    ,nvl(n.hxtyoperateorg, o.hxtyoperateorg) as hxtyoperateorg -- 归口管理部门
    ,nvl(n.classifyresulteleven, o.classifyresulteleven) as classifyresulteleven -- 债项分类
    ,nvl(n.iscreditincrement, o.iscreditincrement) as iscreditincrement -- 是否有增信
    ,nvl(n.hxtymainratelevel, o.hxtymainratelevel) as hxtymainratelevel -- 外部主体评级
    ,nvl(n.mainlevelorg, o.mainlevelorg) as mainlevelorg -- 主体评级机构
    ,nvl(n.mainleveldate, o.mainleveldate) as mainleveldate -- 主体评级日期
    ,nvl(n.purpose, o.purpose) as purpose -- 资金用途
    ,nvl(n.investtarget, o.investtarget) as investtarget -- 投资标的
    ,nvl(n.publicorg, o.publicorg) as publicorg -- 发行场所
    ,nvl(n.approvepubsum, o.approvepubsum) as approvepubsum -- 批准发行总额
    ,nvl(n.publishsum, o.publishsum) as publishsum -- 本次发行金额
    ,nvl(n.issuername, o.issuername) as issuername -- 发行人名称
    ,nvl(n.issuerid, o.issuerid) as issuerid -- 发行人编号
    ,nvl(n.originalname, o.originalname) as originalname -- 原始权益人名称
    ,nvl(n.originalid, o.originalid) as originalid -- 原始权益人编号
    ,nvl(n.channelname, o.channelname) as channelname -- 通道方名称
    ,nvl(n.channelid, o.channelid) as channelid -- 通道方编号
    ,nvl(n.managename, o.managename) as managename -- 管理人名称
    ,nvl(n.manageid, o.manageid) as manageid -- 管理人客户号
    ,nvl(n.ispenetrate, o.ispenetrate) as ispenetrate -- 是否可穿透
    ,nvl(n.moneyindustryt, o.moneyindustryt) as moneyindustryt -- 资金投向行业
    ,nvl(n.supplychain, o.supplychain) as supplychain -- 供应链业务单占核心企业额度
    ,nvl(n.islikelowrisk, o.islikelowrisk) as islikelowrisk -- 是否类低风险
    ,nvl(n.focuslendtype, o.focuslendtype) as focuslendtype -- 集中放款业务类型
    ,nvl(n.isinnovate, o.isinnovate) as isinnovate -- 是否创新业务
    ,nvl(n.issupplychainfinance, o.issupplychainfinance) as issupplychainfinance -- 是否供应链金融业务
    ,nvl(n.lmttyp, o.lmttyp) as lmttyp -- 同业额度合同-额度类型
    ,nvl(n.sqdkze, o.sqdkze) as sqdkze -- 
    ,nvl(n.isjoinlimits, o.isjoinlimits) as isjoinlimits -- 
    ,nvl(n.otherlimitamount, o.otherlimitamount) as otherlimitamount -- 
    ,nvl(n.iscollectionagency, o.iscollectionagency) as iscollectionagency -- 
    ,nvl(n.islimit, o.islimit) as islimit -- 
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
from (select * from ${iol_schema}.icms_bc_cl_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_bc_cl_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.lineclass <> n.lineclass
        or o.currencyrange <> n.currencyrange
        or o.lngotimes <> n.lngotimes
        or o.occupynominalsum <> n.occupynominalsum
        or o.afterloanuserid <> n.afterloanuserid
        or o.creditflowtype <> n.creditflowtype
        or o.creditarea <> n.creditarea
        or o.approvalsuggestion <> n.approvalsuggestion
        or o.useterm <> n.useterm
        or o.freezeflag <> n.freezeflag
        or o.bizlongestterm <> n.bizlongestterm
        or o.occupyexposuresum <> n.occupyexposuresum
        or o.limitusecondition <> n.limitusecondition
        or o.classifytype2 <> n.classifytype2
        or o.bizextendedterm <> n.bizextendedterm
        or o.outclassifydate <> n.outclassifydate
        or o.termtype <> n.termtype
        or o.availablenominalsum <> n.availablenominalsum
        or o.afterloanorgid <> n.afterloanorgid
        or o.outclassifyorg <> n.outclassifyorg
        or o.investway <> n.investway
        or o.bizlowestfloatrate <> n.bizlowestfloatrate
        or o.guarantybailsubaccount <> n.guarantybailsubaccount
        or o.isrz <> n.isrz
        or o.isgovernfinance <> n.isgovernfinance
        or o.isgreenfinance <> n.isgreenfinance
        or o.maxnominalamount <> n.maxnominalamount
        or o.usewithoutcondition <> n.usewithoutcondition
        or o.businesstype2 <> n.businesstype2
        or o.fundsource <> n.fundsource
        or o.playtype <> n.playtype
        or o.bizmostmortgagerate <> n.bizmostmortgagerate
        or o.bizbailinitialrate <> n.bizbailinitialrate
        or o.availableexposuresum <> n.availableexposuresum
        or o.syndicatetotalsum <> n.syndicatetotalsum
        or o.isbeltroadfinance <> n.isbeltroadfinance
        or o.migtflag <> n.migtflag
        or o.istrans <> n.istrans
        or o.linecontrolmode <> n.linecontrolmode
        or o.otherlimitflag <> n.otherlimitflag
        or o.singlebizmostamount <> n.singlebizmostamount
        or o.exposuresum <> n.exposuresum
        or o.putoutorgid <> n.putoutorgid
        or o.riskexposuresum <> n.riskexposuresum
        or o.isquerycreditreport <> n.isquerycreditreport
        or o.onlineamount <> n.onlineamount
        or o.isconsumerfinance <> n.isconsumerfinance
        or o.maxexposureamount <> n.maxexposureamount
        or o.ispubliccredit <> n.ispubliccredit
        or o.creditauthno <> n.creditauthno
        or o.islikeloan <> n.islikeloan
        or o.lowriskexposuresum <> n.lowriskexposuresum
        or o.drtimes <> n.drtimes
        or o.guarantybailaccount <> n.guarantybailaccount
        or o.nominalsum <> n.nominalsum
        or o.latestusedate <> n.latestusedate
        or o.outclassifylevel <> n.outclassifylevel
        or o.isestatefinance <> n.isestatefinance
        or o.noeffectreason <> n.noeffectreason
        or o.changetype <> n.changetype
        or o.hxtyoperateorg <> n.hxtyoperateorg
        or o.classifyresulteleven <> n.classifyresulteleven
        or o.iscreditincrement <> n.iscreditincrement
        or o.hxtymainratelevel <> n.hxtymainratelevel
        or o.mainlevelorg <> n.mainlevelorg
        or o.mainleveldate <> n.mainleveldate
        or o.purpose <> n.purpose
        or o.investtarget <> n.investtarget
        or o.publicorg <> n.publicorg
        or o.approvepubsum <> n.approvepubsum
        or o.publishsum <> n.publishsum
        or o.issuername <> n.issuername
        or o.issuerid <> n.issuerid
        or o.originalname <> n.originalname
        or o.originalid <> n.originalid
        or o.channelname <> n.channelname
        or o.channelid <> n.channelid
        or o.managename <> n.managename
        or o.manageid <> n.manageid
        or o.ispenetrate <> n.ispenetrate
        or o.moneyindustryt <> n.moneyindustryt
        or o.supplychain <> n.supplychain
        or o.islikelowrisk <> n.islikelowrisk
        or o.focuslendtype <> n.focuslendtype
        or o.isinnovate <> n.isinnovate
        or o.issupplychainfinance <> n.issupplychainfinance
        or o.lmttyp <> n.lmttyp
        or o.sqdkze <> n.sqdkze
        or o.isjoinlimits <> n.isjoinlimits
        or o.otherlimitamount <> n.otherlimitamount
        or o.iscollectionagency <> n.iscollectionagency
        or o.islimit <> n.islimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_bc_cl_info_cl(
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,sqdkze -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_bc_cl_info_op(
            serialno -- 流水号
            ,lineclass -- 额度种类综合/专项/其他)
            ,currencyrange -- 项下业务币种范围
            ,lngotimes -- 借新还旧次数
            ,occupynominalsum -- 已用名义金额自动计算)
            ,afterloanuserid -- 贷后管理人员
            ,creditflowtype -- 授信业务流程类型
            ,creditarea -- 授信区域
            ,approvalsuggestion -- 建议审批等级
            ,useterm -- 额度项下业务最迟到期日期
            ,freezeflag -- 冻结标志
            ,bizlongestterm -- 额度下业务最长期限月)
            ,occupyexposuresum -- 已用敞口金额自动计算)
            ,limitusecondition -- 额度使用条件
            ,classifytype2 -- 风险暴露分类
            ,bizextendedterm -- 额度下业务延展期限月)
            ,outclassifydate -- 外部评级日期
            ,termtype -- 期限申请类型额度)
            ,availablenominalsum -- 可用名义金额
            ,afterloanorgid -- 贷后管理机构
            ,outclassifyorg -- 外部评级机构
            ,investway -- 投资方式
            ,bizlowestfloatrate -- 额度下业务利率最低浮动
            ,guarantybailsubaccount -- 押品转保证金子户号
            ,isrz -- 是否融资合同
            ,isgovernfinance -- 是否涉及政府类融资
            ,isgreenfinance -- 是否为绿色信贷融资
            ,maxnominalamount -- 单一最高授信额度名义金额
            ,usewithoutcondition -- 能否直接使用额度)
            ,businesstype2 -- 专业贷款分类
            ,fundsource -- 资金来源
            ,playtype -- 参与方式
            ,bizmostmortgagerate -- 额度下业务最高抵质押率
            ,bizbailinitialrate -- 额度下业务初始保证金比例
            ,availableexposuresum -- 可用敞口金额
            ,syndicatetotalsum -- 银团贷款总金额
            ,isbeltroadfinance -- 是否为一带一路建设投融资
            ,migtflag -- 
            ,istrans -- 是否转授信
            ,linecontrolmode -- 集团额度管控模式超额分配/全额分配)
            ,otherlimitflag -- 是否占用他用额度
            ,singlebizmostamount -- 额度下业务单笔最大金额
            ,exposuresum -- 额度敞口金额
            ,putoutorgid -- 放贷机构
            ,riskexposuresum -- 其中，一般风险敞口金额(元)
            ,isquerycreditreport -- 是否自动查询贷后报告
            ,onlineamount -- 线上额度(元)
            ,isconsumerfinance -- 是否为消费服务类融资
            ,maxexposureamount -- 单一最高授信额度敞口金额
            ,ispubliccredit -- 是否公开授信额度)
            ,creditauthno -- 征信授权影像流水号
            ,islikeloan -- 是否类信贷
            ,lowriskexposuresum -- 其中，类低风险敞口金额(元)
            ,drtimes -- 债务重组次数
            ,guarantybailaccount -- 押品转保证金账号
            ,nominalsum -- 额度名义金额
            ,latestusedate -- 额度最迟使用日期
            ,outclassifylevel -- 外部债项评级
            ,isestatefinance -- 是否涉及房地产融资
            ,noeffectreason -- 失效原因
            ,changetype -- 变更原因
            ,hxtyoperateorg -- 归口管理部门
            ,classifyresulteleven -- 债项分类
            ,iscreditincrement -- 是否有增信
            ,hxtymainratelevel -- 外部主体评级
            ,mainlevelorg -- 主体评级机构
            ,mainleveldate -- 主体评级日期
            ,purpose -- 资金用途
            ,investtarget -- 投资标的
            ,publicorg -- 发行场所
            ,approvepubsum -- 批准发行总额
            ,publishsum -- 本次发行金额
            ,issuername -- 发行人名称
            ,issuerid -- 发行人编号
            ,originalname -- 原始权益人名称
            ,originalid -- 原始权益人编号
            ,channelname -- 通道方名称
            ,channelid -- 通道方编号
            ,managename -- 管理人名称
            ,manageid -- 管理人客户号
            ,ispenetrate -- 是否可穿透
            ,moneyindustryt -- 资金投向行业
            ,supplychain -- 供应链业务单占核心企业额度
            ,islikelowrisk -- 是否类低风险
            ,focuslendtype -- 集中放款业务类型
            ,isinnovate -- 是否创新业务
            ,issupplychainfinance -- 是否供应链金融业务
            ,lmttyp -- 同业额度合同-额度类型
            ,sqdkze -- 
            ,isjoinlimits -- 
            ,otherlimitamount -- 
            ,iscollectionagency -- 
            ,islimit -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.lineclass -- 额度种类综合/专项/其他)
    ,o.currencyrange -- 项下业务币种范围
    ,o.lngotimes -- 借新还旧次数
    ,o.occupynominalsum -- 已用名义金额自动计算)
    ,o.afterloanuserid -- 贷后管理人员
    ,o.creditflowtype -- 授信业务流程类型
    ,o.creditarea -- 授信区域
    ,o.approvalsuggestion -- 建议审批等级
    ,o.useterm -- 额度项下业务最迟到期日期
    ,o.freezeflag -- 冻结标志
    ,o.bizlongestterm -- 额度下业务最长期限月)
    ,o.occupyexposuresum -- 已用敞口金额自动计算)
    ,o.limitusecondition -- 额度使用条件
    ,o.classifytype2 -- 风险暴露分类
    ,o.bizextendedterm -- 额度下业务延展期限月)
    ,o.outclassifydate -- 外部评级日期
    ,o.termtype -- 期限申请类型额度)
    ,o.availablenominalsum -- 可用名义金额
    ,o.afterloanorgid -- 贷后管理机构
    ,o.outclassifyorg -- 外部评级机构
    ,o.investway -- 投资方式
    ,o.bizlowestfloatrate -- 额度下业务利率最低浮动
    ,o.guarantybailsubaccount -- 押品转保证金子户号
    ,o.isrz -- 是否融资合同
    ,o.isgovernfinance -- 是否涉及政府类融资
    ,o.isgreenfinance -- 是否为绿色信贷融资
    ,o.maxnominalamount -- 单一最高授信额度名义金额
    ,o.usewithoutcondition -- 能否直接使用额度)
    ,o.businesstype2 -- 专业贷款分类
    ,o.fundsource -- 资金来源
    ,o.playtype -- 参与方式
    ,o.bizmostmortgagerate -- 额度下业务最高抵质押率
    ,o.bizbailinitialrate -- 额度下业务初始保证金比例
    ,o.availableexposuresum -- 可用敞口金额
    ,o.syndicatetotalsum -- 银团贷款总金额
    ,o.isbeltroadfinance -- 是否为一带一路建设投融资
    ,o.migtflag -- 
    ,o.istrans -- 是否转授信
    ,o.linecontrolmode -- 集团额度管控模式超额分配/全额分配)
    ,o.otherlimitflag -- 是否占用他用额度
    ,o.singlebizmostamount -- 额度下业务单笔最大金额
    ,o.exposuresum -- 额度敞口金额
    ,o.putoutorgid -- 放贷机构
    ,o.riskexposuresum -- 其中，一般风险敞口金额(元)
    ,o.isquerycreditreport -- 是否自动查询贷后报告
    ,o.onlineamount -- 线上额度(元)
    ,o.isconsumerfinance -- 是否为消费服务类融资
    ,o.maxexposureamount -- 单一最高授信额度敞口金额
    ,o.ispubliccredit -- 是否公开授信额度)
    ,o.creditauthno -- 征信授权影像流水号
    ,o.islikeloan -- 是否类信贷
    ,o.lowriskexposuresum -- 其中，类低风险敞口金额(元)
    ,o.drtimes -- 债务重组次数
    ,o.guarantybailaccount -- 押品转保证金账号
    ,o.nominalsum -- 额度名义金额
    ,o.latestusedate -- 额度最迟使用日期
    ,o.outclassifylevel -- 外部债项评级
    ,o.isestatefinance -- 是否涉及房地产融资
    ,o.noeffectreason -- 失效原因
    ,o.changetype -- 变更原因
    ,o.hxtyoperateorg -- 归口管理部门
    ,o.classifyresulteleven -- 债项分类
    ,o.iscreditincrement -- 是否有增信
    ,o.hxtymainratelevel -- 外部主体评级
    ,o.mainlevelorg -- 主体评级机构
    ,o.mainleveldate -- 主体评级日期
    ,o.purpose -- 资金用途
    ,o.investtarget -- 投资标的
    ,o.publicorg -- 发行场所
    ,o.approvepubsum -- 批准发行总额
    ,o.publishsum -- 本次发行金额
    ,o.issuername -- 发行人名称
    ,o.issuerid -- 发行人编号
    ,o.originalname -- 原始权益人名称
    ,o.originalid -- 原始权益人编号
    ,o.channelname -- 通道方名称
    ,o.channelid -- 通道方编号
    ,o.managename -- 管理人名称
    ,o.manageid -- 管理人客户号
    ,o.ispenetrate -- 是否可穿透
    ,o.moneyindustryt -- 资金投向行业
    ,o.supplychain -- 供应链业务单占核心企业额度
    ,o.islikelowrisk -- 是否类低风险
    ,o.focuslendtype -- 集中放款业务类型
    ,o.isinnovate -- 是否创新业务
    ,o.issupplychainfinance -- 是否供应链金融业务
    ,o.lmttyp -- 同业额度合同-额度类型
    ,o.sqdkze -- 
    ,o.isjoinlimits -- 
    ,o.otherlimitamount -- 
    ,o.iscollectionagency -- 
    ,o.islimit -- 
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
from ${iol_schema}.icms_bc_cl_info_bk o
    left join ${iol_schema}.icms_bc_cl_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_bc_cl_info_cl d
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
--truncate table ${iol_schema}.icms_bc_cl_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_bc_cl_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_bc_cl_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_bc_cl_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_bc_cl_info exchange partition p_${batch_date} with table ${iol_schema}.icms_bc_cl_info_cl;
alter table ${iol_schema}.icms_bc_cl_info exchange partition p_20991231 with table ${iol_schema}.icms_bc_cl_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_bc_cl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_bc_cl_info_op purge;
drop table ${iol_schema}.icms_bc_cl_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_bc_cl_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_bc_cl_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
