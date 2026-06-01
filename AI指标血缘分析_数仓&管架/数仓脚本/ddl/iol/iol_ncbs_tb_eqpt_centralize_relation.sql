/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_eqpt_centralize_relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_eqpt_centralize_relation
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_eqpt_centralize_relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_centralize_relation(
    address varchar2(400) -- 地址
    ,company varchar2(20) -- 法人
    ,centralize_flag varchar2(1) -- 是否集中式
    ,memo varchar2(50) -- 备用字段
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cash_sign_deal_user varchar2(8) -- 现金长短款处理柜员
    ,manage_branch varchar2(12) -- 管理机构编号
    ,virtual_user_id varchar2(8) -- 虚拟柜员代号
    ,virtual_branch varchar2(12) -- 虚拟柜员柜员所在机构
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
grant select on ${iol_schema}.ncbs_tb_eqpt_centralize_relation to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_centralize_relation to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_centralize_relation to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_centralize_relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_eqpt_centralize_relation is '自助设备集中式管理关系表';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.address is '地址';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.company is '法人';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.centralize_flag is '是否集中式';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.memo is '备用字段';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.cash_sign_deal_user is '现金长短款处理柜员';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.manage_branch is '管理机构编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.virtual_user_id is '虚拟柜员代号';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.virtual_branch is '虚拟柜员柜员所在机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_centralize_relation.etl_timestamp is 'ETL处理时间戳';
