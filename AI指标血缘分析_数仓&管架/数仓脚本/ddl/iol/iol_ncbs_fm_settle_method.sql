/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_settle_method
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_settle_method
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_settle_method purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_settle_method(
    doc_type varchar2(10) -- 凭证类型
    ,company varchar2(20) -- 法人
    ,contact_type varchar2(20) -- 联系类型	
    ,dest_client_type varchar2(1) -- 目标客户类型
    ,dest_id varchar2(50) -- 目标id
    ,dest_type varchar2(1) -- 目标类型
    ,dp_settle_flag varchar2(1) -- 是否为dp清算
    ,format varchar2(10) -- 电位类型
    ,is_cash varchar2(1) -- 是否现金
    ,media varchar2(10) -- 报表格式
    ,pay_rec varchar2(1) -- 收付标志
    ,print_mode varchar2(5) -- 打印模式
    ,release_security varchar2(1) -- 安全释放
    ,senders_contact_type varchar2(2) -- 发报方联系类型
    ,settle_acct_type varchar2(1) -- 结算账户类型
    ,settle_method varchar2(3) -- 结算方法
    ,settle_method_desc varchar2(50) -- 结算方法描述
    ,verify_security varchar2(1) -- 安全复合
    ,route varchar2(10) -- 联系方式类型
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_settle_method to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_settle_method to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_settle_method to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_settle_method to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_settle_method is '结算方法定义表';
comment on column ${iol_schema}.ncbs_fm_settle_method.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.company is '法人';
comment on column ${iol_schema}.ncbs_fm_settle_method.contact_type is '联系类型	';
comment on column ${iol_schema}.ncbs_fm_settle_method.dest_client_type is '目标客户类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.dest_id is '目标id';
comment on column ${iol_schema}.ncbs_fm_settle_method.dest_type is '目标类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.dp_settle_flag is '是否为dp清算';
comment on column ${iol_schema}.ncbs_fm_settle_method.format is '电位类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.is_cash is '是否现金';
comment on column ${iol_schema}.ncbs_fm_settle_method.media is '报表格式';
comment on column ${iol_schema}.ncbs_fm_settle_method.pay_rec is '收付标志';
comment on column ${iol_schema}.ncbs_fm_settle_method.print_mode is '打印模式';
comment on column ${iol_schema}.ncbs_fm_settle_method.release_security is '安全释放';
comment on column ${iol_schema}.ncbs_fm_settle_method.senders_contact_type is '发报方联系类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.settle_acct_type is '结算账户类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.settle_method is '结算方法';
comment on column ${iol_schema}.ncbs_fm_settle_method.settle_method_desc is '结算方法描述';
comment on column ${iol_schema}.ncbs_fm_settle_method.verify_security is '安全复合';
comment on column ${iol_schema}.ncbs_fm_settle_method.route is '联系方式类型';
comment on column ${iol_schema}.ncbs_fm_settle_method.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_settle_method.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_settle_method.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_settle_method.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_settle_method.etl_timestamp is 'ETL处理时间戳';
