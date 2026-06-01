/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpp_dscnt_deal_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpp_dscnt_deal_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpp_dscnt_deal_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_dscnt_deal_details(
    id varchar2(60) -- ID
    ,deal_id varchar2(60) -- 成交表ID
    ,dealed_no varchar2(30) -- 成交单编号
    ,request_no varchar2(30) -- 交割单编号
    ,draft_number varchar2(45) -- 票据号码
    ,draft_amount number(18,2) -- 票面金额
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 票据到期日
    ,real_due_date varchar2(12) -- 实际到期日
    ,tenor_days number(8,0) -- 剩余期限
    ,pay_interest number(18,2) -- 应付利息
    ,settle_amt number(18,2) -- 结算金额
    ,rate number(9,6) -- 贴现利率
    ,settle_mode varchar2(8) -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,settle_date varchar2(12) -- 结算日期
    ,set_status varchar2(6) -- 结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败
    ,dscnt_entry_acct varchar2(48) -- 贴现入账账号
    ,sell_agen_br_id varchar2(14) -- 贴出人经纪机构代码
    ,sell_agen_br_name varchar2(270) -- 经纪机构名称
    ,sell_social_no varchar2(27) -- 贴出人社会信用代码
    ,sell_name varchar2(270) -- 贴现申请人名称
    ,sell_bank_no varchar2(18) -- 贴出人开户行号
    ,sell_bank_name varchar2(270) -- 贴出人开户行名称
    ,sell_acct_no varchar2(48) -- 贴出人账号
    ,buy_agen_br_id varchar2(14) -- 贴入人经纪机构代码
    ,buy_agen_br_name varchar2(270) -- 贴现机构名称
    ,buy_bank_no varchar2(18) -- 贴入人开户行号
    ,buy_bank_name varchar2(270) -- 贴入人开户行名称
    ,buy_acct_no varchar2(48) -- 贴入人账号
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,sub_range varchar2(38) -- 子票据区间
    ,product_type varchar2(21) -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,standard_amount number(18,2) -- 标准金额
    ,create_time varchar2(21) -- 鍒涘缓鏃堕棿
    ,create_by varchar2(45) -- 创建人
    ,sell_brh_no varchar2(14) -- 贴出人开户机构代码
    ,sell_acct_name varchar2(675) -- 贴出人账户名称
    ,buy_tacct_no varchar2(48) -- 贴入人托管账户
    ,buy_tacct_name varchar2(675) -- 贴入人托管账户名称
    ,buy_facct_no varchar2(48) -- 贴入人托管账户
    ,buy_facct_name varchar2(675) -- 贴入人托管账户名称
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
grant select on ${iol_schema}.bdms_cpp_dscnt_deal_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpp_dscnt_deal_details is '贴现通意向成交单明细信息表';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.deal_id is '成交表ID';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.request_no is '交割单编号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.draft_amount is '票面金额';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.maturity_date is '票据到期日';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.real_due_date is '实际到期日';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.pay_interest is '应付利息';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.rate is '贴现利率';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.settle_mode is '清算方式： OLN01 线上清算 OLN02 线下清算';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.set_status is '结算结果： RS00 待清算 RS01 清算成功（金额一致） RS02 清算成功（金额不同） RS03 清算失败';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.dscnt_entry_acct is '贴现入账账号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_agen_br_id is '贴出人经纪机构代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_agen_br_name is '经纪机构名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_social_no is '贴出人社会信用代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_name is '贴现申请人名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_bank_no is '贴出人开户行号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_bank_name is '贴出人开户行名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_acct_no is '贴出人账号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_agen_br_id is '贴入人经纪机构代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_agen_br_name is '贴现机构名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_bank_no is '贴入人开户行号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_bank_name is '贴入人开户行名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_acct_no is '贴入人账号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sub_range is '子票据区间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.product_type is '分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.standard_amount is '标准金额';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.create_time is '鍒涘缓鏃堕棿';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.create_by is '创建人';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_brh_no is '贴出人开户机构代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.sell_acct_name is '贴出人账户名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_tacct_no is '贴入人托管账户';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_tacct_name is '贴入人托管账户名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_facct_no is '贴入人托管账户';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.buy_facct_name is '贴入人托管账户名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal_details.etl_timestamp is 'ETL处理时间戳';
