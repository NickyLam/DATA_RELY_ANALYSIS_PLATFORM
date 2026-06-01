/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_equity_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_equity_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_equity_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_ext(
    i_code varchar2(75) -- 主键
    ,h_datefield varchar2(29) -- 日期类型
    ,h_textfield varchar2(90) -- 文本类型
    ,h_numberfield number(31,2) -- 数值类型
    ,h_combobox varchar2(150) -- 下拉框类型
    ,h_textarea varchar2(4000) -- 文本域类型
    ,h_issuer varchar2(90) -- 发行人
    ,h_honour_date varchar2(29) -- 兑付日
    ,h_grade_org varchar2(135) -- 评级机构
    ,h_risk_classify varchar2(150) -- 风险分类
    ,h_guarantor_type varchar2(150) -- 担保方类型
    ,h_product_grade varchar2(150) -- 产品评级
    ,asset_product_statistics_code varchar2(75) -- 资管产品统计编码
    ,special_purpose_vehicle_type varchar2(75) -- 特定目的载体类型
    ,issuer_region_code varchar2(75) -- 发行人地区代码
    ,excute_mode varchar2(75) -- 运行方式
    ,special_purpose_vehicle_code varchar2(75) -- 特定目的载体代码
    ,issuer_code varchar2(75) -- 发行人代码
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
grant select on ${iol_schema}.ibms_ttrd_equity_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_equity_ext is '净值型扩展信息表';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.i_code is '主键';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_datefield is '日期类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_textfield is '文本类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_numberfield is '数值类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_combobox is '下拉框类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_textarea is '文本域类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_issuer is '发行人';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_honour_date is '兑付日';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_grade_org is '评级机构';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_risk_classify is '风险分类';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_guarantor_type is '担保方类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.h_product_grade is '产品评级';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.asset_product_statistics_code is '资管产品统计编码';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.special_purpose_vehicle_type is '特定目的载体类型';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.issuer_region_code is '发行人地区代码';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.excute_mode is '运行方式';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.special_purpose_vehicle_code is '特定目的载体代码';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.issuer_code is '发行人代码';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_equity_ext.etl_timestamp is 'ETL处理时间戳';
