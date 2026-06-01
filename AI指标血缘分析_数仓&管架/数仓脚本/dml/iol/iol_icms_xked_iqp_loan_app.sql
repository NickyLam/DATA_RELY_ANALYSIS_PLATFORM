/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_xked_iqp_loan_app
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
create table ${iol_schema}.icms_xked_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_xked_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_xked_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_xked_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_xked_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_xked_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_xked_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_xked_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_xked_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,channel -- 接入渠道
            ,termmonth -- 贷款期限
            ,loadamount -- 申请金额
            ,inputid -- 客户经理号
            ,dwellareacode -- 额度是否循环
            ,dwelladdress -- 主担保方式
            ,taxstrdate -- 产品分类标志
            ,enterprisename -- 企业名称
            ,entidttp -- 企业身份标识类型
            ,entidtno -- 企业身份标识号码
            ,businessscope -- 经营地址所属省
            ,validitedate -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 经营详细地址
            ,sciencetechenttype -- 科创企业类型
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,entsolftcopyrightregnum -- 企业软著登记公告次数
            ,entknowledgepropnum -- 企业知识产权数量
            ,knowledgepropinventnum -- 知识产权发明数量
            ,intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
            ,knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
            ,knowledgepropunfaircompenum -- 知识产权不正当竞争次数
            ,knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
            ,past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
            ,past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
            ,past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
            ,past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
            ,past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
            ,past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
            ,past24minvoicrevenue -- 近24个月开票收入
            ,annualhightechproincome -- 本年度高新技术产品（服务）收入
            ,preyearhightechproincome -- 上年度高新技术产品（服务）收入
            ,annualoperaincome -- 本年度营业收入
            ,annualempsnum -- 本年度从业人数（人）
            ,preyearempsnum -- 上年度从业人数
            ,annualtechninum -- 本年度科技人员人数
            ,preyeartechninum -- 上年度科技人员人数
            ,annualresearchdevamt -- 本年度研发费用金额
            ,preyearresearchdevamt -- 上年度研发费用金额
            ,annualentgetgovsusidy -- 本年度企业获取政府补贴收入
            ,preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
            ,forecastnextyearsale -- 预测次年销售量
            ,otherchannelworkcapit -- 其他渠道提供的运营资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
            ,nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,isknowledgepledged -- 知识产权是否质押
            ,knowledgepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 系统来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,custname -- 法人代表人姓名
            ,sex -- 法人代表人性别
            ,nation -- 法人代表人国籍
            ,idtype -- 法人代表人证件类型
            ,idno -- 法人代表人身份证号码
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,approvestatus -- 审批状态
            ,finalapplyamount -- 终审额度
            ,transstatus -- 流程状态
            ,status -- 任务状态
            ,branchid -- 所属分行
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分卡得分
            ,apprendtime -- 营业日期
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bizscope -- 经营范围
            ,registerdaddress -- 企业注册地址
            ,enttermduedate -- 企业营业期限到期日
            ,bano -- 授信申请编号
            ,taxqueryflag -- 税务查询标志
            ,taxauthorizeno -- 税务授权流水号
            ,taxpayeridentityno -- 纳税人识别号
            ,istaxsuccessgs -- 广税授权是否成功
            ,idexpirydate -- 企业证件到期日
            ,loanendtime -- 终审结束时间
            ,loanstarttime -- 终审申请时间
            ,opercorpflg -- 经营企业是否涉及专精特新
            ,loanusage -- 贷款用途
            ,brwercorpoperscope -- 企业经营范围
            ,enterstartdate -- 企业经营有效期起始日
            ,enterenddate -- 企业经营有效期到期日
            ,setupdate -- 企业成立日期
            ,massage -- 拒绝原因
            ,isrelateent -- 是否关联企业
            ,isgarden -- 是否园区贷
            ,informflag -- 终审通知成功与否
            ,completeflag -- 数据完善标志；码值为CompleteFlag
            ,channlefrom -- 线上线下标志：1线下，2线上
            ,customerid -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_xked_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,channel -- 接入渠道
            ,termmonth -- 贷款期限
            ,loadamount -- 申请金额
            ,inputid -- 客户经理号
            ,dwellareacode -- 额度是否循环
            ,dwelladdress -- 主担保方式
            ,taxstrdate -- 产品分类标志
            ,enterprisename -- 企业名称
            ,entidttp -- 企业身份标识类型
            ,entidtno -- 企业身份标识号码
            ,businessscope -- 经营地址所属省
            ,validitedate -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 经营详细地址
            ,sciencetechenttype -- 科创企业类型
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,entsolftcopyrightregnum -- 企业软著登记公告次数
            ,entknowledgepropnum -- 企业知识产权数量
            ,knowledgepropinventnum -- 知识产权发明数量
            ,intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
            ,knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
            ,knowledgepropunfaircompenum -- 知识产权不正当竞争次数
            ,knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
            ,past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
            ,past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
            ,past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
            ,past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
            ,past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
            ,past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
            ,past24minvoicrevenue -- 近24个月开票收入
            ,annualhightechproincome -- 本年度高新技术产品（服务）收入
            ,preyearhightechproincome -- 上年度高新技术产品（服务）收入
            ,annualoperaincome -- 本年度营业收入
            ,annualempsnum -- 本年度从业人数（人）
            ,preyearempsnum -- 上年度从业人数
            ,annualtechninum -- 本年度科技人员人数
            ,preyeartechninum -- 上年度科技人员人数
            ,annualresearchdevamt -- 本年度研发费用金额
            ,preyearresearchdevamt -- 上年度研发费用金额
            ,annualentgetgovsusidy -- 本年度企业获取政府补贴收入
            ,preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
            ,forecastnextyearsale -- 预测次年销售量
            ,otherchannelworkcapit -- 其他渠道提供的运营资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
            ,nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,isknowledgepledged -- 知识产权是否质押
            ,knowledgepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 系统来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,custname -- 法人代表人姓名
            ,sex -- 法人代表人性别
            ,nation -- 法人代表人国籍
            ,idtype -- 法人代表人证件类型
            ,idno -- 法人代表人身份证号码
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,approvestatus -- 审批状态
            ,finalapplyamount -- 终审额度
            ,transstatus -- 流程状态
            ,status -- 任务状态
            ,branchid -- 所属分行
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分卡得分
            ,apprendtime -- 营业日期
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bizscope -- 经营范围
            ,registerdaddress -- 企业注册地址
            ,enttermduedate -- 企业营业期限到期日
            ,bano -- 授信申请编号
            ,taxqueryflag -- 税务查询标志
            ,taxauthorizeno -- 税务授权流水号
            ,taxpayeridentityno -- 纳税人识别号
            ,istaxsuccessgs -- 广税授权是否成功
            ,idexpirydate -- 企业证件到期日
            ,loanendtime -- 终审结束时间
            ,loanstarttime -- 终审申请时间
            ,opercorpflg -- 经营企业是否涉及专精特新
            ,loanusage -- 贷款用途
            ,brwercorpoperscope -- 企业经营范围
            ,enterstartdate -- 企业经营有效期起始日
            ,enterenddate -- 企业经营有效期到期日
            ,setupdate -- 企业成立日期
            ,massage -- 拒绝原因
            ,isrelateent -- 是否关联企业
            ,isgarden -- 是否园区贷
            ,informflag -- 终审通知成功与否
            ,completeflag -- 数据完善标志；码值为CompleteFlag
            ,channlefrom -- 线上线下标志：1线下，2线上
            ,customerid -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.channel, o.channel) as channel -- 接入渠道
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 贷款期限
    ,nvl(n.loadamount, o.loadamount) as loadamount -- 申请金额
    ,nvl(n.inputid, o.inputid) as inputid -- 客户经理号
    ,nvl(n.dwellareacode, o.dwellareacode) as dwellareacode -- 额度是否循环
    ,nvl(n.dwelladdress, o.dwelladdress) as dwelladdress -- 主担保方式
    ,nvl(n.taxstrdate, o.taxstrdate) as taxstrdate -- 产品分类标志
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.entidttp, o.entidttp) as entidttp -- 企业身份标识类型
    ,nvl(n.entidtno, o.entidtno) as entidtno -- 企业身份标识号码
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营地址所属省
    ,nvl(n.validitedate, o.validitedate) as validitedate -- 经营地址所属市
    ,nvl(n.registerarea, o.registerarea) as registerarea -- 经营地址所属县（区）
    ,nvl(n.registeraddress, o.registeraddress) as registeraddress -- 经营详细地址
    ,nvl(n.sciencetechenttype, o.sciencetechenttype) as sciencetechenttype -- 科创企业类型
    ,nvl(n.actualcontrollerempyears, o.actualcontrollerempyears) as actualcontrollerempyears -- 实控人从业年限（年）
    ,nvl(n.flowannualsalesrevenue, o.flowannualsalesrevenue) as flowannualsalesrevenue -- 流水推算的年销售收入
    ,nvl(n.entsolftcopyrightregnum, o.entsolftcopyrightregnum) as entsolftcopyrightregnum -- 企业软著登记公告次数
    ,nvl(n.entknowledgepropnum, o.entknowledgepropnum) as entknowledgepropnum -- 企业知识产权数量
    ,nvl(n.knowledgepropinventnum, o.knowledgepropinventnum) as knowledgepropinventnum -- 知识产权发明数量
    ,nvl(n.intefcircuitlayoutdesignappnum, o.intefcircuitlayoutdesignappnum) as intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
    ,nvl(n.knowledgepropinfrinpunishnum, o.knowledgepropinfrinpunishnum) as knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
    ,nvl(n.knowledgepropunfaircompenum, o.knowledgepropunfaircompenum) as knowledgepropunfaircompenum -- 知识产权不正当竞争次数
    ,nvl(n.knowledgepropjudgdocdefentnum, o.knowledgepropjudgdocdefentnum) as knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
    ,nvl(n.past24mupstreamtop5purchamt, o.past24mupstreamtop5purchamt) as past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
    ,nvl(n.past24mupstreamintegpurchamt, o.past24mupstreamintegpurchamt) as past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
    ,nvl(n.past24mdownstreamtop5saleamt, o.past24mdownstreamtop5saleamt) as past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
    ,nvl(n.past24mdownstreamintegsaleamt, o.past24mdownstreamintegsaleamt) as past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
    ,nvl(n.past12mispartnertop10transamt, o.past12mispartnertop10transamt) as past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
    ,nvl(n.past12miscusttop10transamt, o.past12miscusttop10transamt) as past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
    ,nvl(n.past24minvoicrevenue, o.past24minvoicrevenue) as past24minvoicrevenue -- 近24个月开票收入
    ,nvl(n.annualhightechproincome, o.annualhightechproincome) as annualhightechproincome -- 本年度高新技术产品（服务）收入
    ,nvl(n.preyearhightechproincome, o.preyearhightechproincome) as preyearhightechproincome -- 上年度高新技术产品（服务）收入
    ,nvl(n.annualoperaincome, o.annualoperaincome) as annualoperaincome -- 本年度营业收入
    ,nvl(n.annualempsnum, o.annualempsnum) as annualempsnum -- 本年度从业人数（人）
    ,nvl(n.preyearempsnum, o.preyearempsnum) as preyearempsnum -- 上年度从业人数
    ,nvl(n.annualtechninum, o.annualtechninum) as annualtechninum -- 本年度科技人员人数
    ,nvl(n.preyeartechninum, o.preyeartechninum) as preyeartechninum -- 上年度科技人员人数
    ,nvl(n.annualresearchdevamt, o.annualresearchdevamt) as annualresearchdevamt -- 本年度研发费用金额
    ,nvl(n.preyearresearchdevamt, o.preyearresearchdevamt) as preyearresearchdevamt -- 上年度研发费用金额
    ,nvl(n.annualentgetgovsusidy, o.annualentgetgovsusidy) as annualentgetgovsusidy -- 本年度企业获取政府补贴收入
    ,nvl(n.preyearentgetgovsusidy, o.preyearentgetgovsusidy) as preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
    ,nvl(n.forecastnextyearsale, o.forecastnextyearsale) as forecastnextyearsale -- 预测次年销售量
    ,nvl(n.otherchannelworkcapit, o.otherchannelworkcapit) as otherchannelworkcapit -- 其他渠道提供的运营资金
    ,nvl(n.nocrediteachdebtaccubalance, o.nocrediteachdebtaccubalance) as nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
    ,nvl(n.nocreditmonthaccurepaydebt, o.nocreditmonthaccurepaydebt) as nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
    ,nvl(n.entmonthrepaybalance, o.entmonthrepaybalance) as entmonthrepaybalance -- 企业月还款额
    ,nvl(n.ispledgedreceiveaccount, o.ispledgedreceiveaccount) as ispledgedreceiveaccount -- 企业应收账款是否质押
    ,nvl(n.pledgereceiveamt, o.pledgereceiveamt) as pledgereceiveamt -- 应收账款质押贷款金额
    ,nvl(n.isknowledgepledged, o.isknowledgepledged) as isknowledgepledged -- 知识产权是否质押
    ,nvl(n.knowledgepledgereceiveamt, o.knowledgepledgereceiveamt) as knowledgepledgereceiveamt -- 知识产权质押贷款金额
    ,nvl(n.isstockpledged, o.isstockpledged) as isstockpledged -- 股权是否质押
    ,nvl(n.stockpledgedamt, o.stockpledgedamt) as stockpledgedamt -- 股权质押贷款金额
    ,nvl(n.qryusertype, o.qryusertype) as qryusertype -- 征信查询人类型
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 征信查询操作申请类型
    ,nvl(n.partner, o.partner) as partner -- 系统来源
    ,nvl(n.reportusernm, o.reportusernm) as reportusernm -- 报告使用人姓名
    ,nvl(n.reportuseroff, o.reportuseroff) as reportuseroff -- 报告使用人所属部门
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.custname, o.custname) as custname -- 法人代表人姓名
    ,nvl(n.sex, o.sex) as sex -- 法人代表人性别
    ,nvl(n.nation, o.nation) as nation -- 法人代表人国籍
    ,nvl(n.idtype, o.idtype) as idtype -- 法人代表人证件类型
    ,nvl(n.idno, o.idno) as idno -- 法人代表人身份证号码
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 终审额度
    ,nvl(n.transstatus, o.transstatus) as transstatus -- 流程状态
    ,nvl(n.status, o.status) as status -- 任务状态
    ,nvl(n.branchid, o.branchid) as branchid -- 所属分行
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联人
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分卡得分
    ,nvl(n.apprendtime, o.apprendtime) as apprendtime -- 营业日期
    ,nvl(n.risknote, o.risknote) as risknote -- 备注
    ,nvl(n.riskwarm, o.riskwarm) as riskwarm -- 预警
    ,nvl(n.tradecode, o.tradecode) as tradecode -- 行业类型
    ,nvl(n.empcountyear, o.empcountyear) as empcountyear -- 从业人数
    ,nvl(n.tatalasset, o.tatalasset) as tatalasset -- 资产合计
    ,nvl(n.proceeds, o.proceeds) as proceeds -- 营业收入
    ,nvl(n.scale, o.scale) as scale -- 企业规模
    ,nvl(n.bizscope, o.bizscope) as bizscope -- 经营范围
    ,nvl(n.registerdaddress, o.registerdaddress) as registerdaddress -- 企业注册地址
    ,nvl(n.enttermduedate, o.enttermduedate) as enttermduedate -- 企业营业期限到期日
    ,nvl(n.bano, o.bano) as bano -- 授信申请编号
    ,nvl(n.taxqueryflag, o.taxqueryflag) as taxqueryflag -- 税务查询标志
    ,nvl(n.taxauthorizeno, o.taxauthorizeno) as taxauthorizeno -- 税务授权流水号
    ,nvl(n.taxpayeridentityno, o.taxpayeridentityno) as taxpayeridentityno -- 纳税人识别号
    ,nvl(n.istaxsuccessgs, o.istaxsuccessgs) as istaxsuccessgs -- 广税授权是否成功
    ,nvl(n.idexpirydate, o.idexpirydate) as idexpirydate -- 企业证件到期日
    ,nvl(n.loanendtime, o.loanendtime) as loanendtime -- 终审结束时间
    ,nvl(n.loanstarttime, o.loanstarttime) as loanstarttime -- 终审申请时间
    ,nvl(n.opercorpflg, o.opercorpflg) as opercorpflg -- 经营企业是否涉及专精特新
    ,nvl(n.loanusage, o.loanusage) as loanusage -- 贷款用途
    ,nvl(n.brwercorpoperscope, o.brwercorpoperscope) as brwercorpoperscope -- 企业经营范围
    ,nvl(n.enterstartdate, o.enterstartdate) as enterstartdate -- 企业经营有效期起始日
    ,nvl(n.enterenddate, o.enterenddate) as enterenddate -- 企业经营有效期到期日
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 企业成立日期
    ,nvl(n.massage, o.massage) as massage -- 拒绝原因
    ,nvl(n.isrelateent, o.isrelateent) as isrelateent -- 是否关联企业
    ,nvl(n.isgarden, o.isgarden) as isgarden -- 是否园区贷
    ,nvl(n.informflag, o.informflag) as informflag -- 终审通知成功与否
    ,nvl(n.completeflag, o.completeflag) as completeflag -- 数据完善标志；码值为CompleteFlag
    ,nvl(n.channlefrom, o.channlefrom) as channlefrom -- 线上线下标志：1线下，2线上
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
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
from (select * from ${iol_schema}.icms_xked_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_xked_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.prdname <> n.prdname
        or o.channel <> n.channel
        or o.termmonth <> n.termmonth
        or o.loadamount <> n.loadamount
        or o.inputid <> n.inputid
        or o.dwellareacode <> n.dwellareacode
        or o.dwelladdress <> n.dwelladdress
        or o.taxstrdate <> n.taxstrdate
        or o.enterprisename <> n.enterprisename
        or o.entidttp <> n.entidttp
        or o.entidtno <> n.entidtno
        or o.businessscope <> n.businessscope
        or o.validitedate <> n.validitedate
        or o.registerarea <> n.registerarea
        or o.registeraddress <> n.registeraddress
        or o.sciencetechenttype <> n.sciencetechenttype
        or o.actualcontrollerempyears <> n.actualcontrollerempyears
        or o.flowannualsalesrevenue <> n.flowannualsalesrevenue
        or o.entsolftcopyrightregnum <> n.entsolftcopyrightregnum
        or o.entknowledgepropnum <> n.entknowledgepropnum
        or o.knowledgepropinventnum <> n.knowledgepropinventnum
        or o.intefcircuitlayoutdesignappnum <> n.intefcircuitlayoutdesignappnum
        or o.knowledgepropinfrinpunishnum <> n.knowledgepropinfrinpunishnum
        or o.knowledgepropunfaircompenum <> n.knowledgepropunfaircompenum
        or o.knowledgepropjudgdocdefentnum <> n.knowledgepropjudgdocdefentnum
        or o.past24mupstreamtop5purchamt <> n.past24mupstreamtop5purchamt
        or o.past24mupstreamintegpurchamt <> n.past24mupstreamintegpurchamt
        or o.past24mdownstreamtop5saleamt <> n.past24mdownstreamtop5saleamt
        or o.past24mdownstreamintegsaleamt <> n.past24mdownstreamintegsaleamt
        or o.past12mispartnertop10transamt <> n.past12mispartnertop10transamt
        or o.past12miscusttop10transamt <> n.past12miscusttop10transamt
        or o.past24minvoicrevenue <> n.past24minvoicrevenue
        or o.annualhightechproincome <> n.annualhightechproincome
        or o.preyearhightechproincome <> n.preyearhightechproincome
        or o.annualoperaincome <> n.annualoperaincome
        or o.annualempsnum <> n.annualempsnum
        or o.preyearempsnum <> n.preyearempsnum
        or o.annualtechninum <> n.annualtechninum
        or o.preyeartechninum <> n.preyeartechninum
        or o.annualresearchdevamt <> n.annualresearchdevamt
        or o.preyearresearchdevamt <> n.preyearresearchdevamt
        or o.annualentgetgovsusidy <> n.annualentgetgovsusidy
        or o.preyearentgetgovsusidy <> n.preyearentgetgovsusidy
        or o.forecastnextyearsale <> n.forecastnextyearsale
        or o.otherchannelworkcapit <> n.otherchannelworkcapit
        or o.nocrediteachdebtaccubalance <> n.nocrediteachdebtaccubalance
        or o.nocreditmonthaccurepaydebt <> n.nocreditmonthaccurepaydebt
        or o.entmonthrepaybalance <> n.entmonthrepaybalance
        or o.ispledgedreceiveaccount <> n.ispledgedreceiveaccount
        or o.pledgereceiveamt <> n.pledgereceiveamt
        or o.isknowledgepledged <> n.isknowledgepledged
        or o.knowledgepledgereceiveamt <> n.knowledgepledgereceiveamt
        or o.isstockpledged <> n.isstockpledged
        or o.stockpledgedamt <> n.stockpledgedamt
        or o.qryusertype <> n.qryusertype
        or o.qryopertp <> n.qryopertp
        or o.partner <> n.partner
        or o.reportusernm <> n.reportusernm
        or o.reportuseroff <> n.reportuseroff
        or o.authotype <> n.authotype
        or o.biometrics <> n.biometrics
        or o.authotime <> n.authotime
        or o.authostrdate <> n.authostrdate
        or o.authoenddate <> n.authoenddate
        or o.custname <> n.custname
        or o.sex <> n.sex
        or o.nation <> n.nation
        or o.idtype <> n.idtype
        or o.idno <> n.idno
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.approvestatus <> n.approvestatus
        or o.finalapplyamount <> n.finalapplyamount
        or o.transstatus <> n.transstatus
        or o.status <> n.status
        or o.branchid <> n.branchid
        or o.isbankrel <> n.isbankrel
        or o.autoscore <> n.autoscore
        or o.apprendtime <> n.apprendtime
        or o.risknote <> n.risknote
        or o.riskwarm <> n.riskwarm
        or o.tradecode <> n.tradecode
        or o.empcountyear <> n.empcountyear
        or o.tatalasset <> n.tatalasset
        or o.proceeds <> n.proceeds
        or o.scale <> n.scale
        or o.bizscope <> n.bizscope
        or o.registerdaddress <> n.registerdaddress
        or o.enttermduedate <> n.enttermduedate
        or o.bano <> n.bano
        or o.taxqueryflag <> n.taxqueryflag
        or o.taxauthorizeno <> n.taxauthorizeno
        or o.taxpayeridentityno <> n.taxpayeridentityno
        or o.istaxsuccessgs <> n.istaxsuccessgs
        or o.idexpirydate <> n.idexpirydate
        or o.loanendtime <> n.loanendtime
        or o.loanstarttime <> n.loanstarttime
        or o.opercorpflg <> n.opercorpflg
        or o.loanusage <> n.loanusage
        or o.brwercorpoperscope <> n.brwercorpoperscope
        or o.enterstartdate <> n.enterstartdate
        or o.enterenddate <> n.enterenddate
        or o.setupdate <> n.setupdate
        or o.massage <> n.massage
        or o.isrelateent <> n.isrelateent
        or o.isgarden <> n.isgarden
        or o.informflag <> n.informflag
        or o.completeflag <> n.completeflag
        or o.channlefrom <> n.channlefrom
        or o.customerid <> n.customerid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_xked_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,channel -- 接入渠道
            ,termmonth -- 贷款期限
            ,loadamount -- 申请金额
            ,inputid -- 客户经理号
            ,dwellareacode -- 额度是否循环
            ,dwelladdress -- 主担保方式
            ,taxstrdate -- 产品分类标志
            ,enterprisename -- 企业名称
            ,entidttp -- 企业身份标识类型
            ,entidtno -- 企业身份标识号码
            ,businessscope -- 经营地址所属省
            ,validitedate -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 经营详细地址
            ,sciencetechenttype -- 科创企业类型
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,entsolftcopyrightregnum -- 企业软著登记公告次数
            ,entknowledgepropnum -- 企业知识产权数量
            ,knowledgepropinventnum -- 知识产权发明数量
            ,intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
            ,knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
            ,knowledgepropunfaircompenum -- 知识产权不正当竞争次数
            ,knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
            ,past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
            ,past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
            ,past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
            ,past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
            ,past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
            ,past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
            ,past24minvoicrevenue -- 近24个月开票收入
            ,annualhightechproincome -- 本年度高新技术产品（服务）收入
            ,preyearhightechproincome -- 上年度高新技术产品（服务）收入
            ,annualoperaincome -- 本年度营业收入
            ,annualempsnum -- 本年度从业人数（人）
            ,preyearempsnum -- 上年度从业人数
            ,annualtechninum -- 本年度科技人员人数
            ,preyeartechninum -- 上年度科技人员人数
            ,annualresearchdevamt -- 本年度研发费用金额
            ,preyearresearchdevamt -- 上年度研发费用金额
            ,annualentgetgovsusidy -- 本年度企业获取政府补贴收入
            ,preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
            ,forecastnextyearsale -- 预测次年销售量
            ,otherchannelworkcapit -- 其他渠道提供的运营资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
            ,nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,isknowledgepledged -- 知识产权是否质押
            ,knowledgepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 系统来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,custname -- 法人代表人姓名
            ,sex -- 法人代表人性别
            ,nation -- 法人代表人国籍
            ,idtype -- 法人代表人证件类型
            ,idno -- 法人代表人身份证号码
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,approvestatus -- 审批状态
            ,finalapplyamount -- 终审额度
            ,transstatus -- 流程状态
            ,status -- 任务状态
            ,branchid -- 所属分行
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分卡得分
            ,apprendtime -- 营业日期
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bizscope -- 经营范围
            ,registerdaddress -- 企业注册地址
            ,enttermduedate -- 企业营业期限到期日
            ,bano -- 授信申请编号
            ,taxqueryflag -- 税务查询标志
            ,taxauthorizeno -- 税务授权流水号
            ,taxpayeridentityno -- 纳税人识别号
            ,istaxsuccessgs -- 广税授权是否成功
            ,idexpirydate -- 企业证件到期日
            ,loanendtime -- 终审结束时间
            ,loanstarttime -- 终审申请时间
            ,opercorpflg -- 经营企业是否涉及专精特新
            ,loanusage -- 贷款用途
            ,brwercorpoperscope -- 企业经营范围
            ,enterstartdate -- 企业经营有效期起始日
            ,enterenddate -- 企业经营有效期到期日
            ,setupdate -- 企业成立日期
            ,massage -- 拒绝原因
            ,isrelateent -- 是否关联企业
            ,isgarden -- 是否园区贷
            ,informflag -- 终审通知成功与否
            ,completeflag -- 数据完善标志；码值为CompleteFlag
            ,channlefrom -- 线上线下标志：1线下，2线上
            ,customerid -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_xked_iqp_loan_app_op(
            serialno -- 业务流水号
            ,applyno -- 信贷申请流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,channel -- 接入渠道
            ,termmonth -- 贷款期限
            ,loadamount -- 申请金额
            ,inputid -- 客户经理号
            ,dwellareacode -- 额度是否循环
            ,dwelladdress -- 主担保方式
            ,taxstrdate -- 产品分类标志
            ,enterprisename -- 企业名称
            ,entidttp -- 企业身份标识类型
            ,entidtno -- 企业身份标识号码
            ,businessscope -- 经营地址所属省
            ,validitedate -- 经营地址所属市
            ,registerarea -- 经营地址所属县（区）
            ,registeraddress -- 经营详细地址
            ,sciencetechenttype -- 科创企业类型
            ,actualcontrollerempyears -- 实控人从业年限（年）
            ,flowannualsalesrevenue -- 流水推算的年销售收入
            ,entsolftcopyrightregnum -- 企业软著登记公告次数
            ,entknowledgepropnum -- 企业知识产权数量
            ,knowledgepropinventnum -- 知识产权发明数量
            ,intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
            ,knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
            ,knowledgepropunfaircompenum -- 知识产权不正当竞争次数
            ,knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
            ,past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
            ,past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
            ,past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
            ,past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
            ,past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
            ,past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
            ,past24minvoicrevenue -- 近24个月开票收入
            ,annualhightechproincome -- 本年度高新技术产品（服务）收入
            ,preyearhightechproincome -- 上年度高新技术产品（服务）收入
            ,annualoperaincome -- 本年度营业收入
            ,annualempsnum -- 本年度从业人数（人）
            ,preyearempsnum -- 上年度从业人数
            ,annualtechninum -- 本年度科技人员人数
            ,preyeartechninum -- 上年度科技人员人数
            ,annualresearchdevamt -- 本年度研发费用金额
            ,preyearresearchdevamt -- 上年度研发费用金额
            ,annualentgetgovsusidy -- 本年度企业获取政府补贴收入
            ,preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
            ,forecastnextyearsale -- 预测次年销售量
            ,otherchannelworkcapit -- 其他渠道提供的运营资金
            ,nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
            ,nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
            ,entmonthrepaybalance -- 企业月还款额
            ,ispledgedreceiveaccount -- 企业应收账款是否质押
            ,pledgereceiveamt -- 应收账款质押贷款金额
            ,isknowledgepledged -- 知识产权是否质押
            ,knowledgepledgereceiveamt -- 知识产权质押贷款金额
            ,isstockpledged -- 股权是否质押
            ,stockpledgedamt -- 股权质押贷款金额
            ,qryusertype -- 征信查询人类型
            ,qryopertp -- 征信查询操作申请类型
            ,partner -- 系统来源
            ,reportusernm -- 报告使用人姓名
            ,reportuseroff -- 报告使用人所属部门
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,custname -- 法人代表人姓名
            ,sex -- 法人代表人性别
            ,nation -- 法人代表人国籍
            ,idtype -- 法人代表人证件类型
            ,idno -- 法人代表人身份证号码
            ,inputorgid -- 登记机构
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,updateuserid -- 更新人
            ,updatedate -- 更新时间
            ,approvestatus -- 审批状态
            ,finalapplyamount -- 终审额度
            ,transstatus -- 流程状态
            ,status -- 任务状态
            ,branchid -- 所属分行
            ,isbankrel -- 是否我行关联人
            ,autoscore -- 评分卡得分
            ,apprendtime -- 营业日期
            ,risknote -- 备注
            ,riskwarm -- 预警
            ,tradecode -- 行业类型
            ,empcountyear -- 从业人数
            ,tatalasset -- 资产合计
            ,proceeds -- 营业收入
            ,scale -- 企业规模
            ,bizscope -- 经营范围
            ,registerdaddress -- 企业注册地址
            ,enttermduedate -- 企业营业期限到期日
            ,bano -- 授信申请编号
            ,taxqueryflag -- 税务查询标志
            ,taxauthorizeno -- 税务授权流水号
            ,taxpayeridentityno -- 纳税人识别号
            ,istaxsuccessgs -- 广税授权是否成功
            ,idexpirydate -- 企业证件到期日
            ,loanendtime -- 终审结束时间
            ,loanstarttime -- 终审申请时间
            ,opercorpflg -- 经营企业是否涉及专精特新
            ,loanusage -- 贷款用途
            ,brwercorpoperscope -- 企业经营范围
            ,enterstartdate -- 企业经营有效期起始日
            ,enterenddate -- 企业经营有效期到期日
            ,setupdate -- 企业成立日期
            ,massage -- 拒绝原因
            ,isrelateent -- 是否关联企业
            ,isgarden -- 是否园区贷
            ,informflag -- 终审通知成功与否
            ,completeflag -- 数据完善标志；码值为CompleteFlag
            ,channlefrom -- 线上线下标志：1线下，2线上
            ,customerid -- 客户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.applyno -- 信贷申请流水号
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.channel -- 接入渠道
    ,o.termmonth -- 贷款期限
    ,o.loadamount -- 申请金额
    ,o.inputid -- 客户经理号
    ,o.dwellareacode -- 额度是否循环
    ,o.dwelladdress -- 主担保方式
    ,o.taxstrdate -- 产品分类标志
    ,o.enterprisename -- 企业名称
    ,o.entidttp -- 企业身份标识类型
    ,o.entidtno -- 企业身份标识号码
    ,o.businessscope -- 经营地址所属省
    ,o.validitedate -- 经营地址所属市
    ,o.registerarea -- 经营地址所属县（区）
    ,o.registeraddress -- 经营详细地址
    ,o.sciencetechenttype -- 科创企业类型
    ,o.actualcontrollerempyears -- 实控人从业年限（年）
    ,o.flowannualsalesrevenue -- 流水推算的年销售收入
    ,o.entsolftcopyrightregnum -- 企业软著登记公告次数
    ,o.entknowledgepropnum -- 企业知识产权数量
    ,o.knowledgepropinventnum -- 知识产权发明数量
    ,o.intefcircuitlayoutdesignappnum -- 集成电路布图设计申请数量
    ,o.knowledgepropinfrinpunishnum -- 知识产权侵权处罚次数
    ,o.knowledgepropunfaircompenum -- 知识产权不正当竞争次数
    ,o.knowledgepropjudgdocdefentnum -- 知识产权裁判文书被告次数
    ,o.past24mupstreamtop5purchamt -- 近24个月上游前5大采购金额
    ,o.past24mupstreamintegpurchamt -- 近24个月上游整体采购金额
    ,o.past24mdownstreamtop5saleamt -- 近24个月下游前5大销售金额
    ,o.past24mdownstreamintegsaleamt -- 近24个月下游整体销售金额
    ,o.past12mispartnertop10transamt -- 近12个月重要稳定供应商（前十）交易金额
    ,o.past12miscusttop10transamt -- 近12个月重要稳定客户（前十）交易金额
    ,o.past24minvoicrevenue -- 近24个月开票收入
    ,o.annualhightechproincome -- 本年度高新技术产品（服务）收入
    ,o.preyearhightechproincome -- 上年度高新技术产品（服务）收入
    ,o.annualoperaincome -- 本年度营业收入
    ,o.annualempsnum -- 本年度从业人数（人）
    ,o.preyearempsnum -- 上年度从业人数
    ,o.annualtechninum -- 本年度科技人员人数
    ,o.preyeartechninum -- 上年度科技人员人数
    ,o.annualresearchdevamt -- 本年度研发费用金额
    ,o.preyearresearchdevamt -- 上年度研发费用金额
    ,o.annualentgetgovsusidy -- 本年度企业获取政府补贴收入
    ,o.preyearentgetgovsusidy -- 上年度企业获取政府补贴收入
    ,o.forecastnextyearsale -- 预测次年销售量
    ,o.otherchannelworkcapit -- 其他渠道提供的运营资金
    ,o.nocrediteachdebtaccubalance -- 未在征信报告中体现的各类负债
    ,o.nocreditmonthaccurepaydebt -- 未在征信报告中体现的各类负债月还款额
    ,o.entmonthrepaybalance -- 企业月还款额
    ,o.ispledgedreceiveaccount -- 企业应收账款是否质押
    ,o.pledgereceiveamt -- 应收账款质押贷款金额
    ,o.isknowledgepledged -- 知识产权是否质押
    ,o.knowledgepledgereceiveamt -- 知识产权质押贷款金额
    ,o.isstockpledged -- 股权是否质押
    ,o.stockpledgedamt -- 股权质押贷款金额
    ,o.qryusertype -- 征信查询人类型
    ,o.qryopertp -- 征信查询操作申请类型
    ,o.partner -- 系统来源
    ,o.reportusernm -- 报告使用人姓名
    ,o.reportuseroff -- 报告使用人所属部门
    ,o.authotype -- 授权方式
    ,o.biometrics -- 生物识别技术
    ,o.authotime -- 授权时间
    ,o.authostrdate -- 授权开始时间
    ,o.authoenddate -- 授权结束时间
    ,o.custname -- 法人代表人姓名
    ,o.sex -- 法人代表人性别
    ,o.nation -- 法人代表人国籍
    ,o.idtype -- 法人代表人证件类型
    ,o.idno -- 法人代表人身份证号码
    ,o.inputorgid -- 登记机构
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新时间
    ,o.approvestatus -- 审批状态
    ,o.finalapplyamount -- 终审额度
    ,o.transstatus -- 流程状态
    ,o.status -- 任务状态
    ,o.branchid -- 所属分行
    ,o.isbankrel -- 是否我行关联人
    ,o.autoscore -- 评分卡得分
    ,o.apprendtime -- 营业日期
    ,o.risknote -- 备注
    ,o.riskwarm -- 预警
    ,o.tradecode -- 行业类型
    ,o.empcountyear -- 从业人数
    ,o.tatalasset -- 资产合计
    ,o.proceeds -- 营业收入
    ,o.scale -- 企业规模
    ,o.bizscope -- 经营范围
    ,o.registerdaddress -- 企业注册地址
    ,o.enttermduedate -- 企业营业期限到期日
    ,o.bano -- 授信申请编号
    ,o.taxqueryflag -- 税务查询标志
    ,o.taxauthorizeno -- 税务授权流水号
    ,o.taxpayeridentityno -- 纳税人识别号
    ,o.istaxsuccessgs -- 广税授权是否成功
    ,o.idexpirydate -- 企业证件到期日
    ,o.loanendtime -- 终审结束时间
    ,o.loanstarttime -- 终审申请时间
    ,o.opercorpflg -- 经营企业是否涉及专精特新
    ,o.loanusage -- 贷款用途
    ,o.brwercorpoperscope -- 企业经营范围
    ,o.enterstartdate -- 企业经营有效期起始日
    ,o.enterenddate -- 企业经营有效期到期日
    ,o.setupdate -- 企业成立日期
    ,o.massage -- 拒绝原因
    ,o.isrelateent -- 是否关联企业
    ,o.isgarden -- 是否园区贷
    ,o.informflag -- 终审通知成功与否
    ,o.completeflag -- 数据完善标志；码值为CompleteFlag
    ,o.channlefrom -- 线上线下标志：1线下，2线上
    ,o.customerid -- 客户编号
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
from ${iol_schema}.icms_xked_iqp_loan_app_bk o
    left join ${iol_schema}.icms_xked_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_xked_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_xked_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_xked_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_xked_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_xked_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_xked_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_xked_iqp_loan_app_cl;
alter table ${iol_schema}.icms_xked_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_xked_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_xked_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_xked_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_xked_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_xked_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_xked_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
