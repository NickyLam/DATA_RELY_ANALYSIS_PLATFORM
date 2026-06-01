/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ph_soc_cfm_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ph_soc_cfm_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ph_soc_cfm_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ph_soc_cfm_evt(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,dubil_id varchar2(100) -- 借据编号
    ,input_dt date -- 录入日期
    ,crdt_appl_id varchar2(100) -- 授信申请编号
    ,chn_src varchar2(100) -- 渠道来源
    ,cfm_dt date -- 确认日期
    ,tot_soc_amt number(30,2) -- 总理赔金额
    ,guar_soc_amt number(30,2) -- 担保理赔金额
    ,pa_insure_soc_amt number(30,2) -- 产险理赔金额
    ,gr_insure_soc_amt number(30,2) -- 国任理赔金额
    ,stud_loan_prod_id varchar2(100) -- 助贷产品编号
    ,remark varchar2(1000) -- 备注
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
grant select on ${iml_schema}.evt_ph_soc_cfm_evt to ${icl_schema};
grant select on ${iml_schema}.evt_ph_soc_cfm_evt to ${idl_schema};
grant select on ${iml_schema}.evt_ph_soc_cfm_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ph_soc_cfm_evt is '平安普惠理赔确认事件';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.input_dt is '录入日期';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.crdt_appl_id is '授信申请编号';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.chn_src is '渠道来源';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.cfm_dt is '确认日期';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.tot_soc_amt is '总理赔金额';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.guar_soc_amt is '担保理赔金额';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.pa_insure_soc_amt is '产险理赔金额';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.gr_insure_soc_amt is '国任理赔金额';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.stud_loan_prod_id is '助贷产品编号';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.remark is '备注';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ph_soc_cfm_evt.etl_timestamp is 'ETL处理时间戳';
