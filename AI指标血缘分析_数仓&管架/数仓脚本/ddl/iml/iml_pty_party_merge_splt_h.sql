/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_merge_splt_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_merge_splt_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_merge_splt_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_merge_splt_h(
    seq_num varchar2(60) -- 序号
    ,lp_id varchar2(60) -- 法人编号
    ,party_id varchar2(100) -- 当事人编号
    ,merged_party_id varchar2(100) -- 被归并方当事人编号
    ,merge_status_cd varchar2(30) -- 归并状态代码
    ,merge_dt date -- 归并日期
    ,merge_org_id varchar2(100) -- 归并机构编号
    ,merge_teller_id varchar2(100) -- 归并柜员编号
    ,splt_dt date -- 拆分日期
    ,splt_org_id varchar2(100) -- 拆分机构编号
    ,splt_teller_id varchar2(100) -- 拆分柜员编号
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
grant select on ${iml_schema}.pty_party_merge_splt_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_merge_splt_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_merge_splt_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_merge_splt_h is '当事人归并拆分历史';
comment on column ${iml_schema}.pty_party_merge_splt_h.seq_num is '序号';
comment on column ${iml_schema}.pty_party_merge_splt_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.merged_party_id is '被归并方当事人编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.merge_status_cd is '归并状态代码';
comment on column ${iml_schema}.pty_party_merge_splt_h.merge_dt is '归并日期';
comment on column ${iml_schema}.pty_party_merge_splt_h.merge_org_id is '归并机构编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.merge_teller_id is '归并柜员编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.splt_dt is '拆分日期';
comment on column ${iml_schema}.pty_party_merge_splt_h.splt_org_id is '拆分机构编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.splt_teller_id is '拆分柜员编号';
comment on column ${iml_schema}.pty_party_merge_splt_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_merge_splt_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_merge_splt_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_merge_splt_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_merge_splt_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_merge_splt_h.etl_timestamp is 'ETL处理时间戳';
