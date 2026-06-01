/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hqd_iqp_loan_prior
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hqd_iqp_loan_prior
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hqd_iqp_loan_prior purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hqd_iqp_loan_prior(
    serialno varchar2(33) -- 业务流水号
    ,applyno varchar2(32) -- 信贷申请流水号
    ,prdcode varchar2(32) -- 产品编号
    ,prdname varchar2(200) -- 产品名称
    ,cusid varchar2(32) -- 法人代表人客户号
    ,cusname varchar2(100) -- 法人代表人姓名
    ,finalapplyamount number(24,6) -- 初审审批额度(元)
    ,inputdate date -- 初审申请日期
    ,approvestatus varchar2(20) -- 审批状态
    ,inputid varchar2(20) -- 客户经理编号
    ,belongdept varchar2(50) -- 所属分行名称
    ,appchannel varchar2(20) -- 接入渠道
    ,birth date -- 法人代表人出生日期
    ,certtype varchar2(4) -- 法人代表人证件类型
    ,certno varchar2(20) -- 法人代表人证件号码
    ,gender varchar2(5) -- 法人代表人性别
    ,phone varchar2(35) -- 法人代表人联系号码
    ,issdate date -- 签发日期
    ,expirydate date -- 借款人证件到期日
    ,dwellprovincecode varchar2(30) -- 居住地址所在省份编码
    ,dwellcitycode varchar2(80) -- 居住地址所在城市编码
    ,dwellareacode varchar2(30) -- 居住地址所在区域编码
    ,dwelladdress varchar2(200) -- 居住详细地址
    ,career varchar2(10) -- 职业
    ,nationality varchar2(200) -- 国籍
    ,entname varchar2(200) -- 企业名称
    ,creditcode varchar2(30) -- 统一社会信用代码
    ,taxno varchar2(20) -- 纳税人识别号
    ,taxflag varchar2(2) -- 税务查询标志(深圳/广东税务局)
    ,applyflag varchar2(2) -- 是否授权
    ,taxapplyno varchar2(50) -- 税务查询授权流水号
    ,productchannel varchar2(20) -- 产品分类标志
    ,attribute1 varchar2(100) -- 备用字段1
    ,attribute2 varchar2(100) -- 备用字段2
    ,attribute3 varchar2(100) -- 备用字段3
    ,attribute4 varchar2(100) -- 备用字段4
    ,attribute5 varchar2(100) -- 备用字段5
    ,sysid varchar2(10) -- 系统来源
    ,qryopertp varchar2(2) -- 查询操作申请类型
    ,authotype varchar2(52) -- 授权方式
    ,biometrics varchar2(2) -- 生物识别技术
    ,authotime varchar2(50) -- 授权时间
    ,authostrdate date -- 授权开始时间
    ,authoenddate date -- 授权结束时间
    ,warninginfo varchar2(4000) -- 预警信息
    ,failreason varchar2(4000) -- 拒绝原因
    ,businessscope varchar2(3000) -- 经营范围
    ,businessvalidity varchar2(200) -- 经营有效期（区间）
    ,registeredaddress varchar2(200) -- 注册地址
    ,issmallent varchar2(2) -- 是否小微企业
    ,inputorgid varchar2(20) -- 登记机构
    ,nextyearincome number(24,2) -- 预测次年销售收入
    ,otherincome number(24,2) -- 其他渠道提供的营运资金
    ,informflag varchar2(2) -- 是否通知
    ,applyenddate date -- 初审结束日期
    ,registerdate varchar2(100) -- 企业注册时间
    ,entmouthprice varchar2(100) -- 每月租金金额
    ,entmouth varchar2(20) -- 企业入驻月份数
    ,scale varchar2(20) -- 企业规模
    ,proceeds number(24,2) -- 经营收入
    ,autoscore varchar2(5) -- 评分分值
    ,gongancheckresult varchar2(10) -- 公安联网核查结果
    ,mybankaffiliateflag varchar2(2) -- 是否我行关联人
    ,zhengxincheckresult varchar2(10) -- 征信校验结果
    ,baserialno varchar2(64) -- 授信表流水号
    ,status varchar2(2) -- 初审状态
    ,tradecode varchar2(32) -- 行业类型
    ,empcountyear number(28,2) -- 从业人数
    ,tatalasset number(28,2) -- 资产合计
    ,enreportimage varchar2(2000) -- 风控企业影像编号
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
grant select on ${iol_schema}.icms_hqd_iqp_loan_prior to ${iml_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_prior to ${icl_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_prior to ${idl_schema};
grant select on ${iol_schema}.icms_hqd_iqp_loan_prior to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hqd_iqp_loan_prior is '好企贷-初审';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.serialno is '业务流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.applyno is '信贷申请流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.prdcode is '产品编号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.prdname is '产品名称';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.cusid is '法人代表人客户号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.cusname is '法人代表人姓名';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.finalapplyamount is '初审审批额度(元)';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.inputdate is '初审申请日期';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.inputid is '客户经理编号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.belongdept is '所属分行名称';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.appchannel is '接入渠道';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.birth is '法人代表人出生日期';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.certtype is '法人代表人证件类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.certno is '法人代表人证件号码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.gender is '法人代表人性别';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.phone is '法人代表人联系号码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.issdate is '签发日期';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.expirydate is '借款人证件到期日';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.dwellprovincecode is '居住地址所在省份编码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.dwellcitycode is '居住地址所在城市编码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.dwellareacode is '居住地址所在区域编码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.dwelladdress is '居住详细地址';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.career is '职业';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.nationality is '国籍';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.entname is '企业名称';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.creditcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.taxno is '纳税人识别号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.taxflag is '税务查询标志(深圳/广东税务局)';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.applyflag is '是否授权';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.taxapplyno is '税务查询授权流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.productchannel is '产品分类标志';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.attribute1 is '备用字段1';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.attribute2 is '备用字段2';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.attribute3 is '备用字段3';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.attribute4 is '备用字段4';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.attribute5 is '备用字段5';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.sysid is '系统来源';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.qryopertp is '查询操作申请类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.authotype is '授权方式';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.authotime is '授权时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.failreason is '拒绝原因';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.businessscope is '经营范围';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.businessvalidity is '经营有效期（区间）';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.registeredaddress is '注册地址';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.issmallent is '是否小微企业';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.nextyearincome is '预测次年销售收入';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.otherincome is '其他渠道提供的营运资金';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.informflag is '是否通知';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.applyenddate is '初审结束日期';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.registerdate is '企业注册时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.entmouthprice is '每月租金金额';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.entmouth is '企业入驻月份数';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.scale is '企业规模';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.proceeds is '经营收入';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.autoscore is '评分分值';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.gongancheckresult is '公安联网核查结果';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.mybankaffiliateflag is '是否我行关联人';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.zhengxincheckresult is '征信校验结果';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.baserialno is '授信表流水号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.status is '初审状态';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.tradecode is '行业类型';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.empcountyear is '从业人数';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.tatalasset is '资产合计';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.enreportimage is '风控企业影像编号';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.start_dt is '开始时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.end_dt is '结束时间';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.id_mark is '增删标志';
comment on column ${iol_schema}.icms_hqd_iqp_loan_prior.etl_timestamp is 'ETL处理时间戳';
