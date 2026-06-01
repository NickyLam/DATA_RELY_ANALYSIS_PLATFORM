/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_fund_corp_finan_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_fund_corp_finan_data
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_fund_corp_finan_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_fund_corp_finan_data(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,corp_code varchar2(300) -- 公司代码
    ,org_name varchar2(300) -- 公司名称
    ,ed date -- 截止日期
    ,revenue number(24,4) -- 营业收入
    ,op number(24,4) -- 营业利润
    ,total_profit number(24,4) -- 利润总额
    ,net_profit number(24,4) -- 净利润
    ,total_assets number(24,4) -- 总资产
    ,net_assets number(24,4) -- 净资产
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
grant select on ${iol_schema}.uxds_fund_corp_finan_data to ${iml_schema};
grant select on ${iol_schema}.uxds_fund_corp_finan_data to ${icl_schema};
grant select on ${iol_schema}.uxds_fund_corp_finan_data to ${idl_schema};
grant select on ${iol_schema}.uxds_fund_corp_finan_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_fund_corp_finan_data is '中国基金公司财务数据';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.rtime is '记录同步时间';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.corp_code is '公司代码';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.org_name is '公司名称';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.ed is '截止日期';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.revenue is '营业收入';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.op is '营业利润';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.total_profit is '利润总额';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.net_profit is '净利润';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.total_assets is '总资产';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.net_assets is '净资产';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_fund_corp_finan_data.etl_timestamp is 'ETL处理时间戳';
