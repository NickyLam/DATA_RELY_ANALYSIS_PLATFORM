/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1d_sub_feature
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1d_sub_feature
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1d_sub_feature purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1d_sub_feature(
    sub_fetr_id varchar2(18) -- 子特征编号
    ,sub_fetr_name varchar2(288) -- 子特征名称
    ,fetr_type varchar2(2) -- 特征类型（参见[字典:aml0011]）
    ,exec_mode varchar2(2) -- 特征计算方式（参见[字典:aml0013]）
    ,fetr_sts varchar2(2) -- 特征状态（参见[字典:aml0014]）
    ,is_local_curr varchar2(2) -- 是否本币（参见[字典:aml0015]）
    ,fetr_freq varchar2(2) -- 特征频度（参见[字典:t00026]）
    ,fetr_desc varchar2(750) -- 特征描述
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,fetr_id varchar2(18) -- 特征编号
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
grant select on ${iol_schema}.amls_t1d_sub_feature to ${iml_schema};
grant select on ${iol_schema}.amls_t1d_sub_feature to ${icl_schema};
grant select on ${iol_schema}.amls_t1d_sub_feature to ${idl_schema};
grant select on ${iol_schema}.amls_t1d_sub_feature to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1d_sub_feature is 't1d_特征定义子表';
comment on column ${iol_schema}.amls_t1d_sub_feature.sub_fetr_id is '子特征编号';
comment on column ${iol_schema}.amls_t1d_sub_feature.sub_fetr_name is '子特征名称';
comment on column ${iol_schema}.amls_t1d_sub_feature.fetr_type is '特征类型（参见[字典:aml0011]）';
comment on column ${iol_schema}.amls_t1d_sub_feature.exec_mode is '特征计算方式（参见[字典:aml0013]）';
comment on column ${iol_schema}.amls_t1d_sub_feature.fetr_sts is '特征状态（参见[字典:aml0014]）';
comment on column ${iol_schema}.amls_t1d_sub_feature.is_local_curr is '是否本币（参见[字典:aml0015]）';
comment on column ${iol_schema}.amls_t1d_sub_feature.fetr_freq is '特征频度（参见[字典:t00026]）';
comment on column ${iol_schema}.amls_t1d_sub_feature.fetr_desc is '特征描述';
comment on column ${iol_schema}.amls_t1d_sub_feature.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t1d_sub_feature.creator is '创建人';
comment on column ${iol_schema}.amls_t1d_sub_feature.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t1d_sub_feature.modifier is '修改人';
comment on column ${iol_schema}.amls_t1d_sub_feature.fetr_id is '特征编号';
comment on column ${iol_schema}.amls_t1d_sub_feature.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t1d_sub_feature.etl_timestamp is 'ETL处理时间戳';
