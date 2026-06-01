/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_xked_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_xked_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_xked_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_xked_iqp_loan_app(
    serialno varchar2(64) -- 业务流水号
    ,applyno varchar2(64) -- 信贷申请流水号
    ,prdcode varchar2(64) -- 产品编号
    ,prdname varchar2(64) -- 产品名称
    ,channel varchar2(32) -- 接入渠道
    ,termmonth varchar2(16) -- 贷款期限
    ,loadamount number(24,6) -- 申请金额
    ,inputid varchar2(32) -- 客户经理号
    ,dwellareacode varchar2(10) -- 额度是否循环
    ,dwelladdress varchar2(32) -- 主担保方式
    ,taxstrdate varchar2(32) -- 产品分类标志
    ,enterprisename varchar2(1000) -- 企业名称
    ,entidttp varchar2(32) -- 企业身份标识类型
    ,entidtno varchar2(32) -- 企业身份标识号码
    ,businessscope varchar2(32) -- 经营地址所属省
    ,validitedate varchar2(32) -- 经营地址所属市
    ,registerarea varchar2(32) -- 经营地址所属县（区）
    ,registeraddress varchar2(100) -- 经营详细地址
    ,sciencetechenttype varchar2(100) -- 科创企业类型
    ,actualcontrollerempyears varchar2(32) -- 实控人从业年限（年）
    ,flowannualsalesrevenue number(24,6) -- 流水推算的年销售收入
    ,entsolftcopyrightregnum varchar2(32) -- 企业软著登记公告次数
    ,entknowledgepropnum varchar2(32) -- 企业知识产权数量
    ,knowledgepropinventnum varchar2(32) -- 知识产权发明数量
    ,intefcircuitlayoutdesignappnum varchar2(32) -- 集成电路布图设计申请数量
    ,knowledgepropinfrinpunishnum varchar2(32) -- 知识产权侵权处罚次数
    ,knowledgepropunfaircompenum varchar2(32) -- 知识产权不正当竞争次数
    ,knowledgepropjudgdocdefentnum varchar2(32) -- 知识产权裁判文书被告次数
    ,past24mupstreamtop5purchamt number(24,6) -- 近24个月上游前5大采购金额
    ,past24mupstreamintegpurchamt number(24,6) -- 近24个月上游整体采购金额
    ,past24mdownstreamtop5saleamt number(24,6) -- 近24个月下游前5大销售金额
    ,past24mdownstreamintegsaleamt number(24,6) -- 近24个月下游整体销售金额
    ,past12mispartnertop10transamt number(24,6) -- 近12个月重要稳定供应商（前十）交易金额
    ,past12miscusttop10transamt number(24,6) -- 近12个月重要稳定客户（前十）交易金额
    ,past24minvoicrevenue number(24,6) -- 近24个月开票收入
    ,annualhightechproincome number(24,6) -- 本年度高新技术产品（服务）收入
    ,preyearhightechproincome number(24,6) -- 上年度高新技术产品（服务）收入
    ,annualoperaincome number(24,6) -- 本年度营业收入
    ,annualempsnum varchar2(32) -- 本年度从业人数（人）
    ,preyearempsnum varchar2(32) -- 上年度从业人数
    ,annualtechninum varchar2(32) -- 本年度科技人员人数
    ,preyeartechninum varchar2(32) -- 上年度科技人员人数
    ,annualresearchdevamt number(24,6) -- 本年度研发费用金额
    ,preyearresearchdevamt number(24,6) -- 上年度研发费用金额
    ,annualentgetgovsusidy number(24,6) -- 本年度企业获取政府补贴收入
    ,preyearentgetgovsusidy number(24,6) -- 上年度企业获取政府补贴收入
    ,forecastnextyearsale varchar2(32) -- 预测次年销售量
    ,otherchannelworkcapit number(24,6) -- 其他渠道提供的运营资金
    ,nocrediteachdebtaccubalance number(24,6) -- 未在征信报告中体现的各类负债
    ,nocreditmonthaccurepaydebt number(24,6) -- 未在征信报告中体现的各类负债月还款额
    ,entmonthrepaybalance number(24,6) -- 企业月还款额
    ,ispledgedreceiveaccount varchar2(32) -- 企业应收账款是否质押
    ,pledgereceiveamt number(24,6) -- 应收账款质押贷款金额
    ,isknowledgepledged varchar2(32) -- 知识产权是否质押
    ,knowledgepledgereceiveamt number(24,6) -- 知识产权质押贷款金额
    ,isstockpledged varchar2(32) -- 股权是否质押
    ,stockpledgedamt number(24,6) -- 股权质押贷款金额
    ,qryusertype varchar2(32) -- 征信查询人类型
    ,qryopertp varchar2(32) -- 征信查询操作申请类型
    ,partner varchar2(32) -- 系统来源
    ,reportusernm varchar2(32) -- 报告使用人姓名
    ,reportuseroff varchar2(32) -- 报告使用人所属部门
    ,authotype varchar2(32) -- 授权方式
    ,biometrics varchar2(32) -- 生物识别技术
    ,authotime date -- 授权时间
    ,authostrdate date -- 授权开始时间
    ,authoenddate date -- 授权结束时间
    ,custname varchar2(32) -- 法人代表人姓名
    ,sex varchar2(32) -- 法人代表人性别
    ,nation varchar2(32) -- 法人代表人国籍
    ,idtype varchar2(32) -- 法人代表人证件类型
    ,idno varchar2(32) -- 法人代表人身份证号码
    ,inputorgid varchar2(32) -- 登记机构
    ,inputuserid varchar2(32) -- 登记人
    ,inputdate date -- 登记日期
    ,updateorgid varchar2(32) -- 更新机构
    ,updateuserid varchar2(32) -- 更新人
    ,updatedate date -- 更新时间
    ,approvestatus varchar2(32) -- 审批状态
    ,finalapplyamount number(24,6) -- 终审额度
    ,transstatus varchar2(32) -- 流程状态
    ,status varchar2(32) -- 任务状态
    ,branchid varchar2(32) -- 所属分行
    ,isbankrel varchar2(2) -- 是否我行关联人
    ,autoscore varchar2(32) -- 评分卡得分
    ,apprendtime date -- 营业日期
    ,risknote varchar2(4000) -- 备注
    ,riskwarm varchar2(4000) -- 预警
    ,tradecode varchar2(18) -- 行业类型
    ,empcountyear number(22) -- 从业人数
    ,tatalasset number(24,6) -- 资产合计
    ,proceeds number(24,6) -- 营业收入
    ,scale varchar2(10) -- 企业规模
    ,bizscope varchar2(64) -- 经营范围
    ,registerdaddress varchar2(64) -- 企业注册地址
    ,enttermduedate date -- 企业营业期限到期日
    ,bano varchar2(64) -- 授信申请编号
    ,taxqueryflag varchar2(1) -- 税务查询标志
    ,taxauthorizeno varchar2(64) -- 税务授权流水号
    ,taxpayeridentityno varchar2(64) -- 纳税人识别号
    ,istaxsuccessgs varchar2(32) -- 广税授权是否成功
    ,idexpirydate date -- 企业证件到期日
    ,loanendtime date -- 终审结束时间
    ,loanstarttime date -- 终审申请时间
    ,opercorpflg varchar2(10) -- 经营企业是否涉及专精特新
    ,loanusage varchar2(64) -- 贷款用途
    ,brwercorpoperscope varchar2(200) -- 企业经营范围
    ,enterstartdate date -- 企业经营有效期起始日
    ,enterenddate date -- 企业经营有效期到期日
    ,setupdate date -- 企业成立日期
    ,massage varchar2(200) -- 拒绝原因
    ,isrelateent varchar2(64) -- 是否关联企业
    ,isgarden varchar2(64) -- 是否园区贷
    ,informflag varchar2(4) -- 终审通知成功与否
    ,completeflag varchar2(2) -- 数据完善标志；码值为CompleteFlag
    ,channlefrom varchar2(2) -- 线上线下标志：1线下，2线上
    ,customerid varchar2(64) -- 客户编号
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
grant select on ${iol_schema}.icms_xked_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_xked_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_xked_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_xked_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_xked_iqp_loan_app is '兴科e贷-终审';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.prdcode is '产品编号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.prdname is '产品名称';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.channel is '接入渠道';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.termmonth is '贷款期限';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.loadamount is '申请金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.inputid is '客户经理号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.dwellareacode is '额度是否循环';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.dwelladdress is '主担保方式';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.taxstrdate is '产品分类标志';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.entidttp is '企业身份标识类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.entidtno is '企业身份标识号码';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.businessscope is '经营地址所属省';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.validitedate is '经营地址所属市';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.registerarea is '经营地址所属县（区）';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.registeraddress is '经营详细地址';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.sciencetechenttype is '科创企业类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.actualcontrollerempyears is '实控人从业年限（年）';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.flowannualsalesrevenue is '流水推算的年销售收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.entsolftcopyrightregnum is '企业软著登记公告次数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.entknowledgepropnum is '企业知识产权数量';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.knowledgepropinventnum is '知识产权发明数量';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.intefcircuitlayoutdesignappnum is '集成电路布图设计申请数量';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.knowledgepropinfrinpunishnum is '知识产权侵权处罚次数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.knowledgepropunfaircompenum is '知识产权不正当竞争次数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.knowledgepropjudgdocdefentnum is '知识产权裁判文书被告次数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past24mupstreamtop5purchamt is '近24个月上游前5大采购金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past24mupstreamintegpurchamt is '近24个月上游整体采购金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past24mdownstreamtop5saleamt is '近24个月下游前5大销售金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past24mdownstreamintegsaleamt is '近24个月下游整体销售金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past12mispartnertop10transamt is '近12个月重要稳定供应商（前十）交易金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past12miscusttop10transamt is '近12个月重要稳定客户（前十）交易金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.past24minvoicrevenue is '近24个月开票收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualhightechproincome is '本年度高新技术产品（服务）收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.preyearhightechproincome is '上年度高新技术产品（服务）收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualoperaincome is '本年度营业收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualempsnum is '本年度从业人数（人）';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.preyearempsnum is '上年度从业人数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualtechninum is '本年度科技人员人数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.preyeartechninum is '上年度科技人员人数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualresearchdevamt is '本年度研发费用金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.preyearresearchdevamt is '上年度研发费用金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.annualentgetgovsusidy is '本年度企业获取政府补贴收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.preyearentgetgovsusidy is '上年度企业获取政府补贴收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.forecastnextyearsale is '预测次年销售量';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.otherchannelworkcapit is '其他渠道提供的运营资金';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.nocrediteachdebtaccubalance is '未在征信报告中体现的各类负债';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.nocreditmonthaccurepaydebt is '未在征信报告中体现的各类负债月还款额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.entmonthrepaybalance is '企业月还款额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.ispledgedreceiveaccount is '企业应收账款是否质押';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.pledgereceiveamt is '应收账款质押贷款金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.isknowledgepledged is '知识产权是否质押';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.knowledgepledgereceiveamt is '知识产权质押贷款金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.isstockpledged is '股权是否质押';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.stockpledgedamt is '股权质押贷款金额';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.qryusertype is '征信查询人类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.qryopertp is '征信查询操作申请类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.partner is '系统来源';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.reportusernm is '报告使用人姓名';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.reportuseroff is '报告使用人所属部门';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.authotype is '授权方式';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.authotime is '授权时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.custname is '法人代表人姓名';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.sex is '法人代表人性别';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.nation is '法人代表人国籍';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.idtype is '法人代表人证件类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.idno is '法人代表人身份证号码';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.inputuserid is '登记人';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.inputdate is '登记日期';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.updateuserid is '更新人';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.updatedate is '更新时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.finalapplyamount is '终审额度';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.transstatus is '流程状态';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.status is '任务状态';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.branchid is '所属分行';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.isbankrel is '是否我行关联人';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.autoscore is '评分卡得分';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.apprendtime is '营业日期';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.risknote is '备注';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.riskwarm is '预警';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.tradecode is '行业类型';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.empcountyear is '从业人数';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.tatalasset is '资产合计';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.proceeds is '营业收入';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.scale is '企业规模';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.bizscope is '经营范围';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.registerdaddress is '企业注册地址';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.enttermduedate is '企业营业期限到期日';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.bano is '授信申请编号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.taxqueryflag is '税务查询标志';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.taxauthorizeno is '税务授权流水号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.taxpayeridentityno is '纳税人识别号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.istaxsuccessgs is '广税授权是否成功';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.idexpirydate is '企业证件到期日';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.loanendtime is '终审结束时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.loanstarttime is '终审申请时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.opercorpflg is '经营企业是否涉及专精特新';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.loanusage is '贷款用途';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.brwercorpoperscope is '企业经营范围';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.enterstartdate is '企业经营有效期起始日';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.enterenddate is '企业经营有效期到期日';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.setupdate is '企业成立日期';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.massage is '拒绝原因';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.isrelateent is '是否关联企业';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.isgarden is '是否园区贷';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.informflag is '终审通知成功与否';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.completeflag is '数据完善标志；码值为CompleteFlag';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.channlefrom is '线上线下标志：1线下，2线上';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.customerid is '客户编号';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_xked_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
