/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_finc_prod_lmt_ctrl_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_finc_prod_lmt_ctrl_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_finc_prod_lmt_ctrl_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_finc_prod_lmt_ctrl_h(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,org_id varchar2(100) -- 机构编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,finc_intnal_org_id varchar2(100) -- 理财内部机构编号
    ,tot_sell_lmt number(30,2) -- 总销售额度
    ,indv_cust_lmt number(30,2) -- 个人客户额度
    ,selled_indv_lmt number(30,2) -- 已销售个人额度
    ,asigned_indv_lmt number(30,2) -- 已分配个人额度
    ,org_cust_lmt number(30,2) -- 机构客户额度
    ,selled_org_lmt number(30,2) -- 已销售机构额度
    ,asigned_org_lmt number(30,2) -- 已分配机构额度
    ,flexb_lmt number(30,2) -- 机动额度
    ,selled_indv_flexb_lmt number(30,2) -- 已销售个人机动额度
    ,selled_org_flexb_lmt number(30,2) -- 已销售机构机动额度
    ,asigned_flexb_lmt number(30,2) -- 已分配机动额度
    ,precon_lmt_uplmi number(30,2) -- 预约额度上限
    ,accu_precon_lmt number(30,2) -- 累积预约额度
    ,precon_buyed_lmt number(30,2) -- 预约已购买额度
    ,resv_lmt number(30,2) -- 保留额度
    ,asigned_resv_lmt number(30,2) -- 已分配保留额度
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_finc_prod_lmt_ctrl_h to ${icl_schema};
grant select on ${iml_schema}.prd_finc_prod_lmt_ctrl_h to ${idl_schema};
grant select on ${iml_schema}.prd_finc_prod_lmt_ctrl_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_finc_prod_lmt_ctrl_h is '理财产品额度控制历史';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.prod_id is '产品编号';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.org_id is '机构编号';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.finc_intnal_org_id is '理财内部机构编号';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.tot_sell_lmt is '总销售额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.indv_cust_lmt is '个人客户额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.selled_indv_lmt is '已销售个人额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.asigned_indv_lmt is '已分配个人额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.org_cust_lmt is '机构客户额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.selled_org_lmt is '已销售机构额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.asigned_org_lmt is '已分配机构额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.flexb_lmt is '机动额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.selled_indv_flexb_lmt is '已销售个人机动额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.selled_org_flexb_lmt is '已销售机构机动额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.asigned_flexb_lmt is '已分配机动额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.precon_lmt_uplmi is '预约额度上限';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.accu_precon_lmt is '累积预约额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.precon_buyed_lmt is '预约已购买额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.resv_lmt is '保留额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.asigned_resv_lmt is '已分配保留额度';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_finc_prod_lmt_ctrl_h.etl_timestamp is 'ETL处理时间戳';
