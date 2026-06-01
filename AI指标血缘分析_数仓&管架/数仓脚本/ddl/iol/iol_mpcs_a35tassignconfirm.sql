/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a35tassignconfirm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a35tassignconfirm
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a35tassignconfirm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a35tassignconfirm(
    cobank varchar2(2) -- 合作银行 (0-平安  1-交行)
    ,custname varchar2(105) -- 客户名称
    ,idtype varchar2(6) -- 证件类型
    ,idno varchar2(48) -- 证件号码
    ,acctno varchar2(48) -- 结算账号
    ,pswd varchar2(24) -- 结算账号密码
    ,seccd varchar2(12) -- 券商代码
    ,secname varchar2(90) -- 券商名称
    ,capitalacctno varchar2(33) -- 证券资金台账号
    ,capitalpswd varchar2(24) -- 券商证券资金密码
    ,ccy varchar2(5) -- 币种
    ,custmanagerid varchar2(12) -- 客户经理号
    ,custtype varchar2(3) -- 客户类型 (00：机构 01：个人 默认“个人”)
    ,openbrcno varchar2(15) -- 开户机构 (4位的合作行机构编号)
    ,sex varchar2(2) -- 性别(0-男 1-女)
    ,secbrcno varchar2(12) -- 券商营业部编号
    ,tycustno varchar2(30) -- 同业客户号
    ,tyacctno varchar2(48) -- 同业结算账号
    ,signtm varchar2(26) -- 预指定确定时间 (统计月开户数)
    ,brcno varchar2(9) -- 机构号
    ,brcname varchar2(120) -- 机构名称
    ,confirmstatus varchar2(2) -- 签约状态
    ,rspmsg varchar2(180) -- 签约响应信息
    ,bizagtname varchar2(30) -- 经办人姓名
    ,bizagtidtype varchar2(6) -- 经办人证件类型
    ,bizagtidno varchar2(27) -- 经办人证件号码
    ,custno varchar2(48) -- 客户号
    ,reserve2 varchar2(96) -- 备用字段2
    ,reserve3 varchar2(96) -- 备用字段3
    ,issign varchar2(3) -- 是否签署(0-否，1-是)
    ,treaty_version varchar2(384) -- 签约协议书的版本号
    ,argue_dealway varchar2(3) -- 争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)
    ,treaty_source varchar2(3) -- 签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)
    ,signdate varchar2(26) -- 签署协议时间
    ,signseqno varchar2(96) -- 签署流水号
    ,sign_source varchar2(3) -- 三方存管签约来源(0-未知，1-柜面，2-其他第三方)
    ,sign_ip varchar2(192) -- 签署IP
    ,sign_mac varchar2(768) -- 签署MAC地址
    ,sign_type varchar2(768) -- 电脑或手机型号
    ,reserve4 varchar2(768) -- 备用字段4
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
grant select on ${iol_schema}.mpcs_a35tassignconfirm to ${iml_schema};
grant select on ${iol_schema}.mpcs_a35tassignconfirm to ${icl_schema};
grant select on ${iol_schema}.mpcs_a35tassignconfirm to ${idl_schema};
grant select on ${iol_schema}.mpcs_a35tassignconfirm to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a35tassignconfirm is '预指定确定流水表';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.cobank is '合作银行 (0-平安  1-交行)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.custname is '客户名称';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.acctno is '结算账号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.pswd is '结算账号密码';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.seccd is '券商代码';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.secname is '券商名称';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.capitalacctno is '证券资金台账号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.capitalpswd is '券商证券资金密码';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.ccy is '币种';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.custmanagerid is '客户经理号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.custtype is '客户类型 (00：机构 01：个人 默认“个人”)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.openbrcno is '开户机构 (4位的合作行机构编号)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.sex is '性别(0-男 1-女)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.secbrcno is '券商营业部编号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.tycustno is '同业客户号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.tyacctno is '同业结算账号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.signtm is '预指定确定时间 (统计月开户数)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.brcname is '机构名称';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.confirmstatus is '签约状态';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.rspmsg is '签约响应信息';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.bizagtname is '经办人姓名';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.bizagtidtype is '经办人证件类型';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.bizagtidno is '经办人证件号码';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.custno is '客户号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.reserve2 is '备用字段2';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.reserve3 is '备用字段3';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.issign is '是否签署(0-否，1-是)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.treaty_version is '签约协议书的版本号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.argue_dealway is '争议选择解决方式(01-深圳国际仲裁院,02-平安所在人民法院)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.treaty_source is '签约协议来源(00-待签署,02-手机银行,03-个人网银,04-柜面,05-其他)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.signdate is '签署协议时间';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.signseqno is '签署流水号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.sign_source is '三方存管签约来源(0-未知，1-柜面，2-其他第三方)';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.sign_ip is '签署IP';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.sign_mac is '签署MAC地址';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.sign_type is '电脑或手机型号';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.reserve4 is '备用字段4';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a35tassignconfirm.etl_timestamp is 'ETL处理时间戳';
