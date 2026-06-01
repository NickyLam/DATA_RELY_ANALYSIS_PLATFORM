/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_uncounter_restraints_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_uncounter_restraints_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_uncounter_restraints_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_uncounter_restraints_hist(
    acct_status varchar2(2) -- 账户状态
    ,base_acct_no varchar2(100) -- 交易账号/卡号
    ,client_name varchar2(400) -- 客户名称
    ,client_no varchar2(32) -- 客户编号
    ,document_id varchar2(120) -- 证件号码
    ,document_type varchar2(8) -- 客户证件类型
    ,batch_no varchar2(100) -- 批次号
    ,company varchar2(40) -- 法人
    ,isscan_flag varchar2(2) -- 是否已被扫描
    ,list_source varchar2(2) -- 名单来源
    ,settle_acct_class varchar2(6) -- 结算账户分类
    ,success_flag varchar2(2) -- 成功标志
    ,uncounter_desc varchar2(100) -- 入表原因
    ,uncounter_no varchar2(100) -- 编号
    ,uncounter_restraint_status varchar2(2) -- 暂停非柜面标记
    ,acct_open_date date -- 账户开户日期
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,tran_timestamp varchar2(52) -- 交易时间戳
    ,uncounter_time varchar2(52) -- 单笔交易录入时间
    ,update_date date -- 更新日期
    ,open_branch varchar2(24) -- 开立机构
    ,remark1 varchar2(600) -- 备注1
    ,remark2 varchar2(600) -- 备注2
    ,remark3 varchar2(600) -- 备注3
    ,update_branch varchar2(24) -- 最后修改机构
    ,update_user varchar2(16) -- 更新柜员
    ,uncounter_restraint_type varchar2(8) -- 暂记非柜面限制类型
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
grant select on ${iol_schema}.ncbs_rb_uncounter_restraints_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_uncounter_restraints_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_uncounter_restraints_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_uncounter_restraints_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_uncounter_restraints_hist is '暂停非柜面账户限制历史表';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.isscan_flag is '是否已被扫描';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.list_source is '名单来源';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.settle_acct_class is '结算账户分类';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.success_flag is '成功标志';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.uncounter_desc is '入表原因';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.uncounter_no is '编号';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.uncounter_restraint_status is '暂停非柜面标记';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.uncounter_time is '单笔交易录入时间';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.remark2 is '备注2';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.update_branch is '最后修改机构';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.update_user is '更新柜员';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.uncounter_restraint_type is '暂记非柜面限制类型';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_uncounter_restraints_hist.etl_timestamp is 'ETL处理时间戳';
