/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_guaranty_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_guaranty_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_guaranty_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_guaranty_contract(
    guarantyno varchar2(50) -- 担保合同编号
    ,registationcode varchar2(3) -- 注册国家/地区代码
    ,checkguarantymanb varchar2(400) -- 核保人二）
    ,inputorgid varchar2(64) -- 登记机构
    ,creditorgid varchar2(40) -- 债权人机构代码
    ,partyblegalperson varchar2(80) -- 借款人法定代表人
    ,signdate varchar2(20) -- 协议签定日期
    ,checkguarantyman2 varchar2(80) -- 核保人（二）
    ,iscustody varchar2(1) -- 是否代保管
    ,currency3 varchar2(2) -- 担保债务币种2
    ,begindate varchar2(20) -- 合同生效日
    ,checkguarantydate varchar2(20) -- 核保日期
    ,secondcreditcurrency varchar2(2) -- 被授信币种2
    ,financeitem7 varchar2(500) -- 债务权益比率（当期总负债／当期净资产）不高于
    ,reception varchar2(80) -- 接待人姓名
    ,channelflag varchar2(24) -- 渠道标志
    ,guarbalance number(20,2) -- 可用余额
    ,authostrdate varchar2(20) -- 授权起始日
    ,guarantyorsum number(18,2) -- 保证人净资产
    ,pigeonholedate varchar2(10) -- 归档日
    ,maincontractsum number(24,6) -- 主合同金额
    ,isquerycreditreport varchar2(10) -- 是否自动查询贷后报告
    ,totalcopies varchar2(10) -- 合同总份数
    ,partybpostcode varchar2(10) -- 借款人邮编
    ,shortorg varchar2(20) -- 机构简称
    ,guarantyinfo varchar2(1000) -- 担保物概况
    ,firstcreditsum number(24,6) -- 被授信金额一
    ,contractsum1 number(24,6) -- 担保债务本金1
    ,creditorgname varchar2(200) -- 债权人机构名称
    ,contractname varchar2(40) -- 合同名称1
    ,guarantystyle varchar2(12) -- 担保方式
    ,istranguaranty varchar2(4) -- 是否包含反担保措施
    ,thirdcreditsum number(24,6) -- 被授信金额3
    ,quoteguarantyquotano varchar2(32) -- 引入担保额度流水号
    ,partybfax varchar2(20) -- 借款人传真
    ,guarantyphone varchar2(20) -- 保证人电话
    ,ypguarantorid varchar2(64) -- 押品系统保证人id
    ,enddate varchar2(20) -- 合同到期日
    ,otherdescsribe varchar2(1000) -- 其它特别约定
    ,contractno1 varchar2(20) -- 合同号1
    ,maincontractcurrency varchar2(10) -- 主合同币种
    ,otherguarantyperiod2 varchar2(4000) -- 其他保证期间2
    ,partyaprincipal varchar2(40) -- 贷款人负责人
    ,guarantyvalue number(24,6) -- 担保总金额
    ,industrytype varchar2(5) -- 所属行业类型
    ,thirdcreditparty varchar2(40) -- 被授信人3
    ,creditauthno varchar2(200) -- 征信查询授权书编号
    ,begintime varchar2(10) -- 担保起始日
    ,certtype varchar2(4) -- 担保人证件类型
    ,guarterm number(30,0) -- 担保期限(月)
    ,econtracttype varchar2(10) -- 电子合同类型
    ,firstcreditcurrency varchar2(2) -- 被授信币种一
    ,printflag varchar2(10) -- 追加担保合同打印标志
    ,othername varchar2(80) -- 其他名称
    ,financeitem6 varchar2(500) -- 负债率（当期总负债／当期总资产）不高于
    ,customerid varchar2(32) -- 被担保人客户号
    ,contractname2 varchar2(40) -- 合同名称2
    ,partybcerttype varchar2(10) -- 借款人证件种类
    ,guarantycurrency varchar2(3) -- 担保币种
    ,usesum number(20,2) -- 已担保金额
    ,endtime varchar2(10) -- 担保到期日
    ,currency4 varchar2(2) -- 担保债务币种3
    ,currency2 varchar2(2) -- 合同币种2
    ,guarantyopinion varchar2(1000) -- 担保意见
    ,contractno2 varchar2(20) -- 合同号2
    ,customerownership varchar2(3) -- 客户所有制类型
    ,otherguarantyrange varchar2(4000) -- 其他担保范围
    ,textmaincontractno varchar2(80) -- 主合同文本编号
    ,guarantyaddress varchar2(80) -- 保证人地址
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,inputdate date -- 登记日期
    ,thirdcreditcurrency varchar2(2) -- 被授信币种3
    ,partyacopies varchar2(10) -- 甲方执合同份数
    ,quoteguarantyquota varchar2(2) -- 是否占用担保额度
    ,enterprisescope varchar2(18) -- 企业规模
    ,guarantyrange varchar2(1) -- 担保范围
    ,obligeeid varchar2(40) -- 权利人客户编号
    ,contractword2 varchar2(20) -- 合同机构简称+编号类型2
    ,certid varchar2(60) -- 担保人证件号码
    ,orgname varchar2(200) -- 机构名称
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,residentflag varchar2(1) -- 居民标志
    ,guarantorid varchar2(60) -- 担保人编号
    ,guaranteeform varchar2(12) -- 保证担保形式
    ,receptionduty varchar2(80) -- 接待人职务
    ,firstcreditparty varchar2(40) -- 被授信人一
    ,contractsum2 number(24,6) -- 合同本金2
    ,compensatetype varchar2(1) -- 清偿处理方式
    ,partyaduty varchar2(40) -- 贷款人负责人职务
    ,guartorcate varchar2(2) -- 担保人类别
    ,bailratio number(24,6) -- 保证金比例
    ,otherguarantyperiod1 varchar2(200) -- 其他保证期间1
    ,updateuserid varchar2(64) -- 更新人
    ,guarantyfax varchar2(20) -- 保证人传真
    ,partybname varchar2(80) -- 借款人名称
    ,updateorgid varchar2(64) -- 更新机构
    ,partyaphone varchar2(20) -- 债权人电话
    ,issaveowner varchar2(1) -- 是否直接向我行担保
    ,partybphone varchar2(20) -- 借款人电话
    ,commondate varchar2(10) -- 通用日期
    ,contractsum3 number(24,6) -- 担保债务金额
    ,ectempsaveflag varchar2(10) -- 暂存标志
    ,transfercreditrange varchar2(4000) -- 被转贷款人范围
    ,partybcertid varchar2(40) -- 借款人证件号码
    ,contractsum4 number(24,6) -- 担保债务金额3
    ,secondcreditsum number(24,6) -- 被授信金额2
    ,otherparties varchar2(40) -- 其余各方当事人及有关登记部门
    ,checkguarantymana varchar2(400) -- 核保人一）
    ,updatedate date -- 更新日期
    ,partyaaddress varchar2(80) -- 贷款人地址
    ,ecodepartmentcode varchar2(18) -- 国民经济部门
    ,vouchtype varchar2(20) -- 主担保方式
    ,preserialno varchar2(40) -- 被拷贝的担保流水号
    ,partybduty varchar2(40) -- 借款人法定代表人职务
    ,guarantorname varchar2(200) -- 担保人名称
    ,loancardno varchar2(64) -- 担保人贷款卡编号
    ,secondcreditparty varchar2(40) -- 被授信人2
    ,otherpromise varchar2(4000) -- 约定其他事项
    ,notarizationflag varchar2(1) -- 是否强制执行公证
    ,partybaddress varchar2(200) -- 借款人地址
    ,contractword varchar2(20) -- 合同机构简称+编号类型1
    ,guarantytype varchar2(6) -- 一般担保合同、最高额担保合同
    ,guarantystatus varchar2(12) -- 担保合同状态
    ,inputuserid varchar2(64) -- 登记人
    ,guarantyperiod varchar2(1) -- 保证期间
    ,newregioncode varchar2(18) -- 注册地行政区划代码
    ,creditaggreement varchar2(36) -- 额度协议流水号
    ,currency1 varchar2(2) -- 担保债务币种1
    ,guarantytype2 varchar2(20) -- 担保类型分类
    ,corporgid varchar2(64) -- 法人机构编号
    ,obligeename varchar2(40) -- 权利人名称
    ,partyafax varchar2(20) -- 贷款人传真
    ,textcontractno varchar2(120) -- 文本合同编号
    ,maincontractname varchar2(80) -- 主合同名称
    ,remark varchar2(1000) -- 备注
    ,customerriskactualrate number(24,6) -- 客户风险实际抵质押率
    ,approvalandpledgerate number(15,8) -- 审批抵质押率
    ,maximumguarability number(24,6) -- 保证人保证能力上限
    ,isguarantyplatformloan varchar2(4) -- 是否政府性融资担保公司保证（1-是，2-否）
    ,isbackguaranty varchar2(2) -- 是否反担保
    ,clno varchar2(100) -- 
    ,mortgagereceiptno varchar2(64) -- 
    ,encumbranceno varchar2(64) -- 
    ,registcountryresult varchar2(225) -- 保证人注册地所在国家或地区外部评级结果
    ,outratingdate date -- 保证人外部评级日期
    ,outratingresult varchar2(225) -- 保证人外部评级结果
    ,inratingdate date -- 保证人内部评级日期
    ,inratingresult varchar2(225) -- 保证人内部评级结果
    ,guarcash number(24,6) -- 担保公司保证金金额
    ,isstage varchar2(6) -- 是否阶段性担保
    ,insuranceno varchar2(135) -- 保证保险保单号码
    ,purpose varchar2(6) -- 保证目的
    ,independence varchar2(6) -- 保证人担保独立性
    ,netasset number(24,6) -- 保证人净资产
    ,netassetcurrency varchar2(18) -- 保证人净资产币种
    ,orgtype varchar2(6) -- 开立机构类型（保函）\开证机构类型（信用证）
    ,iscancel varchar2(6) -- 是否不可撤销
    ,letterno varchar2(40) -- 保函编号/备用信用证编号
    ,lettertype varchar2(6) -- 保函类型
    ,lettercontry varchar2(3) -- 证书开具国别/开证国别
    ,lettersum number(22,2) -- 保函金额/备用信用证金额
    ,lettercurrency varchar2(18) -- 保函币种/备用信用证币种
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
grant select on ${iol_schema}.icms_guaranty_contract to ${iml_schema};
grant select on ${iol_schema}.icms_guaranty_contract to ${icl_schema};
grant select on ${iol_schema}.icms_guaranty_contract to ${idl_schema};
grant select on ${iol_schema}.icms_guaranty_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_guaranty_contract is '担保合同表';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyno is '担保合同编号';
comment on column ${iol_schema}.icms_guaranty_contract.registationcode is '注册国家/地区代码';
comment on column ${iol_schema}.icms_guaranty_contract.checkguarantymanb is '核保人二）';
comment on column ${iol_schema}.icms_guaranty_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_guaranty_contract.creditorgid is '债权人机构代码';
comment on column ${iol_schema}.icms_guaranty_contract.partyblegalperson is '借款人法定代表人';
comment on column ${iol_schema}.icms_guaranty_contract.signdate is '协议签定日期';
comment on column ${iol_schema}.icms_guaranty_contract.checkguarantyman2 is '核保人（二）';
comment on column ${iol_schema}.icms_guaranty_contract.iscustody is '是否代保管';
comment on column ${iol_schema}.icms_guaranty_contract.currency3 is '担保债务币种2';
comment on column ${iol_schema}.icms_guaranty_contract.begindate is '合同生效日';
comment on column ${iol_schema}.icms_guaranty_contract.checkguarantydate is '核保日期';
comment on column ${iol_schema}.icms_guaranty_contract.secondcreditcurrency is '被授信币种2';
comment on column ${iol_schema}.icms_guaranty_contract.financeitem7 is '债务权益比率（当期总负债／当期净资产）不高于';
comment on column ${iol_schema}.icms_guaranty_contract.reception is '接待人姓名';
comment on column ${iol_schema}.icms_guaranty_contract.channelflag is '渠道标志';
comment on column ${iol_schema}.icms_guaranty_contract.guarbalance is '可用余额';
comment on column ${iol_schema}.icms_guaranty_contract.authostrdate is '授权起始日';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyorsum is '保证人净资产';
comment on column ${iol_schema}.icms_guaranty_contract.pigeonholedate is '归档日';
comment on column ${iol_schema}.icms_guaranty_contract.maincontractsum is '主合同金额';
comment on column ${iol_schema}.icms_guaranty_contract.isquerycreditreport is '是否自动查询贷后报告';
comment on column ${iol_schema}.icms_guaranty_contract.totalcopies is '合同总份数';
comment on column ${iol_schema}.icms_guaranty_contract.partybpostcode is '借款人邮编';
comment on column ${iol_schema}.icms_guaranty_contract.shortorg is '机构简称';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyinfo is '担保物概况';
comment on column ${iol_schema}.icms_guaranty_contract.firstcreditsum is '被授信金额一';
comment on column ${iol_schema}.icms_guaranty_contract.contractsum1 is '担保债务本金1';
comment on column ${iol_schema}.icms_guaranty_contract.creditorgname is '债权人机构名称';
comment on column ${iol_schema}.icms_guaranty_contract.contractname is '合同名称1';
comment on column ${iol_schema}.icms_guaranty_contract.guarantystyle is '担保方式';
comment on column ${iol_schema}.icms_guaranty_contract.istranguaranty is '是否包含反担保措施';
comment on column ${iol_schema}.icms_guaranty_contract.thirdcreditsum is '被授信金额3';
comment on column ${iol_schema}.icms_guaranty_contract.quoteguarantyquotano is '引入担保额度流水号';
comment on column ${iol_schema}.icms_guaranty_contract.partybfax is '借款人传真';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyphone is '保证人电话';
comment on column ${iol_schema}.icms_guaranty_contract.ypguarantorid is '押品系统保证人id';
comment on column ${iol_schema}.icms_guaranty_contract.enddate is '合同到期日';
comment on column ${iol_schema}.icms_guaranty_contract.otherdescsribe is '其它特别约定';
comment on column ${iol_schema}.icms_guaranty_contract.contractno1 is '合同号1';
comment on column ${iol_schema}.icms_guaranty_contract.maincontractcurrency is '主合同币种';
comment on column ${iol_schema}.icms_guaranty_contract.otherguarantyperiod2 is '其他保证期间2';
comment on column ${iol_schema}.icms_guaranty_contract.partyaprincipal is '贷款人负责人';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyvalue is '担保总金额';
comment on column ${iol_schema}.icms_guaranty_contract.industrytype is '所属行业类型';
comment on column ${iol_schema}.icms_guaranty_contract.thirdcreditparty is '被授信人3';
comment on column ${iol_schema}.icms_guaranty_contract.creditauthno is '征信查询授权书编号';
comment on column ${iol_schema}.icms_guaranty_contract.begintime is '担保起始日';
comment on column ${iol_schema}.icms_guaranty_contract.certtype is '担保人证件类型';
comment on column ${iol_schema}.icms_guaranty_contract.guarterm is '担保期限(月)';
comment on column ${iol_schema}.icms_guaranty_contract.econtracttype is '电子合同类型';
comment on column ${iol_schema}.icms_guaranty_contract.firstcreditcurrency is '被授信币种一';
comment on column ${iol_schema}.icms_guaranty_contract.printflag is '追加担保合同打印标志';
comment on column ${iol_schema}.icms_guaranty_contract.othername is '其他名称';
comment on column ${iol_schema}.icms_guaranty_contract.financeitem6 is '负债率（当期总负债／当期总资产）不高于';
comment on column ${iol_schema}.icms_guaranty_contract.customerid is '被担保人客户号';
comment on column ${iol_schema}.icms_guaranty_contract.contractname2 is '合同名称2';
comment on column ${iol_schema}.icms_guaranty_contract.partybcerttype is '借款人证件种类';
comment on column ${iol_schema}.icms_guaranty_contract.guarantycurrency is '担保币种';
comment on column ${iol_schema}.icms_guaranty_contract.usesum is '已担保金额';
comment on column ${iol_schema}.icms_guaranty_contract.endtime is '担保到期日';
comment on column ${iol_schema}.icms_guaranty_contract.currency4 is '担保债务币种3';
comment on column ${iol_schema}.icms_guaranty_contract.currency2 is '合同币种2';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyopinion is '担保意见';
comment on column ${iol_schema}.icms_guaranty_contract.contractno2 is '合同号2';
comment on column ${iol_schema}.icms_guaranty_contract.customerownership is '客户所有制类型';
comment on column ${iol_schema}.icms_guaranty_contract.otherguarantyrange is '其他担保范围';
comment on column ${iol_schema}.icms_guaranty_contract.textmaincontractno is '主合同文本编号';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyaddress is '保证人地址';
comment on column ${iol_schema}.icms_guaranty_contract.isinuse is '添加维护标志1正常2不维护';
comment on column ${iol_schema}.icms_guaranty_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_guaranty_contract.thirdcreditcurrency is '被授信币种3';
comment on column ${iol_schema}.icms_guaranty_contract.partyacopies is '甲方执合同份数';
comment on column ${iol_schema}.icms_guaranty_contract.quoteguarantyquota is '是否占用担保额度';
comment on column ${iol_schema}.icms_guaranty_contract.enterprisescope is '企业规模';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyrange is '担保范围';
comment on column ${iol_schema}.icms_guaranty_contract.obligeeid is '权利人客户编号';
comment on column ${iol_schema}.icms_guaranty_contract.contractword2 is '合同机构简称+编号类型2';
comment on column ${iol_schema}.icms_guaranty_contract.certid is '担保人证件号码';
comment on column ${iol_schema}.icms_guaranty_contract.orgname is '机构名称';
comment on column ${iol_schema}.icms_guaranty_contract.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_guaranty_contract.residentflag is '居民标志';
comment on column ${iol_schema}.icms_guaranty_contract.guarantorid is '担保人编号';
comment on column ${iol_schema}.icms_guaranty_contract.guaranteeform is '保证担保形式';
comment on column ${iol_schema}.icms_guaranty_contract.receptionduty is '接待人职务';
comment on column ${iol_schema}.icms_guaranty_contract.firstcreditparty is '被授信人一';
comment on column ${iol_schema}.icms_guaranty_contract.contractsum2 is '合同本金2';
comment on column ${iol_schema}.icms_guaranty_contract.compensatetype is '清偿处理方式';
comment on column ${iol_schema}.icms_guaranty_contract.partyaduty is '贷款人负责人职务';
comment on column ${iol_schema}.icms_guaranty_contract.guartorcate is '担保人类别';
comment on column ${iol_schema}.icms_guaranty_contract.bailratio is '保证金比例';
comment on column ${iol_schema}.icms_guaranty_contract.otherguarantyperiod1 is '其他保证期间1';
comment on column ${iol_schema}.icms_guaranty_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyfax is '保证人传真';
comment on column ${iol_schema}.icms_guaranty_contract.partybname is '借款人名称';
comment on column ${iol_schema}.icms_guaranty_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_guaranty_contract.partyaphone is '债权人电话';
comment on column ${iol_schema}.icms_guaranty_contract.issaveowner is '是否直接向我行担保';
comment on column ${iol_schema}.icms_guaranty_contract.partybphone is '借款人电话';
comment on column ${iol_schema}.icms_guaranty_contract.commondate is '通用日期';
comment on column ${iol_schema}.icms_guaranty_contract.contractsum3 is '担保债务金额';
comment on column ${iol_schema}.icms_guaranty_contract.ectempsaveflag is '暂存标志';
comment on column ${iol_schema}.icms_guaranty_contract.transfercreditrange is '被转贷款人范围';
comment on column ${iol_schema}.icms_guaranty_contract.partybcertid is '借款人证件号码';
comment on column ${iol_schema}.icms_guaranty_contract.contractsum4 is '担保债务金额3';
comment on column ${iol_schema}.icms_guaranty_contract.secondcreditsum is '被授信金额2';
comment on column ${iol_schema}.icms_guaranty_contract.otherparties is '其余各方当事人及有关登记部门';
comment on column ${iol_schema}.icms_guaranty_contract.checkguarantymana is '核保人一）';
comment on column ${iol_schema}.icms_guaranty_contract.updatedate is '更新日期';
comment on column ${iol_schema}.icms_guaranty_contract.partyaaddress is '贷款人地址';
comment on column ${iol_schema}.icms_guaranty_contract.ecodepartmentcode is '国民经济部门';
comment on column ${iol_schema}.icms_guaranty_contract.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_guaranty_contract.preserialno is '被拷贝的担保流水号';
comment on column ${iol_schema}.icms_guaranty_contract.partybduty is '借款人法定代表人职务';
comment on column ${iol_schema}.icms_guaranty_contract.guarantorname is '担保人名称';
comment on column ${iol_schema}.icms_guaranty_contract.loancardno is '担保人贷款卡编号';
comment on column ${iol_schema}.icms_guaranty_contract.secondcreditparty is '被授信人2';
comment on column ${iol_schema}.icms_guaranty_contract.otherpromise is '约定其他事项';
comment on column ${iol_schema}.icms_guaranty_contract.notarizationflag is '是否强制执行公证';
comment on column ${iol_schema}.icms_guaranty_contract.partybaddress is '借款人地址';
comment on column ${iol_schema}.icms_guaranty_contract.contractword is '合同机构简称+编号类型1';
comment on column ${iol_schema}.icms_guaranty_contract.guarantytype is '一般担保合同、最高额担保合同';
comment on column ${iol_schema}.icms_guaranty_contract.guarantystatus is '担保合同状态';
comment on column ${iol_schema}.icms_guaranty_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_guaranty_contract.guarantyperiod is '保证期间';
comment on column ${iol_schema}.icms_guaranty_contract.newregioncode is '注册地行政区划代码';
comment on column ${iol_schema}.icms_guaranty_contract.creditaggreement is '额度协议流水号';
comment on column ${iol_schema}.icms_guaranty_contract.currency1 is '担保债务币种1';
comment on column ${iol_schema}.icms_guaranty_contract.guarantytype2 is '担保类型分类';
comment on column ${iol_schema}.icms_guaranty_contract.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_guaranty_contract.obligeename is '权利人名称';
comment on column ${iol_schema}.icms_guaranty_contract.partyafax is '贷款人传真';
comment on column ${iol_schema}.icms_guaranty_contract.textcontractno is '文本合同编号';
comment on column ${iol_schema}.icms_guaranty_contract.maincontractname is '主合同名称';
comment on column ${iol_schema}.icms_guaranty_contract.remark is '备注';
comment on column ${iol_schema}.icms_guaranty_contract.customerriskactualrate is '客户风险实际抵质押率';
comment on column ${iol_schema}.icms_guaranty_contract.approvalandpledgerate is '审批抵质押率';
comment on column ${iol_schema}.icms_guaranty_contract.maximumguarability is '保证人保证能力上限';
comment on column ${iol_schema}.icms_guaranty_contract.isguarantyplatformloan is '是否政府性融资担保公司保证（1-是，2-否）';
comment on column ${iol_schema}.icms_guaranty_contract.isbackguaranty is '是否反担保';
comment on column ${iol_schema}.icms_guaranty_contract.clno is '';
comment on column ${iol_schema}.icms_guaranty_contract.mortgagereceiptno is '';
comment on column ${iol_schema}.icms_guaranty_contract.encumbranceno is '';
comment on column ${iol_schema}.icms_guaranty_contract.registcountryresult is '保证人注册地所在国家或地区外部评级结果';
comment on column ${iol_schema}.icms_guaranty_contract.outratingdate is '保证人外部评级日期';
comment on column ${iol_schema}.icms_guaranty_contract.outratingresult is '保证人外部评级结果';
comment on column ${iol_schema}.icms_guaranty_contract.inratingdate is '保证人内部评级日期';
comment on column ${iol_schema}.icms_guaranty_contract.inratingresult is '保证人内部评级结果';
comment on column ${iol_schema}.icms_guaranty_contract.guarcash is '担保公司保证金金额';
comment on column ${iol_schema}.icms_guaranty_contract.isstage is '是否阶段性担保';
comment on column ${iol_schema}.icms_guaranty_contract.insuranceno is '保证保险保单号码';
comment on column ${iol_schema}.icms_guaranty_contract.purpose is '保证目的';
comment on column ${iol_schema}.icms_guaranty_contract.independence is '保证人担保独立性';
comment on column ${iol_schema}.icms_guaranty_contract.netasset is '保证人净资产';
comment on column ${iol_schema}.icms_guaranty_contract.netassetcurrency is '保证人净资产币种';
comment on column ${iol_schema}.icms_guaranty_contract.orgtype is '开立机构类型（保函）\开证机构类型（信用证）';
comment on column ${iol_schema}.icms_guaranty_contract.iscancel is '是否不可撤销';
comment on column ${iol_schema}.icms_guaranty_contract.letterno is '保函编号/备用信用证编号';
comment on column ${iol_schema}.icms_guaranty_contract.lettertype is '保函类型';
comment on column ${iol_schema}.icms_guaranty_contract.lettercontry is '证书开具国别/开证国别';
comment on column ${iol_schema}.icms_guaranty_contract.lettersum is '保函金额/备用信用证金额';
comment on column ${iol_schema}.icms_guaranty_contract.lettercurrency is '保函币种/备用信用证币种';
comment on column ${iol_schema}.icms_guaranty_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_guaranty_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_guaranty_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_guaranty_contract.etl_timestamp is 'ETL处理时间戳';
