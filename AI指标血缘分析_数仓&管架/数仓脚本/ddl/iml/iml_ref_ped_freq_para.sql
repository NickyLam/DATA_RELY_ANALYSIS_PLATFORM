/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ref_ped_freq_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ref_ped_freq_para
whenever sqlerror continue none;
drop table ${iml_schema}.ref_ped_freq_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_ped_freq_para(
    lp_id varchar2(100) -- 法人编号
    ,ped_freq_cd varchar2(30) -- 周期频率代码
    ,ped_freq_descb varchar2(500) -- 周期频率描述
    ,holiday_defer_flg varchar2(10) -- 节假日顺延标志
    ,eh_issue_qtty number(30) -- 每期数量
    ,eh_issue_corp_cd varchar2(30) -- 每期单位代码
    ,eh_issue_days number(10) -- 每期天数
    ,tenor_corp_val number(10) -- 期限单位值
    ,tm_bg_or_term_end_flg_cd varchar2(30) -- 期初或期末标志代码
    ,half_mon_flg varchar2(10) -- 半月标志
    ,cust_flo_val number(18,6) -- 客户浮动值
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
grant select on ${iml_schema}.ref_ped_freq_para to ${icl_schema};
grant select on ${iml_schema}.ref_ped_freq_para to ${idl_schema};
grant select on ${iml_schema}.ref_ped_freq_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.ref_ped_freq_para is '周期频率参数表';
comment on column ${iml_schema}.ref_ped_freq_para.lp_id is '法人编号';
comment on column ${iml_schema}.ref_ped_freq_para.ped_freq_cd is '周期频率代码';
comment on column ${iml_schema}.ref_ped_freq_para.ped_freq_descb is '周期频率描述';
comment on column ${iml_schema}.ref_ped_freq_para.holiday_defer_flg is '节假日顺延标志';
comment on column ${iml_schema}.ref_ped_freq_para.eh_issue_qtty is '每期数量';
comment on column ${iml_schema}.ref_ped_freq_para.eh_issue_corp_cd is '每期单位代码';
comment on column ${iml_schema}.ref_ped_freq_para.eh_issue_days is '每期天数';
comment on column ${iml_schema}.ref_ped_freq_para.tenor_corp_val is '期限单位值';
comment on column ${iml_schema}.ref_ped_freq_para.tm_bg_or_term_end_flg_cd is '期初或期末标志代码';
comment on column ${iml_schema}.ref_ped_freq_para.half_mon_flg is '半月标志';
comment on column ${iml_schema}.ref_ped_freq_para.cust_flo_val is '客户浮动值';
comment on column ${iml_schema}.ref_ped_freq_para.start_dt is '开始时间';
comment on column ${iml_schema}.ref_ped_freq_para.end_dt is '结束时间';
comment on column ${iml_schema}.ref_ped_freq_para.id_mark is '增删标志';
comment on column ${iml_schema}.ref_ped_freq_para.src_table_name is '源表名称';
comment on column ${iml_schema}.ref_ped_freq_para.job_cd is '任务编码';
comment on column ${iml_schema}.ref_ped_freq_para.etl_timestamp is 'ETL处理时间戳';
