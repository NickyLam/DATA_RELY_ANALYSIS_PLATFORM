/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ba_personal_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ba_personal_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ba_personal_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_personal_loan(
    serialno varchar2(128) -- 流水号
    ,usccno varchar2(64) -- 统一社会信用码
    ,flowflag varchar2(20) -- 流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审
    ,isdiscount varchar2(4) -- 是否行内贴息/贴息标识
    ,authinfo varchar2(4000) -- 授权信息(JSON格式:授权类别,授权名称)
    ,groupavailexposure number(24,6) -- 集团客户可用敞口额度
    ,othercontsigndate date -- 挂靠或租赁协议签订日期
    ,companybusinesssum number(22,2) -- 公司授信总金额
    ,parkingarea number(18,2) -- 购车位面积
    ,certid varchar2(60) -- 借款人证件号码
    ,isfirstpurchase varchar2(4) -- 是否首次购房
    ,downpayment number(24,6) -- 首付金额
    ,paybankname varchar2(400) -- 收款人行名
    ,sellercertid varchar2(36) -- 卖房人证件号码
    ,mandaterequirement varchar2(2000) -- 委托条件
    ,buildingcompany varchar2(320) -- 建筑单位
    ,cuscomrelation varchar2(20) -- 借款人与公司关系
    ,insurance number(24,6) -- 保险金额
    ,loanaccountclearbank varchar2(64) -- 入账账户清算行行号
    ,feesum number(24,6) -- 手续费金额
    ,yxserno varchar2(120) -- 影像流水号
    ,discountratio number(22) -- 贴息比例
    ,mandatedepositcurrency varchar2(6) -- 委托存款币种
    ,determprice number(24,6) -- 认定价格
    ,evaluationname varchar2(320) -- 评估机构名称
    ,onlineapproveresult varchar2(20) -- 线上审批结果
    ,applycustype varchar2(20) -- 申请人其他类型
    ,iswhite varchar2(2) -- 是否白户
    ,mandatedepositaccounts varchar2(128) -- 委托贷款存款账号
    ,passtime date -- 审批通过时间
    ,repaymentdatetype varchar2(20) -- 还款日确定
    ,businesslicence varchar2(128) -- 营业执照号码
    ,presalepermitno varchar2(128) -- 预售许可证编号
    ,guaranteeagreement varchar2(128) -- 相关回购/担保协议书编号
    ,isgroupcustomer varchar2(24) -- 是否集团客户
    ,returncapitalinterval varchar2(40) -- 归还本金间隔
    ,insuranceperiod number(22) -- 保险期限
    ,insurername varchar2(320) -- 保险公司名称
    ,stallprice number(24,6) -- 车位总价
    ,iscancel varchar2(20) -- 是否撤销
    ,returncapitalratio number(24,8) -- 归还本金比例
    ,purchasecontractid varchar2(128) -- 购房合同号
    ,recordrelativeserialno varchar2(128) -- 关联中介备案编号
    ,groupcustomerid varchar2(80) -- 集团客户号
    ,relserialno varchar2(64) -- 关联流水号
    ,guarantytype varchar2(72) -- 担保类型
    ,companyname varchar2(400) -- 公司客户名称
    ,isthreemonthnewcar varchar2(20) -- 是否三个月内上牌新车
    ,isonline varchar2(24) -- 是否线上审批
    ,housingprice number(24,6) -- 房屋总价
    ,propertycontractno varchar2(128) -- 车位配套住房产权号/购房合同号
    ,esaepclassify varchar2(72) -- 节能环保分类
    ,businessname varchar2(320) -- 商家/销售商/开发商/建房单位名称
    ,enddate date -- 审批结束时间
    ,telephone varchar2(60) -- 借款人手机号码
    ,evaluateprice number(24,6) -- 评估价格
    ,imageupflag varchar2(20) -- 影像上传结果1完成上传2未完成上传
    ,phreceivableam number(24,6) -- 平安普惠收款金额
    ,suggestsum number(22,0) -- 建议贷款金额(元)
    ,authtelephone varchar2(30) -- 绑卡鉴权手机号
    ,isimage varchar2(4) -- 是否引入影像
    ,payeename varchar2(160) -- 收款人名称
    ,parkingaddress varchar2(2000) -- 购车位详址
    ,applyaddr varchar2(600) -- 申请地点
    ,isvendorassumeliability varchar2(4) -- 是否销售商承担回购责任
    ,sellername varchar2(320) -- 卖房人名称
    ,informflag varchar2(20) -- 申请结果是否通知成功
    ,loanratio number(24,8) -- 贷款成数
    ,vehiclecontractno varchar2(128) -- 购车合同号
    ,balloonamortenddate date -- 气球贷摊销到期日
    ,investoinon varchar2(4000) -- 调查人意见
    ,otherloancontractno varchar2(60) -- 借款合同编号
    ,mandatedepositsum number(24,6) -- 委托存款金额
    ,propertycertid varchar2(128) -- 房屋权证号
    ,evaluationcertid varchar2(128) -- 评估机构证件号码
    ,contimageupflag varchar2(20) -- 借款合同影像上传结果1完成上传2未完成上传
    ,payeeaccounttel varchar2(40) -- 开户b绑定手机号
    ,suitesunitprice number(24,6) -- 套房面积单价
    ,mandateriskclassify varchar2(72) -- 委托贷款风险分类
    ,financialbond number(24,6) -- 委放/专项/金融债
    ,propertyarea number(18,2) -- 所购房产面积
    ,applyamt number(22,0) -- 申请额度
    ,insurancevariety varchar2(320) -- 保险品种
    ,isback varchar2(20) -- 客户是否捞回
    ,resetamt number(22,0) -- 重置额度
    ,housingname varchar2(320) -- 楼盘名称
    ,channelcode varchar2(60) -- 渠道来源
    ,enterprisecode varchar2(128) -- 经销商企业代码
    ,propertytype varchar2(72) -- 所购房产类型
    ,excess number(22) -- 免赔率
    ,isbankrel varchar2(24) -- 是否与我行存在关联关系
    ,ischeckcreditreport varchar2(20) -- 征信两岗是否点击了查看征信报告按钮:1是，0否
    ,housingsum number(22) -- 房屋套数
    ,businessclass varchar2(72) -- 类别
    ,purpose varchar2(2000) -- 用途
    ,checkresult varchar2(4) -- 校验结果
    ,insurflag varchar2(60) -- 是否有保险
    ,insurancecontractno varchar2(128) -- 保险合同编号
    ,isexception varchar2(24) -- 是否例外额度
    ,startdate date -- 审批开始时间
    ,callbackurl varchar2(2000) -- 普惠签约回调地址
    ,finalresult varchar2(20) -- 最终风控结果-移动展业赎楼贷
    ,housingform varchar2(72) -- 房屋形式
    ,fitmentprice number(24,6) -- 装修总价
    ,repayinterval varchar2(72) -- 归还本金间隔
    ,indtype varchar2(20) -- 客户性质
    ,taxcode varchar2(128) -- 纳税人识别号
    ,buildingunitprice number(24,6) -- 建筑面积单价
    ,vehicletype varchar2(128) -- 车型
    ,availexposure number(22,4) -- 集团客户名称
    ,companyid varchar2(40) -- 公司客户编号
    ,graceperiod number(4,0) -- 宽限期（天）
    ,personalbusinessloanstype varchar2(72) -- 个人经营性贷款分类
    ,isloananytime varchar2(24) -- 是否随借随还
    ,housingaddress varchar2(2000) -- 房屋详址
    ,repayratio number(24,8) -- 归还本金比例
    ,signaddr varchar2(600) -- 签署地
    ,evaluationcerttype varchar2(128) -- 评估证件类型
    ,paymentobject varchar2(320) -- 支付对象
    ,certtype varchar2(20) -- 借款人证件类型
    ,relycompanyname varchar2(400) -- 自家/挂靠企业名称
    ,paymenttype varchar2(72) -- 支付方式
    ,feepayment varchar2(72) -- 手续费支付方式
    ,paymentbasis varchar2(2000) -- 首付款依据
    ,propertyunitprice number(24,6) -- 物管费单价
    ,compcertid varchar2(60) -- 企业证件号码
    ,groupcustcode varchar2(40) -- 是否集团客户
    ,payeeaccountno varchar2(400) -- 收款人帐号
    ,isinsurance varchar2(4) -- 是否购买保险
    ,isopenentsettleaccounts varchar2(4) -- 是否能够开立单位结算账户
    ,compcerttype varchar2(20) -- 企业证件类型
    ,vehicleprice number(24,6) -- 汽车总价
    ,housinglevel varchar2(72) -- 房屋等级
    ,isbusinessguarantee varchar2(4) -- 是否合作机构/开发商/经销商担保
    ,localstrategicindustry varchar2(320) -- 本地战略性新兴产业
    ,migtflag varchar2(160) -- 迁移标志：crsrcrilcupl
    ,cusgruoprelation varchar2(20) -- 借款人与集团关系
    ,corporgid varchar2(128) -- 法人机构编号
    ,relycompanycreditno varchar2(120) -- 自家/挂靠企业统一社会信用代码
    ,baserateadjustper number(10,6) -- 基准利率上浮比例
    ,feeratio number(10,6) -- 手续费率
    ,companyquotacontrol varchar2(22) -- 是否公司额度管控
    ,suitesarea number(18,2) -- 购房面积（套内面积）
    ,isaddamt varchar2(4) -- 是否提额
    ,groupcustname varchar2(400) -- 集团客户号
    ,buildingarea number(18,2) -- 购房面积（建筑面积）
    ,creditscore number(10,6) -- 机评信用等级
    ,remark varchar2(4000) -- 备注
    ,paymentratio number(24,8) -- 首付比例
    ,loandirection varchar2(128) -- 资金投向
    ,groupcustomername varchar2(160) -- 集团客户名称
    ,isjgaccount varchar2(24) -- 是否在我行开立监管账户
    ,creditimageupflag varchar2(20) -- 征信授权书影像上传结果1完成上传2未完成上传
    ,creditincrmode varchar2(64) -- 增信模式标志
    ,referrerid varchar2(64) -- 推荐人ID
    ,iswthrmanuactclmt varchar2(20) -- 是否人工激活额度YesNo
    ,recheckflag varchar2(20) -- 复核标识YesNo
    ,consignerid varchar2(96) -- 委托人ID
    ,ishouseinguangdong varchar2(4) -- 委托人ID
    ,worktype varchar2(40) -- 委托人ID
    ,bigloanpurpose varchar2(16) -- 贷款用途大类
    ,title varchar2(120) -- 标题
    ,riskcontrolback varchar2(240) -- 风控背景
    ,cuscreditscore number(22) -- 客户信用分数:内评
    ,cuscreditscorelevel varchar2(4) -- 客户信用分数等级
    ,cartype varchar2(8) -- 车辆类型
    ,greenloanpurpose varchar2(16) -- 绿色贷款用途
    ,companytype varchar2(8) -- 企业规模
    ,employments number(22) -- 从业人员
    ,busiincome number(24,6) -- 营业收入
    ,assetstotal number(20,2) -- 资产总额
    ,industry varchar2(10) -- 所属行业
    ,custcreditlevel varchar2(8) -- 客户风险等级
    ,loanpurposedetails varchar2(16) -- 贷款用途细类字段
    ,highindustry varchar2(20) -- 高技术产业
    ,economyindustry varchar2(20) -- 数字经济核心产业
    ,intellectualindustry varchar2(20) -- 投向知识产权密集型产业
    ,cultureindustry varchar2(20) -- 投向文化及相关产业
    ,isagriculture varchar2(4) -- 是否涉农
    ,strategicindustry varchar2(20) -- 
    ,custlabel varchar2(20) -- 
    ,warninginfo varchar2(2000) -- 
    ,subgreenconsumeloanpurpose varchar2(8) -- 
    ,isoperatingentinvolvespecialized varchar2(1) -- 
    ,ishightechnologyent varchar2(1) -- 
    ,istechnologyent varchar2(1) -- 
    ,isscientifictechent varchar2(1) -- 
    ,isspecializedgiantent varchar2(1) -- 
    ,isspecializedsmallandmident varchar2(1) -- 
    ,istechnologysmallandmident varchar2(1) -- 
    ,isindustrysinglechampionent varchar2(1) -- 
    ,isnationaltechnologinnovationent varchar2(1) -- 
    ,isgarden varchar2(4) -- 
    ,productchannel varchar2(20) -- 
    ,iscentralizedofficestaff varchar2(4) -- 
    ,cobsratio number(10,4) -- 
    ,workingmonth number(10,4) -- 
    ,flowbranchtype varchar2(10) -- 
    ,isicmsfactory varchar2(2) -- 
    ,guaranteecompanyname varchar2(200) -- 
    ,runentyearincome number(24,6) -- 
    ,lastyearentyearincome number(24,6) -- 
    ,yearincomerate number(24,6) -- 
    ,operationloanbalanceskr number(24,6) -- 
    ,otherworkcaptial number(24,6) -- 
    ,isrelatedcompany varchar2(10) -- 
    ,intentguaramt number(24,6) -- 
    ,guarcompanyterm number(22) -- 
    ,comptaxgrade varchar2(10) -- 
    ,iscompanyrelatedperson varchar2(10) -- 
    ,recommendedamt number(24,6) -- 
    ,recommendedterm number(22) -- 
    ,otherlimitflag varchar2(10) -- 
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
grant select on ${iol_schema}.icms_ba_personal_loan to ${iml_schema};
grant select on ${iol_schema}.icms_ba_personal_loan to ${icl_schema};
grant select on ${iol_schema}.icms_ba_personal_loan to ${idl_schema};
grant select on ${iol_schema}.icms_ba_personal_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ba_personal_loan is '申请个人贷款业务附属表';
comment on column ${iol_schema}.icms_ba_personal_loan.serialno is '流水号';
comment on column ${iol_schema}.icms_ba_personal_loan.usccno is '统一社会信用码';
comment on column ${iol_schema}.icms_ba_personal_loan.flowflag is '流程标记0业务申请1业务审批2出账申请3出账审批4待放款5放款6还款中7已结清,9已拒绝11-借呗初审12-借呗终审';
comment on column ${iol_schema}.icms_ba_personal_loan.isdiscount is '是否行内贴息/贴息标识';
comment on column ${iol_schema}.icms_ba_personal_loan.authinfo is '授权信息(JSON格式:授权类别,授权名称)';
comment on column ${iol_schema}.icms_ba_personal_loan.groupavailexposure is '集团客户可用敞口额度';
comment on column ${iol_schema}.icms_ba_personal_loan.othercontsigndate is '挂靠或租赁协议签订日期';
comment on column ${iol_schema}.icms_ba_personal_loan.companybusinesssum is '公司授信总金额';
comment on column ${iol_schema}.icms_ba_personal_loan.parkingarea is '购车位面积';
comment on column ${iol_schema}.icms_ba_personal_loan.certid is '借款人证件号码';
comment on column ${iol_schema}.icms_ba_personal_loan.isfirstpurchase is '是否首次购房';
comment on column ${iol_schema}.icms_ba_personal_loan.downpayment is '首付金额';
comment on column ${iol_schema}.icms_ba_personal_loan.paybankname is '收款人行名';
comment on column ${iol_schema}.icms_ba_personal_loan.sellercertid is '卖房人证件号码';
comment on column ${iol_schema}.icms_ba_personal_loan.mandaterequirement is '委托条件';
comment on column ${iol_schema}.icms_ba_personal_loan.buildingcompany is '建筑单位';
comment on column ${iol_schema}.icms_ba_personal_loan.cuscomrelation is '借款人与公司关系';
comment on column ${iol_schema}.icms_ba_personal_loan.insurance is '保险金额';
comment on column ${iol_schema}.icms_ba_personal_loan.loanaccountclearbank is '入账账户清算行行号';
comment on column ${iol_schema}.icms_ba_personal_loan.feesum is '手续费金额';
comment on column ${iol_schema}.icms_ba_personal_loan.yxserno is '影像流水号';
comment on column ${iol_schema}.icms_ba_personal_loan.discountratio is '贴息比例';
comment on column ${iol_schema}.icms_ba_personal_loan.mandatedepositcurrency is '委托存款币种';
comment on column ${iol_schema}.icms_ba_personal_loan.determprice is '认定价格';
comment on column ${iol_schema}.icms_ba_personal_loan.evaluationname is '评估机构名称';
comment on column ${iol_schema}.icms_ba_personal_loan.onlineapproveresult is '线上审批结果';
comment on column ${iol_schema}.icms_ba_personal_loan.applycustype is '申请人其他类型';
comment on column ${iol_schema}.icms_ba_personal_loan.iswhite is '是否白户';
comment on column ${iol_schema}.icms_ba_personal_loan.mandatedepositaccounts is '委托贷款存款账号';
comment on column ${iol_schema}.icms_ba_personal_loan.passtime is '审批通过时间';
comment on column ${iol_schema}.icms_ba_personal_loan.repaymentdatetype is '还款日确定';
comment on column ${iol_schema}.icms_ba_personal_loan.businesslicence is '营业执照号码';
comment on column ${iol_schema}.icms_ba_personal_loan.presalepermitno is '预售许可证编号';
comment on column ${iol_schema}.icms_ba_personal_loan.guaranteeagreement is '相关回购/担保协议书编号';
comment on column ${iol_schema}.icms_ba_personal_loan.isgroupcustomer is '是否集团客户';
comment on column ${iol_schema}.icms_ba_personal_loan.returncapitalinterval is '归还本金间隔';
comment on column ${iol_schema}.icms_ba_personal_loan.insuranceperiod is '保险期限';
comment on column ${iol_schema}.icms_ba_personal_loan.insurername is '保险公司名称';
comment on column ${iol_schema}.icms_ba_personal_loan.stallprice is '车位总价';
comment on column ${iol_schema}.icms_ba_personal_loan.iscancel is '是否撤销';
comment on column ${iol_schema}.icms_ba_personal_loan.returncapitalratio is '归还本金比例';
comment on column ${iol_schema}.icms_ba_personal_loan.purchasecontractid is '购房合同号';
comment on column ${iol_schema}.icms_ba_personal_loan.recordrelativeserialno is '关联中介备案编号';
comment on column ${iol_schema}.icms_ba_personal_loan.groupcustomerid is '集团客户号';
comment on column ${iol_schema}.icms_ba_personal_loan.relserialno is '关联流水号';
comment on column ${iol_schema}.icms_ba_personal_loan.guarantytype is '担保类型';
comment on column ${iol_schema}.icms_ba_personal_loan.companyname is '公司客户名称';
comment on column ${iol_schema}.icms_ba_personal_loan.isthreemonthnewcar is '是否三个月内上牌新车';
comment on column ${iol_schema}.icms_ba_personal_loan.isonline is '是否线上审批';
comment on column ${iol_schema}.icms_ba_personal_loan.housingprice is '房屋总价';
comment on column ${iol_schema}.icms_ba_personal_loan.propertycontractno is '车位配套住房产权号/购房合同号';
comment on column ${iol_schema}.icms_ba_personal_loan.esaepclassify is '节能环保分类';
comment on column ${iol_schema}.icms_ba_personal_loan.businessname is '商家/销售商/开发商/建房单位名称';
comment on column ${iol_schema}.icms_ba_personal_loan.enddate is '审批结束时间';
comment on column ${iol_schema}.icms_ba_personal_loan.telephone is '借款人手机号码';
comment on column ${iol_schema}.icms_ba_personal_loan.evaluateprice is '评估价格';
comment on column ${iol_schema}.icms_ba_personal_loan.imageupflag is '影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_ba_personal_loan.phreceivableam is '平安普惠收款金额';
comment on column ${iol_schema}.icms_ba_personal_loan.suggestsum is '建议贷款金额(元)';
comment on column ${iol_schema}.icms_ba_personal_loan.authtelephone is '绑卡鉴权手机号';
comment on column ${iol_schema}.icms_ba_personal_loan.isimage is '是否引入影像';
comment on column ${iol_schema}.icms_ba_personal_loan.payeename is '收款人名称';
comment on column ${iol_schema}.icms_ba_personal_loan.parkingaddress is '购车位详址';
comment on column ${iol_schema}.icms_ba_personal_loan.applyaddr is '申请地点';
comment on column ${iol_schema}.icms_ba_personal_loan.isvendorassumeliability is '是否销售商承担回购责任';
comment on column ${iol_schema}.icms_ba_personal_loan.sellername is '卖房人名称';
comment on column ${iol_schema}.icms_ba_personal_loan.informflag is '申请结果是否通知成功';
comment on column ${iol_schema}.icms_ba_personal_loan.loanratio is '贷款成数';
comment on column ${iol_schema}.icms_ba_personal_loan.vehiclecontractno is '购车合同号';
comment on column ${iol_schema}.icms_ba_personal_loan.balloonamortenddate is '气球贷摊销到期日';
comment on column ${iol_schema}.icms_ba_personal_loan.investoinon is '调查人意见';
comment on column ${iol_schema}.icms_ba_personal_loan.otherloancontractno is '借款合同编号';
comment on column ${iol_schema}.icms_ba_personal_loan.mandatedepositsum is '委托存款金额';
comment on column ${iol_schema}.icms_ba_personal_loan.propertycertid is '房屋权证号';
comment on column ${iol_schema}.icms_ba_personal_loan.evaluationcertid is '评估机构证件号码';
comment on column ${iol_schema}.icms_ba_personal_loan.contimageupflag is '借款合同影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_ba_personal_loan.payeeaccounttel is '开户b绑定手机号';
comment on column ${iol_schema}.icms_ba_personal_loan.suitesunitprice is '套房面积单价';
comment on column ${iol_schema}.icms_ba_personal_loan.mandateriskclassify is '委托贷款风险分类';
comment on column ${iol_schema}.icms_ba_personal_loan.financialbond is '委放/专项/金融债';
comment on column ${iol_schema}.icms_ba_personal_loan.propertyarea is '所购房产面积';
comment on column ${iol_schema}.icms_ba_personal_loan.applyamt is '申请额度';
comment on column ${iol_schema}.icms_ba_personal_loan.insurancevariety is '保险品种';
comment on column ${iol_schema}.icms_ba_personal_loan.isback is '客户是否捞回';
comment on column ${iol_schema}.icms_ba_personal_loan.resetamt is '重置额度';
comment on column ${iol_schema}.icms_ba_personal_loan.housingname is '楼盘名称';
comment on column ${iol_schema}.icms_ba_personal_loan.channelcode is '渠道来源';
comment on column ${iol_schema}.icms_ba_personal_loan.enterprisecode is '经销商企业代码';
comment on column ${iol_schema}.icms_ba_personal_loan.propertytype is '所购房产类型';
comment on column ${iol_schema}.icms_ba_personal_loan.excess is '免赔率';
comment on column ${iol_schema}.icms_ba_personal_loan.isbankrel is '是否与我行存在关联关系';
comment on column ${iol_schema}.icms_ba_personal_loan.ischeckcreditreport is '征信两岗是否点击了查看征信报告按钮:1是，0否';
comment on column ${iol_schema}.icms_ba_personal_loan.housingsum is '房屋套数';
comment on column ${iol_schema}.icms_ba_personal_loan.businessclass is '类别';
comment on column ${iol_schema}.icms_ba_personal_loan.purpose is '用途';
comment on column ${iol_schema}.icms_ba_personal_loan.checkresult is '校验结果';
comment on column ${iol_schema}.icms_ba_personal_loan.insurflag is '是否有保险';
comment on column ${iol_schema}.icms_ba_personal_loan.insurancecontractno is '保险合同编号';
comment on column ${iol_schema}.icms_ba_personal_loan.isexception is '是否例外额度';
comment on column ${iol_schema}.icms_ba_personal_loan.startdate is '审批开始时间';
comment on column ${iol_schema}.icms_ba_personal_loan.callbackurl is '普惠签约回调地址';
comment on column ${iol_schema}.icms_ba_personal_loan.finalresult is '最终风控结果-移动展业赎楼贷';
comment on column ${iol_schema}.icms_ba_personal_loan.housingform is '房屋形式';
comment on column ${iol_schema}.icms_ba_personal_loan.fitmentprice is '装修总价';
comment on column ${iol_schema}.icms_ba_personal_loan.repayinterval is '归还本金间隔';
comment on column ${iol_schema}.icms_ba_personal_loan.indtype is '客户性质';
comment on column ${iol_schema}.icms_ba_personal_loan.taxcode is '纳税人识别号';
comment on column ${iol_schema}.icms_ba_personal_loan.buildingunitprice is '建筑面积单价';
comment on column ${iol_schema}.icms_ba_personal_loan.vehicletype is '车型';
comment on column ${iol_schema}.icms_ba_personal_loan.availexposure is '集团客户名称';
comment on column ${iol_schema}.icms_ba_personal_loan.companyid is '公司客户编号';
comment on column ${iol_schema}.icms_ba_personal_loan.graceperiod is '宽限期（天）';
comment on column ${iol_schema}.icms_ba_personal_loan.personalbusinessloanstype is '个人经营性贷款分类';
comment on column ${iol_schema}.icms_ba_personal_loan.isloananytime is '是否随借随还';
comment on column ${iol_schema}.icms_ba_personal_loan.housingaddress is '房屋详址';
comment on column ${iol_schema}.icms_ba_personal_loan.repayratio is '归还本金比例';
comment on column ${iol_schema}.icms_ba_personal_loan.signaddr is '签署地';
comment on column ${iol_schema}.icms_ba_personal_loan.evaluationcerttype is '评估证件类型';
comment on column ${iol_schema}.icms_ba_personal_loan.paymentobject is '支付对象';
comment on column ${iol_schema}.icms_ba_personal_loan.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_ba_personal_loan.relycompanyname is '自家/挂靠企业名称';
comment on column ${iol_schema}.icms_ba_personal_loan.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_ba_personal_loan.feepayment is '手续费支付方式';
comment on column ${iol_schema}.icms_ba_personal_loan.paymentbasis is '首付款依据';
comment on column ${iol_schema}.icms_ba_personal_loan.propertyunitprice is '物管费单价';
comment on column ${iol_schema}.icms_ba_personal_loan.compcertid is '企业证件号码';
comment on column ${iol_schema}.icms_ba_personal_loan.groupcustcode is '是否集团客户';
comment on column ${iol_schema}.icms_ba_personal_loan.payeeaccountno is '收款人帐号';
comment on column ${iol_schema}.icms_ba_personal_loan.isinsurance is '是否购买保险';
comment on column ${iol_schema}.icms_ba_personal_loan.isopenentsettleaccounts is '是否能够开立单位结算账户';
comment on column ${iol_schema}.icms_ba_personal_loan.compcerttype is '企业证件类型';
comment on column ${iol_schema}.icms_ba_personal_loan.vehicleprice is '汽车总价';
comment on column ${iol_schema}.icms_ba_personal_loan.housinglevel is '房屋等级';
comment on column ${iol_schema}.icms_ba_personal_loan.isbusinessguarantee is '是否合作机构/开发商/经销商担保';
comment on column ${iol_schema}.icms_ba_personal_loan.localstrategicindustry is '本地战略性新兴产业';
comment on column ${iol_schema}.icms_ba_personal_loan.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ba_personal_loan.cusgruoprelation is '借款人与集团关系';
comment on column ${iol_schema}.icms_ba_personal_loan.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ba_personal_loan.relycompanycreditno is '自家/挂靠企业统一社会信用代码';
comment on column ${iol_schema}.icms_ba_personal_loan.baserateadjustper is '基准利率上浮比例';
comment on column ${iol_schema}.icms_ba_personal_loan.feeratio is '手续费率';
comment on column ${iol_schema}.icms_ba_personal_loan.companyquotacontrol is '是否公司额度管控';
comment on column ${iol_schema}.icms_ba_personal_loan.suitesarea is '购房面积（套内面积）';
comment on column ${iol_schema}.icms_ba_personal_loan.isaddamt is '是否提额';
comment on column ${iol_schema}.icms_ba_personal_loan.groupcustname is '集团客户号';
comment on column ${iol_schema}.icms_ba_personal_loan.buildingarea is '购房面积（建筑面积）';
comment on column ${iol_schema}.icms_ba_personal_loan.creditscore is '机评信用等级';
comment on column ${iol_schema}.icms_ba_personal_loan.remark is '备注';
comment on column ${iol_schema}.icms_ba_personal_loan.paymentratio is '首付比例';
comment on column ${iol_schema}.icms_ba_personal_loan.loandirection is '资金投向';
comment on column ${iol_schema}.icms_ba_personal_loan.groupcustomername is '集团客户名称';
comment on column ${iol_schema}.icms_ba_personal_loan.isjgaccount is '是否在我行开立监管账户';
comment on column ${iol_schema}.icms_ba_personal_loan.creditimageupflag is '征信授权书影像上传结果1完成上传2未完成上传';
comment on column ${iol_schema}.icms_ba_personal_loan.creditincrmode is '增信模式标志';
comment on column ${iol_schema}.icms_ba_personal_loan.referrerid is '推荐人ID';
comment on column ${iol_schema}.icms_ba_personal_loan.iswthrmanuactclmt is '是否人工激活额度YesNo';
comment on column ${iol_schema}.icms_ba_personal_loan.recheckflag is '复核标识YesNo';
comment on column ${iol_schema}.icms_ba_personal_loan.consignerid is '委托人ID';
comment on column ${iol_schema}.icms_ba_personal_loan.ishouseinguangdong is '委托人ID';
comment on column ${iol_schema}.icms_ba_personal_loan.worktype is '委托人ID';
comment on column ${iol_schema}.icms_ba_personal_loan.bigloanpurpose is '贷款用途大类';
comment on column ${iol_schema}.icms_ba_personal_loan.title is '标题';
comment on column ${iol_schema}.icms_ba_personal_loan.riskcontrolback is '风控背景';
comment on column ${iol_schema}.icms_ba_personal_loan.cuscreditscore is '客户信用分数:内评';
comment on column ${iol_schema}.icms_ba_personal_loan.cuscreditscorelevel is '客户信用分数等级';
comment on column ${iol_schema}.icms_ba_personal_loan.cartype is '车辆类型';
comment on column ${iol_schema}.icms_ba_personal_loan.greenloanpurpose is '绿色贷款用途';
comment on column ${iol_schema}.icms_ba_personal_loan.companytype is '企业规模';
comment on column ${iol_schema}.icms_ba_personal_loan.employments is '从业人员';
comment on column ${iol_schema}.icms_ba_personal_loan.busiincome is '营业收入';
comment on column ${iol_schema}.icms_ba_personal_loan.assetstotal is '资产总额';
comment on column ${iol_schema}.icms_ba_personal_loan.industry is '所属行业';
comment on column ${iol_schema}.icms_ba_personal_loan.custcreditlevel is '客户风险等级';
comment on column ${iol_schema}.icms_ba_personal_loan.loanpurposedetails is '贷款用途细类字段';
comment on column ${iol_schema}.icms_ba_personal_loan.highindustry is '高技术产业';
comment on column ${iol_schema}.icms_ba_personal_loan.economyindustry is '数字经济核心产业';
comment on column ${iol_schema}.icms_ba_personal_loan.intellectualindustry is '投向知识产权密集型产业';
comment on column ${iol_schema}.icms_ba_personal_loan.cultureindustry is '投向文化及相关产业';
comment on column ${iol_schema}.icms_ba_personal_loan.isagriculture is '是否涉农';
comment on column ${iol_schema}.icms_ba_personal_loan.strategicindustry is '';
comment on column ${iol_schema}.icms_ba_personal_loan.custlabel is '';
comment on column ${iol_schema}.icms_ba_personal_loan.warninginfo is '';
comment on column ${iol_schema}.icms_ba_personal_loan.subgreenconsumeloanpurpose is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isoperatingentinvolvespecialized is '';
comment on column ${iol_schema}.icms_ba_personal_loan.ishightechnologyent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.istechnologyent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isscientifictechent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isspecializedgiantent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isspecializedsmallandmident is '';
comment on column ${iol_schema}.icms_ba_personal_loan.istechnologysmallandmident is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isindustrysinglechampionent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isnationaltechnologinnovationent is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isgarden is '';
comment on column ${iol_schema}.icms_ba_personal_loan.productchannel is '';
comment on column ${iol_schema}.icms_ba_personal_loan.iscentralizedofficestaff is '';
comment on column ${iol_schema}.icms_ba_personal_loan.cobsratio is '';
comment on column ${iol_schema}.icms_ba_personal_loan.workingmonth is '';
comment on column ${iol_schema}.icms_ba_personal_loan.flowbranchtype is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isicmsfactory is '';
comment on column ${iol_schema}.icms_ba_personal_loan.guaranteecompanyname is '';
comment on column ${iol_schema}.icms_ba_personal_loan.runentyearincome is '';
comment on column ${iol_schema}.icms_ba_personal_loan.lastyearentyearincome is '';
comment on column ${iol_schema}.icms_ba_personal_loan.yearincomerate is '';
comment on column ${iol_schema}.icms_ba_personal_loan.operationloanbalanceskr is '';
comment on column ${iol_schema}.icms_ba_personal_loan.otherworkcaptial is '';
comment on column ${iol_schema}.icms_ba_personal_loan.isrelatedcompany is '';
comment on column ${iol_schema}.icms_ba_personal_loan.intentguaramt is '';
comment on column ${iol_schema}.icms_ba_personal_loan.guarcompanyterm is '';
comment on column ${iol_schema}.icms_ba_personal_loan.comptaxgrade is '';
comment on column ${iol_schema}.icms_ba_personal_loan.iscompanyrelatedperson is '';
comment on column ${iol_schema}.icms_ba_personal_loan.recommendedamt is '';
comment on column ${iol_schema}.icms_ba_personal_loan.recommendedterm is '';
comment on column ${iol_schema}.icms_ba_personal_loan.otherlimitflag is '';
comment on column ${iol_schema}.icms_ba_personal_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ba_personal_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ba_personal_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ba_personal_loan.etl_timestamp is 'ETL处理时间戳';
