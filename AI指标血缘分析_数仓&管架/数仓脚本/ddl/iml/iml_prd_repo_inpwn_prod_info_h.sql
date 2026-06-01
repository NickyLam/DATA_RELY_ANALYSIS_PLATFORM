/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_repo_inpwn_prod_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_repo_inpwn_prod_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_repo_inpwn_prod_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_repo_inpwn_prod_info_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,brch_seq_num number(10) -- 分支序号
    ,inpwn_fin_prod_id varchar2(100) -- 质押金融产品编号
    ,inpwn_fac_val number(30,2) -- 质押面值
    ,inpwn_qtty number(30,2) -- 质押数量
    ,inpwn_rat number(30,14) -- 质押率
    ,inpwn_amt number(30,2) -- 质押金额
    ,create_tm timestamp -- 创建时间
    ,update_tm timestamp -- 更新时间
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
grant select on ${iml_schema}.prd_repo_inpwn_prod_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_repo_inpwn_prod_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_repo_inpwn_prod_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_repo_inpwn_prod_info_h is '回购质押产品信息历史';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.brch_seq_num is '分支序号';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.inpwn_fin_prod_id is '质押金融产品编号';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.inpwn_fac_val is '质押面值';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.inpwn_qtty is '质押数量';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.inpwn_rat is '质押率';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.inpwn_amt is '质押金额';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_repo_inpwn_prod_info_h.etl_timestamp is 'ETL处理时间戳';
