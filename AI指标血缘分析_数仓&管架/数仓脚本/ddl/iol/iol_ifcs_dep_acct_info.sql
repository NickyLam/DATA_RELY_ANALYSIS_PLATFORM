/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_dep_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_dep_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_dep_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_dep_acct_info(
    acct_id varchar2(90) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,cust_id varchar2(90) -- 客户编号
    ,acct_type_cd varchar2(15) -- 账户类型代码
    ,open_acct_chn_cd varchar2(15) -- 开户渠道代码
    ,open_acct_dt varchar2(15) -- 开户日期
    ,acct_status_cd varchar2(15) -- 账户状态代码
    ,froz_status varchar2(15) -- 冻结状态
    ,stpay_status_cd varchar2(15) -- 止付状态
    ,acpt_pay_status varchar2(15) -- 收付标志
    ,sleep_acct_flg varchar2(15) -- 睡眠户标志
    ,dormt_acct_flg varchar2(15) -- 不动户标志
    ,acct_usage_cd varchar2(45) -- 账户用途代码
    ,open_acct_flow_num varchar2(90) -- 开户流水号
    ,acct_kind_cd varchar2(15) -- 账户种类代码
    ,open_acct_org_id varchar2(90) -- 开户机构编号
    ,close_acct_dt varchar2(15) -- 销户日期
    ,close_acct_ti varchar2(32) -- 销户时间
    ,close_acct_flow_num varchar2(90) -- 销户流水号
    ,last_sub_id varchar2(15) -- 最后子户序号
    ,bind_acct_id varchar2(150) -- 绑定微众账户编号
    ,last_activ_acct_dt varchar2(15) -- 最后动户日期
    ,open_acct_tm varchar2(32) -- 开户完成时间
    ,part_id varchar2(6) -- 分区id
    ,base_val varchar2(30) -- 基准值
    ,sync_status_cd varchar2(15) -- 同步状态
    ,accept_status varchar2(2) -- 止收状态
    ,dps_type_cd varchar2(5) -- 储种
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
grant select on ${iol_schema}.ifcs_dep_acct_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_dep_acct_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_dep_acct_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_dep_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_dep_acct_info is '账户信息表';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_id is '账户编号';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_name is '账户名称';
comment on column ${iol_schema}.ifcs_dep_acct_info.cust_id is '客户编号';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_type_cd is '账户类型代码';
comment on column ${iol_schema}.ifcs_dep_acct_info.open_acct_chn_cd is '开户渠道代码';
comment on column ${iol_schema}.ifcs_dep_acct_info.open_acct_dt is '开户日期';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_status_cd is '账户状态代码';
comment on column ${iol_schema}.ifcs_dep_acct_info.froz_status is '冻结状态';
comment on column ${iol_schema}.ifcs_dep_acct_info.stpay_status_cd is '止付状态';
comment on column ${iol_schema}.ifcs_dep_acct_info.acpt_pay_status is '收付标志';
comment on column ${iol_schema}.ifcs_dep_acct_info.sleep_acct_flg is '睡眠户标志';
comment on column ${iol_schema}.ifcs_dep_acct_info.dormt_acct_flg is '不动户标志';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_usage_cd is '账户用途代码';
comment on column ${iol_schema}.ifcs_dep_acct_info.open_acct_flow_num is '开户流水号';
comment on column ${iol_schema}.ifcs_dep_acct_info.acct_kind_cd is '账户种类代码';
comment on column ${iol_schema}.ifcs_dep_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${iol_schema}.ifcs_dep_acct_info.close_acct_dt is '销户日期';
comment on column ${iol_schema}.ifcs_dep_acct_info.close_acct_ti is '销户时间';
comment on column ${iol_schema}.ifcs_dep_acct_info.close_acct_flow_num is '销户流水号';
comment on column ${iol_schema}.ifcs_dep_acct_info.last_sub_id is '最后子户序号';
comment on column ${iol_schema}.ifcs_dep_acct_info.bind_acct_id is '绑定微众账户编号';
comment on column ${iol_schema}.ifcs_dep_acct_info.last_activ_acct_dt is '最后动户日期';
comment on column ${iol_schema}.ifcs_dep_acct_info.open_acct_tm is '开户完成时间';
comment on column ${iol_schema}.ifcs_dep_acct_info.part_id is '分区id';
comment on column ${iol_schema}.ifcs_dep_acct_info.base_val is '基准值';
comment on column ${iol_schema}.ifcs_dep_acct_info.sync_status_cd is '同步状态';
comment on column ${iol_schema}.ifcs_dep_acct_info.accept_status is '止收状态';
comment on column ${iol_schema}.ifcs_dep_acct_info.dps_type_cd is '储种';
comment on column ${iol_schema}.ifcs_dep_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.ifcs_dep_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.ifcs_dep_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.ifcs_dep_acct_info.etl_timestamp is 'ETL处理时间戳';
