/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_apply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_apply_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_apply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_apply_info(
    reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,apply_id varchar2(50) -- 申请预约编号
    ,apply_type varchar2(1) -- 预约申请类型
    ,company varchar2(20) -- 法人
    ,confirm_user_id varchar2(30) -- 确认柜员编号
    ,in_out_type varchar2(1) -- 调入调出方式
    ,move_id varchar2(30) -- 调拨转移id
    ,narrative varchar2(400) -- 摘要
    ,apply_date date -- 申请日期
    ,approve_date date -- 批准日期
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,apply_user_id varchar2(8) -- 申请柜员
    ,appr_user_id varchar2(8) -- 复核柜员
    ,approve_branch varchar2(12) -- 复核柜员所属机构
    ,refuse_reason varchar2(200) -- 拒绝原因
    ,to_branch varchar2(12) -- 对方机构
    ,from_branch varchar2(12) -- 转出机构
    ,apply_branch varchar2(12) -- 申请机构
    ,dispatch_date date -- 调拨日期
    ,apply_status varchar2(1) -- 现金凭证预约状态
    ,confirm_branch varchar2(20) -- 确认机构
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
grant select on ${iol_schema}.ncbs_tb_voucher_apply_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_apply_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_apply_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_apply_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_apply_info is '凭证预约申请信息表';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_id is '申请预约编号';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_type is '预约申请类型';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.confirm_user_id is '确认柜员编号';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.in_out_type is '调入调出方式';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_date is '申请日期';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.approve_date is '批准日期';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_user_id is '申请柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.approve_branch is '复核柜员所属机构';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.refuse_reason is '拒绝原因';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.to_branch is '对方机构';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.from_branch is '转出机构';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_branch is '申请机构';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.dispatch_date is '调拨日期';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.apply_status is '现金凭证预约状态';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.confirm_branch is '确认机构';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_apply_info.etl_timestamp is 'ETL处理时间戳';
