/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_eqpt_cash_tran_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_eqpt_cash_tran_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_eqpt_cash_tran_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_cash_tran_info(
    ccy varchar2(3) -- 币种
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,user_id varchar2(8) -- 交易柜员编号
    ,batch_no varchar2(50) -- 批次号
    ,company varchar2(20) -- 法人
    ,confirm_user_id varchar2(30) -- 确认柜员编号
    ,centralize_flag varchar2(1) -- 是否集中式
    ,move_id varchar2(30) -- 调拨转移id
    ,on_way_status varchar2(1) -- 在途状态
    ,reserve_flag varchar2(1) -- 冲正标志
    ,confirm_date date -- 上缴确认日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,confirm_branch varchar2(20) -- 确认机构
    ,eqpt_type varchar2(5) -- 自助设备类型
    ,eqpt_seq_no varchar2(50) -- 自助设备交易编号
    ,eqpt_tran_operate_type varchar2(2) -- 自助设备交易操作类型
    ,eqpt_tran_status varchar2(2) -- 自助设备交易流程状态
    ,confirm_tran_amt number(17,2) -- 确认金额
    ,confirm_reference varchar2(50) -- 确认交易流水号
    ,eqpt_mistake_id varchar2(50) -- 自助设备交易差错编号
    ,virtual_user_id varchar2(8) -- 虚拟柜员代号
    ,virtual_branch varchar2(12) -- 虚拟柜员柜员所在机构
    ,virtual_tailbox_id varchar2(20) -- 虚拟柜员柜员尾箱id
    ,teller_user_id varchar2(8) -- 自助设备出库真实柜员
    ,teller_branch varchar2(12) -- 自助设备出库真实柜员所属机构
    ,teller_trailbox_id varchar2(50) -- 自助设备出库真实柜员尾箱
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
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_eqpt_cash_tran_info is '自助设备现金交易信息表';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.confirm_user_id is '确认柜员编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.centralize_flag is '是否集中式';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.on_way_status is '在途状态';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.confirm_date is '上缴确认日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.confirm_branch is '确认机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.eqpt_type is '自助设备类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.eqpt_seq_no is '自助设备交易编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.eqpt_tran_operate_type is '自助设备交易操作类型';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.eqpt_tran_status is '自助设备交易流程状态';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.confirm_tran_amt is '确认金额';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.confirm_reference is '确认交易流水号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.eqpt_mistake_id is '自助设备交易差错编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.virtual_user_id is '虚拟柜员代号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.virtual_branch is '虚拟柜员柜员所在机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.virtual_tailbox_id is '虚拟柜员柜员尾箱id';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.teller_user_id is '自助设备出库真实柜员';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.teller_branch is '自助设备出库真实柜员所属机构';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.teller_trailbox_id is '自助设备出库真实柜员尾箱';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_info.etl_timestamp is 'ETL处理时间戳';
