/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cif_client_restraints
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cif_client_restraints
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cif_client_restraints purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cif_client_restraints(
    res_seq_no varchar2(50) -- 限制编号
    ,restraint_type varchar2(3) -- 限制类型
    ,source_type varchar2(6) -- 渠道编号
    ,tran_date date -- 交易日期
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,maintain_type varchar2(1) -- 维护方式
    ,client_no varchar2(16) -- 客户编号
    ,start_date date -- 开始日期
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,end_date date -- 结束日期
    ,restraints_status varchar2(1) -- 限制状态
    ,narrative varchar2(400) -- 摘要
    ,user_id varchar2(8) -- 交易柜员编号
    ,auth_user_id varchar2(8) -- 授权柜员
    ,last_change_date date -- 最后修改日期
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,sign_user_id varchar2(8) -- 签约柜员
    ,out_sign_user_id varchar2(8) -- 解约柜员
    ,sign_channel varchar2(20) -- 签约渠道
    ,unlost_time varchar2(26) -- 解挂时间
    ,oper_narrative varchar2(400) -- 操作备注
    ,start_timestamp varchar2(26) -- 加限的交易时间戳
    ,actual_effect_time varchar2(26) -- 实际生效时间
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
grant select on ${iol_schema}.ncbs_cif_client_restraints to ${iml_schema};
grant select on ${iol_schema}.ncbs_cif_client_restraints to ${icl_schema};
grant select on ${iol_schema}.ncbs_cif_client_restraints to ${idl_schema};
grant select on ${iol_schema}.ncbs_cif_client_restraints to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cif_client_restraints is '客户限制表';
comment on column ${iol_schema}.ncbs_cif_client_restraints.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_cif_client_restraints.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_cif_client_restraints.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cif_client_restraints.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cif_client_restraints.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cif_client_restraints.maintain_type is '维护方式';
comment on column ${iol_schema}.ncbs_cif_client_restraints.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cif_client_restraints.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cif_client_restraints.term is '存期';
comment on column ${iol_schema}.ncbs_cif_client_restraints.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_cif_client_restraints.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cif_client_restraints.restraints_status is '限制状态';
comment on column ${iol_schema}.ncbs_cif_client_restraints.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cif_client_restraints.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cif_client_restraints.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cif_client_restraints.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cif_client_restraints.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cif_client_restraints.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cif_client_restraints.company is '法人';
comment on column ${iol_schema}.ncbs_cif_client_restraints.sign_user_id is '签约柜员';
comment on column ${iol_schema}.ncbs_cif_client_restraints.out_sign_user_id is '解约柜员';
comment on column ${iol_schema}.ncbs_cif_client_restraints.sign_channel is '签约渠道';
comment on column ${iol_schema}.ncbs_cif_client_restraints.unlost_time is '解挂时间';
comment on column ${iol_schema}.ncbs_cif_client_restraints.oper_narrative is '操作备注';
comment on column ${iol_schema}.ncbs_cif_client_restraints.start_timestamp is '加限的交易时间戳';
comment on column ${iol_schema}.ncbs_cif_client_restraints.actual_effect_time is '实际生效时间';
comment on column ${iol_schema}.ncbs_cif_client_restraints.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cif_client_restraints.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cif_client_restraints.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cif_client_restraints.etl_timestamp is 'ETL处理时间戳';
