/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_business_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_apply(
    serialno varchar2(32) -- 流水号
    ,lhdreqid varchar2(64) -- 联合贷请求ID
    ,zdreqid varchar2(64) -- 助贷请求ID
    ,accountid varchar2(64) -- 授信ID
    ,credittag varchar2(16) -- 授信请求类型
    ,approvestatus varchar2(32) -- 授信状态
    ,status varchar2(16) -- 授信状态
    ,customerid varchar2(16) -- 客户号
    ,name varchar2(200) -- 姓名
    ,idnumber varchar2(128) -- 身份证
    ,phone varchar2(64) -- 手机号
    ,gender varchar2(12) -- 性别
    ,nation varchar2(32) -- 国籍
    ,productmode varchar2(16) -- 产品类别
    ,homephone varchar2(64) -- 家庭电话
    ,address varchar2(512) -- 居住地址
    ,birthday date -- 生日
    ,creditamount number(24,6) -- 授信额度
    ,dailyrate number(20,6) -- 授信日利率
    ,annualrate number(20,6) -- 授信年利率
    ,idcardaddress varchar2(512) -- 身份证上的地址信息
    ,idcardstartdate varchar2(32) -- 身份证有效期开始时间
    ,idcardenddate varchar2(32) -- 身份证有效期结束时间
    ,idcardethnicity varchar2(32) -- 民族
    ,idcardauthority varchar2(200) -- 签发机关
    ,careerindustry varchar2(16) -- 现单位/经营主体所属行业
    ,cardid varchar2(32) -- 银行卡号
    ,bankname varchar2(64) -- 银行名称
    ,bankphone varchar2(64) -- 银行预留手机号
    ,enterprisename varchar2(256) -- 企业名称或者法人名称
    ,uniformsocialcreditcode varchar2(64) -- 社会信用代码
    ,businesslicense varchar2(64) -- 营业执照号
    ,customertype varchar2(16) -- 客户属性
    ,companyindustry varchar2(64) -- 所属行业类型
    ,ifexeshare varchar2(16) -- 是否董监高
    ,xwlabel varchar2(2048) -- 小微标签
    ,riskstatus varchar2(32) -- 风控结果
    ,failreason varchar2(2048) -- 风控拒绝原因
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,businessflag varchar2(10) -- 业务类型
    ,loanid varchar2(64) -- 借款流水号
    ,appliedamount number(24,6) -- 实际额度
    ,availableamount number(24,6) -- 可用额度
    ,loanamount number(24,6) -- 借款总金额
    ,bankamount number(24,6) -- 联合行金额
    ,period varchar2(32) -- 分期数
    ,repaytype varchar2(16) -- 计息方式
    ,usage varchar2(32) -- 借款用途
    ,currency varchar2(16) -- 币种
    ,orderdailyrate number(20,6) -- 日利率
    ,orderannualrate number(20,6) -- 年利率
    ,capitalsetno varchar2(32) -- 资金码
    ,riskcreditamount number(24,6) -- 风控授信额度
    ,riskintrate number(20,6) -- 风控利息年利率
    ,certtype varchar2(32) -- 证件类型
    ,productid varchar2(32) -- 产品编号
    ,riskreqtime date -- 风控回调时间
    ,creditchannel varchar2(60) -- 授信渠道
    ,contractno varchar2(32) -- 额度合同号
    ,failcode varchar2(200) -- 风控拒绝码
    ,effectdate date -- 有效到期日
    ,intraindustrytype varchar2(20) -- 投向行业
    ,industrysource varchar2(20) -- 所属行业数据来源
    ,totalassets varchar2(50) -- 资产总额
    ,operatingrevenue varchar2(50) -- 营业收入
    ,colleguesnum varchar2(50) -- 从业人数
    ,enterprisescale varchar2(50) -- 企业规模
    ,locationinfo varchar2(1024) -- 客户位置信息
    ,repayday varchar2(16) -- 每月还款日
    ,reserveinfo varchar2(2048) -- 征信预留字段
    ,rdriskstatus varchar2(32) -- 融担风控结果
    ,rdfailcode varchar2(200) -- 融担风控拒绝码
    ,rdfailreason varchar2(2048) -- 融担风控拒绝原因
    ,rdriskreqtime date -- 融担回调时间
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
grant select on ${iol_schema}.icms_zjbk_business_apply to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_business_apply to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_business_apply to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_business_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_business_apply is '字节授信申请表';
comment on column ${iol_schema}.icms_zjbk_business_apply.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_business_apply.lhdreqid is '联合贷请求ID';
comment on column ${iol_schema}.icms_zjbk_business_apply.zdreqid is '助贷请求ID';
comment on column ${iol_schema}.icms_zjbk_business_apply.accountid is '授信ID';
comment on column ${iol_schema}.icms_zjbk_business_apply.credittag is '授信请求类型';
comment on column ${iol_schema}.icms_zjbk_business_apply.approvestatus is '授信状态';
comment on column ${iol_schema}.icms_zjbk_business_apply.status is '授信状态';
comment on column ${iol_schema}.icms_zjbk_business_apply.customerid is '客户号';
comment on column ${iol_schema}.icms_zjbk_business_apply.name is '姓名';
comment on column ${iol_schema}.icms_zjbk_business_apply.idnumber is '身份证';
comment on column ${iol_schema}.icms_zjbk_business_apply.phone is '手机号';
comment on column ${iol_schema}.icms_zjbk_business_apply.gender is '性别';
comment on column ${iol_schema}.icms_zjbk_business_apply.nation is '国籍';
comment on column ${iol_schema}.icms_zjbk_business_apply.productmode is '产品类别';
comment on column ${iol_schema}.icms_zjbk_business_apply.homephone is '家庭电话';
comment on column ${iol_schema}.icms_zjbk_business_apply.address is '居住地址';
comment on column ${iol_schema}.icms_zjbk_business_apply.birthday is '生日';
comment on column ${iol_schema}.icms_zjbk_business_apply.creditamount is '授信额度';
comment on column ${iol_schema}.icms_zjbk_business_apply.dailyrate is '授信日利率';
comment on column ${iol_schema}.icms_zjbk_business_apply.annualrate is '授信年利率';
comment on column ${iol_schema}.icms_zjbk_business_apply.idcardaddress is '身份证上的地址信息';
comment on column ${iol_schema}.icms_zjbk_business_apply.idcardstartdate is '身份证有效期开始时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.idcardenddate is '身份证有效期结束时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.idcardethnicity is '民族';
comment on column ${iol_schema}.icms_zjbk_business_apply.idcardauthority is '签发机关';
comment on column ${iol_schema}.icms_zjbk_business_apply.careerindustry is '现单位/经营主体所属行业';
comment on column ${iol_schema}.icms_zjbk_business_apply.cardid is '银行卡号';
comment on column ${iol_schema}.icms_zjbk_business_apply.bankname is '银行名称';
comment on column ${iol_schema}.icms_zjbk_business_apply.bankphone is '银行预留手机号';
comment on column ${iol_schema}.icms_zjbk_business_apply.enterprisename is '企业名称或者法人名称';
comment on column ${iol_schema}.icms_zjbk_business_apply.uniformsocialcreditcode is '社会信用代码';
comment on column ${iol_schema}.icms_zjbk_business_apply.businesslicense is '营业执照号';
comment on column ${iol_schema}.icms_zjbk_business_apply.customertype is '客户属性';
comment on column ${iol_schema}.icms_zjbk_business_apply.companyindustry is '所属行业类型';
comment on column ${iol_schema}.icms_zjbk_business_apply.ifexeshare is '是否董监高';
comment on column ${iol_schema}.icms_zjbk_business_apply.xwlabel is '小微标签';
comment on column ${iol_schema}.icms_zjbk_business_apply.riskstatus is '风控结果';
comment on column ${iol_schema}.icms_zjbk_business_apply.failreason is '风控拒绝原因';
comment on column ${iol_schema}.icms_zjbk_business_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zjbk_business_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zjbk_business_apply.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zjbk_business_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_zjbk_business_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_zjbk_business_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_zjbk_business_apply.businessflag is '业务类型';
comment on column ${iol_schema}.icms_zjbk_business_apply.loanid is '借款流水号';
comment on column ${iol_schema}.icms_zjbk_business_apply.appliedamount is '实际额度';
comment on column ${iol_schema}.icms_zjbk_business_apply.availableamount is '可用额度';
comment on column ${iol_schema}.icms_zjbk_business_apply.loanamount is '借款总金额';
comment on column ${iol_schema}.icms_zjbk_business_apply.bankamount is '联合行金额';
comment on column ${iol_schema}.icms_zjbk_business_apply.period is '分期数';
comment on column ${iol_schema}.icms_zjbk_business_apply.repaytype is '计息方式';
comment on column ${iol_schema}.icms_zjbk_business_apply.usage is '借款用途';
comment on column ${iol_schema}.icms_zjbk_business_apply.currency is '币种';
comment on column ${iol_schema}.icms_zjbk_business_apply.orderdailyrate is '日利率';
comment on column ${iol_schema}.icms_zjbk_business_apply.orderannualrate is '年利率';
comment on column ${iol_schema}.icms_zjbk_business_apply.capitalsetno is '资金码';
comment on column ${iol_schema}.icms_zjbk_business_apply.riskcreditamount is '风控授信额度';
comment on column ${iol_schema}.icms_zjbk_business_apply.riskintrate is '风控利息年利率';
comment on column ${iol_schema}.icms_zjbk_business_apply.certtype is '证件类型';
comment on column ${iol_schema}.icms_zjbk_business_apply.productid is '产品编号';
comment on column ${iol_schema}.icms_zjbk_business_apply.riskreqtime is '风控回调时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_zjbk_business_apply.contractno is '额度合同号';
comment on column ${iol_schema}.icms_zjbk_business_apply.failcode is '风控拒绝码';
comment on column ${iol_schema}.icms_zjbk_business_apply.effectdate is '有效到期日';
comment on column ${iol_schema}.icms_zjbk_business_apply.intraindustrytype is '投向行业';
comment on column ${iol_schema}.icms_zjbk_business_apply.industrysource is '所属行业数据来源';
comment on column ${iol_schema}.icms_zjbk_business_apply.totalassets is '资产总额';
comment on column ${iol_schema}.icms_zjbk_business_apply.operatingrevenue is '营业收入';
comment on column ${iol_schema}.icms_zjbk_business_apply.colleguesnum is '从业人数';
comment on column ${iol_schema}.icms_zjbk_business_apply.enterprisescale is '企业规模';
comment on column ${iol_schema}.icms_zjbk_business_apply.locationinfo is '客户位置信息';
comment on column ${iol_schema}.icms_zjbk_business_apply.repayday is '每月还款日';
comment on column ${iol_schema}.icms_zjbk_business_apply.reserveinfo is '征信预留字段';
comment on column ${iol_schema}.icms_zjbk_business_apply.rdriskstatus is '融担风控结果';
comment on column ${iol_schema}.icms_zjbk_business_apply.rdfailcode is '融担风控拒绝码';
comment on column ${iol_schema}.icms_zjbk_business_apply.rdfailreason is '融担风控拒绝原因';
comment on column ${iol_schema}.icms_zjbk_business_apply.rdriskreqtime is '融担回调时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_business_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_business_apply.etl_timestamp is 'ETL处理时间戳';
