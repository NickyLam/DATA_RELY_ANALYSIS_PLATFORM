/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_fin_stat_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_fin_stat_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_fin_stat_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_fin_stat_h(
    party_id varchar2(60) -- 当事人编号
    ,rec_id varchar2(60) -- 记录编号
    ,lp_id varchar2(60) -- 法人编号
    ,rept_curr_cd varchar2(10) -- 报表币种代码
    ,rept_corp_cd varchar2(30) -- 报表单位代码
    ,rept_cali_type_cd varchar2(30) -- 报表口径类型代码
    ,rept_dt date -- 财务报表日期
    ,rept_ped_cd varchar2(30) -- 报表周期代码
    ,rept_note varchar2(500) -- 报表注释
    ,rept_status_cd varchar2(30) -- 报表状态代码
    ,rgst_org_id varchar2(60) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,rgst_user_id varchar2(60) -- 登记用户编号
    ,audit_flg varchar2(10) -- 审计标志
    ,audit_corp varchar2(500) -- 审计单位名称
    ,audit_opinion varchar2(1000) -- 审计意见
    ,fin_rept_type_cd varchar2(100) -- 财报类型代码
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
grant select on ${iml_schema}.pty_party_fin_stat_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_fin_stat_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_fin_stat_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_fin_stat_h is '当事人财务报表历史';
comment on column ${iml_schema}.pty_party_fin_stat_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_fin_stat_h.rec_id is '记录编号';
comment on column ${iml_schema}.pty_party_fin_stat_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_curr_cd is '报表币种代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_corp_cd is '报表单位代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_cali_type_cd is '报表口径类型代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_dt is '财务报表日期';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_ped_cd is '报表周期代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_note is '报表注释';
comment on column ${iml_schema}.pty_party_fin_stat_h.rept_status_cd is '报表状态代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_party_fin_stat_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_party_fin_stat_h.rgst_user_id is '登记用户编号';
comment on column ${iml_schema}.pty_party_fin_stat_h.audit_flg is '审计标志';
comment on column ${iml_schema}.pty_party_fin_stat_h.audit_corp is '审计单位名称';
comment on column ${iml_schema}.pty_party_fin_stat_h.audit_opinion is '审计意见';
comment on column ${iml_schema}.pty_party_fin_stat_h.fin_rept_type_cd is '财报类型代码';
comment on column ${iml_schema}.pty_party_fin_stat_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_fin_stat_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_fin_stat_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_fin_stat_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_fin_stat_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_fin_stat_h.etl_timestamp is 'ETL处理时间戳';
