/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_kpi_asses_scor_jg_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_kpi_asses_scor_jg_dtl
whenever sqlerror continue none;
drop table ${idl_schema}.mc_kpi_asses_scor_jg_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_kpi_asses_scor_jg_dtl(
    stat_dt varchar2(200) -- 统计日期
    ,sup_org_no varchar2(200) -- 上级机构编号
    ,org_no varchar2(200) -- 机构编号
    ,org_name varchar2(200) -- 机构名称
    ,prop_id varchar2(20) -- 方案编号
    ,prop_name varchar2(100) -- 方案名称
    ,ind_name varchar2(200) -- 指标名称
    ,sup_ind_seq varchar2(30) -- 上级指标序号
    ,sup_ind_name varchar2(200) -- 上级指标名称
    ,std_scor number(12,6) -- 标准得分
    ,scor_uplmi number(25,4) -- 得分上限
    ,scor_lolmi number(25,4) -- 得分下限
    ,year_target_val number(25,4) -- 年度目标值
    ,tm_prog_val number(25,4) -- 时间进度值
    ,base_val number(25,4) -- 基数
    ,ind_val number(25,4) -- 指标值
    ,net_incre number(25,4) -- 净增值
    ,asses_scor number(25,4) -- 考核得分
    ,year_cmplt_rat number(12,6) -- 年度完成率
    ,tm_prog_cmplt_rat number(12,6) -- 时间进度完成率
    ,seq_num number -- 序号
    ,belong_comb varchar2(30) -- 归属组别
    ,unit varchar2(30) -- 指标单位
    ,ind_no varchar2(100) -- 指标编号
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
grant select on ${idl_schema}.mc_kpi_asses_scor_jg_dtl to ${iel_schema};

-- comment
comment on table ${idl_schema}.mc_kpi_asses_scor_jg_dtl is 'KPI考核得分明细_机构';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.stat_dt is '统计日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.sup_org_no is '上级机构编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.org_no is '机构编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.org_name is '机构名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.prop_id is '方案编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.prop_name is '方案名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.ind_name is '指标名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.sup_ind_seq is '上级指标序号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.sup_ind_name is '上级指标名称';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.std_scor is '标准得分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.scor_uplmi is '得分上限';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.scor_lolmi is '得分下限';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.year_target_val is '年度目标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.tm_prog_val is '时间进度值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.base_val is '基数';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.ind_val is '指标值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.net_incre is '净增值';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.asses_scor is '考核得分';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.year_cmplt_rat is '年度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.tm_prog_cmplt_rat is '时间进度完成率';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.seq_num is '序号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.belong_comb is '归属组别';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.unit is '指标单位';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.ind_no is '指标编号';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mc_kpi_asses_scor_jg_dtl.etl_timestamp is 'ETL处理时间戳';