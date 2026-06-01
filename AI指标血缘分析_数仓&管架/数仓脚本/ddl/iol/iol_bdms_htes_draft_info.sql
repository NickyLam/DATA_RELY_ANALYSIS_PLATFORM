/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_htes_draft_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_htes_draft_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_htes_draft_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_htes_draft_info(
    id varchar2(60) -- ID
    ,draft_number varchar2(45) -- 票据（包）号
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_type varchar2(6) -- 票据类型： AC01 银承 AC02 商承
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 票据到期日期
    ,draft_amount number(18,2) -- 票据（包）金额
    ,remitter_name varchar2(150) -- 出票人名称
    ,remitter_account varchar2(48) -- 出票人账号
    ,remitter_credit_no varchar2(48) -- 出票人社会信用代码
    ,remitter_brh_no varchar2(14) -- 出票人开户机构代码
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,acceptor_name varchar2(150) -- 承兑人名称
    ,acceptor_account varchar2(48) -- 承兑人账号
    ,acceptor_credit_no varchar2(48) -- 承兑人社会信用代码
    ,acceptor_brh_no varchar2(14) -- 承兑人开户机构代码
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行行号
    ,acceptor_bank_name varchar2(270) -- 承兑人开户行名称
    ,payee_name varchar2(150) -- 收款人名称
    ,payee_account varchar2(48) -- 收款人账号
    ,payee_credit_no varchar2(48) -- 收款人社会信用代码
    ,payee_brh_no varchar2(14) -- 收款人开户机构代码
    ,payee_bank_no varchar2(18) -- 收款人开户行行号
    ,payee_bank_name varchar2(270) -- 收款人开户行行名
    ,payer_brh_no varchar2(14) -- 付款行机构代码
    ,payer_bank_no varchar2(18) -- 付款行行号
    ,guarantee_brh_no varchar2(14) -- 保证增信行机构代码
    ,payer_confirm_brh_no varchar2(14) -- 付款确认机构代码
    ,discount_brh_no varchar2(14) -- 贴现行行机构代码
    ,accept_gua_brh_no varchar2(14) -- 承兑保证行机构代码
    ,disc_gua_brh_no varchar2(14) -- 贴现保证机构代码
    ,store_brh_no varchar2(14) -- 库存保管机构代码
    ,flow_status varchar2(9) -- 票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,risk_status varchar2(6) -- 风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,store_status varchar2(6) -- 票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,status varchar2(9) -- 票据状态：码值来源：1.票据业务系统直连接口规范【概述分册】：       CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清     2.产品中心新增码值：       CS99 已拆分     3.历史码值参考：中国票据交易系统直连接口规范【概述分册】
    ,org_flow_status varchar2(9) -- 原流转状态：见中国票据交易系统直连接口规范【概述分册】
    ,org_risk_status varchar2(6) -- 原风险票据状态：见中国票据交易系统直连接口规范【概述分册】
    ,org_status varchar2(9) -- 原票价状态
    ,org_store_status varchar2(6) -- 原票据库存状态：见中国票据交易系统直连接口规范【概述分册】
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(675) -- 备注域
    ,disc_date varchar2(12) -- 贴现日期
    ,emerg_flag varchar2(2) -- 是否应急票据： 0 否 1 是
    ,bp_no varchar2(45) -- 供应链票据包编号
    ,forehand_range varchar2(38) -- 前手区间
    ,current_range varchar2(38) -- 当前区间
    ,product_type varchar2(6) -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,cd_range varchar2(38) -- 子票区间
    ,standard_amt number(18,2) -- 标准金额
    ,draft_remark varchar2(675) -- 票面备注
    ,draft_explain varchar2(675) -- 票面说明
    ,cd_split varchar2(2) -- 是否允许分包流转： 0 否 1 是
    ,remitter_mem_no varchar2(9) -- 出票人渠道代码
    ,remitter_dist_tp varchar2(6) -- 出票人识别类型： DT01 票据账户 DT02 银行账户
    ,remitter_brh_name varchar2(450) -- 出票人开户行机构名称
    ,acceptor_mem_no varchar2(9) -- 承兑人渠道代码
    ,acceptor_dist_tp varchar2(6) -- 承兑人识别类型： DT01 票据账户 DT02 银行账户
    ,acceptor_brh_name varchar2(450) -- 承兑人开户行机构名称
    ,payee_mem_no varchar2(9) -- 收款人渠道代码
    ,payee_dist_tp varchar2(6) -- 收款人识别类型： DT01 票据账户 DT02 银行账户
    ,payee_brh_name varchar2(450) -- 收款人开户行机构名称
    ,holder_mem_no varchar2(9) -- 持票人渠道代码
    ,holder_name varchar2(675) -- 持票人名称
    ,holder_crt_no varchar2(48) -- 持票人社会信用代码
    ,holder_dist_tp varchar2(6) -- 持票人识别类型： DT01 票据账户 DT02 银行账户
    ,holder_acct_no varchar2(48) -- 持票人账号
    ,holder_bank_no varchar2(18) -- 持票人开户行行号
    ,holder_bank_name varchar2(270) -- 持票人开户行名称
    ,holder_brh_no varchar2(14) -- 持票人开户行机构代码
    ,holder_brh_name varchar2(450) -- 持票人开户行机构名称
    ,transfer_flag varchar2(6) -- 不得转让标志： EM00 可再转让 EM01 不得转让
    ,consignment_code varchar2(6) -- 到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付
    ,owership_flag varchar2(3) -- 权属标识
    ,payer_name varchar2(270) -- 付款人名称
    ,payer_account varchar2(48) -- 付款人账号
    ,payer_credit_no varchar2(48) -- 付款人社会信用代码
    ,payer_bank_name varchar2(270) -- 付款人开户行名称
    ,payer_mem_no varchar2(9) -- 付款人渠道代码
    ,payer_dist_tp varchar2(6) -- 付款人识别类型： DT01 票据账户 DT02 银行账户
    ,payer_brh_name varchar2(450) -- 付款人开户行机构名称
    ,acceptor_acctname varchar2(675) -- 承兑人账户名称
    ,remitter_acctname varchar2(675) -- 出票人账户名称
    ,payee_acctname varchar2(675) -- 收款人账户名称
    ,create_time varchar2(21) -- 创建时间
    ,create_by varchar2(45) -- 创建人
    ,remitter_account_name varchar2(225) -- 接收人账户名称
    ,acceptor_account_name varchar2(225) -- 承兑人账户名称
    ,payee_account_name varchar2(225) -- 付款人账户名称
    ,holder_acct_name varchar2(675) -- 持票人账户名称
    ,draft_pay_status varchar2(6) -- 票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08
    ,pay_no varchar2(53) -- 票据支付订单编号
    ,settle_date varchar2(12) -- 结清日期
    ,migrate_flag varchar2(15) -- ECDS迁移标志
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
grant select on ${iol_schema}.bdms_htes_draft_info to ${iml_schema};
grant select on ${iol_schema}.bdms_htes_draft_info to ${icl_schema};
grant select on ${iol_schema}.bdms_htes_draft_info to ${idl_schema};
grant select on ${iol_schema}.bdms_htes_draft_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_htes_draft_info is '票据信息主表';
comment on column ${iol_schema}.bdms_htes_draft_info.id is 'ID';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_number is '票据（包）号';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_type is '票据类型： AC01 银承 AC02 商承';
comment on column ${iol_schema}.bdms_htes_draft_info.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_htes_draft_info.maturity_date is '票据到期日期';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_amount is '票据（包）金额';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_credit_no is '出票人社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_brh_no is '出票人开户机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_credit_no is '承兑人社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_brh_no is '承兑人开户机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_name is '收款人名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_account is '收款人账号';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_credit_no is '收款人社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_brh_no is '收款人开户机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_bank_no is '收款人开户行行号';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_bank_name is '收款人开户行行名';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_brh_no is '付款行机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_htes_draft_info.guarantee_brh_no is '保证增信行机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_confirm_brh_no is '付款确认机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.discount_brh_no is '贴现行行机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.accept_gua_brh_no is '承兑保证行机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.disc_gua_brh_no is '贴现保证机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.store_brh_no is '库存保管机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.flow_status is '票据流转状态： 	码值来源： 		1,票据业务系统直连接口规范【概述分册】： 			TF0101 待收票 TF0301 可流通 TF0302 已锁定 TF0303 不可转让 			TF0304 已质押 TF0305 待赎回 TF0401 托收在途 TF0402 追索中 TF0501 已结束 		2,产品中心新增码值： 			TF0999 不可流通 		3,历史码值参考：中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.risk_status is '风险票据状态：见中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.store_status is '票据库存状态：见中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.status is '票据状态：码值来源：1.票据业务系统直连接口规范【概述分册】：       CS01 已出票 CS02 已承兑 CS03 已收票 CS04 已到期 CS05 已终止 CS06 已结清     2.产品中心新增码值：       CS99 已拆分     3.历史码值参考：中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.org_flow_status is '原流转状态：见中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.org_risk_status is '原风险票据状态：见中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.org_status is '原票价状态';
comment on column ${iol_schema}.bdms_htes_draft_info.org_store_status is '原票据库存状态：见中国票据交易系统直连接口规范【概述分册】';
comment on column ${iol_schema}.bdms_htes_draft_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_htes_draft_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_htes_draft_info.misc is '备注域';
comment on column ${iol_schema}.bdms_htes_draft_info.disc_date is '贴现日期';
comment on column ${iol_schema}.bdms_htes_draft_info.emerg_flag is '是否应急票据： 0 否 1 是';
comment on column ${iol_schema}.bdms_htes_draft_info.bp_no is '供应链票据包编号';
comment on column ${iol_schema}.bdms_htes_draft_info.forehand_range is '前手区间';
comment on column ${iol_schema}.bdms_htes_draft_info.current_range is '当前区间';
comment on column ${iol_schema}.bdms_htes_draft_info.product_type is '票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_htes_draft_info.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_htes_draft_info.standard_amt is '标准金额';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_explain is '票面说明';
comment on column ${iol_schema}.bdms_htes_draft_info.cd_split is '是否允许分包流转： 0 否 1 是';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_mem_no is '出票人渠道代码';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_dist_tp is '出票人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_brh_name is '出票人开户行机构名称';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_mem_no is '承兑人渠道代码';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_dist_tp is '承兑人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_brh_name is '承兑人开户行机构名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_mem_no is '收款人渠道代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_dist_tp is '收款人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_brh_name is '收款人开户行机构名称';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_mem_no is '持票人渠道代码';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_name is '持票人名称';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_crt_no is '持票人社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_dist_tp is '持票人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_acct_no is '持票人账号';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_bank_no is '持票人开户行行号';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_bank_name is '持票人开户行名称';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_brh_no is '持票人开户行机构代码';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_brh_name is '持票人开户行机构名称';
comment on column ${iol_schema}.bdms_htes_draft_info.transfer_flag is '不得转让标志： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_htes_draft_info.consignment_code is '到期无条件委托： CC00 含委托/承诺兑付 CC01 不含委托/不承诺兑付';
comment on column ${iol_schema}.bdms_htes_draft_info.owership_flag is '权属标识';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_name is '付款人名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_account is '付款人账号';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_credit_no is '付款人社会信用代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_bank_name is '付款人开户行名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_mem_no is '付款人渠道代码';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_dist_tp is '付款人识别类型： DT01 票据账户 DT02 银行账户';
comment on column ${iol_schema}.bdms_htes_draft_info.payer_brh_name is '付款人开户行机构名称';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_acctname is '承兑人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_acctname is '出票人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_acctname is '收款人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_htes_draft_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_htes_draft_info.remitter_account_name is '接收人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.acceptor_account_name is '承兑人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.payee_account_name is '付款人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.holder_acct_name is '持票人账户名称';
comment on column ${iol_schema}.bdms_htes_draft_info.draft_pay_status is '票据支付状态： 空	PS00 预锁定	PS01 锁定	PS02 即时支付预锁定	PS03 解锁（接收人可签收）	PS04 解锁（发起人可撤销）	PS05 已完成	PS06 已取消	PS07 即时支付锁定	PS08';
comment on column ${iol_schema}.bdms_htes_draft_info.pay_no is '票据支付订单编号';
comment on column ${iol_schema}.bdms_htes_draft_info.settle_date is '结清日期';
comment on column ${iol_schema}.bdms_htes_draft_info.migrate_flag is 'ECDS迁移标志';
comment on column ${iol_schema}.bdms_htes_draft_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_htes_draft_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_htes_draft_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_htes_draft_info.etl_timestamp is 'ETL处理时间戳';
