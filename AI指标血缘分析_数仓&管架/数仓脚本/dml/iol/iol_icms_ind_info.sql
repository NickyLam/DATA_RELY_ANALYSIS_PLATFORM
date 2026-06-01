/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_info
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
create table ${iol_schema}.icms_ind_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ind_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_info_op purge;
drop table ${iol_schema}.icms_ind_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_info where 0=1;

create table ${iol_schema}.icms_ind_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ind_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_info_cl(
            customerid -- 客户编号个人客户编号
            ,customerdetail -- 客户细类
            ,newcreditmonthpay -- 本次贷款月支出
            ,empstatus -- 就业状况
            ,cpndist -- 单位所在地行政区划
            ,workname -- 单位名称
            ,livingyears -- 本地居住年限(年)
            ,updateorgid -- 更新机构
            ,nativetype -- 农村城市标志
            ,incomesource -- 主要经济来源
            ,oldcreditmonthpay -- 存量贷款月支出
            ,inputorgid -- 登记机构编号
            ,corporgid -- 法人机构编号
            ,nation -- 国籍
            ,updatedate -- 更新日期
            ,nationality -- 民族民族（代码：1-汉族2-其他少数名族）
            ,familymonthincome -- 家庭月收入
            ,emergencycontactaddress -- 紧急联系人地址
            ,ishavecar -- 自有汽车情况
            ,homedetails -- 家庭描述
            ,occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
            ,selfyearincome -- 个人年收入
            ,emergencycontactmobilephone -- 紧急联系人手机
            ,sino -- 社会保险号
            ,payaccountbank -- 工资卡开户银行
            ,nativeaddress -- 户籍所在地
            ,edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
            ,homedebtsum -- 家庭总负债
            ,evaluatedate -- 评估日期
            ,residist -- 居住地行政区划
            ,maildist -- 通讯地行政区划
            ,localcontractaddress -- 本地联系人地址
            ,livingareapostalcode -- 居住地邮编
            ,isrelative -- 是否我行关联方标志
            ,entscale -- 企业规模
            ,healthstatus -- 健康状况
            ,driveryears -- 驾龄
            ,industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
            ,iddist -- 证件签发机关所在地行政区划
            ,birthday -- 出生日期
            ,payaccount -- 工资账号
            ,nineelements -- 九要素是否齐全(1是2否)
            ,familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
            ,isbankstaff -- 是否行员标志
            ,graduateschool -- 毕业学校
            ,children -- 子女情况（人）
            ,indmonthincome -- 个人月收入
            ,currentworkyears -- 现单位工作年限
            ,isfarmer -- 是否农户
            ,carprice -- 汽车价值
            ,billstyle -- 账单形式
            ,unitphone -- 单位电话
            ,indtype -- 客户类型
            ,usuallivingarea -- 常住地行政区划
            ,nativeadd -- 户籍地址
            ,eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
            ,rgstad -- 家庭住址行政区划代码
            ,graduateyear -- 毕业年份
            ,sex -- 性别性别（代码：1-男2-女3-未说明的性别）
            ,workbegindate -- 加入本单位日期
            ,housevalue -- 房屋价值
            ,title -- 职称等级
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,localcontract -- 本地联系人
            ,iscreditlimit -- 是否授信暂禁
            ,remark -- 备注
            ,idorgname -- 证件签发机关名称
            ,workstartdate -- 本单位工作起始年份
            ,localcontractmobilephone -- 本地联系人手机
            ,drivercartype -- 准驾车型
            ,taxedannualincome -- 客户纳税年收入
            ,unitaddress -- 单位地址
            ,homeyearincome -- 家庭年收入
            ,headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,customername -- 客户姓名客户名称
            ,politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
            ,emergencycontact -- 紧急联系人
            ,driverlicenseid -- 驾照档案编号
            ,ishavework -- 是否有工作单位
            ,email -- 邮箱
            ,updateuserid -- 更新人
            ,nativeplace -- 籍贯
            ,nativedetail -- 户籍性质
            ,customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
            ,totalsum -- 资产总额
            ,city -- 市/州/地区
            ,socialsecyear -- 社保缴纳时长(年）
            ,unitpostcode -- 单位邮编
            ,inputdate -- 登记日期
            ,incomeprove -- 收入证明形式
            ,incomeratio -- 收入负债比
            ,creditlevel -- 内部信用评级级别
            ,hndist -- 户籍所在地行政区划
            ,lmcredittype -- 客户洗钱风险分类
            ,supportpopulations -- 供养人口（人）
            ,unitkind -- 单位性质
            ,unitcountry -- 单位所在地
            ,marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
            ,indcharacter -- 客户性质
            ,hobby -- 兴趣爱好
            ,inputuserid -- 登记人
            ,houseadd -- 家庭地址
            ,localcontracttelephone -- 本地联系人电话
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,othercareer -- 其他职业说明
            ,cuscreditscorelevel -- 客户信用分数等级:内评
            ,migtcustomerid -- 转换前客户号
            ,isfamilyfarm -- 是否家庭农场
            ,islowhouse -- 是否低保户
            ,isdisabled -- 是否残疾人
            ,cuscreditscore -- 客户信用分数
            ,holdratio -- 控股比例
            ,incomecurrency -- 收入币种
            ,formername -- 曾用名
            ,productid -- 产品编号
            ,channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_info_op(
            customerid -- 客户编号个人客户编号
            ,customerdetail -- 客户细类
            ,newcreditmonthpay -- 本次贷款月支出
            ,empstatus -- 就业状况
            ,cpndist -- 单位所在地行政区划
            ,workname -- 单位名称
            ,livingyears -- 本地居住年限(年)
            ,updateorgid -- 更新机构
            ,nativetype -- 农村城市标志
            ,incomesource -- 主要经济来源
            ,oldcreditmonthpay -- 存量贷款月支出
            ,inputorgid -- 登记机构编号
            ,corporgid -- 法人机构编号
            ,nation -- 国籍
            ,updatedate -- 更新日期
            ,nationality -- 民族民族（代码：1-汉族2-其他少数名族）
            ,familymonthincome -- 家庭月收入
            ,emergencycontactaddress -- 紧急联系人地址
            ,ishavecar -- 自有汽车情况
            ,homedetails -- 家庭描述
            ,occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
            ,selfyearincome -- 个人年收入
            ,emergencycontactmobilephone -- 紧急联系人手机
            ,sino -- 社会保险号
            ,payaccountbank -- 工资卡开户银行
            ,nativeaddress -- 户籍所在地
            ,edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
            ,homedebtsum -- 家庭总负债
            ,evaluatedate -- 评估日期
            ,residist -- 居住地行政区划
            ,maildist -- 通讯地行政区划
            ,localcontractaddress -- 本地联系人地址
            ,livingareapostalcode -- 居住地邮编
            ,isrelative -- 是否我行关联方标志
            ,entscale -- 企业规模
            ,healthstatus -- 健康状况
            ,driveryears -- 驾龄
            ,industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
            ,iddist -- 证件签发机关所在地行政区划
            ,birthday -- 出生日期
            ,payaccount -- 工资账号
            ,nineelements -- 九要素是否齐全(1是2否)
            ,familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
            ,isbankstaff -- 是否行员标志
            ,graduateschool -- 毕业学校
            ,children -- 子女情况（人）
            ,indmonthincome -- 个人月收入
            ,currentworkyears -- 现单位工作年限
            ,isfarmer -- 是否农户
            ,carprice -- 汽车价值
            ,billstyle -- 账单形式
            ,unitphone -- 单位电话
            ,indtype -- 客户类型
            ,usuallivingarea -- 常住地行政区划
            ,nativeadd -- 户籍地址
            ,eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
            ,rgstad -- 家庭住址行政区划代码
            ,graduateyear -- 毕业年份
            ,sex -- 性别性别（代码：1-男2-女3-未说明的性别）
            ,workbegindate -- 加入本单位日期
            ,housevalue -- 房屋价值
            ,title -- 职称等级
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,localcontract -- 本地联系人
            ,iscreditlimit -- 是否授信暂禁
            ,remark -- 备注
            ,idorgname -- 证件签发机关名称
            ,workstartdate -- 本单位工作起始年份
            ,localcontractmobilephone -- 本地联系人手机
            ,drivercartype -- 准驾车型
            ,taxedannualincome -- 客户纳税年收入
            ,unitaddress -- 单位地址
            ,homeyearincome -- 家庭年收入
            ,headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,customername -- 客户姓名客户名称
            ,politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
            ,emergencycontact -- 紧急联系人
            ,driverlicenseid -- 驾照档案编号
            ,ishavework -- 是否有工作单位
            ,email -- 邮箱
            ,updateuserid -- 更新人
            ,nativeplace -- 籍贯
            ,nativedetail -- 户籍性质
            ,customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
            ,totalsum -- 资产总额
            ,city -- 市/州/地区
            ,socialsecyear -- 社保缴纳时长(年）
            ,unitpostcode -- 单位邮编
            ,inputdate -- 登记日期
            ,incomeprove -- 收入证明形式
            ,incomeratio -- 收入负债比
            ,creditlevel -- 内部信用评级级别
            ,hndist -- 户籍所在地行政区划
            ,lmcredittype -- 客户洗钱风险分类
            ,supportpopulations -- 供养人口（人）
            ,unitkind -- 单位性质
            ,unitcountry -- 单位所在地
            ,marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
            ,indcharacter -- 客户性质
            ,hobby -- 兴趣爱好
            ,inputuserid -- 登记人
            ,houseadd -- 家庭地址
            ,localcontracttelephone -- 本地联系人电话
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,othercareer -- 其他职业说明
            ,cuscreditscorelevel -- 客户信用分数等级:内评
            ,migtcustomerid -- 转换前客户号
            ,isfamilyfarm -- 是否家庭农场
            ,islowhouse -- 是否低保户
            ,isdisabled -- 是否残疾人
            ,cuscreditscore -- 客户信用分数
            ,holdratio -- 控股比例
            ,incomecurrency -- 收入币种
            ,formername -- 曾用名
            ,productid -- 产品编号
            ,channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customerid, o.customerid) as customerid -- 客户编号个人客户编号
    ,nvl(n.customerdetail, o.customerdetail) as customerdetail -- 客户细类
    ,nvl(n.newcreditmonthpay, o.newcreditmonthpay) as newcreditmonthpay -- 本次贷款月支出
    ,nvl(n.empstatus, o.empstatus) as empstatus -- 就业状况
    ,nvl(n.cpndist, o.cpndist) as cpndist -- 单位所在地行政区划
    ,nvl(n.workname, o.workname) as workname -- 单位名称
    ,nvl(n.livingyears, o.livingyears) as livingyears -- 本地居住年限(年)
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.nativetype, o.nativetype) as nativetype -- 农村城市标志
    ,nvl(n.incomesource, o.incomesource) as incomesource -- 主要经济来源
    ,nvl(n.oldcreditmonthpay, o.oldcreditmonthpay) as oldcreditmonthpay -- 存量贷款月支出
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.nation, o.nation) as nation -- 国籍
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.nationality, o.nationality) as nationality -- 民族民族（代码：1-汉族2-其他少数名族）
    ,nvl(n.familymonthincome, o.familymonthincome) as familymonthincome -- 家庭月收入
    ,nvl(n.emergencycontactaddress, o.emergencycontactaddress) as emergencycontactaddress -- 紧急联系人地址
    ,nvl(n.ishavecar, o.ishavecar) as ishavecar -- 自有汽车情况
    ,nvl(n.homedetails, o.homedetails) as homedetails -- 家庭描述
    ,nvl(n.occupation, o.occupation) as occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
    ,nvl(n.selfyearincome, o.selfyearincome) as selfyearincome -- 个人年收入
    ,nvl(n.emergencycontactmobilephone, o.emergencycontactmobilephone) as emergencycontactmobilephone -- 紧急联系人手机
    ,nvl(n.sino, o.sino) as sino -- 社会保险号
    ,nvl(n.payaccountbank, o.payaccountbank) as payaccountbank -- 工资卡开户银行
    ,nvl(n.nativeaddress, o.nativeaddress) as nativeaddress -- 户籍所在地
    ,nvl(n.edudegree, o.edudegree) as edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
    ,nvl(n.homedebtsum, o.homedebtsum) as homedebtsum -- 家庭总负债
    ,nvl(n.evaluatedate, o.evaluatedate) as evaluatedate -- 评估日期
    ,nvl(n.residist, o.residist) as residist -- 居住地行政区划
    ,nvl(n.maildist, o.maildist) as maildist -- 通讯地行政区划
    ,nvl(n.localcontractaddress, o.localcontractaddress) as localcontractaddress -- 本地联系人地址
    ,nvl(n.livingareapostalcode, o.livingareapostalcode) as livingareapostalcode -- 居住地邮编
    ,nvl(n.isrelative, o.isrelative) as isrelative -- 是否我行关联方标志
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.healthstatus, o.healthstatus) as healthstatus -- 健康状况
    ,nvl(n.driveryears, o.driveryears) as driveryears -- 驾龄
    ,nvl(n.industry, o.industry) as industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
    ,nvl(n.iddist, o.iddist) as iddist -- 证件签发机关所在地行政区划
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.payaccount, o.payaccount) as payaccount -- 工资账号
    ,nvl(n.nineelements, o.nineelements) as nineelements -- 九要素是否齐全(1是2否)
    ,nvl(n.familystatus, o.familystatus) as familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
    ,nvl(n.isbankstaff, o.isbankstaff) as isbankstaff -- 是否行员标志
    ,nvl(n.graduateschool, o.graduateschool) as graduateschool -- 毕业学校
    ,nvl(n.children, o.children) as children -- 子女情况（人）
    ,nvl(n.indmonthincome, o.indmonthincome) as indmonthincome -- 个人月收入
    ,nvl(n.currentworkyears, o.currentworkyears) as currentworkyears -- 现单位工作年限
    ,nvl(n.isfarmer, o.isfarmer) as isfarmer -- 是否农户
    ,nvl(n.carprice, o.carprice) as carprice -- 汽车价值
    ,nvl(n.billstyle, o.billstyle) as billstyle -- 账单形式
    ,nvl(n.unitphone, o.unitphone) as unitphone -- 单位电话
    ,nvl(n.indtype, o.indtype) as indtype -- 客户类型
    ,nvl(n.usuallivingarea, o.usuallivingarea) as usuallivingarea -- 常住地行政区划
    ,nvl(n.nativeadd, o.nativeadd) as nativeadd -- 户籍地址
    ,nvl(n.eduexperience, o.eduexperience) as eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
    ,nvl(n.rgstad, o.rgstad) as rgstad -- 家庭住址行政区划代码
    ,nvl(n.graduateyear, o.graduateyear) as graduateyear -- 毕业年份
    ,nvl(n.sex, o.sex) as sex -- 性别性别（代码：1-男2-女3-未说明的性别）
    ,nvl(n.workbegindate, o.workbegindate) as workbegindate -- 加入本单位日期
    ,nvl(n.housevalue, o.housevalue) as housevalue -- 房屋价值
    ,nvl(n.title, o.title) as title -- 职称等级
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crs rcr ilc upl
    ,nvl(n.localcontract, o.localcontract) as localcontract -- 本地联系人
    ,nvl(n.iscreditlimit, o.iscreditlimit) as iscreditlimit -- 是否授信暂禁
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.idorgname, o.idorgname) as idorgname -- 证件签发机关名称
    ,nvl(n.workstartdate, o.workstartdate) as workstartdate -- 本单位工作起始年份
    ,nvl(n.localcontractmobilephone, o.localcontractmobilephone) as localcontractmobilephone -- 本地联系人手机
    ,nvl(n.drivercartype, o.drivercartype) as drivercartype -- 准驾车型
    ,nvl(n.taxedannualincome, o.taxedannualincome) as taxedannualincome -- 客户纳税年收入
    ,nvl(n.unitaddress, o.unitaddress) as unitaddress -- 单位地址
    ,nvl(n.homeyearincome, o.homeyearincome) as homeyearincome -- 家庭年收入
    ,nvl(n.headship, o.headship) as headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,nvl(n.customername, o.customername) as customername -- 客户姓名客户名称
    ,nvl(n.politicalface, o.politicalface) as politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
    ,nvl(n.emergencycontact, o.emergencycontact) as emergencycontact -- 紧急联系人
    ,nvl(n.driverlicenseid, o.driverlicenseid) as driverlicenseid -- 驾照档案编号
    ,nvl(n.ishavework, o.ishavework) as ishavework -- 是否有工作单位
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.nativeplace, o.nativeplace) as nativeplace -- 籍贯
    ,nvl(n.nativedetail, o.nativedetail) as nativedetail -- 户籍性质
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
    ,nvl(n.totalsum, o.totalsum) as totalsum -- 资产总额
    ,nvl(n.city, o.city) as city -- 市/州/地区
    ,nvl(n.socialsecyear, o.socialsecyear) as socialsecyear -- 社保缴纳时长(年）
    ,nvl(n.unitpostcode, o.unitpostcode) as unitpostcode -- 单位邮编
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.incomeprove, o.incomeprove) as incomeprove -- 收入证明形式
    ,nvl(n.incomeratio, o.incomeratio) as incomeratio -- 收入负债比
    ,nvl(n.creditlevel, o.creditlevel) as creditlevel -- 内部信用评级级别
    ,nvl(n.hndist, o.hndist) as hndist -- 户籍所在地行政区划
    ,nvl(n.lmcredittype, o.lmcredittype) as lmcredittype -- 客户洗钱风险分类
    ,nvl(n.supportpopulations, o.supportpopulations) as supportpopulations -- 供养人口（人）
    ,nvl(n.unitkind, o.unitkind) as unitkind -- 单位性质
    ,nvl(n.unitcountry, o.unitcountry) as unitcountry -- 单位所在地
    ,nvl(n.marriage, o.marriage) as marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
    ,nvl(n.indcharacter, o.indcharacter) as indcharacter -- 客户性质
    ,nvl(n.hobby, o.hobby) as hobby -- 兴趣爱好
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.houseadd, o.houseadd) as houseadd -- 家庭地址
    ,nvl(n.localcontracttelephone, o.localcontracttelephone) as localcontracttelephone -- 本地联系人电话
    ,nvl(n.migtoldvalue, o.migtoldvalue) as migtoldvalue -- 迁移数据-参数转换前字段值
    ,nvl(n.othercareer, o.othercareer) as othercareer -- 其他职业说明
    ,nvl(n.cuscreditscorelevel, o.cuscreditscorelevel) as cuscreditscorelevel -- 客户信用分数等级:内评
    ,nvl(n.migtcustomerid, o.migtcustomerid) as migtcustomerid -- 转换前客户号
    ,nvl(n.isfamilyfarm, o.isfamilyfarm) as isfamilyfarm -- 是否家庭农场
    ,nvl(n.islowhouse, o.islowhouse) as islowhouse -- 是否低保户
    ,nvl(n.isdisabled, o.isdisabled) as isdisabled -- 是否残疾人
    ,nvl(n.cuscreditscore, o.cuscreditscore) as cuscreditscore -- 客户信用分数
    ,nvl(n.holdratio, o.holdratio) as holdratio -- 控股比例
    ,nvl(n.incomecurrency, o.incomecurrency) as incomecurrency -- 收入币种
    ,nvl(n.formername, o.formername) as formername -- 曾用名
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,case when
            n.customerid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customerid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customerid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ind_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ind_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customerid = n.customerid
