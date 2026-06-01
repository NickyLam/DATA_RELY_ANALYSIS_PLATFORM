/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_dpst_apply_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_dpst_apply_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_dpst_apply_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_dpst_apply_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次ID
    ,apply_id varchar2(30) -- 存托申请单编号
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_id varchar2(60) -- 票据表ID
    ,draft_number varchar2(45) -- 票号
    ,draft_amount number(18,2) -- 票据金额
    ,maturity_date varchar2(12) -- 到期日
    ,bp_no varchar2(45) -- 票据包编号
    ,bp_range varchar2(38) -- 票据区间
    ,discount_date varchar2(12) -- 贴现日
    ,remit_date varchar2(12) -- 出票日
    ,remitter_name varchar2(270) -- 出票人名称
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,pay_interest number(18,2) -- 应付利息
    ,settle_amount number(18,2) -- 结算金额
    ,valid_flag varchar2(2) -- 有效标识： 0 否 1 是
    ,wthd_status varchar2(3) -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,tenor_day varchar2(15) -- 剩余期限
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,standard_amt number(18,2) -- 标准金额
    ,org_draft_id varchar2(60) -- 原票据id
    ,split_range varchar2(38) -- 拆前区间
    ,org_draft_amount number(18,2) -- 原始票据（包）金额
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
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
grant select on ${iol_schema}.bdms_cpes_dpst_apply_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_dpst_apply_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_dpst_apply_details is '存托票据业务明细表';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.contract_id is '批次ID';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.draft_number is '票号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.bp_no is '票据包编号';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.bp_range is '票据区间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.discount_date is '贴现日';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.settle_amount is '结算金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.valid_flag is '有效标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.wthd_status is '退票状态： 00 未退票 01 主动退票 02 通知退票';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.tenor_day is '剩余期限';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.org_draft_id is '原票据id';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.split_range is '拆前区间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.org_draft_amount is '原始票据（包）金额';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_dpst_apply_details.etl_timestamp is 'ETL处理时间戳';
