/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_cont_guar_cont_rela_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_cont_guar_cont_rela_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_cont_guar_cont_rela_h(
etl_dt date --数据日期
,cont_id varchar2(100) --合同编号
,guar_cont_id varchar2(60) --担保合同编号
,guar_type_cd varchar2(10) --担保类型代码
,guar_amt number(30,2) --担保金额
,guar_curr_cd varchar2(10) --担保币种代码
,src_sys_cd varchar2(10) --来源系统代码
,strip_line_cd varchar2(10) --条线代码
,pri_contr_type_cd varchar2(10) --主合同类型代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(100) --协议编号
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
grant select on ${idl_schema}.oass_agt_cont_guar_cont_rela_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_cont_guar_cont_rela_h is '合同与担保合同关系历史';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.cont_id is '合同编号';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.guar_cont_id is '担保合同编号';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.guar_type_cd is '担保类型代码';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.guar_amt is '担保金额';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.guar_curr_cd is '担保币种代码';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.src_sys_cd is '来源系统代码';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.strip_line_cd is '条线代码';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.pri_contr_type_cd is '主合同类型代码';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_cont_guar_cont_rela_h.lp_id is '法人编号';

