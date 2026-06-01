/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_acct_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_acct_b
whenever sqlerror continue none;
drop table ${iml_schema}.agt_acct_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_acct_b(
    acct_b_id varchar2(60) -- 账簿编号
    ,lp_id varchar2(60) -- 法人编号
    ,acct_b_name varchar2(150) -- 账簿名称
    ,dept_id varchar2(60) -- 部门编号
    ,cost_accti_way_cd varchar2(10) -- 成本核算方式代码
    ,fair_val_flg varchar2(10) -- 公允价值标志
    ,acct_b_attr_cd varchar2(10) -- 账簿属性代码
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
grant select on ${iml_schema}.agt_acct_b to ${icl_schema};
grant select on ${iml_schema}.agt_acct_b to ${idl_schema};
grant select on ${iml_schema}.agt_acct_b to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_acct_b is '账簿';
comment on column ${iml_schema}.agt_acct_b.acct_b_id is '账簿编号';
comment on column ${iml_schema}.agt_acct_b.lp_id is '法人编号';
comment on column ${iml_schema}.agt_acct_b.acct_b_name is '账簿名称';
comment on column ${iml_schema}.agt_acct_b.dept_id is '部门编号';
comment on column ${iml_schema}.agt_acct_b.cost_accti_way_cd is '成本核算方式代码';
comment on column ${iml_schema}.agt_acct_b.fair_val_flg is '公允价值标志';
comment on column ${iml_schema}.agt_acct_b.acct_b_attr_cd is '账簿属性代码';
comment on column ${iml_schema}.agt_acct_b.create_dt is '创建日期';
comment on column ${iml_schema}.agt_acct_b.update_dt is '更新日期';
comment on column ${iml_schema}.agt_acct_b.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.agt_acct_b.id_mark is '增删标志';
comment on column ${iml_schema}.agt_acct_b.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_acct_b.job_cd is '任务编码';
comment on column ${iml_schema}.agt_acct_b.etl_timestamp is 'ETL处理时间戳';
