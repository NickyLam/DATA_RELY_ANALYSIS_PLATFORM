/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_domain
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_domain
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_domain purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_domain(
    domainid varchar2(30) -- 域帐号
    ,employeeid varchar2(24) -- 员工编号
    ,name varchar2(150) -- 姓名
    ,sysstatus varchar2(2) -- 员工系统状态 1-正常 2-锁定
    ,companycountrycode varchar2(6) -- 单位电话国际区号
    ,companyareacode varchar2(6) -- 单位电话国内区号
    ,companyphone varchar2(17) -- 单位电话
    ,companysubphone varchar2(9) -- 单位电话分机号
    ,mobile varchar2(17) -- 移动电话
    ,post varchar2(9) -- 邮政编码
    ,address varchar2(383) -- 详细地址
    ,email varchar2(150) -- 电子邮箱
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
grant select on ${iol_schema}.uuss_uus_domain to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_domain to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_domain to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_domain to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_domain is '域用户信息表';
comment on column ${iol_schema}.uuss_uus_domain.domainid is '域帐号';
comment on column ${iol_schema}.uuss_uus_domain.employeeid is '员工编号';
comment on column ${iol_schema}.uuss_uus_domain.name is '姓名';
comment on column ${iol_schema}.uuss_uus_domain.sysstatus is '员工系统状态 1-正常 2-锁定';
comment on column ${iol_schema}.uuss_uus_domain.companycountrycode is '单位电话国际区号';
comment on column ${iol_schema}.uuss_uus_domain.companyareacode is '单位电话国内区号';
comment on column ${iol_schema}.uuss_uus_domain.companyphone is '单位电话';
comment on column ${iol_schema}.uuss_uus_domain.companysubphone is '单位电话分机号';
comment on column ${iol_schema}.uuss_uus_domain.mobile is '移动电话';
comment on column ${iol_schema}.uuss_uus_domain.post is '邮政编码';
comment on column ${iol_schema}.uuss_uus_domain.address is '详细地址';
comment on column ${iol_schema}.uuss_uus_domain.email is '电子邮箱';
comment on column ${iol_schema}.uuss_uus_domain.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_domain.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_domain.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_domain.etl_timestamp is 'ETL处理时间戳';
