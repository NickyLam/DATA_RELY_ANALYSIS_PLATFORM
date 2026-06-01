/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cif_category_type
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cif_category_type
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cif_category_type purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_category_type(
    client_type varchar2(3) -- 客户类型
    ,bank_flag varchar2(1) -- 是否为银行
    ,broker_flag varchar2(1) -- 是否为经纪人
    ,category_desc varchar2(50) -- 客户细分类型描述
    ,category_type varchar2(3) -- 存款人类别
    ,central_bank_flag varchar2(1) -- 是否为中央银行
    ,company varchar2(20) -- 法人
    ,corporation_flag varchar2(1) -- 是否为企业标识
    ,fin_institution varchar2(1) -- 金融机构标志
    ,government_flag varchar2(1) -- 政府部门标志
    ,individual_flag varchar2(1) -- 对公对私标志
    ,intl_institution_flag varchar2(1) -- 国际组织标志
    ,join_collat_flag varchar2(1) -- 联合体标志
    ,other_flag varchar2(1) -- 是否是其他
    ,rep_office varchar2(1) -- 是否为代表处
    ,libra_op_time number(15) -- libra执行次数
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cif_category_type to ${iml_schema};
grant select on ${iol_schema}.ncbs_cif_category_type to ${icl_schema};
grant select on ${iol_schema}.ncbs_cif_category_type to ${idl_schema};
grant select on ${iol_schema}.ncbs_cif_category_type to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cif_category_type is '客户类型-细分类表';
comment on column ${iol_schema}.ncbs_cif_category_type.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cif_category_type.bank_flag is '是否为银行';
comment on column ${iol_schema}.ncbs_cif_category_type.broker_flag is '是否为经纪人';
comment on column ${iol_schema}.ncbs_cif_category_type.category_desc is '客户细分类型描述';
comment on column ${iol_schema}.ncbs_cif_category_type.category_type is '存款人类别';
comment on column ${iol_schema}.ncbs_cif_category_type.central_bank_flag is '是否为中央银行';
comment on column ${iol_schema}.ncbs_cif_category_type.company is '法人';
comment on column ${iol_schema}.ncbs_cif_category_type.corporation_flag is '是否为企业标识';
comment on column ${iol_schema}.ncbs_cif_category_type.fin_institution is '金融机构标志';
comment on column ${iol_schema}.ncbs_cif_category_type.government_flag is '政府部门标志';
comment on column ${iol_schema}.ncbs_cif_category_type.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_cif_category_type.intl_institution_flag is '国际组织标志';
comment on column ${iol_schema}.ncbs_cif_category_type.join_collat_flag is '联合体标志';
comment on column ${iol_schema}.ncbs_cif_category_type.other_flag is '是否是其他';
comment on column ${iol_schema}.ncbs_cif_category_type.rep_office is '是否为代表处';
comment on column ${iol_schema}.ncbs_cif_category_type.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_cif_category_type.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cif_category_type.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cif_category_type.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cif_category_type.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cif_category_type.etl_timestamp is 'ETL处理时间戳';
