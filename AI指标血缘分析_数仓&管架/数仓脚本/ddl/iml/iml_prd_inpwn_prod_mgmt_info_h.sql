/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_inpwn_prod_mgmt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_inpwn_prod_mgmt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_inpwn_prod_mgmt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_inpwn_prod_mgmt_info_h(
    prod_pk varchar2(60) -- 产品主键
    ,lp_id varchar2(60) -- 法人编号
    ,fin_prod_id varchar2(100) -- 金融产品编号
    ,pmo_type_descb varchar2(100) -- 抵质押物类型描述
    ,pmo_acct_num varchar2(500) -- 抵质押物账号
    ,pmo_evltion_amt number(38,8) -- 抵质押物估值金额
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,evltion_dt date -- 估值日期
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
grant select on ${iml_schema}.prd_inpwn_prod_mgmt_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_inpwn_prod_mgmt_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_inpwn_prod_mgmt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_inpwn_prod_mgmt_info_h is '质押品管理信息历史';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.prod_pk is '产品主键';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.fin_prod_id is '金融产品编号';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.pmo_type_descb is '抵质押物类型描述';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.pmo_acct_num is '抵质押物账号';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.pmo_evltion_amt is '抵质押物估值金额';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.value_dt is '起息日期';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.evltion_dt is '估值日期';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.update_tm is '更新时间';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_inpwn_prod_mgmt_info_h.etl_timestamp is 'ETL处理时间戳';
