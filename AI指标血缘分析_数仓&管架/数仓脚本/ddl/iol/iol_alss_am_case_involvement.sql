/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_case_involvement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_case_involvement
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_case_involvement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_case_involvement(
    input_date varchar2(180) -- 通报日期
    ,case_typ varchar2(180) -- 案件类型
    ,sfip_date varchar2(180) -- 首笔涉案日
    ,involved_amount varchar2(180) -- 涉案金额
    ,whether_pre_control varchar2(180) -- 是否提前管控
    ,victim varchar2(180) -- 受害人
    ,fpsi_pft_date varchar2(180) -- 首次公安止付时间
    ,aum_m_avg_bal varchar2(180) -- AUM月均值（涉案前）
    ,facm_date varchar2(180) -- 首笔自主管控时间（当前有效）
    ,after_calc_day_lmt varchar2(180) -- 日限额（涉案前）
    ,froa_date varchar2(180) -- 首次风险单预警日
    ,data_release_id varchar2(180) -- 发布数据主键
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.alss_am_case_involvement to ${iml_schema};
grant select on ${iol_schema}.alss_am_case_involvement to ${icl_schema};
grant select on ${iol_schema}.alss_am_case_involvement to ${idl_schema};
grant select on ${iol_schema}.alss_am_case_involvement to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_case_involvement is '';
comment on column ${iol_schema}.alss_am_case_involvement.input_date is '通报日期';
comment on column ${iol_schema}.alss_am_case_involvement.case_typ is '案件类型';
comment on column ${iol_schema}.alss_am_case_involvement.sfip_date is '首笔涉案日';
comment on column ${iol_schema}.alss_am_case_involvement.involved_amount is '涉案金额';
comment on column ${iol_schema}.alss_am_case_involvement.whether_pre_control is '是否提前管控';
comment on column ${iol_schema}.alss_am_case_involvement.victim is '受害人';
comment on column ${iol_schema}.alss_am_case_involvement.fpsi_pft_date is '首次公安止付时间';
comment on column ${iol_schema}.alss_am_case_involvement.aum_m_avg_bal is 'AUM月均值（涉案前）';
comment on column ${iol_schema}.alss_am_case_involvement.facm_date is '首笔自主管控时间（当前有效）';
comment on column ${iol_schema}.alss_am_case_involvement.after_calc_day_lmt is '日限额（涉案前）';
comment on column ${iol_schema}.alss_am_case_involvement.froa_date is '首次风险单预警日';
comment on column ${iol_schema}.alss_am_case_involvement.data_release_id is '发布数据主键';
comment on column ${iol_schema}.alss_am_case_involvement.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_case_involvement.etl_timestamp is 'ETL处理时间戳';
