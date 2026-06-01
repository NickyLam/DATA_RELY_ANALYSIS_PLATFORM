/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_open
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_open
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_open purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_open(
    client_type varchar2(3) -- 客户类型
    ,file_name varchar2(200) -- 文件名称
    ,file_path varchar2(200) -- 文件路径
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,withdrawal_type varchar2(1) -- 支取方式
    ,appr_flag varchar2(1) -- 复核标志
    ,auth_flag varchar2(1) -- 授权标志
    ,batch_desc varchar2(50) -- 批处理描述
    ,batch_no varchar2(50) -- 批次号
    ,batch_status varchar2(1) -- 批次处理状态
    ,card_pb_ind varchar2(1) -- 卡/折标志
    ,category_type varchar2(3) -- 存款人类别
    ,company varchar2(20) -- 法人
    ,contact_type varchar2(20) -- 联系类型	
    ,copr_name varchar2(200) -- 单位名称
    ,error_desc varchar2(3000) -- 错误描述
    ,failure_number number(5) -- 失败数量
    ,gain_type varchar2(1) -- 卡片领取方式
    ,mac_value varchar2(200) -- 传输密押
    ,open_type varchar2(3) -- 批量开立方式
    ,seq_no varchar2(50) -- 序号
    ,server_ip varchar2(50) -- 后台服务ip
    ,source_branch_no varchar2(12) -- 源节点编号
    ,source_type varchar2(6) -- 渠道编号
    ,succ_num number(5) -- 成功数量
    ,system_id varchar2(20) -- 系统id
    ,thread_no varchar2(50) -- 线程编号
    ,total_num number(5) -- 总数量
    ,tran_mode varchar2(1) -- 交易模式
    ,user_lang varchar2(3) -- 柜员语言
    ,begin_time varchar2(26) -- 开始时间
    ,expire_date date -- 失效日期
    ,open_date date -- 开立日期
    ,run_date date -- 运行日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,dest_branch_no varchar2(12) -- 目标机构编号
    ,from_card_no varchar2(50) -- 转出卡号
    ,open_branch varchar2(12) -- 开立机构
    ,open_ccy varchar2(3) -- 批量开户币种
    ,to_card_no varchar2(50) -- 终止卡号
    ,total_amt number(17,2) -- 总金额
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
grant select on ${iol_schema}.ncbs_rb_batch_open to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_open to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_open is '批量开立信息登记簿';
comment on column ${iol_schema}.ncbs_rb_batch_open.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_batch_open.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_rb_batch_open.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_rb_batch_open.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_batch_open.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_rb_batch_open.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_rb_batch_open.auth_flag is '授权标志';
comment on column ${iol_schema}.ncbs_rb_batch_open.batch_desc is '批处理描述';
comment on column ${iol_schema}.ncbs_rb_batch_open.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_batch_open.batch_status is '批次处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_open.card_pb_ind is '卡/折标志';
comment on column ${iol_schema}.ncbs_rb_batch_open.category_type is '存款人类别';
comment on column ${iol_schema}.ncbs_rb_batch_open.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_open.contact_type is '联系类型	';
comment on column ${iol_schema}.ncbs_rb_batch_open.copr_name is '单位名称';
comment on column ${iol_schema}.ncbs_rb_batch_open.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_batch_open.failure_number is '失败数量';
comment on column ${iol_schema}.ncbs_rb_batch_open.gain_type is '卡片领取方式';
comment on column ${iol_schema}.ncbs_rb_batch_open.mac_value is '传输密押';
comment on column ${iol_schema}.ncbs_rb_batch_open.open_type is '批量开立方式';
comment on column ${iol_schema}.ncbs_rb_batch_open.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_open.server_ip is '后台服务ip';
comment on column ${iol_schema}.ncbs_rb_batch_open.source_branch_no is '源节点编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.succ_num is '成功数量';
comment on column ${iol_schema}.ncbs_rb_batch_open.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_batch_open.thread_no is '线程编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.total_num is '总数量';
comment on column ${iol_schema}.ncbs_rb_batch_open.tran_mode is '交易模式';
comment on column ${iol_schema}.ncbs_rb_batch_open.user_lang is '柜员语言';
comment on column ${iol_schema}.ncbs_rb_batch_open.begin_time is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_open.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_batch_open.open_date is '开立日期';
comment on column ${iol_schema}.ncbs_rb_batch_open.run_date is '运行日期';
comment on column ${iol_schema}.ncbs_rb_batch_open.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_batch_open.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_open.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_batch_open.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_batch_open.dest_branch_no is '目标机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_open.from_card_no is '转出卡号';
comment on column ${iol_schema}.ncbs_rb_batch_open.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_rb_batch_open.open_ccy is '批量开户币种';
comment on column ${iol_schema}.ncbs_rb_batch_open.to_card_no is '终止卡号';
comment on column ${iol_schema}.ncbs_rb_batch_open.total_amt is '总金额';
comment on column ${iol_schema}.ncbs_rb_batch_open.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_open.etl_timestamp is 'ETL处理时间戳';