where (
        o.customerid is null
    )
    or (
        n.customerid is null
    )
    or (
        o.customerdetail <> n.customerdetail
        or o.newcreditmonthpay <> n.newcreditmonthpay
        or o.empstatus <> n.empstatus
        or o.cpndist <> n.cpndist
        or o.workname <> n.workname
        or o.livingyears <> n.livingyears
        or o.updateorgid <> n.updateorgid
        or o.nativetype <> n.nativetype
        or o.incomesource <> n.incomesource
        or o.oldcreditmonthpay <> n.oldcreditmonthpay
        or o.inputorgid <> n.inputorgid
        or o.corporgid <> n.corporgid
        or o.nation <> n.nation
        or o.updatedate <> n.updatedate
        or o.nationality <> n.nationality
        or o.familymonthincome <> n.familymonthincome
        or o.emergencycontactaddress <> n.emergencycontactaddress
        or o.ishavecar <> n.ishavecar
        or o.homedetails <> n.homedetails
        or o.occupation <> n.occupation
        or o.selfyearincome <> n.selfyearincome
        or o.emergencycontactmobilephone <> n.emergencycontactmobilephone
        or o.sino <> n.sino
        or o.payaccountbank <> n.payaccountbank
        or o.nativeaddress <> n.nativeaddress
        or o.edudegree <> n.edudegree
        or o.homedebtsum <> n.homedebtsum
        or o.evaluatedate <> n.evaluatedate
        or o.residist <> n.residist
        or o.maildist <> n.maildist
        or o.localcontractaddress <> n.localcontractaddress
        or o.livingareapostalcode <> n.livingareapostalcode
        or o.isrelative <> n.isrelative
        or o.entscale <> n.entscale
        or o.healthstatus <> n.healthstatus
        or o.driveryears <> n.driveryears
        or o.industry <> n.industry
        or o.iddist <> n.iddist
        or o.birthday <> n.birthday
        or o.payaccount <> n.payaccount
        or o.nineelements <> n.nineelements
        or o.familystatus <> n.familystatus
        or o.isbankstaff <> n.isbankstaff
        or o.graduateschool <> n.graduateschool
        or o.children <> n.children
        or o.indmonthincome <> n.indmonthincome
        or o.currentworkyears <> n.currentworkyears
        or o.isfarmer <> n.isfarmer
        or o.carprice <> n.carprice
        or o.billstyle <> n.billstyle
        or o.unitphone <> n.unitphone
        or o.indtype <> n.indtype
        or o.usuallivingarea <> n.usuallivingarea
        or o.nativeadd <> n.nativeadd
        or o.eduexperience <> n.eduexperience
        or o.rgstad <> n.rgstad
        or o.graduateyear <> n.graduateyear
        or o.sex <> n.sex
        or o.workbegindate <> n.workbegindate
        or o.housevalue <> n.housevalue
        or o.title <> n.title
        or o.migtflag <> n.migtflag
        or o.localcontract <> n.localcontract
        or o.iscreditlimit <> n.iscreditlimit
        or o.remark <> n.remark
        or o.idorgname <> n.idorgname
        or o.workstartdate <> n.workstartdate
        or o.localcontractmobilephone <> n.localcontractmobilephone
        or o.drivercartype <> n.drivercartype
        or o.taxedannualincome <> n.taxedannualincome
        or o.unitaddress <> n.unitaddress
        or o.homeyearincome <> n.homeyearincome
        or o.headship <> n.headship
        or o.customername <> n.customername
        or o.politicalface <> n.politicalface
        or o.emergencycontact <> n.emergencycontact
        or o.driverlicenseid <> n.driverlicenseid
        or o.ishavework <> n.ishavework
        or o.email <> n.email
        or o.updateuserid <> n.updateuserid
        or o.nativeplace <> n.nativeplace
        or o.nativedetail <> n.nativedetail
        or o.customertype <> n.customertype
        or o.totalsum <> n.totalsum
        or o.city <> n.city
        or o.socialsecyear <> n.socialsecyear
        or o.unitpostcode <> n.unitpostcode
        or o.inputdate <> n.inputdate
        or o.incomeprove <> n.incomeprove
        or o.incomeratio <> n.incomeratio
        or o.creditlevel <> n.creditlevel
        or o.hndist <> n.hndist
        or o.lmcredittype <> n.lmcredittype
        or o.supportpopulations <> n.supportpopulations
        or o.unitkind <> n.unitkind
        or o.unitcountry <> n.unitcountry
        or o.marriage <> n.marriage
        or o.indcharacter <> n.indcharacter
        or o.hobby <> n.hobby
        or o.inputuserid <> n.inputuserid
        or o.houseadd <> n.houseadd
        or o.localcontracttelephone <> n.localcontracttelephone
        or o.migtoldvalue <> n.migtoldvalue
        or o.othercareer <> n.othercareer
        or o.cuscreditscorelevel <> n.cuscreditscorelevel
        or o.migtcustomerid <> n.migtcustomerid
        or o.isfamilyfarm <> n.isfamilyfarm
        or o.islowhouse <> n.islowhouse
        or o.isdisabled <> n.isdisabled
        or o.cuscreditscore <> n.cuscreditscore
        or o.holdratio <> n.holdratio
        or o.incomecurrency <> n.incomecurrency
        or o.formername <> n.formername
        or o.productid <> n.productid
        or o.channel <> n.channel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ind_info_cl(
            customerid -- 客户编号个人客户编号
            ,customerdetail -- 客户细类
            ,newcreditmonthpay -- 本次贷款月支出
            ,empstatus -- 就业状况
            ,cpndist -- 单位所在地行政区划
            ,workname -- 单位名称
            ,livingyears -- 本地居住年限(年)
            ,updateorgid -- 更新机构
            ,nativetype -- 农村城市标志
            ,incomesource -- 主要经济来源
            ,oldcreditmonthpay -- 存量贷款月支出
            ,inputorgid -- 登记机构编号
            ,corporgid -- 法人机构编号
            ,nation -- 国籍
            ,updatedate -- 更新日期
            ,nationality -- 民族民族（代码：1-汉族2-其他少数名族）
            ,familymonthincome -- 家庭月收入
            ,emergencycontactaddress -- 紧急联系人地址
            ,ishavecar -- 自有汽车情况
            ,homedetails -- 家庭描述
            ,occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
            ,selfyearincome -- 个人年收入
            ,emergencycontactmobilephone -- 紧急联系人手机
            ,sino -- 社会保险号
            ,payaccountbank -- 工资卡开户银行
            ,nativeaddress -- 户籍所在地
            ,edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
            ,homedebtsum -- 家庭总负债
            ,evaluatedate -- 评估日期
            ,residist -- 居住地行政区划
            ,maildist -- 通讯地行政区划
            ,localcontractaddress -- 本地联系人地址
            ,livingareapostalcode -- 居住地邮编
            ,isrelative -- 是否我行关联方标志
            ,entscale -- 企业规模
            ,healthstatus -- 健康状况
            ,driveryears -- 驾龄
            ,industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
            ,iddist -- 证件签发机关所在地行政区划
            ,birthday -- 出生日期
            ,payaccount -- 工资账号
            ,nineelements -- 九要素是否齐全(1是2否)
            ,familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
            ,isbankstaff -- 是否行员标志
            ,graduateschool -- 毕业学校
            ,children -- 子女情况（人）
            ,indmonthincome -- 个人月收入
            ,currentworkyears -- 现单位工作年限
            ,isfarmer -- 是否农户
            ,carprice -- 汽车价值
            ,billstyle -- 账单形式
            ,unitphone -- 单位电话
            ,indtype -- 客户类型
            ,usuallivingarea -- 常住地行政区划
            ,nativeadd -- 户籍地址
            ,eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
            ,rgstad -- 家庭住址行政区划代码
            ,graduateyear -- 毕业年份
            ,sex -- 性别性别（代码：1-男2-女3-未说明的性别）
            ,workbegindate -- 加入本单位日期
            ,housevalue -- 房屋价值
            ,title -- 职称等级
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,localcontract -- 本地联系人
            ,iscreditlimit -- 是否授信暂禁
            ,remark -- 备注
            ,idorgname -- 证件签发机关名称
            ,workstartdate -- 本单位工作起始年份
            ,localcontractmobilephone -- 本地联系人手机
            ,drivercartype -- 准驾车型
            ,taxedannualincome -- 客户纳税年收入
            ,unitaddress -- 单位地址
            ,homeyearincome -- 家庭年收入
            ,headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,customername -- 客户姓名客户名称
            ,politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
            ,emergencycontact -- 紧急联系人
            ,driverlicenseid -- 驾照档案编号
            ,ishavework -- 是否有工作单位
            ,email -- 邮箱
            ,updateuserid -- 更新人
            ,nativeplace -- 籍贯
            ,nativedetail -- 户籍性质
            ,customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
            ,totalsum -- 资产总额
            ,city -- 市/州/地区
            ,socialsecyear -- 社保缴纳时长(年）
            ,unitpostcode -- 单位邮编
            ,inputdate -- 登记日期
            ,incomeprove -- 收入证明形式
            ,incomeratio -- 收入负债比
            ,creditlevel -- 内部信用评级级别
            ,hndist -- 户籍所在地行政区划
            ,lmcredittype -- 客户洗钱风险分类
            ,supportpopulations -- 供养人口（人）
            ,unitkind -- 单位性质
            ,unitcountry -- 单位所在地
            ,marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
            ,indcharacter -- 客户性质
            ,hobby -- 兴趣爱好
            ,inputuserid -- 登记人
            ,houseadd -- 家庭地址
            ,localcontracttelephone -- 本地联系人电话
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,othercareer -- 其他职业说明
            ,cuscreditscorelevel -- 客户信用分数等级:内评
            ,migtcustomerid -- 转换前客户号
            ,isfamilyfarm -- 是否家庭农场
            ,islowhouse -- 是否低保户
            ,isdisabled -- 是否残疾人
            ,cuscreditscore -- 客户信用分数
            ,holdratio -- 控股比例
            ,incomecurrency -- 收入币种
            ,formername -- 曾用名
            ,productid -- 产品编号
            ,channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ind_info_op(
            customerid -- 客户编号个人客户编号
            ,customerdetail -- 客户细类
            ,newcreditmonthpay -- 本次贷款月支出
            ,empstatus -- 就业状况
            ,cpndist -- 单位所在地行政区划
            ,workname -- 单位名称
            ,livingyears -- 本地居住年限(年)
            ,updateorgid -- 更新机构
            ,nativetype -- 农村城市标志
            ,incomesource -- 主要经济来源
            ,oldcreditmonthpay -- 存量贷款月支出
            ,inputorgid -- 登记机构编号
            ,corporgid -- 法人机构编号
            ,nation -- 国籍
            ,updatedate -- 更新日期
            ,nationality -- 民族民族（代码：1-汉族2-其他少数名族）
            ,familymonthincome -- 家庭月收入
            ,emergencycontactaddress -- 紧急联系人地址
            ,ishavecar -- 自有汽车情况
            ,homedetails -- 家庭描述
            ,occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
            ,selfyearincome -- 个人年收入
            ,emergencycontactmobilephone -- 紧急联系人手机
            ,sino -- 社会保险号
            ,payaccountbank -- 工资卡开户银行
            ,nativeaddress -- 户籍所在地
            ,edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
            ,homedebtsum -- 家庭总负债
            ,evaluatedate -- 评估日期
            ,residist -- 居住地行政区划
            ,maildist -- 通讯地行政区划
            ,localcontractaddress -- 本地联系人地址
            ,livingareapostalcode -- 居住地邮编
            ,isrelative -- 是否我行关联方标志
            ,entscale -- 企业规模
            ,healthstatus -- 健康状况
            ,driveryears -- 驾龄
            ,industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
            ,iddist -- 证件签发机关所在地行政区划
            ,birthday -- 出生日期
            ,payaccount -- 工资账号
            ,nineelements -- 九要素是否齐全(1是2否)
            ,familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
            ,isbankstaff -- 是否行员标志
            ,graduateschool -- 毕业学校
            ,children -- 子女情况（人）
            ,indmonthincome -- 个人月收入
            ,currentworkyears -- 现单位工作年限
            ,isfarmer -- 是否农户
            ,carprice -- 汽车价值
            ,billstyle -- 账单形式
            ,unitphone -- 单位电话
            ,indtype -- 客户类型
            ,usuallivingarea -- 常住地行政区划
            ,nativeadd -- 户籍地址
            ,eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
            ,rgstad -- 家庭住址行政区划代码
            ,graduateyear -- 毕业年份
            ,sex -- 性别性别（代码：1-男2-女3-未说明的性别）
            ,workbegindate -- 加入本单位日期
            ,housevalue -- 房屋价值
            ,title -- 职称等级
            ,migtflag -- 迁移标志：crs rcr ilc upl
            ,localcontract -- 本地联系人
            ,iscreditlimit -- 是否授信暂禁
            ,remark -- 备注
            ,idorgname -- 证件签发机关名称
            ,workstartdate -- 本单位工作起始年份
            ,localcontractmobilephone -- 本地联系人手机
            ,drivercartype -- 准驾车型
            ,taxedannualincome -- 客户纳税年收入
            ,unitaddress -- 单位地址
            ,homeyearincome -- 家庭年收入
            ,headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
            ,customername -- 客户姓名客户名称
            ,politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
            ,emergencycontact -- 紧急联系人
            ,driverlicenseid -- 驾照档案编号
            ,ishavework -- 是否有工作单位
            ,email -- 邮箱
            ,updateuserid -- 更新人
            ,nativeplace -- 籍贯
            ,nativedetail -- 户籍性质
            ,customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
            ,totalsum -- 资产总额
            ,city -- 市/州/地区
            ,socialsecyear -- 社保缴纳时长(年）
            ,unitpostcode -- 单位邮编
            ,inputdate -- 登记日期
            ,incomeprove -- 收入证明形式
            ,incomeratio -- 收入负债比
            ,creditlevel -- 内部信用评级级别
            ,hndist -- 户籍所在地行政区划
            ,lmcredittype -- 客户洗钱风险分类
            ,supportpopulations -- 供养人口（人）
            ,unitkind -- 单位性质
            ,unitcountry -- 单位所在地
            ,marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
            ,indcharacter -- 客户性质
            ,hobby -- 兴趣爱好
            ,inputuserid -- 登记人
            ,houseadd -- 家庭地址
            ,localcontracttelephone -- 本地联系人电话
            ,migtoldvalue -- 迁移数据-参数转换前字段值
            ,othercareer -- 其他职业说明
            ,cuscreditscorelevel -- 客户信用分数等级:内评
            ,migtcustomerid -- 转换前客户号
            ,isfamilyfarm -- 是否家庭农场
            ,islowhouse -- 是否低保户
            ,isdisabled -- 是否残疾人
            ,cuscreditscore -- 客户信用分数
            ,holdratio -- 控股比例
            ,incomecurrency -- 收入币种
            ,formername -- 曾用名
            ,productid -- 产品编号
            ,channel -- 渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customerid -- 客户编号个人客户编号
    ,o.customerdetail -- 客户细类
    ,o.newcreditmonthpay -- 本次贷款月支出
    ,o.empstatus -- 就业状况
    ,o.cpndist -- 单位所在地行政区划
    ,o.workname -- 单位名称
    ,o.livingyears -- 本地居住年限(年)
    ,o.updateorgid -- 更新机构
    ,o.nativetype -- 农村城市标志
    ,o.incomesource -- 主要经济来源
    ,o.oldcreditmonthpay -- 存量贷款月支出
    ,o.inputorgid -- 登记机构编号
    ,o.corporgid -- 法人机构编号
    ,o.nation -- 国籍
    ,o.updatedate -- 更新日期
    ,o.nationality -- 民族民族（代码：1-汉族2-其他少数名族）
    ,o.familymonthincome -- 家庭月收入
    ,o.emergencycontactaddress -- 紧急联系人地址
    ,o.ishavecar -- 自有汽车情况
    ,o.homedetails -- 家庭描述
    ,o.occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
    ,o.selfyearincome -- 个人年收入
    ,o.emergencycontactmobilephone -- 紧急联系人手机
    ,o.sino -- 社会保险号
    ,o.payaccountbank -- 工资卡开户银行
    ,o.nativeaddress -- 户籍所在地
    ,o.edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
    ,o.homedebtsum -- 家庭总负债
    ,o.evaluatedate -- 评估日期
    ,o.residist -- 居住地行政区划
    ,o.maildist -- 通讯地行政区划
    ,o.localcontractaddress -- 本地联系人地址
    ,o.livingareapostalcode -- 居住地邮编
    ,o.isrelative -- 是否我行关联方标志
    ,o.entscale -- 企业规模
    ,o.healthstatus -- 健康状况
    ,o.driveryears -- 驾龄
    ,o.industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
    ,o.iddist -- 证件签发机关所在地行政区划
    ,o.birthday -- 出生日期
    ,o.payaccount -- 工资账号
    ,o.nineelements -- 九要素是否齐全(1是2否)
    ,o.familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
    ,o.isbankstaff -- 是否行员标志
    ,o.graduateschool -- 毕业学校
    ,o.children -- 子女情况（人）
    ,o.indmonthincome -- 个人月收入
    ,o.currentworkyears -- 现单位工作年限
    ,o.isfarmer -- 是否农户
    ,o.carprice -- 汽车价值
    ,o.billstyle -- 账单形式
    ,o.unitphone -- 单位电话
    ,o.indtype -- 客户类型
    ,o.usuallivingarea -- 常住地行政区划
    ,o.nativeadd -- 户籍地址
    ,o.eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
    ,o.rgstad -- 家庭住址行政区划代码
    ,o.graduateyear -- 毕业年份
    ,o.sex -- 性别性别（代码：1-男2-女3-未说明的性别）
    ,o.workbegindate -- 加入本单位日期
    ,o.housevalue -- 房屋价值
    ,o.title -- 职称等级
    ,o.migtflag -- 迁移标志：crs rcr ilc upl
    ,o.localcontract -- 本地联系人
    ,o.iscreditlimit -- 是否授信暂禁
    ,o.remark -- 备注
    ,o.idorgname -- 证件签发机关名称
    ,o.workstartdate -- 本单位工作起始年份
    ,o.localcontractmobilephone -- 本地联系人手机
    ,o.drivercartype -- 准驾车型
    ,o.taxedannualincome -- 客户纳税年收入
    ,o.unitaddress -- 单位地址
    ,o.homeyearincome -- 家庭年收入
    ,o.headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,o.customername -- 客户姓名客户名称
    ,o.politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
    ,o.emergencycontact -- 紧急联系人
    ,o.driverlicenseid -- 驾照档案编号
    ,o.ishavework -- 是否有工作单位
    ,o.email -- 邮箱
    ,o.updateuserid -- 更新人
    ,o.nativeplace -- 籍贯
    ,o.nativedetail -- 户籍性质
    ,o.customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
    ,o.totalsum -- 资产总额
    ,o.city -- 市/州/地区
    ,o.socialsecyear -- 社保缴纳时长(年）
    ,o.unitpostcode -- 单位邮编
    ,o.inputdate -- 登记日期
    ,o.incomeprove -- 收入证明形式
    ,o.incomeratio -- 收入负债比
    ,o.creditlevel -- 内部信用评级级别
    ,o.hndist -- 户籍所在地行政区划
    ,o.lmcredittype -- 客户洗钱风险分类
    ,o.supportpopulations -- 供养人口（人）
    ,o.unitkind -- 单位性质
    ,o.unitcountry -- 单位所在地
    ,o.marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
    ,o.indcharacter -- 客户性质
    ,o.hobby -- 兴趣爱好
    ,o.inputuserid -- 登记人
    ,o.houseadd -- 家庭地址
    ,o.localcontracttelephone -- 本地联系人电话
    ,o.migtoldvalue -- 迁移数据-参数转换前字段值
    ,o.othercareer -- 其他职业说明
    ,o.cuscreditscorelevel -- 客户信用分数等级:内评
    ,o.migtcustomerid -- 转换前客户号
    ,o.isfamilyfarm -- 是否家庭农场
    ,o.islowhouse -- 是否低保户
    ,o.isdisabled -- 是否残疾人
    ,o.cuscreditscore -- 客户信用分数
    ,o.holdratio -- 控股比例
    ,o.incomecurrency -- 收入币种
    ,o.formername -- 曾用名
    ,o.productid -- 产品编号
    ,o.channel -- 渠道
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
from ${iol_schema}.icms_ind_info_bk o
    left join ${iol_schema}.icms_ind_info_op n
        on
            o.customerid = n.customerid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ind_info_cl d
        on
            o.customerid = d.customerid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ind_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ind_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ind_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ind_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ind_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ind_info_cl;
alter table ${iol_schema}.icms_ind_info exchange partition p_20991231 with table ${iol_schema}.icms_ind_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ind_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ind_info_op purge;
drop table ${iol_schema}.icms_ind_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ind_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ind_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
