/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_redcst_ctr_nt_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_redcst_ctr_nt_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_redcst_ctr_nt_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_redcst_ctr_nt_info_h(
    agt_id varchar2(100) -- 协议编号
    ,lp_id varchar2(60) -- 法人编号
    ,ctr_nt_ser_num varchar2(60) -- 成交单序列号
    ,ctr_nt_id varchar2(60) -- 成交单编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,quot_bill_id varchar2(60) -- 报价单编号
    ,redcst_batch_id varchar2(60) -- 再贴现批次编号
    ,bag_way_cd varchar2(30) -- 成交方式代码
    ,tra_dt date -- 成交日期
    ,bag_tm timestamp -- 成交时间
    ,bag_status_cd varchar2(30) -- 成交状态代码
    ,clear_status_cd varchar2(30) -- 清算状态代码
    ,exp_stl_status_cd varchar2(30) -- 到期结算状态代码
    ,apv_rest_cd varchar2(30) -- 审批结果代码
    ,org_cd varchar2(60) -- 机构代码
    ,prod_id varchar2(60) -- 产品编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,pbc_org_cd varchar2(60) -- 人行机构代码
    ,quot_bill_status_cd varchar2(30) -- 报价单状态代码
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
grant select on ${iml_schema}.agt_redcst_ctr_nt_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_redcst_ctr_nt_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_redcst_ctr_nt_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_redcst_ctr_nt_info_h is '再贴现成交单信息历史';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.ctr_nt_ser_num is '成交单序列号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.ctr_nt_id is '成交单编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.quot_bill_id is '报价单编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.redcst_batch_id is '再贴现批次编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.bag_way_cd is '成交方式代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.tra_dt is '成交日期';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.bag_tm is '成交时间';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.bag_status_cd is '成交状态代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.clear_status_cd is '清算状态代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.exp_stl_status_cd is '到期结算状态代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.apv_rest_cd is '审批结果代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.org_cd is '机构代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.prod_id is '产品编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.pbc_org_cd is '人行机构代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.quot_bill_status_cd is '报价单状态代码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_redcst_ctr_nt_info_h.etl_timestamp is 'ETL处理时间戳';
