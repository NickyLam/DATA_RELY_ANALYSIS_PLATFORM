/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_dz_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_dz_info
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_dz_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_dz_info(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,draw_dt varchar2(10) -- 动支日期
    ,draw_cnt number(20) -- 申请笔数
    ,draw_pass_cnt number(20) -- 通过笔数
    ,draw_pass_percent number(38,4) -- 通过率
    ,draw_amt number(38,4) -- 总放款
    ,draw_amt_avg number(38,4) -- 放款件均
    ,avg_pricing number(38,4) -- 平均定价
    ,disb_ratio number(38,4) -- 支用比例
    ,bal number(38,2) -- 在贷余额
    ,prod_cls_name varchar2(150) -- 产品分类(易贷，字节)
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
grant select on ${idl_schema}.mckb_dz_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_dz_info is '整体-进件-提现';
comment on column ${idl_schema}.mckb_dz_info.org_id is '机构编号';
comment on column ${idl_schema}.mckb_dz_info.org_name is '机构名称';
comment on column ${idl_schema}.mckb_dz_info.draw_dt is '动支日期';
comment on column ${idl_schema}.mckb_dz_info.draw_cnt is '申请笔数';
comment on column ${idl_schema}.mckb_dz_info.draw_pass_cnt is '通过笔数';
comment on column ${idl_schema}.mckb_dz_info.draw_pass_percent is '通过率';
comment on column ${idl_schema}.mckb_dz_info.draw_amt is '总放款';
comment on column ${idl_schema}.mckb_dz_info.draw_amt_avg is '放款件均';
comment on column ${idl_schema}.mckb_dz_info.avg_pricing is '平均定价';
comment on column ${idl_schema}.mckb_dz_info.disb_ratio is '支用比例';
comment on column ${idl_schema}.mckb_dz_info.bal is '在贷余额';
comment on column ${idl_schema}.mckb_dz_info.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_dz_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_dz_info.etl_timestamp is 'ETL处理时间戳';