/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_collat_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_collat_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_collat_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_collat_info(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,remark varchar2(600) -- 备注
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,collat_no varchar2(32) -- 押品编号
    ,collat_type varchar2(10) -- 抵押品种类
    ,company varchar2(20) -- 法人
    ,tran_seq_no varchar2(50) -- 交易序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,payment_direction varchar2(10) -- 押品收付方向
    ,register_type varchar2(10) -- 登记薄类型
    ,collat_amount number(17,2) -- 押品金额
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
grant select on ${iol_schema}.ncbs_cl_collat_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_collat_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_collat_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_collat_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_collat_info is '押品登记信息表';
comment on column ${iol_schema}.ncbs_cl_collat_info.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_collat_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_collat_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_collat_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_collat_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_collat_info.remark is '备注';
comment on column ${iol_schema}.ncbs_cl_collat_info.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_collat_info.collat_no is '押品编号';
comment on column ${iol_schema}.ncbs_cl_collat_info.collat_type is '抵押品种类';
comment on column ${iol_schema}.ncbs_cl_collat_info.company is '法人';
comment on column ${iol_schema}.ncbs_cl_collat_info.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_cl_collat_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_collat_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_collat_info.payment_direction is '押品收付方向';
comment on column ${iol_schema}.ncbs_cl_collat_info.register_type is '登记薄类型';
comment on column ${iol_schema}.ncbs_cl_collat_info.collat_amount is '押品金额';
comment on column ${iol_schema}.ncbs_cl_collat_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_collat_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_collat_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_collat_info.etl_timestamp is 'ETL处理时间戳';
