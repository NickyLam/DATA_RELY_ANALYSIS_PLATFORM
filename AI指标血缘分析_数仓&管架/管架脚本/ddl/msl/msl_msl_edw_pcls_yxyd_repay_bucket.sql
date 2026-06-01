/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_pcls_yxyd_repay_bucket
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket(
    etl_dt date
    ,repay_area varchar2(4000)
    ,datecreated1 varchar2(4000)
    ,appl_cnt number(20)
    ,appl_pass_cnt number(20)
    ,appl_pass_percent number(20)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket is '好易贷自营定价分箱表';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.repay_area is '定价区间';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.datecreated1 is '申请日期';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.appl_cnt is '申请笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.appl_pass_cnt is '申请通过笔数';
comment on column ${msl_schema}.msl_edw_pcls_yxyd_repay_bucket.appl_pass_percent is '申请通过率';
