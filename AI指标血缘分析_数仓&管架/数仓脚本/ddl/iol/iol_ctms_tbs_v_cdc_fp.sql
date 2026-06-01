/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_cdc_fp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_cdc_fp
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_cdc_fp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_cdc_fp(
    security_code varchar2(24) -- 债券代码
    ,pricing_date number(8,0) -- 日期
    ,market varchar2(24) -- 市场类别
    ,ttm number -- 剩余期限
    ,reliability varchar2(9) -- 是否推荐
    ,dp number -- 全价
    ,cp number -- 净价
    ,yield number -- 到期收益率
    ,duration number -- 久期
    ,mduration number -- 修正久期
    ,valid number(1,0) -- 有效性
    ,lastupdate date -- 最后更新时间
    ,end_dp number -- 日终全价
    ,cdc_yield number -- 估价收益率（%）
    ,cdc_md number -- 估价修正久期
    ,cdc_convexity number -- 估价凸性
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
grant select on ${iol_schema}.ctms_tbs_v_cdc_fp to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_cdc_fp to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_cdc_fp to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_cdc_fp to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_cdc_fp is 'CDC公允价格';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.pricing_date is '日期';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.market is '市场类别';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.ttm is '剩余期限';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.reliability is '是否推荐';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.dp is '全价';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.cp is '净价';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.yield is '到期收益率';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.duration is '久期';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.mduration is '修正久期';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.valid is '有效性';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.lastupdate is '最后更新时间';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.end_dp is '日终全价';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.cdc_yield is '估价收益率（%）';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.cdc_md is '估价修正久期';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.cdc_convexity is '估价凸性';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ctms_tbs_v_cdc_fp.etl_timestamp is 'ETL处理时间戳';
