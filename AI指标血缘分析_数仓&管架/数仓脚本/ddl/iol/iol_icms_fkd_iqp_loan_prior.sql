/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_fkd_iqp_loan_prior
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_fkd_iqp_loan_prior
whenever sqlerror continue none;
drop table ${iol_schema}.icms_fkd_iqp_loan_prior purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fkd_iqp_loan_prior(
    serialno varchar2(32) -- 业务流水号
    ,iscollectcredit varchar2(20) -- 征信查询情况
    ,originalloan varchar2(1) -- 是否有原贷款
    ,workingloanbalance number(24,2) -- 企业流动资金贷款余额（元）
    ,projectname varchar2(200) -- 小区名称
    ,isbankorg varchar2(2) -- 是否银行机构
    ,approvestatus varchar2(20) -- 初审审批状态
    ,inputid varchar2(20) -- 推荐人
    ,displaceoperatloanbal number(24,2) -- 拟置换经营性贷款余额
    ,lot number(24,2) -- 份额
    ,nationality varchar2(3) -- 国籍
    ,prdname varchar2(80) -- 产品名称
    ,enterpriseyearincome number(24,2) -- 经营主体年销售收
    ,customgroupcode varchar2(3) -- 客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士
    ,individexpdt date -- 证件到期日
    ,orgmtgbankbranch varchar2(200) -- 原抵押银行分行名称
    ,appchannel varchar2(20) -- 接入渠道
    ,sysid varchar2(10) -- 系统来源
    ,deviceamount varchar2(16) -- 设备数量（定型机）
    ,certtype varchar2(4) -- 主借人证件类型
    ,autoscore varchar2(10) -- 评分分值
    ,isotherbankmtg varchar2(1) -- 是否他行在押房产
    ,qryopertp varchar2(2) -- 查询操作申请类型
    ,isgetcuscode varchar2(2) -- 是否开户成功
    ,comname varchar2(200) -- 地推公司名称
    ,msflag varchar2(2) -- 庙算是否通过
    ,indivocc varchar2(5) -- 职业
    ,onbranchbank varchar2(100) -- 所在分行
    ,relationphone varchar2(20) -- 直系亲属联系电话
    ,taxapprovestatus varchar2(20) -- 涉税审批状态
    ,isbankrel varchar2(2) -- 是否我行关联人
    ,seqid varchar2(32) -- 请求流水（用于庙算接口查询）
    ,orghouseloanbalance number(24,2) -- 在押房产贷款余额（元）
    ,obankloansurnotbal number(24,2) -- 原银行房贷剩余未还本金
    ,accountbank varchar2(100) -- 绑定银行卡开户行
    ,accountname varchar2(200) -- 绑定银行卡户名
    ,authostrdate date -- 授权开始时间
    ,respstatus varchar2(2) -- 存证返回状态（0为失败，1为成功）
    ,recacctbankname varchar2(100) -- 开户行(经销商)
    ,indivrsdaddr varchar2(200) -- 居住地址
    ,ischeckinspect number(22,0) -- 联网核查状态
    ,phone varchar2(35) -- 手机号
    ,informflag varchar2(2) -- 初审通知成功与否
    ,failreason varchar2(4000) -- 拒绝原因
    ,otherdirection varchar2(100) -- 其他原房产贷款类型说明
    ,cityname varchar2(50) -- 所在城市
    ,taxpayeridentino varchar2(32) -- 纳税人识别号
    ,monincome number(24,2) -- 税后月收入
    ,biometrics varchar2(2) -- 生物识别技术
    ,custname varchar2(80) -- 客户姓名
    ,cltrtyp varchar2(10) -- 押品类型
    ,mainbusiness varchar2(5) -- 主营业务
    ,cltrname varchar2(100) -- 押品名称
    ,whitecertcode varchar2(60) -- 白名单客户证件号码
    ,limitloanterm varchar2(4) -- 额度合同申请期限
    ,isonloanbank varchar2(100) -- 在途贷款银行
    ,taxbureauserno varchar2(32) -- 税局授权流水
    ,preloanterm varchar2(4) -- 兴车贷-贷款期限
    ,risklevel varchar2(5) -- 风险等级
    ,warninginfo varchar2(4000) -- 预警信息
    ,whitecusid varchar2(32) -- 白名单客户号
    ,deviceloanbalance number(24,2) -- 企业设备融资租赁贷款余额（元）
    ,relationcertcode varchar2(20) -- 直系亲属证件号
    ,repayway varchar2(2) -- 还款方式
    ,accumulfundmon varchar2(5) -- 公积金连续缴存月数
    ,roomprice number(24,2) -- 评估价值
    ,applyno varchar2(32) -- 信贷申请流水号
    ,inputtime varchar2(20) -- 初审申请时间
    ,indivsex varchar2(1) -- 性别
    ,cuttomgroupname varchar2(50) -- 客群分类名称
    ,devicetotalprice number(24,2) -- 企业设备资产总值
    ,finabrid varchar2(20) -- 账务机构
    ,migtflag varchar2(80) -- 
    ,fixedfundloanbalance number(24,2) -- 企业固定资产贷款余额（元）
    ,channelno varchar2(20) -- 渠道号
    ,comno varchar2(20) -- 地推公司编号
    ,recacct varchar2(32) -- 收款账户(经销商)
    ,accountnumber varchar2(50) -- 绑定银行卡账号
    ,cfmseqnum varchar2(32) -- 智贷押品确认流水号
    ,ownerflag varchar2(2) -- 借款人是否实控人
    ,fourelementsverificationresult varchar2(100) -- 绑定银行卡四要素验证结果
    ,urgentcontactphone varchar2(20) -- 紧急联系人电话
    ,urgentcontactname varchar2(100) -- 紧急联系人姓名
    ,ishouse varchar2(2) -- 是否有房
    ,prdcode varchar2(32) -- 产品编号
    ,cusid varchar2(32) -- 客户号
    ,roomsize number(24,2) -- 房屋面积
    ,taxrelatedtype varchar2(2) -- 涉税类型
    ,propertytype varchar2(20) -- 房产类型-STD_FKD_FCLX
    ,istaxrela varchar2(2) -- 是否跑涉税风控
    ,relationname varchar2(100) -- 直系亲属姓名
    ,inputdate date -- 初审申请日期
    ,faceidentifiscore varchar2(10) -- 人脸识别照与证件照比对分数值
    ,ctrlbranch varchar2(20) -- 所属分行
    ,inputbrid varchar2(20) -- 管理机构
    ,netvalue number(24,2) -- 净值
    ,invtstkperc number(10,4) -- 借款人持股比例
    ,coopno varchar2(50) -- 合作方客户经理工号
    ,oloaniscircle varchar2(2) -- 原贷款是否循环
    ,principalamt number(24,2) -- 本金
    ,purpors varchar2(10) -- 贷款用途
    ,certno varchar2(20) -- 主借人证件编号
    ,isemoji varchar2(2) -- 是否有影像文件
    ,orghouseloantype varchar2(2) -- 原房产贷款类型
    ,authotime varchar2(20) -- 授权时间
    ,creditamt number(24,6) -- 授信金额
    ,isoverduemain varchar2(1) -- 主借款人是否触碰征信逾期金额过大
    ,detailaddr varchar2(200) -- 房产地址
    ,areacode varchar2(20) -- 区域编号
    ,grtduedate date -- 押品到期日
    ,socialmon varchar2(5) -- 社保连续缴存月数
    ,authoenddate date -- 授权结束时间
    ,monthlyrepay number(24,2) -- 月还款金额
    ,whitecerttype varchar2(5) -- 白名单客户证件类型
    ,authotype varchar2(2) -- 授权方式
    ,orgmtgbank varchar2(200) -- 原抵押银行
    ,loanamt number(24,2) -- 客户贷款金额
    ,obankloanamt number(24,2) -- 原银行房贷贷款金额
    ,indivoccremarks varchar2(200) -- 职业备注信息
    ,ctrlorg varchar2(20) -- 所属机构
    ,apprendtime varchar2(20) -- 审批结束时间
    ,cityareacode varchar2(20) -- 城市编码
    ,mscreditamt number(24,6) -- 庙算初审额度
    ,oloansurterm number(24,2) -- 原贷款剩余期限
    ,manualapproval varchar2(1) -- 是否人工审批标识
    ,taxflg varchar2(2) -- 是否涉税：YesNo
    ,pauperroomprice number(24,2) -- 世联下户评估价值
    ,bkprice number(20,2) -- 贝壳网房产评估价值
    ,certidstartdate date -- 证件起始日
    ,iscrossregionrun varchar2(2) -- 
    ,wisdomloanmode varchar2(2) -- 
    ,cuscreditscorelevel varchar2(2) -- 
    ,matchpurchhousecondition varchar2(5) -- 
    ,housetxnprice number(24,6) -- 
    ,isaddedvalue varchar2(1) -- 
    ,addedvalue number(24,6) -- 
    ,carinvoice number(24,6) -- 
    ,isnewcoborrower varchar2(10) -- 
    ,villatype varchar2(50) -- 
    ,housetypelocation varchar2(200) -- 
    ,rowno varchar2(10) -- 
    ,gardenarea number(24,6) -- 
    ,freearea number(24,6) -- 
    ,identityexpire date -- 
    ,enttype varchar2(10) -- 
    ,enterprisename varchar2(200) -- 
    ,entidttp varchar2(10) -- 
    ,entidtno varchar2(32) -- 
    ,entaddress varchar2(200) -- 
    ,enttermduedate date -- 
    ,cobsratio number(10,4) -- 
    ,updatedate date -- 
    ,istaxsuccessgs varchar2(10) -- 
    ,ishavecar varchar2(10) -- 
    ,licensenumber varchar2(100) -- 
    ,drivinglicensedate date -- 
    ,businessserialno varchar2(100) -- 
    ,resiloczonecd varchar2(20) -- 
    ,untloczonecd varchar2(20) -- 
    ,resiloczone varchar2(400) -- 
    ,compphone varchar2(30) -- 
    ,isriskcust varchar2(10) -- 
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
grant select on ${iol_schema}.icms_fkd_iqp_loan_prior to ${iml_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_prior to ${icl_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_prior to ${idl_schema};
grant select on ${iol_schema}.icms_fkd_iqp_loan_prior to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_fkd_iqp_loan_prior is '华兴快贷系列初审';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.serialno is '业务流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.iscollectcredit is '征信查询情况';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.originalloan is '是否有原贷款';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.workingloanbalance is '企业流动资金贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.projectname is '小区名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isbankorg is '是否银行机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.approvestatus is '初审审批状态';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.inputid is '推荐人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.displaceoperatloanbal is '拟置换经营性贷款余额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.lot is '份额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.nationality is '国籍';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.prdname is '产品名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.enterpriseyearincome is '经营主体年销售收';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.customgroupcode is '客群分类代码A-优质客户B-有房/放贷C-自雇人士D-授薪人士';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.individexpdt is '证件到期日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.orgmtgbankbranch is '原抵押银行分行名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.appchannel is '接入渠道';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.sysid is '系统来源';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.deviceamount is '设备数量（定型机）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.certtype is '主借人证件类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.autoscore is '评分分值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isotherbankmtg is '是否他行在押房产';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.qryopertp is '查询操作申请类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isgetcuscode is '是否开户成功';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.comname is '地推公司名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.msflag is '庙算是否通过';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.indivocc is '职业';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.onbranchbank is '所在分行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.relationphone is '直系亲属联系电话';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.taxapprovestatus is '涉税审批状态';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isbankrel is '是否我行关联人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.seqid is '请求流水（用于庙算接口查询）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.orghouseloanbalance is '在押房产贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.obankloansurnotbal is '原银行房贷剩余未还本金';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.accountbank is '绑定银行卡开户行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.accountname is '绑定银行卡户名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.respstatus is '存证返回状态（0为失败，1为成功）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.recacctbankname is '开户行(经销商)';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.indivrsdaddr is '居住地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ischeckinspect is '联网核查状态';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.phone is '手机号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.informflag is '初审通知成功与否';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.otherdirection is '其他原房产贷款类型说明';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cityname is '所在城市';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.taxpayeridentino is '纳税人识别号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.monincome is '税后月收入';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.custname is '客户姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cltrtyp is '押品类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.mainbusiness is '主营业务';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cltrname is '押品名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.whitecertcode is '白名单客户证件号码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.limitloanterm is '额度合同申请期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isonloanbank is '在途贷款银行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.taxbureauserno is '税局授权流水';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.preloanterm is '兴车贷-贷款期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.risklevel is '风险等级';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.whitecusid is '白名单客户号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.deviceloanbalance is '企业设备融资租赁贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.relationcertcode is '直系亲属证件号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.repayway is '还款方式';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.accumulfundmon is '公积金连续缴存月数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.roomprice is '评估价值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.inputtime is '初审申请时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.indivsex is '性别';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cuttomgroupname is '客群分类名称';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.devicetotalprice is '企业设备资产总值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.finabrid is '账务机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.migtflag is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.fixedfundloanbalance is '企业固定资产贷款余额（元）';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.channelno is '渠道号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.comno is '地推公司编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.recacct is '收款账户(经销商)';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.accountnumber is '绑定银行卡账号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cfmseqnum is '智贷押品确认流水号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ownerflag is '借款人是否实控人';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.fourelementsverificationresult is '绑定银行卡四要素验证结果';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.urgentcontactphone is '紧急联系人电话';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.urgentcontactname is '紧急联系人姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ishouse is '是否有房';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.prdcode is '产品编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cusid is '客户号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.roomsize is '房屋面积';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.taxrelatedtype is '涉税类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.propertytype is '房产类型-STD_FKD_FCLX';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.istaxrela is '是否跑涉税风控';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.relationname is '直系亲属姓名';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.inputdate is '初审申请日期';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.faceidentifiscore is '人脸识别照与证件照比对分数值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ctrlbranch is '所属分行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.inputbrid is '管理机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.netvalue is '净值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.invtstkperc is '借款人持股比例';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.coopno is '合作方客户经理工号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.oloaniscircle is '原贷款是否循环';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.principalamt is '本金';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.purpors is '贷款用途';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.certno is '主借人证件编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isemoji is '是否有影像文件';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.orghouseloantype is '原房产贷款类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.authotime is '授权时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.creditamt is '授信金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isoverduemain is '主借款人是否触碰征信逾期金额过大';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.detailaddr is '房产地址';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.areacode is '区域编号';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.grtduedate is '押品到期日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.socialmon is '社保连续缴存月数';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.monthlyrepay is '月还款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.whitecerttype is '白名单客户证件类型';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.authotype is '授权方式';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.orgmtgbank is '原抵押银行';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.loanamt is '客户贷款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.obankloanamt is '原银行房贷贷款金额';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.indivoccremarks is '职业备注信息';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ctrlorg is '所属机构';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.apprendtime is '审批结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cityareacode is '城市编码';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.mscreditamt is '庙算初审额度';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.oloansurterm is '原贷款剩余期限';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.manualapproval is '是否人工审批标识';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.taxflg is '是否涉税：YesNo';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.pauperroomprice is '世联下户评估价值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.bkprice is '贝壳网房产评估价值';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.certidstartdate is '证件起始日';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.iscrossregionrun is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.wisdomloanmode is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cuscreditscorelevel is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.matchpurchhousecondition is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.housetxnprice is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isaddedvalue is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.addedvalue is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.carinvoice is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isnewcoborrower is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.villatype is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.housetypelocation is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.rowno is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.gardenarea is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.freearea is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.identityexpire is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.enttype is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.enterprisename is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.entidttp is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.entidtno is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.entaddress is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.enttermduedate is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.cobsratio is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.updatedate is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.istaxsuccessgs is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.ishavecar is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.licensenumber is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.drivinglicensedate is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.businessserialno is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.resiloczonecd is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.untloczonecd is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.resiloczone is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.compphone is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.isriskcust is '';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.start_dt is '开始时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.end_dt is '结束时间';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.id_mark is '增删标志';
comment on column ${iol_schema}.icms_fkd_iqp_loan_prior.etl_timestamp is 'ETL处理时间戳';
