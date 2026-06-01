/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_sxd_company_lrbxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_sxd_company_lrbxx
whenever sqlerror continue none;
drop table ${iol_schema}.icms_sxd_company_lrbxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_lrbxx(
    id varchar2(32) -- 主键
    ,bqje number(12,2) -- 本年累计金额
    ,bblx varchar2(3) -- 版本类型
    ,sqje number(12,2) -- 上期金额
    ,xm varchar2(200) -- 科目名称
    ,mc varchar2(5) -- 序号
    ,sbrq date -- 申报日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,sssqq date -- 所属时间起
    ,serno varchar2(32) -- 业务流水号
    ,sssqz date -- 所属时间止
    ,bys number(12,2) -- 本月数
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
grant select on ${iol_schema}.icms_sxd_company_lrbxx to ${iml_schema};
grant select on ${iol_schema}.icms_sxd_company_lrbxx to ${icl_schema};
grant select on ${iol_schema}.icms_sxd_company_lrbxx to ${idl_schema};
grant select on ${iol_schema}.icms_sxd_company_lrbxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_sxd_company_lrbxx is '税兴贷企业利润表';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.id is '主键';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.bqje is '本年累计金额';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.bblx is '版本类型';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.sqje is '上期金额';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.xm is '科目名称';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.mc is '序号';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.sbrq is '申报日期';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.sssqq is '所属时间起';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.serno is '业务流水号';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.sssqz is '所属时间止';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.bys is '本月数';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.start_dt is '开始时间';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.end_dt is '结束时间';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.id_mark is '增删标志';
comment on column ${iol_schema}.icms_sxd_company_lrbxx.etl_timestamp is 'ETL处理时间戳';
