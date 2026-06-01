/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_fee_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_fee_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_fee_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_fee_mapping(
    branch_rule varchar2(200) -- 机构匹配规则
    ,category_type_rule varchar2(200) -- 客户类型细类
    ,ccy_rule varchar2(200) -- 费用启用规则币种
    ,client_type_rule varchar2(10) -- 费用启用规则客户类型
    ,company varchar2(20) -- 法人
    ,company_rule varchar2(200) -- 费用启用规则法人
    ,doc_type_rule varchar2(200) -- 凭证类型启用规则
    ,event_type_rule varchar2(200) -- 费用启用规则事件类型
    ,fee_type varchar2(20) -- 费率类型
    ,irl_seq_no varchar2(50) -- 费率编号
    ,is_local_rule varchar2(3) -- 跨行标志
    ,new_status_rule varchar2(200) -- 新凭证状态启用规则
    ,old_status_rule varchar2(3) -- 原凭证状态启用规则
    ,prod_group_rule varchar2(3) -- 费用启用规则产品组
    ,rule_flag varchar2(1) -- 是否使用规则
    ,service_id_rule varchar2(200) -- 规则匹配代码
    ,source_type_rule varchar2(200) -- 渠道类型配置值
    ,tran_type_rule varchar2(200) -- 费用启用规则交易类型
    ,urgent_flag_rule varchar2(3) -- 加急标志
    ,prod_type_rule varchar2(200) -- 费用启用规则产品类型
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,area_code_rule varchar2(200) -- 地区匹配规则
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
grant select on ${iol_schema}.ncbs_mb_fee_mapping to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_fee_mapping to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_mapping to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_fee_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_fee_mapping is '费用启用规则表';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.branch_rule is '机构匹配规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.category_type_rule is '客户类型细类';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.ccy_rule is '费用启用规则币种';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.client_type_rule is '费用启用规则客户类型';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.company is '法人';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.company_rule is '费用启用规则法人';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.doc_type_rule is '凭证类型启用规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.event_type_rule is '费用启用规则事件类型';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.is_local_rule is '跨行标志';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.new_status_rule is '新凭证状态启用规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.old_status_rule is '原凭证状态启用规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.prod_group_rule is '费用启用规则产品组';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.rule_flag is '是否使用规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.service_id_rule is '规则匹配代码';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.source_type_rule is '渠道类型配置值';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.tran_type_rule is '费用启用规则交易类型';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.urgent_flag_rule is '加急标志';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.prod_type_rule is '费用启用规则产品类型';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.area_code_rule is '地区匹配规则';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_fee_mapping.etl_timestamp is 'ETL处理时间戳';
