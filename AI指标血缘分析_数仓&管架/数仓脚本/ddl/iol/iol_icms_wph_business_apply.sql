/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wph_business_apply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wph_business_apply
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wph_business_apply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_business_apply(
    tenantid varchar2(4) -- 租户ID
    ,userid varchar2(32) -- 用户编号
    ,creditappno varchar2(32) -- 申请编号
    ,partnercode varchar2(20) -- 合作行代码
    ,productcode varchar2(20) -- 产品编号
    ,applyid varchar2(32) -- 第三方申请编号
    ,loantype varchar2(4) -- 信贷类型
    ,amounttype varchar2(4) -- 额度类型
    ,creditlimit number(18,6) -- 申请总额度
    ,creditlimitcrop number(18,6) -- 合作方承贷金额
    ,startdate varchar2(10) -- 额度起始日
    ,enddate varchar2(10) -- 额度到期日
    ,advicerate number(18,10) -- 年化利率
    ,chinesename varchar2(64) -- 客户姓名
    ,mobile varchar2(11) -- 客户手机号
    ,idtype varchar2(4) -- 证件类型
    ,idnumber varchar2(40) -- 证件号
    ,idaddress varchar2(256) -- 身份证户籍地址
    ,idissueagent varchar2(100) -- 身份证签发机构
    ,ideffectivedate varchar2(10) -- 身份证有效期起
    ,idexpiredate varchar2(10) -- 身份证有效期止
    ,birthdate varchar2(10) -- 生日
    ,nationality varchar2(3) -- 国籍
    ,race varchar2(8) -- 民族
    ,sex varchar2(1) -- 性别
    ,education varchar2(4) -- 学历
    ,maritalstatus varchar2(4) -- 婚姻状态
    ,degree varchar2(4) -- 学位
    ,income varchar2(50) -- 收入
    ,occupationtype varchar2(4) -- 就业状况
    ,occupation varchar2(5) -- 职业
    ,post varchar2(4) -- 职务
    ,title varchar2(4) -- 职称
    ,companyname varchar2(50) -- 工作单位名称
    ,companyattribute varchar2(20) -- 工作单位性质
    ,companyindustry varchar2(5) -- 工作单位所属行业
    ,companyphone varchar2(20) -- 单位电话
    ,homephone varchar2(20) -- 家庭电话
    ,businesstype varchar2(20) -- 业务类型
    ,customergroup varchar2(8) -- 客群
    ,loanuse varchar2(8) -- 贷款用途
    ,tenor varchar2(11) -- 贷款期数
    ,pdcustdata varchar2(4000) -- 风控扩展字段
    ,productid varchar2(12) -- 信贷产品编号
    ,customerid varchar2(16) -- 客户编号
    ,approvestatus varchar2(10) -- 申请状态
    ,riskstatus varchar2(32) -- 风控结果
    ,failreason varchar2(2048) -- 风控拒绝原因
    ,riskcreditamount number(24,6) -- 风控授信额度
    ,riskintrate number(20,6) -- 风控利息年利率
    ,riskreqtime date -- 风控回调时间
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新日期
    ,downloadfileflag varchar2(2) -- 影像下载成功标记
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
grant select on ${iol_schema}.icms_wph_business_apply to ${iml_schema};
grant select on ${iol_schema}.icms_wph_business_apply to ${icl_schema};
grant select on ${iol_schema}.icms_wph_business_apply to ${idl_schema};
grant select on ${iol_schema}.icms_wph_business_apply to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wph_business_apply is '唯品授信申请表';
comment on column ${iol_schema}.icms_wph_business_apply.tenantid is '租户ID';
comment on column ${iol_schema}.icms_wph_business_apply.userid is '用户编号';
comment on column ${iol_schema}.icms_wph_business_apply.creditappno is '申请编号';
comment on column ${iol_schema}.icms_wph_business_apply.partnercode is '合作行代码';
comment on column ${iol_schema}.icms_wph_business_apply.productcode is '产品编号';
comment on column ${iol_schema}.icms_wph_business_apply.applyid is '第三方申请编号';
comment on column ${iol_schema}.icms_wph_business_apply.loantype is '信贷类型';
comment on column ${iol_schema}.icms_wph_business_apply.amounttype is '额度类型';
comment on column ${iol_schema}.icms_wph_business_apply.creditlimit is '申请总额度';
comment on column ${iol_schema}.icms_wph_business_apply.creditlimitcrop is '合作方承贷金额';
comment on column ${iol_schema}.icms_wph_business_apply.startdate is '额度起始日';
comment on column ${iol_schema}.icms_wph_business_apply.enddate is '额度到期日';
comment on column ${iol_schema}.icms_wph_business_apply.advicerate is '年化利率';
comment on column ${iol_schema}.icms_wph_business_apply.chinesename is '客户姓名';
comment on column ${iol_schema}.icms_wph_business_apply.mobile is '客户手机号';
comment on column ${iol_schema}.icms_wph_business_apply.idtype is '证件类型';
comment on column ${iol_schema}.icms_wph_business_apply.idnumber is '证件号';
comment on column ${iol_schema}.icms_wph_business_apply.idaddress is '身份证户籍地址';
comment on column ${iol_schema}.icms_wph_business_apply.idissueagent is '身份证签发机构';
comment on column ${iol_schema}.icms_wph_business_apply.ideffectivedate is '身份证有效期起';
comment on column ${iol_schema}.icms_wph_business_apply.idexpiredate is '身份证有效期止';
comment on column ${iol_schema}.icms_wph_business_apply.birthdate is '生日';
comment on column ${iol_schema}.icms_wph_business_apply.nationality is '国籍';
comment on column ${iol_schema}.icms_wph_business_apply.race is '民族';
comment on column ${iol_schema}.icms_wph_business_apply.sex is '性别';
comment on column ${iol_schema}.icms_wph_business_apply.education is '学历';
comment on column ${iol_schema}.icms_wph_business_apply.maritalstatus is '婚姻状态';
comment on column ${iol_schema}.icms_wph_business_apply.degree is '学位';
comment on column ${iol_schema}.icms_wph_business_apply.income is '收入';
comment on column ${iol_schema}.icms_wph_business_apply.occupationtype is '就业状况';
comment on column ${iol_schema}.icms_wph_business_apply.occupation is '职业';
comment on column ${iol_schema}.icms_wph_business_apply.post is '职务';
comment on column ${iol_schema}.icms_wph_business_apply.title is '职称';
comment on column ${iol_schema}.icms_wph_business_apply.companyname is '工作单位名称';
comment on column ${iol_schema}.icms_wph_business_apply.companyattribute is '工作单位性质';
comment on column ${iol_schema}.icms_wph_business_apply.companyindustry is '工作单位所属行业';
comment on column ${iol_schema}.icms_wph_business_apply.companyphone is '单位电话';
comment on column ${iol_schema}.icms_wph_business_apply.homephone is '家庭电话';
comment on column ${iol_schema}.icms_wph_business_apply.businesstype is '业务类型';
comment on column ${iol_schema}.icms_wph_business_apply.customergroup is '客群';
comment on column ${iol_schema}.icms_wph_business_apply.loanuse is '贷款用途';
comment on column ${iol_schema}.icms_wph_business_apply.tenor is '贷款期数';
comment on column ${iol_schema}.icms_wph_business_apply.pdcustdata is '风控扩展字段';
comment on column ${iol_schema}.icms_wph_business_apply.productid is '信贷产品编号';
comment on column ${iol_schema}.icms_wph_business_apply.customerid is '客户编号';
comment on column ${iol_schema}.icms_wph_business_apply.approvestatus is '申请状态';
comment on column ${iol_schema}.icms_wph_business_apply.riskstatus is '风控结果';
comment on column ${iol_schema}.icms_wph_business_apply.failreason is '风控拒绝原因';
comment on column ${iol_schema}.icms_wph_business_apply.riskcreditamount is '风控授信额度';
comment on column ${iol_schema}.icms_wph_business_apply.riskintrate is '风控利息年利率';
comment on column ${iol_schema}.icms_wph_business_apply.riskreqtime is '风控回调时间';
comment on column ${iol_schema}.icms_wph_business_apply.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wph_business_apply.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_wph_business_apply.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wph_business_apply.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wph_business_apply.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wph_business_apply.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wph_business_apply.downloadfileflag is '影像下载成功标记';
comment on column ${iol_schema}.icms_wph_business_apply.start_dt is '开始时间';
comment on column ${iol_schema}.icms_wph_business_apply.end_dt is '结束时间';
comment on column ${iol_schema}.icms_wph_business_apply.id_mark is '增删标志';
comment on column ${iol_schema}.icms_wph_business_apply.etl_timestamp is 'ETL处理时间戳';
