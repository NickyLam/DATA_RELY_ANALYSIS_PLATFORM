/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_cp_order_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_cp_order_txn
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_cp_order_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_cp_order_txn(
    key_rsp varchar2(48) -- 唯一流水号
    ,inst_date varchar2(12) -- 交易日期
    ,inst_time varchar2(9) -- 交易时间
    ,msg_src_id varchar2(6) -- 原系统id
    ,msg_dest_id varchar2(6) -- 目标系统id
    ,txn_num varchar2(6) -- 交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：app支付 1306：公众号支付
    ,txn_channel varchar2(30) -- 后端渠道类型：支付宝“alipay”,微信支付“wxpay”,银联二维码"uppay"
    ,pay_type varchar2(9) -- 交易费率
    ,mcht_no varchar2(150) -- 商户号
    ,mcht_name varchar2(225) -- 商户名称
    ,channel_mcht_no varchar2(150) -- 渠道商户号
    ,channel_mcht_name varchar2(225) -- 渠道商户名称
    ,channel_sec_mcht_no varchar2(150) -- 渠道子商户号
    ,channel_sec_mcht_name varchar2(225) -- 渠道子商户名称
    ,channel_ssn varchar2(96) -- 后端渠道流水号
    ,channel_date varchar2(21) -- 后端渠道交易日期
    ,pay_rate varchar2(18) -- 支付渠道费率
    ,buyerid varchar2(90) -- 用户标示
    ,adddata1 varchar2(90) -- 附加数据1
    ,adddata2 varchar2(150) -- 附加数据2
    ,channel varchar2(30) -- 费率通道
    ,out_order_id varchar2(48) -- 外部订单号（商户）
    ,out_order_title varchar2(576) -- 订单标题
    ,out_order_desc varchar2(576) -- 订单描述
    ,auth_cd varchar2(48) -- 授权码
    ,agent_cd varchar2(23) -- 代理商编号
    ,goodstag varchar2(48) -- 订单优惠标记
    ,wx_public varchar2(90) -- 微信公众号
    ,notifyurl varchar2(150) -- 外部回调地址
    ,settlecurrencycode varchar2(15) -- 币种：默认值’人民币：156’
    ,trade_money varchar2(24) -- 交易金额(包含：消费、退货、撤销)
    ,market_money varchar2(24) -- 营销活动金额（单笔消费营销活动的金额）
    ,add_money varchar2(24) -- 增加金额退货等处理的时候计算
    ,ogl_ord_id varchar2(48) -- 退货/撤销 原订单流水号
    ,ogl_ord_date varchar2(48) -- 退货/撤销 原订单交易日期
    ,txn_sta varchar2(3) -- 交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭
    ,banktype varchar2(24) -- 付款银行
    ,successdate varchar2(12) -- 付款成功日期
    ,successtime varchar2(9) -- 付款成功时间
    ,res_code varchar2(23) -- 响应码 0000：交易成功0001：交易失败
    ,res_desc varchar2(1536) -- 响应码描述
    ,undo_refund_flag varchar2(8) -- 撤销退货专用字段 0：正常    1：已退货    2：已撤销
    ,delay_flag varchar2(2) -- 挂账标志：0.正常        1.进行挂账
    ,code_url varchar2(300) -- 付款二维码/付款吗
    ,expiretime varchar2(15) -- 订单有效时间
    ,pan varchar2(29) -- 支付卡号(不支持大于19位的存折)
    ,term_type varchar2(3) -- 终端类型 01:手机、02：电脑pc端、03：其它
    ,brh_id varchar2(30) -- 收单分行
    ,limitpay varchar2(30) -- 借贷标识
    ,card_type varchar2(15) -- 卡类型
    ,mq_state varchar2(2) -- mq发送状态
    ,notice_thread_id varchar2(48) -- 发送线程id
    ,out_mcht_no varchar2(48) -- 外部商户号
    ,pay_channel varchar2(30) -- 支付渠道
    ,transaction_id varchar2(48) -- 
    ,idc_flag varchar2(5) -- 网联idc标识
    ,gateway varchar2(75) -- 网关
    ,voucher_num varchar2(48) -- 付款凭证号
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
grant select on ${iol_schema}.mrms_tbl_cp_order_txn to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_cp_order_txn to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_cp_order_txn to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_cp_order_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_cp_order_txn is '';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.key_rsp is '唯一流水号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.inst_date is '交易日期';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.inst_time is '交易时间';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.msg_src_id is '原系统id';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.msg_dest_id is '目标系统id';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.txn_num is '交易码：1301：消费 、 1302：交易状态查询 1401：代理商对账文件下载 5301：退款、 3301：撤销、 3302：订单关闭 7301：商户入驻 7302：商户产品开通 7303：商户信息修改 7304：商户产品修改 7305：子商户微信配置添加 7307:下游退汇重出 7308:下游退汇重出(单一) 7309:代理商资金转出                                                                   7310:存量商户迁移                                                                   1303：扫码支付 1304：条码支付 1305：app支付 1306：公众号支付';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.txn_channel is '后端渠道类型：支付宝“alipay”,微信支付“wxpay”,银联二维码"uppay"';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.pay_type is '交易费率';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.mcht_no is '商户号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.mcht_name is '商户名称';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_mcht_no is '渠道商户号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_mcht_name is '渠道商户名称';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_sec_mcht_no is '渠道子商户号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_sec_mcht_name is '渠道子商户名称';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_ssn is '后端渠道流水号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel_date is '后端渠道交易日期';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.pay_rate is '支付渠道费率';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.buyerid is '用户标示';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.adddata1 is '附加数据1';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.adddata2 is '附加数据2';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.channel is '费率通道';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.out_order_id is '外部订单号（商户）';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.out_order_title is '订单标题';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.out_order_desc is '订单描述';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.auth_cd is '授权码';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.agent_cd is '代理商编号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.goodstag is '订单优惠标记';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.wx_public is '微信公众号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.notifyurl is '外部回调地址';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.settlecurrencycode is '币种：默认值’人民币：156’';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.trade_money is '交易金额(包含：消费、退货、撤销)';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.market_money is '营销活动金额（单笔消费营销活动的金额）';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.add_money is '增加金额退货等处理的时候计算';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.ogl_ord_id is '退货/撤销 原订单流水号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.ogl_ord_date is '退货/撤销 原订单交易日期';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.txn_sta is '交易状态 01：新建 02：支付成功 03：支付失败 04：交易超时 05：交易成功不可退货或撤销 06：已发送，正在处理中 07: 客户扣款成功但未入商户账 08: 退款正在处理中(微信退款已处理) 09：支付成功，未到货 10：支付成功，部分到货 11: 支付成功，全部到货 00：预下订单成功，待支付中 13：订单已关闭';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.banktype is '付款银行';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.successdate is '付款成功日期';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.successtime is '付款成功时间';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.res_code is '响应码 0000：交易成功0001：交易失败';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.res_desc is '响应码描述';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.undo_refund_flag is '撤销退货专用字段 0：正常    1：已退货    2：已撤销';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.delay_flag is '挂账标志：0.正常        1.进行挂账';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.code_url is '付款二维码/付款吗';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.expiretime is '订单有效时间';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.pan is '支付卡号(不支持大于19位的存折)';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.term_type is '终端类型 01:手机、02：电脑pc端、03：其它';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.brh_id is '收单分行';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.limitpay is '借贷标识';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.card_type is '卡类型';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.mq_state is 'mq发送状态';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.notice_thread_id is '发送线程id';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.out_mcht_no is '外部商户号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.pay_channel is '支付渠道';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.transaction_id is '';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.idc_flag is '网联idc标识';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.gateway is '网关';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.voucher_num is '付款凭证号';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_cp_order_txn.etl_timestamp is 'ETL处理时间戳';
