/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icms_ind_economic
CreateDate: 20250509
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.icms_ind_economic purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.icms_ind_economic(
etl_dt date --数据日期
,serialno varchar2(64) --流水号
,licname varchar2(200) --企业登记注册类型名称
,certtype varchar2(4) --企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
,migtflag varchar2(80) --迁移标志：crs rcr ilc upl
,confirmcompsize varchar2(6) --我行认定企业规模
,taxtype varchar2(200) --纳税类型1-小规模纳税人2-一般纳税人
,taxorganname varchar2(200) --主管税务机关名称
,relation varchar2(8) --借款人与经营实体的关系
,accountingsystem varchar2(10) --适用会计制度
,customername varchar2(100) --经营者姓名
,taxlevel varchar2(10) --纳税信用等级a，b，c，d
,customerid varchar2(16) --客户编号
,legalcertcode varchar2(64) --经营者证件号码
,comptel varchar2(64) --经营企业电话
,landtaxcode varchar2(40) --地税登记号
,shareratio varchar2(10) --股东占股比例
,businessname varchar2(160) --企业名称
,inputuserid varchar2(64) --登记人
,legalcert varchar2(36) --经营者证件类型
,updateuserid varchar2(64) --更新人
,workersnum number(22) --企业员工人数
,regaddres varchar2(500) --注册地址
,realcapital number(26,6) --实收资本
,lictype varchar2(10) --企业登记注册类型代码
,citnum varchar2(60) --中征码
,bussowner varchar2(36) --经营场所所有权
,telephone varchar2(30) --联系电话
,bussenddate date --营业执照到期日期
,busstime varchar2(36) --本行业从业时间
,bussname varchar2(100) --个体工商户名称
,taxpayerstate varchar2(30) --纳税人状态名称1-正常2-非正常
,relrepyidtype varchar2(10) --相关还款责任人证件类型
,bussregdate date --营业执照注册日期
,formtype varchar2(200) --组成形式
,compzip varchar2(10) --经营企业地址邮编
,relrepyrsplpsntype varchar2(10) --相关还款责任人类型
,compsize varchar2(6) --企业规模
,bussmain varchar2(4000) --经营范围
,inputdate date --登记时间
,comestatus varchar2(400) --来源状态
,busilicname varchar2(200) --企业营业执照类型名称
,industry varchar2(36) --所属行业编号
,legalname varchar2(200) --法定代表人姓名
,taxorgancode varchar2(80) --税务机关代码
,regdist varchar2(10) --企业注册地址行政区划数字代码
,busscode varchar2(64) --个体工商户营业执照代码
,ownerprop varchar2(64) --所有制性质
,industryname varchar2(400) --所属行业名称
,compaddr varchar2(500) --企业地址
,totalassets number(22,2) --企业总资产总额
,loanpassword varchar2(40) --贷款卡密码
,accountingsystemname varchar2(200) --适用会计制度名称
,operreve number(22,2) --营业收入(年)
,updatedate date --更新时间
,businessid varchar2(64) --企业编号
,bussbank varchar2(80) --主要结算银行
,busilictype varchar2(10) --企业营业执照类型代码
,corporgid varchar2(64) --法人机构编号
,loancode varchar2(40) --贷款卡号/中征码
,relrepyid varchar2(20) --相关还款责任人核心客户号
,establishdate date --企业成立日期
,legalphone varchar2(100) --法定代表人电话号码
,legalemail varchar2(100) --法定代表人电子邮箱
,regcapital number(26,6) --注册资本
,certcode varchar2(30) --组织机构代码证号码
,relrepyidentype varchar2(10) --相关还款责任人身份类型
,certid varchar2(32) --证件号
,busslegaltype varchar2(24) --企业控股类型
,bussrentend date --租赁到期日
,nationaltaxcode varchar2(40) --国税登记号
,updateorgid varchar2(64) --更新机构
,inputorgid varchar2(64) --登记机构
,industrytype varchar2(20) --所属行业
,isoperatingentinvolvespecialized varchar2(1) --经营企业是否涉及专精特新
,ishightechnologyent varchar2(1) --是否高新技术企业
,istechnologyent varchar2(1) --是否科技型企业
,isscientifictechent varchar2(1) --是否科创企业
,isspecializedgiantent varchar2(1) --是否专精特新小巨人企业
,isspecializedsmallandmident varchar2(1) --是否专精特新中小企业
,istechnologysmallandmident varchar2(1) --是否科技型中小企业
,isindustrysinglechampionent varchar2(1) --是否制造业单项冠军企业
,isnationaltechnologinnovationent varchar2(1) --是否国家技术创新示范企业
,isgarden varchar2(4) --是否园区贷
,regno varchar2(64) --注册号
,offareacode varchar2(100) --注册地址行政区编号
,province varchar2(100) --所在省份
,regcapcur varchar2(100) --注册资本币种
,runstatus varchar2(64) --经营状态
,canceldate varchar2(64) --注销日期
,revokedate varchar2(64) --吊销日期
,address varchar2(1000) --住址
,busiscope2 varchar2(200) --经营(业务)范围及方式
,chkyear varchar2(100) --最后年检年度
,cocode varchar2(64) --国民经济行业代码
,coname varchar2(300) --国民经济行业名称
,creditcode varchar2(64) --证件号码
,city varchar2(80) --市/州/地区
,economicid varchar2(64) --经营实体id

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icms_ind_economic to ${iel_schema};

-- comment
comment on table ${idl_schema}.icms_ind_economic is '个人经营企业信息';
comment on column ${idl_schema}.icms_ind_economic.etl_dt is '数据日期';
comment on column ${idl_schema}.icms_ind_economic.serialno is '流水号';
comment on column ${idl_schema}.icms_ind_economic.licname is '企业登记注册类型名称';
comment on column ${idl_schema}.icms_ind_economic.certtype is '企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）';
comment on column ${idl_schema}.icms_ind_economic.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${idl_schema}.icms_ind_economic.confirmcompsize is '我行认定企业规模';
comment on column ${idl_schema}.icms_ind_economic.taxtype is '纳税类型1-小规模纳税人2-一般纳税人';
comment on column ${idl_schema}.icms_ind_economic.taxorganname is '主管税务机关名称';
comment on column ${idl_schema}.icms_ind_economic.relation is '借款人与经营实体的关系';
comment on column ${idl_schema}.icms_ind_economic.accountingsystem is '适用会计制度';
comment on column ${idl_schema}.icms_ind_economic.customername is '经营者姓名';
comment on column ${idl_schema}.icms_ind_economic.taxlevel is '纳税信用等级a，b，c，d';
comment on column ${idl_schema}.icms_ind_economic.customerid is '客户编号';
comment on column ${idl_schema}.icms_ind_economic.legalcertcode is '经营者证件号码';
comment on column ${idl_schema}.icms_ind_economic.comptel is '经营企业电话';
comment on column ${idl_schema}.icms_ind_economic.landtaxcode is '地税登记号';
comment on column ${idl_schema}.icms_ind_economic.shareratio is '股东占股比例';
comment on column ${idl_schema}.icms_ind_economic.businessname is '企业名称';
comment on column ${idl_schema}.icms_ind_economic.inputuserid is '登记人';
comment on column ${idl_schema}.icms_ind_economic.legalcert is '经营者证件类型';
comment on column ${idl_schema}.icms_ind_economic.updateuserid is '更新人';
comment on column ${idl_schema}.icms_ind_economic.workersnum is '企业员工人数';
comment on column ${idl_schema}.icms_ind_economic.regaddres is '注册地址';
comment on column ${idl_schema}.icms_ind_economic.realcapital is '实收资本';
comment on column ${idl_schema}.icms_ind_economic.lictype is '企业登记注册类型代码';
comment on column ${idl_schema}.icms_ind_economic.citnum is '中征码';
comment on column ${idl_schema}.icms_ind_economic.bussowner is '经营场所所有权';
comment on column ${idl_schema}.icms_ind_economic.telephone is '联系电话';
comment on column ${idl_schema}.icms_ind_economic.bussenddate is '营业执照到期日期';
comment on column ${idl_schema}.icms_ind_economic.busstime is '本行业从业时间';
comment on column ${idl_schema}.icms_ind_economic.bussname is '个体工商户名称';
comment on column ${idl_schema}.icms_ind_economic.taxpayerstate is '纳税人状态名称1-正常2-非正常';
comment on column ${idl_schema}.icms_ind_economic.relrepyidtype is '相关还款责任人证件类型';
comment on column ${idl_schema}.icms_ind_economic.bussregdate is '营业执照注册日期';
comment on column ${idl_schema}.icms_ind_economic.formtype is '组成形式';
comment on column ${idl_schema}.icms_ind_economic.compzip is '经营企业地址邮编';
comment on column ${idl_schema}.icms_ind_economic.relrepyrsplpsntype is '相关还款责任人类型';
comment on column ${idl_schema}.icms_ind_economic.compsize is '企业规模';
comment on column ${idl_schema}.icms_ind_economic.bussmain is '经营范围';
comment on column ${idl_schema}.icms_ind_economic.inputdate is '登记时间';
comment on column ${idl_schema}.icms_ind_economic.comestatus is '来源状态';
comment on column ${idl_schema}.icms_ind_economic.busilicname is '企业营业执照类型名称';
comment on column ${idl_schema}.icms_ind_economic.industry is '所属行业编号';
comment on column ${idl_schema}.icms_ind_economic.legalname is '法定代表人姓名';
comment on column ${idl_schema}.icms_ind_economic.taxorgancode is '税务机关代码';
comment on column ${idl_schema}.icms_ind_economic.regdist is '企业注册地址行政区划数字代码';
comment on column ${idl_schema}.icms_ind_economic.busscode is '个体工商户营业执照代码';
comment on column ${idl_schema}.icms_ind_economic.ownerprop is '所有制性质';
comment on column ${idl_schema}.icms_ind_economic.industryname is '所属行业名称';
comment on column ${idl_schema}.icms_ind_economic.compaddr is '企业地址';
comment on column ${idl_schema}.icms_ind_economic.totalassets is '企业总资产总额';
comment on column ${idl_schema}.icms_ind_economic.loanpassword is '贷款卡密码';
comment on column ${idl_schema}.icms_ind_economic.accountingsystemname is '适用会计制度名称';
comment on column ${idl_schema}.icms_ind_economic.operreve is '营业收入(年)';
comment on column ${idl_schema}.icms_ind_economic.updatedate is '更新时间';
comment on column ${idl_schema}.icms_ind_economic.businessid is '企业编号';
comment on column ${idl_schema}.icms_ind_economic.bussbank is '主要结算银行';
comment on column ${idl_schema}.icms_ind_economic.busilictype is '企业营业执照类型代码';
comment on column ${idl_schema}.icms_ind_economic.corporgid is '法人机构编号';
comment on column ${idl_schema}.icms_ind_economic.loancode is '贷款卡号/中征码';
comment on column ${idl_schema}.icms_ind_economic.relrepyid is '相关还款责任人核心客户号';
comment on column ${idl_schema}.icms_ind_economic.establishdate is '企业成立日期';
comment on column ${idl_schema}.icms_ind_economic.legalphone is '法定代表人电话号码';
comment on column ${idl_schema}.icms_ind_economic.legalemail is '法定代表人电子邮箱';
comment on column ${idl_schema}.icms_ind_economic.regcapital is '注册资本';
comment on column ${idl_schema}.icms_ind_economic.certcode is '组织机构代码证号码';
comment on column ${idl_schema}.icms_ind_economic.relrepyidentype is '相关还款责任人身份类型';
comment on column ${idl_schema}.icms_ind_economic.certid is '证件号';
comment on column ${idl_schema}.icms_ind_economic.busslegaltype is '企业控股类型';
comment on column ${idl_schema}.icms_ind_economic.bussrentend is '租赁到期日';
comment on column ${idl_schema}.icms_ind_economic.nationaltaxcode is '国税登记号';
comment on column ${idl_schema}.icms_ind_economic.updateorgid is '更新机构';
comment on column ${idl_schema}.icms_ind_economic.inputorgid is '登记机构';
comment on column ${idl_schema}.icms_ind_economic.industrytype is '所属行业';
comment on column ${idl_schema}.icms_ind_economic.isoperatingentinvolvespecialized is '经营企业是否涉及专精特新';
comment on column ${idl_schema}.icms_ind_economic.ishightechnologyent is '是否高新技术企业';
comment on column ${idl_schema}.icms_ind_economic.istechnologyent is '是否科技型企业';
comment on column ${idl_schema}.icms_ind_economic.isscientifictechent is '是否科创企业';
comment on column ${idl_schema}.icms_ind_economic.isspecializedgiantent is '是否专精特新小巨人企业';
comment on column ${idl_schema}.icms_ind_economic.isspecializedsmallandmident is '是否专精特新中小企业';
comment on column ${idl_schema}.icms_ind_economic.istechnologysmallandmident is '是否科技型中小企业';
comment on column ${idl_schema}.icms_ind_economic.isindustrysinglechampionent is '是否制造业单项冠军企业';
comment on column ${idl_schema}.icms_ind_economic.isnationaltechnologinnovationent is '是否国家技术创新示范企业';
comment on column ${idl_schema}.icms_ind_economic.isgarden is '是否园区贷';
comment on column ${idl_schema}.icms_ind_economic.regno is '注册号';
comment on column ${idl_schema}.icms_ind_economic.offareacode is '注册地址行政区编号';
comment on column ${idl_schema}.icms_ind_economic.province is '所在省份';
comment on column ${idl_schema}.icms_ind_economic.regcapcur is '注册资本币种';
comment on column ${idl_schema}.icms_ind_economic.runstatus is '经营状态';
comment on column ${idl_schema}.icms_ind_economic.canceldate is '注销日期';
comment on column ${idl_schema}.icms_ind_economic.revokedate is '吊销日期';
comment on column ${idl_schema}.icms_ind_economic.address is '住址';
comment on column ${idl_schema}.icms_ind_economic.busiscope2 is '经营(业务)范围及方式';
comment on column ${idl_schema}.icms_ind_economic.chkyear is '最后年检年度';
comment on column ${idl_schema}.icms_ind_economic.cocode is '国民经济行业代码';
comment on column ${idl_schema}.icms_ind_economic.coname is '国民经济行业名称';
comment on column ${idl_schema}.icms_ind_economic.creditcode is '证件号码';
comment on column ${idl_schema}.icms_ind_economic.city is '市/州/地区';
comment on column ${idl_schema}.icms_ind_economic.economicid is '经营实体id';

