/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_crdt_apv_rest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_crdt_apv_rest
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_crdt_apv_rest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_crdt_apv_rest(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(60) -- 序列号
    ,batch_doc_name varchar2(150) -- 批量文件名称
    ,apv_dt date -- 审批日期
    ,bank_id varchar2(60) -- 银行编号
    ,final_apv_rest varchar2(150) -- 最终审批结果
    ,co_bk_apv_rest varchar2(150) -- 合作行审批结果
    ,co_bk_g_room_apv_rest varchar2(150) -- 合作行机房审批结果
    ,psz_rg_apv_rest varchar2(150) -- Psz区审批结果
    ,refuse_cd varchar2(250) -- 拒绝代码
    ,fst_deb_flg varchar2(10) -- 首借标志
    ,flow_num varchar2(60) -- 流水号
    ,score_val varchar2(375) -- 评分分值
    ,etl_dt date -- ETL处理日期
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
grant select on ${iml_schema}.evt_wld_crdt_apv_rest to ${icl_schema};
grant select on ${iml_schema}.evt_wld_crdt_apv_rest to ${idl_schema};
grant select on ${iml_schema}.evt_wld_crdt_apv_rest to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_crdt_apv_rest is '微粒贷授信审批结果事件';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.ser_num is '序列号';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.apv_dt is '审批日期';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.bank_id is '银行编号';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.final_apv_rest is '最终审批结果';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.co_bk_apv_rest is '合作行审批结果';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.co_bk_g_room_apv_rest is '合作行机房审批结果';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.psz_rg_apv_rest is 'Psz区审批结果';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.refuse_cd is '拒绝代码';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.fst_deb_flg is '首借标志';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.flow_num is '流水号';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.score_val is '评分分值';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_crdt_apv_rest.etl_timestamp is 'ETL处理时间戳';
