/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_bond_int_rat_reval_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_bond_int_rat_reval_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_bond_int_rat_reval_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_bond_int_rat_reval_info(
    bond_id varchar2(60) -- 债券编号
    ,lp_id varchar2(60) -- 法人编号
    ,seq_num varchar2(60) -- 序号
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,reval_dt date -- 重定价日期
    ,reval_int_rat number(18,8) -- 重定价利率
    ,adj_spread number(18,6) -- 调整点差
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
grant select on ${iml_schema}.prd_bond_int_rat_reval_info to ${icl_schema};
grant select on ${iml_schema}.prd_bond_int_rat_reval_info to ${idl_schema};
grant select on ${iml_schema}.prd_bond_int_rat_reval_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_bond_int_rat_reval_info is '债券利率重定价信息';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.bond_id is '债券编号';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.seq_num is '序号';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.reval_dt is '重定价日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.reval_int_rat is '重定价利率';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.adj_spread is '调整点差';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_bond_int_rat_reval_info.etl_timestamp is 'ETL处理时间戳';
