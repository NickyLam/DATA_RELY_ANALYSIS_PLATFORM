/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_draft_centre_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_draft_centre_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_draft_centre_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_draft_centre_info(
    id varchar2(60) -- ID
    ,draft_number varchar2(45) -- 票据号码
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,src_type varchar2(3) -- 票据来源
    ,buy_contract_id varchar2(60) -- 买入协议ID
    ,trans_id varchar2(60) -- 交易ID
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 票据到期日期
    ,draft_amount number(18,2) -- 票面金额
    ,remitter_role varchar2(6) -- 出票人类别
    ,remitter_cmonid varchar2(15) -- 出票人组织机构代码
    ,remitter_name varchar2(270) -- 出票人名称
    ,remitter_account varchar2(60) -- 出票人账号
    ,remitter_bank_no varchar2(30) -- 出票人开户行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,df_drwr_cdtratgs varchar2(5) -- 出票人-信用等级
    ,df_drwr_cdtratgsagcy varchar2(270) -- 出票人-评级机构
    ,df_drwr_cdtratgduedt varchar2(12) -- 出票人-评级到期日
    ,acceptor_role varchar2(6) -- 承兑人类别
    ,acceptor_name varchar2(270) -- 承兑人
    ,acceptor_bank_no varchar2(30) -- 承兑人开户行
    ,acceptor_account varchar2(60) -- 承兑人账号
    ,acceptor_bank_name varchar2(300) -- 承兑人开户行名称
    ,drawee_bank_name varchar2(300) -- 付款行全称
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_address varchar2(300) -- 付款行地址
    ,payee_name varchar2(270) -- 票面收款人名称
    ,payee_account varchar2(60) -- 票面收款人账号
    ,payee_bank_no varchar2(30) -- 票面收款人开户行号
    ,payee_bank_name varchar2(270) -- 票面收款人开户行
    ,payee_cust_no varchar2(45) -- 收款人客户NO
    ,payee_organ_code varchar2(45) -- 票面收款人组织机构代码
    ,draft_remark varchar2(384) -- 票面备注
    ,inner_accept_flag varchar2(2) -- 是否系统内承兑： 0 否 1 是
    ,belong_branch_no varchar2(30) -- 票据所属机构号
    ,store_status varchar2(23) -- 实物库存状态
    ,last_operator_no varchar2(45) -- 最后修改操作员号
    ,last_txn_date timestamp -- 最后修改时间
    ,endorse_times number(22,0) -- 背书次数
    ,deduct_status varchar2(2) -- 扣款状态（是否扣款）： 0 否 1 是
    ,first_trans_id varchar2(60) -- 最初进系统的交易ID
    ,recently_trans_id varchar2(60) -- 最近进系统的交易ID
    ,payment_status varchar2(2) -- 付款状态（是否付款）： 0 否 1 是
    ,del_flag varchar2(3) -- 删除标志： 0 否 1 是
    ,report_of_loss_flag varchar2(3) -- 挂失状态（是否挂失）： 0 否 1 是
    ,reserve1 varchar2(150) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,reserve3 varchar2(150) -- 备注3
    ,reserve4 varchar2(150) -- 备注4
    ,apply_trans_id varchar2(60) -- 申请ID
    ,sign_trans_id varchar2(60) -- 签收ID
    ,prov_interest number(22,2) -- PROV_INTEREST
    ,rema_interest number(22,2) -- REMA_INTEREST
    ,is_receipt varchar2(6) -- 是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）
    ,stock_status varchar2(30) -- 是否再贴现（1-已再贴现，0-库存。）
    ,draft_transfer_flag varchar2(6) -- 票面不得转让标志：EM00 可再转让 EM01 不得转让
    ,voucher_no varchar2(45) -- 凭证号
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
grant select on ${iol_schema}.bdms_bms_draft_centre_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_draft_centre_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_draft_centre_info is '票据信息主表';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.src_type is '票据来源';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.buy_contract_id is '买入协议ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.trans_id is '交易ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.maturity_date is '票据到期日期';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_role is '出票人类别';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_cmonid is '出票人组织机构代码';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_bank_no is '出票人开户行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.df_drwr_cdtratgs is '出票人-信用等级';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.df_drwr_cdtratgsagcy is '出票人-评级机构';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.df_drwr_cdtratgduedt is '出票人-评级到期日';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.acceptor_role is '承兑人类别';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.acceptor_name is '承兑人';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.acceptor_bank_no is '承兑人开户行';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.drawee_bank_name is '付款行全称';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.drawee_address is '付款行地址';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_name is '票面收款人名称';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_account is '票面收款人账号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_bank_no is '票面收款人开户行号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_bank_name is '票面收款人开户行';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_cust_no is '收款人客户NO';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payee_organ_code is '票面收款人组织机构代码';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.inner_accept_flag is '是否系统内承兑： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.belong_branch_no is '票据所属机构号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.store_status is '实物库存状态';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.last_operator_no is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.last_txn_date is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.deduct_status is '扣款状态（是否扣款）： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.first_trans_id is '最初进系统的交易ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.recently_trans_id is '最近进系统的交易ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.payment_status is '付款状态（是否付款）： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.del_flag is '删除标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.report_of_loss_flag is '挂失状态（是否挂失）： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.reserve4 is '备注4';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.apply_trans_id is '申请ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.sign_trans_id is '签收ID';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.prov_interest is 'PROV_INTEREST';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.rema_interest is 'REMA_INTEREST';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.is_receipt is '是否是小票（1-是，0-否。金额小于等于500万元人民币，且承兑银行非我行（系统外银行）为”是“ ，反之为”否“）';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.stock_status is '是否再贴现（1-已再贴现，0-库存。）';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.draft_transfer_flag is '票面不得转让标志：EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.voucher_no is '凭证号';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_draft_centre_info.etl_timestamp is 'ETL处理时间戳';
