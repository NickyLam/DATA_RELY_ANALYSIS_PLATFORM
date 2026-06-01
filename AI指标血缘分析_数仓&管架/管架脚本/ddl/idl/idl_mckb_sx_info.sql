/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_sx_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_sx_info
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_sx_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_sx_info(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,appl_dt varchar2(10) -- 申请日期
    ,appl_cnt number(20) -- 申请笔数
    ,appl_pass_cnt number(20) -- 通过笔数
    ,appl_pass_percent number(38,4) -- 通过率
    ,credit_amount_avg number(38,4) -- 授信件均
    ,rate number(38,4) -- 平均定价
    ,avg_lmt number(38,4) -- 平均额度
    ,prod_cls_name varchar2(150) -- 产品分类(字节,字节助贷,字节联贷)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_sx_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_sx_info is '整体-进件-授信-字节';
comment on column ${idl_schema}.mckb_sx_info.org_id is '机构编号';
comment on column ${idl_schema}.mckb_sx_info.org_name is '机构名称';
comment on column ${idl_schema}.mckb_sx_info.appl_dt is '申请日期';
comment on column ${idl_schema}.mckb_sx_info.appl_cnt is '申请笔数';
comment on column ${idl_schema}.mckb_sx_info.appl_pass_cnt is '通过笔数';
comment on column ${idl_schema}.mckb_sx_info.appl_pass_percent is '通过率';
comment on column ${idl_schema}.mckb_sx_info.credit_amount_avg is '授信件均';
comment on column ${idl_schema}.mckb_sx_info.rate is '平均定价';
comment on column ${idl_schema}.mckb_sx_info.avg_lmt is '平均额度';
comment on column ${idl_schema}.mckb_sx_info.prod_cls_name is '产品分类(字节,字节助贷,字节联贷)';
comment on column ${idl_schema}.mckb_sx_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_sx_info.etl_timestamp is 'ETL处理时间戳';