/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_estat_avg_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_estat_avg_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_estat_avg_info(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,local_prov_cd varchar2(60) --所在省代码
,local_city_cd varchar2(60) --所在市代码
,local_rg_cd varchar2(60) --所在区代码
,estat_name varchar2(100) --楼盘名称
,ext_estim_price number(30,2) --外部评估价格
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,batch_dt varchar2(30) --批次日期
,estat_id varchar2(60) --楼盘编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_estat_avg_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_estat_avg_info is '楼盘均价信息';
comment on column ${idl_schema}.oass_ast_estat_avg_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_estat_avg_info.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ast_estat_avg_info.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.oass_ast_estat_avg_info.local_city_cd is '所在市代码';
comment on column ${idl_schema}.oass_ast_estat_avg_info.local_rg_cd is '所在区代码';
comment on column ${idl_schema}.oass_ast_estat_avg_info.estat_name is '楼盘名称';
comment on column ${idl_schema}.oass_ast_estat_avg_info.ext_estim_price is '外部评估价格';
comment on column ${idl_schema}.oass_ast_estat_avg_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_estat_avg_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_estat_avg_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_estat_avg_info.batch_dt is '批次日期';
comment on column ${idl_schema}.oass_ast_estat_avg_info.estat_id is '楼盘编号';

