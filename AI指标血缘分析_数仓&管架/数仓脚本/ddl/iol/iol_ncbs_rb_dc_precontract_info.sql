/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_precontract_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_precontract_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_precontract_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_precontract_info(
    client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,int_calc_type varchar2(1) -- 计息类型
    ,narrative varchar2(400) -- 摘要
    ,precontract_no varchar2(50) -- 预约号
    ,precontract_status varchar2(1) -- 期次产品预约状态
    ,precontract_stype varchar2(1) -- 预约/认购方式
    ,res_seq_no varchar2(50) -- 限制编号
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,delete_date date -- 删除日期
    ,issue_end_date date -- 发行终止日期
    ,issue_start_date date -- 发行起始日期
    ,open_date date -- 开立日期
    ,precontract_date date -- 预约登记日期
    ,precontract_open_date date -- 预约开户日期
    ,print_date date -- 打印日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,actual_rate number(15,8) -- 行内利率
    ,auth_user_id varchar2(8) -- 授权柜员
    ,ch_client_name varchar2(200) -- 客户中文名称
    ,del_auth_user_id varchar2(8) -- 删除授权柜员
    ,del_reason varchar2(200) -- 删除原因
    ,del_user_id varchar2(8) -- 删除柜员
    ,failure_reason varchar2(200) -- 失败原因
    ,float_rate number(15,8) -- 浮动利率
    ,issue_amt number(17,2) -- 期次发行金额
    ,precontract_amt number(17,2) -- 预约金额
    ,precontract_amt_branch varchar2(12) -- 大额存单申购可用金额配置机构
    ,precontract_branch varchar2(12) -- 预约/认购机构
    ,precontract_ccy varchar2(3) -- 期次产品预约币种
    ,print_user_id varchar2(8) -- 打印柜员
    ,real_rate number(15,8) -- 执行利率
    ,comb_prod_no varchar2(200) -- 组合产品编号
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
grant select on ${iol_schema}.ncbs_rb_dc_precontract_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_precontract_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_precontract_info is '大额存单预约认购申购流水表';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.int_calc_type is '计息类型';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_no is '预约号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_status is '期次产品预约状态';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_stype is '预约/认购方式';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.delete_date is '删除日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.issue_end_date is '发行终止日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.issue_start_date is '发行起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.open_date is '开立日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_date is '预约登记日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_open_date is '预约开户日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.print_date is '打印日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.ch_client_name is '客户中文名称';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.del_auth_user_id is '删除授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.del_reason is '删除原因';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.del_user_id is '删除柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.issue_amt is '期次发行金额';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_amt is '预约金额';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_amt_branch is '大额存单申购可用金额配置机构';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_branch is '预约/认购机构';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.precontract_ccy is '期次产品预约币种';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.print_user_id is '打印柜员';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.comb_prod_no is '组合产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_precontract_info.etl_timestamp is 'ETL处理时间戳';
