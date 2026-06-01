/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_guar_cont_guar_rela_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_guar_cont_guar_rela_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_guar_cont_guar_rela_h(
etl_dt date --数据日期
,obj_type_name varchar2(500) --对象类型名称
,obj_id varchar2(100) --对象编号
,guar_id varchar2(100) --担保物编号
,guar_cont_id varchar2(100) --担保合同编号
,rela_status_cd varchar2(30) --关联状态代码
,rgst_org_id varchar2(200) --登记机构编号
,rgst_teller_id varchar2(100) --登记柜员编号
,rgst_dt date --登记日期
,update_org_id varchar2(200) --更新机构编号
,update_teller_id varchar2(100) --更新柜员编号
,modif_dt date --变更日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,asset_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_guar_cont_guar_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_guar_cont_guar_rela_h is '担保合同担保物关系历史';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.obj_type_name is '对象类型名称';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.obj_id is '对象编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.guar_id is '担保物编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.guar_cont_id is '担保合同编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.rela_status_cd is '关联状态代码';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.rgst_org_id is '登记机构编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.rgst_teller_id is '登记柜员编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.rgst_dt is '登记日期';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.update_org_id is '更新机构编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.update_teller_id is '更新柜员编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.modif_dt is '变更日期';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.asset_id is '协议编号';
comment on column ${idl_schema}.oass_agt_guar_cont_guar_rela_h.lp_id is '法人编号';

