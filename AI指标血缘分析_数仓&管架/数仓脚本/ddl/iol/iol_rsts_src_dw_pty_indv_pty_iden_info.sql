/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_pty_indv_pty_iden_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info(
    pty_id varchar2(60) -- 客户编号
    ,etl_dt_ora date -- 数据日期
    ,iden_typ_cd varchar2(30) -- 证件类型代码
    ,iden_num varchar2(400) -- 证件号码
    ,iden_eff_dt date -- 证件生效日期
    ,iden_due_dt date -- 证件到期日期
    ,iden_issue_org varchar2(100) -- 证件签发机关
    ,iden_issue_pla varchar2(200) -- 证件签发地
    ,iden_issue_cty_cd varchar2(3) -- 证件签发国家代码
    ,open_iden_flg varchar2(1) -- 开户证件标志
    ,prim_iden_flg varchar2(1) -- 主证件标志
    ,iden_status_cd varchar2(1) -- 证件状态代码
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
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
grant select on ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info is '数仓_个人客户证件信息';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.pty_id is '客户编号';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_typ_cd is '证件类型代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_num is '证件号码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_eff_dt is '证件生效日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_due_dt is '证件到期日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_issue_org is '证件签发机关';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_issue_pla is '证件签发地';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_issue_cty_cd is '证件签发国家代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.open_iden_flg is '开户证件标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.prim_iden_flg is '主证件标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.iden_status_cd is '证件状态代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_pty_indv_pty_iden_info.etl_timestamp is 'ETL处理时间戳';
