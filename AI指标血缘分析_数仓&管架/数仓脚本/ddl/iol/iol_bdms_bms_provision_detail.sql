/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_provision_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_provision_detail
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_provision_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_provision_detail(
    prov_de_id varchar2(60) -- 计提明细表ID
    ,prov_id varchar2(60) -- 计提主表ID
    ,prov_acct_id varchar2(60) -- 计提记账表ID
    ,draft_id varchar2(60) -- 票据ID
    ,draft_number varchar2(45) -- 票据号
    ,draft_type varchar2(6) -- 票据种类
    ,tprov_interest number(18,2) -- 当日计提利息
    ,is_success varchar2(3) -- 是否记账成功： 0 否 1 是
    ,acct_dt varchar2(12) -- 记账日
    ,back_flow_no varchar2(150) -- 核心流水号
    ,fore_flow_no varchar2(150) -- 前台流水号
    ,brch_no varchar2(18) -- 交易机构编号
    ,product_no varchar2(23) -- 业务产品号
    ,it_in_subject_no varchar2(150) -- 利息收入科目
    ,it_back_subject_no varchar2(150) -- 计提后科目
    ,it_sale_subject_no varchar2(150) -- 卖断后科目
    ,create_time timestamp -- 创建时间
    ,reserve1 varchar2(150) -- 保留字段1
    ,reserve2 varchar2(150) -- 保留字段2
    ,reserve3 varchar2(150) -- 保留字段3
    ,jiti_type varchar2(60) -- 计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购
    ,cd_range varchar2(38) -- 子票区间
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
grant select on ${iol_schema}.bdms_bms_provision_detail to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_provision_detail to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_provision_detail to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_provision_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_provision_detail is '计提明细表';
comment on column ${iol_schema}.bdms_bms_provision_detail.prov_de_id is '计提明细表ID';
comment on column ${iol_schema}.bdms_bms_provision_detail.prov_id is '计提主表ID';
comment on column ${iol_schema}.bdms_bms_provision_detail.prov_acct_id is '计提记账表ID';
comment on column ${iol_schema}.bdms_bms_provision_detail.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_provision_detail.draft_number is '票据号';
comment on column ${iol_schema}.bdms_bms_provision_detail.draft_type is '票据种类';
comment on column ${iol_schema}.bdms_bms_provision_detail.tprov_interest is '当日计提利息';
comment on column ${iol_schema}.bdms_bms_provision_detail.is_success is '是否记账成功： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_provision_detail.acct_dt is '记账日';
comment on column ${iol_schema}.bdms_bms_provision_detail.back_flow_no is '核心流水号';
comment on column ${iol_schema}.bdms_bms_provision_detail.fore_flow_no is '前台流水号';
comment on column ${iol_schema}.bdms_bms_provision_detail.brch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_bms_provision_detail.product_no is '业务产品号';
comment on column ${iol_schema}.bdms_bms_provision_detail.it_in_subject_no is '利息收入科目';
comment on column ${iol_schema}.bdms_bms_provision_detail.it_back_subject_no is '计提后科目';
comment on column ${iol_schema}.bdms_bms_provision_detail.it_sale_subject_no is '卖断后科目';
comment on column ${iol_schema}.bdms_bms_provision_detail.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_provision_detail.reserve1 is '保留字段1';
comment on column ${iol_schema}.bdms_bms_provision_detail.reserve2 is '保留字段2';
comment on column ${iol_schema}.bdms_bms_provision_detail.reserve3 is '保留字段3';
comment on column ${iol_schema}.bdms_bms_provision_detail.jiti_type is '计提配置类型： 1 贴现 2 转贴现 3 买入质押式回购 4 买入买断式回购 5 卖出质押式回购 6 卖出买断式回购 7 再贴现回购';
comment on column ${iol_schema}.bdms_bms_provision_detail.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_bms_provision_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_bms_provision_detail.etl_timestamp is 'ETL处理时间戳';
