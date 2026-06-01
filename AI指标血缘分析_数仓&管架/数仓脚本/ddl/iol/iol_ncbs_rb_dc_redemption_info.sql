/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_redemption_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_redemption_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_redemption_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_redemption_info(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,issue_year varchar2(5) -- 发行年度
    ,redemption_status varchar2(1) -- 赎回状态
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,apply_date date -- 申请日期
    ,tohonor_date date -- 赎回日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,tohonor_rate number(15,8) -- 赎回利率
    ,approval_no varchar2(50) -- 审批单号
    ,title_info varchar2(30) -- 标题
    ,apply_client_name varchar2(50) -- 申请人名称
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
grant select on ${iol_schema}.ncbs_rb_dc_redemption_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_redemption_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_redemption_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_redemption_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_redemption_info is '大额存单赎回申请表';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.redemption_status is '赎回状态';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.tohonor_date is '赎回日期';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.tohonor_rate is '赎回利率';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.title_info is '标题';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.apply_client_name is '申请人名称';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_redemption_info.etl_timestamp is 'ETL处理时间戳';
