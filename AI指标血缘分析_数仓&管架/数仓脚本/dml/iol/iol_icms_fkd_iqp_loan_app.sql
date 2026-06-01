/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fkd_iqp_loan_app
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
create table ${iol_schema}.icms_fkd_iqp_loan_app_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fkd_iqp_loan_app
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_fkd_iqp_loan_app_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_iqp_loan_app_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_iqp_loan_app where 0=1;

create table ${iol_schema}.icms_fkd_iqp_loan_app_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fkd_iqp_loan_app where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,highestcreditorrightamt -- 
            ,cuscreditscorelevel -- 
            ,renewalmodel -- 
            ,selfemplflg -- 
            ,salapeopflg -- 
            ,bropermshrhratio -- 
            ,csldsocilccode -- 
            ,firstpayamt -- 
            ,prepapplowncnt -- 
            ,prepapplcomperrela -- 
            ,brwersixmonincome -- 
            ,brwersixmonfundpayamt -- 
            ,brwerfundmonpayamt -- 
            ,brwerfunduntpayratio -- 
            ,brwerfundindvpayratio -- 
            ,brwerretiage -- 
            ,spousixmonincome -- 
            ,spousixmonfundpayamt -- 
            ,ownhouseqty -- 
            ,locallmtpurchplcy -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,imagecheckno -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,cardaddr -- 
            ,idenblngprovcity -- 
            ,roomprice -- 
            ,yearlyrental -- 
            ,updatedate -- 
            ,creditmodel -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,highestcreditorrightamt -- 
            ,cuscreditscorelevel -- 
            ,renewalmodel -- 
            ,selfemplflg -- 
            ,salapeopflg -- 
            ,bropermshrhratio -- 
            ,csldsocilccode -- 
            ,firstpayamt -- 
            ,prepapplowncnt -- 
            ,prepapplcomperrela -- 
            ,brwersixmonincome -- 
            ,brwersixmonfundpayamt -- 
            ,brwerfundmonpayamt -- 
            ,brwerfunduntpayratio -- 
            ,brwerfundindvpayratio -- 
            ,brwerretiage -- 
            ,spousixmonincome -- 
            ,spousixmonfundpayamt -- 
            ,ownhouseqty -- 
            ,locallmtpurchplcy -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,imagecheckno -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,cardaddr -- 
            ,idenblngprovcity -- 
            ,roomprice -- 
            ,yearlyrental -- 
            ,updatedate -- 
            ,creditmodel -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 业务流水号
    ,nvl(n.prdcode, o.prdcode) as prdcode -- 产品编号
    ,nvl(n.prdname, o.prdname) as prdname -- 产品名称
    ,nvl(n.ctrlbranch, o.ctrlbranch) as ctrlbranch -- 所属分行
    ,nvl(n.appchannel, o.appchannel) as appchannel -- 接入渠道
    ,nvl(n.channelno, o.channelno) as channelno -- 渠道号
    ,nvl(n.applyno, o.applyno) as applyno -- 信贷申请流水号
    ,nvl(n.appadvice, o.appadvice) as appadvice -- 审批意见
    ,nvl(n.appconclusion, o.appconclusion) as appconclusion -- 审批结论
    ,nvl(n.certtype, o.certtype) as certtype -- 主借人证件类型
    ,nvl(n.certno, o.certno) as certno -- 主借人证件编号
    ,nvl(n.gender, o.gender) as gender -- 性别
    ,nvl(n.issauthority, o.issauthority) as issauthority -- 签发机关
    ,nvl(n.isscountry, o.isscountry) as isscountry -- 签发国家
    ,nvl(n.issdate, o.issdate) as issdate -- 签发日期
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 到期日期
    ,nvl(n.bankind, o.bankind) as bankind -- 本行员工标志
    ,nvl(n.hashouseind, o.hashouseind) as hashouseind -- 除本次抵押房产外，是否有其他住房
    ,nvl(n.housecount, o.housecount) as housecount -- 房产数量
    ,nvl(n.paysourcen, o.paysourcen) as paysourcen -- 还款来源
    ,nvl(n.partnercoownerind, o.partnercoownerind) as partnercoownerind -- 配偶共有人标志
    ,nvl(n.partnerrelind, o.partnerrelind) as partnerrelind -- 配偶关联人标志
    ,nvl(n.marriagedate, o.marriagedate) as marriagedate -- 婚姻登记日期
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 经营类型
    ,nvl(n.merchantname, o.merchantname) as merchantname -- 商户名称
    ,nvl(n.businessaddrtype, o.businessaddrtype) as businessaddrtype -- 经营场所类型
    ,nvl(n.businessaddr, o.businessaddr) as businessaddr -- 经营场所
    ,nvl(n.bsoptname, o.bsoptname) as bsoptname -- 经营者
    ,nvl(n.actualcontroler, o.actualcontroler) as actualcontroler -- 实际控制人
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围
    ,nvl(n.enterprisename, o.enterprisename) as enterprisename -- 企业名称
    ,nvl(n.unifysocialcreditnum, o.unifysocialcreditnum) as unifysocialcreditnum -- 统一社会信用编号
    ,nvl(n.orginstitudecode, o.orginstitudecode) as orginstitudecode -- 组织机构代码
    ,nvl(n.entloanaccount, o.entloanaccount) as entloanaccount -- 企业贷款卡/中征码
    ,nvl(n.entlegalpersonname, o.entlegalpersonname) as entlegalpersonname -- 企业法人姓名
    ,nvl(n.entlegalpersonidno, o.entlegalpersonidno) as entlegalpersonidno -- 企业法人身份证号
    ,nvl(n.borroweridentity, o.borroweridentity) as borroweridentity -- 借款人身份
    ,nvl(n.registaddress, o.registaddress) as registaddress -- 注册地址
    ,nvl(n.registassets, o.registassets) as registassets -- 注册资本
    ,nvl(n.validitedate, o.validitedate) as validitedate -- 有效期
    ,nvl(n.registdate, o.registdate) as registdate -- 注册日期
    ,nvl(n.cptype, o.cptype) as cptype -- 企业类型
    ,nvl(n.bsstartdate, o.bsstartdate) as bsstartdate -- 营业起始日
    ,nvl(n.bsenddate, o.bsenddate) as bsenddate -- 营业到期日
    ,nvl(n.practyears, o.practyears) as practyears -- 法人从业年限
    ,nvl(n.licensename, o.licensename) as licensename -- 许可证名称
    ,nvl(n.licenseno, o.licenseno) as licenseno -- 许可证编号
    ,nvl(n.companyyear, o.companyyear) as companyyear -- 经营年限
    ,nvl(n.userbusinesssum, o.userbusinesssum) as userbusinesssum -- 客户经理意见金额
    ,nvl(n.userlimitterm, o.userlimitterm) as userlimitterm -- 客户经理意见期限
    ,nvl(n.recommendtype, o.recommendtype) as recommendtype -- 推荐类型
    ,nvl(n.recommendagency, o.recommendagency) as recommendagency -- 推荐中介名称
    ,nvl(n.creditamt, o.creditamt) as creditamt -- 授信金额
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 终审申请时间
    ,nvl(n.autoscore, o.autoscore) as autoscore -- 评分分值
    ,nvl(n.iscollectcredit, o.iscollectcredit) as iscollectcredit -- 征信查询情况
    ,nvl(n.informflag, o.informflag) as informflag -- 终审通知成功与否
    ,nvl(n.loaninformflag, o.loaninformflag) as loaninformflag -- 放款通知成功与否
    ,nvl(n.failreason, o.failreason) as failreason -- 拒绝原因
    ,nvl(n.finalapplyamount, o.finalapplyamount) as finalapplyamount -- 终审审批额度(元)
    ,nvl(n.cusid, o.cusid) as cusid -- 客户号
    ,nvl(n.detailaddr, o.detailaddr) as detailaddr -- 详细地址
    ,nvl(n.worknature, o.worknature) as worknature -- 工作性质
    ,nvl(n.inputbrid, o.inputbrid) as inputbrid -- 管理机构
    ,nvl(n.isbankrel, o.isbankrel) as isbankrel -- 是否我行关联人
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.apprendtime, o.apprendtime) as apprendtime -- 审批结束时间
    ,nvl(n.isemoji, o.isemoji) as isemoji -- 是否有影像文件
    ,nvl(n.inputid, o.inputid) as inputid -- 分行客户经理号（普惠金融专用）
    ,nvl(n.isoverduemain, o.isoverduemain) as isoverduemain -- 主借款人是否触碰征信逾期金额过大
    ,nvl(n.isoverduemaincp, o.isoverduemaincp) as isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
    ,nvl(n.seqid, o.seqid) as seqid -- 请求流水（用于庙算接口查询）
    ,nvl(n.comno, o.comno) as comno -- 地推公司编号
    ,nvl(n.comname, o.comname) as comname -- 地推公司名称
    ,nvl(n.checkersuggest, o.checkersuggest) as checkersuggest -- 下户核验意见
    ,nvl(n.inspsuggest, o.inspsuggest) as inspsuggest -- 质检岗意见
    ,nvl(n.inspsum, o.inspsum) as inspsum -- 质检岗建议金额
    ,nvl(n.insplimitterm, o.insplimitterm) as insplimitterm -- 质检岗建议期限
    ,nvl(n.interviewsuggest, o.interviewsuggest) as interviewsuggest -- 面谈意见
    ,nvl(n.ispreflag, o.ispreflag) as ispreflag -- 是否预终审
    ,nvl(n.contno, o.contno) as contno -- 合同编号
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 押品编号
    ,nvl(n.conttype, o.conttype) as conttype -- 合同类型（1:单笔合同2：额度合同）
    ,nvl(n.isonline, o.isonline) as isonline -- 是否线上（1-是2否）
    ,nvl(n.domicileaddr, o.domicileaddr) as domicileaddr -- 户籍所在地（户籍地址）
    ,nvl(n.lmtserno, o.lmtserno) as lmtserno -- 额度合同编号
    ,nvl(n.originalloan, o.originalloan) as originalloan -- 是否有原贷款
    ,nvl(n.isotherbankmtg, o.isotherbankmtg) as isotherbankmtg -- 是否他行在押房产
    ,nvl(n.orgmtgbank, o.orgmtgbank) as orgmtgbank -- 原抵押银行
    ,nvl(n.orgmtgbankbranch, o.orgmtgbankbranch) as orgmtgbankbranch -- 原抵押银行分行名称
    ,nvl(n.orghouseloanbalance, o.orghouseloanbalance) as orghouseloanbalance -- 在押房产贷款余额（元）
    ,nvl(n.isddjfloan, o.isddjfloan) as isddjfloan -- 大道是否放款
    ,nvl(n.canceltype, o.canceltype) as canceltype -- 取消类型（1取消订单，2取消放款）
    ,nvl(n.loaninterdt, o.loaninterdt) as loaninterdt -- 同贷交互时间
    ,nvl(n.oloaniscircle, o.oloaniscircle) as oloaniscircle -- 原贷款是否循环
    ,nvl(n.isbankorg, o.isbankorg) as isbankorg -- 是否银行机构
    ,nvl(n.isonloanbank, o.isonloanbank) as isonloanbank -- 在途贷款银行
    ,nvl(n.obankloanamt, o.obankloanamt) as obankloanamt -- 原银行房贷贷款金额
    ,nvl(n.obankloansurnotbal, o.obankloansurnotbal) as obankloansurnotbal -- 原银行房贷剩余未还本金
    ,nvl(n.oloansurterm, o.oloansurterm) as oloansurterm -- 原贷款剩余期限
    ,nvl(n.enterpriseyearincome, o.enterpriseyearincome) as enterpriseyearincome -- 企业年收入
    ,nvl(n.orghouseloantype, o.orghouseloantype) as orghouseloantype -- 原房产贷款类型
    ,nvl(n.otherdirection, o.otherdirection) as otherdirection -- 其他原房产贷款类型说明
    ,nvl(n.displaceoperatloanbal, o.displaceoperatloanbal) as displaceoperatloanbal -- 拟置换经营性贷款余额
    ,nvl(n.taxbureauserno, o.taxbureauserno) as taxbureauserno -- 税局授权流水
    ,nvl(n.taxrelatedtype, o.taxrelatedtype) as taxrelatedtype -- 涉税类型
    ,nvl(n.taxpayeridentino, o.taxpayeridentino) as taxpayeridentino -- 纳税人识别号
    ,nvl(n.employmentsituation, o.employmentsituation) as employmentsituation -- 就业状况
    ,nvl(n.annualtaxrevenue, o.annualtaxrevenue) as annualtaxrevenue -- 客户纳税年收入
    ,nvl(n.ddjfapprovestatus, o.ddjfapprovestatus) as ddjfapprovestatus -- 大道审批结果
    ,nvl(n.respstatus, o.respstatus) as respstatus -- 存证返回状态（0为失败，1为成功）
    ,nvl(n.agriflg, o.agriflg) as agriflg -- 是否农户
    ,nvl(n.businessesflag, o.businessesflag) as businessesflag -- 客户性质
    ,nvl(n.invtstkperc, o.invtstkperc) as invtstkperc -- 借款人持股比例
    ,nvl(n.coboinvtstkperc, o.coboinvtstkperc) as coboinvtstkperc -- 共借人持股比例
    ,nvl(n.onbranchbank, o.onbranchbank) as onbranchbank -- 所在分行
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 风险等级
    ,nvl(n.lot, o.lot) as lot -- 份额
    ,nvl(n.netvalue, o.netvalue) as netvalue -- 净值
    ,nvl(n.principalamt, o.principalamt) as principalamt -- 本金
    ,nvl(n.loanstartdate, o.loanstartdate) as loanstartdate -- 贷款起始日
    ,nvl(n.loanenddate, o.loanenddate) as loanenddate -- 贷款到期日
    ,nvl(n.warninginfo, o.warninginfo) as warninginfo -- 预警信息
    ,nvl(n.loantype, o.loantype) as loantype -- 贷款类型（STD_KD_LOAN_TYPE）
    ,nvl(n.lmtloanappno, o.lmtloanappno) as lmtloanappno -- 额度合同信贷申请流水号
    ,nvl(n.relationname, o.relationname) as relationname -- 直系亲属姓名
    ,nvl(n.relationphone, o.relationphone) as relationphone -- 直系亲属联系电话
    ,nvl(n.urgentcontactname, o.urgentcontactname) as urgentcontactname -- 紧急联系人姓名
    ,nvl(n.urgentcontactphone, o.urgentcontactphone) as urgentcontactphone -- 紧急联系人电话
    ,nvl(n.socialmon, o.socialmon) as socialmon -- 社保连续缴存月数
    ,nvl(n.accumulfundmon, o.accumulfundmon) as accumulfundmon -- 公积金连续缴存月数
    ,nvl(n.monincome, o.monincome) as monincome -- 税后月收入
    ,nvl(n.monthlyrepay, o.monthlyrepay) as monthlyrepay -- 月还款金额
    ,nvl(n.ishouse, o.ishouse) as ishouse -- 是否有房
    ,nvl(n.preloanterm, o.preloanterm) as preloanterm -- 兴车贷-贷款期限
    ,nvl(n.isborrowbook, o.isborrowbook) as isborrowbook -- 同贷书是否生成
    ,nvl(n.docoutputloca, o.docoutputloca) as docoutputloca -- 同贷书地址
    ,nvl(n.sysid, o.sysid) as sysid -- 系统来源
    ,nvl(n.qryopertp, o.qryopertp) as qryopertp -- 查询操作申请类型
    ,nvl(n.authotype, o.authotype) as authotype -- 授权方式
    ,nvl(n.biometrics, o.biometrics) as biometrics -- 生物识别技术
    ,nvl(n.authotime, o.authotime) as authotime -- 授权时间
    ,nvl(n.authostrdate, o.authostrdate) as authostrdate -- 授权开始时间
    ,nvl(n.authoenddate, o.authoenddate) as authoenddate -- 授权结束时间
    ,nvl(n.recacct, o.recacct) as recacct -- 收款账户(经销商)
    ,nvl(n.recacctbankname, o.recacctbankname) as recacctbankname -- 开户行(经销商)
    ,nvl(n.faceidentifiscore, o.faceidentifiscore) as faceidentifiscore -- 人脸识别照与证件照比对分数值
    ,nvl(n.loanamt, o.loanamt) as loanamt -- 客户贷款金额
    ,nvl(n.obillno, o.obillno) as obillno -- 原借据号
    ,nvl(n.ocontno, o.ocontno) as ocontno -- 原合同号
    ,nvl(n.oloanamount, o.oloanamount) as oloanamount -- 原借据金额
    ,nvl(n.oloanbalance, o.oloanbalance) as oloanbalance -- 原借据余额
    ,nvl(n.renewalstartdate, o.renewalstartdate) as renewalstartdate -- 续贷起始日期
    ,nvl(n.renewalenddate, o.renewalenddate) as renewalenddate -- 续贷到期日期
    ,nvl(n.iswhite, o.iswhite) as iswhite -- 是否白户
    ,nvl(n.whitecusid, o.whitecusid) as whitecusid -- 白名单客户号
    ,nvl(n.whitecerttype, o.whitecerttype) as whitecerttype -- 白名单客户证件类型
    ,nvl(n.whitecertcode, o.whitecertcode) as whitecertcode -- 白名单客户证件号码
    ,nvl(n.mainbusiness, o.mainbusiness) as mainbusiness -- 主营业务
    ,nvl(n.deviceamount, o.deviceamount) as deviceamount -- 设备数量（定型机）
    ,nvl(n.devicetotalprice, o.devicetotalprice) as devicetotalprice -- 企业设备资产总值
    ,nvl(n.fixedfundloanbalance, o.fixedfundloanbalance) as fixedfundloanbalance -- 企业固定资产贷款余额（元）
    ,nvl(n.deviceloanbalance, o.deviceloanbalance) as deviceloanbalance -- 企业设备融资租赁贷款余额（元）
    ,nvl(n.workingloanbalance, o.workingloanbalance) as workingloanbalance -- 企业流动资金贷款余额（元）
    ,nvl(n.relationcertcode, o.relationcertcode) as relationcertcode -- 直系亲属证件号
    ,nvl(n.ownerflag, o.ownerflag) as ownerflag -- 借款人是否实控人
    ,nvl(n.limitloanterm, o.limitloanterm) as limitloanterm -- 额度合同申请期限
    ,nvl(n.ctrlorg, o.ctrlorg) as ctrlorg -- 所属机构
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 终审申请日期
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 终审审批状态
    ,nvl(n.manualapproval, o.manualapproval) as manualapproval -- 是否人工审批标识
    ,nvl(n.taxflg, o.taxflg) as taxflg -- 是否涉税：YesNo
    ,nvl(n.applyamt, o.applyamt) as applyamt -- 申请金额
    ,nvl(n.blankcollateral, o.blankcollateral) as blankcollateral -- 抵押物毛坯状态
    ,nvl(n.fundlegal, o.fundlegal) as fundlegal -- 本次质押标的的资金来源是否合法合规
    ,nvl(n.iszdwhile, o.iszdwhile) as iszdwhile -- 是否智贷白名单
    ,nvl(n.managerialsetupamt, o.managerialsetupamt) as managerialsetupamt -- 经营机构推荐贷款额度
    ,nvl(n.natureland, o.natureland) as natureland -- 土地性质
    ,nvl(n.naturelandexplain, o.naturelandexplain) as naturelandexplain -- 土地性质其他说明
    ,nvl(n.natureregistered, o.natureregistered) as natureregistered -- 户籍性质
    ,nvl(n.ownershipratio, o.ownershipratio) as ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
    ,nvl(n.specialconsumer, o.specialconsumer) as specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
    ,nvl(n.specialprofession, o.specialprofession) as specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
    ,nvl(n.branchmanageopinion, o.branchmanageopinion) as branchmanageopinion -- 分行零售信贷负责人意见
    ,nvl(n.enterprisecerttype, o.enterprisecerttype) as enterprisecerttype -- 企业身份标识类型
    ,nvl(n.enterprisecertid, o.enterprisecertid) as enterprisecertid -- 企业身份标识号码
    ,nvl(n.iscrossregionrun, o.iscrossregionrun) as iscrossregionrun -- 
    ,nvl(n.wisdomloanmode, o.wisdomloanmode) as wisdomloanmode -- 
    ,nvl(n.highestcreditorrightamt, o.highestcreditorrightamt) as highestcreditorrightamt -- 
    ,nvl(n.cuscreditscorelevel, o.cuscreditscorelevel) as cuscreditscorelevel -- 
    ,nvl(n.renewalmodel, o.renewalmodel) as renewalmodel -- 
    ,nvl(n.selfemplflg, o.selfemplflg) as selfemplflg -- 
    ,nvl(n.salapeopflg, o.salapeopflg) as salapeopflg -- 
    ,nvl(n.bropermshrhratio, o.bropermshrhratio) as bropermshrhratio -- 
    ,nvl(n.csldsocilccode, o.csldsocilccode) as csldsocilccode -- 
    ,nvl(n.firstpayamt, o.firstpayamt) as firstpayamt -- 
    ,nvl(n.prepapplowncnt, o.prepapplowncnt) as prepapplowncnt -- 
    ,nvl(n.prepapplcomperrela, o.prepapplcomperrela) as prepapplcomperrela -- 
    ,nvl(n.brwersixmonincome, o.brwersixmonincome) as brwersixmonincome -- 
    ,nvl(n.brwersixmonfundpayamt, o.brwersixmonfundpayamt) as brwersixmonfundpayamt -- 
    ,nvl(n.brwerfundmonpayamt, o.brwerfundmonpayamt) as brwerfundmonpayamt -- 
    ,nvl(n.brwerfunduntpayratio, o.brwerfunduntpayratio) as brwerfunduntpayratio -- 
    ,nvl(n.brwerfundindvpayratio, o.brwerfundindvpayratio) as brwerfundindvpayratio -- 
    ,nvl(n.brwerretiage, o.brwerretiage) as brwerretiage -- 
    ,nvl(n.spousixmonincome, o.spousixmonincome) as spousixmonincome -- 
    ,nvl(n.spousixmonfundpayamt, o.spousixmonfundpayamt) as spousixmonfundpayamt -- 
    ,nvl(n.ownhouseqty, o.ownhouseqty) as ownhouseqty -- 
    ,nvl(n.locallmtpurchplcy, o.locallmtpurchplcy) as locallmtpurchplcy -- 
    ,nvl(n.isaddedvalue, o.isaddedvalue) as isaddedvalue -- 
    ,nvl(n.addedvalue, o.addedvalue) as addedvalue -- 
    ,nvl(n.carinvoice, o.carinvoice) as carinvoice -- 
    ,nvl(n.isnewcoborrower, o.isnewcoborrower) as isnewcoborrower -- 
    ,nvl(n.imagecheckno, o.imagecheckno) as imagecheckno -- 
    ,nvl(n.villatype, o.villatype) as villatype -- 
    ,nvl(n.housetypelocation, o.housetypelocation) as housetypelocation -- 
    ,nvl(n.rowno, o.rowno) as rowno -- 
    ,nvl(n.gardenarea, o.gardenarea) as gardenarea -- 
    ,nvl(n.freearea, o.freearea) as freearea -- 
    ,nvl(n.cardaddr, o.cardaddr) as cardaddr -- 
    ,nvl(n.idenblngprovcity, o.idenblngprovcity) as idenblngprovcity -- 
    ,nvl(n.roomprice, o.roomprice) as roomprice -- 
    ,nvl(n.yearlyrental, o.yearlyrental) as yearlyrental -- 
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 
    ,nvl(n.creditmodel, o.creditmodel) as creditmodel -- 
    ,nvl(n.ishavecar, o.ishavecar) as ishavecar -- 
    ,nvl(n.licensenumber, o.licensenumber) as licensenumber -- 
    ,nvl(n.drivinglicensedate, o.drivinglicensedate) as drivinglicensedate -- 
    ,nvl(n.resiloczonecd, o.resiloczonecd) as resiloczonecd -- 
    ,nvl(n.untloczonecd, o.untloczonecd) as untloczonecd -- 
    ,nvl(n.resiloczone, o.resiloczone) as resiloczone -- 
    ,nvl(n.compphone, o.compphone) as compphone -- 
    ,nvl(n.isriskcust, o.isriskcust) as isriskcust -- 
    ,nvl(n.atachcomm, o.atachcomm) as atachcomm -- 
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
from (select * from ${iol_schema}.icms_fkd_iqp_loan_app_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fkd_iqp_loan_app where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.prdcode <> n.prdcode
        or o.prdname <> n.prdname
        or o.ctrlbranch <> n.ctrlbranch
        or o.appchannel <> n.appchannel
        or o.channelno <> n.channelno
        or o.applyno <> n.applyno
        or o.appadvice <> n.appadvice
        or o.appconclusion <> n.appconclusion
        or o.certtype <> n.certtype
        or o.certno <> n.certno
        or o.gender <> n.gender
        or o.issauthority <> n.issauthority
        or o.isscountry <> n.isscountry
        or o.issdate <> n.issdate
        or o.expirydate <> n.expirydate
        or o.bankind <> n.bankind
        or o.hashouseind <> n.hashouseind
        or o.housecount <> n.housecount
        or o.paysourcen <> n.paysourcen
        or o.partnercoownerind <> n.partnercoownerind
        or o.partnerrelind <> n.partnerrelind
        or o.marriagedate <> n.marriagedate
        or o.businesstype <> n.businesstype
        or o.merchantname <> n.merchantname
        or o.businessaddrtype <> n.businessaddrtype
        or o.businessaddr <> n.businessaddr
        or o.bsoptname <> n.bsoptname
        or o.actualcontroler <> n.actualcontroler
        or o.businessscope <> n.businessscope
        or o.enterprisename <> n.enterprisename
        or o.unifysocialcreditnum <> n.unifysocialcreditnum
        or o.orginstitudecode <> n.orginstitudecode
        or o.entloanaccount <> n.entloanaccount
        or o.entlegalpersonname <> n.entlegalpersonname
        or o.entlegalpersonidno <> n.entlegalpersonidno
        or o.borroweridentity <> n.borroweridentity
        or o.registaddress <> n.registaddress
        or o.registassets <> n.registassets
        or o.validitedate <> n.validitedate
        or o.registdate <> n.registdate
        or o.cptype <> n.cptype
        or o.bsstartdate <> n.bsstartdate
        or o.bsenddate <> n.bsenddate
        or o.practyears <> n.practyears
        or o.licensename <> n.licensename
        or o.licenseno <> n.licenseno
        or o.companyyear <> n.companyyear
        or o.userbusinesssum <> n.userbusinesssum
        or o.userlimitterm <> n.userlimitterm
        or o.recommendtype <> n.recommendtype
        or o.recommendagency <> n.recommendagency
        or o.creditamt <> n.creditamt
        or o.inputtime <> n.inputtime
        or o.autoscore <> n.autoscore
        or o.iscollectcredit <> n.iscollectcredit
        or o.informflag <> n.informflag
        or o.loaninformflag <> n.loaninformflag
        or o.failreason <> n.failreason
        or o.finalapplyamount <> n.finalapplyamount
        or o.cusid <> n.cusid
        or o.detailaddr <> n.detailaddr
        or o.worknature <> n.worknature
        or o.inputbrid <> n.inputbrid
        or o.isbankrel <> n.isbankrel
        or o.phone <> n.phone
        or o.apprendtime <> n.apprendtime
        or o.isemoji <> n.isemoji
        or o.inputid <> n.inputid
        or o.isoverduemain <> n.isoverduemain
        or o.isoverduemaincp <> n.isoverduemaincp
        or o.seqid <> n.seqid
        or o.comno <> n.comno
        or o.comname <> n.comname
        or o.checkersuggest <> n.checkersuggest
        or o.inspsuggest <> n.inspsuggest
        or o.inspsum <> n.inspsum
        or o.insplimitterm <> n.insplimitterm
        or o.interviewsuggest <> n.interviewsuggest
        or o.ispreflag <> n.ispreflag
        or o.contno <> n.contno
        or o.guarantyid <> n.guarantyid
        or o.conttype <> n.conttype
        or o.isonline <> n.isonline
        or o.domicileaddr <> n.domicileaddr
        or o.lmtserno <> n.lmtserno
        or o.originalloan <> n.originalloan
        or o.isotherbankmtg <> n.isotherbankmtg
        or o.orgmtgbank <> n.orgmtgbank
        or o.orgmtgbankbranch <> n.orgmtgbankbranch
        or o.orghouseloanbalance <> n.orghouseloanbalance
        or o.isddjfloan <> n.isddjfloan
        or o.canceltype <> n.canceltype
        or o.loaninterdt <> n.loaninterdt
        or o.oloaniscircle <> n.oloaniscircle
        or o.isbankorg <> n.isbankorg
        or o.isonloanbank <> n.isonloanbank
        or o.obankloanamt <> n.obankloanamt
        or o.obankloansurnotbal <> n.obankloansurnotbal
        or o.oloansurterm <> n.oloansurterm
        or o.enterpriseyearincome <> n.enterpriseyearincome
        or o.orghouseloantype <> n.orghouseloantype
        or o.otherdirection <> n.otherdirection
        or o.displaceoperatloanbal <> n.displaceoperatloanbal
        or o.taxbureauserno <> n.taxbureauserno
        or o.taxrelatedtype <> n.taxrelatedtype
        or o.taxpayeridentino <> n.taxpayeridentino
        or o.employmentsituation <> n.employmentsituation
        or o.annualtaxrevenue <> n.annualtaxrevenue
        or o.ddjfapprovestatus <> n.ddjfapprovestatus
        or o.respstatus <> n.respstatus
        or o.agriflg <> n.agriflg
        or o.businessesflag <> n.businessesflag
        or o.invtstkperc <> n.invtstkperc
        or o.coboinvtstkperc <> n.coboinvtstkperc
        or o.onbranchbank <> n.onbranchbank
        or o.risklevel <> n.risklevel
        or o.lot <> n.lot
        or o.netvalue <> n.netvalue
        or o.principalamt <> n.principalamt
        or o.loanstartdate <> n.loanstartdate
        or o.loanenddate <> n.loanenddate
        or o.warninginfo <> n.warninginfo
        or o.loantype <> n.loantype
        or o.lmtloanappno <> n.lmtloanappno
        or o.relationname <> n.relationname
        or o.relationphone <> n.relationphone
        or o.urgentcontactname <> n.urgentcontactname
        or o.urgentcontactphone <> n.urgentcontactphone
        or o.socialmon <> n.socialmon
        or o.accumulfundmon <> n.accumulfundmon
        or o.monincome <> n.monincome
        or o.monthlyrepay <> n.monthlyrepay
        or o.ishouse <> n.ishouse
        or o.preloanterm <> n.preloanterm
        or o.isborrowbook <> n.isborrowbook
        or o.docoutputloca <> n.docoutputloca
        or o.sysid <> n.sysid
        or o.qryopertp <> n.qryopertp
        or o.authotype <> n.authotype
        or o.biometrics <> n.biometrics
        or o.authotime <> n.authotime
        or o.authostrdate <> n.authostrdate
        or o.authoenddate <> n.authoenddate
        or o.recacct <> n.recacct
        or o.recacctbankname <> n.recacctbankname
        or o.faceidentifiscore <> n.faceidentifiscore
        or o.loanamt <> n.loanamt
        or o.obillno <> n.obillno
        or o.ocontno <> n.ocontno
        or o.oloanamount <> n.oloanamount
        or o.oloanbalance <> n.oloanbalance
        or o.renewalstartdate <> n.renewalstartdate
        or o.renewalenddate <> n.renewalenddate
        or o.iswhite <> n.iswhite
        or o.whitecusid <> n.whitecusid
        or o.whitecerttype <> n.whitecerttype
        or o.whitecertcode <> n.whitecertcode
        or o.mainbusiness <> n.mainbusiness
        or o.deviceamount <> n.deviceamount
        or o.devicetotalprice <> n.devicetotalprice
        or o.fixedfundloanbalance <> n.fixedfundloanbalance
        or o.deviceloanbalance <> n.deviceloanbalance
        or o.workingloanbalance <> n.workingloanbalance
        or o.relationcertcode <> n.relationcertcode
        or o.ownerflag <> n.ownerflag
        or o.limitloanterm <> n.limitloanterm
        or o.ctrlorg <> n.ctrlorg
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.approvestatus <> n.approvestatus
        or o.manualapproval <> n.manualapproval
        or o.taxflg <> n.taxflg
        or o.applyamt <> n.applyamt
        or o.blankcollateral <> n.blankcollateral
        or o.fundlegal <> n.fundlegal
        or o.iszdwhile <> n.iszdwhile
        or o.managerialsetupamt <> n.managerialsetupamt
        or o.natureland <> n.natureland
        or o.naturelandexplain <> n.naturelandexplain
        or o.natureregistered <> n.natureregistered
        or o.ownershipratio <> n.ownershipratio
        or o.specialconsumer <> n.specialconsumer
        or o.specialprofession <> n.specialprofession
        or o.branchmanageopinion <> n.branchmanageopinion
        or o.enterprisecerttype <> n.enterprisecerttype
        or o.enterprisecertid <> n.enterprisecertid
        or o.iscrossregionrun <> n.iscrossregionrun
        or o.wisdomloanmode <> n.wisdomloanmode
        or o.highestcreditorrightamt <> n.highestcreditorrightamt
        or o.cuscreditscorelevel <> n.cuscreditscorelevel
        or o.renewalmodel <> n.renewalmodel
        or o.selfemplflg <> n.selfemplflg
        or o.salapeopflg <> n.salapeopflg
        or o.bropermshrhratio <> n.bropermshrhratio
        or o.csldsocilccode <> n.csldsocilccode
        or o.firstpayamt <> n.firstpayamt
        or o.prepapplowncnt <> n.prepapplowncnt
        or o.prepapplcomperrela <> n.prepapplcomperrela
        or o.brwersixmonincome <> n.brwersixmonincome
        or o.brwersixmonfundpayamt <> n.brwersixmonfundpayamt
        or o.brwerfundmonpayamt <> n.brwerfundmonpayamt
        or o.brwerfunduntpayratio <> n.brwerfunduntpayratio
        or o.brwerfundindvpayratio <> n.brwerfundindvpayratio
        or o.brwerretiage <> n.brwerretiage
        or o.spousixmonincome <> n.spousixmonincome
        or o.spousixmonfundpayamt <> n.spousixmonfundpayamt
        or o.ownhouseqty <> n.ownhouseqty
        or o.locallmtpurchplcy <> n.locallmtpurchplcy
        or o.isaddedvalue <> n.isaddedvalue
        or o.addedvalue <> n.addedvalue
        or o.carinvoice <> n.carinvoice
        or o.isnewcoborrower <> n.isnewcoborrower
        or o.imagecheckno <> n.imagecheckno
        or o.villatype <> n.villatype
        or o.housetypelocation <> n.housetypelocation
        or o.rowno <> n.rowno
        or o.gardenarea <> n.gardenarea
        or o.freearea <> n.freearea
        or o.cardaddr <> n.cardaddr
        or o.idenblngprovcity <> n.idenblngprovcity
        or o.roomprice <> n.roomprice
        or o.yearlyrental <> n.yearlyrental
        or o.updatedate <> n.updatedate
        or o.creditmodel <> n.creditmodel
        or o.ishavecar <> n.ishavecar
        or o.licensenumber <> n.licensenumber
        or o.drivinglicensedate <> n.drivinglicensedate
        or o.resiloczonecd <> n.resiloczonecd
        or o.untloczonecd <> n.untloczonecd
        or o.resiloczone <> n.resiloczone
        or o.compphone <> n.compphone
        or o.isriskcust <> n.isriskcust
        or o.atachcomm <> n.atachcomm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fkd_iqp_loan_app_cl(
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,highestcreditorrightamt -- 
            ,cuscreditscorelevel -- 
            ,renewalmodel -- 
            ,selfemplflg -- 
            ,salapeopflg -- 
            ,bropermshrhratio -- 
            ,csldsocilccode -- 
            ,firstpayamt -- 
            ,prepapplowncnt -- 
            ,prepapplcomperrela -- 
            ,brwersixmonincome -- 
            ,brwersixmonfundpayamt -- 
            ,brwerfundmonpayamt -- 
            ,brwerfunduntpayratio -- 
            ,brwerfundindvpayratio -- 
            ,brwerretiage -- 
            ,spousixmonincome -- 
            ,spousixmonfundpayamt -- 
            ,ownhouseqty -- 
            ,locallmtpurchplcy -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,imagecheckno -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,cardaddr -- 
            ,idenblngprovcity -- 
            ,roomprice -- 
            ,yearlyrental -- 
            ,updatedate -- 
            ,creditmodel -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fkd_iqp_loan_app_op(
            serialno -- 业务流水号
            ,prdcode -- 产品编号
            ,prdname -- 产品名称
            ,ctrlbranch -- 所属分行
            ,appchannel -- 接入渠道
            ,channelno -- 渠道号
            ,applyno -- 信贷申请流水号
            ,appadvice -- 审批意见
            ,appconclusion -- 审批结论
            ,certtype -- 主借人证件类型
            ,certno -- 主借人证件编号
            ,gender -- 性别
            ,issauthority -- 签发机关
            ,isscountry -- 签发国家
            ,issdate -- 签发日期
            ,expirydate -- 到期日期
            ,bankind -- 本行员工标志
            ,hashouseind -- 除本次抵押房产外，是否有其他住房
            ,housecount -- 房产数量
            ,paysourcen -- 还款来源
            ,partnercoownerind -- 配偶共有人标志
            ,partnerrelind -- 配偶关联人标志
            ,marriagedate -- 婚姻登记日期
            ,businesstype -- 经营类型
            ,merchantname -- 商户名称
            ,businessaddrtype -- 经营场所类型
            ,businessaddr -- 经营场所
            ,bsoptname -- 经营者
            ,actualcontroler -- 实际控制人
            ,businessscope -- 经营范围
            ,enterprisename -- 企业名称
            ,unifysocialcreditnum -- 统一社会信用编号
            ,orginstitudecode -- 组织机构代码
            ,entloanaccount -- 企业贷款卡/中征码
            ,entlegalpersonname -- 企业法人姓名
            ,entlegalpersonidno -- 企业法人身份证号
            ,borroweridentity -- 借款人身份
            ,registaddress -- 注册地址
            ,registassets -- 注册资本
            ,validitedate -- 有效期
            ,registdate -- 注册日期
            ,cptype -- 企业类型
            ,bsstartdate -- 营业起始日
            ,bsenddate -- 营业到期日
            ,practyears -- 法人从业年限
            ,licensename -- 许可证名称
            ,licenseno -- 许可证编号
            ,companyyear -- 经营年限
            ,userbusinesssum -- 客户经理意见金额
            ,userlimitterm -- 客户经理意见期限
            ,recommendtype -- 推荐类型
            ,recommendagency -- 推荐中介名称
            ,creditamt -- 授信金额
            ,inputtime -- 终审申请时间
            ,autoscore -- 评分分值
            ,iscollectcredit -- 征信查询情况
            ,informflag -- 终审通知成功与否
            ,loaninformflag -- 放款通知成功与否
            ,failreason -- 拒绝原因
            ,finalapplyamount -- 终审审批额度(元)
            ,cusid -- 客户号
            ,detailaddr -- 详细地址
            ,worknature -- 工作性质
            ,inputbrid -- 管理机构
            ,isbankrel -- 是否我行关联人
            ,phone -- 手机号
            ,apprendtime -- 审批结束时间
            ,isemoji -- 是否有影像文件
            ,inputid -- 分行客户经理号（普惠金融专用）
            ,isoverduemain -- 主借款人是否触碰征信逾期金额过大
            ,isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
            ,seqid -- 请求流水（用于庙算接口查询）
            ,comno -- 地推公司编号
            ,comname -- 地推公司名称
            ,checkersuggest -- 下户核验意见
            ,inspsuggest -- 质检岗意见
            ,inspsum -- 质检岗建议金额
            ,insplimitterm -- 质检岗建议期限
            ,interviewsuggest -- 面谈意见
            ,ispreflag -- 是否预终审
            ,contno -- 合同编号
            ,guarantyid -- 押品编号
            ,conttype -- 合同类型（1:单笔合同2：额度合同）
            ,isonline -- 是否线上（1-是2否）
            ,domicileaddr -- 户籍所在地（户籍地址）
            ,lmtserno -- 额度合同编号
            ,originalloan -- 是否有原贷款
            ,isotherbankmtg -- 是否他行在押房产
            ,orgmtgbank -- 原抵押银行
            ,orgmtgbankbranch -- 原抵押银行分行名称
            ,orghouseloanbalance -- 在押房产贷款余额（元）
            ,isddjfloan -- 大道是否放款
            ,canceltype -- 取消类型（1取消订单，2取消放款）
            ,loaninterdt -- 同贷交互时间
            ,oloaniscircle -- 原贷款是否循环
            ,isbankorg -- 是否银行机构
            ,isonloanbank -- 在途贷款银行
            ,obankloanamt -- 原银行房贷贷款金额
            ,obankloansurnotbal -- 原银行房贷剩余未还本金
            ,oloansurterm -- 原贷款剩余期限
            ,enterpriseyearincome -- 企业年收入
            ,orghouseloantype -- 原房产贷款类型
            ,otherdirection -- 其他原房产贷款类型说明
            ,displaceoperatloanbal -- 拟置换经营性贷款余额
            ,taxbureauserno -- 税局授权流水
            ,taxrelatedtype -- 涉税类型
            ,taxpayeridentino -- 纳税人识别号
            ,employmentsituation -- 就业状况
            ,annualtaxrevenue -- 客户纳税年收入
            ,ddjfapprovestatus -- 大道审批结果
            ,respstatus -- 存证返回状态（0为失败，1为成功）
            ,agriflg -- 是否农户
            ,businessesflag -- 客户性质
            ,invtstkperc -- 借款人持股比例
            ,coboinvtstkperc -- 共借人持股比例
            ,onbranchbank -- 所在分行
            ,risklevel -- 风险等级
            ,lot -- 份额
            ,netvalue -- 净值
            ,principalamt -- 本金
            ,loanstartdate -- 贷款起始日
            ,loanenddate -- 贷款到期日
            ,warninginfo -- 预警信息
            ,loantype -- 贷款类型（STD_KD_LOAN_TYPE）
            ,lmtloanappno -- 额度合同信贷申请流水号
            ,relationname -- 直系亲属姓名
            ,relationphone -- 直系亲属联系电话
            ,urgentcontactname -- 紧急联系人姓名
            ,urgentcontactphone -- 紧急联系人电话
            ,socialmon -- 社保连续缴存月数
            ,accumulfundmon -- 公积金连续缴存月数
            ,monincome -- 税后月收入
            ,monthlyrepay -- 月还款金额
            ,ishouse -- 是否有房
            ,preloanterm -- 兴车贷-贷款期限
            ,isborrowbook -- 同贷书是否生成
            ,docoutputloca -- 同贷书地址
            ,sysid -- 系统来源
            ,qryopertp -- 查询操作申请类型
            ,authotype -- 授权方式
            ,biometrics -- 生物识别技术
            ,authotime -- 授权时间
            ,authostrdate -- 授权开始时间
            ,authoenddate -- 授权结束时间
            ,recacct -- 收款账户(经销商)
            ,recacctbankname -- 开户行(经销商)
            ,faceidentifiscore -- 人脸识别照与证件照比对分数值
            ,loanamt -- 客户贷款金额
            ,obillno -- 原借据号
            ,ocontno -- 原合同号
            ,oloanamount -- 原借据金额
            ,oloanbalance -- 原借据余额
            ,renewalstartdate -- 续贷起始日期
            ,renewalenddate -- 续贷到期日期
            ,iswhite -- 是否白户
            ,whitecusid -- 白名单客户号
            ,whitecerttype -- 白名单客户证件类型
            ,whitecertcode -- 白名单客户证件号码
            ,mainbusiness -- 主营业务
            ,deviceamount -- 设备数量（定型机）
            ,devicetotalprice -- 企业设备资产总值
            ,fixedfundloanbalance -- 企业固定资产贷款余额（元）
            ,deviceloanbalance -- 企业设备融资租赁贷款余额（元）
            ,workingloanbalance -- 企业流动资金贷款余额（元）
            ,relationcertcode -- 直系亲属证件号
            ,ownerflag -- 借款人是否实控人
            ,limitloanterm -- 额度合同申请期限
            ,ctrlorg -- 所属机构
            ,migtflag -- 
            ,inputdate -- 终审申请日期
            ,approvestatus -- 终审审批状态
            ,manualapproval -- 是否人工审批标识
            ,taxflg -- 是否涉税：YesNo
            ,applyamt -- 申请金额
            ,blankcollateral -- 抵押物毛坯状态
            ,fundlegal -- 本次质押标的的资金来源是否合法合规
            ,iszdwhile -- 是否智贷白名单
            ,managerialsetupamt -- 经营机构推荐贷款额度
            ,natureland -- 土地性质
            ,naturelandexplain -- 土地性质其他说明
            ,natureregistered -- 户籍性质
            ,ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
            ,specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
            ,specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
            ,branchmanageopinion -- 分行零售信贷负责人意见
            ,enterprisecerttype -- 企业身份标识类型
            ,enterprisecertid -- 企业身份标识号码
            ,iscrossregionrun -- 
            ,wisdomloanmode -- 
            ,highestcreditorrightamt -- 
            ,cuscreditscorelevel -- 
            ,renewalmodel -- 
            ,selfemplflg -- 
            ,salapeopflg -- 
            ,bropermshrhratio -- 
            ,csldsocilccode -- 
            ,firstpayamt -- 
            ,prepapplowncnt -- 
            ,prepapplcomperrela -- 
            ,brwersixmonincome -- 
            ,brwersixmonfundpayamt -- 
            ,brwerfundmonpayamt -- 
            ,brwerfunduntpayratio -- 
            ,brwerfundindvpayratio -- 
            ,brwerretiage -- 
            ,spousixmonincome -- 
            ,spousixmonfundpayamt -- 
            ,ownhouseqty -- 
            ,locallmtpurchplcy -- 
            ,isaddedvalue -- 
            ,addedvalue -- 
            ,carinvoice -- 
            ,isnewcoborrower -- 
            ,imagecheckno -- 
            ,villatype -- 
            ,housetypelocation -- 
            ,rowno -- 
            ,gardenarea -- 
            ,freearea -- 
            ,cardaddr -- 
            ,idenblngprovcity -- 
            ,roomprice -- 
            ,yearlyrental -- 
            ,updatedate -- 
            ,creditmodel -- 
            ,ishavecar -- 
            ,licensenumber -- 
            ,drivinglicensedate -- 
            ,resiloczonecd -- 
            ,untloczonecd -- 
            ,resiloczone -- 
            ,compphone -- 
            ,isriskcust -- 
            ,atachcomm -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 业务流水号
    ,o.prdcode -- 产品编号
    ,o.prdname -- 产品名称
    ,o.ctrlbranch -- 所属分行
    ,o.appchannel -- 接入渠道
    ,o.channelno -- 渠道号
    ,o.applyno -- 信贷申请流水号
    ,o.appadvice -- 审批意见
    ,o.appconclusion -- 审批结论
    ,o.certtype -- 主借人证件类型
    ,o.certno -- 主借人证件编号
    ,o.gender -- 性别
    ,o.issauthority -- 签发机关
    ,o.isscountry -- 签发国家
    ,o.issdate -- 签发日期
    ,o.expirydate -- 到期日期
    ,o.bankind -- 本行员工标志
    ,o.hashouseind -- 除本次抵押房产外，是否有其他住房
    ,o.housecount -- 房产数量
    ,o.paysourcen -- 还款来源
    ,o.partnercoownerind -- 配偶共有人标志
    ,o.partnerrelind -- 配偶关联人标志
    ,o.marriagedate -- 婚姻登记日期
    ,o.businesstype -- 经营类型
    ,o.merchantname -- 商户名称
    ,o.businessaddrtype -- 经营场所类型
    ,o.businessaddr -- 经营场所
    ,o.bsoptname -- 经营者
    ,o.actualcontroler -- 实际控制人
    ,o.businessscope -- 经营范围
    ,o.enterprisename -- 企业名称
    ,o.unifysocialcreditnum -- 统一社会信用编号
    ,o.orginstitudecode -- 组织机构代码
    ,o.entloanaccount -- 企业贷款卡/中征码
    ,o.entlegalpersonname -- 企业法人姓名
    ,o.entlegalpersonidno -- 企业法人身份证号
    ,o.borroweridentity -- 借款人身份
    ,o.registaddress -- 注册地址
    ,o.registassets -- 注册资本
    ,o.validitedate -- 有效期
    ,o.registdate -- 注册日期
    ,o.cptype -- 企业类型
    ,o.bsstartdate -- 营业起始日
    ,o.bsenddate -- 营业到期日
    ,o.practyears -- 法人从业年限
    ,o.licensename -- 许可证名称
    ,o.licenseno -- 许可证编号
    ,o.companyyear -- 经营年限
    ,o.userbusinesssum -- 客户经理意见金额
    ,o.userlimitterm -- 客户经理意见期限
    ,o.recommendtype -- 推荐类型
    ,o.recommendagency -- 推荐中介名称
    ,o.creditamt -- 授信金额
    ,o.inputtime -- 终审申请时间
    ,o.autoscore -- 评分分值
    ,o.iscollectcredit -- 征信查询情况
    ,o.informflag -- 终审通知成功与否
    ,o.loaninformflag -- 放款通知成功与否
    ,o.failreason -- 拒绝原因
    ,o.finalapplyamount -- 终审审批额度(元)
    ,o.cusid -- 客户号
    ,o.detailaddr -- 详细地址
    ,o.worknature -- 工作性质
    ,o.inputbrid -- 管理机构
    ,o.isbankrel -- 是否我行关联人
    ,o.phone -- 手机号
    ,o.apprendtime -- 审批结束时间
    ,o.isemoji -- 是否有影像文件
    ,o.inputid -- 分行客户经理号（普惠金融专用）
    ,o.isoverduemain -- 主借款人是否触碰征信逾期金额过大
    ,o.isoverduemaincp -- 主借款人配偶是否触碰征信逾期金额过大
    ,o.seqid -- 请求流水（用于庙算接口查询）
    ,o.comno -- 地推公司编号
    ,o.comname -- 地推公司名称
    ,o.checkersuggest -- 下户核验意见
    ,o.inspsuggest -- 质检岗意见
    ,o.inspsum -- 质检岗建议金额
    ,o.insplimitterm -- 质检岗建议期限
    ,o.interviewsuggest -- 面谈意见
    ,o.ispreflag -- 是否预终审
    ,o.contno -- 合同编号
    ,o.guarantyid -- 押品编号
    ,o.conttype -- 合同类型（1:单笔合同2：额度合同）
    ,o.isonline -- 是否线上（1-是2否）
    ,o.domicileaddr -- 户籍所在地（户籍地址）
    ,o.lmtserno -- 额度合同编号
    ,o.originalloan -- 是否有原贷款
    ,o.isotherbankmtg -- 是否他行在押房产
    ,o.orgmtgbank -- 原抵押银行
    ,o.orgmtgbankbranch -- 原抵押银行分行名称
    ,o.orghouseloanbalance -- 在押房产贷款余额（元）
    ,o.isddjfloan -- 大道是否放款
    ,o.canceltype -- 取消类型（1取消订单，2取消放款）
    ,o.loaninterdt -- 同贷交互时间
    ,o.oloaniscircle -- 原贷款是否循环
    ,o.isbankorg -- 是否银行机构
    ,o.isonloanbank -- 在途贷款银行
    ,o.obankloanamt -- 原银行房贷贷款金额
    ,o.obankloansurnotbal -- 原银行房贷剩余未还本金
    ,o.oloansurterm -- 原贷款剩余期限
    ,o.enterpriseyearincome -- 企业年收入
    ,o.orghouseloantype -- 原房产贷款类型
    ,o.otherdirection -- 其他原房产贷款类型说明
    ,o.displaceoperatloanbal -- 拟置换经营性贷款余额
    ,o.taxbureauserno -- 税局授权流水
    ,o.taxrelatedtype -- 涉税类型
    ,o.taxpayeridentino -- 纳税人识别号
    ,o.employmentsituation -- 就业状况
    ,o.annualtaxrevenue -- 客户纳税年收入
    ,o.ddjfapprovestatus -- 大道审批结果
    ,o.respstatus -- 存证返回状态（0为失败，1为成功）
    ,o.agriflg -- 是否农户
    ,o.businessesflag -- 客户性质
    ,o.invtstkperc -- 借款人持股比例
    ,o.coboinvtstkperc -- 共借人持股比例
    ,o.onbranchbank -- 所在分行
    ,o.risklevel -- 风险等级
    ,o.lot -- 份额
    ,o.netvalue -- 净值
    ,o.principalamt -- 本金
    ,o.loanstartdate -- 贷款起始日
    ,o.loanenddate -- 贷款到期日
    ,o.warninginfo -- 预警信息
    ,o.loantype -- 贷款类型（STD_KD_LOAN_TYPE）
    ,o.lmtloanappno -- 额度合同信贷申请流水号
    ,o.relationname -- 直系亲属姓名
    ,o.relationphone -- 直系亲属联系电话
    ,o.urgentcontactname -- 紧急联系人姓名
    ,o.urgentcontactphone -- 紧急联系人电话
    ,o.socialmon -- 社保连续缴存月数
    ,o.accumulfundmon -- 公积金连续缴存月数
    ,o.monincome -- 税后月收入
    ,o.monthlyrepay -- 月还款金额
    ,o.ishouse -- 是否有房
    ,o.preloanterm -- 兴车贷-贷款期限
    ,o.isborrowbook -- 同贷书是否生成
    ,o.docoutputloca -- 同贷书地址
    ,o.sysid -- 系统来源
    ,o.qryopertp -- 查询操作申请类型
    ,o.authotype -- 授权方式
    ,o.biometrics -- 生物识别技术
    ,o.authotime -- 授权时间
    ,o.authostrdate -- 授权开始时间
    ,o.authoenddate -- 授权结束时间
    ,o.recacct -- 收款账户(经销商)
    ,o.recacctbankname -- 开户行(经销商)
    ,o.faceidentifiscore -- 人脸识别照与证件照比对分数值
    ,o.loanamt -- 客户贷款金额
    ,o.obillno -- 原借据号
    ,o.ocontno -- 原合同号
    ,o.oloanamount -- 原借据金额
    ,o.oloanbalance -- 原借据余额
    ,o.renewalstartdate -- 续贷起始日期
    ,o.renewalenddate -- 续贷到期日期
    ,o.iswhite -- 是否白户
    ,o.whitecusid -- 白名单客户号
    ,o.whitecerttype -- 白名单客户证件类型
    ,o.whitecertcode -- 白名单客户证件号码
    ,o.mainbusiness -- 主营业务
    ,o.deviceamount -- 设备数量（定型机）
    ,o.devicetotalprice -- 企业设备资产总值
    ,o.fixedfundloanbalance -- 企业固定资产贷款余额（元）
    ,o.deviceloanbalance -- 企业设备融资租赁贷款余额（元）
    ,o.workingloanbalance -- 企业流动资金贷款余额（元）
    ,o.relationcertcode -- 直系亲属证件号
    ,o.ownerflag -- 借款人是否实控人
    ,o.limitloanterm -- 额度合同申请期限
    ,o.ctrlorg -- 所属机构
    ,o.migtflag -- 
    ,o.inputdate -- 终审申请日期
    ,o.approvestatus -- 终审审批状态
    ,o.manualapproval -- 是否人工审批标识
    ,o.taxflg -- 是否涉税：YesNo
    ,o.applyamt -- 申请金额
    ,o.blankcollateral -- 抵押物毛坯状态
    ,o.fundlegal -- 本次质押标的的资金来源是否合法合规
    ,o.iszdwhile -- 是否智贷白名单
    ,o.managerialsetupamt -- 经营机构推荐贷款额度
    ,o.natureland -- 土地性质
    ,o.naturelandexplain -- 土地性质其他说明
    ,o.natureregistered -- 户籍性质
    ,o.ownershipratio -- 借款人持有本次贷款质物的权属是否为100%
    ,o.specialconsumer -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
    ,o.specialprofession -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
    ,o.branchmanageopinion -- 分行零售信贷负责人意见
    ,o.enterprisecerttype -- 企业身份标识类型
    ,o.enterprisecertid -- 企业身份标识号码
    ,o.iscrossregionrun -- 
    ,o.wisdomloanmode -- 
    ,o.highestcreditorrightamt -- 
    ,o.cuscreditscorelevel -- 
    ,o.renewalmodel -- 
    ,o.selfemplflg -- 
    ,o.salapeopflg -- 
    ,o.bropermshrhratio -- 
    ,o.csldsocilccode -- 
    ,o.firstpayamt -- 
    ,o.prepapplowncnt -- 
    ,o.prepapplcomperrela -- 
    ,o.brwersixmonincome -- 
    ,o.brwersixmonfundpayamt -- 
    ,o.brwerfundmonpayamt -- 
    ,o.brwerfunduntpayratio -- 
    ,o.brwerfundindvpayratio -- 
    ,o.brwerretiage -- 
    ,o.spousixmonincome -- 
    ,o.spousixmonfundpayamt -- 
    ,o.ownhouseqty -- 
    ,o.locallmtpurchplcy -- 
    ,o.isaddedvalue -- 
    ,o.addedvalue -- 
    ,o.carinvoice -- 
    ,o.isnewcoborrower -- 
    ,o.imagecheckno -- 
    ,o.villatype -- 
    ,o.housetypelocation -- 
    ,o.rowno -- 
    ,o.gardenarea -- 
    ,o.freearea -- 
    ,o.cardaddr -- 
    ,o.idenblngprovcity -- 
    ,o.roomprice -- 
    ,o.yearlyrental -- 
    ,o.updatedate -- 
    ,o.creditmodel -- 
    ,o.ishavecar -- 
    ,o.licensenumber -- 
    ,o.drivinglicensedate -- 
    ,o.resiloczonecd -- 
    ,o.untloczonecd -- 
    ,o.resiloczone -- 
    ,o.compphone -- 
    ,o.isriskcust -- 
    ,o.atachcomm -- 
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
from ${iol_schema}.icms_fkd_iqp_loan_app_bk o
    left join ${iol_schema}.icms_fkd_iqp_loan_app_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fkd_iqp_loan_app_cl d
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
--truncate table ${iol_schema}.icms_fkd_iqp_loan_app;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fkd_iqp_loan_app') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fkd_iqp_loan_app drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fkd_iqp_loan_app add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fkd_iqp_loan_app exchange partition p_${batch_date} with table ${iol_schema}.icms_fkd_iqp_loan_app_cl;
alter table ${iol_schema}.icms_fkd_iqp_loan_app exchange partition p_20991231 with table ${iol_schema}.icms_fkd_iqp_loan_app_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fkd_iqp_loan_app to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fkd_iqp_loan_app_op purge;
drop table ${iol_schema}.icms_fkd_iqp_loan_app_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fkd_iqp_loan_app_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fkd_iqp_loan_app',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
