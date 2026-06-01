/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_info_lhdk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_info_lhdk
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_info_lhdk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_lhdk(
    customerid varchar2(32) -- 客户号
    ,customername varchar2(400) -- 客户姓名
    ,certtype varchar2(8) -- 证件类型
    ,certid varchar2(120) -- 证件号码
    ,certstartdate date -- 证件起始日
    ,certmaturity date -- 证件到期日
    ,sex varchar2(2) -- 性别
    ,occupation varchar2(1000) -- 职业
    ,nation varchar2(6) -- 国籍
    ,address varchar2(1200) -- 地址
    ,telephone varchar2(60) -- 联系电话
    ,isfarmer varchar2(2) -- 农户标志
    ,indtype varchar2(20) -- 客户性质
    ,indincome number(20,2) -- 个人收入（元）
    ,homeincome number(20,2) -- 家庭收入（元）
    ,accountno varchar2(60) -- 银行卡号
    ,accountbankname varchar2(400) -- 开户行名称
    ,migtflag varchar2(160) -- 迁移标志：crs rcr ilc upl
    ,workno varchar2(128) -- 单位编号
    ,workname varchar2(1000) -- 单位名称
    ,unitaddress varchar2(1000) -- 单位地址
    ,unitpostcode varchar2(36) -- 单位地址邮政编码
    ,liveaddress varchar2(2000) -- 居住地址
    ,inputuserid varchar2(128) -- 登记人
    ,inputorgid varchar2(128) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(128) -- 更新人
    ,updateorgid varchar2(128) -- 更新机构
    ,updatedate date -- 更新日期
    ,comcrddt date -- 信用评级时间
    ,comcrdgrade varchar2(64) -- 客户信用评级
    ,comcrdscore varchar2(64) -- 信用评级积分
    ,disabledflag varchar2(4) -- 是否残疾人
    ,familyfarmflag varchar2(4) -- 是否家庭农场
    ,lowincomeflag varchar2(4) -- 是否低保户
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
grant select on ${iol_schema}.icms_customer_info_lhdk to ${iml_schema};
grant select on ${iol_schema}.icms_customer_info_lhdk to ${icl_schema};
grant select on ${iol_schema}.icms_customer_info_lhdk to ${idl_schema};
grant select on ${iol_schema}.icms_customer_info_lhdk to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_info_lhdk is '联合贷款客户';
comment on column ${iol_schema}.icms_customer_info_lhdk.customerid is '客户号';
comment on column ${iol_schema}.icms_customer_info_lhdk.customername is '客户姓名';
comment on column ${iol_schema}.icms_customer_info_lhdk.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_info_lhdk.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_info_lhdk.certstartdate is '证件起始日';
comment on column ${iol_schema}.icms_customer_info_lhdk.certmaturity is '证件到期日';
comment on column ${iol_schema}.icms_customer_info_lhdk.sex is '性别';
comment on column ${iol_schema}.icms_customer_info_lhdk.occupation is '职业';
comment on column ${iol_schema}.icms_customer_info_lhdk.nation is '国籍';
comment on column ${iol_schema}.icms_customer_info_lhdk.address is '地址';
comment on column ${iol_schema}.icms_customer_info_lhdk.telephone is '联系电话';
comment on column ${iol_schema}.icms_customer_info_lhdk.isfarmer is '农户标志';
comment on column ${iol_schema}.icms_customer_info_lhdk.indtype is '客户性质';
comment on column ${iol_schema}.icms_customer_info_lhdk.indincome is '个人收入（元）';
comment on column ${iol_schema}.icms_customer_info_lhdk.homeincome is '家庭收入（元）';
comment on column ${iol_schema}.icms_customer_info_lhdk.accountno is '银行卡号';
comment on column ${iol_schema}.icms_customer_info_lhdk.accountbankname is '开户行名称';
comment on column ${iol_schema}.icms_customer_info_lhdk.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_customer_info_lhdk.workno is '单位编号';
comment on column ${iol_schema}.icms_customer_info_lhdk.workname is '单位名称';
comment on column ${iol_schema}.icms_customer_info_lhdk.unitaddress is '单位地址';
comment on column ${iol_schema}.icms_customer_info_lhdk.unitpostcode is '单位地址邮政编码';
comment on column ${iol_schema}.icms_customer_info_lhdk.liveaddress is '居住地址';
comment on column ${iol_schema}.icms_customer_info_lhdk.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_info_lhdk.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_info_lhdk.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_info_lhdk.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_info_lhdk.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_info_lhdk.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_info_lhdk.comcrddt is '信用评级时间';
comment on column ${iol_schema}.icms_customer_info_lhdk.comcrdgrade is '客户信用评级';
comment on column ${iol_schema}.icms_customer_info_lhdk.comcrdscore is '信用评级积分';
comment on column ${iol_schema}.icms_customer_info_lhdk.disabledflag is '是否残疾人';
comment on column ${iol_schema}.icms_customer_info_lhdk.familyfarmflag is '是否家庭农场';
comment on column ${iol_schema}.icms_customer_info_lhdk.lowincomeflag is '是否低保户';
comment on column ${iol_schema}.icms_customer_info_lhdk.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_info_lhdk.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_info_lhdk.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_info_lhdk.etl_timestamp is 'ETL处理时间戳';
