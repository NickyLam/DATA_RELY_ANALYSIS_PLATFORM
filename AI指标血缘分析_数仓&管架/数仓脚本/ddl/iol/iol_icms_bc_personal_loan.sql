/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bc_personal_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bc_personal_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bc_personal_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bc_personal_loan(
    serialno varchar2(128) -- 流水号
    ,esaepclassify varchar2(72) -- 节能环保分类
    ,mandatedepositaccounts varchar2(128) -- 委托贷款存款账号
    ,relationship varchar2(16) -- 集团客户可用敞口额度
    ,eaccountno varchar2(30) -- E账户
    ,stallprice number(22,0) -- 车位总价
    ,companyexposuresum number(24,6) -- 公司授信总金额(元)
    ,purpose varchar2(2000) -- 用途
    ,isbankrel number(4,0) -- 是否我行关联方
    ,sellercertid varchar2(18) -- 卖房人证件号码
    ,loanaccountname varchar2(80) -- 入账账户名称
    ,buildingunitprice number(22,0) -- 建筑面积单价
    ,mandaterequirement varchar2(2000) -- 委托条件
    ,isexception varchar2(2) -- 是否例外额度
    ,endaccountname varchar2(64) -- 最终绑定卡卡名
    ,imageapprresult varchar2(5) -- 影像审批结果
    ,isdiscount varchar2(72) -- 是否行内贴息/贴息标识
    ,vehiclecontractno varchar2(128) -- 购车合同号
    ,housingsum number(22,0) -- 房屋套数
    ,renewalflag varchar2(10) -- 合同是否支持续期标识
    ,localstrategicindustry varchar2(800) -- 本地战略性新兴产业
    ,insuranceperiod number(22,0) -- 保险期限保险期限(月)
    ,housingname varchar2(800) -- 楼盘名称
    ,totalrecyleamt number(16,2) -- 累计回收金额
    ,guarantytype varchar2(72) -- 担保类型
    ,guaranteeagreement varchar2(128) -- 相关回购/担保协议书编号
    ,insurancecontractno varchar2(128) -- 保险合同编号
    ,paymentobject varchar2(800) -- 支付对象
    ,relserialno varchar2(32) -- 关联编号
    ,excess number(22,0) -- 免赔率
    ,imagefilepath varchar2(100) -- 影像文件路径
    ,parkingaddress varchar2(2000) -- 购车位详址
    ,groupcustcode varchar2(20) -- 集团客户号
    ,paymentratio number(22,0) -- 首付比例
    ,isopenentsettleaccounts varchar2(4) -- 是否能够开立单位结算账户
    ,isfirstpurchase varchar2(4) -- 是否首次购房
    ,imageflag varchar2(32) -- 影像标识
    ,mandatedepositsum number(24,6) -- 委托存款金额
    ,suitesunitprice number(22,0) -- 套房面积单价
    ,downpayment number(22,0) -- 首付金额
    ,isinsurance varchar2(4) -- 是否购买保险
    ,eaccountname varchar2(60) -- E账户户名
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,businessname varchar2(800) -- 商家/销售商/开发商/建房单位名称
    ,parkingarea number(22,0) -- 购车位面积
    ,feeratio number(10,6) -- 手续费率
    ,housingprice number(22,0) -- 房屋总价
    ,iswhite varchar2(1) -- 借款人与集团关系
    ,purchasecontractid varchar2(128) -- 购房合同号
    ,loanratio number(22,0) -- 贷款成数
    ,businesslicence varchar2(128) -- 营业执照号码
    ,payaccountcertid varchar2(64) -- 绑定身份证号
    ,recordrelativeserialno varchar2(128) -- 关联中介备案编号
    ,telephone varchar2(30) -- 手机号
    ,isbigaccountmode varchar2(3) -- 是否大账户模式
    ,channelno varchar2(20) -- 渠道编号
    ,buildingcompany varchar2(800) -- 建筑单位
    ,housinglevel varchar2(72) -- 房屋等级
    ,startbankno varchar2(20) -- 初始卡开户行
    ,financialbond number(22,0) -- 委放/专项/金融债
    ,insurername varchar2(800) -- 保险公司名称
    ,fitmentprice number(22,0) -- 装修总价
    ,repaymentaccname varchar2(80) -- 还款账户名称
    ,endclearbankno varchar2(50) -- 收款方开户行清算行行号（最终）
    ,presalepermitno varchar2(128) -- 预售许可证编号
    ,extenddays number(22) -- 宽限天数
    ,isonline varchar2(8) -- 是否线上审批
    ,propertyarea number(22,0) -- 所购房产面积
    ,evaluationname varchar2(320) -- 评估机构名称
    ,suitesarea number(22,0) -- 购房面积（套内面积）
    ,payaccounttel varchar2(20) -- 开户手机
    ,evaluationcertid varchar2(18) -- 评估机构证件号码
    ,mandatedepositcurrency varchar2(3) -- 委托存款币种
    ,exposeclassifyresult varchar2(10) -- 风险暴露分类结果
    ,fundsprovided varchar2(2000) -- 资金来源
    ,principalcertid varchar2(18) -- 委托人有效证件号码
    ,endaccountno varchar2(32) -- 最终绑定卡卡号
    ,principalmarriage varchar2(72) -- 委托人婚姻状况
    ,isbusinessguarantee varchar2(4) -- 是否合作机构/开发商/经销商担保
    ,isvendorassumeliability varchar2(4) -- 是否销售商承担回购责任
    ,groupcustname varchar2(200) -- 集团客户名称
    ,housingaddress varchar2(2000) -- 房屋详址
    ,payaccounttype varchar2(10) -- 还款卡类型0-本行卡,1-他行卡
    ,personalbusinessloanstype varchar2(72) -- 个人经营性贷款分类
    ,evaluationcerttype varchar2(128) -- 评估证件类型
    ,discountratio number(22,0) -- 贴息比例
    ,corporgid varchar2(128) -- 法人机构编号
    ,iscompanycustomer varchar2(2) -- 是否公司额度管控
    ,enterprisecode varchar2(128) -- 经销商企业代码
    ,companycustomername varchar2(200) -- 公司客户名称
    ,housingform varchar2(72) -- 房屋形式
    ,paymentbasis varchar2(2000) -- 首付款依据
    ,feesum number(22,0) -- 手续费金额
    ,isgroupcustomer varchar2(2) -- 是否集团客户
    ,isloananytime varchar2(8) -- 是否随借随还
    ,sellername varchar2(800) -- 卖房人名称
    ,businessclass varchar2(72) -- 类别
    ,principalname varchar2(800) -- 委托人名称
    ,creditincrmode varchar2(32) -- 增信模式标志
    ,loandirection varchar2(128) -- 资金投向
    ,insurancevariety varchar2(72) -- 保险品种
    ,buildingarea number(22,0) -- 购房面积（建筑面积）
    ,repaydatetype varchar2(8) -- 还款日确定
    ,feepayment varchar2(72) -- 手续费支付方式
    ,repaymentaccount varchar2(32) -- 还款账号
    ,evaluateprice number(22,0) -- 评估价格
    ,propertyunitprice number(22,0) -- 物管费单价
    ,availexposure number(22,0) -- 集团客户可用敞口额度
    ,endbankno varchar2(20) -- 最终实体卡对应的开户行
    ,companyrelation varchar2(10) -- 借款人与公司关系
    ,propertytype varchar2(72) -- 所购房产类型
    ,endbankname varchar2(64) -- 最终实体卡对应的开户行名称
    ,isjgaccount varchar2(8) -- 是否在我行开立监管账户
    ,vehicletype varchar2(72) -- 车型
    ,startaccountno varchar2(32) -- 初始卡卡号
    ,startclearbankno varchar2(50) -- 收款方开户行清算行行号（最初）
    ,vehicleprice number(22,0) -- 汽车总价
    ,insurance number(22,0) -- 保险金额
    ,wthruselmt varchar2(8) -- 是否使用额度
    ,mandateriskclassify varchar2(72) -- 委托贷款风险分类
    ,propertycertid varchar2(128) -- 房屋权证号
    ,loanaccountno varchar2(32) -- 入账账号
    ,startbankname varchar2(64) -- 初始卡开户行名称
    ,determprice number(22,0) -- 认定价格
    ,paymenttype varchar2(72) -- 支付方式
    ,companycustomerid varchar2(64) -- 公司客户号
    ,propertycontractno varchar2(128) -- 车位配套住房产权号/购房合同号
    ,clientno varchar2(128) -- 委托人编号
    ,startaccountname varchar2(64) -- 初始卡账户名称
    ,commodityamt number(16,2) -- 购买金额
    ,businesscertcode varchar2(32) -- 统一社会信用代码
    ,payway varchar2(2) -- 贷款发放方式(1-一次2-分次)
    ,dealdisputeway varchar2(2) -- 解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)
    ,dealdisputetxt varchar2(200) -- 解决争议方式备注
    ,isforcedeal varchar2(2) -- 是否强制执行公证(1-是2-否)
    ,bigloanpurpose varchar2(8) -- 贷款用途大类
    ,zjkjstatus varchar2(10) -- 致景科技合同激活状态 0-未激活 1-待激活 2-已激活
    ,cartype varchar2(4) -- 车辆类型
    ,greenloanpurpose varchar2(8) -- 绿色贷款用途
    ,accountserialno varchar2(32) -- 关联账户流水号
    ,subgreenconsumeloanpurpose varchar2(8) -- 绿色消费子类
    ,isagriculture varchar2(4) -- 是否涉农
    ,highindustry varchar2(20) -- 高技术产业
    ,economyindustry varchar2(20) -- 数字经济核心产业
    ,intellectualindustry varchar2(20) -- 投向知识产权密集型产业
    ,strategicindustry varchar2(20) -- 
    ,cultureindustry varchar2(20) -- 投向文化及相关产业
    ,isnewcoborrower varchar2(10) -- 是否新增共同借款人
    ,productchannel varchar2(20) -- 产品渠道标识
    ,claimperson varchar2(64) -- 集中办公合同认领人员
    ,isclaim varchar2(4) -- 是否认领
    ,isbelongterm varchar2(2) -- 是否靠档计息
    ,centralizeorgid varchar2(32) -- 登记机构（集中录入人员）
    ,centralizeoperaid varchar2(32) -- 登记所属机构（集中录入人员）
    ,claimdate varchar2(32) -- 集中录入日期
    ,extloanaccountno varchar2(64) -- 行外收款银行卡号
    ,extloanaccountname varchar2(200) -- 行外收款卡户名
    ,recvbankid varchar2(64) -- 收款银行编号
    ,recvbankname varchar2(200) -- 收款银行名称
    ,extrepaymentaccount varchar2(64) -- 行外还款银行卡号
    ,extrepaymentaccname varchar2(200) -- 行外还款卡户名
    ,repaybankid varchar2(64) -- 还款银行编号
    ,repaybankname varchar2(200) -- 还款银行名称
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
grant select on ${iol_schema}.icms_bc_personal_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bc_personal_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bc_personal_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bc_personal_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bc_personal_loan is '合同个人贷款业务附属表';
comment on column ${iol_schema}.icms_bc_personal_loan.serialno is '流水号';
comment on column ${iol_schema}.icms_bc_personal_loan.esaepclassify is '节能环保分类';
comment on column ${iol_schema}.icms_bc_personal_loan.mandatedepositaccounts is '委托贷款存款账号';
comment on column ${iol_schema}.icms_bc_personal_loan.relationship is '集团客户可用敞口额度';
comment on column ${iol_schema}.icms_bc_personal_loan.eaccountno is 'E账户';
comment on column ${iol_schema}.icms_bc_personal_loan.stallprice is '车位总价';
comment on column ${iol_schema}.icms_bc_personal_loan.companyexposuresum is '公司授信总金额(元)';
comment on column ${iol_schema}.icms_bc_personal_loan.purpose is '用途';
comment on column ${iol_schema}.icms_bc_personal_loan.isbankrel is '是否我行关联方';
comment on column ${iol_schema}.icms_bc_personal_loan.sellercertid is '卖房人证件号码';
comment on column ${iol_schema}.icms_bc_personal_loan.loanaccountname is '入账账户名称';
comment on column ${iol_schema}.icms_bc_personal_loan.buildingunitprice is '建筑面积单价';
comment on column ${iol_schema}.icms_bc_personal_loan.mandaterequirement is '委托条件';
comment on column ${iol_schema}.icms_bc_personal_loan.isexception is '是否例外额度';
comment on column ${iol_schema}.icms_bc_personal_loan.endaccountname is '最终绑定卡卡名';
comment on column ${iol_schema}.icms_bc_personal_loan.imageapprresult is '影像审批结果';
comment on column ${iol_schema}.icms_bc_personal_loan.isdiscount is '是否行内贴息/贴息标识';
comment on column ${iol_schema}.icms_bc_personal_loan.vehiclecontractno is '购车合同号';
comment on column ${iol_schema}.icms_bc_personal_loan.housingsum is '房屋套数';
comment on column ${iol_schema}.icms_bc_personal_loan.renewalflag is '合同是否支持续期标识';
comment on column ${iol_schema}.icms_bc_personal_loan.localstrategicindustry is '本地战略性新兴产业';
comment on column ${iol_schema}.icms_bc_personal_loan.insuranceperiod is '保险期限保险期限(月)';
comment on column ${iol_schema}.icms_bc_personal_loan.housingname is '楼盘名称';
comment on column ${iol_schema}.icms_bc_personal_loan.totalrecyleamt is '累计回收金额';
comment on column ${iol_schema}.icms_bc_personal_loan.guarantytype is '担保类型';
comment on column ${iol_schema}.icms_bc_personal_loan.guaranteeagreement is '相关回购/担保协议书编号';
comment on column ${iol_schema}.icms_bc_personal_loan.insurancecontractno is '保险合同编号';
comment on column ${iol_schema}.icms_bc_personal_loan.paymentobject is '支付对象';
comment on column ${iol_schema}.icms_bc_personal_loan.relserialno is '关联编号';
comment on column ${iol_schema}.icms_bc_personal_loan.excess is '免赔率';
comment on column ${iol_schema}.icms_bc_personal_loan.imagefilepath is '影像文件路径';
comment on column ${iol_schema}.icms_bc_personal_loan.parkingaddress is '购车位详址';
comment on column ${iol_schema}.icms_bc_personal_loan.groupcustcode is '集团客户号';
comment on column ${iol_schema}.icms_bc_personal_loan.paymentratio is '首付比例';
comment on column ${iol_schema}.icms_bc_personal_loan.isopenentsettleaccounts is '是否能够开立单位结算账户';
comment on column ${iol_schema}.icms_bc_personal_loan.isfirstpurchase is '是否首次购房';
comment on column ${iol_schema}.icms_bc_personal_loan.imageflag is '影像标识';
comment on column ${iol_schema}.icms_bc_personal_loan.mandatedepositsum is '委托存款金额';
comment on column ${iol_schema}.icms_bc_personal_loan.suitesunitprice is '套房面积单价';
comment on column ${iol_schema}.icms_bc_personal_loan.downpayment is '首付金额';
comment on column ${iol_schema}.icms_bc_personal_loan.isinsurance is '是否购买保险';
comment on column ${iol_schema}.icms_bc_personal_loan.eaccountname is 'E账户户名';
comment on column ${iol_schema}.icms_bc_personal_loan.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bc_personal_loan.businessname is '商家/销售商/开发商/建房单位名称';
comment on column ${iol_schema}.icms_bc_personal_loan.parkingarea is '购车位面积';
comment on column ${iol_schema}.icms_bc_personal_loan.feeratio is '手续费率';
comment on column ${iol_schema}.icms_bc_personal_loan.housingprice is '房屋总价';
comment on column ${iol_schema}.icms_bc_personal_loan.iswhite is '借款人与集团关系';
comment on column ${iol_schema}.icms_bc_personal_loan.purchasecontractid is '购房合同号';
comment on column ${iol_schema}.icms_bc_personal_loan.loanratio is '贷款成数';
comment on column ${iol_schema}.icms_bc_personal_loan.businesslicence is '营业执照号码';
comment on column ${iol_schema}.icms_bc_personal_loan.payaccountcertid is '绑定身份证号';
comment on column ${iol_schema}.icms_bc_personal_loan.recordrelativeserialno is '关联中介备案编号';
comment on column ${iol_schema}.icms_bc_personal_loan.telephone is '手机号';
comment on column ${iol_schema}.icms_bc_personal_loan.isbigaccountmode is '是否大账户模式';
comment on column ${iol_schema}.icms_bc_personal_loan.channelno is '渠道编号';
comment on column ${iol_schema}.icms_bc_personal_loan.buildingcompany is '建筑单位';
comment on column ${iol_schema}.icms_bc_personal_loan.housinglevel is '房屋等级';
comment on column ${iol_schema}.icms_bc_personal_loan.startbankno is '初始卡开户行';
comment on column ${iol_schema}.icms_bc_personal_loan.financialbond is '委放/专项/金融债';
comment on column ${iol_schema}.icms_bc_personal_loan.insurername is '保险公司名称';
comment on column ${iol_schema}.icms_bc_personal_loan.fitmentprice is '装修总价';
comment on column ${iol_schema}.icms_bc_personal_loan.repaymentaccname is '还款账户名称';
comment on column ${iol_schema}.icms_bc_personal_loan.endclearbankno is '收款方开户行清算行行号（最终）';
comment on column ${iol_schema}.icms_bc_personal_loan.presalepermitno is '预售许可证编号';
comment on column ${iol_schema}.icms_bc_personal_loan.extenddays is '宽限天数';
comment on column ${iol_schema}.icms_bc_personal_loan.isonline is '是否线上审批';
comment on column ${iol_schema}.icms_bc_personal_loan.propertyarea is '所购房产面积';
comment on column ${iol_schema}.icms_bc_personal_loan.evaluationname is '评估机构名称';
comment on column ${iol_schema}.icms_bc_personal_loan.suitesarea is '购房面积（套内面积）';
comment on column ${iol_schema}.icms_bc_personal_loan.payaccounttel is '开户手机';
comment on column ${iol_schema}.icms_bc_personal_loan.evaluationcertid is '评估机构证件号码';
comment on column ${iol_schema}.icms_bc_personal_loan.mandatedepositcurrency is '委托存款币种';
comment on column ${iol_schema}.icms_bc_personal_loan.exposeclassifyresult is '风险暴露分类结果';
comment on column ${iol_schema}.icms_bc_personal_loan.fundsprovided is '资金来源';
comment on column ${iol_schema}.icms_bc_personal_loan.principalcertid is '委托人有效证件号码';
comment on column ${iol_schema}.icms_bc_personal_loan.endaccountno is '最终绑定卡卡号';
comment on column ${iol_schema}.icms_bc_personal_loan.principalmarriage is '委托人婚姻状况';
comment on column ${iol_schema}.icms_bc_personal_loan.isbusinessguarantee is '是否合作机构/开发商/经销商担保';
comment on column ${iol_schema}.icms_bc_personal_loan.isvendorassumeliability is '是否销售商承担回购责任';
comment on column ${iol_schema}.icms_bc_personal_loan.groupcustname is '集团客户名称';
comment on column ${iol_schema}.icms_bc_personal_loan.housingaddress is '房屋详址';
comment on column ${iol_schema}.icms_bc_personal_loan.payaccounttype is '还款卡类型0-本行卡,1-他行卡';
comment on column ${iol_schema}.icms_bc_personal_loan.personalbusinessloanstype is '个人经营性贷款分类';
comment on column ${iol_schema}.icms_bc_personal_loan.evaluationcerttype is '评估证件类型';
comment on column ${iol_schema}.icms_bc_personal_loan.discountratio is '贴息比例';
comment on column ${iol_schema}.icms_bc_personal_loan.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_bc_personal_loan.iscompanycustomer is '是否公司额度管控';
comment on column ${iol_schema}.icms_bc_personal_loan.enterprisecode is '经销商企业代码';
comment on column ${iol_schema}.icms_bc_personal_loan.companycustomername is '公司客户名称';
comment on column ${iol_schema}.icms_bc_personal_loan.housingform is '房屋形式';
comment on column ${iol_schema}.icms_bc_personal_loan.paymentbasis is '首付款依据';
comment on column ${iol_schema}.icms_bc_personal_loan.feesum is '手续费金额';
comment on column ${iol_schema}.icms_bc_personal_loan.isgroupcustomer is '是否集团客户';
comment on column ${iol_schema}.icms_bc_personal_loan.isloananytime is '是否随借随还';
comment on column ${iol_schema}.icms_bc_personal_loan.sellername is '卖房人名称';
comment on column ${iol_schema}.icms_bc_personal_loan.businessclass is '类别';
comment on column ${iol_schema}.icms_bc_personal_loan.principalname is '委托人名称';
comment on column ${iol_schema}.icms_bc_personal_loan.creditincrmode is '增信模式标志';
comment on column ${iol_schema}.icms_bc_personal_loan.loandirection is '资金投向';
comment on column ${iol_schema}.icms_bc_personal_loan.insurancevariety is '保险品种';
comment on column ${iol_schema}.icms_bc_personal_loan.buildingarea is '购房面积（建筑面积）';
comment on column ${iol_schema}.icms_bc_personal_loan.repaydatetype is '还款日确定';
comment on column ${iol_schema}.icms_bc_personal_loan.feepayment is '手续费支付方式';
comment on column ${iol_schema}.icms_bc_personal_loan.repaymentaccount is '还款账号';
comment on column ${iol_schema}.icms_bc_personal_loan.evaluateprice is '评估价格';
comment on column ${iol_schema}.icms_bc_personal_loan.propertyunitprice is '物管费单价';
comment on column ${iol_schema}.icms_bc_personal_loan.availexposure is '集团客户可用敞口额度';
comment on column ${iol_schema}.icms_bc_personal_loan.endbankno is '最终实体卡对应的开户行';
comment on column ${iol_schema}.icms_bc_personal_loan.companyrelation is '借款人与公司关系';
comment on column ${iol_schema}.icms_bc_personal_loan.propertytype is '所购房产类型';
comment on column ${iol_schema}.icms_bc_personal_loan.endbankname is '最终实体卡对应的开户行名称';
comment on column ${iol_schema}.icms_bc_personal_loan.isjgaccount is '是否在我行开立监管账户';
comment on column ${iol_schema}.icms_bc_personal_loan.vehicletype is '车型';
comment on column ${iol_schema}.icms_bc_personal_loan.startaccountno is '初始卡卡号';
comment on column ${iol_schema}.icms_bc_personal_loan.startclearbankno is '收款方开户行清算行行号（最初）';
comment on column ${iol_schema}.icms_bc_personal_loan.vehicleprice is '汽车总价';
comment on column ${iol_schema}.icms_bc_personal_loan.insurance is '保险金额';
comment on column ${iol_schema}.icms_bc_personal_loan.wthruselmt is '是否使用额度';
comment on column ${iol_schema}.icms_bc_personal_loan.mandateriskclassify is '委托贷款风险分类';
comment on column ${iol_schema}.icms_bc_personal_loan.propertycertid is '房屋权证号';
comment on column ${iol_schema}.icms_bc_personal_loan.loanaccountno is '入账账号';
comment on column ${iol_schema}.icms_bc_personal_loan.startbankname is '初始卡开户行名称';
comment on column ${iol_schema}.icms_bc_personal_loan.determprice is '认定价格';
comment on column ${iol_schema}.icms_bc_personal_loan.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_bc_personal_loan.companycustomerid is '公司客户号';
comment on column ${iol_schema}.icms_bc_personal_loan.propertycontractno is '车位配套住房产权号/购房合同号';
comment on column ${iol_schema}.icms_bc_personal_loan.clientno is '委托人编号';
comment on column ${iol_schema}.icms_bc_personal_loan.startaccountname is '初始卡账户名称';
comment on column ${iol_schema}.icms_bc_personal_loan.commodityamt is '购买金额';
comment on column ${iol_schema}.icms_bc_personal_loan.businesscertcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_bc_personal_loan.payway is '贷款发放方式(1-一次2-分次)';
comment on column ${iol_schema}.icms_bc_personal_loan.dealdisputeway is '解决争议方式(1-甲方所在地人民法院2-仲裁委员会3-天河区人民法院4-其他)';
comment on column ${iol_schema}.icms_bc_personal_loan.dealdisputetxt is '解决争议方式备注';
comment on column ${iol_schema}.icms_bc_personal_loan.isforcedeal is '是否强制执行公证(1-是2-否)';
comment on column ${iol_schema}.icms_bc_personal_loan.bigloanpurpose is '贷款用途大类';
comment on column ${iol_schema}.icms_bc_personal_loan.zjkjstatus is '致景科技合同激活状态 0-未激活 1-待激活 2-已激活';
comment on column ${iol_schema}.icms_bc_personal_loan.cartype is '车辆类型';
comment on column ${iol_schema}.icms_bc_personal_loan.greenloanpurpose is '绿色贷款用途';
comment on column ${iol_schema}.icms_bc_personal_loan.accountserialno is '关联账户流水号';
comment on column ${iol_schema}.icms_bc_personal_loan.subgreenconsumeloanpurpose is '绿色消费子类';
comment on column ${iol_schema}.icms_bc_personal_loan.isagriculture is '是否涉农';
comment on column ${iol_schema}.icms_bc_personal_loan.highindustry is '高技术产业';
comment on column ${iol_schema}.icms_bc_personal_loan.economyindustry is '数字经济核心产业';
comment on column ${iol_schema}.icms_bc_personal_loan.intellectualindustry is '投向知识产权密集型产业';
comment on column ${iol_schema}.icms_bc_personal_loan.strategicindustry is '';
comment on column ${iol_schema}.icms_bc_personal_loan.cultureindustry is '投向文化及相关产业';
comment on column ${iol_schema}.icms_bc_personal_loan.isnewcoborrower is '是否新增共同借款人';
comment on column ${iol_schema}.icms_bc_personal_loan.productchannel is '产品渠道标识';
comment on column ${iol_schema}.icms_bc_personal_loan.claimperson is '集中办公合同认领人员';
comment on column ${iol_schema}.icms_bc_personal_loan.isclaim is '是否认领';
comment on column ${iol_schema}.icms_bc_personal_loan.isbelongterm is '是否靠档计息';
comment on column ${iol_schema}.icms_bc_personal_loan.centralizeorgid is '登记机构（集中录入人员）';
comment on column ${iol_schema}.icms_bc_personal_loan.centralizeoperaid is '登记所属机构（集中录入人员）';
comment on column ${iol_schema}.icms_bc_personal_loan.claimdate is '集中录入日期';
comment on column ${iol_schema}.icms_bc_personal_loan.extloanaccountno is '行外收款银行卡号';
comment on column ${iol_schema}.icms_bc_personal_loan.extloanaccountname is '行外收款卡户名';
comment on column ${iol_schema}.icms_bc_personal_loan.recvbankid is '收款银行编号';
comment on column ${iol_schema}.icms_bc_personal_loan.recvbankname is '收款银行名称';
comment on column ${iol_schema}.icms_bc_personal_loan.extrepaymentaccount is '行外还款银行卡号';
comment on column ${iol_schema}.icms_bc_personal_loan.extrepaymentaccname is '行外还款卡户名';
comment on column ${iol_schema}.icms_bc_personal_loan.repaybankid is '还款银行编号';
comment on column ${iol_schema}.icms_bc_personal_loan.repaybankname is '还款银行名称';
comment on column ${iol_schema}.icms_bc_personal_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bc_personal_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bc_personal_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bc_personal_loan.etl_timestamp is 'ETL处理时间戳';
