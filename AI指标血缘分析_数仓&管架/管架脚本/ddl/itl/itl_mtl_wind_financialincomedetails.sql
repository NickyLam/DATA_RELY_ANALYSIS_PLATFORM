/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_wind_financialincomedetails
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_wind_financialincomedetails
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_wind_financialincomedetails purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_wind_financialincomedetails(
     object_id varchar2(38) -- 对象ID
    ,s_info_compcode varchar2(10) -- 公司id
    ,statement_type varchar2(40) -- 报表类型
    ,report_period varchar2(8) -- 报告期
    ,ann_dt varchar2(8) -- 公告日期
    ,crncy_code varchar2(10) -- 货币代码
    ,subject_name varchar2(200) -- 科目名称
    ,item_amount number(20,4) -- 科目金额
    ,classification_number number(4,0) -- 序号
    ,publish_value varchar2(40) -- 公布值
    ,publish_counitdimension varchar2(20) -- 公布量纲
    ,is_listing_data number(1,0) -- 是否上市后数据
    ,acc_sta_code varchar2(40) -- 会计准则类型
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
grant select on ${itl_schema}.mtl_wind_financialincomedetails to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_wind_financialincomedetails is '金融机构利润明细表';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.object_id is '对象ID';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.s_info_compcode is '公司id';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.statement_type is '报表类型';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.report_period is '报告期';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.ann_dt is '公告日期';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.crncy_code is '货币代码';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.subject_name is '科目名称';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.item_amount is '科目金额';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.classification_number is '序号';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.publish_value is '公布值';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.publish_counitdimension is '公布量纲';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.is_listing_data is '是否上市后数据';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.acc_sta_code is '会计准则类型';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_wind_financialincomedetails.etl_timestamp is 'ETL处理时间戳';
