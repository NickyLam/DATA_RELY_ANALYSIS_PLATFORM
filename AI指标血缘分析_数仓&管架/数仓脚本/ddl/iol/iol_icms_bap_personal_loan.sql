/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bap_personal_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bap_personal_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bap_personal_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bap_personal_loan(
    serialno varchar2(64) -- 流水号
    ,isinsurance varchar2(2) -- 是否购买保险
    ,groupcustomerid varchar2(40) -- 集团客户号
    ,isjgaccount varchar2(12) -- 是否在我行开立监管账户
    ,propertytype varchar2(36) -- 所购房产类型
    ,insuranceperiod number(22) -- 保险期限
    ,balloonamortenddate date -- 气球贷摊销到期日
    ,creditimageupflag varchar2(10) -- 征信授权书影像上传结果1完成上传2未完成上传
    ,housingform varchar2(36) -- 房屋形式
    ,isexception varchar2(12) -- 是否例外额度
    ,companyquotacontrol varchar2(11) -- 是否公司额度管控
    ,authinfo varchar2(3000) -- 授权信息(JSON格式:授权类别,授权名称)
    ,enterprisecode varchar2(64) -- 经销商企业代码
    ,finalresult varchar2(10) -- 最终风控结果-移动展业赎楼贷
    ,relserialno varchar2(32) -- 关联流水号
    ,returncapitalinterval varchar2(20) -- 归还本金间隔
    ,contimageupflag varchar2(10) -- 借款合同影像上传结果1完成上传2未完成上传
    ,businesslicence varchar2(64) -- 营业执照号码
    ,isimage varchar2(2) -- 是否引入影像
    ,corporgid varchar2(64) -- 法人机构编号
    ,groupcustomername varchar2(80) -- 集团客户名称
    ,relycompanycreditno varchar2(60) -- 自家/挂靠企业统一社会信用代码
    ,purchasecontractid varchar2(64) -- 购房合同号
    ,phreceivableam number(24,6) -- 平安普惠收款金额
    ,mandateriskclassify varchar2(36) -- 委托贷款风险分类
    ,indtype varchar2(10) -- 客户性质
    ,paymentobject varchar2(160) -- 支付对象
    ,vehicletype varchar2(64) -- 车型
    ,feeratio number(10,6) -- 手续费率
    ,returncapitalratio number(24,8) -- 归还本金比例
    ,companybusinesssum number(22,2) -- 公司授信总金额
    ,repaymentdatetype varchar2(10) -- 还款日确定
    ,resetamt number(22,0) -- 重置额度
    ,mandatedepositcurrency varchar2(3) -- 委托存款币种
    ,housingprice number(24,6) -- 房屋总价
    ,buildingarea number(18,2) -- 购房面积（建筑面积）
    ,applycustype varchar2(10) -- 申请人其他类型
    ,isvendorassumeliability varchar2(2) -- 是否销售商承担回购责任
    ,evaluationcerttype varchar2(64) -- 评估证件类型
    ,flowflag varchar2(10) -- 流程标记
    ,passtime date -- 审批通过时间
    ,iswhite varchar2(1) -- 是否白户
    ,suggestsum number(22,0) -- 建议贷款金额(元)
    ,applyamt number(22,0) -- 申请额度
    ,onlineapproveresult varchar2(10) -- 线上审批结果
    ,companyname varchar2(200) -- 企业名称
    ,fitmentprice number(24,6) -- 装修总价
    ,propertycontractno varchar2(64) -- 车位配套住房产权号/购房合同号
    ,esaepclassify varchar2(36) -- 节能环保分类
    ,repayratio number(24,8) -- 归还本金比例
    ,suitesarea number(18,2) -- 购房面积（套内面积）
    ,businessclass varchar2(36) -- 类别
    ,cusgruoprelation varchar2(10) -- 借款人与集团关系
    ,insurance number(24,6) -- 保险金额
    ,sellername varchar2(160) -- 卖房人名称
    ,buildingcompany varchar2(160) -- 建筑单位
    ,presalepermitno varchar2(64) -- 预售许可证编号
    ,propertyarea number(18,2) -- 所购房产面积
    ,isopenentsettleaccounts varchar2(2) -- 是否能够开立单位结算账户
    ,isaddamt varchar2(2) -- 是否提额
    ,suitesunitprice number(24,6) -- 套房面积单价
    ,evaluationcertid varchar2(64) -- 评估机构证件号码
    ,vehiclecontractno varchar2(64) -- 购车合同号
    ,determprice number(24,6) -- 认定价格
    ,propertyunitprice number(24,6) -- 物管费单价
    ,insurancecontractno varchar2(64) -- 保险合同编号
    ,isthreemonthnewcar varchar2(10) -- 是否三个月内上牌新车
    ,propertycertid varchar2(128) -- 房屋权证号
    ,applyaddr varchar2(300) -- 申请地点
    ,signaddr varchar2(300) -- 签署地
    ,insurancevariety varchar2(160) -- 保险品种
    ,mandatedepositsum number(24,6) -- 委托存款金额
    ,payeeaccountno varchar2(200) -- 收款人帐号
    ,informflag varchar2(10) -- 申请结果是否通知成功
    ,payeeaccounttel varchar2(20) -- 开户b绑定手机号
    ,housingaddress varchar2(1000) -- 房屋详址
    ,companyid varchar2(20) -- 公司客户编号
    ,isloananytime varchar2(12) -- 是否随借随还
    ,purpose varchar2(1000) -- 用途
    ,startdate date -- 审批开始时间
    ,isfirstpurchase varchar2(2) -- 是否首次购房
    ,groupavailexposure number(24,6) -- 集团客户可用敞口额度
    ,isbusinessguarantee varchar2(2) -- 是否合作机构/开发商/经销商担保
    ,guarantytype varchar2(36) -- 担保类型
    ,discountratio number(22) -- 贴息比例
    ,enddate date -- 审批结束时间
    ,certid varchar2(30) -- 借款人证件号码
    ,baserateadjustper number(10,6) -- 基准利率上浮比例
    ,housinglevel varchar2(36) -- 房屋等级
    ,paymentratio number(24,8) -- 首付比例
    ,otherloancontractno varchar2(30) -- 借款合同编号
    ,isonline varchar2(12) -- 是否线上审批
    ,mandatedepositaccounts varchar2(15) -- 委托贷款存款账号
    ,ischeckcreditreport varchar2(10) -- 征信两岗是否点击了查看征信报告按钮:1是，0否
    ,imageupflag varchar2(10) -- 影像上传结果1完成上传2未完成上传
    ,usccno varchar2(32) -- 统一社会信用码
    ,businessname varchar2(160) -- 商家/销售商/开发商/建房单位名称
    ,feesum number(24,6) -- 手续费金额
    ,stallprice number(24,6) -- 车位总价
    ,loanratio number(24,8) -- 贷款成数
    ,loandirection varchar2(64) -- 资金投向
    ,housingsum number(22) -- 房屋套数
    ,downpayment number(24,6) -- 首付金额
    ,paymentbasis varchar2(1000) -- 首付款依据
    ,yxserno varchar2(60) -- 影像流水号
    ,mandaterequirement varchar2(1000) -- 委托条件
    ,creditincrmode varchar2(32) -- 增信模式标志
    ,channelcode varchar2(30) -- 渠道来源
    ,isback varchar2(10) -- 客户是否捞回
    ,relycompanyname varchar2(200) -- 自家/挂靠企业名称
    ,vehicleprice number(24,6) -- 汽车总价
    ,checkresult varchar2(2) -- 校验结果
    ,authtelephone varchar2(15) -- 绑卡鉴权手机号
    ,certtype varchar2(10) -- 借款人证件类型
    ,othercontsigndate date -- 挂靠或租赁协议签订日期
    ,taxcode varchar2(64) -- 纳税人识别号
    ,evaluationname varchar2(200) -- 评估机构名称
    ,parkingarea number(18,2) -- 购车位面积
    ,telephone varchar2(30) -- 借款人手机号码
    ,compcertid varchar2(30) -- 企业证件号码
    ,evaluateprice number(24,6) -- 评估价格
    ,recordrelativeserialno varchar2(64) -- 关联中介备案编号
    ,creditscore number(10,6) -- 机评信用等级
    ,remark varchar2(4000) -- 备注
    ,guaranteeagreement varchar2(64) -- 相关回购/担保协议书编号
    ,feepayment varchar2(36) -- 手续费支付方式
    ,paymenttype varchar2(36) -- 支付方式
    ,housingname varchar2(160) -- 楼盘名称
    ,personalbusinessloanstype varchar2(36) -- 个人经营性贷款分类
    ,payeename varchar2(80) -- 收款人名称
    ,investoinon varchar2(4000) -- 调查人意见
    ,isbankrel varchar2(12) -- 是否与我行存在关联关系
    ,insurername varchar2(160) -- 保险公司名称
    ,paybankname varchar2(200) -- 收款人行名
    ,sellercertid varchar2(64) -- 卖房人证件号码
    ,buildingunitprice number(24,6) -- 建筑面积单价
    ,repayinterval varchar2(36) -- 归还本金间隔
    ,graceperiod number(22) -- 宽限期（天）
    ,isgroupcustomer varchar2(12) -- 是否集团客户
    ,iscancel varchar2(10) -- 是否撤销
    ,insurflag varchar2(30) -- INSUR_Y:有保险,INSUR_N：无保险
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,callbackurl varchar2(1000) -- 普惠签约回调地址
    ,loanaccountclearbank varchar2(32) -- 入账账户清算行行号
    ,financialbond number(24,6) -- 委放/专项/金融债
    ,localstrategicindustry varchar2(160) -- 本地战略性新兴产业
    ,compcerttype varchar2(10) -- 企业证件类型
    ,excess number(22) -- 免赔率
    ,parkingaddress varchar2(1000) -- 购车位详址
    ,cuscomrelation varchar2(10) -- 借款人与公司关系
    ,isdiscount varchar2(2) -- 是否行内贴息/贴息标识
    ,bigloanpurpose varchar2(8) -- 贷款用途大类
    ,title varchar2(60) -- 标题
    ,riskcontrolback varchar2(120) -- 风控背景
    ,cartype varchar2(4) -- 车辆类型
    ,greenloanpurpose varchar2(8) -- 绿色贷款用途
    ,subgreenconsumeloanpurpose varchar2(8) -- 绿色消费子类
    ,productchannel varchar2(20) -- 产品渠道标识
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
grant select on ${iol_schema}.icms_bap_personal_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bap_personal_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bap_personal_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bap_personal_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bap_personal_loan is '批复个人贷款业务附属表';
comment on column ${iol_schema}.icms_bap_personal_loan.serialno is '流水号';
comment on column ${iol_schema}.icms_bap_personal_loan.isinsurance is '是否购买保险';
comment on column ${iol_schema}.icms_bap_personal_loan.groupcustomerid is '集团客户号';
comment on column ${iol_schema}.icms_bap_personal_loan.isjgaccount is '是否在我行开立监管账户';
comment on column ${iol_schema}.icms_bap_personal_loan.propertytype is '所购房产类型';
comment on column ${iol_schema}.icms_bap_personal_loan.insuranceperiod is '保险期限';
comment on column ${iol_schema}.icms_bap_personal_loan.balloonamortenddate is '气球贷摊销到期日';
comment on column ${iol_schema}.icms_bap_personal_loan.creditimageupflag is '征信授权书影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_bap_personal_loan.housingform is '房屋形式';
comment on column ${iol_schema}.icms_bap_personal_loan.isexception is '是否例外额度';
comment on column ${iol_schema}.icms_bap_personal_loan.companyquotacontrol is '是否公司额度管控';
comment on column ${iol_schema}.icms_bap_personal_loan.authinfo is '授权信息(JSON格式:授权类别,授权名称)';
comment on column ${iol_schema}.icms_bap_personal_loan.enterprisecode is '经销商企业代码';
comment on column ${iol_schema}.icms_bap_personal_loan.finalresult is '最终风控结果-移动展业赎楼贷';
comment on column ${iol_schema}.icms_bap_personal_loan.relserialno is '关联流水号';
comment on column ${iol_schema}.icms_bap_personal_loan.returncapitalinterval is '归还本金间隔';
comment on column ${iol_schema}.icms_bap_personal_loan.contimageupflag is '借款合同影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_bap_personal_loan.businesslicence is '营业执照号码';
comment on column ${iol_schema}.icms_bap_personal_loan.isimage is '是否引入影像';
comment on column ${iol_schema}.icms_bap_personal_loan.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_bap_personal_loan.groupcustomername is '集团客户名称';
comment on column ${iol_schema}.icms_bap_personal_loan.relycompanycreditno is '自家/挂靠企业统一社会信用代码';
comment on column ${iol_schema}.icms_bap_personal_loan.purchasecontractid is '购房合同号';
comment on column ${iol_schema}.icms_bap_personal_loan.phreceivableam is '平安普惠收款金额';
comment on column ${iol_schema}.icms_bap_personal_loan.mandateriskclassify is '委托贷款风险分类';
comment on column ${iol_schema}.icms_bap_personal_loan.indtype is '客户性质';
comment on column ${iol_schema}.icms_bap_personal_loan.paymentobject is '支付对象';
comment on column ${iol_schema}.icms_bap_personal_loan.vehicletype is '车型';
comment on column ${iol_schema}.icms_bap_personal_loan.feeratio is '手续费率';
comment on column ${iol_schema}.icms_bap_personal_loan.returncapitalratio is '归还本金比例';
comment on column ${iol_schema}.icms_bap_personal_loan.companybusinesssum is '公司授信总金额';
comment on column ${iol_schema}.icms_bap_personal_loan.repaymentdatetype is '还款日确定';
comment on column ${iol_schema}.icms_bap_personal_loan.resetamt is '重置额度';
comment on column ${iol_schema}.icms_bap_personal_loan.mandatedepositcurrency is '委托存款币种';
comment on column ${iol_schema}.icms_bap_personal_loan.housingprice is '房屋总价';
comment on column ${iol_schema}.icms_bap_personal_loan.buildingarea is '购房面积（建筑面积）';
comment on column ${iol_schema}.icms_bap_personal_loan.applycustype is '申请人其他类型';
comment on column ${iol_schema}.icms_bap_personal_loan.isvendorassumeliability is '是否销售商承担回购责任';
comment on column ${iol_schema}.icms_bap_personal_loan.evaluationcerttype is '评估证件类型';
comment on column ${iol_schema}.icms_bap_personal_loan.flowflag is '流程标记';
comment on column ${iol_schema}.icms_bap_personal_loan.passtime is '审批通过时间';
comment on column ${iol_schema}.icms_bap_personal_loan.iswhite is '是否白户';
comment on column ${iol_schema}.icms_bap_personal_loan.suggestsum is '建议贷款金额(元)';
comment on column ${iol_schema}.icms_bap_personal_loan.applyamt is '申请额度';
comment on column ${iol_schema}.icms_bap_personal_loan.onlineapproveresult is '线上审批结果';
comment on column ${iol_schema}.icms_bap_personal_loan.companyname is '企业名称';
comment on column ${iol_schema}.icms_bap_personal_loan.fitmentprice is '装修总价';
comment on column ${iol_schema}.icms_bap_personal_loan.propertycontractno is '车位配套住房产权号/购房合同号';
comment on column ${iol_schema}.icms_bap_personal_loan.esaepclassify is '节能环保分类';
comment on column ${iol_schema}.icms_bap_personal_loan.repayratio is '归还本金比例';
comment on column ${iol_schema}.icms_bap_personal_loan.suitesarea is '购房面积（套内面积）';
comment on column ${iol_schema}.icms_bap_personal_loan.businessclass is '类别';
comment on column ${iol_schema}.icms_bap_personal_loan.cusgruoprelation is '借款人与集团关系';
comment on column ${iol_schema}.icms_bap_personal_loan.insurance is '保险金额';
comment on column ${iol_schema}.icms_bap_personal_loan.sellername is '卖房人名称';
comment on column ${iol_schema}.icms_bap_personal_loan.buildingcompany is '建筑单位';
comment on column ${iol_schema}.icms_bap_personal_loan.presalepermitno is '预售许可证编号';
comment on column ${iol_schema}.icms_bap_personal_loan.propertyarea is '所购房产面积';
comment on column ${iol_schema}.icms_bap_personal_loan.isopenentsettleaccounts is '是否能够开立单位结算账户';
comment on column ${iol_schema}.icms_bap_personal_loan.isaddamt is '是否提额';
comment on column ${iol_schema}.icms_bap_personal_loan.suitesunitprice is '套房面积单价';
comment on column ${iol_schema}.icms_bap_personal_loan.evaluationcertid is '评估机构证件号码';
comment on column ${iol_schema}.icms_bap_personal_loan.vehiclecontractno is '购车合同号';
comment on column ${iol_schema}.icms_bap_personal_loan.determprice is '认定价格';
comment on column ${iol_schema}.icms_bap_personal_loan.propertyunitprice is '物管费单价';
comment on column ${iol_schema}.icms_bap_personal_loan.insurancecontractno is '保险合同编号';
comment on column ${iol_schema}.icms_bap_personal_loan.isthreemonthnewcar is '是否三个月内上牌新车';
comment on column ${iol_schema}.icms_bap_personal_loan.propertycertid is '房屋权证号';
comment on column ${iol_schema}.icms_bap_personal_loan.applyaddr is '申请地点';
comment on column ${iol_schema}.icms_bap_personal_loan.signaddr is '签署地';
comment on column ${iol_schema}.icms_bap_personal_loan.insurancevariety is '保险品种';
comment on column ${iol_schema}.icms_bap_personal_loan.mandatedepositsum is '委托存款金额';
comment on column ${iol_schema}.icms_bap_personal_loan.payeeaccountno is '收款人帐号';
comment on column ${iol_schema}.icms_bap_personal_loan.informflag is '申请结果是否通知成功';
comment on column ${iol_schema}.icms_bap_personal_loan.payeeaccounttel is '开户b绑定手机号';
comment on column ${iol_schema}.icms_bap_personal_loan.housingaddress is '房屋详址';
comment on column ${iol_schema}.icms_bap_personal_loan.companyid is '公司客户编号';
comment on column ${iol_schema}.icms_bap_personal_loan.isloananytime is '是否随借随还';
comment on column ${iol_schema}.icms_bap_personal_loan.purpose is '用途';
comment on column ${iol_schema}.icms_bap_personal_loan.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_bap_personal_loan.isfirstpurchase is '是否首次购房';
comment on column ${iol_schema}.icms_bap_personal_loan.groupavailexposure is '集团客户可用敞口额度';
comment on column ${iol_schema}.icms_bap_personal_loan.isbusinessguarantee is '是否合作机构/开发商/经销商担保';
comment on column ${iol_schema}.icms_bap_personal_loan.guarantytype is '担保类型';
comment on column ${iol_schema}.icms_bap_personal_loan.discountratio is '贴息比例';
comment on column ${iol_schema}.icms_bap_personal_loan.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_bap_personal_loan.certid is '借款人证件号码';
comment on column ${iol_schema}.icms_bap_personal_loan.baserateadjustper is '基准利率上浮比例';
comment on column ${iol_schema}.icms_bap_personal_loan.housinglevel is '房屋等级';
comment on column ${iol_schema}.icms_bap_personal_loan.paymentratio is '首付比例';
comment on column ${iol_schema}.icms_bap_personal_loan.otherloancontractno is '借款合同编号';
comment on column ${iol_schema}.icms_bap_personal_loan.isonline is '是否线上审批';
comment on column ${iol_schema}.icms_bap_personal_loan.mandatedepositaccounts is '委托贷款存款账号';
comment on column ${iol_schema}.icms_bap_personal_loan.ischeckcreditreport is '征信两岗是否点击了查看征信报告按钮:1是，0否';
comment on column ${iol_schema}.icms_bap_personal_loan.imageupflag is '影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_bap_personal_loan.usccno is '统一社会信用码';
comment on column ${iol_schema}.icms_bap_personal_loan.businessname is '商家/销售商/开发商/建房单位名称';
comment on column ${iol_schema}.icms_bap_personal_loan.feesum is '手续费金额';
comment on column ${iol_schema}.icms_bap_personal_loan.stallprice is '车位总价';
comment on column ${iol_schema}.icms_bap_personal_loan.loanratio is '贷款成数';
comment on column ${iol_schema}.icms_bap_personal_loan.loandirection is '资金投向';
comment on column ${iol_schema}.icms_bap_personal_loan.housingsum is '房屋套数';
comment on column ${iol_schema}.icms_bap_personal_loan.downpayment is '首付金额';
comment on column ${iol_schema}.icms_bap_personal_loan.paymentbasis is '首付款依据';
comment on column ${iol_schema}.icms_bap_personal_loan.yxserno is '影像流水号';
comment on column ${iol_schema}.icms_bap_personal_loan.mandaterequirement is '委托条件';
comment on column ${iol_schema}.icms_bap_personal_loan.creditincrmode is '增信模式标志';
comment on column ${iol_schema}.icms_bap_personal_loan.channelcode is '渠道来源';
comment on column ${iol_schema}.icms_bap_personal_loan.isback is '客户是否捞回';
comment on column ${iol_schema}.icms_bap_personal_loan.relycompanyname is '自家/挂靠企业名称';
comment on column ${iol_schema}.icms_bap_personal_loan.vehicleprice is '汽车总价';
comment on column ${iol_schema}.icms_bap_personal_loan.checkresult is '校验结果';
comment on column ${iol_schema}.icms_bap_personal_loan.authtelephone is '绑卡鉴权手机号';
comment on column ${iol_schema}.icms_bap_personal_loan.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_bap_personal_loan.othercontsigndate is '挂靠或租赁协议签订日期';
comment on column ${iol_schema}.icms_bap_personal_loan.taxcode is '纳税人识别号';
comment on column ${iol_schema}.icms_bap_personal_loan.evaluationname is '评估机构名称';
comment on column ${iol_schema}.icms_bap_personal_loan.parkingarea is '购车位面积';
comment on column ${iol_schema}.icms_bap_personal_loan.telephone is '借款人手机号码';
comment on column ${iol_schema}.icms_bap_personal_loan.compcertid is '企业证件号码';
comment on column ${iol_schema}.icms_bap_personal_loan.evaluateprice is '评估价格';
comment on column ${iol_schema}.icms_bap_personal_loan.recordrelativeserialno is '关联中介备案编号';
comment on column ${iol_schema}.icms_bap_personal_loan.creditscore is '机评信用等级';
comment on column ${iol_schema}.icms_bap_personal_loan.remark is '备注';
comment on column ${iol_schema}.icms_bap_personal_loan.guaranteeagreement is '相关回购/担保协议书编号';
comment on column ${iol_schema}.icms_bap_personal_loan.feepayment is '手续费支付方式';
comment on column ${iol_schema}.icms_bap_personal_loan.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_bap_personal_loan.housingname is '楼盘名称';
comment on column ${iol_schema}.icms_bap_personal_loan.personalbusinessloanstype is '个人经营性贷款分类';
comment on column ${iol_schema}.icms_bap_personal_loan.payeename is '收款人名称';
comment on column ${iol_schema}.icms_bap_personal_loan.investoinon is '调查人意见';
comment on column ${iol_schema}.icms_bap_personal_loan.isbankrel is '是否与我行存在关联关系';
comment on column ${iol_schema}.icms_bap_personal_loan.insurername is '保险公司名称';
comment on column ${iol_schema}.icms_bap_personal_loan.paybankname is '收款人行名';
comment on column ${iol_schema}.icms_bap_personal_loan.sellercertid is '卖房人证件号码';
comment on column ${iol_schema}.icms_bap_personal_loan.buildingunitprice is '建筑面积单价';
comment on column ${iol_schema}.icms_bap_personal_loan.repayinterval is '归还本金间隔';
comment on column ${iol_schema}.icms_bap_personal_loan.graceperiod is '宽限期（天）';
comment on column ${iol_schema}.icms_bap_personal_loan.isgroupcustomer is '是否集团客户';
comment on column ${iol_schema}.icms_bap_personal_loan.iscancel is '是否撤销';
comment on column ${iol_schema}.icms_bap_personal_loan.insurflag is 'INSUR_Y:有保险,INSUR_N：无保险';
comment on column ${iol_schema}.icms_bap_personal_loan.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_bap_personal_loan.callbackurl is '普惠签约回调地址';
comment on column ${iol_schema}.icms_bap_personal_loan.loanaccountclearbank is '入账账户清算行行号';
comment on column ${iol_schema}.icms_bap_personal_loan.financialbond is '委放/专项/金融债';
comment on column ${iol_schema}.icms_bap_personal_loan.localstrategicindustry is '本地战略性新兴产业';
comment on column ${iol_schema}.icms_bap_personal_loan.compcerttype is '企业证件类型';
comment on column ${iol_schema}.icms_bap_personal_loan.excess is '免赔率';
comment on column ${iol_schema}.icms_bap_personal_loan.parkingaddress is '购车位详址';
comment on column ${iol_schema}.icms_bap_personal_loan.cuscomrelation is '借款人与公司关系';
comment on column ${iol_schema}.icms_bap_personal_loan.isdiscount is '是否行内贴息/贴息标识';
comment on column ${iol_schema}.icms_bap_personal_loan.bigloanpurpose is '贷款用途大类';
comment on column ${iol_schema}.icms_bap_personal_loan.title is '标题';
comment on column ${iol_schema}.icms_bap_personal_loan.riskcontrolback is '风控背景';
comment on column ${iol_schema}.icms_bap_personal_loan.cartype is '车辆类型';
comment on column ${iol_schema}.icms_bap_personal_loan.greenloanpurpose is '绿色贷款用途';
comment on column ${iol_schema}.icms_bap_personal_loan.subgreenconsumeloanpurpose is '绿色消费子类';
comment on column ${iol_schema}.icms_bap_personal_loan.productchannel is '产品渠道标识';
comment on column ${iol_schema}.icms_bap_personal_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bap_personal_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bap_personal_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bap_personal_loan.etl_timestamp is 'ETL处理时间戳';
