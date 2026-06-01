/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_economic
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
create table ${iol_schema}.icms_ind_economic_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_economic
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_economic_op purge;
drop table ${iol_schema}.icms_ind_economic_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_economic_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_economic where 0=1;

create table ${iol_schema}.icms_ind_economic_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_economic where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_economic_cl(
            serialno -- 流水号
            ,licname -- 企业登记注册类型名称
            ,certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,confirmcompsize -- 我行认定企业规模
            ,taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
            ,taxorganname -- 主管税务机关名称
            ,relation -- 借款人与经营实体的关系
            ,accountingsystem -- 适用会计制度
            ,customername -- 经营者姓名
            ,taxlevel -- 纳税信用等级a，b，c，d
            ,customerid -- 客户编号
            ,legalcertcode -- 经营者证件号码
            ,comptel -- 经营企业电话
            ,landtaxcode -- 地税登记号
            ,shareratio -- 股东占股比例
            ,businessname -- 企业名称
            ,inputuserid -- 登记人
            ,legalcert -- 经营者证件类型
            ,updateuserid -- 更新人
            ,workersnum -- 企业员工人数
            ,regaddres -- 注册地址
            ,realcapital -- 实收资本
            ,lictype -- 企业登记注册类型代码
            ,citnum -- 中征码
            ,bussowner -- 经营场所所有权
            ,telephone -- 联系电话
            ,bussenddate -- 营业执照到期日期
            ,busstime -- 本行业从业时间
            ,bussname -- 个体工商户名称
            ,taxpayerstate -- 纳税人状态名称1-正常2-非正常
            ,relrepyidtype -- 相关还款责任人证件类型
            ,bussregdate -- 营业执照注册日期
            ,formtype -- 组成形式
            ,compzip -- 经营企业地址邮编
            ,relrepyrsplpsntype -- 相关还款责任人类型
            ,compsize -- 企业规模
            ,bussmain -- 经营范围
            ,inputdate -- 登记时间
            ,comestatus -- 来源状态
            ,busilicname -- 企业营业执照类型名称
            ,industry -- 所属行业编号
            ,legalname -- 法定代表人姓名
            ,taxorgancode -- 税务机关代码
            ,regdist -- 企业注册地址行政区划数字代码
            ,busscode -- 个体工商户营业执照代码
            ,ownerprop -- 所有制性质
            ,industryname -- 所属行业名称
            ,compaddr -- 企业地址
            ,totalassets -- 企业总资产总额
            ,loanpassword -- 贷款卡密码
            ,accountingsystemname -- 适用会计制度名称
            ,operreve -- 营业收入(年)
            ,updatedate -- 更新时间
            ,businessid -- 企业编号
            ,bussbank -- 主要结算银行
            ,busilictype -- 企业营业执照类型代码
            ,corporgid -- 法人机构编号
            ,loancode -- 贷款卡号/中征码
            ,relrepyid -- 相关还款责任人核心客户号
            ,establishdate -- 企业成立日期
            ,legalphone -- 法定代表人电话号码
            ,legalemail -- 法定代表人电子邮箱
            ,regcapital -- 注册资本
            ,certcode -- 组织机构代码证号码
            ,relrepyidentype -- 相关还款责任人身份类型
            ,certid -- 证件号
            ,busslegaltype -- 企业控股类型
            ,bussrentend -- 租赁到期日
            ,nationaltaxcode -- 国税登记号
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,industrytype -- 所属行业
            ,isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
            ,ishightechnologyent -- 是否高新技术企业
            ,istechnologyent -- 是否科技型企业
            ,isscientifictechent -- 是否科创企业
            ,isspecializedgiantent -- 是否专精特新小巨人企业
            ,isspecializedsmallandmident -- 是否专精特新中小企业
            ,istechnologysmallandmident -- 是否科技型中小企业
            ,isindustrysinglechampionent -- 是否制造业单项冠军企业
            ,isnationaltechnologinnovationent -- 是否国家技术创新示范企业
            ,isgarden -- 是否园区贷
            ,regno -- 注册号
            ,offareacode -- 注册地址行政区编号
            ,province -- 所在省份
            ,regcapcur -- 注册资本币种
            ,runstatus -- 经营状态
            ,canceldate -- 注销日期
            ,revokedate -- 吊销日期
            ,address -- 住址
            ,busiscope2 -- 经营(业务)范围及方式
            ,chkyear -- 最后年检年度
            ,cocode -- 国民经济行业代码
            ,coname -- 国民经济行业名称
            ,creditcode -- 证件号码
            ,city -- 市/州/地区
            ,economicid -- 经营实体ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_economic_op(
            serialno -- 流水号
            ,licname -- 企业登记注册类型名称
            ,certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,confirmcompsize -- 我行认定企业规模
            ,taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
            ,taxorganname -- 主管税务机关名称
            ,relation -- 借款人与经营实体的关系
            ,accountingsystem -- 适用会计制度
            ,customername -- 经营者姓名
            ,taxlevel -- 纳税信用等级a，b，c，d
            ,customerid -- 客户编号
            ,legalcertcode -- 经营者证件号码
            ,comptel -- 经营企业电话
            ,landtaxcode -- 地税登记号
            ,shareratio -- 股东占股比例
            ,businessname -- 企业名称
            ,inputuserid -- 登记人
            ,legalcert -- 经营者证件类型
            ,updateuserid -- 更新人
            ,workersnum -- 企业员工人数
            ,regaddres -- 注册地址
            ,realcapital -- 实收资本
            ,lictype -- 企业登记注册类型代码
            ,citnum -- 中征码
            ,bussowner -- 经营场所所有权
            ,telephone -- 联系电话
            ,bussenddate -- 营业执照到期日期
            ,busstime -- 本行业从业时间
            ,bussname -- 个体工商户名称
            ,taxpayerstate -- 纳税人状态名称1-正常2-非正常
            ,relrepyidtype -- 相关还款责任人证件类型
            ,bussregdate -- 营业执照注册日期
            ,formtype -- 组成形式
            ,compzip -- 经营企业地址邮编
            ,relrepyrsplpsntype -- 相关还款责任人类型
            ,compsize -- 企业规模
            ,bussmain -- 经营范围
            ,inputdate -- 登记时间
            ,comestatus -- 来源状态
            ,busilicname -- 企业营业执照类型名称
            ,industry -- 所属行业编号
            ,legalname -- 法定代表人姓名
            ,taxorgancode -- 税务机关代码
            ,regdist -- 企业注册地址行政区划数字代码
            ,busscode -- 个体工商户营业执照代码
            ,ownerprop -- 所有制性质
            ,industryname -- 所属行业名称
            ,compaddr -- 企业地址
            ,totalassets -- 企业总资产总额
            ,loanpassword -- 贷款卡密码
            ,accountingsystemname -- 适用会计制度名称
            ,operreve -- 营业收入(年)
            ,updatedate -- 更新时间
            ,businessid -- 企业编号
            ,bussbank -- 主要结算银行
            ,busilictype -- 企业营业执照类型代码
            ,corporgid -- 法人机构编号
            ,loancode -- 贷款卡号/中征码
            ,relrepyid -- 相关还款责任人核心客户号
            ,establishdate -- 企业成立日期
            ,legalphone -- 法定代表人电话号码
            ,legalemail -- 法定代表人电子邮箱
            ,regcapital -- 注册资本
            ,certcode -- 组织机构代码证号码
            ,relrepyidentype -- 相关还款责任人身份类型
            ,certid -- 证件号
            ,busslegaltype -- 企业控股类型
            ,bussrentend -- 租赁到期日
            ,nationaltaxcode -- 国税登记号
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,industrytype -- 所属行业
            ,isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
            ,ishightechnologyent -- 是否高新技术企业
            ,istechnologyent -- 是否科技型企业
            ,isscientifictechent -- 是否科创企业
            ,isspecializedgiantent -- 是否专精特新小巨人企业
            ,isspecializedsmallandmident -- 是否专精特新中小企业
            ,istechnologysmallandmident -- 是否科技型中小企业
            ,isindustrysinglechampionent -- 是否制造业单项冠军企业
            ,isnationaltechnologinnovationent -- 是否国家技术创新示范企业
            ,isgarden -- 是否园区贷
            ,regno -- 注册号
            ,offareacode -- 注册地址行政区编号
            ,province -- 所在省份
            ,regcapcur -- 注册资本币种
            ,runstatus -- 经营状态
            ,canceldate -- 注销日期
            ,revokedate -- 吊销日期
            ,address -- 住址
            ,busiscope2 -- 经营(业务)范围及方式
            ,chkyear -- 最后年检年度
            ,cocode -- 国民经济行业代码
            ,coname -- 国民经济行业名称
            ,creditcode -- 证件号码
            ,city -- 市/州/地区
            ,economicid -- 经营实体ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.licname, o.licname) as licname -- 企业登记注册类型名称
    ,nvl(n.certtype, o.certtype) as certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.confirmcompsize, o.confirmcompsize) as confirmcompsize -- 我行认定企业规模
    ,nvl(n.taxtype, o.taxtype) as taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
    ,nvl(n.taxorganname, o.taxorganname) as taxorganname -- 主管税务机关名称
    ,nvl(n.relation, o.relation) as relation -- 借款人与经营实体的关系
    ,nvl(n.accountingsystem, o.accountingsystem) as accountingsystem -- 适用会计制度
    ,nvl(n.customername, o.customername) as customername -- 经营者姓名
    ,nvl(n.taxlevel, o.taxlevel) as taxlevel -- 纳税信用等级a，b，c，d
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.legalcertcode, o.legalcertcode) as legalcertcode -- 经营者证件号码
    ,nvl(n.comptel, o.comptel) as comptel -- 经营企业电话
    ,nvl(n.landtaxcode, o.landtaxcode) as landtaxcode -- 地税登记号
    ,nvl(n.shareratio, o.shareratio) as shareratio -- 股东占股比例
    ,nvl(n.businessname, o.businessname) as businessname -- 企业名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.legalcert, o.legalcert) as legalcert -- 经营者证件类型
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.workersnum, o.workersnum) as workersnum -- 企业员工人数
    ,nvl(n.regaddres, o.regaddres) as regaddres -- 注册地址
    ,nvl(n.realcapital, o.realcapital) as realcapital -- 实收资本
    ,nvl(n.lictype, o.lictype) as lictype -- 企业登记注册类型代码
    ,nvl(n.citnum, o.citnum) as citnum -- 中征码
    ,nvl(n.bussowner, o.bussowner) as bussowner -- 经营场所所有权
    ,nvl(n.telephone, o.telephone) as telephone -- 联系电话
    ,nvl(n.bussenddate, o.bussenddate) as bussenddate -- 营业执照到期日期
    ,nvl(n.busstime, o.busstime) as busstime -- 本行业从业时间
    ,nvl(n.bussname, o.bussname) as bussname -- 个体工商户名称
    ,nvl(n.taxpayerstate, o.taxpayerstate) as taxpayerstate -- 纳税人状态名称1-正常2-非正常
    ,nvl(n.relrepyidtype, o.relrepyidtype) as relrepyidtype -- 相关还款责任人证件类型
    ,nvl(n.bussregdate, o.bussregdate) as bussregdate -- 营业执照注册日期
    ,nvl(n.formtype, o.formtype) as formtype -- 组成形式
    ,nvl(n.compzip, o.compzip) as compzip -- 经营企业地址邮编
    ,nvl(n.relrepyrsplpsntype, o.relrepyrsplpsntype) as relrepyrsplpsntype -- 相关还款责任人类型
    ,nvl(n.compsize, o.compsize) as compsize -- 企业规模
    ,nvl(n.bussmain, o.bussmain) as bussmain -- 经营范围
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.comestatus, o.comestatus) as comestatus -- 来源状态
    ,nvl(n.busilicname, o.busilicname) as busilicname -- 企业营业执照类型名称
    ,nvl(n.industry, o.industry) as industry -- 所属行业编号
    ,nvl(n.legalname, o.legalname) as legalname -- 法定代表人姓名
    ,nvl(n.taxorgancode, o.taxorgancode) as taxorgancode -- 税务机关代码
    ,nvl(n.regdist, o.regdist) as regdist -- 企业注册地址行政区划数字代码
    ,nvl(n.busscode, o.busscode) as busscode -- 个体工商户营业执照代码
    ,nvl(n.ownerprop, o.ownerprop) as ownerprop -- 所有制性质
    ,nvl(n.industryname, o.industryname) as industryname -- 所属行业名称
    ,nvl(n.compaddr, o.compaddr) as compaddr -- 企业地址
    ,nvl(n.totalassets, o.totalassets) as totalassets -- 企业总资产总额
    ,nvl(n.loanpassword, o.loanpassword) as loanpassword -- 贷款卡密码
    ,nvl(n.accountingsystemname, o.accountingsystemname) as accountingsystemname -- 适用会计制度名称
    ,nvl(n.operreve, o.operreve) as operreve -- 营业收入(年)
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.businessid, o.businessid) as businessid -- 企业编号
    ,nvl(n.bussbank, o.bussbank) as bussbank -- 主要结算银行
    ,nvl(n.busilictype, o.busilictype) as busilictype -- 企业营业执照类型代码
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.loancode, o.loancode) as loancode -- 贷款卡号/中征码
    ,nvl(n.relrepyid, o.relrepyid) as relrepyid -- 相关还款责任人核心客户号
    ,nvl(n.establishdate, o.establishdate) as establishdate -- 企业成立日期
    ,nvl(n.legalphone, o.legalphone) as legalphone -- 法定代表人电话号码
    ,nvl(n.legalemail, o.legalemail) as legalemail -- 法定代表人电子邮箱
    ,nvl(n.regcapital, o.regcapital) as regcapital -- 注册资本
    ,nvl(n.certcode, o.certcode) as certcode -- 组织机构代码证号码
    ,nvl(n.relrepyidentype, o.relrepyidentype) as relrepyidentype -- 相关还款责任人身份类型
    ,nvl(n.certid, o.certid) as certid -- 证件号
    ,nvl(n.busslegaltype, o.busslegaltype) as busslegaltype -- 企业控股类型
    ,nvl(n.bussrentend, o.bussrentend) as bussrentend -- 租赁到期日
    ,nvl(n.nationaltaxcode, o.nationaltaxcode) as nationaltaxcode -- 国税登记号
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业
    ,nvl(n.isoperatingentinvolvespecialized, o.isoperatingentinvolvespecialized) as isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
    ,nvl(n.ishightechnologyent, o.ishightechnologyent) as ishightechnologyent -- 是否高新技术企业
    ,nvl(n.istechnologyent, o.istechnologyent) as istechnologyent -- 是否科技型企业
    ,nvl(n.isscientifictechent, o.isscientifictechent) as isscientifictechent -- 是否科创企业
    ,nvl(n.isspecializedgiantent, o.isspecializedgiantent) as isspecializedgiantent -- 是否专精特新小巨人企业
    ,nvl(n.isspecializedsmallandmident, o.isspecializedsmallandmident) as isspecializedsmallandmident -- 是否专精特新中小企业
    ,nvl(n.istechnologysmallandmident, o.istechnologysmallandmident) as istechnologysmallandmident -- 是否科技型中小企业
    ,nvl(n.isindustrysinglechampionent, o.isindustrysinglechampionent) as isindustrysinglechampionent -- 是否制造业单项冠军企业
    ,nvl(n.isnationaltechnologinnovationent, o.isnationaltechnologinnovationent) as isnationaltechnologinnovationent -- 是否国家技术创新示范企业
    ,nvl(n.isgarden, o.isgarden) as isgarden -- 是否园区贷
    ,nvl(n.regno, o.regno) as regno -- 注册号
    ,nvl(n.offareacode, o.offareacode) as offareacode -- 注册地址行政区编号
    ,nvl(n.province, o.province) as province -- 所在省份
    ,nvl(n.regcapcur, o.regcapcur) as regcapcur -- 注册资本币种
    ,nvl(n.runstatus, o.runstatus) as runstatus -- 经营状态
    ,nvl(n.canceldate, o.canceldate) as canceldate -- 注销日期
    ,nvl(n.revokedate, o.revokedate) as revokedate -- 吊销日期
    ,nvl(n.address, o.address) as address -- 住址
    ,nvl(n.busiscope2, o.busiscope2) as busiscope2 -- 经营(业务)范围及方式
    ,nvl(n.chkyear, o.chkyear) as chkyear -- 最后年检年度
    ,nvl(n.cocode, o.cocode) as cocode -- 国民经济行业代码
    ,nvl(n.coname, o.coname) as coname -- 国民经济行业名称
    ,nvl(n.creditcode, o.creditcode) as creditcode -- 证件号码
    ,nvl(n.city, o.city) as city -- 市/州/地区
    ,nvl(n.economicid, o.economicid) as economicid -- 经营实体ID
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
from (select * from ${iol_schema}.icms_ind_economic_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_economic where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.licname <> n.licname
        or o.certtype <> n.certtype
        or o.migtflag <> n.migtflag
        or o.confirmcompsize <> n.confirmcompsize
        or o.taxtype <> n.taxtype
        or o.taxorganname <> n.taxorganname
        or o.relation <> n.relation
        or o.accountingsystem <> n.accountingsystem
        or o.customername <> n.customername
        or o.taxlevel <> n.taxlevel
        or o.customerid <> n.customerid
        or o.legalcertcode <> n.legalcertcode
        or o.comptel <> n.comptel
        or o.landtaxcode <> n.landtaxcode
        or o.shareratio <> n.shareratio
        or o.businessname <> n.businessname
        or o.inputuserid <> n.inputuserid
        or o.legalcert <> n.legalcert
        or o.updateuserid <> n.updateuserid
        or o.workersnum <> n.workersnum
        or o.regaddres <> n.regaddres
        or o.realcapital <> n.realcapital
        or o.lictype <> n.lictype
        or o.citnum <> n.citnum
        or o.bussowner <> n.bussowner
        or o.telephone <> n.telephone
        or o.bussenddate <> n.bussenddate
        or o.busstime <> n.busstime
        or o.bussname <> n.bussname
        or o.taxpayerstate <> n.taxpayerstate
        or o.relrepyidtype <> n.relrepyidtype
        or o.bussregdate <> n.bussregdate
        or o.formtype <> n.formtype
        or o.compzip <> n.compzip
        or o.relrepyrsplpsntype <> n.relrepyrsplpsntype
        or o.compsize <> n.compsize
        or o.bussmain <> n.bussmain
        or o.inputdate <> n.inputdate
        or o.comestatus <> n.comestatus
        or o.busilicname <> n.busilicname
        or o.industry <> n.industry
        or o.legalname <> n.legalname
        or o.taxorgancode <> n.taxorgancode
        or o.regdist <> n.regdist
        or o.busscode <> n.busscode
        or o.ownerprop <> n.ownerprop
        or o.industryname <> n.industryname
        or o.compaddr <> n.compaddr
        or o.totalassets <> n.totalassets
        or o.loanpassword <> n.loanpassword
        or o.accountingsystemname <> n.accountingsystemname
        or o.operreve <> n.operreve
        or o.updatedate <> n.updatedate
        or o.businessid <> n.businessid
        or o.bussbank <> n.bussbank
        or o.busilictype <> n.busilictype
        or o.corporgid <> n.corporgid
        or o.loancode <> n.loancode
        or o.relrepyid <> n.relrepyid
        or o.establishdate <> n.establishdate
        or o.legalphone <> n.legalphone
        or o.legalemail <> n.legalemail
        or o.regcapital <> n.regcapital
        or o.certcode <> n.certcode
        or o.relrepyidentype <> n.relrepyidentype
        or o.certid <> n.certid
        or o.busslegaltype <> n.busslegaltype
        or o.bussrentend <> n.bussrentend
        or o.nationaltaxcode <> n.nationaltaxcode
        or o.updateorgid <> n.updateorgid
        or o.inputorgid <> n.inputorgid
        or o.industrytype <> n.industrytype
        or o.isoperatingentinvolvespecialized <> n.isoperatingentinvolvespecialized
        or o.ishightechnologyent <> n.ishightechnologyent
        or o.istechnologyent <> n.istechnologyent
        or o.isscientifictechent <> n.isscientifictechent
        or o.isspecializedgiantent <> n.isspecializedgiantent
        or o.isspecializedsmallandmident <> n.isspecializedsmallandmident
        or o.istechnologysmallandmident <> n.istechnologysmallandmident
        or o.isindustrysinglechampionent <> n.isindustrysinglechampionent
        or o.isnationaltechnologinnovationent <> n.isnationaltechnologinnovationent
        or o.isgarden <> n.isgarden
        or o.regno <> n.regno
        or o.offareacode <> n.offareacode
        or o.province <> n.province
        or o.regcapcur <> n.regcapcur
        or o.runstatus <> n.runstatus
        or o.canceldate <> n.canceldate
        or o.revokedate <> n.revokedate
        or o.address <> n.address
        or o.busiscope2 <> n.busiscope2
        or o.chkyear <> n.chkyear
        or o.cocode <> n.cocode
        or o.coname <> n.coname
        or o.creditcode <> n.creditcode
        or o.city <> n.city
        or o.economicid <> n.economicid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_economic_cl(
            serialno -- 流水号
            ,licname -- 企业登记注册类型名称
            ,certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,confirmcompsize -- 我行认定企业规模
            ,taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
            ,taxorganname -- 主管税务机关名称
            ,relation -- 借款人与经营实体的关系
            ,accountingsystem -- 适用会计制度
            ,customername -- 经营者姓名
            ,taxlevel -- 纳税信用等级a，b，c，d
            ,customerid -- 客户编号
            ,legalcertcode -- 经营者证件号码
            ,comptel -- 经营企业电话
            ,landtaxcode -- 地税登记号
            ,shareratio -- 股东占股比例
            ,businessname -- 企业名称
            ,inputuserid -- 登记人
            ,legalcert -- 经营者证件类型
            ,updateuserid -- 更新人
            ,workersnum -- 企业员工人数
            ,regaddres -- 注册地址
            ,realcapital -- 实收资本
            ,lictype -- 企业登记注册类型代码
            ,citnum -- 中征码
            ,bussowner -- 经营场所所有权
            ,telephone -- 联系电话
            ,bussenddate -- 营业执照到期日期
            ,busstime -- 本行业从业时间
            ,bussname -- 个体工商户名称
            ,taxpayerstate -- 纳税人状态名称1-正常2-非正常
            ,relrepyidtype -- 相关还款责任人证件类型
            ,bussregdate -- 营业执照注册日期
            ,formtype -- 组成形式
            ,compzip -- 经营企业地址邮编
            ,relrepyrsplpsntype -- 相关还款责任人类型
            ,compsize -- 企业规模
            ,bussmain -- 经营范围
            ,inputdate -- 登记时间
            ,comestatus -- 来源状态
            ,busilicname -- 企业营业执照类型名称
            ,industry -- 所属行业编号
            ,legalname -- 法定代表人姓名
            ,taxorgancode -- 税务机关代码
            ,regdist -- 企业注册地址行政区划数字代码
            ,busscode -- 个体工商户营业执照代码
            ,ownerprop -- 所有制性质
            ,industryname -- 所属行业名称
            ,compaddr -- 企业地址
            ,totalassets -- 企业总资产总额
            ,loanpassword -- 贷款卡密码
            ,accountingsystemname -- 适用会计制度名称
            ,operreve -- 营业收入(年)
            ,updatedate -- 更新时间
            ,businessid -- 企业编号
            ,bussbank -- 主要结算银行
            ,busilictype -- 企业营业执照类型代码
            ,corporgid -- 法人机构编号
            ,loancode -- 贷款卡号/中征码
            ,relrepyid -- 相关还款责任人核心客户号
            ,establishdate -- 企业成立日期
            ,legalphone -- 法定代表人电话号码
            ,legalemail -- 法定代表人电子邮箱
            ,regcapital -- 注册资本
            ,certcode -- 组织机构代码证号码
            ,relrepyidentype -- 相关还款责任人身份类型
            ,certid -- 证件号
            ,busslegaltype -- 企业控股类型
            ,bussrentend -- 租赁到期日
            ,nationaltaxcode -- 国税登记号
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,industrytype -- 所属行业
            ,isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
            ,ishightechnologyent -- 是否高新技术企业
            ,istechnologyent -- 是否科技型企业
            ,isscientifictechent -- 是否科创企业
            ,isspecializedgiantent -- 是否专精特新小巨人企业
            ,isspecializedsmallandmident -- 是否专精特新中小企业
            ,istechnologysmallandmident -- 是否科技型中小企业
            ,isindustrysinglechampionent -- 是否制造业单项冠军企业
            ,isnationaltechnologinnovationent -- 是否国家技术创新示范企业
            ,isgarden -- 是否园区贷
            ,regno -- 注册号
            ,offareacode -- 注册地址行政区编号
            ,province -- 所在省份
            ,regcapcur -- 注册资本币种
            ,runstatus -- 经营状态
            ,canceldate -- 注销日期
            ,revokedate -- 吊销日期
            ,address -- 住址
            ,busiscope2 -- 经营(业务)范围及方式
            ,chkyear -- 最后年检年度
            ,cocode -- 国民经济行业代码
            ,coname -- 国民经济行业名称
            ,creditcode -- 证件号码
            ,city -- 市/州/地区
            ,economicid -- 经营实体ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_economic_op(
            serialno -- 流水号
            ,licname -- 企业登记注册类型名称
            ,certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,confirmcompsize -- 我行认定企业规模
            ,taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
            ,taxorganname -- 主管税务机关名称
            ,relation -- 借款人与经营实体的关系
            ,accountingsystem -- 适用会计制度
            ,customername -- 经营者姓名
            ,taxlevel -- 纳税信用等级a，b，c，d
            ,customerid -- 客户编号
            ,legalcertcode -- 经营者证件号码
            ,comptel -- 经营企业电话
            ,landtaxcode -- 地税登记号
            ,shareratio -- 股东占股比例
            ,businessname -- 企业名称
            ,inputuserid -- 登记人
            ,legalcert -- 经营者证件类型
            ,updateuserid -- 更新人
            ,workersnum -- 企业员工人数
            ,regaddres -- 注册地址
            ,realcapital -- 实收资本
            ,lictype -- 企业登记注册类型代码
            ,citnum -- 中征码
            ,bussowner -- 经营场所所有权
            ,telephone -- 联系电话
            ,bussenddate -- 营业执照到期日期
            ,busstime -- 本行业从业时间
            ,bussname -- 个体工商户名称
            ,taxpayerstate -- 纳税人状态名称1-正常2-非正常
            ,relrepyidtype -- 相关还款责任人证件类型
            ,bussregdate -- 营业执照注册日期
            ,formtype -- 组成形式
            ,compzip -- 经营企业地址邮编
            ,relrepyrsplpsntype -- 相关还款责任人类型
            ,compsize -- 企业规模
            ,bussmain -- 经营范围
            ,inputdate -- 登记时间
            ,comestatus -- 来源状态
            ,busilicname -- 企业营业执照类型名称
            ,industry -- 所属行业编号
            ,legalname -- 法定代表人姓名
            ,taxorgancode -- 税务机关代码
            ,regdist -- 企业注册地址行政区划数字代码
            ,busscode -- 个体工商户营业执照代码
            ,ownerprop -- 所有制性质
            ,industryname -- 所属行业名称
            ,compaddr -- 企业地址
            ,totalassets -- 企业总资产总额
            ,loanpassword -- 贷款卡密码
            ,accountingsystemname -- 适用会计制度名称
            ,operreve -- 营业收入(年)
            ,updatedate -- 更新时间
            ,businessid -- 企业编号
            ,bussbank -- 主要结算银行
            ,busilictype -- 企业营业执照类型代码
            ,corporgid -- 法人机构编号
            ,loancode -- 贷款卡号/中征码
            ,relrepyid -- 相关还款责任人核心客户号
            ,establishdate -- 企业成立日期
            ,legalphone -- 法定代表人电话号码
            ,legalemail -- 法定代表人电子邮箱
            ,regcapital -- 注册资本
            ,certcode -- 组织机构代码证号码
            ,relrepyidentype -- 相关还款责任人身份类型
            ,certid -- 证件号
            ,busslegaltype -- 企业控股类型
            ,bussrentend -- 租赁到期日
            ,nationaltaxcode -- 国税登记号
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,industrytype -- 所属行业
            ,isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
            ,ishightechnologyent -- 是否高新技术企业
            ,istechnologyent -- 是否科技型企业
            ,isscientifictechent -- 是否科创企业
            ,isspecializedgiantent -- 是否专精特新小巨人企业
            ,isspecializedsmallandmident -- 是否专精特新中小企业
            ,istechnologysmallandmident -- 是否科技型中小企业
            ,isindustrysinglechampionent -- 是否制造业单项冠军企业
            ,isnationaltechnologinnovationent -- 是否国家技术创新示范企业
            ,isgarden -- 是否园区贷
            ,regno -- 注册号
            ,offareacode -- 注册地址行政区编号
            ,province -- 所在省份
            ,regcapcur -- 注册资本币种
            ,runstatus -- 经营状态
            ,canceldate -- 注销日期
            ,revokedate -- 吊销日期
            ,address -- 住址
            ,busiscope2 -- 经营(业务)范围及方式
            ,chkyear -- 最后年检年度
            ,cocode -- 国民经济行业代码
            ,coname -- 国民经济行业名称
            ,creditcode -- 证件号码
            ,city -- 市/州/地区
            ,economicid -- 经营实体ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.licname -- 企业登记注册类型名称
    ,o.certtype -- 企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.confirmcompsize -- 我行认定企业规模
    ,o.taxtype -- 纳税类型1-小规模纳税人2-一般纳税人
    ,o.taxorganname -- 主管税务机关名称
    ,o.relation -- 借款人与经营实体的关系
    ,o.accountingsystem -- 适用会计制度
    ,o.customername -- 经营者姓名
    ,o.taxlevel -- 纳税信用等级a，b，c，d
    ,o.customerid -- 客户编号
    ,o.legalcertcode -- 经营者证件号码
    ,o.comptel -- 经营企业电话
    ,o.landtaxcode -- 地税登记号
    ,o.shareratio -- 股东占股比例
    ,o.businessname -- 企业名称
    ,o.inputuserid -- 登记人
    ,o.legalcert -- 经营者证件类型
    ,o.updateuserid -- 更新人
    ,o.workersnum -- 企业员工人数
    ,o.regaddres -- 注册地址
    ,o.realcapital -- 实收资本
    ,o.lictype -- 企业登记注册类型代码
    ,o.citnum -- 中征码
    ,o.bussowner -- 经营场所所有权
    ,o.telephone -- 联系电话
    ,o.bussenddate -- 营业执照到期日期
    ,o.busstime -- 本行业从业时间
    ,o.bussname -- 个体工商户名称
    ,o.taxpayerstate -- 纳税人状态名称1-正常2-非正常
    ,o.relrepyidtype -- 相关还款责任人证件类型
    ,o.bussregdate -- 营业执照注册日期
    ,o.formtype -- 组成形式
    ,o.compzip -- 经营企业地址邮编
    ,o.relrepyrsplpsntype -- 相关还款责任人类型
    ,o.compsize -- 企业规模
    ,o.bussmain -- 经营范围
    ,o.inputdate -- 登记时间
    ,o.comestatus -- 来源状态
    ,o.busilicname -- 企业营业执照类型名称
    ,o.industry -- 所属行业编号
    ,o.legalname -- 法定代表人姓名
    ,o.taxorgancode -- 税务机关代码
    ,o.regdist -- 企业注册地址行政区划数字代码
    ,o.busscode -- 个体工商户营业执照代码
    ,o.ownerprop -- 所有制性质
    ,o.industryname -- 所属行业名称
    ,o.compaddr -- 企业地址
    ,o.totalassets -- 企业总资产总额
    ,o.loanpassword -- 贷款卡密码
    ,o.accountingsystemname -- 适用会计制度名称
    ,o.operreve -- 营业收入(年)
    ,o.updatedate -- 更新时间
    ,o.businessid -- 企业编号
    ,o.bussbank -- 主要结算银行
    ,o.busilictype -- 企业营业执照类型代码
    ,o.corporgid -- 法人机构编号
    ,o.loancode -- 贷款卡号/中征码
    ,o.relrepyid -- 相关还款责任人核心客户号
    ,o.establishdate -- 企业成立日期
    ,o.legalphone -- 法定代表人电话号码
    ,o.legalemail -- 法定代表人电子邮箱
    ,o.regcapital -- 注册资本
    ,o.certcode -- 组织机构代码证号码
    ,o.relrepyidentype -- 相关还款责任人身份类型
    ,o.certid -- 证件号
    ,o.busslegaltype -- 企业控股类型
    ,o.bussrentend -- 租赁到期日
    ,o.nationaltaxcode -- 国税登记号
    ,o.updateorgid -- 更新机构
    ,o.inputorgid -- 登记机构
    ,o.industrytype -- 所属行业
    ,o.isoperatingentinvolvespecialized -- 经营企业是否涉及专精特新
    ,o.ishightechnologyent -- 是否高新技术企业
    ,o.istechnologyent -- 是否科技型企业
    ,o.isscientifictechent -- 是否科创企业
    ,o.isspecializedgiantent -- 是否专精特新小巨人企业
    ,o.isspecializedsmallandmident -- 是否专精特新中小企业
    ,o.istechnologysmallandmident -- 是否科技型中小企业
    ,o.isindustrysinglechampionent -- 是否制造业单项冠军企业
    ,o.isnationaltechnologinnovationent -- 是否国家技术创新示范企业
    ,o.isgarden -- 是否园区贷
    ,o.regno -- 注册号
    ,o.offareacode -- 注册地址行政区编号
    ,o.province -- 所在省份
    ,o.regcapcur -- 注册资本币种
    ,o.runstatus -- 经营状态
    ,o.canceldate -- 注销日期
    ,o.revokedate -- 吊销日期
    ,o.address -- 住址
    ,o.busiscope2 -- 经营(业务)范围及方式
    ,o.chkyear -- 最后年检年度
    ,o.cocode -- 国民经济行业代码
    ,o.coname -- 国民经济行业名称
    ,o.creditcode -- 证件号码
    ,o.city -- 市/州/地区
    ,o.economicid -- 经营实体ID
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
from ${iol_schema}.icms_ind_economic_bk o
    left join ${iol_schema}.icms_ind_economic_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_economic_cl d
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
--truncate table ${iol_schema}.icms_ind_economic;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_economic') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_economic drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_economic add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_economic exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_economic_cl;
alter table ${iol_schema}.icms_ind_economic exchange partition p_20991231 with table ${iol_schema}.icms_ind_economic_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_economic to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_economic_op purge;
drop table ${iol_schema}.icms_ind_economic_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_economic_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_economic',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
