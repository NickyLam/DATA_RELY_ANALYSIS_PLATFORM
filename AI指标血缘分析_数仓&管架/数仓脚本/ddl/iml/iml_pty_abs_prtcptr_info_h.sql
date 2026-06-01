/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_abs_prtcptr_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_abs_prtcptr_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_abs_prtcptr_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_abs_prtcptr_info_h(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,prtcptr_id varchar2(100) -- 参与方编号
    ,prtcptr_name varchar2(150) -- 参与方名称
    ,prtcptr_type_cd varchar2(30) -- 参与方类型代码
    ,acct_id varchar2(100) -- 账户编号
    ,acct_name varchar2(375) -- 账户名称
    ,open_bank_no varchar2(100) -- 开户行行号
    ,bigamt_bank_no varchar2(100) -- 大额行号
    ,bigamt_bank_name varchar2(150) -- 大额行名
    ,rela_ps_name varchar2(300) -- 关联人名称
    ,tel_num varchar2(60) -- 电话号码
    ,rgst_emply_id varchar2(100) -- 登记员工编号
    ,rgst_org_id varchar2(100) -- 登记机构编号
    ,rgst_dt date -- 登记日期
    ,modif_emply_id varchar2(100) -- 修改员工编号
    ,modif_org_id varchar2(100) -- 修改机构编号
    ,modif_dt date -- 修改日期
    ,ts_flg varchar2(10) -- 暂存标志
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
grant select on ${iml_schema}.pty_abs_prtcptr_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_abs_prtcptr_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_abs_prtcptr_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_abs_prtcptr_info_h is '资产证券化参与方信息历史';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.prtcptr_id is '参与方编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.prtcptr_name is '参与方名称';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.prtcptr_type_cd is '参与方类型代码';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.acct_id is '账户编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.acct_name is '账户名称';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.open_bank_no is '开户行行号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.bigamt_bank_no is '大额行号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.bigamt_bank_name is '大额行名';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.rela_ps_name is '关联人名称';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.tel_num is '电话号码';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.rgst_emply_id is '登记员工编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.rgst_org_id is '登记机构编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.rgst_dt is '登记日期';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.modif_emply_id is '修改员工编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.modif_org_id is '修改机构编号';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.modif_dt is '修改日期';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.ts_flg is '暂存标志';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_abs_prtcptr_info_h.etl_timestamp is 'ETL处理时间戳';
