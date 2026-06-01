/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pcls_yxyd_dz_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pcls_yxyd_dz_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pcls_yxyd_dz_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pcls_yxyd_dz_info(
    draw_dt number(22) -- 动支日期
    ,draw_cnt number(22) -- 动支笔数
    ,draw_pass_cnt number(22) -- 动支成功笔数
    ,draw_pass_percent number(38,6) -- 动支成功率
    ,draw_amt number(38,6) -- 放款金额
    ,draw_amt_avg number(38,6) -- 笔均放款金额
    ,bal number(38,6) -- 贷款余额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pcls_yxyd_dz_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pcls_yxyd_dz_info is '好易贷自营动支表';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_dt is '动支日期';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_cnt is '动支笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_pass_cnt is '动支成功笔数';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_pass_percent is '动支成功率';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_amt is '放款金额';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.draw_amt_avg is '笔均放款金额';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.bal is '贷款余额';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pcls_yxyd_dz_info.etl_timestamp is 'ETL处理时间戳';
