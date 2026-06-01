/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icms_ind_info
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
alter table ${idl_schema}.icms_ind_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icms_ind_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icms_ind_info (
etl_dt  --数据日期
,customerid  --客户编号个人客户编号
,customerdetail  --客户细类
,newcreditmonthpay  --本次贷款月支出
,empstatus  --就业状况
,cpndist  --单位所在地行政区划
,workname  --单位名称
,livingyears  --本地居住年限(年)
,updateorgid  --更新机构
,nativetype  --农村城市标志
,incomesource  --主要经济来源
,oldcreditmonthpay  --存量贷款月支出
,inputorgid  --登记机构编号
,corporgid  --法人机构编号
,nation  --国籍
,updatedate  --更新日期
,nationality  --民族民族（代码：1-汉族2-其他少数名族）
,familymonthincome  --家庭月收入
,emergencycontactaddress  --紧急联系人地址
,ishavecar  --自有汽车情况
,homedetails  --家庭描述
,occupation  --职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
,selfyearincome  --个人年收入
,emergencycontactmobilephone  --紧急联系人手机
,sino  --社会保险号
,payaccountbank  --工资卡开户银行
,nativeaddress  --户籍所在地
,edudegree  --最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
,homedebtsum  --家庭总负债
,evaluatedate  --评估日期
,residist  --居住地行政区划
,maildist  --通讯地行政区划
,localcontractaddress  --本地联系人地址
,livingareapostalcode  --居住地邮编
,isrelative  --是否我行关联方标志
,entscale  --企业规模
,healthstatus  --健康状况
,driveryears  --驾龄
,industry  --单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
,iddist  --证件签发机关所在地行政区划
,birthday  --出生日期
,payaccount  --工资账号
,nineelements  --九要素是否齐全(1是2否)
,familystatus  --居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
,isbankstaff  --是否行员标志
,graduateschool  --毕业学校
,children  --子女情况（人）
,indmonthincome  --个人月收入
,currentworkyears  --现单位工作年限
,isfarmer  --是否农户
,carprice  --汽车价值
,billstyle  --账单形式
,unitphone  --单位电话
,indtype  --客户类型
,usuallivingarea  --常住地行政区划
,nativeadd  --户籍地址
,eduexperience  --最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
,rgstad  --家庭住址行政区划代码
,graduateyear  --毕业年份
,sex  --性别性别（代码：1-男2-女3-未说明的性别）
,workbegindate  --加入本单位日期
,housevalue  --房屋价值
,title  --职称等级
,migtflag  --迁移标志：crs rcr ilc upl
,localcontract  --本地联系人
,iscreditlimit  --是否授信暂禁
,remark  --备注
,idorgname  --证件签发机关名称
,workstartdate  --本单位工作起始年份
,localcontractmobilephone  --本地联系人手机
,drivercartype  --准驾车型
,taxedannualincome  --客户纳税年收入
,unitaddress  --单位地址
,homeyearincome  --家庭年收入
,headship  --职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
,customername  --客户姓名客户名称
,politicalface  --政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
,emergencycontact  --紧急联系人
,driverlicenseid  --驾照档案编号
,ishavework  --是否有工作单位
,email  --邮箱
,updateuserid  --更新人
,nativeplace  --籍贯
,nativedetail  --户籍性质
,customertype  --客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
,totalsum  --资产总额
,city  --市/州/地区
,socialsecyear  --社保缴纳时长(年）
,unitpostcode  --单位邮编
,inputdate  --登记日期
,incomeprove  --收入证明形式
,incomeratio  --收入负债比
,creditlevel  --内部信用评级级别
,hndist  --户籍所在地行政区划
,lmcredittype  --客户洗钱风险分类
,supportpopulations  --供养人口（人）
,unitkind  --单位性质
,unitcountry  --单位所在地
,marriage  --婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
,indcharacter  --客户性质
,hobby  --兴趣爱好
,inputuserid  --登记人
,houseadd  --家庭地址
,localcontracttelephone  --本地联系人电话
,migtoldvalue  --迁移数据-参数转换前字段值
,othercareer  --其他职业说明
,cuscreditscorelevel  --客户信用分数等级:内评
,migtcustomerid  --转换前客户号
,isfamilyfarm  --是否家庭农场
,islowhouse  --是否低保户
,isdisabled  --是否残疾人
,cuscreditscore  --客户信用分数
,holdratio  --控股比例
,incomecurrency  --收入币种
,formername  --曾用名
,productid  --产品编号
,channel  --渠道

)
select
to_date('${batch_date}','yyyymmdd') as etl_dt --数据日期
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid --客户编号个人客户编号
,replace(replace(t1.customerdetail,chr(13),''),chr(10),'') as customerdetail --客户细类
,t1.newcreditmonthpay as newcreditmonthpay --本次贷款月支出
,replace(replace(t1.empstatus,chr(13),''),chr(10),'') as empstatus --就业状况
,replace(replace(t1.cpndist,chr(13),''),chr(10),'') as cpndist --单位所在地行政区划
,replace(replace(t1.workname,chr(13),''),chr(10),'') as workname --单位名称
,t1.livingyears as livingyears --本地居住年限(年)
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid --更新机构
,replace(replace(t1.nativetype,chr(13),''),chr(10),'') as nativetype --农村城市标志
,replace(replace(t1.incomesource,chr(13),''),chr(10),'') as incomesource --主要经济来源
,t1.oldcreditmonthpay as oldcreditmonthpay --存量贷款月支出
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid --登记机构编号
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid --法人机构编号
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation --国籍
,t1.updatedate as updatedate --更新日期
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality --民族民族（代码：1-汉族2-其他少数名族）
,t1.familymonthincome as familymonthincome --家庭月收入
,replace(replace(t1.emergencycontactaddress,chr(13),''),chr(10),'') as emergencycontactaddress --紧急联系人地址
,replace(replace(t1.ishavecar,chr(13),''),chr(10),'') as ishavecar --自有汽车情况
,replace(replace(t1.homedetails,chr(13),''),chr(10),'') as homedetails --家庭描述
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation --职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
,t1.selfyearincome as selfyearincome --个人年收入
,replace(replace(t1.emergencycontactmobilephone,chr(13),''),chr(10),'') as emergencycontactmobilephone --紧急联系人手机
,replace(replace(t1.sino,chr(13),''),chr(10),'') as sino --社会保险号
,replace(replace(t1.payaccountbank,chr(13),''),chr(10),'') as payaccountbank --工资卡开户银行
,replace(replace(t1.nativeaddress,chr(13),''),chr(10),'') as nativeaddress --户籍所在地
,replace(replace(t1.edudegree,chr(13),''),chr(10),'') as edudegree --最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
,t1.homedebtsum as homedebtsum --家庭总负债
,t1.evaluatedate as evaluatedate --评估日期
,replace(replace(t1.residist,chr(13),''),chr(10),'') as residist --居住地行政区划
,replace(replace(t1.maildist,chr(13),''),chr(10),'') as maildist --通讯地行政区划
,replace(replace(t1.localcontractaddress,chr(13),''),chr(10),'') as localcontractaddress --本地联系人地址
,replace(replace(t1.livingareapostalcode,chr(13),''),chr(10),'') as livingareapostalcode --居住地邮编
,replace(replace(t1.isrelative,chr(13),''),chr(10),'') as isrelative --是否我行关联方标志
,replace(replace(t1.entscale,chr(13),''),chr(10),'') as entscale --企业规模
,replace(replace(t1.healthstatus,chr(13),''),chr(10),'') as healthstatus --健康状况
,t1.driveryears as driveryears --驾龄
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry --单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
,replace(replace(t1.iddist,chr(13),''),chr(10),'') as iddist --证件签发机关所在地行政区划
,t1.birthday as birthday --出生日期
,replace(replace(t1.payaccount,chr(13),''),chr(10),'') as payaccount --工资账号
,replace(replace(t1.nineelements,chr(13),''),chr(10),'') as nineelements --九要素是否齐全(1是2否)
,replace(replace(t1.familystatus,chr(13),''),chr(10),'') as familystatus --居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
,replace(replace(t1.isbankstaff,chr(13),''),chr(10),'') as isbankstaff --是否行员标志
,replace(replace(t1.graduateschool,chr(13),''),chr(10),'') as graduateschool --毕业学校
,t1.children as children --子女情况（人）
,t1.indmonthincome as indmonthincome --个人月收入
,t1.currentworkyears as currentworkyears --现单位工作年限
,replace(replace(t1.isfarmer,chr(13),''),chr(10),'') as isfarmer --是否农户
,t1.carprice as carprice --汽车价值
,replace(replace(t1.billstyle,chr(13),''),chr(10),'') as billstyle --账单形式
,replace(replace(t1.unitphone,chr(13),''),chr(10),'') as unitphone --单位电话
,replace(replace(t1.indtype,chr(13),''),chr(10),'') as indtype --客户类型
,replace(replace(t1.usuallivingarea,chr(13),''),chr(10),'') as usuallivingarea --常住地行政区划
,replace(replace(t1.nativeadd,chr(13),''),chr(10),'') as nativeadd --户籍地址
,replace(replace(t1.eduexperience,chr(13),''),chr(10),'') as eduexperience --最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
,replace(replace(t1.rgstad,chr(13),''),chr(10),'') as rgstad --家庭住址行政区划代码
,t1.graduateyear as graduateyear --毕业年份
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex --性别性别（代码：1-男2-女3-未说明的性别）
,t1.workbegindate as workbegindate --加入本单位日期
,t1.housevalue as housevalue --房屋价值
,replace(replace(t1.title,chr(13),''),chr(10),'') as title --职称等级
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag --迁移标志：crs rcr ilc upl
,replace(replace(t1.localcontract,chr(13),''),chr(10),'') as localcontract --本地联系人
,replace(replace(t1.iscreditlimit,chr(13),''),chr(10),'') as iscreditlimit --是否授信暂禁
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark --备注
,replace(replace(t1.idorgname,chr(13),''),chr(10),'') as idorgname --证件签发机关名称
,replace(replace(t1.workstartdate,chr(13),''),chr(10),'') as workstartdate --本单位工作起始年份
,replace(replace(t1.localcontractmobilephone,chr(13),''),chr(10),'') as localcontractmobilephone --本地联系人手机
,replace(replace(t1.drivercartype,chr(13),''),chr(10),'') as drivercartype --准驾车型
,t1.taxedannualincome as taxedannualincome --客户纳税年收入
,replace(replace(t1.unitaddress,chr(13),''),chr(10),'') as unitaddress --单位地址
,t1.homeyearincome as homeyearincome --家庭年收入
,replace(replace(t1.headship,chr(13),''),chr(10),'') as headship --职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername --客户姓名客户名称
,replace(replace(t1.politicalface,chr(13),''),chr(10),'') as politicalface --政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
,replace(replace(t1.emergencycontact,chr(13),''),chr(10),'') as emergencycontact --紧急联系人
,replace(replace(t1.driverlicenseid,chr(13),''),chr(10),'') as driverlicenseid --驾照档案编号
,replace(replace(t1.ishavework,chr(13),''),chr(10),'') as ishavework --是否有工作单位
,replace(replace(t1.email,chr(13),''),chr(10),'') as email --邮箱
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid --更新人
,replace(replace(t1.nativeplace,chr(13),''),chr(10),'') as nativeplace --籍贯
,replace(replace(t1.nativedetail,chr(13),''),chr(10),'') as nativedetail --户籍性质
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype --客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
,t1.totalsum as totalsum --资产总额
,replace(replace(t1.city,chr(13),''),chr(10),'') as city --市/州/地区
,replace(replace(t1.socialsecyear,chr(13),''),chr(10),'') as socialsecyear --社保缴纳时长(年）
,replace(replace(t1.unitpostcode,chr(13),''),chr(10),'') as unitpostcode --单位邮编
,t1.inputdate as inputdate --登记日期
,replace(replace(t1.incomeprove,chr(13),''),chr(10),'') as incomeprove --收入证明形式
,t1.incomeratio as incomeratio --收入负债比
,replace(replace(t1.creditlevel,chr(13),''),chr(10),'') as creditlevel --内部信用评级级别
,replace(replace(t1.hndist,chr(13),''),chr(10),'') as hndist --户籍所在地行政区划
,replace(replace(t1.lmcredittype,chr(13),''),chr(10),'') as lmcredittype --客户洗钱风险分类
,t1.supportpopulations as supportpopulations --供养人口（人）
,replace(replace(t1.unitkind,chr(13),''),chr(10),'') as unitkind --单位性质
,replace(replace(t1.unitcountry,chr(13),''),chr(10),'') as unitcountry --单位所在地
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage --婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
,replace(replace(t1.indcharacter,chr(13),''),chr(10),'') as indcharacter --客户性质
,replace(replace(t1.hobby,chr(13),''),chr(10),'') as hobby --兴趣爱好
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid --登记人
,replace(replace(t1.houseadd,chr(13),''),chr(10),'') as houseadd --家庭地址
,replace(replace(t1.localcontracttelephone,chr(13),''),chr(10),'') as localcontracttelephone --本地联系人电话
,replace(replace(t1.migtoldvalue,chr(13),''),chr(10),'') as migtoldvalue --迁移数据-参数转换前字段值
,replace(replace(t1.othercareer,chr(13),''),chr(10),'') as othercareer --其他职业说明
,replace(replace(t1.cuscreditscorelevel,chr(13),''),chr(10),'') as cuscreditscorelevel --客户信用分数等级:内评
,replace(replace(t1.migtcustomerid,chr(13),''),chr(10),'') as migtcustomerid --转换前客户号
,replace(replace(t1.isfamilyfarm,chr(13),''),chr(10),'') as isfamilyfarm --是否家庭农场
,replace(replace(t1.islowhouse,chr(13),''),chr(10),'') as islowhouse --是否低保户
,replace(replace(t1.isdisabled,chr(13),''),chr(10),'') as isdisabled --是否残疾人
,t1.cuscreditscore as cuscreditscore --客户信用分数
,t1.holdratio as holdratio --控股比例
,replace(replace(t1.incomecurrency,chr(13),''),chr(10),'') as incomecurrency --收入币种
,replace(replace(t1.formername,chr(13),''),chr(10),'') as formername --曾用名
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid --产品编号
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel --渠道
from ${iol_schema}.icms_ind_info t1    --个人客户信息
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icms_ind_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
