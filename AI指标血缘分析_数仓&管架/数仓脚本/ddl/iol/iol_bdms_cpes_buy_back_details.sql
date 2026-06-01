/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_buy_back_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_buy_back_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_buy_back_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_back_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 批次表ID
    ,draft_id varchar2(60) -- 票据ID
    ,valid_flag varchar2(2) -- 有效标识 0 无效 1 有效
    ,draft_amount number(18,2) -- 票据金额
    ,buy_back_pay_interest number(18,2) -- 赎回应付利息
    ,buy_back_amount number(18,2) -- 赎回金额
    ,deal_status varchar2(3) -- 处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,last_upd_opr varchar2(45) -- 最后操作人
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,draft_number varchar2(45) -- 票据(包)号
    ,cd_range varchar2(38) -- 子票区间
    ,buss_flag varchar2(3) -- 业务类型： 01 申请 02 签收
    ,brh_no varchar2(14) -- 本方机构号
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
grant select on ${iol_schema}.bdms_cpes_buy_back_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_back_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_buy_back_details is '提前和逾期赎回申请批次明细表';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.contract_id is '批次表ID';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.valid_flag is '有效标识 0 无效 1 有效';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.buy_back_pay_interest is '赎回应付利息';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.buy_back_amount is '赎回金额';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.deal_status is '处理状态： 00 未处理 01 发送中 02 发送成功 03 返回成功 04 返回失败 05 通讯失败 06 撤回中 07 撤回成功 08 撤回失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.last_upd_opr is '最后操作人';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.draft_number is '票据(包)号';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.buss_flag is '业务类型： 01 申请 02 签收';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.brh_no is '本方机构号';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_buy_back_details.etl_timestamp is 'ETL处理时间戳';
