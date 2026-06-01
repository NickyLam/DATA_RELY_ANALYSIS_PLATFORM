/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hqd_iqp_loan_app
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hqd_iqp_loan_app
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hqd_iqp_loan_app purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hqd_iqp_loan_app(
    serialno varchar2(33) -- 业务流水号
    ,applyno varchar2(32) -- 信贷申请流水号
    ,prdcode varchar2(32) -- 业务品种
    ,applyamt number(24,6) -- 申请金额
    ,termmonth number(22) -- 贷款期限
    ,appchannel varchar2(20) -- 接入渠道
    ,channelno varchar2(20) -- 产品分类标志（渠道号）
    ,inputuserid varchar2(8) -- 客户经理号
    ,inputorgid varchar2(12) -- 客户经理所属机构
    ,inputdate date -- 终审申请日期
    ,approvestatus varchar2(20) -- 终审审批状态
    ,entlegalercusid varchar2(32) -- 法人代表人客户号
    ,entcusid varchar2(32) -- 企业客户号
    ,enterprisename varchar2(500) -- 企业名称
    ,enterprisecerttype varchar2(4) -- 企业身份标识类型
    ,enterprisecertid varchar2(100) -- 企业身份标识号码
    ,registerprov varchar2(100) -- 经营地址所属省
    ,registercity varchar2(100) -- 经营地址所属市
    ,registerarea varchar2(100) -- 经营地址所属县（区）
    ,registeraddress varchar2(500) -- 注册详细地址
    ,warninginfo varchar2(4000) -- 预警信息
    ,failreason varchar2(4000) -- 拒绝原因
    ,finalapplyamount number(24,6) -- 终审审批额度(元)
    ,informflag varchar2(4) -- 终审通知成功与否
    ,managerquest varchar2(2000) -- 客户经理意见
    ,isrelateent varchar2(4) -- 是否关联企业
    ,iscycle varchar2(4) -- 额度是否循环
    ,vouchtype varchar2(8) -- 主担保方式
    ,annualempsnum number(24,6) -- 本年度从业人数（人）
    ,actualcontrollerempyears number(24,6) -- 实控人从业年限（年）
    ,flowannualsalesrevenue number(24,6) -- 流水推算的年销售收入
    ,predictsalerevenueflowyear number(24,6) -- 预测次年销售收入
    ,otherchannelworkcapit number(24,6) -- 其他渠道提供的营运资金
    ,nocrediteachdebtaccubalance number(24,6) -- 未在征信报告中体现的各类负债余额
    ,nocreditmonthaccurepaydebt number(24,6) -- 征信中未体现的各类负债月还款额
    ,entmonthrepaybalance number(24,6) -- 企业月还款额
    ,ispledgedreceiveaccount varchar2(4) -- 企业应收账款是否质押
    ,pledgereceiveamt number(24,6) -- 应收账款质押贷款金额
    ,knowagepledgereceiveamt number(24,6) -- 知识产权质押贷款金额
    ,isstockpledged varchar2(4) -- 股权是否质押
    ,stockpledgedamt number(24,6) -- 股权质押贷款金额
    ,lmtserno varchar2(32) -- 额度合同编号
    ,sysid varchar2(10) -- 系统来源
    ,qryopertp varchar2(2) -- 查询操作申请类型
    ,authotype varchar2(2) -- 授权方式
    ,biometrics varchar2(2) -- 生物识别技术
    ,authotime varchar2(20) -- 授权时间
    ,authostrdate date -- 授权开始时间
    ,authoenddate date -- 授权结束时间
    ,updateuserid varchar2(8) -- 更新客户经理号
    ,updateorgid varchar2(12) -- 更新客户经理所属机构
    ,updatedate date -- 更新时间
    ,belongorgid varchar2(12) -- 所属分行
    ,zsapplyenddate date -- 终审结束时间
    ,tradecode varchar2(18) -- 行业类型
    ,empcountyear number(22) -- 从业人数
    ,tatalasset number(24,6) -- 资产合计
    ,proceeds number(24,6) -- 营业收入
    ,scale varchar2(10) -- 企业规模
    ,bano varchar2(64) -- 授信流水号
    ,idexpirydate date -- 企业证件到期日
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
grant select on ${iol_schema}.icms_hqd_iqp_loan_app to ${iml_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_app to ${icl_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_app to ${idl_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_app to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hqd_iqp_loan_app is '好企贷-终审';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.serialno is '业务流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.prdcode is '业务品种';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.applyamt is '申请金额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.termmonth is '贷款期限';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.appchannel is '接入渠道';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.channelno is '产品分类标志（渠道号）';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.inputuserid is '客户经理号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.inputorgid is '客户经理所属机构';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.inputdate is '终审申请日期';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.approvestatus is '终审审批状态';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.entlegalercusid is '法人代表人客户号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.entcusid is '企业客户号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.enterprisename is '企业名称';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.enterprisecerttype is '企业身份标识类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.enterprisecertid is '企业身份标识号码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.registerprov is '经营地址所属省';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.registercity is '经营地址所属市';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.registerarea is '经营地址所属县（区）';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.registeraddress is '注册详细地址';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.finalapplyamount is '终审审批额度(元)';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.informflag is '终审通知成功与否';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.managerquest is '客户经理意见';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.isrelateent is '是否关联企业';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.iscycle is '额度是否循环';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.vouchtype is '主担保方式';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.annualempsnum is '本年度从业人数（人）';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.actualcontrollerempyears is '实控人从业年限（年）';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.flowannualsalesrevenue is '流水推算的年销售收入';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.predictsalerevenueflowyear is '预测次年销售收入';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.otherchannelworkcapit is '其他渠道提供的营运资金';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.nocrediteachdebtaccubalance is '未在征信报告中体现的各类负债余额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.nocreditmonthaccurepaydebt is '征信中未体现的各类负债月还款额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.entmonthrepaybalance is '企业月还款额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.ispledgedreceiveaccount is '企业应收账款是否质押';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.pledgereceiveamt is '应收账款质押贷款金额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.knowagepledgereceiveamt is '知识产权质押贷款金额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.isstockpledged is '股权是否质押';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.stockpledgedamt is '股权质押贷款金额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.lmtserno is '额度合同编号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.sysid is '系统来源';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.qryopertp is '查询操作申请类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.authotype is '授权方式';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.authotime is '授权时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.updateuserid is '更新客户经理号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.updateorgid is '更新客户经理所属机构';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.updatedate is '更新时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.belongorgid is '所属分行';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.zsapplyenddate is '终审结束时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.tradecode is '行业类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.empcountyear is '从业人数';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.tatalasset is '资产合计';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.proceeds is '营业收入';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.scale is '企业规模';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.bano is '授信流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.idexpirydate is '企业证件到期日';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.start_dt is '开始时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.end_dt is '结束时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.id_mark is '增删标志';
comment on column ${iol_schema}.icms_hqd_iqp_loan_app.etl_timestamp is 'ETL处理时间戳';
