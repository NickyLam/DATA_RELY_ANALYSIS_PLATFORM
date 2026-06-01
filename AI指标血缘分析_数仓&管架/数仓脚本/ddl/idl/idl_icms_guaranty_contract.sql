/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_guaranty_contract
CreateDate: 20221228
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_guaranty_contract purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_guaranty_contract(
etl_dt date --ETL处理日期
,checkguarantydate varchar2(20) --核保日期
,checkguarantymana varchar2(400) --核保人;一）
,checkguarantymanb varchar2(400) --核保人;二）
,certtype varchar2(4) --担保人证件类型
,certid varchar2(60) --担保人证件号码
,loancardno varchar2(64) --担保人贷款卡编号
,guaranteeform varchar2(12) --保证担保形式
,inputorgid varchar2(64) --登记机构
,inputuserid varchar2(64) --登记人
,inputdate date --登记日期
,updateorgid varchar2(64) --更新机构
,updateuserid varchar2(64) --更新人
,updatedate date --更新日期
,remark varchar2(1000) --备注
,corporgid varchar2(64) --法人机构编号
,authostrdate varchar2(20) --授权起始日
,istranguaranty varchar2(4) --是否包含反担保措施
,isquerycreditreport varchar2(10) --征信查询授权书编号
,creditauthno varchar2(200) --征信查询授权书编号
,industrytype varchar2(5) --国标行业分类
,enterprisescope varchar2(18) --企业规模
,ecodepartmentcode varchar2(18) --国民经济部门
,newregioncode varchar2(18) --注册地行政区划代码
,issaveowner varchar2(1) --是否直接向我行担保
,obligeename varchar2(40) --权利人名称
,obligeeid varchar2(40) --权利人客户编号
,iscustody varchar2(1) --是否代保管
,residentflag varchar2(1) --居民标志
,registationcode varchar2(3) --注册国家/地区代码
,guarantyorsum number(18,2) --保证人净资产
,ypguarantorid varchar2(64) --押品系统保证人id
,guarantyfax varchar2(20) --保证人传真
,guarantyphone varchar2(20) --保证人电话
,guarantyaddress varchar2(80) --保证人地址
,isinuse varchar2(1) --添加维护标志1正常2不维护
,preserialno varchar2(40) --被拷贝的担保流水号
,creditaggreement varchar2(36) --额度协议流水号
,thirdcreditsum number(24,6) --被授信金额3
,thirdcreditcurrency varchar2(2) --被授信币种3
,thirdcreditparty varchar2(40) --被授信人3
,secondcreditsum number(24,6) --被授信金额2
,secondcreditcurrency varchar2(2) --被授信币种2
,secondcreditparty varchar2(40) --被授信人2
,firstcreditsum number(24,6) --被授信金额一
,firstcreditcurrency varchar2(2) --被授信币种一
,firstcreditparty varchar2(40) --被授信人一
,contractsum4 number(24,6) --担保债务金额3
,currency4 varchar2(2) --担保债务币种3
,contractsum3 number(24,6) --担保债务金额
,currency3 varchar2(2) --担保债务币种2
,contractsum2 number(24,6) --合同本金2
,currency2 varchar2(2) --合同币种2
,contractname2 varchar2(40) --合同名称2
,contractno2 varchar2(20) --合同号2
,contractword2 varchar2(20) --合同机构简称+编号类型2
,contractsum1 number(24,6) --担保债务本金1
,currency1 varchar2(2) --担保债务币种1
,contractname varchar2(40) --合同名称1
,contractno1 varchar2(20) --合同号1
,contractword varchar2(20) --合同机构简称+编号类型1
,partyacopies varchar2(10) --甲方执合同份数
,totalcopies varchar2(10) --合同总份数
,quoteguarantyquotano varchar2(32) --引入担保额度流水号
,quoteguarantyquota varchar2(2) --是否占用担保额度
,pigeonholedate varchar2(10) --归档日
,printflag varchar2(10) --追加担保合同打印标志
,guarantytype2 varchar2(20) --担保类型分类
,financeitem6 varchar2(500) --负债率（当期总负债／当期总资产）不高于
,financeitem7 varchar2(500) --债务权益比率（当期总负债／当期净资产）不高于
,endtime varchar2(10) --担保到期日
,begintime varchar2(10) --担保起始日
,transfercreditrange varchar2(4000) --被转贷款人范围
,compensatetype varchar2(1) --清偿处理方式
,maincontractsum number(24,6) --主合同金额
,maincontractcurrency varchar2(10) --主合同币种
,maincontractname varchar2(80) --主合同名称
,otherparties varchar2(40) --其余各方当事人及有关登记部门
,otherpromise varchar2(4000) --约定其他事项
,notarizationflag varchar2(1) --是否强制执行公证
,otherguarantyperiod2 varchar2(4000) --其他保证期间2
,otherguarantyperiod1 varchar2(200) --其他保证期间1
,guarantyperiod varchar2(1) --保证期间
,otherguarantyrange varchar2(4000) --其他担保范围
,guarantyrange varchar2(1) --担保范围
,textmaincontractno varchar2(80) --主合同文本编号
,partybduty varchar2(40) --借款人法定代表人职务
,partybpostcode varchar2(10) --借款人邮编
,partyblegalperson varchar2(80) --借款人法定代表人
,partybfax varchar2(20) --借款人传真
,partybphone varchar2(20) --借款人电话
,partybaddress varchar2(200) --借款人地址
,partybcertid varchar2(40) --借款人证件号码
,partybcerttype varchar2(10) --借款人证件种类
,partybname varchar2(80) --借款人名称
,partyaduty varchar2(40) --贷款人负责人职务
,partyaprincipal varchar2(40) --贷款人负责人
,partyafax varchar2(20) --贷款人传真
,partyaphone varchar2(20) --债权人电话
,partyaaddress varchar2(80) --贷款人地址
,orgname varchar2(200) --机构名称
,shortorg varchar2(20) --机构简称
,textcontractno varchar2(120) --文本合同编号
,ectempsaveflag varchar2(10) --暂存标志
,econtracttype varchar2(10) --电子合同类型
,vouchtype varchar2(20) --主要担保方式
,bailratio number(24,6) --保证金比例
,commondate varchar2(10) --通用日期
,othername varchar2(80) --其他名称
,checkguarantyman2 varchar2(80) --核保人（二）
,receptionduty varchar2(80) --接待人职务
,reception varchar2(80) --接待人姓名
,creditorgname varchar2(200) --债权人机构名称
,creditorgid varchar2(40) --债权人机构代码
,customerownership varchar2(3) --客户所有制类型
,channelflag varchar2(24) --渠道标志
,guarterm number(30,0) --
,usesum number(20,2) --
,guarbalance number(20,2) --
,guarantyno varchar2(50) --担保合同编号
,guarantytype varchar2(6) --一般担保合同、最高额担保合同
,guarantystyle varchar2(12) --担保方式
,guarantystatus varchar2(12) --担保合同状态
,signdate varchar2(20) --协议签定日期
,begindate varchar2(20) --合同生效日
,enddate varchar2(20) --合同到期日
,customerid varchar2(32) --被担保人客户号
,guarantorid varchar2(60) --担保人编号
,guarantorname varchar2(200) --担保人名称
,guarantycurrency varchar2(3) --担保币种
,guarantyvalue number(24,6) --担保总金额
,guarantyinfo varchar2(1000) --担保物概况
,otherdescsribe varchar2(1000) --其它特别约定
,guarantyopinion varchar2(1000) --担保意见
,start_dt date --开始日期
,end_dt date --结束日期
,id_mark varchar2(10) --删除标识
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,guartorcate varchar2(2) --微贷担保类型
,etl_timestamp               timestamp(6)     -- 任务处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_guaranty_contract to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_guaranty_contract is '担保合同类型';
comment on column ${idl_schema}.icms_guaranty_contract.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.icms_guaranty_contract.checkguarantydate is '核保日期';
comment on column ${idl_schema}.icms_guaranty_contract.checkguarantymana is '核保人;一）';
comment on column ${idl_schema}.icms_guaranty_contract.checkguarantymanb is '核保人;二）';
comment on column ${idl_schema}.icms_guaranty_contract.certtype is '担保人证件类型';
comment on column ${idl_schema}.icms_guaranty_contract.certid is '担保人证件号码';
comment on column ${idl_schema}.icms_guaranty_contract.loancardno is '担保人贷款卡编号';
comment on column ${idl_schema}.icms_guaranty_contract.guaranteeform is '保证担保形式';
comment on column ${idl_schema}.icms_guaranty_contract.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_guaranty_contract.inputuserid is '登记人';
comment on column ${idl_schema}.icms_guaranty_contract.inputdate is '登记日期';
comment on column ${idl_schema}.icms_guaranty_contract.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_guaranty_contract.updateuserid is '更新人';
comment on column ${idl_schema}.icms_guaranty_contract.updatedate is '更新日期';
comment on column ${idl_schema}.icms_guaranty_contract.remark is '备注';
comment on column ${idl_schema}.icms_guaranty_contract.corporgid is '法人机构编号';
comment on column ${idl_schema}.icms_guaranty_contract.authostrdate is '授权起始日';
comment on column ${idl_schema}.icms_guaranty_contract.istranguaranty is '是否包含反担保措施';
comment on column ${idl_schema}.icms_guaranty_contract.isquerycreditreport is '征信查询授权书编号';
comment on column ${idl_schema}.icms_guaranty_contract.creditauthno is '征信查询授权书编号';
comment on column ${idl_schema}.icms_guaranty_contract.industrytype is '国标行业分类';
comment on column ${idl_schema}.icms_guaranty_contract.enterprisescope is '企业规模';
comment on column ${idl_schema}.icms_guaranty_contract.ecodepartmentcode is '国民经济部门';
comment on column ${idl_schema}.icms_guaranty_contract.newregioncode is '注册地行政区划代码';
comment on column ${idl_schema}.icms_guaranty_contract.issaveowner is '是否直接向我行担保';
comment on column ${idl_schema}.icms_guaranty_contract.obligeename is '权利人名称';
comment on column ${idl_schema}.icms_guaranty_contract.obligeeid is '权利人客户编号';
comment on column ${idl_schema}.icms_guaranty_contract.iscustody is '是否代保管';
comment on column ${idl_schema}.icms_guaranty_contract.residentflag is '居民标志';
comment on column ${idl_schema}.icms_guaranty_contract.registationcode is '注册国家/地区代码';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyorsum is '保证人净资产';
comment on column ${idl_schema}.icms_guaranty_contract.ypguarantorid is '押品系统保证人id';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyfax is '保证人传真';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyphone is '保证人电话';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyaddress is '保证人地址';
comment on column ${idl_schema}.icms_guaranty_contract.isinuse is '添加维护标志1正常2不维护';
comment on column ${idl_schema}.icms_guaranty_contract.preserialno is '被拷贝的担保流水号';
comment on column ${idl_schema}.icms_guaranty_contract.creditaggreement is '额度协议流水号';
comment on column ${idl_schema}.icms_guaranty_contract.thirdcreditsum is '被授信金额3';
comment on column ${idl_schema}.icms_guaranty_contract.thirdcreditcurrency is '被授信币种3';
comment on column ${idl_schema}.icms_guaranty_contract.thirdcreditparty is '被授信人3';
comment on column ${idl_schema}.icms_guaranty_contract.secondcreditsum is '被授信金额2';
comment on column ${idl_schema}.icms_guaranty_contract.secondcreditcurrency is '被授信币种2';
comment on column ${idl_schema}.icms_guaranty_contract.secondcreditparty is '被授信人2';
comment on column ${idl_schema}.icms_guaranty_contract.firstcreditsum is '被授信金额一';
comment on column ${idl_schema}.icms_guaranty_contract.firstcreditcurrency is '被授信币种一';
comment on column ${idl_schema}.icms_guaranty_contract.firstcreditparty is '被授信人一';
comment on column ${idl_schema}.icms_guaranty_contract.contractsum4 is '担保债务金额3';
comment on column ${idl_schema}.icms_guaranty_contract.currency4 is '担保债务币种3';
comment on column ${idl_schema}.icms_guaranty_contract.contractsum3 is '担保债务金额';
comment on column ${idl_schema}.icms_guaranty_contract.currency3 is '担保债务币种2';
comment on column ${idl_schema}.icms_guaranty_contract.contractsum2 is '合同本金2';
comment on column ${idl_schema}.icms_guaranty_contract.currency2 is '合同币种2';
comment on column ${idl_schema}.icms_guaranty_contract.contractname2 is '合同名称2';
comment on column ${idl_schema}.icms_guaranty_contract.contractno2 is '合同号2';
comment on column ${idl_schema}.icms_guaranty_contract.contractword2 is '合同机构简称+编号类型2';
comment on column ${idl_schema}.icms_guaranty_contract.contractsum1 is '担保债务本金1';
comment on column ${idl_schema}.icms_guaranty_contract.currency1 is '担保债务币种1';
comment on column ${idl_schema}.icms_guaranty_contract.contractname is '合同名称1';
comment on column ${idl_schema}.icms_guaranty_contract.contractno1 is '合同号1';
comment on column ${idl_schema}.icms_guaranty_contract.contractword is '合同机构简称+编号类型1';
comment on column ${idl_schema}.icms_guaranty_contract.partyacopies is '甲方执合同份数';
comment on column ${idl_schema}.icms_guaranty_contract.totalcopies is '合同总份数';
comment on column ${idl_schema}.icms_guaranty_contract.quoteguarantyquotano is '引入担保额度流水号';
comment on column ${idl_schema}.icms_guaranty_contract.quoteguarantyquota is '是否占用担保额度';
comment on column ${idl_schema}.icms_guaranty_contract.pigeonholedate is '归档日';
comment on column ${idl_schema}.icms_guaranty_contract.printflag is '追加担保合同打印标志';
comment on column ${idl_schema}.icms_guaranty_contract.guarantytype2 is '担保类型分类';
comment on column ${idl_schema}.icms_guaranty_contract.financeitem6 is '负债率（当期总负债／当期总资产）不高于';
comment on column ${idl_schema}.icms_guaranty_contract.financeitem7 is '债务权益比率（当期总负债／当期净资产）不高于';
comment on column ${idl_schema}.icms_guaranty_contract.endtime is '担保到期日';
comment on column ${idl_schema}.icms_guaranty_contract.begintime is '担保起始日';
comment on column ${idl_schema}.icms_guaranty_contract.transfercreditrange is '被转贷款人范围';
comment on column ${idl_schema}.icms_guaranty_contract.compensatetype is '清偿处理方式';
comment on column ${idl_schema}.icms_guaranty_contract.maincontractsum is '主合同金额';
comment on column ${idl_schema}.icms_guaranty_contract.maincontractcurrency is '主合同币种';
comment on column ${idl_schema}.icms_guaranty_contract.maincontractname is '主合同名称';
comment on column ${idl_schema}.icms_guaranty_contract.otherparties is '其余各方当事人及有关登记部门';
comment on column ${idl_schema}.icms_guaranty_contract.otherpromise is '约定其他事项';
comment on column ${idl_schema}.icms_guaranty_contract.notarizationflag is '是否强制执行公证';
comment on column ${idl_schema}.icms_guaranty_contract.otherguarantyperiod2 is '其他保证期间2';
comment on column ${idl_schema}.icms_guaranty_contract.otherguarantyperiod1 is '其他保证期间1';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyperiod is '保证期间';
comment on column ${idl_schema}.icms_guaranty_contract.otherguarantyrange is '其他担保范围';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyrange is '担保范围';
comment on column ${idl_schema}.icms_guaranty_contract.textmaincontractno is '主合同文本编号';
comment on column ${idl_schema}.icms_guaranty_contract.partybduty is '借款人法定代表人职务';
comment on column ${idl_schema}.icms_guaranty_contract.partybpostcode is '借款人邮编';
comment on column ${idl_schema}.icms_guaranty_contract.partyblegalperson is '借款人法定代表人';
comment on column ${idl_schema}.icms_guaranty_contract.partybfax is '借款人传真';
comment on column ${idl_schema}.icms_guaranty_contract.partybphone is '借款人电话';
comment on column ${idl_schema}.icms_guaranty_contract.partybaddress is '借款人地址';
comment on column ${idl_schema}.icms_guaranty_contract.partybcertid is '借款人证件号码';
comment on column ${idl_schema}.icms_guaranty_contract.partybcerttype is '借款人证件种类';
comment on column ${idl_schema}.icms_guaranty_contract.partybname is '借款人名称';
comment on column ${idl_schema}.icms_guaranty_contract.partyaduty is '贷款人负责人职务';
comment on column ${idl_schema}.icms_guaranty_contract.partyaprincipal is '贷款人负责人';
comment on column ${idl_schema}.icms_guaranty_contract.partyafax is '贷款人传真';
comment on column ${idl_schema}.icms_guaranty_contract.partyaphone is '债权人电话';
comment on column ${idl_schema}.icms_guaranty_contract.partyaaddress is '贷款人地址';
comment on column ${idl_schema}.icms_guaranty_contract.orgname is '机构名称';
comment on column ${idl_schema}.icms_guaranty_contract.shortorg is '机构简称';
comment on column ${idl_schema}.icms_guaranty_contract.textcontractno is '文本合同编号';
comment on column ${idl_schema}.icms_guaranty_contract.ectempsaveflag is '暂存标志';
comment on column ${idl_schema}.icms_guaranty_contract.econtracttype is '电子合同类型';
comment on column ${idl_schema}.icms_guaranty_contract.vouchtype is '主要担保方式';
comment on column ${idl_schema}.icms_guaranty_contract.bailratio is '保证金比例';
comment on column ${idl_schema}.icms_guaranty_contract.commondate is '通用日期';
comment on column ${idl_schema}.icms_guaranty_contract.othername is '其他名称';
comment on column ${idl_schema}.icms_guaranty_contract.checkguarantyman2 is '核保人（二）';
comment on column ${idl_schema}.icms_guaranty_contract.receptionduty is '接待人职务';
comment on column ${idl_schema}.icms_guaranty_contract.reception is '接待人姓名';
comment on column ${idl_schema}.icms_guaranty_contract.creditorgname is '债权人机构名称';
comment on column ${idl_schema}.icms_guaranty_contract.creditorgid is '债权人机构代码';
comment on column ${idl_schema}.icms_guaranty_contract.customerownership is '客户所有制类型';
comment on column ${idl_schema}.icms_guaranty_contract.channelflag is '渠道标志';
comment on column ${idl_schema}.icms_guaranty_contract.guarterm is '';
comment on column ${idl_schema}.icms_guaranty_contract.usesum is '';
comment on column ${idl_schema}.icms_guaranty_contract.guarbalance is '';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyno is '担保合同编号';
comment on column ${idl_schema}.icms_guaranty_contract.guarantytype is '一般担保合同、最高额担保合同';
comment on column ${idl_schema}.icms_guaranty_contract.guarantystyle is '担保方式';
comment on column ${idl_schema}.icms_guaranty_contract.guarantystatus is '担保合同状态';
comment on column ${idl_schema}.icms_guaranty_contract.signdate is '协议签定日期';
comment on column ${idl_schema}.icms_guaranty_contract.begindate is '合同生效日';
comment on column ${idl_schema}.icms_guaranty_contract.enddate is '合同到期日';
comment on column ${idl_schema}.icms_guaranty_contract.customerid is '被担保人客户号';
comment on column ${idl_schema}.icms_guaranty_contract.guarantorid is '担保人编号';
comment on column ${idl_schema}.icms_guaranty_contract.guarantorname is '担保人名称';
comment on column ${idl_schema}.icms_guaranty_contract.guarantycurrency is '担保币种';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyvalue is '担保总金额';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyinfo is '担保物概况';
comment on column ${idl_schema}.icms_guaranty_contract.otherdescsribe is '其它特别约定';
comment on column ${idl_schema}.icms_guaranty_contract.guarantyopinion is '担保意见';
comment on column ${idl_schema}.icms_guaranty_contract.start_dt is '开始日期';
comment on column ${idl_schema}.icms_guaranty_contract.end_dt is '结束日期';
comment on column ${idl_schema}.icms_guaranty_contract.id_mark is '删除标识';
comment on column ${idl_schema}.icms_guaranty_contract.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_guaranty_contract.guartorcate is '微贷担保类型';
comment on column ${idl_schema}.icms_guaranty_contract.etl_timestamp is '任务处理时间';
