/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_bok_clawback_info_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_bok_clawback_info_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_bok_clawback_info_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_clawback_info_detail(
    bookset_id varchar2(32) -- 账套代码
    ,layering_id varchar2(32) -- 分层代码，子产品存分层代码，母产品存核算主体代码
    ,finprod_id varchar2(32) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型
    ,branch number(10) -- 分支序号
    ,happen_date date -- 会计日期
    ,book_date date -- 入账日期
    ,bookset_date date -- 账套日期
    ,fee_type varchar2(50) -- 费用类型
    ,clawback_amt number(30,2) -- 回补金额
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
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
grant select on ${iol_schema}.fams_bok_clawback_info_detail to ${iml_schema};
grant select on ${iol_schema}.fams_bok_clawback_info_detail to ${icl_schema};
grant select on ${iol_schema}.fams_bok_clawback_info_detail to ${idl_schema};
grant select on ${iol_schema}.fams_bok_clawback_info_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_bok_clawback_info_detail is '账套回补信息明细';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.layering_id is '分层代码，子产品存分层代码，母产品存核算主体代码';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.finprod_type is '金融产品类型';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.branch is '分支序号';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.happen_date is '会计日期';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.book_date is '入账日期';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.bookset_date is '账套日期';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.fee_type is '费用类型';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.clawback_amt is '回补金额';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.create_user is '创建人';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.create_dept is '创建部门';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.create_time is '创建时间';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.update_user is '更新人';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.update_time is '更新时间';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.start_dt is '开始时间';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.end_dt is '结束时间';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.id_mark is '增删标志';
comment on column ${iol_schema}.fams_bok_clawback_info_detail.etl_timestamp is 'ETL处理时间戳';
