/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_cpes_provi_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_cpes_provi_dtl
whenever sqlerror continue none;
drop table ${iml_schema}.evt_cpes_provi_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cpes_provi_dtl(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,provi_dtl_id varchar2(60) -- 计提明细编号
    ,provi_mtbl_id varchar2(60) -- 计提主表编号
    ,provi_entry_id varchar2(60) -- 计提记账编号
    ,bill_id varchar2(60) -- 票据编号
    ,td_provi_int number(30,2) -- 当日计提利息
    ,entry_sucs_flg varchar2(10) -- 记账成功标志
    ,entry_dt date -- 记账日期
    ,org_id varchar2(60) -- 机构编号
    ,bus_prod_id varchar2(60) -- 业务产品编号
    ,int_income_subj_id varchar2(100) -- 利息收入科目编号
    ,provi_post_subj_id varchar2(100) -- 计提后科目编号
    ,sys_track_no varchar2(100) -- 系统跟踪号
    ,provi_type_cd varchar2(60) -- 计提类型代码
    ,bill_sub_intrv_id varchar2(60) -- 票据子区间号
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
grant select on ${iml_schema}.evt_cpes_provi_dtl to ${icl_schema};
grant select on ${iml_schema}.evt_cpes_provi_dtl to ${idl_schema};
grant select on ${iml_schema}.evt_cpes_provi_dtl to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_cpes_provi_dtl is '票交所计提明细事件';
comment on column ${iml_schema}.evt_cpes_provi_dtl.evt_id is '事件编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.lp_id is '法人编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.provi_dtl_id is '计提明细编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.provi_mtbl_id is '计提主表编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.provi_entry_id is '计提记账编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.bill_id is '票据编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.td_provi_int is '当日计提利息';
comment on column ${iml_schema}.evt_cpes_provi_dtl.entry_sucs_flg is '记账成功标志';
comment on column ${iml_schema}.evt_cpes_provi_dtl.entry_dt is '记账日期';
comment on column ${iml_schema}.evt_cpes_provi_dtl.org_id is '机构编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.bus_prod_id is '业务产品编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.int_income_subj_id is '利息收入科目编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.provi_post_subj_id is '计提后科目编号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.sys_track_no is '系统跟踪号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.provi_type_cd is '计提类型代码';
comment on column ${iml_schema}.evt_cpes_provi_dtl.bill_sub_intrv_id is '票据子区间号';
comment on column ${iml_schema}.evt_cpes_provi_dtl.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_cpes_provi_dtl.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_cpes_provi_dtl.job_cd is '任务编码';
comment on column ${iml_schema}.evt_cpes_provi_dtl.etl_timestamp is 'ETL处理时间戳';
