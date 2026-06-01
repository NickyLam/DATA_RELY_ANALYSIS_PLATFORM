/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_base_rule_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_base_rule_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_base_rule_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_base_rule_info(
    base_rule_id varchar2(32) -- 业绩基准代码，同金融产品代码
    ,eff_date date -- 生效日期
    ,rate_type varchar2(50) -- 利率类型
    ,rate number(30,14) -- 初始利率
    ,index_id varchar2(32) -- 基准编号
    ,index_source varchar2(50) -- 基准来源，复合基准、利率行情、指数行情、曲线
    ,coefficient number(30,14) -- 系数
    ,spread_rate number(30,14) -- 利差
    ,reset_type varchar2(50) -- 重置规则，期初、期末等
    ,finprod_id varchar2(50) -- 金融产品代码
    ,branch number(10) -- 分支序号
    ,remark varchar2(1000) -- 备注
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,base_rule_type varchar2(50) -- 业绩基准类型,产品披露，浮动管理费，业绩回补
    ,publish_type varchar2(50) -- 业绩基准披露类型，区间披露，单点披露
    ,rate_lower number(30,14) -- 利率下限
    ,rate_limit number(30,14) -- 利率上限
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
grant select on ${iol_schema}.fams_fin_base_rule_info to ${iml_schema};
grant select on ${iol_schema}.fams_fin_base_rule_info to ${icl_schema};
grant select on ${iol_schema}.fams_fin_base_rule_info to ${idl_schema};
grant select on ${iol_schema}.fams_fin_base_rule_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_base_rule_info is '业绩基准信息';
comment on column ${iol_schema}.fams_fin_base_rule_info.base_rule_id is '业绩基准代码，同金融产品代码';
comment on column ${iol_schema}.fams_fin_base_rule_info.eff_date is '生效日期';
comment on column ${iol_schema}.fams_fin_base_rule_info.rate_type is '利率类型';
comment on column ${iol_schema}.fams_fin_base_rule_info.rate is '初始利率';
comment on column ${iol_schema}.fams_fin_base_rule_info.index_id is '基准编号';
comment on column ${iol_schema}.fams_fin_base_rule_info.index_source is '基准来源，复合基准、利率行情、指数行情、曲线';
comment on column ${iol_schema}.fams_fin_base_rule_info.coefficient is '系数';
comment on column ${iol_schema}.fams_fin_base_rule_info.spread_rate is '利差';
comment on column ${iol_schema}.fams_fin_base_rule_info.reset_type is '重置规则，期初、期末等';
comment on column ${iol_schema}.fams_fin_base_rule_info.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_base_rule_info.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_base_rule_info.remark is '备注';
comment on column ${iol_schema}.fams_fin_base_rule_info.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_base_rule_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_base_rule_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_base_rule_info.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_base_rule_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_base_rule_info.base_rule_type is '业绩基准类型,产品披露，浮动管理费，业绩回补';
comment on column ${iol_schema}.fams_fin_base_rule_info.publish_type is '业绩基准披露类型，区间披露，单点披露';
comment on column ${iol_schema}.fams_fin_base_rule_info.rate_lower is '利率下限';
comment on column ${iol_schema}.fams_fin_base_rule_info.rate_limit is '利率上限';
comment on column ${iol_schema}.fams_fin_base_rule_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_base_rule_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_base_rule_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_base_rule_info.etl_timestamp is 'ETL处理时间戳';
