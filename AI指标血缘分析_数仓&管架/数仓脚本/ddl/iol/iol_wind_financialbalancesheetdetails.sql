/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_financialbalancesheetdetails
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_financialbalancesheetdetails
whenever sqlerror continue none;
drop table ${iol_schema}.wind_financialbalancesheetdetails purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_financialbalancesheetdetails(
    object_id varchar2(57) -- 对象ID
    ,s_info_compcode varchar2(15) -- 公司id
    ,statement_type varchar2(60) -- 报表类型
    ,report_period varchar2(12) -- 报告期
    ,ann_dt varchar2(12) -- 公告日期
    ,crncy_code varchar2(15) -- 货币代码
    ,subject_name varchar2(300) -- 科目名称
    ,item_amount number(20,4) -- 科目金额
    ,classification_number number(4,0) -- 序号
    ,publish_value varchar2(60) -- 公布值
    ,publish_counitdimension varchar2(30) -- 公布量纲
    ,is_listing_data number(1,0) -- 是否上市后数据
    ,acc_sta_code varchar2(60) -- 会计准则类型
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
grant select on ${iol_schema}.wind_financialbalancesheetdetails to ${iml_schema};
grant select on ${iol_schema}.wind_financialbalancesheetdetails to ${icl_schema};
grant select on ${iol_schema}.wind_financialbalancesheetdetails to ${idl_schema};
grant select on ${iol_schema}.wind_financialbalancesheetdetails to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_financialbalancesheetdetails is '金融机构资产负债明细表';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.object_id is '对象ID';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.statement_type is '报表类型';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.report_period is '报告期';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.subject_name is '科目名称';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.item_amount is '科目金额';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.classification_number is '序号';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.publish_value is '公布值';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.publish_counitdimension is '公布量纲';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.is_listing_data is '是否上市后数据';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.acc_sta_code is '会计准则类型';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_financialbalancesheetdetails.etl_timestamp is 'ETL处理时间戳';
