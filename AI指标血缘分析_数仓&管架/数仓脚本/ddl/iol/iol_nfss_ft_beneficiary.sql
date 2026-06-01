/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_ft_beneficiary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_ft_beneficiary
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_ft_beneficiary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_beneficiary(
    id varchar2(75) -- 主键序号
    ,product_id varchar2(75) -- 产品id
    ,nationnality varchar2(192) -- 国籍
    ,name varchar2(48) -- 受益人姓名
    ,phone varchar2(17) -- 受益人手机号
    ,id_type varchar2(18) -- 受益人证件类型
    ,id_no varchar2(27) -- 受益人证件号码
    ,valid_time varchar2(36) -- 证件有效期
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
grant select on ${iol_schema}.nfss_ft_beneficiary to ${iml_schema};
grant select on ${iol_schema}.nfss_ft_beneficiary to ${icl_schema};
grant select on ${iol_schema}.nfss_ft_beneficiary to ${idl_schema};
grant select on ${iol_schema}.nfss_ft_beneficiary to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_ft_beneficiary is '受益人管理表';
comment on column ${iol_schema}.nfss_ft_beneficiary.id is '主键序号';
comment on column ${iol_schema}.nfss_ft_beneficiary.product_id is '产品id';
comment on column ${iol_schema}.nfss_ft_beneficiary.nationnality is '国籍';
comment on column ${iol_schema}.nfss_ft_beneficiary.name is '受益人姓名';
comment on column ${iol_schema}.nfss_ft_beneficiary.phone is '受益人手机号';
comment on column ${iol_schema}.nfss_ft_beneficiary.id_type is '受益人证件类型';
comment on column ${iol_schema}.nfss_ft_beneficiary.id_no is '受益人证件号码';
comment on column ${iol_schema}.nfss_ft_beneficiary.valid_time is '证件有效期';
comment on column ${iol_schema}.nfss_ft_beneficiary.created_by is '创建者';
comment on column ${iol_schema}.nfss_ft_beneficiary.updated_by is '修改者';
comment on column ${iol_schema}.nfss_ft_beneficiary.create_time is '创建时间';
comment on column ${iol_schema}.nfss_ft_beneficiary.update_time is '修改时间';
comment on column ${iol_schema}.nfss_ft_beneficiary.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_ft_beneficiary.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_ft_beneficiary.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_ft_beneficiary.etl_timestamp is 'ETL处理时间戳';
