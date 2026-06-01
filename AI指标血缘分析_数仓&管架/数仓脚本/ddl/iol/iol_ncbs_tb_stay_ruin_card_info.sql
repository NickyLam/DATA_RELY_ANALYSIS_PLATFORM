/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_stay_ruin_card_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_stay_ruin_card_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_stay_ruin_card_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_stay_ruin_card_info(
    card_no varchar2(50) -- 卡号
    ,client_name varchar2(200) -- 客户名称
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,remark varchar2(600) -- 备注
    ,atm_no varchar2(50) -- atm机编号
    ,company varchar2(20) -- 法人
    ,draw_man varchar2(30) -- 领取人
    ,other_bank_flag varchar2(1) -- 他行标记
    ,capture_date date -- 收缴日期
    ,ruin_date date -- 销毁日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,untread_date date -- 领取日期
    ,belong_user_id varchar2(8) -- 所属柜员
    ,capture_branch varchar2(12) -- 收缴机构
    ,capture_user_id varchar2(8) -- 收缴柜员
    ,open_branch varchar2(12) -- 开立机构
    ,ruin_branch varchar2(12) -- 销毁机构
    ,ruin_user_id varchar2(8) -- 销毁柜员
    ,untread_user_id varchar2(8) -- 领取交易柜员
    ,stay_card_type varchar2(1) -- 吞没卡种类
    ,stay_card_status varchar2(1) -- 吞没卡状态
    ,belong_branch varchar2(12) -- 归属机构
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
grant select on ${iol_schema}.ncbs_tb_stay_ruin_card_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_stay_ruin_card_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_stay_ruin_card_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_stay_ruin_card_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_stay_ruin_card_info is '待销毁卡管理登记表';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.card_no is '卡号';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.remark is '备注';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.atm_no is 'atm机编号';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.company is '法人';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.draw_man is '领取人';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.other_bank_flag is '他行标记';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.capture_date is '收缴日期';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.ruin_date is '销毁日期';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.untread_date is '领取日期';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.belong_user_id is '所属柜员';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.capture_branch is '收缴机构';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.capture_user_id is '收缴柜员';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.open_branch is '开立机构';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.ruin_branch is '销毁机构';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.ruin_user_id is '销毁柜员';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.untread_user_id is '领取交易柜员';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.stay_card_type is '吞没卡种类';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.stay_card_status is '吞没卡状态';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.belong_branch is '归属机构';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_stay_ruin_card_info.etl_timestamp is 'ETL处理时间戳';
