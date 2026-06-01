/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_iqp_loan_prior
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
create table ${iol_schema}.icms_fkd_iqp_loan_prior_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_iqp_loan_prior
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior_op purge;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_iqp_loan_prior_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_iqp_loan_prior where 0=1;

create table ${iol_schema}.icms_fkd_iqp_loan_prior_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_iqp_loan_prior where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_iqp_loan_prior_cl(
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,cuscreditscorelevel -- 
            ,matchpurchhousecondition -- 
            ,housetxnprice -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,identityexpire -- 
            ,enttype -- 
            ,enterprisename -- 
            ,entidttp -- 
            ,entidtno -- 
            ,entaddress -- 
            ,enttermduedate -- 
            ,cobsratio -- 
            ,updatedate -- 
            ,istaxsuccessgs -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,businessserialno -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_iqp_loan_prior_op(
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,cuscreditscorelevel -- 
            ,matchpurchhousecondition -- 
            ,housetxnprice -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,identityexpire -- 
            ,enttype -- 
            ,enterprisename -- 
            ,entidttp -- 
            ,entidtno -- 
            ,entaddress -- 
            ,enttermduedate -- 
            ,cobsratio -- 
            ,updatedate -- 
            ,istaxsuccessgs -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,businessserialno -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.iscollectcredit, o.iscollectcredit) as iscollectcredit -- 征信查询情况
    ,nvl(n.originalloan, o.originalloan) as originalloan -- 是否有原贷款
    ,nvl(n.workingloanbalance, o.workingloanbalance) as workingloanbalance -- 企业流动资金贷款余额（元）
    ,nvl(n.projectname, o.projectname) as projectname -- 小区名称
    ,nvl(n.isbankorg, o.isbankorg) as isbankorg -- 是否银行机构
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 初审审批状态
    ,nvl(n.inputid, o.inputid) as inputid -- 推荐人
    ,nvl(n.displaceoperatloanbal, o.displaceoperatloanbal) as displaceoperatloanbal -- 拟置换经营性贷款余额
    ,nvl(n.lot, o.lot) as lot -- 份额
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.enterpriseyearincome, o.enterpriseyearincome) as enterpriseyearincome -- 经营主体年销售收
    ,nvl(n.customgroupcode, o.customgroupcode) as customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
    ,nvl(n.individexpdt, o.individexpdt) as individexpdt -- 证件到期日
    ,nvl(n.orgmtgbankbranch, o.orgmtgbankbranch) as orgmtgbankbranch -- 原抵押银行分行名称
    ,nvl(n.appchannel, o.appchannel) as appchannel -- 接入渠道
    ,nvl(n.sysid, o.sysid) as sysid -- 系统来源
    ,nvl(n.deviceamount, o.deviceamount) as deviceamount -- 设备数量（定型机）
    ,nvl(n.certtype, o.certtype) as certtype -- 主借人证件类型
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分分值
    ,nvl(n.isotherbankmtg, o.isotherbankmtg) as isotherbankmtg -- 是否他行在押房产
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 查询操作申请类型
    ,nvl(n.isgetcuscode, o.isgetcuscode) as isgetcuscode -- 是否开户成功
    ,nvl(n.comname, o.comname) as comname -- 地推公司名称
    ,nvl(n.msflag, o.msflag) as msflag -- 庙算是否通过
    ,nvl(n.indivocc, o.indivocc) as indivocc -- 职业
    ,nvl(n.onbranchbank, o.onbranchbank) as onbranchbank -- 所在分行
    ,nvl(n.relationphone, o.relationphone) as relationphone -- 直系亲属联系电话
    ,nvl(n.taxapprovestatus, o.taxapprovestatus) as taxapprovestatus -- 涉税审批状态
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联人
    ,nvl(n.seqid, o.seqid) as seqid -- 请求流水（用于庙算接口查询）
    ,nvl(n.orghouseloanbalance, o.orghouseloanbalance) as orghouseloanbalance -- 在押房产贷款余额（元）
    ,nvl(n.obankloansurnotbal, o.obankloansurnotbal) as obankloansurnotbal -- 原银行房贷剩余未还本金
    ,nvl(n.accountbank, o.accountbank) as accountbank -- 绑定银行卡开户行
    ,nvl(n.accountname, o.accountname) as accountname -- 绑定银行卡户名
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.respstatus, o.respstatus) as respstatus -- 存证返回状态（0为失败，1为成功）
    ,nvl(n.recacctbankname, o.recacctbankname) as recacctbankname -- 开户行(经销商)
    ,nvl(n.indivrsdaddr, o.indivrsdaddr) as indivrsdaddr -- 居住地址
    ,nvl(n.ischeckinspect, o.ischeckinspect) as ischeckinspect -- 联网核查状态
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.informflag, o.informflag) as informflag -- 初审通知成功与否
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.otherdirection, o.otherdirection) as otherdirection -- 其他原房产贷款类型说明
    ,nvl(n.cityname, o.cityname) as cityname -- 所在城市
    ,nvl(n.taxpayeridentino, o.taxpayeridentino) as taxpayeridentino -- 纳税人识别号
    ,nvl(n.monincome, o.monincome) as monincome -- 税后月收入
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.custname, o.custname) as custname -- 客户姓名
    ,nvl(n.cltrtyp, o.cltrtyp) as cltrtyp -- 押品类型
    ,nvl(n.mainbusiness, o.mainbusiness) as mainbusiness -- 主营业务
    ,nvl(n.cltrname, o.cltrname) as cltrname -- 押品名称
    ,nvl(n.whitecertcode, o.whitecertcode) as whitecertcode -- 白名单客户证件号码
    ,nvl(n.limitloanterm, o.limitloanterm) as limitloanterm -- 额度合同申请期限
    ,nvl(n.isonloanbank, o.isonloanbank) as isonloanbank -- 在途贷款银行
    ,nvl(n.taxbureauserno, o.taxbureauserno) as taxbureauserno -- 税局授权流水
    ,nvl(n.preloanterm, o.preloanterm) as preloanterm -- 兴车贷-贷款期限
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 风险等级
    ,nvl(n.warninginfo, o.warninginfo) as warninginfo -- 预警信息
    ,nvl(n.whitecusid, o.whitecusid) as whitecusid -- 白名单客户号
    ,nvl(n.deviceloanbalance, o.deviceloanbalance) as deviceloanbalance -- 企业设备融资租赁贷款余额（元）
    ,nvl(n.relationcertcode, o.relationcertcode) as relationcertcode -- 直系亲属证件号
    ,nvl(n.repayway, o.repayway) as repayway -- 还款方式
    ,nvl(n.accumulfundmon, o.accumulfundmon) as accumulfundmon -- 公积金连续缴存月数
    ,nvl(n.roomprice, o.roomprice) as roomprice -- 评估价值
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 初审申请时间
    ,nvl(n.indivsex, o.indivsex) as indivsex -- 性别
    ,nvl(n.cuttomgroupname, o.cuttomgroupname) as cuttomgroupname -- 客群分类名称
    ,nvl(n.devicetotalprice, o.devicetotalprice) as devicetotalprice -- 企业设备资产总值
    ,nvl(n.finabrid, o.finabrid) as finabrid -- 账务机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.fixedfundloanbalance, o.fixedfundloanbalance) as fixedfundloanbalance -- 企业固定资产贷款余额（元）
    ,nvl(n.channelno, o.channelno) as channelno -- 渠道号
    ,nvl(n.comno, o.comno) as comno -- 地推公司编号
    ,nvl(n.recacct, o.recacct) as recacct -- 收款账户(经销商)
    ,nvl(n.accountnumber, o.accountnumber) as accountnumber -- 绑定银行卡账号
    ,nvl(n.cfmseqnum, o.cfmseqnum) as cfmseqnum -- 智贷押品确认流水号
    ,nvl(n.ownerflag, o.ownerflag) as ownerflag -- 借款人是否实控人
    ,nvl(n.fourelementsverificationresult, o.fourelementsverificationresult) as fourelementsverificationresult -- 绑定银行卡四要素验证结果
    ,nvl(n.urgentcontactphone, o.urgentcontactphone) as urgentcontactphone -- 紧急联系人电话
    ,nvl(n.urgentcontactname, o.urgentcontactname) as urgentcontactname -- 紧急联系人姓名
    ,nvl(n.ishouse, o.ishouse) as ishouse -- 是否有房
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.roomsize, o.roomsize) as roomsize -- 房屋面积
    ,nvl(n.taxrelatedtype, o.taxrelatedtype) as taxrelatedtype -- 涉税类型
    ,nvl(n.propertytype, o.propertytype) as propertytype -- 房产类型-STD_FKD_FCLX
    ,nvl(n.istaxrela, o.istaxrela) as istaxrela -- 是否跑涉税风控
    ,nvl(n.relationname, o.relationname) as relationname -- 直系亲属姓名
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 初审申请日期
    ,nvl(n.faceidentifiscore, o.faceidentifiscore) as faceidentifiscore -- 人脸识别照与证件照比对分数值
    ,nvl(n.ctrlbranch, o.ctrlbranch) as ctrlbranch -- 所属分行
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 管理机构
    ,nvl(n.netvalue, o.netvalue) as netvalue -- 净值
    ,nvl(n.invtstkperc, o.invtstkperc) as invtstkperc -- 借款人持股比例
    ,nvl(n.coopno, o.coopno) as coopno -- 合作方客户经理工号
    ,nvl(n.oloaniscircle, o.oloaniscircle) as oloaniscircle -- 原贷款是否循环
    ,nvl(n.principalamt, o.principalamt) as principalamt -- 本金
    ,nvl(n.purpors, o.purpors) as purpors -- 贷款用途
    ,nvl(n.certno, o.certno) as certno -- 主借人证件编号
    ,nvl(n.isemoji, o.isemoji) as isemoji -- 是否有影像文件
    ,nvl(n.orghouseloantype, o.orghouseloantype) as orghouseloantype -- 原房产贷款类型
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.creditamt, o.creditamt) as creditamt -- 授信金额
    ,nvl(n.isoverduemain, o.isoverduemain) as isoverduemain -- 主借款人是否触碰征信逾期金额过大
    ,nvl(n.detailaddr, o.detailaddr) as detailaddr -- 房产地址
    ,nvl(n.areacode, o.areacode) as areacode -- 区域编号
    ,nvl(n.grtduedate, o.grtduedate) as grtduedate -- 押品到期日
    ,nvl(n.socialmon, o.socialmon) as socialmon -- 社保连续缴存月数
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.monthlyrepay, o.monthlyrepay) as monthlyrepay -- 月还款金额
    ,nvl(n.whitecerttype, o.whitecerttype) as whitecerttype -- 白名单客户证件类型
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.orgmtgbank, o.orgmtgbank) as orgmtgbank -- 原抵押银行
    ,nvl(n.loanamt, o.loanamt) as loanamt -- 客户贷款金额
    ,nvl(n.obankloanamt, o.obankloanamt) as obankloanamt -- 原银行房贷贷款金额
    ,nvl(n.indivoccremarks, o.indivoccremarks) as indivoccremarks -- 职业备注信息
    ,nvl(n.ctrlorg, o.ctrlorg) as ctrlorg -- 所属机构
    ,nvl(n.apprendtime, o.apprendtime) as apprendtime -- 审批结束时间
    ,nvl(n.cityareacode, o.cityareacode) as cityareacode -- 城市编码
    ,nvl(n.mscreditamt, o.mscreditamt) as mscreditamt -- 庙算初审额度
    ,nvl(n.oloansurterm, o.oloansurterm) as oloansurterm -- 原贷款剩余期限
    ,nvl(n.manualapproval, o.manualapproval) as manualapproval -- 是否人工审批标识
    ,nvl(n.taxflg, o.taxflg) as taxflg -- 是否涉税：YesNo
    ,nvl(n.pauperroomprice, o.pauperroomprice) as pauperroomprice -- 世联下户评估价值
    ,nvl(n.bkprice, o.bkprice) as bkprice -- 贝壳网房产评估价值
    ,nvl(n.certidstartdate, o.certidstartdate) as certidstartdate -- 证件起始日
    ,nvl(n.iscrossregionrun, o.iscrossregionrun) as iscrossregionrun -- 
    ,nvl(n.wisdomloanmode, o.wisdomloanmode) as wisdomloanmode -- 
    ,nvl(n.cuscreditscorelevel, o.cuscreditscorelevel) as cuscreditscorelevel -- 
    ,nvl(n.matchpurchhousecondition, o.matchpurchhousecondition) as matchpurchhousecondition -- 
    ,nvl(n.housetxnprice, o.housetxnprice) as housetxnprice -- 
    ,nvl(n.isaddedvalue, o.isaddedvalue) as isaddedvalue -- 
    ,nvl(n.addedvalue, o.addedvalue) as addedvalue -- 
    ,nvl(n.carinvoice, o.carinvoice) as carinvoice -- 
    ,nvl(n.isnewcoborrower, o.isnewcoborrower) as isnewcoborrower -- 
    ,nvl(n.villatype, o.villatype) as villatype -- 
    ,nvl(n.housetypelocation, o.housetypelocation) as housetypelocation -- 
    ,nvl(n.rowno, o.rowno) as rowno -- 
    ,nvl(n.gardenarea, o.gardenarea) as gardenarea -- 
    ,nvl(n.freearea, o.freearea) as freearea -- 
    ,nvl(n.identityexpire, o.identityexpire) as identityexpire -- 
    ,nvl(n.enttype, o.enttype) as enttype -- 
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 
    ,nvl(n.entidttp, o.entidttp) as entidttp -- 
    ,nvl(n.entidtno, o.entidtno) as entidtno -- 
    ,nvl(n.entaddress, o.entaddress) as entaddress -- 
    ,nvl(n.enttermduedate, o.enttermduedate) as enttermduedate -- 
    ,nvl(n.cobsratio, o.cobsratio) as cobsratio -- 
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 
    ,nvl(n.istaxsuccessgs, o.istaxsuccessgs) as istaxsuccessgs -- 
    ,nvl(n.ishavecar, o.ishavecar) as ishavecar -- 
    ,nvl(n.licensenumber, o.licensenumber) as licensenumber -- 
    ,nvl(n.drivinglicensedate, o.drivinglicensedate) as drivinglicensedate -- 
    ,nvl(n.businessserialno, o.businessserialno) as businessserialno -- 
    ,nvl(n.resiloczonecd, o.resiloczonecd) as resiloczonecd -- 
    ,nvl(n.untloczonecd, o.untloczonecd) as untloczonecd -- 
    ,nvl(n.resiloczone, o.resiloczone) as resiloczone -- 
    ,nvl(n.compphone, o.compphone) as compphone -- 
    ,nvl(n.isriskcust, o.isriskcust) as isriskcust -- 
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
from (select * from ${iol_schema}.icms_fkd_iqp_loan_prior_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_iqp_loan_prior where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.iscollectcredit <> n.iscollectcredit
        or o.originalloan <> n.originalloan
        or o.workingloanbalance <> n.workingloanbalance
        or o.projectname <> n.projectname
        or o.isbankorg <> n.isbankorg
        or o.approvestatus <> n.approvestatus
        or o.inputid <> n.inputid
        or o.displaceoperatloanbal <> n.displaceoperatloanbal
        or o.lot <> n.lot
        or o.nationality <> n.nationality
        or o.prdname <> n.prdname
        or o.enterpriseyearincome <> n.enterpriseyearincome
        or o.customgroupcode <> n.customgroupcode
        or o.individexpdt <> n.individexpdt
        or o.orgmtgbankbranch <> n.orgmtgbankbranch
        or o.appchannel <> n.appchannel
        or o.sysid <> n.sysid
        or o.deviceamount <> n.deviceamount
        or o.certtype <> n.certtype
        or o.autoscore <> n.autoscore
        or o.isotherbankmtg <> n.isotherbankmtg
        or o.qryopertp <> n.qryopertp
        or o.isgetcuscode <> n.isgetcuscode
        or o.comname <> n.comname
        or o.msflag <> n.msflag
        or o.indivocc <> n.indivocc
        or o.onbranchbank <> n.onbranchbank
        or o.relationphone <> n.relationphone
        or o.taxapprovestatus <> n.taxapprovestatus
        or o.isbankrel <> n.isbankrel
        or o.seqid <> n.seqid
        or o.orghouseloanbalance <> n.orghouseloanbalance
        or o.obankloansurnotbal <> n.obankloansurnotbal
        or o.accountbank <> n.accountbank
        or o.accountname <> n.accountname
        or o.authostrdate <> n.authostrdate
        or o.respstatus <> n.respstatus
        or o.recacctbankname <> n.recacctbankname
        or o.indivrsdaddr <> n.indivrsdaddr
        or o.ischeckinspect <> n.ischeckinspect
        or o.phone <> n.phone
        or o.informflag <> n.informflag
        or o.failreason <> n.failreason
        or o.otherdirection <> n.otherdirection
        or o.cityname <> n.cityname
        or o.taxpayeridentino <> n.taxpayeridentino
        or o.monincome <> n.monincome
        or o.biometrics <> n.biometrics
        or o.custname <> n.custname
        or o.cltrtyp <> n.cltrtyp
        or o.mainbusiness <> n.mainbusiness
        or o.cltrname <> n.cltrname
        or o.whitecertcode <> n.whitecertcode
        or o.limitloanterm <> n.limitloanterm
        or o.isonloanbank <> n.isonloanbank
        or o.taxbureauserno <> n.taxbureauserno
        or o.preloanterm <> n.preloanterm
        or o.risklevel <> n.risklevel
        or o.warninginfo <> n.warninginfo
        or o.whitecusid <> n.whitecusid
        or o.deviceloanbalance <> n.deviceloanbalance
        or o.relationcertcode <> n.relationcertcode
        or o.repayway <> n.repayway
        or o.accumulfundmon <> n.accumulfundmon
        or o.roomprice <> n.roomprice
        or o.applyno <> n.applyno
        or o.inputtime <> n.inputtime
        or o.indivsex <> n.indivsex
        or o.cuttomgroupname <> n.cuttomgroupname
        or o.devicetotalprice <> n.devicetotalprice
        or o.finabrid <> n.finabrid
        or o.migtflag <> n.migtflag
        or o.fixedfundloanbalance <> n.fixedfundloanbalance
        or o.channelno <> n.channelno
        or o.comno <> n.comno
        or o.recacct <> n.recacct
        or o.accountnumber <> n.accountnumber
        or o.cfmseqnum <> n.cfmseqnum
        or o.ownerflag <> n.ownerflag
        or o.fourelementsverificationresult <> n.fourelementsverificationresult
        or o.urgentcontactphone <> n.urgentcontactphone
        or o.urgentcontactname <> n.urgentcontactname
        or o.ishouse <> n.ishouse
        or o.prdcode <> n.prdcode
        or o.cusid <> n.cusid
        or o.roomsize <> n.roomsize
        or o.taxrelatedtype <> n.taxrelatedtype
        or o.propertytype <> n.propertytype
        or o.istaxrela <> n.istaxrela
        or o.relationname <> n.relationname
        or o.inputdate <> n.inputdate
        or o.faceidentifiscore <> n.faceidentifiscore
        or o.ctrlbranch <> n.ctrlbranch
        or o.inputbrid <> n.inputbrid
        or o.netvalue <> n.netvalue
        or o.invtstkperc <> n.invtstkperc
        or o.coopno <> n.coopno
        or o.oloaniscircle <> n.oloaniscircle
        or o.principalamt <> n.principalamt
        or o.purpors <> n.purpors
        or o.certno <> n.certno
        or o.isemoji <> n.isemoji
        or o.orghouseloantype <> n.orghouseloantype
        or o.authotime <> n.authotime
        or o.creditamt <> n.creditamt
        or o.isoverduemain <> n.isoverduemain
        or o.detailaddr <> n.detailaddr
        or o.areacode <> n.areacode
        or o.grtduedate <> n.grtduedate
        or o.socialmon <> n.socialmon
        or o.authoenddate <> n.authoenddate
        or o.monthlyrepay <> n.monthlyrepay
        or o.whitecerttype <> n.whitecerttype
        or o.authotype <> n.authotype
        or o.orgmtgbank <> n.orgmtgbank
        or o.loanamt <> n.loanamt
        or o.obankloanamt <> n.obankloanamt
        or o.indivoccremarks <> n.indivoccremarks
        or o.ctrlorg <> n.ctrlorg
        or o.apprendtime <> n.apprendtime
        or o.cityareacode <> n.cityareacode
        or o.mscreditamt <> n.mscreditamt
        or o.oloansurterm <> n.oloansurterm
        or o.manualapproval <> n.manualapproval
        or o.taxflg <> n.taxflg
        or o.pauperroomprice <> n.pauperroomprice
        or o.bkprice <> n.bkprice
        or o.certidstartdate <> n.certidstartdate
        or o.iscrossregionrun <> n.iscrossregionrun
        or o.wisdomloanmode <> n.wisdomloanmode
        or o.cuscreditscorelevel <> n.cuscreditscorelevel
        or o.matchpurchhousecondition <> n.matchpurchhousecondition
        or o.housetxnprice <> n.housetxnprice
        or o.isaddedvalue <> n.isaddedvalue
        or o.addedvalue <> n.addedvalue
        or o.carinvoice <> n.carinvoice
        or o.isnewcoborrower <> n.isnewcoborrower
        or o.villatype <> n.villatype
        or o.housetypelocation <> n.housetypelocation
        or o.rowno <> n.rowno
        or o.gardenarea <> n.gardenarea
        or o.freearea <> n.freearea
        or o.identityexpire <> n.identityexpire
        or o.enttype <> n.enttype
        or o.enterprisename <> n.enterprisename
        or o.entidttp <> n.entidttp
        or o.entidtno <> n.entidtno
        or o.entaddress <> n.entaddress
        or o.enttermduedate <> n.enttermduedate
        or o.cobsratio <> n.cobsratio
        or o.updatedate <> n.updatedate
        or o.istaxsuccessgs <> n.istaxsuccessgs
        or o.ishavecar <> n.ishavecar
        or o.licensenumber <> n.licensenumber
        or o.drivinglicensedate <> n.drivinglicensedate
        or o.businessserialno <> n.businessserialno
        or o.resiloczonecd <> n.resiloczonecd
        or o.untloczonecd <> n.untloczonecd
        or o.resiloczone <> n.resiloczone
        or o.compphone <> n.compphone
        or o.isriskcust <> n.isriskcust
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_iqp_loan_prior_cl(
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,cuscreditscorelevel -- 
            ,matchpurchhousecondition -- 
            ,housetxnprice -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,identityexpire -- 
            ,enttype -- 
            ,enterprisename -- 
            ,entidttp -- 
            ,entidtno -- 
            ,entaddress -- 
            ,enttermduedate -- 
            ,cobsratio -- 
            ,updatedate -- 
            ,istaxsuccessgs -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,businessserialno -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_iqp_loan_prior_op(
            serialno -- 业务流水号
            ,iscollectcredit -- 征信查询情况
            ,originalloan -- 是否有原贷款
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,projectname -- 小区名称
            ,isbankorg -- 是否银行机构
            ,approvestatus -- 初审审批状态
            ,inputid -- 推荐人
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,lot -- 份额
            ,nationality -- 国籍
            ,prdname -- 产品名称
            ,enterpriseyearincome -- 经营主体年销售收
            ,customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
            ,individexpdt -- 证件到期日
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,appchannel -- 接入渠道
            ,sysid -- 系统来源
            ,deviceamount -- 设备数量（定型机）
            ,certtype -- 主借人证件类型
            ,autoscore -- 评分分值
            ,isotherbankmtg -- 是否他行在押房产
            ,qryopertp -- 查询操作申请类型
            ,isgetcuscode -- 是否开户成功
            ,comname -- 地推公司名称
            ,msflag -- 庙算是否通过
            ,indivocc -- 职业
            ,onbranchbank -- 所在分行
            ,relationphone -- 直系亲属联系电话
            ,taxapprovestatus -- 涉税审批状态
            ,isbankrel -- 是否我行关联人
            ,seqid -- 请求流水（用于庙算接口查询）
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,accountbank -- 绑定银行卡开户行
            ,accountname -- 绑定银行卡户名
            ,authostrdate -- 授权开始时间
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,recacctbankname -- 开户行(经销商)
            ,indivrsdaddr -- 居住地址
            ,ischeckinspect -- 联网核查状态
            ,phone -- 手机号
            ,informflag -- 初审通知成功与否
            ,failreason -- 拒绝原因
            ,otherdirection -- 其他原房产贷款类型说明
            ,cityname -- 所在城市
            ,taxpayeridentino -- 纳税人识别号
            ,monincome -- 税后月收入
            ,biometrics -- 生物识别技术
            ,custname -- 客户姓名
            ,cltrtyp -- 押品类型
            ,mainbusiness -- 主营业务
            ,cltrname -- 押品名称
            ,whitecertcode -- 白名单客户证件号码
            ,limitloanterm -- 额度合同申请期限
            ,isonloanbank -- 在途贷款银行
            ,taxbureauserno -- 税局授权流水
            ,preloanterm -- 兴车贷-贷款期限
            ,risklevel -- 风险等级
            ,warninginfo -- 预警信息
            ,whitecusid -- 白名单客户号
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,repayway -- 还款方式
            ,accumulfundmon -- 公积金连续缴存月数
            ,roomprice -- 评估价值
            ,applyno -- 信贷申请流水号
            ,inputtime -- 初审申请时间
            ,indivsex -- 性别
            ,cuttomgroupname -- 客群分类名称
            ,devicetotalprice -- 企业设备资产总值
            ,finabrid -- 账务机构
            ,migtflag -- 
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,channelno -- 渠道号
            ,comno -- 地推公司编号
            ,recacct -- 收款账户(经销商)
            ,accountnumber -- 绑定银行卡账号
            ,cfmseqnum -- 智贷押品确认流水号
            ,ownerflag -- 借款人是否实控人
            ,fourelementsverificationresult -- 绑定银行卡四要素验证结果
            ,urgentcontactphone -- 紧急联系人电话
            ,urgentcontactname -- 紧急联系人姓名
            ,ishouse -- 是否有房
            ,prdcode -- 产品编号
            ,cusid -- 客户号
            ,roomsize -- 房屋面积
            ,taxrelatedtype -- 涉税类型
            ,propertytype -- 房产类型-STD_FKD_FCLX
            ,istaxrela -- 是否跑涉税风控
            ,relationname -- 直系亲属姓名
            ,inputdate -- 初审申请日期
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,ctrlbranch -- 所属分行
            ,inputbrid -- 管理机构
            ,netvalue -- 净值
            ,invtstkperc -- 借款人持股比例
            ,coopno -- 合作方客户经理工号
            ,oloaniscircle -- 原贷款是否循环
            ,principalamt -- 本金
            ,purpors -- 贷款用途
            ,certno -- 主借人证件编号
            ,isemoji -- 是否有影像文件
            ,orghouseloantype -- 原房产贷款类型
            ,authotime -- 授权时间
            ,creditamt -- 授信金额
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,detailaddr -- 房产地址
            ,areacode -- 区域编号
            ,grtduedate -- 押品到期日
            ,socialmon -- 社保连续缴存月数
            ,authoenddate -- 授权结束时间
            ,monthlyrepay -- 月还款金额
            ,whitecerttype -- 白名单客户证件类型
            ,authotype -- 授权方式
            ,orgmtgbank -- 原抵押银行
            ,loanamt -- 客户贷款金额
            ,obankloanamt -- 原银行房贷贷款金额
            ,indivoccremarks -- 职业备注信息
            ,ctrlorg -- 所属机构
            ,apprendtime -- 审批结束时间
            ,cityareacode -- 城市编码
            ,mscreditamt -- 庙算初审额度
            ,oloansurterm -- 原贷款剩余期限
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,pauperroomprice -- 世联下户评估价值
            ,bkprice -- 贝壳网房产评估价值
            ,certidstartdate -- 证件起始日
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,cuscreditscorelevel -- 
            ,matchpurchhousecondition -- 
            ,housetxnprice -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,identityexpire -- 
            ,enttype -- 
            ,enterprisename -- 
            ,entidttp -- 
            ,entidtno -- 
            ,entaddress -- 
            ,enttermduedate -- 
            ,cobsratio -- 
            ,updatedate -- 
            ,istaxsuccessgs -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,businessserialno -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.iscollectcredit -- 征信查询情况
    ,o.originalloan -- 是否有原贷款
    ,o.workingloanbalance -- 企业流动资金贷款余额（元）
    ,o.projectname -- 小区名称
    ,o.isbankorg -- 是否银行机构
    ,o.approvestatus -- 初审审批状态
    ,o.inputid -- 推荐人
    ,o.displaceoperatloanbal -- 拟置换经营性贷款余额
    ,o.lot -- 份额
    ,o.nationality -- 国籍
    ,o.prdname -- 产品名称
    ,o.enterpriseyearincome -- 经营主体年销售收
    ,o.customgroupcode -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
    ,o.individexpdt -- 证件到期日
    ,o.orgmtgbankbranch -- 原抵押银行分行名称
    ,o.appchannel -- 接入渠道
    ,o.sysid -- 系统来源
    ,o.deviceamount -- 设备数量（定型机）
    ,o.certtype -- 主借人证件类型
    ,o.autoscore -- 评分分值
    ,o.isotherbankmtg -- 是否他行在押房产
    ,o.qryopertp -- 查询操作申请类型
    ,o.isgetcuscode -- 是否开户成功
    ,o.comname -- 地推公司名称
    ,o.msflag -- 庙算是否通过
    ,o.indivocc -- 职业
    ,o.onbranchbank -- 所在分行
    ,o.relationphone -- 直系亲属联系电话
    ,o.taxapprovestatus -- 涉税审批状态
    ,o.isbankrel -- 是否我行关联人
    ,o.seqid -- 请求流水（用于庙算接口查询）
    ,o.orghouseloanbalance -- 在押房产贷款余额（元）
    ,o.obankloansurnotbal -- 原银行房贷剩余未还本金
    ,o.accountbank -- 绑定银行卡开户行
    ,o.accountname -- 绑定银行卡户名
    ,o.authostrdate -- 授权开始时间
    ,o.respstatus -- 存证返回状态（0为失败，1为成功）
    ,o.recacctbankname -- 开户行(经销商)
    ,o.indivrsdaddr -- 居住地址
    ,o.ischeckinspect -- 联网核查状态
    ,o.phone -- 手机号
    ,o.informflag -- 初审通知成功与否
    ,o.failreason -- 拒绝原因
    ,o.otherdirection -- 其他原房产贷款类型说明
    ,o.cityname -- 所在城市
    ,o.taxpayeridentino -- 纳税人识别号
    ,o.monincome -- 税后月收入
    ,o.biometrics -- 生物识别技术
    ,o.custname -- 客户姓名
    ,o.cltrtyp -- 押品类型
    ,o.mainbusiness -- 主营业务
    ,o.cltrname -- 押品名称
    ,o.whitecertcode -- 白名单客户证件号码
    ,o.limitloanterm -- 额度合同申请期限
    ,o.isonloanbank -- 在途贷款银行
    ,o.taxbureauserno -- 税局授权流水
    ,o.preloanterm -- 兴车贷-贷款期限
    ,o.risklevel -- 风险等级
    ,o.warninginfo -- 预警信息
    ,o.whitecusid -- 白名单客户号
    ,o.deviceloanbalance -- 企业设备融资租赁贷款余额（元）
    ,o.relationcertcode -- 直系亲属证件号
    ,o.repayway -- 还款方式
    ,o.accumulfundmon -- 公积金连续缴存月数
    ,o.roomprice -- 评估价值
    ,o.applyno -- 信贷申请流水号
    ,o.inputtime -- 初审申请时间
    ,o.indivsex -- 性别
    ,o.cuttomgroupname -- 客群分类名称
    ,o.devicetotalprice -- 企业设备资产总值
    ,o.finabrid -- 账务机构
    ,o.migtflag -- 
    ,o.fixedfundloanbalance -- 企业固定资产贷款余额（元）
    ,o.channelno -- 渠道号
    ,o.comno -- 地推公司编号
    ,o.recacct -- 收款账户(经销商)
    ,o.accountnumber -- 绑定银行卡账号
    ,o.cfmseqnum -- 智贷押品确认流水号
    ,o.ownerflag -- 借款人是否实控人
    ,o.fourelementsverificationresult -- 绑定银行卡四要素验证结果
    ,o.urgentcontactphone -- 紧急联系人电话
    ,o.urgentcontactname -- 紧急联系人姓名
    ,o.ishouse -- 是否有房
    ,o.prdcode -- 产品编号
    ,o.cusid -- 客户号
    ,o.roomsize -- 房屋面积
    ,o.taxrelatedtype -- 涉税类型
    ,o.propertytype -- 房产类型-STD_FKD_FCLX
    ,o.istaxrela -- 是否跑涉税风控
    ,o.relationname -- 直系亲属姓名
    ,o.inputdate -- 初审申请日期
    ,o.faceidentifiscore -- 人脸识别照与证件照比对分数值
    ,o.ctrlbranch -- 所属分行
    ,o.inputbrid -- 管理机构
    ,o.netvalue -- 净值
    ,o.invtstkperc -- 借款人持股比例
    ,o.coopno -- 合作方客户经理工号
    ,o.oloaniscircle -- 原贷款是否循环
    ,o.principalamt -- 本金
    ,o.purpors -- 贷款用途
    ,o.certno -- 主借人证件编号
    ,o.isemoji -- 是否有影像文件
    ,o.orghouseloantype -- 原房产贷款类型
    ,o.authotime -- 授权时间
    ,o.creditamt -- 授信金额
    ,o.isoverduemain -- 主借款人是否触碰征信逾期金额过大
    ,o.detailaddr -- 房产地址
    ,o.areacode -- 区域编号
    ,o.grtduedate -- 押品到期日
    ,o.socialmon -- 社保连续缴存月数
    ,o.authoenddate -- 授权结束时间
    ,o.monthlyrepay -- 月还款金额
    ,o.whitecerttype -- 白名单客户证件类型
    ,o.authotype -- 授权方式
    ,o.orgmtgbank -- 原抵押银行
    ,o.loanamt -- 客户贷款金额
    ,o.obankloanamt -- 原银行房贷贷款金额
    ,o.indivoccremarks -- 职业备注信息
    ,o.ctrlorg -- 所属机构
    ,o.apprendtime -- 审批结束时间
    ,o.cityareacode -- 城市编码
    ,o.mscreditamt -- 庙算初审额度
    ,o.oloansurterm -- 原贷款剩余期限
    ,o.manualapproval -- 是否人工审批标识
    ,o.taxflg -- 是否涉税：YesNo
    ,o.pauperroomprice -- 世联下户评估价值
    ,o.bkprice -- 贝壳网房产评估价值
    ,o.certidstartdate -- 证件起始日
    ,o.iscrossregionrun -- 
    ,o.wisdomloanmode -- 
    ,o.cuscreditscorelevel -- 
    ,o.matchpurchhousecondition -- 
    ,o.housetxnprice -- 
    ,o.isaddedvalue -- 
    ,o.addedvalue -- 
    ,o.carinvoice -- 
    ,o.isnewcoborrower -- 
    ,o.villatype -- 
    ,o.housetypelocation -- 
    ,o.rowno -- 
    ,o.gardenarea -- 
    ,o.freearea -- 
    ,o.identityexpire -- 
    ,o.enttype -- 
    ,o.enterprisename -- 
    ,o.entidttp -- 
    ,o.entidtno -- 
    ,o.entaddress -- 
    ,o.enttermduedate -- 
    ,o.cobsratio -- 
    ,o.updatedate -- 
    ,o.istaxsuccessgs -- 
    ,o.ishavecar -- 
    ,o.licensenumber -- 
    ,o.drivinglicensedate -- 
    ,o.businessserialno -- 
    ,o.resiloczonecd -- 
    ,o.untloczonecd -- 
    ,o.resiloczone -- 
    ,o.compphone -- 
    ,o.isriskcust -- 
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
from ${iol_schema}.icms_fkd_iqp_loan_prior_bk o
    left join ${iol_schema}.icms_fkd_iqp_loan_prior_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_iqp_loan_prior_cl d
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
--truncate table ${iol_schema}.icms_fkd_iqp_loan_prior;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_iqp_loan_prior') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_iqp_loan_prior drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_iqp_loan_prior add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_iqp_loan_prior exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_iqp_loan_prior_cl;
alter table ${iol_schema}.icms_fkd_iqp_loan_prior exchange partition p_20991231 with table ${iol_schema}.icms_fkd_iqp_loan_prior_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_iqp_loan_prior to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior_op purge;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_iqp_loan_prior',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
