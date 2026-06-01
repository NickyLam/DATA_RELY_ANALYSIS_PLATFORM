/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_prod_catlg_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_prod_catlg_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_prod_catlg_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_catlg_h(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(100) -- 法人编号
    ,prod_hibchy number(10) -- 产品层级
    ,prod_gen_id varchar2(100) -- 产品线大类编号
    ,prod_gen_name varchar2(500) -- 产品线大类名称
    ,prod_sclass_id varchar2(100) -- 产品线小类编号
    ,prod_sclass_name varchar2(500) -- 产品线小类名称
    ,prod_group_id varchar2(100) -- 产品组编号
    ,prod_group_name varchar2(500) -- 产品组名称
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,base_prod_name varchar2(500) -- 基础产品名称
    ,sellbl_prod_id varchar2(100) -- 可售产品编号
    ,sellbl_prod_name varchar2(500) -- 可售产品名称
    ,prod_descb varchar2(500) -- 产品描述
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,mgmt_org_id varchar2(100) -- 管理机构编号
    ,sys_id varchar2(100) -- 系统编号
    ,tran_tm timestamp -- 交易时间
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_prod_catlg_h to ${icl_schema};
grant select on ${iml_schema}.prd_prod_catlg_h to ${idl_schema};
grant select on ${iml_schema}.prd_prod_catlg_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_prod_catlg_h is '产品目录历史';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_prod_catlg_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_hibchy is '产品层级';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_gen_id is '产品线大类编号';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_gen_name is '产品线大类名称';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_sclass_id is '产品线小类编号';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_sclass_name is '产品线小类名称';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_group_id is '产品组编号';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_group_name is '产品组名称';
comment on column ${iml_schema}.prd_prod_catlg_h.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.prd_prod_catlg_h.base_prod_name is '基础产品名称';
comment on column ${iml_schema}.prd_prod_catlg_h.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.prd_prod_catlg_h.sellbl_prod_name is '可售产品名称';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_descb is '产品描述';
comment on column ${iml_schema}.prd_prod_catlg_h.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_prod_catlg_h.mgmt_org_id is '管理机构编号';
comment on column ${iml_schema}.prd_prod_catlg_h.sys_id is '系统编号';
comment on column ${iml_schema}.prd_prod_catlg_h.tran_tm is '交易时间';
comment on column ${iml_schema}.prd_prod_catlg_h.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_prod_catlg_h.invalid_dt is '失效日期';
comment on column ${iml_schema}.prd_prod_catlg_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_prod_catlg_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_prod_catlg_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_prod_catlg_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_prod_catlg_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_prod_catlg_h.etl_timestamp is 'ETL处理时间戳';
