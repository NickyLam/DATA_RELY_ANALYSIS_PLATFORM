/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_service_company
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_service_company
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_service_company purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_service_company(
    no varchar2(120) -- 编号
    ,name varchar2(240) -- 服务商名称
    ,linkman varchar2(90) -- 联系人
    ,address varchar2(240) -- 地址
    ,phone varchar2(90) -- 固话
    ,mobile varchar2(90) -- 手机
    ,fax varchar2(90) -- 传真
    ,email varchar2(120) -- 电子邮箱
    ,infofilepath varchar2(1500) -- 信息文件路径
    ,infofilename varchar2(150) -- 信息文件名称
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
grant select on ${iol_schema}.atms_dev_service_company to ${iml_schema};
grant select on ${iol_schema}.atms_dev_service_company to ${icl_schema};
grant select on ${iol_schema}.atms_dev_service_company to ${idl_schema};
grant select on ${iol_schema}.atms_dev_service_company to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_service_company is '设备维护商表';
comment on column ${iol_schema}.atms_dev_service_company.no is '编号';
comment on column ${iol_schema}.atms_dev_service_company.name is '服务商名称';
comment on column ${iol_schema}.atms_dev_service_company.linkman is '联系人';
comment on column ${iol_schema}.atms_dev_service_company.address is '地址';
comment on column ${iol_schema}.atms_dev_service_company.phone is '固话';
comment on column ${iol_schema}.atms_dev_service_company.mobile is '手机';
comment on column ${iol_schema}.atms_dev_service_company.fax is '传真';
comment on column ${iol_schema}.atms_dev_service_company.email is '电子邮箱';
comment on column ${iol_schema}.atms_dev_service_company.infofilepath is '信息文件路径';
comment on column ${iol_schema}.atms_dev_service_company.infofilename is '信息文件名称';
comment on column ${iol_schema}.atms_dev_service_company.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_service_company.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_service_company.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_service_company.etl_timestamp is 'ETL处理时间戳';
