/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_crss_ind_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.oass_crss_ind_info
whenever sqlerror continue none;
drop table ${idl_schema}.oass_crss_ind_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.oass_crss_ind_info(
    etl_dt date -- 数据日期   
    ,customerid varchar2(32) --    
    ,fullname varchar2(80) --    
    ,sex varchar2(18) --    
    ,birthday varchar2(10) --    
    ,certtype varchar2(18) --    
    ,certid varchar2(32) --    
    ,sino varchar2(32) --    
    ,country varchar2(18) --    
    ,nationality varchar2(18) --    
    ,nativeplace varchar2(200) --    
    ,politicalface varchar2(18) --    
    ,marriage varchar2(18) --    
    ,relativetype varchar2(200) --    
    ,familyadd varchar2(200) --    
    ,familyzip varchar2(32) --    
    ,emailadd varchar2(80) --    
    ,familytel varchar2(32) --    
    ,mobiletelephone varchar2(32) --    
    ,unitkind varchar2(18) --    
    ,workcorp varchar2(100) --    
    ,workadd varchar2(200) --    
    ,worktel varchar2(32) --    
    ,occupation varchar2(18) --    
    ,position varchar2(18) --    
    ,employrecord varchar2(200) --    
    ,edurecord varchar2(200) --    
    ,eduexperience varchar2(18) --    
    ,edudegree varchar2(18) --    
    ,graduateyear varchar2(10) --    
    ,financebelong varchar2(18) --    
    ,creditlevel varchar2(18) --    
    ,evaluatedate varchar2(10) --    
    ,balancesheet varchar2(200) --    
    ,intro varchar2(200) --    
    ,selfmonthincome number(24,6) --    
    ,familymonthincome number(24,6) --    
    ,incomesource varchar2(200) --    
    ,population number(22) --    
    ,loancardno varchar2(32) --    
    ,loancardinsyear varchar2(10) --    
    ,farmersort varchar2(18) --    
    ,regionalism varchar2(18) --    
    ,staff varchar2(18) --    
    ,creditfarmer varchar2(18) --    
    ,riskinclination varchar2(200) --    
    ,character varchar2(200) --    
    ,dataquality varchar2(1) --    
    ,inputorgid varchar2(32) --    
    ,inputuserid varchar2(32) --    
    ,inputdate varchar2(10) --    
    ,updatedate varchar2(10) --    
    ,remark varchar2(200) --    
    ,updateorgid varchar2(32) --    
    ,updateuserid varchar2(32) --    
    ,commadd varchar2(200) --    
    ,commzip varchar2(10) --    
    ,nativeadd varchar2(200) --    
    ,workzip varchar2(10) --    
    ,headship varchar2(18) --    
    ,workbegindate varchar2(10) --    
    ,yearincome number(24,6) --    
    ,payaccount varchar2(32) --    
    ,payaccountbank varchar2(200) --    
    ,familystatus varchar2(18) --    
    ,tempsaveflag varchar2(18) --    
    ,certid18 varchar2(40) --    
    ,nativenature varchar2(18) -- 增加户籍性质   
    ,housevalue varchar2(18) -- 房屋价值   
    ,freecarcondition varchar2(18) -- 自由汽车状况   
    ,familyyearincomepercapita number(24,6) -- 家庭人均年收入   
    ,monthincome number(24,6) -- 个人月收入   
    ,supportpopulations number(22) -- 供养人口   
    ,children number(22) -- 其中子女人数   
    ,currentworkyears number(22) -- 现单位工作年限   
    ,age number(22) -- 年龄   
    ,familytotalassets number(24,6) -- 家庭总资产   
    ,familytotalliabilities number(24,6) -- 家庭总负债   
    ,billstyle varchar2(18) -- 账单形式   
    ,emergencycontact varchar2(80) -- 紧急联系人   
    ,emergencycontactaddress varchar2(200) -- 紧急联系人地址   
    ,emergencycontactmobilephone varchar2(32) -- 紧急联系人手机   
    ,localcontract varchar2(80) -- 本地联系人   
    ,localcontractaddress varchar2(200) -- 本地联系人地址   
    ,localcontracttelephone varchar2(32) -- 本地联系人电话   
    ,localcontractmobilephone varchar2(32) -- 本地联系人手机   
    ,currentindustryworkyears number(22) -- 目前行业从业年限   
    ,workyears number(22) -- 任职年限   
    ,registeredcapital number(24,6) -- 注册资本   
    ,managementscope varchar2(200) -- 经营范围   
    ,managementtype varchar2(200) -- 经营类型   
    ,managementplace varchar2(200) -- 经营场所   
    ,enterpriseyearincome number(24,6) -- 经营企业年业务收入   
    ,enterpriseadd varchar2(200) -- 经营企业地址   
    ,newcustomertype varchar2(10) -- 客户类型  代码：NewCustomerType   
    ,otherincome number(24,6) -- 其他收入(元)---核实要素   
    ,rentincome number(24,6) -- 租金收入(元)---核实要素   
    ,convertincome number(24,6) -- 财产折算收入(元)---核实要素   
    ,salaryincome number(24,6) -- 薪资收入(元)---核实要素   
    ,takingsmonthly number(24,6) -- 月营业收入(元)---核实要素   
    ,profitmarginmonthly number(24,6) -- 核算利润率(%)---核实要素   
    ,stocklot number(24,6) -- 股份%(企业主股东填写)---核实要素   
    ,debtmonthly number(24,6) -- 个人月负债额(元)---核实要素   
    ,housearea varchar2(20) -- 住宅电话:地区号   
    ,corparea varchar2(20) -- 单位电话:地区号   
    ,cheatcheckresult varchar2(10) -- 欺诈检测结果(0.正常 1.可疑)   
    ,lmcredittype varchar2(1) -- 客户洗钱风险分类   
    ,isrelatedparty varchar2(10) -- 是否关联方   
    ,socialinsuranceflag varchar2(200) --    
    ,localhouseflag varchar2(200) --    
    ,localyear varchar2(200) --    
    ,monthcashout varchar2(200) --    
    ,corpextension varchar2(200) --    
    ,corpzone varchar2(200) --    
    ,department varchar2(200) --    
    ,regioncodename varchar2(200) --    
    ,firsttel varchar2(200) --    
    ,housezone varchar2(200) --    
    ,custen varchar2(100) -- 英文名称   
    ,custtp varchar2(2) -- 客户类型   
    ,isblak varchar2(1) -- 是否黑名单客户   
    ,custst varchar2(2) -- 客户状态   
    ,psrntg varchar2(1) -- 居民标识   
    ,ntlycd varchar2(4) -- 国籍   
    ,rgstad varchar2(8) -- 地区代码   
    ,lncdno varchar2(20) -- 贷款卡编号   
    ,lncdpw varchar2(6) -- 贷款卡密码   
    ,lncdtg varchar2(1) -- 贷款卡状态   
    ,ispart varchar2(1) -- 是否我行股东   
    ,mainfg varchar2(1) -- 是否主证件号   
    ,idtfst varchar2(1) -- 证件状态   
    ,contna varchar2(100) -- 联系人姓名   
    ,cmainf varchar2(1) -- 是否主联系方式   
    ,othrtl varchar2(50) -- 其他电话   
    ,mailad varchar2(100) -- 地址   
    ,mfcustomerid varchar2(10) -- CIF客户号   
    ,businessentityid varchar2(32) --    
    ,businessentityname varchar2(80) --    
    ,businessentityshinfo varchar2(80) --    
    ,finalevaluatedate varchar2(10) -- 评级日期   
    ,customermemberlevel varchar2(20) --    
    ,isrelative varchar2(18) -- 是否我行关联交易   
    ,ownertype varchar2(1) -- 业主类型：1-个体工商户，2-小微企业主   
    ,iscountryhousehold varchar2(1) -- 是否农村户口   
    ,worknature varchar2(10) -- 单位性质   
    ,posionlevel varchar2(10) -- 职务类型   
    ,employeetype varchar2(10) -- 雇佣类型   
    ,industryage number -- 企业成立年限   
    ,regioncode varchar2(30) -- 户口所在地   
    ,firstemail varchar2(10) -- 首选邮寄   
    ,bqueryresult varchar2(10) -- 单位工商查询结果   
    ,risktype varchar2(10) -- 行业风险类别   
    ,jobtype varchar2(10) -- 工作性质   
    ,corptradeflag varchar2(10) -- 贸易型企业   
    ,corpregisterdate varchar2(10) -- 注册时间   
    ,registerfinancing number(24,6) -- 注册资本金   
    ,preyeardpf number(24,6) -- 流水份数   
    ,incomeremark varchar2(400) -- 个人月收入计算<br>特殊说明<br>   
    ,debtflag varchar2(10) -- 或有负债   
    ,debtmonthlyremark varchar2(400) -- 已有债务月付额<br>计算公式及说明<br>   
    ,bpcreditlevel varchar2(10) -- 人行信用报告结果   
    ,creditremark varchar2(400) -- 其他说明<br>   
    ,consistentflag varchar2(10) -- 工作单位与<br>社保/公积金一致   
    ,realtycontractcount varchar2(10) -- 已有房贷笔数   
    ,bankrelativeflag varchar2(10) -- 银行关联方   
    ,creditresult varchar2(400) -- 征信结论<br>   
    ,alipayaccount varchar2(100) -- 支付宝账号   
    ,jdaccount varchar2(100) -- 京东网账号   
    ,remark2 varchar2(100) -- 人寿保单的保险公司名称   
    ,otherbankcard varchar2(100) -- 持有他行信用卡   
    ,certidaddress varchar2(200) -- 身份证发证所在地   
    ,baseresidyear number(22) -- 本地居住年限   
    ,baseindustryyear number(22) -- 从事本行业年限   
    ,managindustry varchar2(32) -- 经营行业   
    ,debtorbusiness number(24,6) -- 或有负债规模   
    ,carsum number(22) -- 车辆情况   
    ,housepvalue number(24,6) -- 房产价值   
    ,isinvestmentsm varchar2(2) -- 是否有融资投资股市   
    ,incomeratio number(24,6) -- 收入还贷比   
    ,socialsecyear number(22) -- 社保缴纳时长   
    ,accumuratio number(24,6) -- 公积金缴纳比例   
    ,ishavework varchar2(2) -- 配偶是否有工作   
    ,unsettledsum number(22) -- 当前未结清信用贷款笔数   
    ,expectedsum number(22) -- 近6个月逾期次数   
    ,maxposition number(24,6) -- 信用卡单张最大授信额度   
    ,creditcondit varchar2(4) -- 是否在我行信贷情况   
    ,ishavembusiness varchar2(2) -- 是否在本行办理了中间业务   
    ,isbaseemployee varchar2(2) -- 是否我行员工   
    ,isbasebpay varchar2(2) -- 是否我行代发工资户   
    ,isbasebpaccount varchar2(2) -- 是否我行的定期账户   
    ,isbasebfaccount varchar2(2) -- 是否我行理财账户   
    ,isbasebvipaccount varchar2(2) -- 是否我行VIP账户   
    ,isfammigration varchar2(2) -- 配偶及子女是否移民   
    ,isnegationeva varchar2(2) -- 是否存在第三方负面评价   
    ,ispaydefault varchar2(2) -- 经营实体是否存在工资拖欠情况   
    ,ishaveprefer varchar2(2) -- 是否享受国家政策优惠   
    ,creditguarantee varchar2(4) -- 在我行信贷情况   
    ,isexcecase varchar2(2) -- 是否出现过“冻结”、“止付”等特殊情况   
    ,isoverrotio varchar2(2) -- 是否或有负债占净资产比重超过100%   
    ,isoverhealth varchar2(2) -- 是否借款人身体状况较差，曾发生过重大疾病住院记录   
    ,isbadbehavior varchar2(2) -- 是否存在不良行为，如赌博、斗殴等不良嗜好、拖欠电话费、水电煤气费、承包费等   
    ,ishavepower varchar2(2) -- 是否不具有所经营范围的经营权，或营业执照无效   
    ,industyperesult varchar2(10) -- 授信政策行业   
    ,ispenal varchar2(2) -- 近5年是否存在刑事判决记录   
    ,isviolation varchar2(2) -- 是否存在重大违法违规行为   
    ,isecondis varchar2(2) -- 是否存在重大经济纠纷   
    ,isbreach varchar2(2) -- 是否存在重大违约行为   
    ,managescale number(22) -- 经营规模(经营人数)   
    ,accumumount number(24,6) -- 公积金缴纳基数   
    ,overduetimes varchar2(8) -- 信用卡逾期次数   
    ,allavgusedsum_last_six_month number(24,6) -- 所有贷记和准贷记卡近六月平均使用额度   
    ,creditcardsum varchar2(8) -- 信用卡张数   
    ,guarforothers varchar2(1) -- 有无对外担保(1有，2无)   
    ,dsblk varchar2(1) -- 是否在大数黑名单   
    ,customerisrelative varchar2(1) -- 借款人为我行关联方 0-否，1-是   
    ,guarantorisrelative varchar2(1) -- 保证人为我行关联方 0-否，1-是   
    ,busicerttype varchar2(10) -- 企业证件类型   
    ,start_dt date -- 开始日期   
    ,end_dt date -- 结束日期   
    ,id_mark varchar2(10) -- 删除标识   
	,etl_timestamp timestamp(6)
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_crss_ind_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_crss_ind_info is '个人基本信息';
comment on column ${idl_schema}.oass_crss_ind_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_crss_ind_info.customerid is '';
comment on column ${idl_schema}.oass_crss_ind_info.fullname is '';
comment on column ${idl_schema}.oass_crss_ind_info.sex is '';
comment on column ${idl_schema}.oass_crss_ind_info.birthday is '';
comment on column ${idl_schema}.oass_crss_ind_info.certtype is '';
comment on column ${idl_schema}.oass_crss_ind_info.certid is '';
comment on column ${idl_schema}.oass_crss_ind_info.sino is '';
comment on column ${idl_schema}.oass_crss_ind_info.country is '';
comment on column ${idl_schema}.oass_crss_ind_info.nationality is '';
comment on column ${idl_schema}.oass_crss_ind_info.nativeplace is '';
comment on column ${idl_schema}.oass_crss_ind_info.politicalface is '';
comment on column ${idl_schema}.oass_crss_ind_info.marriage is '';
comment on column ${idl_schema}.oass_crss_ind_info.relativetype is '';
comment on column ${idl_schema}.oass_crss_ind_info.familyadd is '';
comment on column ${idl_schema}.oass_crss_ind_info.familyzip is '';
comment on column ${idl_schema}.oass_crss_ind_info.emailadd is '';
comment on column ${idl_schema}.oass_crss_ind_info.familytel is '';
comment on column ${idl_schema}.oass_crss_ind_info.mobiletelephone is '';
comment on column ${idl_schema}.oass_crss_ind_info.unitkind is '';
comment on column ${idl_schema}.oass_crss_ind_info.workcorp is '';
comment on column ${idl_schema}.oass_crss_ind_info.workadd is '';
comment on column ${idl_schema}.oass_crss_ind_info.worktel is '';
comment on column ${idl_schema}.oass_crss_ind_info.occupation is '';
comment on column ${idl_schema}.oass_crss_ind_info.position is '';
comment on column ${idl_schema}.oass_crss_ind_info.employrecord is '';
comment on column ${idl_schema}.oass_crss_ind_info.edurecord is '';
comment on column ${idl_schema}.oass_crss_ind_info.eduexperience is '';
comment on column ${idl_schema}.oass_crss_ind_info.edudegree is '';
comment on column ${idl_schema}.oass_crss_ind_info.graduateyear is '';
comment on column ${idl_schema}.oass_crss_ind_info.financebelong is '';
comment on column ${idl_schema}.oass_crss_ind_info.creditlevel is '';
comment on column ${idl_schema}.oass_crss_ind_info.evaluatedate is '';
comment on column ${idl_schema}.oass_crss_ind_info.balancesheet is '';
comment on column ${idl_schema}.oass_crss_ind_info.intro is '';
comment on column ${idl_schema}.oass_crss_ind_info.selfmonthincome is '';
comment on column ${idl_schema}.oass_crss_ind_info.familymonthincome is '';
comment on column ${idl_schema}.oass_crss_ind_info.incomesource is '';
comment on column ${idl_schema}.oass_crss_ind_info.population is '';
comment on column ${idl_schema}.oass_crss_ind_info.loancardno is '';
comment on column ${idl_schema}.oass_crss_ind_info.loancardinsyear is '';
comment on column ${idl_schema}.oass_crss_ind_info.farmersort is '';
comment on column ${idl_schema}.oass_crss_ind_info.regionalism is '';
comment on column ${idl_schema}.oass_crss_ind_info.staff is '';
comment on column ${idl_schema}.oass_crss_ind_info.creditfarmer is '';
comment on column ${idl_schema}.oass_crss_ind_info.riskinclination is '';
comment on column ${idl_schema}.oass_crss_ind_info.character is '';
comment on column ${idl_schema}.oass_crss_ind_info.dataquality is '';
comment on column ${idl_schema}.oass_crss_ind_info.inputorgid is '';
comment on column ${idl_schema}.oass_crss_ind_info.inputuserid is '';
comment on column ${idl_schema}.oass_crss_ind_info.inputdate is '';
comment on column ${idl_schema}.oass_crss_ind_info.updatedate is '';
comment on column ${idl_schema}.oass_crss_ind_info.remark is '';
comment on column ${idl_schema}.oass_crss_ind_info.updateorgid is '';
comment on column ${idl_schema}.oass_crss_ind_info.updateuserid is '';
comment on column ${idl_schema}.oass_crss_ind_info.commadd is '';
comment on column ${idl_schema}.oass_crss_ind_info.commzip is '';
comment on column ${idl_schema}.oass_crss_ind_info.nativeadd is '';
comment on column ${idl_schema}.oass_crss_ind_info.workzip is '';
comment on column ${idl_schema}.oass_crss_ind_info.headship is '';
comment on column ${idl_schema}.oass_crss_ind_info.workbegindate is '';
comment on column ${idl_schema}.oass_crss_ind_info.yearincome is '';
comment on column ${idl_schema}.oass_crss_ind_info.payaccount is '';
comment on column ${idl_schema}.oass_crss_ind_info.payaccountbank is '';
comment on column ${idl_schema}.oass_crss_ind_info.familystatus is '';
comment on column ${idl_schema}.oass_crss_ind_info.tempsaveflag is '';
comment on column ${idl_schema}.oass_crss_ind_info.certid18 is '';
comment on column ${idl_schema}.oass_crss_ind_info.nativenature is '增加户籍性质';
comment on column ${idl_schema}.oass_crss_ind_info.housevalue is '房屋价值';
comment on column ${idl_schema}.oass_crss_ind_info.freecarcondition is '自由汽车状况';
comment on column ${idl_schema}.oass_crss_ind_info.familyyearincomepercapita is '家庭人均年收入';
comment on column ${idl_schema}.oass_crss_ind_info.monthincome is '个人月收入';
comment on column ${idl_schema}.oass_crss_ind_info.supportpopulations is '供养人口';
comment on column ${idl_schema}.oass_crss_ind_info.children is '其中子女人数';
comment on column ${idl_schema}.oass_crss_ind_info.currentworkyears is '现单位工作年限';
comment on column ${idl_schema}.oass_crss_ind_info.age is '年龄';
comment on column ${idl_schema}.oass_crss_ind_info.familytotalassets is '家庭总资产';
comment on column ${idl_schema}.oass_crss_ind_info.familytotalliabilities is '家庭总负债';
comment on column ${idl_schema}.oass_crss_ind_info.billstyle is '账单形式';
comment on column ${idl_schema}.oass_crss_ind_info.emergencycontact is '紧急联系人';
comment on column ${idl_schema}.oass_crss_ind_info.emergencycontactaddress is '紧急联系人地址';
comment on column ${idl_schema}.oass_crss_ind_info.emergencycontactmobilephone is '紧急联系人手机';
comment on column ${idl_schema}.oass_crss_ind_info.localcontract is '本地联系人';
comment on column ${idl_schema}.oass_crss_ind_info.localcontractaddress is '本地联系人地址';
comment on column ${idl_schema}.oass_crss_ind_info.localcontracttelephone is '本地联系人电话';
comment on column ${idl_schema}.oass_crss_ind_info.localcontractmobilephone is '本地联系人手机';
comment on column ${idl_schema}.oass_crss_ind_info.currentindustryworkyears is '目前行业从业年限';
comment on column ${idl_schema}.oass_crss_ind_info.workyears is '任职年限';
comment on column ${idl_schema}.oass_crss_ind_info.registeredcapital is '注册资本';
comment on column ${idl_schema}.oass_crss_ind_info.managementscope is '经营范围';
comment on column ${idl_schema}.oass_crss_ind_info.managementtype is '经营类型';
comment on column ${idl_schema}.oass_crss_ind_info.managementplace is '经营场所';
comment on column ${idl_schema}.oass_crss_ind_info.enterpriseyearincome is '经营企业年业务收入';
comment on column ${idl_schema}.oass_crss_ind_info.enterpriseadd is '经营企业地址';
comment on column ${idl_schema}.oass_crss_ind_info.newcustomertype is '客户类型  代码：NewCustomerType';
comment on column ${idl_schema}.oass_crss_ind_info.otherincome is '其他收入(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.rentincome is '租金收入(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.convertincome is '财产折算收入(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.salaryincome is '薪资收入(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.takingsmonthly is '月营业收入(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.profitmarginmonthly is '核算利润率(%)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.stocklot is '股份%(企业主股东填写)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.debtmonthly is '个人月负债额(元)---核实要素';
comment on column ${idl_schema}.oass_crss_ind_info.housearea is '住宅电话:地区号';
comment on column ${idl_schema}.oass_crss_ind_info.corparea is '单位电话:地区号';
comment on column ${idl_schema}.oass_crss_ind_info.cheatcheckresult is '欺诈检测结果(0.正常 1.可疑)';
comment on column ${idl_schema}.oass_crss_ind_info.lmcredittype is '客户洗钱风险分类';
comment on column ${idl_schema}.oass_crss_ind_info.isrelatedparty is '是否关联方';
comment on column ${idl_schema}.oass_crss_ind_info.socialinsuranceflag is '';
comment on column ${idl_schema}.oass_crss_ind_info.localhouseflag is '';
comment on column ${idl_schema}.oass_crss_ind_info.localyear is '';
comment on column ${idl_schema}.oass_crss_ind_info.monthcashout is '';
comment on column ${idl_schema}.oass_crss_ind_info.corpextension is '';
comment on column ${idl_schema}.oass_crss_ind_info.corpzone is '';
comment on column ${idl_schema}.oass_crss_ind_info.department is '';
comment on column ${idl_schema}.oass_crss_ind_info.regioncodename is '';
comment on column ${idl_schema}.oass_crss_ind_info.firsttel is '';
comment on column ${idl_schema}.oass_crss_ind_info.housezone is '';
comment on column ${idl_schema}.oass_crss_ind_info.custen is '英文名称';
comment on column ${idl_schema}.oass_crss_ind_info.custtp is '客户类型';
comment on column ${idl_schema}.oass_crss_ind_info.isblak is '是否黑名单客户';
comment on column ${idl_schema}.oass_crss_ind_info.custst is '客户状态';
comment on column ${idl_schema}.oass_crss_ind_info.psrntg is '居民标识';
comment on column ${idl_schema}.oass_crss_ind_info.ntlycd is '国籍';
comment on column ${idl_schema}.oass_crss_ind_info.rgstad is '地区代码';
comment on column ${idl_schema}.oass_crss_ind_info.lncdno is '贷款卡编号';
comment on column ${idl_schema}.oass_crss_ind_info.lncdpw is '贷款卡密码';
comment on column ${idl_schema}.oass_crss_ind_info.lncdtg is '贷款卡状态';
comment on column ${idl_schema}.oass_crss_ind_info.ispart is '是否我行股东';
comment on column ${idl_schema}.oass_crss_ind_info.mainfg is '是否主证件号';
comment on column ${idl_schema}.oass_crss_ind_info.idtfst is '证件状态';
comment on column ${idl_schema}.oass_crss_ind_info.contna is '联系人姓名';
comment on column ${idl_schema}.oass_crss_ind_info.cmainf is '是否主联系方式';
comment on column ${idl_schema}.oass_crss_ind_info.othrtl is '其他电话';
comment on column ${idl_schema}.oass_crss_ind_info.mailad is '地址';
comment on column ${idl_schema}.oass_crss_ind_info.mfcustomerid is 'CIF客户号';
comment on column ${idl_schema}.oass_crss_ind_info.businessentityid is '';
comment on column ${idl_schema}.oass_crss_ind_info.businessentityname is '';
comment on column ${idl_schema}.oass_crss_ind_info.businessentityshinfo is '';
comment on column ${idl_schema}.oass_crss_ind_info.finalevaluatedate is '评级日期';
comment on column ${idl_schema}.oass_crss_ind_info.customermemberlevel is '';
comment on column ${idl_schema}.oass_crss_ind_info.isrelative is '是否我行关联交易';
comment on column ${idl_schema}.oass_crss_ind_info.ownertype is '业主类型：1-个体工商户，2-小微企业主';
comment on column ${idl_schema}.oass_crss_ind_info.iscountryhousehold is '是否农村户口';
comment on column ${idl_schema}.oass_crss_ind_info.worknature is '单位性质';
comment on column ${idl_schema}.oass_crss_ind_info.posionlevel is '职务类型';
comment on column ${idl_schema}.oass_crss_ind_info.employeetype is '雇佣类型';
comment on column ${idl_schema}.oass_crss_ind_info.industryage is '企业成立年限';
comment on column ${idl_schema}.oass_crss_ind_info.regioncode is '户口所在地';
comment on column ${idl_schema}.oass_crss_ind_info.firstemail is '首选邮寄';
comment on column ${idl_schema}.oass_crss_ind_info.bqueryresult is '单位工商查询结果';
comment on column ${idl_schema}.oass_crss_ind_info.risktype is '行业风险类别';
comment on column ${idl_schema}.oass_crss_ind_info.jobtype is '工作性质';
comment on column ${idl_schema}.oass_crss_ind_info.corptradeflag is '贸易型企业';
comment on column ${idl_schema}.oass_crss_ind_info.corpregisterdate is '注册时间';
comment on column ${idl_schema}.oass_crss_ind_info.registerfinancing is '注册资本金';
comment on column ${idl_schema}.oass_crss_ind_info.preyeardpf is '流水份数';
comment on column ${idl_schema}.oass_crss_ind_info.incomeremark is '个人月收入计算<br>特殊说明<br>';
comment on column ${idl_schema}.oass_crss_ind_info.debtflag is '或有负债';
comment on column ${idl_schema}.oass_crss_ind_info.debtmonthlyremark is '已有债务月付额<br>计算公式及说明<br>';
comment on column ${idl_schema}.oass_crss_ind_info.bpcreditlevel is '人行信用报告结果';
comment on column ${idl_schema}.oass_crss_ind_info.creditremark is '其他说明<br>';
comment on column ${idl_schema}.oass_crss_ind_info.consistentflag is '工作单位与<br>社保/公积金一致';
comment on column ${idl_schema}.oass_crss_ind_info.realtycontractcount is '已有房贷笔数';
comment on column ${idl_schema}.oass_crss_ind_info.bankrelativeflag is '银行关联方';
comment on column ${idl_schema}.oass_crss_ind_info.creditresult is '征信结论<br>';
comment on column ${idl_schema}.oass_crss_ind_info.alipayaccount is '支付宝账号';
comment on column ${idl_schema}.oass_crss_ind_info.jdaccount is '京东网账号';
comment on column ${idl_schema}.oass_crss_ind_info.remark2 is '人寿保单的保险公司名称';
comment on column ${idl_schema}.oass_crss_ind_info.otherbankcard is '持有他行信用卡';
comment on column ${idl_schema}.oass_crss_ind_info.certidaddress is '身份证发证所在地';
comment on column ${idl_schema}.oass_crss_ind_info.baseresidyear is '本地居住年限';
comment on column ${idl_schema}.oass_crss_ind_info.baseindustryyear is '从事本行业年限';
comment on column ${idl_schema}.oass_crss_ind_info.managindustry is '经营行业';
comment on column ${idl_schema}.oass_crss_ind_info.debtorbusiness is '或有负债规模';
comment on column ${idl_schema}.oass_crss_ind_info.carsum is '车辆情况';
comment on column ${idl_schema}.oass_crss_ind_info.housepvalue is '房产价值';
comment on column ${idl_schema}.oass_crss_ind_info.isinvestmentsm is '是否有融资投资股市';
comment on column ${idl_schema}.oass_crss_ind_info.incomeratio is '收入还贷比';
comment on column ${idl_schema}.oass_crss_ind_info.socialsecyear is '社保缴纳时长';
comment on column ${idl_schema}.oass_crss_ind_info.accumuratio is '公积金缴纳比例';
comment on column ${idl_schema}.oass_crss_ind_info.ishavework is '配偶是否有工作';
comment on column ${idl_schema}.oass_crss_ind_info.unsettledsum is '当前未结清信用贷款笔数';
comment on column ${idl_schema}.oass_crss_ind_info.expectedsum is '近6个月逾期次数';
comment on column ${idl_schema}.oass_crss_ind_info.maxposition is '信用卡单张最大授信额度';
comment on column ${idl_schema}.oass_crss_ind_info.creditcondit is '是否在我行信贷情况';
comment on column ${idl_schema}.oass_crss_ind_info.ishavembusiness is '是否在本行办理了中间业务';
comment on column ${idl_schema}.oass_crss_ind_info.isbaseemployee is '是否我行员工';
comment on column ${idl_schema}.oass_crss_ind_info.isbasebpay is '是否我行代发工资户';
comment on column ${idl_schema}.oass_crss_ind_info.isbasebpaccount is '是否我行的定期账户';
comment on column ${idl_schema}.oass_crss_ind_info.isbasebfaccount is '是否我行理财账户';
comment on column ${idl_schema}.oass_crss_ind_info.isbasebvipaccount is '是否我行VIP账户';
comment on column ${idl_schema}.oass_crss_ind_info.isfammigration is '配偶及子女是否移民';
comment on column ${idl_schema}.oass_crss_ind_info.isnegationeva is '是否存在第三方负面评价';
comment on column ${idl_schema}.oass_crss_ind_info.ispaydefault is '经营实体是否存在工资拖欠情况';
comment on column ${idl_schema}.oass_crss_ind_info.ishaveprefer is '是否享受国家政策优惠';
comment on column ${idl_schema}.oass_crss_ind_info.creditguarantee is '在我行信贷情况';
comment on column ${idl_schema}.oass_crss_ind_info.isexcecase is '是否出现过“冻结”、“止付”等特殊情况';
comment on column ${idl_schema}.oass_crss_ind_info.isoverrotio is '是否或有负债占净资产比重超过100%';
comment on column ${idl_schema}.oass_crss_ind_info.isoverhealth is '是否借款人身体状况较差，曾发生过重大疾病住院记录';
comment on column ${idl_schema}.oass_crss_ind_info.isbadbehavior is '是否存在不良行为，如赌博、斗殴等不良嗜好、拖欠电话费、水电煤气费、承包费等';
comment on column ${idl_schema}.oass_crss_ind_info.ishavepower is '是否不具有所经营范围的经营权，或营业执照无效';
comment on column ${idl_schema}.oass_crss_ind_info.industyperesult is '授信政策行业';
comment on column ${idl_schema}.oass_crss_ind_info.ispenal is '近5年是否存在刑事判决记录';
comment on column ${idl_schema}.oass_crss_ind_info.isviolation is '是否存在重大违法违规行为';
comment on column ${idl_schema}.oass_crss_ind_info.isecondis is '是否存在重大经济纠纷';
comment on column ${idl_schema}.oass_crss_ind_info.isbreach is '是否存在重大违约行为';
comment on column ${idl_schema}.oass_crss_ind_info.managescale is '经营规模(经营人数)';
comment on column ${idl_schema}.oass_crss_ind_info.accumumount is '公积金缴纳基数';
comment on column ${idl_schema}.oass_crss_ind_info.overduetimes is '信用卡逾期次数';
comment on column ${idl_schema}.oass_crss_ind_info.allavgusedsum_last_six_month is '所有贷记和准贷记卡近六月平均使用额度';
comment on column ${idl_schema}.oass_crss_ind_info.creditcardsum is '信用卡张数';
comment on column ${idl_schema}.oass_crss_ind_info.guarforothers is '有无对外担保(1有，2无)';
comment on column ${idl_schema}.oass_crss_ind_info.dsblk is '是否在大数黑名单';
comment on column ${idl_schema}.oass_crss_ind_info.customerisrelative is '借款人为我行关联方 0-否，1-是';
comment on column ${idl_schema}.oass_crss_ind_info.guarantorisrelative is '保证人为我行关联方 0-否，1-是';
comment on column ${idl_schema}.oass_crss_ind_info.busicerttype is '企业证件类型';
comment on column ${idl_schema}.oass_crss_ind_info.start_dt is '开始日期';
comment on column ${idl_schema}.oass_crss_ind_info.end_dt is '结束日期';
comment on column ${idl_schema}.oass_crss_ind_info.id_mark is '删除标识';
comment on column ${idl_schema}.oass_crss_ind_info.etl_timestamp is '';