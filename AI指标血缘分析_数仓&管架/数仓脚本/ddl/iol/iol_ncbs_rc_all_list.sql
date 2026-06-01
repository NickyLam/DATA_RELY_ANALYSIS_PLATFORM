/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rc_all_list
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rc_all_list
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rc_all_list purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_all_list(
    acct_name varchar2(200) -- 账户名称
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,document_type varchar2(4) -- 客户证件类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,list_type varchar2(10) -- 名单类型代码
    ,company varchar2(20) -- 法人
    ,data_type varchar2(20) -- 数据类型
    ,data_value varchar2(50) -- 数据值
    ,list_category varchar2(2) -- 名单种类代码
    ,narrative varchar2(400) -- 摘要
    ,our_bank_flag varchar2(1) -- 黑名单客户标志
    ,source_type varchar2(6) -- 渠道编号
    ,effect_date date -- 产品生效日期
    ,maturity_date date -- 到期日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,input_branch varchar2(12) -- 录入机构
    ,list_org varchar2(12) -- 名单发送/审核机构
    ,remark1 varchar2(600) -- 备注1
    ,remark2 varchar2(600) -- 备注2
    ,remark3 varchar2(600) -- 备注3
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rc_all_list to ${iml_schema};
grant select on ${iol_schema}.ncbs_rc_all_list to ${icl_schema};
grant select on ${iol_schema}.ncbs_rc_all_list to ${idl_schema};
grant select on ${iol_schema}.ncbs_rc_all_list to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rc_all_list is '黑灰名单信息表';
comment on column ${iol_schema}.ncbs_rc_all_list.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rc_all_list.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rc_all_list.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rc_all_list.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rc_all_list.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rc_all_list.list_type is '名单类型代码';
comment on column ${iol_schema}.ncbs_rc_all_list.company is '法人';
comment on column ${iol_schema}.ncbs_rc_all_list.data_type is '数据类型';
comment on column ${iol_schema}.ncbs_rc_all_list.data_value is '数据值';
comment on column ${iol_schema}.ncbs_rc_all_list.list_category is '名单种类代码';
comment on column ${iol_schema}.ncbs_rc_all_list.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rc_all_list.our_bank_flag is '黑名单客户标志';
comment on column ${iol_schema}.ncbs_rc_all_list.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rc_all_list.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rc_all_list.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rc_all_list.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rc_all_list.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rc_all_list.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rc_all_list.input_branch is '录入机构';
comment on column ${iol_schema}.ncbs_rc_all_list.list_org is '名单发送/审核机构';
comment on column ${iol_schema}.ncbs_rc_all_list.remark1 is '备注1';
comment on column ${iol_schema}.ncbs_rc_all_list.remark2 is '备注2';
comment on column ${iol_schema}.ncbs_rc_all_list.remark3 is '备注3';
comment on column ${iol_schema}.ncbs_rc_all_list.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rc_all_list.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rc_all_list.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rc_all_list.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rc_all_list.etl_timestamp is 'ETL处理时间戳';
