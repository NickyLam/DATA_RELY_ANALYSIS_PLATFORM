/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_idx_finindexresult
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_idx_finindexresult
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_idx_finindexresult purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_idx_finindexresult(
    clientcode varchar2(30) -- 客户编号
    ,regioncode varchar2(4) -- 地区号
    ,reporttime varchar2(14) -- 报表期数
    ,indexcode varchar2(30) -- 指标编码
    ,indexresult varchar2(30) -- 指标结果
    ,intime varchar2(15) -- 录入时间
    ,indexname varchar2(300) -- 指标名称
    ,reporttime_bj varchar2(14) -- 比较期财务报表
    ,flag varchar2(1) -- 计算方法标示
    ,indus_rank number -- 行业排名
    ,indus_avg number(24,6) -- 指标行业均值
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_idx_finindexresult to ${iml_schema};
grant select on ${iol_schema}.nrrs_idx_finindexresult to ${icl_schema};
grant select on ${iol_schema}.nrrs_idx_finindexresult to ${idl_schema};
grant select on ${iol_schema}.nrrs_idx_finindexresult to ${iel_schema};

-- comment
comment on table ${iol_schema}.nrrs_idx_finindexresult is '指标结算结果';
comment on column ${iol_schema}.nrrs_idx_finindexresult.clientcode is '客户编号';
comment on column ${iol_schema}.nrrs_idx_finindexresult.regioncode is '地区号';
comment on column ${iol_schema}.nrrs_idx_finindexresult.reporttime is '报表期数';
comment on column ${iol_schema}.nrrs_idx_finindexresult.indexcode is '指标编码';
comment on column ${iol_schema}.nrrs_idx_finindexresult.indexresult is '指标结果';
comment on column ${iol_schema}.nrrs_idx_finindexresult.intime is '录入时间';
comment on column ${iol_schema}.nrrs_idx_finindexresult.indexname is '指标名称';
comment on column ${iol_schema}.nrrs_idx_finindexresult.reporttime_bj is '比较期财务报表';
comment on column ${iol_schema}.nrrs_idx_finindexresult.flag is '计算方法标示';
comment on column ${iol_schema}.nrrs_idx_finindexresult.indus_rank is '行业排名';
comment on column ${iol_schema}.nrrs_idx_finindexresult.indus_avg is '指标行业均值';
comment on column ${iol_schema}.nrrs_idx_finindexresult.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_idx_finindexresult.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_idx_finindexresult.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_idx_finindexresult.etl_timestamp is 'ETL处理时间戳';
