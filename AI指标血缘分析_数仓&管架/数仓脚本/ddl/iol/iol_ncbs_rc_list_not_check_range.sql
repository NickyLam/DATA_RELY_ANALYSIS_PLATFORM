/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rc_list_not_check_range
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rc_list_not_check_range
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rc_list_not_check_range purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rc_list_not_check_range(
    remark varchar2(600) -- 备注
    ,list_type varchar2(10) -- 名单类型代码
    ,company varchar2(20) -- 法人
    ,message_code varchar2(10) -- 接口服务代码
    ,message_type varchar2(10) -- 接口服务类型
    ,program_id varchar2(20) -- 交易代码
    ,seq_no varchar2(50) -- 序号
    ,service_code varchar2(20) -- 服务代码
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rc_list_not_check_range to ${iml_schema};
grant select on ${iol_schema}.ncbs_rc_list_not_check_range to ${icl_schema};
grant select on ${iol_schema}.ncbs_rc_list_not_check_range to ${idl_schema};
grant select on ${iol_schema}.ncbs_rc_list_not_check_range to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rc_list_not_check_range is '黑灰名单不检查范围表';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.remark is '备注';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.list_type is '名单类型代码';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.company is '法人';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.message_code is '接口服务代码';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.message_type is '接口服务类型';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.service_code is '服务代码';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rc_list_not_check_range.etl_timestamp is 'ETL处理时间戳';
