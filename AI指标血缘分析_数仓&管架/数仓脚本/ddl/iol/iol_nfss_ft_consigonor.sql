/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_consigonor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_consigonor
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_consigonor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_consigonor(
    ecif_id varchar2(75) -- 主键序号
    ,ecif_name varchar2(192) -- 客户姓名
    ,ecif_no varchar2(48) -- 客户号
    ,id_type varchar2(18) -- 证件类型
    ,id_no varchar2(27) -- 证件号码
    ,phone varchar2(17) -- 手机号
    ,dep varchar2(150) -- 所属机构
    ,is_primary varchar2(5) -- 是否是主委托人0 不是  1是
    ,sort_field varchar2(48) -- 排序字段
    ,created_by varchar2(150) -- 创建者
    ,updated_by varchar2(150) -- 修改者
    ,create_time date -- 创建时间
    ,update_time date -- 修改时间
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
grant select on ${iol_schema}.nfss_ft_consigonor to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_consigonor to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_consigonor to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_consigonor to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_consigonor is '委托人管理表';
comment on column ${iol_schema}.nfss_ft_consigonor.ecif_id is '主键序号';
comment on column ${iol_schema}.nfss_ft_consigonor.ecif_name is '客户姓名';
comment on column ${iol_schema}.nfss_ft_consigonor.ecif_no is '客户号';
comment on column ${iol_schema}.nfss_ft_consigonor.id_type is '证件类型';
comment on column ${iol_schema}.nfss_ft_consigonor.id_no is '证件号码';
comment on column ${iol_schema}.nfss_ft_consigonor.phone is '手机号';
comment on column ${iol_schema}.nfss_ft_consigonor.dep is '所属机构';
comment on column ${iol_schema}.nfss_ft_consigonor.is_primary is '是否是主委托人0 不是  1是';
comment on column ${iol_schema}.nfss_ft_consigonor.sort_field is '排序字段';
comment on column ${iol_schema}.nfss_ft_consigonor.created_by is '创建者';
comment on column ${iol_schema}.nfss_ft_consigonor.updated_by is '修改者';
comment on column ${iol_schema}.nfss_ft_consigonor.create_time is '创建时间';
comment on column ${iol_schema}.nfss_ft_consigonor.update_time is '修改时间';
comment on column ${iol_schema}.nfss_ft_consigonor.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ft_consigonor.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ft_consigonor.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ft_consigonor.etl_timestamp is 'ETL处理时间戳';
