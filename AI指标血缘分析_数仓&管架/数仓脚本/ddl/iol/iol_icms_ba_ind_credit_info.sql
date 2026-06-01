/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ba_ind_credit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ba_ind_credit_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ba_ind_credit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ba_ind_credit_info(
    serialno varchar2(32) -- 流水号
    ,baserialno varchar2(32) -- 申请流水号
    ,reportdate varchar2(10) -- 报告日期
    ,reportid varchar2(40) -- 报告ID
    ,certtype varchar2(4) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,customername varchar2(100) -- 客户姓名
    ,customerid varchar2(30) -- 客户号
    ,customertype varchar2(10) -- 客户类型
    ,relativetype varchar2(10) -- 关联人类型
    ,inputuserid varchar2(40) -- 登记人
    ,inputorgid varchar2(40) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(40) -- 更新人
    ,updateorgid varchar2(40) -- 更新机构
    ,updatedate date -- 更新日期
    ,reportremark varchar2(2000) -- 征信报告备注
    ,qryopertp varchar2(2000) -- 查询操作申请类型
    ,authotype varchar2(20) -- 授权方式
    ,biometrics varchar2(20) -- 生物识别技术
    ,status varchar2(10) -- 请求结果状态
    ,pbcdata varchar2(2000) -- 征信查询结果
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,authodate date -- 授权时间
    ,authostrdate date -- 授权起始时间
    ,authoenddate date -- 授权结束时间
    ,supplyflag varchar2(2) -- 补录标识YesNo 1-是 ，0-否
    ,supplycomplete varchar2(1) -- 影像资料是否补充完全YesNo,1-是，0-否
    ,iscreditflag varchar2(2) -- 是否查询征信报告
    ,craserialno varchar2(32) -- 征信申请流程关联流水号
    ,xxdyxserialno varchar2(32) -- 新兴贷用信申请关联流水号
    ,creditvalidatetime varchar2(10) -- 征信有效期
    ,authobkid varchar2(64) -- 客户数据授权书编号
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
grant select on ${iol_schema}.icms_ba_ind_credit_info to ${iml_schema};
grant select on ${iol_schema}.icms_ba_ind_credit_info to ${icl_schema};
grant select on ${iol_schema}.icms_ba_ind_credit_info to ${idl_schema};
grant select on ${iol_schema}.icms_ba_ind_credit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ba_ind_credit_info is '个人客户征信信息';
comment on column ${iol_schema}.icms_ba_ind_credit_info.serialno is '流水号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.baserialno is '申请流水号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.reportdate is '报告日期';
comment on column ${iol_schema}.icms_ba_ind_credit_info.reportid is '报告ID';
comment on column ${iol_schema}.icms_ba_ind_credit_info.certtype is '证件类型';
comment on column ${iol_schema}.icms_ba_ind_credit_info.certid is '证件号码';
comment on column ${iol_schema}.icms_ba_ind_credit_info.customername is '客户姓名';
comment on column ${iol_schema}.icms_ba_ind_credit_info.customerid is '客户号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_ba_ind_credit_info.relativetype is '关联人类型';
comment on column ${iol_schema}.icms_ba_ind_credit_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ba_ind_credit_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ba_ind_credit_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ba_ind_credit_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ba_ind_credit_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ba_ind_credit_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ba_ind_credit_info.reportremark is '征信报告备注';
comment on column ${iol_schema}.icms_ba_ind_credit_info.qryopertp is '查询操作申请类型';
comment on column ${iol_schema}.icms_ba_ind_credit_info.authotype is '授权方式';
comment on column ${iol_schema}.icms_ba_ind_credit_info.biometrics is '生物识别技术';
comment on column ${iol_schema}.icms_ba_ind_credit_info.status is '请求结果状态';
comment on column ${iol_schema}.icms_ba_ind_credit_info.pbcdata is '征信查询结果';
comment on column ${iol_schema}.icms_ba_ind_credit_info.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_ba_ind_credit_info.authodate is '授权时间';
comment on column ${iol_schema}.icms_ba_ind_credit_info.authostrdate is '授权起始时间';
comment on column ${iol_schema}.icms_ba_ind_credit_info.authoenddate is '授权结束时间';
comment on column ${iol_schema}.icms_ba_ind_credit_info.supplyflag is '补录标识YesNo 1-是 ，0-否';
comment on column ${iol_schema}.icms_ba_ind_credit_info.supplycomplete is '影像资料是否补充完全YesNo,1-是，0-否';
comment on column ${iol_schema}.icms_ba_ind_credit_info.iscreditflag is '是否查询征信报告';
comment on column ${iol_schema}.icms_ba_ind_credit_info.craserialno is '征信申请流程关联流水号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.xxdyxserialno is '新兴贷用信申请关联流水号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.creditvalidatetime is '征信有效期';
comment on column ${iol_schema}.icms_ba_ind_credit_info.authobkid is '客户数据授权书编号';
comment on column ${iol_schema}.icms_ba_ind_credit_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_ba_ind_credit_info.etl_timestamp is 'ETL处理时间戳';
