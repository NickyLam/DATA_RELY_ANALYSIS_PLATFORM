/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ifs_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ifs_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ifs_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ifs_prod(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,curr_cd varchar2(10) -- 币种代码
    ,sav_type_cd varchar2(10) -- 储种代码
    ,dep_term_cd varchar2(10) -- 存期代码
    ,pric_accting_code varchar2(45) -- 本金会计核算码
    ,int_paybl_accting_code varchar2(45) -- 应付利息会计核算码
    ,int_expns_accting_code varchar2(45) -- 利息支出会计核算码
    ,accti_org_id varchar2(60) -- 核算机构编号
    ,exec_int_rat_cate_cd varchar2(10) -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd varchar2(10) -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd varchar2(10) -- 逾期利率类别代码
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
grant select on ${iml_schema}.prd_ifs_prod to ${icl_schema};
grant select on ${iml_schema}.prd_ifs_prod to ${idl_schema};
grant select on ${iml_schema}.prd_ifs_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ifs_prod is '联合存款产品';
comment on column ${iml_schema}.prd_ifs_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_ifs_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ifs_prod.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_ifs_prod.sav_type_cd is '储种代码';
comment on column ${iml_schema}.prd_ifs_prod.dep_term_cd is '存期代码';
comment on column ${iml_schema}.prd_ifs_prod.pric_accting_code is '本金会计核算码';
comment on column ${iml_schema}.prd_ifs_prod.int_paybl_accting_code is '应付利息会计核算码';
comment on column ${iml_schema}.prd_ifs_prod.int_expns_accting_code is '利息支出会计核算码';
comment on column ${iml_schema}.prd_ifs_prod.accti_org_id is '核算机构编号';
comment on column ${iml_schema}.prd_ifs_prod.exec_int_rat_cate_cd is '执行利率类别代码';
comment on column ${iml_schema}.prd_ifs_prod.pa_ext_int_rat_cate_cd is '部提利率类别代码';
comment on column ${iml_schema}.prd_ifs_prod.ovdue_int_rat_cate_cd is '逾期利率类别代码';
comment on column ${iml_schema}.prd_ifs_prod.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ifs_prod.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ifs_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ifs_prod.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ifs_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ifs_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ifs_prod.etl_timestamp is 'ETL处理时间戳';
