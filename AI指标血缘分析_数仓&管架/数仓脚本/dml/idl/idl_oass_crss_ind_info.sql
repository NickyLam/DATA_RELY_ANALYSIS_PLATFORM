/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_oass_crss_ind_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.oass_crss_ind_info drop partition p_${last_date};
alter table ${idl_schema}.oass_crss_ind_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.oass_crss_ind_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.oass_crss_ind_info (
    etl_dt  -- 数据日期
    ,customerid  -- 
    ,fullname  -- 
    ,sex  -- 
    ,birthday  -- 
    ,certtype  -- 
    ,certid  -- 
    ,sino  -- 
    ,country  -- 
    ,nationality  -- 
    ,nativeplace  -- 
    ,politicalface  -- 
    ,marriage  -- 
    ,relativetype  -- 
    ,familyadd  -- 
    ,familyzip  -- 
    ,emailadd  -- 
    ,familytel  -- 
    ,mobiletelephone  -- 
    ,unitkind  -- 
    ,workcorp  -- 
    ,workadd  -- 
    ,worktel  -- 
    ,occupation  -- 
    ,position  -- 
    ,employrecord  -- 
    ,edurecord  -- 
    ,eduexperience  -- 
    ,edudegree  -- 
    ,graduateyear  -- 
    ,financebelong  -- 
    ,creditlevel  -- 
    ,evaluatedate  -- 
    ,balancesheet  -- 
    ,intro  -- 
    ,selfmonthincome  -- 
    ,familymonthincome  -- 
    ,incomesource  -- 
    ,population  -- 
    ,loancardno  -- 
    ,loancardinsyear  -- 
    ,farmersort  -- 
    ,regionalism  -- 
    ,staff  -- 
    ,creditfarmer  -- 
    ,riskinclination  -- 
    ,character  -- 
    ,dataquality  -- 
    ,inputorgid  -- 
    ,inputuserid  -- 
    ,inputdate  -- 
    ,updatedate  -- 
    ,remark  -- 
    ,updateorgid  -- 
    ,updateuserid  -- 
    ,commadd  -- 
    ,commzip  -- 
    ,nativeadd  -- 
    ,workzip  -- 
    ,headship  -- 
    ,workbegindate  -- 
    ,yearincome  -- 
    ,payaccount  -- 
    ,payaccountbank  -- 
    ,familystatus  -- 
    ,tempsaveflag  -- 
    ,certid18  -- 
    ,nativenature  -- 增加户籍性质
    ,housevalue  -- 房屋价值
    ,freecarcondition  -- 自由汽车状况
    ,familyyearincomepercapita  -- 家庭人均年收入
    ,monthincome  -- 个人月收入
    ,supportpopulations  -- 供养人口
    ,children  -- 其中子女人数
    ,currentworkyears  -- 现单位工作年限
    ,age  -- 年龄
    ,familytotalassets  -- 家庭总资产
    ,familytotalliabilities  -- 家庭总负债
    ,billstyle  -- 账单形式
    ,emergencycontact  -- 紧急联系人
    ,emergencycontactaddress  -- 紧急联系人地址
    ,emergencycontactmobilephone  -- 紧急联系人手机
    ,localcontract  -- 本地联系人
    ,localcontractaddress  -- 本地联系人地址
    ,localcontracttelephone  -- 本地联系人电话
    ,localcontractmobilephone  -- 本地联系人手机
    ,currentindustryworkyears  -- 目前行业从业年限
    ,workyears  -- 任职年限
    ,registeredcapital  -- 注册资本
    ,managementscope  -- 经营范围
    ,managementtype  -- 经营类型
    ,managementplace  -- 经营场所
    ,enterpriseyearincome  -- 经营企业年业务收入
    ,enterpriseadd  -- 经营企业地址
    ,newcustomertype  -- 客户类型  代码：NewCustomerType
    ,otherincome  -- 其他收入(元)---核实要素
    ,rentincome  -- 租金收入(元)---核实要素
    ,convertincome  -- 财产折算收入(元)---核实要素
    ,salaryincome  -- 薪资收入(元)---核实要素
    ,takingsmonthly  -- 月营业收入(元)---核实要素
    ,profitmarginmonthly  -- 核算利润率(%)---核实要素
    ,stocklot  -- 股份%(企业主股东填写)---核实要素
    ,debtmonthly  -- 个人月负债额(元)---核实要素
    ,housearea  -- 住宅电话:地区号
    ,corparea  -- 单位电话:地区号
    ,cheatcheckresult  -- 欺诈检测结果(0.正常 1.可疑)
    ,lmcredittype  -- 客户洗钱风险分类
    ,isrelatedparty  -- 是否关联方
    ,socialinsuranceflag  -- 
    ,localhouseflag  -- 
    ,localyear  -- 
    ,monthcashout  -- 
    ,corpextension  -- 
    ,corpzone  -- 
    ,department  -- 
    ,regioncodename  -- 
    ,firsttel  -- 
    ,housezone  -- 
    ,custen  -- 英文名称
    ,custtp  -- 客户类型
    ,isblak  -- 是否黑名单客户
    ,custst  -- 客户状态
    ,psrntg  -- 居民标识
    ,ntlycd  -- 国籍
    ,rgstad  -- 地区代码
    ,lncdno  -- 贷款卡编号
    ,lncdpw  -- 贷款卡密码
    ,lncdtg  -- 贷款卡状态
    ,ispart  -- 是否我行股东
    ,mainfg  -- 是否主证件号
    ,idtfst  -- 证件状态
    ,contna  -- 联系人姓名
    ,cmainf  -- 是否主联系方式
    ,othrtl  -- 其他电话
    ,mailad  -- 地址
    ,mfcustomerid  -- CIF客户号
    ,businessentityid  -- 
    ,businessentityname  -- 
    ,businessentityshinfo  -- 
    ,finalevaluatedate  -- 评级日期
    ,customermemberlevel  -- 
    ,isrelative  -- 是否我行关联交易
    ,ownertype  -- 业主类型：1-个体工商户，2-小微企业主
    ,iscountryhousehold  -- 是否农村户口
    ,worknature  -- 单位性质
    ,posionlevel  -- 职务类型
    ,employeetype  -- 雇佣类型
    ,industryage  -- 企业成立年限
    ,regioncode  -- 户口所在地
    ,firstemail  -- 首选邮寄
    ,bqueryresult  -- 单位工商查询结果
    ,risktype  -- 行业风险类别
    ,jobtype  -- 工作性质
    ,corptradeflag  -- 贸易型企业
    ,corpregisterdate  -- 注册时间
    ,registerfinancing  -- 注册资本金
    ,preyeardpf  -- 流水份数
    ,incomeremark  -- 个人月收入计算<br>特殊说明<br>
    ,debtflag  -- 或有负债
    ,debtmonthlyremark  -- 已有债务月付额<br>计算公式及说明<br>
    ,bpcreditlevel  -- 人行信用报告结果
    ,creditremark  -- 其他说明<br>
    ,consistentflag  -- 工作单位与<br>社保/公积金一致
    ,realtycontractcount  -- 已有房贷笔数
    ,bankrelativeflag  -- 银行关联方
    ,creditresult  -- 征信结论<br>
    ,alipayaccount  -- 支付宝账号
    ,jdaccount  -- 京东网账号
    ,remark2  -- 人寿保单的保险公司名称
    ,otherbankcard  -- 持有他行信用卡
    ,certidaddress  -- 身份证发证所在地
    ,baseresidyear  -- 本地居住年限
    ,baseindustryyear  -- 从事本行业年限
    ,managindustry  -- 经营行业
    ,debtorbusiness  -- 或有负债规模
    ,carsum  -- 车辆情况
    ,housepvalue  -- 房产价值
    ,isinvestmentsm  -- 是否有融资投资股市
    ,incomeratio  -- 收入还贷比
    ,socialsecyear  -- 社保缴纳时长
    ,accumuratio  -- 公积金缴纳比例
    ,ishavework  -- 配偶是否有工作
    ,unsettledsum  -- 当前未结清信用贷款笔数
    ,expectedsum  -- 近6个月逾期次数
    ,maxposition  -- 信用卡单张最大授信额度
    ,creditcondit  -- 是否在我行信贷情况
    ,ishavembusiness  -- 是否在本行办理了中间业务
    ,isbaseemployee  -- 是否我行员工
    ,isbasebpay  -- 是否我行代发工资户
    ,isbasebpaccount  -- 是否我行的定期账户
    ,isbasebfaccount  -- 是否我行理财账户
    ,isbasebvipaccount  -- 是否我行VIP账户
    ,isfammigration  -- 配偶及子女是否移民
    ,isnegationeva  -- 是否存在第三方负面评价
    ,ispaydefault  -- 经营实体是否存在工资拖欠情况
    ,ishaveprefer  -- 是否享受国家政策优惠
    ,creditguarantee  -- 在我行信贷情况
    ,isexcecase  -- 是否出现过“冻结”、“止付”等特殊情况
    ,isoverrotio  -- 是否或有负债占净资产比重超过100%
    ,isoverhealth  -- 是否借款人身体状况较差，曾发生过重大疾病住院记录
    ,isbadbehavior  -- 是否存在不良行为，如赌博、斗殴等不良嗜好、拖欠电话费、水电煤气费、承包费等
    ,ishavepower  -- 是否不具有所经营范围的经营权，或营业执照无效
    ,industyperesult  -- 授信政策行业
    ,ispenal  -- 近5年是否存在刑事判决记录
    ,isviolation  -- 是否存在重大违法违规行为
    ,isecondis  -- 是否存在重大经济纠纷
    ,isbreach  -- 是否存在重大违约行为
    ,managescale  -- 经营规模(经营人数)
    ,accumumount  -- 公积金缴纳基数
    ,overduetimes  -- 信用卡逾期次数
    ,allavgusedsum_last_six_month  -- 所有贷记和准贷记卡近六月平均使用额度
    ,creditcardsum  -- 信用卡张数
    ,guarforothers  -- 有无对外担保(1有，2无)
    ,dsblk  -- 是否在大数黑名单
    ,customerisrelative  -- 借款人为我行关联方 0-否，1-是
    ,guarantorisrelative  -- 保证人为我行关联方 0-否，1-是
    ,busicerttype  -- 企业证件类型
    ,start_dt  -- 开始日期
    ,end_dt  -- 结束日期
    ,id_mark  -- 删除标识
	,etl_timestamp
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.customerid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.fullname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sex,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.birthday,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.certtype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.certid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sino,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.country,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nationality,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nativeplace,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.politicalface,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.marriage,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.relativetype,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.familyadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.familyzip,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.emailadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.familytel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.mobiletelephone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.unitkind,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.workcorp,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.workadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.worktel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.occupation,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.position,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.employrecord,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.edurecord,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.eduexperience,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.edudegree,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.graduateyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.financebelong,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditlevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.evaluatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.balancesheet,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.intro,chr(13),''),chr(10),'')  -- 
    ,t1.selfmonthincome  -- 
    ,t1.familymonthincome  -- 
    ,replace(replace(t1.incomesource,chr(13),''),chr(10),'')  -- 
    ,t1.population  -- 
    ,replace(replace(t1.loancardno,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.loancardinsyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.farmersort,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.regionalism,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.staff,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.creditfarmer,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.riskinclination,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.character,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.dataquality,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.inputdate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updatedate,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updateorgid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.updateuserid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.commadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.commzip,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nativeadd,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.workzip,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.headship,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.workbegindate,chr(13),''),chr(10),'')  -- 
    ,t1.yearincome  -- 
    ,replace(replace(t1.payaccount,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.payaccountbank,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.familystatus,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.tempsaveflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.certid18,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.nativenature,chr(13),''),chr(10),'')  -- 增加户籍性质
    ,replace(replace(t1.housevalue,chr(13),''),chr(10),'')  -- 房屋价值
    ,replace(replace(t1.freecarcondition,chr(13),''),chr(10),'')  -- 自由汽车状况
    ,t1.familyyearincomepercapita  -- 家庭人均年收入
    ,t1.monthincome  -- 个人月收入
    ,t1.supportpopulations  -- 供养人口
    ,t1.children  -- 其中子女人数
    ,t1.currentworkyears  -- 现单位工作年限
    ,t1.age  -- 年龄
    ,t1.familytotalassets  -- 家庭总资产
    ,t1.familytotalliabilities  -- 家庭总负债
    ,replace(replace(t1.billstyle,chr(13),''),chr(10),'')  -- 账单形式
    ,replace(replace(t1.emergencycontact,chr(13),''),chr(10),'')  -- 紧急联系人
    ,replace(replace(t1.emergencycontactaddress,chr(13),''),chr(10),'')  -- 紧急联系人地址
    ,replace(replace(t1.emergencycontactmobilephone,chr(13),''),chr(10),'')  -- 紧急联系人手机
    ,replace(replace(t1.localcontract,chr(13),''),chr(10),'')  -- 本地联系人
    ,replace(replace(t1.localcontractaddress,chr(13),''),chr(10),'')  -- 本地联系人地址
    ,replace(replace(t1.localcontracttelephone,chr(13),''),chr(10),'')  -- 本地联系人电话
    ,replace(replace(t1.localcontractmobilephone,chr(13),''),chr(10),'')  -- 本地联系人手机
    ,t1.currentindustryworkyears  -- 目前行业从业年限
    ,t1.workyears  -- 任职年限
    ,t1.registeredcapital  -- 注册资本
    ,replace(replace(t1.managementscope,chr(13),''),chr(10),'')  -- 经营范围
    ,replace(replace(t1.managementtype,chr(13),''),chr(10),'')  -- 经营类型
    ,replace(replace(t1.managementplace,chr(13),''),chr(10),'')  -- 经营场所
    ,t1.enterpriseyearincome  -- 经营企业年业务收入
    ,replace(replace(t1.enterpriseadd,chr(13),''),chr(10),'')  -- 经营企业地址
    ,replace(replace(t1.newcustomertype,chr(13),''),chr(10),'')  -- 客户类型  代码：NewCustomerType
    ,t1.otherincome  -- 其他收入(元)---核实要素
    ,t1.rentincome  -- 租金收入(元)---核实要素
    ,t1.convertincome  -- 财产折算收入(元)---核实要素
    ,t1.salaryincome  -- 薪资收入(元)---核实要素
    ,t1.takingsmonthly  -- 月营业收入(元)---核实要素
    ,t1.profitmarginmonthly  -- 核算利润率(%)---核实要素
    ,t1.stocklot  -- 股份%(企业主股东填写)---核实要素
    ,t1.debtmonthly  -- 个人月负债额(元)---核实要素
    ,replace(replace(t1.housearea,chr(13),''),chr(10),'')  -- 住宅电话:地区号
    ,replace(replace(t1.corparea,chr(13),''),chr(10),'')  -- 单位电话:地区号
    ,replace(replace(t1.cheatcheckresult,chr(13),''),chr(10),'')  -- 欺诈检测结果(0.正常 1.可疑)
    ,replace(replace(t1.lmcredittype,chr(13),''),chr(10),'')  -- 客户洗钱风险分类
    ,replace(replace(t1.isrelatedparty,chr(13),''),chr(10),'')  -- 是否关联方
    ,replace(replace(t1.socialinsuranceflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.localhouseflag,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.localyear,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.monthcashout,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpextension,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.corpzone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.department,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.regioncodename,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.firsttel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.housezone,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.custen,chr(13),''),chr(10),'')  -- 英文名称
    ,replace(replace(t1.custtp,chr(13),''),chr(10),'')  -- 客户类型
    ,replace(replace(t1.isblak,chr(13),''),chr(10),'')  -- 是否黑名单客户
    ,replace(replace(t1.custst,chr(13),''),chr(10),'')  -- 客户状态
    ,replace(replace(t1.psrntg,chr(13),''),chr(10),'')  -- 居民标识
    ,replace(replace(t1.ntlycd,chr(13),''),chr(10),'')  -- 国籍
    ,replace(replace(t1.rgstad,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.lncdno,chr(13),''),chr(10),'')  -- 贷款卡编号
    ,replace(replace(t1.lncdpw,chr(13),''),chr(10),'')  -- 贷款卡密码
    ,replace(replace(t1.lncdtg,chr(13),''),chr(10),'')  -- 贷款卡状态
    ,replace(replace(t1.ispart,chr(13),''),chr(10),'')  -- 是否我行股东
    ,replace(replace(t1.mainfg,chr(13),''),chr(10),'')  -- 是否主证件号
    ,replace(replace(t1.idtfst,chr(13),''),chr(10),'')  -- 证件状态
    ,replace(replace(t1.contna,chr(13),''),chr(10),'')  -- 联系人姓名
    ,replace(replace(t1.cmainf,chr(13),''),chr(10),'')  -- 是否主联系方式
    ,replace(replace(t1.othrtl,chr(13),''),chr(10),'')  -- 其他电话
    ,replace(replace(t1.mailad,chr(13),''),chr(10),'')  -- 地址
    ,replace(replace(t1.mfcustomerid,chr(13),''),chr(10),'')  -- CIF客户号
    ,replace(replace(t1.businessentityid,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businessentityname,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.businessentityshinfo,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.finalevaluatedate,chr(13),''),chr(10),'')  -- 评级日期
    ,replace(replace(t1.customermemberlevel,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.isrelative,chr(13),''),chr(10),'')  -- 是否我行关联交易
    ,replace(replace(t1.ownertype,chr(13),''),chr(10),'')  -- 业主类型：1-个体工商户，2-小微企业主
    ,replace(replace(t1.iscountryhousehold,chr(13),''),chr(10),'')  -- 是否农村户口
    ,replace(replace(t1.worknature,chr(13),''),chr(10),'')  -- 单位性质
    ,replace(replace(t1.posionlevel,chr(13),''),chr(10),'')  -- 职务类型
    ,replace(replace(t1.employeetype,chr(13),''),chr(10),'')  -- 雇佣类型
    ,t1.industryage  -- 企业成立年限
    ,replace(replace(t1.regioncode,chr(13),''),chr(10),'')  -- 户口所在地
    ,replace(replace(t1.firstemail,chr(13),''),chr(10),'')  -- 首选邮寄
    ,replace(replace(t1.bqueryresult,chr(13),''),chr(10),'')  -- 单位工商查询结果
    ,replace(replace(t1.risktype,chr(13),''),chr(10),'')  -- 行业风险类别
    ,replace(replace(t1.jobtype,chr(13),''),chr(10),'')  -- 工作性质
    ,replace(replace(t1.corptradeflag,chr(13),''),chr(10),'')  -- 贸易型企业
    ,replace(replace(t1.corpregisterdate,chr(13),''),chr(10),'')  -- 注册时间
    ,t1.registerfinancing  -- 注册资本金
    ,t1.preyeardpf  -- 流水份数
    ,replace(replace(t1.incomeremark,chr(13),''),chr(10),'')  -- 个人月收入计算<br>特殊说明<br>
    ,replace(replace(t1.debtflag,chr(13),''),chr(10),'')  -- 或有负债
    ,replace(replace(t1.debtmonthlyremark,chr(13),''),chr(10),'')  -- 已有债务月付额<br>计算公式及说明<br>
    ,replace(replace(t1.bpcreditlevel,chr(13),''),chr(10),'')  -- 人行信用报告结果
    ,replace(replace(t1.creditremark,chr(13),''),chr(10),'')  -- 其他说明<br>
    ,replace(replace(t1.consistentflag,chr(13),''),chr(10),'')  -- 工作单位与<br>社保/公积金一致
    ,replace(replace(t1.realtycontractcount,chr(13),''),chr(10),'')  -- 已有房贷笔数
    ,replace(replace(t1.bankrelativeflag,chr(13),''),chr(10),'')  -- 银行关联方
    ,replace(replace(t1.creditresult,chr(13),''),chr(10),'')  -- 征信结论<br>
    ,replace(replace(t1.alipayaccount,chr(13),''),chr(10),'')  -- 支付宝账号
    ,replace(replace(t1.jdaccount,chr(13),''),chr(10),'')  -- 京东网账号
    ,replace(replace(t1.remark2,chr(13),''),chr(10),'')  -- 人寿保单的保险公司名称
    ,replace(replace(t1.otherbankcard,chr(13),''),chr(10),'')  -- 持有他行信用卡
    ,replace(replace(t1.certidaddress,chr(13),''),chr(10),'')  -- 身份证发证所在地
    ,t1.baseresidyear  -- 本地居住年限
    ,t1.baseindustryyear  -- 从事本行业年限
    ,replace(replace(t1.managindustry,chr(13),''),chr(10),'')  -- 经营行业
    ,t1.debtorbusiness  -- 或有负债规模
    ,t1.carsum  -- 车辆情况
    ,t1.housepvalue  -- 房产价值
    ,replace(replace(t1.isinvestmentsm,chr(13),''),chr(10),'')  -- 是否有融资投资股市
    ,t1.incomeratio  -- 收入还贷比
    ,t1.socialsecyear  -- 社保缴纳时长
    ,t1.accumuratio  -- 公积金缴纳比例
    ,replace(replace(t1.ishavework,chr(13),''),chr(10),'')  -- 配偶是否有工作
    ,t1.unsettledsum  -- 当前未结清信用贷款笔数
    ,t1.expectedsum  -- 近6个月逾期次数
    ,t1.maxposition  -- 信用卡单张最大授信额度
    ,replace(replace(t1.creditcondit,chr(13),''),chr(10),'')  -- 是否在我行信贷情况
    ,replace(replace(t1.ishavembusiness,chr(13),''),chr(10),'')  -- 是否在本行办理了中间业务
    ,replace(replace(t1.isbaseemployee,chr(13),''),chr(10),'')  -- 是否我行员工
    ,replace(replace(t1.isbasebpay,chr(13),''),chr(10),'')  -- 是否我行代发工资户
    ,replace(replace(t1.isbasebpaccount,chr(13),''),chr(10),'')  -- 是否我行的定期账户
    ,replace(replace(t1.isbasebfaccount,chr(13),''),chr(10),'')  -- 是否我行理财账户
    ,replace(replace(t1.isbasebvipaccount,chr(13),''),chr(10),'')  -- 是否我行VIP账户
    ,replace(replace(t1.isfammigration,chr(13),''),chr(10),'')  -- 配偶及子女是否移民
    ,replace(replace(t1.isnegationeva,chr(13),''),chr(10),'')  -- 是否存在第三方负面评价
    ,replace(replace(t1.ispaydefault,chr(13),''),chr(10),'')  -- 经营实体是否存在工资拖欠情况
    ,replace(replace(t1.ishaveprefer,chr(13),''),chr(10),'')  -- 是否享受国家政策优惠
    ,replace(replace(t1.creditguarantee,chr(13),''),chr(10),'')  -- 在我行信贷情况
    ,replace(replace(t1.isexcecase,chr(13),''),chr(10),'')  -- 是否出现过“冻结”、“止付”等特殊情况
    ,replace(replace(t1.isoverrotio,chr(13),''),chr(10),'')  -- 是否或有负债占净资产比重超过100%
    ,replace(replace(t1.isoverhealth,chr(13),''),chr(10),'')  -- 是否借款人身体状况较差，曾发生过重大疾病住院记录
    ,replace(replace(t1.isbadbehavior,chr(13),''),chr(10),'')  -- 是否存在不良行为，如赌博、斗殴等不良嗜好、拖欠电话费、水电煤气费、承包费等
    ,replace(replace(t1.ishavepower,chr(13),''),chr(10),'')  -- 是否不具有所经营范围的经营权，或营业执照无效
    ,replace(replace(t1.industyperesult,chr(13),''),chr(10),'')  -- 授信政策行业
    ,replace(replace(t1.ispenal,chr(13),''),chr(10),'')  -- 近5年是否存在刑事判决记录
    ,replace(replace(t1.isviolation,chr(13),''),chr(10),'')  -- 是否存在重大违法违规行为
    ,replace(replace(t1.isecondis,chr(13),''),chr(10),'')  -- 是否存在重大经济纠纷
    ,replace(replace(t1.isbreach,chr(13),''),chr(10),'')  -- 是否存在重大违约行为
    ,t1.managescale  -- 经营规模(经营人数)
    ,t1.accumumount  -- 公积金缴纳基数
    ,replace(replace(t1.overduetimes,chr(13),''),chr(10),'')  -- 信用卡逾期次数
    ,t1.allavgusedsum_last_six_month  -- 所有贷记和准贷记卡近六月平均使用额度
    ,replace(replace(t1.creditcardsum,chr(13),''),chr(10),'')  -- 信用卡张数
    ,replace(replace(t1.guarforothers,chr(13),''),chr(10),'')  -- 有无对外担保(1有，2无)
    ,replace(replace(t1.dsblk,chr(13),''),chr(10),'')  -- 是否在大数黑名单
    ,replace(replace(t1.customerisrelative,chr(13),''),chr(10),'')  -- 借款人为我行关联方 0-否，1-是
    ,replace(replace(t1.guarantorisrelative,chr(13),''),chr(10),'')  -- 保证人为我行关联方 0-否，1-是
    ,replace(replace(t1.busicerttype,chr(13),''),chr(10),'')  -- 企业证件类型
    ,t1.start_dt  -- 开始日期
    ,t1.end_dt  -- 结束日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
	,t1.etl_timestamp
from ${iol_schema}.crss_ind_info t1    --个人基本信息
where start_dt <=to_date('${batch_date}', 'yyyymmdd')  and end_dt >to_date('${batch_date}', 'yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'oass_crss_ind_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);