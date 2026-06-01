/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tailbox_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tailbox_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tailbox_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tailbox_tran_hist(
    branch varchar2(12) -- 机构编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_date date -- 交易日期
    ,tran_time varchar2(26) -- 交易时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,to_user_id varchar2(8) -- 对方柜员
    ,tailbox_option varchar2(2) -- 尾箱维护类型
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
grant select on ${iol_schema}.ncbs_tb_tailbox_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tailbox_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tailbox_tran_hist is '尾箱操作历史信息表';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.tran_time is '交易时间';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.to_user_id is '对方柜员';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.tailbox_option is '尾箱维护类型';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_tailbox_tran_hist.etl_timestamp is 'ETL处理时间戳';
