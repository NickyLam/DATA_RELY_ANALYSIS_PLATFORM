/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_info(
    customerid varchar2(64) -- 客户编号个人客户编号
    ,customerdetail varchar2(36) -- 客户细类
    ,newcreditmonthpay number(24,6) -- 本次贷款月支出
    ,empstatus varchar2(12) -- 就业状况
    ,cpndist varchar2(160) -- 单位所在地行政区划
    ,workname varchar2(400) -- 单位名称
    ,livingyears number(22,0) -- 本地居住年限(年)
    ,updateorgid varchar2(64) -- 更新机构
    ,nativetype varchar2(36) -- 农村城市标志
    ,incomesource varchar2(36) -- 主要经济来源
    ,oldcreditmonthpay number(24,6) -- 存量贷款月支出
    ,inputorgid varchar2(24) -- 登记机构编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,nation varchar2(6) -- 国籍
    ,updatedate date -- 更新日期
    ,nationality varchar2(4) -- 民族民族（代码：1-汉族2-其他少数名族）
    ,familymonthincome number(24,6) -- 家庭月收入
    ,emergencycontactaddress varchar2(400) -- 紧急联系人地址
    ,ishavecar varchar2(4) -- 自有汽车情况
    ,homedetails varchar2(1600) -- 家庭描述
    ,occupation varchar2(10) -- 职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）
    ,selfyearincome number(24,6) -- 个人年收入
    ,emergencycontactmobilephone varchar2(64) -- 紧急联系人手机
    ,sino varchar2(64) -- 社会保险号
    ,payaccountbank varchar2(64) -- 工资卡开户银行
    ,nativeaddress varchar2(36) -- 户籍所在地
    ,edudegree varchar2(6) -- 最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）
    ,homedebtsum number(24,6) -- 家庭总负债
    ,evaluatedate date -- 评估日期
    ,residist varchar2(12) -- 居住地行政区划
    ,maildist varchar2(12) -- 通讯地行政区划
    ,localcontractaddress varchar2(400) -- 本地联系人地址
    ,livingareapostalcode varchar2(36) -- 居住地邮编
    ,isrelative varchar2(4) -- 是否我行关联方标志
    ,entscale varchar2(36) -- 企业规模
    ,healthstatus varchar2(200) -- 健康状况
    ,driveryears number(22,0) -- 驾龄
    ,industry varchar2(36) -- 单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）
    ,iddist varchar2(12) -- 证件签发机关所在地行政区划
    ,birthday date -- 出生日期
    ,payaccount varchar2(64) -- 工资账号
    ,nineelements varchar2(4) -- 九要素是否齐全(1是2否)
    ,familystatus varchar2(4) -- 居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）
    ,isbankstaff varchar2(20) -- 是否行员标志
    ,graduateschool varchar2(1000) -- 毕业学校
    ,children number(22,0) -- 子女情况（人）
    ,indmonthincome number(24,6) -- 个人月收入
    ,currentworkyears number(22,0) -- 现单位工作年限
    ,isfarmer varchar2(4) -- 是否农户
    ,carprice number(16,2) -- 汽车价值
    ,billstyle varchar2(36) -- 账单形式
    ,unitphone varchar2(192) -- 单位电话
    ,indtype varchar2(36) -- 客户类型
    ,usuallivingarea varchar2(200) -- 常住地行政区划
    ,nativeadd varchar2(800) -- 户籍地址
    ,eduexperience varchar2(4) -- 最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）
    ,rgstad varchar2(16) -- 家庭住址行政区划代码
    ,graduateyear date -- 毕业年份
    ,sex varchar2(12) -- 性别性别（代码：1-男2-女3-未说明的性别）
    ,workbegindate date -- 加入本单位日期
    ,housevalue number(24,6) -- 房屋价值
    ,title varchar2(4) -- 职称等级
    ,migtflag varchar2(160) -- 迁移标志：crs rcr ilc upl
    ,localcontract varchar2(160) -- 本地联系人
    ,iscreditlimit varchar2(4) -- 是否授信暂禁
    ,remark varchar2(1000) -- 备注
    ,idorgname varchar2(400) -- 证件签发机关名称
    ,workstartdate varchar2(24) -- 本单位工作起始年份
    ,localcontractmobilephone varchar2(64) -- 本地联系人手机
    ,drivercartype varchar2(72) -- 准驾车型
    ,taxedannualincome number(24,6) -- 客户纳税年收入
    ,unitaddress varchar2(600) -- 单位地址
    ,homeyearincome number(24,6) -- 家庭年收入
    ,headship varchar2(72) -- 职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）
    ,customername varchar2(400) -- 客户姓名客户名称
    ,politicalface varchar2(36) -- 政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）
    ,emergencycontact varchar2(160) -- 紧急联系人
    ,driverlicenseid varchar2(64) -- 驾照档案编号
    ,ishavework varchar2(4) -- 是否有工作单位
    ,email varchar2(1000) -- 邮箱
    ,updateuserid varchar2(64) -- 更新人
    ,nativeplace varchar2(400) -- 籍贯
    ,nativedetail varchar2(160) -- 户籍性质
    ,customertype varchar2(36) -- 客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）
    ,totalsum number(24,6) -- 资产总额
    ,city varchar2(160) -- 市/州/地区
    ,socialsecyear varchar2(200) -- 社保缴纳时长(年）
    ,unitpostcode varchar2(36) -- 单位邮编
    ,inputdate date -- 登记日期
    ,incomeprove varchar2(36) -- 收入证明形式
    ,incomeratio number(24,6) -- 收入负债比
    ,creditlevel varchar2(64) -- 内部信用评级级别
    ,hndist varchar2(12) -- 户籍所在地行政区划
    ,lmcredittype varchar2(2) -- 客户洗钱风险分类
    ,supportpopulations number(22,0) -- 供养人口（人）
    ,unitkind varchar2(200) -- 单位性质
    ,unitcountry varchar2(200) -- 单位所在地
    ,marriage varchar2(4) -- 婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）
    ,indcharacter varchar2(144) -- 客户性质
    ,hobby varchar2(1000) -- 兴趣爱好
    ,inputuserid varchar2(64) -- 登记人
    ,houseadd varchar2(800) -- 家庭地址
    ,localcontracttelephone varchar2(64) -- 本地联系人电话
    ,migtoldvalue varchar2(500) -- 迁移数据-参数转换前字段值
    ,othercareer varchar2(510) -- 其他职业说明
    ,cuscreditscorelevel varchar2(4) -- 客户信用分数等级:内评
    ,migtcustomerid varchar2(128) -- 转换前客户号
    ,isfamilyfarm varchar2(4) -- 是否家庭农场
    ,islowhouse varchar2(4) -- 是否低保户
    ,isdisabled varchar2(4) -- 是否残疾人
    ,cuscreditscore number(18,2) -- 客户信用分数
    ,holdratio number(10,6) -- 控股比例
    ,incomecurrency varchar2(10) -- 收入币种
    ,formername varchar2(200) -- 曾用名
    ,productid varchar2(32) -- 产品编号
    ,channel varchar2(32) -- 渠道
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
grant select on ${iol_schema}.icms_ind_info to ${iml_schema};
grant select on ${iol_schema}.icms_ind_info to ${icl_schema};
grant select on ${iol_schema}.icms_ind_info to ${idl_schema};
grant select on ${iol_schema}.icms_ind_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_info is '个人客户信息';
comment on column ${iol_schema}.icms_ind_info.customerid is '客户编号个人客户编号';
comment on column ${iol_schema}.icms_ind_info.customerdetail is '客户细类';
comment on column ${iol_schema}.icms_ind_info.newcreditmonthpay is '本次贷款月支出';
comment on column ${iol_schema}.icms_ind_info.empstatus is '就业状况';
comment on column ${iol_schema}.icms_ind_info.cpndist is '单位所在地行政区划';
comment on column ${iol_schema}.icms_ind_info.workname is '单位名称';
comment on column ${iol_schema}.icms_ind_info.livingyears is '本地居住年限(年)';
comment on column ${iol_schema}.icms_ind_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_info.nativetype is '农村城市标志';
comment on column ${iol_schema}.icms_ind_info.incomesource is '主要经济来源';
comment on column ${iol_schema}.icms_ind_info.oldcreditmonthpay is '存量贷款月支出';
comment on column ${iol_schema}.icms_ind_info.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_ind_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_info.nation is '国籍';
comment on column ${iol_schema}.icms_ind_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_info.nationality is '民族民族（代码：1-汉族2-其他少数名族）';
comment on column ${iol_schema}.icms_ind_info.familymonthincome is '家庭月收入';
comment on column ${iol_schema}.icms_ind_info.emergencycontactaddress is '紧急联系人地址';
comment on column ${iol_schema}.icms_ind_info.ishavecar is '自有汽车情况';
comment on column ${iol_schema}.icms_ind_info.homedetails is '家庭描述';
comment on column ${iol_schema}.icms_ind_info.occupation is '职业职业（代码：1-国家机关、党群组织、企业，事业单位负责人2-专业技术人员3-办事人员和有关人员4-商业，服务业人员5-农、林、牧、渔、水利业生产人员6-生产、运输设备操作人员及有关人员7-军人8-不便分类的其他从业人员9-未知）';
comment on column ${iol_schema}.icms_ind_info.selfyearincome is '个人年收入';
comment on column ${iol_schema}.icms_ind_info.emergencycontactmobilephone is '紧急联系人手机';
comment on column ${iol_schema}.icms_ind_info.sino is '社会保险号';
comment on column ${iol_schema}.icms_ind_info.payaccountbank is '工资卡开户银行';
comment on column ${iol_schema}.icms_ind_info.nativeaddress is '户籍所在地';
comment on column ${iol_schema}.icms_ind_info.edudegree is '最高学位最高学位（代码：1-其他2-名誉博士3-博士4-硕士5-学士6-未知）';
comment on column ${iol_schema}.icms_ind_info.homedebtsum is '家庭总负债';
comment on column ${iol_schema}.icms_ind_info.evaluatedate is '评估日期';
comment on column ${iol_schema}.icms_ind_info.residist is '居住地行政区划';
comment on column ${iol_schema}.icms_ind_info.maildist is '通讯地行政区划';
comment on column ${iol_schema}.icms_ind_info.localcontractaddress is '本地联系人地址';
comment on column ${iol_schema}.icms_ind_info.livingareapostalcode is '居住地邮编';
comment on column ${iol_schema}.icms_ind_info.isrelative is '是否我行关联方标志';
comment on column ${iol_schema}.icms_ind_info.entscale is '企业规模';
comment on column ${iol_schema}.icms_ind_info.healthstatus is '健康状况';
comment on column ${iol_schema}.icms_ind_info.driveryears is '驾龄';
comment on column ${iol_schema}.icms_ind_info.industry is '单位所属行业单位所属行业（代码：1-农、林、牧、渔业2-农业3-谷物种植4-小麦种植5-玉米种植6-其他谷物种植7-豆类、油料和薯类种植8-豆类种植。。。）';
comment on column ${iol_schema}.icms_ind_info.iddist is '证件签发机关所在地行政区划';
comment on column ${iol_schema}.icms_ind_info.birthday is '出生日期';
comment on column ${iol_schema}.icms_ind_info.payaccount is '工资账号';
comment on column ${iol_schema}.icms_ind_info.nineelements is '九要素是否齐全(1是2否)';
comment on column ${iol_schema}.icms_ind_info.familystatus is '居住状况居住状况（代码：1-自置2-按揭3-亲属楼宇4-集体宿舍5-租房6-公有住宅7-其他8-未知）';
comment on column ${iol_schema}.icms_ind_info.isbankstaff is '是否行员标志';
comment on column ${iol_schema}.icms_ind_info.graduateschool is '毕业学校';
comment on column ${iol_schema}.icms_ind_info.children is '子女情况（人）';
comment on column ${iol_schema}.icms_ind_info.indmonthincome is '个人月收入';
comment on column ${iol_schema}.icms_ind_info.currentworkyears is '现单位工作年限';
comment on column ${iol_schema}.icms_ind_info.isfarmer is '是否农户';
comment on column ${iol_schema}.icms_ind_info.carprice is '汽车价值';
comment on column ${iol_schema}.icms_ind_info.billstyle is '账单形式';
comment on column ${iol_schema}.icms_ind_info.unitphone is '单位电话';
comment on column ${iol_schema}.icms_ind_info.indtype is '客户类型';
comment on column ${iol_schema}.icms_ind_info.usuallivingarea is '常住地行政区划';
comment on column ${iol_schema}.icms_ind_info.nativeadd is '户籍地址';
comment on column ${iol_schema}.icms_ind_info.eduexperience is '最高学历最高学历（代码：1-研究生2-大学本科3-大学专科4-中专/中等技校5-技术学校6-高中7-初中8-小学9-文盲或半文盲10-未知）';
comment on column ${iol_schema}.icms_ind_info.rgstad is '家庭住址行政区划代码';
comment on column ${iol_schema}.icms_ind_info.graduateyear is '毕业年份';
comment on column ${iol_schema}.icms_ind_info.sex is '性别性别（代码：1-男2-女3-未说明的性别）';
comment on column ${iol_schema}.icms_ind_info.workbegindate is '加入本单位日期';
comment on column ${iol_schema}.icms_ind_info.housevalue is '房屋价值';
comment on column ${iol_schema}.icms_ind_info.title is '职称等级';
comment on column ${iol_schema}.icms_ind_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_ind_info.localcontract is '本地联系人';
comment on column ${iol_schema}.icms_ind_info.iscreditlimit is '是否授信暂禁';
comment on column ${iol_schema}.icms_ind_info.remark is '备注';
comment on column ${iol_schema}.icms_ind_info.idorgname is '证件签发机关名称';
comment on column ${iol_schema}.icms_ind_info.workstartdate is '本单位工作起始年份';
comment on column ${iol_schema}.icms_ind_info.localcontractmobilephone is '本地联系人手机';
comment on column ${iol_schema}.icms_ind_info.drivercartype is '准驾车型';
comment on column ${iol_schema}.icms_ind_info.taxedannualincome is '客户纳税年收入';
comment on column ${iol_schema}.icms_ind_info.unitaddress is '单位地址';
comment on column ${iol_schema}.icms_ind_info.homeyearincome is '家庭年收入';
comment on column ${iol_schema}.icms_ind_info.headship is '职务职务（代码：1-高级领导(行政级别局级及局级以上领导或大公司高级管理人员)2-中级领导(行政级别局级以下领导或大公司中级管理人员)3-一般员工4-其他5-未知）';
comment on column ${iol_schema}.icms_ind_info.customername is '客户姓名客户名称';
comment on column ${iol_schema}.icms_ind_info.politicalface is '政治面貌政治面貌（代码：1-中共党员2-共青团员3-民主党派4-群众）';
comment on column ${iol_schema}.icms_ind_info.emergencycontact is '紧急联系人';
comment on column ${iol_schema}.icms_ind_info.driverlicenseid is '驾照档案编号';
comment on column ${iol_schema}.icms_ind_info.ishavework is '是否有工作单位';
comment on column ${iol_schema}.icms_ind_info.email is '邮箱';
comment on column ${iol_schema}.icms_ind_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_info.nativeplace is '籍贯';
comment on column ${iol_schema}.icms_ind_info.nativedetail is '户籍性质';
comment on column ${iol_schema}.icms_ind_info.customertype is '客户类型（个人客户细分，码值：customertype，自营客户、非自营客户）';
comment on column ${iol_schema}.icms_ind_info.totalsum is '资产总额';
comment on column ${iol_schema}.icms_ind_info.city is '市/州/地区';
comment on column ${iol_schema}.icms_ind_info.socialsecyear is '社保缴纳时长(年）';
comment on column ${iol_schema}.icms_ind_info.unitpostcode is '单位邮编';
comment on column ${iol_schema}.icms_ind_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_info.incomeprove is '收入证明形式';
comment on column ${iol_schema}.icms_ind_info.incomeratio is '收入负债比';
comment on column ${iol_schema}.icms_ind_info.creditlevel is '内部信用评级级别';
comment on column ${iol_schema}.icms_ind_info.hndist is '户籍所在地行政区划';
comment on column ${iol_schema}.icms_ind_info.lmcredittype is '客户洗钱风险分类';
comment on column ${iol_schema}.icms_ind_info.supportpopulations is '供养人口（人）';
comment on column ${iol_schema}.icms_ind_info.unitkind is '单位性质';
comment on column ${iol_schema}.icms_ind_info.unitcountry is '单位所在地';
comment on column ${iol_schema}.icms_ind_info.marriage is '婚姻状况婚姻状况（代码：1-未婚2-已婚3-未知）';
comment on column ${iol_schema}.icms_ind_info.indcharacter is '客户性质';
comment on column ${iol_schema}.icms_ind_info.hobby is '兴趣爱好';
comment on column ${iol_schema}.icms_ind_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_info.houseadd is '家庭地址';
comment on column ${iol_schema}.icms_ind_info.localcontracttelephone is '本地联系人电话';
comment on column ${iol_schema}.icms_ind_info.migtoldvalue is '迁移数据-参数转换前字段值';
comment on column ${iol_schema}.icms_ind_info.othercareer is '其他职业说明';
comment on column ${iol_schema}.icms_ind_info.cuscreditscorelevel is '客户信用分数等级:内评';
comment on column ${iol_schema}.icms_ind_info.migtcustomerid is '转换前客户号';
comment on column ${iol_schema}.icms_ind_info.isfamilyfarm is '是否家庭农场';
comment on column ${iol_schema}.icms_ind_info.islowhouse is '是否低保户';
comment on column ${iol_schema}.icms_ind_info.isdisabled is '是否残疾人';
comment on column ${iol_schema}.icms_ind_info.cuscreditscore is '客户信用分数';
comment on column ${iol_schema}.icms_ind_info.holdratio is '控股比例';
comment on column ${iol_schema}.icms_ind_info.incomecurrency is '收入币种';
comment on column ${iol_schema}.icms_ind_info.formername is '曾用名';
comment on column ${iol_schema}.icms_ind_info.productid is '产品编号';
comment on column ${iol_schema}.icms_ind_info.channel is '渠道';
comment on column ${iol_schema}.icms_ind_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_info.etl_timestamp is 'ETL处理时间戳';
