/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_one_click_input
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_one_click_input
whenever sqlerror continue none;
drop table ${iol_schema}.icms_one_click_input purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_one_click_input(
    serialno varchar2(64) -- 申请编号
    ,occurdate date -- 申请日期
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(100) -- 客户名称
    ,certid varchar2(18) -- 证件号码
    ,certstartdate varchar2(10) -- 证件起始日
    ,certenddate varchar2(10) -- 证件到期日
    ,certtype varchar2(4) -- 证件类型
    ,phone varchar2(11) -- 联系电话（短信通知）
    ,city varchar2(20) -- 地址所属市/县
    ,nativeadd varchar2(400) -- 地址详情（经常居住）
    ,occupation varchar2(20) -- 职业
    ,occupationshow varchar2(100) -- 职业说明
    ,sex varchar2(6) -- 性别
    ,nation varchar2(20) -- 国籍
    ,birthday varchar2(10) -- 出生日期
    ,userid varchar2(16) -- 客户经理编号
    ,username varchar2(20) -- 客户经理名称
    ,productid varchar2(32) -- 产品编号
    ,loanapplamt varchar2(20) -- 贷款申请金额
    ,loanapplyterm varchar2(10) -- 贷款申请期限
    ,inputorgid varchar2(64) -- 归属分行
    ,ifcreditfactory varchar2(2) -- 是否信贷工厂模式
    ,qryusertype varchar2(2) -- 征信查询人类型
    ,qryopertp varchar2(2) -- 征信查询操作申请类型
    ,partner varchar2(10) -- 客户来源
    ,reportusernm varchar2(100) -- 报告使用人姓名
    ,reportuseroff varchar2(20) -- 报告使用人所属部门
    ,authotype varchar2(2) -- 授权方式
    ,biometrics varchar2(2) -- 生物识别技术
    ,authotime varchar2(20) -- 授权时间
    ,authostrdate varchar2(20) -- 授权开始时间
    ,authoenddate varchar2(20) -- 授权结束时间
    ,inputdate date -- 登记时间
    ,approvestatus varchar2(20) -- 审批状态
    ,creditscorelevel varchar2(4) -- 评分等级
    ,applyno varchar2(64) -- 申请流水号
    ,baserialno varchar2(64) -- 业务流水号
    ,baserialno1 varchar2(64) -- 额度申请流水号
    ,household varchar2(20) -- 住房情况
    ,autoscore varchar2(10) -- 评分卡分数
    ,failreason varchar2(4000) -- 备注信息
    ,warninginfo varchar2(4000) -- 预警信息
    ,channel varchar2(32) -- 渠道
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 修改人
    ,updateorgid varchar2(64) -- 修改人机构
    ,loantype varchar2(1) -- 贷款类型（0:经营;1:消费）
    ,biztime varchar2(20) -- 客户进件时间
    ,creditauthotime varchar2(20) -- 征信授权时间
    ,pfktype varchar2(1) -- 评分卡类型（0:经营;1:消费）
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_one_click_input to ${iml_schema};
grant select on ${iol_schema}.icms_one_click_input to ${icl_schema};
grant select on ${iol_schema}.icms_one_click_input to ${idl_schema};
grant select on ${iol_schema}.icms_one_click_input to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_one_click_input is '信贷工厂一键进件';
comment on column ${iol_schema}.icms_one_click_input.serialno is '申请编号';
comment on column ${iol_schema}.icms_one_click_input.occurdate is '申请日期';
comment on column ${iol_schema}.icms_one_click_input.customerid is '客户编号';
comment on column ${iol_schema}.icms_one_click_input.customername is '客户名称';
comment on column ${iol_schema}.icms_one_click_input.certid is '证件号码';
comment on column ${iol_schema}.icms_one_click_input.certstartdate is '证件起始日';
comment on column ${iol_schema}.icms_one_click_input.certenddate is '证件到期日';
comment on column ${iol_schema}.icms_one_click_input.certtype is '证件类型';
comment on column ${iol_schema}.icms_one_click_input.phone is '联系电话（短信通知）';
comment on column ${iol_schema}.icms_one_click_input.city is '地址所属市/县';
comment on column ${iol_schema}.icms_one_click_input.nativeadd is '地址详情（经常居住）';
comment on column ${iol_schema}.icms_one_click_input.occupation is '职业';
comment on column ${iol_schema}.icms_one_click_input.occupationshow is '职业说明';
comment on column ${iol_schema}.icms_one_click_input.sex is '性别';
comment on column ${iol_schema}.icms_one_click_input.nation is '国籍';
comment on column ${iol_schema}.icms_one_click_input.birthday is '出生日期';
comment on column ${iol_schema}.icms_one_click_input.userid is '客户经理编号';
comment on column ${iol_schema}.icms_one_click_input.username is '客户经理名称';
comment on column ${iol_schema}.icms_one_click_input.productid is '产品编号';
comment on column ${iol_schema}.icms_one_click_input.loanapplamt is '贷款申请金额';
comment on column ${iol_schema}.icms_one_click_input.loanapplyterm is '贷款申请期限';
comment on column ${iol_schema}.icms_one_click_input.inputorgid is '归属分行';
comment on column ${iol_schema}.icms_one_click_input.ifcreditfactory is '是否信贷工厂模式';
comment on column ${iol_schema}.icms_one_click_input.qryusertype is '征信查询人类型';
comment on column ${iol_schema}.icms_one_click_input.qryopertp is '征信查询操作申请类型';
comment on column ${iol_schema}.icms_one_click_input.partner is '客户来源';
comment on column ${iol_schema}.icms_one_click_input.reportusernm is '报告使用人姓名';
comment on column ${iol_schema}.icms_one_click_input.reportuseroff is '报告使用人所属部门';
comment on column ${iol_schema}.icms_one_click_input.authotype is '授权方式';
comment on column ${iol_schema}.icms_one_click_input.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_one_click_input.authotime is '授权时间';
comment on column ${iol_schema}.icms_one_click_input.authostrdate is '授权开始时间';
comment on column ${iol_schema}.icms_one_click_input.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_one_click_input.inputdate is '登记时间';
comment on column ${iol_schema}.icms_one_click_input.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_one_click_input.creditscorelevel is '评分等级';
comment on column ${iol_schema}.icms_one_click_input.applyno is '申请流水号';
comment on column ${iol_schema}.icms_one_click_input.baserialno is '业务流水号';
comment on column ${iol_schema}.icms_one_click_input.baserialno1 is '额度申请流水号';
comment on column ${iol_schema}.icms_one_click_input.household is '住房情况';
comment on column ${iol_schema}.icms_one_click_input.autoscore is '评分卡分数';
comment on column ${iol_schema}.icms_one_click_input.failreason is '备注信息';
comment on column ${iol_schema}.icms_one_click_input.warninginfo is '预警信息';
comment on column ${iol_schema}.icms_one_click_input.channel is '渠道';
comment on column ${iol_schema}.icms_one_click_input.inputuserid is '登记人';
comment on column ${iol_schema}.icms_one_click_input.updateuserid is '修改人';
comment on column ${iol_schema}.icms_one_click_input.updateorgid is '修改人机构';
comment on column ${iol_schema}.icms_one_click_input.loantype is '贷款类型（0:经营;1:消费）';
comment on column ${iol_schema}.icms_one_click_input.biztime is '客户进件时间';
comment on column ${iol_schema}.icms_one_click_input.creditauthotime is '征信授权时间';
comment on column ${iol_schema}.icms_one_click_input.pfktype is '评分卡类型（0:经营;1:消费）';
comment on column ${iol_schema}.icms_one_click_input.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_one_click_input.etl_timestamp is 'ETL处理时间戳';
