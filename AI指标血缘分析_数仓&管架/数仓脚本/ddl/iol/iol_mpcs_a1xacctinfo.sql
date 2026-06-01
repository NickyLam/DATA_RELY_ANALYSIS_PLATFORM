/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1xacctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1xacctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1xacctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1xacctinfo(
    fntdt varchar2(12) -- 渠道日期
    ,phoneno varchar2(24) -- 手机号
    ,customid varchar2(45) -- 客户ID
    ,acctno varchar2(30) -- 账号
    ,custno varchar2(24) -- 客户号
    ,issinscode varchar2(17) -- 开户行机构代码
    ,txnno varchar2(96) -- 银联开户交易流水号
    ,txntm date -- 开户日期
    ,bussid varchar2(2) -- 业务类别 1：旅行通卡业务 2：福旅通业务
    ,elemmode varchar2(2) -- 开户要素模式
    ,idcardtyp varchar2(96) -- 证件类型
    ,certifid1 varchar2(30) -- 证件号1
    ,certifid2 varchar2(30) -- 证件号2
    ,familynm varchar2(150) -- 姓
    ,firstnm varchar2(150) -- 名
    ,custna varchar2(300) -- 姓名
    ,sex varchar2(2) -- 性别
    ,birthday varchar2(12) -- 出生日期
    ,nationality varchar2(5) -- 国籍
    ,occupation varchar2(8) -- 职业
    ,ocpdsc varchar2(150) -- 职业描述
    ,taxresidenttype varchar2(6) -- 税收居民身份
    ,address varchar2(1536) -- 联系地址
    ,validstart varchar2(12) -- 身份证件发证日期
    ,validuntil varchar2(12) -- 身份证件有效期
    ,photoqryid varchar2(60) -- 影印件采集交易的查询流水号
    ,provincecode varchar2(9) -- 省代码
    ,citycode varchar2(9) -- 市代码
    ,districtcode varchar2(9) -- 区代码
    ,crsresidenttaxnation varchar2(6) -- 税收居民国/地区
    ,crsresidenttaxid varchar2(192) -- 居民国/地区纳税人识别号
    ,crstaxntnungetreason varchar2(2) -- 不能提供居民国/地区纳税人识别号的原因
    ,crstaxidungetreason varchar2(150) -- 具体原因
    ,entrychannel varchar2(2) -- 入境渠道
    ,verifyresult varchar2(3) -- 信源核验结果
    ,channelid varchar2(6) -- 申卡渠道ID
    ,channelname varchar2(75) -- 申卡渠道名称
    ,globalseq varchar2(96) -- 开户全局流水号
    ,status varchar2(2) -- 状态
    ,degree varchar2(2) -- 账户等级
    ,subaccprd varchar2(18) -- 旅行通卡有效期
    ,limitamt varchar2(18) -- 旅行通卡限额
    ,sumamt varchar2(23) -- 累计充值金额
    ,tkamt varchar2(48) -- 退卡账户余额，即退卡账户转清算户交易金额
    ,updatetm date -- 最新维护时间
    ,unsigndt date -- 解约日期
    ,remark1 varchar2(384) -- 备注1
    ,remark2 varchar2(384) -- 备注2
    ,remark3 varchar2(768) -- 备注3
    ,remark4 varchar2(768) -- 备注4
    ,remark5 varchar2(1536) -- 备注5
    ,remark6 varchar2(1536) -- 备注6
    ,remark7 varchar2(3072) -- 备注7
    ,remark8 varchar2(3072) -- 备注8
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
grant select on ${iol_schema}.mpcs_a1xacctinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1xacctinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1xacctinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1xacctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1xacctinfo is '旅行通卡开户表';
comment on column ${iol_schema}.mpcs_a1xacctinfo.fntdt is '渠道日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.phoneno is '手机号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.customid is '客户ID';
comment on column ${iol_schema}.mpcs_a1xacctinfo.acctno is '账号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.issinscode is '开户行机构代码';
comment on column ${iol_schema}.mpcs_a1xacctinfo.txnno is '银联开户交易流水号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.txntm is '开户日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.bussid is '业务类别 1：旅行通卡业务 2：福旅通业务';
comment on column ${iol_schema}.mpcs_a1xacctinfo.elemmode is '开户要素模式';
comment on column ${iol_schema}.mpcs_a1xacctinfo.idcardtyp is '证件类型';
comment on column ${iol_schema}.mpcs_a1xacctinfo.certifid1 is '证件号1';
comment on column ${iol_schema}.mpcs_a1xacctinfo.certifid2 is '证件号2';
comment on column ${iol_schema}.mpcs_a1xacctinfo.familynm is '姓';
comment on column ${iol_schema}.mpcs_a1xacctinfo.firstnm is '名';
comment on column ${iol_schema}.mpcs_a1xacctinfo.custna is '姓名';
comment on column ${iol_schema}.mpcs_a1xacctinfo.sex is '性别';
comment on column ${iol_schema}.mpcs_a1xacctinfo.birthday is '出生日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.nationality is '国籍';
comment on column ${iol_schema}.mpcs_a1xacctinfo.occupation is '职业';
comment on column ${iol_schema}.mpcs_a1xacctinfo.ocpdsc is '职业描述';
comment on column ${iol_schema}.mpcs_a1xacctinfo.taxresidenttype is '税收居民身份';
comment on column ${iol_schema}.mpcs_a1xacctinfo.address is '联系地址';
comment on column ${iol_schema}.mpcs_a1xacctinfo.validstart is '身份证件发证日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.validuntil is '身份证件有效期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.photoqryid is '影印件采集交易的查询流水号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.provincecode is '省代码';
comment on column ${iol_schema}.mpcs_a1xacctinfo.citycode is '市代码';
comment on column ${iol_schema}.mpcs_a1xacctinfo.districtcode is '区代码';
comment on column ${iol_schema}.mpcs_a1xacctinfo.crsresidenttaxnation is '税收居民国/地区';
comment on column ${iol_schema}.mpcs_a1xacctinfo.crsresidenttaxid is '居民国/地区纳税人识别号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.crstaxntnungetreason is '不能提供居民国/地区纳税人识别号的原因';
comment on column ${iol_schema}.mpcs_a1xacctinfo.crstaxidungetreason is '具体原因';
comment on column ${iol_schema}.mpcs_a1xacctinfo.entrychannel is '入境渠道';
comment on column ${iol_schema}.mpcs_a1xacctinfo.verifyresult is '信源核验结果';
comment on column ${iol_schema}.mpcs_a1xacctinfo.channelid is '申卡渠道ID';
comment on column ${iol_schema}.mpcs_a1xacctinfo.channelname is '申卡渠道名称';
comment on column ${iol_schema}.mpcs_a1xacctinfo.globalseq is '开户全局流水号';
comment on column ${iol_schema}.mpcs_a1xacctinfo.status is '状态';
comment on column ${iol_schema}.mpcs_a1xacctinfo.degree is '账户等级';
comment on column ${iol_schema}.mpcs_a1xacctinfo.subaccprd is '旅行通卡有效期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.limitamt is '旅行通卡限额';
comment on column ${iol_schema}.mpcs_a1xacctinfo.sumamt is '累计充值金额';
comment on column ${iol_schema}.mpcs_a1xacctinfo.tkamt is '退卡账户余额，即退卡账户转清算户交易金额';
comment on column ${iol_schema}.mpcs_a1xacctinfo.updatetm is '最新维护时间';
comment on column ${iol_schema}.mpcs_a1xacctinfo.unsigndt is '解约日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark1 is '备注1';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark2 is '备注2';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark3 is '备注3';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark4 is '备注4';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark5 is '备注5';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark6 is '备注6';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark7 is '备注7';
comment on column ${iol_schema}.mpcs_a1xacctinfo.remark8 is '备注8';
comment on column ${iol_schema}.mpcs_a1xacctinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1xacctinfo.etl_timestamp is 'ETL处理时间戳';
