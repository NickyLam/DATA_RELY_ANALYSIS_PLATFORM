/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_teller_perf_analy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_teller_perf_analy
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_teller_perf_analy purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_teller_perf_analy(
    teller_no varchar2(10) -- 柜员号
    ,teller_name varchar2(150) -- 柜员名称
    ,sign_dt date -- 签到日期
    ,tot_duran number(16,2) -- 总时长
    ,td_sign_in_cnt number -- 当天签到次数
    ,td_sign_out_cnt number -- 当天签退次数
    ,td_fir_sign_in_tm date -- 当天首次签到时间
    ,td_final_sign_out_tm date -- 当天最后签退时间
    ,onl_tot_duran number(16,2) -- 在线总时长
    ,onl_tran_duran number(16,2) -- 在线交易时长
    ,onl_null_duran number(16,2) -- 在线空闲时长
    ,offl_duran number(16,2) -- 离柜时长
    ,td_fir_tran_tm date -- 当天首次交易时间
    ,td_final_tran_tm date -- 当天最后交易时间
    ,org_no varchar2(6) -- 所属机构号
    ,teller_type varchar2(6) -- 柜员类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
    ,super_org_no varchar2(6) -- 给前端加的伪列
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_teller_perf_analy to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_teller_perf_analy is '柜员绩效分析表';
comment on column ${idl_schema}.base_d_teller_perf_analy.teller_no is '柜员号';
comment on column ${idl_schema}.base_d_teller_perf_analy.teller_name is '柜员名称';
comment on column ${idl_schema}.base_d_teller_perf_analy.sign_dt is '签到日期';
comment on column ${idl_schema}.base_d_teller_perf_analy.tot_duran is '总时长';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_sign_in_cnt is '当天签到次数';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_sign_out_cnt is '当天签退次数';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_fir_sign_in_tm is '当天首次签到时间';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_final_sign_out_tm is '当天最后签退时间';
comment on column ${idl_schema}.base_d_teller_perf_analy.onl_tot_duran is '在线总时长';
comment on column ${idl_schema}.base_d_teller_perf_analy.onl_tran_duran is '在线交易时长';
comment on column ${idl_schema}.base_d_teller_perf_analy.onl_null_duran is '在线空闲时长';
comment on column ${idl_schema}.base_d_teller_perf_analy.offl_duran is '离柜时长';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_fir_tran_tm is '当天首次交易时间';
comment on column ${idl_schema}.base_d_teller_perf_analy.td_final_tran_tm is '当天最后交易时间';
comment on column ${idl_schema}.base_d_teller_perf_analy.org_no is '所属机构号';
comment on column ${idl_schema}.base_d_teller_perf_analy.teller_type is '柜员类型';
comment on column ${idl_schema}.base_d_teller_perf_analy.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_teller_perf_analy.etl_timestamp is 'ETL处理时间戳';
comment on column ${idl_schema}.base_d_teller_perf_analy.super_org_no is '给前端加的伪列';