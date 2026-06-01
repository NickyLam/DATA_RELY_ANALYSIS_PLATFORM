/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_fund_company_latest_size
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_fund_company_latest_size
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_fund_company_latest_size purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_fund_company_latest_size(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,org_name varchar2(600) -- 机构名称
    ,report_date date -- 报告日期
    ,stat_type number(2,0) -- 统计类型
    ,total_net_asset_value number(20,10) -- 资产净值合计
    ,asset_size number(20,10) -- 资管管理规模
    ,total_shares number(20,10) -- 份额合计
    ,ed date -- 截止日期
    ,number_of_funds number(10,0) -- 基金数量
    ,org_id varchar2(120) -- 机构ID
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_fund_company_latest_size to ${iml_schema};
grant select on ${iol_schema}.uxds_fund_company_latest_size to ${icl_schema};
grant select on ${iol_schema}.uxds_fund_company_latest_size to ${idl_schema};
grant select on ${iol_schema}.uxds_fund_company_latest_size to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_fund_company_latest_size is '中国基金公司最新规模';
comment on column ${iol_schema}.uxds_fund_company_latest_size.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_fund_company_latest_size.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_fund_company_latest_size.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_fund_company_latest_size.rtime is '记录同步时间';
comment on column ${iol_schema}.uxds_fund_company_latest_size.org_name is '机构名称';
comment on column ${iol_schema}.uxds_fund_company_latest_size.report_date is '报告日期';
comment on column ${iol_schema}.uxds_fund_company_latest_size.stat_type is '统计类型';
comment on column ${iol_schema}.uxds_fund_company_latest_size.total_net_asset_value is '资产净值合计';
comment on column ${iol_schema}.uxds_fund_company_latest_size.asset_size is '资管管理规模';
comment on column ${iol_schema}.uxds_fund_company_latest_size.total_shares is '份额合计';
comment on column ${iol_schema}.uxds_fund_company_latest_size.ed is '截止日期';
comment on column ${iol_schema}.uxds_fund_company_latest_size.number_of_funds is '基金数量';
comment on column ${iol_schema}.uxds_fund_company_latest_size.org_id is '机构ID';
comment on column ${iol_schema}.uxds_fund_company_latest_size.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_fund_company_latest_size.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_fund_company_latest_size.etl_timestamp is 'ETL处理时间戳';
