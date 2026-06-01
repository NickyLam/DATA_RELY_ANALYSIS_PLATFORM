/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_account_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_account_detail
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_account_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_account_detail(
    vouch_subnum varchar2(32) -- 凭证子表编号
    ,vouch_num varchar2(32) -- 凭证编号
    ,bus_vouchsubnum varchar2(32) -- 业务凭证子表编号
    ,happen_date date -- 发生日期
    ,table_id varchar2(32) -- 场景代码
    ,cd_flag varchar2(50) -- 借贷方向
    ,subject_no varchar2(30) -- 科目号
    ,happen_amt number(30,2) -- 发生额
    ,happen_number number(30,4) -- 发生数量
    ,busi_id varchar2(50) -- 业务明细代码
    ,ccy varchar2(50) -- 币种
    ,trade_id varchar2(32) -- 交易编号
    ,detail_subject_no varchar2(12) -- 四级科目号
    ,book_type varchar2(50) -- 凭证类型
    ,b_happen_amt number(30,2) -- 本位币发生额
    ,b_ccy varchar2(50) -- 本位币
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
grant select on ${iol_schema}.fams_ban_account_detail to ${iml_schema};
grant select on ${iol_schema}.fams_ban_account_detail to ${icl_schema};
grant select on ${iol_schema}.fams_ban_account_detail to ${idl_schema};
grant select on ${iol_schema}.fams_ban_account_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_account_detail is '凭证明细表';
comment on column ${iol_schema}.fams_ban_account_detail.vouch_subnum is '凭证子表编号';
comment on column ${iol_schema}.fams_ban_account_detail.vouch_num is '凭证编号';
comment on column ${iol_schema}.fams_ban_account_detail.bus_vouchsubnum is '业务凭证子表编号';
comment on column ${iol_schema}.fams_ban_account_detail.happen_date is '发生日期';
comment on column ${iol_schema}.fams_ban_account_detail.table_id is '场景代码';
comment on column ${iol_schema}.fams_ban_account_detail.cd_flag is '借贷方向';
comment on column ${iol_schema}.fams_ban_account_detail.subject_no is '科目号';
comment on column ${iol_schema}.fams_ban_account_detail.happen_amt is '发生额';
comment on column ${iol_schema}.fams_ban_account_detail.happen_number is '发生数量';
comment on column ${iol_schema}.fams_ban_account_detail.busi_id is '业务明细代码';
comment on column ${iol_schema}.fams_ban_account_detail.ccy is '币种';
comment on column ${iol_schema}.fams_ban_account_detail.trade_id is '交易编号';
comment on column ${iol_schema}.fams_ban_account_detail.detail_subject_no is '四级科目号';
comment on column ${iol_schema}.fams_ban_account_detail.book_type is '凭证类型';
comment on column ${iol_schema}.fams_ban_account_detail.b_happen_amt is '本位币发生额';
comment on column ${iol_schema}.fams_ban_account_detail.b_ccy is '本位币';
comment on column ${iol_schema}.fams_ban_account_detail.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_account_detail.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_account_detail.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_account_detail.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_account_detail.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_account_detail.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_account_detail.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_account_detail.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_account_detail.etl_timestamp is 'ETL处理时间戳';
