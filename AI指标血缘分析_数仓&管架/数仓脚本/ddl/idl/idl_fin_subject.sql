/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl fin_subject
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.fin_subject
whenever sqlerror continue none;
drop table ${idl_schema}.fin_subject purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.fin_subject(
    etl_dt date -- 数据日期   
    ,subject_id varchar2(60) -- 科目编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,subj_name varchar2(200) -- 科目名称   
    ,super_subject_id varchar2(60) -- 上级科目编号   
    ,subj_type_cd varchar2(10) -- 科目类型代码   
    ,subj_lev_cd varchar2(10) -- 科目级别代码   
    ,subj_char_cd varchar2(10) -- 科目性质代码   
    ,effect_flg varchar2(10) -- 生效标志   
    ,dtl_subj_flg varchar2(10) -- 明细科目标志   
    ,subj_dir_cd varchar2(30) -- 科目方向代码   
    ,in_out_tab_flg varchar2(10) -- 表内外标志   
    ,allow_od_flg varchar2(10) -- 允许透支标志   
    ,bal_char_cd varchar2(30) -- 余额性质代码   
    ,subj_src_cls_cd varchar2(30) -- 科目来源分类代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.fin_subject to ${iel_schema};

-- comment
comment on table ${idl_schema}.fin_subject is '科目';
comment on column ${idl_schema}.fin_subject.etl_dt is '数据日期';
comment on column ${idl_schema}.fin_subject.subject_id is '科目编号';
comment on column ${idl_schema}.fin_subject.lp_id is '法人编号';
comment on column ${idl_schema}.fin_subject.subj_name is '科目名称';
comment on column ${idl_schema}.fin_subject.super_subject_id is '上级科目编号';
comment on column ${idl_schema}.fin_subject.subj_type_cd is '科目类型代码';
comment on column ${idl_schema}.fin_subject.subj_lev_cd is '科目级别代码';
comment on column ${idl_schema}.fin_subject.subj_char_cd is '科目性质代码';
comment on column ${idl_schema}.fin_subject.effect_flg is '生效标志';
comment on column ${idl_schema}.fin_subject.dtl_subj_flg is '明细科目标志';
comment on column ${idl_schema}.fin_subject.subj_dir_cd is '科目方向代码';
comment on column ${idl_schema}.fin_subject.in_out_tab_flg is '表内外标志';
comment on column ${idl_schema}.fin_subject.allow_od_flg is '允许透支标志';
comment on column ${idl_schema}.fin_subject.bal_char_cd is '余额性质代码';
comment on column ${idl_schema}.fin_subject.subj_src_cls_cd is '科目来源分类代码';
comment on column ${idl_schema}.fin_subject.create_dt is '创建日期';
comment on column ${idl_schema}.fin_subject.update_dt is '更新日期';
comment on column ${idl_schema}.fin_subject.id_mark is '删除标识';