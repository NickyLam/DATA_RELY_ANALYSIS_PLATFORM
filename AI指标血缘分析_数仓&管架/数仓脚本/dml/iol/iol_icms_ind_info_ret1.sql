/*
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ind_info_ret1
CreateDate: 20250331
*/

set timing on
-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);

begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM icms_ind_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var
    from user_tab_partitions
   where substr(partition_name,3) = tb.end_dt
     and table_name = upper('icms_ind_info');

  if v_var <> 0 then
    execute immediate 'alter table icms_ind_info drop partition p_' || tb.end_dt;
  end if;

    v_sql :='alter table icms_ind_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';

    execute immediate v_sql;

-- 回插所有数据

insert /*+ append */ into ${iol_schema}.icms_ind_info (
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
    customerid as customerid -- 客户编号个人客户编号
    ,customerdetail as customerdetail -- 客户细类
    ,newcreditmonthpay as newcreditmonthpay -- 本次贷款月支出
    ,empstatus as empstatus -- 就业状况
    ,cpndist as cpndist -- 单位所在地行政区划
    ,workname as workname -- 单位名称
    ,livingyears as livingyears -- 本地居住年限(年)
    ,updateorgid as updateorgid -- 更新机构
    ,nativetype as nativetype -- 农村城市标志
    ,incomesource as incomesource -- 主要经济来源
    ,oldcreditmonthpay as oldcreditmonthpay -- 存量贷款月支出
    ,inputorgid as inputorgid -- 登记机构编号
    ,corporgid as corporgid -- 法人机构编号
    ,nation as nation -- 国籍
    ,updatedate as updatedate -- 更新日期
    ,nationality as nationality -- 民族民族（代码：1-汉族2-其他少数名族）
    ,familymonthincome as familymonthincome -- 家庭月收入
    ,emergencycontactaddress as emergencycontactaddress -- 紧急联系人地址
    ,ishavecar as ishavecar -- 自有汽车情况
    ,homedetails as homedetails -- 家庭描述
    ,occupation as occupation -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
    ,selfyearincome as selfyearincome -- 个人年收入
    ,emergencycontactmobilephone as emergencycontactmobilephone -- 紧急联系人手机
    ,sino as sino -- 社会保险号
    ,payaccountbank as payaccountbank -- 工资卡开户银行
    ,nativeaddress as nativeaddress -- 户籍所在地
    ,edudegree as edudegree -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
    ,homedebtsum as homedebtsum -- 家庭总负债
    ,evaluatedate as evaluatedate -- 评估日期
    ,residist as residist -- 居住地行政区划
    ,maildist as maildist -- 通讯地行政区划
    ,localcontractaddress as localcontractaddress -- 本地联系人地址
    ,livingareapostalcode as livingareapostalcode -- 居住地邮编
    ,isrelative as isrelative -- 是否我行关联方标志
    ,entscale as entscale -- 企业规模
    ,healthstatus as healthstatus -- 健康状况
    ,driveryears as driveryears -- 驾龄
    ,industry as industry -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
    ,iddist as iddist -- 证件签发机关所在地行政区划
    ,birthday as birthday -- 出生日期
    ,payaccount as payaccount -- 工资账号
    ,nineelements as nineelements -- 九要素是否齐全(1是2否)
    ,familystatus as familystatus -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
    ,isbankstaff as isbankstaff -- 是否行员标志
    ,graduateschool as graduateschool -- 毕业学校
    ,children as children -- 子女情况（人）
    ,indmonthincome as indmonthincome -- 个人月收入
    ,currentworkyears as currentworkyears -- 现单位工作年限
    ,isfarmer as isfarmer -- 是否农户
    ,carprice as carprice -- 汽车价值
    ,billstyle as billstyle -- 账单形式
    ,unitphone as unitphone -- 单位电话
    ,indtype as indtype -- 客户类型
    ,usuallivingarea as usuallivingarea -- 常住地行政区划
    ,nativeadd as nativeadd -- 户籍地址
    ,eduexperience as eduexperience -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
    ,rgstad as rgstad -- 家庭住址行政区划代码
    ,graduateyear as graduateyear -- 毕业年份
    ,sex as sex -- 性别性别（代码：1-男2-女3-未说明的性别）
    ,workbegindate as workbegindate -- 加入本单位日期
    ,housevalue as housevalue -- 房屋价值
    ,title as title -- 职称等级
    ,migtflag as migtflag -- 迁移标志：crs rcr ilc upl
    ,localcontract as localcontract -- 本地联系人
    ,iscreditlimit as iscreditlimit -- 是否授信暂禁
    ,remark as remark -- 备注
    ,idorgname as idorgname -- 证件签发机关名称
    ,workstartdate as workstartdate -- 本单位工作起始年份
    ,localcontractmobilephone as localcontractmobilephone -- 本地联系人手机
    ,drivercartype as drivercartype -- 准驾车型
    ,taxedannualincome as taxedannualincome -- 客户纳税年收入
    ,unitaddress as unitaddress -- 单位地址
    ,homeyearincome as homeyearincome -- 家庭年收入
    ,headship as headship -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,customername as customername -- 客户姓名客户名称
    ,politicalface as politicalface -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
    ,emergencycontact as emergencycontact -- 紧急联系人
    ,driverlicenseid as driverlicenseid -- 驾照档案编号
    ,ishavework as ishavework -- 是否有工作单位
    ,email as email -- 邮箱
    ,updateuserid as updateuserid -- 更新人
    ,nativeplace as nativeplace -- 籍贯
    ,nativedetail as nativedetail -- 户籍性质
    ,customertype as customertype -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
    ,totalsum as totalsum -- 资产总额
    ,city as city -- 市/州/地区
    ,socialsecyear as socialsecyear -- 社保缴纳时长(年）
    ,unitpostcode as unitpostcode -- 单位邮编
    ,inputdate as inputdate -- 登记日期
    ,incomeprove as incomeprove -- 收入证明形式
    ,incomeratio as incomeratio -- 收入负债比
    ,creditlevel as creditlevel -- 内部信用评级级别
    ,hndist as hndist -- 户籍所在地行政区划
    ,lmcredittype as lmcredittype -- 客户洗钱风险分类
    ,supportpopulations as supportpopulations -- 供养人口（人）
    ,unitkind as unitkind -- 单位性质
    ,unitcountry as unitcountry -- 单位所在地
    ,marriage as marriage -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
    ,indcharacter as indcharacter -- 客户性质
    ,hobby as hobby -- 兴趣爱好
    ,inputuserid as inputuserid -- 登记人
    ,houseadd as houseadd -- 家庭地址
    ,localcontracttelephone as localcontracttelephone -- 本地联系人电话
    ,migtoldvalue as migtoldvalue -- 迁移数据-参数转换前字段值
    ,othercareer as othercareer -- 其他职业说明
    ,cuscreditscorelevel as cuscreditscorelevel -- 客户信用分数等级:内评
    ,' ' as migtcustomerid -- 转换前客户号
    ,' ' as isfamilyfarm -- 是否家庭农场
    ,' ' as islowhouse -- 是否低保户
    ,' ' as isdisabled -- 是否残疾人
    ,0 as cuscreditscore -- 客户信用分数
    ,0 as holdratio -- 控股比例
    ,' ' as incomecurrency -- 收入币种
    ,' ' as formername -- 曾用名
    ,' ' as productid -- 产品编号
    ,' ' as channel -- 渠道
    ,start_dt as start_dt -- 开始时间
    ,end_dt as end_dt -- 结束时间
    ,id_mark as id_mark -- 增删标志
    ,etl_timestamp as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_ind_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');

commit;

end loop;
end;
/

