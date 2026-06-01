/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_fkd_vehic_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_fkd_vehic_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_fkd_vehic_info(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,bus_flow_num varchar2(60) --业务流水号
,vehic_model varchar2(60) --车辆型号
,vehic_price number(30,2) --车辆价格
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,asset_id varchar2(60) --资产编号
,vehic_list_id varchar2(60) --车辆列表编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ast_fkd_vehic_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_fkd_vehic_info is '房快贷车辆信息';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.vehic_model is '车辆型号';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.vehic_price is '车辆价格';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_fkd_vehic_info.vehic_list_id is '车辆列表编号';

