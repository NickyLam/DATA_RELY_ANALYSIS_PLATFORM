/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_yxyd_sj_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_yxyd_sj_info
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_yxyd_sj_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_yxyd_sj_info(
    rj_rule_big varchar2(4000) -- 首拒原因（大类）
    ,rj_rule varchar2(4000) -- 首拒原因
    ,t_1_cnt number(22) -- T-1申请笔数
    ,t_2_cnt number(22) -- T-2申请笔数
    ,t_3_cnt number(22) -- T-3申请笔数
    ,t_4_cnt number(22) -- T-4申请笔数
    ,t_5_cnt number(22) -- T-5申请笔数
    ,t_6_cnt number(22) -- T-6申请笔数
    ,t_7_cnt number(22) -- T-7申请笔数
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pcls_yxyd_sj_info to ${iml_schema};
grant select on ${iol_schema}.pcls_yxyd_sj_info to ${icl_schema};
grant select on ${iol_schema}.pcls_yxyd_sj_info to ${idl_schema};
grant select on ${iol_schema}.pcls_yxyd_sj_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_yxyd_sj_info is '好易贷自营首拒表';
comment on column ${iol_schema}.pcls_yxyd_sj_info.rj_rule_big is '首拒原因（大类）';
comment on column ${iol_schema}.pcls_yxyd_sj_info.rj_rule is '首拒原因';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_1_cnt is 'T-1申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_2_cnt is 'T-2申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_3_cnt is 'T-3申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_4_cnt is 'T-4申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_5_cnt is 'T-5申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_6_cnt is 'T-6申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.t_7_cnt is 'T-7申请笔数';
comment on column ${iol_schema}.pcls_yxyd_sj_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_yxyd_sj_info.etl_timestamp is 'ETL处理时间戳';
