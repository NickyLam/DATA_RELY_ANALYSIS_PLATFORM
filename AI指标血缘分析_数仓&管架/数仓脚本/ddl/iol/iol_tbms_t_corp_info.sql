/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_corp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_corp_info
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_corp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_corp_info(
    companyid number(20) -- 企业ID
    ,orgcode varchar2(48) -- 企业组织机构代码
    ,cname varchar2(180) -- 企业名称
    ,legalid number(20) -- 企业法人ID
    ,adminid number(20) -- 企业最高管理者ID
    ,phone varchar2(39) -- 企业电话
    ,email varchar2(150) -- 企业邮箱
    ,address varchar2(450) -- 企业通讯地址
    ,status number(4) -- 认证状态,1默认未认证,2认证中,3已认证
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
    ,logourl varchar2(765) -- 企业logo
    ,cpytype number(10) -- 企业所属类型
    ,summary varchar2(765) -- 企业简介
    ,website varchar2(765) -- 企业logo
    ,legal varchar2(90) -- 企业法人ID
    ,legalphone varchar2(36) -- 企业法人手机号
    ,contactinfo varchar2(765) -- 企业所在省
    ,provinces number(20) -- 企业所在市Id
    ,city number(20) -- 企业所属行业Id
    ,industryid number(20) -- 是否金额机构
    ,isfunc number(4) -- 企业类型
    ,etype number(10) -- 成立日期
    ,estdate varchar2(60) -- 注册资金
    ,regcaptial number(20) -- 企业统一社会信用代码
    ,uscc varchar2(54) -- 企业客户号
    ,companyno varchar2(96) -- 企业联系人
    ,authorgid number(20) -- 认证（签约）机构
    ,authtime date -- 认证（签约）时间
    ,authorgcode varchar2(60) -- 认证(签约)机构编号
    ,operusercode varchar2(60) -- 操作认证(签约)人员编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbms_t_corp_info to ${iml_schema};
grant select on ${iol_schema}.tbms_t_corp_info to ${icl_schema};
grant select on ${iol_schema}.tbms_t_corp_info to ${idl_schema};
grant select on ${iol_schema}.tbms_t_corp_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_corp_info is '企业信息表';
comment on column ${iol_schema}.tbms_t_corp_info.companyid is '企业ID';
comment on column ${iol_schema}.tbms_t_corp_info.orgcode is '企业组织机构代码';
comment on column ${iol_schema}.tbms_t_corp_info.cname is '企业名称';
comment on column ${iol_schema}.tbms_t_corp_info.legalid is '企业法人ID';
comment on column ${iol_schema}.tbms_t_corp_info.adminid is '企业最高管理者ID';
comment on column ${iol_schema}.tbms_t_corp_info.phone is '企业电话';
comment on column ${iol_schema}.tbms_t_corp_info.email is '企业邮箱';
comment on column ${iol_schema}.tbms_t_corp_info.address is '企业通讯地址';
comment on column ${iol_schema}.tbms_t_corp_info.status is '认证状态,1默认未认证,2认证中,3已认证';
comment on column ${iol_schema}.tbms_t_corp_info.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_corp_info.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_corp_info.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_corp_info.logourl is '企业logo';
comment on column ${iol_schema}.tbms_t_corp_info.cpytype is '企业所属类型';
comment on column ${iol_schema}.tbms_t_corp_info.summary is '企业简介';
comment on column ${iol_schema}.tbms_t_corp_info.website is '企业logo';
comment on column ${iol_schema}.tbms_t_corp_info.legal is '企业法人ID';
comment on column ${iol_schema}.tbms_t_corp_info.legalphone is '企业法人手机号';
comment on column ${iol_schema}.tbms_t_corp_info.contactinfo is '企业所在省';
comment on column ${iol_schema}.tbms_t_corp_info.provinces is '企业所在市Id';
comment on column ${iol_schema}.tbms_t_corp_info.city is '企业所属行业Id';
comment on column ${iol_schema}.tbms_t_corp_info.industryid is '是否金额机构';
comment on column ${iol_schema}.tbms_t_corp_info.isfunc is '企业类型';
comment on column ${iol_schema}.tbms_t_corp_info.etype is '成立日期';
comment on column ${iol_schema}.tbms_t_corp_info.estdate is '注册资金';
comment on column ${iol_schema}.tbms_t_corp_info.regcaptial is '企业统一社会信用代码';
comment on column ${iol_schema}.tbms_t_corp_info.uscc is '企业客户号';
comment on column ${iol_schema}.tbms_t_corp_info.companyno is '企业联系人';
comment on column ${iol_schema}.tbms_t_corp_info.authorgid is '认证（签约）机构';
comment on column ${iol_schema}.tbms_t_corp_info.authtime is '认证（签约）时间';
comment on column ${iol_schema}.tbms_t_corp_info.authorgcode is '认证(签约)机构编号';
comment on column ${iol_schema}.tbms_t_corp_info.operusercode is '操作认证(签约)人员编号';
comment on column ${iol_schema}.tbms_t_corp_info.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_corp_info.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_corp_info.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_corp_info.etl_timestamp is 'ETL处理时间戳';
