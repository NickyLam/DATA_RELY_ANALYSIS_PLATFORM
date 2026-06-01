/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_addit_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_addit_prod_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_addit_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_addit_prod_info(
    prod_id varchar2(100) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,main_prod_id varchar2(100) -- 主险产品编号
    ,addit_prod_name varchar2(750) -- 附加险产品名称
    ,insu_comp_addit_prod_id varchar2(100) -- 保险公司附加险产品编号
    ,permium_calc_corp_type_cd varchar2(30) -- 保费计算单位类型代码
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
grant select on ${iml_schema}.prd_addit_prod_info to ${icl_schema};
grant select on ${iml_schema}.prd_addit_prod_info to ${idl_schema};
grant select on ${iml_schema}.prd_addit_prod_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_addit_prod_info is '附加险产品信息';
comment on column ${iml_schema}.prd_addit_prod_info.prod_id is '产品编号';
comment on column ${iml_schema}.prd_addit_prod_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_addit_prod_info.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_addit_prod_info.main_prod_id is '主险产品编号';
comment on column ${iml_schema}.prd_addit_prod_info.addit_prod_name is '附加险产品名称';
comment on column ${iml_schema}.prd_addit_prod_info.insu_comp_addit_prod_id is '保险公司附加险产品编号';
comment on column ${iml_schema}.prd_addit_prod_info.permium_calc_corp_type_cd is '保费计算单位类型代码';
comment on column ${iml_schema}.prd_addit_prod_info.create_dt is '创建日期';
comment on column ${iml_schema}.prd_addit_prod_info.update_dt is '更新日期';
comment on column ${iml_schema}.prd_addit_prod_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_addit_prod_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_addit_prod_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_addit_prod_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_addit_prod_info.etl_timestamp is 'ETL处理时间戳';
