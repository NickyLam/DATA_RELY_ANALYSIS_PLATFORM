/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_sdn_dpst_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_sdn_dpst_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_sdn_dpst_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_sdn_dpst_details(
    id varchar2(60) -- ID
    ,dpst_apply_id varchar2(60) -- 申请单表ID
    ,apply_id varchar2(30) -- 存托申请单编号
    ,draft_number varchar2(45) -- 票号
    ,bp_no varchar2(45) -- 票据包编号
    ,bp_range varchar2(38) -- 票据区间
    ,draft_amount number(18,2) -- 票据金额
    ,maturity_date varchar2(12) -- 到期日
    ,pay_interest number(18,2) -- 应付利息
    ,settle_amount number(18,2) -- 结算金额
    ,return_date varchar2(12) -- 退票日期
    ,valid_flag varchar2(2) -- 有效标识： 0 否 1 是
    ,wthd_status varchar2(3) -- 退票状态： 00 未退票 01 主动退票 02 通知退票
    ,tenor_day varchar2(15) -- 剩余期限
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,standard_amt number(18,2) -- 标准金额
    ,create_time varchar2(21) -- 鍒涘缓鏃堕棿
    ,create_by varchar2(45) -- 创建人
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
grant select on ${iol_schema}.bdms_sdn_dpst_details to ${iml_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_details to ${icl_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_details to ${idl_schema};
grant select on ${iol_schema}.bdms_sdn_dpst_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_sdn_dpst_details is '存托票据业明细表';
comment on column ${iol_schema}.bdms_sdn_dpst_details.id is 'ID';
comment on column ${iol_schema}.bdms_sdn_dpst_details.dpst_apply_id is '申请单表ID';
comment on column ${iol_schema}.bdms_sdn_dpst_details.apply_id is '存托申请单编号';
comment on column ${iol_schema}.bdms_sdn_dpst_details.draft_number is '票号';
comment on column ${iol_schema}.bdms_sdn_dpst_details.bp_no is '票据包编号';
comment on column ${iol_schema}.bdms_sdn_dpst_details.bp_range is '票据区间';
comment on column ${iol_schema}.bdms_sdn_dpst_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_sdn_dpst_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_sdn_dpst_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_sdn_dpst_details.settle_amount is '结算金额';
comment on column ${iol_schema}.bdms_sdn_dpst_details.return_date is '退票日期';
comment on column ${iol_schema}.bdms_sdn_dpst_details.valid_flag is '有效标识： 0 否 1 是';
comment on column ${iol_schema}.bdms_sdn_dpst_details.wthd_status is '退票状态： 00 未退票 01 主动退票 02 通知退票';
comment on column ${iol_schema}.bdms_sdn_dpst_details.tenor_day is '剩余期限';
comment on column ${iol_schema}.bdms_sdn_dpst_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_sdn_dpst_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_sdn_dpst_details.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_sdn_dpst_details.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_sdn_dpst_details.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_sdn_dpst_details.create_time is '鍒涘缓鏃堕棿';
comment on column ${iol_schema}.bdms_sdn_dpst_details.create_by is '创建人';
comment on column ${iol_schema}.bdms_sdn_dpst_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_sdn_dpst_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_sdn_dpst_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_sdn_dpst_details.etl_timestamp is 'ETL处理时间戳';
