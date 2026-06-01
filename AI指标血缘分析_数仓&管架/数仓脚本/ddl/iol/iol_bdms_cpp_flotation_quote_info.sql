/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpp_flotation_quote_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpp_flotation_quote_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpp_flotation_quote_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_flotation_quote_info(
    id varchar2(60) -- ID
    ,busi_id varchar2(60) -- 业务表ID
    ,trade_direct varchar2(8) -- 交易方向： TDD01 贴入 TDD02 贴出
    ,quote_no varchar2(24) -- 报价单编号
    ,emc_brh_no varchar2(15) -- 经济机构代码
    ,emc_user_id varchar2(15) -- 经济机构交易员ID
    ,dscnt_brh_no varchar2(15) -- 贴现机构代码
    ,dscnt_user_id varchar2(15) -- 贴现交易员ID
    ,mem_no varchar2(9) -- 本方会员代码
    ,cust_name varchar2(300) -- 申请人名称
    ,cust_social_no varchar2(27) -- 申请人社会信用代码
    ,cust_corp_scale varchar2(6) -- 企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,cust_ind_clss varchar2(8) -- 行业分类：详见概述分册
    ,cust_arc_flag varchar2(2) -- 是否涉农企业： 0 否 1 是
    ,cust_grn_flag varchar2(2) -- 是否绿色企业： 0 否 1 是
    ,cust_sci_flag varchar2(2) -- 是否科技企业： 0 否 1 是
    ,cust_pop_flag varchar2(2) -- 是否民营企业： 0 否 1 是
    ,cust_province varchar2(3) -- 贴现申请人省份：参见附录省份代码
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,draft_attr varchar2(6) -- 票据属性： ME01 纸票 ME02 电票
    ,bargain_falg varchar2(2) -- 是否允许议价： 0 否 1 是
    ,sum_count number(8,0) -- 票据张数
    ,sum_amt number(18,2) -- 票据总金额
    ,rate number(7,6) -- 贴现利率
    ,ans_time varchar2(12) -- 应答时间
    ,tenor_days number(8,0) -- 剩余期限
    ,settle_date varchar2(12) -- 结算日期
    ,settle_speed varchar2(6) -- 清算速度： CS00 T+0 CS01 T+1
    ,clear_mode varchar2(8) -- 清算方式： OLN01 线上清算 OLN02 线下清算
    ,pay_inetrest number(18,2) -- 应付利息
    ,settle_amt number(18,2) -- 结算金额
    ,trade_cp_type varchar2(1500) -- 交易对手类型
    ,esc_branch_type varchar2(1500) -- 剔除交易对手行别
    ,dscnt_entry_bank_no varchar2(21) -- 贴现资金入账行号
    ,dscnt_entry_acct varchar2(48) -- 贴现入账账号
    ,draft_number varchar2(45) -- 票据号码
    ,draft_amt number(18,2) -- 票面金额
    ,maturity_date varchar2(12) -- 票据到期日
    ,real_maturity_date varchar2(12) -- 票据实际到期日
    ,drawer_name varchar2(270) -- 出票人名称
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,quote_status varchar2(8) -- 报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*
    ,process_code varchar2(14) -- 处理码
    ,process_msg varchar2(1152) -- 处理信息
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(4000) -- 备注
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行号
    ,msg_id varchar2(53) -- 报文标识号
    ,msg_type varchar2(18) -- 报文编号
    ,msg_date varchar2(12) -- 报文日期
    ,msg_tm varchar2(21) -- 报文时间
    ,standard_amount number(18,2) -- 标准金额
    ,product_type varchar2(6) -- 分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据
    ,sub_range varchar2(38) -- 子票据区间
    ,draft_channel varchar2(6) -- 票据所在渠道
    ,cust_mem_no varchar2(9) -- 票据业务所在渠道代码
    ,cust_dist_type varchar2(6) -- 账号识别类型
    ,cust_acct_name varchar2(675) -- 贴现申请人账户名称
    ,cust_brh_no varchar2(14) -- 贴现申请人开户机构代码
    ,entry_acct_name varchar2(675) -- 资金入账账户名称
    ,entry_brh_no varchar2(14) -- 资金入账账户机构代码
    ,cust_acct varchar2(48) -- 贴现申请人帐号
    ,entry_acct varchar2(48) -- 资金入账账户
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 鍒涘缓鏃堕棿
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
grant select on ${iol_schema}.bdms_cpp_flotation_quote_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpp_flotation_quote_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpp_flotation_quote_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpp_flotation_quote_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpp_flotation_quote_info is '贴现通挂牌询价报价信息表';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.id is 'ID';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.busi_id is '业务表ID';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.trade_direct is '交易方向： TDD01 贴入 TDD02 贴出';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.quote_no is '报价单编号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.emc_brh_no is '经济机构代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.emc_user_id is '经济机构交易员ID';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.dscnt_brh_no is '贴现机构代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.dscnt_user_id is '贴现交易员ID';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.mem_no is '本方会员代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_name is '申请人名称';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_social_no is '申请人社会信用代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_corp_scale is '企业规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_ind_clss is '行业分类：详见概述分册';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_arc_flag is '是否涉农企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_grn_flag is '是否绿色企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_sci_flag is '是否科技企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_pop_flag is '是否民营企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_province is '贴现申请人省份：参见附录省份代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.draft_attr is '票据属性： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.bargain_falg is '是否允许议价： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.sum_count is '票据张数';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.sum_amt is '票据总金额';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.rate is '贴现利率';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.ans_time is '应答时间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.tenor_days is '剩余期限';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.settle_speed is '清算速度： CS00 T+0 CS01 T+1';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.clear_mode is '清算方式： OLN01 线上清算 OLN02 线下清算';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.pay_inetrest is '应付利息';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.settle_amt is '结算金额';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.trade_cp_type is '交易对手类型';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.esc_branch_type is '剔除交易对手行别';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.dscnt_entry_bank_no is '贴现资金入账行号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.dscnt_entry_acct is '贴现入账账号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.draft_amt is '票面金额';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.maturity_date is '票据到期日';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.real_maturity_date is '票据实际到期日';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.drawer_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.quote_status is '报价单状态： DES01 已保存* DES02 已挂牌 DES03 已摘牌 DES04 挂牌待确认* DES05 成交待确认* DES06 已撤回 DES07 已作废 DES08 已成交 DES09 已转对话报价 DES10 已拆单* DES11 摘牌待确认*';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.process_code is '处理码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.process_msg is '处理信息';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.misc is '备注';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.acceptor_bank_no is '承兑人开户行号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.msg_id is '报文标识号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.msg_type is '报文编号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.msg_date is '报文日期';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.msg_tm is '报文时间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.standard_amount is '标准金额';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.product_type is '分类标记： CF01 普通票据 CF02 供应链票据 CF03 等分化票据';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.sub_range is '子票据区间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.draft_channel is '票据所在渠道';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_mem_no is '票据业务所在渠道代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_dist_type is '账号识别类型';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_acct_name is '贴现申请人账户名称';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_brh_no is '贴现申请人开户机构代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.entry_acct_name is '资金入账账户名称';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.entry_brh_no is '资金入账账户机构代码';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.cust_acct is '贴现申请人帐号';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.entry_acct is '资金入账账户';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.create_time is '鍒涘缓鏃堕棿';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpp_flotation_quote_info.etl_timestamp is 'ETL处理时间戳';
