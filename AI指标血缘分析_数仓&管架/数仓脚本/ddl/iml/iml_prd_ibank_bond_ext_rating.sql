/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_bond_ext_rating
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_bond_ext_rating
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_bond_ext_rating purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_bond_ext_rating(
    fin_instm_id varchar2(60) -- 金融工具编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,market_type_id varchar2(60) -- 市场类型编号
    ,lp_id varchar2(60) -- 法人编号
    ,crdt_rating_cd varchar2(10) -- 信用评级代码
    ,rating_org_name varchar2(750) -- 评级机构名称
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,rating_type_cd varchar2(10) -- 评级类型代码
    ,seq_num varchar2(60) -- 序号
    ,rating_outl varchar2(150) -- 评级展望
    ,rating_chg_dir_cd varchar2(10) -- 评级变动方向代码
    ,input_dt date -- 录入日期
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_ibank_bond_ext_rating to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_bond_ext_rating to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_bond_ext_rating to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_bond_ext_rating is '同业债券外部评级';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.fin_instm_id is '金融工具编号';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.asset_type_id is '资产类型编号';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.market_type_id is '市场类型编号';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.crdt_rating_cd is '信用评级代码';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.rating_org_name is '评级机构名称';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.rating_type_cd is '评级类型代码';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.seq_num is '序号';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.rating_outl is '评级展望';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.rating_chg_dir_cd is '评级变动方向代码';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.input_dt is '录入日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_bond_ext_rating.etl_timestamp is 'ETL处理时间戳';
