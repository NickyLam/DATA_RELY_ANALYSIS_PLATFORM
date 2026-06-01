/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_rela_ps_h
CreateDate: 20230404
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_rela_ps_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_rela_ps_h(
etl_dt date --数据日期
,sorc_sys_cd varchar2(10) --源系统代码
,rela_ps_rela_type_cd varchar2(30) --关联人关系类型代码
,rela_ps_join_work_tm date --关联人参加工作时间
,rela_ps_corp_phone varchar2(60) --关联人单位联系电话
,rela_ps_tel_num varchar2(60) --关联人电话号码
,rela_ps_corp_name varchar2(100) --关联人单位名称
,rela_ps_name varchar2(200) --关联人名称
,rela_ps_mobile_no varchar2(60) --关联人手机号码
,rela_ps_gender_cd varchar2(10) --关联人性别代码
,rela_ps_mon_inco number(30,2) --关联人月收入
,rela_ps_cert_no varchar2(60) --关联人证件号码
,rela_ps_cert_type_cd varchar2(30) --
,rela_ps_title_cd varchar2(10) --关联人职称代码
,rela_ps_post_cd varchar2(10) --关联人职务代码
,rela_ps_career_cd varchar2(10) --关联人职业代码
,cty_rg_cd varchar2(10) --国家和地区代码
,rela_ps_zip_cd varchar2(10) --关联人邮政编码
,seq_num varchar2(60) --序号
,spouse_is_have_work varchar2(10) --配偶是否有工作
,rela_ps_phys_addr varchar2(500) --关联人物理地址
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_party_rela_ps_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_rela_ps_h is '当事人关联人历史';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_rela_type_cd is '关联人关系类型代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_join_work_tm is '关联人参加工作时间';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_corp_phone is '关联人单位联系电话';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_tel_num is '关联人电话号码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_corp_name is '关联人单位名称';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_name is '关联人名称';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_mobile_no is '关联人手机号码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_gender_cd is '关联人性别代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_mon_inco is '关联人月收入';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_cert_no is '关联人证件号码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_cert_type_cd is '';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_title_cd is '关联人职称代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_post_cd is '关联人职务代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_career_cd is '关联人职业代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.cty_rg_cd is '国家和地区代码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_zip_cd is '关联人邮政编码';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.seq_num is '序号';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.spouse_is_have_work is '配偶是否有工作';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.rela_ps_phys_addr is '关联人物理地址';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_rela_ps_h.lp_id is '法人编号';

