/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_rela_party_non_nature_ps_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_rela_party_non_nature_ps_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_rela_party_non_nature_ps_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_rela_party_non_nature_ps_info_h(
    rela_party_id varchar2(60) -- 关联方编号
    ,lp_id varchar2(60) -- 法人编号
    ,corp_name varchar2(250) -- 单位名称
    ,corp_cert_no_1 varchar2(100) -- 对公证件号码1
    ,corp_cert_no_2 varchar2(100) -- 对公证件号码2
    ,pos_or_incid_rela_descb varchar2(60) -- 担任职务或关联关系描述
    ,corp_belong_corp_group_name varchar2(100) -- 单位所属企业集团名称
    ,share_ratio varchar2(250) -- 持股比例
    ,remark varchar2(500) -- 备注
    ,final_update_tm timestamp -- 最后更新时间
    ,final_update_affair_tm timestamp -- 最后更新事务时间
    ,create_tm timestamp -- 创建时间
    ,create_affair_tm timestamp -- 创建事务时间
    ,belong_org_id varchar2(100) -- 归属机构编号
    ,matn_org_id varchar2(100) -- 维护机构编号
    ,belong_org_cd varchar2(100) -- 所属机构代码
    ,corp_cert_type_cd_1 varchar2(100) -- 对公证件类型代码1
    ,corp_cert_type_cd_2 varchar2(100) -- 对公证件类型代码2
    ,dom_overs_flg_1 varchar2(60) -- 境内外标志1
    ,dom_overs_flg_2 varchar2(60) -- 境内外标志2
    ,shard_or_rela_party_type_cd varchar2(60) -- 股东或关联方类型代码
    ,shard_or_rela_party_bl_induty_cd varchar2(60) -- 股东或关联方所属行业代码
    ,shard_or_rela_party_rgst varchar2(500) -- 股东或关联方注册地
    ,shard_or_rela_party_rela_type_cd varchar2(60) -- 股东或关联方关系类型代码
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
grant select on ${iml_schema}.pty_rela_party_non_nature_ps_info_h to ${icl_schema};
grant select on ${iml_schema}.pty_rela_party_non_nature_ps_info_h to ${idl_schema};
grant select on ${iml_schema}.pty_rela_party_non_nature_ps_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_rela_party_non_nature_ps_info_h is '关联方非自然人信息历史';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.rela_party_id is '关联方编号';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_name is '单位名称';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_cert_no_1 is '对公证件号码1';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_cert_no_2 is '对公证件号码2';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.pos_or_incid_rela_descb is '担任职务或关联关系描述';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_belong_corp_group_name is '单位所属企业集团名称';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.share_ratio is '持股比例';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.remark is '备注';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.final_update_tm is '最后更新时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.final_update_affair_tm is '最后更新事务时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.create_tm is '创建时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.create_affair_tm is '创建事务时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.belong_org_id is '归属机构编号';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.matn_org_id is '维护机构编号';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.belong_org_cd is '所属机构代码';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_cert_type_cd_1 is '对公证件类型代码1';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.corp_cert_type_cd_2 is '对公证件类型代码2';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.dom_overs_flg_1 is '境内外标志1';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.dom_overs_flg_2 is '境内外标志2';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.shard_or_rela_party_type_cd is '股东或关联方类型代码';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.shard_or_rela_party_bl_induty_cd is '股东或关联方所属行业代码';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.shard_or_rela_party_rgst is '股东或关联方注册地';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.shard_or_rela_party_rela_type_cd is '股东或关联方关系类型代码';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_rela_party_non_nature_ps_info_h.etl_timestamp is 'ETL处理时间戳';
