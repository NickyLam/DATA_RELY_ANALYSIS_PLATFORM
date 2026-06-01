/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1d_feature
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1d_feature
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1d_feature purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1d_feature(
    fetr_id varchar2(18) -- 特征编号
    ,fetr_name varchar2(288) -- 特征名称
    ,fetr_type varchar2(2) -- 特征类型（参见[字典:aml0011]）
    ,pbc_tcr varchar2(6) -- 人行特征代码
    ,fetr_catg varchar2(2) -- 特征分类（参见[字典:aml0012]）
    ,exec_mode varchar2(2) -- 特征计算方式（参见[字典:aml0013]）
    ,is_prop varchar2(2) -- 是否属性（参见[字典:t00002]）
    ,is_net varchar2(2) -- 是否用于资金网络（参见[字典:t00002]）
    ,is_case varchar2(2) -- 单独形成案例（参见[字典:t00002]）
    ,crime_type varchar2(300) -- 涉罪类型
    ,fetr_desc varchar2(750) -- 特征描述
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,is_valid varchar2(2) -- 是否有效（参见[字典:t00002]）
    ,fetr_s_type varchar2(2) -- 业务特征
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
grant select on ${iol_schema}.amls_t1d_feature to ${iml_schema};
grant select on ${iol_schema}.amls_t1d_feature to ${icl_schema};
grant select on ${iol_schema}.amls_t1d_feature to ${idl_schema};
grant select on ${iol_schema}.amls_t1d_feature to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1d_feature is 't1d_特征定义表';
comment on column ${iol_schema}.amls_t1d_feature.fetr_id is '特征编号';
comment on column ${iol_schema}.amls_t1d_feature.fetr_name is '特征名称';
comment on column ${iol_schema}.amls_t1d_feature.fetr_type is '特征类型（参见[字典:aml0011]）';
comment on column ${iol_schema}.amls_t1d_feature.pbc_tcr is '人行特征代码';
comment on column ${iol_schema}.amls_t1d_feature.fetr_catg is '特征分类（参见[字典:aml0012]）';
comment on column ${iol_schema}.amls_t1d_feature.exec_mode is '特征计算方式（参见[字典:aml0013]）';
comment on column ${iol_schema}.amls_t1d_feature.is_prop is '是否属性（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1d_feature.is_net is '是否用于资金网络（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1d_feature.is_case is '单独形成案例（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1d_feature.crime_type is '涉罪类型';
comment on column ${iol_schema}.amls_t1d_feature.fetr_desc is '特征描述';
comment on column ${iol_schema}.amls_t1d_feature.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t1d_feature.creator is '创建人';
comment on column ${iol_schema}.amls_t1d_feature.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t1d_feature.modifier is '修改人';
comment on column ${iol_schema}.amls_t1d_feature.is_valid is '是否有效（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t1d_feature.fetr_s_type is '业务特征';
comment on column ${iol_schema}.amls_t1d_feature.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t1d_feature.etl_timestamp is 'ETL处理时间戳';
