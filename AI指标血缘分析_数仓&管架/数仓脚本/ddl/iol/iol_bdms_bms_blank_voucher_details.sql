/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_blank_voucher_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_blank_voucher_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_blank_voucher_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_blank_voucher_details(
    id varchar2(60) -- ID
    ,batch_id varchar2(60) -- 批次ID
    ,draft_no1 varchar2(15) -- 票据1
    ,draft_no2 varchar2(24) -- 票据2
    ,draft_number varchar2(45) -- 票号
    ,voucher_state varchar2(3) -- 凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废
    ,operator_no varchar2(45) -- 操作人
    ,branch_no varchar2(30) -- 机构号
    ,bank_no varchar2(18) -- 行号
    ,voucher_type varchar2(3) -- 凭证种类
    ,print_flag varchar2(3) -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,reserved_no varchar2(18) -- 预留号
    ,area_code varchar2(18) -- 省别地区代码
    ,print_id_code varchar2(18) -- 印制识别码
    ,reserve1 varchar2(75) -- 备注1
    ,reserve2 varchar2(75) -- 备注2
    ,reserve3 varchar2(75) -- 备注3
    ,misc varchar2(150) -- MISC
    ,last_upd_oper_no varchar2(45) -- 最后修改人编号
    ,take_time varchar2(21) -- 领用时间
    ,draft_type varchar2(2) -- 票据种类
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
grant select on ${iol_schema}.bdms_bms_blank_voucher_details to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_blank_voucher_details to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_blank_voucher_details to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_blank_voucher_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_blank_voucher_details is '凭证信息表';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.id is 'ID';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.batch_id is '批次ID';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.draft_no1 is '票据1';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.draft_no2 is '票据2';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.draft_number is '票号';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.voucher_state is '凭证状态： 0 已领用 1 已分配 2 已使用 3 已作废';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.operator_no is '操作人';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.branch_no is '机构号';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.bank_no is '行号';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.voucher_type is '凭证种类';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.print_flag is '补打标识： 0 有效 1 作废 2 补打中 3 补打完成';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.reserved_no is '预留号';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.area_code is '省别地区代码';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.print_id_code is '印制识别码';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.misc is 'MISC';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.last_upd_oper_no is '最后修改人编号';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.take_time is '领用时间';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.draft_type is '票据种类';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_blank_voucher_details.etl_timestamp is 'ETL处理时间戳';
