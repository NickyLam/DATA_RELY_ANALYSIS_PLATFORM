/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_voucher_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_voucher_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_voucher_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_def(
    doc_type varchar2(10) -- 凭证类型
    ,profit_center varchar2(20) -- 利润中心
    ,user_id varchar2(8) -- 交易柜员编号
    ,allow_cheque_denom_flag varchar2(1) -- 有价单证是否固定面额标志
    ,allow_distr_flag varchar2(1) -- 允许调拨标志
    ,branch_restraint_flag varchar2(1) -- 是否限制机构使用
    ,company varchar2(20) -- 法人
    ,deposit_type varchar2(1) -- 存款类型
    ,doc_class varchar2(3) -- 存款凭证种类
    ,doc_type_desc varchar2(50) -- 凭证类型描述
    ,have_number varchar2(1) -- 是否有号
    ,in_contral varchar2(1) -- 总行入库标志
    ,is_cash_cheque varchar2(1) -- 是否现金支票标记
    ,is_cheque_book varchar2(1) -- 是否支票标记
    ,other_bank_flag varchar2(1) -- 他行标记
    ,prefix_req varchar2(1) -- 前缀标志
    ,sale_flag varchar2(1) -- 出售类凭证标志
    ,tc_denom_group varchar2(10) -- 有价单证固定面额组
    ,use_by_order_flag varchar2(1) -- 是否按顺序使用
    ,voucher_approve_status varchar2(1) -- 批准状态
    ,voucher_bill_ind varchar2(1) -- 凭证票据标识
    ,voucher_length varchar2(5) -- 凭证号长度
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,commission_vou_lost_days number(5) -- 代办人口挂天数
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,vou_lost_days number(5) -- 口挂天数
    ,vou_lost_reissue_days number(5) -- 挂失补发天数
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
grant select on ${iol_schema}.ncbs_tb_voucher_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_voucher_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_voucher_def is '凭证类型定义表';
comment on column ${iol_schema}.ncbs_tb_voucher_def.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_tb_voucher_def.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_tb_voucher_def.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_voucher_def.allow_cheque_denom_flag is '有价单证是否固定面额标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.allow_distr_flag is '允许调拨标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.branch_restraint_flag is '是否限制机构使用';
comment on column ${iol_schema}.ncbs_tb_voucher_def.company is '法人';
comment on column ${iol_schema}.ncbs_tb_voucher_def.deposit_type is '存款类型';
comment on column ${iol_schema}.ncbs_tb_voucher_def.doc_class is '存款凭证种类';
comment on column ${iol_schema}.ncbs_tb_voucher_def.doc_type_desc is '凭证类型描述';
comment on column ${iol_schema}.ncbs_tb_voucher_def.have_number is '是否有号';
comment on column ${iol_schema}.ncbs_tb_voucher_def.in_contral is '总行入库标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.is_cash_cheque is '是否现金支票标记';
comment on column ${iol_schema}.ncbs_tb_voucher_def.is_cheque_book is '是否支票标记';
comment on column ${iol_schema}.ncbs_tb_voucher_def.other_bank_flag is '他行标记';
comment on column ${iol_schema}.ncbs_tb_voucher_def.prefix_req is '前缀标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.sale_flag is '出售类凭证标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.tc_denom_group is '有价单证固定面额组';
comment on column ${iol_schema}.ncbs_tb_voucher_def.use_by_order_flag is '是否按顺序使用';
comment on column ${iol_schema}.ncbs_tb_voucher_def.voucher_approve_status is '批准状态';
comment on column ${iol_schema}.ncbs_tb_voucher_def.voucher_bill_ind is '凭证票据标识';
comment on column ${iol_schema}.ncbs_tb_voucher_def.voucher_length is '凭证号长度';
comment on column ${iol_schema}.ncbs_tb_voucher_def.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_tb_voucher_def.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_tb_voucher_def.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_tb_voucher_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_voucher_def.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_def.commission_vou_lost_days is '代办人口挂天数';
comment on column ${iol_schema}.ncbs_tb_voucher_def.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_tb_voucher_def.vou_lost_days is '口挂天数';
comment on column ${iol_schema}.ncbs_tb_voucher_def.vou_lost_reissue_days is '挂失补发天数';
comment on column ${iol_schema}.ncbs_tb_voucher_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_voucher_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_voucher_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_voucher_def.etl_timestamp is 'ETL处理时间戳';
