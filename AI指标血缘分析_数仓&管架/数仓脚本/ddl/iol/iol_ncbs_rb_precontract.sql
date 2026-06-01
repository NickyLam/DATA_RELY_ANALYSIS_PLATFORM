/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_precontract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_precontract
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_precontract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_precontract(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,mobile_no varchar2(30) -- 电话号码
    ,precontract_method varchar2(1) -- 预约方式
    ,precontract_no varchar2(50) -- 预约号
    ,precontract_status varchar2(1) -- 期次产品预约状态
    ,precontract_type varchar2(1) -- 预约登记的账户类型
    ,precontract_wtd_type varchar2(1) -- 预约支取方式
    ,last_change_date date -- 最后修改日期
    ,precontract_date date -- 预约登记日期
    ,precontract_draw_date date -- 取款日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,precontract_amt number(17,2) -- 预约金额
    ,precontract_ccy varchar2(3) -- 期次产品预约币种
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,unlost_user_id varchar2(8) -- 解挂柜员
    ,violate_adj number(38,2) -- 通知存款违约基数
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
grant select on ${iol_schema}.ncbs_rb_precontract to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_precontract to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_precontract to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_precontract to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_precontract is '大额现金支取预约及通知存款预约信息表';
comment on column ${iol_schema}.ncbs_rb_precontract.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_precontract.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_precontract.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_precontract.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_precontract.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_precontract.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_precontract.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_precontract.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_precontract.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_precontract.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_precontract.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_precontract.company is '法人';
comment on column ${iol_schema}.ncbs_rb_precontract.mobile_no is '电话号码';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_method is '预约方式';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_no is '预约号';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_status is '期次产品预约状态';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_type is '预约登记的账户类型';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_wtd_type is '预约支取方式';
comment on column ${iol_schema}.ncbs_rb_precontract.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_date is '预约登记日期';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_draw_date is '取款日期';
comment on column ${iol_schema}.ncbs_rb_precontract.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_amt is '预约金额';
comment on column ${iol_schema}.ncbs_rb_precontract.precontract_ccy is '期次产品预约币种';
comment on column ${iol_schema}.ncbs_rb_precontract.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_precontract.unlost_user_id is '解挂柜员';
comment on column ${iol_schema}.ncbs_rb_precontract.violate_adj is '通知存款违约基数';
comment on column ${iol_schema}.ncbs_rb_precontract.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_precontract.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_precontract.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_precontract.etl_timestamp is 'ETL处理时间戳';
