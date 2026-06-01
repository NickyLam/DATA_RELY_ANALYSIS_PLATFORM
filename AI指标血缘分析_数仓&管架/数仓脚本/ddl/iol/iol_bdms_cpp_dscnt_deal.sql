/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpp_dscnt_deal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpp_dscnt_deal
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpp_dscnt_deal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_dscnt_deal(
    id varchar2(60) -- ID
    ,dealed_no varchar2(30) -- 成交单编号
    ,quote_no varchar2(30) -- 报价单编号
    ,trade_direct varchar2(8) -- 交易方向： TDD01 贴入 TDD02 贴出
    ,busi_type varchar2(9) -- 业务类型： RE4001 贴现通
    ,trade_type varchar2(6) -- 成交方式： TT01 对话报价 TT02 挂牌询价
    ,trade_date varchar2(12) -- 成交日期
    ,trade_time varchar2(21) -- 成交时间
    ,trade_status varchar2(6) -- 成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时
    ,settle_status varchar2(6) -- 清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算
    ,bro_brh_no varchar2(14) -- 经济机构代码
    ,bro_user_id varchar2(15) -- 经济机构交易员ID
    ,dsc_brh_no varchar2(14) -- 贴现机构代码
    ,dsc_user_id varchar2(15) -- 贴现机构交易员ID
    ,dsc_bank_no varchar2(18) -- 贴入人开户行号
    ,dsc_acct_no varchar2(48) -- 贴入人账号
    ,cust_name varchar2(300) -- 申请人名称
    ,cust_social_no varchar2(27) -- 申请人社会信用代码
    ,cust_bank_no varchar2(18) -- 申请人开户行号
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,sum_count number(8,0) -- 票据张数
    ,sum_amount number(18,2) -- 票据总额
    ,ave_tenor_days number(8,0) -- 加权平均剩余期限
    ,rate number(7,6) -- 贴现利率
    ,clear_speed varchar2(6) -- 清算速度
    ,settle_date varchar2(12) -- 结算日期
    ,settle_mode varchar2(8) -- 清算方式： CS00 T+0 CS01 T+1
    ,settle_amt number(18,2) -- 结算金额
    ,misc varchar2(1500) -- 备注
    ,reserver1 varchar2(384) -- 预留域1
    ,reserver2 varchar2(384) -- 预留域2
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,create_time varchar2(21) -- 创建时间
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
grant select on ${iol_schema}.bdms_cpp_dscnt_deal to ${iml_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal to ${icl_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal to ${idl_schema};
grant select on ${iol_schema}.bdms_cpp_dscnt_deal to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpp_dscnt_deal is '贴现通意向成交单表';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.id is 'ID';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.dealed_no is '成交单编号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.trade_direct is '交易方向： TDD01 贴入 TDD02 贴出';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.busi_type is '业务类型： RE4001 贴现通';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.trade_type is '成交方式： TT01 对话报价 TT02 挂牌询价';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.trade_date is '成交日期';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.trade_time is '成交时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.trade_status is '成交状态： DS01 已成交 DS02 已撤销 DS03 待提票 DS05 提票超时';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.settle_status is '清算状态： SS00 待清算 SS01 部分清算 SS02 全部清算';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.bro_brh_no is '经济机构代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.bro_user_id is '经济机构交易员ID';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.dsc_brh_no is '贴现机构代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.dsc_user_id is '贴现机构交易员ID';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.dsc_bank_no is '贴入人开户行号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.dsc_acct_no is '贴入人账号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.cust_name is '申请人名称';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.cust_social_no is '申请人社会信用代码';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.cust_bank_no is '申请人开户行号';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.sum_amount is '票据总额';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.ave_tenor_days is '加权平均剩余期限';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.rate is '贴现利率';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.clear_speed is '清算速度';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.settle_mode is '清算方式： CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.misc is '备注';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.reserver1 is '预留域1';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.reserver2 is '预留域2';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.create_by is '创建人';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpp_dscnt_deal.etl_timestamp is 'ETL处理时间戳';
