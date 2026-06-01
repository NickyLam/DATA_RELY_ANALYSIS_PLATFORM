/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ref_emply_post_para
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ref_emply_post_para purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ref_emply_post_para(
etl_dt date --ETL处理日期
,post_name varchar2(100) --职务名称
,post_cate_id varchar2(60) --职务类别编号
,start_use_status_flg varchar2(10) --启用状态标志
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,post_id varchar2(60) --职务编号
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
grant select on ${idl_schema}.oass_ref_emply_post_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ref_emply_post_para is '员工职务参数';
comment on column ${idl_schema}.oass_ref_emply_post_para.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_ref_emply_post_para.post_name is '职务名称';
comment on column ${idl_schema}.oass_ref_emply_post_para.post_cate_id is '职务类别编号';
comment on column ${idl_schema}.oass_ref_emply_post_para.start_use_status_flg is '启用状态标志';
comment on column ${idl_schema}.oass_ref_emply_post_para.create_dt is '创建日期';
comment on column ${idl_schema}.oass_ref_emply_post_para.update_dt is '更新日期';
comment on column ${idl_schema}.oass_ref_emply_post_para.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ref_emply_post_para.post_id is '职务编号';
comment on column ${idl_schema}.oass_ref_emply_post_para.lp_id is '法人编号';

