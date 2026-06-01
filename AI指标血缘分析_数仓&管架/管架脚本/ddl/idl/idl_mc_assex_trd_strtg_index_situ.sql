/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_assex_trd_strtg_index_situ
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_assex_trd_strtg_index_situ
whenever sqlerror continue none;
drop table ${idl_schema}.mc_assex_trd_strtg_index_situ purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_assex_trd_strtg_index_situ(
    seq_num number -- 序号
    ,index_no varchar2(150) -- 指标编号
    ,index_name varchar2(150) -- 指标名称
    ,org_no varchar2(150) -- 机构编号
    ,org_name varchar2(150) -- 机构名称
    ,label_key varchar2(150) -- 标签键
    ,label_key_desc varchar2(150) -- 标签键描述
    ,label_value varchar2(4000) -- 标签值
	,unit varchar2(150) -- 单位
    ,sort_flg varchar2(150) -- 排序标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd')),
	partition p_20250131 values (to_date('20250131','yyyymmdd')),
	partition p_20250228 values (to_date('20250228','yyyymmdd')),
	partition p_20250331 values (to_date('20250331','yyyymmdd')),
	partition p_20250430 values (to_date('20250430','yyyymmdd')),
	partition p_20250531 values (to_date('20250531','yyyymmdd')),
	partition p_20250630 values (to_date('20250630','yyyymmdd')),
	partition p_20250731 values (to_date('20250731','yyyymmdd')),
	partition p_20250831 values (to_date('20250831','yyyymmdd')),
	partition p_20250930 values (to_date('20250930','yyyymmdd')),
	partition p_20251031 values (to_date('20251031','yyyymmdd')),
	partition p_20251130 values (to_date('20251130','yyyymmdd')),
	partition p_20251231 values (to_date('20251231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mc_assex_trd_strtg_index_situ to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_assex_trd_strtg_index_situ is '考核模块三化指标情况';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.seq_num is '序号';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.index_no is '指标编号';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.index_name is '指标名称';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.org_no is '机构编号';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.org_name is '机构名称';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.label_key is '标签键';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.label_key_desc is '标签键描述';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.label_value is '标签值';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.unit is '单位';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.sort_flg is '排序标志';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_assex_trd_strtg_index_situ.etl_timestamp is 'ETL处理时间戳';