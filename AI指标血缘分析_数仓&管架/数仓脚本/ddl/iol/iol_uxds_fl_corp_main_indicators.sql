/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_fl_corp_main_indicators
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_fl_corp_main_indicators
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_fl_corp_main_indicators purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_fl_corp_main_indicators(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录同步时间
    ,chg_seq number(3,0) -- 变动序号
    ,project_seq number(3,0) -- 项目序号
    ,org_id varchar2(33) -- 机构ID
    ,ed date -- 截止日期
    ,statement_year number(4,0) -- 报表年度
    ,report_type_code varchar2(54) -- 报告类型编码
    ,statement_type_code varchar2(54) -- 报表类型编码
    ,announcement_date date -- 公告日期
    ,lastest_symbol number(1,0) -- 最新标志
    ,project_announced_name varchar2(300) -- 项目公布名称
    ,project_speci_name_code varchar2(54) -- 项目规范名称编码
    ,numerical_value number(24,4) -- 数值
    ,unit varchar2(60) -- 单位
    ,currency_variety_name_code varchar2(54) -- 币种名称编码
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
grant select on ${iol_schema}.uxds_fl_corp_main_indicators to ${iml_schema};
grant select on ${iol_schema}.uxds_fl_corp_main_indicators to ${icl_schema};
grant select on ${iol_schema}.uxds_fl_corp_main_indicators to ${idl_schema};
grant select on ${iol_schema}.uxds_fl_corp_main_indicators to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_fl_corp_main_indicators is '金融租赁公司专项指标';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.rtime is '记录同步时间';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.chg_seq is '变动序号';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.project_seq is '项目序号';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.org_id is '机构ID';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.ed is '截止日期';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.statement_year is '报表年度';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.report_type_code is '报告类型编码';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.statement_type_code is '报表类型编码';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.announcement_date is '公告日期';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.lastest_symbol is '最新标志';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.project_announced_name is '项目公布名称';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.project_speci_name_code is '项目规范名称编码';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.numerical_value is '数值';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.unit is '单位';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.currency_variety_name_code is '币种名称编码';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_fl_corp_main_indicators.etl_timestamp is 'ETL处理时间戳';
