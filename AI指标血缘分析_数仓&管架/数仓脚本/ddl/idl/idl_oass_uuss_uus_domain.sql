/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_uus_domain
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_uus_domain purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_uus_domain(
etl_dt date --数据日期
,name varchar2(100) --姓名
,sysstatus varchar2(1) --员工系统状态 1-正常 2-锁定
,companycountrycode varchar2(4) --单位电话国际区号
,companyareacode varchar2(4) --单位电话国内区号
,companyphone varchar2(11) --单位电话
,companysubphone varchar2(6) --单位电话分机号
,mobile varchar2(11) --移动电话
,post varchar2(6) --邮政编码
,address varchar2(255) --详细地址
,email varchar2(100) --电子邮箱
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,domainid varchar2(20) --域帐号
,employeeid varchar2(16) --员工编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_uus_domain to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_uus_domain is '域用户信息表';
comment on column ${idl_schema}.oass_uuss_uus_domain.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_uus_domain.name is '姓名';
comment on column ${idl_schema}.oass_uuss_uus_domain.sysstatus is '员工系统状态 1-正常 2-锁定';
comment on column ${idl_schema}.oass_uuss_uus_domain.companycountrycode is '单位电话国际区号';
comment on column ${idl_schema}.oass_uuss_uus_domain.companyareacode is '单位电话国内区号';
comment on column ${idl_schema}.oass_uuss_uus_domain.companyphone is '单位电话';
comment on column ${idl_schema}.oass_uuss_uus_domain.companysubphone is '单位电话分机号';
comment on column ${idl_schema}.oass_uuss_uus_domain.mobile is '移动电话';
comment on column ${idl_schema}.oass_uuss_uus_domain.post is '邮政编码';
comment on column ${idl_schema}.oass_uuss_uus_domain.address is '详细地址';
comment on column ${idl_schema}.oass_uuss_uus_domain.email is '电子邮箱';
comment on column ${idl_schema}.oass_uuss_uus_domain.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_uus_domain.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_uus_domain.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_uus_domain.domainid is '域帐号';
comment on column ${idl_schema}.oass_uuss_uus_domain.employeeid is '员工编号';

