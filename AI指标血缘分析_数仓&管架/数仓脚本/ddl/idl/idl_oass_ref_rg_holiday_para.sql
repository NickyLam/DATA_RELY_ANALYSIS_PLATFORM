/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ref_rg_holiday_para
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ref_rg_holiday_para purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ref_rg_holiday_para(
etl_dt date --数据日期
,local_cty_rg_cd varchar2(30) --所在国家和地区代码
,local_prov_cd varchar2(30) --所在省代码
,holiday_dt date --假日日期
,holiday_type_descb varchar2(500) --假日类型描述
,wd_flg varchar2(10) --工作日标志
,fit_range_cd varchar2(30) --适用范围代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,lp_id varchar2(100) --法人编号
,holiday_type_cd varchar2(30) --假日类型代码

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_ref_rg_holiday_para to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ref_rg_holiday_para is '地区节假日参数';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.local_cty_rg_cd is '所在国家和地区代码';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.local_prov_cd is '所在省代码';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.holiday_dt is '假日日期';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.holiday_type_descb is '假日类型描述';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.wd_flg is '工作日标志';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.fit_range_cd is '适用范围代码';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.lp_id is '法人编号';
comment on column ${idl_schema}.oass_ref_rg_holiday_para.holiday_type_cd is '假日类型代码';

