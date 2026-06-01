/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_iqp_loan_app(
    serialno varchar2(32) -- 业务流水号
    ,prdcode varchar2(32) -- 产品编号
    ,prdname varchar2(200) -- 产品名称
    ,ctrlbranch varchar2(200) -- 所属分行
    ,appchannel varchar2(20) -- 接入渠道
    ,channelno varchar2(100) -- 渠道号
    ,applyno varchar2(32) -- 信贷申请流水号
    ,appadvice varchar2(1000) -- 审批意见
    ,appconclusion varchar2(20) -- 审批结论
    ,certtype varchar2(4) -- 主借人证件类型
    ,certno varchar2(20) -- 主借人证件编号
    ,gender varchar2(5) -- 性别
    ,issauthority varchar2(60) -- 签发机关
    ,isscountry varchar2(30) -- 签发国家
    ,issdate date -- 签发日期
    ,expirydate date -- 到期日期
    ,bankind varchar2(1) -- 本行员工标志
    ,hashouseind varchar2(1) -- 除本次抵押房产外，是否有其他住房
    ,housecount number(2,0) -- 房产数量
    ,paysourcen varchar2(10) -- 还款来源
    ,partnercoownerind varchar2(10) -- 配偶共有人标志
    ,partnerrelind varchar2(10) -- 配偶关联人标志
    ,marriagedate date -- 婚姻登记日期
    ,businesstype varchar2(10) -- 经营类型
    ,merchantname varchar2(80) -- 商户名称
    ,businessaddrtype varchar2(10) -- 经营场所类型
    ,businessaddr varchar2(255) -- 经营场所
    ,bsoptname varchar2(200) -- 经营者
    ,actualcontroler varchar2(100) -- 实际控制人
    ,businessscope varchar2(200) -- 经营范围
    ,enterprisename varchar2(80) -- 企业名称
    ,unifysocialcreditnum varchar2(100) -- 统一社会信用编号
    ,orginstitudecode varchar2(50) -- 组织机构代码
    ,entloanaccount varchar2(50) -- 企业贷款卡/中征码
    ,entlegalpersonname varchar2(100) -- 企业法人姓名
    ,entlegalpersonidno varchar2(20) -- 企业法人身份证号
    ,borroweridentity varchar2(2) -- 借款人身份
    ,registaddress varchar2(200) -- 注册地址
    ,registassets number(24,2) -- 注册资本
    ,validitedate date -- 有效期
    ,registdate date -- 注册日期
    ,cptype varchar2(5) -- 企业类型
    ,bsstartdate date -- 营业起始日
    ,bsenddate date -- 营业到期日
    ,practyears varchar2(2) -- 法人从业年限
    ,licensename varchar2(50) -- 许可证名称
    ,licenseno varchar2(50) -- 许可证编号
    ,companyyear number(10,0) -- 经营年限
    ,userbusinesssum number(24,6) -- 客户经理意见金额
    ,userlimitterm varchar2(10) -- 客户经理意见期限
    ,recommendtype varchar2(10) -- 推荐类型
    ,recommendagency varchar2(100) -- 推荐中介名称
    ,creditamt number(24,6) -- 授信金额
    ,inputtime varchar2(20) -- 终审申请时间
    ,autoscore varchar2(10) -- 评分分值
    ,iscollectcredit varchar2(20) -- 征信查询情况
    ,informflag varchar2(2) -- 终审通知成功与否
    ,loaninformflag varchar2(2) -- 放款通知成功与否
    ,failreason varchar2(4000) -- 拒绝原因
    ,finalapplyamount number(24,6) -- 终审审批额度(元)
    ,cusid varchar2(32) -- 客户号
    ,detailaddr varchar2(255) -- 详细地址
    ,worknature varchar2(20) -- 工作性质
    ,inputbrid varchar2(20) -- 管理机构
    ,isbankrel varchar2(2) -- 是否我行关联人
    ,phone varchar2(35) -- 手机号
    ,apprendtime varchar2(20) -- 审批结束时间
    ,isemoji varchar2(2) -- 是否有影像文件
    ,inputid varchar2(20) -- 分行客户经理号（普惠金融专用）
    ,isoverduemain varchar2(1) -- 主借款人是否触碰征信逾期金额过大
    ,isoverduemaincp varchar2(1) -- 主借款人配偶是否触碰征信逾期金额过大
    ,seqid varchar2(32) -- 请求流水（用于庙算接口查询）
    ,comno varchar2(20) -- 地推公司编号
    ,comname varchar2(200) -- 地推公司名称
    ,checkersuggest varchar2(1000) -- 下户核验意见
    ,inspsuggest varchar2(1000) -- 质检岗意见
    ,inspsum number(24,6) -- 质检岗建议金额
    ,insplimitterm varchar2(10) -- 质检岗建议期限
    ,interviewsuggest varchar2(1000) -- 面谈意见
    ,ispreflag varchar2(2) -- 是否预终审
    ,contno varchar2(32) -- 合同编号
    ,guarantyid varchar2(32) -- 押品编号
    ,conttype varchar2(1) -- 合同类型（1:单笔合同2：额度合同）
    ,isonline varchar2(1) -- 是否线上（1-是2否）
    ,domicileaddr varchar2(200) -- 户籍所在地（户籍地址）
    ,lmtserno varchar2(32) -- 额度合同编号
    ,originalloan varchar2(1) -- 是否有原贷款
    ,isotherbankmtg varchar2(1) -- 是否他行在押房产
    ,orgmtgbank varchar2(200) -- 原抵押银行
    ,orgmtgbankbranch varchar2(200) -- 原抵押银行分行名称
    ,orghouseloanbalance number(24,6) -- 在押房产贷款余额（元）
    ,isddjfloan varchar2(5) -- 大道是否放款
    ,canceltype varchar2(5) -- 取消类型（1取消订单，2取消放款）
    ,loaninterdt varchar2(20) -- 同贷交互时间
    ,oloaniscircle varchar2(2) -- 原贷款是否循环
    ,isbankorg varchar2(2) -- 是否银行机构
    ,isonloanbank varchar2(100) -- 在途贷款银行
    ,obankloanamt number(24,6) -- 原银行房贷贷款金额
    ,obankloansurnotbal number(24,6) -- 原银行房贷剩余未还本金
    ,oloansurterm number(24,2) -- 原贷款剩余期限
    ,enterpriseyearincome number(24,2) -- 企业年收入
    ,orghouseloantype varchar2(2) -- 原房产贷款类型
    ,otherdirection varchar2(100) -- 其他原房产贷款类型说明
    ,displaceoperatloanbal number(24,2) -- 拟置换经营性贷款余额
    ,taxbureauserno varchar2(32) -- 税局授权流水
    ,taxrelatedtype varchar2(2) -- 涉税类型
    ,taxpayeridentino varchar2(32) -- 纳税人识别号
    ,employmentsituation varchar2(2) -- 就业状况
    ,annualtaxrevenue number(24,2) -- 客户纳税年收入
    ,ddjfapprovestatus varchar2(5) -- 大道审批结果
    ,respstatus varchar2(2) -- 存证返回状态（0为失败，1为成功）
    ,agriflg varchar2(1) -- 是否农户
    ,businessesflag varchar2(1) -- 客户性质
    ,invtstkperc number(10,4) -- 借款人持股比例
    ,coboinvtstkperc number(10,4) -- 共借人持股比例
    ,onbranchbank varchar2(100) -- 所在分行
    ,risklevel varchar2(5) -- 风险等级
    ,lot number(24,2) -- 份额
    ,netvalue number(24,2) -- 净值
    ,principalamt number(24,2) -- 本金
    ,loanstartdate varchar2(20) -- 贷款起始日
    ,loanenddate date -- 贷款到期日
    ,warninginfo varchar2(4000) -- 预警信息
    ,loantype varchar2(2) -- 贷款类型（STD_KD_LOAN_TYPE）
    ,lmtloanappno varchar2(32) -- 额度合同信贷申请流水号
    ,relationname varchar2(100) -- 直系亲属姓名
    ,relationphone varchar2(20) -- 直系亲属联系电话
    ,urgentcontactname varchar2(100) -- 紧急联系人姓名
    ,urgentcontactphone varchar2(20) -- 紧急联系人电话
    ,socialmon varchar2(5) -- 社保连续缴存月数
    ,accumulfundmon varchar2(5) -- 公积金连续缴存月数
    ,monincome number(24,2) -- 税后月收入
    ,monthlyrepay number(24,2) -- 月还款金额
    ,ishouse varchar2(2) -- 是否有房
    ,preloanterm varchar2(4) -- 兴车贷-贷款期限
    ,isborrowbook varchar2(4) -- 同贷书是否生成
    ,docoutputloca varchar2(200) -- 同贷书地址
    ,sysid varchar2(10) -- 系统来源
    ,qryopertp varchar2(2) -- 查询操作申请类型
    ,authotype varchar2(2) -- 授权方式
    ,biometrics varchar2(2) -- 生物识别技术
    ,authotime varchar2(20) -- 授权时间
    ,authostrdate date -- 授权开始时间
    ,authoenddate date -- 授权结束时间
    ,recacct varchar2(32) -- 收款账户(经销商)
    ,recacctbankname varchar2(100) -- 开户行(经销商)
    ,faceidentifiscore varchar2(10) -- 人脸识别照与证件照比对分数值
    ,loanamt number(24,2) -- 客户贷款金额
    ,obillno varchar2(30) -- 原借据号
    ,ocontno varchar2(30) -- 原合同号
    ,oloanamount number(24,2) -- 原借据金额
    ,oloanbalance number(24,2) -- 原借据余额
    ,renewalstartdate date -- 续贷起始日期
    ,renewalenddate date -- 续贷到期日期
    ,iswhite varchar2(2) -- 是否白户
    ,whitecusid varchar2(32) -- 白名单客户号
    ,whitecerttype varchar2(5) -- 白名单客户证件类型
    ,whitecertcode varchar2(60) -- 白名单客户证件号码
    ,mainbusiness varchar2(5) -- 主营业务
    ,deviceamount varchar2(16) -- 设备数量（定型机）
    ,devicetotalprice number(24,2) -- 企业设备资产总值
    ,fixedfundloanbalance number(24,2) -- 企业固定资产贷款余额（元）
    ,deviceloanbalance number(24,2) -- 企业设备融资租赁贷款余额（元）
    ,workingloanbalance number(24,2) -- 企业流动资金贷款余额（元）
    ,relationcertcode varchar2(20) -- 直系亲属证件号
    ,ownerflag varchar2(2) -- 借款人是否实控人
    ,limitloanterm varchar2(4) -- 额度合同申请期限
    ,ctrlorg varchar2(20) -- 所属机构
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,inputdate date -- 终审申请日期
    ,approvestatus varchar2(20) -- 终审审批状态
    ,manualapproval varchar2(1) -- 是否人工审批标识
    ,taxflg varchar2(2) -- 是否涉税：YesNo
    ,applyamt number(20,2) -- 申请金额
    ,blankcollateral varchar2(2) -- 抵押物毛坯状态
    ,fundlegal varchar2(2) -- 本次质押标的的资金来源是否合法合规
    ,iszdwhile varchar2(2) -- 是否智贷白名单
    ,managerialsetupamt varchar2(2) -- 经营机构推荐贷款额度
    ,natureland varchar2(2) -- 土地性质
    ,naturelandexplain varchar2(300) -- 土地性质其他说明
    ,natureregistered varchar2(10) -- 户籍性质
    ,ownershipratio varchar2(2) -- 借款人持有本次贷款质物的权属是否为100%
    ,specialconsumer varchar2(2) -- 如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途
    ,specialprofession varchar2(2) -- 借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所
    ,branchmanageopinion varchar2(64) -- 分行零售信贷负责人意见
    ,enterprisecerttype varchar2(10) -- 企业身份标识类型
    ,enterprisecertid varchar2(32) -- 企业身份标识号码
    ,iscrossregionrun varchar2(2) -- 是否跨区域经营
    ,wisdomloanmode varchar2(2) -- 华兴智贷模式
    ,highestcreditorrightamt number(24,6) -- 最高债权数额
    ,cuscreditscorelevel varchar2(2) -- 客户信用分数等级
    ,renewalmodel varchar2(2) -- 续贷模式
    ,selfemplflg varchar2(5) -- 自雇人士标志
    ,salapeopflg varchar2(5) -- 受薪人士标志
    ,bropermshrhratio number(10,4) -- 借款人在经营主体持股比例
    ,csldsocilccode varchar2(50) -- 单位所属统一社会代码
    ,firstpayamt number(24,6) -- 首付款金额
    ,prepapplowncnt varchar2(10) -- 拟申请的产权人人数
    ,prepapplcomperrela varchar2(4) -- 拟申请的产权共有人关系
    ,brwersixmonincome number(24,6) -- 借款人近六个月月均流水收入
    ,brwersixmonfundpayamt number(24,6) -- 借款人近六个月月均公积金缴存金额
    ,brwerfundmonpayamt number(24,6) -- 借款人公积金月缴存额
    ,brwerfunduntpayratio number(24,6) -- 借款人公积金单位缴存比例
    ,brwerfundindvpayratio number(24,6) -- 借款人公积金个人缴存比例
    ,brwerretiage varchar2(10) -- 借款人退休年龄
    ,spousixmonincome number(24,6) -- 配偶近六个月月均流水收入
    ,spousixmonfundpayamt number(24,6) -- 配偶近六个月月均公积金缴存金额
    ,ownhouseqty varchar2(10) -- 已有房产数量
    ,locallmtpurchplcy varchar2(20) -- 当地限购政策
    ,isaddedvalue varchar2(1) -- 否选择附加权益
    ,addedvalue number(24,6) -- 附加贷权益
    ,carinvoice number(24,6) -- 汽车裸车价格发票
    ,isnewcoborrower varchar2(10) -- 是否新增共同借款人
    ,imagecheckno varchar2(60) -- 影像核验流水号
    ,villatype varchar2(50) -- 别墅类型
    ,housetypelocation varchar2(200) -- 户型位置
    ,rowno varchar2(10) -- 联排数
    ,gardenarea number(24,6) -- 花园面积
    ,freearea number(24,6) -- 赠送面积
    ,cardaddr varchar2(200) -- 身份证地址
    ,idenblngprovcity varchar2(32) -- 身份证所在地区
    ,roomprice number(24,2) -- 评估价值
    ,yearlyrental number(24,6) -- 租赁年收入（元）
    ,updatedate date -- 更新时间
    ,creditmodel varchar2(2) -- 授信模式：1-额度类业务 2-单笔单批业务
    ,ishavecar varchar2(10) -- 是否有车
    ,licensenumber varchar2(100) -- 车牌号码
    ,drivinglicensedate date -- 行驶证发证日期
    ,resiloczonecd varchar2(20) -- 户籍地址所在地区编码
    ,untloczonecd varchar2(20) -- 单位地址所在地区编码
    ,resiloczone varchar2(400) -- 户籍所在地区
    ,compphone varchar2(30) -- 单位电话
    ,isriskcust varchar2(10) -- 是否风险客户
    ,atachcomm varchar2(1000) -- 补录说明
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_fkd_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_iqp_loan_app is '华兴快贷系列（终审）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ctrlbranch is '所属分行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.appchannel is '接入渠道';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.channelno is '渠道号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.appadvice is '审批意见';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.appconclusion is '审批结论';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.certtype is '主借人证件类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.certno is '主借人证件编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.gender is '性别';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.issauthority is '签发机关';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isscountry is '签发国家';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.issdate is '签发日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.expirydate is '到期日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.bankind is '本行员工标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.hashouseind is '除本次抵押房产外，是否有其他住房';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.housecount is '房产数量';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.paysourcen is '还款来源';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.partnercoownerind is '配偶共有人标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.partnerrelind is '配偶关联人标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.marriagedate is '婚姻登记日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.businesstype is '经营类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.merchantname is '商户名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.businessaddrtype is '经营场所类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.businessaddr is '经营场所';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.bsoptname is '经营者';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.actualcontroler is '实际控制人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.businessscope is '经营范围';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.unifysocialcreditnum is '统一社会信用编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.orginstitudecode is '组织机构代码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.entloanaccount is '企业贷款卡/中征码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.entlegalpersonname is '企业法人姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.entlegalpersonidno is '企业法人身份证号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.borroweridentity is '借款人身份';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.registaddress is '注册地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.registassets is '注册资本';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.validitedate is '有效期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.registdate is '注册日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.cptype is '企业类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.bsstartdate is '营业起始日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.bsenddate is '营业到期日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.practyears is '法人从业年限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.licensename is '许可证名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.licenseno is '许可证编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.companyyear is '经营年限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.userbusinesssum is '客户经理意见金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.userlimitterm is '客户经理意见期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.recommendtype is '推荐类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.recommendagency is '推荐中介名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.creditamt is '授信金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inputtime is '终审申请时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.autoscore is '评分分值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.iscollectcredit is '征信查询情况';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.informflag is '终审通知成功与否';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loaninformflag is '放款通知成功与否';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.finalapplyamount is '终审审批额度(元)';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.cusid is '客户号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.detailaddr is '详细地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.worknature is '工作性质';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inputbrid is '管理机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isbankrel is '是否我行关联人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.phone is '手机号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.apprendtime is '审批结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isemoji is '是否有影像文件';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inputid is '分行客户经理号（普惠金融专用）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isoverduemain is '主借款人是否触碰征信逾期金额过大';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isoverduemaincp is '主借款人配偶是否触碰征信逾期金额过大';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.seqid is '请求流水（用于庙算接口查询）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.comno is '地推公司编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.comname is '地推公司名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.checkersuggest is '下户核验意见';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inspsuggest is '质检岗意见';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inspsum is '质检岗建议金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.insplimitterm is '质检岗建议期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.interviewsuggest is '面谈意见';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ispreflag is '是否预终审';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.contno is '合同编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.guarantyid is '押品编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.conttype is '合同类型（1:单笔合同2：额度合同）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isonline is '是否线上（1-是2否）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.domicileaddr is '户籍所在地（户籍地址）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.lmtserno is '额度合同编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.originalloan is '是否有原贷款';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isotherbankmtg is '是否他行在押房产';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.orgmtgbank is '原抵押银行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.orgmtgbankbranch is '原抵押银行分行名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.orghouseloanbalance is '在押房产贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isddjfloan is '大道是否放款';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.canceltype is '取消类型（1取消订单，2取消放款）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loaninterdt is '同贷交互时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.oloaniscircle is '原贷款是否循环';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isbankorg is '是否银行机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isonloanbank is '在途贷款银行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.obankloanamt is '原银行房贷贷款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.obankloansurnotbal is '原银行房贷剩余未还本金';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.oloansurterm is '原贷款剩余期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.enterpriseyearincome is '企业年收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.orghouseloantype is '原房产贷款类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.otherdirection is '其他原房产贷款类型说明';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.displaceoperatloanbal is '拟置换经营性贷款余额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.taxbureauserno is '税局授权流水';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.taxrelatedtype is '涉税类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.taxpayeridentino is '纳税人识别号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.employmentsituation is '就业状况';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.annualtaxrevenue is '客户纳税年收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ddjfapprovestatus is '大道审批结果';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.respstatus is '存证返回状态（0为失败，1为成功）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.agriflg is '是否农户';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.businessesflag is '客户性质';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.invtstkperc is '借款人持股比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.coboinvtstkperc is '共借人持股比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.onbranchbank is '所在分行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.risklevel is '风险等级';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.lot is '份额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.netvalue is '净值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.principalamt is '本金';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loanstartdate is '贷款起始日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loanenddate is '贷款到期日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loantype is '贷款类型（STD_KD_LOAN_TYPE）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.lmtloanappno is '额度合同信贷申请流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.relationname is '直系亲属姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.relationphone is '直系亲属联系电话';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.urgentcontactname is '紧急联系人姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.urgentcontactphone is '紧急联系人电话';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.socialmon is '社保连续缴存月数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.accumulfundmon is '公积金连续缴存月数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.monincome is '税后月收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.monthlyrepay is '月还款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ishouse is '是否有房';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.preloanterm is '兴车贷-贷款期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isborrowbook is '同贷书是否生成';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.docoutputloca is '同贷书地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.sysid is '系统来源';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.qryopertp is '查询操作申请类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.authotype is '授权方式';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.authotime is '授权时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.recacct is '收款账户(经销商)';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.recacctbankname is '开户行(经销商)';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.faceidentifiscore is '人脸识别照与证件照比对分数值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.loanamt is '客户贷款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.obillno is '原借据号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ocontno is '原合同号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.oloanamount is '原借据金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.oloanbalance is '原借据余额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.renewalstartdate is '续贷起始日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.renewalenddate is '续贷到期日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.iswhite is '是否白户';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.whitecusid is '白名单客户号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.whitecerttype is '白名单客户证件类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.whitecertcode is '白名单客户证件号码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.mainbusiness is '主营业务';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.deviceamount is '设备数量（定型机）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.devicetotalprice is '企业设备资产总值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.fixedfundloanbalance is '企业固定资产贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.deviceloanbalance is '企业设备融资租赁贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.workingloanbalance is '企业流动资金贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.relationcertcode is '直系亲属证件号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ownerflag is '借款人是否实控人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.limitloanterm is '额度合同申请期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ctrlorg is '所属机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.inputdate is '终审申请日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.approvestatus is '终审审批状态';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.manualapproval is '是否人工审批标识';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.taxflg is '是否涉税：YesNo';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.applyamt is '申请金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.blankcollateral is '抵押物毛坯状态';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.fundlegal is '本次质押标的的资金来源是否合法合规';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.iszdwhile is '是否智贷白名单';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.managerialsetupamt is '经营机构推荐贷款额度';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.natureland is '土地性质';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.naturelandexplain is '土地性质其他说明';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.natureregistered is '户籍性质';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ownershipratio is '借款人持有本次贷款质物的权属是否为100%';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.specialconsumer is '如贷款用途为消费时，是否用于购车、购车位、装修、婚庆、进修/培训、留学（非本人）、医疗保健/美容、旅游、购耐用消费品及其他合理、合规的消费用途';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.specialprofession is '借款人工作单位是否为武警、特警、部队、法院、仲裁、律师、监狱、看守所';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.branchmanageopinion is '分行零售信贷负责人意见';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.enterprisecerttype is '企业身份标识类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.enterprisecertid is '企业身份标识号码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.iscrossregionrun is '是否跨区域经营';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.wisdomloanmode is '华兴智贷模式';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.highestcreditorrightamt is '最高债权数额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.cuscreditscorelevel is '客户信用分数等级';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.renewalmodel is '续贷模式';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.selfemplflg is '自雇人士标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.salapeopflg is '受薪人士标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.bropermshrhratio is '借款人在经营主体持股比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.csldsocilccode is '单位所属统一社会代码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.firstpayamt is '首付款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.prepapplowncnt is '拟申请的产权人人数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.prepapplcomperrela is '拟申请的产权共有人关系';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwersixmonincome is '借款人近六个月月均流水收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwersixmonfundpayamt is '借款人近六个月月均公积金缴存金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwerfundmonpayamt is '借款人公积金月缴存额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwerfunduntpayratio is '借款人公积金单位缴存比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwerfundindvpayratio is '借款人公积金个人缴存比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.brwerretiage is '借款人退休年龄';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.spousixmonincome is '配偶近六个月月均流水收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.spousixmonfundpayamt is '配偶近六个月月均公积金缴存金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ownhouseqty is '已有房产数量';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.locallmtpurchplcy is '当地限购政策';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isaddedvalue is '否选择附加权益';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.addedvalue is '附加贷权益';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.carinvoice is '汽车裸车价格发票';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isnewcoborrower is '是否新增共同借款人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.imagecheckno is '影像核验流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.villatype is '别墅类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.housetypelocation is '户型位置';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.rowno is '联排数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.gardenarea is '花园面积';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.freearea is '赠送面积';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.cardaddr is '身份证地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.idenblngprovcity is '身份证所在地区';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.roomprice is '评估价值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.yearlyrental is '租赁年收入（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.updatedate is '更新时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.creditmodel is '授信模式：1-额度类业务 2-单笔单批业务';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.ishavecar is '是否有车';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.licensenumber is '车牌号码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.drivinglicensedate is '行驶证发证日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.resiloczonecd is '户籍地址所在地区编码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.untloczonecd is '单位地址所在地区编码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.resiloczone is '户籍所在地区';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.compphone is '单位电话';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.isriskcust is '是否风险客户';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.atachcomm is '补录说明';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
