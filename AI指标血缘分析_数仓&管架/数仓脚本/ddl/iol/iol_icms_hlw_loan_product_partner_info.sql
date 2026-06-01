/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hlw_loan_product_partner_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hlw_loan_product_partner_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hlw_loan_product_partner_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hlw_loan_product_partner_info(
    serialno varchar2(32) -- 流水号
    ,objectno varchar2(32) -- HLW_LOAN_PRODUCT_INFO流水号
    ,partnername varchar2(200) -- 合作方名称
    ,channelno varchar2(100) -- 渠道性质
    ,certid varchar2(60) -- 合作方统一社会信用代码
    ,investmentprop number(24,8) -- 出资比例
    ,startdate date -- 启用时间
    ,enddate date -- 停用时间
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
grant select on ${iol_schema}.icms_hlw_loan_product_partner_info to ${iml_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_partner_info to ${icl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_partner_info to ${idl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_partner_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hlw_loan_product_partner_info is '互联网贷款产品合作方信息表';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.serialno is '流水号';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.objectno is 'HLW_LOAN_PRODUCT_INFO流水号';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.partnername is '合作方名称';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.channelno is '渠道性质';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.certid is '合作方统一社会信用代码';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.investmentprop is '出资比例';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.startdate is '启用时间';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.enddate is '停用时间';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_hlw_loan_product_partner_info.etl_timestamp is 'ETL处理时间戳';
