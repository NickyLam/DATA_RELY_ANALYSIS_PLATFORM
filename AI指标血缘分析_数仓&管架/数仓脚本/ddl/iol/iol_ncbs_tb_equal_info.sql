/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_equal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_equal_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_equal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_equal_info(
    user_id varchar2(8) -- 交易柜员编号
    ,agent_flag varchar2(1) -- 代理标志
    ,company varchar2(20) -- 法人
    ,equal_class varchar2(1) -- 碰库种类
    ,equal_seq_no varchar2(50) -- 碰库序号
    ,equal_type varchar2(1) -- 碰库类型
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,equal_date date -- 碰库日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,agent_user_id varchar2(8) -- 代碰库柜员
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
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
grant select on ${iol_schema}.ncbs_tb_equal_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_equal_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_equal_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_equal_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_equal_info is '碰库信息表';
comment on column ${iol_schema}.ncbs_tb_equal_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_equal_info.agent_flag is '代理标志';
comment on column ${iol_schema}.ncbs_tb_equal_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_equal_info.equal_class is '碰库种类';
comment on column ${iol_schema}.ncbs_tb_equal_info.equal_seq_no is '碰库序号';
comment on column ${iol_schema}.ncbs_tb_equal_info.equal_type is '碰库类型';
comment on column ${iol_schema}.ncbs_tb_equal_info.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_equal_info.equal_date is '碰库日期';
comment on column ${iol_schema}.ncbs_tb_equal_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_equal_info.agent_user_id is '代碰库柜员';
comment on column ${iol_schema}.ncbs_tb_equal_info.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_equal_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_equal_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_equal_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_equal_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_equal_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_equal_info.etl_timestamp is 'ETL处理时间戳';
