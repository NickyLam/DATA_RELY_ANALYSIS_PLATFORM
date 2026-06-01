/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_ind_economic
CreateDate: 20250509
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.icms_ind_economic drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_ind_economic add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_ind_economic (
etl_dt  --数据日期
,serialno  --流水号
,licname  --企业登记注册类型名称
,certtype  --企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
,migtflag  --迁移标志：crs rcr ilc upl
,confirmcompsize  --我行认定企业规模
,taxtype  --纳税类型1-小规模纳税人2-一般纳税人
,taxorganname  --主管税务机关名称
,relation  --借款人与经营实体的关系
,accountingsystem  --适用会计制度
,customername  --经营者姓名
,taxlevel  --纳税信用等级a，b，c，d
,customerid  --客户编号
,legalcertcode  --经营者证件号码
,comptel  --经营企业电话
,landtaxcode  --地税登记号
,shareratio  --股东占股比例
,businessname  --企业名称
,inputuserid  --登记人
,legalcert  --经营者证件类型
,updateuserid  --更新人
,workersnum  --企业员工人数
,regaddres  --注册地址
,realcapital  --实收资本
,lictype  --企业登记注册类型代码
,citnum  --中征码
,bussowner  --经营场所所有权
,telephone  --联系电话
,bussenddate  --营业执照到期日期
,busstime  --本行业从业时间
,bussname  --个体工商户名称
,taxpayerstate  --纳税人状态名称1-正常2-非正常
,relrepyidtype  --相关还款责任人证件类型
,bussregdate  --营业执照注册日期
,formtype  --组成形式
,compzip  --经营企业地址邮编
,relrepyrsplpsntype  --相关还款责任人类型
,compsize  --企业规模
,bussmain  --经营范围
,inputdate  --登记时间
,comestatus  --来源状态
,busilicname  --企业营业执照类型名称
,industry  --所属行业编号
,legalname  --法定代表人姓名
,taxorgancode  --税务机关代码
,regdist  --企业注册地址行政区划数字代码
,busscode  --个体工商户营业执照代码
,ownerprop  --所有制性质
,industryname  --所属行业名称
,compaddr  --企业地址
,totalassets  --企业总资产总额
,loanpassword  --贷款卡密码
,accountingsystemname  --适用会计制度名称
,operreve  --营业收入(年)
,updatedate  --更新时间
,businessid  --企业编号
,bussbank  --主要结算银行
,busilictype  --企业营业执照类型代码
,corporgid  --法人机构编号
,loancode  --贷款卡号/中征码
,relrepyid  --相关还款责任人核心客户号
,establishdate  --企业成立日期
,legalphone  --法定代表人电话号码
,legalemail  --法定代表人电子邮箱
,regcapital  --注册资本
,certcode  --组织机构代码证号码
,relrepyidentype  --相关还款责任人身份类型
,certid  --证件号
,busslegaltype  --企业控股类型
,bussrentend  --租赁到期日
,nationaltaxcode  --国税登记号
,updateorgid  --更新机构
,inputorgid  --登记机构
,industrytype  --所属行业
,isoperatingentinvolvespecialized  --经营企业是否涉及专精特新
,ishightechnologyent  --是否高新技术企业
,istechnologyent  --是否科技型企业
,isscientifictechent  --是否科创企业
,isspecializedgiantent  --是否专精特新小巨人企业
,isspecializedsmallandmident  --是否专精特新中小企业
,istechnologysmallandmident  --是否科技型中小企业
,isindustrysinglechampionent  --是否制造业单项冠军企业
,isnationaltechnologinnovationent  --是否国家技术创新示范企业
,isgarden  --是否园区贷
,regno  --注册号
,offareacode  --注册地址行政区编号
,province  --所在省份
,regcapcur  --注册资本币种
,runstatus  --经营状态
,canceldate  --注销日期
,revokedate  --吊销日期
,address  --住址
,busiscope2  --经营(业务)范围及方式
,chkyear  --最后年检年度
,cocode  --国民经济行业代码
,coname  --国民经济行业名称
,creditcode  --证件号码
,city  --市/州/地区
,economicid  --经营实体id

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno --流水号
,replace(replace(t1.licname,chr(13),''),chr(10),'') as licname --企业登记注册类型名称
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype --企业证件类型证件类型（代码：1-组机构代码2-营业执照3-其他）
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.confirmcompsize,chr(13),''),chr(10),'') as confirmcompsize --我行认定企业规模
,replace(replace(t1.taxtype,chr(13),''),chr(10),'') as taxtype --纳税类型1-小规模纳税人2-一般纳税人
,replace(replace(t1.taxorganname,chr(13),''),chr(10),'') as taxorganname --主管税务机关名称
,replace(replace(t1.relation,chr(13),''),chr(10),'') as relation --借款人与经营实体的关系
,replace(replace(t1.accountingsystem,chr(13),''),chr(10),'') as accountingsystem --适用会计制度
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --经营者姓名
,replace(replace(t1.taxlevel,chr(13),''),chr(10),'') as taxlevel --纳税信用等级a，b，c，d
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号
,replace(replace(t1.legalcertcode,chr(13),''),chr(10),'') as legalcertcode --经营者证件号码
,replace(replace(t1.comptel,chr(13),''),chr(10),'') as comptel --经营企业电话
,replace(replace(t1.landtaxcode,chr(13),''),chr(10),'') as landtaxcode --地税登记号
,replace(replace(t1.shareratio,chr(13),''),chr(10),'') as shareratio --股东占股比例
,replace(replace(t1.businessname,chr(13),''),chr(10),'') as businessname --企业名称
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.legalcert,chr(13),''),chr(10),'') as legalcert --经营者证件类型
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,t1.workersnum as workersnum --企业员工人数
,replace(replace(t1.regaddres,chr(13),''),chr(10),'') as regaddres --注册地址
,t1.realcapital as realcapital --实收资本
,replace(replace(t1.lictype,chr(13),''),chr(10),'') as lictype --企业登记注册类型代码
,replace(replace(t1.citnum,chr(13),''),chr(10),'') as citnum --中征码
,replace(replace(t1.bussowner,chr(13),''),chr(10),'') as bussowner --经营场所所有权
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone --联系电话
,t1.bussenddate as bussenddate --营业执照到期日期
,replace(replace(t1.busstime,chr(13),''),chr(10),'') as busstime --本行业从业时间
,replace(replace(t1.bussname,chr(13),''),chr(10),'') as bussname --个体工商户名称
,replace(replace(t1.taxpayerstate,chr(13),''),chr(10),'') as taxpayerstate --纳税人状态名称1-正常2-非正常
,replace(replace(t1.relrepyidtype,chr(13),''),chr(10),'') as relrepyidtype --相关还款责任人证件类型
,t1.bussregdate as bussregdate --营业执照注册日期
,replace(replace(t1.formtype,chr(13),''),chr(10),'') as formtype --组成形式
,replace(replace(t1.compzip,chr(13),''),chr(10),'') as compzip --经营企业地址邮编
,replace(replace(t1.relrepyrsplpsntype,chr(13),''),chr(10),'') as relrepyrsplpsntype --相关还款责任人类型
,replace(replace(t1.compsize,chr(13),''),chr(10),'') as compsize --企业规模
,replace(replace(t1.bussmain,chr(13),''),chr(10),'') as bussmain --经营范围
,t1.inputdate as inputdate --登记时间
,replace(replace(t1.comestatus,chr(13),''),chr(10),'') as comestatus --来源状态
,replace(replace(t1.busilicname,chr(13),''),chr(10),'') as busilicname --企业营业执照类型名称
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry --所属行业编号
,replace(replace(t1.legalname,chr(13),''),chr(10),'') as legalname --法定代表人姓名
,replace(replace(t1.taxorgancode,chr(13),''),chr(10),'') as taxorgancode --税务机关代码
,replace(replace(t1.regdist,chr(13),''),chr(10),'') as regdist --企业注册地址行政区划数字代码
,replace(replace(t1.busscode,chr(13),''),chr(10),'') as busscode --个体工商户营业执照代码
,replace(replace(t1.ownerprop,chr(13),''),chr(10),'') as ownerprop --所有制性质
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname --所属行业名称
,replace(replace(t1.compaddr,chr(13),''),chr(10),'') as compaddr --企业地址
,t1.totalassets as totalassets --企业总资产总额
,replace(replace(t1.loanpassword,chr(13),''),chr(10),'') as loanpassword --贷款卡密码
,replace(replace(t1.accountingsystemname,chr(13),''),chr(10),'') as accountingsystemname --适用会计制度名称
,t1.operreve as operreve --营业收入(年)
,t1.updatedate as updatedate --更新时间
,replace(replace(t1.businessid,chr(13),''),chr(10),'') as businessid --企业编号
,replace(replace(t1.bussbank,chr(13),''),chr(10),'') as bussbank --主要结算银行
,replace(replace(t1.busilictype,chr(13),''),chr(10),'') as busilictype --企业营业执照类型代码
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.loancode,chr(13),''),chr(10),'') as loancode --贷款卡号/中征码
,replace(replace(t1.relrepyid,chr(13),''),chr(10),'') as relrepyid --相关还款责任人核心客户号
,t1.establishdate as establishdate --企业成立日期
,replace(replace(t1.legalphone,chr(13),''),chr(10),'') as legalphone --法定代表人电话号码
,replace(replace(t1.legalemail,chr(13),''),chr(10),'') as legalemail --法定代表人电子邮箱
,t1.regcapital as regcapital --注册资本
,replace(replace(t1.certcode,chr(13),''),chr(10),'') as certcode --组织机构代码证号码
,replace(replace(t1.relrepyidentype,chr(13),''),chr(10),'') as relrepyidentype --相关还款责任人身份类型
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid --证件号
,replace(replace(t1.busslegaltype,chr(13),''),chr(10),'') as busslegaltype --企业控股类型
,t1.bussrentend as bussrentend --租赁到期日
,replace(replace(t1.nationaltaxcode,chr(13),''),chr(10),'') as nationaltaxcode --国税登记号
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构
,replace(replace(t1.industrytype,chr(13),''),chr(10),'') as industrytype --所属行业
,replace(replace(t1.isoperatingentinvolvespecialized,chr(13),''),chr(10),'') as isoperatingentinvolvespecialized --经营企业是否涉及专精特新
,replace(replace(t1.ishightechnologyent,chr(13),''),chr(10),'') as ishightechnologyent --是否高新技术企业
,replace(replace(t1.istechnologyent,chr(13),''),chr(10),'') as istechnologyent --是否科技型企业
,replace(replace(t1.isscientifictechent,chr(13),''),chr(10),'') as isscientifictechent --是否科创企业
,replace(replace(t1.isspecializedgiantent,chr(13),''),chr(10),'') as isspecializedgiantent --是否专精特新小巨人企业
,replace(replace(t1.isspecializedsmallandmident,chr(13),''),chr(10),'') as isspecializedsmallandmident --是否专精特新中小企业
,replace(replace(t1.istechnologysmallandmident,chr(13),''),chr(10),'') as istechnologysmallandmident --是否科技型中小企业
,replace(replace(t1.isindustrysinglechampionent,chr(13),''),chr(10),'') as isindustrysinglechampionent --是否制造业单项冠军企业
,replace(replace(t1.isnationaltechnologinnovationent,chr(13),''),chr(10),'') as isnationaltechnologinnovationent --是否国家技术创新示范企业
,replace(replace(t1.isgarden,chr(13),''),chr(10),'') as isgarden --是否园区贷
,replace(replace(t1.regno,chr(13),''),chr(10),'') as regno --注册号
,replace(replace(t1.offareacode,chr(13),''),chr(10),'') as offareacode --注册地址行政区编号
,replace(replace(t1.province,chr(13),''),chr(10),'') as province --所在省份
,replace(replace(t1.regcapcur,chr(13),''),chr(10),'') as regcapcur --注册资本币种
,replace(replace(t1.runstatus,chr(13),''),chr(10),'') as runstatus --经营状态
,replace(replace(t1.canceldate,chr(13),''),chr(10),'') as canceldate --注销日期
,replace(replace(t1.revokedate,chr(13),''),chr(10),'') as revokedate --吊销日期
,replace(replace(t1.address,chr(13),''),chr(10),'') as address --住址
,replace(replace(t1.busiscope2,chr(13),''),chr(10),'') as busiscope2 --经营(业务)范围及方式
,replace(replace(t1.chkyear,chr(13),''),chr(10),'') as chkyear --最后年检年度
,replace(replace(t1.cocode,chr(13),''),chr(10),'') as cocode --国民经济行业代码
,replace(replace(t1.coname,chr(13),''),chr(10),'') as coname --国民经济行业名称
,replace(replace(t1.creditcode,chr(13),''),chr(10),'') as creditcode --证件号码
,replace(replace(t1.city,chr(13),''),chr(10),'') as city --市/州/地区
,replace(replace(t1.economicid,chr(13),''),chr(10),'') as economicid --经营实体id
from ${iol_schema}.icms_ind_economic t1    --个人经营企业信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_ind_economic',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
