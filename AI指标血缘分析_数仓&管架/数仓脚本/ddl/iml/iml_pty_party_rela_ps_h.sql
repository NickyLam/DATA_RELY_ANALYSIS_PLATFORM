/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_party_rela_ps_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_party_rela_ps_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_party_rela_ps_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_rela_ps_h(
    party_id varchar2(60) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_cd varchar2(10) -- 源系统代码
    ,rela_ps_rela_type_cd varchar2(30) -- 关联人关系类型代码
    ,rela_ps_join_work_tm date -- 关联人参加工作时间
    ,rela_ps_corp_phone varchar2(90) -- 关联人单位联系电话
    ,rela_ps_tel_num varchar2(60) -- 关联人电话号码
    ,rela_ps_corp_name varchar2(150) -- 关联人单位名称
    ,rela_ps_name varchar2(300) -- 关联人名称
    ,rela_ps_mobile_no varchar2(60) -- 关联人手机号码
    ,rela_ps_gender_cd varchar2(10) -- 关联人性别代码
    ,rela_ps_mon_inco number(30,2) -- 关联人月收入
    ,rela_ps_cert_no varchar2(60) -- 关联人证件号码
    ,rela_ps_cert_type_cd varchar2(30) -- 关联人证件类型代码
    ,rela_ps_title_cd varchar2(10) -- 关联人职称代码
    ,rela_ps_post_cd varchar2(10) -- 关联人职务代码
    ,rela_ps_career_cd varchar2(10) -- 关联人职业代码
    ,cty_rg_cd varchar2(10) -- 国家和地区代码
    ,rela_ps_zip_cd varchar2(15) -- 关联人邮政编码
    ,seq_num varchar2(60) -- 序号
    ,spouse_is_have_work varchar2(15) -- 配偶是否有工作
    ,rela_ps_phys_addr varchar2(750) -- 关联人物理地址
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
grant select on ${iml_schema}.pty_party_rela_ps_h to ${icl_schema};
grant select on ${iml_schema}.pty_party_rela_ps_h to ${idl_schema};
grant select on ${iml_schema}.pty_party_rela_ps_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_party_rela_ps_h is '当事人关联人历史';
comment on column ${iml_schema}.pty_party_rela_ps_h.party_id is '当事人编号';
comment on column ${iml_schema}.pty_party_rela_ps_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_party_rela_ps_h.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_rela_type_cd is '关联人关系类型代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_join_work_tm is '关联人参加工作时间';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_corp_phone is '关联人单位联系电话';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_tel_num is '关联人电话号码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_corp_name is '关联人单位名称';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_name is '关联人名称';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_mobile_no is '关联人手机号码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_gender_cd is '关联人性别代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_mon_inco is '关联人月收入';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_cert_no is '关联人证件号码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_cert_type_cd is '关联人证件类型代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_title_cd is '关联人职称代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_post_cd is '关联人职务代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_career_cd is '关联人职业代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.cty_rg_cd is '国家和地区代码';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_zip_cd is '关联人邮政编码';
comment on column ${iml_schema}.pty_party_rela_ps_h.seq_num is '序号';
comment on column ${iml_schema}.pty_party_rela_ps_h.spouse_is_have_work is '配偶是否有工作';
comment on column ${iml_schema}.pty_party_rela_ps_h.rela_ps_phys_addr is '关联人物理地址';
comment on column ${iml_schema}.pty_party_rela_ps_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_party_rela_ps_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_party_rela_ps_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_party_rela_ps_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_party_rela_ps_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_party_rela_ps_h.etl_timestamp is 'ETL处理时间戳';
